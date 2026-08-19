-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local BBFromModelVisibleOnly = require(ReplicatedStorage.Library.Functions.BBFromModelVisibleOnly);

return {
    Create = function(p1, p2) -- Line: 17, Name: Create
        -- upvalues: Asserts (copy), BBFromModelVisibleOnly (copy)
        Asserts.Model(p1);
        Asserts.BasePart(p2);
        local v3 = p1:GetPivot();
        local v4, v5 = BBFromModelVisibleOnly(p1);
        local Part = Instance.new("Part");
        Part.Name = "AssetInteractionPromptAnchor";
        Part.Size = Vector3.new(1, 1, 1);
        Part.Transparency = 1;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.Massless = true;
        local v6 = v5.Y * 0.5;
        Part.CFrame = CFrame.new(v3.Position.X, v4.Position.Y - v6 + math.min(3, v6), v3.Position.Z);
        Part.Parent = p1;
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = p2;
        WeldConstraint.Part1 = Part;
        WeldConstraint.Parent = Part;

        return Part;
    end
};