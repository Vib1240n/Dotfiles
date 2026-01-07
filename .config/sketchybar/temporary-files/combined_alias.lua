local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Stats ALIAS-based configuration
-- Using actual Stats app menu bar items as aliases
-- Note: Stats app must be running and showing items in menu bar

-- Get the correct Stats PID using pgrep
local stats_pid = "$(pgrep Stats )"

-- Battery alias (visible by default) - Shows actual Stats battery icon
local statsBattery = sbar.add("alias", "Control Center,eu.exelban.Stats", {
	position = "right",
	alias_color = colors.icon,
	background = {
		color = colors.transparent,
		padding_left = settings.paddings - 5,
		padding_right = settings.paddings - 5,
	},
	click_script = "$CONFIG_DIR/helpers/submenu/bin/submenu -c " .. stats_pid .. " 0",
})

-- Toggle arrow (starts closed)
local statsToggle = sbar.add("item", "stats.toggle", {
	position = "right",
	icon = {
		string = "􀄪",  -- Chevron left (closed state)
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Regular"],
			size = 14.0,
		},
		color = colors.icon,
	},
	label = {
		drawing = false,
	},
	background = {
		color = colors.transparent,
		padding_left = 5,
		padding_right = settings.paddings - 5,
	},
})

-- CPU alias (hidden) - Shows actual Stats CPU icon
local statsCPU = sbar.add("alias", "Control Center,eu.exelban.Stats.CPU", {
	position = "right",
	width = 0,
	drawing = false,
	alias_color = colors.icon,
	background = {
		color = colors.transparent,
		padding_left = settings.paddings - 5,
		padding_right = settings.paddings - 5,
	},
	click_script = "$CONFIG_DIR/helpers/submenu/bin/submenu -c " .. stats_pid .. " 4",
})

-- Memory/RAM alias (hidden) - Shows actual Stats RAM icon
local statsMemory = sbar.add("alias", "Control Center,eu.exelban.Stats.RAM", {
	position = "right",
	width = 0,
	drawing = false,
	alias_color = colors.icon,
	background = {
		color = colors.transparent,
		padding_left = settings.paddings - 5,
		padding_right = settings.paddings - 5,
	},
	click_script = "$CONFIG_DIR/helpers/submenu/bin/submenu -c " .. stats_pid .. " 3",
})

-- Network alias (hidden) - Shows actual Stats Network icon
local statsNetwork = sbar.add("alias", "Control Center,eu.exelban.Stats.Network", {
	position = "right",
	width = 0,
	drawing = false,
	alias_color = colors.icon,
	background = {
		color = colors.transparent,
		padding_left = settings.paddings - 5,
		padding_right = settings.paddings - 5,
	},
	click_script = "$CONFIG_DIR/helpers/submenu/bin/submenu -c " .. stats_pid .. " 1",
})

-- Disk/SSD alias (hidden) - Shows actual Stats Disk icon
local statsDisks = sbar.add("alias", "Control Center,eu.exelban.Stats.Disk", {
	position = "right",
	width = 0,
	drawing = false,
	alias_color = colors.icon,
	background = {
		color = colors.transparent,
		padding_left = settings.paddings - 5,
		padding_right = settings.paddings - 5,
	},
	click_script = "$CONFIG_DIR/helpers/submenu/bin/submenu -c " .. stats_pid .. " 2",
})

-- Create bracket (includes toggle arrow)
local stats_bracket = sbar.add("bracket", {
	statsToggle.name,
	statsBattery.name,
	statsCPU.name,
	statsMemory.name,
	statsNetwork.name,
	statsDisks.name,
}, {
	background = {
		color = colors.transparent,
		border_width = 0,
	},
})

-- Track expansion state
local is_expanded = false

-- Toggle function with rotation animation
local function toggle_stats_with_rotation()
	is_expanded = not is_expanded

	-- First, fade out the current icon
	sbar.animate("tanh", 15, function()
		statsToggle:set({ icon = { drawing = false } })
	end)

	-- Then change the icon and fade it back in
	sbar.exec("sleep 0.15 && sketchybar --set stats.toggle icon.drawing=on icon=" .. (is_expanded and "􀆊" or "􀆉"))

	if is_expanded then
		sbar.animate("tanh", 25, function()
			statsCPU:set({ width = "dynamic", drawing = true })
			statsMemory:set({ width = "dynamic", drawing = true })
			statsNetwork:set({ width = "dynamic", drawing = true })
			statsDisks:set({ width = "dynamic", drawing = true })
			stats_bracket:set({
				background = {
					color = colors.item,
					border_width = 1,
					border_color = colors.item_border,
				},
			})
		end)
	else
		sbar.animate("tanh", 25, function()
			statsCPU:set({ width = 0, drawing = false })
			statsMemory:set({ width = 0, drawing = false })
			statsNetwork:set({ width = 0, drawing = false })
			statsDisks:set({ width = 0, drawing = false })
			stats_bracket:set({
				background = {
					color = colors.transparent,
					border_width = 0,
				},
			})
		end)
	end
end

-- Subscribe toggle arrow to click
statsToggle:subscribe("mouse.clicked", toggle_stats_with_rotation)

-- Hover effects for each stats alias
-- Note: For aliases, we can only modify background/border, not the icon itself

-- Battery hover
statsBattery:subscribe("mouse.entered", function()
	sbar.animate("tanh", 15, function()
		statsBattery:set({
			background = {
				color = 0x40ffffff,  -- Semi-transparent white highlight
				border_color = colors.icon,
				border_width = 1,
			},
		})
	end)
end)

statsBattery:subscribe("mouse.exited", function()
	sbar.animate("tanh", 15, function()
		statsBattery:set({
			background = {
				color = colors.transparent,
				border_color = colors.transparent,
				border_width = 0,
			},
		})
	end)
end)

-- CPU hover
statsCPU:subscribe("mouse.entered", function()
	sbar.animate("tanh", 15, function()
		statsCPU:set({
			background = {
				color = 0x40ffffff,
				border_color = colors.icon,
				border_width = 1,
			},
		})
	end)
end)

statsCPU:subscribe("mouse.exited", function()
	sbar.animate("tanh", 15, function()
		statsCPU:set({
			background = {
				color = colors.transparent,
				border_color = colors.transparent,
				border_width = 0,
			},
		})
	end)
end)

-- Memory hover
statsMemory:subscribe("mouse.entered", function()
	sbar.animate("tanh", 15, function()
		statsMemory:set({
			background = {
				color = 0x40ffffff,
				border_color = colors.icon,
				border_width = 1,
			},
		})
	end)
end)
