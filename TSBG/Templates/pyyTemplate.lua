local lplr = game.Players.LocalPlayer
local char = lplr.Character or lplr.CharacterAdded:Wait()

-- Object Removers (will remove vfx on the weapons, though)
local katana1 = false -- Make true if you want to remove Blade Master's katana
local katana2 = false -- Make true if you want to remove Sonic's katana
local bat = false -- Make true if you want to remove Metal Bat's baseball bat
if katana1 then char:FindFirstChild("Sheathe"):Destroy() char:FindFirstChild("#KATANAWEAPON"):Destroy() end
if katana2 then char:FindFirstChild("Sheathed"):Destroy() char:FindFirstChild("#NinjaKATANA"):Destroy() end
if bat then char:FindFirstChild("#BATWEAPON"):Destroy() end

-- Editing names
local plrgui:PlayerGui = lplr:FindFirstChild("PlayerGui")
local gui:ScreenGui = plrgui:FindFirstChild("Bar")
local ultbar:Frame = gui:FindFirstChild("MagicHealth")
local ultbarclr:Frame = ultbar:FindFirstChild("Health").Bar.Bar
local ulttext:TextButton = ultbar:FindFirstChild("TextLabel")

-- Awakening text & color
ulttext.Text = "Missing Brother"
ultbarclr.BackgroundColor3 = Color3.fromRGB(136, 0, 0) -- In RGB values (red, green, blue)

local hotbar:ScreenGui = plrgui:FindFirstChild("Hotbar")
local backpack = hotbar:FindFirstChild("Backpack")
local hotbarf:Frame = backpack:FindFirstChild("Hotbar")
local bbb1, bbb2, bbb3, bbb4 = hotbarf["1"], hotbarf["2"], hotbarf["3"], hotbarf["4"]
local bb1, bb2, bb3, bb4 = bbb1["Base"], bbb2["Base"], bbb3["Base"], bbb4["Base"]
local b1, b2, b3, b4 = bb1["ToolName"], bb2["ToolName"], bb3["ToolName"], bb4["ToolName"]

-- Move names
local function SetMoveNames()
    b1.Text = "Piercing Blood"
    b2.Text = "Blood Squirt"
    b3.Text = "Kickback"
    b4.Text = "Uprise"
end
SetMoveNames()

-- Awakening move names
local function SetAwkNames()
    b1.Text = "Vengeance"
    b2.Text = "Blood Rain"
    b3.Text = "200% Piercing Blood"
    b4.Text = "Sky Maelstrom"
end

-- Tools
local extraTools = {
    run = {
        Name = "Run", -- if Name is not provided, it uses it's internal name instead ("run")
    }
}
local extraMoves = { -- Tools but acts like moves
    fart = {
        Name = "Fart",
        Cooldown = 1, -- Adds a cooldown on the tool
    }
}

-- Animations
-- Old Animations (Animations that are currently being replaced)
local oldAnimations = {
    m1 = "10469493270", -- Replace with the old m1 animation ID
    m2 = "10469630950", -- Replace with the old m2 animation ID
    m3 = "10469639222", -- Replace with the old m3 animation ID
    m4 = "10469643643", -- Replace with the old m4 animation ID
    ds = "10470104242", -- Actually, DON'T replace this
    up = "10503381238", -- Actually, DON'T replace this
    wc = "15955393872", -- Replace with the old wall combo animation ID
    fdash = "18715858574", -- Actually, DON'T replace this
    bdash = "...", -- Actually, DON'T replace this
    ldash = "10480796021", -- Actually, DON'T replace this
    rdash = "10480793962", -- Actually, DON'T replace this
    awk = "12447707844", -- Replace with the old awakening animation ID
    move1 = "10468665991", -- Replace with the old move 1 animation ID
    move2 = "10466974800", -- Replace with the old move 2 animation ID
    move3 = "10471336737", -- Replace with the old move 3 animation ID
    move4 = "12510170988", -- Replace with the old move 4 animation ID
    amove1 = "18715881168", -- Replace with the old awakening move 1 animation ID
    amove2 = "11365563255", -- Replace with the old awakening move 2 animation ID
    amove3 = "12983333733", -- Replace with the old awakening move 3 animation ID
    amove4 = "13927612951", -- Replace with the old awakening move 4 animation ID
}

