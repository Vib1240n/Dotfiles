local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

Wifi = sbar.add("alias", "Control Center,WiFi", {
  position = "popup.cal",
  -- alias = { color = colors.white },
  -- width = 8,
  alias = {
    color = colors.green,
    icon = {
      drawing = true,
    },
  },
  height = 30,
  -- padding_left = 0,
  background = {
    -- padding_right = 0,
    -- padding_left = 0,
  },
  -- label = { padding_right = 0, padding_left = 0, color = colors.green },
  -- icon = { padding_right = 0, padding_left = 0 },
  -- width = 75,
  -- padding_right = 0,
  popup = {
    drawing = true,
  },
})

sbar.add("bracket", "widgets.wifi.bracket", { Wifi.name }, {
  background = { color = colors.transparent, border_width = 1, border_color = colors.white },
  -- padding_left = 5,
})

sbar.add("item", "widgets.wifi.padding", { Wifi.name }, {
  position = "popup.cal",
  padding_right = 0,
  padding_left = 0,
  -- width = settings.group_paddings,
  icon = {
    padding_right = 0,
    padding_left = 0,
  },
  label = {
    padding_right = 0,
    padding_left = 0,
  },
  background = {
    padding_right = 0,
    padding_left = 0,
  },
})
