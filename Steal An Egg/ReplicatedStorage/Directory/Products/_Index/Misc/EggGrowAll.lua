-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
require(script:FindFirstAncestor("Products").Types.Interface);

return {
    ProductId = 3611613592,
    DisplayName = "Grow All Eggs",
    Desc = "Finish growing all placed eggs.",
    LockWhileProcessing = true,
    DisableNotification = true,

    ServerTest = function(p1) -- Line: 18, Name: ServerTest
        -- upvalues: Asserts (copy), ServerScriptService (copy)
        Asserts.Player(p1);

        return require(ServerScriptService.Controllers.Eggs).CanPurchaseGrowAll(p1);
    end,

    ClientTest = function() -- Line: 25, Name: ClientTest
        -- upvalues: ReplicatedStorage (copy)
        return require(ReplicatedStorage.Library.Client.EggCmds).CanPurchaseGrowAll();
    end,

    Callback = function(p2) -- Line: 30, Name: Callback
        -- upvalues: Asserts (copy), ServerScriptService (copy)
        Asserts.Player(p2);

        return require(ServerScriptService.Controllers.Eggs).PurchaseGrowAll(p2);
    end
};