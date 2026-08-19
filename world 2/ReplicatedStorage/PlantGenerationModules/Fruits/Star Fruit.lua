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

        local v31 = u4:NextNumber(-0.05, 0.05);
        local v32 = p3 or 1;

        for _, child in u1:GetChildren() do
            if tonumber(child.Name) then
                local v33, v34, v35 = child.Color:ToHSV();
                child.Color = Color3.fromHSV(v33 + v31, v34, v35);
            end;
        end;

        if u4:NextInteger(1, 25) == 1 then
            for _, descendant in u1:GetDescendants() do
                if descendant:IsA("BasePart") or descendant:IsA("MeshPart") then
                    descendant.Color = Color3.fromRGB(235, 64, 160);
                end;
            end;
        end;

        for _, v in u1:QueryDescendants("ParticleEmitter, BasePart") do
            if v:IsA("ParticleEmitter") then
                local v36 = {};

                for _, v2 in ipairs(v.Size.Keypoints) do
                    table.insert(v36, NumberSequenceKeypoint.new(v2.Time, v2.Value * v32, v2.Envelope * v32));
                end;

                v.Size = NumberSequence.new(v36);
            end;

            if v:IsA("BasePart") then
                v.Size = v.Size * v32;
                local v37 = Base.CFrame:ToObjectSpace(v.CFrame);
                local v38 = CFrame.new(v37.Position * v32) * CFrame.fromMatrix(Vector3.new(0, 0, 0), v37.XVector, v37.YVector, v37.ZVector);
                v.CFrame = Base.CFrame * v38;
            end;
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u39) -- Line: 116, Name: BeginFruitGrowth
        local PrimaryPart = u39.PrimaryPart;
        local u40 = {};

        for _, v in u39:QueryDescendants("BasePart") do
            local v41 = tonumber(v.Name);

            if v41 then
                local v42 = not v:GetAttribute("DontShow");
                local v43 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v43, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v42 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v44 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v41,
                    decals = v43
                };
                table.insert(u40, v44);
                v.CanCollide = false;

                if v42 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 151
            -- upvalues: u39 (copy), u40 (copy), PrimaryPart (copy)
            local v45 = u39:GetAttribute("Age") or 0;
            local v46 = u39:GetAttribute("MaxAge") or 1;
            local v47 = v45 / v46;

            for _, v in u40 do
                if not v.part:GetAttribute("DontShow") then
                    local v48 = math.clamp((v47 - v.partAge / v46) * v46, 0, 1);

                    if v48 ~= v.lastProgress then
                        v.lastProgress = v48;

                        if v48 > 0 then
                            local v49 = v.maxSize * v48;
                            v.part.Size = v49;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v49.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v48);
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

            if v46 <= v45 then
                for _, v in u39:QueryDescendants("ParticleEmitter") do
                    v.Enabled = true;
                end;
            end;
        end;

        u39:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p50) -- Line: 196, Name: OnFullyGrown
        local v51 = p50:GetAttribute("CorePartName");

        if v51 then
            local v52 = p50:FindFirstChild(v51);
            local v53 = v52 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v53 then
                local v54 = v53:Clone();
                v54.Name = "ProximityPrompt";
                v54.Parent = v52;
            end;
        end;

        p50:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Corn",
        Harvestable = true
    }
};