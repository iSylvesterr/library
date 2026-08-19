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
                local v37 = u4:NextNumber(-15, 15);
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

                if v32 % 2 == 1 then
                    v40.Color = Color3.fromRGB(255, 66, 8);
                end;
            end;
        end;

        for _, child in u1.Anthers:GetChildren() do
            local v43 = child:GetPivot();
            local Angles = CFrame.Angles;
            local v44 = u4:NextNumber(-15, 15);
            local v45 = math.rad(v44);
            local v46 = u4:NextNumber(-5, 5);
            child:PivotTo(v43 * Angles(v45, 0, (math.rad(v46))));

            for _, child2 in child:GetChildren() do
                child2.Parent = u1;
            end;
        end;

        local v47 = u4:NextInteger(3, 4);
        local v48 = u4:NextNumber(-35, 35);

        for i = 1, v47 do
            local v49 = script.SharpLeaf:Clone();
            v49.Parent = u1;
            v49.Size = v49.Size * u4:NextNumber(0.85, 1.05);
            local v50 = v31.CFrame * CFrame.new(0, 0.5, 0);
            local Angles = CFrame.Angles;
            local v51 = math.rad(360 / v47 * i + v48);
            local v52 = u4:NextNumber(102, 118);
            local v53 = v50 * Angles(0, v51, (math.rad(v52))) * CFrame.new(0, v49.Size.Y / 2, 0);
            local Angles2 = CFrame.Angles;
            local v54 = u4:NextNumber(-180, 180);
            v49.CFrame = v53 * Angles2(0, math.rad(v54), 0);
            v49.Name = 2;
            local v55, v56, v57, v58, v59, v60, v61;

            if u4:NextInteger(1, 3) == 1 then
                local v62, v63 = Color3.fromRGB(255, 136, 38);
                local v64, v65, v66 = v62:ToHSV();
                local v67 = v63 or 0.05;
                local v68 = v64 + u4:NextNumber(-v67, v67);
                local v69 = math.clamp(v68, 0, 0.99);
                v55 = Color3.fromHSV(v69, v65, v66);

                if not v55 then
                    v56, v57, v58 = v49.Color:ToHSV();
                    v59 = nil or 0.05;
                    v60 = v56 + u4:NextNumber(-v59, v59);
                    v61 = math.clamp(v60, 0, 0.99);
                    v55 = Color3.fromHSV(v61, v57, v58);
                end;
            else
                v56, v57, v58 = v49.Color:ToHSV();
                v59 = nil or 0.05;
                v60 = v56 + u4:NextNumber(-v59, v59);
                v61 = math.clamp(v60, 0, 0.99);
                v55 = Color3.fromHSV(v61, v57, v58);
            end;

            v49.Color = v55;
        end;

        u1.Anthers:Destroy();

        for _, v in ipairs(u1:QueryDescendants("BasePart")) do
            if v ~= Base then
                v.Size = v.Size * v33;
                local v70 = Base.CFrame:ToObjectSpace(v.CFrame);
                v.CFrame = Base.CFrame * CFrame.new(v70.Position * v33) * v70.Rotation;
            end;
        end;

        local v71 = u4:NextNumber(-0.025, 0.025);

        for _, child in u1:GetChildren() do
            if tonumber(child.Name) then
                local v72, v73, v74 = child.Color:ToHSV();
                child.Color = Color3.fromHSV(v72 + v71, v73, v74);
            end;
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u75) -- Line: 149, Name: BeginFruitGrowth
        local PrimaryPart = u75.PrimaryPart;
        local u76 = {};

        for _, v in u75:QueryDescendants("BasePart") do
            local v77 = tonumber(v.Name);

            if v77 then
                local v78 = not v:GetAttribute("DontShow");
                local v79 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v79, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v78 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v80 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v77,
                    decals = v79
                };
                table.insert(u76, v80);
                v.CanCollide = false;

                if v78 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 184
            -- upvalues: u75 (copy), u76 (copy), PrimaryPart (copy)
            local v81 = u75:GetAttribute("Age") or 0;
            local v82 = u75:GetAttribute("MaxAge") or 1;
            local v83 = v81 / v82;

            for _, v in u76 do
                if not v.part:GetAttribute("DontShow") then
                    local v84 = math.clamp((v83 - v.partAge / v82) * v82, 0, 1);

                    if v84 ~= v.lastProgress then
                        v.lastProgress = v84;

                        if v84 > 0 then
                            local v85 = v.maxSize * v84;
                            v.part.Size = v85;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v85.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v84);
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

            if v82 <= v81 then
                for _, v in u75:QueryDescendants("ParticleEmitter") do
                    v.Enabled = true;
                end;
            end;
        end;

        u75:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p86) -- Line: 229, Name: OnFullyGrown
        local v87 = p86:GetAttribute("CorePartName");

        if v87 then
            local v88 = p86:FindFirstChild(v87);
            local v89 = v88 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v89 then
                local v90 = v89:Clone();
                v90.Name = "ProximityPrompt";
                v90.Parent = v88;
            end;
        end;

        p86:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Corn",
        Harvestable = true
    }
};