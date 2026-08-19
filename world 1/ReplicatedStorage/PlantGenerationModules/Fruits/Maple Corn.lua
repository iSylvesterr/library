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

        local v14, v15 = Color3.fromRGB(198, 114, 12);
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
        local v27;

        if u5:NextInteger(1, 700) == 1 then
            v27 = Color3.new(0, 1, 0.368627);
        else
            v27 = nil;
        end;

        if u5:NextInteger(1, 7000) == 1 then
            v27 = Color3.new(0.141176, 0, 0);
        end;

        local v28 = u1["1"];
        local v29 = u5:NextInteger(3, 4);
        local v30 = Corn:GetPivot();
        local Angles = CFrame.Angles;
        local v31 = u5:NextNumber(-5, 5);
        local v32 = math.rad(v31);
        local v33 = u5:NextNumber(-45, 45);
        Corn:PivotTo(v30 * Angles(v32, math.rad(v33), 0));

        for _, child in Corn:GetChildren() do
            local CFrame2 = child.CFrame;
            local Angles2 = CFrame.Angles;
            local v34 = u5:NextNumber(-5, 5);
            child.CFrame = CFrame2 * Angles2(0, math.rad(v34), 0);

            if v27 ~= nil then
                child.Color = v27;
            end;

            child.Parent = u1;
        end;

        for i = 1, v29 do
            local v35 = script.FlowerPetal:Clone();
            local v36 = 360 / v29 * (i * u5:NextNumber(0.8, 1.2));
            v35.Parent = u1;
            v35:PivotTo(v28.CFrame * CFrame.new(0, -v28.Size.Y / 2.25, 0) * CFrame.Angles(0, math.rad(v36), 0) * CFrame.Angles(1.3089969389957472, 0, 0));
            v35.Name = 2;
        end;

        Corn:Destroy();
        u1:ScaleTo(v4 + v4 ^ 3 * 1e-7);
        u1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u37) -- Line: 102, Name: BeginFruitGrowth
        local PrimaryPart = u37.PrimaryPart;
        local u38 = {};

        for _, v in u37:QueryDescendants("BasePart") do
            local v39 = tonumber(v.Name);

            if v39 then
                local v40 = not v:GetAttribute("DontShow");
                local v41 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v41, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v40 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v42 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v39,
                    decals = v41
                };
                table.insert(u38, v42);
                v.CanCollide = false;

                if v40 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 137
            -- upvalues: u37 (copy), u38 (copy), PrimaryPart (copy)
            local v43 = u37:GetAttribute("Age") or 0;
            local v44 = u37:GetAttribute("MaxAge") or 1;
            local v45 = v43 / v44;

            for _, v in u38 do
                if not v.part:GetAttribute("DontShow") then
                    local v46 = math.clamp((v45 - v.partAge / v44) * v44, 0, 1);

                    if v46 ~= v.lastProgress then
                        v.lastProgress = v46;

                        if v46 > 0 then
                            local v47 = v.maxSize * v46;
                            v.part.Size = v47;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v47.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v46);
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

        u37:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p48) -- Line: 176, Name: OnFullyGrown
        local v49 = p48:GetAttribute("CorePartName");

        if v49 then
            local v50 = p48:FindFirstChild(v49);
            local v51 = v50 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v51 then
                local v52 = v51:Clone();
                v52.Name = "ProximityPrompt";
                v52.Parent = v50;
            end;
        end;

        p48:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Corn",
        Harvestable = true
    }
};