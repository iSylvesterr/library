-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local Rarity = require(ReplicatedStorage.Library.Types.Rarity);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Tools = require(ReplicatedStorage.Library.Types.Tools);
local v2 = {
    GearNameExists = function(p1) -- Line: 16
        error("unimplemented");
    end,

    BatControllerData = t.interface({
        Duration = t.number,
        Force = t.number,
        RangeBonus = t.number
    }),
    IndexBatConfigOptions = t.interface({
        DisplayName = t.string,
        Icon = t.string,
        IndexBatTier = t.number,
        Duration = t.number,
        Force = t.number,
        Rarity = Rarity.Rarity
    })
};
v2.DefaultConfig = t.interface({
    _id = t.string,
    Icon = t.string,
    DisplayName = t.string,
    MoneyCost = t.number,
    ShopDropWeight = t.number,
    MinShopStockQuantity = t.number,
    MaxShopStockQuantity = t.number,
    Persistent = t.boolean,
    Rarity = Rarity.Rarity,
    DisplayInShop = t.optional(t.boolean),
    ToolModel = t.optional(t.string),
    IndexBatTier = t.optional(t.number),
    BatControllerData = t.optional(v2.BatControllerData),
    ControllerData = t.optional(t.union(Tools.SlapControllerData)),
    SlapPower = t.optional(t.number),

    ToolController = function(p3) -- Line: 54, Name: ToolController
        -- upvalues: t (copy), Constants (copy), ServerScriptService (copy)
        local v4, v5 = t.string(p3);

        if not v4 then
            return false, `ToolController must be a string: {v5}`;
        end;

        if Constants.IS_SERVER then
            local v6, v7 = require(ServerScriptService.Library.Tools).Types.ControllerNameExists(p3);

            if not v6 then
                return false, v7;
            end;
        end;

        return true;
    end,

    Description = t.optional(t.string),
    SinglePurchase = t.optional(t.boolean),
    MaxActiveDeployments = t.optional(t.number),
    ActiveDeploymentAttribute = t.optional(t.string)
});

return v2;