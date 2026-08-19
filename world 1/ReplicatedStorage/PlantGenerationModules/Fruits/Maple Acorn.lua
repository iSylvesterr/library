-- Decompiled with Potassium's decompiler.

local MaterialService = game:GetService("MaterialService");

local function GetRandomHSV(p1, p2, p3) -- Line: 6
    local v4, v5, v6 = p2:ToHSV();
    local v7 = p3 or 0.05;
    local v8 = v4 + p1:NextNumber(-v7, v7);

    return Color3.fromHSV(v8, v5, v6), v8, v5, v6;
end;

local function CreatePart(p9, p10, p11, p12) -- Line: 15
    -- upvalues: MaterialService (copy)
    local Part = Instance.new("Part");
    local v13 = p10 or "Studs";
    Part.Parent = p9;
    Part.TopSurface = Enum.SurfaceType[v13];
    Part.BackSurface = Enum.SurfaceType[v13];
    Part.FrontSurface = Enum.SurfaceType[v13];
    Part.BottomSurface = Enum.SurfaceType[v13];
    Part.LeftSurface = Enum.SurfaceType[v13];
    Part.RightSurface = Enum.SurfaceType[v13];
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.Transparency = 0;

    if p12 then
        Part.Shape = Enum.PartType[p12];
    end;

    if p11 then
        Part.MaterialVariant = p11;
        local v14 = MaterialService:FindFirstChild(p11, true);

        if not v14 then
            return Part;
        end;

        Part.Material = v14.BaseMaterial;
    end;

    return Part;
end;

local function CreateMeshPart(p15, p16, p17) -- Line: 45
    local v18 = p16:Clone();
    v18.Parent = p15;
    v18.Anchored = true;
    v18.CanCollide = false;
    v18.Transparency = 0;

    if p17 then
        v18.MaterialVariant = p17;
    end;

    return v18;
end;

local function GetDifference(p19, p20) -- Line: 57
    return p20 + (p19 - p20) / 2;
end;

return {
    GrowData = {
        BaseWeight = 1.5,
        GrowRate = 0.0058,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(p21, p22, p23) -- Line: 69, Name: InitFruit
        local v24 = Random.new(p22);
        local _ = 5 * p23;
        local v25, v26, v27 = Color3.fromRGB(199, 132, 65):ToHSV();
        local v28 = 0.025 or 0.05;
        local v29 = v25 + v24:NextNumber(-v28, v28);
        local v30 = Color3.fromHSV(v29, v26, v27);
        local v31 = p21:FindFirstChild("1");
        local v32 = p21:FindFirstChild("2");

        if v31 and v32 then
            local v33 = v24:NextNumber(0.25, 0.4);
            v31.Size = Vector3.new(v33, 0.85, v33);
            v31.CFrame = v32.CFrame * CFrame.Angles(0, 0, 3.141592653589793) * CFrame.new(0, 0.425 + v32.Size.Y / 2, 0) * CFrame.Angles(0, 0, 3.141592653589793);
        end;

        for _, child in p21:GetChildren() do
            if child:IsA("BasePart") then
                local v34 = tonumber(child.Name);

                if v34 then
                    local CFrame2 = child.CFrame;
                    local Angles = CFrame.Angles;
                    local v35 = v24:NextNumber(-10, 10);
                    child.CFrame = CFrame2 * Angles(0, math.rad(v35), 0);

                    if v34 > 3 then
                        child.Color = v30;
                    end;
                end;
            end;
        end;

        local v36 = (p23 * 0.5 + 0.3) ^ 1.25;
        p21:ScaleTo(v36 + v36 ^ 3 * 0.0001);
        p21:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u37) -- Line: 113, Name: BeginFruitGrowth
        local PrimaryPart = u37.PrimaryPart;
        local u38 = {};

        for _, v in u37:QueryDescendants("BasePart") do
            local v39 = tonumber(v.Name);

            if v39 then
                local v40 = not v:GetAttribute("DontShow");
                local v41 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v39
                };
                table.insert(u38, v41);
                v.CanCollide = false;

                if v40 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 134
            -- upvalues: u37 (copy), u38 (copy), PrimaryPart (copy)
            local v42 = u37:GetAttribute("Age") or 0;
            local v43 = u37:GetAttribute("MaxAge") or 1;
            local v44 = v42 / v43;

            for _, v in u38 do
                if not v.part:GetAttribute("DontShow") then
                    local v45 = math.clamp((v44 - v.partAge / v43) * v43, 0, 1);

                    if v45 ~= v.lastProgress then
                        v.lastProgress = v45;

                        if v45 > 0 then
                            local v46 = v.maxSize * v45;
                            v.part.Size = v46;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v46.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;
                        else
                            v.part.Transparency = 1;
                            v.part.CanCollide = false;
                        end;
                    end;
                end;
            end;
        end;

        u37:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p47) -- Line: 170, Name: OnFullyGrown
        local v48 = p47:GetAttribute("CorePartName");

        if v48 then
            local v49 = p47:FindFirstChild(v48);
            local v50 = v49 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v50 then
                local v51 = v50:Clone();
                v51.Name = "ProximityPrompt";
                v51.Parent = v49;
            end;
        end;

        p47:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Acorn",
        Harvestable = true
    }
};