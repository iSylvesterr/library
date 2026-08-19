-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "monetization", "monetizationIds");
local Devproducts = v1.Devproducts;
local Gamepasses = v1.Gamepasses;
local MarketplaceService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").MarketplaceService;

local function retry(u2, u3, p4) -- Line: 7
    -- upvalues: RuntimeLib (copy)
    local u5 = p4 == nil and 0 or p4;

    return RuntimeLib.Promise.new(function(u6) -- Line: 11
        -- upvalues: u2 (copy), u5 (ref), u3 (copy)
        local function u8(u7) -- Line: 13
            -- upvalues: u2 (ref), u6 (copy), u5 (ref), u8 (ref)
            local success, result = pcall(u2);

            if success then
                u6(result);

                return nil;
            end;

            if u7 <= 0 then
                u6(nil);

                return;
            end;

            if u5 > 0 then
                task.delay(u5, function() -- Line: 21
                    -- upvalues: u8 (ref), u7 (copy)
                    return u8(u7 - 1);
                end);

                return;
            end;

            u8(u7 - 1);
        end;

        u8(u3);
    end);
end;

local u9 = {};

return {
    getMonetizedItemPrice = RuntimeLib.async(function(u10, p11, p12) -- Line: 35
        -- upvalues: u9 (copy), RuntimeLib (copy), retry (copy), Gamepasses (copy), Devproducts (copy), MarketplaceService (copy)
        local v13 = u9[u10];

        if v13 ~= nil then
            return v13;
        end;

        local v18 = RuntimeLib.await(retry(function() -- Line: 47
            -- upvalues: Gamepasses (ref), u10 (copy), Devproducts (ref), MarketplaceService (ref)
            local v14 = Gamepasses[u10];
            local v15;

            if v14 == nil then
                v15 = Devproducts[u10];
            else
                v15 = v14;
            end;

            if v15 == nil or v15 <= 0 then
                return 0;
            end;

            local v16;

            if v14 == nil then
                v16 = false;
            else
                v16 = v14 > 0;
            end;

            local v17;

            if v16 then
                v17 = MarketplaceService:GetProductInfo(v15, Enum.InfoType.GamePass);
            else
                v17 = MarketplaceService:GetProductInfo(v15, Enum.InfoType.Product);
            end;

            local PriceInRobux = v17.PriceInRobux;

            return PriceInRobux == nil and 0 or PriceInRobux;
        end, p11 == nil and 3 or p11, p12 == nil and 1 or p12));

        if v18 ~= nil then
            u9[u10] = v18;
        end;

        return v18 == nil and 0 or v18;
    end)
};