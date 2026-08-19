-- Decompiled with Potassium's decompiler.

game:GetService("MaterialService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PlantUpdateVariants = require(ReplicatedStorage.SharedModules.PlantUpdateVariants);

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u1, p2, p3, p4) -- Line: 12, Name: InitPlant
        -- upvalues: PlantUpdateVariants (copy)
        local MaterialService = game:GetService("MaterialService");
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

        local v14, v15 = Color3.fromRGB(186, 162, 27);
        local v16, v17, v18 = v14:ToHSV();
        local v19 = v15 or 0.05;
        local v20 = v16 + u5:NextNumber(-v19, v19);
        local v21 = math.clamp(v20, 0, 0.99);
        local u22 = Color3.fromHSV(v21, v17, v18);
        local v23, v24 = Color3.fromRGB(186, 119, 26);
        local v25, v26, v27 = v23:ToHSV();
        local v28 = v24 or 0.05;
        local v29 = v25 + u5:NextNumber(-v28, v28);
        local v30 = math.clamp(v29, 0, 0.99);
        local u31 = Color3.fromHSV(v30, v26, v27);

        local function CreatePart(p32, p33, p34) -- Line: 33
            -- upvalues: u1 (copy), MaterialService (copy)
            local Part = Instance.new("Part");
            local v35 = p32 or "Studs";
            Part.Parent = u1;
            Part.TopSurface = Enum.SurfaceType[v35];
            Part.BackSurface = Enum.SurfaceType[v35];
            Part.FrontSurface = Enum.SurfaceType[v35];
            Part.BottomSurface = Enum.SurfaceType[v35];
            Part.LeftSurface = Enum.SurfaceType[v35];
            Part.RightSurface = Enum.SurfaceType[v35];
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Transparency = 0;

            if p34 then
                Part.Shape = Enum.PartType[p34];
            end;

            if p33 then
                Part.MaterialVariant = p33;
                local v36 = MaterialService:FindFirstChild(p33, true);

                if not v36 then
                    return Part;
                end;

                Part.Material = v36.BaseMaterial;
            end;

            return Part;
        end;

        local function CreateFruitSpawn(p37, p38, p39) -- Line: 63
            -- upvalues: CreatePart (copy), u5 (copy), u22 (copy), u31 (copy), FruitSpawnLocations (copy)
            local v40 = CreatePart(nil, "2022 Inlet");
            v40.Size = Vector3.new(p38.X * 1.5, 0.5, p38.X * 1.5);
            v40.CFrame = p37;
            v40.Color = u5:NextInteger(1, 2) == 1 and u22 or u31;
            v40.Name = p39 + 1;
            local v41 = CreatePart(nil, "2022 Inlet");
            v41.Size = Vector3.new(p38.X * 1.5, 0.4, p38.X * 1.5);
            v41.CFrame = v40.CFrame * CFrame.Angles(0, 0.7853981633974483, 0);
            v41.Color = u5:NextInteger(1, 2) == 1 and u22 or u31;
            v41.Name = p39 + 2;
            local v42 = CreatePart();
            v42.Parent = FruitSpawnLocations;
            v42.Size = Vector3.new(1, 1, 1);
            v42.CFrame = v40.CFrame * CFrame.new(0, 0.25, 0);
            v42.Transparency = 1;
        end;

        local function CreateStem(p43, p44, p45, p46) -- Line: 86
            -- upvalues: CreatePart (copy), u5 (copy), u22 (copy), u31 (copy), CreateFruitSpawn (copy), u1 (copy)
            for i = 1, p43 do
                local v47 = CreatePart(nil, "2022 Inlet");
                v47.Size = p44;
                local Angles = CFrame.Angles;
                local v48 = u5:NextNumber(-9, 9);
                local v49 = math.rad(v48);
                local v50 = u5:NextNumber(-9, 9);
                v47.CFrame = p45 * Angles(v49, 0.2617993877991494, (math.rad(v50))) * CFrame.new(0, p44.Y / 2.2, 0);
                v47.Color = u5:NextInteger(1, 2) == 1 and u22 or u31;
                v47.Name = i + p46;

                if i > 1 and (i < p43 and u5:NextInteger(1, 2) == 1) then
                    local v51 = u5:NextInteger(1, 3);
                    local v52 = v47.CFrame * CFrame.new(0, -(v47.Size.Y / 2), 0);
                    local Angles2 = CFrame.Angles;
                    local v53 = u5:NextNumber(-180, 180);
                    local v54 = v52 * Angles2(0, math.rad(v53), 0);
                    local Angles3 = CFrame.Angles;
                    local v55 = u5:NextNumber(20, 40);
                    local v56 = v54 * Angles3(math.rad(v55), 0, 0);

                    for i2 = 1, v51 do
                        local v57 = CreatePart(nil, "2022 Inlet");
                        v57.Size = Vector3.new(p44.X * 0.9, p44.Y * 0.6, p44.Z * 0.9);
                        local Angles4 = CFrame.Angles;
                        local v58 = u5:NextNumber(10, 25);
                        v57.CFrame = v56 * Angles4(math.rad(v58), 0, 0) * CFrame.new(0, v57.Size.Y / 2, 0);
                        v57.Name = i + p46 + i2;
                        v57.Color = u5:NextInteger(1, 2) == 1 and u22 or u31;
                        v56 = v57.CFrame * CFrame.new(0, v57.Size.Y / 2, 0);
                        local CFrame2 = v57.CFrame;
                        local Angles5 = CFrame.Angles;
                        local v59 = u5:NextNumber(-25, 25);
                        v57.CFrame = CFrame2 * Angles5(0, math.rad(v59), 0);

                        if i2 == v51 then
                            CreateFruitSpawn(v56, v57.Size, i + p46 + i2);
                        end;
                    end;
                end;

                if u5:NextInteger(1, 3) == 1 then
                    local v60 = CreatePart(nil, "2022 Inlet");
                    v60.Size = Vector3.new(p44.X * 0.8, p44.Y * 0.65, p44.Z * 0.8);
                    local v61 = v47.CFrame * CFrame.new(0, -(v47.Size.Y / 2), 0);
                    local Angles2 = CFrame.Angles;
                    local v62 = u5:NextNumber(-180, 180);
                    local v63 = v61 * Angles2(0, math.rad(v62), 0);
                    local Angles3 = CFrame.Angles;
                    local v64 = u5:NextNumber(40, 55);
                    v60.CFrame = v63 * Angles3(math.rad(v64), 0, 0) * CFrame.new(0, v60.Size.Y / 2, 0);
                    v60.Name = i + p46 + 1;
                    v60.Color = u5:NextInteger(1, 2) == 1 and u22 or u31;
                    local v65 = script.FlowerPetal:Clone();
                    v65.Parent = u1;
                    v65:PivotTo(v60.CFrame * CFrame.new(0, v60.Size.Y / 2.5, 0) * CFrame.Angles(0.6108652381980153, 0, 0));
                    v65.Name = i + p46 + 2;
                end;

                p45 = v47.CFrame * CFrame.new(0, p44.Y / 2.2, 0);
                local CFrame2 = v47.CFrame;
                local Angles2 = CFrame.Angles;
                local v66 = u5:NextNumber(-25, 25);
                v47.CFrame = CFrame2 * Angles2(0, math.rad(v66), 0);

                if i == p43 then
                    CreateFruitSpawn(p45, v47.Size, i + p46);
                end;
            end;
        end;

        local v67 = u5:NextInteger(3, 5);
        local v68 = p3 or 1;

        for i = 1, v67 do
            local v69 = script.CurvedLeaf:Clone();
            v69.Parent = u1;
            local v70 = 360 / v67 * (i * u5:NextNumber(0.8, 1.2));
            local v71 = Base.CFrame * CFrame.Angles(0, math.rad(v70), 0);
            local Angles = CFrame.Angles;
            local v72 = -u5:NextNumber(35, 55);
            v69:PivotTo(v71 * Angles(math.rad(v72), 0, 0));
            v69.Name = 1;
        end;

        local v73, v74, v75;

        if PlantUpdateVariants.ReturnVariant("Corn", p4) >= 1 then
            v73 = u5:NextNumber(0.45, 0.75) * (v68 * 0.3 + 0.7);
            v74 = u5:NextNumber(2.9, 4) * (v68 * 0.3 + 0.7);
            v75 = u5:NextInteger(3, 5) * v68;

            while u5:NextInteger(1, 70) == 1 do
                v75 = v75 * 2;
            end;
        else
            v73 = u5:NextNumber(0.45, 0.75) * (v68 * 0.5 + 0.5);
            v74 = u5:NextNumber(2.9, 4) * (v68 * 0.5 + 0.5);
            v75 = u5:NextInteger(3, 5) * v68;

            while u5:NextInteger(1, 30) == 1 do
                v75 = v75 * 2;

                while u5:NextInteger(1, 3) == 1 do
                    v73 = v73 * 2;
                    v74 = v74 * 2;
                end;
            end;
        end;

        CreateStem(v75, Vector3.new(v73, v74, v73), Base.CFrame, 0, true);
        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u76) -- Line: 188, Name: BeginPlantGrowth
        local PrimaryPart = u76.PrimaryPart;
        local u77 = {};
        local u78 = {};

        for _, v in u76:QueryDescendants("BasePart") do
            if v:HasTag("PlantTruss") then
                table.insert(u77, v);
            else
                local v79 = not v:GetAttribute("DontShow");
                local v80 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v80, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v79 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v81 = tonumber(v.Name);

                if v81 then
                    local v82 = {
                        v,
                        v.Size,
                        PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                        v81,
                        decals = v80
                    };
                    table.insert(u78, v82);
                    v.CanCollide = false;
                    v.Transparency = 1;
                end;
            end;
        end;

        table.sort(u78, function(p83, p84) -- Line: 229
            return p83[4] < p84[4];
        end);

        local function updateGrowth() -- Line: 231
            -- upvalues: u76 (copy), u78 (copy), PrimaryPart (copy), u77 (copy)
            local v85 = u76:GetAttribute("Age") or 0;

            for _, v in u78 do
                local v86 = v[1];
                local v87 = v[2];
                local v88 = v[3];
                local v89 = math.min(v85 - v[4], 1);
                local v90 = math.clamp(v89, 0, 1);

                if v90 ~= v.lastProgress then
                    v.lastProgress = v90;

                    if v89 > 0 then
                        v86.Size = Vector3.new(v87.X, v87.Y * v89, v87.Z);
                        v86.CFrame = PrimaryPart.CFrame * v88 * CFrame.new(0, (v86.Size.Y - v87.Y) / 2, 0);
                        v86.Transparency = v86:GetAttribute("OG_Transparency") or 0;
                        v86.CanCollide = true;

                        for _, v2 in v.decals do
                            v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v90);
                        end;
                    else
                        v86.Transparency = 1;
                        v86.CanCollide = false;

                        for _, v2 in v.decals do
                            v2.decal.Transparency = 1;
                        end;
                    end;
                end;
            end;

            for _, v in u77 do
                local v91 = v:GetAttribute("TrunkReference");
                local v92 = tonumber(v91);

                if v92 then
                    if math.min(v85 - v92, 1) >= 1 then
                        v.CanCollide = true;
                    else
                        v.CanCollide = false;
                    end;
                end;
            end;
        end;

        u76:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};