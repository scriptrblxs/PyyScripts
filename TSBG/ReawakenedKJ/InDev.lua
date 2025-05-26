-- LICENSE.md
print(game:HttpGet("https://raw.githubusercontent.com/scriptrblxs/PyyScripts/refs/heads/main/LICENSE.md"))

local function notif(msg)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Reawakened KJ",
        Text = msg
    })
end

-- Premium Check
local verified = {
    "oioioibaaka828828",
    "skibidiSigm192919",
}
if not table.find(verified, game.Players.LocalPlayer.Name) and not table.find(game:GetService("HttpService"):JSONDecode(game:HttpGet("https://raw.githubusercontent.com/Mukuro-Hoshimiya/Whitelist/refs/heads/main/whitelist.json")).whitelist, game.Players.LocalPlayer.Name) then
notif("Premium checking, may take a while...")
httpserv = game:GetService"HttpService"
local keypoint = "https://pyy-api.glitch.me/v1/getpremiums"
repeat task.wait(5) until game:HttpGet(keypoint)
local data = httpserv:JSONDecode(game:HttpGet(keypoint))
local isValid = false
for _, v in pairs(data) do
    local suc, id = pcall(function()
        return game.Players:GetDataFromUsernameAsync(v)
    end)
    if id == game.Players.LocalPlayer.UserId then
        isValid = true
    end
end
if not isValid then game.Players.LocalPlayer:Kick("User is detected not to be a premium user while using premium script!") end
end

local lplr = game.Players.LocalPlayer

local char = lplr.Character or lplr.CharacterAdded:Wait()

-- Object Removers (will remove vfx on the weapons, though)
local katana1 = false -- Make true if you want to remove Blade Master's katana
local katana2 = false -- Make true if you want to remove Sonic's katana
local bat = false -- Make true if you want to remove Metal Bat's baseball bat
if katana1 then char:FindFirstChild("Sheathe"):Destroy() char:FindFirstChild("#KATANAWEAPON"):Destroy() end
if katana2 then char:FindFirstChild("Sheathed"):Destroy() char:FindFirstChild("#NinjaKATANA"):Destroy() end
if bat then char:FindFirstChild("#BATWEAPON"):Destroy() end

-- Modules
local cutmod = loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptrblxs/PyyScripts/refs/heads/main/TSBG/CutsceneModule.lua"))()
local cfseq = cutmod.CFrameSequence

-- Editing names
local plrgui:PlayerGui = lplr:FindFirstChild("PlayerGui")
local gui:ScreenGui = plrgui:FindFirstChild("Bar")
local ultbar:Frame = gui:FindFirstChild("MagicHealth")
local ultbarclr:Frame = ultbar:FindFirstChild("Health").Bar.Bar
local ulttext:TextButton = ultbar:FindFirstChild("TextLabel")

-- Awakening text & color
ulttext.Text = "KJ's Question"
ultbarclr.BackgroundColor3 = Color3.fromRGB(255, 35, 35) -- In RGB values (red, green, blue)

local hotbar:ScreenGui = plrgui:FindFirstChild("Hotbar")
local backpack = hotbar:FindFirstChild("Backpack")
local hotbarf:Frame = backpack:FindFirstChild("Hotbar")
local bbb1, bbb2, bbb3, bbb4 = hotbarf["1"], hotbarf["2"], hotbarf["3"], hotbarf["4"]
local bb1, bb2, bb3, bb4 = bbb1["Base"], bbb2["Base"], bbb3["Base"], bbb4["Base"]
local b1, b2, b3, b4 = bb1["ToolName"], bb2["ToolName"], bb3["ToolName"], bb4["ToolName"]

-- Move names
local function SetMoveNames()
    b1.Text = "Dilating Strike"
    b2.Text = "Ravaging Punches"
    b3.Text = "Swift Kick"
    b4.Text = "Collapse"
end
SetMoveNames()

-- Awakening move names
local function SetAwkNames()
    b1.Text = "20 Series"
    b2.Text = "Palm of Infinity"
    b3.Text = "Infinite Modulations"
    b4.Text = "Calm Ordnance"
