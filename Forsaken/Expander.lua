local plr = game.Players.LocalPlayer
local chr = plr.Character or plr.CharacterAdded:Wait()
local hum = chr:WaitForChild("Humanoid")
local hrp = chr:WaitForChild("HumanoidRootPart")
local RunService = game:GetService("RunService")

local boostedAnimations = {
    ["rbxassetid://86545133269813"] = {waitTime = 0.01, dist = 6.5},
    ["rbxassetid://116618003477002"] = {waitTime = 0.4, dist = 5},
    ["rbxassetid://87259391926321"] = {waitTime = 0.7, dist = 8.5},
    ["rbxassetid://106538427162796"] = {waitTime = 0.25, dist = 10},
    ["rbxassetid://126830014841198"] = {waitTime = 0.1, dist = 5},
}

local boosttime = 0.5
local expanding = false

local function hitboxexpaend(extenddist)
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
            local extraVel = vel.Unit * (extenddist / ping)
            hrp.AssemblyLinearVelocity = vel + (extraVel * (elapsed * 2))
        end
    end)
end

hum.AnimationPlayed:Connect(function(track)
    local animId = track.Animation.AnimationId
    local animData = boostedAnimations[animId]
    if animData then
        task.delay(animData.waitTime, function()
            if track.IsPlaying then
                hitboxexpaend(animData.dist)
            end
        end)
    end
end)
