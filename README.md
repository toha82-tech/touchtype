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
- Omarchy menu integration: `Trigger → Blind Type → Open trainer / Reset progress`.

## Install

Copy (or symlink) this directory into your Omarchy plugins folder:

```bash
cp -r . ~/.config/omarchy/plugins/blindtype
# or, to keep developing here and have the shell pick up live edits:
ln -s "$(pwd)" ~/.config/omarchy/plugins/blindtype
```

Then register the bar widget and menu entries (already done automatically if
you copied this from an already-configured machine; otherwise):

1. Add `{"id": "blindtype"}` to `bar.layout.right` (or another section) in
   `~/.config/omarchy/shell.json`.
2. Add to `~/.config/omarchy/extensions/omarchy-menu.jsonc`:
   ```jsonc
   "trigger.blindtype": {"icon":"⌨","label":"Blind Type","aliases":["blindtype","typing"]},
   "trigger.blindtype.open": {"icon":"⌨","label":"Open trainer","action":"omarchy-shell shell toggle blindtype"},
   "trigger.blindtype.reset": {"icon":"󰭌","label":"Reset progress","action":"rm -f ~/.local/state/omarchy/blindtype-progress.json && omarchy-notification-send 'Blind Type' 'Progress reset'"}
   ```
3. Reload: `omarchy-shell shell rescanPlugins` (or `omarchy restart shell`).

## Usage

- Click the ⌨ bar indicator, or use the Omarchy menu
  (`Trigger → Blind Type → Open trainer`), or run
  `omarchy-shell shell toggle blindtype`.
- Navigate levels with `↑`/`↓` + `Enter`, number keys, or mouse click.
- `Esc` returns to the previous screen / closes the overlay.
- Progress is stored at `~/.local/state/omarchy/blindtype-progress.json`.
  Reset anytime via the menu's "Reset progress" action.

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

## Development notes

- Validated with `qmllint` (only the standard false-positive categories that
  also appear in Omarchy's own first-party plugins, due to the dynamic
  `qs.Commons`/`qs.Ui` import namespace not being statically resolvable).
- Live-tested against a running `quickshell -p /usr/share/omarchy/shell`
  instance: overlay open/close, full lesson completion, level unlocking,
  bar-widget live update, and menu actions all confirmed working.
