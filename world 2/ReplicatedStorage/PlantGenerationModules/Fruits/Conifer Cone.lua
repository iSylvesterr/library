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
        local Base = u1.Base;

        local function GetRandomHSV(p5, p6) -- Line: 20
            -- upvalues: u4 (copy)
            local v7, v8, v9 = p5:ToHSV();
            local v10 = p6 or 0.05;
            local v11 = v7 + u4:NextNumber(-v10, v10);
            local v12 = math.clamp(v11, 0, 0.99);

            return Color3.fromHSV(v12, v8, v9), v12, v8, v9;
        end;

        local v13, v14 = Color3.fromRGB(51, 136, 5);
        local v15, v16, v17 = v13:ToHSV();
        local v18 = v14 or 0.05;
        local v19 = v15 + u4:NextNumber(-v18, v18);
        local v20 = math.clamp(v19, 0, 0.99);
        Color3.fromHSV(v20, v16, v17);

        local function CreatePart(p21, p22, p23) -- Line: 30
            -- upvalues: u1 (copy), MaterialService (copy)
            local Part = Instance.new("Part");
            local v24 = p21 or "Studs";
            Part.Parent = u1;
            Part.TopSurface = Enum.SurfaceType[v24];
            Part.BackSurface = Enum.SurfaceType[v24];
            Part.FrontSurface = Enum.SurfaceType[v24];
            Part.BottomSurface = Enum.SurfaceType[v24];
            Part.LeftSurface = Enum.SurfaceType[v24];
            Part.RightSurface = Enum.SurfaceType[v24];
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Transparency = 0;

            for _, child in pairs(script:GetChildren()) do
                if child:IsA("Texture") then
                    child:Clone().Parent = Part;
                end;
            end;

            if p23 then
                Part.Shape = Enum.PartType[p23];
            end;

            if p22 then
                Part.MaterialVariant = p22;
                local v25 = MaterialService:FindFirstChild(p22, true);

                if not v25 then
                    return Part;
                end;

                Part.Material = v25.BaseMaterial;
            end;

            return Part;
        end;

        local function GetColorWithRange(p26, p27) -- Line: 66
            local v28, v29, v30 = p26:ToHSV();

            return Color3.fromHSV(v28 + p27, v29, v30);
        end;

        local Leaves = u1.Leaves;
        local v31 = p3 or 1;

        for _, child in Leaves:GetChildren() do
            local v32 = child:GetPivot();
            local Angles = CFrame.Angles;
            local v33 = u4:NextNumber(-15, 15);
            child:PivotTo(v32 * Angles(0, math.rad(v33), 0));

            for _, child2 in child:GetChildren() do
                child2.Parent = u1;
            end;
        end;

        Leaves:Destroy();
        local v34 = u4:NextNumber(-0.04, 0.04);

        for _, descendant in u1:GetDescendants() do
            if descendant:IsA("BasePart") or descendant:IsA("MeshPart") then
                local v35, v36, v37 = descendant.Color:ToHSV();
                descendant.Color = Color3.fromHSV(math.clamp(v35 + v34, 0.01, 0.99), v36, v37);
                descendant.Size = descendant.Size * v31;
                local v38 = Base.CFrame:ToObjectSpace(descendant.CFrame);
                local v39 = CFrame.new(v38.Position * v31) * CFrame.fromMatrix(Vector3.new(0, 0, 0), v38.XVector, v38.YVector, v38.ZVector);
                descendant.CFrame = Base.CFrame * v39;

                if descendant:FindFirstChild("Decal") then
                    for _, child in descendant:GetChildren() do
                        if child:IsA("Decal") then
                            local v40, v41, v42 = child.Color3:ToHSV();
                            child.Color3 = Color3.fromHSV(math.clamp(v40 + v34, 0.01, 0.99), v41, v42);
                        end;
                    end;
                end;
            end;
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u43) -- Line: 114, Name: BeginFruitGrowth
        local PrimaryPart = u43.PrimaryPart;
        local u44 = {};

        for _, v in u43:QueryDescendants("BasePart") do
            local v45 = tonumber(v.Name);

            if v45 then
                local v46 = not v:GetAttribute("DontShow");
                local v47 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v47, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v46 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v48 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v45,
                    decals = v47
                };
                table.insert(u44, v48);
                v.CanCollide = false;

                if v46 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 149
            -- upvalues: u43 (copy), u44 (copy), PrimaryPart (copy)
            local v49 = u43:GetAttribute("Age") or 0;
            local v50 = u43:GetAttribute("MaxAge") or 1;
            local v51 = v49 / v50;

            for _, v in u44 do
                if not v.part:GetAttribute("DontShow") then
                    local v52 = math.clamp((v51 - v.partAge / v50) * v50, 0, 1);

                    if v52 ~= v.lastProgress then
                        v.lastProgress = v52;

                        if v52 > 0 then
                            local v53 = v.maxSize * v52;
                            v.part.Size = v53;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v53.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v52);
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

            if v50 <= v49 then
                for _, v in u43:QueryDescendants("ParticleEmitter") do
                    v.Enabled = true;
                end;
            end;
        end;

        u43:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p54) -- Line: 194, Name: OnFullyGrown
        local v55 = p54:GetAttribute("CorePartName");

        if v55 then
            local v56 = p54:FindFirstChild(v55);
            local v57 = v56 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v57 then
                local v58 = v57:Clone();
                v58.Name = "ProximityPrompt";
                v58.Parent = v56;
            end;
        end;

        p54:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Corn",
        Harvestable = true
    }
};