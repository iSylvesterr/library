-- Decompiled with Potassium's decompiler.

local MaterialService = game:GetService("MaterialService");
game:GetService("TweenService");

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u1, p2, p3) -- Line: 9, Name: InitPlant
        -- upvalues: MaterialService (copy)
        local u4 = p3 or 1;
        local u5 = Random.new(p2);
        local FruitSpawnLocations = u1.FruitSpawnLocations;
        local Base = u1.Base;

        local function GetRandomHSV(p6, p7) -- Line: 18
            -- upvalues: u5 (copy)
            local v8, v9, v10 = p6:ToHSV();
            local v11 = p7 or 0.05;
            local v12 = v8 + u5:NextNumber(-v11, v11);
            local v13 = math.clamp(v12, 0, 0.99);

            return Color3.fromHSV(v13, v9, v10), v13, v9, v10;
        end;

        local v14, v15 = Color3.fromRGB(51, 136, 5);
        local v16, v17, v18 = v14:ToHSV();
        local v19 = v15 or 0.05;
        local v20 = v16 + u5:NextNumber(-v19, v19);
        local v21 = math.clamp(v20, 0, 0.99);
        Color3.fromHSV(v21, v17, v18);

        local function CreatePart(p22, p23, p24) -- Line: 28
            -- upvalues: u1 (copy), MaterialService (ref)
            local Part = Instance.new("Part");
            local v25 = p22 or "Studs";
            Part.Parent = u1;
            Part.TopSurface = Enum.SurfaceType[v25];
            Part.BackSurface = Enum.SurfaceType[v25];
            Part.FrontSurface = Enum.SurfaceType[v25];
            Part.BottomSurface = Enum.SurfaceType[v25];
            Part.LeftSurface = Enum.SurfaceType[v25];
            Part.RightSurface = Enum.SurfaceType[v25];
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Transparency = 0;

            for _, child in pairs(script:GetChildren()) do
                if child:IsA("Texture") then
                    child:Clone().Parent = Part;
                end;
            end;

            if p24 then
                Part.Shape = Enum.PartType[p24];
            end;

            if p23 then
                Part.MaterialVariant = p23;
                local v26 = MaterialService:FindFirstChild(p23, true);

                if not v26 then
                    return Part;
                end;

                Part.Material = v26.BaseMaterial;
            end;

            return Part;
        end;

        local function GetColorWithRange(p27, p28) -- Line: 64
            local v29, v30, v31 = p27:ToHSV();

            return Color3.fromHSV(v29 + p28, v30, v31);
        end;

        local function Lerp(p32, p33, p34) -- Line: 70
            return p32 + (p33 - p32) * p34;
        end;

        local v35 = u5:NextInteger(11, 14);

        if u5:NextInteger(1, 200) == 1 then
            v35 = v35 * 2;
        end;

        local u36 = Color3.fromRGB(123, 189, 255);
        local u37 = u5:NextNumber(2.6, 2.9) * u4;
        local v38 = u37 * 0.75;
        local v39 = u5:NextNumber(-4, 4);
        local v40 = Base.CFrame * CFrame.Angles(0, -0.7853981633974483, 0);

        local function NamePartsInModel(p41, p42) -- Line: 87
            -- upvalues: u4 (ref), u1 (copy)
            p41:ScaleTo(p41:GetScale() * u4);

            for _, child in p41:GetChildren() do
                local v43 = tonumber(child.Name);

                if v43 then
                    child.Name = p42 + v43;
                    child.Parent = u1;
                end;
            end;

            p41:Destroy();
        end;

        for i = 1, v35 do
            local v44 = script.Stem:Clone();
            v44.Parent = u1;
            local v45 = i / v35;
            local v46 = i == 1 and 0 or (v45 <= 0.05 and 0 or (v45 <= 0.25 and 20 or (v45 <= 0.35 and -25 or (v45 <= 0.6 and -10 or (v45 <= 0.85 and -25 or -45)))));

            if i == v35 then
                v46 = v46 / 2;
            end;

            if v45 > 0.1 and u5:NextInteger(1, 6) ~= 1 then
                v44.Color = u36;
            end;

            local v47 = 0.85 - v45 * 0.65;
            v44.Size = v44.Size * (v47 * u4);
            v44.Size = Vector3.new(v44.Size.X, u37 + (v38 - u37) * v45, v44.Size.Z);
            local Size = v44.Size;
            local v48 = u5:NextNumber(-2, 2);
            v44:PivotTo(v40 * CFrame.Angles(math.rad(v39), math.rad(v48), (math.rad(v46))) * CFrame.new(0, Size.Y / 2.2, 0));

            if i % 3 == 0 then
                local v49 = script.StemEffect:Clone();
                v49.Parent = u1;
                v49.Parent = v44;
            end;

            if u5:NextInteger(1, 2) == 1 and (v45 < 0.45 and v45 > 0.2) then
                local v50 = script.Leaf:Clone();
                v50.Parent = u1;
                local v51 = v44:GetPivot() * CFrame.new(0, u5:NextNumber(-Size.Y, Size.Y) * 0.25, 0);
                local Angles = CFrame.Angles;
                local v52 = u5:NextNumber(-180, 180);
                local v53 = v51 * Angles(0, math.rad(v52), 1.5707963267948966);
                local Angles2 = CFrame.Angles;
                local v54 = u5:NextNumber(20, 40);
                v50:PivotTo(v53 * Angles2(0, math.rad(v54), 0));
                NamePartsInModel(v50, i);
            end;

            if v45 < 0.85 and u5:NextInteger(1, 3) ~= 1 then
                for _ = 1, u5:NextInteger(1, 3) == 1 and 2 or 1 do
                    local v55 = script.Spike:Clone();
                    v55.Parent = u1;
                    v55.Size = v55.Size * (v47 * 1.75 * u4);
                    v55.Size = v55.Size + Vector3.new(0, 1, 0) * u5:NextNumber(-0.35, 0.65);
                    local v56 = v44:GetPivot() * CFrame.new(0, u5:NextNumber(-Size.Y, Size.Y) * 0.25, 0);
                    local Angles = CFrame.Angles;
                    local v57 = u5:NextNumber(-180, 180);
                    local v58 = v56 * Angles(0, math.rad(v57), 1.5707963267948966);
                    local Angles2 = CFrame.Angles;
                    local v59 = u5:NextNumber(-15, 15);
                    local v60 = math.rad(v59);
                    local v61 = u5:NextNumber(-15, 15);
                    v55:PivotTo(v58 * Angles2(v60, 0, (math.rad(v61))) * CFrame.new(0, v55.Size.Y / 2, 0));
                    v55.Name = i + 1;
                end;
            end;

            if i == v35 then
                local v62 = script.Bulb:Clone();
                v62.Parent = u1;
                v62.Size = v62.Size * (Size.X * 1.75);
                v62.CFrame = v44:GetPivot() * CFrame.new(0, Size.Y / 2.5 + v62.Size.Y / 2.5, 0);
                v62.Name = i + 1;
            end;

            if v35 < 19 and i == math.floor(v35 / 2) or v35 >= 19 and (i == math.floor(v35 / 2) - 2 or i == math.floor(v35 / 2) + 1) then
                local v63 = v44:Clone();
                v63.Parent = u1;
                v63.Size = v63.Size * 0.75;
                v63.Size = v63.Size + Vector3.new(0, 1.5, 0);
                local Size2 = v63.Size;
                local v64 = v44:GetPivot();
                local Angles = CFrame.Angles;
                local v65 = #FruitSpawnLocations:GetChildren() == 0 and -25 or 125;
                v63:PivotTo(v64 * Angles(0, math.rad(v65), -1.5707963267948966) * CFrame.new(0, Size2.Y / 2.5, 0));
                local v66 = CreatePart();
                v66.Size = Vector3.new(1, 1, 1);
                v66.CFrame = v63:GetPivot() * CFrame.new(0, Size2.Y / 2.5, 0) * CFrame.Angles(0, 0, 1.5707963267948966) * CFrame.Angles(0, -1.5707963267948966, 0);
                v66.Parent = FruitSpawnLocations;
                v66.Transparency = 1;
                v63.Name = i + 1;
            end;

            v44.Name = i;
            v40 = v44:GetPivot() * CFrame.new(0, Size.Y / 2.2, 0);
        end;

        local u67 = v38 * 0.8;

        local function GenerateSideStem(p68) -- Line: 205
            -- upvalues: u5 (copy), u1 (copy), u36 (copy), u37 (copy), u67 (ref), u4 (ref), NamePartsInModel (copy)
            local v69 = u5:NextInteger(6, 9);
            local v70 = u5:NextNumber(0.375, 0.55);
            local v71 = false;

            for i = 1, v69 do
                local v72 = script.Stem:Clone();
                v72.Parent = u1;
                local v73 = i / v69;

                if i ~= 1 then
                    v72.Color = u36;
                end;

                local v74 = u37 * 0.75;
                local v75 = 0.75 - v73 * 0.5;
                v72.Size = v72.Size * (v75 * u4);
                v72.Size = Vector3.new(v72.Size.X, v74 + (u67 * 0.75 - v74) * v73, v72.Size.Z);
                local Size = v72.Size;
                v72:PivotTo(p68 * CFrame.Angles(0, 0, (math.rad(v70 < v73 and v73 < 0.8 and -14 or (v73 > 0.8 and -22 or 13)))) * CFrame.new(0, Size.Y / 2.2, 0));

                if i % 3 == 0 then
                    local v76 = script.StemEffect:Clone();
                    v76.Parent = u1;
                    v76.Parent = v72;
                end;

                if u5:NextInteger(1, 2) == 1 and (v73 < 0.7 and v73 > 0.4) then
                    local v77 = script.Leaf:Clone();
                    v77.Parent = u1;
                    local v78 = v72:GetPivot() * CFrame.new(0, u5:NextNumber(-Size.Y, Size.Y) * 0.25, 0);
                    local Angles = CFrame.Angles;
                    local v79 = u5:NextNumber(-180, 180);
                    local v80 = v78 * Angles(0, math.rad(v79), 1.5707963267948966);
                    local Angles2 = CFrame.Angles;
                    local v81 = u5:NextNumber(20, 40);
                    v77:PivotTo(v80 * Angles2(0, math.rad(v81), 0));
                    NamePartsInModel(v77, i + 1);
                end;

                if u5:NextInteger(1, 4) == 1 and (not v71 and (i > 2 and v73 < 0.7)) then
                    local v82 = u5:NextInteger(4, 6);
                    local v83 = v72:GetPivot() * CFrame.Angles(0, 1.5707963267948966, 0.6981317007977318);
                    v71 = true;

                    for i2 = 1, v82 do
                        local v84 = v72:Clone();
                        v84.Parent = u1;
                        v84.Size = v84.Size * (1 - i2 / v82 * 0.45);
                        local Size2 = v84.Size;
                        local Angles = CFrame.Angles;
                        local v85 = u5:NextNumber(-5, 5);
                        local v86 = math.rad(v85);
                        local v87 = u5:NextNumber(-5, 20);
                        v84:PivotTo(v83 * Angles(v86, 0, (math.rad(v87))) * CFrame.new(0, Size2.Y / 2.5, 0));
                        v83 = v84:GetPivot() * CFrame.new(0, Size2.Y / 2.5, 0);
                        v84.Name = i + i2 + 1;

                        if i2 == v82 then
                            if u5:NextInteger(1, 2) == 1 then
                                local v88 = u5:NextInteger(2, 3);

                                for i3 = 1, v88 do
                                    local v89 = script.Claw:Clone();
                                    v89.Parent = u1;
                                    v89:PivotTo(v83 * CFrame.Angles(0, math.rad(360 / v88 * i3), 0) * CFrame.Angles(-0.4363323129985824, 0, 0));
                                    NamePartsInModel(v89, i2 + i);
                                end;

                                script.SwirlEffect:Clone().Parent = v84;
                            else
                                local v90 = script.Bulb:Clone();
                                v90.Parent = u1;
                                v90.Size = v90.Size * (Size2.X * 1.75);
                                v90.CFrame = v84:GetPivot() * CFrame.new(0, Size2.Y / 2.5 + v90.Size.Y / 2.5, 0);
                                v90.Name = i2 + i + 1;
                            end;
                        end;
                    end;
                end;

                if v73 < 0.85 and u5:NextInteger(1, 3) ~= 1 then
                    for _ = 1, u5:NextInteger(1, 3) == 1 and 2 or 1 do
                        local v91 = script.Spike:Clone();
                        v91.Parent = u1;
                        v91.Size = v91.Size * (v75 * 1.75 * u4);
                        v91.Size = v91.Size + Vector3.new(0, 1, 0) * u5:NextNumber(-0.35, 0.65);
                        local v92 = v72:GetPivot() * CFrame.new(0, u5:NextNumber(-Size.Y, Size.Y) * 0.25, 0);
                        local Angles = CFrame.Angles;
                        local v93 = u5:NextNumber(-180, 180);
                        local v94 = v92 * Angles(0, math.rad(v93), 1.5707963267948966);
                        local Angles2 = CFrame.Angles;
                        local v95 = u5:NextNumber(-15, 15);
                        local v96 = math.rad(v95);
                        local v97 = u5:NextNumber(-15, 15);
                        v91:PivotTo(v94 * Angles2(v96, 0, (math.rad(v97))) * CFrame.new(0, v91.Size.Y / 2, 0));
                        v91.Name = i + 2;
                    end;
                end;

                p68 = v72:GetPivot() * CFrame.new(0, Size.Y / 2.2, 0);
                v72.Name = i + 1;

                if i == v69 then
                    if u5:NextInteger(1, 2) == 1 then
                        local v98 = u5:NextInteger(2, 3);

                        for i2 = 1, v98 do
                            local v99 = script.Claw:Clone();
                            v99.Parent = u1;
                            v99:PivotTo(p68 * CFrame.Angles(0, math.rad(360 / v98 * i2), 0) * CFrame.Angles(-0.4363323129985824, 0, 0));
                            NamePartsInModel(v99, i + 1);
                        end;

                        script.SwirlEffect:Clone().Parent = v72;
                    else
                        local v100 = script.Bulb:Clone();
                        v100.Parent = u1;
                        v100.Size = v100.Size * (Size.X * 1.75);
                        v100.CFrame = v72:GetPivot() * CFrame.new(0, Size.Y / 2.5 + v100.Size.Y / 2.5, 0);
                        v100.Name = i + 2;
                    end;
                end;
            end;
        end;

        local v101 = u5:NextInteger(2, 3);
        local v102 = u5:NextNumber(-25, 25);

        for i = 1, v101 do
            local v103 = 360 / v101 * (i * u5:NextNumber(0.9, 1.1)) + v102;

            if i == 1 or v101 == 3 and u5:NextInteger(1, 5) == 1 then
                local v104 = u5:NextInteger(9, 11);
                local v105 = Base.CFrame * CFrame.Angles(0, math.rad(v103 + 45), 0) * CFrame.new(-1.25, 0, 0);
                local v106 = u37 * 0.675;
                local v107 = v106 * 0.5;

                for i2 = 1, v104 do
                    local v108 = script.Stem:Clone();
                    v108.Parent = u1;
                    local v109 = i2 / v104;
                    local v110 = math.floor(v104 * 0.7) < i2 and 20 or (i2 == 1 and 0 or 10);

                    if i2 ~= 1 then
                        v108.Color = u36;
                    end;

                    local v111 = 0.65 - v109 * 0.375;
                    v108.Size = v108.Size * (v111 * u4);
                    v108.Size = Vector3.new(v108.Size.X, v106 + (v107 - v106) * v109, v108.Size.Z);
                    local Size = v108.Size;
                    v108:PivotTo(v105 * CFrame.Angles(0, 0, (math.rad((i2 == v104 - 2 or i2 == v104 - 3) and 30 or v110))) * CFrame.new(0, Size.Y / 2.2, 0));
                    v105 = v108:GetPivot() * CFrame.new(0, Size.Y / 2.2, 0);
                    v108.Name = i2 + 1;

                    if v109 < 0.85 and u5:NextInteger(1, 3) ~= 1 then
                        for _ = 1, u5:NextInteger(1, 3) == 1 and 2 or 1 do
                            local v112 = script.Spike:Clone();
                            v112.Parent = u1;
                            v112.Size = v112.Size * (v111 * 1.25 * u4);
                            v112.Size = v112.Size + Vector3.new(0, 1, 0) * u5:NextNumber(-0.35, 0.65);
                            local v113 = v108:GetPivot() * CFrame.new(0, u5:NextNumber(-Size.Y, Size.Y) * 0.25, 0);
                            local Angles = CFrame.Angles;
                            local v114 = u5:NextNumber(-180, 180);
                            local v115 = v113 * Angles(0, math.rad(v114), 1.5707963267948966);
                            local Angles2 = CFrame.Angles;
                            local v116 = u5:NextNumber(-15, 15);
                            local v117 = math.rad(v116);
                            local v118 = u5:NextNumber(-15, 15);
                            v112:PivotTo(v115 * Angles2(v117, 0, (math.rad(v118))) * CFrame.new(0, v112.Size.Y / 2, 0));
                            v112.Name = i2 + 2;
                        end;
                    end;

                    if i2 == v104 then
                        local v119 = script.Bulb:Clone();
                        v119.Parent = u1;
                        v119.Size = v119.Size * (Size.X * 1.75);
                        v119.CFrame = v108:GetPivot() * CFrame.new(0, Size.Y / 2.5 + v119.Size.Y / 2.5, 0);
                        v119.Name = i2 + 2;
                    end;
                end;
            end;

            GenerateSideStem(Base.CFrame * CFrame.Angles(0, math.rad(v103), 0.4363323129985824) * CFrame.new(-0.5, 0, -0.5));
        end;

        local v120 = u5:NextNumber(-0.065, 0.065);

        for _, v in u1:QueryDescendants("BasePart, ParticleEmitter") do
            if v:IsA("BasePart") then
                local v121, v122, v123 = v.Color:ToHSV();
                v.Color = Color3.fromHSV(math.clamp(v121 + v120, 0.01, 0.99), v122, v123);

                if v:FindFirstChild("Decal") then
                    for _, child in v:GetChildren() do
                        if child:IsA("Decal") then
                            local v124, v125, v126 = child.Color3:ToHSV();
                            child.Color3 = Color3.fromHSV(math.clamp(v124 + v120, 0.01, 0.99), v125, v126);
                        end;
                    end;
                end;
            end;

            if v:IsA("ParticleEmitter") then
                v.Enabled = false;
            end;
        end;

        for _, v in u1:QueryDescendants("ParticleEmitter") do
            local v127 = {};

            for _, v2 in ipairs(v.Size.Keypoints) do
                table.insert(v127, NumberSequenceKeypoint.new(v2.Time, v2.Value * u4, v2.Envelope * u4));
            end;

            v.Size = NumberSequence.new(v127);
        end;

        if u5:NextInteger(1, 1700) == 1 then
            if u5:NextInteger(1, 2) == 1 then
                for _, child in pairs(u1:GetChildren()) do
                    if child:IsA("BasePart") then
                        child.Color = Color3.new(1, 0.333333, 1);
                    end;
                end;
            else
                for _, child in pairs(u1:GetChildren()) do
                    if child:IsA("BasePart") then
                        child.Color = Color3.new(0, 0.666667, 1);
                    end;
                end;
            end;
        end;

        if u5:NextInteger(1, 7000) == 1 then
            for _, child in pairs(u1:GetChildren()) do
                if child:IsA("BasePart") then
                    child.Color = Color3.new(1, 1, 1);
                end;
            end;
        end;

        if u5:NextInteger(1, 30000) == 1 then
            for _, child in pairs(u1:GetChildren()) do
                if child:IsA("BasePart") then
                    child.Color = Color3.new(0, 0, 0);
                end;
            end;
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u128) -- Line: 508, Name: BeginPlantGrowth
        local PrimaryPart = u128.PrimaryPart;
        local u129 = {};

        for _, v in u128:QueryDescendants("BasePart") do
            local v130 = tonumber(v.Name);

            if v130 then
                local v131 = not v:GetAttribute("DontShow");
                local v132 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v132, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v131 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v133 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v130,
                    decals = v132
                };
                table.insert(u129, v133);
                v.CanCollide = false;

                if v131 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 543
            -- upvalues: u128 (copy), u129 (copy), PrimaryPart (copy)
            local v134 = u128:GetAttribute("Age") or 0;
            local v135 = u128:GetAttribute("MaxAge") or 1;
            local v136 = v134 / v135;

            for _, v in u129 do
                if not v.part:GetAttribute("DontShow") then
                    local v137 = math.clamp((v136 - v.partAge / v135) * v135, 0, 1);

                    if v137 ~= v.lastProgress then
                        v.lastProgress = v137;

                        if v137 > 0 then
                            local v138 = v.maxSize * v137;
                            v.part.Size = v138;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v138.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v137);
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

            if v135 <= v134 then
                for _, v in u128:QueryDescendants("ParticleEmitter") do
                    v.Enabled = true;
                end;
            end;
        end;

        u128:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};