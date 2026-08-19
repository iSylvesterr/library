-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "monetization", "monetizationIds");
local Devproducts = v1.Devproducts;
local Gamepasses = v1.Gamepasses;
local MarketplaceService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").MarketplaceService;
local Player = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").Player;

return {
    promptMonetizedItem = function(p2) -- Line: 8
        -- upvalues: Gamepasses (copy), Devproducts (copy), MarketplaceService (copy), Player (copy)
        local v3 = Gamepasses[p2];
        local v4;

        if v3 == nil then
            v4 = Devproducts[p2];
        else
            v4 = v3;
        end;

        if v4 == nil or v4 <= 0 then
            return nil;
        end;

        local v5;

        if v3 == nil then
            v5 = false;
        else
            v5 = v3 > 0;
        end;

        if v5 then
            MarketplaceService:PromptGamePassPurchase(Player, v4);

            return;
        end;

        MarketplaceService:PromptProductPurchase(Player, v4);
    end
};