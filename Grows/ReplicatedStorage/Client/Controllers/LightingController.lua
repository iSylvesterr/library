-- Decompiled with Potassium's decompiler.

game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Lighting = game:GetService("Lighting");
local v1 = require(ReplicatedStorage.Packages.Knit).CreateController({
    Name = "LightingController"
});

function v1.KnitStart(p2) -- Line: 11
    -- upvalues: Lighting (copy)
    local EnableOnStart = Lighting:FindFirstChild("EnableOnStart");

    if EnableOnStart then
        for _, child in EnableOnStart:GetChildren() do
            child.Parent = Lighting;
        end;
    end;
end;

return v1;