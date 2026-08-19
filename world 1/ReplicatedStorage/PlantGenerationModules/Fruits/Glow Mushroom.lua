-- Decompiled with Potassium's decompiler.

game:GetService("MaterialService");

return {
    GrowData = {
        GrowRate = 0.05,
        BaseWeight = 7,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(u1, p2, p3) -- Line: 10, Name: InitFruit
        local MaterialService = game:GetService("MaterialService");
        local v4 = p3 or 1;
        local u5 = Random.new(p2);
        local Base = u1.Base;

        local function GetRandomHSV(p6, p7) -- Line: 20
            -- upvalues: u5 (copy)
            local v8, v9, v10 = p6:ToHSV();
            local v11 = p7 or 0.05;
            local v12 = v8 + u5:NextNumber(-v11, v11);
            local v13 = math.clamp(v12, 0, 0.99);

            return Color3.fromHSV(v13, v9, v10), v13, v9, v10;
        end;

        local u14 = Color3.fromRGB(180, 170, 158);
        local v15, v16, v17 = Color3.fromRGB(100, 0, 192):ToHSV();
        local v18 = 0.1 or 0.05;
        local v19 = v15 + u5:NextNumber(-v18, v18);
        local v20 = math.clamp(v19, 0, 0.99);
        local u21 = Color3.fromHSV(v20, v16, v17);

        local function CreatePart(p22, p23, p24) -- Line: 31
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

        local function CreateStem(p27, p28, p29, p30, p31) -- Line: 61
            -- upvalues: CreatePart (copy), u5 (copy), u14 (copy), u1 (copy), u21 (copy)
            local Y = p28.Y;
            local X = p28.X;
            local v32 = Y;

            for i = 1, p27 do
                local v33 = CreatePart(nil, "2022 Inlet");
                v33.Size = p28;
                local Angles = CFrame.Angles;
                local v34 = u5:NextNumber(-6, 6);
                local v35 = math.rad(v34);
                local v36 = u5:NextNumber(-6, 6);
                v33.CFrame = p29 * Angles(v35, 0.2617993877991494, (math.rad(v36))) * CFrame.new(0, p28.Y / 2.2, 0);
                v33.Color = u14;
                v33.Name = tostring(i + p30);
                p29 = v33.CFrame * CFrame.new(0, p28.Y / 2.2, 0);
                Y = math.clamp(Y * 1.15, 0, v32 * 2);

                if i == p27 then
                    local v37 = script.MushroomTop:Clone();
                    v37.Parent = u1;
                    v37:ScaleTo((i == p27 and u5:NextNumber(0.65, 0.75) or u5:NextNumber(0.19, 0.27)) * (X * 0.85));
                    v37:PivotTo(p29);

                    for _, child in v37:GetChildren() do
                        local v38 = tonumber(child.Name);

                        if v38 then
                            if v38 > 1 then
                                child.Color = u21;
                            end;

                            if v38 == 3 then
                                local CFrame2 = child.CFrame;
                                local Angles2 = CFrame.Angles;
                                local v39 = u5:NextNumber(-10, 10);
                                child.CFrame = CFrame2 * Angles2(0, math.rad(v39), 0);
                            end;

                            if v38 > 1 and i == p27 then
                                local v40 = 90;

                                for _ = 1, 2 do
                                    for _ = 1, u5:NextInteger(3, 6) do
                                        local v41 = u5:NextNumber(p28.X * 0.08, p28.X * 0.1);
                                        local v42 = CreatePart();
                                        local v43 = {
                                            X = 0,
                                            Y = u5:NextNumber(-child.Size.Y, child.Size.Y) * 0.35,
                                            Z = u5:NextNumber(-child.Size.Z, child.Size.Z) * 0.3
                                        };
                                        v42.Material = Enum.Material.Neon;
                                        v42.Size = Vector3.new(v41, child.Size.Z + 0.1, v41);
                                        v42.CFrame = child.CFrame * CFrame.Angles(0, math.rad(v40), 0) * CFrame.new(v43.X, v43.Y, v43.Z) * CFrame.Angles(0, 0, 1.5707963267948966);
                                        v42.Color = Color3.fromRGB(180, 170, 158);
                                        v42.Name = i + p30 + v38 + 1;
                                    end;

                                    v40 = v40 * 2;
                                end;
                            end;

                            child.Name = v38 + i + p30;
                            child.Parent = u1;
                        end;
                    end;
                end;

                p28 = Vector3.new(p28.X * 0.75, Y, p28.Z * 0.75);
            end;
        end;

        local v44 = u5:NextNumber(1.1, 1.2) * v4;
        local v45 = u5:NextNumber(1.7, 1.8) * v4;
        local v46 = math.clamp(2 * v4, 2, 3);
        local v47 = math.floor(v46);
        local v48 = Vector3.new(v44, v45, v44);
        local _ = 1 * v4;
        CreateStem(v47, v48, Base.CFrame, 0, true);
        u1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u49) -- Line: 148, Name: BeginFruitGrowth
        local PrimaryPart = u49.PrimaryPart;
        local u50 = {};

        for _, v in u49:QueryDescendants("BasePart") do
            local v51 = tonumber(v.Name);

            if v51 then
                local v52 = not v:GetAttribute("DontShow");
                local v53 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v53, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v52 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v54 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v51,
                    decals = v53
                };
                table.insert(u50, v54);
                v.CanCollide = false;

                if v52 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 183
            -- upvalues: u49 (copy), u50 (copy), PrimaryPart (copy)
            local v55 = u49:GetAttribute("Age") or 0;
            local v56 = u49:GetAttribute("MaxAge") or 1;
            local v57 = v55 / v56;

            for _, v in u50 do
                if not v.part:GetAttribute("DontShow") then
                    local v58 = math.clamp((v57 - v.partAge / v56) * v56, 0, 1);

                    if v58 ~= v.lastProgress then
                        v.lastProgress = v58;

                        if v58 > 0 then
                            local v59 = v.maxSize * v58;
                            v.part.Size = v59;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v59.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v58);
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

        u49:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p60) -- Line: 222, Name: OnFullyGrown
        local v61 = p60:GetAttribute("CorePartName");

        if v61 then
            local v62 = p60:FindFirstChild(v61);
            local v63 = v62 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v63 then
                local v64 = v63:Clone();
                v64.Name = "ProximityPrompt";
                v64.Parent = v62;
            end;
        end;

        p60:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Glow Mushroom",
        Harvestable = true
    }
};