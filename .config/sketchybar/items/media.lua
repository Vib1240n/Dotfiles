local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local M = {}

-- Simple media text item
M.media = sbar.add("item", {
	position = "center",
	icon = {
		string = icons.media.play_pause,
		color = colors.orange,
	},
	label = {
		color = colors.orange,
		font = { 
			family = settings.font.text,
			size = 12,
		},
	},
	background = {
		color = colors.bg2,
		border_color = colors.item_border,
		border_width = 1,
		corner_radius = 9,
		height = 40,
	},
	padding_left = 10,
	padding_right = 10,
	drawing = false,
	update_freq = 3,  -- Poll every 3 seconds
})

-- Update function
local function update_media()
	-- Direct script that checks and formats media info
	local script = [[
#!/bin/bash
NOWPLAYING="/opt/homebrew/bin/nowplaying-cli"
[ ! -f "$NOWPLAYING" ] && NOWPLAYING="/usr/local/bin/nowplaying-cli"
[ ! -f "$NOWPLAYING" ] && NOWPLAYING="$(which nowplaying-cli 2>/dev/null)"

if [ -z "$NOWPLAYING" ] || [ ! -f "$NOWPLAYING" ]; then
    echo "OFF"
    exit 0
fi

RATE=$($NOWPLAYING get playbackRate 2>/dev/null)
if [ "$RATE" = "1" ]; then
    ARTIST=$($NOWPLAYING get artist 2>/dev/null)
    TITLE=$($NOWPLAYING get title 2>/dev/null)
    if [ -n "$ARTIST" ] && [ -n "$TITLE" ]; then
        echo "ON|$ARTIST - $TITLE"
    else
        echo "OFF"
    fi
else
    echo "OFF"
fi
]]
	
	sbar.exec(script, function(result)
		if result and result ~= "" then
			result = result:gsub("^%s+", ""):gsub("%s+$", "")  -- Trim
			
			if result:match("^ON") then
				local label = result:gsub("^ON|", "")
				M.media:set({ 
					drawing = true,
					label = label
				})
			else
				M.media:set({ drawing = false })
			end
		else
			M.media:set({ drawing = false })
		end
	end)
end

-- Subscribe to routine for polling
M.media:subscribe("routine", update_media)

-- Initial update
update_media()

return M
