-- Decompiled with Potassium's decompiler.

require(script.Parent.Types);
local Part = require(script:WaitForChild("Part"));
local WedgePart = require(script:WaitForChild("WedgePart"));
local TetraPart = require(script:WaitForChild("TetraPart"));
local CornerWedgePart = require(script:WaitForChild("CornerWedgePart"));
local u1 = {};
u1.__index = u1;
u1.TetraPartAssetId = 552212360;

function getSolver(p2)
    -- upvalues: CornerWedgePart (copy), WedgePart (copy), u1 (copy), TetraPart (copy), Part (copy)
    local v3 = nil;

    if p2:IsA("CornerWedgePart") then
        return CornerWedgePart;
    end;

    if p2:IsA("WedgePart") then
        return WedgePart;
    end;

    if p2:IsA("MeshPart") and p2.MeshId == "rbxassetid://" .. tostring(u1.TetraPartAssetId) then
        return TetraPart;
    end;

    if p2:IsA("BasePart") then
        v3 = Part;
    end;

    return v3;
end;

function u1.getVertices(p4) -- Line: 42
    return getSolver(p4).getVertices(p4);
end;

function u1.getLines(p5) -- Line: 48
    return getSolver(p5).getLines(p5);
end;

function u1.getSurfaces(p6) -- Line: 54
    return getSolver(p6).getSurfaces(p6);
end;

function u1.renderTriangle(p7, p8, p9, p10) -- Line: 60
    local v11 = p10 or 0;
    local WedgePart2 = Instance.new("WedgePart");
    WedgePart2.Anchored = true;
    WedgePart2.TopSurface = Enum.SurfaceType.Smooth;
    WedgePart2.BottomSurface = Enum.SurfaceType.Smooth;
    local v12 = WedgePart2:Clone();
    local v13 = p8 - p7;
    local v14 = p9 - p7;
    local v15 = p9 - p8;
    local v16 = v13:Dot(v13);
    local v17 = v14:Dot(v14);
    local v18 = v15:Dot(v15);

    if v17 < v16 and v18 < v16 then
        local v19 = p9;
        p9 = p7;
        p7 = p8;
        p8 = v19;
    elseif v18 < v17 then
        if v16 >= v17 then
            local v20 = p8;
            p8 = p7;
            p7 = v20;
        end;
    else
        local v21 = p8;
        p8 = p7;
        p7 = v21;
    end;

    local v22 = p7 - p8;
    local v23 = p9 - p8;
    local v24 = p9 - p7;
    local Unit = v23:Cross(v22).Unit;
    local Unit2 = v24:Cross(Unit).Unit;
    local Unit3 = v24.Unit;
    local v25 = v22:Dot(Unit2);
    local v26 = math.abs(v25);
    local v27 = v22:Dot(Unit3);
    local v28 = math.abs(v27);
    WedgePart2.Size = Vector3.new(v11, v26, v28);
    WedgePart2.CFrame = CFrame.fromMatrix((p8 + p7) / 2, Unit, Unit2, Unit3);
    local v29 = v23:Dot(Unit3);
    local v30 = math.abs(v29);
    v12.Size = Vector3.new(v11, v26, v30);
    v12.CFrame = CFrame.fromMatrix((p8 + p9) / 2, -Unit, Unit2, -Unit3);

    return WedgePart2, v12;
end;

function u1.solveGreedyMesh(u31) -- Line: 97
    local u32 = {};
    local v33 = {};

    for i, _ in pairs(u31) do
        if u32[i] == nil then
            local function try(p34) -- Line: 105
                -- upvalues: u31 (copy), u32 (copy)
                return u31[p34] ~= nil and u32[p34] == nil;
            end;

            local function tryX(p35) -- Line: 114
                -- upvalues: i (copy), u31 (copy), u32 (copy)
                local v36 = Vector3.new(p35, i.Y, i.Z);

                return u31[v36] ~= nil and u32[v36] == nil;
            end;

            local X = i.X;

            while true do
                local v37 = Vector3.new(X + 1, i.Y, i.Z);

                if u31[v37] == nil or u32[v37] ~= nil then
                    break;
                end;

                X = X + 1;
            end;

            local X2 = i.X;

            while true do
                local v38 = Vector3.new(X2 - 1, i.Y, i.Z);

                if u31[v38] == nil or u32[v38] ~= nil then
                    break;
                end;

                X2 = X2 - 1;
            end;

            local function tryXY(p39) -- Line: 129
                -- upvalues: X2 (ref), X (ref), i (copy), u31 (copy), u32 (copy)
                for i2 = X2, X do
                    local v40 = Vector3.new(i2, p39, i.Z);

                    if u31[v40] == nil or u32[v40] ~= nil then
                        return false;
                    end;
                end;

                return true;
            end;

            local Y = i.Y;

            while tryXY(Y + 1) do
                Y = Y + 1;
            end;

            local Y2 = i.Y;

            while tryXY(Y2 - 1) do
                Y2 = Y2 - 1;
            end;

            local function tryXYZ(p41) -- Line: 148
                -- upvalues: X2 (ref), X (ref), Y2 (ref), Y (ref), u31 (copy), u32 (copy)
                for i2 = X2, X do
                    for i3 = Y2, Y do
                        local v42 = Vector3.new(i2, i3, p41);

                        if u31[v42] == nil or u32[v42] ~= nil then
                            return false;
                        end;
                    end;
                end;

                return true;
            end;

            local Z = i.Z;

            while tryXYZ(Z + 1) do
                Z = Z + 1;
            end;

            local Z2 = i.Z;

            while tryXYZ(Z2 - 1) do
                Z2 = Z2 - 1;
            end;

            local v43 = { Vector3.new(X2, Y2, Z2), (Vector3.new(X, Y, Z)) };
            table.insert(v33, v43);

            for i2 = X2, X do
                for i3 = Y2, Y do
                    for i4 = Z2, Z do
                        u32[Vector3.new(i2, i3, i4)] = #v33;
                    end;
                end;
            end;
        end;
    end;

    return v33;
end;

function u1.getBoundingBoxAtCFrame(p44, p45) -- Line: 186
    -- upvalues: u1 (copy)
    if #p45 == 0 then
        return Vector3.new(0, 0, 0), CFrame.new(0, 0, 0);
    end;

    local v46 = {};
    local v47 = (1 / 0);
    local v48 = (1 / 0);
    local v49 = (1 / 0);
    local v50 = (-1 / 0);
    local v51 = (-1 / 0);
    local v52 = (-1 / 0);

    for _, v in ipairs(p45) do
        local v53 = u1.getVertices(v);

        for _, v2 in ipairs(v53) do
            v46[(p44:Inverse() * CFrame.new(v2)).Position] = true;
        end;
    end;

    for i, _ in pairs(v46) do
        v47 = math.min(i.X, v47);
        v48 = math.min(i.Y, v48);
        v49 = math.min(i.Z, v49);
        v50 = math.max(i.X, v50);
        v51 = math.max(i.Y, v51);
        v52 = math.max(i.Z, v52);
    end;

    local v54 = Vector3.new(v47, v48, v49);
    local v55 = Vector3.new(v50, v51, v52);
    local v56 = p44 * CFrame.fromMatrix(v54:Lerp(v55, 0.5), p44.XVector, p44.YVector, p44.ZVector);

    return v55 - v54, v56;
end;

return u1;