-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Parent = script.Parent.Parent;
require(Parent.Types);
local packType = require(Parent.Animation.packType);
local springCoefficients = require(Parent.Animation.springCoefficients);
local updateAll = require(Parent.Dependencies.updateAll);
local v1 = {};
local u2 = {};
local u3 = os.clock();

function v1.add(p4) -- Line: 24
    -- upvalues: u3 (ref), u2 (copy)
    p4._lastSchedule = u3;
    p4._startDisplacements = {};
    p4._startVelocities = {};

    for i, v in ipairs(p4._springGoals) do
        p4._startDisplacements[i] = p4._springPositions[i] - v;
        p4._startVelocities[i] = p4._springVelocities[i];
    end;

    u2[p4] = true;
end;

function v1.remove(p5) -- Line: 39
    -- upvalues: u2 (copy)
    u2[p5] = nil;
end;

RunService:BindToRenderStep("__FusionSpringScheduler", Enum.RenderPriority.First.Value, function() -- Line: 44, Name: updateAllSprings
    -- upvalues: u3 (ref), u2 (copy), springCoefficients (copy), packType (copy), updateAll (copy)
    local v6 = {};
    u3 = os.clock();

    for i in pairs(u2) do
        local v7, v8, v9, v10 = springCoefficients(u3 - i._lastSchedule, i._currentDamping, i._currentSpeed);
        local _springPositions = i._springPositions;
        local _springVelocities = i._springVelocities;
        local _startDisplacements = i._startDisplacements;
        local _startVelocities = i._startVelocities;
        local v11 = false;

        for i2, v in ipairs(i._springGoals) do
            local v12 = _startDisplacements[i2];
            local v13 = _startVelocities[i2];
            local v14 = v12 * v7 + v13 * v8;
            local v15 = v12 * v9 + v13 * v10;
            v11 = (math.abs(v14) > 0.0001 or math.abs(v15) > 0.0001) and true or v11;
            _springPositions[i2] = v14 + v;
            _springVelocities[i2] = v15;
        end;

        if not v11 then
            v6[i] = true;
        end;
    end;

    for i in pairs(u2) do
        i._currentValue = packType(i._springPositions, i._currentType);
        updateAll(i);
    end;

    for i in pairs(v6) do
        u2[i] = nil;
    end;
end);

return v1;