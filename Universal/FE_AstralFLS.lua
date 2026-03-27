local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local lp = Players.LocalPlayer
local cam = Workspace.CurrentCamera

local active = false
local char, ghost, breadcrumbs = nil, nil, {}

local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local btn = Instance.new("TextButton", gui)
local corner = Instance.new("UICorner", btn)
local stroke = Instance.new("UIStroke", btn)

gui.Name = "A_Burst"
btn.Name = "T"
btn.AnchorPoint = Vector2.new(1, 0.5)
btn.Position = UDim2.new(1, -20, 0.15, 0)
btn.Size = UDim2.new(0, 120, 0, 45)
btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
btn.Text = "ASTRAL: OFF"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14

corner.CornerRadius = UDim.new(0, 8)
stroke.Color = Color3.fromRGB(60, 60, 60)
stroke.Thickness = 2

local function clear()
    if ghost then ghost:Destroy() end
    ghost = nil
    active = false
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.Anchored = false
        local hum = char:FindFirstChild("Humanoid")
        if hum then cam.CameraSubject = hum end
    end
    btn.Text = "ASTRAL: OFF"
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    stroke.Color = Color3.fromRGB(60, 60, 60)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
end

local function toggle()
    if active then
        RunService:UnbindFromRenderStep("A_Loop")
        btn.Text = "MOVING"
        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.Anchored = false
            if #breadcrumbs > 0 then
                for i = 1, #breadcrumbs, 15 do
                    local lastCf = breadcrumbs[#breadcrumbs]
                    local cf = breadcrumbs[i]
                    char.HumanoidRootPart.CFrame = cf:Lerp(lastCf, i / #breadcrumbs)
                    RunService.Heartbeat:Wait()
                end
                char.HumanoidRootPart.CFrame = breadcrumbs[#breadcrumbs]
                char.HumanoidRootPart.Velocity = ghost.HumanoidRootPart.Velocity
            end
        end
        clear()
    else
        char = lp.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        
        active = true
        breadcrumbs = {}
        
        char.Archivable = true
        ghost = char:Clone()
        char.Archivable = false
        ghost.Name = "G_Instance"
        ghost.Parent = Workspace
        
        local con
        con = RunService.Stepped:Connect(function()
            if not ghost then con:Disconnect() return end
            for _, p in pairs(ghost:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.Transparency = 0.5
                    p.Material = Enum.Material.Neon
                    p.CanCollide = false
                end
            end
        end)
        
        char.HumanoidRootPart.Anchored = true
        ghost.HumanoidRootPart.Anchored = false
        ghost.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame
        
        local gHum = ghost:FindFirstChild("Humanoid")
        workspace.CurrentCamera.CameraSubject = gHum
        
        btn.Text = "RECORDING"
        btn.BackgroundColor3 = Color3.fromRGB(150, 0, 150)
        stroke.Color = Color3.fromRGB(200, 50, 200)
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        
        RunService:BindToRenderStep("A_Loop", 201, function()
            local rH = char:FindFirstChild("Humanoid")
            local gH = ghost:FindFirstChild("Humanoid")
            local gR = ghost:FindFirstChild("HumanoidRootPart")
            if rH and gH and gR then
                gH:Move(rH.MoveDirection, false)
                gH.Jump = rH.Jump
                gH.WalkSpeed = rH.WalkSpeed
                table.insert(breadcrumbs, gR.CFrame)
            end
        end)
    end
end

btn.MouseButton1Down:Connect(toggle)

UserInputService.InputBegan:Connect(function(io, gpe)
    if not gpe and io.KeyCode == Enum.KeyCode.X and active then
        RunService:UnbindFromRenderStep("A_Loop")
        clear()
    end
end)

RunService.PreSimulation:Connect(function()
    settings():GetService("NetworkSettings").IncomingReplicationLag = active and math.huge or 0
end)