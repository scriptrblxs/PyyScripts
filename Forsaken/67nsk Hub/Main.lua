local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local SelectedRunAnimation = "Survivor"
local SelectedWalkAnimation = "Survivor"
local SelectedIdleAnimation = "Survivor"

local Window = Rayfield:CreateWindow({
   Name = "67nsk",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "67nsk le sigmabroy",
   LoadingSubtitle = "by aerialasf",
   ShowText = "67", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Amethyst", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = Enum.KeyCode.F5, -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "IMTHEsigmaestSAKENER", -- Create a custom folder for your hub/game
      FileName = "ch7_0"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "Hey you yes you i dont trust you",
      Subtitle = "ligma key",
      Note = "i dont fuckign know maybe join the discord server", -- Use this to tell the user how to get a key
      FileName = "SIGMASIGMASakenkeyLIGMALIGMAohmy67", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Forsake thee"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local Animations = Window:CreateTab("Animations", "a-large-small")

local testbtn = Animations:CreateButton({
    Name = "SIGMA BUTTON PLS CLICK",
    Callback = function()
        print("thanks")
    end
})

local RunDropdown = Animations:CreateDropdown({
   Name = "Target Run Animation",
   Options = {
       "Survivor",
       "This",
       "Dropdown",
       "Does",
       "Nothing",
       "Yet",
   },
   CurrentOption = {"Survivor"},
   MultipleOptions = false,
   Flag = "SurvivorRunAnimationId", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Options)
       local optn = Options[1]
       SelectedRunAnimation = optn
   end,
})

local WalkDropdown = Animations:CreateDropdown({
   Name = "Target Walk Animation",
   Options = {
       "Survivor",
       "This",
       "Dropdown",
       "Does",
       "Nothing",
       "Yet",
   },
   CurrentOption = {"Survivor"},
   MultipleOptions = false,
   Flag = "SurvivorWalkAnimationId", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Options)
       local optn = Options[1]
       SelectedWalkAnimation = optn
   end,
})

local IdleDropdown = Animations:CreateDropdown({
   Name = "Target Idle Animation",
   Options = {
       "Survivor",
       "This",
       "Dropdown",
       "Does",
       "Nothing",
       "Yet",
   },
   CurrentOption = {"Survivor"},
   MultipleOptions = false,
   Flag = "SurvivorIdleAnimationId", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Options)
       local optn = Options[1]
       SelectedIdleAnimation = optn
   end,
})

local i = 0
while true do
    i += 1
    print(tick() .. " " .. i)
    print(SelectedRunAnimation)
    print(SelectedWalkAnimation)
    print(SelectedIdleAnimation)
    task.wait(1)
end