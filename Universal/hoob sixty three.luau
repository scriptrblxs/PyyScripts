local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

-- Load LiteUI
local LiteUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/NicelyTinned/lite-ui/refs/heads/main/src/init.luau"))()

-- ==========================================
-- 1. FILE SYSTEM & CONFIGURATION MANAGER
-- ==========================================
local FOLDER_NAME = "Hub63"
local FILE_PATH = FOLDER_NAME .. "/options.json"

local options = {
    ShowSkin = true,
    DefaultSkinUsername = ""
}

-- Helper function to save JSON cleanly with nice spacing/indentation
local function saveBeautifiedOptions()
    local jsonTemplate = "{\n" ..
        '    "ShowSkin": %s,\n' ..
        '    "DefaultSkinUsername": "%s"\n' ..
        "}"
    
    local formattedJson = string.format(jsonTemplate, tostring(options.ShowSkin), options.DefaultSkinUsername)
    
    pcall(function()
        writefile(FILE_PATH, formattedJson)
    end)
end

-- Initialize folders and check files
if not isfolder(FOLDER_NAME) then
    makefolder(FOLDER_NAME)
end

if isfile(FILE_PATH) then
    local readSuccess, rawContent = pcall(readfile, FILE_PATH)
    if readSuccess then
        local decodeSuccess, parsedJson = pcall(function() return HttpService:JSONDecode(rawContent) end)
        if decodeSuccess and type(parsedJson) == "table" then
            -- Fallback checks to ensure structural validity
            if parsedJson.ShowSkin ~= nil then options.ShowSkin = parsedJson.ShowSkin end
            if parsedJson.DefaultSkinUsername ~= nil then options.DefaultSkinUsername = parsedJson.DefaultSkinUsername end
        else
            saveBeautifiedOptions() -- Reset corrupt file to defaults
        end
    end
else
    saveBeautifiedOptions() -- Generate fresh template file if missing
end

-- ==========================================
-- 2. CORE ENCODER, DECODER, & GLOBAL SPACE
-- ==========================================
local ALL_TRACKED_MESHES = {} 
local renderConnection = nil
_G.CurrentSkinId = 123826306477155 -- Default fallback skin

local PREFIX_REQUEST   = "TehEpikDuckIsComing" 
local PREFIX_BROADCAST = "BuilderManMan"       

local WORD_POOL = {
    [0]="apple", [1]="banana", [2]="cherry", [3]="dog", [4]="cat", [5]="house", [6]="tree", [7]="river",
    [8]="ocean", [9]="cloud", [10]="sun", [11]="moon", [12]="star", [13]="rock", [14]="grass", [15]="bird",
    [16]="fish", [17]="book", [18]="pen", [19]="chair", [20]="table", [21]="door", [22]="window", [23]="shirt",
    [24]="pants", [25]="shoe", [26]="hat", [27]="glove", [28]="paper", [29]="clock", [30]="coin", [31]="key",
    [32]="lamp", [33]="box", [34]="ring", [35]="cup"
}

local WORD_LOOKUP = {}
for i, word in pairs(WORD_POOL) do WORD_LOOKUP[word] = i end
local function toCamel(word) return string.gsub(word, "^%l", string.upper) end

local function EncodeUserId(num)
    num = tonumber(num) or 0
    if num == 0 then return toCamel(WORD_POOL[0]) end
    local result = ""
    while num > 0 do
        local remainder = num % 36
        result = toCamel(WORD_POOL[remainder]) .. result
        num = math.floor(num / 36)
    end
    return result
end

local function DecodeUserId(camelStr)
    if not camelStr or camelStr == "" then return nil end
    local num = 0
    for word in string.gmatch(camelStr, "%u%l*") do
        local lowerWord = string.lower(word)
        local val = WORD_LOOKUP[lowerWord]
        if not val then return nil end
        num = num * 36 + val
    end
    return num
end

local function BroadcastSkinId(targetSkinId)
    -- Respect the ShowSkin option block before handling network overhead
    if not options.ShowSkin then return end
    
    local payload = PREFIX_BROADCAST .. EncodeUserId(targetSkinId)
    local generalChannel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
    if generalChannel then
        generalChannel:SendAsync(payload)
    end
end

