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

        local v14, v15 = Color3.fromRGB(51, 136, 5);
        local v16, v17, v18 = v14:ToHSV();
        local v19 = v15 or 0.05;
        local v20 = v16 + u5:NextNumber(-v19, v19);
        local v21 = math.clamp(v20, 0, 0.99);
        Color3.fromHSV(v21, v17, v18);

        local function GetColorWithRange(p22, p23) -- Line: 66
            local v24, v25, v26 = p22:ToHSV();

            return Color3.fromHSV(v24 + p23, v25, v26);
        end;

        local v27 = math.floor(v4 ^ 1.5);
        local v28 = Color3.fromRGB(97, 48, 3);
        local v29 = Base.CFrame * CFrame.Angles(0, 0, 3.141592653589793);

        local function CreatePart(p30, p31, p32) -- Line: 30
            -- upvalues: u1 (copy), MaterialService (copy)
            local Part = Instance.new("Part");
            local v33 = p30 or "Studs";
            Part.Parent = u1;
            Part.TopSurface = Enum.SurfaceType[v33];
            Part.BackSurface = Enum.SurfaceType[v33];
            Part.FrontSurface = Enum.SurfaceType[v33];
            Part.BottomSurface = Enum.SurfaceType[v33];
            Part.LeftSurface = Enum.SurfaceType[v33];
            Part.RightSurface = Enum.SurfaceType[v33];
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Transparency = 0;

            for _, child in pairs(script:GetChildren()) do
                if child:IsA("Texture") then
                    child:Clone().Parent = Part;
                end;
            end;

            if p32 then
                Part.Shape = Enum.PartType[p32];
            end;

            if p31 then
                Part.MaterialVariant = p31;
                local v34 = MaterialService:FindFirstChild(p31, true);

                if not v34 then
                    return Part;
                end;

                Part.Material = v34.BaseMaterial;
            end;

            return Part;
        end;

        local v35 = 0;

        for i = 1, v27 do
            local v36 = CreatePart(nil, "2022 Stud Wavy");
            v36.Size = Vector3.new(0.5, 2.5, 0.5);
            local Angles = CFrame.Angles;
            local v37 = u5:NextNumber(-25, 25);
            v36.CFrame = v29 * Angles(0, math.rad(v37), 0) * CFrame.new(0, v36.Size.Y / 2, 0);
            v36.Color = v28;
            v36.Name = i;
            local v38 = u5:NextInteger(1, 2);

            for i2 = 1, v38 do
                local v39 = v38 == 1 and u5:NextNumber(-180, 180) or 360 / v38 * (i2 * u5:NextNumber(0.9, 1.1));
                local v40 = CreatePart(nil, "2022 Stud Wavy");
                local v41 = u5:NextNumber(0.9, 1.3);
                v40.Size = Vector3.new(0.4, v41, 0.4);
                v40.CFrame = v36.CFrame * CFrame.Angles(0, math.rad(v39 + v35), 1.3089969389957472) * CFrame.new(0, v40.Size.Y / 2, 0);
                v40.Color = v28;
                v40.Name = i + 1;
                local v42 = script.Berry:Clone();
                v42.Parent = u1;
                v42:PivotTo(v40.CFrame * CFrame.new(0, v40.Size.Y / 2, 0));

                for _, child in v42:GetChildren() do
                    local v43 = tonumber(child.Name);

                    if v43 then
                        child.Name = v43 + i + 1;
                        child.Parent = u1;
                    end;
                end;

                v42:Destroy();
            end;

            v35 = v35 + 90;
            v29 = v36.CFrame * CFrame.new(0, v36.Size.Y / 2, 0);

            if i == v27 then
                local v44 = script.Berry:Clone();
                v44.Parent = u1;
                v44:PivotTo(v29);

                for _, child in v44:GetChildren() do
                    local v45 = tonumber(child.Name);

                    if v45 then
                        child.Name = v45 + i;
                        child.Parent = u1;
                    end;
                end;

                v44:Destroy();
            end;
        end;

        local v46 = u5:NextNumber(-0.03, 0.03);

        for _, descendant in u1:GetDescendants() do
            if descendant:IsA("BasePart") or descendant:IsA("MeshPart") then
                local v47, v48, v49 = descendant.Color:ToHSV();
                local v50;

                if descendant.Color == v28 then
                    v50 = v46 / 2 or v46;
                else
                    v50 = v46;
                end;

                descendant.Color = Color3.fromHSV(math.clamp(v47 + v50, 0.01, 0.99), v48, v49);
                descendant.Size = descendant.Size * v4;
                local v51 = Base.CFrame:ToObjectSpace(descendant.CFrame);
                local v52 = CFrame.new(v51.Position * v4) * CFrame.fromMatrix(Vector3.new(0, 0, 0), v51.XVector, v51.YVector, v51.ZVector);
                descendant.CFrame = Base.CFrame * v52;

                if descendant:FindFirstChild("Decal") then
                    for _, child in descendant:GetChildren() do
                        if child:IsA("Decal") then
                            local v53, v54, v55 = child.Color3:ToHSV();
                            child.Color3 = Color3.fromHSV(math.clamp(v53 + v46, 0.01, 0.99), v54, v55);
                        end;
                    end;
                end;
            end;
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u56) -- Line: 163, Name: BeginFruitGrowth
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

        local function updateGrowth() -- Line: 198
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

            if v63 <= v62 then
                for _, v in u56:QueryDescendants("ParticleEmitter") do
                    v.Enabled = true;
                end;
            end;
        end;

        u56:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p67) -- Line: 243, Name: OnFullyGrown
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