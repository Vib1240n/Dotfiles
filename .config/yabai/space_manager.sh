#!/usr/bin/env bash
# Dynamic Space Manager for Yabai
# Creates spaces on-demand when apps open, destroys empty spaces when apps close

RECENT_SPACE_FILE="/tmp/yabai_recent_space"

# App to Label mapping
declare -A APP_LABELS=(
    # Terminals -> T
    ["kitty"]="T"
    ["iTerm2"]="T"
    ["iTerm"]="T"
    ["Alacritty"]="T"
    ["WezTerm"]="T"
    ["Ghostty"]="T"
    ["Fleet"]="T"
    
    # Browsers -> B
    ["Arc"]="B"
    ["Zen Browser"]="B"
    ["Zen"]="B"
    ["Google Chrome"]="B"
    ["Chrome"]="B"
    ["Dia"]="B"
    
    # 3D Printing -> P
    ["Bambu Studio"]="P"
    ["BambuStudio"]="P"
    ["OrcaSlicer"]="P"
    ["PrusaSlicer"]="P"
    ["Cura"]="P"
    
    # Fusion -> F
    ["Autodesk Fusion"]="F"
    ["Fusion 360"]="F"
    ["Fusion"]="F"
    
    # Discord -> D
    ["Legcord"]="D"
    ["Discord"]="D"
    
    # Obsidian -> O
    ["Obsidian"]="O"
    
    # Music -> M
    ["Spotify"]="M"
    ["Music"]="M"
    ["eqMac"]="M"
    
    # Utilities -> U
    ["Wootility"]="U"
    ["wootility-lekker"]="U"
    ["Zed"]="U"
    ["TickTick"]="U"
    ["PDFgear"]="U"
    ["Stats"]="U"
    ["TinkerTool"]="U"
)

# Get the label for an app (returns empty if not mapped)
get_app_label() {
    local app_name="$1"
    echo "${APP_LABELS[$app_name]:-}"
}

# Find space index by label (returns empty if not found)
get_space_by_label() {
    local label="$1"
    yabai -m query --spaces | jq -r ".[] | select(.label == \"$label\") | .index" | head -1
}

# Get current space index
get_current_space() {
    yabai -m query --spaces --space | jq -r '.index'
}

# Save current space as recent before switching
save_recent_space() {
    local current=$(get_current_space)
    if [ -n "$current" ]; then
        echo "$current" > "$RECENT_SPACE_FILE"
    fi
}

# Get the recent space
get_recent_space() {
    if [ -f "$RECENT_SPACE_FILE" ]; then
        cat "$RECENT_SPACE_FILE"
    else
        echo "1"
    fi
}


# Create a new space with label on the appropriate display
create_labeled_space() {
    local label="$1"
    local display="$1"
    
    # Determine which display based on label
    # Display 1: T, B, P, F, U
    # Display 2: D, O, M
    case "$label" in
        T|B|P|F|U) display=1 ;;
        D|O|M) display=2 ;;
        *) display=1 ;;
    esac
    
    # Check if display exists
    local num_displays=$(yabai -m query --displays | jq 'length')
    if [ "$num_displays" -lt "$display" ]; then
        display=1
    fi
    
    # Create space on the target display
    yabai -m display --focus "$display" 2>/dev/null
    yabai -m space --create 2>/dev/null
    
    # Get the newly created space (last space on that display)
    local new_space=$(yabai -m query --spaces --display "$display" | jq -r '.[-1].index')
    
    # Label the new space
    yabai -m space "$new_space" --label "$label" 2>/dev/null
    
    echo "$new_space"
}

# Get or create a space by label
get_or_create_space() {
    local label="$1"
    local space_index=$(get_space_by_label "$label")
    
    if [ -z "$space_index" ]; then
        # Space doesn't exist, create it
        space_index=$(create_labeled_space "$label")
    fi
    
    echo "$space_index"
}

# Move window to labeled space (creates space if needed)
move_window_to_label() {
    local window_id="$1"
    local label="$2"
    
    if [ -z "$label" ]; then
        return 1
    fi
    
    # Save current space before switching
    save_recent_space
    
    # Get or create the target space
    local target_space=$(get_or_create_space "$label")
    
    if [ -n "$target_space" ]; then
        # Move window silently (don't follow)
        yabai -m window "$window_id" --space "$target_space" 2>/dev/null
    fi
}

# Check if a space is empty (no windows)
is_space_empty() {
    local space_index="$1"
    local window_count=$(yabai -m query --windows --space "$space_index" 2>/dev/null | jq 'length')
    [ "$window_count" -eq 0 ]
}

# Destroy empty space and return to recent
cleanup_empty_space() {
    local space_index="$1"
    
    # Don't destroy if it's the only space on its display
    local display=$(yabai -m query --spaces --space "$space_index" 2>/dev/null | jq -r '.display')
    local spaces_on_display=$(yabai -m query --spaces --display "$display" 2>/dev/null | jq 'length')
    
    if [ "$spaces_on_display" -le 1 ]; then
        return 0
    fi
    
    # Check if space is empty
    if is_space_empty "$space_index"; then
        # Get recent space before destroying
        local recent=$(get_recent_space)
        
        # Focus recent space first
        if [ "$recent" != "$space_index" ] && [ -n "$recent" ]; then
            yabai -m space --focus "$recent" 2>/dev/null
        else
            yabai -m space --focus recent 2>/dev/null
        fi
        
        # Destroy the empty space
        yabai -m space "$space_index" --destroy 2>/dev/null
    fi
}

# Handle window created event
on_window_created() {
    local window_id="$1"
    
    # Get app name
    local app_name=$(yabai -m query --windows --window "$window_id" 2>/dev/null | jq -r '.app')
    
    if [ -z "$app_name" ]; then
        return 0
    fi
    
    # Get label for this app
    local label=$(get_app_label "$app_name")
    
    if [ -n "$label" ]; then
        move_window_to_label "$window_id" "$label"
    fi
}

# Handle window destroyed event
on_window_destroyed() {
    local space_index="$1"
    
    if [ -n "$space_index" ]; then
        # Small delay to let yabai update its state
        sleep 0.1
        cleanup_empty_space "$space_index"
    fi
}

# Main entry point - called with action and args
case "$1" in
    window_created)
        on_window_created "$2"
        ;;
    window_destroyed)
        on_window_destroyed "$2"
        ;;
    get_or_create)
        get_or_create_space "$2"
        ;;
    cleanup)
        cleanup_empty_space "$2"
        ;;
    *)
        echo "Usage: $0 {window_created|window_destroyed|get_or_create|cleanup} [args]"
        ;;
esac
