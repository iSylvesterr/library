-- Decompiled with Potassium's decompiler.

game:GetService("MaterialService");

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u1, p2, p3) -- Line: 9, Name: InitPlant
        local MaterialService = game:GetService("MaterialService");
        local v4 = (p3 or 1) * 0.25 + 0.75;
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

        local function GetColorWithRange(p14, p15) -- Line: 67
            local v16, v17, v18 = p14:ToHSV();

            return Color3.fromHSV(v16 + p15, v17, v18);
        end;

        local function AddGradient(p19) -- Line: 73
            for _, child in script.Gradient:GetChildren() do
                child:Clone().Parent = p19;
            end;
        end;

        local v20 = Color3.fromRGB(245, 192, 124);
        local v21 = u5:NextNumber(3.4, 4) * v4;
        local v22 = u5:NextNumber(5, 6) * v4;
        local v23 = u5:NextInteger(5, 8) * v4;
        local v24 = math.clamp(v23, 4, 32);
        local v25 = math.floor(v24);

        local function CreatePart(p26, p27, p28) -- Line: 31
            -- upvalues: u1 (copy), MaterialService (copy)
            local Part = Instance.new("Part");
            local v29 = p26 or "Studs";
            Part.Parent = u1;
            Part.TopSurface = Enum.SurfaceType[v29];
            Part.BackSurface = Enum.SurfaceType[v29];
            Part.FrontSurface = Enum.SurfaceType[v29];
            Part.BottomSurface = Enum.SurfaceType[v29];
            Part.LeftSurface = Enum.SurfaceType[v29];
            Part.RightSurface = Enum.SurfaceType[v29];
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Transparency = 0;

            for _, child in pairs(script:GetChildren()) do
                if child:IsA("Texture") then
                    child:Clone().Parent = Part;
                end;
            end;

            if p28 then
                Part.Shape = Enum.PartType[p28];
            end;

            if p27 then
                Part.MaterialVariant = p27;
                local v30 = MaterialService:FindFirstChild(p27, true);

                if not v30 then
                    return Part;
                end;

                Part.Material = v30.BaseMaterial;
            end;

            return Part;
        end;

        while u5:NextInteger(1, 100) == 1 do
            v25 = v25 * 2;
        end;

        local v31 = Vector3.new(v21, v22, v21);
        local v32 = Vector3.new(v21 * 0.55, v22 * 0.875, v21 * 0.55);
        local v33 = u5:NextInteger(1, 15) == 1;
        local CFrame2 = Base.CFrame;
        local v34 = u5:NextNumber(300, 420) * (v25 * 0.125) / v25;
        local v35 = {};
        local CFrame3 = Base.CFrame;
        local new = CFrame.new;
        local v36 = math.rad(v34 + 180);
        local v37 = math.cos(v36) * (v21 / 2);
        local v38 = math.rad(v34 + 180);
        v35[1] = CFrame3 * new(v37, 0, math.sin(v38) * (v21 / 2));
        local CFrame4 = Base.CFrame;
        local new2 = CFrame.new;
        local v39 = math.rad(v34);
        local v40 = math.cos(v39) * v21;
        local v41 = math.rad(v34);
        v35[2] = CFrame4 * new2(v40, 0, math.sin(v41) * v21);
        local CFrame5 = Base.CFrame;
        local v42 = u5:NextInteger(4, 6);
        local v43 = {};

        for i = 1, v42 do
            local v44 = script.BottomSpike:Clone();
            v44.Parent = u1;
            local v45 = 360 / v42 * (i * u5:NextNumber(0.9, 1.1));
            v44.Size = v44.Size * (u5:NextNumber(0.8, 1.2) * v4);
            local CFrame6 = Base.CFrame;
            local Angles = CFrame.Angles;
            local v46 = math.rad(v45);
            local v47 = u5:NextNumber(45, 65);
            local v48 = CFrame6 * Angles(0, v46, (math.rad(v47)));
            local Angles2 = CFrame.Angles;
            local v49 = u5:NextNumber(-45, 45);
            v44.CFrame = v48 * Angles2(0, math.rad(v49), 0) * CFrame.new(0, v44.Size.Y / 2, 0);
            v44.Name = 1;
        end;

        for i = 1, v25 do
            local v50 = CreatePart(nil, "GoldStudTexture");
            local v51 = v33 and u5:NextNumber(-15, 15) or u5:NextNumber(-5, 5);
            local v52 = v33 and u5:NextNumber(-15, 15) or u5:NextNumber(-5, 5);
            v50.Size = v31:Lerp(v32, i / v25);
            v50.CFrame = CFrame2 * CFrame.Angles(math.rad(v51), 0, (math.rad(v52))) * CFrame.new(0, v50.Size.Y / 2.2, 0);
            v50.Color = v20;
            v50.Name = i;

            if i % 3 == 1 then
                script.ParticleEmitter:Clone().Parent = v50;
            end;

            local CFrame6 = v50.CFrame;
            local new3 = CFrame.new;
            local v53 = u5:NextNumber(-v50.Size.X, v50.Size.X) * 0.35;
            local v54 = CFrame6 * new3((Vector3.new(v53, v50.Size.Y / 2, 0)));
            local Magnitude = (v54.Position - CFrame5.Position).Magnitude;
            local Unit = (v54.Position - CFrame5.Position).Unit;
            local Unit2 = v50.CFrame.YVector:Cross(Unit).Unit;
            local Unit3 = Unit:Cross(Unit2).Unit;
            local v55 = CreatePart();
            v55.Material = Enum.Material.Neon;
            v55.Size = Vector3.new(v50.Size.Z + 0.35, 0.5, Magnitude + 0.2);
            v55.Color = Color3.fromRGB(213, 173, 107);
            v55.CFrame = CFrame.fromMatrix((CFrame5.Position + v54.Position) / 2, Unit2, Unit3);
            v55.Name = i + 1;

            if i < v25 - 1 then
                table.insert(v43, v50);
                local v56 = v34 * i;

                for i2 = 1, 2 do
                    local v57;

                    if i2 == 1 then
                        v57 = v56 + 180 or v56;
                    else
                        v57 = v56;
                    end;

                    local v58 = v35[i2];
                    local CFrame7 = v50.CFrame;
                    local new4 = CFrame.new;
                    local v59 = math.rad(v57);
                    local v60 = math.cos(v59) * v21;
                    local v61 = math.rad(v57);
                    local v62 = CFrame7 * new4(v60, 0, math.sin(v61) * v21);
                    local v63 = (v58.Position - v62.Position).Magnitude * 1.1;
                    local v64 = CreatePart(nil, "GoldStudTexture");
                    v64.Size = Vector3.new(v21 * 0.6, v21 * 0.6, v63);
                    v64.CFrame = CFrame.lookAt(v58.Position, v62.Position) * CFrame.new(0, 0, -v63 / 2);
                    v64.Color = v20;
                    v64.Name = i;
                    v64:SetAttribute("GrowZAxis", true);

                    if i % 3 == 1 then
                        for i3 = 1, 2 do
                            local v65 = script.StemStar:Clone();
                            v65.Parent = u1;
                            v65.Size = Vector3.new(v64.Size.X * 0.775, v64.Size.X * 0.8, v64.Size.Y + 0.25);
                            v65.CFrame = v64.CFrame * CFrame.Angles(-1.5707963267948966, math.rad(i3 * 90), 0);
                            v65.Name = i + 1;
                        end;
                    end;

                    for _, child in script.Gradient:GetChildren() do
                        child:Clone().Parent = v64;
                    end;

                    if i % 5 == 0 and v25 - i > 7 or i == v25 - 2 then
                        local v66 = CreatePart(nil, "GoldStudTexture");
                        v66.Size = v64.Size;
                        v66.CFrame = v64.CFrame * CFrame.new(0, 0, -v64.Size.Z / 2.1) * CFrame.Angles(-0.3490658503988659, -0.6981317007977318, 0) * CFrame.new(0, 0, -v66.Size.Z / 2.1);
                        v66.Name = i + 1;
                        v66.Color = v20;

                        for _, child in script.Gradient:GetChildren() do
                            child:Clone().Parent = v66;
                        end;

                        local v67 = u5:NextNumber(95, 120);
                        local v68 = -v67;

                        for _ = 1, 3 do
                            local v69 = u5:NextInteger(2, 3);
                            local v70 = v66.CFrame * CFrame.Angles(-1.5707963267948966, 0, 0) * CFrame.new(0, v66.Size.Z / 2, 0) * CFrame.Angles(0, math.rad(90 + v68), (math.rad(i % 5 == 0 and v25 - i > 7 and -80 or -50)));
                            local v71 = Vector3.new(v66.Size.X * 0.65, v66.Size.Z * 0.6, v66.Size.X * 0.65);
                            local v72 = Vector3.new(v66.Size.X * 0.5, v66.Size.Z * 0.5, v66.Size.X * 0.5);
                            v68 = v68 + v67;

                            for i3 = 1, v69 do
                                local v73 = CreatePart(nil, "GoldStudTexture");
                                v73.Size = v71:Lerp(v72, i3 / v69);
                                local Angles = CFrame.Angles;
                                local v74 = u5:NextNumber(-8, 8);
                                local v75 = math.rad(v74);
                                local v76 = u5:NextNumber(-15, 20);
                                v73.CFrame = v70 * Angles(v75, 0, (math.rad(v76))) * CFrame.new(0, v73.Size.Y / 2, 0);
                                v73.Color = v20;
                                v73.Name = i + 1 + i3;
                                v70 = v73.CFrame * CFrame.new(0, v73.Size.Y / 2, 0);

                                for _, child in script.Gradient:GetChildren() do
                                    child:Clone().Parent = v73;
                                end;
                            end;

                            local v77 = CreatePart();
                            v77.Size = Vector3.new(1, 1, 1);
                            v77.CFrame = v70;
                            v77.Transparency = 1;
                            v77.Parent = FruitSpawnLocations;
                        end;
                    end;

                    v35[i2] = v62;

                    if i == 2 then
                        local v78 = Vector3.new(v21 * 0.55, v63, v21 * 0.55);
                        local v79 = v64.CFrame * CFrame.Angles(-0.4363323129985824, 0, 1.5707963267948966) * CFrame.new(0, 0, u5:NextNumber(-v50.Size.Z, v50.Size.Z) * 0.3);

                        for i3 = 1, 2 do
                            local v80 = CreatePart(nil, "GoldStudTexture");
                            v80.Size = v78;
                            local Angles = CFrame.Angles;
                            local v81 = u5:NextNumber(25, 35);
                            v80.CFrame = v79 * Angles(0, 0, (math.rad(v81))) * CFrame.new(0, v80.Size.Y / 2.25, 0);
                            v80.Color = v20;
                            v80.Name = i3 + 2;
                            v79 = v80.CFrame * CFrame.new(0, v80.Size.Y / 2.25, 0);
                            local CFrame8 = v80.CFrame;
                            local Angles2 = CFrame.Angles;
                            local v82 = u5:NextNumber(-25, 25);
                            v80.CFrame = CFrame8 * Angles2(0, math.rad(v82), 0);

                            for _, child in script.Gradient:GetChildren() do
                                child:Clone().Parent = v80;
                            end;

                            v78 = v78 * 0.85;
                        end;
                    end;
                end;
            end;

            CFrame2 = v50.CFrame * CFrame.new(0, v50.Size.Y / 2.2, 0);

            if i == v25 then
                local v83 = script.TopStar:Clone();
                v83.Parent = u1;
                v83:ScaleTo(v83:GetScale() * v4);
                v83:PivotTo(CFrame2);

                for _, child in v83:GetChildren() do
                    child.Parent = u1;
                    child.Name = v25 + 1;

                    for _, descendant in child:GetDescendants() do
                        if descendant:IsA("ParticleEmitter") then
                            descendant.Enabled = false;
                        end;
                    end;
                end;

                v83:Destroy();
                local v84 = script.Aura:Clone();

                for _, child in v84:GetChildren() do
                    child.CFrame = CFrame2:ToWorldSpace(child.CFrame);
                end;

                v84.Parent = u1;
                game:GetService("CollectionService"):AddTag(u1, "StarFruitAura");
                local v85 = CreatePart();
                v85.Size = Vector3.new(1, 1, 1);
                v85.CFrame = CFrame2;
                v85.Transparency = 1;
                v85.Parent = FruitSpawnLocations;
                CFrame5 = v54;
            else
                CFrame5 = v54;
            end;
        end;

        if u5:NextInteger(1, 25) == 1 then
            for _, descendant in u1:GetDescendants() do
                if descendant:IsA("BasePart") or descendant:IsA("MeshPart") then
                    descendant.Color = Color3.fromRGB(235, 64, 160);
                end;
            end;
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u86) -- Line: 307, Name: BeginPlantGrowth
        local PrimaryPart = u86.PrimaryPart;
        local u87 = {};

        for _, v in u86:QueryDescendants("BasePart") do
            local v88 = tonumber(v.Name);

            if v88 then
                local v89 = not v:GetAttribute("DontShow");
                local v90 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v90, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v89 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v91 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v88,
                    decals = v90
                };
                table.insert(u87, v91);
                v.CanCollide = false;

                if v89 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 342
            -- upvalues: u86 (copy), u87 (copy), PrimaryPart (copy)
            local v92 = u86:GetAttribute("Age") or 0;
            local v93 = u86:GetAttribute("MaxAge") or 1;
            local v94 = v92 / v93;

            for _, v in u87 do
                if not v.part:GetAttribute("DontShow") then
                    if v94 >= 1 then
                        for _, descendant in v.part:GetDescendants() do
                            if descendant:IsA("ParticleEmitter") then
                                descendant.Enabled = true;
                            end;
                        end;
                    end;

                    local v95 = math.clamp((v94 - v.partAge / v93) * v93, 0, 1);

                    if v95 ~= v.lastProgress then
                        v.lastProgress = v95;

                        if v95 > 0 then
                            local v96 = v.maxSize * v95;
                            v.part.Size = v96;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v96.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            if v.part:GetAttribute("GrowZAxis") then
                                v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, 0, (v.maxSize.Z - v96.Z) / 2);
                            end;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v95);
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

        u86:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};