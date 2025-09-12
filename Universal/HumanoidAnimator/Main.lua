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

function HumanoidAnimator.new(character)
    local self = setmetatable({
        Character = character,
        Sequence = nil,
        Playing = false,
        StartTime = 0,
        Duration = 0,
        Parts = {}
    }, HumanoidAnimator)

    -- Store all BaseParts
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            self.Parts[part.Name] = part
        end
    end

    return self
end

-- Play a sequence
function HumanoidAnimator:Play(sequence, duration)
    if not sequence or #sequence.Keypoints < 2 then return end
    self.Sequence = sequence
    self.Playing = true
    self.StartTime = tick()
    self.Duration = duration or 1

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

-- Interpolate parts linearly
function HumanoidAnimator:Interpolate(time)
    local keypoints = self.Sequence.Keypoints
    for _, kp in ipairs(keypoints) do
        local k1, k2 = kp, keypoints[_+1]
        if not k2 then break end
        if time >= k1.Time and time <= k2.Time then
            local t = (time - k1.Time) / (k2.Time - k1.Time)
            for partName, part in pairs(self.Parts) do
                local offset1 = k1.Offsets[partName] or CFrame.new()
                local offset2 = k2.Offsets[partName] or offset1

                -- Try to find a motor6d connecting to this part
                local motor = part.Parent:FindFirstChildWhichIsA("Motor6D")
                local baseCFrame = part.CFrame
                if motor then
                    baseCFrame = motor.Part0.CFrame * motor.C0
                end

                -- Apply linear interpolation of offsets and set CFrame
                part.CFrame = baseCFrame * offset1:Lerp(offset2, t)
            end
            break
        end
    end
end

-- Apply a keyframe instantly
function HumanoidAnimator:ApplyKeypoint(kp)
    for partName, part in pairs(self.Parts) do
        local offset = kp.Offsets[partName]
        if offset then
            local motor = part.Parent:FindFirstChildWhichIsA("Motor6D")
            local baseCFrame = part.CFrame
            if motor then
                baseCFrame = motor.Part0.CFrame * motor.C0
            end
            part.CFrame = baseCFrame * offset
        end
    end
end

function HumanoidAnimator:Stop()
    self.Playing = false
end

return HumanoidAnimator