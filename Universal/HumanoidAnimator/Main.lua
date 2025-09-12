-- HumanoidAnimator v2 - Ragdoll-style with offsets
local HumanoidAnimator = {}
HumanoidAnimator.__index = HumanoidAnimator

-- CFrameSequenceKeypoint
local CFrameSequenceKeypoint = {}
CFrameSequenceKeypoint.__index = CFrameSequenceKeypoint
function CFrameSequenceKeypoint.new(time, offsets)
    return setmetatable({Time = time, Offsets = offsets}, CFrameSequenceKeypoint)
end

-- CFrameSequence
local CFrameSequence = {}
CFrameSequence.__index = CFrameSequence
function CFrameSequence.new() return setmetatable({Keypoints = {}}, CFrameSequence) end
function CFrameSequence:AddKeypoint(time, offsets)
    table.insert(self.Keypoints, CFrameSequenceKeypoint.new(time, offsets))
    table.sort(self.Keypoints, function(a,b) return a.Time < b.Time end)
end
HumanoidAnimator.CFrameSequence = CFrameSequence

-- Create a new animator
function HumanoidAnimator.new(character)
    local self = setmetatable({
        Character = character,
        Sequence = nil,
        Playing = false,
        StartTime = 0,
        Duration = 0,
        Parts = {},
        OriginalMotors = {}
    }, HumanoidAnimator)

    -- Store all BaseParts
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            self.Parts[part.Name] = part
        end
    end

    -- Store and destroy all Motor6Ds
    for _, motor in pairs(character:GetDescendants()) do
        if motor:IsA("Motor6D") then
            self.OriginalMotors[motor.Name] = {Parent = motor.Parent, Part0 = motor.Part0, Part1 = motor.Part1, C0 = motor.C0, C1 = motor.C1}
            motor:Destroy()
        end
    end

    return self
end

-- Play a sequence
function HumanoidAnimator:Play(sequence, duration)
    if not sequence or #sequence.Keypoints < 1 then return end
    self.Sequence = sequence
    self.Playing = true
    self.StartTime = tick()
    self.Duration = duration or (sequence.Keypoints[#sequence.Keypoints].Time)

    task.spawn(function()
        while self.Playing do
            local elapsed = tick() - self.StartTime
            if elapsed >= self.Duration then
                self:ApplyKeypoint(sequence.Keypoints[#sequence.Keypoints])
                self.Playing = false
                break
            end
            self:Interpolate(elapsed)
            task.wait()
        end
    end)
end

-- Linear interpolation
function HumanoidAnimator:Interpolate(time)
    local keypoints = self.Sequence.Keypoints
    for i, k1 in ipairs(keypoints) do
        local k2 = keypoints[i+1]
        if not k2 then break end
        if time >= k1.Time and time <= k2.Time then
            local t = (time - k1.Time) / (k2.Time - k1.Time)
            for partName, part in pairs(self.Parts) do
                local offset1 = k1.Offsets[partName] or CFrame.new()
                local offset2 = k2.Offsets[partName] or offset1

                -- Use stored Motor6D data if it exists
                for motorName, motorData in pairs(self.OriginalMotors) do
                    if motorData.Part1 == part then
                        local baseCFrame = motorData.Part0.CFrame * motorData.C0
                        part.CFrame = baseCFrame * offset1:Lerp(offset2, t)
                        break
                    end
                end
            end
            break
        end
    end
end

-- Apply keyframe instantly
function HumanoidAnimator:ApplyKeypoint(kp)
    for partName, part in pairs(self.Parts) do
        local offset = kp.Offsets[partName]
        if offset then
            for motorName, motorData in pairs(self.OriginalMotors) do
                if motorData.Part1 == part then
                    local baseCFrame = motorData.Part0.CFrame * motorData.C0
                    part.CFrame = baseCFrame * offset
                    break
                end
            end
        end
    end
end

-- Stop animation
function HumanoidAnimator:Stop()
    self.Playing = false
end

-- Restore original Motor6Ds
function HumanoidAnimator:RestoreMotors()
    for name, data in pairs(self.OriginalMotors) do
        local motor = Instance.new("Motor6D")
        motor.Name = name
        motor.Part0 = data.Part0
        motor.Part1 = data.Part1
        motor.C0 = data.C0
        motor.C1 = data.C1
        motor.Parent = data.Parent
    end
end

return HumanoidAnimator