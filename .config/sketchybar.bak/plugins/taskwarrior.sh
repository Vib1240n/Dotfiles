#!/bin/bash
# Function to list due tasks and update sketchybar
list_stats() {
    sketchybar --set "$NAME" popup.text="$(task stats)"

}
popup() {
	sketchybar --set "$NAME" popup.drawing="$1"
}
case "$SENDER" in
  "mouse.entered")
    list_stats
    popup on
    ;;
  "mouse.exited" | "mouse.exited.global")
    popup off
    ;;
  "mouse.clicked")
    list_stats
    popup toggle
    ;;
esac