local colors = require("colors")
local settings = require("settings")

local LIST_MODE = "aerospace list-modes --current"
local LIST_ALL_MODES = "aerospace list-modes"

local mode_item = sbar.add("item", {
  position = "right",
  icon = {
    -- padding_right = 20,
    -- padding_left = 20,
    color = colors.black,
    -- string = "modes",
    y_offset = 1,
  },
  padding_right = 20,
  padding_left = 20,
  -- background = {
  --   padding_right = 20,
  --   padding_left = 20,
  -- },
  -- popup = {
  --   topmost = true,
  --   blur_radius = 30,
  --   height = 50,
  --   padding_right = 10,
  --   padding_left = 10,
  --   align = "right",
  --   horizontal = true,
  --   background = {
  --     color = colors.with_alpha(colors.white, 0.01),
  --     border_width = 1,
  --     border_color = colors.with_alpha(colors.teal, 0.2),
  --     -- padding_right = 10,
  --     -- padding_left = 10,
  --   },
  -- },
})

-- Create bracket for double border effect
local mode_bracket = sbar.add("bracket", { mode_item.name }, {
  background = {
    color = colors.with_alpha(colors.black, 0.3),
    border_color = colors.white,
    height = 30,
    border_width = 0,
    -- padding_right = 15,
    -- padding_left = 15,
  },
  -- padding_right = 15,
  -- padding_left = 15,
  blur_radius = 30,
  drawing = true,
})

mode_item:subscribe("space_windows_change", function()
  sbar.exec(LIST_MODE, function(modeOutput)
    modeOutput = modeOutput:gsub("%s+$", "") -- trim trailing spaces/newlines
    modeOutput = modeOutput:lower()
    mode_item:set({
      icon = {
        string = "modes",
      },
    })

    if string.find(modeOutput, "main") then
      mode_bracket:set({ background = { color = colors.with_alpha(colors.black, 0.3) } })
    elseif string.find(modeOutput, "resize") then
      mode_bracket:set({ background = { color = colors.with_alpha(colors.purple, 0.5) } })
    elseif string.find(modeOutput, "service") then
      mode_bracket:set({ background = { color = colors.with_alpha(colors.orange, 0.9) } })
    elseif string.find(modeOutput, "open") then
      mode_bracket:set({ background = { color = colors.with_alpha(colors.red, 0.5) } })
    elseif string.find(modeOutput, "pass") then
      mode_bracket:set({ background = { color = colors.with_alpha(colors.green, 0.5) } })
    else
      mode_bracket:set({ background = { color = colors.with_alpha(colors.magenta, 0.5) } })
    end
  end)
end)

-- mode_item:subscribe("mouse.clicked", function()
--   sbar.exec("aerospace mode main")
--   sbar.trigger("space_windows_change")
-- end)
--
-- mode_item:subscribe("mouse.clicked", function(env)
--   sbar.animate("sin", 3000, function(env)
--     mode_item:set({ popup = { drawing = "toggle" } })
--   end)
-- end)
