-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Devproducts = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "monetization", "monetizationIds").Devproducts;
local MarketplaceService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").MarketplaceService;
local Player = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").Player;

return {
    promptDevProduct = function(p1) -- Line: 6
        -- upvalues: Devproducts (copy), MarketplaceService (copy), Player (copy)
        local v2 = Devproducts[p1];

        if v2 == nil or v2 <= 0 then
            return nil;
        end;

        MarketplaceService:PromptProductPurchase(Player, v2);
    end
};