-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Bases = require(ReplicatedStorage.Directory.Bases);
require(script:FindFirstAncestor("Products").Types.Interface);

return function(p1, u2, p3) -- Line: 13
    -- upvalues: Asserts (copy), Bases (copy), ServerScriptService (copy), ReplicatedStorage (copy)
    Asserts.string(p1);
    Asserts.integerNonNegative(u2);
    Asserts.number(p3);
    assert(u2 > 0, "Base upgrade product target level must be positive");
    assert(p3 > 0, "Base upgrade product id must be positive");
    local v4 = Bases.BASES[u2];
    local v5 = `Base upgrade level {u2} does not exist`;
    assert(v4 ~= nil, v5);

    local function canBuyNextUpgrade(p6) -- Line: 23
        -- upvalues: u2 (copy)
        if p6 + 1 == u2 then
            return true;
        end;

        return false, "This is not your next base upgrade";
    end;

    local function ServerTest(p7) -- Line: 30
        -- upvalues: Asserts (ref), ServerScriptService (ref), canBuyNextUpgrade (copy)
        Asserts.Player(p7);
        local v8, v9 = require(ServerScriptService.Library.Database).UnsafeGetProfileAwait(p7);

        if v8 and v9 ~= nil then
            return canBuyNextUpgrade(v9.BaseUpgradeLevel);
        end;

        return false, "Player profile not found";
    end;

    local function ClientTest() -- Line: 41
        -- upvalues: ReplicatedStorage (ref), canBuyNextUpgrade (copy)
        local v10 = require(ReplicatedStorage.Library.Client.Save).Get();

        if v10 == nil then
            return false, "Data not loaded";
        end;

        return canBuyNextUpgrade(v10.BaseUpgradeLevel);
    end;

    local function Callback(p11) -- Line: 50
        -- upvalues: Asserts (ref), ServerScriptService (ref), u2 (copy)
        Asserts.Player(p11);

        return require(ServerScriptService.Controllers.PlotService).UpgradeBase(p11, u2, false);
    end;

    return {
        SinglePurchase = true,
        LockWhileProcessing = true,
        ProductId = p3,
        DisplayName = `Base Upgrade Tier {u2}`,
        Desc = `Upgrade your base to tier {u2} and equip {v4.MaxAssets} pets.`,
        ServerTest = ServerTest,
        ClientTest = ClientTest,
        Callback = Callback
    };
end;