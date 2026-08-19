-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Signal = require(ReplicatedStorage.Library.Signal);
local Asserts = require(ReplicatedStorage.Library.Asserts);
require(ReplicatedStorage.Library.Util.HumanoidStats.Types.Stats);
local u1 = {};
u1.__index = u1;

function u1.new(p2, p3, p4) -- Line: 24
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.finite(p2);
    Asserts.func(p4);
    local v5 = setmetatable({}, u1);
    v5._base = p2;
    v5._policy = p4;
    v5._modifiers = {};
    v5._value = p2;
    v5.Changed = p3;

    return v5;
end;

function u1.GetBase(p6) -- Line: 44
    return p6._base;
end;

function u1.SetBase(p7, p8) -- Line: 48
    -- upvalues: Asserts (copy)
    Asserts.finite(p8);

    if p7._base == p8 then
        return;
    end;

    p7._base = p8;
    p7:_recalculate();
end;

function u1.AddModifier(p9, p10) -- Line: 59
    -- upvalues: Asserts (copy)
    Asserts.table(p10);
    Asserts.string(p10.id);
    Asserts.cond(p10.type == "positive" and true or p10.type == "malus");
    Asserts.finite(p10.value);

    for _, v in ipairs(p9._modifiers) do
        if v.id == p10.id then
            error(string.format("Modifier with ID \'%s\' already exists", p10.id));
        end;
    end;

    table.insert(p9._modifiers, p10);
    p9:_recalculate();
end;

function u1.RemoveModifier(p11, p12) -- Line: 76
    -- upvalues: Asserts (copy)
    Asserts.string(p12);

    for i, v in ipairs(p11._modifiers) do
        if v.id == p12 then
            table.remove(p11._modifiers, i);
            p11:_recalculate();

            return;
        end;
    end;
end;

function u1.RemoveModifiersBySource(p13, p14) -- Line: 90
    -- upvalues: Asserts (copy)
    Asserts.string(p14);
    local v15 = false;

    for i = #p13._modifiers, 1, -1 do
        if p13._modifiers[i].source == p14 then
            table.remove(p13._modifiers, i);
            v15 = true;
        end;
    end;

    if v15 then
        p13:_recalculate();
    end;
end;

function u1.GetValue(p16) -- Line: 108
    return p16._value;
end;

function u1.GetModifiers(p17) -- Line: 112
    return p17._modifiers;
end;

function u1._recalculate(p18) -- Line: 116
    -- upvalues: Signal (copy)
    local v19 = p18._policy(p18._base, p18._modifiers);

    if math.abs(v19 - p18._value) < 0.001 then
        return;
    end;

    p18._value = v19;
    Signal.Fire(p18.Changed, v19);
end;

return u1;