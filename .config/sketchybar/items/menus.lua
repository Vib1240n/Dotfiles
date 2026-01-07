local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local menu_watcher = sbar.add("item", {
	drawing = false,
	updates = false,
})
local space_menu_swap = sbar.add("item", {
	drawing = false,
	updates = true,
})
sbar.add("event", "swap_menus_and_spaces")

local max_items = 10
local menu_items = {}

-- print("max_items" .. max_items)
local function create_menus()
	for i = 1, max_items, 1 do
		local menu = sbar.add("item", "menu." .. i, {
			padding_left = settings.paddings,
			height = settings.split_height,
			padding_right = settings.paddings,
			drawing = false,
			icon = { drawing = false },
			label = {
				font = {
					style = settings.font.style_map[i == 1 and "Heavy" or "Semibold"],
					size = settings.fontL,
				},
				padding_left = 6,
				padding_right = 6,
			},
			background = {
				height = settings.split_height,
				drawing = false,
			},
			click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s " .. i,
		})

		menu_items[i] = menu
	end
end

local menu_bracket = sbar.add("bracket", { "/menu\\..*/" }, {
	background = {
		color = colors.bar,
		height = settings.split_height,
		border_width = 1,
		border_color = colors.with_alpha(colors.light, 0.5),
	},
	blur_radius = settings.blur,
})

-- -- Add global mouse.exited to close menus when mouse leaves any menu item
-- menu_bracket:subscribe("mouse.exited.global", function(env)
-- 	sbar.trigger("swap_menus_and_spaces")
-- end)

local menu_padding = sbar.add("item", "menu.padding", {
	drawing = false,
	width = 0,
})
sbar.exec("sketchybar --query displays | jq -r '.[0].frame | \"\\(.w) \\(.h)\"'", function(output)
	local w, h = tonumber(output:match("([%d.]+)"))
	local monitor_w = tonumber(w)
	local monitor_h = tonumber(h)
	print("monitor width", monitor_w)
	print("monitor height", monitor_h)
	if monitor_w or monitor_h and (monitor_w < 1800 or monitor_h < 1169) then
		max_items = 5
	else
		max_items = 15
	end
	create_menus()
end)

local function update_menus(env)
	sbar.exec("$CONFIG_DIR/helpers/menus/bin/menus -l", function(menus)
		sbar.set("/menu\\..*/", { drawing = false })
		menu_padding:set({ drawing = true })
		id = 1
		for menu in string.gmatch(menus, "[^\r\n]+") do
			if id < max_items then
				menu_items[id]:set({ label = menu, drawing = true })
			else
				break
			end
			id = id + 1
		end
	end)
end
-- local function update_menus(env)
-- 	local handle = io.popen("$CONFIG_DIR/helpers/menus/bin/menus -l")
-- 	if handle then
-- 		local menus = handle:read("*a")
-- 		handle:close()
--
-- 		sbar.set("/menu\\..*/", { drawing = false })
-- 		menu_padding:set({ drawing = true })
--
-- 		local id = 1
-- 		for menu in string.gmatch(menus, "[^\r\n]+") do
-- 			if id < max_items then
-- 				menu_items[id]:set({ label = menu, drawing = true })
-- 			else
-- 				break
-- 			end
-- 			id = id + 1
-- 		end
-- 	else
-- 		-- handle error opening the process
-- 		print("Failed to run menus command")
-- 	end
-- end

menu_watcher:subscribe("front_app_switched", update_menus)

space_menu_swap:subscribe("swap_menus_and_spaces", function(env)
	local drawing = menu_items[1]:query().geometry.drawing == "on"
	if drawing then
		menu_watcher:set({ updates = false })
		sbar.set("/menu\\..*/", { drawing = false })
		sbar.set("/spaceID\\..*/", { drawing = true })
		sbar.set("front_app", { drawing = true })
	else
		menu_watcher:set({ updates = true })
		sbar.set("/spaceID\\..*/", { drawing = false })
		sbar.set("front_app", { drawing = false })
		update_menus()
	end
end)

return menu_watcher
