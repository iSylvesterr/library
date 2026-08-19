-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
require(script:FindFirstAncestor("Products").Types.Interface);
local Rarity = require(ReplicatedStorage.Directory.Rarity);

return function(p1, p2, u3) -- Line: 17
    -- upvalues: Asserts (copy), Rarity (copy), ServerScriptService (copy)
    Asserts.string(p1);
    Asserts.string(p2);
    Asserts.number(u3);
    local v4, v5 = Rarity.Types.RarityNameExists(p2);
    local v6 = v5 or `Rarity "{p2}" does not exist`;
    assert(v4, v6);
    local DisplayName = Rarity.Rarities[p2].DisplayName;

    local function ServerTest(p7, p8) -- Line: 36
        -- upvalues: Asserts (ref), u3 (copy), ServerScriptService (ref)
        Asserts.Player(p7);

        if u3 <= 0 then
            return false, "This DNA steal product is not configured yet.";
        end;

        local AssetDnaStealService = require(ServerScriptService.Controllers.AssetDnaStealService);
        local v9, v10;

        if p8 == nil then
            v9, v10 = AssetDnaStealService.CanPromptProduct(p7, u3);
        else
            v9, v10 = AssetDnaStealService.CanRedeemProduct(p7, u3);
        end;

        if v9 then
            return true;
        end;

        return false, v10 or "Choose a valid pet to steal DNA from first.";
    end;

    local function ReservePrompt(p11) -- Line: 58
        -- upvalues: Asserts (ref), ServerScriptService (ref), u3 (copy)
        Asserts.Player(p11);

        return require(ServerScriptService.Controllers.AssetDnaStealService).ReservePrompt(p11, u3);
    end;

    local function CancelPrompt(p12) -- Line: 65
        -- upvalues: Asserts (ref), ServerScriptService (ref), u3 (copy)
        Asserts.Player(p12);
        require(ServerScriptService.Controllers.AssetDnaStealService).CancelPrompt(p12, u3);
    end;

    local function Callback(p13) -- Line: 72
        -- upvalues: Asserts (ref), ServerScriptService (ref), u3 (copy)
        Asserts.Player(p13);
        local v14, v15 = require(ServerScriptService.Controllers.AssetDnaStealService).RedeemProduct(p13, u3);

        if v14 then
            return true;
        end;

        return false, v15 or "Failed to pet asset DNA";
    end;

    return {
        LockWhileProcessing = true,
        ProductId = u3,
        DisplayName = `Steal DNA {DisplayName}`,
        Desc = `Create an exact egg from another player's {DisplayName} asset DNA.`,
        ReservePrompt = ReservePrompt,
        CancelPrompt = CancelPrompt,

        ClientTest = function() -- Line: 28, Name: ClientTest
            -- upvalues: u3 (copy)
            if u3 <= 0 then
                return false, "This DNA steal product is not configured yet.";
            end;

            return true;
        end,

        ServerTest = ServerTest,
        Callback = Callback,
        StealRarity = p2
    };
end;