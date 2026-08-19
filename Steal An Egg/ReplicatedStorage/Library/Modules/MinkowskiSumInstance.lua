-- Decompiled with Potassium's decompiler.

local Modules = game:GetService("ReplicatedStorage").Library.Modules;
local TrianglePart = require(Modules.TrianglePart);
local QuickHull2 = require(Modules.QuickHull2);
local u1 = {
    meshCache = {},
    timeSpentTracing = 0
};
local u2 = { Vector3.new(0.5, 0.5, 0.5), Vector3.new(0.5, 0.5, -0.5), Vector3.new(-0.5, 0.5, 0.5), Vector3.new(-0.5, 0.5, -0.5), Vector3.new(0.5, -0.5, 0.5), Vector3.new(0.5, -0.5, -0.5), Vector3.new(-0.5, -0.5, 0.5), Vector3.new(-0.5, -0.5, -0.5) };
local u3 = { Vector3.new(0.5, -0.5, -0.5), Vector3.new(-0.5, -0.5, -0.5), Vector3.new(0.5, -0.5, 0.5), Vector3.new(-0.5, -0.5, 0.5), Vector3.new(0.5, 0.5, 0.5), Vector3.new(-0.5, 0.5, 0.5) };
local u4 = { Vector3.new(0.5, 0.5, -0.5), Vector3.new(0.5, -0.5, 0.5), Vector3.new(-0.5, -0.5, 0.5), Vector3.new(0.5, -0.5, -0.5), Vector3.new(-0.5, -0.5, -0.5) };

local function IsUnique(p5, p6, p7) -- Line: 42
    for _, v in pairs(p5) do
        if math.abs(v.ed - p7) < 0.01 and v.n:Dot(p6) > 0.95 then
            return false;
        end;
    end;

    return true;
end;

local function IsUniquePoint(p8, p9) -- Line: 54
    for _, v in pairs(p8) do
        if (v - p9).magnitude < 0.001 then
            return false;
        end;
    end;

    return true;
end;

local function IsUniqueTri(p10, p11, p12) -- Line: 65
    for _, v in pairs(p10) do
        if math.abs(v[5] - p12) <= 0.001 and v[4]:Dot(p11) >= 0.999 then
            return false;
        end;
    end;

    return true;
end;

function u1.GetPlanesForInstance(p13, p14, p15, p16, p17, p18) -- Line: 105
    -- upvalues: u1 (copy)
    if p14:IsA("MeshPart") and (p14.Anchored == true and (p14.CollisionFidelity == Enum.CollisionFidelity.Hull or p14.CollisionFidelity == Enum.CollisionFidelity.PreciseConvexDecomposition)) then
        return u1:GetPlanesForInstanceMeshPart(p14, p15, p16, p17, p18);
    end;

    local v19 = p13:GeneratePointsForInstance(p14, p15, p16);

    if p18 ~= nil then
        p13:VisualizePlanesForPoints(v19, p18);
    end;

    return p13:GetPlanesForPoints(v19, p17);
end;

function u1.GetPlanesForPointsExpanded(p20, p21, p22, p23, p24) -- Line: 130
    -- upvalues: u2 (copy)
    local v25 = {};

    for _, v in pairs(p21) do
        for _, v2 in pairs(u2) do
            table.insert(v25, v + v2 * p22);
        end;
    end;

    if p24 ~= nil then
        p20:VisualizePlanesForPoints(v25, p24);
    end;

    return p20:GetPlanesForPoints(v25, p23);
end;

function u1.VisualizePlanesForPoints(p26, p27) -- Line: 145
    -- upvalues: QuickHull2 (copy)
    p26:VisualizeTriangles(QuickHull2:GenerateHull(p27), Vector3.new(0, 0, 0));
end;

function u1.VisualizeTriangles(p28, p29, p30) -- Line: 154
    -- upvalues: TrianglePart (copy)
    local v31 = Color3.fromHSV(math.random(), 0.5, 1);

    for _, v in pairs(p29) do
        local v32, v33 = TrianglePart:Triangle(v[1] + p30, v[2] + p30, v[3] + p30);
        v32.Parent = game.Workspace.Terrain;
        v32.Color = v31;
        v33.Parent = game.Workspace.Terrain;
        v33.Color = v31;
        local unit = (v[1] - v[2]):Cross(v[1] - v[3]).unit;
        local v34 = (v[1] + v[2] + v[3]) / 3;
        local Part = Instance.new("Part");
        Part.Size = Vector3.new(0.1, 0.1, 2);
        Part.CFrame = CFrame.lookAt(v34 + unit, v34 + unit * 2);
        Part.Parent = game.Workspace.Terrain;
        Part.CanCollide = false;
        Part.Anchored = true;
    end;
