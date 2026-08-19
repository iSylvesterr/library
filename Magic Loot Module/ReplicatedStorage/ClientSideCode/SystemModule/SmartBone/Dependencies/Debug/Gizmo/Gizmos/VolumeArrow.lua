-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.Init(p2, p3, p4, p5, p6, p7) -- Line: 4
    -- upvalues: u1 (copy)
    local v8 = setmetatable({}, u1);
    v8.Ceive = p2;
    v8.Propertys = p3;
    v8.Request = p4;
    v8.Release = p5;
    v8.Retain = p6;
    v8.Register = p7;

    return v8;
end;

function u1.Draw(p9, p10, p11, p12, p13, p14, p15) -- Line: 17
    local Ceive = p9.Ceive;

    if not Ceive.Enabled then
        return;
    end;

    local v16 = CFrame.lookAt(p11 - (p11 - p10).Unit * (p14 * 0.5), p11);

    if p15 == true then
        local Position = v16.Position;
        local Magnitude = (Position - p10).Magnitude;
        local v17 = CFrame.lookAt((p10 + Position) * 0.5, p11);
        Ceive.VolumeCylinder:Draw(v17, p12, Magnitude);
    else
        Ceive.Ray:Draw(p10, p11);
    end;

    Ceive.VolumeCone:Draw(v16, p13, p14);
    p9.Ceive.ScheduleCleaning();
end;

function u1.Create(p18, p19, p20, p21, p22, p23, p24) -- Line: 40
    local v25 = {
        Enabled = true,
        Destroy = false,
        Origin = p19,
        End = p20,
        CylinderRadius = p21,
        ConeRadius = p22,
        Length = p23,
        UseCylinder = p24,
        AlwaysOnTop = p18.Propertys.AlwaysOnTop,
        Transparency = p18.Propertys.Transparency,
        Color3 = p18.Propertys.Color3
    };
    p18.Retain(p18, v25);

    return v25;
end;

function u1.Update(p26, p27) -- Line: 60
    local Ceive = p26.Ceive;
    Ceive.PushProperty("AlwaysOnTop", p27.AlwaysOnTop);
    Ceive.PushProperty("Transparency", p27.Transparency);
    Ceive.PushProperty("Color3", p27.Color3);
    p26:Draw(p27.Origin, p27.End, p27.Radius, p27.Length, p27.UseCylinder);
end;

return u1;