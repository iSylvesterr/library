-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("TweenService");
local Debris = game:GetService("Debris");
game:GetService("RunService");
local EffectAssets = ReplicatedStorage:WaitForChild("ClientEffectsModules"):WaitForChild("EffectAssets");
EffectAssets:WaitForChild("MutationEffects"):WaitForChild("Radiant"):WaitForChild("Radiant");
local VoidBeam = EffectAssets:WaitForChild("VoidBeam");
EffectAssets:WaitForChild("FireFistHit");
local Client = workspace:WaitForChild("World"):WaitForChild("Map"):WaitForChild("PlacedItems"):WaitForChild("Client");
local Brimstone = script:WaitForChild("Brimstone");
local Visuals = workspace:WaitForChild("World"):WaitForChild("Visuals");

return {
    Play = function(p1) -- Line: 25, Name: Play
        -- upvalues: VoidBeam (copy), Client (copy), Visuals (copy), Debris (copy), Brimstone (copy)
        local _ = p1.Target;
        local TowerID = p1.TowerID;
        local TowerPosition = p1.TowerPosition;
        local TargetPosition = p1.TargetPosition;
        local v2 = VoidBeam:Clone();

        if not v2 then
            return;
        end;

        local v3 = Client:FindFirstChild(TowerID);

        if v3 then
            TowerPosition = v3:WaitForChild("Head"):WaitForChild("EffectPart").Position;
        end;

        v2.Parent = Visuals;
        v2.Attachment0.Position = TowerPosition;
        v2.Attachment1.Position = TargetPosition;
        Debris:AddItem(v2, 0.2);
        local v4 = Brimstone:Clone();

        if v4 then
            v4.Parent = v2.Attachment0;
            v4.TimePosition = 0.2;
            v4:Play();
        end;

        Debris:AddItem(v4, 0.2);
    end
};