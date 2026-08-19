-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
require(script:FindFirstAncestor("Products").Types.Interface);

return {
    ProductId = 3597897050,
    DisplayName = "Rebirth Skip",
    Desc = "Rebirth instantly without resetting your speed.",
    LockWhileProcessing = true,
    DisableNotification = true,

    ServerTest = function(p1) -- Line: 15, Name: ServerTest
        -- upvalues: Asserts (copy), ServerScriptService (copy)
        Asserts.Player(p1);

        return require(ServerScriptService.Controllers.RebirthService).CanPurchaseSkipRebirth(p1);
    end,

    ClientTest = function() -- Line: 22, Name: ClientTest
        -- upvalues: ReplicatedStorage (copy)
        local Save = require(ReplicatedStorage.Library.Client.Save);
        local RebirthUtil = require(ReplicatedStorage.Library.Util.RebirthUtil);
        local v2 = Save.Get();

        if not v2 then
            return false, "Data not loaded";
        end;

        if (v2.Rebirth or 0) >= RebirthUtil.GetMaxRebirth() then
            return false, "Max rebirth reached";
        end;

        return true;
    end,

    Callback = function(p3) -- Line: 37, Name: Callback
        -- upvalues: Asserts (copy), ServerScriptService (copy)
        Asserts.Player(p3);

        return require(ServerScriptService.Controllers.RebirthService).PurchaseSkipRebirth(p3);
    end
};