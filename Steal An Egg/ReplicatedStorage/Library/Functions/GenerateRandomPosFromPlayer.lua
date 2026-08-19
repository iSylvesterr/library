-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();
local Asserts = require(ReplicatedStorage.Library.Asserts);
local u2 = require(ReplicatedStorage.Library.Modules.BetterRandom).new();

return function(p3, p4) -- Line: 11
    -- upvalues: Asserts (copy), u1 (copy), u2 (copy)
    Asserts.Player(p3);
    local HumanoidRootPart = (p3.Character or p3.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart", 60);

    if not HumanoidRootPart then
        return u1:AtWarning():Log((`Failed to gen rng pos from player "{p3.Name}", primary part timeout`));
    end;

    local v5 = p4 and u2:positiveYVector3() or u2:Vector3();

    return HumanoidRootPart.Position + v5 * u2:number(20, 50);
end;