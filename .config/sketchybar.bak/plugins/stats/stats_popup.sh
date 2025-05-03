#!/bin/bash
source $CONFIG_DIR/colors.sh
cpu_percent=(
	label.font="SF Pro:Semibold:15.0"
	label=CPU%
	label.color="$WHITE"
	icon="􀫥"
	icon.color="$WHITE"
	update_freq=2
	mach_helper="$HELPER"
	script="$CONFIG_DIR/plugins/stats/scripts/cpu.sh"
)


memory=(
    label.font="SF Pro:Semibold:15.0"
	label.color="$WHITE"
	icon="􀫦"
	icon.font="SF Pro:Medium:16.0"
	icon.color="$WHITE"
	update_freq=15
	script="$CONFIG_DIR/plugins/stats/scripts/ram.sh"
)

disk=(
	label.font="SF Pro:Semibold:15.0"
	label.color=$BLACK
	icon="􀧘"
	icon.color="$WHITE"
	update_freq=60
	script="$CONFIG_DIR/plugins/stats/scripts/disk.sh"
)

network_down=(
	# y_offset=-5
	label.font="SF Pro:Light:10.0"
	label.color=$BLUE
	icon="􁾭"
	icon.font="SF Pro:Light:10.0"
	icon.color=$WHITE
	icon.highlight_color=$ITEM_BG_COLOR
	update_freq=1
)

network_up=(
	# background.padding_right=-70
	# y_offset=5
	label.font="SF Pro:Light:10.0"
	label.color=$GREEN
	icon="􁾩"
	icon.font="SF Pro:Light:10.0"
	icon.color=$WHITE
	icon.highlight_color=$ITEM_BG_COLOR
	update_freq=1
	script="$CONFIG_DIR/plugins/stats/scripts/network.sh"
)



# sketchybar --set network.up "${network_up[@]}" \
# 			      label.font="SF Pro:Light:10.0" \
# 			      label.color=$GREEN \
# 			      icon="􁾩" \
# 			      icon.font="SF Pro:Light:10.0" \
# 			      icon.color=$WHITE \
# 			      icon.highlight_color=$ITEM_BG_COLOR \
# 			      update_freq=1 \
# 			      script="$PLUGIN_DIR/stats/scripts/network.sh" \
# 		--set network.down "${network_down[@]}" \
#                   label.font="SF Pro:Light:10.0" \
#                   label.color=$BLUE \
#                   icon="􁾭" \
#                   icon.font="SF Pro:Light:10.0" \
#                   icon.color=$WHITE \
#                   icon.highlight_color=$ITEM_BG_COLOR \
#                   update_freq=1 \
# 		--set disk "${disk[@]}" \
# 			      label.font="SF Pro:Semibold:15.0" \
# 			      label.color=$WHITE \
# 			      icon="􀧘" \
# 			      icon.color=$WHITE \
# 			      update_freq=60 \
# 			      script="$PLUGIN_DIR/stats/scripts/disk.sh" \
# 		--set memory "${memory[@]}" \
# 			      label.font="SF Pro:Semibold:15.0" \
# 				  label.color="$WHITE" \
# 				  icon="􀫦" \
# 				  icon.font="SF Pro:Medium:16.0" \
# 				  icon.color="$WHITE" \
# 				  update_freq=15 \
# 				  script="$PLUGIN_DIR/stats/scripts/ram.sh" \
# 		--set cpu.percent "${cpu_percent[@]}" \
# 			      label.font="SF Pro:Semibold:15.0" \
# 			      label=CPU% \
# 			      label.color="$WHITE" \
# 			      icon="􀫥" \
# 			      icon.color="$WHITE" \
# 			      update_freq=2 \
# 			      mach_helper="$HELPER" \
# 			      script="$PLUGIN_DIR/stats/scripts/cpu.sh" \

# case "$SENDER" in
#   "mouse.entered")
#     sketchybar --set $NAME popup.drawing=on
#     #echo "Mouse Hovered in $NAME icon" >> /tmp/sketchybar_debug.log
#     ;;
#   "mouse.exited" | "mouse.exited.global")
#     sketchybar --set $NAME popup.drawing=off
#     #echo "Mouse left hover of $NAME icon" >> /tmp/sketchybar_debug.log
#     ;;
#   "mouse.clicked")
#     sketchybar --set $NAME popup.drawing=toggle
#     #echo "Mouse clicked on $NAME icon" >> /tmp/sketchybar_debug.log
#     ;;
# esac