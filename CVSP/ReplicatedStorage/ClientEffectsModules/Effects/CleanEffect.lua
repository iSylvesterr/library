-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("TweenService");
local Debris = game:GetService("Debris");
game:GetService("RunService");
require(ReplicatedStorage.Sounds.UISoundController);
local CleanEffect = ReplicatedStorage:WaitForChild("ClientEffectsModules"):WaitForChild("EffectAssets"):WaitForChild("CleanEffect");
local Bubble = script:WaitForChild("Bubble");
local World = workspace:WaitForChild("World");
World:WaitForChild("Map"):WaitForChild("PlacedItems"):WaitForChild("Client");
local Visuals = World:WaitForChild("Visuals");

return {
    Play = function(p1) -- Line: 23, Name: Play
        -- upvalues: CleanEffect (copy), Visuals (copy), Bubble (copy), Debris (copy)
        local v2 = CleanEffect:Clone();
        v2.Position = p1.Position;
        v2.Parent = Visuals;
        local v3 = Bubble:Clone();
        v3.Parent = v2;
        v3.PlaybackSpeed = Random.new():NextNumber(1.2, 1.6);
        v3:Play();

        if v2:FindFirstChild("Suds") then
            v2.Suds:Emit(10);
        end;

        if v2:FindFirstChild("Bubble") then
            v2.Bubble:Emit(10);
        end;

        Debris:AddItem(v2, 5);
    end
};