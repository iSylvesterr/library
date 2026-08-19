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

        local function GetRandomHSV(p5, p6) -- Line: 23
            -- upvalues: u4 (copy)
            local v7, v8, v9 = p5:ToHSV();
            local v10 = p6 or 0.05;
            local v11 = v7 + u4:NextNumber(-v10, v10);
            local v12 = math.clamp(v11, 0, 0.99);

            return Color3.fromHSV(v12, v8, v9), v12, v8, v9;
        end;

        local function GetColorWithRange(p13, p14) -- Line: 67
            local v15, v16, v17 = p13:ToHSV();

            return Color3.fromHSV(v15 + p14, v16, v17);
        end;

        local function AddGradient(p18) -- Line: 73
            for _, child in script.Gradient:GetChildren() do
                child:Clone().Parent = p18;
            end;
        end;

        local v19 = (p3 or 1) * 0.25 + 0.75 - 0.5 + u4:NextNumber(0.5, 2);

        local function CreatePart(p20, p21, p22) -- Line: 31
            -- upvalues: u1 (copy), MaterialService (copy)
            local Part = Instance.new("Part");
            local v23 = p20 or "Studs";
            Part.Parent = u1;
            Part.TopSurface = Enum.SurfaceType[v23];
            Part.BackSurface = Enum.SurfaceType[v23];
            Part.FrontSurface = Enum.SurfaceType[v23];
            Part.BottomSurface = Enum.SurfaceType[v23];
            Part.LeftSurface = Enum.SurfaceType[v23];
            Part.RightSurface = Enum.SurfaceType[v23];
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Transparency = 0;

            for _, child in pairs(script:GetChildren()) do
                if child:IsA("Texture") then
                    child:Clone().Parent = Part;
                end;
            end;

            if p22 then
                Part.Shape = Enum.PartType[p22];
            end;

            if p21 then
                Part.MaterialVariant = p21;
                local v24 = MaterialService:FindFirstChild(p21, true);

                if not v24 then
                    return Part;
                end;

                Part.Material = v24.BaseMaterial;
            end;

            return Part;
        end;

        while u4:NextInteger(1, 20) == 1 do
            v19 = v19 * u4:NextNumber(1.8, 3);
        end;

        for _, child in u1:GetChildren() do
            if tonumber(child.Name) then
                local Y = child.Size.Y;
                child.Size = child.Size + Vector3.new(0, 1, 0) * v19;
                child.CFrame = child.CFrame * CFrame.new(0, (child.Size.Y - Y) / 2, 0);
            end;
        end;

        local v25 = CreatePart();
        v25.Size = Vector3.new(1, 1, 1);
        v25.Parent = FruitSpawnLocations;
        v25.Transparency = 1;
        v25.CFrame = Base.CFrame * CFrame.new(0, u1["1"].Size.Y, 0);
        local v26 = Random.new(p2):NextNumber(-0.035, 0.035);

        for _, descendant in u1:GetDescendants() do
            if descendant:IsA("BasePart") or descendant:IsA("MeshPart") then
                local v27, v28, v29 = descendant.Color:ToHSV();
                descendant.Color = Color3.fromHSV(math.clamp(v27 + v26, 0.01, 0.99), v28, v29);

                if descendant:FindFirstChild("Decal") then
                    for _, child in descendant:GetChildren() do
                        if child:IsA("Decal") then
                            local v30, v31, v32 = child.Color3:ToHSV();
                            child.Color3 = Color3.fromHSV(math.clamp(v30 + v26, 0.01, 0.99), v31, v32);
                        end;
                    end;
                end;
            end;
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u33) -- Line: 127, Name: BeginPlantGrowth
        local PrimaryPart = u33.PrimaryPart;
        local u34 = {};

        for _, v in u33:QueryDescendants("BasePart") do
            local v35 = tonumber(v.Name);

            if v35 then
                local v36 = not v:GetAttribute("DontShow");
                local v37 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v37, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v36 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v38 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v35,
                    decals = v37
                };
                table.insert(u34, v38);
                v.CanCollide = false;

                if v36 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 165
            -- upvalues: u33 (copy), u34 (copy), PrimaryPart (copy)
            local v39 = u33:GetAttribute("Age") or 0;
            local v40 = u33:GetAttribute("MaxAge") or 1;
            local v41 = v39 / v40;

            for _, v in u34 do
                if not v.part:GetAttribute("DontShow") then
                    if v41 >= 1 then
                        for _, descendant in v.part:GetDescendants() do
                            if descendant:IsA("ParticleEmitter") then
                                descendant.Enabled = true;
                            end;
                        end;
                    end;

                    local v42 = math.clamp((v41 - v.partAge / v40) * v40, 0, 1);

                    if v42 ~= v.lastProgress then
                        v.lastProgress = v42;

                        if v42 > 0 then
                            local v43 = math.min(v42 / 0.25, 1);
                            local v44 = Vector3.new(v.maxSize.X * v43, v.maxSize.Y * v42, v.maxSize.Z * v43);

                            if v.part:GetAttribute("GrowZAxis") then
                                v44 = v.maxSize * v42;
                            end;

                            v.part.Size = v44;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v44.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            if v.part:GetAttribute("GrowZAxis") then
                                v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, 0, (v.maxSize.Z - v44.Z) / 2);
                            end;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v42);
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

        u33:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};