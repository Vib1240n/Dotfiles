-- Require the sketchybar module
sbar = require("sketchybar")

-- Set the bar name, if you are using another bar instance than sketchybar
-- sbar.set_bar_name("bottom_bar")

-- Bundle the entire initial configuration into a single message to sketchybar
sbar.begin_config()
require("bar")
require("default")
require("items")
-- require("temporary-files")
sbar.hotload(true)
sbar.end_config()

-- Start the fan speed monitoring background script
sbar.exec("killall fan_timer.sh 2>/dev/null; $CONFIG_DIR/plugins/fan_timer.sh &")

-- Run the event loop of the sketchybar module (without this there will be no
-- callback functions executed in the lua module)
sbar.event_loop()
