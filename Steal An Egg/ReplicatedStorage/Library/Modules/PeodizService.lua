-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local u1 = {};
local u2 = {};
u2.__index = u2;
local Functions = require(script.Functions);

function u2.new(p3, p4) -- Line: 8
    -- upvalues: u2 (copy), Functions (copy), u1 (copy)
    local v5 = setmetatable({}, u2);
    v5.Type = "Heartbeat";
    v5.LifeTime = p3.Time or 1;
    v5.Tween = p3.Tween or nil;

    if p4 then
        v5.Function = p4;
        v5.YieldEvent = Instance.new("BindableEvent");
    end;

    if Functions[v5.Type] then
        v5.UpdateFunction = Functions[v5.Type];
    end;

    table.insert(u1, v5);
    local YieldEvent = v5.YieldEvent;

    if not (p4 and YieldEvent) then
        return v5;
    end;

    YieldEvent.Event:Wait();
    YieldEvent:Destroy();
end;

function u2.Heartbeat(p6, p7) -- Line: 36
    -- upvalues: u2 (copy), Functions (copy), u1 (copy)
    local v8 = setmetatable({}, u2);
    v8.Type = "Heartbeat";
    v8.LifeTime = p6.Time or 1;
    v8.NoYield = true;
    v8.Tween = p6.Tween or nil;

    if p7 then
        v8.Function = p7;
    end;

    if Functions[v8.Type] then
        v8.UpdateFunction = Functions[v8.Type];
    end;

    table.insert(u1, v8);

    return v8;
end;

function u2.HeartbeatWait(p9, p10) -- Line: 55
    -- upvalues: u2 (copy), Functions (copy), u1 (copy)
    local v11 = setmetatable({}, u2);
    v11.Type = "HeartbeatWait";
    v11.LifeTime = p9.Time or 1;

    if p9.WaitTime and p9.WaitTime <= 0 then
        p9.WaitTime = 0.016666666666666666;
    end;

    p9.WaitTime = p9.WaitTime or 0.016666666666666666;
    v11.WaitTime = p9.WaitTime;
    v11.Tween = p9.Tween or nil;

    if p10 then
        v11.Function = p10;
        v11.YieldEvent = Instance.new("BindableEvent");
    end;

    if Functions[v11.Type] then
        v11.UpdateFunction = Functions[v11.Type];
    end;

    table.insert(u1, v11);
    local YieldEvent = v11.YieldEvent;

    if not (p10 and YieldEvent) then
        return v11;
    end;

    YieldEvent.Event:Wait();
    YieldEvent:Destroy();
end;

function u2.CustomForLoop(p12, p13) -- Line: 89
    -- upvalues: u2 (copy), Functions (copy), u1 (copy)
    local v14 = setmetatable({}, u2);
    v14.Type = "CustomForLoop";

    if p12.WaitTime and p12.WaitTime <= 0 then
        p12.WaitTime = 0.016666666666666666;
    end;

    p12.WaitTime = p12.WaitTime or 0.016666666666666666;
    p12.Step = p12.Step or 10;
    p12.Start = p12.Start or 0;
    p12.End = p12.End or 1;
    v14.Step = p12.Step;
    v14.Start = p12.Start;
    v14.End = p12.End;
    v14.WaitTime = p12.WaitTime;
    v14.LifeTime = v14.End / v14.Step * v14.WaitTime;
    v14.Tween = p12.Tween or nil;
    v14.CurrentWaitTime = p12.WaitTime;
    v14.CurrentTime = v14.Start / v14.End;

    if p13 then
        v14.Function = p13;
        v14.YieldEvent = Instance.new("BindableEvent");
    end;

    if Functions[v14.Type] then
        v14.UpdateFunction = Functions[v14.Type];
    end;

    table.insert(u1, v14);
    local YieldEvent = v14.YieldEvent;

    if not (p13 and YieldEvent) then
        return v14;
    end;

    YieldEvent.Event:Wait();
    YieldEvent:Destroy();
end;

function u2.CustomForceForLoop(p15, p16) -- Line: 132
    -- upvalues: u2 (copy), Functions (copy), u1 (copy)
    local v17 = setmetatable({}, u2);
    v17.Type = "CustomForceForLoop";

    if p15.WaitTime and p15.WaitTime <= 0 then
        p15.WaitTime = 0.016666666666666666;
    end;

    p15.WaitTime = p15.WaitTime or 0.016666666666666666;
    p15.Step = p15.Step or 10;
    p15.Start = p15.Start or 0;
    p15.End = p15.End or 1;
    v17.StepData = {};
    v17.Step = p15.Step;
    v17.Start = p15.Start;
    v17.End = p15.End;
    v17.WaitTime = p15.WaitTime;
    v17.LifeTime = v17.End / v17.Step * v17.WaitTime;
    v17.Tween = p15.Tween or nil;
    v17.CurrentWaitTime = p15.WaitTime;
    v17.CurrentTime = v17.Start / v17.End;

    if p16 then
        v17.Function = p16;
        v17.YieldEvent = Instance.new("BindableEvent");
    end;

    if Functions[v17.Type] then
        v17.UpdateFunction = Functions[v17.Type];
    end;

    table.insert(u1, v17);
    local YieldEvent = v17.YieldEvent;

    if not (p16 and YieldEvent) then
        return v17;
    end;

    YieldEvent.Event:Wait();
    YieldEvent:Destroy();
