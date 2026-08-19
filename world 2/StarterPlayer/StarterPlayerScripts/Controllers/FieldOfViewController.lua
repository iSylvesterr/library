-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 0
};
local TweenService = game:GetService("TweenService");
local u2 = 70;
local u3 = 0;
local u4 = 0;
local u5 = nil;

local function getCurrentCamera() -- Line: 21
    return workspace.CurrentCamera;
end;

local function getTargetFOV() -- Line: 25
    -- upvalues: u2 (ref), u3 (ref), u4 (ref)
    return u2 + u3 + u4;
end;

local function applyFOV(p6, p7) -- Line: 29
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), TweenService (copy)
    local CurrentCamera = workspace.CurrentCamera;

    if not CurrentCamera then
        return;
    end;

    local v8 = u2 + u3 + u4;

    if u5 then
        u5:Cancel();
        u5:Destroy();
        u5 = nil;
    end;

    if p6 then
        CurrentCamera.FieldOfView = v8;

        return;
    end;

    local u9 = TweenService:Create(CurrentCamera, TweenInfo.new(p7 or 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        FieldOfView = v8
    });
    u5 = u9;
    u9.Completed:Once(function() -- Line: 47
        -- upvalues: u5 (ref), u9 (copy)
        if u5 == u9 then
            u5 = nil;
        end;

        u9:Destroy();
    end);
    u9:Play();
end;

function v1.GetBaseFOV(p10) -- Line: 59
    -- upvalues: u2 (ref)
    return u2;
end;

function v1.SetBaseFOV(p11, p12, p13, p14) -- Line: 63
    -- upvalues: u2 (ref), u3 (ref), applyFOV (copy)
    u2 = p12;
    u3 = 0;
    applyFOV(p13, p14);
end;

function v1.GetAdjuster(p15) -- Line: 69
    -- upvalues: u3 (ref)
    return u3;
end;

function v1.SetAdjuster(p16, p17, p18) -- Line: 73
    -- upvalues: u3 (ref), applyFOV (copy)
    u3 = p17;
    applyFOV(p18);
end;

function v1.GetTargetFOV(p19) -- Line: 79
    -- upvalues: u2 (ref), u3 (ref), u4 (ref)
    return u2 + u3 + u4;
end;

function v1.GetCurrentFOV(p20) -- Line: 83
    -- upvalues: u2 (ref)
    local CurrentCamera = workspace.CurrentCamera;

    return CurrentCamera and CurrentCamera.FieldOfView or u2;
end;

function v1.ClearAdjuster(p21, p22) -- Line: 88
    -- upvalues: u3 (ref), applyFOV (copy)
    u3 = 0;
    applyFOV(p22);
end;

function v1.GetPunch(p23) -- Line: 94
    -- upvalues: u4 (ref)
    return u4;
end;

function v1.SetPunch(p24, p25) -- Line: 100
    -- upvalues: u4 (ref), u2 (ref), u3 (ref), u5 (ref)
    u4 = p25;
    local CurrentCamera = workspace.CurrentCamera;

    if not CurrentCamera then
        return;
    end;

    if u5 then
        u5:Cancel();
        u5:Destroy();
        u5 = nil;
    end;

    CurrentCamera.FieldOfView = u2 + u3 + u4;
end;

function v1.Reset(p26, p27) -- Line: 105
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), applyFOV (copy)
    u2 = 70;
    u3 = 0;
    u4 = 0;
    applyFOV(p27);
end;

function v1.Init(p28) -- Line: 117
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref)
    u2 = 70;
    local CurrentCamera = workspace.CurrentCamera;

    if CurrentCamera then
        CurrentCamera.FieldOfView = u2;
    end;

    workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 123
        -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref)
        local CurrentCamera2 = workspace.CurrentCamera;

        if not CurrentCamera2 then
            return;
        end;

        if u5 then
            u5:Cancel();
            u5:Destroy();
            u5 = nil;
        end;

        CurrentCamera2.FieldOfView = u2 + u3 + u4;
    end);
end;

function v1.Start(p29) -- Line: 128
end;

return v1;