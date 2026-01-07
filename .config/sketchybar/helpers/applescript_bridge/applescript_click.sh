#!/bin/bash

# AppleScript Bridge - Click menu bar items that block Accessibility API
# Usage: applescript_click.sh <process_name> <index>
# Example: applescript_click.sh "iStat Menus Menubar" 1

PROCESS_NAME="$1"
INDEX="$2"

if [ -z "$PROCESS_NAME" ] || [ -z "$INDEX" ]; then
    echo "Usage: $0 <process_name> <index>"
    echo "Example: $0 \"iStat Menus Menubar\" 1"
    exit 1
fi

# Click the menu bar item using AppleScript
osascript <<EOF
tell application "System Events"
    tell process "$PROCESS_NAME"
        try
            click menu bar item $INDEX of menu bar 1
            return "success"
        on error errMsg
            return "error: " & errMsg
        end try
    end tell
end tell
EOF
