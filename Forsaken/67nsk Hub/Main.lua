local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local SelectedAnimations = {
    Run = "Survivor",
    Walk = "Survivor",
    Idle = "Survivor"
}

local AnimationOptions = {"Survivor", "Noli", "John Doe", "Slasher", "1x1x1x1"}

local AnimationIds = {
    Run = {
        Survivor = "rbxassetid://136252471123500",
        Noli = "rbxassetid://117451341682452",
        ["John Doe"] = "rbxassetid://132653655520682",
        Slasher = "rbxassetid://93054787145505",
        ["1x1x1x1"] = "rbxassetid://106485518413331",
    },
    Walk = {
        Survivor = "rbxassetid://108018357044094",
        Noli = "rbxassetid://109700476007435",
        ["John Doe"] = "rbxassetid://81193817424328",
        Slasher = "rbxassetid://93622022596108",
        ["1x1x1x1"] = "rbxassetid://109130982296927",
    },
    Idle = {
        Survivor = "rbxassetid://131082534135875",
        Noli = "rbxassetid://83465205704188",
        ["John Doe"] = "rbxassetid://105880087711722",
        Slasher = "rbxassetid://116050994905421",
        ["1x1x1x1"] = "rbxassetid://138754221537146",
    }
}

local Window = Rayfield:CreateWindow({
    Name = "67nsk",
    Icon = 0,
    LoadingTitle = "67nsk le sigmabroy",
    LoadingSubtitle = "by aerialasf",
    ShowText = "67",
    Theme = "Amethyst",
    ToggleUIKeybind = Enum.KeyCode.F5,
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "IMTHEsigmaestSAKENER",
        FileName = "ch7_0"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = true,
    KeySettings = {
        Title = "Hey you yes you i dont trust you",
        Subtitle = "ligma key",
        Note = "i dont fuckign know maybe join the discord server",
        FileName = "SIGMASIGMASakenkeyLIGMALIGMAohmy67",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"Forsake thee"}
    }
})

local AnimationsTab = Window:CreateTab("Animations", "a-large-small")

AnimationsTab:CreateButton({
    Name = "SIGMA BUTTON PLS CLICK",
    Callback = function()
        print("thanks")
    end
})

local function CreateAnimationDropdown(animType)
    AnimationsTab:CreateDropdown({
        Name = "Target " .. animType .. " Animation",
        Options = AnimationOptions,
        CurrentOption = {SelectedAnimations[animType]},
        MultipleOptions = false,
        Flag = animType .. "AnimationFlag",
        Callback = function(Options)
            SelectedAnimations[animType] = Options[1]
        end
    })
end

for _, animType in ipairs({"Run", "Walk", "Idle"}) do
    CreateAnimationDropdown(animType)
end

local lplr = game.Players.LocalPlayer

local function playAnimation(hum, id, weight, speed)
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