-- ==========================================
-- 3. AVATAR LOADING & PHYSICS ENTRIES
-- ==========================================
local function weldCustomAccessory(character, accessory)
    local handle = accessory:FindFirstChild("Handle")
    if not handle then return end
    
    local accAtt = handle:FindFirstChildWhichIsA("Attachment")
    if not accAtt then return end

    local charAtt = character:FindFirstChild(accAtt.Name, true)
    if not charAtt then return end

    handle.Anchored = false
    local weld = Instance.new("Weld")
    weld.Name = "AccessoryWeld"
    weld.Part0 = charAtt.Parent
    weld.Part1 = handle
    weld.C0 = charAtt.CFrame
    weld.C1 = accAtt.CFrame
    weld.Parent = handle
    
    accessory.Parent = character
end

local function loadPlayerAvatar(userId, character)
    if not character then return end

    -- Clean out previous custom structures
    for _, obj in pairs(character:GetChildren()) do
        if obj.Name:match("^CustomMesh_") or obj:IsA("Accessory") or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("BodyColors") then
            obj:Destroy()
        end
    end
    
    if ALL_TRACKED_MESHES[character] then
        for _, entry in ipairs(ALL_TRACKED_MESHES[character]) do
            if entry.CustomPart then entry.CustomPart:Destroy() end
        end
    end
    ALL_TRACKED_MESHES[character] = {}

    local success, appearanceModel = pcall(function()
        return Players:GetCharacterAppearanceAsync(userId)
    end)
    if not success or not appearanceModel then return end

    local shirtTemplate, pantsTemplate, bodyColors = nil, nil, nil

    for _, item in pairs(appearanceModel:GetChildren()) do
        if item:IsA("Shirt") then
            shirtTemplate = item.ShirtTemplate
            item:Clone().Parent = character
        elseif item:IsA("Pants") then
            pantsTemplate = item.PantsTemplate
            item:Clone().Parent = character
        elseif item:IsA("BodyColors") then
            item:Clone().Parent = character
            bodyColors = item
        elseif item:IsA("Accessory") then
            weldCustomAccessory(character, item:Clone())
        end
    end

    for _, obj in character:GetDescendants() do
        if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" and not obj.Parent:IsA("Accessory") then
            obj.Transparency = (obj.Name:match("Arm") or obj.Name == "Head") and 0 or 1
        elseif obj:IsA("Decal") and obj.Parent.Name ~= "Head" and not obj.Parent:IsA("Accessory") then
            obj.Transparency = 1
        end
    end

    local DYNAMIC_MESH_DATA = {
        {BodyPart = "Torso", MeshId = "123826306477155", TextureId = shirtTemplate, Size = 1.01, Opacity = 0.02, Position = Vector3.zero, Rotation = Vector3.new(0, -90, 0)},
        {BodyPart = "Torso", MeshId = "123826306477155", TextureId = shirtTemplate, Size = 0.95, Opacity = 1, Position = Vector3.zero, Rotation = Vector3.new(0, -90, 0)},
        {BodyPart = "Torso", MeshId = "114977119770915", TextureId = pantsTemplate, Size = 0.8, Opacity = 1, Position = Vector3.new(0.5, -1, -0.4), Rotation = Vector3.new(0, 180, 0), RotationalDrag = {MaxDownAngle = 20, MaxUpAngle = 20, Pivot = CFrame.new(0, -1, -0.5) * CFrame.Angles(0,math.rad(180),0), Strength = 0.2, Damp = 0.7}},
        {BodyPart = "Torso", MeshId = "102005630554650", TextureId = pantsTemplate, Size = 0.8, Opacity = 1, Position = Vector3.new(-0.5, -1, -0.4), Rotation = Vector3.new(0, 180, 0), RotationalDrag = {MaxDownAngle = 20, MaxUpAngle = 20, Pivot = CFrame.new(0, -1, -0.5) * CFrame.Angles(0,math.rad(180),0), Strength = 0.2, Damp = 0.7}},
        {BodyPart = "Torso", MeshId = "7606070501", TextureId = shirtTemplate, Size = 1.15, Opacity = 1, Position = Vector3.new(0, 0.2, 0.75), Rotation = Vector3.new(0, -90, 0), RotationalDrag = {MaxDownAngle = 25, MaxUpAngle = 80, Pivot = CFrame.new(0, 1, -0.5), Strength = 0.2, Damp = 0.45}},
        {BodyPart = "Right Leg", MeshId = "71665474693582", TextureId = pantsTemplate, Size = 1, Opacity = 1, Position = Vector3.new(0.05, 0, 0), Rotation = Vector3.new(0, 180, 0)},
        {BodyPart = "Left Leg", MeshId = "107817600592761", TextureId = pantsTemplate, Size = 1, Opacity = 1, Position = Vector3.new(-0.05, 0, 0), Rotation = Vector3.new(0, 180, 0)}
    }

    local R15_MAP = {["Torso"] = "UpperTorso", ["Left Leg"] = "LeftUpperLeg", ["Right Leg"] = "RightUpperLeg"}

    for _, data in ipairs(DYNAMIC_MESH_DATA) do
        local targetPart = character:FindFirstChild(data.BodyPart) or character:FindFirstChild(R15_MAP[data.BodyPart])
        if not targetPart then continue end

        local customPart = Instance.new("MeshPart")
        customPart.Name = "CustomMesh_" .. data.BodyPart
        customPart.CanCollide = false; customPart.CanTouch = false; customPart.CanQuery = false; customPart.Massless = true; customPart.Anchored = true
        
        if bodyColors then 
            pcall(function() customPart.Color = bodyColors[data.BodyPart:gsub("%s", "") .. "Color3"] end)
        end
        
        customPart.Transparency = 1 - (data.Opacity or 1)
        
        pcall(function()
            customPart.MeshId = "rbxassetid://" .. data.MeshId
            if data.TextureId then
                local surfaceApp = Instance.new("SurfaceAppearance")
                surfaceApp.ColorMap = data.TextureId
                surfaceApp.AlphaMode = Enum.AlphaMode.Overlay
                surfaceApp.Parent = customPart
            end
        end)
        
        customPart.Size = Vector3.new(data.Size, data.Size, data.Size)
        local offsetCFrame = CFrame.new(data.Position.X, data.Position.Y, -data.Position.Z) * CFrame.Angles(math.rad(data.Rotation.X), math.rad(data.Rotation.Y), math.rad(data.Rotation.Z))
        customPart.CFrame = targetPart.CFrame * offsetCFrame
        customPart.Parent = character

        local entry = { CustomPart = customPart, TargetPart = targetPart, Offset = offsetCFrame, RotationalDrag = data.RotationalDrag }
        if data.RotationalDrag then
            entry.CurrentAngleX = 0; entry.AngularVelocity = 0; entry.LastPosition = targetPart.Position
        end
        
        table.insert(ALL_TRACKED_MESHES[character], entry)
    end