-- New Animations (Animations that will replace the old ones)
local newAnimations = {
    m1 = "17889458563", -- Replace with your new m1 animation ID
    m2 = "17889461810", -- Replace with your new m2 animation ID
    m3 = "17889471098", -- Replace with your new m3 animation ID
    m4 = "17889290569", -- Replace with your new m4 animation ID
    ds = "10470104242", -- Replace with your new downslam animation ID
    up = "10503381238", -- Replace with your new mini uppercut animation ID
    wc = "15955393872", -- Replace with your new wall combo animation ID
    fdash = "18715858574", -- Replace with your new front dash animation ID
    bdash = "696969", -- Replace with your new back dash animation ID
    ldash = "10480796021", -- Replace with your new left dash animation ID
    rdash = "10480793962", -- Replace with your new right dash animation ID
    awk = "13716964686", -- Replace with your new awakening animation ID
    move1 = "12509505723", -- Replace with your new move 1 animation ID
    move2 = "12618271998", -- Replace with your new move 2 animation ID
    move3 = "17838619895", -- Replace with your new move 3 animation ID
    move4 = "18179181663", -- Replace with your new move 4 animation ID
    amove1 = "18715881168", -- Replace with your new move awakening 1 animation ID
    amove2 = "11365563255", -- Replace with your new move awakening 2 animation ID
    amove3 = "12983333733", -- Replace with your new move awakening 3 animation ID
    amove4 = "13927612951", -- Replace with your new move awakening 4 animation ID
}

-- Code/functions to use in the handlers
local function chat(msg: string)
    game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
end
local function playAnimation(id, details)
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid or not humanoid:FindFirstChild("Animator") then
        warn("Invalid humanoid or humanoid has no Animator.")
        return
    end
    
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://" .. tostring(id)
    
    local animator:Animator = humanoid:FindFirstChild("Animator")
    local animationTrack = animator:LoadAnimation(animation)

    animationTrack:Play()
    
    if details then
        if details.Priority then
            animationTrack.Priority = details.Priority
        end
        if details.Looped ~= nil then
            animationTrack.Looped = details.Looped
        end
        if details.Speed then
            animationTrack:AdjustSpeed(details.Speed)
        end
        if details.TimePosition then
            animationTrack.TimePosition = details.TimePosition
        end
        if details.Weight then
            animationTrack:AdjustWeight(details.Weight)
        end
    end

    return animationTrack
end


-- Handlers for each m1s, the ultimate anim, and moves (if it doesnt have handlers, it would be a blank custom moveset script with no vfx, no other stuff other than custom animations)
-- Also handlers for the extraTools and extraMoves
local handlers = {
    m1 = function() end,
    m2 = function() end,
    m3 = function() end,
    m4 = function() end,
    wc = function() end,
    fdash = function() end,
    bdash = function() end,
    ldash = function() end,
    rdash = function() end,

    awk = function()
        chat("I will do my best...")
        task.wait(0.5)
        chat("...as a brother!")
    end,

    move1 = function(tr)
        local hrp = char:FindFirstChild("HumanoidRootPart")

        local bloodvfx = game.ReplicatedStorage.Resources.BloodSplatter.Attachment:Clone()
        bloodvfx.Parent = char:FindFirstChild("Torso")
        for _, v in pairs(game.ReplicatedStorage.Resources.BloodSplatter.Attachment:GetChildren()) do
            if v:IsA("ParticleEmitter") then
                v.Enabled = false
                v:Emit(5)
            end
        end
        bloodvfx:Destroy()

        task.wait(0.7)
        if not tr.IsPlaying then
            return
        end
        local blood = Instance.new("Part")
        blood.Size = Vector3.new(0.25, 0.25, 60)
        blood.CFrame = hrp.CFrame * CFrame.new(0, 0, -25)
        blood.CanCollide = false
        blood.Anchored = true

        blood.Color = Color3.fromRGB(85, 19, 13)
        blood.Material = Enum.Material.Neon
        blood.CastShadow = false
        blood.Parent = workspace
        for _, v in pairs(game.ReplicatedStorage.Resources.BloodSplatter.Attachment:GetChildren()) do
            if v:IsA("ParticleEmitter") then
                local cl = v:Clone()
                cl.Parent = blood
                cl:Emit(2)
            end
        end
        game:GetService("Debris"):AddItem(blood, 1)
    end,

    move2 = function(tr:AnimationTrack)
        local bloodvfx = game.ReplicatedStorage.Resources.BloodSplatter.Attachment:Clone()
        bloodvfx.Parent = char:FindFirstChild("Torso")
        for _, v in pairs(game.ReplicatedStorage.Resources.BloodSplatter.Attachment:GetChildren()) do
            if v:IsA("ParticleEmitter") then
                v.Enabled = true
            end
        end

        local c = tr.Ended:Once(function()
            bloodvfx:Destroy()
        end)

        task.wait(1.5)
        bloodvfx:Destroy()
        c:Disconnect()
    end,

    move3 = function(newtr)
        local hrp = char:FindFirstChild("HumanoidRootPart")
        task.wait(0.5)
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, 0, math.huge)
        bv.Velocity = hrp.CFrame.LookVector * 50
        bv.Parent = hrp
        
        task.spawn(function()
            while true do
                bv.Velocity = hrp.CFrame.LookVector * 100
                task.wait()
            end
        end)
        game:GetService("Debris"):AddItem(bv, 0.5)
        
        newtr:Stop()
        playAnimation("75547590335774", { Weight = 10, Speed = 1.7 })
    end,

    move4 = function()
        print("choso awk")
    end,

    amove1 = function()
        print("choso awk")
    end,
    
    amove2 = function()
        print("choso awk")
    end,

    amove3 = function()
        print("choso awk")
    end,

    amove4 = function()
        print("choso awk")
    end,
}

