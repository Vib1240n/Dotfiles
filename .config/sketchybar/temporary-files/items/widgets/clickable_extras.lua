local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- This file contains examples of clickable menu bar items
-- Uncomment and add them to your items/init.lua to use them

local M = {}

-- Battery - native macOS battery menu
M.battery = sbar.add("item", "menu.battery", {
	position = "right",
	icon = {
		string = icons.battery._100,
		color = colors.green,
		padding_left = 8,
		padding_right = 8,
	},
	label = {
		string = "100%",
		color = colors.white,
		padding_right = 8,
	},
	background = {
		color = colors.bg2,
		border_color = colors.item_border,
		border_width = 1,
		corner_radius = 9,
		height = 40,
	},
	padding_left = 5,
	padding_right = 5,
	update_freq = 120,
	-- Click to open native Battery menu
	click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 'Control Center,Battery'",
})

-- WiFi - native macOS WiFi menu
M.wifi = sbar.add("item", "menu.wifi", {
	position = "right",
	icon = {
		string = icons.wifi.connected,
		color = colors.white,
		padding_left = 8,
		padding_right = 8,
	},
	label = { drawing = false },
	background = {
		color = colors.bg2,
		border_color = colors.item_border,
		border_width = 1,
		corner_radius = 9,
		height = 40,
	},
	padding_left = 5,
	padding_right = 5,
	-- Click to open native WiFi menu
	click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 'Control Center,WiFi'",
})

-- Bluetooth - native macOS Bluetooth menu
M.bluetooth = sbar.add("item", "menu.bluetooth", {
	position = "right",
	icon = {
		string = "󰂯", -- Bluetooth icon
		color = colors.blue,
		padding_left = 8,
		padding_right = 8,
	},
	label = { drawing = false },
	background = {
		color = colors.bg2,
		border_color = colors.item_border,
		border_width = 1,
		corner_radius = 9,
		height = 40,
	},
	padding_left = 5,
	padding_right = 5,
	-- Click to open native Bluetooth menu
	click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 'Control Center,Bluetooth'",
})

-- Sound/Volume - native macOS Sound menu
M.sound = sbar.add("item", "menu.sound", {
	position = "right",
	icon = {
		string = icons.volume._100,
		color = colors.white,
		padding_left = 8,
		padding_right = 8,
	},
	label = { drawing = false },
	background = {
		color = colors.bg2,
		border_color = colors.item_border,
		border_width = 1,
		corner_radius = 9,
		height = 40,
	},
	padding_left = 5,
	padding_right = 5,
	-- Click to open native Sound menu
	click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 'Control Center,Sound'",
})

-- Control Center - native macOS Control Center
M.control_center = sbar.add("item", "menu.control_center", {
	position = "right",
	icon = {
		string = "􀣋", -- Control Center icon
		color = colors.white,
		padding_left = 8,
		padding_right = 8,
	},
	label = { drawing = false },
	background = {
		color = colors.bg2,
		border_color = colors.item_border,
		border_width = 1,
		corner_radius = 9,
		height = 40,
	},
	padding_left = 5,
	padding_right = 5,
	-- Click to open Control Center
	click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 'ControlCenter,ControlCenter'",
})

-- Add hover effects to all menu items
for name, item in pairs(M) do
	item:subscribe("mouse.entered", function(env)
		sbar.animate("tanh", 10, function()
			item:set({
				background = {
					color = colors.with_alpha(colors.orange, 0.3),
				},
			})
		end)
	end)

	item:subscribe("mouse.exited", function(env)
		sbar.animate("tanh", 10, function()
			item:set({
				background = {
					color = colors.bg2,
				},
			})
		end)
	end)
end

return M
