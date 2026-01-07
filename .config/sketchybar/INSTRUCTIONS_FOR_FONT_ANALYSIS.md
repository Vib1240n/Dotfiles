# Font Mapping Analysis Instructions

We have successfully built a custom font (`sketchybar-icon-font.ttf`) containing battery icons. Now we need to know **which character code** corresponds to **which icon** so we can use them in Sketchybar.

## Goal
Find the Unicode values (e.g., `\ue001` or `a`) for each of the following icons:
*   `battery_0`, `battery_10`, ... `battery_100`
*   `battery_charging_0`, ... `battery_charging_100`
*   `battery_warning`
*   `battery_charging_slow`

## Steps to Find the Mapping

1.  **Check the SVG Font File:**
    Run this command in the terminal to inspect the generated SVG font. It usually lists the `glyph-name` and the corresponding `unicode` character.
    ```bash
    grep "glyph-name=\"battery" dist/sketchybar-icon-font.svg
    ```
    *Look for output like:* `<glyph glyph-name="battery_100" unicode="&#xe001;" ... />`

2.  **Check for CSS/HTML Maps:**
    Sometimes a CSS file or HTML demo file is generated in `dist/` that lists the codes.
    *   Look for any `.css` or `.html` files in `dist/`.
    *   Search them for "battery".

3.  **Result Needed:**
    We need a list like this:
    *   `battery_0` -> `0xe000` (or character "A")
    *   `battery_100` -> `0xe00a`
    *   etc.

Once you have this list, we can update `items/widgets/battery.lua` to display the correct icons.
