print("autogen and finder creds: aerialasf and alchemist_gaming2.0")
if getgenv().AutoGenPlusFinder then
    return
end
getgenv().AutoGenPlusFinder = true

task.spawn(function()
    while true do
        local map = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame") and workspace.Map.Ingame:FindFirstChild("Map")
        if map then
            for _, gen in pairs(map:GetChildren()) do
                if gen:IsA("Model") and gen.Name == "Generator" then
                    local re = gen:FindFirstChild("Remotes") and gen.Remotes:FindFirstChild("RE")
                    if re then
                        re:FireServer()
                    end
                end
            end
        end
        task.wait(2.5)
    end
end)

task.spawn(function()
    while true do
        local map = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame") and workspace.Map.Ingame:FindFirstChild("Map")
        if map then
            for _, gen in pairs(map:GetChildren()) do
                if gen:IsA("Model") and gen.Name == "Generator" then
                    local h = gen:FindFirstChild("GeneratorHighlight") or Instance.new("Highlight")
                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    h.FillTransparency = 1
                    h.OutlineColor = Color3.new(1, 0, 0)
                    if gen.Progress.Value >= 100 then
                        h.OutlineColor = Color3.new(0, 1, 0)
                    end
                    h.Parent = gen
                end
            end
        end
        task.wait()
    end
end)