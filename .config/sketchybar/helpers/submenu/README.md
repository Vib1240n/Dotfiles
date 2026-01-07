# Submenu - Menu Bar Extras Control

A C program for clicking menu bar extras (right-side items) in SketchyBar, based on Felix Kratz's proven approach.

## How It Works

Uses **PID-based approach** with macOS Accessibility APIs:
- Takes a process ID (PID)
- Accesses `kAXExtrasMenuBarAttribute` directly
- Clicks menu bar items by index

## Quick Start

### 1. Compile

```bash
cd ~/.config/sketchybar/helpers/submenu
clang -std=c99 -O3 -F/System/Library/PrivateFrameworks/ -framework Carbon -framework ApplicationServices submenu.c -o bin/submenu
```

### 2. Find Processes with Menu Bar Extras

```bash
~/.config/sketchybar/helpers/submenu/bin/submenu -l
```

Output:
```
Scanning for processes with menu bar extras...
==============================================

PID: 12345   Name: iStat Menus Status          Items: 7
PID: 67890   Name: Control Center              Items: 5
PID: 54321   Name: Raycast                     Items: 1

Found 3 process(es) with menu bar extras
```

### 3. List Items for a Specific Process

```bash
# Using the PID from above
submenu -p 12345
```

Output:
```
Process 12345 has 7 menu bar extra(s):
  [0] Description: CPU
  [1] Description: Memory
  [2] Description: Network
  [3] Description: Disks
  [4] Description: Sensors
  [5] Description: Battery
  [6] Description: Time
```

### 4. Click a Menu Bar Extra

```bash
# Click first item (index 0)
submenu -c 12345

# Click specific item (e.g., Battery at index 5)
submenu -c 12345 5

# Click with debug output
submenu -v -c 12345 5
```

## Usage with SketchyBar

### Method 1: Using pidof

```lua
local istats_cpu = sbar.add("item", "istats_cpu", {
    position = "right",
    icon = { string = "󰍛" },
    label = { string = "CPU" },
    click_script = "$CONFIG_DIR/helpers/submenu/bin/submenu -c $(pidof 'iStat Menus Status') 0",
})
```

### Method 2: Store PID in variable

```bash
# In your sketchybarrc or a helper script
ISTATS_PID=$(pidof "iStat Menus Status")

sketchybar --add item istats_cpu right \
           --set istats_cpu \
                 icon=󰍛 \
                 label="CPU" \
                 click_script="$CONFIG_DIR/helpers/submenu/bin/submenu -c $ISTATS_PID 0"
```

### Method 3: Lua helper function

```lua
-- In your items file
local function get_pid(process_name)
    local handle = io.popen("pidof '" .. process_name .. "'")
    local pid = handle:read("*a"):gsub("%s+", "")
    handle:close()
    return pid
end

local istats_pid = get_pid("iStat Menus Status")

local istats_cpu = sbar.add("item", "istats_cpu", {
    position = "right",
    icon = { string = "󰍛" },
    click_script = "$CONFIG_DIR/helpers/submenu/bin/submenu -c " .. istats_pid .. " 0",
})
```

## Finding PIDs

Several ways to find the PID of a process:

```bash
# Method 1: pidof
pidof "iStat Menus Status"

# Method 2: pgrep
pgrep -f "iStat"

# Method 3: ps
ps aux | grep -i "istat" | grep -v grep

# Method 4: Use submenu itself
submenu -l  # Lists all processes with menu bar extras
```

## Common Examples

### iStat Menus

```bash
# Find PID
ISTATS_PID=$(pidof "iStat Menus Status")

# List available items
submenu -p $ISTATS_PID

# Click CPU (usually index 0)
submenu -c $ISTATS_PID 0

# Click Memory (usually index 1)
submenu -c $ISTATS_PID 1
```

### Control Center Items

```bash
# Find Control Center PID
CC_PID=$(pidof "Control Center")

# Click WiFi (find index with -p first)
submenu -c $CC_PID 0
```

### Raycast

```bash
RAYCAST_PID=$(pidof "Raycast")
submenu -c $RAYCAST_PID 0
```

## Command Reference

```
submenu -l                  List all processes with menu bar extras
submenu -p <PID>           List items for specific process
submenu -c <PID> [index]   Click item (default index: 0)
submenu -v -c <PID> [idx]  Click with verbose debug output
```

## Troubleshooting

### "Accessibility permissions not granted"

1. Open System Settings
2. Go to Privacy & Security > Accessibility  
3. Add your terminal app (iTerm, Terminal)
4. Enable the toggle

### "Process has no menu bar extras"

- Process doesn't have menu bar items
- Try using `submenu -l` to see which processes do have items

### Click doesn't work

1. Verify the PID: `pidof "Process Name"`
2. List items: `submenu -p <PID>`
3. Try with verbose: `submenu -v -c <PID> 0`
4. Check the index - it might not be 0

## Advantages of PID-Based Approach

✅ **More reliable** - Direct accessibility API access
✅ **Handles duplicates** - Index-based selection
✅ **Simpler code** - No window matching needed
✅ **Proven method** - Used by SketchyBar maintainer

## Credits

Based on the working code shared by Felix Kratz (SketchyBar maintainer) in:
https://github.com/FelixKratz/SketchyBar/discussions/236
