-- Decompiled with Potassium's decompiler.

local v1 = {};
local Model = Instance.new("Model", workspace);

function v1.clearParts() -- Line: 12
    -- upvalues: Model (copy)
    Model:ClearAllChildren();
end;

function v1.createPart(p2, ...) -- Line: 21
    -- upvalues: Model (copy)
    for _, v in { ... } do
        local Part = Instance.new("Part");
        Part.CFrame = v;
        Part.Anchored = true;
        Part.Size = Vector3.new(1, 1, 1);
        Part.Material = Enum.Material.Metal;
        Instance.new("Highlight", Part).FillColor = p2;
        local SurfaceGui = Instance.new("SurfaceGui");
        local TextLabel = Instance.new("TextLabel", SurfaceGui);
        TextLabel.Size = UDim2.fromScale(1, 1);
        TextLabel.Text = "Front";
        TextLabel.TextScaled = true;
        SurfaceGui.Face = Enum.NormalId.Front;
        SurfaceGui.Parent = Part;
        Part.Parent = Model;
    end;
end;

return v1;