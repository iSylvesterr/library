-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Gamepasses = require(ReplicatedStorage.Directory.Gamepasses);
local Products = require(ReplicatedStorage.Directory.Products);
local GetPrice = require(ReplicatedStorage.Library.Functions.GetPrice);
require(ReplicatedStorage.Library.Types.Monetization);
local ProductCache = require(ReplicatedStorage.Library.Functions.ProductCache);
local X2Money = Gamepasses.Directory.X2Money;
local X2Growth = Gamepasses.Directory.X2Growth;
local Lucky = Gamepasses.Directory.Lucky;
local u1 = table.freeze({
    [X2Money._id] = true
});
local u2 = table.freeze({
    [Lucky._id] = true
});
local u3 = table.freeze({
    [X2Money._id] = true,
    [Lucky._id] = true
});
local u4 = {
    SPENDER_TYPES_ENUM = table.freeze({
        MONETIZATION_PROFILE_NON_SPENDER = "NonSpender",
        MONETIZATION_PROFILE_AVATAR_VALUE_ONLY = "AvatarValueOnly",
        MONETIZATION_PROFILE_SPENT_ROBUX = "SpentRobux"
    })
};

local function normalizeRobuxSpentTotal(p5) -- Line: 61
    if typeof(p5) ~= "number" then
        return 0;
    end;

    local v6 = math.floor(p5);

    return math.max(v6, 0);
end;

local function ownsGamepass(p7, p8) -- Line: 69
    if typeof(p7) == "table" then
        return p7[p8] == true;
    end;

    return false;
end;

local function ownsProduct(p9, p10) -- Line: 77
    if typeof(p9) == "table" then
        return p9[tostring(p10)] == true;
    end;

    return false;
end;

local function hasOwnedAttribute(p11, p12) -- Line: 85
    -- upvalues: Asserts (copy)
    Asserts.Player(p11);
    Asserts.string(p12);

    return p11:GetAttribute(p12) == true;
end;

function u4.SyncPlayerAttributes(p13, p14, p15, p16) -- Line: 96
    -- upvalues: Asserts (copy), X2Money (copy), Lucky (copy), u4 (copy)
    Asserts.Player(p13);
    local _id = X2Money._id;
    local v17;

    if typeof(p14) == "table" then
        v17 = p14[_id] == true;
    else
        v17 = false;
    end;

    p13:SetAttribute("MonetizationX2MoneyGamepassOwned", v17);
    local _id2 = Lucky._id;
    local v18;

    if typeof(p14) == "table" then
        v18 = p14[_id2] == true;
    else
        v18 = false;
    end;

    p13:SetAttribute("MonetizationLuckyGamepassOwned", v18);
    p13:SetAttribute("MonetizationRobuxSpentTotal", u4.GetEffectiveRobuxSpentTotal(p14, p15, p16));
end;

function u4.OwnsX2Money(p19) -- Line: 112
    -- upvalues: X2Money (copy)
    local _id = X2Money._id;

    if typeof(p19) == "table" then
        return p19[_id] == true;
    end;

    return false;
end;

function u4.OwnsX2Growth(p20) -- Line: 116
    -- upvalues: X2Growth (copy)
    local _id = X2Growth._id;

    if typeof(p20) == "table" then
        return p20[_id] == true;
    end;

    return false;
end;

function u4.OwnsLucky(p21) -- Line: 120
    -- upvalues: Lucky (copy)
    local _id = Lucky._id;

    if typeof(p21) == "table" then
        return p21[_id] == true;
    end;

    return false;
end;

function u4.OwnsVipProduct(p22) -- Line: 124
    return false;
end;

function u4.PlayerOwnsX2Money(p23) -- Line: 128
    -- upvalues: Asserts (copy)
    Asserts.Player(p23);
    Asserts.string("MonetizationX2MoneyGamepassOwned");

    return p23:GetAttribute("MonetizationX2MoneyGamepassOwned") == true;
end;

function u4.PlayerOwnsLucky(p24) -- Line: 132
    -- upvalues: Asserts (copy)
    Asserts.Player(p24);
    Asserts.string("MonetizationLuckyGamepassOwned");

    return p24:GetAttribute("MonetizationLuckyGamepassOwned") == true;
end;

function u4.PlayerOwnsVipProduct(p25) -- Line: 136
    return false;
end;

function u4.NormalizeRobuxSpentTotal(p26) -- Line: 140
    if typeof(p26) ~= "number" then
        return 0;
    end;

    local v27 = math.floor(p26);

    return math.max(v27, 0);
end;

