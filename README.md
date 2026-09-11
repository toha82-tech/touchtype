# Blind Type

A guided, level-based touch-typing (blind typing) trainer plugin for the
[Omarchy](https://omarchy.org/) shell (Quickshell). Fully theme-aware — it
reuses Omarchy's `Color`/`Style` design tokens, so it automatically matches
whatever Omarchy theme you have active.

## Features

- 10 progressive levels: home row → top row → bottom row → full alphabet →
  numbers/punctuation → mixed drills → timed sentences.
- Levels unlock as you pass the one before them (accuracy threshold per level).
- Live on-screen keyboard that highlights the next expected key (with
  shift-key hinting) and marks the F/J home-row bumps.
- Live stats while typing: elapsed time, WPM, accuracy.
- Results screen: pass/fail, accuracy/WPM/time, and a "weakest keys" heatmap
  built from your per-key hit/miss stats.
- Daily streak tracking and best-score-per-level persistence.
- Compact bar-widget indicator (current level + streak), click to open.
- Optional Omarchy menu shortcuts: `Trigger → Blind Type → Open trainer / Reset progress`.

## Install

```bash
omarchy plugin add https://github.com/toha82-tech/blindtype.git --enable
```

That's it — this clones the plugin into `~/.config/omarchy/plugins/blindtype`,
registers it with the running shell, and places the bar indicator for you
(you'll be prompted to pick left/center/right, or pass
`--enable` non-interactively and move it later with
`omarchy bar move blindtype --section right`).

If you'd rather install manually (e.g. for local development):

```bash
git clone https://github.com/toha82-tech/blindtype.git ~/.config/omarchy/plugins/blindtype
omarchy plugin enable blindtype --section right
```

### Optional: menu shortcuts

The bar icon alone is enough to open the trainer, but if you'd also like it
reachable from the Omarchy launcher menu (`Trigger → Blind Type`), add these
lines to `~/.config/omarchy/extensions/omarchy-menu.jsonc` (this file is
user-owned config, not something a plugin installer can safely write to for
you):

```jsonc
"trigger.blindtype": {"icon":"⌨","label":"Blind Type","aliases":["blindtype","typing"]},
"trigger.blindtype.open": {"icon":"⌨","label":"Open trainer","action":"omarchy-shell shell toggle blindtype"},
"trigger.blindtype.reset": {"icon":"󰭌","label":"Reset progress","action":"rm -f ~/.local/state/omarchy/blindtype-progress.json && omarchy-notification-send 'Blind Type' 'Progress reset'"}
```

The file hot-reloads on save — no restart needed.

## Usage

- Click the ⌨ bar indicator, or run `omarchy-shell shell toggle blindtype`,
  or (if you added the optional menu entries) use
  `Trigger → Blind Type → Open trainer`.
- Navigate levels with `↑`/`↓` + `Enter`, number keys, or mouse click.
- `Esc` returns to the previous screen / closes the overlay.
- Progress is stored at `~/.local/state/omarchy/blindtype-progress.json`.
  Reset anytime by deleting that file, or via the optional menu's
  "Reset progress" action.

## Uninstall

```bash
omarchy plugin remove blindtype
```

This disables the plugin, removes its bar placement, and deletes
`~/.config/omarchy/plugins/blindtype` (a timestamped backup is kept
automatically alongside it, e.g. `.blindtype.bak.<timestamp>`, in case you
want to restore it).

To also remove saved progress and the optional menu entries:

```bash
rm -f ~/.local/state/omarchy/blindtype-progress.json
# and remove the three trigger.blindtype* lines you added to
# ~/.config/omarchy/extensions/omarchy-menu.jsonc, if you added them
```

## Files

| File | Purpose |
|---|---|
| `manifest.json` | Plugin manifest (id, kinds, entry points). |
| `BlindType.qml` | Main overlay: menu/lesson/results screens, state machine, persistence. |
| `Keyboard.qml` | On-screen QWERTY keyboard visual, theme-derived colors. |
| `BarWidget.qml` | Compact bar indicator (level + streak). |
| `Corpus.js` | Word/sentence/punctuation data banks. |
| `Curriculum.js` | 10-level curriculum definitions + drill-text generators. |
| `ProgressStore.js` | Progress persistence, accuracy/WPM/streak calculators. |

## License

MIT — see [LICENSE](LICENSE).

## Development notes

- Validated with `qmllint` (only the standard false-positive categories that
  also appear in Omarchy's own first-party plugins, due to the dynamic
  `qs.Commons`/`qs.Ui` import namespace not being statically resolvable).
- Live-tested against a running `quickshell -p /usr/share/omarchy/shell`
  instance: overlay open/close, full lesson completion, level unlocking,
  bar-widget live update, and menu actions all confirmed working.
