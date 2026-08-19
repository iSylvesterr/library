-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ModuleLoader = require(ReplicatedStorage.ModuleLoader);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Interface = require(script.Types.Interface);
local MakeTableStrict = require(ReplicatedStorage.Library.Functions.MakeTableStrict);
local ProductCache = require(ReplicatedStorage.Library.Functions.ProductCache);
local Trails = require(ReplicatedStorage.Directory.Trails);
local Treadmills = require(ReplicatedStorage.Directory.Treadmills);
local CreateTrailProductConfig = require(script.Internal.CreateTrailProductConfig);
local CreateTreadmillProductConfig = require(script.Internal.CreateTreadmillProductConfig);
local CreateTreadmillSpeedEquivalentProductConfig = require(script.Internal.CreateTreadmillSpeedEquivalentProductConfig);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local TreadmillSpeedEquivalentOffers = require(script.TreadmillSpeedEquivalentOffers);
local u1 = game.CreatorType == Enum.CreatorType.Group and "Group" or "User";
local CreatorId = game.CreatorId;
local u2 = Log.new();
local v3 = {};
local u4 = ModuleLoader(script._Index, {}, {
    typeCast = "ProductsDir",
    rootName = "Products.Dir",
    noPrint = true,
    shouldInject = true,
    forceSafeLoad = Constants.IS_CLIENT
});
v3.Directory = u4;
v3.Types = Interface;
v3.DataByProductId = {};
v3.TreadmillSpeedEquivalentOffers = TreadmillSpeedEquivalentOffers;

local function getCreatorTargetId(p5) -- Line: 102
    if not p5 then
        return nil;
    end;

    local CreatorTargetId = p5.CreatorTargetId;

    if CreatorTargetId and CreatorTargetId > 0 then
        return CreatorTargetId;
    end;

    local Id = p5.Id;

    if Id and Id > 0 then
        return Id;
    end;

    return nil;
end;

function v3.Types.ProductNameExists(u6) -- Line: 165
    -- upvalues: u4 (copy)
    if pcall(function() -- Line: 166
        -- upvalues: u4 (ref), u6 (copy)
        return u4[u6];
    end) then
        return true;
    end;

    return false, `Products name "{u6}" does not exist in the Products directory.`;
end;

function v3.GetEggSkipGrowthProduct(p7) -- Line: 177
    -- upvalues: u4 (copy)
    assert(p7 >= 0, "Egg skip growth remaining seconds must be non-negative");

    if p7 <= 300 then
        return nil;
    end;

    local v8 = 0;
    local v9 = (1 / 0);
    local v10 = nil;
    local v11 = nil;

    for _, v in pairs(u4) do
        local EggSkipGrowthMaxRemainingSeconds = v.EggSkipGrowthMaxRemainingSeconds;

        if EggSkipGrowthMaxRemainingSeconds ~= nil then
            if v8 < EggSkipGrowthMaxRemainingSeconds then
                v11 = v;
                v8 = EggSkipGrowthMaxRemainingSeconds;
            end;

            if p7 <= EggSkipGrowthMaxRemainingSeconds and EggSkipGrowthMaxRemainingSeconds < v9 then
                v10 = v;
                v9 = EggSkipGrowthMaxRemainingSeconds;
            end;
        end;
    end;

    return v10 or assert(v11, "Products must define at least one egg skip growth product");
end;

