-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
require(ReplicatedStorage.Library.Modules.DefaultStats.Types.Interface);
require(script:FindFirstAncestor("Products").Types.Interface);
local TreadmillUtil = require(ReplicatedStorage.Library.Util.TreadmillUtil);

local function canPurchaseTemporarySpeedBoost(p1) -- Line: 24
    if p1 == nil then
        return false, "Data not loaded";
    end;

    return true;
end;

return function(p2, p3, u4) -- Line: 32
    -- upvalues: Asserts (copy), TreadmillUtil (copy), ServerScriptService (copy), canPurchaseTemporarySpeedBoost (copy), ReplicatedStorage (copy)
    Asserts.string(p2);
    Asserts.number(p3);
    Asserts.number(u4);
    assert(u4 > 0, "Temporary speed boost duration must be positive");
    local v5 = TreadmillUtil.FormatTemporarySpeedBoostProductDuration(u4);

    local function ServerTest(p6) -- Line: 40
        -- upvalues: Asserts (ref), ServerScriptService (ref), canPurchaseTemporarySpeedBoost (ref)
        Asserts.Player(p6);
        local v7, v8 = require(ServerScriptService.Library.Database).UnsafeGetProfileAwait(p6);

        if v7 and v8 then
            return canPurchaseTemporarySpeedBoost(v8);
        end;

        return false, "Player profile not found";
    end;

    local function ClientTest() -- Line: 52
        -- upvalues: ReplicatedStorage (ref), canPurchaseTemporarySpeedBoost (ref)
        return canPurchaseTemporarySpeedBoost(require(ReplicatedStorage.Library.Client.Save).Get());
    end;

    local function Callback(p9) -- Line: 57
        -- upvalues: Asserts (ref), ServerScriptService (ref), u4 (copy)
        Asserts.Player(p9);

        return require(ServerScriptService.Controllers.SpeedPowerService).AddTemporarySpeedBoostDuration(p9, u4);
    end;

    return {
        LockWhileProcessing = true,
        ProductId = p3,
        DisplayName = `x2 Speed Boost ({v5})`,
        Desc = `Double all speed gains for {v5}.`,
        TemporarySpeedBoostDurationSeconds = u4,
        TemporarySpeedBoostMultiplier = TreadmillUtil.TEMPORARY_SPEED_BOOST_MULTIPLIER,
        ServerTest = ServerTest,
        ClientTest = ClientTest,
        Callback = Callback
    };
end;