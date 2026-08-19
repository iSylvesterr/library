-- Decompiled with Potassium's decompiler.

local BehaviorBase = require(script.Parent.BehaviorBase);
local u1 = setmetatable({}, {
    __index = BehaviorBase
});
u1.__index = u1;
u1.Name = "StealFruit";

function u1.new(p2) -- Line: 10
    -- upvalues: BehaviorBase (copy), u1 (copy)
    local v3 = BehaviorBase.New(u1, p2);
    v3.TargetPlayer = nil;
    v3.TargetPlantId = nil;
    v3.TargetFruitId = nil;
    v3.CarriedFruitData = nil;
    v3.States = {
        Targeting = {
            Enter = function(p4) -- Line: 23, Name: Enter
                p4:Stop("NotImplemented");
            end
        }
    };

    return v3;
end;

function u1.GetInitialState(p5) -- Line: 33
    return "Targeting";
end;

function u1.CanStart(p6) -- Line: 38
    return true;
end;

return u1;