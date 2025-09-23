local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local spaces_indicator = sbar.add("item", {
  padding_left = 2,
  padding_right = 5,
  icon = {
    padding_left = 5,
    padding_right = 5,
    color = colors.bar.white,
    string = icons.switch.off,
    font = settings.font.text["SemiBold"],
  },
  label = {
    width = 0,
    padding_left = 0,
    padding_right = 8,
    string = "Spaces",
    color = colors.bar.bg_light,
    font = settings.font.text["SemiBold"],
  },
  background = {
    -- color = colors.bar.bg_light,
    border_width = 0,
  },
})

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
  local currently_on = spaces_indicator:query().icon.value == icons.switch.on
  spaces_indicator:set({
    icon = currently_on and icons.switch.off or icons.switch.on,
  })
end)

spaces_indicator:subscribe("mouse.entered.global", function(env)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 1.0 },
        border_color = { alpha = 1.0 },
      },
      icon = { color = colors.bar.label_white },
      label = { width = "dynamic", color = colors.red },
    })
  end)
end)

spaces_indicator:subscribe("mouse.exited.global", function(env)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 0.0 },
        border_color = { alpha = 0.0 },
      },
      icon = { color = colors.grey },
      label = { width = 0 },
    })
  end)
end)

spaces_indicator:subscribe("mouse.entered", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)
