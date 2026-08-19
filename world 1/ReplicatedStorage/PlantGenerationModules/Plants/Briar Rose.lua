-- Decompiled with Potassium's decompiler.

local MaterialService = game:GetService("MaterialService");
game:GetService("TweenService");

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u1, p2, p3) -- Line: 9, Name: InitPlant
        -- upvalues: MaterialService (copy)
        local v4 = p3 or 1;
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

        local v27 = {};
        local v28, v29 = Color3.fromRGB(24, 13, 36);
        local v30, v31, v32 = v28:ToHSV();
        local v33 = v29 or 0.05;
        local v34 = v30 + u5:NextNumber(-v33, v33);
        local v35 = math.clamp(v34, 0, 0.99);
        v27.Stem = Color3.fromHSV(v35, v31, v32);
        local v36, v37 = Color3.fromRGB(133, 25, 241);
        local v38, v39, v40 = v36:ToHSV();
        local v41 = v37 or 0.05;
        local v42 = v38 + u5:NextNumber(-v41, v41);
        local v43 = math.clamp(v42, 0, 0.99);
        v27.Spike = Color3.fromHSV(v43, v39, v40);
        local v44, v45 = Color3.fromRGB(139, 26, 204);
        local v46, v47, v48 = v44:ToHSV();
        local v49 = v45 or 0.05;
        local v50 = v46 + u5:NextNumber(-v49, v49);
        local v51 = math.clamp(v50, 0, 0.99);
        v27.Leaf = Color3.fromHSV(v51, v47, v48);
        local v52 = u5:NextNumber(2.2, 2.6);
        local v53 = u5:NextNumber(5.3, 6);
        local v54 = Vector3.new(v52, v53, v52) * (v4 * 0.1 + 0.9);
        local v55 = Vector3.new(v52 * 0.5, v53 * 0.6, v52 * 0.5) * (v4 * 0.1 + 0.9);
        local v56 = u5:NextInteger(5, 6) * (v4 * 0.5 + 0.5);
        local v57 = math.clamp(v56, 5, 30);
        local v58 = Base.CFrame * CFrame.Angles(0, 0, 0);

        while u5:NextInteger(1, 200) == 1 do
            v57 = v57 * 2;
        end;

        local v59 = u5:NextInteger(-60, -25);
        local v60 = u5:NextInteger(3, 5);
        local v61 = 0;

        if u5:NextInteger(1, 25) == 1 then
            local v62 = Color3.fromRGB(2, 42, 43);
            v27.Stem = v62;
            v27.Spike = Color3.fromRGB(0, 141, 255);
            v27.Leaf = v62;
        end;

        if u5:NextInteger(1, 100) == 1 then
            local v63 = Color3.fromRGB(97, 23, 8);
            v27.Stem = v63;
            v27.Spike = Color3.fromRGB(235, 38, 0);
            v27.Leaf = v63;
        end;

        script.Leaf["2"].Color = v27.Leaf;
        script.Spike.Color = v27.Spike;

        while u5:NextInteger(1, 3) == 1 and v57 < 40 do
            v57 = v57 + u5:NextInteger(1, 2);
        end;

        local v64 = u5:NextInteger(3, 4);
        local v65 = v57 > 6 and 3 or 2;
        local v66 = 0;

        for i = 1, v64 do
            local v67 = script.Spike:Clone();
            v67.Parent = u1;
            v67.Size = v67.Size * (u5:NextNumber(0.6, 1.2) * v4);
            v67.Size = v67.Size + Vector3.new(0, 1, 0) * u5:NextNumber(-1, 0.35);
            local v68 = Base.CFrame * CFrame.Angles(0, math.rad(360 / v64 * i), 0) * CFrame.new(0, -0.25, v52 / 2.35);
            local Angles = CFrame.Angles;
            local v69 = u5:NextNumber(20, 40);
            local v70 = math.rad(v69);
            local v71 = u5:NextNumber(-10, 10);
            v67:PivotTo(v68 * Angles(v70, 0, (math.rad(v71))) * CFrame.new(0, v67.Size.Y / 2, 0));
            v67.Name = 1;
        end;

        for i = 1, v57 do
            local v72 = CreatePart(nil, "2022 Stud DiagonalLines");
            v61 = v61 + 1;

            if v60 < v61 then
                v59 = -v59;
                v61 = 0;
            end;

            local v73 = {};
            local v74 = u5:NextNumber(-10, 10);
            v73.X = math.rad(v74);
            local v75 = u5:NextNumber(-2, 2);
            v73.Y = math.rad(v75);
            v73.Z = math.rad(v59 / v60);
            v72.Size = v54:Lerp(v55, i / v57);
            v72.CFrame = v58 * CFrame.Angles(v73.X, v73.Y, v73.Z) * CFrame.new(0, v72.Size.Y / 2.5, 0);
            v72.Color = v27.Stem;
            v72.Name = i;

            if u5:NextInteger(1, 6) == 1 then
                local v76 = script.Leaf:Clone();
                v76.Parent = u1;
                v76:ScaleTo(0.8 * v4);
                local CFrame2 = v72.CFrame;
                local Angles = CFrame.Angles;
                local v77 = u5:NextInteger(1, 2) == 1 and -u5:NextNumber(160, 200) or u5:NextNumber(160, 200);
                v76:PivotTo(CFrame2 * Angles(0, math.rad(v77), 0) * CFrame.Angles(1.5707963267948966, 0, 0) * CFrame.new(0, v72.Size.Z / 2, 0));

                for _, child in v76:GetChildren() do
                    local v78 = tonumber(child.Name);

                    if v78 then
                        child.Name = v78 + i;
                        child.Parent = u1;
                    end;
                end;

                v76:Destroy();
            end;

            if u5:NextInteger(1, 4) ~= 1 then
                for i2 = 1, 4 do
                    if u5:NextInteger(1, 2) ~= 1 then
                        local v79 = script.Spike:Clone();
                        v79.Parent = u1;
                        v79.MaterialVariant = "2022 Stud DiagonalLines";
                        v79.Size = v79.Size + Vector3.new(0, 1, 0) * u5:NextNumber(-1, -0.25);
                        v79.Size = v79.Size * (u5:NextNumber(0.3, 0.5) * v4);
                        v79:PivotTo(v72.CFrame * CFrame.new(0, u5:NextNumber(-v72.Size.Y, v72.Size.Y) * 0.35, 0) * CFrame.Angles(0, math.rad(i2 * 90), 1.5707963267948966) * CFrame.new(0, v72.Size.Z / 2 + v79.Size.Y / 2, 0));
                        v79.Name = i + 1;
                    end;
                end;
            end;

            if i % v65 == 0 and i < v57 - 2 then
                v66 = v66 + 1;

                for i2 = 1, 2 do
                    local v80 = u5:NextInteger(4, 5);

                    if u5:NextInteger(1, 20) == 1 then
                        v80 = u5:NextInteger(6, 7);
                    end;

                    local v81 = v72.Size * 0.85;
                    local v82 = v55 * 0.8;
                    local v83 = 90;
                    local v84;

                    if i2 == 2 then
                        v84 = v66 % 2 ~= 0 and 0 or -v83;
                    else
                        v84 = v66 % 2 ~= 0 and 180 or v83;
                    end;

                    local v85 = v72.CFrame * CFrame.new(0, u5:NextNumber(-v72.Size.Y, v72.Size.Y) * 0.35, 0) * CFrame.Angles(0, math.rad(v84), 1.0471975511965976) * CFrame.new(0, v72.Size.Z * 0.25, 0);

                    for i3 = 1, v80 do
                        local v86 = CreatePart(nil, "2022 Stud DiagonalLines");
                        local v87 = {};
                        local v88 = u5:NextNumber(-10, 10);
                        v87.X = math.rad(v88);
                        local v89 = u5:NextNumber(-2, 2);
                        v87.Y = math.rad(v89);
                        local v90 = u5:NextNumber(-15, 5);
                        v87.Z = math.rad(v90);
                        v86.Size = v81:Lerp(v82, i3 / v80);
                        v86.CFrame = v85 * CFrame.Angles(v87.X, v87.Y, v87.Z) * CFrame.new(0, v86.Size.Y / 2.5, 0);
                        v86.Name = i3 + i;
                        v86.Color = v27.Stem;

                        if u5:NextInteger(1, 4) == 1 and i3 > 2 then
                            local v91 = script.Leaf:Clone();
                            v91.Parent = u1;
                            v91:ScaleTo(0.65 * v4);
                            local CFrame2 = v86.CFrame;
                            local Angles = CFrame.Angles;
                            local v92 = u5:NextInteger(1, 2) == 1 and -u5:NextNumber(70, 100) or u5:NextNumber(70, 100);
                            v91:PivotTo(CFrame2 * Angles(0, math.rad(v92), 0) * CFrame.Angles(1.5707963267948966, 0, 0) * CFrame.new(0, v86.Size.Z / 2, 0));

                            for _, child in v91:GetChildren() do
                                local v93 = tonumber(child.Name);

                                if v93 then
                                    child.Name = v93 + i3 + i;
                                    child.Parent = u1;
                                end;
                            end;

                            v91:Destroy();
                        end;

                        if u5:NextInteger(1, 4) ~= 1 then
                            for i4 = 1, 4 do
                                if u5:NextInteger(1, 2) ~= 1 then
                                    local v94 = script.Spike:Clone();
                                    v94.Parent = u1;
                                    v94.MaterialVariant = "2022 Stud DiagonalLines";
                                    v94.Size = v94.Size + Vector3.new(0, 1, 0) * u5:NextNumber(-1, -0.25);
                                    v94.Size = v94.Size * (u5:NextNumber(0.3, 0.5) * v4);
                                    v94:PivotTo(v86.CFrame * CFrame.new(0, u5:NextNumber(-v86.Size.Y, v86.Size.Y) * 0.35, 0) * CFrame.Angles(0, math.rad(i4 * 90), 1.5707963267948966) * CFrame.new(0, v86.Size.Z / 2 + v94.Size.Y / 2, 0));
                                    v94.Name = i + i3 + 1;
                                end;
                            end;
                        end;

                        v85 = v86.CFrame * CFrame.new(0, v86.Size.Y / 2.5, 0);
                    end;

                    local v95 = CreatePart();
                    v95.Size = Vector3.new(1, 1, 1);
                    v95.CFrame = v85;
                    v95.Parent = FruitSpawnLocations;
                    v95.Transparency = 1;
                end;
            end;

            v58 = v72.CFrame * CFrame.new(0, v72.Size.Y / 2.5, 0);
        end;

        local v96 = CreatePart();
        v96.Size = Vector3.new(1, 1, 1);
        v96.CFrame = v58;
        v96.Parent = FruitSpawnLocations;
        v96.Transparency = 1;
        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u97) -- Line: 290, Name: BeginPlantGrowth
        local PrimaryPart = u97.PrimaryPart;
        local u98 = {};

        for _, v in u97:QueryDescendants("BasePart") do
            local v99 = tonumber(v.Name);

            if v99 then
                local v100 = not v:GetAttribute("DontShow");
                local v101 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v101, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v100 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v102 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v99,
                    decals = v101
                };
                table.insert(u98, v102);
                v.CanCollide = false;

                if v100 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 325
            -- upvalues: u97 (copy), u98 (copy), PrimaryPart (copy)
            local v103 = u97:GetAttribute("Age") or 0;
            local v104 = u97:GetAttribute("MaxAge") or 1;
            local v105 = v103 / v104;

            for _, v in u98 do
                if not v.part:GetAttribute("DontShow") then
                    local v106 = math.clamp((v105 - v.partAge / v104) * v104, 0, 1);

                    if v106 ~= v.lastProgress then
                        v.lastProgress = v106;

                        if v106 > 0 then
                            local v107 = v.maxSize * v106;
                            v.part.Size = v107;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v107.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v106);
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

        u97:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};