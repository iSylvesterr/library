-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.Init(p2, p3, p4, p5, p6) -- Line: 4
    -- upvalues: u1 (copy)
    local v7 = setmetatable({}, u1);
    v7.Ceive = p2;
    v7.Propertys = p3;
    v7.Request = p4;
    v7.Release = p5;
    v7.Retain = p6;

    return v7;
end;

function u1.Draw(p8, p9, p10, p11, p12, p13) -- Line: 16
    local Ceive = p8.Ceive;

    if not Ceive.Enabled then
        return;
    end;

    Ceive.Ray:Draw(p9, p10);
    local v14 = CFrame.lookAt(p10 + (p9 - p10).Unit * (p12 * 0.5), p10);
    Ceive.Cone:Draw(v14, p11, p12, p13);
end;

function u1.Create(p15, p16, p17, p18, p19, p20) -- Line: 29
    local v21 = {
        Enabled = true,
        Destroy = false,
        Origin = p16,
        End = p17,
        Radius = p18,
        Length = p19,
        Subdivisions = p20,
        AlwaysOnTop = p15.Propertys.AlwaysOnTop,
        Transparency = p15.Propertys.Transparency,
        Color3 = p15.Propertys.Color3
    };
    p15.Retain(p15, v21);

    return v21;
end;

function u1.Update(p22, p23) -- Line: 48
    local Ceive = p22.Ceive;
    Ceive.PushProperty("AlwaysOnTop", p23.AlwaysOnTop);
    Ceive.PushProperty("Transparency", p23.Transparency);
    Ceive.PushProperty("Color3", p23.Color3);
    p22:Draw(p23.Origin, p23.End, p23.Radius, p23.Length, p23.Subdivisions);
end;

return u1;