end

if renderConnection then renderConnection:Disconnect() end
renderConnection = RunService.PreRender:Connect(function(dt)
    for character, trackedMeshes in pairs(ALL_TRACKED_MESHES) do
        if not character or not character.Parent then
            ALL_TRACKED_MESHES[character] = nil
            continue
        end

        for i = #trackedMeshes, 1, -1 do
            local data = trackedMeshes[i]
            if not (data.TargetPart and data.TargetPart.Parent and data.CustomPart and data.CustomPart.Parent) then
                if data.CustomPart then data.CustomPart:Destroy() end
                table.remove(trackedMeshes, i)
                continue
            end

            local targetCFrame = data.TargetPart.CFrame * data.Offset

            if data.RotationalDrag then
                local dragParams = data.RotationalDrag; local targetAngleX = 0
                local currentPosition = data.TargetPart.Position
                local worldVelocity = (currentPosition - data.LastPosition) / dt
                data.LastPosition = currentPosition 
                
                local localVel = data.TargetPart.CFrame:VectorToObjectSpace(worldVelocity)
                local dragForce = (localVel.Z * 2.5) - (localVel.Y * 1.5)
                
                targetAngleX = dragForce < 0 and math.max(dragForce, -dragParams.MaxDownAngle) or math.min(dragForce, dragParams.MaxUpAngle)

                local stiffness = (dragParams.Strength or 0.2) * 800
                local damping = (dragParams.Damp or 0.78) * 15
                
                local displacement = data.CurrentAngleX - targetAngleX
                local springAcceleration = (-stiffness * displacement) - (damping * data.AngularVelocity)
                
                data.AngularVelocity = data.AngularVelocity + (springAcceleration * dt)
                data.CurrentAngleX = data.CurrentAngleX + (data.AngularVelocity * dt)
                
                data.CurrentAngleX = data.CurrentAngleX < 0 and math.max(data.CurrentAngleX, -dragParams.MaxDownAngle) or math.min(data.CurrentAngleX, dragParams.MaxUpAngle)

                local pivotCFrame = data.TargetPart.CFrame * dragParams.Pivot
                local originalCFrame = data.TargetPart.CFrame * data.Offset
                local offsetFromPivot = pivotCFrame:Inverse() * originalCFrame
                local rotationCFrame = CFrame.Angles(math.rad(data.CurrentAngleX), 0, 0)
                
                data.CustomPart.CFrame = pivotCFrame * rotationCFrame * offsetFromPivot
            else
                data.CustomPart.CFrame = targetCFrame
            end
        end
    end
end)

