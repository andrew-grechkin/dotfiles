# keymapd configuration

JSON is used here instead of the repository default YAML so that `keymapd` can
run on stock Perl with core modules only (`JSON::PP`).

Key names are the kernel evdev names from `linux/input-event-codes.h`,
lowercased and without the `KEY_` prefix. Matching is case-insensitive, so
`LeftAlt`, `leftalt` and `KEY_LEFTALT` all resolve to the same key. Common X11
spellings such as `return`, `escape`, `bracketleft`, `bracketright` and
`period` are also accepted.

## tap-hold.json

Contains a top-level `disable` switch, top-level `tap_time` and `hold_timeout`
defaults, and a `rules` mapping from a physical key to a tap/hold pair.

```json
{
  "disable": false,
  "tap_time": 150,
  "hold_timeout": 150,
  "rules": {
    "a": {
      "tap": "a",
      "hold": "LeftCtrl"
    }
  }
}
```

- `disable`: optional, defaults to `false`. When `true`, hold detection stays
  disabled, including across configuration reloads and service restarts. Set it
  back to `false` (or omit it) to restore normal tap/hold behavior
- `tap_time`: optional, defaults to `0` (disabled). Milliseconds within which
  re-pressing the same physical key repeats its tap instead of starting a new
  tap/hold decision. This is a typing-speed setting, so it applies to every
  rule unless a rule overrides it
- `hold_timeout`: optional, defaults to `200`. Milliseconds before a held key
  commits to its hold. Applies to every rule unless a rule overrides it
- `rules`: maps physical keys to tap/hold pairs. Tap-hold keys must be nested
  here, not at the document root
- `rules.<key>.tap`: key emitted on a short press
- `rules.<key>.hold`: key emitted when the key is held longer than
  `hold_timeout`
- `rules.<key>.hold_timeout`: optional, overrides the top-level `hold_timeout`
  for this key only. Use this when one finger needs a different hold dwell
  time than the rest
- `rules.<key>.tap_time`: optional, overrides the top-level `tap_time` for
  this key only. Use this when one finger needs a different repeat window
  than the rest

While a tap/hold key is undecided, other key events are buffered. The tap/hold
decision is emitted first, then the buffered events are replayed in order, so a
chord pressed inside the hold window still receives the hold modifier.

## bindings.json

Maps a key combination to a shell command.

```json
{
  "binding_marker": "f24",
  "bindings": [
    {
      "keys": ["super", "return"],
      "command": "wezterm start --always-new-process /usr/bin/zsh"
    }
  ],
  "replacements": {
    "start --class 'TermFloating'": "--config initial_cols=128 --config initial_rows=30 start --class 'TermFloating'"
  }
}
```

- `bindings[].keys`: optional modifiers followed by the main key
- `bindings[].command`: shell command executed on match
- `binding_marker`: key emitted briefly when a binding with modifiers fires.
  This prevents the compositor from treating the modifier as pressed alone, for
  example KDE opening the application menu after super+return. Set to `none` to
  disable
- `replacements`: literal substrings replaced in every binding command before
  execution. Matching is plain text, not shell syntax or key-aware

## Runtime control

`keymapd` reacts to two signals:

- `SIGUSR1`: reload the configuration and restore hold detection to the state
  configured by `disable`. This is also the signal used by
  `systemctl --user reload keymapd`.
- `SIGUSR2`: disable hold detection without stopping the service, until the
  next reload or restart.

```bash
systemctl --user kill -s USR2 keymapd.service   # disable hold detection
systemctl --user reload keymapd.service         # reload config, restore configured state
```

A `disable` value of `true` in `tap-hold.json` keeps hold detection off even
after a reload, so the feature stays disabled until the configuration is
changed.

With hold detection disabled, tap/hold keys emit their `tap` key immediately on
press and never emit their `hold` key. Real modifier chords still match
bindings, so combinations using a physical `super`, `alt`, `ctrl` or `shift`
keep working. Home-row keys no longer produce modifiers, so chords that relied
on a hold mapping will not match until hold detection is enabled again.
