-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
require(script:FindFirstAncestor("Products").Types.Interface);
local Treadmills = require(ReplicatedStorage.Directory.Treadmills);

return function(p1, u2, p3) -- Line: 13
    -- upvalues: Asserts (copy), Treadmills (copy), ServerScriptService (copy), ReplicatedStorage (copy)
    Asserts.string(p1);
    Asserts.string(u2);
    Asserts.number(p3);
    local v4, v5 = Treadmills.Types.TreadmillNameExists(u2);
    local v6 = v5 or `Treadmill "{u2}" does not exist`;
    assert(v4, v6);
    local v7 = Treadmills.Directory[u2];
    local u8 = Treadmills.GetUpgradeLevel(u2);
    local v9 = `Treadmill "{u2}" has no upgrade level`;
    assert(u8 ~= nil, v9);

    local function canBuyNextUpgrade(p10) -- Line: 25
        -- upvalues: u8 (copy)
        if p10 + 1 == u8 then
            return true;
        end;

        return false, "This is not your next treadmill upgrade";
    end;

    local function ServerTest(p11) -- Line: 32
        -- upvalues: Asserts (ref), ServerScriptService (ref), canBuyNextUpgrade (copy)
        Asserts.Player(p11);
        local v12, v13 = require(ServerScriptService.Library.Database).UnsafeGetProfileAwait(p11);

        if v12 and v13 then
            return canBuyNextUpgrade(v13.TreadmillUpgradeLevel);
        end;

        return false, "Player profile not found";
    end;

    local function ClientTest() -- Line: 44
        -- upvalues: ReplicatedStorage (ref), canBuyNextUpgrade (copy)
        local v14 = require(ReplicatedStorage.Library.Client.Save).Get();

        if v14 then
            return canBuyNextUpgrade(v14.TreadmillUpgradeLevel);
        end;

        return false, "Data not loaded";
    end;

    local function Callback(p15) -- Line: 54
        -- upvalues: Asserts (ref), ServerScriptService (ref), u2 (copy)
        Asserts.Player(p15);

        return require(ServerScriptService.Controllers.TreadmillService).UpgradeTreadmill(p15, u2, false);
    end;

    return {
        SinglePurchase = true,
        LockWhileProcessing = true,
        ProductId = p3,
        DisplayName = v7.DisplayName,
        Icon = v7.Icon,
        Desc = `Upgrade to the {v7.DisplayName} treadmill.`,
        ServerTest = ServerTest,
        ClientTest = ClientTest,
        Callback = Callback
    };
end;