-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Simple = require(ReplicatedStorage.Library.Modules.FormatNumber.Simple);
require(script:FindFirstAncestor("Products").Types.Interface);

return function(p1, p2) -- Line: 17
    -- upvalues: Asserts (copy), ServerScriptService (copy), ReplicatedStorage (copy), Simple (copy)
    Asserts.string(p1);
    Asserts.number(p2);
    local v3 = p1:gsub("SpeedPower_", ""):gsub("%D", "");
    local u4 = tonumber(v3);
    assert(u4 ~= nil, "Speed power product name must include a numeric reward amount");
    assert(u4 > 0, "Speed power reward must be positive");

    local function ensureDataLoaded(p5) -- Line: 26
        if p5 then
            return true;
        end;

        return false, "Player data is not loaded yet.";
    end;

    local function ServerTest(p6) -- Line: 34
        -- upvalues: ServerScriptService (ref), ensureDataLoaded (copy)
        local v7, v8 = require(ServerScriptService.Library.Database).UnsafeGetProfileAwait(p6);

        if v7 then
            return ensureDataLoaded(v8);
        end;

        return false, "Failed to retrieve player data.";
    end;

    local function ClientTest() -- Line: 44
        -- upvalues: ReplicatedStorage (ref), ensureDataLoaded (copy)
        return ensureDataLoaded((require(ReplicatedStorage.Library.Client.Save).Get()));
    end;

    local function Callback(u9) -- Line: 51
        -- upvalues: Asserts (ref), ServerScriptService (ref), u4 (copy), ReplicatedStorage (ref)
        Asserts.Player(u9);
        local v10, u11 = require(ServerScriptService.Controllers.SpeedPowerService).AddSpeedPower(u9, u4, "Instant");

        if not v10 then
            return false, 0;
        end;

        task.spawn(function() -- Line: 59
            -- upvalues: ServerScriptService (ref), ReplicatedStorage (ref), u9 (copy), u11 (copy)
            require(ServerScriptService.Library.Functions.NotifyItem)(u9, require(ReplicatedStorage.Library.Items.SpeedPowerItem)():SetAmount(u11));
        end);

        return true, u11;
    end;

    return {
        Desc = "Purchase bonus speed!",
        LockWhileProcessing = true,
        ProductId = p2,
        DisplayName = `+{Simple.FormatCompact(u4, ".#")} Speed`,
        SpeedPowerReward = u4,
        ServerTest = ServerTest,
        ClientTest = ClientTest,
        Callback = Callback
    };
end;