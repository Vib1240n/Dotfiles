#!/usr/bin/env bash
# Focus a space by label, creating it if it doesn't exist

LABEL="$1"

if [ -z "$LABEL" ]; then
    echo "Usage: $0 <label>"
    exit 1
fi

# Find space with this label
target_space=$(yabai -m query --spaces | jq -r ".[] | select(.label == \"$LABEL\") | .index" | head -1)

if [ -n "$target_space" ]; then
    # Space exists, focus it
    yabai -m space --focus "$target_space"
else
    # Space doesn't exist, create it
    # Determine display based on label
    case "$LABEL" in
        T|B|P|F|U) target_display=1 ;;
        D|O|M) target_display=2 ;;
        *) target_display=1 ;;
    esac
    
    # Check display count
    num_displays=$(yabai -m query --displays | jq "length")
    if [ "$num_displays" -lt "$target_display" ]; then
        target_display=1
    fi
    
    # Create space
    yabai -m space --create
    new_space=$(yabai -m query --spaces | jq -r ".[-1].index")
    yabai -m space "$new_space" --label "$LABEL"
    
    # Move to correct display if needed
    current_display=$(yabai -m query --spaces --space "$new_space" | jq -r ".display")
    if [ "$current_display" != "$target_display" ]; then
        yabai -m space "$new_space" --display "$target_display" 2>/dev/null
        # Re-query index as it may have changed
        new_space=$(yabai -m query --spaces | jq -r ".[] | select(.label == \"$LABEL\") | .index")
    fi
    
    # Focus the new space
    yabai -m space --focus "$new_space"
fi