(function() -- Line: 64, Name: registerGeneratedTreadmillProducts
    -- upvalues: Treadmills (copy), u4 (copy), CreateTreadmillProductConfig (copy)
    for i, v in pairs(Treadmills.Directory) do
        local ProductId = v.ProductId;

        if typeof(ProductId) == "number" then
            local v12 = `Treadmill_{i}`;
            local v13 = u4[v12] == nil;
            local v14 = `Duplicate generated treadmill product "{v12}"`;
            assert(v13, v14);
            u4[v12] = CreateTreadmillProductConfig(v12, i, ProductId);
        end;
    end;
end)();
(function() -- Line: 78, Name: registerGeneratedTrailProducts
    -- upvalues: Trails (copy), u4 (copy), CreateTrailProductConfig (copy)
    for i, v in pairs(Trails.Directory) do
        local ProductId = v.ProductId;

        if typeof(ProductId) == "number" then
            local v15 = `Trail_{i}`;
            local v16 = u4[v15] == nil;
            local v17 = `Duplicate generated trail product "{v15}"`;
            assert(v16, v17);
            u4[v15] = CreateTrailProductConfig(v15, i, ProductId);
        end;
    end;
end)();
(function() -- Line: 92, Name: registerTreadmillSpeedEquivalentProducts
    -- upvalues: TreadmillSpeedEquivalentOffers (copy), u4 (copy), CreateTreadmillSpeedEquivalentProductConfig (copy)
    for _, v in ipairs(TreadmillSpeedEquivalentOffers) do
        local ProductId = v.ProductId;
        local v18 = `Treadmill speed product "{v.ProductName}" must have a positive ProductId`;
        assert(ProductId > 0, v18);
        local v19 = u4[v.ProductName] == nil;
        local v20 = `Duplicate generated product "{v.ProductName}"`;
        assert(v19, v20);
        u4[v.ProductName] = CreateTreadmillSpeedEquivalentProductConfig.Create(ProductId, v.DurationSeconds);
    end;
end)();

local function validateMarketplaceProduct(p21, p22) -- Line: 120
    -- upvalues: ProductCache (copy), u2 (copy), u1 (copy), CreatorId (copy)
    local v23, v24 = ProductCache.getProductInfo(p22.ProductId, Enum.InfoType.Product);

    if not v24 then
        u2:AtWarning():Log(`Failed to validate marketplace product info for {p21}`, {
            ProductId = p22.ProductId
        });

        return;
    end;

    local Info = v23.Info;
    local v25 = Info.PriceInRobux or 0;

    if v25 <= 0 then
        u2:AtWarning():Log(`Product {p21} has an invalid Robux price`, {
            ProductId = p22.ProductId,
            PriceInRobux = v25
        });
    elseif v25 > 10000 then
        u2:AtWarning():Log(`Product {p21} is priced above the Studio validation threshold`, {
            MaxAllowedPrice = 10000,
            ProductId = p22.ProductId,
            PriceInRobux = v25
        });
    end;

    local Creator = Info.Creator;
    local v26;

    if Creator then
        v26 = Creator.CreatorType;
    else
        v26 = Creator;
    end;

    local v27;

    if Creator then
        v27 = Creator.CreatorTargetId;

        if not v27 or v27 <= 0 then
            v27 = Creator.Id;

            if not v27 or v27 <= 0 then
                v27 = nil;
            end;
        end;
    else
        v27 = nil;
    end;

    if v26 and (v27 and (v26 ~= u1 or v27 ~= CreatorId)) then
        u2:AtWarning():Log(`Product {p21} is owned by the wrong creator`, {
            ProductId = p22.ProductId,
            ExpectedCreatorType = u1,
            ExpectedCreatorId = CreatorId,
            CreatorType = v26,
            CreatorTargetId = v27
        });
    end;
end;

for _, v in pairs(u4) do
    v3.DataByProductId[v.ProductId] = v;
end;

if Constants.IS_STUDIO then
    local v28 = {};

    for i, v in pairs(u4) do
        local v29, v30 = Interface.DefaultConfig(v);
        local v31 = `Bad config found in Products: {i} - {v30}`;
        assert(v29, v31);

        if v28[v.ProductId] then
            error((`Duplicate Product: {i} / {v.ProductId}`));
        else
            v28[v.ProductId] = i;
        end;

        task.spawn(validateMarketplaceProduct, i, v);
    end;
end;

MakeTableStrict(u4, "Products");

return v3;