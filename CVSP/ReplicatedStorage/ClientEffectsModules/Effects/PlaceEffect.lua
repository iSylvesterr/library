-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("TweenService");
local Debris = game:GetService("Debris");
game:GetService("RunService");
require(ReplicatedStorage.Sounds.UISoundController);
local PlaceEffect = ReplicatedStorage:WaitForChild("ClientEffectsModules"):WaitForChild("EffectAssets"):WaitForChild("PlaceEffect");
local Place = script:WaitForChild("Place");
local World = workspace:WaitForChild("World");
World:WaitForChild("Map"):WaitForChild("PlacedItems"):WaitForChild("Client");
local Visuals = World:WaitForChild("Visuals");

return {
    Play = function(p1) -- Line: 23, Name: Play
        -- upvalues: PlaceEffect (copy), Visuals (copy), Place (copy), Debris (copy)
        local v2 = PlaceEffect:Clone();
        v2.Position = p1.Position;
        v2.Parent = Visuals;
        local v3 = Place:Clone();
        v3.Parent = v2;
        v3:Play();
        local Attachment = v2:FindFirstChild("Attachment");

        if Attachment and Attachment:FindFirstChild("Dust") then
            Attachment.Dust:Emit(18);
        end;

        Debris:AddItem(v2, 1.5);
    end
};