-- Decompiled with Potassium's decompiler.

local MarketplaceService = game:GetService("MarketplaceService");
local Cache = require(game.ReplicatedStorage.UserGenerated.Concurrency.Cache);
local Asserts = require(game.ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = Asserts.TablePermissive({
    PurchaseId = Asserts.String,
    PlayerId = Asserts.Integer,
    ProductId = Asserts.Integer,
    PlaceIdWherePurchased = Asserts.Integer,
    CurrencySpent = Asserts.IntegerNonNegative,
    CurrencyType = Asserts.AnyOf(Asserts.Enum(Enum.CurrencyType), Asserts.String),
    ProductPurchaseChannel = Asserts.Enum(Enum.ProductPurchaseChannel)
});
local u2 = Asserts.Table({
    AssetId = Asserts.Integer,
    InfoType = Asserts.Enum(Enum.InfoType)
});
local u5 = Cache.new({
    Callback = function(p3) -- Line: 158, Name: Callback
        -- upvalues: MarketplaceService (copy)
        return MarketplaceService:GetProductInfo(p3.AssetId, p3.InfoType);
    end,

    AssertKey = function(p4) -- Line: 161, Name: AssertKey
        -- upvalues: u2 (copy)
        u2(p4);

        return `{p4.AssetId},{p4.InfoType.Value}`;
    end
});

return table.freeze({
    AssertReceiptInfo = v1,

    GetInfoAsync = function(p6, p7, p8) -- Line: 171, Name: GetInfoAsync
        -- upvalues: Asserts (copy), u5 (copy)
        Asserts.Integer(p6);
        Asserts.Enum(Enum.InfoType)(p7);
        Asserts.Optional(Asserts.Boolean)(p8);
        local v9 = {
            AssetId = p6,
            InfoType = p7
        };

        if p8 then
            return u5:Get(v9);
        end;

        return u5:GetAsync(v9);
    end
});