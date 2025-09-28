//! # Secret Service API CLI
//!
//! ## ABSTRACT
//!
//! A command-line interface for interacting with the D-Bus Secret Service API
//! (e.g., GNOME Keyring, KWallet). Provides functionality to list, fetch, and
//! remove secrets with proper content-type handling including base64 encoding.
//!
//! ## DESCRIPTION
//!
//! This tool provides a JSON-based interface to the freedesktop.org Secret Service
//! specification, which is implemented by various Linux keyring managers like GNOME
//! Keyring and KDE Wallet. It connects to the system's secret service via D-Bus and
//! exposes three main operations:
//!
//! ### Commands:
//!
//! - **list**: Enumerates all secrets with their metadata (path, label, attributes,
//!   content-type, creation/modification timestamps). Does not retrieve secret values.
//!
//! - **fetch <paths>**: Retrieves one or more secrets by their D-Bus object paths.
//!   Automatically unlocks locked items and intelligently decodes secret values based
//!   on their content-type metadata. Supports:
//!   - Plain text secrets (content-type: text/*)
//!   - Base64-encoded secrets (encoding=base64 parameter)
//!   - Binary secrets (encoded as base64 for JSON output)
//!   - Proper decoding chain: base64 decode → charset decode
//!
//! - **remove <paths>**: Deletes one or more secrets by their D-Bus object paths.
//!
//! ### Content-Type Handling:
//!
//! The tool parses content-type metadata to determine how to decode secrets:
//! - `text/plain` → decoded as UTF-8 string (default charset)
//! - `text/plain; charset=utf-8` → decoded using specified charset
//! - `text/plain; charset=iso-8859-1` → decoded using ISO-8859-1 (supports all encoding_rs charsets)
//! - `text/plain; encoding=base64` → base64 decoded, then UTF-8 decoded
//! - `text/plain; charset=utf-8; encoding=base64` → base64 decoded, then charset decoded
//! - `application/octet-stream; encoding=base64` → base64 decoded, output as base64
//! - `application/octet-stream` → raw binary, output as base64
//!
//! Decoding order: base64 (if encoding=base64) → charset (if text/* mime type)
//!
//! ### Output Format:
//!
//! All commands output JSON to stdout. Errors are output as JSON to stderr with
//! status information including the operation, identifier, and error message.
//!
//! ### Authentication:
//!
//! Uses plain (unencrypted) D-Bus connection. Authentication and encryption are
//! handled by the secret service daemon itself (typically via user session unlock).

use anyhow::Result;
use base64::{engine::general_purpose::STANDARD as B64, Engine};
use clap::{Parser, Subcommand};
use dbus_secret_service::{EncryptionType, SecretService};
use encoding_rs::Encoding;
use serde::Serialize;
use std::collections::HashMap;

#[derive(Parser)]
#[command(author, version, about, long_about = None)]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// List all available secrets
    List,
    /// Fetch one or more secrets by their D-Bus paths
    Fetch {
        /// The D-Bus paths of the secrets to fetch
        paths: Vec<String>,
    },
    /// Remove one or more secrets by their D-Bus paths
    Remove {
        /// The D-Bus paths of the secrets to remove
        paths: Vec<String>,
    },
}

#[derive(Serialize)]
struct SecretInfo {
    path: String,
    attributes: HashMap<String, String>,

    #[serde(skip_serializing_if = "Option::is_none")]
    content_type: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    created: Option<u64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    label: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    modified: Option<u64>,
}

#[derive(Serialize)]
struct FetchedSecret {
    #[serde(flatten)]
    info: SecretInfo,
    secret: String,
}

#[derive(Serialize)]
struct Status {
    identifier: String,
    message: Option<String>,
    status: String,
}

fn main() -> Result<()> {
    let cli = Cli::parse();
    let ss = SecretService::connect(EncryptionType::Plain)?;

    match &cli.command {
        Commands::List => list_secrets(&ss)?,
        Commands::Fetch { paths } => {
            let items_map = get_all_items_map(&ss)?;
            for path in paths {
                fetch_secret(&items_map, path);
            }
        }
        Commands::Remove { paths } => {
            let items_map = get_all_items_map(&ss)?;
            for path in paths {
                remove_secret(&items_map, path);
            }
        }
    }

    Ok(())
}

fn get_all_items_map<'a>(
    ss: &'a SecretService,
) -> Result<HashMap<String, dbus_secret_service::Item<'a>>> {
    let all_items = ss.search_items(HashMap::new())?;
    let mut results = HashMap::new();

    for item in all_items.locked.into_iter().chain(all_items.unlocked.into_iter()) {
        results.insert(item.path.to_string(), item);
    }

    Ok(results)
}

