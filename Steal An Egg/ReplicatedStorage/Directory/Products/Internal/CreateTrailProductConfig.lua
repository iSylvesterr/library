-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
require(ReplicatedStorage.Library.Modules.DefaultStats.Types.Interface);
require(script:FindFirstAncestor("Products").Types.Interface);
local Trails = require(ReplicatedStorage.Directory.Trails);

return function(p1, u2, p3) -- Line: 14
    -- upvalues: Asserts (copy), Trails (copy), ServerScriptService (copy), ReplicatedStorage (copy)
    Asserts.string(p1);
    Asserts.string(u2);
    Asserts.number(p3);
    local v4, v5 = Trails.Types.TrailNameExists(u2);
    local v6 = v5 or `Trail "{u2}" does not exist`;
    assert(v4, v6);
    local v7 = Trails.Directory[u2];

    local function validateData(p8) -- Line: 24
        -- upvalues: u2 (copy)
        if not p8 then
            return false, "Player data not found";
        end;

        if p8.TrailInventory[u2] then
            return false, "You already own this trail";
        end;

        return true;
    end;

    local function ServerTest(p9) -- Line: 35
        -- upvalues: Asserts (ref), ServerScriptService (ref), validateData (copy)
        Asserts.Player(p9);
        local v10, v11 = require(ServerScriptService.Library.Database).UnsafeGetProfileAwait(p9);

        if v10 and v11 then
            return validateData(v11);
        end;

        return false, "Player profile not found";
    end;

    local function ClientTest() -- Line: 47
        -- upvalues: ReplicatedStorage (ref), validateData (copy)
        local v12 = require(ReplicatedStorage.Library.Client.Save).Get();

        if v12 then
            return validateData(v12);
        end;

        return false, "Data not loaded";
    end;

    local function Callback(p13) -- Line: 57
        -- upvalues: Asserts (ref), ServerScriptService (ref), u2 (copy)
        Asserts.Player(p13);

        return require(ServerScriptService.Controllers.TrailShop).GrantOwnedTrail(p13, u2, true);
    end;

    return {
        SinglePurchase = true,
        LockWhileProcessing = true,
        ProductId = p3,
        DisplayName = v7.DisplayName,
        Icon = v7.Icon,
        Desc = `Unlock the {v7.DisplayName} trail.`,
        ServerTest = ServerTest,
        ClientTest = ClientTest,
        Callback = Callback
    };
end;