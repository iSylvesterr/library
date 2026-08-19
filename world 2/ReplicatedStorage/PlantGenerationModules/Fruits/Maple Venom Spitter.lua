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
        local _ = u1.Base;

        local function GetRandomHSV(p5, p6) -- Line: 18
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

        local function CreatePart(p21, p22, p23) -- Line: 28
            -- upvalues: u1 (copy), MaterialService (ref)
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

        local function GetColorWithRange(p26, p27) -- Line: 64
            local v28, v29, v30 = p26:ToHSV();

            return Color3.fromHSV(v28 + p27, v29, v30);
        end;

        local v31 = u4:NextNumber(-0.03, 0.03);

        for _, child in u1:GetChildren() do
            if tonumber(child.Name) then
                local v32, v33, v34 = child.Color:ToHSV();
                child.Color = Color3.fromHSV(v32 + v31, v33, v34);
            end;
        end;

        u1:ScaleTo(1 + ((p3 or 1) * 0.25 + 0.75));
        u1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u35) -- Line: 99, Name: BeginFruitGrowth
        local PrimaryPart = u35.PrimaryPart;
        local u36 = {};

        for _, v in u35:QueryDescendants("BasePart") do
            local v37 = tonumber(v.Name);

            if v37 then
                local v38 = not v:GetAttribute("DontShow");
                local v39 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v39, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v38 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v40 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v37,
                    decals = v39
                };
                table.insert(u36, v40);
                v.CanCollide = false;

                if v38 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 134
            -- upvalues: u35 (copy), u36 (copy), PrimaryPart (copy)
            local v41 = u35:GetAttribute("Age") or 0;
            local v42 = u35:GetAttribute("MaxAge") or 1;
            local v43 = v41 / v42;

            for _, v in u36 do
                if not v.part:GetAttribute("DontShow") then
                    local v44 = math.clamp((v43 - v.partAge / v42) * v42, 0, 1);

                    if v44 ~= v.lastProgress then
                        v.lastProgress = v44;

                        if v44 > 0 then
                            local v45 = v.maxSize * v44;
                            v.part.Size = v45;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v45.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v44);
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

        u35:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p46) -- Line: 173, Name: OnFullyGrown
        local v47 = p46:GetAttribute("CorePartName");

        if v47 then
            local v48 = p46:FindFirstChild(v47);
            local v49 = v48 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v49 then
                local v50 = v49:Clone();
                v50.Name = "ProximityPrompt";
                v50.Parent = v48;
            end;
        end;

        p46:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Corn",
        Harvestable = true
    }
};