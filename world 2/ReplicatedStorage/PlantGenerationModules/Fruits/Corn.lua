-- Decompiled with Potassium's decompiler.

game:GetService("MaterialService");

return {
    GrowData = {
        GrowRate = 0.0444,
        BaseWeight = 3,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(u1, p2, p3) -- Line: 10, Name: InitFruit
        local MaterialService = game:GetService("MaterialService");
        local v4 = (p3 or 1) * 0.5 + 0.5;
        local u5 = Random.new(p2);
        local _ = u1.Base;

        local function GetRandomHSV(p6, p7) -- Line: 25
            -- upvalues: u5 (copy)
            local v8, v9, v10 = p6:ToHSV();
            local v11 = p7 or 0.05;
            local v12 = v8 + u5:NextNumber(-v11, v11);
            local v13 = math.clamp(v12, 0, 0.99);

            return Color3.fromHSV(v13, v9, v10), v13, v9, v10;
        end;

        local v14, v15 = Color3.fromRGB(51, 136, 5);
        local v16, v17, v18 = v14:ToHSV();
        local v19 = v15 or 0.05;
        local v20 = v16 + u5:NextNumber(-v19, v19);
        local v21 = math.clamp(v20, 0, 0.99);
        Color3.fromHSV(v21, v17, v18);

        local function CreatePart(p22, p23, p24) -- Line: 35
            -- upvalues: u1 (copy), MaterialService (copy)
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

        local Corn = u1.Corn;
        local v27, v28 = Color3.fromRGB(255, 243, 0);
        local v29, v30, v31 = v27:ToHSV();
        local v32 = v28 or 0.05;
        local v33 = v29 + u5:NextNumber(-v32, v32);
        local v34 = math.clamp(v33, 0, 0.99);
        local v35 = Color3.fromHSV(v34, v30, v31);

        if u5:NextInteger(1, 700) == 1 then
            v35 = Color3.new(0.666667, 0.333333, 1);
        end;

        if u5:NextInteger(1, 7000) == 1 then
            v35 = Color3.new(1, 1, 1);
        end;

        local v36 = u1["1"];
        local v37 = u5:NextInteger(3, 4);
        local v38 = Corn:GetPivot();
        local Angles = CFrame.Angles;
        local v39 = u5:NextNumber(-5, 5);
        local v40 = math.rad(v39);
        local v41 = u5:NextNumber(-45, 45);
        Corn:PivotTo(v38 * Angles(v40, math.rad(v41), 0));

        for _, child in Corn:GetChildren() do
            local CFrame2 = child.CFrame;
            local Angles2 = CFrame.Angles;
            local v42 = u5:NextNumber(-5, 5);
            child.CFrame = CFrame2 * Angles2(0, math.rad(v42), 0);
            child.Color = v35;
            child.Parent = u1;
        end;

        for i = 1, v37 do
            local v43 = script.FlowerPetal:Clone();
            local v44 = 360 / v37 * (i * u5:NextNumber(0.8, 1.2));
            v43.Parent = u1;
            v43:PivotTo(v36.CFrame * CFrame.new(0, -v36.Size.Y / 2.25, 0) * CFrame.Angles(0, math.rad(v44), 0) * CFrame.Angles(1.3089969389957472, 0, 0));
            v43.Name = 2;
        end;

        Corn:Destroy();
        u1:ScaleTo(v4 + v4 ^ 3 * 1e-7);
        u1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u45) -- Line: 100, Name: BeginFruitGrowth
        local PrimaryPart = u45.PrimaryPart;
        local u46 = {};

        for _, v in u45:QueryDescendants("BasePart") do
            local v47 = tonumber(v.Name);

            if v47 then
                local v48 = not v:GetAttribute("DontShow");
                local v49 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v49, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v48 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v50 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v47,
                    decals = v49
                };
                table.insert(u46, v50);
                v.CanCollide = false;

                if v48 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 135
            -- upvalues: u45 (copy), u46 (copy), PrimaryPart (copy)
            local v51 = u45:GetAttribute("Age") or 0;
            local v52 = u45:GetAttribute("MaxAge") or 1;
            local v53 = v51 / v52;

            for _, v in u46 do
                if not v.part:GetAttribute("DontShow") then
                    local v54 = math.clamp((v53 - v.partAge / v52) * v52, 0, 1);

                    if v54 ~= v.lastProgress then
                        v.lastProgress = v54;

                        if v54 > 0 then
                            local v55 = v.maxSize * v54;
                            v.part.Size = v55;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v55.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v54);
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

        u45:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p56) -- Line: 174, Name: OnFullyGrown
        local v57 = p56:GetAttribute("CorePartName");

        if v57 then
            local v58 = p56:FindFirstChild(v57);
            local v59 = v58 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v59 then
                local v60 = v59:Clone();
                v60.Name = "ProximityPrompt";
                v60.Parent = v58;
            end;
        end;

        p56:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Corn",
        Harvestable = true
    }
};