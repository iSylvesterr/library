-- Decompiled with Potassium's decompiler.

local MaterialService = game:GetService("MaterialService");

return {
    GrowData = {
        GrowRate = 0.0095,
        BaseWeight = 2.1,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(u1, p2, p3) -- Line: 10, Name: InitFruit
        -- upvalues: MaterialService (copy)
        local v4 = p3 or 1;
        local u5 = Random.new(p2);
        local Base = u1.Base;

        local function GetRandomHSV(p6, p7) -- Line: 16
            -- upvalues: u5 (copy)
            local v8, v9, v10 = p6:ToHSV();
            local v11 = p7 or 0.05;
            local v12 = v8 + u5:NextNumber(-v11, v11);

            return Color3.fromHSV(v12, v9, v10), v12, v9, v10;
        end;

        local v13 = Color3.fromRGB(74, 112, 33);

        local function CreatePart(p14, p15, p16) -- Line: 26
            -- upvalues: u1 (copy), MaterialService (ref)
            local Part = Instance.new("Part");
            local v17 = p14 or "Studs";
            Part.Parent = u1;
            Part.TopSurface = Enum.SurfaceType[v17];
            Part.BackSurface = Enum.SurfaceType[v17];
            Part.FrontSurface = Enum.SurfaceType[v17];
            Part.BottomSurface = Enum.SurfaceType[v17];
            Part.LeftSurface = Enum.SurfaceType[v17];
            Part.RightSurface = Enum.SurfaceType[v17];
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Transparency = 0;

            if p16 then
                Part.Shape = Enum.PartType[p16];
            end;

            if p15 then
                Part.MaterialVariant = p15;
                local v18 = MaterialService:FindFirstChild(p15, true);

                if not v18 then
                    return Part;
                end;

                Part.Material = v18.BaseMaterial;
            end;

            return Part;
        end;

        local v19 = u5:NextNumber(0.25, 0.35) * v4;
        local v20 = Vector3.new(v19, 1.8, v19);
        local CFrame2 = Base.CFrame;
        local _ = 1 * v4;
        local v21 = 1.8;

        for i = 1, 2 do
            local v22 = CreatePart(nil, "2022 Weld");
            v22.Size = v20;
            local Angles = CFrame.Angles;
            local v23 = u5:NextNumber(-30, -15);
            local v24 = math.rad(v23);
            local v25 = u5:NextNumber(-6, 6);
            v22.CFrame = CFrame2 * Angles(v24, 0, (math.rad(v25))) * CFrame.new(0, v20.Y / 2.2, 0);
            v22.Color = v13;
            v22.Name = tostring(i);
            CFrame2 = v22.CFrame * CFrame.new(0, v20.Y / 2.2, 0);
            v21 = math.clamp(v21 * 1.5, 0, 2.25);

            if i == 2 then
                local v26 = -90;

                for i2 = 1, 3 do
                    local v27 = script.Leaf:Clone();
                    v27.Parent = u1;
                    local v28 = v22.CFrame * CFrame.Angles(0, 3.141592653589793, (math.rad(v26))) * CFrame.new(0, i2 % 2 == 0 and (v22.Size.Y / 2.5 or 0) or 0, 0);
                    local Angles2 = CFrame.Angles;
                    local v29 = u5:NextNumber(10, 25);
                    local v30 = math.rad(v29);
                    local v31 = u5:NextNumber(-10, 10);
                    v27:PivotTo(v28 * Angles2(v30, 0, (math.rad(v31))));
                    v27.Size = v27.Size * u5:NextNumber(0.9, 1.05);
                    v27.Name = 3;
                    v27:AddTag("PoisonIvy");
                    v26 = v26 + 90;
                end;
            end;

            v20 = Vector3.new(v20.X * 0.85, v21, v20.Z * 0.85);
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u32) -- Line: 100, Name: BeginFruitGrowth
        local PrimaryPart = u32.PrimaryPart;
        local u33 = {};

        for _, v in u32:QueryDescendants("BasePart") do
            local v34 = tonumber(v.Name);

            if v34 then
                local v35 = not v:GetAttribute("DontShow");
                local v36 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v36, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v35 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v37 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v34,
                    decals = v36
                };
                table.insert(u33, v37);
                v.CanCollide = false;

                if v35 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 135
            -- upvalues: u32 (copy), u33 (copy), PrimaryPart (copy)
            local v38 = u32:GetAttribute("Age") or 0;
            local v39 = u32:GetAttribute("MaxAge") or 1;
            local v40 = v38 / v39;

            for _, v in u33 do
                if not v.part:GetAttribute("DontShow") then
                    local v41 = math.clamp((v40 - v.partAge / v39) * v39, 0, 1);

                    if v41 ~= v.lastProgress then
                        v.lastProgress = v41;

                        if v41 > 0 then
                            local v42 = v.maxSize * v41;
                            v.part.Size = v42;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v42.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v41);
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

        u32:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p43) -- Line: 174, Name: OnFullyGrown
        local v44 = p43:GetAttribute("CorePartName");

        if v44 then
            local v45 = p43:FindFirstChild(v44);
            local v46 = v45 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v46 then
                local v47 = v46:Clone();
                v47.Name = "ProximityPrompt";
                v47.Parent = v45;
            end;
        end;

        p43:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Poison Ivy",
        Harvestable = true
    }
};