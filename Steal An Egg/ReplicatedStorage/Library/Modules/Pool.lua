-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local u1 = {};
u1.__index = u1;

local function DefaultDestructor() -- Line: 8
end;

local u2 = t.optional(t.string);

function u1.new(p3, p4) -- Line: 26
    -- upvalues: t (copy), DefaultDestructor (copy), u1 (copy)
    assert(t.callback(p3));
    local v5 = t.optional(t.callback);
    assert(v5(p4));

    return setmetatable({
        _destroyed = false,
        _index = 1,
        _prevIndex = 0,
        _debugId = nil,
        _constructor = p3,
        _destructor = p4 or DefaultDestructor,
        _unKeyed = {},
        _keyed = {},
        _usedKeys = {},
        _prevUsedKeys = {}
    }, u1);
end;

function u1.Get(p6, p7) -- Line: 44
    -- upvalues: u2 (copy)
    assert(u2(p7));
    assert(not p6._destroyed, "Pool was destroyed");

    if p7 == nil then
        local v8 = p6._unKeyed[p6._index];
        local v9 = v8 == nil;

        if v9 then
            v8 = p6._constructor();
            p6._unKeyed[p6._index] = v8;
        end;

        p6._index = p6._index + 1;

        return v8, v9;
    end;

    local v10 = p6._keyed[p7];
    local v11 = v10 == nil;

    if v11 then
        v10 = p6._constructor();
        p6._keyed[p7] = v10;
    end;

    p6._usedKeys[p7] = true;

    return v10, v11;
end;

function u1._setDebugId(p12, p13) -- Line: 73
    p12._debugId = p13;
end;

function u1.Done(p14) -- Line: 77
    assert(not p14._destroyed, "Pool was destroyed");

    for i = p14._index, p14._prevIndex do
        local v15 = p14._unKeyed[i];
        p14._destructor(v15);
        v15.Parent = nil;
    end;

    p14._prevIndex = p14._index - 1;
    p14._index = 1;

    for i, v in pairs(p14._keyed) do
        if not p14._usedKeys[i] and p14._prevUsedKeys[i] then
            p14._destructor(v);
            v.Parent = nil;
        end;
    end;

    p14._prevUsedKeys = table.clone(p14._usedKeys);
    table.clear(p14._usedKeys);
end;

function u1.Destroy(p16) -- Line: 100
    assert(not p16._destroyed, "Pool was destroyed");

    for i, v in pairs(p16._unKeyed) do
        if i <= p16._prevIndex then
            p16._destructor(v);
        end;

        v:Destroy();
    end;

    for i, v in pairs(p16._keyed) do
        if p16._prevUsedKeys[i] then
            p16._destructor(v);
        end;

        v:Destroy();
    end;

    table.clear(p16._unKeyed);
    table.clear(p16._keyed);
    table.clear(p16._usedKeys);
    table.clear(p16._prevUsedKeys);
    p16._destroyed = true;
end;

return u1;