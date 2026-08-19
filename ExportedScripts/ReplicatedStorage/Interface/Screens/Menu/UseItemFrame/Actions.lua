-- Decompiled with Potassium's decompiler.

local v1 = {};
game:GetService("ReplicatedStorage");
require(script.Types);
local AttachCharm = require(script.AttachCharm);
local u2 = {};

function v1.Register(p3) -- Line: 41
    -- upvalues: u2 (copy)
    if u2[p3.ActionType] then
        warn((`[Actions] Action "{p3.ActionType}" is already registered`));

        return;
    end;

    u2[p3.ActionType] = p3;
end;

function v1.Get(p4) -- Line: 52
    -- upvalues: u2 (copy)
    return u2[p4];
end;

function v1.Has(p5) -- Line: 59
    -- upvalues: u2 (copy)
    return u2[p5] ~= nil;
end;

function v1.GetAllTypes() -- Line: 66
    -- upvalues: u2 (copy)
    local v6 = {};

    for i, _ in pairs(u2) do
        table.insert(v6, i);
    end;

    return v6;
end;

function v1.InitializeAll() -- Line: 77
    -- upvalues: u2 (copy)
    for _, v in pairs(u2) do
        if v.Initialize then
            v.Initialize();
        end;
    end;
end;

function v1.DestroyAll() -- Line: 88
    -- upvalues: u2 (copy)
    for _, v in pairs(u2) do
        if v.Destroy then
            v.Destroy();
        end;
    end;
end;

v1.Register(AttachCharm);

return v1;