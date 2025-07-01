local lplr = game.Players.LocalPlayer
local char = lplr.Character
local hrp = char.HumanoidRootPart
local hum = char.Humanoid
local bp = lplr.Backpack

local bar = lplr.PlayerGui.Bar
for _, v in pairs(bar:GetChildren()) do
    if v:IsA("GuiObject") then
        v:Destroy()
    end
end

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
    local movenumber = #bp:GetChildren()
    
    tool.Equipped:Connect(function()
        if not onCd then
            task.spawn(handler)
            
            local bps = lplr.PlayerGui.Hotbar:FindFirstChildOfClass("LocalScript") or lplr.PlayerGui.Hotbar.Backpack:FindFirstChildOfClass("LocalScript")
            local cdg = bps.Base.Cooldown:Clone()
            cdg.Parent = lplr.PlayerGui.Hotbar.Backpack.Hotbar:FindFirstChild(tostring(movenumber))
            game:GetService("TweenService"):Create(cdg, TweenInfo.new(cooldown), {Size = UDim2.fromScale(1, 0)}):Play()
            game:GetService("Debris"):AddItem(cdg, cooldown)
            
            onCd = true
            task.delay(cooldown, function()
                onCd = false
            end)
        end
        hum:UnequipTools()
    end)
end


local function  hitbox(size, offset, duration)
    local start = tick()
    
    while tick() - start < duration do
        local hb = Instance.new("Part")
        hb.Anchored = true
        hb.Transparency = 0.9
        hb.Material = Enum.Material.Foil
        hb.Color3 = Color3.fromRGB(255,0,0)
        hb.Size = size
        hb.CFrame = hrp.CFrame * CFrame.new(offset)
        hb.Parent = workspace
        
        local op = OverlapParams.new()
        op.FilterType = Enum.RaycastFilterType.Exclude
        op.FilterDescendantsInstances = {char}
        
        local parts = workspace:GetPartsInPart(hb, op)
        
        for _, v in pairs(parts) do
            local chr = v.Parent
            local hm = chr:FindFirstChildOfClass("Humanoid")
            if v.Name == "HumanoidRootPart" and chr and hm then
                return chr
            end
        end
        
        game:GetService("Debris"):AddItem(hb, 2)
        task.wait(0.1)
    end
    
    return nil
end

-- actual move sthit
newmove("Walkspeed Override", 20, function()
    local anm = Instance.new("Animation")
    anm.AnimationId = "rbxassetid://12983333733"
    local d = hum:LoadAnimation(anm)
    d:Play()
    d:AdjustWeight(10)
    d:AdjustSpeed(0)
    d.TimePosition = d.Length
    task.delay(1.3, d.Stop, d)
    
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = hrp.CFrame.LookVector * 50
    bv.P = 2500
    bv.Parent = hrp
    game:GetService("Debris"):AddItem(bv, 1.3)
    
    local hit = hitbox(Vector3.new(7, 5, 7), Vector3.new(0, 0, -(7/2)), 1.3)
    if hit then
        local hhrp = hit.HumanoidRootPart
        local anm = Instance.new("Animation")
        anm.AnimationId = "rbxassetid://12983333733"
        local h = hum:LoadAnimation(anm)
        h:Play()
        h:AdjustWeight(10)
        h.TimePosition = 101010102992 -- placeholder
        
        activateMove("Shove")
        local SSSS = tick()
        while tick() - SSSS < 1 do
            local dir = CFrame.Angles(hrp.CFrame:ToEulerAnglesXYZ())
            hrp.CFrame = CFrame.new(hhrp.CFrame.Position) * dir * CFrame.new(0, 0, 1)
        end
    else
        local anm = Instance.new("Animation")
        anm.AnimationId = "rbxassetid://12983333733"
        local h = hum:LoadAnimation(anm)
        h:Play()
        h:AdjustWeight(10)
        h.TimePosition = 1919198292 -- placeholder
        
        hrp.Anchored = true
        task.delay(1, function()
            hrp.Anchored = false
        end)
    end
end)