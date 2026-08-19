-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Functions = require(ReplicatedStorage.Library.Functions);

return function(u1, p2, p3) -- Line: 4, Name: Wiggle
    -- upvalues: Functions (copy)
    local u4 = p2 or 15;
    local Rotation = u1.Rotation;

    return Functions.RenderStepped(function(p5, p6) -- Line: 7
        -- upvalues: u4 (ref), u1 (copy)
        u1.Rotation = u4 * math.sin(6.283185307179586 * (1 + p6) * 6) / 4 ^ (5 * p6);
    end, p3 or 1, true):Then(function() -- Line: 11
        -- upvalues: u1 (copy), Rotation (copy)
        u1.Rotation = Rotation;
    end);
end;