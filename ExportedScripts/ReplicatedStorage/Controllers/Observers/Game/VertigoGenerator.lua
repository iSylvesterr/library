-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script:WaitForChild("Types"));
local Observers = require(ReplicatedStorage.Packages.Observers);
local Animation = Instance.new("Animation", nil);
Animation.AnimationId = "rbxassetid://106431666932790";
Animation.Name = "GENERATOR_IDLE";

return Observers.observeTag("VertigoGenerator", function(p1) -- Line: 20
    -- upvalues: Animation (copy)
    p1:WaitForChild("AnimationController"):WaitForChild("Animator");

    if not p1:IsDescendantOf(workspace) then
        return function() -- Line: 31
        end;
    end;

    local u2 = p1.AnimationController.Animator:LoadAnimation(Animation);
    u2:Play();

    return function() -- Line: 27
        -- upvalues: u2 (copy)
        u2:Destroy();
    end;
end);