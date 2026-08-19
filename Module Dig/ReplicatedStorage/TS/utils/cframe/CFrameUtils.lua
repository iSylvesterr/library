-- Decompiled with Potassium's decompiler.

local Workspace = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace;

return {
    CFrameUtils = {
        serialize = function(p1) -- Line: 7, Name: serialize
            local v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13 = p1:GetComponents();

            return {
                v2,
                v3,
                v4,
                v5,
                v6,
                v7,
                v8,
                v9,
                v10,
                v11,
                v12,
                v13
            };
        end,

        deserialize = function(p14) -- Line: 12, Name: deserialize
            if p14 and #p14 == 12 then
                return CFrame.new(p14[1], p14[2], p14[3], p14[4], p14[5], p14[6], p14[7], p14[8], p14[9], p14[10], p14[11], p14[12]);
            end;

            return CFrame.new();
        end,

        pointInsidePart = function(p15, p16) -- Line: 32, Name: pointInsidePart
            local v17 = p16.CFrame:PointToObjectSpace(p15);
            local v18 = p16.Size / 2;
            local v19;

            if math.abs(v17.X) <= v18.X and math.abs(v17.Y) <= v18.Y then
                v19 = math.abs(v17.Z) <= v18.Z;
            else
                v19 = false;
            end;

            return v19;
        end,

        clampPointToPart = function(p20, p21) -- Line: 38, Name: clampPointToPart
            local v22 = p21.CFrame:PointToObjectSpace(p20);
            local v23 = p21.Size / 2;
            local v24 = math.clamp(v22.X, -v23.X, v23.X);
            local v25 = math.clamp(v22.Y, -v23.Y, v23.Y);
            local v26 = math.clamp(v22.Z, -v23.Z, v23.Z);
            local v27 = Vector3.new(v24, v25, v26);

            return p21.CFrame:PointToWorldSpace(v27);
        end,

        collidesAt = function(p28, p29, p30) -- Line: 45, Name: collidesAt
            -- upvalues: Workspace (copy)
            local v31 = OverlapParams.new();
            v31.FilterType = Enum.RaycastFilterType.Include;
            v31.FilterDescendantsInstances = p30;

            return #Workspace:GetPartBoundsInBox(p28, p29, v31) > 0;
        end,

        emergeOrientation = function(p32, p33) -- Line: 52, Name: emergeOrientation
            local v34 = 6 + math.random() * 14;
            local v35 = math.rad(v34);
            local v36 = math.random() * 3.141592653589793 * 2;
            local v37 = math.cos(v36);
            local v38 = math.sin(v36);
            local v39 = Vector3.new(v37, 0, v38);
            local v40 = v39 - p32 * v39:Dot(p32);

            if v40.Magnitude < 0.01 then
                v40 = Vector3.new(1, 0, 0) - p32 * (Vector3.new(1, 0, 0)):Dot(p32);
            end;

            local Unit = v40.Unit;
            local v41 = math.cos(v35);
            local v42 = math.sin(v35);
            local Unit2 = (p32 * v41 + Unit * v42).Unit;
            local v43 = math.random() * 3.141592653589793 * 2;
            local v44 = math.cos(v43);
            local v45 = math.sin(v43);
            local v46 = Vector3.new(v44, 0, v45);
            local v47 = v46 - Unit2 * v46:Dot(Unit2);

            if v47.Magnitude < 0.01 then
                v47 = Unit2:Cross(Vector3.new(1, 0, 0));
            end;

            local Unit3 = v47.Unit;
            local v48 = Unit3:Cross(Unit2);
            local v49 = CFrame.fromMatrix(Vector3.new(0, 0, 0), Unit3, Unit2, v48);

            if p33.X >= p33.Y and p33.X >= p33.Z then
                return v49 * CFrame.Angles(0, 0, 1.5707963267948966);
            end;

            if p33.Z >= p33.Y and p33.Z >= p33.X then
                return v49 * CFrame.Angles(-1.5707963267948966, 0, 0);
            end;

            return v49;
        end
    }
};