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

        local Moon = u1.Moon;
        local Leaves = u1.Leaves;
        local Anthers = u1.Anthers;
        local v31 = Color3.fromRGB(255, 255, 255);

        if u4:NextInteger(1, 3) == 1 then
            v31 = u4:NextInteger(1, 2) == 1 and Color3.fromRGB(35, 55, 163) or Color3.fromRGB(34, 180, 248);
        end;

        for _, child in Moon:GetChildren() do
            child.Color = v31;
            child.Parent = u1;
        end;

        Moon:Destroy();

        for _, child in Leaves:GetChildren() do
            if child:IsA("Model") then
                local v32 = child:GetPivot();
                local Angles = CFrame.Angles;
                local v33 = u4:NextNumber(-10, 10);
                local v34 = math.rad(v33);
                local v35 = u4:NextNumber(-10, 10);
                child:PivotTo(v32 * Angles(v34, 0, (math.rad(v35))));

                for _, child2 in child:GetChildren() do
                    child2.Parent = u1;
                end;

                child:Destroy();
            else
                local v36 = child:GetPivot();
                local Angles = CFrame.Angles;
                local v37 = u4:NextNumber(-6, 6);
                local v38 = math.rad(v37);
                local v39 = u4:NextNumber(-20, 20);
                child:PivotTo(v36 * Angles(v38, 0, (math.rad(v39))));
                child.Parent = u1;
            end;
        end;

        for _, child in Anthers:GetChildren() do
            local v40 = child:GetPivot();
            local Angles = CFrame.Angles;
            local v41 = u4:NextNumber(-10, 10);
            local v42 = math.rad(v41);
            local v43 = u4:NextNumber(-15, 25);
            child:PivotTo(v40 * Angles(v42, 0, (math.rad(v43))));

            for _, child2 in child:GetChildren() do
                child2.Parent = u1;
            end;
        end;

        local v44 = u4:NextInteger(2, 4);
        local v45 = u1["1"];

        for i = 1, v44 do
            local v46 = script.Leaf:Clone();
            v46.Parent = u1;
            local v47 = 45 + 360 / v44 * (i * u4:NextNumber(0.9, 1, 1));
            local v48 = v45.CFrame * CFrame.new(0, v45.Size.Y / 2.5, 0);
            local Angles = CFrame.Angles;
            local v49 = math.rad(v47);
            local v50 = u4:NextNumber(97.5, 110);
            v46:PivotTo(v48 * Angles(0, v49, (math.rad(v50))));
            v46.Name = 2;
        end;

        Anthers:Destroy();
        local v51 = u4:NextNumber(-0.1, 0.1);

        for _, child in u1:GetChildren() do
            if tonumber(child.Name) and child.Color ~= Color3.fromRGB(255, 255, 255) then
                local v52, v53, v54 = child.Color:ToHSV();
                child.Color = Color3.fromHSV(v52 + v51, v53, v54);
            end;
        end;

        local v55 = (p3 or 1) * 0.25 + 0.75;
        u1:ScaleTo(v55 + v55 ^ 3 * 1e-6);
        u1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u56) -- Line: 144, Name: BeginFruitGrowth
        local PrimaryPart = u56.PrimaryPart;
        local u57 = {};

        for _, v in u56:QueryDescendants("BasePart") do
            local v58 = tonumber(v.Name);

            if v58 then
                local v59 = not v:GetAttribute("DontShow");
                local v60 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v60, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v59 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v61 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v58,
                    decals = v60
                };
                table.insert(u57, v61);
                v.CanCollide = false;

                if v59 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 179
            -- upvalues: u56 (copy), u57 (copy), PrimaryPart (copy)
            local v62 = u56:GetAttribute("Age") or 0;
            local v63 = u56:GetAttribute("MaxAge") or 1;
            local v64 = v62 / v63;

            for _, v in u57 do
                if not v.part:GetAttribute("DontShow") then
                    local v65 = math.clamp((v64 - v.partAge / v63) * v63, 0, 1);

                    if v65 ~= v.lastProgress then
                        v.lastProgress = v65;

                        if v65 > 0 then
                            local v66 = v.maxSize * v65;
                            v.part.Size = v66;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v66.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v65);
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

        u56:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p67) -- Line: 218, Name: OnFullyGrown
        local v68 = p67:GetAttribute("CorePartName");

        if v68 then
            local v69 = p67:FindFirstChild(v68);
            local v70 = v69 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v70 then
                local v71 = v70:Clone();
                v71.Name = "ProximityPrompt";
                v71.Parent = v69;
            end;
        end;

        p67:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Corn",
        Harvestable = true
    }
};