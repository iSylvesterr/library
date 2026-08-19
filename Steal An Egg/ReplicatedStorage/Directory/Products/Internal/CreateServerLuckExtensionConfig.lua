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

        ServerTest = function(p4) -- Line: 14, Name: ServerTest
            -- upvalues: ServerScriptService (ref)
            return require(ServerScriptService.Controllers.ServerLuck).GetState().Multiplier > 1;
        end,

        Callback = function(p5) -- Line: 20, Name: Callback
            -- upvalues: ServerScriptService (ref), u3 (copy)
            return require(ServerScriptService.Controllers.ServerLuck).AddTime(u3 * 60, p5);
        end
    };
end;