-- Decompiled with Potassium's decompiler.

game:GetService("MaterialService");

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u1, p2, p3) -- Line: 9, Name: InitPlant
        local MaterialService = game:GetService("MaterialService");
        local u4 = p3 or 1;
        local u5 = Random.new(p2);
        local FruitSpawnLocations = u1.FruitSpawnLocations;
        local Base = u1.Base;

        local function GetRandomHSV(p6, p7) -- Line: 20
            -- upvalues: u5 (copy)
            local v8, v9, v10 = p6:ToHSV();
            local v11 = p7 or 0.05;
            local v12 = v8 + u5:NextNumber(-v11, v11);
            local v13 = math.clamp(v12, 0, 0.99);

            return Color3.fromHSV(v13, v9, v10), v13, v9, v10;
        end;

        local function CreatePart(p14, p15, p16) -- Line: 28
            -- upvalues: u1 (copy), MaterialService (copy)
            local Part = Instance.new("Part");
            local v17 = p14 or "Studs";
            Part.Parent = u1;
            Part.TopSurface = Enum.SurfaceType[v17];
            Part.BackSurface = Enum.SurfaceType[v17];
            Part.FrontSurface = Enum.SurfaceType[v17];
            Part.BottomSurface = Enum.SurfaceType[v17];
            Part.LeftSurface = Enum.SurfaceType[v17];
            Part.RightSurface = Enum.SurfaceType[v17];
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Transparency = 0;

            for _, child in pairs(script:GetChildren()) do
                if child:IsA("Texture") then
                    child:Clone().Parent = Part;
                end;
            end;

            if p16 then
                Part.Shape = Enum.PartType[p16];
            end;

            if p15 then
                Part.MaterialVariant = p15;
                local v18 = MaterialService:FindFirstChild(p15, true);

                if not v18 then
                    return Part;
                end;

                Part.Material = v18.BaseMaterial;
            end;

            return Part;
        end;

        local function GetColorWithRange(p19, p20) -- Line: 64
            local v21, v22, v23 = p19:ToHSV();

            return Color3.fromHSV(v21 + p20, v22, v23);
        end;

        local v24 = u5:NextNumber(2.5, 2.9) * u4;
        local v25 = v24 * 0.85;
        local v26 = u5:NextInteger(6, 9);

        if u5:NextInteger(1, 12) == 1 then
            v26 = v26 + u5:NextInteger(4, 10);
        end;

        local v27 = Vector3.new(v24, v25, v24);
        local v28 = Vector3.new(v24 * 0.325, v25 * 1.15, v24 * 0.325);
        local CFrame2 = Base.CFrame;
        local u29 = {
            Start = Color3.fromRGB(255, 112, 46),
            End = Color3.fromRGB(255, 112, 46)
        };
        local v30 = u5:NextNumber(3.75, 6.75);

        if u5:NextInteger(1, 15) == 1 then
            v30 = u5:NextNumber(6.5, 10);
        end;

        local function GenerateDownwardsStem(p31, p32, p33) -- Line: 96
            -- upvalues: u5 (copy), u4 (ref), Base (copy), CreatePart (copy), u29 (copy)
            local v34 = p31 * CFrame.Angles(3.141592653589793, 0, 0);
            local v35 = u5:NextNumber(0.8, 1) * u4;
            local v36 = u5:NextNumber(2, 2.7) * u4;
            local Y = v34.Position.Y;
            local v37 = Vector3.new(v35, v36, v35);
            local v38 = 0;
            local v39 = {};

            while Base.Position.Y < Y do
                local v40 = CreatePart(nil, "2022 Stud Wavy");
                local v41 = u5:NextNumber(p32[1], p32[2]);
                local v42 = math.rad(v41);

                if u5:NextInteger(1, 3) == 1 then
                    v42 = v42 * 2;
                end;

                if v38 == 1 and u5:NextNumber(1, 2) == 1 then
                    v42 = -v42;
                end;

                v38 = v38 + 1;
                v40.Size = v37;
                v40.CFrame = v34 * CFrame.Angles(0, 0, v42) * CFrame.new(0, v40.Size.Y / 2.3, 0);
                v40.Color = u29.Start;
                v40.Name = v38 + 2;
                Y = v40.Position.Y;
                v34 = v40.CFrame * CFrame.new(0, v40.Size.Y / 2.3, 0);
                local v43 = v37.X * u5:NextNumber(1.15, 1.325);
                local v44 = v37.Y * u5:NextNumber(1.05, 1.25);
                v37 = Vector3.new(v43, v44, v43);
                table.insert(v39, v40);
                local _ = v38 % 3 == 1;
            end;

            for _, v in v39 do
                local v45 = tonumber(v.Name) / #v39;
                v.Color = u29.Start:Lerp(p33, v45);
            end;
        end;

        local v46 = u5:NextNumber(-180, 180);
        local identity = CFrame.identity;
        local v47 = 450 / (v26 - 2);
        local v48 = u5:NextNumber(-180, 180);
        local v49 = Vector3.new(1.3, 0, 1.3) * u4;
        local v50 = Vector3.new(0.2, 0, 0.2) * u4;

        for i = 1, v26 do
            local v51 = CreatePart(nil, "2022 Stud Wavy");
            local v52 = i / v26;
            local v53 = {};
            local v54 = u5:NextNumber(-v30, v30);
            v53.X = math.rad(v54);
            local v55 = u5:NextNumber(-1.5, 1.5);
            v53.Y = math.rad(v55);
            local v56 = u5:NextNumber(-v30, v30);
            v53.Z = math.rad(v56);
            v51.Size = v27:Lerp(v28, v52);
            v51.CFrame = CFrame2 * CFrame.Angles(v53.X, v53.Y, v53.Z) * CFrame.new(0, v51.Size.Y / 2.15, 0);
            v51.Color = u29.Start:Lerp(u29.End, v52);
            v51.Name = i;

            if i >= 3 then
                local v57;

                if i == 3 then
                    v57 = v51.CFrame;
                else
                    v57 = identity;
                end;

                local v58 = i == 3 and v51.Size.X * 1.15 or v51.Size.X * 1.5;
                local v59 = v48 + v47 * (i - 2);
                local CFrame3 = v51.CFrame;
                local new = CFrame.new;
                local v60 = math.rad(v59);
                local v61 = math.cos(v60) * v58;
                local v62 = math.rad(v59);
                identity = CFrame3 * new(v61, 0, math.sin(v62) * v58);
                local Magnitude = (v57.Position - identity.Position).Magnitude;
                local v63 = (i - 2) / v26;
                local v64 = CreatePart(nil, "2022 Stud Wavy");
                v64.Size = v49:Lerp(v50, v63) + Vector3.new(0, 1, 0) * Magnitude;
                v64.CFrame = CFrame.lookAt(v57.Position, identity.Position) * CFrame.new(0, 0, -Magnitude / 2) * CFrame.Angles(-1.5707963267948966, 0, 0);
                v64.Color = u29.Start:Lerp(u29.End, v63);
                v64.Name = i + 1;
            end;

            if i == 2 then
                local v65 = u5:NextInteger(3, 5);

                for i2 = 1, v65 do
                    local v66 = 360 / v65 * (i2 * u5:NextNumber(0.9, 1.1));
                    local v67 = v51.CFrame * CFrame.Angles(0, math.rad(v66), 0);
                    local Angles = CFrame.Angles;
                    local v68 = u5:NextNumber(80, 90);
                    GenerateDownwardsStem(v67 * Angles(0, 0, (math.rad(v68))), { 9, 18 }, v51.Color);
                end;
            end;

            if i > 2 and i < v26 then
                local v69 = script.BigLeaf:Clone();
                v69.Parent = u1;
                v69:ScaleTo(u4);
                local v70 = v51.CFrame * CFrame.Angles(0, math.rad(v46), 0);
                local Angles = CFrame.Angles;
                local v71 = u5:NextNumber(-110, -125);
                v69:PivotTo(v70 * Angles(math.rad(v71), 0, 0) * CFrame.new(0, v51.Size.Z / 2.25, 0));
                v46 = v46 + u5:NextNumber(45, 115);

                for _, child in v69:GetChildren() do
                    local v72 = tonumber(child.Name);

                    if v72 then
                        child.Name = v72 + i;
                        child.Parent = u1;
                    end;
                end;

                v69:Destroy();
            end;

            CFrame2 = v51.CFrame * CFrame.new(0, v51.Size.Y / 2.15, 0);
        end;

        local v73 = CreatePart();

        for _, child in pairs(v73:GetChildren()) do
            child:Destroy();
        end;

        v73.Size = Vector3.new(1, 1, 1);
        v73.CFrame = CFrame2;
        v73.Parent = FruitSpawnLocations;
        v73.Transparency = 1;
        local v74 = u5:NextNumber(-0.025, 0.025);

        for _, child in u1:GetChildren() do
            if tonumber(child.Name) then
                local v75, v76, v77 = child.Color:ToHSV();
                child.Color = Color3.fromHSV(v75 + v74, v76, v77);
            end;
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u78) -- Line: 248, Name: BeginPlantGrowth
        local PrimaryPart = u78.PrimaryPart;
        local u79 = {};

        for _, v in u78:QueryDescendants("BasePart") do
            local v80 = tonumber(v.Name);

            if v80 then
                local v81 = not v:GetAttribute("DontShow");
                local v82 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v82, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v81 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v83 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v80,
                    decals = v82
                };
                table.insert(u79, v83);
                v.CanCollide = false;

                if v81 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 283
            -- upvalues: u78 (copy), u79 (copy), PrimaryPart (copy)
            local v84 = u78:GetAttribute("Age") or 0;
            local v85 = u78:GetAttribute("MaxAge") or 1;
            local v86 = v84 / v85;

            for _, v in u79 do
                if not v.part:GetAttribute("DontShow") then
                    local v87 = math.clamp((v86 - v.partAge / v85) * v85, 0, 1);

                    if v87 ~= v.lastProgress then
                        v.lastProgress = v87;

                        if v87 > 0 then
                            local v88 = v.maxSize * v87;
                            v.part.Size = v88;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v88.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v87);
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

        u78:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};