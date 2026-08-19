-- Decompiled with Potassium's decompiler.

local MaterialService = game:GetService("MaterialService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PlantGrowthShaping = require(ReplicatedStorage.SharedModules.PlantGrowthShaping);

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u1, p2, p3) -- Line: 23, Name: InitPlant
        -- upvalues: MaterialService (copy), PlantGrowthShaping (copy)
        local u4 = p3 or 1;
        local u5 = Random.new(p2);
        local _ = u1.FruitSpawnLocations;
        local Base = u1.Base;
        local u6;

        if u4 > 2 then
            u6 = u5:NextInteger(1, 5000) == 1;
        else
            u6 = false;
        end;

        if u6 then
            u1:AddTag("LoopyBanana");
        end;

        local u7 = u5:NextInteger(1, 5000) == 1;

        if u7 then
            u1:AddTag("SpiralBanana");
        end;

        local function GetRandomHSV(p8, p9) -- Line: 40
            -- upvalues: u5 (copy)
            local v10, v11, v12 = p8:ToHSV();
            local v13 = p9 or 0.05;
            local v14 = v10 + u5:NextNumber(-v13, v13);

            return Color3.fromHSV(v14, v11, v12), v14, v11, v12;
        end;

        local function CreatePart(p15, p16, p17) -- Line: 48
            -- upvalues: u1 (copy), MaterialService (ref)
            local Part = Instance.new("Part");
            local v18 = p15 or "Studs";
            Part.Parent = u1;
            Part.TopSurface = Enum.SurfaceType[v18];
            Part.BackSurface = Enum.SurfaceType[v18];
            Part.FrontSurface = Enum.SurfaceType[v18];
            Part.BottomSurface = Enum.SurfaceType[v18];
            Part.LeftSurface = Enum.SurfaceType[v18];
            Part.RightSurface = Enum.SurfaceType[v18];
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Transparency = 1;

            if p17 then
                Part.Shape = Enum.PartType[p17];
            end;

            if p16 then
                Part.MaterialVariant = p16;
                local v19 = MaterialService:FindFirstChild(p16, true);

                if not v19 then
                    return Part;
                end;

                Part.Material = v19.BaseMaterial;
            end;

            return Part;
        end;

        local u20 = PlantGrowthShaping.GeometryShrink(u4, 6);
        local u21 = Vector3.new(2, 4.5, 2) * u4 * u20;
        local _ = Base.CFrame;
        local Base2 = u1.Base;
        local u22 = Color3.fromRGB(164, 94, 26);
        local u23 = Color3.fromRGB(171, 132, 77);

        local function generateTrunk(p24, p25) -- Line: 87
            -- upvalues: u5 (copy), u21 (copy), u7 (copy), u22 (copy), u23 (copy), Base2 (ref), Base (copy), PlantGrowthShaping (ref), u1 (copy), u4 (ref), u20 (copy), u6 (copy)
            local v26 = p24:GetPivot();
            local v27 = u5:NextInteger(-9, 9);
            local v28 = u5:NextInteger(-9, 9);

            for i = 1, p25 do
                local v29 = script.Stud_Part:Clone();
                local _ = (i - 1) / math.max(p25 - 1, 1);
                local v30 = math.clamp(u21.X - (i - 1) / (p25 - 1) * (u21.X / 3), 1, 10);
                local v31;

                if i % 2 == 0 then
                    v31 = -v27;
                else
                    v31 = v27;
                end;

                local v32;

                if i % 2 == 0 then
                    v32 = -v28;
                else
                    v32 = v28;
                end;

                local v33 = u5:NextNumber(-5, 5);
                local v34;

                if u7 then
                    v34 = (i - 1) / math.max(p25 - 1, 1) * 1.9 + 0.1;
                    v31 = 30;
                    v33 = 0;
                    v32 = 60;
                else
                    v34 = 1;
                end;

                local v35 = (u21.Y + u5:NextNumber(-2, 2)) * v34;
                local Angles = CFrame.Angles;
                local v36 = v31 + u5:NextNumber(-2, 2);
                local v37 = math.rad(v36);
                local v38 = math.rad(v33);
                local v39 = v32 + u5:NextNumber(-2, 2);
                local v40 = Angles(v37, v38, (math.rad(v39)));
                local new = CFrame.new;
                local Position = v26.Position;
                local v41 = u5:NextNumber(-5, 5);
                local v42 = u5:NextNumber(-5, 5);
                new(Position + Vector3.new(v41, v42, u5:NextNumber(-5, 5)));
                v29.Color = u22:Lerp(u23, (math.clamp(i / p25, 0, 1)));
                v29.Size = Vector3.new(v30, v35, v30);
                local v43 = 0;

                if Base2 and Base2 ~= Base then
                    v43 = Base2.Size.Y;
                    v26 = Base2:GetPivot();
                elseif u7 then
                    local Angles2 = CFrame.Angles;
                    local v44 = u5:NextNumber(0, 360);
                    v40 = Angles2(0, math.rad(v44), 0) * CFrame.Angles(1.4835298641951802, 0, 0);
                else
                    local Angles2 = CFrame.Angles;
                    local v45 = v31 + u5:NextNumber(-2, 2);
                    local v46 = math.rad(v45);
                    local v47 = u5:NextNumber(0, 360);
                    local v48 = math.rad(v47);
                    local v49 = v31 + u5:NextNumber(-2, 2);
                    v40 = Angles2(v46, v48, (math.rad(v49)));
                end;

                v29.CFrame = v26 * CFrame.new(0, v43 / 2.1, 0) * v40 * CFrame.new(0, v35 / 2.1, 0);
                v29.CFrame = PlantGrowthShaping.TipTowardUp(v29.CFrame, v35 / 2, 0.2);
                v29.Name = i;
                v29.Parent = u1;

                if i == p25 then
                    local v50 = u5:NextNumber(3, 6);

                    while u5:NextInteger(1, 10) == 1 and v50 < 30 do
                        v50 = v50 + 1;
                    end;

                    for i2 = 1, v50 do
                        local v51 = script.SpawnWing:Clone();
                        local v52 = v29:GetPivot() * CFrame.new(0, v29.Size.Y / 2, 0);
                        local Angles2 = CFrame.Angles;
                        local v53 = u5:NextInteger(-5, 5);
                        local v54 = math.rad(v53);
                        local v55 = 360 / v50 * i2 + u5:NextInteger(-15, 15);
                        local v56 = math.rad(v55);
                        local v57 = u5:NextInteger(-5, 5);
                        v51:PivotTo(v52 * Angles2(v54, v56, (math.rad(v57))) * CFrame.Angles(0.8726646259971648, 0, 0));
                        v51:ScaleTo(u5:NextNumber(0.6, 1.1) * u4 * u20);
                        v51.FruitSpawn.Parent = u1.FruitSpawnLocations;

                        for _, child in v51:GetChildren() do
                            child.Name = tonumber(child.Name) + tonumber(v29.Name);
                            child.Parent = u1;
                        end;

                        v51:Destroy();
                    end;
                end;

                if i == p25 then
                    local v58 = u5:NextNumber(3, 6);

                    for i2 = 1, v58 do
                        local v59 = u5:NextInteger(6, 8);

                        while u5:NextInteger(1, 6) == 1 and v59 < 30 do
                            v59 = v59 + 1;
                        end;

                        while u5:NextInteger(1, 1000) == 1 do
                            v59 = v59 * 2;
                        end;

                        local v60 = nil;
                        local v61 = u5:NextInteger(12, 19);
                        local v62 = u5:NextNumber(1, 2);
                        local v63 = u5:NextNumber(2.5, 3);
                        local v64 = Vector3.new(v62, v63, u5:NextNumber(4, 5.5)) * u4 * u20;
                        local v65 = v59 > 17 and 4 or (v59 > 12 and 7 or v61);

                        if u6 then
                            v59 = u5:NextInteger(22, 28);
                            v65 = math.ceil(400 / v59);
                        end;

                        for i3 = 1, v59 do
                            local v66 = script.Stud_Part:Clone();
                            v66.Color = Color3.fromRGB(203, 109, 31);
                            v66.Material = Enum.Material.Glacier;
                            v66.MaterialVariant = "2022 Weld";
                            local v67 = 1 - ((i3 - 1) / math.max(v59 - 1, 1)) ^ 1.15 * 0.7;
                            v66.Size = Vector3.new(v64.Z * v67, v64.Y, v64.X * v67);
                            local v68;

                            if i3 == 1 then
                                local v69 = v29.CFrame * CFrame.new(0, v29.Size.Y / 2, 0);
                                local Angles2 = CFrame.Angles;
                                local v70 = u5:NextInteger(-7, 7);
                                local v71 = math.rad(v70);
                                local v72 = 360 / v58 * i2 + u5:NextInteger(-7, 7);
                                local v73 = math.rad(v72);
                                local v74 = u5:NextInteger(-7, 7);
                                local v75 = v69 * Angles2(v71, v73, (math.rad(v74)));
                                local Angles3 = CFrame.Angles;
                                local v76 = u5:NextInteger(55, 60);
                                v68 = v75 * Angles3(math.rad(v76), 0, 0) * CFrame.new(0, v66.Size.Y / 2, 0);
                            else
                                local v77 = v60:GetPivot() * CFrame.new(0, v60.Size.Y / 2, 0);
                                local Angles2 = CFrame.Angles;
                                local v78 = v65 + u5:NextNumber(-2, 2);
                                local v79 = math.rad(v78);
                                local v80 = u5:NextNumber(-5, 5);
                                local v81 = math.rad(v80);
                                local v82 = u5:NextNumber(-3, 3);
                                v68 = v77 * Angles2(v79, v81, (math.rad(v82))) * CFrame.new(0, v66.Size.Y / 2, 0);
                            end;

                            if i3 == 1 then
                                v66.Size = v66.Size - Vector3.new(v66.Size.X / 1.5, 0, v66.Size.Z / 2);
                            end;

                            v66:PivotTo(v68);
                            v66.Name = i3 + p25;
                            v66.Parent = u1;
                            v60 = v66;
                        end;
                    end;
                end;

                Base2 = v29;
            end;

            Base2 = nil;
        end;

        local v83 = u5:NextInteger(4, 8);

        while u5:NextInteger(1, 8) == 1 do
            v83 = v83 + 1.5;
        end;

        if u5:NextInteger(1, 1000) == 1 then
            v83 = v83 * 2;
        end;

        if u7 then
            v83 = u5:NextInteger(15, 20);
        end;

        generateTrunk(Base, math.floor(v83), true);
        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u84) -- Line: 304, Name: BeginPlantGrowth
        local PrimaryPart = u84.PrimaryPart;
        local u85 = {};

        for _, v in u84:QueryDescendants("BasePart") do
            local v86 = tonumber(v.Name);

            if v86 then
                local v87 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v86
                };
                table.insert(u85, v87);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 322
            -- upvalues: u84 (copy), u85 (copy), PrimaryPart (copy)
            local v88 = u84:GetAttribute("Age") or 0;

            for _, v in u85 do
                local v89 = v[1];
                local v90 = v[2];
                local v91 = v[3];
                local v92 = math.min(v88 - v[4], 1);
                local v93 = math.clamp(v92, 0, 1);

                if v93 ~= v.lastProgress then
                    v.lastProgress = v93;

                    if v92 > 0 then
                        v89.Size = Vector3.new(v90.X, v90.Y * v92, v90.Z);
                        v89.CFrame = PrimaryPart.CFrame * v91 * CFrame.new(0, (v89.Size.Y - v90.Y) / 2, 0);
                        v89.Transparency = v89:GetAttribute("OG_Transparency") or 0;
                        v89.CanCollide = true;
                    else
                        v89.Transparency = 1;
                        v89.CanCollide = false;
                    end;
                end;
            end;
        end;

        u84:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};