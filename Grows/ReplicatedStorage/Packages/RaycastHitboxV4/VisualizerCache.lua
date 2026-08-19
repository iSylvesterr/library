-- Decompiled with Potassium's decompiler.

local u1 = Color3.fromRGB(255, 0, 0);
local u2 = CFrame.new(0, (1 / 0), 0);
local u3 = {};
u3.__index = u3;
u3.__type = "RaycastHitboxVisualizerCache";
u3._AdornmentInUse = {};
u3._AdornmentInReserve = {};

function u3._CreateAdornment(p4) -- Line: 25
    -- upvalues: u1 (copy), u2 (copy)
    local LineHandleAdornment = Instance.new("LineHandleAdornment");
    LineHandleAdornment.Name = "_RaycastHitboxDebugLine";
    LineHandleAdornment.Color3 = u1;
    LineHandleAdornment.Thickness = 4;
    LineHandleAdornment.Length = 0;
    LineHandleAdornment.CFrame = u2;
    LineHandleAdornment.Adornee = workspace.Terrain;
    LineHandleAdornment.Parent = workspace.Terrain;

    return {
        LastUse = 0,
        Adornment = LineHandleAdornment
    };
end;

function u3.GetAdornment(p5) -- Line: 44
    -- upvalues: u3 (copy)
    if #u3._AdornmentInReserve <= 0 then
        local v6 = u3:_CreateAdornment();
        table.insert(u3._AdornmentInReserve, v6);
    end;

    local v7 = table.remove(u3._AdornmentInReserve, 1);

    if v7 then
        v7.Adornment.Visible = true;
        v7.LastUse = os.clock();
        table.insert(u3._AdornmentInUse, v7);
    end;

    return v7;
end;

function u3.ReturnAdornment(p8, p9) -- Line: 64
    -- upvalues: u2 (copy), u3 (copy)
    p9.Adornment.Length = 0;
    p9.Adornment.Visible = false;
    p9.Adornment.CFrame = u2;
    table.insert(u3._AdornmentInReserve, p9);
end;

function u3.Clear(p10) -- Line: 74
    -- upvalues: u3 (copy)
    for i = #u3._AdornmentInReserve, 1, -1 do
        if u3._AdornmentInReserve[i].Adornment then
            u3._AdornmentInReserve[i].Adornment:Destroy();
        end;

        table.remove(u3._AdornmentInReserve, i);
    end;
end;

return u3;