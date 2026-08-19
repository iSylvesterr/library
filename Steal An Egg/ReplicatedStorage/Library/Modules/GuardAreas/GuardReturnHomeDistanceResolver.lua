-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local u1 = {
    ["Abyss Ocean"] = 15,
    Cosmic = 15,
    Prehistoric = 15
};

return {
    Resolve = function(p2) -- Line: 24, Name: Resolve
        -- upvalues: Asserts (copy), u1 (copy)
        Asserts.string(p2);

        return u1[p2] or 3;
    end
};