end

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
    fdash = "10479335397", -- Actually, DON'T replace this
    bdash = "...", -- Actually, DON'T replace this
    ldash = "10480796021", -- Actually, DON'T replace this
    rdash = "10480793962", -- Actually, DON'T replace this
    awk = "12447707844", -- Replace with the old awakening animation ID
    move1 = "10468665991", -- Replace with the old move 1 animation ID
    move2 = "10466974800", -- Replace with the old move 2 animation ID
    move3 = "10471336737", -- Replace with the old move 3 animation ID
    move4 = "12510170988", -- Replace with the old move 4 animation ID
    amove1 = "11343318134", -- Replace with the old awakening move 1 animation ID
    amove2 = "11365563255", -- Replace with the old awakening move 2 animation ID
    amove3 = "12983333733", -- Replace with the old awakening move 3 animation ID
    amove4 = "13927612951", -- Replace with the old awakening move 4 animation ID
}

-- New Animations (Animations that will replace the old ones)
local newAnimations = {
    m1 = "17325510002", -- Replace with your new m1 animation ID
    m2 = "17325537719", -- Replace with your new m2 animation ID
    m3 = "17325522388", -- Replace with your new m3 animation ID
    m4 = "17325537719", -- Replace with your new m4 animation ID
    ds = "10470104242", -- Replace with your new downslam animation ID
    up = "10503381238", -- Replace with your new mini uppercut animation ID
    wc = "15955393872", -- Replace with your new wall combo animation ID
    fdash = "140164642047188", -- Replace with your new front dash animation ID
    bdash = "696969", -- Replace with your new back dash animation ID
    ldash = "10480796021", -- Replace with your new left dash animation ID
    rdash = "10480793962", -- Replace with your new right dash animation ID
    awk = "17140902079", -- Replace with your new awakening animation ID
    move1 = "16945550029", -- Replace with your new move 1 animation ID
    move2 = "16945550029", -- Replace with your new move 2 animation ID
    move3 = "16944265635", -- Replace with your new move 3 animation ID
    move4 = "17325254223", -- Replace with your new move 4 animation ID
    amove1 = "76530443909428", -- Replace with your new move awakening 1 animation ID
    amove2 = "12983333733", -- Replace with your new move awakening 2 animation ID
    amove3 = "77727115892579", -- Replace with your new move awakening 3 animation ID
    amove4 = "17141153099", -- Replace with your new move awakening 4 animation ID
}

-- Code/functions to use in the handlers

-- some variables for handlers
local ufwTime = 5.6

local avfx1 = game.ReplicatedStorage.Resources.KJEffects["fine...Emit"]["EmitBatch1"]:Clone() avfx1.Parent = char.HumanoidRootPart
local avfx2 = game.ReplicatedStorage.Resources.KJEffects["fine...Emit"]["EmitBatch2"]:Clone() avfx2.Parent = char.HumanoidRootPart
local avfx3 = game.ReplicatedStorage.Resources.KJEffects["fine...Emit"]["EmitBatch3"]:Clone() avfx3.Parent = char.HumanoidRootPart
local function awakeningVFXBatch1()
    for _, v in pairs(avfx1:GetDescendants()) do
        if v:IsA("ParticleEmitter") then
            v:Emit(v:GetAttribute("EmitCount"))
        end
    end
    for _, v in pairs(avfx2:GetDescendants()) do
        if v:IsA("ParticleEmitter") then
            v:Emit(v:GetAttribute("EmitCount"))
        end
    end
    for _, v in pairs(avfx3:GetDescendants()) do
        if v:IsA("ParticleEmitter") then
            v:Emit(v:GetAttribute("EmitCount"))
        end
    end
end

local ivfx1 = game.ReplicatedStorage.Resources.KJEffects["fine...1OG"]["EnableBatch2"]:Clone() ivfx1.Parent = char.HumanoidRootPart
local ivfx2 = game.ReplicatedStorage.Resources.KJEffects["fine...1OG"]["REDDDD1"]:Clone() ivfx2.Parent = char.HumanoidRootPart
local ivfx3 = game.ReplicatedStorage.Resources.KJEffects["fine...1OG"]["REDDDD2"]:Clone() ivfx3.Parent = char.HumanoidRootPart
local ivfx4 = game.ReplicatedStorage.Resources.KJEffects["fine...1OG"]["REDDDD3"]:Clone() ivfx4.Parent = char["Left Arm"]
local ivfx5 = game.ReplicatedStorage.Resources.KJEffects["fine...1OG"]["REDDDD4"]:Clone() ivfx5.Parent = char["Right Arm"]
local endvfx = game.ReplicatedStorage.Resources.KJEffects["stoic bomb boom entrance"]["THEACTUALBOOM"]:Clone() endvfx.Parent = char.HumanoidRootPart
local function awakeningVFXBatch2(duration:number)
    for _, v in pairs(ivfx1:GetDescendants()) do
        if v:IsA("ParticleEmitter") then
            v.Enabled = true
        end
    end
    ivfx2.Enabled = true
    ivfx3.Enabled = true
    ivfx4.Enabled = true
    ivfx5.Enabled = true
    
    task.delay(duration, function()
        for _, v in pairs(ivfx1:GetDescendants()) do
            if v:IsA("ParticleEmitter") then
                v.Enabled = false
            end
        end
        ivfx2.Enabled = false
        ivfx3.Enabled = false
        ivfx4.Enabled = false
        ivfx5.Enabled = false
        for _, v in pairs(endvfx:GetDescendants()) do
            if v:IsA("ParticleEmitter") then
                v:Emit(v:GetAttribute("EmitCount"))
            end
        end
    end)
