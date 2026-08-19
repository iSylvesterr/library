-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
require(ReplicatedStorage.Library.Modules.DefaultStats.Types.Interface);
require(script:FindFirstAncestor("Products").Types.Interface);
local TreadmillUtil = require(ReplicatedStorage.Library.Util.TreadmillUtil);
local v1 = {};

local function canPurchase(p2) -- Line: 23
    if p2 == nil then
        return false, "Player data is not loaded yet.";
    end;

    return true, nil;
end;

function v1.Create(p3, u4) -- Line: 34
    -- upvalues: Asserts (copy), TreadmillUtil (copy), ServerScriptService (copy), canPurchase (copy), ReplicatedStorage (copy)
    Asserts.number(p3);
    Asserts.number(u4);
    assert(p3 > 0, "Treadmill equivalent product id must be positive");
    assert(u4 > 0, "Treadmill equivalent duration must be positive");

    local function ServerTest(p5) -- Line: 45
        -- upvalues: Asserts (ref), ServerScriptService (ref), canPurchase (ref)
        Asserts.Player(p5);
        local v6, v7 = require(ServerScriptService.Library.Database).UnsafeGetProfileAwait(p5);

        if v6 then
            return canPurchase(v7);
        end;

        return false, "Player data is not loaded yet.";
    end;

    local function ClientTest() -- Line: 55
        -- upvalues: ReplicatedStorage (ref), canPurchase (ref)
        return canPurchase(require(ReplicatedStorage.Library.Client.Save).Get());
    end;

    local function Callback(p8) -- Line: 60
        -- upvalues: Asserts (ref), ServerScriptService (ref), u4 (copy), ReplicatedStorage (ref)
        Asserts.Player(p8);
        local v9, v10 = require(ServerScriptService.Controllers.SpeedPowerService).AddTreadmillEquivalentSpeedPower(p8, u4);

        if not v9 then
            return false, 0;
        end;

        require(ServerScriptService.Library.Functions.NotifyItem)(p8, require(ReplicatedStorage.Library.Items.SpeedPowerItem)():SetAmount(v10));

        return true, v10;
    end;

    return {
        Desc = "Instantly gain the speed you currently earn on your treadmill.",
        LockWhileProcessing = true,
        ProductId = p3,
        DisplayName = `Speed - {TreadmillUtil.FormatTreadmillSpeedEquivalentDuration(u4)}`,
        TreadmillSpeedEquivalentDurationSeconds = u4,
        ServerTest = ServerTest,
        ClientTest = ClientTest,
        Callback = Callback
    };
end;

return v1;