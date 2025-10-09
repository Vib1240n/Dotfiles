local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Create battery alias (visible by default)
local iStatsBattery = sbar.add("alias", "Control Center,com.bjango.istatmenus.battery", {
	position = "right",
	click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 'Control Center,com.bjango.istatmenus.battery'",
})

-- Add all other aliases (hidden)
local iStatsCPU = sbar.add("alias", "Control Center,com.bjango.istatmenus.cpu", {
	position = "right",
	width = 0,
	drawing = false,
	background = {
		color = colors.transparent,
		border_width = 0,
		corner_radius = 0,
		padding_left = 0,
		padding_right = 0,
	},
	click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 'Control Center,com.bjango.istatmenus.cpu'",
})

local iStatsMemory = sbar.add("alias", "Control Center,com.bjango.istatmenus.memory", {
	position = "right",
	width = 0,
	drawing = false,
	background = {

		color = colors.transparent,
		border_width = 0,
		corner_radius = 0,
		padding_left = 0,
		padding_right = 0,
	},

	click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 'Control Center,com.bjango.istatmenus.memory'",
})

local iStatsNetwork = sbar.add("alias", "Control Center,com.bjango.istatmenus.network", {
	position = "right",
	width = 0,
	drawing = false,
	background = {
		color = colors.transparent,
		border_width = 0,
		corner_radius = 0,
		padding_left = 0,
		padding_right = 0,
	},

	click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 'Control Center,com.bjango.istatmenus.network'",
})

local iStatsDisks = sbar.add("alias", "Control Center,com.bjango.istatmenus.disks", {
	position = "right",
	width = 0,
	drawing = false,
	background = {
		color = colors.transparent,
		border_width = 0,
		corner_radius = 0,
		padding_left = 0,
		padding_right = 0,
	},

	click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 'Control Center,com.bjango.istatmenus.disks'",
})

local iStatsSensors = sbar.add("alias", "Control Center,com.bjango.istatmenus.sensors", {
	position = "right",
	width = 0,
	drawing = false,
	background = {
		color = colors.transparent,
		border_width = 0,
		corner_radius = 0,
		padding_left = 0,
		padding_right = 0,
	},

	click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 'Control Center,com.bjango.istatmenus.sensors'",
})

-- Create bracket using TABLE of item names (not objects!)
local istats_bracket = sbar.add("bracket", {
	"Control Center,com.bjango.istatmenus.sensors",
	"Control Center,com.bjango.istatmenus.disks",
	"Control Center,com.bjango.istatmenus.network",
	"Control Center,com.bjango.istatmenus.memory",
	"Control Center,com.bjango.istatmenus.cpu",
	"Control Center,com.bjango.istatmenus.battery",
}, {
	background = {
		-- color = colors.item_border,
		border_width = 2,
		border_color = colors.item_border,
	},
})

-- Track expansion state
local is_expanded = false

-- Expand function
local function expand_istats()
	if is_expanded then
		return
	end
	is_expanded = true

	sbar.animate("tanh", 25, function()
		-- Show all hidden items
		iStatsSensors:set({ width = "dynamic", drawing = true, background = { drawing = false } })
		iStatsDisks:set({ width = "dynamic", drawing = true, background = { drawing = false } })
		iStatsNetwork:set({ width = "dynamic", drawing = true, background = { drawing = false } })
		iStatsMemory:set({ width = "dynamic", drawing = true, background = { drawing = false } })
		iStatsCPU:set({ width = "dynamic", drawing = true, background = { drawing = false } })

		-- Add unified bracket border
		istats_bracket:set({
			background = {
				color = colors.item,
				border_width = 1,
				border_color = colors.item_border,
			},
		})
	end)
end

-- Collapse function
local function collapse_istats()
	if not is_expanded then
		return
	end
	is_expanded = false

	sbar.animate("tanh", 25, function()
		-- Hide all except battery
		iStatsSensors:set({ width = 0, drawing = false })
		iStatsDisks:set({ width = 0, drawing = false })
		iStatsNetwork:set({ width = 0, drawing = false })
		iStatsMemory:set({ width = 0, drawing = false })
		iStatsCPU:set({ width = 0, drawing = false })

		-- Remove bracket border
		istats_bracket:set({
			background = {
				color = colors.transparent,
				border_width = 0,
			},
		})
	end)
end

-- Subscribe to mouse events
iStatsBattery:subscribe("mouse.entered", expand_istats)
iStatsCPU:subscribe("mouse.entered", expand_istats)
iStatsMemory:subscribe("mouse.entered", expand_istats)
iStatsNetwork:subscribe("mouse.entered", expand_istats)
iStatsDisks:subscribe("mouse.entered", expand_istats)
iStatsSensors:subscribe("mouse.entered", expand_istats)
--
iStatsBattery:subscribe("mouse.exited", collapse_istats)
iStatsCPU:subscribe("mouse.exited", collapse_istats)
iStatsMemory:subscribe("mouse.exited", collapse_istats)
iStatsNetwork:subscribe("mouse.exited", collapse_istats)
iStatsDisks:subscribe("mouse.exited", collapse_istats)
iStatsSensors:subscribe("mouse.exited", collapse_istats)
istats_bracket:subscribe("mouse.exited", collapse_istats)

return iStatsBattery
