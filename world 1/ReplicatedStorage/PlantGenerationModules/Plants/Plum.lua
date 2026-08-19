-- Decompiled with Potassium's decompiler.

game:GetService("MaterialService");

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u1, p2, p3) -- Line: 9, Name: InitPlant
        local MaterialService = game:GetService("MaterialService");
        local u4 = (p3 or 1) * 0.25 + 0.75;
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

        local v20 = u5:NextNumber(1.5, 1.7);
        local v21 = u5:NextNumber(3.3, 3.7);
        local v22 = Vector3.new(v20, v21, v20) * u4;
        local v23 = Vector3.new(v20 * 0.65, v21, v20 * 0.65) * u4;
        local CFrame2 = Base.CFrame;
        local v24 = u5:NextInteger(5, 7);
        local v25 = Color3.fromRGB(49, 139, 47);
        local v26 = u5:NextInteger(3, 4);
        local v27 = u5:NextNumber(4, 10);
        local v28 = u5:NextInteger(2, 3);
        local v29 = u5:NextNumber(70, 160);
        local CFrame3 = Base.CFrame;
        local v30 = 0;
        local v31 = nil;
        local v32 = 0;

        local function CreatePart(p33, p34, p35) -- Line: 31
            -- upvalues: u1 (copy), MaterialService (copy)
            local Part = Instance.new("Part");
            local v36 = p33 or "Studs";
            Part.Parent = u1;
            Part.TopSurface = Enum.SurfaceType[v36];
            Part.BackSurface = Enum.SurfaceType[v36];
            Part.FrontSurface = Enum.SurfaceType[v36];
            Part.BottomSurface = Enum.SurfaceType[v36];
            Part.LeftSurface = Enum.SurfaceType[v36];
            Part.RightSurface = Enum.SurfaceType[v36];
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Transparency = 0;

            for _, child in pairs(script:GetChildren()) do
                if child:IsA("Texture") then
                    child:Clone().Parent = Part;
                end;
            end;

            if p35 then
                Part.Shape = Enum.PartType[p35];
            end;

            if p34 then
                Part.MaterialVariant = p34;
                local v37 = MaterialService:FindFirstChild(p34, true);

                if not v37 then
                    return Part;
                end;

                Part.Material = v37.BaseMaterial;
            end;

            return Part;
        end;

        local v38 = 0;

        while u5:NextInteger(1, 75) == 1 do
            v24 = v24 * 2;
        end;

        local function CreateLeaves(p39, p40, p41) -- Line: 108
            -- upvalues: u5 (copy), u1 (copy), u4 (ref)
            local v42 = u5:NextInteger(2, 3);
            local v43 = u5:NextNumber(80, 100) + (v42 - 2) * 25;

            for i = 1, v42 do
                local v44 = script.Leaf:Clone();
                v44.Parent = u1;
                local v45 = -v43 / 2 + (i - 1) / math.max(v42 - 1, 1) * v43;
                v44:ScaleTo(u5:NextNumber(p41 and (p41[1] or 0.265) or 0.265, p41 and (p41[2] or 0.365) or 0.365) * u4);
                v44:PivotTo(p39 * CFrame.Angles(0, -1.5707963267948966, (math.rad(v45))) * CFrame.Angles(0, 0.3490658503988659, 0));

                for _, child in v44:GetChildren() do
                    child.Name = p40;
                    child.Parent = u1;
                end;

                v44:Destroy();
            end;
        end;

        for i = 1, v24 do
            local v46 = script.Stem:Clone();
            v46.Parent = u1;

            if (i - 1) % v26 == 0 then
                v27 = -v27;
            end;

            v38 = v38 + (v27 - v38) * (1 / v26);
            local v47 = {
                Y = 0,
                X = math.rad(v38),
                Z = math.rad(v38)
            };
            v46.Size = v22:Lerp(v23, i / v24);
            v46.CFrame = CFrame2 * CFrame.Angles(v47.X, 0, v47.Z) * CFrame.new(0, v46.Size.Y / 2.2, 0);
            v46.Color = v25;
            v46.Name = i;

            if i > 1 and i < math.floor(v24 - 1) then
                local v48 = u5:NextInteger(3, 4);
                local CFrame4 = v46.CFrame;
                local Angles = CFrame.Angles;
                local v49 = i * 180 + u5:NextNumber(-50, 50);
                local v50 = math.rad(v49);
                local v51 = u5:NextNumber(20, 30);
                local v52 = CFrame4 * Angles(0, v50, (math.rad(v51)));
                local v53 = v46.Size * 0.75;
                local v54 = v46.Size * 0.55;
                local v55 = u5:NextInteger(0, 1);

                for i2 = 1, v48 do
                    local v56 = script.Stem:Clone();
                    v56.Parent = u1;
                    v56.Size = v53:Lerp(v54, i2 / v48);
                    local Angles2 = CFrame.Angles;
                    local v57 = u5:NextNumber(20, 35);
                    v56.CFrame = v52 * Angles2(0, 0, (math.rad(v57))) * CFrame.new(0, v56.Size.Y / 2.25, 0);
                    v56.Name = i + i2;
                    v56.Color = v25;

                    if i2 == math.floor(v48 - v55) and u5:NextInteger(1, 3) ~= 1 then
                        local v58 = script.Stem:Clone();
                        v58.Parent = u1;
                        v58.Size = v56.Size * 0.45 + Vector3.new(0, 0.15, 0);
                        local CFrame5 = v56.CFrame;
                        local Angles3 = CFrame.Angles;
                        local v59 = u5:NextNumber(-35, 35);
                        v58.CFrame = CFrame5 * Angles3(0, math.rad(v59), -1.5707963267948966) * CFrame.Angles(0, 0, 0.2617993877991494) * CFrame.new(0, v56.Size.Z / 2.5 + v58.Size.Y / 2, 0);
                        v58.Name = i + i2 + 1;
                        v58.Color = v25;
                        CreateLeaves(v58.CFrame * CFrame.new(0, v58.Size.Y / 2, 0) * CFrame.Angles(0, -1.5707963267948966, 0), i + i2 + 2, { 0.125, 0.185 });
                    end;

                    if i2 == v48 - 1 then
                        local v60 = CreatePart();
                        v60.Size = Vector3.new(1, 1, 1);
                        v60.CFrame = CFrame.new(v56.Position - Vector3.new(0, v56.Size.Y * 0.1, 0)) * CFrame.Angles(0, math.rad(v56.Orientation.Y), 0);
                        v60.Parent = FruitSpawnLocations;
                        v60.Transparency = 1;
                    end;

                    v52 = v56.CFrame * CFrame.new(0, v56.Size.Y / 2.25, 0);
                end;

                CreateLeaves(v52, i + v48 + 1);
            end;

            local v61 = v46.Size.Y / v28;
            local v62 = v29 / v28;

            for i2 = 1, v28 do
                v31 = script.Stem:Clone();
                v31.Parent = u1;
                local v63 = v46.CFrame * CFrame.new(0, -v46.Size.Y / 2 + v61 * i2, 0) * CFrame.Angles(0, math.rad(v32), 0) * CFrame.new(0, 0, v46.Size.X / 2 + v31.Size.X / 2);
                local Magnitude = (CFrame3.Position - v63.Position).Magnitude;
                v31.Size = Vector3.new(v46.Size.X, Magnitude + 0.15, v46.Size.Z);
                v31.CFrame = CFrame.lookAt(CFrame3.Position, v63.Position) * CFrame.new(0, 0, -Magnitude / 2) * CFrame.Angles(-1.5707963267948966, 0, 0);
                v31.Color = v25;
                v31.Name = i + i2;
                v32 = v32 + v62;
                v30 = v31.Size.Y;
                CFrame3 = v63;
            end;

            CFrame2 = v46.CFrame * CFrame.new(0, v46.Size.Y / 2.2, 0);
        end;

        local v64 = u5:NextInteger(2, 3);
        local v65 = u5:NextInteger(3, 4);
        local v66 = Vector3.new(v23.X, v30, v23.Z);
        local v67 = Vector3.new(v23.X * 0.7, v30, v23.Z * 0.7);
        local v68 = v31.CFrame * CFrame.new(0, v31.Size.Y / 2, 0) * CFrame.Angles(0, -1.5707963267948966, -0.2617993877991494);

        for i = 1, v65 do
            local v69 = script.Stem:Clone();
            v69.Parent = u1;
            v69.Size = v66:Lerp(v67, i / v65);
            local Angles = CFrame.Angles;
            local v70 = u5:NextNumber(20, 35);
            v69.CFrame = v68 * Angles(0, 0, (math.rad(v70))) * CFrame.new(0, v69.Size.Y / 2.25, 0);
            v69.Color = v25;
            v69.Name = i + v28 * v24;
            v68 = v69.CFrame * CFrame.new(0, v69.Size.Y / 2.25, 0);
        end;

        CreateLeaves(v68, v65 + v28 * v24 + 1);
        local v71 = CFrame2 * CFrame.Angles(0, 3.141592653589793, 0);

        for i = 1, v64 do
            local v72 = script.Stem:Clone();
            v72.Parent = u1;
            v72.Size = v66:Lerp(v67, i / v64) + Vector3.new(0, 1, 0);
            local Angles = CFrame.Angles;
            local v73 = u5:NextNumber(20, 35);
            v72.CFrame = v71 * Angles(0, 0, (math.rad(v73))) * CFrame.new(0, v72.Size.Y / 2.25, 0);
            v72.Color = v25;
            v72.Name = i + v28 * v24;
            v71 = v72.CFrame * CFrame.new(0, v72.Size.Y / 2.25, 0);
        end;

        CreateLeaves(v71, v64 + v28 * v24 + 1);
        local v74 = u5:NextNumber(-0.04, 0.04);

        for _, descendant in u1:GetDescendants() do
            if descendant:IsA("BasePart") or descendant:IsA("MeshPart") then
                local v75, v76, v77 = descendant.Color:ToHSV();
                descendant.Color = Color3.fromHSV(math.clamp(v75 + v74, 0.01, 0.99), v76, v77);

                if descendant:FindFirstChild("Decal") then
                    for _, child in descendant:GetChildren() do
                        if child:IsA("Decal") then
                            local v78, v79, v80 = child.Color3:ToHSV();
                            child.Color3 = Color3.fromHSV(math.clamp(v78 + v74, 0.01, 0.99), v79, v80);
                        end;
                    end;
                end;
            end;
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u81) -- Line: 282, Name: BeginPlantGrowth
        local PrimaryPart = u81.PrimaryPart;
        local u82 = {};

        for _, v in u81:QueryDescendants("BasePart") do
            local v83 = tonumber(v.Name);

            if v83 then
                local v84 = not v:GetAttribute("DontShow");
                local v85 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v85, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v84 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v86 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v83,
                    decals = v85
                };
                table.insert(u82, v86);
                v.CanCollide = false;

                if v84 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 317
            -- upvalues: u81 (copy), u82 (copy), PrimaryPart (copy)
            local v87 = u81:GetAttribute("Age") or 0;
            local v88 = u81:GetAttribute("MaxAge") or 1;
            local v89 = v87 / v88;

            for _, v in u82 do
                if not v.part:GetAttribute("DontShow") then
                    if v89 >= 1 then
                        for _, descendant in v.part:GetDescendants() do
                            if descendant:IsA("ParticleEmitter") then
                                descendant.Enabled = true;
                            end;
                        end;
                    end;

                    local v90 = math.clamp((v89 - v.partAge / v88) * v88, 0, 1);

                    if v90 ~= v.lastProgress then
                        v.lastProgress = v90;

                        if v90 > 0 then
                            local v91 = v.maxSize * v90;
                            v.part.Size = v91;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v91.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            if v.part:GetAttribute("GrowZAxis") then
                                v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, 0, (v.maxSize.Z - v91.Z) / 2);
                            end;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v90);
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

        u81:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};