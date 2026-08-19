-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Gamepasses = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "monetization", "monetizationIds").Gamepasses;
local MarketplaceService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").MarketplaceService;

return {
    getPassPrice = function(p1) -- Line: 5
        -- upvalues: Gamepasses (copy), MarketplaceService (copy)
        local v2 = Gamepasses[p1];

        if v2 == nil or v2 <= 0 then
            return 0;
        end;

        local v3 = MarketplaceService:GetProductInfo(v2, Enum.InfoType.GamePass);

        if v3 ~= nil then
            v3 = v3.PriceInRobux;
        end;

        return v3 ~= nil or 0;
    end
};