-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script:WaitForChild("Types"));
local Observers = require(ReplicatedStorage.Packages.Observers);
local Animation = Instance.new("Animation");
Animation.AnimationId = "rbxassetid://82806563298602";

return Observers.observeTag("Ceiling Fan", function(p1) -- Line: 17
    -- upvalues: Animation (copy)
    p1:WaitForChild("AnimationController"):WaitForChild("Animator");

    if p1:IsDescendantOf(workspace) then
        local u2 = p1.AnimationController.Animator:LoadAnimation(Animation);
        u2:Play();

        return function() -- Line: 27
            -- upvalues: u2 (copy)
            u2:Destroy();
        end;
    end;
end);