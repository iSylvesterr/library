-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Variables = require(ReplicatedStorage.Library.Variables);
local u1 = Random.new();
local u2 = 0;
local u3 = {};
u3.__index = u3;

function u3.new() -- Line: 208
    -- upvalues: u3 (copy), RunService (copy), u1 (copy)
    local v4 = setmetatable({}, u3);
    v4.Amplitude = 1;
    v4.Frequency = 1;
    v4.FadeInTime = 1;
    v4.FadeOutTime = 1;
    v4.SustainTime = 0;
    v4.Sustain = false;
    v4.PositionInfluence = Vector3.new(1, 1, 1);
    v4.RotationInfluence = Vector3.new(1, 1, 1);
    local v5;

    if RunService:IsRunning() then
        v5 = time;
    else
        v5 = os.clock;
    end;

    v4.TimeFunction = v5;
    v4._timeOffset = u1:NextNumber(-1000000, 1000000);
    v4._startTime = 0;
    v4._running = false;
    v4._signalConnections = {};
    v4._renderBindings = {};

    return v4;
end;

function u3.InverseSquare(p6, p7) -- Line: 259
    local v8 = p7 < 1 and 1 or p7;

    return p6 * (1 / (v8 * v8));
end;

function u3.NextRenderName() -- Line: 275
    -- upvalues: u2 (ref)
    u2 = u2 + 1;

    return ("__shake_%.4i__"):format(u2);
end;

function u3.Start(p9) -- Line: 288
    p9._startTime = p9.TimeFunction();
    p9._running = true;
end;

function u3.Stop(p10) -- Line: 300
    -- upvalues: RunService (copy)
    p10._running = false;

    for _, v in p10._renderBindings do
        RunService:UnbindFromRenderStep(v);
    end;

    table.clear(p10._renderBindings);

    for _, v in p10._signalConnections do
        v:Disconnect();
    end;

    table.clear(p10._signalConnections);
end;

function u3.IsShaking(p11) -- Line: 318
    return p11._running;
end;

function u3.StopSustain(p12) -- Line: 327
    local v13 = p12.TimeFunction();
    p12.Sustain = false;
    p12.SustainTime = v13 - p12._startTime - p12.FadeInTime;
end;

function u3.Update(p14) -- Line: 355
    -- upvalues: Variables (copy)
    local v15 = false;
    local v16 = p14.TimeFunction();
    local v17 = v16 - p14._startTime;
    local v18 = (v16 + p14._timeOffset) / p14.Frequency % 10000;
    local v19 = 1;
    local v20 = v17 >= p14.FadeInTime and 1 or v17 / p14.FadeInTime;

    if not p14.Sustain and p14.FadeInTime + p14.SustainTime < v17 then
        if p14.FadeOutTime == 0 then
            v15 = true;
        else
            v19 = 1 - (v17 - p14.FadeInTime - p14.SustainTime) / p14.FadeOutTime;

            if not p14.Sustain and p14.FadeInTime + p14.SustainTime + p14.FadeOutTime <= v17 then
                v15 = true;
            end;
        end;
    end;

    local v21 = math.noise(v18, 0) / 2;
    local v22 = math.noise(0, v18) / 2;
    local v23 = math.noise(v18, v18) / 2;
    local v24 = Vector3.new(v21, v22, v23) * p14.Amplitude * math.min(v20, v19);

    if v15 then
        p14:Stop();
    end;

    local v25 = p14.PositionInfluence * v24;
    local v26 = p14.RotationInfluence * v24;

    if Variables.IsInteractingWithNpc then
        v25 = Vector3.new(0, 0, 0);
        v26 = Vector3.new(0, 0, 0);
    end;

    return v25, v26, v15;
end;

function u3.OnSignal(u27, p28, u29) -- Line: 421
    local v30 = p28:Connect(function() -- Line: 422
        -- upvalues: u29 (copy), u27 (copy)
        u29(u27:Update());
    end);
    table.insert(u27._signalConnections, v30);

    return v30;
end;

function u3.BindToRenderStep(u31, p32, p33, u34) -- Line: 451
    -- upvalues: RunService (copy)
    RunService:BindToRenderStep(p32, p33, function() -- Line: 452
        -- upvalues: u34 (copy), u31 (copy)
        u34(u31:Update());
    end);
    table.insert(u31._renderBindings, p32);
end;

function u3.Clone(p35) -- Line: 488
    -- upvalues: u3 (copy)
    local v36 = u3.new();

    for _, v in { "Amplitude", "Frequency", "FadeInTime", "FadeOutTime", "SustainTime", "Sustain", "PositionInfluence", "RotationInfluence", "TimeFunction" } do
        v36[v] = p35[v];
    end;

    return v36;
end;

function u3.Destroy(p37) -- Line: 510
    p37:Stop();
end;

return {
    new = u3.new,
    InverseSquare = u3.InverseSquare,
    NextRenderName = u3.NextRenderName
};