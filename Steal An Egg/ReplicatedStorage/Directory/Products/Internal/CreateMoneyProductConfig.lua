-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
require(script:FindFirstAncestor("Products").Types.Interface);

return function(p1, p2) -- Line: 16
    -- upvalues: Asserts (copy), ServerScriptService (copy), ReplicatedStorage (copy)
    Asserts.string(p1);
    Asserts.number(p2);
    local v3 = p1:gsub("Money_", ""):gsub("%D", "");
    local u4 = tonumber(v3);
    assert(u4 ~= nil, "Money product name must include a numeric reward amount");
    assert(u4 > 0, "Money reward must be positive");

    local function ensureDataLoaded(p5) -- Line: 25
        if p5 then
            return true;
        end;

        return false, "Player data is not loaded yet.";
    end;

    return {
        Desc = "Purchase bonus money!",
        LockWhileProcessing = true,
        ProductId = p2,
        DisplayName = p1,

        ServerTest = function(p6) -- Line: 33, Name: ServerTest
            -- upvalues: ServerScriptService (ref), ensureDataLoaded (copy)
            local v7, v8 = require(ServerScriptService.Library.Database).UnsafeGetProfileAwait(p6);

            if v7 then
                return ensureDataLoaded(v8);
            end;

            return false, "Failed to retrieve player data.";
        end,

        ClientTest = function() -- Line: 43, Name: ClientTest
            -- upvalues: ReplicatedStorage (ref), ensureDataLoaded (copy)
            return ensureDataLoaded((require(ReplicatedStorage.Library.Client.Save).Get()));
        end,

        Callback = function(p9) -- Line: 50, Name: Callback
            -- upvalues: ServerScriptService (ref), u4 (copy)
            require(ServerScriptService.Controllers.MoneyService).AddMoney(p9, u4);

            return true;
        end
    };
end;