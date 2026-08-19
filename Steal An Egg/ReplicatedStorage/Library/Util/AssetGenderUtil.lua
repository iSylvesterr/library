-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Assets = require(ReplicatedStorage.Directory.Assets);
require(ReplicatedStorage.Library.Types.AssetItem);
local u3 = {
    IsGender = function(p1) -- Line: 24, Name: IsGender
        return p1 == "Male" and true or p1 == "Female";
    end,

    Roll = function(p2) -- Line: 28, Name: Roll
        return (p2 or Random.new()):NextInteger(1, 2) == 1 and "Male" or "Female";
    end
};

function u3.ResolveForCategory(p4, p5, p6) -- Line: 37
    -- upvalues: u3 (copy), Assets (copy)
    if u3.IsGender(p5) then
        return p5;
    end;

    local GenderLocked = Assets.Directory[p4].GenderLocked;

    if u3.IsGender(GenderLocked) then
        return GenderLocked;
    end;

    return u3.Roll(p6);
end;

function u3.GetIcon(p7) -- Line: 51
    return p7 == "Male" and "rbxassetid://88627876961976" or "rbxassetid://98782480225988";
end;

return u3;