end;

function u2.ForLoop(p18, p19) -- Line: 176
    -- upvalues: u2 (copy), Functions (copy), u1 (copy)
    local v20 = setmetatable({}, u2);
    v20.Type = "ForLoop";

    if p18.WaitTime and p18.WaitTime <= 0 then
        p18.WaitTime = 0.016666666666666666;
    end;

    p18.WaitTime = p18.WaitTime or 0.016666666666666666;
    p18.Step = p18.Step or 10;

    if p18.Step < 0 then
        p18.Step = 1;
    end;

    v20.WaitTime = p18.WaitTime;
    v20.LifeTime = p18.WaitTime * p18.Step;
    v20.Tween = p18.Tween or nil;

    if p19 then
        v20.Function = p19;
        v20.YieldEvent = Instance.new("BindableEvent");
    end;

    if Functions[v20.Type] then
        v20.UpdateFunction = Functions[v20.Type];
    end;

    table.insert(u1, v20);
    local YieldEvent = v20.YieldEvent;

    if not (p19 and YieldEvent) then
        return v20;
    end;

    YieldEvent.Event:Wait();
    YieldEvent:Destroy();
end;

function u2.ForceForLoop(p21, p22) -- Line: 215
    -- upvalues: u2 (copy), Functions (copy), u1 (copy)
    local v23 = setmetatable({}, u2);
    v23.Type = "ForceForLoop";

    if p21.WaitTime and p21.WaitTime <= 0 then
        p21.WaitTime = 0.016666666666666666;
    end;

    p21.WaitTime = p21.WaitTime or 0.016666666666666666;
    p21.Step = p21.Step or 10;
    v23.StepData = {};
    v23.Step = p21.Step;
    v23.WaitTime = p21.WaitTime;
    v23.LifeTime = p21.WaitTime * p21.Step;
    v23.Tween = p21.Tween or nil;

    if p22 then
        v23.Function = p22;
        v23.YieldEvent = Instance.new("BindableEvent");
    end;

    if Functions[v23.Type] then
        v23.UpdateFunction = Functions[v23.Type];
    end;

    table.insert(u1, v23);
    local YieldEvent = v23.YieldEvent;

    if not (p22 and YieldEvent) then
        return v23;
    end;

    YieldEvent.Event:Wait();
    YieldEvent:Destroy();
end;

function u2.Update(p24, p25) -- Line: 253
    p24.CurrentTime = p24.CurrentTime or 0;
    p24.CurrentWaitTime = p24.CurrentWaitTime or 0;
    p24.WaitTime = p24.WaitTime or 0.016666666666666666;
    p24.LifeTime = p24.LifeTime or 1;
    p24.CurrentTime = math.min(p24.CurrentTime + p25 / p24.LifeTime, 1);
    p24.CurrentWaitTime = p24.CurrentWaitTime + p25;

    if p24.UpdateFunction then
        p24:UpdateFunction(p25);
    end;

    if p24 and (p24.CurrentTime == 1 and not p24.Finished) then
        p24:Destroy();
    end;
end;

function u2.Connect(p26, p27) -- Line: 271
    if p27 then
        if not p26.Function then
            p26.Function = p27;
        end;

        if not (p26.YieldEvent or p26.NoYield) then
            local BindableEvent = Instance.new("BindableEvent");
            p26.YieldEvent = BindableEvent;
            BindableEvent.Event:Wait();
            BindableEvent:Destroy();
        end;
    end;
end;

function u2.Destroy(p28) -- Line: 285
    -- upvalues: u1 (copy)
    if p28.Finished then
        return;
    end;

    p28.Finished = true;

    if p28.YieldEvent then
        p28.YieldEvent:Fire();
    end;

    for i, v in pairs(u1) do
        if v == p28 then
            table.remove(u1, i);

            for i2, _ in pairs(p28) do
                p28[i2] = nil;
            end;

            table.clear(p28);

            return;
        end;
    end;
end;

RunService.Heartbeat:Connect(function(p29) -- Line: 308
    -- upvalues: u1 (copy)
    for _, v in pairs(u1) do
        v:Update(p29);
    end;
end);

return u2;