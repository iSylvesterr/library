-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);
local u1 = {
    Top = Enum.NormalId.Top,
    Bottom = Enum.NormalId.Bottom,
    Back = Enum.NormalId.Back,
    Front = Enum.NormalId.Front,
    Right = Enum.NormalId.Right,
    Left = Enum.NormalId.Left
};

function getSurfaceCFrame(p2, p3)
    local v4 = CFrame.fromEulerAnglesXYZ(1.5707963267948966, 0, 0);
    local v9 = (function(p5, p6, p7) -- Line: 24, Name: getTranstionBetween
        local v8 = p5:Dot(p6);

        if v8 > 0.99999 then
            return CFrame.new();
        end;

        if v8 < -0.99999 then
            return CFrame.fromAxisAngle(p7, 3.141592653589793);
        end;

        return CFrame.fromAxisAngle(p5:Cross(p6), (math.acos(v8)));
    end)(Vector3.new(0, 1, 0), p3, Vector3.new(0, 0, 1));

    return p2.CFrame * v9 * v4;
end;

function getWorldPosition(p10, p11)
    return (p10.CFrame * CFrame.new(p11 * Vector3.new(-1, 1, 1))).Position;
end;

local u20 = {
    getVertices = function(p12) -- Line: 44, Name: getVertices
        local v13 = p12.Size.X / 2;
        local v14 = p12.Size.Y / 2;
        local v15 = p12.Size.Z / 2;

        return {
            getWorldPosition(p12, (Vector3.new(-v13, -v14, v15))),
            getWorldPosition(p12, (Vector3.new(v13, -v14, -v15))),
            getWorldPosition(p12, (Vector3.new(-v13, -v14, -v15))),
            getWorldPosition(p12, (Vector3.new(-v13, v14, -v15)))
        };
    end,

    getLines = function(p16) -- Line: 60, Name: getLines
        local v17 = p16.Size.X / 2;
        local v18 = p16.Size.Y / 2;
        local v19 = p16.Size.Z / 2;

        return {
            swColumn = { getWorldPosition(p16, (Vector3.new(-v17, -v18, -v19))), getWorldPosition(p16, (Vector3.new(-v17, v18, -v19))) },
            sBorder = { getWorldPosition(p16, (Vector3.new(v17, -v18, -v19))), getWorldPosition(p16, (Vector3.new(-v17, -v18, -v19))) },
            wBorder = { getWorldPosition(p16, (Vector3.new(-v17, -v18, -v19))), getWorldPosition(p16, (Vector3.new(-v17, -v18, v19))) },
            eBorder = { getWorldPosition(p16, (Vector3.new(v17, -v18, -v19))), getWorldPosition(p16, (Vector3.new(-v17, -v18, v19))) },
            wTerrace = { getWorldPosition(p16, (Vector3.new(-v17, v18, -v19))), getWorldPosition(p16, (Vector3.new(-v17, -v18, v19))) },
            seColumn = { getWorldPosition(p16, (Vector3.new(v17, -v18, -v19))), getWorldPosition(p16, (Vector3.new(-v17, v18, -v19))) }
        };
    end
};

function u20.getSurfaces(p21) -- Line: 94
    -- upvalues: u20 (copy), u1 (copy)
    local v22 = u20.getLines(p21);
    local Y = p21.Size.Y;
    local v23 = math.atan2(Y, p21.Size.Z);
    local v24 = math.atan2(Y, p21.Size.X);
    local v25 = {
        Top = getSurfaceCFrame(p21, (Vector3.new(0, 0, 1)):Lerp(Vector3.new(0, 1, 0), (math.cos(v23)))).LookVector,
        Bottom = getSurfaceCFrame(p21, Vector3.new(0, -1, 0)).LookVector,
        Left = getSurfaceCFrame(p21, Vector3.new(1, 0, 0)).LookVector,
        Right = getSurfaceCFrame(p21, (Vector3.new(-1, 0, 0)):Lerp(Vector3.new(0, 1, 0), (math.cos(v24)))).LookVector,
        Back = getSurfaceCFrame(p21, Vector3.new(0, 0, -1)).LookVector
    };
    local v26 = {};

    for i, v in pairs({
        [u1.Top] = { "eBorder", "eTerrace", "wTerrace" },
        [u1.Bottom] = { "sBorder", "eBorder", "wBorder" },
        [u1.Left] = { "swColumn", "wBorder", "wTerrace" },
        [u1.Back] = { "seColumn", "swColumn", "sBorder" }
    }) do
        local v27 = {};

        for _, v2 in pairs(v) do
            table.insert(v27, v22[v2]);
        end;

        v26[i] = {
            Normal = v25[i],
            Lines = v27
        };
    end;

    return v26;
end;

return u20;