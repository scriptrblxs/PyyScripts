local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local SelectedAnimations = {
    Run = "Survivor",
    Walk = "Survivor",
    Idle = "Survivor",
}

local AnimationOptions = {
    "Survivor",
    "Dussekar",
    "Noli",
    "John Doe",
    "Slasher",
    "1x1x1x1",
    "c00lkidd",
    "Stalker/Dog",
}

local AnimationIds = {
    Run = {
        Survivor = "rbxassetid://136252471123500",
        Dussekar = "rbxassetid://125869734469543",
        Noli = "rbxassetid://117451341682452",
        ["John Doe"] = "rbxassetid://132653655520682",
        Slasher = "rbxassetid://93054787145505",
        ["1x1x1x1"] = "rbxassetid://106485518413331",
        c00lkidd = "rbxassetid://96571077893813",
        ["Stalker/Dog"] = "rbxassetid://109671225388655",
    },
    Walk = {
        Survivor = "rbxassetid://108018357044094",
        Dussekar = "rbxassetid://102812745115149",
        Noli = "rbxassetid://109700476007435",
        ["John Doe"] = "rbxassetid://81193817424328",
        Slasher = "rbxassetid://93622022596108",
        ["1x1x1x1"] = "rbxassetid://109130982296927",
        c00lkidd = "rbxassetid://18885906143",
        ["Stalker/Dog"] = "rbxassetid://108287960442206",
    },
    Idle = {
        Survivor = "rbxassetid://131082534135875",
        Dussekar = "rbxassetid://107756518054855",
        Noli = "rbxassetid://83465205704188",
        ["John Doe"] = "rbxassetid://105880087711722",
        Slasher = "rbxassetid://116050994905421",
        ["1x1x1x1"] = "rbxassetid://138754221537146",
        c00lkidd = "rbxassetid://18885903667",
        ["Stalker/Dog"] = "rbxassetid://135419935358802",
    },
}

local Speeds = {
    
}

local Window = Rayfield:CreateWindow({
    Name = "67nsk",
    Icon = 0,
    LoadingTitle = "67nsk le sigmabroy",
    LoadingSubtitle = "by aerialasf",
    ShowText = "67",
    Theme = "Amethyst",
    ToggleUIKeybind = Enum.KeyCode.F5,
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "67nsk Mustard hub",
        FileName = "ch7_0",
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true,
    },
    KeySystem = true,
    KeySettings = {
        Title = "Hey you yes you i dont trust you",
        Subtitle = "ligma key",
        Note = "i dont fuckign know maybe join the discord server",
        FileName = "SIGMASIGMASakenkeyLIGMALIGMAohmy67",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = { "Forsake thee" },
    },
})

local havingFun = false

local AnimationsTab = Window:CreateTab("Animations", "a-large-small")
local AdvantagesTab = Window:CreateTab("Advantages", "a-arrow-up")

AnimationsTab:CreateToggle({
    Name = "Jerking",
    CurrentValue = false,
    Flag = "HavingFunAnimationToggle",
    Callback = function(v) havingFun = v end
})

local function CreateAnimationDropdown(animType)
    AnimationsTab:CreateDropdown({
        Name = "Target " .. animType .. " Animation",
        Options = AnimationOptions,
        CurrentOption = { SelectedAnimations[animType] },
        MultipleOptions = false,
        Flag = animType .. "AnimationFlag",
        Callback = function(Options)
            SelectedAnimations[animType] = Options[1]
        end,
    })
end
for _, animType in ipairs({ "Run", "Walk", "Idle" }) do
    CreateAnimationDropdown(animType)
end

local infstam = false
local speedhx = false
local speedamnt = 0.5
local speedanimmatch = true

local autogen = false
local autogenEsp = false
local autogendelay = 2.5

local esp = false
local espKillerClr = Color3.new(1, 0, 0)
local espSurvivorClr = Color3.new(0, 1, 0)
local espItemClr = Color3.new(1, 0.4, 0.6)
local highlightTransparency = 0.5

