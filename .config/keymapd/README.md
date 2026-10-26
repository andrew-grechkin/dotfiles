# keymapd configuration

JSON is used here instead of the repository default YAML so that `keymapd` can
run on stock Perl with core modules only (`JSON::PP`).

Key names are the kernel evdev names from `linux/input-event-codes.h`,
lowercased and without the `KEY_` prefix. Matching is case-insensitive, so
`LeftAlt`, `leftalt` and `KEY_LEFTALT` all resolve to the same key. Common X11
spellings such as `return`, `escape`, `bracketleft`, `bracketright` and
`period` are also accepted.

## tap-hold.json

Maps a physical key to a tap/hold pair.

```json
{
  "a": {
    "tap": "a",
    "hold": "LeftCtrl",
    "hold_timeout": 150,
    "tap_time": 150
  }
}
```

- `tap`: key emitted on a short press
- `hold`: key emitted when the key is held longer than `hold_timeout`
- `hold_timeout`: milliseconds before the hold is committed
- `tap_time`: re-press within this many milliseconds repeats the tap

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

- `SIGUSR1`: reload the configuration and re-enable hold detection. This is
  also the signal used by `systemctl --user reload keymapd`.
- `SIGUSR2`: disable hold detection without stopping the service.

```bash
systemctl --user kill -s USR2 keymapd.service   # disable hold detection
systemctl --user reload keymapd.service         # reload config, enable hold
```

With hold detection disabled, tap/hold keys emit their `tap` key immediately on
press and never emit their `hold` key. Real modifier chords still match
bindings, so combinations using a physical `super`, `alt`, `ctrl` or `shift`
keep working. Home-row keys no longer produce modifiers, so chords that relied
on a hold mapping will not match until hold detection is enabled again.
