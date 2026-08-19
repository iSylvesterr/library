-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local u1 = {};
local u2 = {
    Changed = require(ReplicatedStorage.Library.Modules.Packages.Signal).new()
};

function u2.Set(p3, p4, p5) -- Line: 21
    -- upvalues: Asserts (copy), u1 (copy), u2 (copy)
    Asserts.string(p3);
    Asserts.string(p4);
    Asserts.Instance(p5);
    local v6 = u1[p3];

    if v6 == nil then
        v6 = {};
        u1[p3] = v6;
    end;

    v6[p4] = p5;
    u2.Changed:Fire(p3, p4, p5);
end;

function u2.Get(p7, p8) -- Line: 34
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.string(p7);
    Asserts.string(p8);
    local v9 = u1[p7];
    local v10;

    if v9 == nil then
        v10 = nil;
    else
        v10 = v9[p8];
    end;

    if v10 == nil or v10.Parent == nil then
        return nil;
    end;

    return v10;
end;

function u2.Require(p11, p12) -- Line: 42
    -- upvalues: u2 (copy)
    local v13 = u2.Get(p11, p12);
    local v14 = `Missing runtime instance "{p11}/{p12}"`;
    assert(v13 ~= nil, v14);

    return v13;
end;

function u2.Clear(p15, p16) -- Line: 48
    -- upvalues: Asserts (copy), u1 (copy), u2 (copy)
    Asserts.string(p15);
    Asserts.optional.string(p16);

    if p16 ~= nil then
        local v17 = u1[p15];

        if v17 ~= nil and v17[p16] ~= nil then
            v17[p16] = nil;
            u2.Changed:Fire(p15, p16, nil);
        end;

        return;
    end;

    if u1[p15] == nil then
        return;
    end;

    u1[p15] = nil;
    u2.Changed:Fire(p15, nil, nil);
end;

return u2;