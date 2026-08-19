-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Knit = require(ReplicatedStorage.Packages.Knit);
local SeedConfig = require(ReplicatedStorage.Shared.Info.SeedConfig);
local FertilizerConfig = require(ReplicatedStorage.Shared.Info.FertilizerConfig);
local RebirthConfig = require(ReplicatedStorage.Shared.Info.RebirthConfig);
local FarmersMarketConfig = require(ReplicatedStorage.Shared.Info.FarmersMarketConfig);
local FurnitureShopConfig = require(ReplicatedStorage.Shared.Info.FurnitureShopConfig);
local v1 = Knit.CreateController({
    Name = "RemoteConfigController"
});

local function apply(u2) -- Line: 22
    -- upvalues: HttpService (copy), SeedConfig (copy), FertilizerConfig (copy), RebirthConfig (copy), FurnitureShopConfig (copy), FarmersMarketConfig (copy)
    if not u2 or u2 == "" then
        return;
    end;

    local success, result = pcall(function() -- Line: 24
        -- upvalues: HttpService (ref), u2 (copy)
        return HttpService:JSONDecode(u2);
    end);

    if not success or type(result) ~= "table" then
        return;
    end;

    SeedConfig.ApplyCostOverrides(result.seeds);
    FertilizerConfig.ApplyOverrides(result.fertilizers);
    RebirthConfig.ApplyOverrides(result.rebirth);
    SeedConfig.ApplyWeightOverrides(result.weights);
    FurnitureShopConfig.ApplyPriceOverrides(result.furniture);
    FarmersMarketConfig.ApplyOverrides(result.market);
end;

function v1.KnitStart(p3) -- Line: 36
    -- upvalues: ReplicatedStorage (copy), apply (copy)
    local RemoteConfig = ReplicatedStorage:WaitForChild("RemoteConfig", 30);

    if not RemoteConfig then
        return;
    end;

    apply(RemoteConfig.Value);
    RemoteConfig:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 40
        -- upvalues: apply (ref), RemoteConfig (copy)
        apply(RemoteConfig.Value);
    end);
end;

return v1;