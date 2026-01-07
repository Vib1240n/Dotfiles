local colors = require("colors")
local settings = require("settings")

-- Bar mode toggle (between battery and bitwarden)
local bar_toggle = sbar.add("item", "bar_toggle", {
	position = "right",
	icon = {
		string = "􀨤", -- Toggle switch icon
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Regular"],
			size = 14.0,
		},
		color = colors.icon,
		padding_left = 6,
		-- padding_right = 6,
	},
	label = { drawing = false },
	background = { drawing = false },
	padding_left = 0,
	padding_right = 0,
})

-- iStats Menu Battery (visible by default)
local statsBattery = sbar.add("alias", "Control Center,com.bjango.istatmenus.battery", {
	position = "right",
	-- background = {
	-- 	padding_left = 4,
	-- 	padding_right = 4,
	-- },
})

-- Toggle arrow (starts closed)
local statsToggle = sbar.add("item", "stats.toggle", {
	position = "right",
	icon = {
		string = "􀆉",
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Regular"],
			size = 10.0,
		},
		color = colors.icon,
		padding_left = 4,
		padding_right = 4,
	},
	label = { drawing = false },
	background = { drawing = false },
	padding_left = 0,
	padding_right = 0,
})

-- iStats Menu Combined (hidden in bracket)
local statsCombined = sbar.add("alias", "Control Center,com.bjango.istatmenus.combined", {
	position = "right",
	width = 0,
	drawing = false,
	background = {
		padding_left = 4,
		padding_right = 4,
	},
})

-- Track expansion state
local is_expanded = false

local function toggle_stats()
	is_expanded = not is_expanded
	if is_expanded then
		statsToggle:set({ icon = { string = "􀆊" } })
		sbar.animate("tanh", 20, function()
			statsCombined:set({ width = "dynamic", drawing = true })
		end)
	else
		statsToggle:set({ icon = { string = "􀆉" } })
		sbar.animate("tanh", 20, function()
			statsCombined:set({ width = 0, drawing = false })
		end)
	end
end

statsToggle:subscribe("mouse.clicked", toggle_stats)

-- Hover effects
statsToggle:subscribe("mouse.entered", function()
	statsToggle:set({ icon = { color = colors.white } })
end)
statsToggle:subscribe("mouse.exited", function()
	statsToggle:set({ icon = { color = colors.icon } })
end)

statsBattery:subscribe("mouse.clicked", function()
	sbar.exec("$CONFIG_DIR/helpers/submenu/submenu-test -c 'Control Center,com.bjango.istatmenus.battery'")
end)

statsCombined:subscribe("mouse.clicked", function()
	sbar.exec("$CONFIG_DIR/helpers/submenu/submenu-test -c 'Control Center,com.bjango.istatmenus.combined'")
end)

-- Bar mode toggle hover and click
bar_toggle:subscribe("mouse.entered", function()
	bar_toggle:set({ icon = { color = colors.white } })
end)
bar_toggle:subscribe("mouse.exited", function()
	bar_toggle:set({ icon = { color = colors.icon } })
end)
bar_toggle:subscribe("mouse.clicked", function()
	sbar.trigger("bar_toggle_clicked")
end)

return { bar_toggle = bar_toggle, statsBattery = statsBattery }
