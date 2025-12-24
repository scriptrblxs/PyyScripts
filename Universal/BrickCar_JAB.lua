local lplr = game.Players.LocalPlayer  
local chr = lplr.Character  
local hrp = chr.HumanoidRootPart  
local hum = chr.Humanoid  
  
local gen = game:GetService("TextChatService").TextChannels.RBXGeneral  
  
gen:SendAsync("-gh 13502645905 13502645905 13502645905 13502645905 13502645905 13502645905")  
  
task.wait(2.5)  
  

local carparts = Instance.new("Folder", workspace)
carparts.Name = "CarParts"

local bricks = {}  
for _, p in ipairs(chr:GetChildren()) do  
    if p:IsA("Accessory") and p.Handle.Size == Vector3.new(2.984999895095825, 1.527999997138977, 1.527999997138977) then  
        p.Handle:BreakJoints()  
        table.insert(bricks, p)  
    end  
end  

task.spawn(function()
    while chr:IsDescendantOf(workspace) do task.wait() end
    carparts:Destroy()
end)
  
  
local function align(brick, offset)  
    local a = Instance.new("Attachment", brick)  
    local ap = Instance.new("AlignPosition", brick)  
    local ao = Instance.new("AlignOrientation", brick)  
      
    game:GetService("RunService").PreSimulation:Connect(function()  
        local worldCf = hrp.CFrame * offset  
          
        ap.Mode = Enum.PositionAlignmentMode.OneAttachment  
        ap.Attachment0 = a  
        ap.MaxForce = math.huge  
        ap.Responsiveness = math.huge  
        ap.RigidityEnabled = true  
        ap.Position = worldCf.Position  
          
        ao.Mode = Enum.OrientationAlignmentMode.OneAttachment  
        ao.Attachment0 = a  
        ao.MaxTorque = math.huge  
        ao.MaxAngularVelocity = math.huge  
        ao.Responsiveness = math.huge  
        ao.RigidityEnabled = true  
        ao.CFrame = worldCf  
        
        brick.CFrame = worldCf
    end)  
end  

gen:SendAsync("-net")
for _, brick in ipairs(bricks) do
    brick.Parent = carparts
end
  
align(bricks[1].Handle, CFrame.new(-0.75, -1.5, 0) * CFrame.Angles(0,math.rad(90),0))  
align(bricks[2].Handle, CFrame.new(0.75, -1.5, 0) * CFrame.Angles(0,math.rad(90),0))  
bricks[1].Handle.CanCollide = false
bricks[2].Handle.CanCollide = false
  
local function wheel(brick, offset, radius)  
    local a = Instance.new("Attachment", brick)  
    local ap = Instance.new("AlignPosition", brick)  
    local ao = Instance.new("AlignOrientation", brick)  
      
    local accumulatedAngle = 0 -- keep track of rotation  
      
    game:GetService("RunService").PreSimulation:Connect(function(dt)  
        local worldCf = hrp.CFrame * offset  
  
        -- Position alignment  
        ap.Mode = Enum.PositionAlignmentMode.OneAttachment  
        ap.Attachment0 = a  
        ap.MaxForce = math.huge  
        ap.Responsiveness = math.huge  
        ap.RigidityEnabled = true  
        ap.Position = worldCf.Position  
  
        -- Orientation alignment  
        ao.Mode = Enum.OrientationAlignmentMode.OneAttachment  
        ao.Attachment0 = a  
        ao.MaxTorque = math.huge  
        ao.MaxAngularVelocity = math.huge  
        ao.RigidityEnabled = true  
        ao.Responsiveness = math.huge  
  
        -- Forward speed  
        local forwardDir = hrp.CFrame.LookVector  
        local speedForward = hum.MoveDirection:Dot(forwardDir) * hrp.AssemblyLinearVelocity.Magnitude  
  
        -- Accumulate rotation  
        accumulatedAngle = accumulatedAngle - speedForward / radius * dt  
  
        -- Apply rotation along Z axis now  
        ao.CFrame = worldCf * CFrame.Angles(0, 0, accumulatedAngle)  
        brick.CFrame = worldCf * CFrame.Angles(0, 0, accumulatedAngle)  
    end)  
end  
  
wheel(bricks[3].Handle, CFrame.new(-2.25,-1.5,2) * CFrame.Angles(0,math.rad(90),math.rad(90)), 2)  
wheel(bricks[4].Handle, CFrame.new(2.25,-1.5,2) * CFrame.Angles(0,math.rad(90),0), 2)  
wheel(bricks[5].Handle, CFrame.new(2.25,-1.5,-2) * CFrame.Angles(0,math.rad(90),math.rad(90)), 2)  
wheel(bricks[6].Handle, CFrame.new(-2.25,-1.5,-2) * CFrame.Angles(0,math.rad(90),0), 2)  
  
local sittingA = Instance.new("Animation")  
sittingA.AnimationId = "rbxassetid://178130996"  
local tr = hum:LoadAnimation(sittingA)  
tr:AdjustWeight(50000)  
tr.Looped = true  
tr:Play()  
  
