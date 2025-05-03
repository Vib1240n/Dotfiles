#!/bin/bash

sketchybar --add item battery right \
           --set battery update_freq=120 \
                         script="$PLUGIN_DIR/battery.sh" \
                         background.color=$TEAL \
                    label.color=$WHITE \
                    icon.color=$WHITE \
                    label.padding_right=20 \
                    icon.padding_left=20 \
           --subscribe battery system_woke power_source_change