AdvantagesTab:CreateSection("Speed")
AdvantagesTab:CreateToggle({
    Name = "Infinite Stamina",
    CurrentValue = false,
    Flag = "InfStamToggle",
    Callback = function(v) infstam = v end
})
AdvantagesTab:CreateToggle({
    Name = "Speedhack",
    CurrentValue = false,
    Flag = "SpeedToggle",
    Callback = function(v) speedhx = v end
})
AdvantagesTab:CreateSlider({
    Name = "Speed Amount",
    Range = {0, 5},
    Increment = 0.5,
    Suffix = "times 10 studs/second",
    CurrentValue = 0.5,
    Flag = "SpeedHaxAmount",
    Callback = function(num) speedamnt = num end
})
AdvantagesTab:CreateToggle({
    Name = "Match Speed with Animation",
    CurrentValue = true,
    Flag = "MatchAnimationToggle",
    Callback = function(v) speedanimmatch = v end
})

AdvantagesTab:CreateSection("Generators")
AdvantagesTab:CreateToggle({
    Name = "Auto Generator",
    CurrentValue = false,
    Flag = "AutomaticGeneratorFix",
    Callback = function(v) autogen = v end
})
AdvantagesTab:CreateToggle({
    Name = "Generators ESP",
    CurrentValue = false,
    Flag = "GeneratorESP",
    Callback = function(v) autogenEsp = v end
})
AdvantagesTab:CreateSlider({
    Name = "Auto Generator Interval",
    Range = {1.75, 60},
    Increment = 0.05,
    Suffix = "interval",
    CurrentValue = 2.5,
    Flag = "AutomaticGeneratorInterval",
    Callback = function(v) autogendelay = v end
})

AdvantagesTab:CreateSection("ESP")
AdvantagesTab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(v) esp = v end
})
AdvantagesTab:CreateColorPicker({
    Name = "Killer ESP Color",
    Color = Color3.new(1, 0, 0),
    Flag = "KillerColor",
    Callback = function(clr) espKillerClr = clr end
})
AdvantagesTab:CreateColorPicker({
    Name = "Survivor ESP Color",
    Color = Color3.new(0, 1, 0),
    Flag = "SurvivorColor",
    Callback = function(clr) espSurvivorClr = clr end
})
AdvantagesTab:CreateColorPicker({
    Name = "Item ESP Color",
    Color = Color3.new(1, 0.4, 0.6),
    Flag = "ItemColor",
    Callback = function(clr) espItemClr = clr end
})
AdvantagesTab:CreateSlider({
    Name = "Highlight Transparency",
    Range = {0, 1},
    Increment = 0.1,
    Suffix = "transparency",
    CurrentValue = 0.5,
    Flag = "ESPTransparency",
    Callback = function(num) highlightTransparency = num end
})

local lplr = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

-- beating
local funAnm = Instance.new("Animation")
funAnm.AnimationId = "rbxassetid://72042024"

local funTrack
local chrDoingTomfoolery
local loopCoroutine

local function startFunLoop()
    if loopCoroutine and coroutine.status(loopCoroutine) ~= "dead" then
        return
    end

    loopCoroutine = coroutine.create(function()
        while havingFun and funTrack do
            funTrack:Play()
            funTrack:AdjustSpeed(0.65)
            funTrack.TimePosition = 0.6
            task.wait(0.1)
            while funTrack and funTrack.IsPlaying and funTrack.TimePosition < 0.65 do
                task.wait(0.1)
            end
            if funTrack and funTrack.IsPlaying then
                funTrack:Stop()
            end
            task.wait(0.1)
        end
    end)
    coroutine.resume(loopCoroutine)
end

local function stopFunLoop()
    if funTrack and funTrack.IsPlaying then
        funTrack:Stop()
    end
    loopCoroutine = nil
end

RunService.PreRender:Connect(function()
    if not chrDoingTomfoolery or not chrDoingTomfoolery.Parent or chrDoingTomfoolery ~= lplr.Character then
        chrDoingTomfoolery = lplr.Character or lplr.CharacterAdded:Wait()
        
        local hum = chrDoingTomfoolery:FindFirstChildWhichIsA("Humanoid")
        if hum then
            local animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)
            funTrack = animator:LoadAnimation(funAnm)
        end
    end
    
    if not funTrack then return end
    
    if havingFun then
        startFunLoop()
    else
        stopFunLoop()
    end
