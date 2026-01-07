#!/usr/bin/env bash
# Move current window to a space by label, creating space if needed, and follow

LABEL="$1"

if [ -z "$LABEL" ]; then
    echo "Usage: $0 <label>"
    exit 1
fi

# Find space with this label
target_space=$(yabai -m query --spaces | jq -r ".[] | select(.label == \"$LABEL\") | .index" | head -1)

if [ -z "$target_space" ]; then
    # Space doesn't exist, create it
    case "$LABEL" in
        T|B|P|F|U) target_display=1 ;;
        D|O|M) target_display=2 ;;
        *) target_display=1 ;;
    esac
    
    num_displays=$(yabai -m query --displays | jq "length")
    if [ "$num_displays" -lt "$target_display" ]; then
        target_display=1
    fi
    
    yabai -m space --create
    target_space=$(yabai -m query --spaces | jq -r ".[-1].index")
    yabai -m space "$target_space" --label "$LABEL"
    
    current_display=$(yabai -m query --spaces --space "$target_space" | jq -r ".display")
    if [ "$current_display" != "$target_display" ]; then
        yabai -m space "$target_space" --display "$target_display" 2>/dev/null
        target_space=$(yabai -m query --spaces | jq -r ".[] | select(.label == \"$LABEL\") | .index")
    fi
fi

# Move window and follow
yabai -m window --space "$target_space"
yabai -m space --focus "$target_space"
