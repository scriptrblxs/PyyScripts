local lplr = game.Players.LocalPlayer
local char = lplr.Character or lplr.CharacterAdded:Wait()

for _, v in pairs(char:GetDescendants()) do
    if v:IsA("Clothing") or v:IsA("Accessory") then
        v:Destroy()
    end
    if v:IsA("CharacterMesh") then
        v:Destroy()
    end
end

local shirt = Instance.new("Shirt", char)
shirt.ShirtTemplate = "https://www.roblox.com/asset/?id=943292579"
local pants = Instance.new("Pants", char)
pants.PantsTemplate = "https://www.roblox.com/asset/?id=943292013"

local clrs = char["Body Colors"]
clrs.HeadColor = BrickColor.new("Fire Yellow")
clrs.TorsoColor = BrickColor.new("Black metallic")
clrs.LeftArmColor = BrickColor.new("Black metallic")
clrs.RightArmColor = BrickColor.new("Black metallic")
clrs.LeftLegColor = BrickColor.new("Black metallic")
clrs.RightLegColor = BrickColor.new("Black metallic")



local hat = game:GetObjects("rbxassetid://86325274703687")[1]
local cape = game:GetObjects("rbxassetid://14021461958")[1]

if hat then
    local handle = hat:FindFirstChild("Handle")
    handle.CFrame = char.Head.CFrame
    handle.CanCollide = false
    char.Humanoid:AddAccessory(hat)
end
if cape then
    local handle = cape:FindFirstChild("Handle")
    handle.CFrame = char.Torso.CFrame
    handle.CanCollide = false
    char.Humanoid:AddAccessory(cape)
end