end

local hrp = char:FindFirstChild("HumanoidRootPart")

local function playbfvfx(target)
    local Debris = game:GetService("Debris")
    local char = lplr.Character or lplr.CharacterAdded:Wait()
    local torso = char:FindFirstChild("Torso")
    local ttorso = target:FindFirstChild("Torso")

    if torso then
        local att1 = Instance.new("Attachment", torso)
        att1.CFrame = CFrame.new(0, 1, 1.5) * CFrame.fromEulerAngles(math.rad(torso.Rotation.X), math.rad(torso.Rotation.Y), math.rad(torso.Rotation.Z))

        local p1 = game.ReplicatedStorage.Resources.KJEffects["KJWallCombo"].FinalImpact.Attachment:Clone()
        p1.Parent = att1
        for _, v in ipairs(p1:GetChildren()) do
            if v:IsA("ParticleEmitter") then
                v.LockedToPart = false
                v.Rotation = NumberRange.new(0)
                v:Emit(v:GetAttribute("EmitCount") or 1)
            end
        end

        local p2 = game.ReplicatedStorage.Resources.KJEffects["KJWallCombo"].FinalImpact.Origin:Clone()
        p2.Parent = att1
        for _, v in ipairs(p2:GetChildren()) do
            if v:IsA("ParticleEmitter") then
                v.LockedToPart = false
                v.Rotation = NumberRange.new(0)
                v:Emit(v:GetAttribute("EmitCount") or 1)
            end
        end

        Debris:AddItem(att1, 1)
    end

    if ttorso then
        local att2 = Instance.new("Attachment", ttorso)
        att2.CFrame = CFrame.new(0, 0, 0) * CFrame.fromEulerAngles(math.rad(ttorso.Rotation.X), math.rad(ttorso.Rotation.Y), math.rad(ttorso.Rotation.Z))

        local p3 = game.ReplicatedStorage.Resources.KJEffects["KJWallCombo"].FinalImpact.Attachment:Clone()
        p3.Parent = att2
        for _, v in ipairs(p3:GetChildren()) do
            if v:IsA("ParticleEmitter") then
                v.LockedToPart = false
                v:Emit(v:GetAttribute("EmitCount") or 1)
            end
        end

        Debris:AddItem(att2, 1)
    end
end

local function emitParticles(attachment: Attachment)
    assert(attachment:IsA("Attachment"), "Particle container must be attachment!")
    for _, v in pairs(attachment:GetDescendants()) do
        if v:IsA("Attachment") then
            v:Emit(v:GetAttribute("EmitCount") or 1)
            game:GetService("Debris"):AddItem(v, 5)
        end
    end
end

local function enableParticles(attachment: Attachment)
    assert(attachment:IsA("Attachment"), "Particle container must be attachment!")
    for _, v in pairs(attachment:GetDescendants()) do
        if v:IsA("Attachment") then
            v.Enabled = true
            task.delay(v:GetAttribute("EmitDuration") or 1, function()
                v.Enabled = false
                game:GetService("Debris"):AddItem(v, duration or v:GetAttribute("Duration") or 1)
            end)
        end
    end
end

