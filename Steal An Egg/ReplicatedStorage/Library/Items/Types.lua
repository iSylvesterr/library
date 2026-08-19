-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local DeepCopyUnsafe = require(ReplicatedStorage.Library.Functions.DeepCopyUnsafe);
local AbstractItem = require(script.Parent.AbstractItem);
local u1 = {
    Types = {
        Currency = require(script.Parent.CurrencyItem),
        Gear = require(script.Parent.GearItem),
        Brainrot = require(script.Parent.BrainrotItem),
        SpeedPower = require(script.Parent.SpeedPowerItem)
    }
};

function u1.TypeUnchecked(p2) -- Line: 28
    -- upvalues: u1 (copy)
    return u1.Types[p2];
end;

function u1.Type(p3) -- Line: 32
    -- upvalues: u1 (copy)
    local v4 = u1.Types[p3];
    local v5 = `Item type '{p3}' does not exist in ItemTypes.Types`;
    assert(v4, v5);

    return v4;
end;

function u1.AssertTypeName(p6) -- Line: 38
    -- upvalues: u1 (copy)
    local v7 = type(p6) == "string";
    local v8 = `Expected typeName to be a string, got {type(p6)}`;
    assert(v7, v8);
    local v9 = u1.Types[p6];
    local v10 = `Item type '{p6}' does not exist in ItemTypes.Types`;
    assert(v9, v10);

    return nil;
end;

function u1.FromModule(p11, p12) -- Line: 44
    return p11:From(p12);
end;

function u1.From(p13, p14) -- Line: 48
    -- upvalues: u1 (copy)
    return u1.Type(p13):From(p14);
end;

function u1.DecodeNetwork(p15) -- Line: 52
    -- upvalues: u1 (copy)
    return u1.From(p15.class, p15.data):SetUID(p15.uid);
end;

function u1.DecodeNetworkCloned(p16) -- Line: 56
    -- upvalues: u1 (copy), DeepCopyUnsafe (copy)
    return u1.From(p16.class, DeepCopyUnsafe(p16.data)):SetUID(p16.uid);
end;

function u1.DecodeUnpacked(p17) -- Line: 60
    -- upvalues: u1 (copy)
    local v18 = {};

    for i, v in pairs(p17) do
        local v19 = u1.TypeUnchecked(i);

        if v19 then
            for i2, v2 in pairs(v) do
                local v20 = v19:From(v2):SetUID(i2);
                table.insert(v18, v20);
            end;
        end;
    end;

    return v18;
end;

function u1.EncodePacked(p21) -- Line: 75
    -- upvalues: AbstractItem (copy)
    local v22 = {};

    for _, v in ipairs(p21) do
        local Name = v.Class.Name;
        local v23 = v22[Name];

        if not v23 then
            v23 = {};
            v22[Name] = v23;
        end;

        local v24 = v:GetOptionalUID() or AbstractItem.GenerateUID();
        local v25 = not v23[v24];
        local v26 = `Duplicate UID found for item of type '{Name}': {v24}`;
        assert(v25, v26);
        v23[v24] = v:GetData();
    end;

    return v22;
end;

function u1.Pack(p27) -- Line: 91
    -- upvalues: AbstractItem (copy)
    local v28 = {};

    for _, v in ipairs(p27) do
        local Name = v.Class.Name;
        local v29 = v28[Name];

        if not v29 then
            v29 = {};
            v28[Name] = v29;
        end;

        local v30 = v:GetOptionalUID() or AbstractItem.GenerateUID();
        local v31 = not v29[v30];
        local v32 = `Duplicate UID found for item of type '{Name}': {v30}`;
        assert(v31, v32);
        v29[v30] = v;
    end;

    return v28;
end;

function u1.Unpack(p33) -- Line: 107
    local v34 = {};

    for _, v in pairs(p33) do
        for _, v2 in pairs(v) do
            table.insert(v34, v2);
        end;
    end;

    return v34;
end;

u1.AssertUniqueItems = AbstractItem.AssertUniqueItems;

return u1;