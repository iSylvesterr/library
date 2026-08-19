-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("TweenService");
local Debris = game:GetService("Debris");
game:GetService("RunService");
require(ReplicatedStorage.Sounds.UISoundController);
local BigTimeEffect = ReplicatedStorage:WaitForChild("ClientEffectsModules"):WaitForChild("EffectAssets"):WaitForChild("BigTimeEffect");
local Time = script:WaitForChild("Time");
local Resume = script:WaitForChild("Resume");
local World = workspace:WaitForChild("World");
World:WaitForChild("Map"):WaitForChild("PlacedItems"):WaitForChild("Client");
local Visuals = World:WaitForChild("Visuals");

return {
    Play = function(p1) -- Line: 25, Name: Play
        -- upvalues: BigTimeEffect (copy), Visuals (copy), Time (copy), Resume (copy), Debris (copy)
        local v2 = BigTimeEffect:Clone();
        v2.Position = p1.Position;
        v2.Parent = Visuals;
        local v3 = Time:Clone();
        v3.Parent = v2;
        v3:Play();
        local u4 = Resume:Clone();
        u4.Parent = v2;
        task.delay(3.5, function() -- Line: 38
            -- upvalues: u4 (copy)
            u4:Play();
        end);
        local Attachment = v2:FindFirstChild("Attachment");

        if Attachment then
            if Attachment:FindFirstChild("Dust") then
                Attachment.Dust:Emit(6);
            end;

            if Attachment:FindFirstChild("Clock") then
                Attachment.Clock:Emit(1);
            end;

            if Attachment:FindFirstChild("Ring") then
                Attachment.Ring:Emit(1);
            end;
        end;

        Debris:AddItem(v3, 3);
        Debris:AddItem(v2, 10);
        Debris:AddItem(u4, 10);
    end
};