function u4.GetProductPriceInRobux(p28) -- Line: 144
    -- upvalues: Asserts (copy), GetPrice (copy)
    Asserts.number(p28);
    local v29, v30 = GetPrice(p28, true);

    if not v30 then
        return 0;
    end;

    if typeof(v29) ~= "number" then
        return 0;
    end;

    local v31 = math.floor(v29);

    return math.max(v31, 0);
end;

function u4.GetGamepassPriceInRobux(p32) -- Line: 155
    -- upvalues: Asserts (copy), GetPrice (copy)
    Asserts.number(p32);
    local v33, v34 = GetPrice(p32, false);

    if not v34 then
        return 0;
    end;

    if typeof(v33) ~= "number" then
        return 0;
    end;

    local v35 = math.floor(v33);

    return math.max(v35, 0);
end;

function u4.GetMarketplaceItemPriceInRobux(p36, p37) -- Line: 166
    -- upvalues: Asserts (copy), ProductCache (copy)
    Asserts.number(p36);
    local v38, v39 = ProductCache.getProductInfo(p36, p37);

    if not v39 then
        return 0;
    end;

    local Info = v38.Info;

    if typeof(Info) ~= "table" then
        return 0;
    end;

    local PriceInRobux = Info.PriceInRobux;

    if typeof(PriceInRobux) ~= "number" then
        return 0;
    end;

    local v40 = math.floor(PriceInRobux);

    return math.max(v40, 0);
end;

function u4.GetAvatarAssetPriceInRobux(p41) -- Line: 182
    -- upvalues: u4 (copy)
    return u4.GetMarketplaceItemPriceInRobux(p41, Enum.InfoType.Asset);
end;

function u4.GetAvatarBundlePriceInRobux(p42) -- Line: 186
    -- upvalues: u4 (copy)
    return u4.GetMarketplaceItemPriceInRobux(p42, Enum.InfoType.Bundle);
end;

function u4.ComputeOwnedRobuxSpentTotal(p43, p44) -- Line: 190
    -- upvalues: Gamepasses (copy), u4 (copy), Products (copy)
    local v45 = 0;

    if typeof(p43) == "table" then
        for _, v in pairs(Gamepasses.Directory) do
            local _id = v._id;
            local v46;

            if typeof(p43) == "table" then
                v46 = p43[_id] == true;
            else
                v46 = false;
            end;

            if v46 then
                v45 = v45 + u4.GetGamepassPriceInRobux(v.ProductId);
            end;
        end;
    end;

    if typeof(p44) == "table" then
        for _, v in pairs(Products.Directory) do
            local ProductId = v.ProductId;
            local v47;

            if typeof(p44) == "table" then
                v47 = p44[tostring(ProductId)] == true;
            else
                v47 = false;
            end;

            if v47 then
                v45 = v45 + u4.GetProductPriceInRobux(v.ProductId);
            end;
        end;
    end;

    return v45;
end;

function u4.GetEffectiveRobuxSpentTotal(p48, p49, p50) -- Line: 215
    -- upvalues: u4 (copy)
    local v51;

    if typeof(p50) == "number" then
        local v52 = math.floor(p50);
        v51 = math.max(v52, 0);
    else
        v51 = 0;
    end;

    if v51 > 0 then
        return v51;
    end;

    return u4.ComputeOwnedRobuxSpentTotal(p48, p49);
end;

function u4.HasSpentRobux(p53) -- Line: 228
    local v54;

    if typeof(p53) == "number" then
        local v55 = math.floor(p53);
        v54 = math.max(v55, 0);
    else
        v54 = 0;
    end;

    return v54 > 0;
end;

function u4.GetPlayerRobuxSpentTotal(p56) -- Line: 232
    -- upvalues: Asserts (copy)
    Asserts.Player(p56);
    local v57 = p56:GetAttribute("MonetizationRobuxSpentTotal");

    if typeof(v57) ~= "number" then
        v57 = nil;
    end;

    if typeof(v57) ~= "number" then
        return 0;
    end;

    local v58 = math.floor(v57);

    return math.max(v58, 0);
end;

function u4.PlayerHasSpentRobux(p59) -- Line: 239
    -- upvalues: u4 (copy)
    return u4.GetPlayerRobuxSpentTotal(p59) > 0;
end;

function u4.SyncPlayerAvatarMarketplaceValueAttribute(p60, p61) -- Line: 243
    -- upvalues: Asserts (copy)
    Asserts.Player(p60);
    local v62;

    if typeof(p61) == "number" then
        local v63 = math.floor(p61);
        v62 = math.max(v63, 0);
    else
        v62 = 0;
    end;

    p60:SetAttribute("MonetizationAvatarMarketplaceValue", v62);
