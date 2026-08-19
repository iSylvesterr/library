-- Decompiled with Potassium's decompiler.

game:GetService("MaterialService");

return {
    GrowData = {
        GrowRate = 0.0047,
        BaseWeight = 9,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(u1, p2, p3) -- Line: 10, Name: InitFruit
        local MaterialService = game:GetService("MaterialService");
        local u4 = Random.new(p2);
        local _ = u1.Base;

        local function GetRandomHSV(p5, p6) -- Line: 20
            -- upvalues: u4 (copy)
            local v7, v8, v9 = p5:ToHSV();
            local v10 = p6 or 0.05;
            local v11 = v7 + u4:NextNumber(-v10, v10);
            local v12 = math.clamp(v11, 0, 0.99);

            return Color3.fromHSV(v12, v8, v9), v12, v8, v9;
        end;

        local function CreatePart(p13, p14, p15) -- Line: 28
            -- upvalues: u1 (copy), MaterialService (copy)
            local Part = Instance.new("Part");
            local v16 = p13 or "Studs";
            Part.Parent = u1;
            Part.TopSurface = Enum.SurfaceType[v16];
            Part.BackSurface = Enum.SurfaceType[v16];
            Part.FrontSurface = Enum.SurfaceType[v16];
            Part.BottomSurface = Enum.SurfaceType[v16];
            Part.LeftSurface = Enum.SurfaceType[v16];
            Part.RightSurface = Enum.SurfaceType[v16];
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Transparency = 0;

            for _, child in pairs(script:GetChildren()) do
                if child:IsA("Texture") then
                    child:Clone().Parent = Part;
                end;
            end;

            if p15 then
                Part.Shape = Enum.PartType[p15];
            end;

            if p14 then
                Part.MaterialVariant = p14;
                local v17 = MaterialService:FindFirstChild(p14, true);

                if not v17 then
                    return Part;
                end;

                Part.Material = v17.BaseMaterial;
            end;

            return Part;
        end;

        local function GetColorWithRange(p18, p19) -- Line: 64
            local v20, v21, v22 = p18:ToHSV();

            return Color3.fromHSV(v20 + p19, v21, v22);
        end;

        local v23 = (p3 or 1) ^ 2;

        for _, child in u1:GetChildren() do
            if tonumber(child.Name) then
                local Y = child.Size.Y;
                child.Size = child.Size + Vector3.new(0, 1, 0) * (v23 - 0.5);
                child.CFrame = child.CFrame * CFrame.new(0, (child.Size.Y - Y) / 2, 0);
            end;
        end;

        local v24 = u1:GetAttribute("PlantSeed") or p2;
        local v25 = Random.new(v24):NextNumber(-0.035, 0.035);

        for _, descendant in u1:GetDescendants() do
            if descendant:IsA("BasePart") or descendant:IsA("MeshPart") then
                local v26, v27, v28 = descendant.Color:ToHSV();
                descendant.Color = Color3.fromHSV(math.clamp(v26 + v25, 0.01, 0.99), v27, v28);

                if descendant:FindFirstChild("Decal") then
                    for _, child in descendant:GetChildren() do
                        if child:IsA("Decal") then
                            local v29, v30, v31 = child.Color3:ToHSV();
                            child.Color3 = Color3.fromHSV(math.clamp(v29 + v25, 0.01, 0.99), v30, v31);
                        end;
                    end;
                end;
            end;
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u32) -- Line: 105, Name: BeginFruitGrowth
        local PrimaryPart = u32.PrimaryPart;
        local u33 = {};

        for _, v in u32:QueryDescendants("BasePart") do
            local v34 = tonumber(v.Name);

            if v34 then
                local v35 = not v:GetAttribute("DontShow");
                local v36 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v36, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v35 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v37 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v34,
                    decals = v36
                };
                table.insert(u33, v37);
                v.CanCollide = false;

                if v35 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 143
            -- upvalues: u32 (copy), u33 (copy), PrimaryPart (copy)
            local v38 = u32:GetAttribute("Age") or 0;
            local v39 = u32:GetAttribute("MaxAge") or 1;
            local v40 = v38 / v39;

            for _, v in u33 do
                if not v.part:GetAttribute("DontShow") then
                    local v41 = math.clamp((v40 - v.partAge / v39) * v39, 0, 1);

                    if v41 ~= v.lastProgress then
                        v.lastProgress = v41;

                        if v41 > 0 then
                            local v42 = math.min(v41 / 0.25, 1);
                            local v43 = Vector3.new(v.maxSize.X * v42, v.maxSize.Y * v41, v.maxSize.Z * v42);
                            v.part.Size = v43;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v43.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v41);
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

            if v39 <= v38 then
                for _, v in u32:QueryDescendants("ParticleEmitter") do
                    v.Enabled = true;
                end;
            end;
        end;

        u32:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p44) -- Line: 194, Name: OnFullyGrown
        local v45 = p44:GetAttribute("CorePartName");

        if v45 then
            local v46 = p44:FindFirstChild(v45);
            local v47 = v46 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v47 then
                local v48 = v47:Clone();
                v48.Name = "ProximityPrompt";
                v48.Parent = v46;
            end;
        end;

        p44:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Corn",
        Harvestable = true
    }
};