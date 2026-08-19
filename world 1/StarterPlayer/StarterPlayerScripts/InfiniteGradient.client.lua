-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PerfFlags = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("Flags"):WaitForChild("PerfFlags"));
local u1 = table.create(10);

local function sampleColor(p2, p3) -- Line: 15
    for i = 1, #p2 - 1 do
        local v4 = p2[i];
        local v5 = p2[i + 1];

        if v4.Time <= p3 and p3 <= v5.Time then
            return v4.Value:Lerp(v5.Value, (p3 - v4.Time) / (v5.Time - v4.Time));
        end;
    end;

    return p2[#p2].Value;
end;

local function shiftColorSequence(p6, p7) -- Line: 26
    -- upvalues: u1 (copy), sampleColor (copy)
    local Keypoints = p6.Keypoints;

    for i = 0, 9 do
        local v8 = i / 9;
        u1[i + 1] = ColorSequenceKeypoint.new(v8, sampleColor(Keypoints, (v8 + p7) % 1));
    end;

    return ColorSequence.new(u1);
end;

local u9 = {};
local u10 = 0;
RunService.Heartbeat:Connect(function(p11) -- Line: 50
    -- upvalues: PerfFlags (copy), u10 (ref), u9 (copy), shiftColorSequence (copy)
    if PerfFlags.AnimatedGradientsDisabled:Get() then
        return;
    end;

    u10 = u10 + p11;

    if u10 < 0.05 then
        return;
    end;

    local v12 = u10;
    u10 = 0;

    for i, v in u9 do
        if i.Parent then
            v.shift = (v.shift + v12 * 0.5) % 1;
            i.Color = shiftColorSequence(v.baseSequence, v.shift);
        else
            u9[i] = nil;
        end;
    end;
end);

local function startScrolling(u13) -- Line: 42
    -- upvalues: u9 (copy)
    if u9[u13] then
        return;
    end;

    u9[u13] = {
        shift = 0,
        baseSequence = u13.Color
    };
    u13.Destroying:Once(function() -- Line: 45
        -- upvalues: u9 (ref), u13 (copy)
        u9[u13] = nil;
    end);
end;

for _, v in CollectionService:GetTagged("InfiniteGradient") do
    startScrolling(v);
end;

CollectionService:GetInstanceAddedSignal("InfiniteGradient"):Connect(function(p14) -- Line: 71
    -- upvalues: startScrolling (copy)
    if p14:IsA("UIGradient") then
        startScrolling(p14);
    end;
end);