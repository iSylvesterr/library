-- Decompiled with Potassium's decompiler.

local MaterialService = game:GetService("MaterialService");

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u1, p2, p3) -- Line: 11, Name: InitPlant
        -- upvalues: MaterialService (copy)
        local u4 = Random.new(p2);
        local _ = u1.FruitSpawnLocations;
        local Base = u1.Base;

        local function GetRandomHSV(p5, p6) -- Line: 20
            -- upvalues: u4 (copy)
            local v7, v8, v9 = p5:ToHSV();
            local v10 = p6 or 0.05;
            local v11 = v7 + u4:NextNumber(-v10, v10);

            return Color3.fromHSV(v11, v8, v9), v11, v8, v9;
        end;

        local function CreatePart(p12, p13, p14) -- Line: 28
            -- upvalues: u1 (copy), MaterialService (ref)
            local Part = Instance.new("Part");
            local v15 = p12 or "Studs";
            Part.Parent = u1;
            Part.TopSurface = Enum.SurfaceType[v15];
            Part.BackSurface = Enum.SurfaceType[v15];
            Part.FrontSurface = Enum.SurfaceType[v15];
            Part.BottomSurface = Enum.SurfaceType[v15];
            Part.LeftSurface = Enum.SurfaceType[v15];
            Part.RightSurface = Enum.SurfaceType[v15];
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Transparency = 1;

            if p14 then
                Part.Shape = Enum.PartType[p14];
            end;

            if p13 then
                Part.MaterialVariant = p13;
                local v16 = MaterialService:FindFirstChild(p13, true);

                if not v16 then
                    return Part;
                end;

                Part.Material = v16.BaseMaterial;
            end;

            return Part;
        end;

        local u17 = u1:WaitForChild("1");
        local v18, v19, v20 = Color3.fromRGB(104, 171, 80):ToHSV();
        local v21 = 0.03 or 0.05;
        local v22 = v18 + u4:NextNumber(-v21, v21);
        u17.Color = Color3.fromHSV(v22, v19, v20);
        local u23 = Vector3.new(0.53, 1.2, 0.53) * Vector3.new(1, p3 or 1, 1);
        local _ = Base.CFrame;
        local v24 = u4:NextInteger(1, 4);
        local u25 = nil;
        local u26 = 3;

        while u4:NextInteger(1, 5) == 1 and v24 < 20 do
            v24 = v24 + 1;
        end;

        local function generateTrunk(p27, p28, p29) -- Line: 81
            -- upvalues: u23 (copy), u4 (copy), u25 (ref), u17 (copy), u26 (ref), u1 (copy)
            local v30 = p27:GetPivot() * CFrame.new(0, p27.Size.Y / 2, 0);

            for i = 1, p28 do
                local v31 = script.Stud_Part:Clone();
                local X = u23.X;
                local v32 = u23.Y + u4:NextNumber(-0.25, 0.5);
                local Angles = CFrame.Angles;
                local v33 = u4:NextNumber(-12, 12);
                local v34 = math.rad(v33);
                local v35 = u4:NextNumber(-15, 15);
                local v36 = math.rad(v35);
                local v37 = u4:NextNumber(-11, 4);
                local v38 = Angles(v34, v36, (math.rad(v37)));
                local new = CFrame.new;
                local Position = v30.Position;
                local v39 = u4:NextNumber(-5, 5);
                local v40 = u4:NextNumber(-5, 5);
                new(Position + Vector3.new(v39, v40, u4:NextNumber(-5, 5)));
                local v41, v42, v43 = Color3.fromRGB(101, 182, 79):ToHSV();
                local v44 = 0.03 or 0.05;
                local v45 = v41 + u4:NextNumber(-v44, v44);
                v31.Color = Color3.fromHSV(v45, v42, v43);
                v31.Size = Vector3.new(X, v32, X);
                local v46 = 0;

                if i == 1 then
                    local Angles2 = CFrame.Angles;
                    local v47 = u4:NextNumber(-5, 5);
                    local v48 = math.rad(v47);
                    local v49 = math.rad(p29);
                    local v50 = u4:NextNumber(-25, -15);
                    v38 = Angles2(v48, v49, (math.rad(v50)));
                else
                    v46 = u25.Size.Y;
                    v30 = u25:GetPivot();

                    if math.ceil(p28 / 2.5) <= i then
                        local Angles2 = CFrame.Angles;
                        local v51 = u4:NextNumber(-10, 10);
                        local v52 = math.rad(v51);
                        local v53 = u4:NextNumber(-10, -5);
                        v38 = Angles2(v52, 0, (math.rad(v53)));
                    end;

                    if i > 5 then
                        local Angles2 = CFrame.Angles;
                        local v54 = u4:NextNumber(-15, 15);
                        local v55 = math.rad(v54);
                        local v56 = u4:NextNumber(-15, 15);
                        local v57 = math.rad(v56);
                        local v58 = u4:NextNumber(-5, 15);
                        v38 = Angles2(v55, v57, (math.rad(v58)));
                    end;
                end;

                v31.CFrame = v30 * CFrame.new(0, v46 / 2.1, 0) * v38 * CFrame.new(0, v32 / 2.1, 0);

                if u17.Position.Y > v31.Position.Y then
                    local v59 = v30 * CFrame.new(0, v46 / 2.1, 0);
                    local v60 = u4:NextNumber(-0.2, 0.2);
                    local Unit = Vector3.new(v60, 1, u4:NextNumber(-0.2, 0.2)).Unit;
                    local _, v61, _ = v38:ToEulerAnglesYXZ();
                    v31.CFrame = v59 * (CFrame.new(Vector3.new(0, 0, 0), Unit) * CFrame.Angles(0, v61, 0)) * CFrame.new(0, v32 / 2.1, 0);
                end;

                v31.Name = u26;
                v31.Parent = u1;

                if u4:NextInteger(1, 5) == 1 then
                    local v62 = script.Leaf:Clone();
                    local v63 = v31:GetPivot();
                    local Angles2 = CFrame.Angles;
                    local v64 = u4:NextInteger(0, 360);
                    local v65 = math.rad(v64);
                    local v66 = u4:NextInteger(60, 120);
                    v62:PivotTo(v63 * Angles2(0, v65, (math.rad(v66))));

                    for _, child in v62:GetChildren() do
                        child.Name = tonumber(child.Name) + u26;
                        child.Parent = u1;
                    end;
                end;

                if i == p28 then
                    local v67 = script.Flowertop:Clone();
                    local v68 = v31:GetPivot() * CFrame.new(0, v31.Size.Y / 2, 0);
                    local Angles2 = CFrame.Angles;
                    local v69 = u4:NextInteger(0, 360);
                    v67:PivotTo(v68 * Angles2(0, math.rad(v69), 0));
                    v67.Name = u26 + 1;
                    v67.Parent = u1;
                end;

                u26 = u26 + 1;
                u25 = v31;
            end;

            local v70 = script.Leaf:Clone();
            local v71 = u25:GetPivot();
            local Angles = CFrame.Angles;
            local v72 = u4:NextInteger(0, 360);
            local v73 = math.rad(v72);
            local v74 = u4:NextInteger(60, 120);
            v70:PivotTo(v71 * Angles(0, v73, (math.rad(v74))));

            for _, child in v70:GetChildren() do
                child.Name = tonumber(child.Name) + tonumber(u25.Name);
                child.Parent = u1;
            end;

            u25 = nil;
        end;

        for i = 1, v24 do
            local v75 = u4:NextInteger(3, 7);

            while u4:NextInteger(1, 8) == 1 and v75 < 20 do
                v75 = v75 + 1;
            end;

            generateTrunk(u17, math.floor(v75), 360 / v24 * i + u4:NextInteger(-15, 15));
        end;

        while u4:NextInteger(1, 7) == 1 and #u1.FruitSpawnLocations:GetChildren() < 10 do
            local v76 = u1.FruitSpawnLocations.part:Clone();
            local v77 = v76:GetPivot();
            local Angles = CFrame.Angles;
            local v78 = u4:NextInteger(0, 360);
            v76:PivotTo(v77 * Angles(0, 0, (math.rad(v78))));
            v76.Parent = u1.FruitSpawnLocations;
        end;

        for _, child in u1.FruitSpawnLocations:GetChildren() do
            local v79 = child:GetPivot();
            local Angles = CFrame.Angles;
            local v80 = u4:NextInteger(-3, 3);
            local v81 = math.rad(v80);
            local v82 = u4:NextInteger(-3, 3);
            local v83 = math.rad(v82);
            local v84 = u4:NextInteger(-3, 3);
            child:PivotTo(v79 * Angles(v81, v83, (math.rad(v84))));
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u85) -- Line: 201, Name: BeginPlantGrowth
        local PrimaryPart = u85.PrimaryPart;
        local u86 = {};

        for _, v in u85:QueryDescendants("BasePart") do
            local v87 = tonumber(v.Name);

            if v87 then
                local v88 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v87
                };
                table.insert(u86, v88);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 219
            -- upvalues: u85 (copy), u86 (copy), PrimaryPart (copy)
            local v89 = u85:GetAttribute("Age") or 0;

            for _, v in u86 do
                local v90 = v[1];
                local v91 = v[2];
                local v92 = v[3];
                local v93 = math.min(v89 - v[4], 1);
                local v94 = math.clamp(v93, 0, 1);

                if v94 ~= v.lastProgress then
                    v.lastProgress = v94;

                    if v93 > 0 then
                        v90.Size = Vector3.new(v91.X, v91.Y * v93, v91.Z);
                        v90.CFrame = PrimaryPart.CFrame * v92 * CFrame.new(0, (v90.Size.Y - v91.Y) / 2, 0);
                        v90.Transparency = v90:GetAttribute("OG_Transparency") or 0;
                        v90.CanCollide = true;
                    else
                        v90.Transparency = 1;
                        v90.CanCollide = false;
                    end;
                end;
            end;
        end;

        u85:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};