end;

function u1.GetPlanesForPoints(p35, p36, p37) -- Line: 178
    -- upvalues: QuickHull2 (copy), IsUnique (copy)
    local v38 = QuickHull2:GenerateHull(p36);
    local v39 = {};

    if v38 ~= nil then
        for _, v in pairs(v38) do
            local unit = (v[1] - v[2]):Cross(v[1] - v[3]).unit;
            local v40 = v[1]:Dot(unit);
            p37 = p37 + 1;

            if IsUnique(v39, unit, v40) then
                table.insert(v39, {
                    n = unit,
                    ed = v40,
                    planeNum = p37
                });
            end;
        end;
    end;

    return v39, p37;
end;

function u1.GetPlanePointForPoints(p41, p42) -- Line: 204
    -- upvalues: QuickHull2 (copy), IsUniqueTri (copy)
    local v43 = QuickHull2:GenerateHull(p42);
    local v44 = {};

    if v43 ~= nil then
        for _, v in pairs(v43) do
            local unit = (v[1] - v[2]):Cross(v[1] - v[3]).unit;
            local v45 = v[1]:Dot(unit);

            if IsUniqueTri(v44, unit, v45) then
                table.insert(v44, {
                    v[1],
                    v[2],
                    v[3],
                    unit,
                    v45
                });
            end;
        end;
    end;

    return v44;
end;

function u1.PointInsideHull(p46, p47, p48) -- Line: 224
    for _, v in pairs(p47) do
        if p48:Dot(v.n) - v.ed > 0 then
            return true;
        end;
    end;

    return false;
end;

function u1.GeneratePointsForInstance(p49, p50, p51, p52) -- Line: 235
    -- upvalues: u2 (copy), u3 (copy), u4 (copy)
    local v53 = {};
    local v54 = u2;

    if p50:IsA("Part") then
        v54 = u2;
    elseif p50:IsA("WedgePart") then
        v54 = u3;
    elseif p50:IsA("CornerWedgePart") then
        v54 = u4;
    end;

    for _, v in pairs(v54) do
        local v55 = p52 * CFrame.new(v * p50.Size);

        for _, v2 in pairs(u2) do
            table.insert(v53, (v55 + v2 * p51).Position);
        end;
    end;

    return v53;
end;

