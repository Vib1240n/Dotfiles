local colors = require("colors")
local settings = require("settings")

-- DISK
local disk = sbar.add("item", "disk", {
	position = "right",
	icon = { string = "􀨪", font = { size = settings.fontL }, color = colors.icon, padding_right = 4 },
	label = { string = "0%", font = { size = settings.fontL }, color = colors.white, padding_right = 6 },
})

disk:subscribe("system_stats", function(env)
	local usage = env.DISK_USAGE or "N/A"
	disk:set({ label = usage })
end)

disk:subscribe("mouse.clicked", function()
	sbar.exec("open 'x-apple.systempreferences:com.apple.settings.Storage'")
end)

return disk
