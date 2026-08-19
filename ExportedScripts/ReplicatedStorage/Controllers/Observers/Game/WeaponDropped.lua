-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Observers = require(ReplicatedStorage.Packages.Observers);
local Weapon = require(script.Weapon);

return Observers.observeTag("WeaponDropped", function(p1) -- Line: 13
    -- upvalues: Weapon (copy)
    local u2 = Weapon.new(p1);

    return function() -- Line: 16
        -- upvalues: u2 (copy)
        if u2 then
            u2:destroy();
        end;
    end;
end);