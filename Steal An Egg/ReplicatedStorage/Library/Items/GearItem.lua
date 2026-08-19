-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Gears = require(ReplicatedStorage.Directory.Gears);
require(ReplicatedStorage.Directory.Gears.Types.Interface);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local AbstractItem = require(script.Parent.AbstractItem);
local Signal = require(ReplicatedStorage.Library.Signal);
local u1 = {
    Directory = Gears.Directory
};
local v2 = setmetatable({}, {
    __index = AbstractItem.Prototype
});
local v3, u4 = AbstractItem.Define("Gear", script, u1);
v2.Class = v3;
u1.Class = v3;
u1.Prototype = v2;

function v2.AbstractPopulate(p5) -- Line: 56
end;

function v2.GetId(p6) -- Line: 58
    return p6._data.id;
end;

function v2.SetId(p7, p8) -- Line: 62
    -- upvalues: Gears (copy)
    local v9 = Gears.Directory[p8];
    local v10 = `Gear not found in directory for ID: {p8}`;
    assert(v9, v10);
    p7._data.id = p8;

    return p7;
end;

function v2.SetDirectory(p11, p12) -- Line: 68
    -- upvalues: Gears (copy)
    local v13 = Gears.Directory[p12._id] == p12;
    local v14 = `Gear not found in directory for ID: {p12._id}`;
    assert(v13, v14);

    return p11:SetId(p12._id);
end;

function v2.Directory(p15) -- Line: 73
    -- upvalues: Gears (copy)
    return Gears.Directory[p15._data.id];
end;

function v2.GetName(p16) -- Line: 77
    return p16:Directory().DisplayName or "";
end;

function v2.GetRarity(p17) -- Line: 81
    -- upvalues: Rarity (copy)
    local Rarity2 = p17:Directory().Rarity;

    return Rarity.Rarities[Rarity2] or Rarity.Rarities.Basic;
end;

function v2.GetIcon(p18) -- Line: 86
    return p18:Directory().Icon or "";
end;

function v2.GetDesc(p19) -- Line: 90
    return p19:Directory().Description or "";
end;

function v2.ToRewardFormat(p20, u21) -- Line: 94
    -- upvalues: Signal (copy)
    local u22 = p20:GetId();
    local u23 = p20:GetAmount();

    return function(p24) -- Line: 97
        -- upvalues: Signal (ref), u22 (copy), u23 (copy), u21 (copy)
        Signal.Fire(Signal.MAP.Server.GearInventory.ADD, p24, u22, u23, nil, nil, u21);
    end;
end;

return setmetatable(u1, {
    __index = u4,

    __call = function(p25, p26) -- Line: 37, Name: newGear
        -- upvalues: Gears (copy), u4 (copy), u1 (copy)
        if type(p26) == "string" then
            local v27 = Gears.Directory[p26];
            local v28 = `Gear not found in directory for identifier: {p26}`;
            assert(v27, v28);
        else
            local v29 = Gears.Directory[p26._id] == p26;
            local v30 = `Gear not found in directory for ID: {p26._id}`;
            assert(v29, v30);
            p26 = p26._id;
        end;

        return u4.From(u1, {
            id = p26
        });
    end
});