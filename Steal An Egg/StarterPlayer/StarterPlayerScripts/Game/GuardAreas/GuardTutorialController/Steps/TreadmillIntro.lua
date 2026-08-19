-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Library.Client.GuardTutorialPresentationComponent);
require(script.Parent.Types.Interface);
local u1 = Color3.fromRGB(255, 255, 255);

return {
    StepId = "TreadmillIntro",

    IsSatisfied = function(p2) -- Line: 24, Name: IsSatisfied
        return p2:HasFinishedTreadmillIntro();
    end,

    Bind = function(u3, u4) -- Line: 28, Name: Bind
        local u5 = false;
        task.delay(7, function() -- Line: 30
            -- upvalues: u5 (ref), u3 (copy), u4 (copy)
            if u5 then
                return;
            end;

            u3:MarkTreadmillIntroFinished();
            u4();
        end);

        return function() -- Line: 38
            -- upvalues: u5 (ref)
            u5 = true;
        end;
    end,

    Present = function(u6, p7) -- Line: 43, Name: Present
        -- upvalues: u1 (copy)
        u6:ShowAnimatedMessage("Use your treadmill to become faster!", u1);

        return function() -- Line: 49
            -- upvalues: u6 (copy)
            u6:ClearAll();
        end;
    end
};