fn item_to_secret_info(item: &dbus_secret_service::Item) -> SecretInfo {
    SecretInfo {
        path: item.path.to_string(),
        label: item.get_label().ok(),
        attributes: (item.get_attributes()).unwrap_or_default(),
        content_type: item.get_secret_content_type().ok(),
        created: item.get_created().ok(),
        modified: item.get_modified().ok(),
    }
}

/// Parsed content-type information
#[derive(Debug)]
struct ContentType {
    mime_type: String,
    charset: Option<String>,
    encoding: Option<String>,
}

/// Parse a content-type string like "text/plain; charset=utf-8; encoding=base64"
/// Returns the MIME type and any parameters (charset, encoding, etc.)
fn parse_content_type(content_type: &str) -> ContentType {
    let mut parts = content_type.split(';').map(|s| s.trim());
    let mime_type = parts.next().unwrap_or("application/octet-stream").to_string();

    let mut charset = None;
    let mut encoding = None;

    for part in parts {
        if let Some((key, value)) = part.split_once('=') {
            let key = key.trim();
            let value = value.trim();

            match key {
                "charset" => charset = Some(value.to_string()),
                "encoding" => encoding = Some(value.to_string()),
                _ => {} // ignore other parameters
            }
        }
    }

    ContentType {
        mime_type,
        charset,
        encoding,
    }
}

fn list_secrets(ss: &SecretService) -> Result<()> {
    let items_map = get_all_items_map(ss)?;
    let results: Vec<SecretInfo> = items_map.values().map(item_to_secret_info).collect();

    println!("{}", serde_json::to_string_pretty(&results)?);
    Ok(())
}

fn fetch_secret(items_map: &HashMap<String, dbus_secret_service::Item>, path: &str) {
    match items_map.get(path) {
        Some(item) => {
            if let Err(err) = (|| -> Result<()> {
                if item.is_locked()? {
                    item.unlock()?;
                }

                let info = item_to_secret_info(item);
                let mut secret_bytes = item.get_secret()?;

                // Parse content-type to determine decoding strategy
                let content_type = info.content_type.as_deref().unwrap_or("application/octet-stream");
                let parsed_ct = parse_content_type(content_type);

                // Check legacy plaintext attribute as fallback
                let is_plaintext_attribute =
                    info.attributes.get("type").map_or(false, |v| v == "plaintext");

                // Step 1: Decode base64 if specified in content-type
                if parsed_ct.encoding.as_deref() == Some("base64") {
                    secret_bytes = B64.decode(&secret_bytes)
                        .unwrap_or_else(|_| secret_bytes.clone());
                }

                // Step 2: Determine if content should be treated as text
                let is_text_content = parsed_ct.mime_type.starts_with("text/");

                // Step 3: Convert to string based on content type and charset
                let secret_string = if is_text_content || is_plaintext_attribute {
                    // Get charset parameter (default to utf-8)
                    let charset_name = parsed_ct.charset.as_deref().unwrap_or("utf-8");

                    // Look up the encoding
                    if let Some(encoding) = Encoding::for_label(charset_name.as_bytes()) {
                        // Decode using the specified charset
                        let (decoded, _, had_errors) = encoding.decode(&secret_bytes);
                        if had_errors {
                            // Decoding failed, output as base64
                            B64.encode(&secret_bytes)
                        } else {
                            decoded.into_owned()
                        }
                    } else {
                        // Unknown charset, output as base64
                        B64.encode(&secret_bytes)
                    }
                } else {
                    // Binary data: output as base64
                    B64.encode(&secret_bytes)
                };

                let result = FetchedSecret {
                    info,
                    secret: secret_string,
                };
                println!("{}", serde_json::to_string(&result)?);
                Ok(())
            })() {
                let status = Status {
                    status: "error".to_string(),
                    identifier: path.to_string(),
                    message: Some(format!("Error processing secret: {}", err)),
                };
                if let Ok(json_err) = serde_json::to_string(&status) {
                    eprintln!("{}", json_err);
                }
            }
        }
        None => {
            let status = Status {
                status: "error".to_string(),
                identifier: path.to_string(),
                message: Some("Secret not found at this path".to_string()),
            };
            if let Ok(json_err) = serde_json::to_string(&status) {
                eprintln!("{}", json_err);
            }
        }
    }
}

fn remove_secret(items_map: &HashMap<String, dbus_secret_service::Item>, path: &str) {
    match items_map.get(path) {
        Some(item) => {
            if let Err(err) = item.delete() {
                let status = Status {
                    status: "error".to_string(),
                    identifier: path.to_string(),
                    message: Some(format!("Failed to delete secret: {}", err)),
                };
                if let Ok(json_err) = serde_json::to_string(&status) {
                    eprintln!("{}", json_err);
                }
            }
        }
        None => {
            let status = Status {
                status: "error".to_string(),
                identifier: path.to_string(),
                message: Some("Secret not found at this path".to_string()),
            };
            if let Ok(json_err) = serde_json::to_string(&status) {
                eprintln!("{}", json_err);
            }
        }
    }
}
