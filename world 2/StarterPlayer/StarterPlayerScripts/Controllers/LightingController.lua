-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 2
};
local Lighting = game:GetService("Lighting");
local TweenService = game:GetService("TweenService");
local u2 = nil;
local u3 = {
    Ambient = Lighting.Ambient,
    Brightness = Lighting.Brightness,
    ColorShift_Bottom = Lighting.ColorShift_Bottom,
    ColorShift_Top = Lighting.ColorShift_Top,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    ClockTime = Lighting.ClockTime,
    EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale
};
local u4 = table.clone(u3);

function v1.GetDefault(p5) -- Line: 19
    -- upvalues: u3 (copy)
    return u3;
end;

function v1.GetCurrentTarget(p6) -- Line: 22
    -- upvalues: u4 (copy)
    return u4;
end;

function v1.TransitionTo(p7, p8, p9) -- Line: 26
    -- upvalues: u2 (ref), u4 (copy), TweenService (copy), Lighting (copy)
    if u2 then
        u2:Cancel();
        u2:Destroy();
        u2 = nil;
    end;

    for i, v in p8 do
        u4[i] = v;
    end;

    local u10 = TweenService:Create(Lighting, TweenInfo.new(p9 or 3, Enum.EasingStyle.Sine), p8);
    u2 = u10;
    u10.Completed:Once(function() -- Line: 39
        -- upvalues: u2 (ref), u10 (copy)
        if u2 == u10 then
            u2 = nil;
        end;

        u10:Destroy();
    end);
    u10:Play();
end;

function v1.SetImmediate(p11, p12) -- Line: 46
    -- upvalues: u2 (ref), u4 (copy), Lighting (copy)
    if u2 then
        u2:Cancel();
        u2:Destroy();
        u2 = nil;
    end;

    for i, v in p12 do
        u4[i] = v;
        Lighting[i] = v;
    end;
end;

function v1.Init(p13) -- Line: 60
end;

function v1.Start(p14) -- Line: 61
end;

return v1;