#!/bin/bash
# Helper script to click menu bar extras by process name instead of PID

SUBMENU_BIN="$(dirname "$0")/bin/submenu"

show_usage() {
    cat << EOF
submenu-by-name - Click menu bar extras by process name

Usage:
  $(basename "$0") -l                      List processes with menu bar extras
  $(basename "$0") -p "Process Name"       List items for a process
  $(basename "$0") -c "Process Name" [idx] Click item (default index: 0)
  $(basename "$0") -v -c "Process Name" [idx] Click with verbose output

Examples:
  $(basename "$0") -l
  $(basename "$0") -p "iStat Menus Status"
  $(basename "$0") -c "iStat Menus Status" 0
  $(basename "$0") -c "Raycast"

Note: Process names are case-sensitive and must match exactly.
EOF
    exit 0
}

if [ $# -eq 0 ]; then
    show_usage
fi

# Pass through -l flag
if [ "$1" = "-l" ]; then
    exec "$SUBMENU_BIN" -l
fi

# Handle -p (list items for process)
if [ "$1" = "-p" ] && [ -n "$2" ]; then
    PID=$(pidof "$2" 2>/dev/null)
    if [ -z "$PID" ]; then
        echo "Error: Process '$2' not found" >&2
        echo "Use: $(basename "$0") -l to see available processes" >&2
        exit 1
    fi
    exec "$SUBMENU_BIN" -p "$PID"
fi

# Handle -c (click)
if [ "$1" = "-c" ] && [ -n "$2" ]; then
    PID=$(pidof "$2" 2>/dev/null)
    if [ -z "$PID" ]; then
        echo "Error: Process '$2' not found" >&2
        echo "Use: $(basename "$0") -l to see available processes" >&2
        exit 1
    fi
    INDEX="${3:-0}"
    exec "$SUBMENU_BIN" -c "$PID" "$INDEX"
fi

# Handle -v -c (click with verbose)
if [ "$1" = "-v" ] && [ "$2" = "-c" ] && [ -n "$3" ]; then
    PID=$(pidof "$3" 2>/dev/null)
    if [ -z "$PID" ]; then
        echo "Error: Process '$3' not found" >&2
        echo "Use: $(basename "$0") -l to see available processes" >&2
        exit 1
    fi
    INDEX="${4:-0}"
    exec "$SUBMENU_BIN" -v -c "$PID" "$INDEX"
fi

echo "Error: Invalid arguments" >&2
show_usage
