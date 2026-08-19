-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
game:GetService("RunService");
require(ReplicatedStorage.Sounds.UISoundController);
local EffectAssets = ReplicatedStorage:WaitForChild("ClientEffectsModules"):WaitForChild("EffectAssets");
local SmashEffect = EffectAssets:WaitForChild("SmashEffect");
local Chicken = script:WaitForChild("Chicken");
local Hammer = script:WaitForChild("Hammer");
local World = workspace:WaitForChild("World");
World:WaitForChild("Map"):WaitForChild("PlacedItems"):WaitForChild("Client");
local Visuals = World:WaitForChild("Visuals");

return {
    Play = function(p1) -- Line: 24, Name: Play
        -- upvalues: SmashEffect (copy), Visuals (copy), Chicken (copy), Hammer (copy), EffectAssets (copy), TweenService (copy), Debris (copy)
        local v2 = SmashEffect:Clone();
        v2.Position = p1.Position;
        v2.Parent = Visuals;
        local v3 = Chicken:Clone();
        v3.Parent = v2;
        Chicken.PlaybackSpeed = Random.new():NextNumber(0.8, 1.2);
        v3:Play();
        local v4 = Hammer:Clone();
        v4.Parent = v2;
        v4:Play();
        local Attachment = v2:FindFirstChild("Attachment");

        if Attachment then
            if Attachment:FindFirstChild("Line") then
                Attachment.Line:Emit(10);
            end;

            if Attachment:FindFirstChild("Pebbles2") then
                Attachment.Pebbles2:Emit(20);
            end;

            if Attachment:FindFirstChild("Woosh") then
                Attachment.Woosh:Emit(12);
            end;
        end;

        local Ring = EffectAssets:FindFirstChild("Ring");
        local v5 = Ring:Clone();
        v5.Position = v2.Position;
        local v6 = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
        Ring.Transparency = 0.3;
        local v7 = TweenService:Create(v5, v6, {
            Size = Vector3.new(16, 16, 3)
        });
        local v8 = TweenService:Create(v5, v6, {
            Transparency = 1
        });
        v7:Play();
        v8:Play();
        v5.Parent = Visuals;
        Debris:AddItem(v2, 1.5);
        Debris:AddItem(v5, 0.5);
    end
};