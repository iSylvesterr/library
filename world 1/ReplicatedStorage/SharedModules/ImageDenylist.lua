-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local u1 = {
    [109918574221466] = true,
    [139417512569425] = true
};
local u2 = FastFlags.Replicated("Game.Security.ImageValidation.Denylist", Asserts.Map(Asserts.String, Asserts.Boolean), {});

return table.freeze({
    IsDenylisted = function(p3) -- Line: 51, Name: IsDenylisted
        -- upvalues: u1 (copy), u2 (copy)
        if type(p3) == "number" then
            return u1[p3] and true or u2:Get()[tostring(p3)] == true;
        end;

        return false;
    end
});