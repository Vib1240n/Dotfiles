#!/bin/sh

# The $SELECTED variable is available for space components and indicates if
# the space invoking this script (with name: $NAME) is currently selected:
# https://felixkratz.github.io/SketchyBar/config/components#space----associate-mission-control-spaces-with-an-item

source $CONFIG_DIR/colors.sh

if [ "$SELECTED" = "true" ]; then
  sketchybar --set "$NAME" background.color=$TEAL\
                           background.drawing=on      \
                           label.color=$WHITE  \
                           icon.color=$WHITE
else
  sketchybar --set "$NAME" background.drawing=off \
                            label.color=$BLACK \
                            icon.color=$BLACK
fi
