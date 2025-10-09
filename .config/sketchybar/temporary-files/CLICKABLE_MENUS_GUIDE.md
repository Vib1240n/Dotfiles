# Clickable Menu Bar Items in Sketchybar

This guide shows you how to make your sketchybar widgets clickable to open native macOS menu popups.

## How It Works

The `helpers/menus/bin/menus` binary uses macOS Accessibility APIs to:
1. Find menu bar items by their alias name
2. Temporarily show the macOS menu bar
3. Click on the menu item to open its popup
4. Hide the menu bar again

## What's Already Set Up

✅ **iStats Menus**: Your combined widget is now clickable
   - Click anywhere on your stats display to open iStats Menus popup

## Usage

### 1. Make iStats Menus Clickable (Already Done!)

The `combined.lua` file is updated with:
```lua
click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 'Control Center,eu.exelban.Stats'",
```

Now when you click on your stats widget, it will open the iStats Menus popup!

### 2. Add Other Native macOS Menu Items

I've created examples in `items/widgets/clickable_extras.lua`:
- Battery (shows battery settings)
- WiFi (shows WiFi networks)
- Bluetooth (shows Bluetooth devices)  
- Sound/Volume (shows sound settings)
- Control Center (opens full Control Center)

To use these, add to your `items/init.lua`:
```lua
require("items.widgets.clickable_extras")
```

### 3. Discover Available Menu Bar Items

Run the discovery script to see what's available on your system:
```bash
chmod +x ~/Development/bash_scripts/discover_menu_items.sh
bash ~/Development/bash_scripts/discover_menu_items.sh
```

This will show all menu bar items in the format: `'OwnerName,WindowName'`

### 4. Create Custom Clickable Items

Format:
```lua
local item = sbar.add("item", "my_item", {
    -- ... your item properties ...
    click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 'Owner,Name'",
})
```

## Common Menu Bar Aliases

### Native macOS Items:
- `'Control Center,Battery'` - Battery menu
- `'Control Center,WiFi'` - WiFi menu
- `'Control Center,Bluetooth'` - Bluetooth menu
- `'Control Center,Sound'` - Volume/Sound menu
- `'ControlCenter,ControlCenter'` - Main Control Center

### Third-Party Apps:
- `'Control Center,eu.exelban.Stats'` - iStats Menus
- `'Control Center,com.bjango.istatmenus.status'` - iStat Menus (older)
- `'MenuBar,Spotify'` - Spotify (if it has a menu bar item)

Use the discovery script to find others!

## Testing

1. **Reload sketchybar:**
   ```bash
   brew services restart sketchybar
   ```

2. **Click on your stats widget** - it should open the iStats Menus popup!

3. **If it doesn't work**, check that:
   - The menus binary is compiled: `ls ~/.config/sketchybar/helpers/menus/bin/menus`
   - Accessibility permissions are granted to Terminal/sketchybar

## Troubleshooting

### Menus binary not found
```bash
cd ~/.config/sketchybar/helpers/menus
make
```

### Permission denied
macOS may need Accessibility permissions:
1. System Settings → Privacy & Security → Accessibility
2. Add Terminal or the app running sketchybar

### Finding the right alias
Run the discovery script to see exactly what's available on your system.

## Notes

- The menu bar is temporarily shown (0.15s) when clicking
- The click happens at the exact location of the menu bar item
- Works with both native macOS items and third-party apps
- Requires Accessibility API access

## Example: Adding Battery Widget

```lua
local battery = sbar.add("item", "battery.clickable", {
    position = "right",
    icon = { string = "󰁹" },
    label = { string = "100%" },
    background = {
        color = colors.bg2,
        border_color = colors.item_border,
        border_width = 1,
        corner_radius = 9,
    },
    click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 'Control Center,Battery'",
})
```

Enjoy your interactive sketchybar! 🎉
