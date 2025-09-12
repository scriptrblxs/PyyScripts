local Raypeeled = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "idk why did i make this",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "pls use 67nsk hub forsaken",
   LoadingSubtitle = "by aerialasf",
   ShowText = "Emotes", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Amethyst", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = Enum.KeyCode.F5, -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = false,
      FolderName = "IMTHEsigmaestSAKENER", -- Create a custom folder for your hub/game
      FileName = "ch7_0"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Hey you yes you i dont trust you",
      Subtitle = "ligma key",
      Note = "i dont fuckign know maybe join the discord server", -- Use this to tell the user how to get a key
      FileName = "SIGMASIGMASakenkeyLIGMALIGMAohmy67", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"emote thee"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local function playId(id)
   local chr = game.Players.LocalPlayer.Character
   local hum = chr.Humanoid
   for _, v in pairs(hum:GetPlayingAnimationTracks()) do
      v:Stop()
   end
   
   local anim = Instance.new("Animation")
   anim.AnimationId = id
   local tr = hum:LoadAnimation(anim)
   tr:AdjustWeight(100)
   tr.Looped = false
   tr:Play()
end

local general = Window:CreateTab("General", "house")
local foreskin = Window:CreateTab("Forsaken", "swords")

-- general tab
general:CreateButton({
   Name = "Obby Head",
   Callback = function()
      playId("rbxassetid://125176243437210")
   end
})

-- freaksakem tab
general:CreateButton({
   Name = "Elliot Pizza Throw",
   Callback = function()
      playId(game:GetObjects("rbxassetid://97958818779904")[1].AnimationId)
   end
})
general:CreateButton({
   Name = "Chance Coin Flip",
   Callback = function()
      playId("rbxassetid://125469112376756")
   end
})

-- game:GetObjects("rbxassetid://97958818779904")[1].AnimationId
-- rbxassetid://125469112376756
-- rbxassetid://125176243437210