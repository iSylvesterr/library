-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Rebirths = require(ReplicatedStorage.Directory.Rebirths);
local u1 = {};

function u1.RebirthToMultiplier(p2) -- Line: 14
    -- upvalues: Asserts (copy), Rebirths (copy), u1 (copy)
    Asserts.number(p2);

    if p2 <= 0 then
        return 1;
    end;

    local v3 = Rebirths[p2] or Rebirths[u1.GetMaxRebirth()];
    assert(v3 ~= nil, "Expected rebirth multiplier entry");

    return v3.Multiplier;
end;

function u1.GetMaxRebirth() -- Line: 29
    -- upvalues: Rebirths (copy)
    return #Rebirths;
end;

function u1.RebirthToRequiredSpeedPower(p4) -- Line: 33
    -- upvalues: Asserts (copy), Rebirths (copy)
    Asserts.number(p4);
    local v5 = Rebirths[p4];

    if not v5 then
        return (1 / 0);
    end;

    local RequiredSpeedPower = v5.Requirements.RequiredSpeedPower;

    return typeof(RequiredSpeedPower) ~= "number" and (1 / 0) or RequiredSpeedPower;
end;

return u1;