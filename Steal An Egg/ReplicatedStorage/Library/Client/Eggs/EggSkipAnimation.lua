-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Debris = game:GetService("Debris");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Easing = require(ReplicatedStorage.Library.Functions.Easing);
local EggActionMovement = require(script.Parent.EggActionMovement);
local EggRenderer = require(script.Parent.EggRenderer);
local SkipEggEffect = ReplicatedStorage.Assets.Particles["Egg Open"].SkipEggEffect;

return {
    Play = function(p1) -- Line: 24, Name: Play
        -- upvalues: Asserts (copy), EggRenderer (copy), SkipEggEffect (copy), RunService (copy), Easing (copy), EggActionMovement (copy), Debris (copy)
        Asserts.Model(p1);
        EggRenderer.DisableCollisions(p1);
        local v2 = p1:GetPivot();
        local v3 = SkipEggEffect.Attachment:Clone();
        v3.Parent = workspace.Terrain;
        local v4 = 0;

        for _, descendant in v3:GetDescendants() do
            descendant.Enabled = true;
        end;

        v3.WorldCFrame = v2 * CFrame.Angles(0, 0, 3.141592653589793);

        while v4 < 1.2 do
            v4 = v4 + RunService.Heartbeat:Wait();
            local v5 = Easing(v4 / 1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
            local SetPivot = EggActionMovement.SetPivot;
            local v6 = v2 * CFrame.Angles(0, math.rad(v5 * 1080), 0);
            local Angles = CFrame.Angles;
            local v7 = math.sin(1080 * v5) * 35 * (1 - v5);
            SetPivot(p1, v6 * Angles(0, 0, (math.rad(v7))));
        end;

        for _, descendant in v3:GetDescendants() do
            descendant.Enabled = false;
        end;

        Debris:AddItem(v3, 5);
    end
};