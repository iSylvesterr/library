-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Shared.Janitor);
local Sound = require(ReplicatedStorage.Classes.Sound);
local Debris = workspace:WaitForChild("Debris");

return function(p1, p2, u3) -- Line: 18
    -- upvalues: ReplicatedStorage (copy), Debris (copy), Sound (copy)
    for _, descendant in ipairs(u3:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CollisionGroup = "Debris";
            descendant.Transparency = 1;
            descendant.CanCollide = false;
            descendant.CanTouch = false;
            descendant.CanQuery = false;
        end;
    end;

    local v4 = p1:Add(ReplicatedStorage.Assets.GrenadeParticles["HE Grenade"]:Clone());
    v4.CFrame = CFrame.new(p2);
    v4.Parent = Debris;
    v4.Anchored = true;
    Sound.new("HE Grenade"):playOneTime({
        Name = "Explode",
        Parent = v4
    });

    for _, descendant in ipairs(v4:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            task.delay(descendant:GetAttribute("EmitDelay") or 0, function() -- Line: 47
                -- upvalues: descendant (copy)
                descendant:Emit(descendant:GetAttribute("EmitCount") or 1);
            end);
        end;
    end;

    task.delay(3, function() -- Line: 54
        -- upvalues: u3 (copy)
        if u3 and u3.Parent then
            u3:Destroy();
        end;
    end);
end;