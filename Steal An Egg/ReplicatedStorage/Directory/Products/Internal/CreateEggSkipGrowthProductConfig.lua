-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
require(script:FindFirstAncestor("Products").Types.Interface);
local FormatDuration = require(ReplicatedStorage.Library.Functions.FormatDuration);

return {
    Create = function(u1, p2, p3) -- Line: 19, Name: Create
        -- upvalues: Asserts (copy), ServerScriptService (copy), ReplicatedStorage (copy), FormatDuration (copy)
        Asserts.string(u1);
        Asserts.number(p2);
        Asserts.positiveInteger(p3);

        local function ServerTest(p4, p5) -- Line: 28
            -- upvalues: Asserts (ref), ServerScriptService (ref), u1 (copy)
            Asserts.Player(p4);
            local Eggs = require(ServerScriptService.Controllers.Eggs);

            if p5 == nil then
                return Eggs.CanPurchaseSkipGrowth(p4, u1);
            end;

            return Eggs.CanRedeemSkipGrowth(p4, u1);
        end;

        local function ReservePrompt(p6) -- Line: 38
            -- upvalues: Asserts (ref), ServerScriptService (ref), u1 (copy)
            Asserts.Player(p6);

            return require(ServerScriptService.Controllers.Eggs).ReserveSkipGrowthPrompt(p6, u1);
        end;

        local function CancelPrompt(p7) -- Line: 45
            -- upvalues: Asserts (ref), ServerScriptService (ref), u1 (copy)
            Asserts.Player(p7);
            require(ServerScriptService.Controllers.Eggs).CancelSkipGrowthPrompt(p7, u1);
        end;

        local function ClientTest() -- Line: 52
            -- upvalues: ReplicatedStorage (ref)
            return require(ReplicatedStorage.Library.Client.EggCmds).CanPurchaseSelectedSkipGrowth();
        end;

        local function Callback(p8) -- Line: 57
            -- upvalues: Asserts (ref), ServerScriptService (ref), u1 (copy)
            Asserts.Player(p8);

            return require(ServerScriptService.Controllers.Eggs).PurchaseSkipGrowth(p8, u1);
        end;

        return {
            LockWhileProcessing = true,
            DisableNotification = true,
            ProductId = p2,
            DisplayName = u1,
            Desc = `Skip the growth of your egg by {FormatDuration(p3)}!`,
            EggSkipGrowthMaxRemainingSeconds = p3,
            ReservePrompt = ReservePrompt,
            CancelPrompt = CancelPrompt,
            ServerTest = ServerTest,
            ClientTest = ClientTest,
            Callback = Callback
        };
    end
};