#!/bin/bash

sketchybar --add item calendar right \
           --set calendar icon=􀉉 \
                update_freq=30 \
                script="$PLUGIN_DIR/calendar.sh" \
                background.color=$TEAL \
                    label.color=$WHITE \
                    icon.color=$WHITE \
                    label.padding_right=20 \
                    icon.padding_left=20 \
