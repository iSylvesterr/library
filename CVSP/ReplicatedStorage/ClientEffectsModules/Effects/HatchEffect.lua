-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("TweenService");
local Debris = game:GetService("Debris");
game:GetService("RunService");
require(ReplicatedStorage.Sounds.UISoundController);
local HatchEffect = ReplicatedStorage:WaitForChild("ClientEffectsModules"):WaitForChild("EffectAssets"):WaitForChild("HatchEffect");
local Hatch = script:WaitForChild("Hatch");
local Shine = script:WaitForChild("Shine");
local World = workspace:WaitForChild("World");
World:WaitForChild("Map"):WaitForChild("PlacedItems"):WaitForChild("Client");
local Visuals = World:WaitForChild("Visuals");

return {
    Play = function(p1) -- Line: 25, Name: Play
        -- upvalues: HatchEffect (copy), Visuals (copy), Hatch (copy), Shine (copy), Debris (copy)
        local v2 = HatchEffect:Clone();
        v2.Position = p1.Position + Vector3.new(0, 1, 0);
        v2.Parent = Visuals;
        local v3 = Hatch:Clone();
        v3.Parent = v2;
        v3:Play();

        if p1.NoShine then
            return;
        end;

        local v4 = Shine:Clone();
        v4.Parent = v2;
        v4:Play();
        local Attachment = v2:FindFirstChild("Attachment");

        if Attachment and Attachment:FindFirstChild("Shine") then
            Attachment.Shine:Emit(1);
        end;

        Debris:AddItem(v2, 4);
    end
};