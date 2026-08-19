-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("TweenService");
local Debris = game:GetService("Debris");
game:GetService("RunService");
require(ReplicatedStorage.Sounds.UISoundController);
local TimeEffect = ReplicatedStorage:WaitForChild("ClientEffectsModules"):WaitForChild("EffectAssets"):WaitForChild("TimeEffect");
local Time = script:WaitForChild("Time");
local World = workspace:WaitForChild("World");
World:WaitForChild("Map"):WaitForChild("PlacedItems"):WaitForChild("Client");
local Visuals = World:WaitForChild("Visuals");

return {
    Play = function(p1) -- Line: 23, Name: Play
        -- upvalues: TimeEffect (copy), Visuals (copy), Time (copy), Debris (copy)
        local v2 = TimeEffect:Clone();
        v2.Position = p1.Position;
        v2.Parent = Visuals;
        local v3 = Time:Clone();
        v3.Parent = v2;
        v3:Play();
        local Attachment = v2:FindFirstChild("Attachment");

        if Attachment then
            if Attachment:FindFirstChild("Dust") then
                Attachment.Dust:Emit(5);
            end;

            if Attachment:FindFirstChild("Clock") then
                Attachment.Clock:Emit(1);
            end;

            if Attachment:FindFirstChild("Ring") then
                Attachment.Ring:Emit(1);
            end;
        end;

        Debris:AddItem(v3, 1.5);
        Debris:AddItem(v2, 5);
    end
};