function u1.GetRaytraceInstancePoints(p56, p57, p58) -- Line: 263
    -- upvalues: QuickHull2 (copy), IsUnique (copy)
    local v59 = os.clock();
    local v60 = p56.meshCache[p57.MeshId];

    if v60 == nil then
        print("Raytracing ", p57.Name, p57.MeshId);

        local function AddUnique(p61, p62) -- Line: 272
            for _, v in pairs(p61) do
                if (v - p62).magnitude < 0.1 then
                    return;
                end;
            end;

            table.insert(p61, p62);
        end;

        local v63 = p57:Clone();
        v63.CFrame = CFrame.new(Vector3.new(0, 0, 0));
        v63.Size = Vector3.new(1, 1, 1);
        v63.Parent = game.Workspace;
        v63.CanQuery = true;
        local v64 = RaycastParams.new();
        v64.FilterType = Enum.RaycastFilterType.Include;
        v64.FilterDescendantsInstances = { v63 };
        v60 = {};

        for i = -0.5, 0.5, 0.2 do
            for i2 = -0.5, 0.5, 0.2 do
                local v65 = Vector3.new(i, -2, i2);
                local v66 = game.Workspace:Raycast(v65, Vector3.new(0, 4, 0), v64);

                if v66 then
                    local Position = v66.Position;
                    local _ = v60;

                    for _, v in pairs(v60) do
                        if (v - Position).magnitude < 0.1 then
                            break;
                        end;
                    end;

                    local v67 = Vector3.new(i, 2, i2);
                    local v68 = game.Workspace:Raycast(v67, Vector3.new(0, -4, 0), v64);

                    if v68 then
                        local Position2 = v68.Position;
                        local _ = v60;

                        for _, v in pairs(v60) do
                            if (v - Position2).magnitude < 0.1 then
                                break;
                            end;
                        end;
                    end;
                end;
            end;
        end;

        for i = -0.5, 0.5, 0.2 do
            for i2 = -0.5, 0.5, 0.2 do
                local v69 = Vector3.new(-2, i, i2);
                local v70 = game.Workspace:Raycast(v69, Vector3.new(4, 0, 0), v64);

                if v70 then
                    local Position = v70.Position;
                    local _ = v60;

                    for _, v in pairs(v60) do
                        if (v - Position).magnitude < 0.1 then
                            break;
                        end;
                    end;

                    local v71 = Vector3.new(2, i, i2);
                    local v72 = game.Workspace:Raycast(v71, Vector3.new(-4, 0, 0), v64);

                    if v72 then
                        local Position2 = v72.Position;
                        local _ = v60;

                        for _, v in pairs(v60) do
                            if (v - Position2).magnitude < 0.1 then
                                break;
                            end;
                        end;
                    end;
                end;
            end;
        end;

        for i = -0.5, 0.5, 0.2 do
            for i2 = -0.5, 0.5, 0.2 do
                local v73 = Vector3.new(i, i2, -2);
                local v74 = game.Workspace:Raycast(v73, Vector3.new(0, 0, 4), v64);

                if v74 then
                    local Position = v74.Position;
                    local _ = v60;

                    for _, v in pairs(v60) do
                        if (v - Position).magnitude < 0.1 then
                            break;
                        end;
                    end;

                    local v75 = Vector3.new(i, i2, 2);
                    local v76 = game.Workspace:Raycast(v75, Vector3.new(0, 0, -4), v64);

                    if v76 then
                        local Position2 = v76.Position;
                        local _ = v60;

                        for _, v in pairs(v60) do
                            if (v - Position2).magnitude < 0.1 then
                                break;
                            end;
                        end;
                    end;
                end;
            end;
        end;

        v63:Destroy();
        local v77 = QuickHull2:GenerateHull(v60);

        if v77 == nil then
            p56.meshCache[p57.MeshId] = {};
        else
            local v78 = {};

            for _, v in pairs(v77) do
                local unit = (v[1] - v[2]):Cross(v[1] - v[3]).unit;
                local v79 = v[1]:Dot(unit);

                if IsUnique(v78, unit, v79) then
                    table.insert(v78, {
                        n = unit,
                        ed = v79,
                        tri = v
                    });
                end;
            end;

            local v80 = {};

            for _, v in pairs(v78) do
                local v81 = v.tri[1];
                local v82 = true;

                for _, v2 in pairs(v80) do
                    if (v2 - v81).magnitude < 0.001 then
                        v82 = false;
                        break;
                    end;
                end;

                if v82 then
                    table.insert(v80, v.tri[1]);
                end;

                local v83 = v.tri[2];
                local v84 = true;

                for _, v2 in pairs(v80) do
                    if (v2 - v83).magnitude < 0.001 then
                        v84 = false;
                        break;
                    end;
                end;

                if v84 then
                    table.insert(v80, v.tri[2]);
                end;

                local v85 = v.tri[3];
                local v86 = true;

                for _, v2 in pairs(v80) do
                    if (v2 - v85).magnitude < 0.001 then
                        v86 = false;
                        break;
                    end;
                end;

                if v86 then
                    table.insert(v80, v.tri[3]);
                end;
            end;

            p56.meshCache[p57.MeshId] = v80;
        end;
    end;

    local Size = p57.Size;
    local v87 = {};

    for _, v in pairs(v60) do
        local v88 = p58:PointToWorldSpace(v * Size);
        table.insert(v87, v88);
    end;

    p56.timeSpentTracing = p56.timeSpentTracing + (os.clock() - v59);

    return v87;
end;

function u1.GetPlanesForInstanceMeshPart(p89, p90, p91, p92, p93, p94) -- Line: 413
    -- upvalues: u2 (copy), QuickHull2 (copy), IsUnique (copy)
    local v95 = p89:GetRaytraceInstancePoints(p90, p92);
    local v96 = {};

    for _, v in pairs(v95) do
        for _, v2 in pairs(u2) do
            table.insert(v96, v + v2 * p91);
        end;
    end;

    local v97 = QuickHull2:GenerateHull(v96);
    local v98 = {};

    if v97 == nil then
        return nil, p93;
    end;

    for _, v in pairs(v97) do
        local unit = (v[1] - v[2]):Cross(v[1] - v[3]).unit;
        local v99 = v[1]:Dot(unit);
        p93 = p93 + 1;

        if IsUnique(v98, unit, v99) then
            table.insert(v98, {
                n = unit,
                ed = v99,
                planeNum = p93
            });
        end;
    end;

    return v98, p93;
end;

return u1;