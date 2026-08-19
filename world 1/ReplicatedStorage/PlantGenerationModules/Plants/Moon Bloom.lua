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

        local v14, v15 = Color3.fromRGB(51, 136, 5);
        local v16, v17, v18 = v14:ToHSV();
        local v19 = v15 or 0.05;
        local v20 = v16 + u5:NextNumber(-v19, v19);
        local v21 = math.clamp(v20, 0, 0.99);
        Color3.fromHSV(v21, v17, v18);

        local function CreatePart(p22, p23, p24) -- Line: 30
            -- upvalues: u1 (copy), MaterialService (copy)
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

        local v27 = u5:NextNumber(2.5, 2.9) * u4;
        local v28 = v27 * 0.85;
        local v29 = u5:NextInteger(6, 9);

        if u5:NextInteger(1, 12) == 1 then
            v29 = v29 + u5:NextInteger(4, 10);
        end;

        local v30 = Vector3.new(v27, v28, v27);
        local v31 = Vector3.new(v27 * 0.325, v28 * 1.15, v27 * 0.325);
        local CFrame2 = Base.CFrame;
        local u32 = {
            Start = Color3.fromRGB(142, 176, 204),
            End = Color3.fromRGB(99, 255, 246)
        };
        local v33 = u5:NextNumber(3.75, 6.75);

        if u5:NextInteger(1, 15) == 1 then
            v33 = u5:NextNumber(6.5, 10);
        end;

        local function GenerateDownwardsStem(p34, p35, p36) -- Line: 92
            -- upvalues: u5 (copy), u4 (ref), Base (copy), CreatePart (copy), u32 (copy)
            local v37 = p34 * CFrame.Angles(3.141592653589793, 0, 0);
            local v38 = u5:NextNumber(0.8, 1) * u4;
            local v39 = u5:NextNumber(2, 2.7) * u4;
            local Y = v37.Position.Y;
            local v40 = Vector3.new(v38, v39, v38);
            local v41 = 0;
            local v42 = {};

            while Base.Position.Y < Y do
                local v43 = CreatePart(nil, "2022 Stud Space");
                local v44 = u5:NextNumber(p35[1], p35[2]);
                local v45 = math.rad(v44);

                if u5:NextInteger(1, 3) == 1 then
                    v45 = v45 * 2;
                end;

                if v41 == 1 and u5:NextNumber(1, 2) == 1 then
                    v45 = -v45;
                end;

                v41 = v41 + 1;
                v43.Size = v40;
                v43.CFrame = v37 * CFrame.Angles(0, 0, v45) * CFrame.new(0, v43.Size.Y / 2.3, 0);
                v43.Color = u32.Start;
                v43.Name = v41 + 2;
                Y = v43.Position.Y;
                v37 = v43.CFrame * CFrame.new(0, v43.Size.Y / 2.3, 0);
                local v46 = v40.X * u5:NextNumber(1.15, 1.325);
                local v47 = v40.Y * u5:NextNumber(1.05, 1.25);
                v40 = Vector3.new(v46, v47, v46);
                table.insert(v42, v43);
                local _ = v41 % 3 == 1;
            end;

            for _, v in v42 do
                local v48 = tonumber(v.Name) / #v42;
                v.Color = u32.Start:Lerp(p36, v48);
            end;
        end;

        local v49 = u5:NextNumber(-180, 180);
        local identity = CFrame.identity;
        local v50 = 450 / (v29 - 2);
        local v51 = u5:NextNumber(-180, 180);
        local v52 = Vector3.new(1.3, 0, 1.3) * u4;
        local v53 = Vector3.new(0.2, 0, 0.2) * u4;

        for i = 1, v29 do
            local v54 = CreatePart(nil, "2022 Stud Space");
            local v55 = i / v29;
            local v56 = {};
            local v57 = u5:NextNumber(-v33, v33);
            v56.X = math.rad(v57);
            local v58 = u5:NextNumber(-1.5, 1.5);
            v56.Y = math.rad(v58);
            local v59 = u5:NextNumber(-v33, v33);
            v56.Z = math.rad(v59);
            v54.Size = v30:Lerp(v31, v55);
            v54.CFrame = CFrame2 * CFrame.Angles(v56.X, v56.Y, v56.Z) * CFrame.new(0, v54.Size.Y / 2.15, 0);
            v54.Color = u32.Start:Lerp(u32.End, v55);
            v54.Name = i;

            if i >= 3 then
                local v60;

                if i == 3 then
                    v60 = v54.CFrame;
                else
                    v60 = identity;
                end;

                local v61 = i == 3 and v54.Size.X * 1.15 or v54.Size.X * 1.5;
                local v62 = v51 + v50 * (i - 2);
                local CFrame3 = v54.CFrame;
                local new = CFrame.new;
                local v63 = math.rad(v62);
                local v64 = math.cos(v63) * v61;
                local v65 = math.rad(v62);
                identity = CFrame3 * new(v64, 0, math.sin(v65) * v61);
                local Magnitude = (v60.Position - identity.Position).Magnitude;
                local v66 = (i - 2) / v29;
                local v67 = CreatePart(nil, "2022 Stud Space");
                v67.Size = v52:Lerp(v53, v66) + Vector3.new(0, 1, 0) * Magnitude;
                v67.CFrame = CFrame.lookAt(v60.Position, identity.Position) * CFrame.new(0, 0, -Magnitude / 2) * CFrame.Angles(-1.5707963267948966, 0, 0);
                v67.Color = u32.Start:Lerp(u32.End, v66);
                v67.Name = i + 1;
            end;

            if i == 2 then
                local v68 = u5:NextInteger(3, 5);

                for i2 = 1, v68 do
                    local v69 = 360 / v68 * (i2 * u5:NextNumber(0.9, 1.1));
                    local v70 = v54.CFrame * CFrame.Angles(0, math.rad(v69), 0);
                    local Angles = CFrame.Angles;
                    local v71 = u5:NextNumber(80, 90);
                    GenerateDownwardsStem(v70 * Angles(0, 0, (math.rad(v71))), { 9, 18 }, v54.Color);
                    local v72 = script.Leaf:Clone();
                    v72.Parent = u1;
                    local v73 = Base.CFrame * CFrame.Angles(0, math.rad(v69 + 45), 0) * CFrame.new(0, 0, -v30.Z / 2);
                    local Angles2 = CFrame.Angles;
                    local v74 = u5:NextNumber(-35, -60);
                    v72:PivotTo(v73 * Angles2(math.rad(v74), 0, 0));
                    v72.Name = 1;
                end;
            end;

            if i > 2 and i < v29 then
                local v75 = script.BigLeaf:Clone();
                v75.Parent = u1;
                v75:ScaleTo(u4);
                local v76 = v54.CFrame * CFrame.Angles(0, math.rad(v49), 0);
                local Angles = CFrame.Angles;
                local v77 = u5:NextNumber(-110, -125);
                v75:PivotTo(v76 * Angles(math.rad(v77), 0, 0) * CFrame.new(0, v54.Size.Z / 2.25, 0));
                v49 = v49 + u5:NextNumber(45, 115);

                for _, child in v75:GetChildren() do
                    local v78 = tonumber(child.Name);

                    if v78 then
                        child.Name = v78 + i;
                        child.Parent = u1;
                    end;
                end;

                v75:Destroy();
            end;

            CFrame2 = v54.CFrame * CFrame.new(0, v54.Size.Y / 2.15, 0);
        end;

        local v79 = CreatePart();

        for _, child in pairs(v79:GetChildren()) do
            child:Destroy();
        end;

        v79.Size = Vector3.new(1, 1, 1);
        v79.CFrame = CFrame2;
        v79.Parent = FruitSpawnLocations;
        v79.Transparency = 1;
        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u80) -- Line: 241, Name: BeginPlantGrowth
        local PrimaryPart = u80.PrimaryPart;
        local u81 = {};

        for _, v in u80:QueryDescendants("BasePart") do
            local v82 = tonumber(v.Name);

            if v82 then
                local v83 = not v:GetAttribute("DontShow");
                local v84 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v84, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v83 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v85 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v82,
                    decals = v84
                };
                table.insert(u81, v85);
                v.CanCollide = false;

                if v83 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 276
            -- upvalues: u80 (copy), u81 (copy), PrimaryPart (copy)
            local v86 = u80:GetAttribute("Age") or 0;
            local v87 = u80:GetAttribute("MaxAge") or 1;
            local v88 = v86 / v87;

            for _, v in u81 do
                if not v.part:GetAttribute("DontShow") then
                    local v89 = math.clamp((v88 - v.partAge / v87) * v87, 0, 1);

                    if v89 ~= v.lastProgress then
                        v.lastProgress = v89;

                        if v89 > 0 then
                            local v90 = v.maxSize * v89;
                            v.part.Size = v90;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v90.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v89);
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

        u80:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};