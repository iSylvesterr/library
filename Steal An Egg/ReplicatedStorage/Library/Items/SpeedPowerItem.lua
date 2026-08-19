-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local AbstractItem = require(script.Parent.AbstractItem);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local u1 = {};
local v2 = setmetatable({
    StackLimit = 1,
    LockingEnabled = false,
    TradingEnabled = false,
    CreationTimeEnabled = false,
    CreationUserEnabled = false,
    OwnerCountEnabled = false,
    OwnerLogEnabled = false,
    NicknameEnabled = false,
    SignedByEnabled = false
}, {
    __index = AbstractItem.Prototype
});
local v3, u4 = AbstractItem.Define("SpeedPower", script, u1);
v2.Class = v3;
u1.Class = v3;
u1.Prototype = v2;

function v2.AbstractGetMaxAmount(p5) -- Line: 55
    return (1 / 0);
end;

function v2.GetName(p6) -- Line: 59
    return "Speed Power";
end;

function v2.GetDesc(p7) -- Line: 63
    return "SPEED";
end;

function v2.GetIcon(p8) -- Line: 67
    return "rbxassetid://99458650446228";
end;

function v2.GetRarity(p9) -- Line: 71
    -- upvalues: Rarity (copy)
    return Rarity.Rarities.Rare;
end;

function v2.Directory(p10) -- Line: 75
    return {};
end;

function v2.GetValue(p11) -- Line: 79
    local value = p11._data.value;

    return typeof(value) ~= "number" and 0 or value;
end;

return setmetatable(u1, {
    __index = u4,

    __call = function(p12) -- Line: 51, Name: newSpeedPower
        -- upvalues: u4 (copy), u1 (copy)
        return u4.From(u1, {});
    end
});