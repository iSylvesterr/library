-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Library.Types.Sprinklers);
local PackVector3 = require(ReplicatedStorage.Library.Functions.PackVector3);
local UnpackVector3 = require(ReplicatedStorage.Library.Functions.UnpackVector3);

return {
    Serialize = function(p1) -- Line: 14, Name: Serialize
        -- upvalues: PackVector3 (copy)
        return {
            Position = PackVector3(p1.Position),
            Remaining = p1.Remaining,
            Category = p1.Category
        };
    end,

    Deserialize = function(p2) -- Line: 24, Name: Deserialize
        -- upvalues: UnpackVector3 (copy)
        return {
            Position = UnpackVector3(p2.Position),
            Remaining = p2.Remaining,
            Category = p2.Category
        };
    end
};