local plr = game.Players.LocalPlayer
local chr = plr.Character or plr.CharacterAdded:Wait()
local hum = chr:WaitForChild("Humanoid")
local hrp = chr:WaitForChild("HumanoidRootPart")
local RunService = game:GetService("RunService")

local boostedAnimations = {
    ["rbxassetid://86545133269813"] = 0.01,
    ["rbxassetid://116618003477002"] = 0.35,
    ["rbxassetid://87259391926321"] = 0.8,
}

local boosttime = 0.5
local extenddist = 20
local expanding = false

local function hitboxexpaend()
    if expanding then return end
    expanding = true
    
    hrp.Anchored = true
    local startTime = tick()
    
    local conn
    conn = RunService.RenderStepped:Connect(function(dt)
        local elapsed = tick() - startTime
        if elapsed > boosttime then
            conn:Disconnect()
            hrp.Anchored = false
            hrp.AssemblyLinearVelocity = Vector3.zero
            expanding = false
            return
        end
        
        local moveDir = hum.MoveDirection
        local speed = hum.WalkSpeed
        if moveDir.Magnitude > 0 then
            chr:TranslateBy(moveDir * speed * dt)
        end
        
        local vel = hrp.AssemblyLinearVelocity
        if vel.Magnitude > 1 then
            local ping = math.max(plr:GetNetworkPing(), 0.01)
            local extraVel = vel.Unit * (extenddist / ping())
            hrp.AssemblyLinearVelocity = vel + (Vector3.zero + (extraVel - Vector3.zero) * (elapsed * 2))
        end
    end)
end

hum.AnimationPlayed:Connect(function(track)
    local animId = track.Animation.AnimationId
    local waitTime = boostedAnimations[animId]
    if waitTime then
        task.delay(waitTime, function()
            if track.IsPlaying then
                hitboxexpaend()
            end
        end)
    end
end)