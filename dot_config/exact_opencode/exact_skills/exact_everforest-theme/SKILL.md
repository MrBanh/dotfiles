---
name: everforest-theme
description: >
  Apply the Everforest color palette to any tool's theme or config file. Use this skill
  whenever the user wants to create a theme, apply colors, or style any CLI tool, terminal
  app, editor plugin, or config file using the Everforest palette — even if they just say
  "make it everforest", "theme this with everforest colors", "add everforest to my X config",
  or "create an everforest theme for X". Also trigger when the user provides a config file
  path and says to apply Everforest.
---

# Everforest Theme Skill

You apply the Everforest color palette to any tool's configuration. The palette is in
`references/palette.md` — read it at the start of every task.

## Workflow

### 1. Read the palette
Always read `references/palette.md` first.

### 2. Learn how the target app handles theming
If you don't already know the app's theme config format:
- Check if the user provided a link to the config docs or an existing config file — read those first.
- Otherwise use WebFetch or WebSearch on the app's official docs to find:
  - What config keys or sections control colors
  - What color format they expect (hex `#RRGGBB`, no-hash `RRGGBB`, rgb tuples, named roles, etc.)
  - Whether the app uses named semantic roles (e.g. `syntax.string`) or positional palette slots
- Look for an existing third-party Everforest port for the app — if one exists, use it as a
  starting point rather than mapping from scratch (search GitHub: `everforest <appname>`).

### 3. Map colors semantically
Match Everforest's colors to the app's theme roles using the cheat sheet in `references/palette.md`.
General rules:

| App concept                  | Color name       | Hex       |
|------------------------------|------------------|-----------|
| Default background           | `black`          | `#2B3339` |
| Raised surface               | `one_bg`         | `#363E44` |
| Deep background              | `darker_black`   | `#272F35` |
| Selection / dividers         | `one_bg3`/`line` | `#3A4248` |
| Popup / lightbg              | `lightbg`        | `#3D454B` |
| Default foreground           | `white`          | `#D3C6AA` |
| Comments / muted             | `grey`           | `#4E565C` |
| Strings / constants          | `green`          | `#83C092` |
| Functions / search / added   | `vibrant_green`  | `#A7C080` |
| Types / warnings             | `yellow`         | `#DBBC7F` |
| Keywords / errors / deleted  | `red`            | `#E67E80` |
| Operators / labels / tags    | `orange`         | `#E69875` |
| Identifiers / info           | `blue`           | `#7393B3` |
| Numbers / booleans / special | `dark_purple`    | `#D699B6` |
| Diff added                   | `vibrant_green`  | `#A7C080` |
| Diff deleted                 | `red`            | `#E67E80` |
| Diff changed                 | `nord_blue`      | `#78B4AC` |
| Borders / separators         | `line`           | `#3A4248` |

Don't force a mapping where the app doesn't have a concept — only fill in what's meaningful.

### 4. Output the config
- Produce a ready-to-use config block the user can paste directly into their config file.
- Show where in the config file it belongs (section header, file path, etc.).
- If the app needs a theme name, use `"everforest"` or `"everforest-dark"`.
- If the user provided their existing config file path, edit it directly rather than just
  printing the snippet.

### 5. Note any gaps
If some app theme slots don't have a clear Everforest equivalent, note them briefly and
explain what you chose or why you left them at the app default.

## Tips

- Prefer hex strings (`#2B3339`) unless the app requires a different format.
- If the app has a plugin or community theme already named "everforest", mention it — the
  user might prefer to install that instead of a hand-rolled config.
- For terminal emulators, map the 16 ANSI slots: blacks → `darker_black`/`black`, brights
  → `white`/`light_grey`, and the 8 standard colors → red/orange/yellow/vibrant_green/green/blue/dark_purple/white.
