-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local u1 = {
    ReadyDebounce = 1,
    ReadyDuration = 5,
    ModificationReadyDuration = 3,
    MessageDebounce = 1,
    MessageLimit = 200,
    ItemLimit = 100,
    HistoryLimit = 20,
    RequiredRebirth = 3,
    BoothHistoryLimit = 30,
    Setting = {
        All = 1,
        Friends = 2,
        Off = 3
    }
};
u1.ClientMessageDebounce = u1.MessageDebounce + 0.5;
u1.ConfirmCountdownSeconds = u1.ReadyDuration;
u1.TradableItemTypesInverse = {
    Currency = "Currency",
    Brainrot = "Brainrot"
};
u1.ItemPolicies = {
    [u1.TradableItemTypesInverse.Currency] = {
        Enabled = false,
        InventoryVisible = false
    },
    [u1.TradableItemTypesInverse.Brainrot] = {
        Enabled = true,
        InventoryVisible = true
    }
};
local v2 = {};
u1.SchemaValidation = v2;
v2.TradableItemTypes = t.union(t.literal("Currency"), t.literal("Brainrot"));

local function buildItemTypeList(p3) -- Line: 58
    -- upvalues: u1 (copy)
    local v4 = {};

    for _, v in ipairs({ u1.TradableItemTypesInverse.Brainrot, u1.TradableItemTypesInverse.Currency }) do
        local v5 = u1.ItemPolicies[v];

        if v5 and p3(v5) then
            table.insert(v4, v);
        end;
    end;

    return v4;
end;

function u1.GetItemPolicy(p6) -- Line: 74
    -- upvalues: u1 (copy)
    return u1.ItemPolicies[p6];
end;

function u1.IsTradableItemType(p7) -- Line: 78
    -- upvalues: u1 (copy)
    local v8 = u1.ItemPolicies[p7];
    local v9;

    if v8 == nil then
        v9 = false;
    else
        v9 = v8.Enabled;
    end;

    return v9;
end;

function u1.IsInventoryItemType(p10) -- Line: 83
    -- upvalues: u1 (copy)
    local v11 = u1.ItemPolicies[p10];
    local v12;

    if v11 == nil then
        v12 = false;
    else
        v12 = v11.Enabled and v11.InventoryVisible;
    end;

    return v12;
end;

function u1.HasRequiredRebirth(p13) -- Line: 88
    -- upvalues: u1 (copy)
    return u1.RequiredRebirth <= p13;
end;

u1.TradableItemTypes = buildItemTypeList(function(p14) -- Line: 92
    return p14.Enabled;
end);
u1.InventoryItemTypes = buildItemTypeList(function(p15) -- Line: 96
    return p15.Enabled and p15.InventoryVisible;
end);

return u1;