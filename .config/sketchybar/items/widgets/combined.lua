local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Execute the event provider binary which provides the event "cpu_update" for
-- the cpu load data, which is fired every 2.0 seconds.
-- sbar.exec("killall cpu_load >/dev/null; $CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load cpu_update 2.0")

local cpu = sbar.add("alias", "Control Center,com.bjango.istatmenus.combined", {
  position = "popup.cal",
  background = {
    drawing = false,
  },
})

-- Background around the cpu item
sbar.add("bracket", "widgets.cpu.bracket", { cpu.name }, {
  background = {
    color = colors.transparent,
  },
})

-- Background around the cpu item
sbar.add("item", "widgets.cpu.padding", {
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
    padding_left = 10,
  },
  -- space = 1,
})
