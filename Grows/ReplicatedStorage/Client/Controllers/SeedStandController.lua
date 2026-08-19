-- Decompiled with Potassium's decompiler.

game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Knit = require(ReplicatedStorage.Packages.Knit);
require(ReplicatedStorage.Packages.Maid);
require(ReplicatedStorage.Shared.Info.SeedConfig);
local v1 = Knit.CreateController({
    Name = "SeedStandController"
});

function v1.KnitStart(p2) -- Line: 12
end;

function v1.KnitInit(p3) -- Line: 111
    -- upvalues: Knit (copy)
    p3.UI_Manager = Knit.GetController("UI_Manager");
end;

return v1;