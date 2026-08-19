-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
require(script:FindFirstAncestor("Products").Types.Interface);

return function(p1, p2, u3) -- Line: 9
    -- upvalues: Asserts (copy), ServerScriptService (copy)
    Asserts.string(p1);
    Asserts.number(p2);
    Asserts.number(u3);

    return {
        LockWhileProcessing = true,
        DisableNotification = true,
        ProductId = p2,
        DisplayName = p1,

        Callback = function(p4) -- Line: 24, Name: Callback
            -- upvalues: ServerScriptService (ref), u3 (copy)
            require(ServerScriptService.Controllers.ServerLuck).HandlePurchase(u3, p4);

            return true;
        end,

        ServerTest = function(p5) -- Line: 14, Name: ServerTest
            -- upvalues: ServerScriptService (ref), u3 (copy)
            if u3 <= require(ServerScriptService.Controllers.ServerLuck).GetState().Multiplier then
                return false, "Server already has equal or better luck";
            end;

            return true;
        end
    };
end;