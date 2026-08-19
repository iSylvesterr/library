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

        local Leaf = u1.Leaf;
        local v31 = Leaf:GetPivot();
        local Angles = CFrame.Angles;
        local v32 = u4:NextNumber(-180, 180);
        Leaf:PivotTo(v31 * Angles(0, 0, (math.rad(v32))));
        local v33 = p3 or 1;

        for _, child in Leaf:GetChildren() do
            child.Parent = u1;
        end;

        Leaf:Destroy();
        local v34 = u4:NextNumber(-0.04, 0.04);

        for _, descendant in u1:GetDescendants() do
            if descendant:IsA("BasePart") or descendant:IsA("MeshPart") then
                local v35, v36, v37 = descendant.Color:ToHSV();
                descendant.Color = Color3.fromHSV(math.clamp(v35 + v34, 0.01, 0.99), v36, v37);

                if descendant:FindFirstChild("Decal") then
                    for _, child in descendant:GetChildren() do
                        if child:IsA("Decal") then
                            local v38, v39, v40 = child.Color3:ToHSV();
                            child.Color3 = Color3.fromHSV(math.clamp(v38 + v34, 0.01, 0.99), v39, v40);
                        end;
                    end;
                end;
            end;
        end;

        for _, v in u1:QueryDescendants("ParticleEmitter, BasePart") do
            if v:IsA("ParticleEmitter") then
                local v41 = {};

                for _, v2 in ipairs(v.Size.Keypoints) do
                    table.insert(v41, NumberSequenceKeypoint.new(v2.Time, v2.Value * v33, v2.Envelope * v33));
                end;

                v.Size = NumberSequence.new(v41);
            end;

            if v:IsA("BasePart") then
                v.Size = v.Size * v33;
                local v42 = Base.CFrame:ToObjectSpace(v.CFrame);
                local v43 = CFrame.new(v42.Position * v33) * CFrame.fromMatrix(Vector3.new(0, 0, 0), v42.XVector, v42.YVector, v42.ZVector);
                v.CFrame = Base.CFrame * v43;
            end;
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u44) -- Line: 128, Name: BeginFruitGrowth
        local PrimaryPart = u44.PrimaryPart;
        local u45 = {};

        for _, v in u44:QueryDescendants("BasePart") do
            local v46 = tonumber(v.Name);

            if v46 then
                local v47 = not v:GetAttribute("DontShow");
                local v48 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v48, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v47 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v49 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v46,
                    decals = v48
                };
                table.insert(u45, v49);
                v.CanCollide = false;

                if v47 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 163
            -- upvalues: u44 (copy), u45 (copy), PrimaryPart (copy)
            local v50 = u44:GetAttribute("Age") or 0;
            local v51 = u44:GetAttribute("MaxAge") or 1;
            local v52 = v50 / v51;

            for _, v in u45 do
                if not v.part:GetAttribute("DontShow") then
                    local v53 = math.clamp((v52 - v.partAge / v51) * v51, 0, 1);

                    if v53 ~= v.lastProgress then
                        v.lastProgress = v53;

                        if v53 > 0 then
                            local v54 = v.maxSize * v53;
                            v.part.Size = v54;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v54.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v53);
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

            if v51 <= v50 then
                for _, v in u44:QueryDescendants("ParticleEmitter") do
                    v.Enabled = true;
                end;
            end;
        end;

        u44:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p55) -- Line: 208, Name: OnFullyGrown
        local v56 = p55:GetAttribute("CorePartName");

        if v56 then
            local v57 = p55:FindFirstChild(v56);
            local v58 = v57 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v58 then
                local v59 = v58:Clone();
                v59.Name = "ProximityPrompt";
                v59.Parent = v57;
            end;
        end;

        p55:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Corn",
        Harvestable = true
    }
};