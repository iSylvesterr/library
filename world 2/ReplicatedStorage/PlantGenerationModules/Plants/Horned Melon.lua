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

        local u17 = u1:WaitForChild("2");
        local v18, v19, v20 = Color3.fromRGB(101, 182, 79):ToHSV();
        local v21 = 0.03 or 0.05;
        local v22 = v18 + u4:NextNumber(-v21, v21);
        u17.Color = Color3.fromHSV(v22, v19, v20);
        local v23 = u4:NextNumber(1, 3);
        u17.Position = u17.Position + Vector3.new(0, v23 / 2, 0);
        u17.Size = u17.Size + Vector3.new(0, v23, 0);
        local _ = Base.CFrame;
        local v24 = u4:NextInteger(2, 4);
        local u25 = nil;
        local u26 = 3;

        while u4:NextInteger(1, 4) == 1 and v24 < 20 do
            v24 = v24 + 1;
        end;

        local function generateTrunk(p27, p28, p29) -- Line: 82
            -- upvalues: u4 (copy), u25 (ref), u17 (copy), u26 (ref), u1 (copy), CreatePart (copy)
            local v30 = p27:GetPivot() * CFrame.new(0, p27.Size.Y / 2, 0);

            for i = 1, p28 do
                local v31 = script.Stud_Part:Clone();
                local v32 = 1.5 + u4:NextNumber(-0.8, 1.3);
                local Angles = CFrame.Angles;
                local v33 = u4:NextNumber(-25, 25);
                local v34 = math.rad(v33);
                local v35 = u4:NextNumber(-15, 15);
                local v36 = math.rad(v35);
                local v37 = u4:NextNumber(-25, 10);
                local v38 = Angles(v34, v36, (math.rad(v37)));
                local new = CFrame.new;
                local Position = v30.Position;
                local v39 = u4:NextNumber(-15, 15);
                local v40 = u4:NextNumber(-15, 15);
                new(Position + Vector3.new(v39, v40, u4:NextNumber(-15, 15)));
                local v41, v42, v43 = Color3.fromRGB(101, 182, 79):ToHSV();
                local v44 = 0.03 or 0.05;
                local v45 = v41 + u4:NextNumber(-v44, v44);
                v31.Color = Color3.fromHSV(v45, v42, v43);
                v31.Size = Vector3.new(0.5299999713897705, v32, 0.5299999713897705);
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
                        local v53 = u4:NextNumber(-30, -10);
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

                if u4:NextInteger(1, 6) == 1 then
                    local v62 = script.Flower:Clone();
                    local v63 = v31:GetPivot();
                    local Angles2 = CFrame.Angles;
                    local v64 = u4:NextInteger(0, 360);
                    v62:PivotTo(v63 * Angles2(0, math.rad(v64), 1.5707963267948966));

                    for _, child in v62:GetChildren() do
                        child.Name = tonumber(child.Name) + u26;
                        child.Parent = u1;
                    end;
                end;

                if u4:NextInteger(1, 15) == 1 then
                    local v65 = script.Leaf:Clone();
                    local v66 = v31:GetPivot();
                    local Angles2 = CFrame.Angles;
                    local v67 = u4:NextInteger(0, 360);
                    local v68 = math.rad(v67);
                    local v69 = u4:NextInteger(60, 120);
                    v65:PivotTo(v66 * Angles2(0, v68, (math.rad(v69))));

                    for _, child in v65:GetChildren() do
                        child.Name = tonumber(child.Name) + u26;
                        child.Parent = u1;
                    end;
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

            local v75 = CreatePart();
            v75.Size = Vector3.new(1, 1, 1);
            v75.CFrame = u25:GetPivot() * CFrame.new(0, u25.Size.Y / 2, 0);
            v75.Orientation = Vector3.new(0, 0, 180);
            v75.Parent = u1.FruitSpawnLocations;
            u25 = nil;
        end;

        for i = 1, v24 do
            local v76 = u4:NextInteger(3, 6);

            while u4:NextInteger(1, 8) == 1 and v76 < 13 do
                v76 = v76 + 1;
            end;

            generateTrunk(u17, math.floor(v76), 360 / v24 * i + u4:NextInteger(-15, 15));
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u77) -- Line: 200, Name: BeginPlantGrowth
        local PrimaryPart = u77.PrimaryPart;
        local u78 = {};

        for _, v in u77:QueryDescendants("BasePart") do
            local v79 = tonumber(v.Name);

            if v79 then
                local v80 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v79
                };
                table.insert(u78, v80);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 218
            -- upvalues: u77 (copy), u78 (copy), PrimaryPart (copy)
            local v81 = u77:GetAttribute("Age") or 0;

            for _, v in u78 do
                local v82 = v[1];
                local v83 = v[2];
                local v84 = v[3];
                local v85 = math.min(v81 - v[4], 1);
                local v86 = math.clamp(v85, 0, 1);

                if v86 ~= v.lastProgress then
                    v.lastProgress = v86;

                    if v85 > 0 then
                        v82.Size = Vector3.new(v83.X, v83.Y * v85, v83.Z);
                        v82.CFrame = PrimaryPart.CFrame * v84 * CFrame.new(0, (v82.Size.Y - v83.Y) / 2, 0);
                        v82.Transparency = v82:GetAttribute("OG_Transparency") or 0;
                        v82.CanCollide = true;
                    else
                        v82.Transparency = 1;
                        v82.CanCollide = false;
                    end;
                end;
            end;
        end;

        u77:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};