-- Decompiled with Potassium's decompiler.

game:GetService("MaterialService");

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u1, p2, p3) -- Line: 9, Name: InitPlant
        local MaterialService = game:GetService("MaterialService");
        local u4 = Random.new(p2);
        local FruitSpawnLocations = u1.FruitSpawnLocations;
        local Base = u1.Base;

        local function GetRandomHSV(p5, p6) -- Line: 23
            -- upvalues: u4 (copy)
            local v7, v8, v9 = p5:ToHSV();
            local v10 = p6 or 0.05;
            local v11 = v7 + u4:NextNumber(-v10, v10);
            local v12 = math.clamp(v11, 0, 0.99);

            return Color3.fromHSV(v12, v8, v9), v12, v8, v9;
        end;

        local function GetColorWithRange(p13, p14) -- Line: 67
            local v15, v16, v17 = p13:ToHSV();

            return Color3.fromHSV(v15 + p14, v16, v17);
        end;

        local function AddGradient(p18) -- Line: 73
            for _, child in script.Gradient:GetChildren() do
                child:Clone().Parent = p18;
            end;
        end;

        local v19 = ((p3 or 1) * 0.25 + 0.75) * 0.7;
        local v20 = Color3.fromRGB(154, 89, 23);
        local v21 = Color3.fromRGB(231, 122, 43);
        local v22 = u4:NextNumber(4.3, 4.8) * v19;
        local v23 = u4:NextNumber(6.7, 7.3) * v19;
        local v24 = Vector3.new(v22, v23, v22);
        local v25 = Vector3.new(v22 * 0.6, v23 * 0.675, v22 * 0.6);
        local v26 = u4:NextInteger(5, 7);
        local v27 = u4:NextNumber(0.75, 2);
        local CFrame2 = Base.CFrame;

        local function CreatePart(p28, p29, p30) -- Line: 31
            -- upvalues: u1 (copy), MaterialService (copy)
            local Part = Instance.new("Part");
            local v31 = p28 or "Studs";
            Part.Parent = u1;
            Part.TopSurface = Enum.SurfaceType[v31];
            Part.BackSurface = Enum.SurfaceType[v31];
            Part.FrontSurface = Enum.SurfaceType[v31];
            Part.BottomSurface = Enum.SurfaceType[v31];
            Part.LeftSurface = Enum.SurfaceType[v31];
            Part.RightSurface = Enum.SurfaceType[v31];
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Transparency = 0;

            for _, child in pairs(script:GetChildren()) do
                if child:IsA("Texture") then
                    child:Clone().Parent = Part;
                end;
            end;

            if p30 then
                Part.Shape = Enum.PartType[p30];
            end;

            if p29 then
                Part.MaterialVariant = p29;
                local v32 = MaterialService:FindFirstChild(p29, true);

                if not v32 then
                    return Part;
                end;

                Part.Material = v32.BaseMaterial;
            end;

            return Part;
        end;

        local v33 = 0;

        while u4:NextInteger(1, 100) == 1 do
            v26 = v26 * 2;
        end;

        local v34 = math.floor(v26);

        for i = 1, v34 do
            local v35 = CreatePart(nil, "2022 Stud Bark");
            v35.Size = v24:Lerp(v25, (i - 1) / v34);
            local Angles = CFrame.Angles;
            local v36 = u4:NextNumber(-5, 5) / v27;
            local v37 = math.rad(v36);
            local v38 = u4:NextNumber(-5, 5) / v27;
            v35.CFrame = CFrame2 * Angles(v37, 0, (math.rad(v38))) * CFrame.new(0, v35.Size.Y / 2.2, 0);
            v35.Color = v20;
            v35.Name = i;

            if i > 2 then
                for i2 = 1, 4 do
                    local v39 = Vector3.new(v35.Size.X * 0.5, v35.Size.Y * 0.65, v35.Size.Z * 0.5);
                    local v40 = v39 * 0.8;
                    local v41 = v35.CFrame * CFrame.new(0, -v35.Size.Y / 2, 0) * CFrame.Angles(0, math.rad(i2 * 90 + v33), 0) * CFrame.Angles(1.5707963267948966, 0, 0) * CFrame.new(0, v35.Size.X / 2, 0);

                    for i3 = 1, 3 do
                        local v42 = CreatePart(nil, "2022 Stud Bark");
                        v42.Size = v39:Lerp(v40, (i3 - 1) / 3);
                        local Angles2 = CFrame.Angles;
                        local v43 = u4:NextNumber(-15, 7);
                        local v44 = math.rad(v43);
                        local v45 = u4:NextNumber(-7, 7);
                        v42.CFrame = v41 * Angles2(v44, 0, (math.rad(v45))) * CFrame.new(0, v42.Size.Y / 2.2, 0);
                        v42.Color = v20;
                        v42.Name = i3 + i;

                        if i3 == 1 then
                            local v46 = CreatePart(nil, "2022 Stud Bark");
                            v46.Size = Vector3.new(v42.Size.X * 0.75, v42.Size.Y, v42.Size.Z * 0.75);
                            v46.CFrame = v42.CFrame * CFrame.Angles(-0.7853981633974483, 0, 0) * CFrame.new(0, -v46.Size.Y / 2, 0);
                            v46.Color = v20;
                            v46.Name = i3 + i;
                        end;

                        v41 = v42.CFrame * CFrame.new(0, v42.Size.Y / 2.2, 0);

                        if i3 == 3 then
                            local v47 = CreatePart(nil, "Studs 2x2 Plastic");
                            v47.Size = Vector3.new(1, 1, 1) * (v39.X * u4:NextNumber(3.3, 4.5));
                            v47.CFrame = v41 * CFrame.new(0, v47.Size.Y / 2.25, 0) * CFrame.Angles(-1.5707963267948966, 0, 0);
                            local v48 = u4:NextNumber(-4, 4);
                            local v49 = math.rad(v48);
                            local Y = v47.Orientation.Y;
                            local v50 = u4:NextNumber(-4, 4);
                            local v51 = math.rad(v50);
                            v47.Orientation = Vector3.new(v49, Y, v51);
                            v47.Color = v21;
                            v47.Name = i + 3 + 1;
                            local v52 = {};

                            for _ = 1, u4:NextInteger(6, 9) do
                                local v53 = CreatePart(nil, "Studs 2x2 Plastic");
                                local v54 = u4:NextNumber(v47.Size.X * 0.35, v47.Size.X * 0.7);
                                v53.Size = Vector3.new(1, 1, 1) * v54;
                                local v55 = u4:NextNumber(0, 360);
                                local v56 = math.rad(v55);
                                local v57 = math.cos(v56) * (v47.Size.X / 2);
                                local v58 = math.rad(v55);
                                local v59 = math.sin(v58) * (v47.Size.Z / 2);
                                local v60 = u4:NextNumber(v54 * -0.25, v54 * 0.125);
                                local v61 = math.rad(v55);
                                local v62 = v57 - math.cos(v61) * v60;
                                local v63 = math.rad(v55);
                                local v64 = v59 - math.sin(v63) * v60;
                                local v65 = u4:NextNumber(-v47.Size.Y * 0.5, v47.Size.Y * 0.5);
                                v53.CFrame = v47.CFrame * CFrame.new(v62, v65, v64);
                                local v66 = u4:NextNumber(-0.035, 0.015);
                                local v67, v68, v69 = v21:ToHSV();
                                v53.Color = Color3.fromHSV(v67 + v66, v68, v69);
                                v53.Name = i + 3 + 2;
                                table.insert(v52, v53);
                            end;

                            if u4:NextInteger(1, 2) == 1 then
                                local v70 = script.Leaf:Clone();
                                v70.Parent = u1;
                                local v71 = u4:NextNumber(-0.035, 0.015);
                                local v72, v73, v74 = v21:ToHSV();
                                v70.Color = Color3.fromHSV(v72 + v71, v73, v74);
                                v70.Size = v70.Size * v19;
                                local CFrame3 = v47.CFrame;
                                local Angles3 = CFrame.Angles;
                                local v75 = u4:NextNumber(-180, 180);
                                local v76 = math.rad(v75);
                                local v77 = u4:NextNumber(-45, 45);
                                v70.CFrame = CFrame3 * Angles3(0, v76, (math.rad(v77))) * CFrame.new(-v47.Size.X / 2.5 + -v70.Size.X / 2.25, 0, 0);
                                v70.Name = i + 3 + 3;
                            end;

                            local v78 = RaycastParams.new();
                            v78.FilterDescendantsInstances = { v47, v52 };
                            v78.FilterType = Enum.RaycastFilterType.Include;
                            local v79 = v47.CFrame * CFrame.new(u4:NextNumber(-v47.Size.X, v47.Size.X) * 0.4, -v47.Size.Y, u4:NextNumber(-v47.Size.Z, v47.Size.Z) * 0.4);
                            local v80 = workspace:Raycast(v79.Position, Vector3.new(0, 100, 0), v78);

                            if v80 then
                                local v81 = CreatePart();
                                v81.CFrame = CFrame.new(v80.Position) * CFrame.Angles(0, math.rad(v47.Orientation.Y), 3.141592653589793);
                                v81.Size = Vector3.new(1, 1, 1);
                                v81.Transparency = 1;
                                v81.Parent = FruitSpawnLocations;
                            end;
                        end;
                    end;
                end;

                v33 = v33 + 45;
            end;

            CFrame2 = v35.CFrame * CFrame.new(0, v35.Size.Y / 2.2, 0);

            if i == v34 then
                local v82 = CreatePart(nil, "Studs 2x2 Plastic");
                v82.Size = Vector3.new(1, 1, 1) * (v25.X * u4:NextNumber(3.6, 4.2));
                v82.CFrame = CFrame2 * CFrame.new(0, v82.Size.Y / 2.25, 0);
                v82.Color = v21;
                v82.Name = i + 1;

                for _ = 1, u4:NextInteger(6, 10) do
                    local v83 = CreatePart(nil, "Studs 2x2 Plastic");
                    local v84 = u4:NextNumber(v82.Size.X * 0.35, v82.Size.X * 0.7);
                    v83.Size = Vector3.new(1, 1, 1) * v84;
                    local v85 = u4:NextNumber(0, 360);
                    local v86 = math.rad(v85);
                    local v87 = math.cos(v86) * (v82.Size.X / 2);
                    local v88 = math.rad(v85);
                    local v89 = math.sin(v88) * (v82.Size.Z / 2);
                    local v90 = u4:NextNumber(v84 * -0.25, v84 * 0.15);
                    local v91 = math.rad(v85);
                    local v92 = v87 - math.cos(v91) * v90;
                    local v93 = math.rad(v85);
                    local v94 = v89 - math.sin(v93) * v90;
                    local v95 = u4:NextNumber(-v82.Size.Y * 0.3, v82.Size.Y * 0.5);
                    v83.CFrame = v82.CFrame * CFrame.new(v92, v95, v94);
                    local v96 = u4:NextNumber(-0.035, 0.015);
                    local v97, v98, v99 = v21:ToHSV();
                    v83.Color = Color3.fromHSV(v97 + v96, v98, v99);
                    v83.Name = i + 2;
                end;
            end;
        end;

        local v100 = u4:NextNumber(-0.02, 0.02);

        for _, descendant in u1:GetDescendants() do
            if descendant:IsA("BasePart") or descendant:IsA("MeshPart") then
                local v101, v102, v103 = descendant.Color:ToHSV();
                descendant.Color = Color3.fromHSV(math.clamp(v101 + v100, 0.01, 0.99), v102, v103);

                if descendant:FindFirstChild("Decal") then
                    for _, child in descendant:GetChildren() do
                        if child:IsA("Decal") then
                            local v104, v105, v106 = child.Color3:ToHSV();
                            child.Color3 = Color3.fromHSV(math.clamp(v104 + v100, 0.01, 0.99), v105, v106);
                        end;
                    end;
                end;
            end;
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u107) -- Line: 273, Name: BeginPlantGrowth
        local PrimaryPart = u107.PrimaryPart;
        local u108 = {};

        for _, v in u107:QueryDescendants("BasePart") do
            local v109 = tonumber(v.Name);

            if v109 then
                local v110 = not v:GetAttribute("DontShow");
                local v111 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v111, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v110 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v112 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v109,
                    decals = v111
                };
                table.insert(u108, v112);
                v.CanCollide = false;

                if v110 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 308
            -- upvalues: u107 (copy), u108 (copy), PrimaryPart (copy)
            local v113 = u107:GetAttribute("Age") or 0;
            local v114 = u107:GetAttribute("MaxAge") or 1;
            local v115 = v113 / v114;

            for _, v in u108 do
                if not v.part:GetAttribute("DontShow") then
                    if v115 >= 1 then
                        for _, descendant in v.part:GetDescendants() do
                            if descendant:IsA("ParticleEmitter") then
                                descendant.Enabled = true;
                            end;
                        end;
                    end;

                    local v116 = math.clamp((v115 - v.partAge / v114) * v114, 0, 1);

                    if v116 ~= v.lastProgress then
                        v.lastProgress = v116;

                        if v116 > 0 then
                            local v117 = v.maxSize * v116;
                            v.part.Size = v117;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v117.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            if v.part:GetAttribute("GrowZAxis") then
                                v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, 0, (v.maxSize.Z - v117.Z) / 2);
                            end;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v116);
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

        u107:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};