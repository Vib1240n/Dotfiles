local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Path to our system metrics script
local METRICS_SCRIPT = os.getenv("HOME") .. "/Development/bash_scripts/system_metrics.sh"

-- ============================================================
-- CREATE NATIVE METRIC ITEMS (instead of iStats aliases)
-- ============================================================

-- Battery item (visible by default)
local battery = sbar.add("item", "widgets.battery", {
	position = "right",
	icon = {
		string = icons.battery.charging,
		color = colors.green,
	},
	label = {
		string = "100%",
		color = colors.white,
	},
	update_freq = 30, -- Update every 30 seconds
	background = {
		color = colors.item,
		border_width = 0,
	},
})

-- CPU item (hidden by default)
local cpu = sbar.add("item", "widgets.cpu", {
	position = "right",
	width = 0,
	drawing = false,
	icon = {
		string = icons.cpu or "CPU",
		color = colors.blue,
	},
	label = {
		string = "0%",
		color = colors.white,
	},
	update_freq = 2, -- Update every 2 seconds
	background = {
		color = colors.transparent,
		border_width = 0,
	},
})

-- Memory item (hidden by default)
local memory = sbar.add("item", "widgets.memory", {
	position = "right",
	width = 0,
	drawing = false,
	icon = {
		string = icons.memory or "MEM",
		color = colors.yellow,
	},
	label = {
		string = "0%",
		color = colors.white,
	},
	update_freq = 5, -- Update every 5 seconds
	background = {
		color = colors.transparent,
		border_width = 0,
	},
})

-- Network item (hidden by default)
local network = sbar.add("item", "widgets.network", {
	position = "right",
	width = 0,
	drawing = false,
	icon = {
		string = icons.network or "NET",
		color = colors.purple,
	},
	label = {
		string = "↓0 ↑0",
		color = colors.white,
	},
	update_freq = 2, -- Update every 2 seconds
	background = {
		color = colors.transparent,
		border_width = 0,
	},
})

-- Disk item (hidden by default)
local disk = sbar.add("item", "widgets.disk", {
	position = "right",
	width = 0,
	drawing = false,
	icon = {
		string = icons.disk or "DISK",
		color = colors.cyan,
	},
	label = {
		string = "0%",
		color = colors.white,
	},
	update_freq = 30, -- Update every 30 seconds
	background = {
		color = colors.transparent,
		border_width = 0,
	},
})

-- Temperature/Sensors item (hidden by default)
local sensors = sbar.add("item", "widgets.sensors", {
	position = "right",
	width = 0,
	drawing = false,
	icon = {
		string = icons.temperature or "TEMP",
		color = colors.red,
	},
	label = {
		string = "N/A",
		color = colors.white,
	},
	update_freq = 5, -- Update every 5 seconds
	background = {
		color = colors.transparent,
		border_width = 0,
	},
})

-- ============================================================
-- UPDATE FUNCTIONS
-- ============================================================

-- Update battery
battery:subscribe("routine", function()
	sbar.exec(METRICS_SCRIPT .. " battery", function(battery_info)
		battery:set({ label = battery_info })
		
		-- Change icon based on status
		if battery_info:match("⚡") then
			battery:set({ icon = { string = icons.battery.charging or "⚡", color = colors.green } })
		elseif battery_info:match("🔌") then
			battery:set({ icon = { string = icons.battery.charged or "🔌", color = colors.green } })
		else
			local percentage = tonumber(battery_info:match("(%d+)%%"))
			if percentage then
				if percentage < 20 then
					battery:set({ icon = { string = icons.battery._0 or "🪫", color = colors.red } })
				elseif percentage < 50 then
					battery:set({ icon = { string = icons.battery._25 or "🔋", color = colors.orange } })
				else
					battery:set({ icon = { string = icons.battery._100 or "🔋", color = colors.green } })
				end
			end
		end
	end)
end)

-- Update CPU
cpu:subscribe("routine", function()
	sbar.exec(METRICS_SCRIPT .. " cpu", function(cpu_usage)
		cpu:set({ label = cpu_usage:gsub("^%s*(.-)%s*$", "%1") .. "%" })
		
		-- Change color based on usage
		local usage = tonumber(cpu_usage)
		if usage then
			if usage > 80 then
				cpu:set({ label = { color = colors.red } })
			elseif usage > 50 then
				cpu:set({ label = { color = colors.orange } })
			else
				cpu:set({ label = { color = colors.white } })
			end
		end
	end)
end)

