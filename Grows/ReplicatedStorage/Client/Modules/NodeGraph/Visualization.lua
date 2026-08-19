-- Decompiled with Potassium's decompiler.

require(script.Parent);
require(script.Parent.Edge);
local Folder = Instance.new("Folder");
Folder.Name = "Graph Visualizations";
Folder.Parent = workspace;

return {
    DebugParts = {},

    DrawGraph = function(p1, p2) -- Line: 20, Name: DrawGraph
        for _, v in p2.Edges do
            p1:DrawEdge(v);
        end;

        return p1.DebugParts;
    end,

    CreateDebugPart = function(p3, p4, p5) -- Line: 28, Name: CreateDebugPart
        -- upvalues: Folder (copy)
        local Part = Instance.new("Part");
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.TopSurface = Enum.SurfaceType.SmoothNoOutlines;
        Part.BottomSurface = Enum.SurfaceType.SmoothNoOutlines;
        Part.Color = p4;
        Part.Name = "BOOP";
        Part.Transparency = 1;

        if p5 then
            Part.Size = p5;
        end;

        Part.Parent = Folder;

        return Part;
    end,

    DrawEdge = function(p6, p7) -- Line: 48, Name: DrawEdge
        local Position = p7.Node0.Data.Position;
        local Position2 = p7.Node1.Data.Position;
        local v8 = Position - Position2;
        local v9 = p6:CreateDebugPart(Color3.new(0.035294, 0.921569, 0.035294));
        v9.Size = Vector3.new(0.1, 0.1, v8.Magnitude);
        v9.CFrame = CFrame.new(Position, Position2) * CFrame.new(0, 0, -v8.Magnitude * 0.5);

        if p6.DebugParts[p7] then
            p6.DebugParts[p7]:Destroy();
        end;

        p6.DebugParts[p7] = v9;

        return v9;
    end,

    Clear = function(p10) -- Line: 68, Name: Clear
        for _, v in p10.DebugParts do
            v:Destroy();
        end;

        p10.DebugParts = {};
    end
};