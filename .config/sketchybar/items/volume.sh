#!/bin/bash


sketchybar --add item volume right \
           --set volume script="$PLUGIN_DIR/volume.sh" \
           background.color=$TEAL \
                    label.color=$WHITE \
                    icon.color=$WHITE \
                    label.padding_right=20 \
                    icon.padding_left=20 \
           --subscribe volume volume_change \

