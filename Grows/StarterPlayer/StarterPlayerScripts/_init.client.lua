-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local StarterGui = game:GetService("StarterGui");
local Knit = require(ReplicatedStorage.Packages.Knit);
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false);

for _, descendant in ipairs(ReplicatedStorage.Client:GetDescendants()) do
    if descendant:IsA("ModuleScript") then
        require(descendant);
    end;
end;

Knit.Start():catch(warn):await();