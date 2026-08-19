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

function u1.Draw(p8, u9, p10, p11) -- Line: 16
    local Ceive = p8.Ceive;

    if not Ceive.Enabled then
        return;
    end;

    local v12 = CFrame.lookAt(u9, u9 + p10);
    local v13 = p11 * Vector3.new(1, 1, 0) * 0.5;
    (function(p14, p15, p16) -- Line: 35, Name: CalculateZFace
        -- upvalues: u9 (copy), Ceive (copy)
        local v17 = u9 + (p14 - p15 + p16);
        local v18 = u9 + (p14 + p15 + p16);
        local v19 = u9 + (-p14 - p15 + p16);
        local v20 = u9 + (-p14 + p15 + p16);
        Ceive.Ray:Draw(v17, v18);
        Ceive.Ray:Draw(v17, v19);
        Ceive.Ray:Draw(v18, v20);
        Ceive.Ray:Draw(v18, v19);
        Ceive.Ray:Draw(v19, v20);
    end)(v12.UpVector * v13.Y, v12.RightVector * v13.X, v12.LookVector * v13.Z);
end;

function u1.Create(p21, p22, p23, p24) -- Line: 53
    local v25 = {
        Enabled = true,
        Destroy = false,
        Position = p22,
        Normal = p23,
        Size = p24,
        AlwaysOnTop = p21.Propertys.AlwaysOnTop,
        Transparency = p21.Propertys.Transparency,
        Color3 = p21.Propertys.Color3
    };
    p21.Retain(p21, v25);

    return v25;
end;

function u1.Update(p26, p27) -- Line: 70
    local Ceive = p26.Ceive;
    Ceive.PushProperty("AlwaysOnTop", p27.AlwaysOnTop);
    Ceive.PushProperty("Transparency", p27.Transparency);
    Ceive.PushProperty("Color3", p27.Color3);
    p26:Draw(p27.Position, p27.Normal, p27.Size);
end;

return u1;