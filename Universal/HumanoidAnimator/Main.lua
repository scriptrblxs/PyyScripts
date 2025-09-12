-- LICENSE.md
v1=function() print("-- HumanoidAnimationModule.lua --\n" .. game:HttpGet("https://raw.githubusercontent.com/scriptrblxs/PyyScripts/refs/heads/main/LICENSE.md"))end
if v1 then v1() end

-- CFrameSequenceKeypoint
local CFrameSequenceKeypoint = {}
CFrameSequenceKeypoint.__index = CFrameSequenceKeypoint

function CFrameSequenceKeypoint.new(time, offsets)
    return setmetatable({ Time = time, Offsets = offsets }, CFrameSequenceKeypoint)
end

-- CFrameSequence
local CFrameSequence = {}
CFrameSequence.__index = CFrameSequence

function CFrameSequence.new()
    return setmetatable({ Keypoints = {} }, CFrameSequence)
end

function CFrameSequence:AddKeypoint(time, offsets)
    table.insert(self.Keypoints, CFrameSequenceKeypoint.new(time, offsets))
    table.sort(self.Keypoints, function(a, b) return a.Time < b.Time end)
end

function CFrameSequence:GetKeypoints()
    return self.Keypoints
end

-- HumanoidAnimator
local HumanoidAnimator = {}
HumanoidAnimator.__index = HumanoidAnimator

HumanoidAnimator.CFrameSequence = CFrameSequence

function HumanoidAnimator.new(character)
    local self = setmetatable({
        Character = character,
        Sequence = nil,
        Playing = false,
        StartTime = 0,
        Duration = 0,
        Motors = {},
        Looped = false,
    }, HumanoidAnimator)

    -- Store all Motor6Ds
    for _, motor in pairs(character:GetDescendants()) do
        if motor:IsA("Motor6D") then
            self.Motors[motor.Name] = motor
        end
    end

    return self
end

-- Find surrounding keyframes for a part
local function findPartKeyframes(keypoints, partName, time)
    local last, next = nil, nil
    for i, kp in ipairs(keypoints) do
        if kp.Offsets[partName] then
            if kp.Time <= time then
                last = kp
            elseif kp.Time > time and not next then
                next = kp
            end
        end
    end
    return last, next
end

function HumanoidAnimator:Play(sequence, duration, looped)
    if not sequence or #sequence.Keypoints < 1 then return end
    self.Sequence = sequence
    self.Duration = duration or 1
    self.Looped = looped or false
    self.Playing = true
    self.StartTime = tick()

    task.spawn(function()
        while self.Playing do
            local elapsed = tick() - self.StartTime

            if elapsed >= self.Duration then
                if self.Looped then
                    self.StartTime = tick()
                    elapsed = 0
                else
                    elapsed = self.Duration
                    self.Playing = false
                end
            end

            for name, motor in pairs(self.Motors) do
                local last, next = findPartKeyframes(sequence.Keypoints, name, elapsed)
                if last and next then
                    local t = (elapsed - last.Time) / (next.Time - last.Time)
                    local c1 = last.Offsets[name]
                    local c2 = next.Offsets[name]
                    motor.Transform = c1:Lerp(c2, t)
                elseif last then
                    motor.Transform = last.Offsets[name]
                end
            end

            task.wait()
        end
    end)
end

function HumanoidAnimator:Stop()
    self.Playing = false
end

return HumanoidAnimator