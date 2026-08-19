-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Directory = require(ReplicatedStorage.Directory.Currency).Directory;
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local AbstractItem = require(script.Parent.AbstractItem);
local Currency = require(ReplicatedStorage.Library.Types.Currency);
require(ReplicatedStorage.Library.Util.ItemUtil.Types.Interface);
local Signal = require(ReplicatedStorage.Library.Signal);
require(ReplicatedStorage.Library.Modules.Packages.InstanceCache);
local u1 = {
    Directory = Directory
};
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
local v3, u4 = AbstractItem.Define("Currency", script, u1);
v2.Class = v3;
u1.Class = v3;
u1.Prototype = v2;
local u5 = {
    [250000] = "rbxassetid://75372541151576",
    [1000000] = "rbxassetid://139742352093157",
    [5000000] = "rbxassetid://112271178072366"
};

function v2.Patch(p6) -- Line: 84
    local v7 = p6:GetAmount();
    local v8 = p6:GetMaxAmount();

    if v8 < v7 then
        p6:SetAmount(v8);
    end;
end;

function v2.AbstractIsRAPVisible(p9) -- Line: 92
    return false;
end;

function v2.GetId(p10) -- Line: 96
    return p10._data.id;
end;

function v2.AbstractGetMaxAmount(p11) -- Line: 100
    return (1 / 0);
end;

function v2.ToRewardFormat(p12) -- Line: 104
    -- upvalues: Signal (copy)
    local u13 = p12:GetId();
    local u14 = p12:GetAmount();

    return function(p15) -- Line: 107
        -- upvalues: Signal (ref), u13 (copy), u14 (copy)
        Signal.Fire(Signal.MAP.Server.MoneyService.ADD, p15, u13, u14);
    end;
end;

function v2.ToItemUtilFormat(p16) -- Line: 112
    -- upvalues: Currency (copy)
    local v17 = Currency.AllCurrencyTypes[p16:GetId()];
    local v18 = `Attempt to convert non-currency item to ItemUtil format: {p16:GetId()}`;
    assert(v17, v18);

    return {
        Currency = p16:GetId(),
        Amount = p16:GetAmount()
    };
end;

function v2.SetId(p19, p20) -- Line: 123
    -- upvalues: Directory (copy)
    local v21 = Directory[p20];
    local v22 = `Currency not found in directory for ID: {p20}`;
    assert(v21, v22);
    p19._data.id = p20;

    return p19;
end;

function v2.SetDirectory(p23, p24) -- Line: 129
    -- upvalues: Directory (copy)
    local v25 = Directory[p24._id] == p24;
    local v26 = `Currency not found in directory for ID: {p24._id}`;
    assert(v25, v26);

    return p23:SetId(p24._id);
end;

function v2.Directory(p27) -- Line: 134
    -- upvalues: Directory (copy)
    return Directory[p27._data.id];
end;

function v2.GetIcon(p28) -- Line: 138
    -- upvalues: u5 (copy)
    local v29 = p28:GetAmount();
    local v30 = -1;
    local v31 = nil;

    for i, v in pairs(u5) do
        if i <= v29 and v30 < i then
            v31 = v;
            v30 = i;
        end;
    end;

    return v31 or (p28:Directory().Icon or "");
end;

function v2.GetName(p32) -- Line: 158
    return p32:Directory().DisplayName or "";
end;

function v2.GetDesc(p33) -- Line: 162
    return p33:Directory().Desc or "";
end;

function v2.GetRarity(p34) -- Line: 166
    -- upvalues: Rarity (copy)
    return p34:Directory().Rarity or Rarity.Rarities.Rare;
end;

function v2.GetOrbInstance(p35) -- Line: 170
    return p35:Directory().Instance;
end;

function v2.GetCollectDistanceOverride(p36) -- Line: 174
    return p36:Directory().CollectDistanceOverride;
end;

function v2.GetPickupDistanceOverride(p37) -- Line: 178
    return p37:Directory().PickupDistanceOverride;
end;

return setmetatable(u1, {
    __index = u4,

    __call = function(p38, p39) -- Line: 62, Name: new
        -- upvalues: Directory (copy), u4 (copy), u1 (copy)
        if type(p39) == "string" then
            local v40 = Directory[p39];
            local v41 = `Currency not found in directory for ID: {p39}`;
            assert(v40, v41);
        else
            local v42 = Directory[p39._id] == p39;
            local v43 = `Currency not found in directory for ID: {p39._id}`;
            assert(v42, v43);
            p39 = p39._id;
        end;

        return u4.From(u1, {
            id = p39
        });
    end
});