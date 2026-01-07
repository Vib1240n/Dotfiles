-- Helper to dynamically find Stats widget alias indices
local M = {}

-- Query sketchybar and parse alias positions
function M.get_indices()
    local handle = io.popen("sketchybar --query alias 2>/dev/null")
    local result = handle:read("*a")
    handle:close()
    
    local indices = {
        battery = -1,
        ram = -1,
        cpu = -1,
        network = -1,
        disk = -1,
        sensor = -1
    }
    
    -- Count Control Center aliases in order
    local idx = 0
    for line in result:gmatch("[^\r\n]+") do
        if line:match("Control Center,Battery") then
            indices.battery = idx
            idx = idx + 1
        elseif line:match("Control Center,RAM_mini") then
            indices.ram = idx
            idx = idx + 1
        elseif line:match("Control Center,CPU_mini") then
            indices.cpu = idx
            idx = idx + 1
        elseif line:match("Control Center,Network_speed") then
            indices.network = idx
            idx = idx + 1
        elseif line:match("Control Center,Disk_mini") then
            indices.disk = idx
            idx = idx + 1
        elseif line:match("Control Center,Sensors_sensors") then
            indices.sensor = idx
            idx = idx + 1
        end
    end
    
    return indices
end

return M
