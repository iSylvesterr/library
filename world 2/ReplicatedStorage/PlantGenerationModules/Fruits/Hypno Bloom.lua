-- Decompiled with Potassium's decompiler.

local MaterialService = game:GetService("MaterialService");

return {
    GrowData = {
        GrowRate = 0.0047,
        BaseWeight = 9,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(u1, p2, p3) -- Line: 10, Name: InitFruit
        -- upvalues: MaterialService (copy)
        local u4 = Random.new(p2);
        local Base = u1.Base;
        local v5 = 0.75 + (p3 or 1) * 0.25;

        local function GetRandomHSV(p6, p7) -- Line: 20
            -- upvalues: u4 (copy)
            local v8, v9, v10 = p6:ToHSV();
            local v11 = p7 or 0.05;
            local v12 = v8 + u4:NextNumber(-v11, v11);
            local v13 = math.clamp(v12, 0, 0.99);

            return Color3.fromHSV(v13, v9, v10), v13, v9, v10;
        end;

        local v14, v15 = Color3.fromRGB(51, 136, 5);
        local v16, v17, v18 = v14:ToHSV();
        local v19 = v15 or 0.05;
        local v20 = v16 + u4:NextNumber(-v19, v19);
        local v21 = math.clamp(v20, 0, 0.99);
        Color3.fromHSV(v21, v17, v18);

        local function CreatePart(p22, p23, p24) -- Line: 30
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

        local function GetColorWithRange(p27, p28) -- Line: 66
            local v29, v30, v31 = p27:ToHSV();

            return Color3.fromHSV(v29 + p28, v30, v31);
        end;

        u4:NextInteger(2, 4);
        local Stem = u1.Stem;
        local Anthers = u1.Anthers;
        local v32 = u4:NextInteger(1, 2) == 1 and 8 or 6;
        local v33 = u4:NextNumber(-45, 45);
        local v34 = u4:NextNumber(-10, 5);

        for i = 1, v32 do
            local v35 = script.Leaf:Clone();
            v35.Parent = u1;
            v35:PivotTo(Stem.CFrame * CFrame.new(0, -0.15, 0) * CFrame.Angles(0, math.rad(360 / v32 * i + v33), 0) * CFrame.Angles(math.rad(-((i % 2 == 0 and 90 or 75) + v34)), 0, 0));
        end;

        for _, child in Anthers:GetChildren() do
            local v36 = child:GetPivot();
            local Angles = CFrame.Angles;
            local v37 = u4:NextNumber(-10, 10);
            local v38 = math.rad(v37);
            local v39 = u4:NextNumber(-5, 5);
            child:PivotTo(v36 * Angles(v38, 0, (math.rad(v39))));
        end;

        local v40 = u4:NextNumber(-0.1, 0.1);

        for _, v in u1:QueryDescendants("BasePart, ParticleEmitter") do
            if v:IsA("BasePart") then
                local v41, v42, v43 = v.Color:ToHSV();
                v.Color = Color3.fromHSV(math.clamp(v41 + v40, 0.01, 0.99), v42, v43);

                if v:FindFirstChild("Decal") then
                    for _, child in v:GetChildren() do
                        if child:IsA("Decal") then
                            local v44, v45, v46 = child.Color3:ToHSV();
                            child.Color3 = Color3.fromHSV(math.clamp(v44 + v40, 0.01, 0.99), v45, v46);
                        end;
                    end;
                end;
            end;

            if v:IsA("ParticleEmitter") then
                v.Enabled = false;
            end;
        end;

        for _, v in u1:QueryDescendants("ParticleEmitter, BasePart") do
            if v:IsA("ParticleEmitter") then
                local v47 = {};

                for _, v2 in ipairs(v.Size.Keypoints) do
                    table.insert(v47, NumberSequenceKeypoint.new(v2.Time, v2.Value * v5, v2.Envelope * v5));
                end;

                v.Size = NumberSequence.new(v47);
            end;

            if v:IsA("BasePart") then
                v.Size = v.Size * v5;
                local v48 = Base.CFrame:ToObjectSpace(v.CFrame);
                local v49 = CFrame.new(v48.Position * v5) * CFrame.fromMatrix(Vector3.new(0, 0, 0), v48.XVector, v48.YVector, v48.ZVector);
                v.CFrame = Base.CFrame * v49;
            end;
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u50) -- Line: 147, Name: BeginFruitGrowth
        local PrimaryPart = u50.PrimaryPart;
        local u51 = {};

        for _, v in u50:QueryDescendants("BasePart") do
            local v52 = tonumber(v.Name);

            if v52 then
                local v53 = not v:GetAttribute("DontShow");
                local v54 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v54, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v53 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v55 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v52,
                    decals = v54
                };
                table.insert(u51, v55);
                v.CanCollide = false;

                if v53 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 182
            -- upvalues: u50 (copy), u51 (copy), PrimaryPart (copy)
            local v56 = u50:GetAttribute("Age") or 0;
            local v57 = u50:GetAttribute("MaxAge") or 1;
            local v58 = v56 / v57;

            for _, v in u51 do
                if not v.part:GetAttribute("DontShow") then
                    local v59 = math.clamp((v58 - v.partAge / v57) * v57, 0, 1);

                    if v59 ~= v.lastProgress then
                        v.lastProgress = v59;

                        if v59 > 0 then
                            local v60 = v.maxSize * v59;
                            v.part.Size = v60;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v60.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v59);
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

            if v57 <= v56 then
                for _, v in u50:QueryDescendants("ParticleEmitter") do
                    if not v:FindFirstAncestor("Emitter") then
                        v.Enabled = true;
                    end;
                end;

                if not u50:HasTag("HypnoBloom") then
                    script.Emitter:Clone().Parent = u50.PrimaryPart;
                    u50:AddTag("HypnoBloom");
                end;
            end;
        end;

        u50:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p61) -- Line: 236, Name: OnFullyGrown
        local v62 = p61:GetAttribute("CorePartName");

        if v62 then
            local v63 = p61:FindFirstChild(v62);
            local v64 = v63 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v64 then
                local v65 = v64:Clone();
                v65.Name = "ProximityPrompt";
                v65.Parent = v63;
            end;
        end;

        p61:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Corn",
        Harvestable = true
    }
};