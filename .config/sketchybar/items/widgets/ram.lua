local colors = require("colors")
local settings = require("settings")

-- RAM
local ram = sbar.add("item", "ram", {
	position = "right",
	icon = { string = "􀫦", font = { size = settings.fontL }, color = colors.icon, padding_right = 4 },
	label = { string = "0 GB", font = { size = settings.fontL }, color = colors.white, padding_right = 6 },
})

ram:subscribe("system_stats", function(env)
	local used = env.RAM_USED or "N/A"
	if used ~= "N/A" then
		ram:set({ label = used })
	else
		ram:set({ label = "N/A" })
	end
end)

ram:subscribe("mouse.clicked", function()
	sbar.exec("open -na kitty --args btop")
end)

return ram
