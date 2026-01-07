local colors = require("colors")

local bitwarden = sbar.add("item", "widgets.bitwarden", {
	position = "right",
	icon = {
		string = ":bit_warden:",
		font = "sketchybar-app-font:Regular:14.0",
		color = colors.icon,
		padding_left = 4,
		padding_right = 4,
	},
	label = { drawing = false },
	background = { drawing = false },
	padding_left = 0,
	padding_right = 0,
})

bitwarden:subscribe("mouse.entered", function()
	bitwarden:set({ icon = { color = colors.white } })
end)
bitwarden:subscribe("mouse.exited", function()
	bitwarden:set({ icon = { color = colors.icon } })
end)
bitwarden:subscribe("mouse.clicked", function()
	sbar.exec("$CONFIG_DIR/helpers/submenu/bin/submenu -c $(pidof Bitwarden)")
end)

return bitwarden