-- Table of animation data for the animations
local animDt = {
    move2 = { Speed = 1.7 },
}

-- Tool/Moves
-- Tools
for k, v in pairs(extraTools) do
    local tool = Instance.new("Tool")
    tool.Name = v.Name or k
    tool.RequiresHandle = false
    tool.Parent = lplr.Backpack
    
    tool.Equipped:Connect(function(mouse)
        local handler = handlers[k] or function()end
        handler(mouse, true, tool) -- Second parameter is if it is equipped or not, third is the tool incase of uhh
    end)
    tool.Unequipped:Connect(function(mouse)
        local handler = handlers[k] or function()end
        handler(mouse, false, tool) -- Second parameter is if it is equipped or not, third is the tool incase of uhh
    end)
end
-- Extra moves
for k, v in pairs(extraMoves) do
    local tool = Instance.new("Tool")
    tool.Name = v.Name or k
    tool.RequiresHandle = false
    tool.Parent = lplr.Backpack
    tool:SetAttribute("OnCooldown", falsse)
    
    tool.Equipped:Connect(function(mouse)
        local hum = char.Humanoid
        if tool:GetAttribute("OnCooldown") then
            hum:UnequipTools()
            return
        end
        tool:SetAttribute("OnCooldown", true)
        local handler = handlers[k] or function()end
        
        handler(mouse)
        hum:UnequipTools()
        
        task.spawn(function()
            local tweenService = game:GetService("TweenService")
            local BACKPACK_SCRIPT = hotbar:FindFirstChildOfClass("LocalScript") or backpack:FindFirstChildOfClass("LocalScript")
            local COOLDOWN_UI = BACKPACK_SCRIPT.Base.Cooldown
            
            local cooldownUi = COOLDOWN_UI:Clone()
            cooldownUi.Parent = hotbarf:FindFirstChild(tostring(#lplr.Backpack:GetChildren()))
            tweenService:Create(cooldownUi, TweenInfo.new(v.Cooldown), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            task.wait(v.Cooldown)
            tool:SetAttribute("OnCooldown", false)
        end)
    end)
end

local hum = char:FindFirstChildOfClass("Humanoid")
local animator = hum:FindFirstChildOfClass("Animator")
for k, v in pairs(oldAnimations) do
    animator.AnimationPlayed:Connect(function(tr)
        if tr.Animation.AnimationId == "rbxassetid://" .. v and tr.Animation.AnimationId ~= "rbxassetid://" .. newAnimations[k] then
            tr:Stop()
            local trdt = animDt[k] or { Weight = 10 }
            if not trdt["Weight"] then trdt.Weight = 10 end -- Avoid bad animation
            local newtr = playAnimation(newAnimations[k], trdt)
            task.spawn(function() handlers[k](newtr) end)

            if k == "awk" then
                task.wait(1.25) -- Modify for your character's ultimate animation length
                SetAwkNames()
            end
        end
    end)
end

lplr:GetAttributeChangedSignal("Ultimate"):Connect(function()
    if lplr:GetAttribute("Ultimate") == 0 then
        task.wait(0.5) SetMoveNames()
    end
end)
