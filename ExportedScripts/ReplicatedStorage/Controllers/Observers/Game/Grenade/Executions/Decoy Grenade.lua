-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Database.Custom.Types);

return function(p1, p2, u3) -- Line: 12
    for _, descendant in ipairs(u3:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CollisionGroup = "Debris";
            descendant.Transparency = 1;
            descendant.CanCollide = false;
            descendant.CanTouch = false;
            descendant.CanQuery = false;
        end;
    end;

    task.delay(0.5, function() -- Line: 25
        -- upvalues: u3 (copy)
        if u3 and u3.Parent then
            u3:Destroy();
        end;
    end);
end;