-- ==========================================
-- 4. INTERCEPTOR & HANDSHAKE ROUTER
-- ==========================================
TextChatService.OnIncomingMessage = function(message)
    -- Return early if configurations have disabled custom skins completely
    if not options.ShowSkin then return end

    local overrideProperties = Instance.new("TextChatMessageProperties")
    local msgText = message.Text
    local sender = message.TextSource and Players:GetPlayerByUserId(message.TextSource.UserId)
    
    if sender == LocalPlayer then return end

    if msgText == PREFIX_REQUEST then
        if sender and _G.CurrentSkinId then
            task.spawn(function()
                task.wait(math.random(10, 30) / 10) 
                BroadcastSkinId(_G.CurrentSkinId)
            end)
        end
        overrideProperties.Text = ""
        return overrideProperties
    end

    if string.sub(msgText, 1, #PREFIX_BROADCAST) == PREFIX_BROADCAST then
        local camelPayload = string.sub(msgText, #PREFIX_BROADCAST + 1)
        local decodedSkinId = DecodeUserId(camelPayload)
        
        if decodedSkinId and sender and sender.Character then
            loadPlayerAvatar(decodedSkinId, sender.Character)
        end
        
        overrideProperties.Text = ""
        return overrideProperties
    end
end

-- ==========================================
-- 5. UI INTERFACE & SYSTEM HOOKS
-- ==========================================
local isMinimized = false
local defaultSize = UDim2.new(0.9, 0, 0, 160)
local minSize = UDim2.new(0, 45, 0, 45)

local ScreenGui = LiteUI.new("ScreenGui", {
    Parent = game.CoreGui,
    Name = "Hub63",
    ResetOnSpawn = false,
    Children = {
        MainFrame = {"Frame", {
            Size = defaultSize,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundColor3 = Color3.fromRGB(30, 30, 35),
            ClipsDescendants = true,
            Children = {
                UICorner = {"UICorner", {CornerRadius = UDim.new(0, 8)}},
                UISizeConstraint = {"UISizeConstraint", {MaxSize = Vector2.new(350, 160)}},
                
                Header = {"Frame", {
                    Size = UDim2.new(1, 0, 0, 45),
                    BackgroundTransparency = 1,
                    Children = {
                        Title = {"TextLabel", {
                            Size = UDim2.new(1, -50, 1, 0),
                            Position = UDim2.new(0, 15, 0, 0),
                            BackgroundTransparency = 1,
                            Text = "Hub63 Avatar Importer",
                            TextColor3 = Color3.new(1, 1, 1),
                            Font = Enum.Font.GothamBold,
                            TextSize = 16,
                            TextXAlignment = Enum.TextXAlignment.Left
                        }},
                        MinButton = {"TextButton", {
                            Size = UDim2.new(0, 45, 0, 45),
                            Position = UDim2.new(1, -45, 0, 0),
                            BackgroundTransparency = 1,
                            Text = "-",
                            TextColor3 = Color3.new(1, 1, 1),
                            Font = Enum.Font.GothamBold,
                            TextSize = 20,
                            Events = {
                                MouseButton1Click = function(self)
                                    local mainFrame = self.Instance.Parent.Parent
                                    local content = mainFrame.Content
                                    if isMinimized then
                                        isMinimized = false; self.Instance.Text = "-"
                                        mainFrame.Header.Title.Visible = true; content.Visible = true
                                        LiteUI.Element(mainFrame):Tween({Size = defaultSize}, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out))
                                    else
                                        isMinimized = true; self.Instance.Text = "+"
                                        mainFrame.Header.Title.Visible = false; content.Visible = false
                                        LiteUI.Element(mainFrame):Tween({Size = minSize}, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out))
                                    end
                                end
                            }
                        }}
                    }
                }},
                
                Content = {"Frame", {
                    Size = UDim2.new(1, 0, 1, -45),
                    Position = UDim2.new(0, 0, 0, 45),
                    BackgroundTransparency = 1,
                    Children = {
                        UsernameInput = {"TextBox", {
                            Size = UDim2.new(1, -30, 0, 40),
                            Position = UDim2.new(0, 15, 0, 5),
                            BackgroundColor3 = Color3.fromRGB(45, 45, 50),
                            PlaceholderText = "Enter Username",
                            Text = options.DefaultSkinUsername, -- Autofill from stored config
                            TextColor3 = Color3.new(1, 1, 1),
                            Font = Enum.Font.Gotham,
                            TextSize = 14,
                            Children = {
                                UICorner = {"UICorner", {CornerRadius = UDim.new(0, 6)}}
                            }
                        }},
                        LoadButton = {"TextButton", {
                            Size = UDim2.new(1, -30, 0, 40),
                            Position = UDim2.new(0, 15, 0, 55),
                            BackgroundColor3 = Color3.fromRGB(80, 120, 200),
                            Text = "Load Skin",
                            TextColor3 = Color3.new(1, 1, 1),
                            Font = Enum.Font.GothamBold,
                            TextSize = 14,
                            Children = {
                                UICorner = {"UICorner", {CornerRadius = UDim.new(0, 6)}}
                            },
                            Events = {
                                MouseButton1Click = function(self)
                                    local inputBox = self.Instance.Parent.UsernameInput
                                    local username = inputBox.Text
                                    
                                    if username and username ~= "" then
                                        self.Instance.Text = "Fetching ID..."
                                        local nameSuccess, targetId = pcall(function()
                                            return Players:GetUserIdFromNameAsync(username)
                                        end)
                                        
                                        if nameSuccess and targetId then
                                            self.Instance.Text = "Loading Assets..."
                                            
                                            loadPlayerAvatar(targetId, LocalPlayer.Character)
                                            _G.CurrentSkinId = targetId
                                            BroadcastSkinId(targetId)
                                            
                                            -- Save this username to persistence storage as default
                                            options.DefaultSkinUsername = username
                                            saveBeautifiedOptions()
                                            
                                            self.Instance.Text = "Load Skin"
                                        else
                                            self.Instance.Text = "User Not Found"; task.wait(1.5); self.Instance.Text = "Load Skin"
                                        end
                                    else
                                        self.Instance.Text = "Enter a name!"; task.wait(1); self.Instance.Text = "Load Skin"
                                    end
                                end
                            }
                        }}
                    }
                }}
            }
        }}
    }
})

local function initializeDrag(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local targetMainFrame = game.CoreGui:WaitForChild("Hub63"):WaitForChild("MainFrame")
initializeDrag(targetMainFrame)

-- ==========================================
-- 6. STARTUP INITIALIZATION & ROUTINES
-- ==========================================
local function RequestAllActiveSkins()
    if not options.ShowSkin then return end
    local generalChannel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
    if generalChannel then
        generalChannel:SendAsync(PREFIX_REQUEST)
    end
end

-- Process configuration startup settings
task.spawn(function()
    -- If a default username was configured in the JSON file, load it immediately on startup
    if options.DefaultSkinUsername ~= "" and options.ShowSkin then
        task.wait()
        local startupSuccess, startupId = pcall(function()
            return Players:GetUserIdFromNameAsync(options.DefaultSkinUsername)
        end)
        
        if startupSuccess and startupId then
            loadPlayerAvatar(startupId, LocalPlayer.Character)
            _G.CurrentSkinId = startupId
        end
    end
    
    -- Prompt server sync query
    RequestAllActiveSkins()
end
