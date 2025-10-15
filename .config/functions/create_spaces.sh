#!/usr/bin/env bash

# Space creation script
# 1. Create all 8 spaces on display 1
# 2. Move spaces 5-8 to display 2 (in REVERSE order to prevent renumbering issues)
# 3. Verify moves completed
# 4. Label spaces based on final positions

TARGET_SPACES=8

echo "=== Yabai Space Setup Starting ==="
echo ""

# Step 1: Detect displays
NUM_DISPLAYS=$(yabai -m query --displays | jq 'length')
echo "Step 1: Display Detection"
echo "  Number of displays: $NUM_DISPLAYS"
echo ""

# Step 2: Create all needed spaces on display 1
CURRENT_SPACES=$(yabai -m query --spaces | jq 'length')
echo "Step 2: Space Creation"
echo "  Current spaces: $CURRENT_SPACES"
echo "  Target spaces: $TARGET_SPACES"

if [ "$CURRENT_SPACES" -lt "$TARGET_SPACES" ]; then
    SPACES_TO_CREATE=$((TARGET_SPACES - CURRENT_SPACES))
    echo "  Creating $SPACES_TO_CREATE spaces on display 1..."
    
    # Focus display 1
    yabai -m display --focus 1 2>/dev/null
    
    for ((i=1; i<=SPACES_TO_CREATE; i++)); do
        yabai -m space --create && echo "    ✓ Created space $((CURRENT_SPACES + i))"
    done
else
    echo "  All spaces already exist"
fi
echo ""

# Step 3: Move spaces 5-8 to display 2 (only if dual monitor)
if [ "$NUM_DISPLAYS" -eq 2 ]; then
    echo "Step 3: Moving Spaces to Display 2"
    echo "  Moving spaces 5, 6, 7, 8 to display 2 (in reverse order)..."
    echo ""
    
    # CRITICAL: Move in REVERSE order (8, 7, 6, 5) to prevent index shifting
    for space in 8 7 6 5; do
        CURRENT_DISPLAY=$(yabai -m query --spaces --space "$space" 2>/dev/null | jq -r '.display')
        if [ "$CURRENT_DISPLAY" != "2" ]; then
            yabai -m space "$space" --display 2 2>/dev/null
            sleep 0.3  # Small delay to ensure move completes
            NEW_DISPLAY=$(yabai -m query --spaces --space "$space" 2>/dev/null | jq -r '.display')
            if [ "$NEW_DISPLAY" == "2" ]; then
                echo "    ✓ Space $space moved to display 2"
            else
                echo "    ✗ Warning: Failed to move space $space (currently on display $NEW_DISPLAY)"
            fi
        else
            echo "    ✓ Space $space already on display 2"
        fi
    done
    echo ""
    
    # Step 4: Verify all moves completed
    echo "Step 4: Verifying Space Placement"
    ALL_MOVED=true
    for space in 5 6 7 8; do
        DISPLAY=$(yabai -m query --spaces --space "$space" 2>/dev/null | jq -r '.display')
        if [ "$DISPLAY" != "2" ]; then
            echo "    ✗ Space $space is on display $DISPLAY (expected 2)"
            ALL_MOVED=false
        fi
    done
    
    if [ "$ALL_MOVED" = true ]; then
        echo "    ✓ All spaces correctly placed"
    else
        echo "    ⚠ Some spaces not correctly placed, continuing with labeling anyway..."
    fi
    echo ""
    
    # Step 5: Label spaces based on their final positions
    echo "Step 5: Labeling Spaces"
    echo ""
    
    echo "  Display 1 (Horizontal):"
    yabai -m space 1 --label A 2>/dev/null && echo "    ✓ Space 1 → A (Browsers)"
    yabai -m space 2 --label F 2>/dev/null && echo "    ✓ Space 2 → F (Fusion 360)"
    yabai -m space 3 --label B 2>/dev/null && echo "    ✓ Space 3 → B (3D Printing)"
    yabai -m space 4 --label W 2>/dev/null && echo "    ✓ Space 4 → W (Utilities)"
    echo ""
    
    echo "  Display 2 (Vertical):"
    yabai -m space 5 --label D 2>/dev/null && echo "    ✓ Space 5 → D (Discord)"
    yabai -m space 6 --label X 2>/dev/null && echo "    ✓ Space 6 → X (Terminal)"
    yabai -m space 7 --label O 2>/dev/null && echo "    ✓ Space 7 → O (Obsidian)"
    yabai -m space 8 --label S 2>/dev/null && echo "    ✓ Space 8 → S (Music)"
    echo ""
    
else
    # Single display mode
    echo "Step 3: Single Display Mode"
    echo "  All 8 spaces remain on display 1"
    echo ""
    
    echo "Step 4: Labeling All Spaces"
    yabai -m space 1 --label A 2>/dev/null && echo "    ✓ Space 1 → A (Browsers)"
    yabai -m space 2 --label D 2>/dev/null && echo "    ✓ Space 2 → D (Discord)"
    yabai -m space 3 --label X 2>/dev/null && echo "    ✓ Space 3 → X (Terminal)"
    yabai -m space 4 --label F 2>/dev/null && echo "    ✓ Space 4 → F (Fusion 360)"
    yabai -m space 5 --label B 2>/dev/null && echo "    ✓ Space 5 → B (3D Printing)"
    yabai -m space 6 --label O 2>/dev/null && echo "    ✓ Space 6 → O (Obsidian)"
    yabai -m space 7 --label S 2>/dev/null && echo "    ✓ Space 7 → S (Music)"
    yabai -m space 8 --label W 2>/dev/null && echo "    ✓ Space 8 → W (Utilities)"
    echo ""
fi

# Step 6: Clean up extra spaces
FINAL_TOTAL=$(yabai -m query --spaces | jq 'length')
if [ "$FINAL_TOTAL" -gt "$TARGET_SPACES" ]; then
    echo "Step 6: Cleaning Up Extra Spaces"
    echo "  Removing $((FINAL_TOTAL - TARGET_SPACES)) extra spaces..."
    for ((i=1; i<=FINAL_TOTAL-TARGET_SPACES; i++)); do
        LAST=$(yabai -m query --spaces | jq -r '.[-1].index')
        yabai -m space "$LAST" --destroy 2>/dev/null && echo "    ✓ Deleted space $LAST"
    done
    echo ""
fi

# Step 7: Final verification
echo "=== Final Configuration ==="
yabai -m query --spaces | jq -r '.[] | "  Space \(.index) (\(.label // "unlabeled")) on Display \(.display)"'
echo ""
echo "✓ Setup Complete!"
