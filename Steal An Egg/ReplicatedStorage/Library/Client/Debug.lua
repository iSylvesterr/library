-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = {};

function v1.Track(p3, p4, p5) -- Line: 4
    -- upvalues: u2 (copy)
    if u2[p4] == nil then
        u2[p4] = {};
    end;

    u2[p4][p3] = p5;
end;

function v1.Cancel(p6, p7) -- Line: 11
    -- upvalues: u2 (copy)
    if not u2[p7] then
        return;
    end;

    u2[p7][p6] = nil;
    local v8, v9, v10;
    v8, v9, v10 = pairs(u2[p7]);
    local v11, v12, v13;

    if type(v8) == "function" then
        v11, v12 = v8(v9, v13);
    else
        v11, v12 = next(v8, v13);
    end;

    v13 = v11;
end;

function v1.Get() -- Line: 21
    -- upvalues: u2 (copy)
    return u2;
end;

return v1;