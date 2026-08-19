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

        local function Lerp(p32, p33, p34) -- Line: 72
            return p32 + (p33 - p32) * p34;
        end;

        local v35 = math.floor(7 * v5);
        local v36 = 1.2 * v5;
        local v37 = 0.6 * v5;
        local v38 = script.Stem.Size * v5;
        local v39 = Vector3.new(0.25, 1.3, 0.25) * v5;
        local CFrame2 = Base.CFrame;

        for i = 1, v35 do
            local v40 = script.Stem:Clone();
            v40.Parent = u1;
            local v41 = i / v35;
            v40.Size = v38:Lerp(v39, v41);
            local Angles = CFrame.Angles;
            local v42 = u4:NextNumber(-10, 3);
            local v43 = math.rad(v42);
            local v44 = u4:NextNumber(-6, 6);
            v40:PivotTo(CFrame2 * Angles(v43, 0, (math.rad(v44))) * CFrame.new(0, v40.Size.Y / 2.25, 0));
            v40.Name = i;

            if i > 1 then
                for i2 = 1, 2 do
                    local v45 = script.Leaf:Clone();
                    v45.Parent = u1;
                    local v46 = u4:NextNumber(55, 65);

                    if i2 == 2 then
                        v46 = -v46;
                    end;

                    v45:ScaleTo(v36 + (v37 - v36) * v41);
                    local v47 = v40.CFrame * CFrame.Angles(0, 0, (math.rad(v46)));
                    local Angles2 = CFrame.Angles;
                    local v48 = u4:NextNumber(-15, 5);
                    local v49 = math.rad(v48);
                    local v50 = u4:NextNumber(-10, 10);
                    v45:PivotTo(v47 * Angles2(v49, math.rad(v50), 0) * CFrame.new(0, v40.Size.Z / 2.25, 0));

                    for _, child in v45:GetChildren() do
                        local v51 = tonumber(child.Name);

                        if v51 then
                            child.Name = v51 + i;
                            child.Parent = u1;
                        end;
                    end;

                    v45:Destroy();
                end;
            end;

            if i == v35 then
                local v52 = script.Leaf:Clone();
                v52.Parent = u1;
                v52:ScaleTo(v52:GetScale() * v5);
                v52:PivotTo(v40.CFrame * CFrame.new(0, v40.Size.Y / 2.5, 0) * CFrame.Angles(-0.4363323129985824, 0, 0));

                for _, child in v52:GetChildren() do
                    local v53 = tonumber(child.Name);

                    if v53 then
                        child.Name = v53 + i;
                        child.Parent = u1;
                    end;
                end;

                v52:Destroy();
            end;

            CFrame2 = v40.CFrame * CFrame.new(0, v40.Size.Y / 2.25, 0);
        end;

        local v54 = u4:NextNumber(-0.035, 0.035);

        for _, v in u1:QueryDescendants("BasePart") do
            local v55, v56, v57 = v.Color:ToHSV();
            v.Color = Color3.fromHSV(math.clamp(v55 + v54, 0.01, 0.99), v56, v57);

            if v:FindFirstChild("Decal") then
                for _, child in v:GetChildren() do
                    if child:IsA("Decal") then
                        local v58, v59, v60 = child.Color3:ToHSV();
                        child.Color3 = Color3.fromHSV(math.clamp(v58 + v54, 0.01, 0.99), v59, v60);
                    end;
                end;
            end;
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u61) -- Line: 158, Name: BeginFruitGrowth
        local PrimaryPart = u61.PrimaryPart;
        local u62 = {};

        for _, v in u61:QueryDescendants("BasePart") do
            local v63 = tonumber(v.Name);

            if v63 then
                local v64 = not v:GetAttribute("DontShow");
                local v65 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v65, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v64 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v66 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v63,
                    decals = v65
                };
                table.insert(u62, v66);
                v.CanCollide = false;

                if v64 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 193
            -- upvalues: u61 (copy), u62 (copy), PrimaryPart (copy)
            local v67 = u61:GetAttribute("Age") or 0;
            local v68 = u61:GetAttribute("MaxAge") or 1;
            local v69 = v67 / v68;

            for _, v in u62 do
                if not v.part:GetAttribute("DontShow") then
                    local v70 = math.clamp((v69 - v.partAge / v68) * v68, 0, 1);

                    if v70 ~= v.lastProgress then
                        v.lastProgress = v70;

                        if v70 > 0 then
                            local v71 = v.maxSize * v70;
                            v.part.Size = v71;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v71.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v70);
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

            if v68 <= v67 then
                for _, v in u61:QueryDescendants("ParticleEmitter") do
                    v.Enabled = true;
                end;
            end;
        end;

        u61:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p72) -- Line: 238, Name: OnFullyGrown
        local v73 = p72:GetAttribute("CorePartName");

        if v73 then
            local v74 = p72:FindFirstChild(v73);
            local v75 = v74 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v75 then
                local v76 = v75:Clone();
                v76.Name = "ProximityPrompt";
                v76.Parent = v74;
            end;
        end;

        p72:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Corn",
        Harvestable = true
    }
};