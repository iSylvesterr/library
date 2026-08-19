-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PerfFlags = require(ReplicatedStorage.SharedModules.Flags.PerfFlags);
local u1 = {};
local u2 = {};
local u3 = nil;

local function SampleColor(p4, p5) -- Line: 74
    for i = 1, #p4 - 1 do
        local v6 = p4[i];
        local v7 = p4[i + 1];

        if v6.Time <= p5 and p5 <= v7.Time then
            local v8 = v7.Time - v6.Time;

            return v6.Value:Lerp(v7.Value, v8 <= 0 and 0 or (p5 - v6.Time) / v8);
        end;
    end;

    return p4[#p4].Value;
end;

local function ShiftColorSequence(p9, p10) -- Line: 89
    -- upvalues: SampleColor (copy)
    local Keypoints = p9.Keypoints;
    local v11 = table.create(20);

    for i = 0, 19 do
        local v12 = i / 19;
        v11[i + 1] = ColorSequenceKeypoint.new(v12, SampleColor(Keypoints, (v12 + p10) % 1));
    end;

    return ColorSequence.new(v11);
end;

local u13 = {};

local function MaybeDisconnect() -- Line: 105
    -- upvalues: u3 (ref), u1 (copy), u2 (copy)
    if u3 and (next(u1) == nil and next(u2) == nil) then
        u3:Disconnect();
        u3 = nil;
    end;
end;

local function Step(p14) -- Line: 112
    -- upvalues: PerfFlags (copy), u1 (copy), u13 (copy), ShiftColorSequence (copy), u2 (copy)
    if PerfFlags.AnimatedGradientsDisabled:Get() then
        return;
    end;

    for i, v in u1 do
        if i.Parent then
            v.Shift = (v.Shift + p14 * v.Speed) % 1;
            i.Color = ShiftColorSequence(v.Base, v.Shift);
        else
            u13:Remove(i);
        end;
    end;

    local v15 = os.clock();

    for i, v in u2 do
        if i.Parent then
            i[v.Property] = Color3.fromHSV(v15 * v.Speed % 1, v.Saturation, v.Value);
        else
            u13:Remove(i);
        end;
    end;
end;

local function EnsureConnected() -- Line: 139
    -- upvalues: u3 (ref), RunService (copy), Step (copy)
    if not u3 then
        u3 = RunService.RenderStepped:Connect(Step);
    end;
end;

function u13.Add(p16, u17, p18) -- Line: 148
    -- upvalues: u1 (copy), u13 (copy), u3 (ref), RunService (copy), Step (copy)
    if typeof(u17) ~= "Instance" or not u17:IsA("UIGradient") then
        return;
    end;

    local v19 = u1[u17];

    if v19 then
        v19.Base = u17.Color;
        v19.Speed = p18 or v19.Speed;

        return;
    end;

    u1[u17] = {
        Shift = 0,
        Base = u17.Color,
        Speed = p18 or 0.5,
        DestroyConn = u17.Destroying:Once(function() -- Line: 162
            -- upvalues: u13 (ref), u17 (copy)
            u13:Remove(u17);
        end)
    };

    if not u3 then
        u3 = RunService.RenderStepped:Connect(Step);
    end;
end;

function u13.AddRainbowColor(p20, u21, p22, p23) -- Line: 173
    -- upvalues: u2 (copy), u13 (copy), u3 (ref), RunService (copy), Step (copy)
    if typeof(u21) ~= "Instance" then
        return;
    end;

    local u24 = p22 or "ImageColor3";
    local v25 = u2[u21];

    if v25 then
        v25.Property = u24;
        v25.Speed = p23 or v25.Speed;

        return;
    end;

    local u26 = Color3.new(1, 1, 1);
    pcall(function() -- Line: 185
        -- upvalues: u26 (ref), u21 (copy), u24 (copy)
        u26 = u21[u24];
    end);
    u2[u21] = {
        Saturation = 1,
        Value = 1,
        Instance = u21,
        Property = u24,
        Speed = p23 or 0.5,
        Original = u26,
        DestroyConn = u21.Destroying:Once(function() -- Line: 196
            -- upvalues: u13 (ref), u21 (copy)
            u13:Remove(u21);
        end)
    };

    if not u3 then
        u3 = RunService.RenderStepped:Connect(Step);
    end;
end;

function u13.Remove(p27, u28) -- Line: 207
    -- upvalues: u1 (copy), u3 (ref), u2 (copy)
    local v29 = u1[u28];

    if v29 then
        v29.DestroyConn:Disconnect();
        u1[u28] = nil;

        if u28.Parent then
            u28.Color = v29.Base;
        end;

        if u3 and (next(u1) == nil and next(u2) == nil) then
            u3:Disconnect();
            u3 = nil;
        end;

        return;
    end;

    local u30 = u2[u28];

    if not u30 then
        return;
    end;

    u30.DestroyConn:Disconnect();
    u2[u28] = nil;

    if u28.Parent then
        pcall(function() -- Line: 225
            -- upvalues: u28 (copy), u30 (copy)
            u28[u30.Property] = u30.Original;
        end);
    end;

    if u3 and (next(u1) == nil and next(u2) == nil) then
        u3:Disconnect();
        u3 = nil;
    end;
end;

return u13;