local function m1finisher()
    local nearestCharacter = nil
    local maxDistance = 100
    
    for _, v in pairs(workspace.Live:GetChildren()) do
        local humanoid = v:FindFirstChildOfClass("Humanoid")
        if humanoid and v ~= char then
            local opponentHrp = v:FindFirstChild("HumanoidRootPart")
            if (opponentHrp.Position - hrp.Position).Magnitude < maxDistance then
                maxDistance = (opponentHrp.Position - hrp.Position).Magnitude
                nearestCharacter = v
            end
        end
    end
    
    local nearestHumanoid = nearestCharacter:FindFirstChildOfClass("Humanoid")
    if nearestHumanoid.Health <= 4 then
        playbfvfx(nearestCharacter)
    end
end

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
        if details.EndTime then
            task.delay(details.EndTime, function() animationTrack:Stop(details.Fade or 0) end)
        end
    end

    return animationTrack
end

-- Removing every bodyvelocity that gets added to the character Y velocity for Collapse
char.DescendantAdded:Connect(function(c)
    if c:IsA("BodyVelocity") then
        c.Velocity = Vector3.new(c.Velocity.X, 0, c.Velocity.Z)
    end
end)

-- Handlers for each m1s, the ultimate anim, and moves (if it doesnt have handlers, it would be a blank custom moveset script with no vfx, no other stuff other than custom animations)
local handlers = {
    m1 = function() m1finisher() end,
    m2 = function() m1finisher() end,
    m3 = function() m1finisher() end,
    m4 = function() m1finisher() end,
    wc = function() m1finisher() end,
    fdash = function() end,
    bdash = function() end,
    ldash = function() end,
    rdash = function() end,

    awk = function(tr)
        awakeningVFXBatch1()
        awakeningVFXBatch2(tr.Length - 0.9)
        local loop = true
        task.spawn(function()
            while loop do
                hotbar.Enabled = false

                char.Humanoid.WalkSpeed = 0
                char.Humanoid.JumpPower = 0

                task.wait()
            end
        end)

        local sound1 = Instance.new("Sound")
        local sound2 = Instance.new("Sound")
        sound1.Parent = char.Head
        sound2.Parent = char.Head
        sound1.SoundId = "rbxassetid://17150550559"
        sound2.SoundId = "rbxassetid://17150550302"
        sound1.Volume = 5
        sound2.Volume = 5
        sound1:Play()
        sound2:Play()

        task.wait(tr.Length)
        loop = false
        sound1:Destroy()
        sound2:Destroy()
        hotbar.Enabled = true
        char.Humanoid.WalkSpeed = 16
        char.Humanoid.JumpPower = 50
    end,

    move1 = function()
        task.wait(0.3)
        local wind = game.ReplicatedStorage.Resources.KJEffects.RUNAROUNDWIND.RUNAROUNDWIND:Clone()
        wind.Parent = hrp
        
        for _, v in pairs(wind:GetDescendants()) do
            if v:IsA("ParticleEmitter") then
                v:Emit(v:GetAttribute("EmitCount"))
            end
        end
        
        game:GetService("Debris"):AddItem(wind, 5)
    end,

    move2 = function()
        task.wait(0.1)
        local smoke = game.ReplicatedStorage.Resources.KJEffects.BARRAGESMOKE.BARRAGESMOKE:Clone()
        local hits = game.ReplicatedStorage.Resources.KJEffects.HitParticles.Hit:Clone()
        smoke.Parent = hrp
        hits.Parent = hrp
        
        for _, v in pairs(smoke:GetDescendants()) do
            if v:IsA("ParticleEmitter") then
                v:Emit(v:GetAttribute("EmitCount"))
            end
        end
        for _, v in pairs(hits:GetDescendants()) do
            if v:IsA("ParticleEmitter") then
                v:Emit(v:GetAttribute("EmitCount"))
            end
        end
        
        game:GetService("Debris"):AddItem(smoke, 5)
        game:GetService("Debris"):AddItem(hits, 5)
    end,

    move3 = function()
        
        task.spawn(function()
            task.wait(0.2)
            local kj = game.ReplicatedStorage.Resources.KJEffects
            local sweep1 = kj.LegSweepHit.Hit
            local sweep2 = kj.LegSweepHit.HitTwo
            sweep1.Parent = hrp
            sweep2.Parent = hrp
            
            for _, v in pairs(sweep1:GetDescendants()) do
                if v:IsA("ParticleEmitter") then
                    v:Emit(v:GetAttribute("EmitCount"))
                end
            end
            for _, v in pairs(sweep2:GetDescendants()) do
                if v:IsA("ParticleEmitter") then
                    v:Emit(v:GetAttribute("EmitCount"))
                end
            end
            
            game:GetService("Debris"):AddItem(sweep1, 5)
            game:GetService("Debris"):AddItem(sweep2, 5)
        end)
    end,

    move4 = function()
        task.wait(0.5)
        local colateral1 = game.ReplicatedStorage.KJEffects.ColateralImapctTest.HitTwo:Clone()
        local colateral2 = game.ReplicatedStorage.KJEffects.ColateralImapctTest2.HitTwo:Clone()
        local spin = game.ReplicatedStorage.KJEffects.SpinnerEndWind.spinningemit:Clone()
        local smoke1 = game.ReplicatedStorage.KJEffects.spinnerthing.spinningparty:Clone()
        local smoke2 = game.ReplicatedStorage.KJEffects.spinnerthing.spinningpartysmoke:Clone()
        
        -- im too lazy. chatgpt, do it fornme
    end,

    amove1 = function(oldTrack)
        workspace.CurrentCamera:remove()
        wait()
        workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character:FindFirstChildWhichIsA('Humanoid')
        workspace.CurrentCamera.CameraType = "Custom"
        game.Players.LocalPlayer.CameraMinZoomDistance = 0.5
        game.Players.LocalPlayer.CameraMaxZoomDistance = 400
        game.Players.LocalPlayer.CameraMode = "Classic"
        game.Players.LocalPlayer.Character.Head.Anchored = false
        
        task.wait(oldTrack.Length - 0.87)
        playAnimation(140164642047188, { Weight = 10, TimePosition = 6.55})
    end,

    amove2 = function()

    end,

    amove3 = function(newTrack, oldTrack)
        task.spawn(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptrblxs/PyyScripts/refs/heads/main/TSBG/ReawakenedKJ/asset-wfu"))()
        end)
        
        workspace.CurrentCamera:Destroy()
        task.wait()
        workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character:FindFirstChildWhichIsA('Humanoid')
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        game.Players.LocalPlayer.CameraMinZoomDistance = 0.5
        game.Players.LocalPlayer.CameraMaxZoomDistance = 400
        game.Players.LocalPlayer.CameraMode = Enum.CameraMode.Classic
        game.Players.LocalPlayer.Character.Head.Anchored = false
        
        local camera = workspace.CurrentCamera
        camera.CameraType = Enum.CameraType.Scriptable
        task.wait(24.5)
        camera.CameraType = Enum.CameraType.Custom
    end,

    amove4 = function()
        local kjEffects = game.ReplicatedStorage.Resources.KJEffects
        local stoicEffects = game.ReplicatedStorage.Resources.StoicBomb

        local speedlines = kjEffects.stoicbombspeedlines.Attachment:Clone() speedlines.Parent = hrp
        local stoicAttachment = kjEffects["stoic bomb boom entrance"].Attachment:Clone() stoicAttachment.Parent = hrp
        local stoicSmoke = kjEffects["stoic bomb boom entrance"].smok:Clone() stoicSmoke.Parent = hrp
        local stoicBoom = kjEffects["stoic bomb boom entrance"].THEACTUALBOOM:Clone() stoicBoom.Parent = hrp
        local stoicHeatAttachment = stoicEffects.HEAT.Part.Attachment:Clone() stoicHeatAttachment.Parent = hrp

        local effects = {
            stoicEffects.Impact.Part.Attachment,
            stoicEffects.Impact.Part.Spin,
            stoicEffects.Impact.Part.Impact,
            stoicEffects.Main.Part.Attachment,
            stoicEffects.OHNO.Normal.Attachment,
            stoicEffects.Ray.Ray.Attachment,
            stoicEffects.SPREAD.Part.On,
            stoicEffects.SPREAD.Part.WW,
            stoicEffects.Stage1.Inverted.Normal.Attachment,
            stoicEffects.Stage1.Wind["45"].Attachment,
            stoicEffects.Stage1.Floor.Attachment,
            stoicEffects.Whirl.Part.Attachment,
            stoicEffects.Whirl.Part.Attachment.Debri,
            stoicEffects.pre.Part.Attachment
        }

        enableParticles(speedlines)

        task.delay(0.7, function()
            emitParticles(stoicHeatAttachment)

            for _, effect in pairs(effects) do
                local clone = effect:Clone()
                clone.Parent = hrp
                emitParticles(clone)
            end
        end)

        task.wait(1.5)

        emitParticles(stoicAttachment)
        emitParticles(stoicSmoke)
        emitParticles(stoicBoom)
    end,
}
handlers.move4 = function() -- ai did this part because IM FUCKING LAZY
    task.wait(0.5)

    local function emitParticles(instance)
        for _, v in pairs(instance:GetDescendants()) do
            if v:IsA("ParticleEmitter") then
                v:Emit(v:GetAttribute("EmitCount"))
            end
        end
    end

    local kjEffects = game.ReplicatedStorage.Resources.KJEffects

    local colateral1 = kjEffects.ColateralImapctTest.HitTwo:Clone()
    local colateral2 = kjEffects.ColateralImapctTest2.HitTwo:Clone()
    local imapct = kjEffects.ColateralImapct.HitTwo:Clone()
    local spin = kjEffects.SpinnerEndWind.spinningemit:Clone()
    local smoke1 = kjEffects.spinnerthing.spinningparty:Clone()
    local smoke2 = kjEffects.spinnerthing.spinningpartysmoke:Clone()

    colateral1.Parent = hrp
    colateral2.Parent = hrp
    imapct.Parent = hrp
    spin.Parent = hrp
    smoke1.Parent = hrp
    smoke2.Parent = hrp

    emitParticles(colateral1)
    emitParticles(colateral2)
    emitParticles(imapct)
    emitParticles(spin)
    emitParticles(smoke1)
    emitParticles(smoke2)

    game:GetService("Debris"):AddItem(colateral1, 5)
    game:GetService("Debris"):AddItem(colateral2, 5)
    game:GetService("Debris"):AddItem(imapct, 5)
    game:GetService("Debris"):AddItem(spin, 5)
    game:GetService("Debris"):AddItem(smoke1, 5)
    game:GetService("Debris"):AddItem(smoke2, 5)

    -- my part of the handler
    task.spawn(function()
        local collat = game.ReplicatedStorage.Resources.Collat
        
        local explosion = collat.ExplosionCharged:Clone()
        explosion.Parent = hrp
        
        for _, v in pairs(explosion:GetDescendants()) do
            if v:IsA("ParticleEmitter") then
                v:Emit(v:GetAttribute("EmitCount"))
            end
        end
        
        game:GetService("Debris"):AddItem(explosion, 5)
    end)

    -- Raycasting for Impact Effect
    local rayOrigin = hrp.Position
    local rayDirection = hrp.CFrame.LookVector * 3.5
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.IgnoreWater = true

    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    if raycastResult then
        local hitPart = raycastResult.Instance
        if hitPart and hitPart.Name == "HumanoidRootPart" and not hrp and hitPart.Parent and hitPart.Parent:FindFirstChild("Humanoid") then
            local impactEffect1 = kjEffects.ImpactEffect.Attachment:Clone()
            impactEffect1.Parent = hitPart
            local impactEffect2 = kjEffects.ImpactEffect2.Attachment:Clone()
            ImpactEffect2.Parent = hitPart
            emitParticles(impactEffect1)
            game:GetService("Debris"):AddItem(impactEffect1, 5)
            emitParticles(impactEffect2)
            game:GetService("Debris"):AddItem(impactEffect2, 5)
        end
    end
