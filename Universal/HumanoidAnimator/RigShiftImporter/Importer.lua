local CFrameSequence = loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptrblxs/PyyScripts/refs/heads/main/Universal/HumanoidAnimator/Main.lua"))()

local function RigShiftToCFrameSequence(codeString)
    local seq = CFrameSequence.new()
    
    local Compressor = require(path_to_compressor).new()
    local decompressed = Compressor:decompress(codeString)
    local HttpService = game:GetService("HttpService")
    local data = HttpService:JSONDecode(decompressed)

    seq.Loop = data.l
    seq.Name = data.n

    local FPS = 60 -- default in Free Animate
    for limbName, limbPoses in pairs(data.k) do
        for _, pose in ipairs(limbPoses) do
            local times = type(pose.t) == "table" and pose.t or { pose.t }
            for i, t in ipairs(times) do
                local cf = CFrame.new(pose.c[1], pose.c[2], pose.c[3])
                if #pose.c == 6 then
                    cf = cf * CFrame.Angles(pose.c[4], pose.c[5], pose.c[6])
                elseif #pose.c == 7 then
                    local qx, qy, qz, qw = pose.c[4], pose.c[5], pose.c[6], pose.c[7]
                    cf = cf * CFrame.fromQuaternion(qx, qy, qz, qw)
                end
                seq:AddKeypoint(t/FPS, {[limbName] = cf})
            end
        end
    end

    return seq
end

return function(code)
    return RigShiftToCFrameSequence(code)
end