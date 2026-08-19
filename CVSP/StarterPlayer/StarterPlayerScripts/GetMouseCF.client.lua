-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes");
local u1 = Players.LocalPlayer:GetMouse();

function Remotes.GetMouseCF.OnClientInvoke() -- Line: 11
    -- upvalues: u1 (copy)
    return u1.Hit;
end;