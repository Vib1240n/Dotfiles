-- Add the sketchybar module to the package cpath
package.cpath = package.cpath .. ";/Users/" .. os.getenv("USER") .. "/.local/share/sketchybar_lua/?.so"

-- Start stats_provider
os.execute("killall stats_provider >/dev/null 2>&1")
os.execute("/opt/homebrew/bin/stats_provider --cpu usage --cpu temperature --disk usage --disk used --memory ram_usage --memory ram_used --interval 3 >/dev/null 2>&1 &")

os.execute("(cd helpers && make)")
