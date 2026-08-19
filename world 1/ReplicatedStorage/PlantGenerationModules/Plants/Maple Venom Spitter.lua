-- Decompiled with Potassium's decompiler.

local MaterialService = game:GetService("MaterialService");
local TweenService = game:GetService("TweenService");

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u1, p2, p3) -- Line: 9, Name: InitPlant
        -- upvalues: MaterialService (copy), TweenService (copy)
        local u4 = Random.new(p2);
        local FruitSpawnLocations = u1.FruitSpawnLocations;
        local Base = u1.Base;

        local function GetRandomHSV(p5, p6) -- Line: 15
            -- upvalues: u4 (copy)
            local v7, v8, v9 = p5:ToHSV();
            local v10 = p6 or 0.05;
            local v11 = v7 + u4:NextNumber(-v10, v10);
            local v12 = math.clamp(v11, 0.01, 0.99);

            return Color3.fromHSV(v12, v8, v9), v12, v8, v9;
        end;

        Color3.fromRGB(74, 112, 33);

        local function CreatePart(p13, p14, p15, p16) -- Line: 24
            -- upvalues: u1 (copy), MaterialService (ref)
            local Part = Instance.new("Part");
            local v17 = p13 or "Studs";
            Part.Parent = p16 or u1;
            Part.TopSurface = Enum.SurfaceType[v17];
            Part.BackSurface = Enum.SurfaceType[v17];
            Part.FrontSurface = Enum.SurfaceType[v17];
            Part.BottomSurface = Enum.SurfaceType[v17];
            Part.LeftSurface = Enum.SurfaceType[v17];
            Part.RightSurface = Enum.SurfaceType[v17];
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Transparency = 0;

            if p15 then
                Part.Shape = Enum.PartType[p15];
            end;

            if p14 then
                Part.MaterialVariant = p14;
                local v18 = MaterialService:FindFirstChild(p14, true);

                if not v18 then
                    return Part;
                end;

                Part.Material = v18.BaseMaterial;
            end;

            return Part;
        end;

        local function GetColorWithRange(p19, p20) -- Line: 54
            local v21, v22, v23 = p19:ToHSV();

            return Color3.fromHSV(math.clamp(v21 + p20, 0.01, 0.99), v22, v23);
        end;

        local function AttachDetails(p24, p25) -- Line: 60
            -- upvalues: u1 (copy)
            local Model = Instance.new("Model");
            Model.Name = p25 or p24.Name .. "Details";
            Model.Parent = u1;
            local ObjectValue = Instance.new("ObjectValue");
            ObjectValue.Name = "Reference";
            ObjectValue.Value = Model;
            ObjectValue.Parent = p24;

            return Model;
        end;

        local function AttachChain(p26, p27) -- Line: 73
            -- upvalues: u1 (copy)
            local Model = Instance.new("Model");
            Model.Name = p27 or p26.Name .. "Stem";
            Model.Parent = u1;
            local ObjectValue = Instance.new("ObjectValue");
            ObjectValue.Name = "LeafStemReference";
            ObjectValue.Value = Model;
            ObjectValue.Parent = p26;

            return Model;
        end;

        local v28 = u4:NextNumber(5.2, 6.2);
        local v29 = Vector3.new(1, 1, 1) * v28;
        local v30 = Vector3.new(v28 * 0.4, v28 * 0.75, v28 * 0.4);
        local v31, v32, v33 = Color3.fromRGB(188, 114, 42):ToHSV();
        local v34 = 0.025 or 0.05;
        local v35 = v31 + u4:NextNumber(-v34, v34);
        local v36 = math.clamp(v35, 0.01, 0.99);
        local v37 = Color3.fromHSV(v36, v32, v33);
        local CFrame2 = Base.CFrame;
        local Model = Instance.new("Model");
        Model.Name = "Stem";
        Model.Parent = u1;
        local v38 = {
            {
                Name = "Right",
                Angle = 90,
                LastPoint = CFrame.identity,
                NextPoint = CFrame.identity
            },
            {
                Name = "Left",
                Angle = -90,
                LastPoint = CFrame.identity,
                NextPoint = CFrame.identity
            },
            {
                Name = "Front",
                Angle = 180,
                LastPoint = CFrame.identity,
                NextPoint = CFrame.identity
            }
        };

        local function Lerp(p39, p40, p41) -- Line: 138
            return p39 + (p40 - p39) * p41;
        end;

        local function ChangeNameToIteration(p42, p43, p44) -- Line: 142
            -- upvalues: u1 (copy)
            for _, descendant in p42:GetDescendants() do
                local v45 = tonumber(descendant.Name);

                if v45 then
                    descendant.Name = v45 + p43;
                    descendant.Parent = p44 or u1;
                end;
            end;

            p42:Destroy();
        end;

        for i = 1, 9 do
            local v46 = CreatePart(nil, "2022 Stud", nil, Model);
            v46.Size = v29:Lerp(v30, (TweenService:GetValue(i / 9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)));
            v46.CFrame = CFrame2 * CFrame.Angles(math.rad(i == 1 and 2.5 or (i == 3 and 25 or (i > 4 and -30 or 10))), 0, 0) * CFrame.new(0, v46.Size.Y / 2.4, 0);
            v46.Color = v37;
            v46.Name = i;
            local Model2 = Instance.new("Model");
            Model2.Name = v46.Name .. "Details";
            Model2.Parent = u1;
            local ObjectValue = Instance.new("ObjectValue");
            ObjectValue.Name = "Reference";
            ObjectValue.Value = Model2;
            ObjectValue.Parent = v46;
            local v47 = i + 1;

            if i == 1 then
                local v48 = u4:NextInteger(3, 4);

                for i2 = 1, v48 do
                    local v49 = 360 / v48 * i2;
                    local v50 = v46.CFrame * CFrame.Angles(0, math.rad(v49), 0) * CFrame.new(-v46.Size.X / 2.5, v46.Size.Y * 0.25, 0) * CFrame.Angles(0, 0, 0.4363323129985824);
                    local v51 = u4:NextInteger(6, 8);
                    local v52 = u4:NextNumber(2, 2.4);
                    local v53 = u4:NextNumber(2.9, 3.4);
                    local v54 = Vector3.new(v52, v53, v52 * 0.75);
                    local v55 = v54 * 0.675;
                    local v56 = CreatePart();
                    v56.Size = Vector3.new(1, 1, 1);
                    v56.CFrame = v46.CFrame * CFrame.Angles(0, math.rad(v49 + 45), 0) * CFrame.new(0, 0, -v46.Size.Z / 2);
                    v56.Parent = FruitSpawnLocations;
                    v56.Transparency = 1;
                    v56.Name = "FruitSpawn";
                    local Model3 = Instance.new("Model");
                    Model3.Name = "Tentacle" .. i2 .. "Stem" or v46.Name .. "Stem";
                    Model3.Parent = u1;
                    local ObjectValue2 = Instance.new("ObjectValue");
                    ObjectValue2.Name = "LeafStemReference";
                    ObjectValue2.Value = Model3;
                    ObjectValue2.Parent = v46;
                    Model3:AddTag("Tentacle");
                    local v57 = CreatePart(nil, "2022 Stud", nil, Model3);
                    v57.Size = Vector3.new(v46.Size.X * 0.6, v46.Size.Y, v46.Size.Z * 0.5);
                    local CFrame3 = v46.CFrame;
                    local Angles = CFrame.Angles;
                    local v58 = v49 + u4:NextNumber(-15, 15);
                    v57.CFrame = CFrame3 * Angles(0, math.rad(v58), 0) * CFrame.new(-v46.Size.X / 2.5, 0, 0) * CFrame.Angles(0, 0, -0.39269908169872414) * CFrame.new(0, -v57.Size.Y / 3, 0);
                    v57.Color = v37;
                    v57.Name = 1;
                    local v59 = CreatePart(nil, "2022 Stud", nil, Model3);
                    v59.Size = v57.Size * 0.85 + Vector3.new(0, 1.25, 0);
                    local CFrame4 = v57.CFrame;
                    local Angles2 = CFrame.Angles;
                    local v60 = u4:NextNumber(-35, -50);
                    v59.CFrame = CFrame4 * Angles2(0, 0, (math.rad(v60))) * CFrame.new(0, -v59.Size.Y / 2, 0);
                    v59.Color = v37;
                    v59.Name = 2;

                    for i3 = 1, v51 do
                        local v61 = CreatePart(nil, "2022 Stud", nil, Model3);
                        local v62 = i3 / v51;
                        local v63 = u4:NextNumber(22, 30);

                        if v62 > 0.7 then
                            v63 = u4:NextNumber(-29, -39);
                        end;

                        v61.Size = v54:Lerp(v55, v62);
                        local Angles3 = CFrame.Angles;
                        local v64 = u4:NextNumber(-5, 5);
                        v61.CFrame = v50 * Angles3(math.rad(v64), 0, (math.rad(v63))) * CFrame.new(0, v61.Size.Y / 2.25, 0);
                        v61.Color = v37;
                        v61.Name = i3 + 2;
                        local Model4 = Instance.new("Model");
                        Model4.Name = v61.Name .. "Details";
                        Model4.Parent = u1;
                        local ObjectValue3 = Instance.new("ObjectValue");
                        ObjectValue3.Name = "Reference";
                        ObjectValue3.Value = Model4;
                        ObjectValue3.Parent = v61;
                        local v65 = i3 + 2 + 1;
                        local v66 = v61:Clone();
                        v66.Parent = Model4;
                        v66.Name = v65;
                        v66.CFrame = v61.CFrame * CFrame.Angles(0, 1.5707963267948966, 0);
                        v50 = v61.CFrame * CFrame.new(0, v61.Size.Y / 2.25, 0);

                        if i3 == v51 then
                            for i4 = 1, 2 do
                                local v67 = CreatePart(nil, "2022 Stud", nil, Model4);
                                v67.Name = v65;
                                v67.Shape = Enum.PartType.Wedge;
                                v67.Size = Vector3.new(v61.Size.X, v61.Size.Y, v61.Size.Z / 2);
                                v67.CFrame = v61.CFrame * CFrame.Angles(0, math.rad(i4 * 180 + 90), 0) * CFrame.new(0, v61.Size.Y / 2 + v67.Size.Y / 2, -v67.Size.Z / 2);
                                v67.Color = v37;
                                local v68 = CreatePart(nil, "2022 Stud", nil, Model4);
                                v68.Name = v65;
                                local v69 = v66.Size.X / 2 - v61.Size.Z / 2;
                                v68.Shape = Enum.PartType.Wedge;
                                v68.Size = Vector3.new(v61.Size.Z, v61.Size.Y, v61.Size.Z / 2 + v69);
                                v68.CFrame = v61.CFrame * CFrame.Angles(0, math.rad(i4 * 180 + 90), 0) * CFrame.new(0, v61.Size.Y / 2 + v68.Size.Y / 2, -v68.Size.Z / 2);
                                v68.Color = v37;
                            end;
                        end;

                        if u4:NextInteger(1, 3) ~= 1 then
                            for _ = 1, u4:NextInteger(1, 2) do
                                local v70 = script.Spike:Clone();
                                v70.Parent = Model4;
                                v70.Name = v65;
                                v70.Size = Vector3.new(0.75, 2.5, 0.75) * u4:NextNumber(0.9, 1.2);
                                local CFrame5 = v61.CFrame;
                                local Angles4 = CFrame.Angles;
                                local v71 = u4:NextNumber(-180, 180);
                                v70.CFrame = CFrame5 * Angles4(0, math.rad(v71), 1.5707963267948966) * CFrame.new(0, v70.Size.Y / 2 + v61.Size.Z / 2.5, 0);
                            end;
                        end;
                    end;

                    local Part = Instance.new("Part");
                    local v72 = nil or "Studs";
                    Part.Parent = Model3 or u1;
                    Part.TopSurface = Enum.SurfaceType[v72];
                    Part.BackSurface = Enum.SurfaceType[v72];
                    Part.FrontSurface = Enum.SurfaceType[v72];
                    Part.BottomSurface = Enum.SurfaceType[v72];
                    Part.LeftSurface = Enum.SurfaceType[v72];
                    Part.RightSurface = Enum.SurfaceType[v72];
                    Part.Anchored = true;
                    Part.CanCollide = false;
                    Part.Transparency = 0;
                    Part.Name = "EndJoint";
                    Part.Size = Vector3.new(0.5, 0.5, 0.5);
                    Part.Transparency = 1;
                    Part.CFrame = v50;
                end;
            end;

            if i >= 4 and i < 9 then
                local v73 = script.Spike:Clone();
                v73.Parent = Model2;
                v73.Name = v47;
                v73.Size = v73.Size * ((i - 4) / 4 * 0.7999999999999998 + 1.5);
                v73.CFrame = v46.CFrame * CFrame.Angles(1.5707963267948966, 0, 0) * CFrame.new(0, v73.Size.Y / 2 + v46.Size.Z / 2.25, 0);
            end;

            if i == 1 then
                for _, v in v38 do
                    local v74 = v46.Size.X / 2;
                    v.LastPoint = v46.CFrame * CFrame.new(0, -v46.Size.Y / 2, 0) * CFrame.Angles(0, math.rad(v.Angle), 0) * CFrame.new(u4:NextNumber(-v46.Size.X, v46.Size.X) * 0.35, 0, v74);
                end;
            else
                for _, v in v38 do
                    v.LastPoint = v.NextPoint;
                end;
            end;

            if i < 6 then
                for _, v in v38 do
                    local v75 = v46.Size.X / 2;

                    if v.Name == "Front" and i < 5 then
                        v.NextPoint = v46.CFrame * CFrame.new(0, v46.Size.Y / 2, 0) * CFrame.Angles(0, math.rad(v.Angle), 0) * CFrame.new(0, 0, v75);
                    else
                        v.NextPoint = v46.CFrame * CFrame.new(0, v46.Size.Y / 2, 0) * CFrame.Angles(0, math.rad(v.Angle), 0) * CFrame.new(u4:NextNumber(-v46.Size.X, v46.Size.X) * 0.35, 0, v75);
                    end;

                    local Magnitude = (v.LastPoint.Position - v.NextPoint.Position).Magnitude;
                    local Part = Instance.new("Part");
                    local v76 = nil or "Studs";
                    Part.Parent = Model2 or u1;
                    Part.TopSurface = Enum.SurfaceType[v76];
                    Part.BackSurface = Enum.SurfaceType[v76];
                    Part.FrontSurface = Enum.SurfaceType[v76];
                    Part.BottomSurface = Enum.SurfaceType[v76];
                    Part.LeftSurface = Enum.SurfaceType[v76];
                    Part.RightSurface = Enum.SurfaceType[v76];
                    Part.Anchored = true;
                    Part.CanCollide = false;
                    Part.Transparency = 0;
                    Part.Name = v47;
                    local v77 = v.Name == "Front" and 0.4 or 1.25;
                    local v78 = v.Name == "Front" and 1.25 or 0.4;

                    if i + 1 >= 6 then
                        Magnitude = Magnitude / 2;

                        for i2 = 1, 2 do
                            local Part2 = Instance.new("Part");
                            local v79 = nil or "Studs";
                            Part2.Parent = Model2 or u1;
                            Part2.TopSurface = Enum.SurfaceType[v79];
                            Part2.BackSurface = Enum.SurfaceType[v79];
                            Part2.FrontSurface = Enum.SurfaceType[v79];
                            Part2.BottomSurface = Enum.SurfaceType[v79];
                            Part2.LeftSurface = Enum.SurfaceType[v79];
                            Part2.RightSurface = Enum.SurfaceType[v79];
                            Part2.Anchored = true;
                            Part2.CanCollide = false;
                            Part2.Transparency = 0;
                            Part2.Name = v47;
                            Part2.Shape = Enum.PartType.Wedge;
                            Part2.Size = Vector3.new(1.25, 0.2, Magnitude * 0.65);
                            Part2.CFrame = CFrame.lookAt(v.LastPoint.Position, v.NextPoint.Position) * CFrame.new(0, 0, -(Magnitude + 0.075)) * CFrame.new(0, 0, -Part2.Size.Z / 2) * CFrame.Angles(0, 0, (math.rad(i2 * 180 + (v.Name == "Front" and 90 or 0)))) * CFrame.new(0, 0.2 - Part2.Size.Y / 2, 0);
                            Part2.Color = Color3.fromRGB(235, 97, 49);
                            Part2.Material = Enum.Material.Neon;
                        end;
                    end;

                    Part.Size = Vector3.new(v77, v78, Magnitude + 0.15);
                    Part.CFrame = CFrame.lookAt(v.LastPoint.Position, v.NextPoint.Position) * CFrame.new(0, 0, -Magnitude / 2);
                    Part.Color = Color3.fromRGB(235, 97, 49);
                    Part.Material = Enum.Material.Neon;

                    if i > 1 and i < 5 then
                        local v80 = script.Spike:Clone();
                        v80.Parent = Model2;
                        v80.Name = v47;
                        local v81 = v.Name == "Left" and -90 or (v.Name == "Front" and 0 or 90);
                        v80.Size = v80.Size * u4:NextNumber(0.8, 1.2);

                        if u4:NextInteger(1, 3) == 1 then
                            v80.Size = v80.Size + Vector3.new(0, 1, 0) * u4:NextNumber(0.3, 1);
                        end;

                        v80:PivotTo(Part.CFrame * CFrame.new(0, 0, u4:NextNumber(-Part.Size.Z, Part.Size.Z) * 0.25) * CFrame.Angles(0, 0, (math.rad(v81))) * CFrame.new(0, v80.Size.Y / 2 + 0.1, 0));
                    end;
                end;
            end;

            for i2 = 1, 2 do
                local v82 = CreatePart(nil, "2022 Stud", nil, Model2);
                v82.Name = v47;
                v82.Size = Vector3.new(v46.Size.X * 0.75, v46.Size.Y, v46.Size.Z * 1.2);
                local CFrame3 = v46.CFrame;
                local Angles = CFrame.Angles;
                local v83 = math.rad(i2 * 90);
                local v84 = u4:NextNumber(-3, 3);
                local v85 = v83 + math.rad(v84);
                local v86 = u4:NextNumber(-3, 3);
                v82.CFrame = CFrame3 * Angles(0, v85, (math.rad(v86)));
                v82.Color = v37;
            end;

            if i == 9 then
                local Model3 = Instance.new("Model");
                Model3.Name = "Head";
                Model3.Parent = u1;
                local ObjectValue2 = Instance.new("ObjectValue");
                ObjectValue2.Name = "Reference";
                ObjectValue2.Value = Model3;
                ObjectValue2.Parent = v46;
                local v87 = i + 1;
                local v88 = CreatePart(nil, "2022 Stud", nil, Model3);
                v88.Name = v87;
                v88.Size = Vector3.new(v46.Size.X * 1.75, v46.Size.Y * 0.4, v46.Size.Z * 1.75);
                v88.CFrame = v46.CFrame * CFrame.new(0, v46.Size.Y / 2.2 + v88.Size.Y / 2, 0);
                v88.Color = v37;
                local v89 = v87 + 1;
                local v90 = u4:NextInteger(3, 5);

                for i2 = 1, v90 do
                    local v91 = script.SmallLeaf:Clone();
                    v91.Parent = Model3;
                    local v92 = 360 / v90 * (i2 * u4:NextNumber(0.9, 1.1));
                    v91:PivotTo(v88.CFrame * CFrame.new(0, v88.Size.Y * 0.25, 0) * CFrame.Angles(0, math.rad(v92), 2.0943951023931953) * CFrame.new(0, v88.Size.Z / 2.5, 0));
                    ChangeNameToIteration(v91, v89, Model3);
                end;

                local v93 = u4:NextInteger(1, 2) == 1 and 6 or 8;
                local v94 = u4:NextNumber(-45, 45);

                for i2 = 1, v93 do
                    local v95 = script.LargeLeaf:Clone();
                    v95.Parent = Model3;
                    local v96 = u4:NextNumber(78, 83);

                    if i2 % 2 == 1 then
                        v96 = u4:NextNumber(69, 74);
                    end;

                    v95:PivotTo(v88.CFrame * CFrame.new(0, -v88.Size.Y * 0.35, 0) * CFrame.Angles(0, math.rad(360 / v93 * i2 + v94), (math.rad(v96))) * CFrame.new(0, v88.Size.Z / 3, 0));
                    ChangeNameToIteration(v95, v89, Model3);
                end;

                local v97 = u4:NextInteger(3, 4);

                for i2 = 1, v97 do
                    local v98 = script.HexagonLeaf:Clone();
                    v98.Parent = Model3;
                    local v99 = 360 / v97 * (i2 * u4:NextNumber(0.9, 1.1));
                    v98.CFrame = v88.CFrame * CFrame.new(0, v88.Size.Y * 0.55, 0) * CFrame.Angles(0, math.rad(v99), 0) * CFrame.new(0, 0, v88.Size.Z / 2) * CFrame.Angles(-0.4363323129985824, 0, 0) * CFrame.new(0, 0, v98.Size.Z * 0.25);
                    v98.Name = v89;
                end;

                local v100 = u4:NextInteger(6, 8);

                for i2 = 1, v100 do
                    local v101 = script.Petal:Clone();
                    v101.Parent = Model3;
                    v101.CFrame = v88.CFrame * CFrame.new(0, v88.Size.Y * 0.85, 0) * CFrame.Angles(0, math.rad(360 / v100 * i2), -1.2217304763960306) * CFrame.new(0, v101.Size.Y * 0.55, 0);
                    v101.Name = v89;
                end;

                local v102 = script.Mouth:Clone();
                v102.Parent = u1;
                v102:PivotTo(v88.CFrame * CFrame.new(0, v88.Size.Y / 2, 0));
                local Tongue = v102.Base.Tongue;
                local TongueEnd = Tongue.TongueEnd;
                local v103 = Tongue.TongueEnd:GetPivot();
                local Angles = CFrame.Angles;
                local v104 = u4:NextNumber(-20, 5);
                local v105 = math.rad(v104);
                local v106 = u4:NextNumber(-10, 10);
                TongueEnd:PivotTo(v103 * Angles(v105, 0, (math.rad(v106))));
                local v107 = Tongue.TongueEnd["10"];
                local v108 = v107:GetPivot();
                local Angles2 = CFrame.Angles;
                local v109 = u4:NextNumber(-25, 5);
                v107:PivotTo(v108 * Angles2(math.rad(v109), 0, 0));
                local TopJaw = v102.TopJaw;
                local v110 = v102.TopJaw:GetPivot();
                local Angles3 = CFrame.Angles;
                local v111 = u4:NextNumber(-3, 6);
                TopJaw:PivotTo(v110 * Angles3(math.rad(v111), 0, 0));
                local v112 = v89 + 1;

                for _, descendant in v102:GetDescendants() do
                    local v113 = tonumber(descendant.Name);

                    if v113 and (descendant:GetAttribute("CanGenDrip") and u4:NextInteger(1, 3) ~= 1) then
                        local v114 = (u4:NextInteger(1, 2) == 1 and script.Drip1 or script.Drip2):Clone();
                        v114.Parent = descendant.Parent;
                        v114.Name = v113 + v112 + 1;
                        v114.Size = v114.Size + Vector3.new(0, 1, 0) * u4:NextNumber(-0.25, 0.75);
                        v114.CFrame = CFrame.new(descendant.Position) * CFrame.Angles(0, 0, 3.141592653589793) * CFrame.new(0, v114.Size.Y / 2, 0);
                    end;
                end;

                for _, descendant in v102:GetDescendants() do
                    local v115 = tonumber(descendant.Name);

                    if v115 then
                        descendant.Name = v115 + v112;
                    end;
                end;

                Model3.Parent = v102.Base;
            end;

            CFrame2 = v46.CFrame * CFrame.new(0, v46.Size.Y / 2.4, 0);
        end;

        local v116 = u4:NextNumber(-0.05, 0.05);

        for _, v in u1:QueryDescendants("BasePart") do
            if v ~= Base and v.Color ~= Color3.fromRGB(255, 255, 255) then
                local v117, v118, v119 = v.Color:ToHSV();
                v.Color = Color3.fromHSV(math.clamp(v117 + v116, 0.01, 0.99), v118, v119);
            end;
        end;

        u1:ScaleTo(0.75 + (p3 or 1) * 0.25);
        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u120) -- Line: 499, Name: BeginPlantGrowth
        local PrimaryPart = u120.PrimaryPart;
        local u121 = {};

        for _, v in u120:QueryDescendants("BasePart") do
            local v122 = tonumber(v.Name);

            if v122 then
                local v123 = not v:GetAttribute("DontShow");
                local v124 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v124, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v123 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v125 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v122,
                    decals = v124
                };
                table.insert(u121, v125);
                v.CanCollide = false;

                if v123 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 534
            -- upvalues: u120 (copy), u121 (copy), PrimaryPart (copy)
            local v126 = u120:GetAttribute("Age") or 0;
            local v127 = u120:GetAttribute("MaxAge") or 1;
            local v128 = v126 / v127;

            for _, v in u121 do
                if not v.part:GetAttribute("DontShow") then
                    local v129 = math.clamp((v128 - v.partAge / v127) * v127, 0, 1);

                    if v129 ~= v.lastProgress then
                        v.lastProgress = v129;

                        if v129 > 0 then
                            local v130 = v.maxSize * v129;
                            v.part.Size = v130;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v130.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v129);
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

            if game.Players.LocalPlayer and (game:GetService("RunService"):IsClient() and (not u120:GetAttribute("SetupIK") and v127 <= v126)) then
                u120:SetAttribute("SetupIK", true);
                task.delay(1, function() -- Line: 574
                    -- upvalues: u120 (ref)
                    u120:AddTag("VenomSpitter");
                end);
            end;
        end;

        u120:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};