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

        local v14, v15 = Color3.fromRGB(51, 136, 5);
        local v16, v17, v18 = v14:ToHSV();
        local v19 = v15 or 0.05;
        local v20 = v16 + u5:NextNumber(-v19, v19);
        local v21 = math.clamp(v20, 0, 0.99);
        local u22 = Color3.fromHSV(v21, v17, v18);

        local function CreatePart(p23, p24, p25) -- Line: 33
            -- upvalues: u1 (copy), MaterialService (copy)
            local Part = Instance.new("Part");
            local v26 = p23 or "Studs";
            Part.Parent = u1;
            Part.TopSurface = Enum.SurfaceType[v26];
            Part.BackSurface = Enum.SurfaceType[v26];
            Part.FrontSurface = Enum.SurfaceType[v26];
            Part.BottomSurface = Enum.SurfaceType[v26];
            Part.LeftSurface = Enum.SurfaceType[v26];
            Part.RightSurface = Enum.SurfaceType[v26];
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Transparency = 0;

            if p25 then
                Part.Shape = Enum.PartType[p25];
            end;

            if p24 then
                Part.MaterialVariant = p24;
                local v27 = MaterialService:FindFirstChild(p24, true);

                if not v27 then
                    return Part;
                end;

                Part.Material = v27.BaseMaterial;
            end;

            return Part;
        end;

        local function CreateFruitSpawn(p28, p29, p30) -- Line: 63
            -- upvalues: CreatePart (copy), u22 (copy), FruitSpawnLocations (copy)
            local v31 = CreatePart(nil, "2022 Inlet");
            v31.Size = Vector3.new(p29.X * 1.5, 0.5, p29.X * 1.5);
            v31.CFrame = p28;
            v31.Color = u22;
            v31.Name = p30 + 1;
            local v32 = CreatePart(nil, "2022 Inlet");
            v32.Size = Vector3.new(p29.X * 1.5, 0.4, p29.X * 1.5);
            v32.CFrame = v31.CFrame * CFrame.Angles(0, 0.7853981633974483, 0);
            v32.Color = u22;
            v32.Name = p30 + 2;
            local v33 = CreatePart();
            v33.Parent = FruitSpawnLocations;
            v33.Size = Vector3.new(1, 1, 1);
            v33.CFrame = v31.CFrame * CFrame.new(0, 0.25, 0);
            v33.Transparency = 1;
        end;

        local function CreateStem(p34, p35, p36, p37) -- Line: 86
            -- upvalues: CreatePart (copy), u5 (copy), u22 (copy), CreateFruitSpawn (copy), u1 (copy)
            for i = 1, p34 do
                local v38 = CreatePart(nil, "2022 Inlet");
                v38.Size = p35;
                local Angles = CFrame.Angles;
                local v39 = u5:NextNumber(-9, 9);
                local v40 = math.rad(v39);
                local v41 = u5:NextNumber(-9, 9);
                v38.CFrame = p36 * Angles(v40, 0.2617993877991494, (math.rad(v41))) * CFrame.new(0, p35.Y / 2.2, 0);
                v38.Color = u22;
                v38.Name = i + p37;

                if i > 1 and (i < p34 and u5:NextInteger(1, 2) == 1) then
                    local v42 = u5:NextInteger(1, 3);
                    local v43 = v38.CFrame * CFrame.new(0, -(v38.Size.Y / 2), 0);
                    local Angles2 = CFrame.Angles;
                    local v44 = u5:NextNumber(-180, 180);
                    local v45 = v43 * Angles2(0, math.rad(v44), 0);
                    local Angles3 = CFrame.Angles;
                    local v46 = u5:NextNumber(20, 40);
                    local v47 = v45 * Angles3(math.rad(v46), 0, 0);

                    for i2 = 1, v42 do
                        local v48 = CreatePart(nil, "2022 Inlet");
                        v48.Size = Vector3.new(p35.X * 0.9, p35.Y * 0.6, p35.Z * 0.9);
                        local Angles4 = CFrame.Angles;
                        local v49 = u5:NextNumber(10, 25);
                        v48.CFrame = v47 * Angles4(math.rad(v49), 0, 0) * CFrame.new(0, v48.Size.Y / 2, 0);
                        v48.Name = i + p37 + i2;
                        v48.Color = u22;
                        v47 = v48.CFrame * CFrame.new(0, v48.Size.Y / 2, 0);
                        local CFrame2 = v48.CFrame;
                        local Angles5 = CFrame.Angles;
                        local v50 = u5:NextNumber(-25, 25);
                        v48.CFrame = CFrame2 * Angles5(0, math.rad(v50), 0);

                        if i2 == v42 then
                            CreateFruitSpawn(v47, v48.Size, i + p37 + i2);
                        end;
                    end;
                end;

                if u5:NextInteger(1, 3) == 1 then
                    local v51 = CreatePart(nil, "2022 Inlet");
                    v51.Size = Vector3.new(p35.X * 0.8, p35.Y * 0.65, p35.Z * 0.8);
                    local v52 = v38.CFrame * CFrame.new(0, -(v38.Size.Y / 2), 0);
                    local Angles2 = CFrame.Angles;
                    local v53 = u5:NextNumber(-180, 180);
                    local v54 = v52 * Angles2(0, math.rad(v53), 0);
                    local Angles3 = CFrame.Angles;
                    local v55 = u5:NextNumber(40, 55);
                    v51.CFrame = v54 * Angles3(math.rad(v55), 0, 0) * CFrame.new(0, v51.Size.Y / 2, 0);
                    v51.Name = i + p37 + 1;
                    v51.Color = u22;
                    local v56 = script.FlowerPetal:Clone();
                    v56.Parent = u1;
                    v56:PivotTo(v51.CFrame * CFrame.new(0, v51.Size.Y / 2.5, 0) * CFrame.Angles(0.6108652381980153, 0, 0));
                    v56.Name = i + p37 + 2;
                end;

                p36 = v38.CFrame * CFrame.new(0, p35.Y / 2.2, 0);
                local CFrame2 = v38.CFrame;
                local Angles2 = CFrame.Angles;
                local v57 = u5:NextNumber(-25, 25);
                v38.CFrame = CFrame2 * Angles2(0, math.rad(v57), 0);

                if i == p34 then
                    CreateFruitSpawn(p36, v38.Size, i + p37);
                end;
            end;
        end;

        local v58 = u5:NextInteger(3, 5);
        local v59 = p3 or 1;

        for i = 1, v58 do
            local v60 = script.CurvedLeaf:Clone();
            v60.Parent = u1;
            local v61 = 360 / v58 * (i * u5:NextNumber(0.8, 1.2));
            local v62 = Base.CFrame * CFrame.Angles(0, math.rad(v61), 0);
            local Angles = CFrame.Angles;
            local v63 = -u5:NextNumber(35, 55);
            v60:PivotTo(v62 * Angles(math.rad(v63), 0, 0));
            v60.Name = 1;
        end;

        local v64, v65, v66;

        if PlantUpdateVariants.ReturnVariant("Corn", p4) >= 1 then
            v64 = u5:NextNumber(0.45, 0.75) * (v59 * 0.3 + 0.7);
            v65 = u5:NextNumber(2.9, 4) * (v59 * 0.3 + 0.7);
            v66 = u5:NextInteger(3, 5) * v59;

            while u5:NextInteger(1, 70) == 1 do
                v66 = v66 * 2;
            end;
        else
            v64 = u5:NextNumber(0.45, 0.75) * (v59 * 0.5 + 0.5);
            v65 = u5:NextNumber(2.9, 4) * (v59 * 0.5 + 0.5);
            v66 = u5:NextInteger(3, 5) * v59;

            while u5:NextInteger(1, 30) == 1 do
                v66 = v66 * 2;

                while u5:NextInteger(1, 3) == 1 do
                    v64 = v64 * 2;
                    v65 = v65 * 2;
                end;
            end;
        end;

        CreateStem(v66, Vector3.new(v64, v65, v64), Base.CFrame, 0, true);
        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u67) -- Line: 188, Name: BeginPlantGrowth
        local PrimaryPart = u67.PrimaryPart;
        local u68 = {};

        for _, v in u67:QueryDescendants("BasePart") do
            local v69 = tonumber(v.Name);

            if v69 then
                local v70 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v69
                };
                table.insert(u68, v70);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 206
            -- upvalues: u67 (copy), u68 (copy), PrimaryPart (copy)
            local v71 = u67:GetAttribute("Age") or 0;

            for _, v in u68 do
                local v72 = v[1];
                local v73 = v[2];
                local v74 = v[3];
                local v75 = math.min(v71 - v[4], 1);
                local v76 = math.clamp(v75, 0, 1);

                if v76 ~= v.lastProgress then
                    v.lastProgress = v76;

                    if v75 > 0 then
                        v72.Size = Vector3.new(v73.X, v73.Y * v75, v73.Z);
                        v72.CFrame = PrimaryPart.CFrame * v74 * CFrame.new(0, (v72.Size.Y - v73.Y) / 2, 0);
                        v72.Transparency = v72:GetAttribute("OG_Transparency") or 0;
                        v72.CanCollide = true;
                    else
                        v72.Transparency = 1;
                        v72.CanCollide = false;
                    end;
                end;
            end;
        end;

        u67:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};