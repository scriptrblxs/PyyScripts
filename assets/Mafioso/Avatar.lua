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

game:GetObjects("rbxassetid://943292579")[1].Parent = char
game:GetObjects("rbassetid://943292013")[1].Parent = char

local clrs = char["Body Colors"]
clrs.HeadColor = BrickColor.new("Fire Yellow")
clrs.TorsoColor = BrickColor.new("Black metallic")
clrs.LeftArmColor = BrickColor.new("Black metallic")
clrs.RightArmColor = BrickColor.new("Black metallic")
clrs.LeftLegColor = BrickColor.new("Black metallic")
clrs.RightLegColor = BrickColor.new("Black metallic")



task.spawn(function()
local char = game.Players.LocalPlayer.Character
local acc = Instance.new("Part", workspace)
local msh = Instance.new("SpecialMesh", acc)

acc.Size = Vector3.one
acc.CanCollide = false
msh.MeshId = "rbxassetid://14017298270"
msh.TextureId = "rbxassetid://12785483723"

while task.wait() do
acc.CFrame = char.Torso.CFrame * CFrame.new(0, -1, 1.45) * CFrame.Angles(0, math.rad(180), 0)
end
end)

task.spawn(function()
local char = game.Players.LocalPlayer.Character
local acc = Instance.new("Part", workspace)
local msh = Instance.new("SpecialMesh", acc)

acc.Size = Vector3.one
acc.CanCollide = false
msh.MeshId = "rbxassetid://100820733582046"
msh.TextureId = "rbxassetid://117078964932861"

while task.wait() do
acc.CFrame = char.Head.CFrame * CFrame.new(0, 0.75, 0)
end
end)