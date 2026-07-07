# Everforest Color Palette Reference

Source: https://github.com/NvChad/base46/blob/v3.0/lua/base46/themes/everforest.lua
(dark variant)

---

## base_30 — Named UI Colors

| Name             | Hex       | Notes                          |
|------------------|-----------|--------------------------------|
| `white`          | `#D3C6AA` | Primary foreground / text      |
| `darker_black`   | `#272F35` | Deepest background             |
| `black`          | `#2B3339` | Default nvim/app background    |
| `black2`         | `#323A40` | Slightly raised background     |
| `one_bg`         | `#363E44` | Raised surface                 |
| `one_bg2`        | `#363E44` | (same as one_bg)               |
| `one_bg3`        | `#3A4248` | Further raised / lines         |
| `grey`           | `#4E565C` | Muted UI elements              |
| `grey_fg`        | `#545C62` | Secondary foreground / muted   |
| `grey_fg2`       | `#626A70` | Slightly lighter muted fg      |
| `light_grey`     | `#656D73` | Lightest grey fg               |
| `red`            | `#E67E80` | Errors, deleted diff           |
| `baby_pink`      | `#CE8196` | Soft pink accent               |
| `pink`           | `#FF75A0` | Bright pink                    |
| `line`           | `#3A4248` | Vertical splits, dividers      |
| `green`          | `#83C092` | Strings, constants, hints      |
| `vibrant_green`  | `#A7C080` | Functions, search, added diff  |
| `nord_blue`      | `#78B4AC` | Teal-blue accent               |
| `blue`           | `#7393B3` | Identifiers, info              |
| `yellow`         | `#DBBC7F` | Types, warnings                |
| `sun`            | `#D1B171` | Warm yellow accent             |
| `purple`         | `#ECAFCC` | Light purple accent            |
| `dark_purple`    | `#D699B6` | Numbers, booleans, annotations |
| `teal`           | `#69A59D` | Teal accent                    |
| `orange`         | `#E69875` | Operators, tags, labels        |
| `cyan`           | `#95D1C9` | Cyan accent                    |
| `statusline_bg`  | `#2E363C` | Status bar background          |
| `lightbg`        | `#3D454B` | Lighter surface (popup bg)     |
| `pmenu_bg`       | `#83C092` | Popup menu background          |
| `folder_bg`      | `#7393B3` | Folder icon color              |

---

## base_16 — Standard Base16 Slots

| Slot     | Hex       | Semantic Role                          |
|----------|-----------|----------------------------------------|
| `base00` | `#2B3339` | Default background                     |
| `base01` | `#323C41` | Lighter background (status bars)       |
| `base02` | `#3A4248` | Selection background                   |
| `base03` | `#424A50` | Comments, invisibles                   |
| `base04` | `#4A5258` | Dark foreground (status bars)          |
| `base05` | `#D3C6AA` | Default foreground                     |
| `base06` | `#DDD0B4` | Light foreground                       |
| `base07` | `#E7DABE` | Light background                       |
| `base08` | `#7FBBB3` | Variables, XML attrs, diff deleted     |
| `base09` | `#D699B6` | Integers, booleans, constants          |
| `base0A` | `#83C092` | Classes, search text bg                |
| `base0B` | `#DBBC7F` | Strings                                |
| `base0C` | `#E69875` | Support, regex, escape chars           |
| `base0D` | `#A7C080` | Functions, methods                     |
| `base0E` | `#E67E80` | Keywords, storage, selectors           |
| `base0F` | `#D699B6` | Deprecated, embedded language tags     |

---

## Quick Semantic Cheat Sheet

```
background           = #2B3339  (black / base00)
background-raised    = #363E44  (one_bg)
background-deep      = #272F35  (darker_black)
statusline-bg        = #2E363C
selection / line     = #3A4248  (one_bg3 / line / base02)
popup-bg             = #3D454B  (lightbg)

foreground           = #D3C6AA  (white / base05)
comment / muted      = #4E565C  (grey / base03-ish)

red    / error       = #E67E80
orange / operators   = #E69875
yellow / types       = #DBBC7F
green  / strings     = #83C092
vibrant-green / fn   = #A7C080
blue   / identifiers = #7393B3
purple / numbers     = #D699B6

diff-add             = #A7C080  (vibrant_green)
diff-delete          = #E67E80  (red)
diff-change          = #7FBBB3  (base08 / nord_blue-ish)
```