-- Update Memory
memory:subscribe("routine", function()
	sbar.exec(METRICS_SCRIPT .. " memory", function(mem_pressure)
		memory:set({ label = mem_pressure:gsub("^%s*(.-)%s*$", "%1") .. "%" })
		
		-- Change color based on pressure
		local pressure = tonumber(mem_pressure)
		if pressure then
			if pressure > 70 then
				memory:set({ label = { color = colors.red } })
			elseif pressure > 50 then
				memory:set({ label = { color = colors.orange } })
			else
				memory:set({ label = { color = colors.white } })
			end
		end
	end)
end)

-- Update Network
network:subscribe("routine", function()
	sbar.exec(METRICS_SCRIPT .. " network", function(net_activity)
		-- Format: "↓ XX KB/s ↑ YY KB/s"
		network:set({ label = net_activity:gsub("^%s*(.-)%s*$", "%1") })
	end)
end)

-- Update Disk
disk:subscribe("routine", function()
	sbar.exec(METRICS_SCRIPT .. " disk_available", function(disk_space)
		disk:set({ label = disk_space:gsub("^%s*(.-)%s*$", "%1") .. " free" })
	end)
end)

-- Update Sensors/Temperature
sensors:subscribe("routine", function()
	sbar.exec(METRICS_SCRIPT .. " temp", function(temp)
		sensors:set({ label = temp:gsub("^%s*(.-)%s*$", "%1") })
	end)
end)

-- ============================================================
-- BRACKET AND EXPANSION
-- ============================================================

-- Create bracket
local metrics_bracket = sbar.add("bracket", {
	sensors.name,
	disk.name,
	network.name,
	memory.name,
	cpu.name,
	battery.name,
}, {
	background = {
		border_width = 2,
		border_color = colors.item_border,
	},
})

-- Track expansion state
local is_expanded = false

-- Expand function
local function expand_metrics()
	if is_expanded then
		return
	end
	is_expanded = true

	sbar.animate("tanh", 25, function()
		-- Show all hidden items
		sensors:set({ width = "dynamic", drawing = true })
		disk:set({ width = "dynamic", drawing = true })
		network:set({ width = "dynamic", drawing = true })
		memory:set({ width = "dynamic", drawing = true })
		cpu:set({ width = "dynamic", drawing = true })

		-- Add unified bracket border
		metrics_bracket:set({
			background = {
				color = colors.item,
				border_width = 1,
				border_color = colors.item_border,
			},
		})
	end)
end

-- Collapse function
local function collapse_metrics()
	if not is_expanded then
		return
	end
	is_expanded = false

	sbar.animate("tanh", 25, function()
		-- Hide all except battery
		sensors:set({ width = 0, drawing = false })
		disk:set({ width = 0, drawing = false })
		network:set({ width = 0, drawing = false })
		memory:set({ width = 0, drawing = false })
		cpu:set({ width = 0, drawing = false })

		-- Remove bracket border
		metrics_bracket:set({
			background = {
				color = colors.transparent,
				border_width = 0,
			},
		})
	end)
end

-- Subscribe to mouse events
battery:subscribe("mouse.entered", expand_metrics)
cpu:subscribe("mouse.entered", expand_metrics)
memory:subscribe("mouse.entered", expand_metrics)
network:subscribe("mouse.entered", expand_metrics)
disk:subscribe("mouse.entered", expand_metrics)
sensors:subscribe("mouse.entered", expand_metrics)

battery:subscribe("mouse.exited", collapse_metrics)
cpu:subscribe("mouse.exited", collapse_metrics)
memory:subscribe("mouse.exited", collapse_metrics)
network:subscribe("mouse.exited", collapse_metrics)
disk:subscribe("mouse.exited", collapse_metrics)
sensors:subscribe("mouse.exited", collapse_metrics)
metrics_bracket:subscribe("mouse.exited", collapse_metrics)

return battery
