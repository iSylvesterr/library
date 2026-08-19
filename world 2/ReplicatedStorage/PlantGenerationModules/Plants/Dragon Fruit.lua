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
        local v5 = (p3 or 1) * 0.25 + 0.75;

        local function GetRandomHSV(p6, p7) -- Line: 22
            -- upvalues: u4 (copy)
            local v8, v9, v10 = p6:ToHSV();
            local v11 = p7 or 0.05;
            local v12 = v8 + u4:NextNumber(-v11, v11);
            local v13 = math.clamp(v12, 0, 0.99);

            return Color3.fromHSV(v13, v9, v10), v13, v9, v10;
        end;

        local v14, v15 = Color3.fromRGB(51, 136, 5);
        local v16, v17, v18 = v14:ToHSV();
        local v19 = v15 or 0.05;
        local v20 = v16 + u4:NextNumber(-v19, v19);
        local v21 = math.clamp(v20, 0, 0.99);
        Color3.fromHSV(v21, v17, v18);
        local v22 = u4:NextInteger(9, 16);

        local function spawnTrunkTrusses(u23) -- Line: 62
            -- upvalues: u1 (copy)
            local Size = u23.Size;
            local CFrame2 = u23.CFrame;
            local Y = Size.Y;
            local v24 = math.ceil(Size.X / 2);
            local v25 = math.max(1, v24);
            local v26 = math.ceil(Size.Z / 2);
            local v27 = math.max(1, v26);

            local function spawnTruss(p28) -- Line: 69
                -- upvalues: Y (copy), u23 (copy), u1 (ref)
                local TrussPart = Instance.new("TrussPart");
                TrussPart.Anchored = true;
                TrussPart.Size = Vector3.new(2, Y, 2);
                TrussPart.CFrame = p28;
                TrussPart:SetAttribute("TrunkReference", u23.Name);
                TrussPart:AddTag("PlantTruss");
                TrussPart.CanCollide = false;
                TrussPart.Transparency = 1;
                TrussPart.Parent = u1;
            end;

            local function spread(p29, p30) -- Line: 81
                local v31 = {};

                if p29 == 1 then
                    v31[1] = 0;

                    return v31;
                end;

                for i = 0, p29 - 1 do
                    v31[i + 1] = -p30 / 2 + 1 + i / (p29 - 1) * (p30 - 2);
                end;

                return v31;
            end;

            local v32 = spread(v25, Size.X);
            local v33 = spread(v27, Size.Z);

            for _, v in ipairs(v32) do
                local v34 = CFrame2 * CFrame.new(v, 0, Size.Z / 2 - 0.8);
                local TrussPart = Instance.new("TrussPart");
                TrussPart.Anchored = true;
                TrussPart.Size = Vector3.new(2, Y, 2);
                TrussPart.CFrame = v34;
                TrussPart:SetAttribute("TrunkReference", u23.Name);
                TrussPart:AddTag("PlantTruss");
                TrussPart.CanCollide = false;
                TrussPart.Transparency = 1;
                TrussPart.Parent = u1;
                local v35 = CFrame2 * CFrame.new(v, 0, -Size.Z / 2 + 0.8);
                local TrussPart2 = Instance.new("TrussPart");
                TrussPart2.Anchored = true;
                TrussPart2.Size = Vector3.new(2, Y, 2);
                TrussPart2.CFrame = v35;
                TrussPart2:SetAttribute("TrunkReference", u23.Name);
                TrussPart2:AddTag("PlantTruss");
                TrussPart2.CanCollide = false;
                TrussPart2.Transparency = 1;
                TrussPart2.Parent = u1;
            end;

            for _, v in ipairs(v33) do
                local v36 = CFrame2 * CFrame.new(Size.X / 2 - 0.8, 0, v);
                local TrussPart = Instance.new("TrussPart");
                TrussPart.Anchored = true;
                TrussPart.Size = Vector3.new(2, Y, 2);
                TrussPart.CFrame = v36;
                TrussPart:SetAttribute("TrunkReference", u23.Name);
                TrussPart:AddTag("PlantTruss");
                TrussPart.CanCollide = false;
                TrussPart.Transparency = 1;
                TrussPart.Parent = u1;
                local v37 = CFrame2 * CFrame.new(-Size.X / 2 + 0.8, 0, v);
                local TrussPart2 = Instance.new("TrussPart");
                TrussPart2.Anchored = true;
                TrussPart2.Size = Vector3.new(2, Y, 2);
                TrussPart2.CFrame = v37;
                TrussPart2:SetAttribute("TrunkReference", u23.Name);
                TrussPart2:AddTag("PlantTruss");
                TrussPart2.CanCollide = false;
                TrussPart2.Transparency = 1;
                TrussPart2.Parent = u1;
            end;
        end;

        local function CreatePart(p38, p39, p40) -- Line: 32
            -- upvalues: u1 (copy), MaterialService (copy)
            local Part = Instance.new("Part");
            local v41 = p38 or "Studs";
            Part.Parent = u1;
            Part.TopSurface = Enum.SurfaceType[v41];
            Part.BackSurface = Enum.SurfaceType[v41];
            Part.FrontSurface = Enum.SurfaceType[v41];
            Part.BottomSurface = Enum.SurfaceType[v41];
            Part.LeftSurface = Enum.SurfaceType[v41];
            Part.RightSurface = Enum.SurfaceType[v41];
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Transparency = 0;

            if p40 then
                Part.Shape = Enum.PartType[p40];
            end;

            if p39 then
                Part.MaterialVariant = p39;
                local v42 = MaterialService:FindFirstChild(p39, true);

                if not v42 then
                    return Part;
                end;

                Part.Material = v42.BaseMaterial;
            end;

            return Part;
        end;

        while u4:NextInteger(1, 70) == 1 do
            v22 = v22 * 3;
        end;

        local v43 = u4:NextNumber(3, 4) * v5;
        local v44 = u4:NextNumber(1.5, 2) * v5;
        local v45 = Vector3.new(v43, v44, v43);
        local CFrame2 = Base.CFrame;
        local v46 = u4:NextNumber(5, 8);
        local v47 = 360 * u4:NextNumber(1.85, 2.75) / v22;
        local v48, v49 = Color3.fromRGB(61, 146, 1);
        local v50, v51, v52 = v48:ToHSV();
        local v53 = v49 or 0.05;
        local v54 = v50 + u4:NextNumber(-v53, v53);
        local v55 = math.clamp(v54, 0, 0.99);
        local v56 = Color3.fromHSV(v55, v51, v52);
        local v57 = 0;

        while u4:NextInteger(1, 4) == 1 do
            v22 = v22 + u4:NextInteger(2, 4);

            if v22 > 25 then
                break;
            end;
        end;

        local CFrame3 = Base.CFrame;
        local v58, v59 = Color3.fromRGB(137, 59, 13);
        local v60, v61, v62 = v58:ToHSV();
        local v63 = v59 or 0.05;
        local v64 = v60 + u4:NextNumber(-v63, v63);
        local v65 = math.clamp(v64, 0, 0.99);
        local v66 = Color3.fromHSV(v65, v61, v62);
        local v67, v68 = Color3.fromRGB(164, 96, 31);
        local v69, v70, v71 = v67:ToHSV();
        local v72 = v68 or 0.05;
        local v73 = v69 + u4:NextNumber(-v72, v72);
        local v74 = math.clamp(v73, 0, 0.99);
        local v75 = Color3.fromHSV(v74, v70, v71);
        local v76 = v22 / 2;

        for i = 1, v22 do
            local v77 = script.Trunk:Clone();
            v77.Parent = u1;
            v77.Size = v45;
            local Angles = CFrame.Angles;
            local v78 = math.rad(v46);
            local v79 = u4:NextNumber(-4, 4);
            v77.CFrame = CFrame2 * Angles(0, v78, (math.rad(v79))) * CFrame.new(0, v45.Y / 2.2, 0);
            v77.Name = i;
            v77.Color = v66:Lerp(v75, 1 - math.abs((i - v76) / v76));
            spawnTrunkTrusses(v77);
            local v80 = v45.X * 0.65;
            local new = CFrame.new;
            local v81 = math.rad(v57);
            local v82 = math.cos(v81) * v80;
            local v83 = v45.Y / 2;
            local v84 = math.rad(v57);
            local v85 = CFrame2 * new(v82, v83, math.sin(v84) * v80);
            local Magnitude = (CFrame3.Position - v85.Position).Magnitude;
            local v86 = CreatePart(nil, "2022 Diamond Stud");
            local v87 = u4:NextNumber(0.7, 1.2) * v5;
            v86.Size = Vector3.new(v87, Magnitude * 1.15, v87);
            v86.CFrame = CFrame.lookAt(CFrame3.Position, v85.Position) * CFrame.new(0, 0, -Magnitude / 2) * CFrame.Angles(-1.5707963267948966, 0, 0);
            v86.Color = v56;
            v86.Name = i + 1;
            CFrame2 = v77.CFrame * CFrame.new(0, v45.Y / 2, 0);
            v57 = v57 + v47;

            if i == v22 then
                local v88 = u4:NextInteger(12, 14);
                CFrame3 = v85;

                for i2 = 1, v88 do
                    local v89 = script.Leaf:Clone();
                    v89.Parent = u1;
                    v89:ScaleTo(u4:NextNumber(0.85, 1.1) * v5);
                    local v90 = CFrame2 * CFrame.Angles(0, math.rad(360 / v88 * i2), 0) * CFrame.new(v45.X * 0.35, 0, 0);
                    local Angles2 = CFrame.Angles;
                    local v91 = -u4:NextNumber(25, 40);
                    v89:PivotTo(v90 * Angles2(0, 0, (math.rad(v91))));

                    for _, child in v89:GetChildren() do
                        if child.Name == "FruitSpawn" then
                            child.CFrame = child.CFrame * CFrame.new(0, u4:NextNumber(-2, 2), 0);
                            child.Parent = FruitSpawnLocations;
                        end;

                        local v92 = tonumber(child.Name);

                        if v92 then
                            child.Color = v56;
                            child.Name = v92 + i;
                            child.Parent = u1;
                        end;
                    end;

                    v85 = CFrame3;
                    CFrame3 = v85;
                end;
            else
                CFrame3 = v85;
            end;
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u93) -- Line: 197, Name: BeginPlantGrowth
        local PrimaryPart = u93.PrimaryPart;
        local u94 = {};
        local u95 = {};

        for _, v in u93:QueryDescendants("BasePart") do
            if v:HasTag("PlantTruss") then
                table.insert(u94, v);
            else
                local v96 = tonumber(v.Name);

                if v96 then
                    local v97 = {
                        v,
                        v.Size,
                        PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                        v96
                    };
                    table.insert(u95, v97);
                    v.CanCollide = false;
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 220
            -- upvalues: u93 (copy), u95 (copy), PrimaryPart (copy), u94 (copy)
            local v98 = u93:GetAttribute("Age") or 0;

            for _, v in u95 do
                local v99 = v[1];
                local v100 = v[2];
                local v101 = v[3];
                local v102 = math.min(v98 - v[4], 1);
                local v103 = math.clamp(v102, 0, 1);

                if v103 ~= v.lastProgress then
                    v.lastProgress = v103;

                    if v102 > 0 then
                        v99.Size = Vector3.new(v100.X, v100.Y * v102, v100.Z);
                        v99.CFrame = PrimaryPart.CFrame * v101 * CFrame.new(0, (v99.Size.Y - v100.Y) / 2, 0);
                        v99.Transparency = v99:GetAttribute("OG_Transparency") or 0;
                        v99.CanCollide = true;
                    else
                        v99.Transparency = 1;
                        v99.CanCollide = false;
                    end;
                end;
            end;

            for _, v in u94 do
                local v104 = v:GetAttribute("TrunkReference");
                local v105 = tonumber(v104);

                if v105 then
                    if math.min(v98 - v105, 1) >= 1 then
                        v.CanCollide = true;
                    else
                        v.CanCollide = false;
                    end;
                end;
            end;
        end;

        u93:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};