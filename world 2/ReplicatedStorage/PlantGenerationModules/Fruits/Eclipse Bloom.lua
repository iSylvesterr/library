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

        local v31 = u1["1"];
        local v32 = 0;
        local v33 = p3 or 1;

        for _, child in u1:GetChildren() do
            if child:GetAttribute("GenLeaf") then
                local v34 = tonumber(child.Name);
                v32 = v32 + 1;
                local v35 = script.BigLeaf:Clone();
                v35.Parent = u1;
                local v36 = child.CFrame * CFrame.new(-0.35, 0, 0);
                local Angles = CFrame.Angles;
                local v37 = u4:NextNumber(-5, 5);
                local v38 = math.rad(v37);
                local v39 = u4:NextNumber(-5, 5);
                v35:PivotTo(v36 * Angles(v38, math.rad(v39), 0));
                v35.Name = v34 + 1;
                local v40 = script.ThinLeaf:Clone();
                v40.Parent = u1;
                local v41 = child.CFrame * CFrame.new(0.15, u4:NextNumber(-1, 1), 0);
                local Angles2 = CFrame.Angles;
                local v42 = u4:NextNumber(-10, -5);
                v40:PivotTo(v41 * Angles2(0, math.rad(v42), 0));
                v40.Name = v34 + 1;
            end;
        end;

        local v43 = u4:NextInteger(3, 4);
        local v44 = u4:NextNumber(-35, 35);

        for i = 1, v43 do
            local v45 = script.SharpLeaf:Clone();
            v45.Parent = u1;
            v45.Size = v45.Size * u4:NextNumber(0.85, 1.05);
            local v46 = v31.CFrame * CFrame.new(0, 0.5, 0);
            local Angles = CFrame.Angles;
            local v47 = math.rad(360 / v43 * i + v44);
            local v48 = u4:NextNumber(102, 118);
            local v49 = v46 * Angles(0, v47, (math.rad(v48))) * CFrame.new(0, v45.Size.Y / 2, 0);
            local Angles2 = CFrame.Angles;
            local v50 = u4:NextNumber(-180, 180);
            v45.CFrame = v49 * Angles2(0, math.rad(v50), 0);
            v45.Name = 2;
        end;

        for _, v in u1:QueryDescendants("ParticleEmitter, BasePart") do
            if v:IsA("ParticleEmitter") then
                local v51 = {};

                for _, v2 in ipairs(v.Size.Keypoints) do
                    table.insert(v51, NumberSequenceKeypoint.new(v2.Time, v2.Value * v33, v2.Envelope * v33));
                end;

                v.Size = NumberSequence.new(v51);
            end;

            if v:IsA("BasePart") then
                v.Size = v.Size * v33;
                local v52 = Base.CFrame:ToObjectSpace(v.CFrame);
                local v53 = CFrame.new(v52.Position * v33) * CFrame.fromMatrix(Vector3.new(0, 0, 0), v52.XVector, v52.YVector, v52.ZVector);
                v.CFrame = Base.CFrame * v53;
            end;
        end;

        local v54 = u4:NextNumber(-0.025, 0.025);

        for _, child in u1:GetChildren() do
            if tonumber(child.Name) then
                local v55, v56, v57 = child.Color:ToHSV();
                child.Color = Color3.fromHSV(v55 + v54, v56, v57);
            end;
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u58) -- Line: 143, Name: BeginFruitGrowth
        local PrimaryPart = u58.PrimaryPart;
        local u59 = {};

        for _, v in u58:QueryDescendants("ParticleEmitter, Beam") do
            if v:FindFirstAncestor("13") then
                v.Enabled = false;
            end;
        end;

        for _, v in u58:QueryDescendants("BasePart") do
            local v60 = tonumber(v.Name);

            if v60 then
                local v61 = not v:GetAttribute("DontShow");
                local v62 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v62, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v61 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v63 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v60,
                    decals = v62
                };
                table.insert(u59, v63);
                v.CanCollide = false;

                if v61 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 188
            -- upvalues: u58 (copy), u59 (copy), PrimaryPart (copy)
            local v64 = u58:GetAttribute("Age") or 0;
            local v65 = u58:GetAttribute("MaxAge") or 1;
            local v66 = v64 / v65;

            for _, v in u59 do
                if not v.part:GetAttribute("DontShow") then
                    local v67 = math.clamp((v66 - v.partAge / v65) * v65, 0, 1);

                    if v67 ~= v.lastProgress then
                        v.lastProgress = v67;

                        if v67 > 0 then
                            local v68 = v.maxSize * v67;
                            v.part.Size = v68;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v68.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v67);
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

            if v65 <= v64 then
                for _, v in u58:QueryDescendants("ParticleEmitter, Beam") do
                    v.Enabled = true;
                end;
            end;
        end;

        u58:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p69) -- Line: 233, Name: OnFullyGrown
        local v70 = p69:GetAttribute("CorePartName");

        if v70 then
            local v71 = p69:FindFirstChild(v70);
            local v72 = v71 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v72 then
                local v73 = v72:Clone();
                v73.Name = "ProximityPrompt";
                v73.Parent = v71;
            end;
        end;

        p69:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Corn",
        Harvestable = true
    }
};