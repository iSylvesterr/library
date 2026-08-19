-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Observers = require(ReplicatedStorage.Packages.Observers);
local Bomb = require(script.Bomb);

return Observers.observeTag("Bomb", function(p1) -- Line: 13
    -- upvalues: Bomb (copy)
    local u2 = Bomb.new(p1);

    return function() -- Line: 16
        -- upvalues: u2 (copy)
        if u2 then
            u2:destroy();
        end;
    end;
end);