game:GetService("RunService").PreRender:Connect(function()  
for _, tr in ipairs(hum:GetPlayingAnimationTracks()) do  
if tr.Animation.AnimationId ~= "rbxassetid://178130996" then tr:Stop() end  
end  
end)



local a1 = Instance.new("Attachment", hrp)
local b1 = Instance.new("Attachment", hrp)
local a2 = Instance.new("Attachment", hrp)
local b2 = Instance.new("Attachment", hrp)
a1.CFrame = CFrame.new(-2.25 - 1,-1.5 - 1,2)
b1.CFrame = CFrame.new(-2.25 + 1,-1.5 - 1,2)
a2.CFrame = CFrame.new(2.25 - 1,-1.5 - 1,2)
b2.CFrame = CFrame.new(2.25 + 1,-1.5 - 1,2)

local t1 = Instance.new("Trail")
t1.Attachment0 = a1
t1.Attachment1 = b1
t1.Color = ColorSequence.new(Color3.fromRGB(28, 14, 14))
t1.Lifetime = 60
t1.Transparency = NumberSequence.new(0)
t1.Parent = hrp
local t2 = Instance.new("Trail")
t2.Attachment0 = a2
t2.Attachment1 = b2
t2.Color = ColorSequence.new(Color3.fromRGB(28, 14, 14))
t2.Lifetime = 60
t2.Transparency = NumberSequence.new(0)
t2.Parent = hrp

local brake = 40
local acceleration = 55
local turnRateLerp = 0.65

local maxSpeed = 90

local isBraking = false
local isAccelerating = false

local sg = Instance.new("ScreenGui", lplr.PlayerGui)  
sg.ScreenInsets = Enum.ScreenInsets.None  
  
local b = Instance.new("TextButton", sg)  
b.Text = "Brakes"  
b.TextScaled = true  
b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)  
b.BorderColor3 = Color3.new(0, 0, 0)  
b.BorderSizePixel = 2  
b.TextColor3 = Color3.new(1, 1, 1)  
b.AnchorPoint = Vector2.new(0.5, 1)  
b.Position = UDim2.fromScale(0.5, 0.95)  
b.Size = UDim2.fromScale(0.35, 0.075)  
  
local acs = Instance.new("TextButton", sg)  
acs.Text = "Accelerate"  
acs.TextScaled = true  
acs.BackgroundColor3 = Color3.fromRGB(50, 50, 50)  
acs.BorderColor3 = Color3.new(0, 0, 0)  
acs.BorderSizePixel = 2  
acs.TextColor3 = Color3.new(1, 1, 1)  
acs.AnchorPoint = Vector2.new(0.5, 1)  
acs.Position = UDim2.fromScale(0.5, 0.95 - (0.075 * 1.25))  
acs.Size = UDim2.fromScale(0.35, 0.075)

b.MouseButton1Down:Connect(function()isBraking=true end)
b.MouseButton1Up:Connect(function()isBraking=false end)

acs.MouseButton1Down:Connect(function()isAccelerating=true end)
acs.MouseButton1Up:Connect(function()isAccelerating=false end)

local skidSound = Instance.new("Sound")
skidSound.SoundId = "rbxassetid://138476695903760"
skidSound.Looped = false
skidSound.Volume = 5
skidSound.Parent = hrp

local currentCamCF = workspace.CurrentCamera.CFrame
game:GetService("RunService").PreRender:Connect(function(dt)
    if isAccelerating then
        hum.WalkSpeed = math.min(hum.WalkSpeed + acceleration * dt, maxSpeed)
    elseif isBraking then
        hum.WalkSpeed = math.max(hum.WalkSpeed - brake * dt, 0)
    end
    
    local speedFactor = math.clamp(1 - (hum.WalkSpeed / maxSpeed), 0.2, 1)
    local currentLerp = turnRateLerp * speedFactor
    
    local forward = currentCamCF.LookVector:Dot(hrp.CFrame.LookVector)
    if forward < 0.5 and hrp.AssemblyLinearVelocity > maxSpeed / 2 then
        if not skidSound.IsPlaying then skidSound:Play() end
        t1.Enabled = true
        t2.Enabled = true
    else
        if skidSound.IsPlaying then skidSound:Stop() end
        t1.Enabled = false
        t2.Enabled = false
    end
    
    currentCamCF = currentCamCF:Lerp(workspace.CurrentCamera.CFrame, currentLerp)
    hum:Move(currentCamCF.LookVector)
end)

game:GetService("RunService").PreSimulation:Connect(function()
    lplr.ReplicationFocus = workspace
    sethiddenproperty(lplr, "SimulationRadius", math.huge)
end)

local rs = game:GetService("RunService")
rs.Heartbeat:Connect(function()
    local vel, movel = nil, 0.1
    
    vel = hrp.Velocity
    hrp.Velocity = hrp.CFrame.LookVector * (hum.WalkSpeed * 5)
    
    rs.RenderStepped:Wait()
    if chr:IsDescendantOf(workspace) then
        hrp.Velocity = vel
    end
    
    rs.Stepped:Wait()
    if chr:IsDescendantOf(workspace) then
        hrp.Velocity = vel + Vector3.new(0, movel, 0)
        movel *= -1
    end
end)