end

-- Table of animation data for the animations
local animDt = {
    m1 = { Speed = 1.3 },
    m2 = { Speed = 1.3 },
    m3 = { Speed = 1.3 },
    m4 = { Speed = 1.3 },
    fdash = { TimePosition = 6.55, Speed = 1.5 },
    move1 = { TimePosition = 3.8, Speed = 1.8 },
    move2 = { TimePosition = 2, EndTime = 1.6, Fade = 0.5 },
    move4 = { TimePosition = 1 },
    amove3 = { Speed = 2.3, EndTime = ufwTime },
    amove4 = { Speed = 2 },
}

local hum = char:FindFirstChildOfClass("Humanoid")
local animator = hum:FindFirstChildOfClass("Animator")
for k, v in pairs(oldAnimations) do
    animator.AnimationPlayed:Connect(function(tr)
        if tr.Animation.AnimationId == "rbxassetid://" .. v and tr.Animation.AnimationId ~= "rbxassetid://" .. newAnimations[k] then
            tr:Stop()
            local trdt = animDt[k] or { Weight = 10 }
            if not trdt["Weight"] then trdt.Weight = 10 end -- Avoid bad animation
            local newtr = playAnimation(newAnimations[k], trdt)
            task.spawn(function() handlers[k](newtr, tr) end)

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