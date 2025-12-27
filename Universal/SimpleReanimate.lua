-- SimpleReanimate.lua
-- As it name says, it is a very, very simple
-- Reanimate script for Roblox R6 rigs.

local lplr = game.Players.LocalPlayer
local chat = game:GetService("TextChatService").TextChannels.RBXGeneral

local rs = game:GetService("RunService")

local lib = {}
lib.__index = lib

function lib:new(self)
    warn("SimpleReanimate: ⚠️ Character must have permadeath or does not respawn.")
    assert(lplr.Character, "SimpleReanimate: The player's Character has not been loaded yet.")
    local chr = lplr.Character
    lib.__chr = chr
    
    lib.Character = {}
    
    local hum = lplr.Character:WaitForChild("Humanoid")
    assert(hum.RigType == Enum.HumanoidRigType.R6, "SimpleReanimate: SR.lua only works on R6 rigs!")
    
    local torso = chr:WaitForChild("Torso")
    local hrp = chr:WaitForChild("HumanoidRootPart")
    
    for _, motor in ipairs(torso:GetChildren()) do
        if motor:IsA("Motor") then
            if motor.Name ~= "Neck" then
                motor:Destroy()
            else
                motor.Enabled = false
            end
        end
    end
    hrp.RootJoint.Enabled = false

    hum:ChangeState(Enum.HumanoidStateType.Running)
    
    for _, p in ipairs(chr:GetChildren()) do
        if p:IsA("BasePart") and p ~= hrp then
            local att = Instance.new("Attachment", p)
            att.Name = "SRAttachment"
            
            local ap = Instance.new("AlignPosition", p)
            ap.Mode = Enum.PositionAlignmentMode.OneAttachment
            ap.Attachment0 = att
            ap.MaxForce = math.huge
            ap.RigidityEnabled = true
            ap.Responsiveness = 5000
            
            local ao = Instance.new("AlignOrientation", p)
            ao.Mode = Enum.OrientationAlignmentMode.OneAttachment
            ao.Attachment0 = att
            ao.MaxTorque = math.huge
            ao.MaxAngularVelocity = math.huge
            ao.RigidityEnabled = true
            ao.Responsiveness = 5000
            
            lib.Character[p.Name] = {CFrame = hrp.CFrame:ToObjectSpace(p.CFrame)}
            
            rs.PreSimulation:Connect(function()
                local worldSpace = hrp.CFrame:ToWorldSpace(lib.Character[p.Name].CFrame)
                ap.Position = worldSpace.Position
                ao.CFrame = worldSpace
            end)
            
            rs.PreRender:Connect(function()
                local worldSpace = hrp.CFrame:ToWorldSpace(lib.Character[p.Name].CFrame)
                p.CFrame = worldSpace
            end)
        end
    end
end



function lib:GetCharacter(self)
    return lib.Character
end

function lib:SetBodyPartCFrame(self, name, cframe)
    assert(name, "SimpleReanimate: Name is nil.")
    assert(cframe, "SimpleReanimate: CFrame is nil")
    
    assert(typeof(name) ~= "string", "SimpleReanimate: Name is not type string.")
    assert(typeof(cframe) ~= "CFrame", "SimpleReanimate: CFrame is not type CFrame.")
    
    if not self.Character[name] then error("SimpleReanimate: BodyPart name of: '" .. name .. "' does not exist.") end
    
    self.Character[name].CFrame = cframe
end

return lib
