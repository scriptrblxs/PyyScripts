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
    },
    Walk = {
        Survivor = "rbxassetid://108018357044094",
        Dussekar = "rbxassetid://102812745115149",
        Noli = "rbxassetid://109700476007435",
        ["John Doe"] = "rbxassetid://81193817424328",
        Slasher = "rbxassetid://93622022596108",
        ["1x1x1x1"] = "rbxassetid://109130982296927",
        c00lkidd = "rbxassetid://18885906143",
    },
    Idle = {
        Survivor = "rbxassetid://131082534135875",
        Dussekar = "rbxassetid://107756518054855",
        Noli = "rbxassetid://83465205704188",
        ["John Doe"] = "rbxassetid://105880087711722",
        Slasher = "rbxassetid://116050994905421",
        ["1x1x1x1"] = "rbxassetid://138754221537146",
        c00lkidd = "rbxassetid://18885903667",
    },
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

local AnimationsTab = Window:CreateTab("Animations", "a-large-small")
local AdvantagesTab = Window:CreateTab("Advantages", "a-arrow-up")

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

local esp = false
local espKillerClr = Color3.new(1, 0, 0)
local espSurvivorClr = Color3.new(0, 1, 0)
local highlightTransparency = 0.5

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
        local sprinting = chr:FindFirstChild("SpeedMultipliers")
            and chr.SpeedMultipliers:FindFirstChild("Sprinting")
            and chr.SpeedMultipliers.Sprinting.Value >= 1.3125
        if spd > 0.01 then
            if sprinting then
                playAnimation(hum, AnimationIds.Run[SelectedAnimations.Run] or AnimationIds.Run.Survivor, 10, spd / 26)
            else
                playAnimation(hum, AnimationIds.Walk[SelectedAnimations.Walk] or AnimationIds.Walk.Survivor, 10, spd / 12)
            end
        else
            playAnimation(hum, AnimationIds.Idle[SelectedAnimations.Idle] or AnimationIds.Idle.Survivor, 9, 1)
        end
    end)
end

if lplr.Character then setupCharacter(lplr.Character) end
lplr.CharacterAdded:Connect(setupCharacter)

local Camera = workspace.CurrentCamera
local espLines = {}
local espHighlights = {}

local PlayersFolder = workspace:FindFirstChild("Players")
local KillersFolder = PlayersFolder and PlayersFolder:FindFirstChild("Killers")
local SurvivorsFolder = PlayersFolder and PlayersFolder:FindFirstChild("Survivors")

local function makeLineForPlayer(player)
    local line = Drawing.new("Line")
    line.Visible = false
    line.Thickness = 1.5
    line.Transparency = 1 -- always visible
    espLines[player] = line
    return line
end

local function makeHighlightForChar(char, player)
    local existing = char:FindFirstChild("67nskESP")
    if existing and existing:IsA("Highlight") then
        espHighlights[player] = existing
        existing.FillTransparency = 1
        existing.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        return existing
    end
    local hl = Instance.new("Highlight")
    hl.Name = "67nskESP"
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.FillTransparency = 1
    hl.Parent = char
    espHighlights[player] = hl
    return hl
end

local function removeEspForPlayer(player)
    if espLines[player] then
        pcall(function() espLines[player]:Remove() end)
        espLines[player] = nil
    end
    if espHighlights[player] then
        pcall(function() espHighlights[player]:Destroy() end)
        espHighlights[player] = nil
    end
end

game.Players.PlayerRemoving:Connect(removeEspForPlayer)

RunService.RenderStepped:Connect(function()
    PlayersFolder = workspace:FindFirstChild("Players")
    KillersFolder = PlayersFolder and PlayersFolder:FindFirstChild("Killers")
    SurvivorsFolder = PlayersFolder and PlayersFolder:FindFirstChild("Survivors")
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player == lplr then
            if espLines[player] then espLines[player].Visible = false end
            if espHighlights[player] and espHighlights[player].Parent then espHighlights[player].Enabled = false end
            continue
        end
        local char = player.Character
        if esp and char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if not espLines[player] then makeLineForPlayer(player) end
            if not espHighlights[player] then makeHighlightForChar(char, player) end
            local line = espLines[player]
            local hl = espHighlights[player]
            local isKiller = false
            if KillersFolder and KillersFolder:FindFirstChild(char.Name) then
                isKiller = true
            elseif SurvivorsFolder and SurvivorsFolder:FindFirstChild(char.Name) then
                isKiller = false
            elseif player.Team then
                isKiller = (player.Team.Name == "Killers")
            end
            local color = isKiller and espKillerClr or espSurvivorClr
            if onScreen then
                line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                line.To = Vector2.new(pos.X, pos.Y)
                line.Color = color
                line.Transparency = 1
                line.Visible = true
                if hl and hl.Parent then
                    hl.OutlineColor = color
                    hl.OutlineTransparency = highlightTransparency
                    hl.Enabled = true
                end
            else
                if line then line.Visible = false end
                if hl and hl.Parent then hl.Enabled = false end
            end
        else
            if espLines[player] then espLines[player].Visible = false end
            if espHighlights[player] and espHighlights[player].Parent then espHighlights[player].Enabled = false end
        end
    end
end)