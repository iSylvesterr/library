-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("TweenService");
local Debris = game:GetService("Debris");
game:GetService("RunService");
local ShotFired = ReplicatedStorage:WaitForChild("ClientEffectsModules"):WaitForChild("EffectAssets"):WaitForChild("ShotFired");
local Shot = script:WaitForChild("Shot");
script:WaitForChild("Impact");
local ChamberSpin = script:WaitForChild("ChamberSpin");
local Hammer = script:WaitForChild("Hammer");
local World = workspace:WaitForChild("World");
local Client = World:WaitForChild("Map"):WaitForChild("PlacedItems"):WaitForChild("Client");
local Visuals = World:WaitForChild("Visuals");

return {
    Play = function(p1) -- Line: 24, Name: Play
        -- upvalues: Client (copy), ShotFired (copy), Visuals (copy), Hammer (copy), Shot (copy), ChamberSpin (copy), Debris (copy)
        local _ = p1.Target;
        local _ = p1.TowerPosition;
        local _ = p1.TargetPosition;
        local v2 = Client:FindFirstChild(p1.TowerID);

        if not v2 then
            return;
        end;

        local Position = v2:WaitForChild("IronWeapon"):WaitForChild("EffectPart").Position;
        local u3 = ShotFired:Clone();
        u3.Position = Position;
        u3.Parent = Visuals;
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = u3;
        WeldConstraint.Part1 = v2:WaitForChild("IronWeapon"):WaitForChild("EffectPart");
        WeldConstraint.Parent = u3;
        u3.Anchored = false;
        local v4 = Hammer:Clone();
        v4.TimePosition = 0.1;
        v4.Parent = u3;
        v4:Play();
        task.delay(0.15, function() -- Line: 55
            -- upvalues: Shot (ref), u3 (copy), ChamberSpin (ref)
            local v5 = Shot:Clone();
            v5.Parent = u3;
            v5:Play();
            local Attachment = u3:FindFirstChild("Attachment");

            if Attachment then
                if Attachment:FindFirstChild("Woosh") then
                    Attachment.Woosh:Emit(4);
                end;

                if Attachment:FindFirstChild("Heat") then
                    Attachment.Heat:Emit(8);
                end;

                if Attachment:FindFirstChild("Smoke") then
                    Attachment.Smoke:Emit(8);
                end;
            end;

            task.delay(0.4, function() -- Line: 68
                -- upvalues: ChamberSpin (ref), u3 (ref)
                local v6 = ChamberSpin:Clone();
                v6.Parent = u3;
                v6:Play();
            end);
        end);
        Debris:AddItem(u3, 2);
    end
};