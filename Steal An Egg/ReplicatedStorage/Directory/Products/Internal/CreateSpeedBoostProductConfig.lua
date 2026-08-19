-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
require(ReplicatedStorage.Library.Modules.DefaultStats.Types.Interface);
require(script:FindFirstAncestor("Products").Types.Interface);
local TreadmillUtil = require(ReplicatedStorage.Library.Util.TreadmillUtil);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);

local function validateTier(p1, p2) -- Line: 27
    -- upvalues: TreadmillUtil (copy)
    if p1 == nil then
        return false, "Data not loaded";
    end;

    local v3 = TreadmillUtil.ResolveSpeedBoostTierIndex(p1);

    if TreadmillUtil.MAX_SPEED_BOOST_TIER_INDEX <= v3 then
        return false, "Max speed boost owned";
    end;

    if p2 == v3 + 1 then
        return true;
    end;

    return false, "Purchase the previous speed boost first";
end;

return function(p4, p5, u6, p7) -- Line: 44
    -- upvalues: Asserts (copy), Constants (copy), TreadmillUtil (copy), ServerScriptService (copy), validateTier (copy), ReplicatedStorage (copy)
    Asserts.string(p4);
    Asserts.number(p5);
    Asserts.number(u6);
    Asserts.number(p7);

    if Constants.IS_STUDIO then
        local v8;

        if u6 >= 1 then
            v8 = u6 <= TreadmillUtil.MAX_SPEED_BOOST_TIER_INDEX;
        else
            v8 = false;
        end;

        local v9 = `Invalid speed boost tier index {u6}`;
        assert(v8, v9);
        local v10 = TreadmillUtil.GetSpeedBoostMultiplierForTierIndex(u6) == p7;
        local v11 = `Invalid speed boost multiplier {p7} for tier {u6}`;
        assert(v10, v11);
    end;

    local v12 = TreadmillUtil.FormatSpeedMultiplierValue(p7);

    local function ServerTest(p13) -- Line: 68
        -- upvalues: Asserts (ref), ServerScriptService (ref), validateTier (ref), u6 (copy)
        Asserts.Player(p13);
        local v14, v15 = require(ServerScriptService.Library.Database).UnsafeGetProfileAwait(p13);

        if v14 and v15 then
            return validateTier(v15, u6);
        end;

        return false, "Player profile not found";
    end;

    local function ClientTest() -- Line: 80
        -- upvalues: ReplicatedStorage (ref), validateTier (ref), u6 (copy)
        return validateTier(require(ReplicatedStorage.Library.Client.Save).Get(), u6);
    end;

    local function Callback(p16) -- Line: 85
        -- upvalues: Asserts (ref), ServerScriptService (ref), u6 (copy), TreadmillUtil (ref)
        Asserts.Player(p16);
        local v22, v23 = require(ServerScriptService.Library.Database).UpdateProfileImmutable(p16, function(p17) -- Line: 89
            -- upvalues: u6 (ref), TreadmillUtil (ref)
            local v18 = u6;
            local v19;

            if p17 == nil then
                v19 = false;
            else
                local v20 = TreadmillUtil.ResolveSpeedBoostTierIndex(p17);

                if TreadmillUtil.MAX_SPEED_BOOST_TIER_INDEX <= v20 then
                    v19 = false;
                else
                    v19 = v18 == v20 + 1;
                end;
            end;

            if not v19 then
                return false;
            end;

            local v21 = table.clone(p17);
            v21.SpeedBoostTierIndex = u6;

            return v21;
        end):await();

        if v22 and v23 then
            return true;
        end;

        return false, "Purchase the previous speed boost first";
    end;

    return {
        SinglePurchase = true,
        LockWhileProcessing = true,
        ProductId = p5,
        DisplayName = `{v12} Speed Boost`,
        Desc = `Upgrade your permanent speed boost to {v12}.`,
        SpeedBoostTierIndex = u6,
        SpeedBoostMultiplier = p7,
        ServerTest = ServerTest,
        ClientTest = ClientTest,
        Callback = Callback
    };
end;