end;

function u4.GetPlayerAvatarMarketplaceValue(p64) -- Line: 252
    -- upvalues: Asserts (copy)
    Asserts.Player(p64);
    local v65 = p64:GetAttribute("MonetizationAvatarMarketplaceValue");

    if typeof(v65) ~= "number" then
        v65 = nil;
    end;

    if typeof(v65) ~= "number" then
        return 0;
    end;

    local v66 = math.floor(v65);

    return math.max(v66, 0);
end;

function u4.PlayerHasPositiveAvatarMarketplaceValue(p67) -- Line: 259
    -- upvalues: u4 (copy)
    return u4.GetPlayerAvatarMarketplaceValue(p67) > 0;
end;

function u4.GetMonetizationProfile(p68, p69) -- Line: 263
    -- upvalues: u4 (copy)
    local v70;

    if typeof(p68) == "number" then
        local v71 = math.floor(p68);
        v70 = math.max(v71, 0);
    else
        v70 = 0;
    end;

    local v72;

    if typeof(p69) == "number" then
        local v73 = math.floor(p69);
        v72 = math.max(v73, 0);
    else
        v72 = 0;
    end;

    if v72 > 0 then
        return u4.SPENDER_TYPES_ENUM.MONETIZATION_PROFILE_SPENT_ROBUX;
    end;

    if v70 > 0 then
        return u4.SPENDER_TYPES_ENUM.MONETIZATION_PROFILE_AVATAR_VALUE_ONLY;
    end;

    return u4.SPENDER_TYPES_ENUM.MONETIZATION_PROFILE_NON_SPENDER;
end;

function u4.GetPlayerMonetizationProfile(p74) -- Line: 280
    -- upvalues: Asserts (copy), u4 (copy)
    Asserts.Player(p74);

    return u4.GetMonetizationProfile(u4.GetPlayerAvatarMarketplaceValue(p74), u4.GetPlayerRobuxSpentTotal(p74));
end;

function u4.PlayerPassesStealTakeBackMonetizationGate(p75) -- Line: 289
    -- upvalues: u4 (copy)
    return u4.GetPlayerMonetizationProfile(p75) ~= u4.SPENDER_TYPES_ENUM.MONETIZATION_PROFILE_NON_SPENDER;
end;

function u4.GetAssetMoneyAdditiveRebirthBonus(p76, p77) -- Line: 294
    -- upvalues: u4 (copy)
    local v78 = 0;

    if u4.OwnsX2Money(p76) then
        v78 = v78 + 1;
    end;

    return v78;
end;

function u4.GetAssetMoneyAdditiveRebirthBonusFromPlayer(p79) -- Line: 307
    -- upvalues: u4 (copy)
    local v80 = 0;

    if u4.PlayerOwnsX2Money(p79) then
        v80 = v80 + 1;
    end;

    return v80;
end;

function u4.GetGameplayBlockLuckPercent(p81) -- Line: 317
    -- upvalues: u4 (copy)
    return u4.OwnsLucky(p81) and 10 or 0;
end;

function u4.GetGameplayBlockLuckPercentFromPlayer(p82) -- Line: 325
    -- upvalues: u4 (copy)
    return u4.PlayerOwnsLucky(p82) and 10 or 0;
end;

function u4.GetFuseRarestWeightMultiplier(p83) -- Line: 333
    -- upvalues: u4 (copy)
    return u4.OwnsLucky(p83) and 1.1 or 1;
end;

function u4.GetFuseRarestWeightMultiplierFromPlayer(p84) -- Line: 341
    -- upvalues: u4 (copy)
    return u4.PlayerOwnsLucky(p84) and 1.1 or 1;
end;

function u4.BuildOwnedGamepassesFromPlayer(p85) -- Line: 349
    -- upvalues: Asserts (copy), u4 (copy), u3 (copy), u1 (copy), u2 (copy)
    Asserts.Player(p85);
    local v86 = u4.PlayerOwnsX2Money(p85);
    local v87 = u4.PlayerOwnsLucky(p85);

    if v86 and v87 then
        return u3;
    end;

    if v86 then
        return u1;
    end;

    if v87 then
        return u2;
    end;

    return nil;
end;

function u4.BuildOwnedProductsFromPlayer(p88) -- Line: 370
    -- upvalues: Asserts (copy)
    Asserts.Player(p88);

    return nil;
end;

return u4;