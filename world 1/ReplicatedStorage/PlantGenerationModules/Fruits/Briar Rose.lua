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
        local v4 = p3 or 1;
        local u5 = Random.new(p2);
        local Base = u1.Base;

        local function GetRandomHSV(p6, p7) -- Line: 18
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

        local function CreatePart(p22, p23, p24) -- Line: 28
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

        local function GetColorWithRange(p27, p28) -- Line: 64
            local v29, v30, v31 = p27:ToHSV();

            return Color3.fromHSV(v29 + p28, v30, v31);
        end;

        local v32 = u5:NextInteger(4, 6);
        local v33, v34 = Color3.fromRGB(70, 38, 106);
        local v35, v36, v37 = v33:ToHSV();
        local v38 = v34 or 0.05;
        local v39 = v35 + u5:NextNumber(-v38, v38);
        local v40 = math.clamp(v39, 0, 0.99);
        local v41 = Color3.fromHSV(v40, v36, v37);
        local v42, v43 = Color3.fromRGB(181, 34, 255);
        local v44, v45, v46 = v42:ToHSV();
        local v47 = v43 or 0.05;
        local v48 = v44 + u5:NextNumber(-v47, v47);
        local v49 = math.clamp(v48, 0, 0.99);
        local v50 = Color3.fromHSV(v49, v45, v46);

        if u5:NextInteger(1, 25) == 1 then
            v41 = Color3.fromRGB(2, 42, 43);
            v50 = Color3.fromRGB(0, 98, 235);
        end;

        if u5:NextInteger(1, 100) == 1 then
            v41 = Color3.fromRGB(97, 23, 8);
            v50 = Color3.fromRGB(235, 38, 0);
        end;

        script.Petal.PrimaryPart.Color = v41;

        for _, child in script.Petal.PrimaryPart:GetChildren() do
            if child:IsA("Decal") and child.Color3 ~= Color3.fromRGB(0, 0, 0) then
                child.Color3 = v50;
            end;
        end;

        for i = 1, v32 do
            local v51 = script.Petal:Clone();
            v51.Parent = u1;
            local v52 = 360 / v32 * (i * u5:NextNumber(0.9, 1.1));
            v51:ScaleTo(1 * v4);
            v51:PivotTo(Base.CFrame * CFrame.Angles(0, math.rad(v52), 0) * CFrame.Angles(0.3490658503988659, 0, 0));
            v51.PrimaryPart.Parent = u1;
            v51:Destroy();
        end;

        local v53 = u5:NextInteger(3, 4);

        for i = 1, v53 do
            local v54 = script.Petal:Clone();
            v54.Parent = u1;
            local v55 = 360 / v53 * (i * u5:NextNumber(0.9, 1.1));
            v54:ScaleTo(0.9 * v4);
            v54:PivotTo(Base.CFrame * CFrame.Angles(0, math.rad(v55), 0) * CFrame.Angles(0.08726646259971647, 0, 0));
            v54.PrimaryPart.Parent = u1;
            v54:Destroy();
        end;

        for i = 1, 3 do
            local v56 = script.Petal:Clone();
            v56.Parent = u1;
            local v57 = 120 * (i * u5:NextNumber(0.9, 1.1));
            v56:ScaleTo(0.8 * v4);
            v56:PivotTo(Base.CFrame * CFrame.Angles(0, math.rad(v57), 0) * CFrame.Angles(-0.2617993877991494, 0, 0));
            v56.PrimaryPart.Parent = u1;
            v56:Destroy();
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u58) -- Line: 142, Name: BeginFruitGrowth
        local PrimaryPart = u58.PrimaryPart;
        local u59 = {};

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

        local function updateGrowth() -- Line: 177
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
        end;

        u58:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p69) -- Line: 216, Name: OnFullyGrown
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