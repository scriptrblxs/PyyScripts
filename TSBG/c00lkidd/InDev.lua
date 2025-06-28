local lplr = game.Players.LocalPlayer
local char = lplr.Character
local hum = char.Humanoid
local bp = lplr.Backpack

local com = char.Communicate

for _, v in pairs(bp:GetChildren()) do
    v.Parent = workspace
    v.Parent = bp
end

local function activateMove(mv)
    local params = {
        Tool = bp:FindFirstChild(mv),
        Goal = "Console Move",
    }
    
    com:FireServer(params)
end

hum.AnimationPlayed:Connect(function(tr)
    if tr.Animation.AnimationId == "rbxassetid://16944265635" then
        tr:Stop()
    end
end)

local function newmove(name, cooldown, handler)
    local tool = Instance.new("Tool")
    tool.Name = name
    tool.RequiresHandle = false
    tool.Parent = bp
    local onCd = false
    
    tool.Equipped:Connect(function()
        if not onCd then
            task.spawn(handler)
            -- cooldown gui thing placeholder
            onCd = true
            task.delay(cooldown, function()
                onCd = false
            end)
        end
        hum:UnequipTools()
    end)
end