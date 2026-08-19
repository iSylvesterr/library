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

        local function CreatePart(p13, p14, p15) -- Line: 31
            -- upvalues: u1 (copy), MaterialService (copy)
            local Part = Instance.new("Part");
            local v16 = p13 or "Studs";
            Part.Parent = u1;
            Part.TopSurface = Enum.SurfaceType[v16];
            Part.BackSurface = Enum.SurfaceType[v16];
            Part.FrontSurface = Enum.SurfaceType[v16];
            Part.BottomSurface = Enum.SurfaceType[v16];
            Part.LeftSurface = Enum.SurfaceType[v16];
            Part.RightSurface = Enum.SurfaceType[v16];
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Transparency = 0;

            for _, child in pairs(script:GetChildren()) do
                if child:IsA("Texture") then
                    child:Clone().Parent = Part;
                end;
            end;

            if p15 then
                Part.Shape = Enum.PartType[p15];
            end;

            if p14 then
                Part.MaterialVariant = p14;
                local v17 = MaterialService:FindFirstChild(p14, true);

                if not v17 then
                    return Part;
                end;

                Part.Material = v17.BaseMaterial;
            end;

            return Part;
        end;

        local function GetColorWithRange(p18, p19) -- Line: 67
            local v20, v21, v22 = p18:ToHSV();

            return Color3.fromHSV(v20 + p19, v21, v22);
        end;

        local function AddGradient(p23) -- Line: 73
            for _, child in script.Gradient:GetChildren() do
                child:Clone().Parent = p23;
            end;
        end;

        local u24 = math.clamp(((p3 or 1) * 0.25 + 0.75) * 0.85, 0.9, 100);
        local u25 = Color3.fromRGB(97, 48, 3);
        local v26 = Color3.fromRGB(206, 92, 0);
        local v27 = u4:NextNumber(3.1, 3.4);
        local v28 = u4:NextNumber(3.6, 3.8);
        local v29 = Vector3.new(v27, v28, v27) * u24;
        local CFrame2 = Base.CFrame;
        local u30 = 0;
        local v31 = u4:NextInteger(1, 2);
        local v32 = u24 < 1 and 1 or v31;

        local function AttemptExtraStem(p33) -- Line: 105
            -- upvalues: u4 (copy), CreatePart (copy), u24 (ref), u25 (copy), u30 (ref)
            if u4:NextInteger(1, 4) ~= 1 then
                return;
            end;

            local v34 = CreatePart(nil, "2022 Stud Wavy");
            v34.Size = p33.Size * u4:NextNumber(0.6, 0.8) + Vector3.new(0, 1, 0) * (u4:NextNumber(-0.25, 1.5) * u24);
            local v35 = p33.CFrame * CFrame.new(0, -p33.Size.Y / 2, 0);
            local Angles = CFrame.Angles;
            local v36 = u4:NextInteger(1, 4) * 90;
            local v37 = math.rad(v36);
            local v38 = u4:NextNumber(20, 45);
            local v39 = v35 * Angles(0, v37, (math.rad(v38)));
            local Angles2 = CFrame.Angles;
            local v40 = u4:NextNumber(-20, 20);
            v34.CFrame = v39 * Angles2(math.rad(v40), 0, 0) * CFrame.new(0, v34.Size.Y / 2 + p33.Size.Z / 2.5, 0);
            v34.Color = u25;
            v34.Name = u30;
        end;

        local function CreateLeaves(p41, p42) -- Line: 118
            -- upvalues: u4 (copy), u1 (copy), u24 (ref)
            local v43 = u4:NextInteger(2, 3);
            local v44 = u4:NextNumber(80, 100) + (v43 - 2) * 25;
            local v45 = p41 * CFrame.Angles(0, 1.5707963267948966, 0);

            for i = 1, v43 do
                local v46 = script.Leaf:Clone();
                v46.Parent = u1;
                local v47 = -v44 / 2 + (i - 1) / math.max(v43 - 1, 1) * v44;
                v46:ScaleTo(u4:NextNumber(0.14, 0.2) * u24);
                v46:PivotTo(v45 * CFrame.Angles(0, -1.5707963267948966, (math.rad(v47))) * CFrame.Angles(0, 0.3490658503988659, 0));

                for _, child in v46:GetChildren() do
                    child.Name = p42;
                    child.Parent = u1;
                end;

                v46:Destroy();
            end;
        end;

        local v48 = 0;

        local function CreateBranches(p49, p50, p51, p52) -- Line: 142
            -- upvalues: u4 (copy), CreatePart (copy), u25 (copy), CreateLeaves (copy)
            local v53 = p52 or u4:NextNumber(160, 200) * u4:NextInteger(1, 2) - 180;
            local v54 = p49.CFrame * CFrame.new(0, p51 and u4:NextNumber(-p49.Size.Y, p49.Size.Y) * 0.35 or u4:NextNumber(p49.Size.Y * 0.25, p49.Size.Y) * 0.35, 0) * CFrame.Angles(0, math.rad(v53), 0) * CFrame.new(0, 0, p49.Size.Z / 2);
            local v55;

            if p51 then
                v55 = v54 * CFrame.Angles(1.5707963267948966, 0, 0);
            else
                v55 = CFrame.new(v54.Position) * CFrame.Angles(0, math.rad(v53 + p49.Orientation.Y), 0) * CFrame.Angles(1.5707963267948966, 0, 0);
            end;

            local v56 = p49.Size.X * u4:NextNumber(0.3, 0.4);
            local v57 = v56 * u4:NextNumber(2.2, 2.7);
            local v58 = Vector3.new(v56, v57, v56);
            local v59 = v58 * 0.8;

            for i = 1, 2 do
                local v60 = CreatePart(nil, "2022 Stud Wavy");
                v60.Size = v58:Lerp(v59, i / 2);
                local Angles = CFrame.Angles;
                local v61 = u4:NextNumber(15, 30);
                local v62 = math.rad(v61);
                local v63 = u4:NextNumber(-10, 10);
                v60.CFrame = v55 * Angles(v62, 0, (math.rad(v63))) * CFrame.new(0, v60.Size.Y / 2.5, 0);
                v60.Color = u25;
                v60.Name = p50 + i;
                v55 = v60.CFrame * CFrame.new(0, v60.Size.Y / 2.5, 0);

                if i == 2 then
                    CreateLeaves(v55, p50 + i + 1);
                end;
            end;
        end;

        local v64 = 0;
        local v65 = { -45, 45, 45, -45 };

        while v29.X >= v27 * 0.6 do
            u30 = u30 + 1;
            local v66 = CreatePart(nil, "2022 Stud Wavy");
            v66.Size = v29;
            local Angles = CFrame.Angles;
            local v67 = u4:NextNumber(-5, 5);
            v66.CFrame = CFrame2 * Angles(math.rad(v67), 0, (math.rad(v48))) * CFrame.new(0, v66.Size.Y / 2.4, 0);
            v66.Color = u25;
            v66.Name = u30;

            if u30 == 1 then
                local v68 = u4:NextInteger(3, 4);
                local v69 = {
                    Vector3.new(v66.Size.X / 2.5, -v66.Size.Y / 2, v66.Size.Z / 2.5),
                    Vector3.new(-v66.Size.X / 2.5, -v66.Size.Y / 2, v66.Size.Z / 2.5),
                    Vector3.new(v66.Size.X / 2.5, -v66.Size.Y / 2, -v66.Size.Z / 2.5),
                    (Vector3.new(-v66.Size.X / 2.5, -v66.Size.Y / 2, -v66.Size.Z / 2.5))
                };

                for i = #v69, 2, -1 do
                    local v70 = u4:NextInteger(1, i);
                    local v71 = v69[i];
                    v69[i] = v69[v70];
                    v69[v70] = v71;
                end;

                for i = 1, v68 do
                    local v72 = CreatePart(nil, "2022 Stud Wavy");
                    local v73 = v69[i];
                    local v74 = v66.Size.X * u4:NextNumber(0.6, 0.8);
                    local v75 = v66.Size.Y * u4:NextNumber(0.4, 0.8);
                    local v76 = v66.Size.Z * u4:NextNumber(0.6, 0.8);
                    v72.Size = Vector3.new(v74, v75, v76);
                    local v77 = v66.CFrame * CFrame.new(v73) * CFrame.new(u4:NextNumber(-v72.Size.X * 1.5, 0) * 0.2, v72.Size.Y / 2, u4:NextNumber(-v72.Size.Z * 1.5, 0) * 0.2);
                    local Angles2 = CFrame.Angles;
                    local v78 = u4:NextNumber(-10, 10);
                    local v79 = math.rad(v78);
                    local v80 = u4:NextNumber(-5, 5);
                    local v81 = math.rad(v80);
                    local v82 = u4:NextNumber(-10, 10);
                    v72.CFrame = v77 * Angles2(v79, v81, (math.rad(v82)));
                    v72.Color = u25;
                    v72.Name = 1;
                end;

                for i = 1, 4 do
                    local v83 = CreatePart(nil, "2022 Stud Wavy");
                    local v84 = v66.Size.X * u4:NextNumber(0.65, 0.8);
                    v83.Size = Vector3.new(v84, v66.Size.Y * 1.25, v84);
                    local v85 = Base.CFrame * CFrame.new(0, v66.Size.Y * 0.25, 0) * CFrame.Angles(0, math.rad(i * 90), 0) * CFrame.new(0, 0, -v66.Size.Z / 2);
                    local Angles2 = CFrame.Angles;
                    local v86 = u4:NextNumber(-10, 10);
                    v83.CFrame = v85 * Angles2(0.7853981633974483, math.rad(v86), 0);
                    v83.Color = u25;
                    v83.Name = 2;

                    if u4:NextInteger(1, 3) == 1 then
                        CreateBranches(v83, u30, true, -180);
                    end;
                end;
            end;

            if u30 > 2 then
                AttemptExtraStem(v66);
            end;

            if u30 > 1 and u4:NextInteger(1, 4) == 1 then
                local v87 = 180 * u4:NextInteger(1, 2) - 180;
                local v88 = CreatePart(nil, "2022 Stud+Neon");
                v88.Size = Vector3.new(1.2, 1.2, 0.3) * u24;
                v88.CFrame = v66.CFrame * CFrame.Angles(0, math.rad(v87), 0) * CFrame.new(0, 0, -v66.Size.Z / 2 + -v88.Size.Z / 2);
                v88.Color = v26;
                v88.Name = u30 + 1;

                for _ = 1, u4:NextInteger(3, 5) do
                    local v89 = CreatePart(nil, "2022 Stud+Neon");
                    local v90 = u4:NextNumber(0.35, 0.8) * u24;
                    local v91 = u4:NextNumber(0.35, 0.8) * u24;
                    local v92 = u4:NextNumber(0.2, 0.45) * u24;
                    v89.Size = Vector3.new(v90, v91, v92);
                    v89.CFrame = v88.CFrame * CFrame.new(u4:NextNumber(-v88.Size.X, v88.Size.X) * 0.5, u4:NextNumber(-v88.Size.Y, v88.Size.Y) * 0.5, 0);
                    local v93, v94, v95 = v26:ToHSV();
                    local v96 = 0.025 or 0.05;
                    local v97 = v93 + u4:NextNumber(-v96, v96);
                    local v98 = math.clamp(v97, 0, 0.99);
                    v89.Color = Color3.fromHSV(v98, v94, v95);
                    v89.Name = u30 + 2;
                end;
            end;

            if u30 > 1 and u4:NextInteger(1, 2) == 1 then
                CreateBranches(v66, u30);
            end;

            if v64 + 4 < u30 then
                v64 = u30;
                local v99 = u4:NextInteger(2, 3);
                local CFrame3 = v66.CFrame;
                local Angles2 = CFrame.Angles;
                local v100 = u4:NextNumber(80, 90);
                local v101 = CFrame3 * Angles2(0, 0, (math.rad(v100))) * CFrame.new(-v66.Size.X / 2.5, 0, 0);
                local Angles3 = CFrame.Angles;
                local v102 = u4:NextNumber(-25, 25);
                local v103 = v101 * Angles3(0, math.rad(v102), 0);
                local v104 = CFrame.new(v103.Position) * v66.CFrame.Rotation;
                local Angles4 = CFrame.Angles;
                local v105 = u4:NextNumber(80, 90);
                local v106 = v104 * Angles4(0, 0, (math.rad(v105)));
                local v107 = Vector3.new(v66.Size.X * 0.55, v66.Size.Y * 0.9, v66.Size.Z * 0.55);
                local v108 = Vector3.new(v107.X * 0.8, v107.Y * 0.6, v107.Z * 0.8);

                for i = 1, v99 do
                    local v109 = CreatePart(nil, "2022 Stud Wavy");
                    v109.Size = v107:Lerp(v108, i / v99);
                    local Angles5 = CFrame.Angles;
                    local v110 = u4:NextNumber(15, 25);
                    v109.CFrame = v106 * Angles5(0, 0, (math.rad(v110))) * CFrame.new(0, v109.Size.Y / 2.2, 0);
                    v109.Color = u25;
                    v109.Name = u30 + i;
                    v106 = v109.CFrame * CFrame.new(0, v109.Size.Y / 2.2, 0);
                end;

                local v111 = CreatePart();
                v111.Size = Vector3.new(1, 1, 1);
                v111.CFrame = CFrame.new(v106.Position) * CFrame.Angles(0, math.rad(v66.Orientation.Y), 0);
                v111.Parent = FruitSpawnLocations;
                v111.Transparency = 1;
            end;

            CFrame2 = v66.CFrame * CFrame.new(0, v66.Size.Y / 2.4, 0);
            v29 = Vector3.new(v29.X * 0.915, v29.Y * 0.9925, v29.Z * 0.915);
            v48 = (v65[math.floor((u30 - 1) / v32) % #v65 + 1] + u4:NextNumber(-15, 15)) / v32;

            if u30 % 25 == 0 then
                task.wait();
            end;
        end;

        local v112 = (v48 > 0 and -33 or 33) / v32;
        local v113 = 4 * v32;
        local v114 = Vector3.new(v27 * 0.4, v28 * 0.9, v27 * 0.4);

        for i = 1, v113 do
            local v115 = CreatePart(nil, "2022 Stud Wavy");
            local v116 = i / v113;
            v115.Size = v29:Lerp(v114, v116);
            v115.CFrame = CFrame2 * CFrame.Angles(0, 0, (math.rad(v112))) * CFrame.new(0, v115.Size.Y / 2.4, 0);
            v115.Color = u25;
            v115.Name = u30 + i;

            if v116 < 0.5 then
                AttemptExtraStem(v115);
            end;

            if u4:NextInteger(1, 3) == 1 and i < v113 - 1 then
                CreateBranches(v115, u30 + i);
            end;

            CFrame2 = v115.CFrame * CFrame.new(0, v115.Size.Y / 2.4, 0);
        end;

        local v117 = CreatePart();
        v117.Size = Vector3.new(1, 1, 1);
        v117.CFrame = CFrame.new(CFrame2.Position);
        v117.Parent = FruitSpawnLocations;
        v117.Transparency = 1;
        local v118 = u4:NextNumber(-0.025, 0.025);

        for _, descendant in u1:GetDescendants() do
            if descendant:IsA("BasePart") or descendant:IsA("MeshPart") then
                local v119, v120, v121 = descendant.Color:ToHSV();
                descendant.Color = Color3.fromHSV(math.clamp(v119 + v118, 0.01, 0.99), v120, v121);

                if descendant:FindFirstChild("Decal") then
                    for _, child in descendant:GetChildren() do
                        if child:IsA("Decal") then
                            local v122, v123, v124 = child.Color3:ToHSV();
                            child.Color3 = Color3.fromHSV(math.clamp(v122 + v118, 0.01, 0.99), v123, v124);
                        end;
                    end;
                end;
            end;
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u125) -- Line: 363, Name: BeginPlantGrowth
        local PrimaryPart = u125.PrimaryPart;
        local u126 = {};

        for _, v in u125:QueryDescendants("BasePart") do
            local v127 = tonumber(v.Name);

            if v127 then
                local v128 = not v:GetAttribute("DontShow");
                local v129 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v129, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v128 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v130 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v127,
                    decals = v129
                };
                table.insert(u126, v130);
                v.CanCollide = false;

                if v128 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 398
            -- upvalues: u125 (copy), u126 (copy), PrimaryPart (copy)
            local v131 = u125:GetAttribute("Age") or 0;
            local v132 = u125:GetAttribute("MaxAge") or 1;
            local v133 = v131 / v132;

            for _, v in u126 do
                if not v.part:GetAttribute("DontShow") then
                    if v133 >= 1 then
                        for _, descendant in v.part:GetDescendants() do
                            if descendant:IsA("ParticleEmitter") then
                                descendant.Enabled = true;
                            end;
                        end;
                    end;

                    local v134 = math.clamp((v133 - v.partAge / v132) * v132, 0, 1);

                    if v134 ~= v.lastProgress then
                        v.lastProgress = v134;

                        if v134 > 0 then
                            local v135 = v.maxSize * v134;
                            v.part.Size = v135;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v135.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            if v.part:GetAttribute("GrowZAxis") then
                                v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, 0, (v.maxSize.Z - v135.Z) / 2);
                            end;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v134);
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

        u125:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};