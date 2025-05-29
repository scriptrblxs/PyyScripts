-- LICENSE.md
local isTesting = true
print(not isTesting and game:HttpGet("https://raw.githubusercontent.com/scriptrblxs/PyyScripts/refs/heads/main/LICENSE.md"))

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
ulttext.Text = "?"
ultbarclr.BackgroundColor3 = Color3.fromRGB(31, 31, 31) -- In RGB values (red, green, blue)

local hotbar:ScreenGui = plrgui:FindFirstChild("Hotbar")
local backpack = hotbar:FindFirstChild("Backpack")
local hotbarf:Frame = backpack:FindFirstChild("Hotbar")
local bbb1, bbb2, bbb3, bbb4 = hotbarf["1"], hotbarf["2"], hotbarf["3"], hotbarf["4"]
local bb1, bb2, bb3, bb4 = bbb1["Base"], bbb2["Base"], bbb3["Base"], bbb4["Base"]
local b1, b2, b3, b4 = bb1["ToolName"], bb2["ToolName"], bb3["ToolName"], bb4["ToolName"]

-- Move names
local function SetMoveNames()
    b1.Text = "You're Mine"
    b2.Text = "Teeth Knocking"
    b3.Text = "Walkspeed Override"
    b4.Text = "Uppercut"
end
SetMoveNames()

-- Awakening move names
local function SetAwkNames()
    if false then
        b1.Text = "20 Series"
        b2.Text = "Palm of Infinity"
        b3.Text = "Infinite Modulations"
        b4.Text = "Calm Ordnance"
    end
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
    m2 = "17325510002", -- Replace with your new m2 animation ID
    m3 = "17325510002", -- Replace with your new m3 animation ID
    m4 = "17325510002", -- Replace with your new m4 animation ID
    ds = "10470104242", -- Replace with your new downslam animation ID
    up = "14900168720", -- Replace with your new mini uppercut animation ID
    wc = "16023456135", -- Replace with your new wall combo animation ID
    fdash = "182393478", -- Replace with your new front dash animation ID
    bdash = "696969", -- Replace with your new back dash animation ID
    ldash = "10480796021", -- Replace with your new left dash animation ID
    rdash = "10480793962", -- Replace with your new right dash animation ID
    awk = "12447707844", -- Replace with your new awakening animation ID
    move1 = "182393478", -- Replace with your new move 1 animation ID
    move2 = "16945550029", -- Replace with your new move 2 animation ID
    move3 = "16944265635", -- Replace with your new move 3 animation ID
    move4 = "14900168720", -- Replace with your new move 4 animation ID
    amove1 = "11343318134", -- Replace with your new move awakening 1 animation ID
    amove2 = "11365563255", -- Replace with your new move awakening 2 animation ID
    amove3 = "12983333733", -- Replace with your new move awakening 3 animation ID
    amove4 = "13927612951", -- Replace with your new move awakening 4 animation ID
}

-- Code/functions to use in the handlers

-- some variables

local function playvl(vl)
    task.spawn(function()
    local file = vl .. ".mp3"
    local url = "https://raw.githubusercontent.com/scriptrblxs/PyyScripts/main/assets/Mafioso/" .. file
    
    local data = game:HttpGet(url)
    
    writefile(file, data)
    
    local s = Instance.new("Sound", char.Head)
    s.SoundId = getcustomasset(file)
    s.Volume = 3
    s.Looped = false
    s:Play()
    
    s.Ended:Wait()
    
    s:Stop()
    s:Destroy()
    end)
end

