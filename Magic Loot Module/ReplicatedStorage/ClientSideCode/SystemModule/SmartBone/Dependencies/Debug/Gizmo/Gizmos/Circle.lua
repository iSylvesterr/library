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

    if Ceive.Enabled then
        local v14 = nil;
        local v15 = 0;
        local v16 = nil;

        for i = 0, p12, math.floor(p12 / p11) do
            local v17 = math.rad(i);
            local v18 = math.sin(v17) * p10;
            local v19 = math.rad(i);
            local v20 = math.cos(v19) * p10;
            local v21 = p9.Position + (p9.UpVector * v20 + p9.RightVector * v18);

            if v14 == nil then
                v16 = v21;
                v15 = i;
                v14 = v16;
                local v22 = v16;
                v16 = v14;
                v22 = v14;
            else
                Ceive.Ray:Draw(v14, v21);
                v15 = i;
                v14 = v21;
            end;
        end;

        if v15 ~= p12 then
            local v23 = math.rad(p12);
            local v24 = math.sin(v23) * p10;
            local v25 = math.rad(p12);
            local v26 = math.cos(v25) * p10;
            Ceive.Ray:Draw(v14, p9.Position + (p9.UpVector * v26 + p9.RightVector * v24));
        end;

        if p13 ~= false then
            Ceive.Ray:Draw(v14, v16);
        end;

        return v14;
    end;
end;

function u1.Create(p27, p28, p29, p30, p31, p32) -- Line: 64
    local v33 = {
        Enabled = true,
        Destroy = false,
        Transform = p28,
        Radius = p29,
        Subdivisions = p30,
        Angle = p31,
        ConnectToStart = p32,
        AlwaysOnTop = p27.Propertys.AlwaysOnTop,
        Transparency = p27.Propertys.Transparency,
        Color3 = p27.Propertys.Color3
    };
    p27.Retain(p27, v33);

    return v33;
end;

function u1.Update(p34, p35) -- Line: 83
    local Ceive = p34.Ceive;
    Ceive.PushProperty("AlwaysOnTop", p35.AlwaysOnTop);
    Ceive.PushProperty("Transparency", p35.Transparency);
    Ceive.PushProperty("Color3", p35.Color3);
    p34:Draw(p35.Transform, p35.Radius, p35.Subdivisions, p35.Angle, p35.ConnectToStart);
end;

return u1;