-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ClientEffectsModules = ReplicatedStorage:WaitForChild("ClientEffectsModules");
local Remotes = ReplicatedStorage:WaitForChild("Remotes");
local Effects = require(ClientEffectsModules.Effects);
Remotes.ClientEffect.OnClientEvent:Connect(function(p1, p2) -- Line: 11
    -- upvalues: Effects (copy)
    Effects.Play(p1, p2);
end);