local function m1finisher()
    local nearestCharacter = nil
    local maxDistance = 100
    
    for _, v in pairs(workspace.Live:GetChildren()) do
        local humanoid = v:FindFirstChildOfClass("Humanoid")
        local opponentHrp = v:FindFirstChild("HumanoidRootPart")
        if humanoid and opponentHrp and v ~= char then
            local distance = (opponentHrp.Position - hrp.Position).Magnitude
            if distance < maxDistance then
                maxDistance = distance
                nearestCharacter = v
            end
        end
    end
    
    if nearestCharacter then
        local nearestHumanoid = nearestCharacter:FindFirstChildOfClass("Humanoid")
        if nearestHumanoid and nearestHumanoid.Health <= 4 then
            game:GetService("Chat"):Chat(char, "Maybe it's time to ragequit, eh?")
            playvl("TimeToRagequit")
        end
    end
end

local humanoid = char:FindFirstChildOfClass("Humanoid")
local function playAnimation(id, details)
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

task.spawn(function()
while task.wait(25) do
    if math.random(1, 10) == 1 then
        game:GetService("Chat"):Chat(char, "I feel no pain, can you say the same?")
        playvl("NoPain")
    end
end
end)

local bgm = "BackgroundMusic.mp3"
local url = "https://raw.githubusercontent.com/scriptrblxs/PyyScripts/main/assets/Mafioso/BackgroundMusic.mp3"
local data = game:HttpGet(url)
writefile(bgm, data)
local s = Instance.new("Sound", char.Head)
s.SoundId = getcustomasset(bgm)
s.Volume = 1.5
s.Looped = true
s:Play()

loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptrblxs/PyyScripts/main/assets/Mafioso/Avatar.lua"))()

game:GetService("Chat"):Chat(char, "I see one of them.")
playvl("SawOne")

-- slow thing
local slowgui = Instance.new("ScreenGui", plrgui)
slowgui.ScreenInsets = Enum.ScreenInsets.None
local slowf = Instance.new("ViewportFrame", slowgui)
slowf.BackgroundTransparency = 1
slowf.AnchorPoint = Vector2.new(0.5, 0.5)
slowf.Position = UDim2.fromScale(0.5, 0.5)
slowf.Size = UDim2.fromScale(1, 1)
task.spawn(function()
    while true do
        slowf:ClearAllChildren()
        local camm = Instance.new("Camera", slowf)
        camm.CFrame = workspace.CurrentCamera
        slowf.CurrentCamera = camm

        local charac = char:Clone()
        charac.Parent = slowf

        local cape = workspace:FindFirstChild("MafiosoCape")
        local hat = workspace:FindFirstChild("MafiosoFedora")
        if cape then cape:Clone().Parent = slowf end
        if hat then hat:Clone().Parent = slowf end

        task.wait(1 / 15)
    end
end)

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
    up = function() m1finisher() end,
    ds = function() m1finisher() end,
    fdash = function() end,
    bdash = function() end,
    ldash = function() end,
    rdash = function() end,

    awk = function(tr)
        game:GetService("Chat"):Chat(char, "I see one of them.")
        playvl("SawOne")
    end,

    move1 = function()
        game:GetService("Chat"):Chat(char, "You're mine!")
        playvl("YoureMine")
    end,

    move2 = function()
        game:GetService("Chat"):Chat(char, "I love knocking out teeth.")
        playvl("TeethKnocker")
    end,

    move3 = function()
        game:GetService("Chat"):Chat(char, "You're mine!")
        playvl("YoureMine")
    end,

    move4 = function()
        
    end,

    amove1 = function(oldTrack)
        
    end,

    amove2 = function()

    end,

    amove3 = function(newTrack, oldTrack)
        
    end,

    amove4 = function()
        
    end,
}

-- Table of animation data for the animations
local animDt = {
    m1 = { Speed = 1.5 },
    m2 = { Speed = 1.5 },
    m3 = { Speed = 1.5 },
    m4 = { Speed = 1.5 },
    up = { Speed = 1.2, TimePosition = 1.5 },
    fdash = { Looped = true, EndTime = 1 },
    move1 = { Looped = true, EndTime = 1 },
    move2 = { TimePosition = 2, EndTime = 1.6, Fade = 0.5 },
    move4 = { TimePosition = 1.4 },
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