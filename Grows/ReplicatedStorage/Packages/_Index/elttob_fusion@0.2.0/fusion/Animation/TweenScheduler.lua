-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Parent = script.Parent.Parent;
require(Parent.Types);
local lerpType = require(Parent.Animation.lerpType);
local getTweenRatio = require(Parent.Animation.getTweenRatio);
local updateAll = require(Parent.Dependencies.updateAll);
local u1 = {};
local u2 = {};
setmetatable(u2, {
    __mode = "k"
});

function u1.add(p3) -- Line: 29
    -- upvalues: u2 (copy)
    u2[p3] = true;
end;

function u1.remove(p4) -- Line: 36
    -- upvalues: u2 (copy)
    u2[p4] = nil;
end;

RunService:BindToRenderStep("__FusionTweenScheduler", Enum.RenderPriority.First.Value, function() -- Line: 43, Name: updateAllTweens
    -- upvalues: u2 (copy), updateAll (copy), u1 (copy), getTweenRatio (copy), lerpType (copy)
    local v5 = os.clock();

    for i in pairs(u2) do
        local v6 = v5 - i._currentTweenStartTime;

        if i._currentTweenDuration < v6 then
            if i._currentTweenInfo.Reverses then
                i._currentValue = i._prevValue;
            else
                i._currentValue = i._nextValue;
            end;

            i._currentlyAnimating = false;
            updateAll(i);
            u1.remove(i);
        else
            local v7 = getTweenRatio(i._currentTweenInfo, v6);
            i._currentValue = lerpType(i._prevValue, i._nextValue, v7);
            i._currentlyAnimating = true;
            updateAll(i);
        end;
    end;
end);

return u1;