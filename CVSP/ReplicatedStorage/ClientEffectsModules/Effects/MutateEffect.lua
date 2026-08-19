-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("TweenService");
local Debris = game:GetService("Debris");
game:GetService("RunService");
require(ReplicatedStorage.Sounds.UISoundController);
local MutateEffect = ReplicatedStorage:WaitForChild("ClientEffectsModules"):WaitForChild("EffectAssets"):WaitForChild("MutateEffect");
local Mutate = script:WaitForChild("Mutate");
local World = workspace:WaitForChild("World");
World:WaitForChild("Map"):WaitForChild("PlacedItems"):WaitForChild("Client");
local Visuals = World:WaitForChild("Visuals");

return {
    Play = function(p1) -- Line: 23, Name: Play
        -- upvalues: MutateEffect (copy), Visuals (copy), Mutate (copy), Debris (copy)
        local v2 = MutateEffect:Clone();
        v2.Position = p1.Position;
        v2.Parent = Visuals;
        local v3 = Mutate:Clone();
        v3.Parent = v2;
        v3:Play();

        if v2:FindFirstChild("Dust") then
            v2.Dust:Emit(10);
        end;

        Debris:AddItem(v2, 5);
    end
};