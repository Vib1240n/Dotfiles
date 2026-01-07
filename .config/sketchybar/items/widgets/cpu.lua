local colors = require("colors")
local settings = require("settings")

-- CPU
local cpu = sbar.add("item", "cpu", {
	position = "right",
	icon = { string = "􀫥", font = { size = settings.fontL }, color = colors.icon, padding_right = 4 },
	label = { string = "0%", font = { size = settings.fontL }, color = colors.white, padding_right = 6 },
	popup = {
		align = "right",
		height = 50,
		y_offset = 5,
		background = { color = colors.bar_solid, corner_radius = 8, border_width = 1, border_color = colors.border },
	},
})

local cpu_popup = sbar.add("item", "cpu.popup", {
	position = "popup." .. cpu.name,
	icon = { drawing = false },
	label = { font = { size = settings.fontXL }, color = colors.white, padding_left = 12, padding_right = 12 },
})

-- Store CPU temp for popup
local cpu_temp = "N/A"

-- Subscribe to system_stats event from stats_provider
cpu:subscribe("system_stats", function(env)
	local usage = env.CPU_USAGE or "N/A"
	cpu:set({ label = usage })

	-- Store temperature for popup use
	cpu_temp = env.CPU_TEMP or "N/A"
end)

-- Update CPU popup when hovering
cpu:subscribe("mouse.entered", function()
	local popup_text = "Temp: " .. cpu_temp
	cpu_popup:set({ label = popup_text })
	sbar.animate("tanh", 15, function()
		cpu:set({ popup = { drawing = true } })
	end)
end)

cpu:subscribe("mouse.exited", function()
	sbar.animate("tanh", 15, function()
		cpu:set({ popup = { drawing = false } })
	end)
end)

-- Click handlers for btop
cpu:subscribe("mouse.clicked", function()
	sbar.exec("open -na kitty --args btop")
end)

return cpu
