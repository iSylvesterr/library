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

    local v13 = p9 * CFrame.Angles(-1.5707963267948966, 0, 0);
    local v14 = v13.Position + v13.UpVector * (p11 * 0.5);
    local v15 = v13.Position + -v13.UpVector * (p11 * 0.5);
    local v16 = CFrame.lookAt(v14, v14 + v13.UpVector);
    local v17 = CFrame.lookAt(v15, v15 - v13.UpVector);
    local v18 = nil;
    local v19 = nil;

    for i = 0, 360, math.floor(360 / p12) do
        local v20 = math.rad(i);
        local v21 = math.sin(v20) * p10;
        local v22 = math.rad(i);
        local v23 = math.cos(v22) * p10;
        local v24 = v17.Position + (v13.LookVector * v23 + v13.RightVector * v21);

        if v18 then
            Ceive.Ray:Draw(v24, v16.Position);
            Ceive.Ray:Draw(v18, v24);
            v18 = v24;
        else
            Ceive.Ray:Draw(v24, v16.Position);
            v19 = v24;
            v18 = v19;
            local v25 = v19;
            v19 = v18;
            v25 = v18;
        end;
    end;

    Ceive.Ray:Draw(v18, v19);
end;

function u1.Create(p26, p27, p28, p29, p30) -- Line: 63
    local v31 = {
        Enabled = true,
        Destroy = false,
        Transform = p27,
        Radius = p28,
        Length = p29,
        Subdivisions = p30,
        AlwaysOnTop = p26.Propertys.AlwaysOnTop,
        Transparency = p26.Propertys.Transparency,
        Color3 = p26.Propertys.Color3
    };
    p26.Retain(p26, v31);

    return v31;
end;

function u1.Update(p32, p33) -- Line: 81
    local Ceive = p32.Ceive;
    Ceive.PushProperty("AlwaysOnTop", p33.AlwaysOnTop);
    Ceive.PushProperty("Transparency", p33.Transparency);
    Ceive.PushProperty("Color3", p33.Color3);
    p32:Draw(p33.Transform, p33.Radius, p33.Length, p33.Subdivisions);
end;

return u1;