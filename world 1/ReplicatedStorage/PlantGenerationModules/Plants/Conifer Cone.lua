-- Decompiled with Potassium's decompiler.

game:GetService("MaterialService");

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u1, p2, p3) -- Line: 9, Name: InitPlant
        local MaterialService = game:GetService("MaterialService");
        local v4 = (p3 or 1) * 0.25 + 0.75;
        local u5 = Random.new(p2);
        local FruitSpawnLocations = u1.FruitSpawnLocations;
        local Base = u1.Base;

        local function GetRandomHSV(p6, p7) -- Line: 23
            -- upvalues: u5 (copy)
            local v8, v9, v10 = p6:ToHSV();
            local v11 = p7 or 0.05;
            local v12 = v8 + u5:NextNumber(-v11, v11);
            local v13 = math.clamp(v12, 0, 0.99);

            return Color3.fromHSV(v13, v9, v10), v13, v9, v10;
        end;

        local function GetColorWithRange(p14, p15) -- Line: 67
            local v16, v17, v18 = p14:ToHSV();

            return Color3.fromHSV(v16 + p15, v17, v18);
        end;

        local function AddGradient(p19) -- Line: 73
            for _, child in script.Gradient:GetChildren() do
                child:Clone().Parent = p19;
            end;
        end;

        local v20 = Color3.fromRGB(154, 89, 23);
        local v21 = Color3.fromRGB(231, 122, 43);
        local v22 = u5:NextNumber(4.3, 4.8) * v4;
        local v23 = u5:NextNumber(6.7, 7.3) * v4;
        local v24 = Vector3.new(v22, v23, v22);
        local v25 = Vector3.new(v22 * 0.6, v23 * 0.675, v22 * 0.6);
        local v26 = u5:NextInteger(5, 7);
        local v27 = u5:NextNumber(0.75, 2);
        local CFrame2 = Base.CFrame;
        local v28 = 0;

        local function CreatePart(p29, p30, p31) -- Line: 31
            -- upvalues: u1 (copy), MaterialService (copy)
            local Part = Instance.new("Part");
            local v32 = p29 or "Studs";
            Part.Parent = u1;
            Part.TopSurface = Enum.SurfaceType[v32];
            Part.BackSurface = Enum.SurfaceType[v32];
            Part.FrontSurface = Enum.SurfaceType[v32];
            Part.BottomSurface = Enum.SurfaceType[v32];
            Part.LeftSurface = Enum.SurfaceType[v32];
            Part.RightSurface = Enum.SurfaceType[v32];
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Transparency = 0;

            for _, child in pairs(script:GetChildren()) do
                if child:IsA("Texture") then
                    child:Clone().Parent = Part;
                end;
            end;

            if p31 then
                Part.Shape = Enum.PartType[p31];
            end;

            if p30 then
                Part.MaterialVariant = p30;
                local v33 = MaterialService:FindFirstChild(p30, true);

                if not v33 then
                    return Part;
                end;

                Part.Material = v33.BaseMaterial;
            end;

            return Part;
        end;

        while u5:NextInteger(1, 100) == 1 do
            v26 = v26 * 2;
        end;

        local v34 = math.floor(v26);

        for i = 1, v34 do
            local v35 = CreatePart(nil, "2022 Stud Bark");
            v35.Size = v24:Lerp(v25, (i - 1) / v34);
            local Angles = CFrame.Angles;
            local v36 = u5:NextNumber(-5, 5) / v27;
            local v37 = math.rad(v36);
            local v38 = u5:NextNumber(-5, 5) / v27;
            v35.CFrame = CFrame2 * Angles(v37, 0, (math.rad(v38))) * CFrame.new(0, v35.Size.Y / 2.2, 0);
            v35.Color = v20;
            v35.Name = i;

            if i == 1 then
                local v39 = u5:NextInteger(3, 4);
                local v40 = {
                    Vector3.new(v35.Size.X / 2, -v35.Size.Y / 2, v35.Size.Z / 2),
                    Vector3.new(-v35.Size.X / 2, -v35.Size.Y / 2, v35.Size.Z / 2),
                    Vector3.new(v35.Size.X / 2, -v35.Size.Y / 2, -v35.Size.Z / 2),
                    (Vector3.new(-v35.Size.X / 2, -v35.Size.Y / 2, -v35.Size.Z / 2))
                };

                for i2 = #v40, 2, -1 do
                    local v41 = u5:NextInteger(1, i2);
                    local v42 = v40[i2];
                    v40[i2] = v40[v41];
                    v40[v41] = v42;
                end;

                for i2 = 1, v39 do
                    local v43 = CreatePart(nil, "2022 Stud Bark");
                    local v44 = v40[i2];
                    local v45 = v35.Size.X * u5:NextNumber(0.6, 0.8);
                    local v46 = v35.Size.Y * u5:NextNumber(0.4, 0.8);
                    local v47 = v35.Size.Z * u5:NextNumber(0.6, 0.8);
                    v43.Size = Vector3.new(v45, v46, v47);
                    local v48 = v35.CFrame * CFrame.new(v44) * CFrame.new(u5:NextNumber(-v43.Size.X * 1.5, v43.Size.X * 0.5) * 0.2, v43.Size.Y / 2, u5:NextNumber(-v43.Size.Z * 1.5, v43.Size.Z * 0.5) * 0.2);
                    local Angles2 = CFrame.Angles;
                    local v49 = u5:NextNumber(-10, 10);
                    local v50 = math.rad(v49);
                    local v51 = u5:NextNumber(-5, 5);
                    local v52 = math.rad(v51);
                    local v53 = u5:NextNumber(-10, 10);
                    v43.CFrame = v48 * Angles2(v50, v52, (math.rad(v53)));
                    v43.Color = v20;
                    v43.Name = 1;
                end;

                local v54 = u5:NextInteger(3, 4);

                for i2 = 1, v54 do
                    local v55 = u5:NextInteger(2, 3);
                    local v56 = v35.CFrame * CFrame.new(0, -v35.Size.Y * 0.1, 0) * CFrame.Angles(0, math.rad(360 / v54 * i2), 0) * CFrame.Angles(2.181661564992912, 0, 0) * CFrame.new(0, v35.Size.X * 0.35, 0);
                    local v57 = Vector3.new(v35.Size.X * 0.7, v35.Size.Y * 0.6, v35.Size.Z * 0.7);
                    local v58 = v57 * 0.7;

                    for i3 = 1, v55 do
                        local v59 = CreatePart(nil, "2022 Stud Bark");
                        v59.Size = v57:Lerp(v58, (i3 - 1) / v55);
                        local Angles2 = CFrame.Angles;
                        local v60 = math.rad(i3 <= 2 and -15.5 or 0);
                        local v61 = u5:NextNumber(-20, 20);
                        v59.CFrame = v56 * Angles2(v60, 0, (math.rad(v61))) * CFrame.new(0, v59.Size.Y / 2.25, 0);
                        v59.Color = v20;
                        v59.Name = i3;

                        if u5:NextInteger(1, 3) == 1 then
                            local v62 = CreatePart(nil, "2022 Stud Bark");
                            v62.Size = Vector3.new(v59.Size.X * 0.7, v59.Size.Y * 1.2, v59.Size.Z * 0.7);
                            local v63 = v59.CFrame * CFrame.new(0, -v59.Size.Y / 2, 0);
                            local Angles3 = CFrame.Angles;
                            local v64 = u5:NextInteger(1, 2) == 1 and u5:NextNumber(-65, -35) or u5:NextNumber(35, 65);
                            v62.CFrame = v63 * Angles3(0, 0, (math.rad(v64))) * CFrame.new(0, v62.Size.Y / 2.5 + v59.Size.Z / 2, 0);
                            v62.Color = v20;
                            v62.Name = i3 + 1;
                        end;

                        v56 = v59.CFrame * CFrame.new(0, v59.Size.Y / 2.25, 0);
                    end;
                end;
            end;

            if i > 2 then
                for i2 = 1, 4 do
                    local v65 = Vector3.new(v35.Size.X * 0.5, v35.Size.Y * 0.65, v35.Size.Z * 0.5);
                    local v66 = v65 * 0.8;
                    local v67 = v35.CFrame * CFrame.new(0, -v35.Size.Y / 2, 0) * CFrame.Angles(0, math.rad(i2 * 90 + v28), 0) * CFrame.Angles(1.5707963267948966, 0, 0) * CFrame.new(0, v35.Size.X / 2, 0);

                    for i3 = 1, 3 do
                        local v68 = CreatePart(nil, "2022 Stud Bark");
                        v68.Size = v65:Lerp(v66, (i3 - 1) / 3);
                        local Angles2 = CFrame.Angles;
                        local v69 = u5:NextNumber(-15, 7);
                        local v70 = math.rad(v69);
                        local v71 = u5:NextNumber(-7, 7);
                        v68.CFrame = v67 * Angles2(v70, 0, (math.rad(v71))) * CFrame.new(0, v68.Size.Y / 2.2, 0);
                        v68.Color = v20;
                        v68.Name = i3 + i;

                        if i3 == 1 then
                            local v72 = CreatePart(nil, "2022 Stud Bark");
                            v72.Size = Vector3.new(v68.Size.X * 0.75, v68.Size.Y, v68.Size.Z * 0.75);
                            v72.CFrame = v68.CFrame * CFrame.Angles(-0.7853981633974483, 0, 0) * CFrame.new(0, -v72.Size.Y / 2, 0);
                            v72.Color = v20;
                            v72.Name = i3 + i;
                        end;

                        v67 = v68.CFrame * CFrame.new(0, v68.Size.Y / 2.2, 0);

                        if i3 == 3 then
                            local v73 = CreatePart(nil, "Studs 2x2 Plastic");
                            v73.Size = Vector3.new(1, 1, 1) * (v65.X * u5:NextNumber(3.3, 4.5));
                            v73.CFrame = v67 * CFrame.new(0, v73.Size.Y / 2.25, 0) * CFrame.Angles(-1.5707963267948966, 0, 0);
                            local v74 = u5:NextNumber(-4, 4);
                            local v75 = math.rad(v74);
                            local Y = v73.Orientation.Y;
                            local v76 = u5:NextNumber(-4, 4);
                            local v77 = math.rad(v76);
                            v73.Orientation = Vector3.new(v75, Y, v77);
                            v73.Color = v21;
                            v73.Name = i + 3 + 1;
                            local v78 = {};

                            for _ = 1, u5:NextInteger(6, 9) do
                                local v79 = CreatePart(nil, "Studs 2x2 Plastic");
                                local v80 = u5:NextNumber(v73.Size.X * 0.35, v73.Size.X * 0.7);
                                v79.Size = Vector3.new(1, 1, 1) * v80;
                                local v81 = u5:NextNumber(0, 360);
                                local v82 = math.rad(v81);
                                local v83 = math.cos(v82) * (v73.Size.X / 2);
                                local v84 = math.rad(v81);
                                local v85 = math.sin(v84) * (v73.Size.Z / 2);
                                local v86 = u5:NextNumber(v80 * -0.25, v80 * 0.125);
                                local v87 = math.rad(v81);
                                local v88 = v83 - math.cos(v87) * v86;
                                local v89 = math.rad(v81);
                                local v90 = v85 - math.sin(v89) * v86;
                                local v91 = u5:NextNumber(-v73.Size.Y * 0.5, v73.Size.Y * 0.5);
                                v79.CFrame = v73.CFrame * CFrame.new(v88, v91, v90);
                                local v92 = u5:NextNumber(-0.035, 0.015);
                                local v93, v94, v95 = v21:ToHSV();
                                v79.Color = Color3.fromHSV(v93 + v92, v94, v95);
                                v79.Name = i + 3 + 2;
                                table.insert(v78, v79);
                            end;

                            if u5:NextInteger(1, 2) == 1 then
                                local v96 = script.Leaf:Clone();
                                v96.Parent = u1;
                                local v97 = u5:NextNumber(-0.035, 0.015);
                                local v98, v99, v100 = v21:ToHSV();
                                v96.Color = Color3.fromHSV(v98 + v97, v99, v100);
                                v96.Size = v96.Size * v4;
                                local CFrame3 = v73.CFrame;
                                local Angles3 = CFrame.Angles;
                                local v101 = u5:NextNumber(-180, 180);
                                local v102 = math.rad(v101);
                                local v103 = u5:NextNumber(-45, 45);
                                v96.CFrame = CFrame3 * Angles3(0, v102, (math.rad(v103))) * CFrame.new(-v73.Size.X / 2.5 + -v96.Size.X / 2.25, 0, 0);
                                v96.Name = i + 3 + 3;
                            end;

                            local v104 = RaycastParams.new();
                            v104.FilterDescendantsInstances = { v73, v78 };
                            v104.FilterType = Enum.RaycastFilterType.Include;
                            local v105 = v73.CFrame * CFrame.new(u5:NextNumber(-v73.Size.X, v73.Size.X) * 0.4, -v73.Size.Y, u5:NextNumber(-v73.Size.Z, v73.Size.Z) * 0.4);
                            local v106 = workspace:Raycast(v105.Position, Vector3.new(0, 100, 0), v104);

                            if v106 then
                                local v107 = CreatePart();
                                v107.CFrame = CFrame.new(v106.Position) * CFrame.Angles(0, math.rad(v73.Orientation.Y), 3.141592653589793);
                                v107.Size = Vector3.new(1, 1, 1);
                                v107.Transparency = 1;
                                v107.Parent = FruitSpawnLocations;
                            end;
                        end;
                    end;
                end;

                v28 = v28 + 45;
            end;

            CFrame2 = v35.CFrame * CFrame.new(0, v35.Size.Y / 2.2, 0);

            if i == v34 then
                local v108 = CreatePart(nil, "Studs 2x2 Plastic");
                v108.Size = Vector3.new(1, 1, 1) * (v25.X * u5:NextNumber(3.6, 4.2));
                v108.CFrame = CFrame2 * CFrame.new(0, v108.Size.Y / 2.25, 0);
                v108.Color = v21;
                v108.Name = i + 1;

                for _ = 1, u5:NextInteger(6, 10) do
                    local v109 = CreatePart(nil, "Studs 2x2 Plastic");
                    local v110 = u5:NextNumber(v108.Size.X * 0.35, v108.Size.X * 0.7);
                    v109.Size = Vector3.new(1, 1, 1) * v110;
                    local v111 = u5:NextNumber(0, 360);
                    local v112 = math.rad(v111);
                    local v113 = math.cos(v112) * (v108.Size.X / 2);
                    local v114 = math.rad(v111);
                    local v115 = math.sin(v114) * (v108.Size.Z / 2);
                    local v116 = u5:NextNumber(v110 * -0.25, v110 * 0.15);
                    local v117 = math.rad(v111);
                    local v118 = v113 - math.cos(v117) * v116;
                    local v119 = math.rad(v111);
                    local v120 = v115 - math.sin(v119) * v116;
                    local v121 = u5:NextNumber(-v108.Size.Y * 0.3, v108.Size.Y * 0.5);
                    v109.CFrame = v108.CFrame * CFrame.new(v118, v121, v120);
                    local v122 = u5:NextNumber(-0.035, 0.015);
                    local v123, v124, v125 = v21:ToHSV();
                    v109.Color = Color3.fromHSV(v123 + v122, v124, v125);
                    v109.Name = i + 2;
                end;
            end;
        end;

        local v126 = u5:NextNumber(-0.02, 0.02);

        for _, descendant in u1:GetDescendants() do
            if descendant:IsA("BasePart") or descendant:IsA("MeshPart") then
                local v127, v128, v129 = descendant.Color:ToHSV();
                descendant.Color = Color3.fromHSV(math.clamp(v127 + v126, 0.01, 0.99), v128, v129);

                if descendant:FindFirstChild("Decal") then
                    for _, child in descendant:GetChildren() do
                        if child:IsA("Decal") then
                            local v130, v131, v132 = child.Color3:ToHSV();
                            child.Color3 = Color3.fromHSV(math.clamp(v130 + v126, 0.01, 0.99), v131, v132);
                        end;
                    end;
                end;
            end;
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u133) -- Line: 328, Name: BeginPlantGrowth
        local PrimaryPart = u133.PrimaryPart;
        local u134 = {};

        for _, v in u133:QueryDescendants("BasePart") do
            local v135 = tonumber(v.Name);

            if v135 then
                local v136 = not v:GetAttribute("DontShow");
                local v137 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v137, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v136 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v138 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v135,
                    decals = v137
                };
                table.insert(u134, v138);
                v.CanCollide = false;

                if v136 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 363
            -- upvalues: u133 (copy), u134 (copy), PrimaryPart (copy)
            local v139 = u133:GetAttribute("Age") or 0;
            local v140 = u133:GetAttribute("MaxAge") or 1;
            local v141 = v139 / v140;

            for _, v in u134 do
                if not v.part:GetAttribute("DontShow") then
                    if v141 >= 1 then
                        for _, descendant in v.part:GetDescendants() do
                            if descendant:IsA("ParticleEmitter") then
                                descendant.Enabled = true;
                            end;
                        end;
                    end;

                    local v142 = math.clamp((v141 - v.partAge / v140) * v140, 0, 1);

                    if v142 ~= v.lastProgress then
                        v.lastProgress = v142;

                        if v142 > 0 then
                            local v143 = v.maxSize * v142;
                            v.part.Size = v143;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v143.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            if v.part:GetAttribute("GrowZAxis") then
                                v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, 0, (v.maxSize.Z - v143.Z) / 2);
                            end;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v142);
                            end;
                        else
                            v.part.Transparency = 1;
                            v.part.CanCollide = false;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = 1;
                            end;
                        end;
                    end;
                end;
            end;
        end;

        u133:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};