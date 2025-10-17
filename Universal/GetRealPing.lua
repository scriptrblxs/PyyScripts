-- GetRealPing.lua
-- open-source feel free to skid i guess
-- its literally free to use anyways

local lplr = Players.LocalPlayer

local defer = 0.003
task.spawn(function()
    while true do
        local ogt = workspace:GetServerTimeNow()
        task.defer(function()
            defer = workspace:GetServerTimeNow() - ogt
        end)
        task.wait()
    end
end)

return function()
    local ping = lplr:GetNetworkPing() * 2
    ping = ping + defer
    ping = ping + (0.03/1000 + (0.06/1000 - 0.03/1000) * math.random())
    return ping
end
