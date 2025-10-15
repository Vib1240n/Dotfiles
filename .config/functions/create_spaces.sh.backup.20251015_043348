#!/usr/bin/env bash

# Get current state
NUM_DISPLAYS=$(yabai -m query --displays | jq 'length')
echo "Number of displays: $NUM_DISPLAYS"

# Define space names
NAMES=(
    "Arc"        # Space 1 - Workspace A
    "Zen"        # Space 2 - Workspace Z
    "Discord"    # Space 3 - Workspace D
    "Terminal"   # Space 4 - Workspace X
    "Fusion"     # Space 5 - Workspace F
    "Bambu"      # Space 6 - Workspace B
    "Wootility"  # Space 7 - Workspace W
    "Utility"    # Space 8 - Workspace E
    "Chrome"     # Space 9 - Workspace C
    "Obsidian"   # Space 10 - Workspace O
    "Spotify"    # Space 11 - Workspace S
)

TARGET_SPACES=11

# Get spaces per display
DISPLAY1_SPACES=$(yabai -m query --spaces --display 1 | jq 'length')
echo "Display 1 has $DISPLAY1_SPACES spaces"

if [ "$NUM_DISPLAYS" -eq 2 ]; then
    DISPLAY2_SPACES=$(yabai -m query --spaces --display 2 | jq 'length')
    echo "Display 2 has $DISPLAY2_SPACES spaces"
    
    # Calculate how many spaces we need total
    TOTAL_CURRENT=$((DISPLAY1_SPACES + DISPLAY2_SPACES))
    echo "Total current spaces: $TOTAL_CURRENT"
    
    if [ "$TOTAL_CURRENT" -lt "$TARGET_SPACES" ]; then
        # Create missing spaces on display 1
        SPACES_TO_CREATE=$((TARGET_SPACES - TOTAL_CURRENT))
        echo "Creating $SPACES_TO_CREATE spaces on display 1..."
        
        # Focus display 1 first
        yabai -m display --focus 1
        
        for ((i=1; i<=SPACES_TO_CREATE; i++)); do
            yabai -m space --create && echo "  Created space $((TOTAL_CURRENT + i))"
        done
    fi
    
    # Now distribute: Move vertical-friendly spaces to display 2
    # Discord (3), Terminal (4), Obsidian (10)
    echo ""
    echo "Moving vertical-friendly spaces to display 2..."
    
    for space in 3 4 10; do
        CURRENT_DISPLAY=$(yabai -m query --spaces --space "$space" | jq -r '.display')
        if [ "$CURRENT_DISPLAY" != "2" ]; then
            yabai -m space "$space" --display 2 2>/dev/null && \
                echo "  Moved space $space (${NAMES[$((space-1))]}) to display 2" || \
                echo "  Warning: Could not move space $space"
        else
            echo "  Space $space already on display 2"
        fi
    done
    
else
    # Single display - just create spaces as needed
    TOTAL_CURRENT=$DISPLAY1_SPACES
    echo "Total current spaces: $TOTAL_CURRENT"
    
    if [ "$TOTAL_CURRENT" -lt "$TARGET_SPACES" ]; then
        SPACES_TO_CREATE=$((TARGET_SPACES - TOTAL_CURRENT))
        echo "Creating $SPACES_TO_CREATE spaces..."
        
        for ((i=1; i<=SPACES_TO_CREATE; i++)); do
            yabai -m space --create && echo "  Created space $((TOTAL_CURRENT + i))"
        done
    fi
fi

# Label all existing spaces
echo ""
echo "Labeling spaces..."
ACTUAL_SPACES=$(yabai -m query --spaces | jq 'length')
for i in "${!NAMES[@]}"; do
    SPACE_NUM=$((i + 1))
    if [ "$SPACE_NUM" -le "$ACTUAL_SPACES" ]; then
        yabai -m space "$SPACE_NUM" --label "${NAMES[$i]}" 2>/dev/null && \
            echo "  Space $SPACE_NUM: ${NAMES[$i]}" || \
            echo "  Warning: Could not label space $SPACE_NUM"
    fi
done

# Delete extra spaces if any
FINAL_TOTAL=$(yabai -m query --spaces | jq 'length')
if [ "$FINAL_TOTAL" -gt "$TARGET_SPACES" ]; then
    echo ""
    echo "Cleaning up $((FINAL_TOTAL - TARGET_SPACES)) extra spaces..."
    for ((i=1; i<=FINAL_TOTAL-TARGET_SPACES; i++)); do
        LAST=$(yabai -m query --spaces | jq -r '.[-1].index')
        yabai -m space "$LAST" --destroy 2>/dev/null && echo "  Deleted space $LAST"
    done
fi

echo ""
echo "=== Setup Complete ==="
yabai -m query --spaces | jq -r '.[] | "Space \(.index): \(.label) on display \(.display)"'
