-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.Init(p2, p3, p4, p5, p6) -- Line: 6
    -- upvalues: u1 (copy)
    local v7 = setmetatable({}, u1);
    v7.Ceive = p2;
    v7.Propertys = p3;
    v7.Request = p4;
    v7.Release = p5;
    v7.Retain = p6;

    return v7;
end;

function u1.Draw(p8, p9, p10, p11, p12) -- Line: 18
    local Ceive = p8.Ceive;

    if not Ceive.Enabled then
        return;
    end;

    local v13 = p9.Position + p9.UpVector * (p11 * 0.5);
    local v14 = p9.Position - p9.UpVector * (p11 * 0.5);
    local v15 = CFrame.lookAt(v13, v13 + p9.UpVector);
    local v16 = CFrame.lookAt(v14, v14 - p9.UpVector);
    local v17 = nil;
    local v18 = nil;
    local v19 = nil;
    local v20 = nil;

    for i = 0, 360, math.floor(360 / p12) do
        local v21 = math.rad(i);
        local v22 = math.sin(v21) * p10;
        local v23 = math.rad(i);
        local v24 = math.cos(v23) * p10;
        local v25 = p9.LookVector * v24 + p9.RightVector * v22;
        local v26 = v15.Position + v25;
        local v27 = v16.Position + v25;
        Ceive.Ray:Draw(v26, v27);
        Ceive.Circle:Draw(CFrame.new(v15.Position) * p9.Rotation * CFrame.Angles(0, math.rad(i), 0), p10, p12 * 0.5, 90, false);
        Ceive.Circle:Draw(CFrame.new(v16.Position) * p9.Rotation * CFrame.Angles(3.141592653589793, math.rad(i), 0), p10, p12 * 0.5, 90, false);

        if v17 then
            Ceive.Ray:Draw(v17, v26);
            Ceive.Ray:Draw(v18, v27);
            v18 = v27;
            v17 = v26;
        else
            v20 = v27;
            v19 = v26;
            v18 = v20;
            v17 = v19;
            local v28 = v20;
            v20 = v18;
            v28 = v19;
            v19 = v17;
            v28 = v18;
            v18 = v20;
            v28 = v17;
        end;
    end;

    Ceive.Ray:Draw(v17, v19);
    Ceive.Ray:Draw(v18, v20);
end;

function u1.Create(p29, p30, p31, p32, p33) -- Line: 88
    local v34 = {
        Enabled = true,
        Destroy = false,
        Transform = p30,
        Radius = p31,
        Length = p32,
        Subdivisions = p33,
        AlwaysOnTop = p29.Propertys.AlwaysOnTop,
        Transparency = p29.Propertys.Transparency,
        Color3 = p29.Propertys.Color3
    };
    p29.Retain(p29, v34);

    return v34;
end;

function u1.Update(p35, p36) -- Line: 106
    local Ceive = p35.Ceive;
    Ceive.PushProperty("AlwaysOnTop", p36.AlwaysOnTop);
    Ceive.PushProperty("Transparency", p36.Transparency);
    Ceive.PushProperty("Color3", p36.Color3);
    p35:Draw(p36.Transform, p36.Radius, p36.Length, p36.Subdivisions);
end;

return u1;