end)

-- custom anism
local function playAnimation(hum, id, weight, speed)
    game:GetService("RunService").PreAnimation:Wait()
    for _, track in pairs(hum:GetPlayingAnimationTracks()) do
        if track.Animation.AnimationId == id then
            track:AdjustSpeed(speed or 1)
            return track
        else
            track:Stop(0.35)
        end
    end
    local anim = Instance.new("Animation")
    anim.AnimationId = id
    local track = hum:LoadAnimation(anim)
    track:AdjustWeight(weight or 10)
    track:Play(0.35)
    if speed then track:AdjustSpeed(speed) end
    return track
end

local function setupCharacter(chr)
    local hum = chr:WaitForChild("Humanoid")
    hum.Running:Connect(function(spd)
        local additiveSpd = not speedhx and 0 or speedamnt * 10
        local sprinting = chr:FindFirstChild("SpeedMultipliers")
            and chr.SpeedMultipliers:FindFirstChild("Sprinting")
            and chr.SpeedMultipliers.Sprinting.Value >= 1.3125
        if spd > 0.01 then
            if sprinting then
                playAnimation(hum, AnimationIds.Run[SelectedAnimations.Run] or AnimationIds.Run.Survivor, 10, (spd + additiveSpd) / 26)
            else
                playAnimation(hum, AnimationIds.Walk[SelectedAnimations.Walk] or AnimationIds.Walk.Survivor, 10, (spd + additiveSpd) / 12)
            end
        else
            playAnimation(hum, AnimationIds.Idle[SelectedAnimations.Idle] or AnimationIds.Idle.Survivor, 9, 1)
        end
    end)
end

if lplr.Character then setupCharacter(lplr.Character) end
lplr.CharacterAdded:Connect(setupCharacter)

-- speed hx
game:GetService("RunService").PreSimulation:Connect(function()
    local sprint = require(game.ReplicatedStorage.Systems.Character.Game.Sprinting)
    sprint.SprintSpeed = 28
    if infstam then
        sprint.StaminaLoss = 0
        sprint.StaminaLossDisabled = true
    else
        sprint.StaminaLoss = 10
        sprint.StaminaLossDisabled = false
    end
end)

game:GetService("RunService").PreSimulation:Connect(function(dt)
    if not speedhx then return end
    local chr = lplr.Character
    if chr then
        local hum = chr:FindFirstChildWhichIsA("Humanoid")
        if not hum or hum.MoveDirection.Magnitude == 0 then return end
        local add = hum.MoveDirection * (speedamnt * dt * 10)
        
        chr:TranslateBy(add)
    end
end)

-- autogen + esp
task.spawn(function()
    while true do
        if not autogen then task.wait() continue end
        local map = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame") and workspace.Map.Ingame:FindFirstChild("Map")
        if map then
            for _, gen in pairs(map:GetChildren()) do
                if gen:IsA("Model") and gen.Name == "Generator" then
                    local re = gen:FindFirstChild("Remotes") and gen.Remotes:FindFirstChild("RE")
                    if re then
                        re:FireServer()
                    end
                end
            end
        end
        task.wait(autogendelay or 2.5)
    end
end)
task.spawn(function()
    while true do
        local map = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame") and workspace.Map.Ingame:FindFirstChild("Map")
        if map then
            for _, gen in pairs(map:GetChildren()) do
                if gen:IsA("Model") and gen.Name == "Generator" then
                    local h = gen:FindFirstChild("GeneratorHighlight") or Instance.new("Highlight")
                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    h.FillTransparency = 1
                    h.OutlineColor = Color3.new(1, 0, 0):Lerp(Color3.new(0, 1, 0), gen.Progress.Value / 100)
                    h.Name = "GeneratorHighlight"
                    h.Parent = gen
                    if not autogenEsp then
                        h:Destroy()
                    end
                end
            end
        end
        task.wait()
    end
end)

