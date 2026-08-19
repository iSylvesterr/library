-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script:WaitForChild("Types"));
local Observers = require(ReplicatedStorage.Packages.Observers);
local Animation = Instance.new("Animation", nil);
Animation.AnimationId = "rbxassetid://103823379066850";
Animation.Name = "FLAG_IDLE";

return Observers.observeTag("Flag", function(p1) -- Line: 20
    -- upvalues: Animation (copy)
    p1:WaitForChild("csFlag"):WaitForChild("AnimationController"):WaitForChild("Animator");
    local u2 = p1.csFlag.AnimationController.Animator:LoadAnimation(Animation);
    u2:Play();

    return function() -- Line: 25
        -- upvalues: u2 (copy)
        u2:Destroy();
    end;
end, { workspace });