-- esp
local Camera = workspace.CurrentCamera
local PlayersFolder = workspace:FindFirstChild("Players")
local KillersFolder = PlayersFolder and PlayersFolder:FindFirstChild("Killers")
local SurvivorsFolder = PlayersFolder and PlayersFolder:FindFirstChild("Survivors")

local objectLines = {}
local objectHighlights = {}

local function getLine(obj, color, zindex)
    if obj == lplr.Character then return end
    local line = objectLines[obj]
    if not line then
        line = Drawing.new("Line")
        line.Thickness = 1
        line.Color = color
        line.ZIndex = zindex
        line.Visible = false
        objectLines[obj] = line
    end
    return line
end

local function getHighlight(char)
    if char == lplr.Character then return end
    local existing = char:FindFirstChild("67nskESP")
    if existing and existing:IsA("Highlight") then
        objectHighlights[char] = existing
        existing.FillTransparency = 1
        existing.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        return existing
    end
    local hl = Instance.new("Highlight")
    hl.Name = "67nskESP"
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.FillTransparency = 1
    hl.Parent = char
    objectHighlights[char] = hl
    return hl
end

local function cleanup()
    for obj, line in pairs(objectLines) do
        if not obj.Parent then
            pcall(function()
                line.Visible = false
                line:Remove()
            end)
            objectLines[obj] = nil
        end
    end
    for char, hl in pairs(objectHighlights) do
        if not char.Parent then
            pcall(function() hl:Destroy() end)
            objectHighlights[char] = nil
        end
    end
end

game.Players.PlayerRemoving:Connect(function(player)
    if objectLines[player] then
        pcall(function() objectLines[player]:Remove() end)
        objectLines[player] = nil
    end
    if objectHighlights[player] then
        pcall(function() objectHighlights[player]:Destroy() end)
        objectHighlights[player] = nil
    end
end)

RunService.RenderStepped:Connect(function()
    local ItemsFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame") and workspace.Map.Ingame:FindFirstChild("Map")
    if not esp then
        for _, line in pairs(objectLines) do line.Visible = false end
        for _, hl in pairs(objectHighlights) do
            if hl.Parent then hl.Enabled = false end
        end
        return
    end

    local origin = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
    if SurvivorsFolder then
        for _, char in pairs(SurvivorsFolder:GetChildren()) do
            if char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                local line = getLine(char, espSurvivorClr, 1)
                if not line then continue end
                line.From = origin
                line.To = Vector2.new(pos.X, pos.Y)
                line.Color = espSurvivorClr
                line.ZIndex = 1
                line.Visible = pos.Z > 0

                local hl = getHighlight(char)
                hl.OutlineColor = espSurvivorClr
                hl.OutlineTransparency = highlightTransparency
                hl.Enabled = onScreen and pos.Z > 0
            end
        end
    end
    
    if KillersFolder then
        for _, char in pairs(KillersFolder:GetChildren()) do
            if char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                local line = getLine(char, espKillerClr, 2)
                if not line then continue end
                line.From = origin
                line.To = Vector2.new(pos.X, pos.Y)
                line.Color = espKillerClr
                line.ZIndex = 2
                line.Visible = pos.Z > 0

                local hl = getHighlight(char)
                hl.OutlineColor = espKillerClr
                hl.OutlineTransparency = highlightTransparency
                hl.Enabled = onScreen and pos.Z > 0
            end
        end
    end

    if ItemsFolder then
        for _, item in pairs(ItemsFolder:GetChildren()) do
            if item:IsA("Tool") and item:FindFirstChild("ItemRoot") then
                local handle = item.ItemRoot
                local pos, onScreen = Camera:WorldToViewportPoint(handle.Position)
                local line = getLine(item, espItemClr, 0)
                if not line then continue end
                line.From = origin
                line.To = Vector2.new(pos.X, pos.Y)
                line.Color = espItemClr
                line.ZIndex = 0
                line.Visible = pos.Z > 0
            end
        end
    end

    cleanup()
end)