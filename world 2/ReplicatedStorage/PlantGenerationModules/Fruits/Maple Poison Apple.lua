-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        GrowRate = 0.0023,
        BaseWeight = 2.25,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(p1, p2, p3) -- Line: 8, Name: InitFruit
        local u4 = Random.new(p2);

        local function GetRandomHSV(p5, p6) -- Line: 10
            -- upvalues: u4 (copy)
            local v7, v8, v9 = p5:ToHSV();
            local v10 = p6 or 0.05;
            local v11 = v7 + u4:NextNumber(-v10, v10);
            local v12 = math.clamp(v11, 0.01, 0.99);

            return Color3.fromHSV(v12, v8, v9), v12, v8, v9;
        end;

        local v13, v14 = Color3.fromRGB(199, 53, 0);
        local v15, v16, v17 = v13:ToHSV();
        local v18 = v14 or 0.05;
        local v19 = v15 + u4:NextNumber(-v18, v18);
        local v20 = math.clamp(v19, 0.01, 0.99);
        local v21 = Color3.fromHSV(v20, v16, v17);
        local v22, v23 = Color3.fromRGB(245, 168, 24);
        local v24, v25, v26 = v22:ToHSV();
        local v27 = v23 or 0.05;
        local v28 = v24 + u4:NextNumber(-v27, v27);
        local v29 = math.clamp(v28, 0.01, 0.99);
        local v30 = Color3.fromHSV(v29, v25, v26);
        local Leaf = p1:FindFirstChild("Leaf");

        if Leaf then
            local v31 = Leaf:GetPivot();
            local Angles = CFrame.Angles;
            local v32 = u4:NextNumber(-180, 180);
            Leaf:PivotTo(v31 * Angles(math.rad(v32), 0, 0));

            if u4:NextInteger(1, 6) == 1 then
                Leaf:Destroy();
            else
                Leaf.Name = "2";
            end;
        end;

        local v33 = p1:FindFirstChild("1");

        if v33 then
            local CFrame2 = v33.CFrame;
            local Angles = CFrame.Angles;
            local v34 = u4:NextNumber(-180, 180);
            local v35 = math.rad(v34);
            local v36 = u4:NextNumber(-5, 5);
            v33.CFrame = CFrame2 * Angles(0, v35, (math.rad(v36)));
        end;

        for _, child in p1:GetChildren() do
            if child:IsA("BasePart") or child:IsA("MeshPart") then
                local CFrame2 = child.CFrame;
                local Angles = CFrame.Angles;
                local v37 = u4:NextNumber(-5, 5);
                child.CFrame = CFrame2 * Angles(0, math.rad(v37), 0);

                if child.Color == Color3.fromRGB(0, 159, 13) then
                    child.Color = v21;
                end;

                if child.Color == Color3.fromRGB(149, 99, 171) then
                    child.Color = v30;
                end;

                if child:FindFirstChild("Decal") then
                    for _, child2 in child:GetChildren() do
                        if child2:IsA("Decal") then
                            child2.Color3 = v30;
                        end;
                    end;
                end;
            end;
        end;

        p1:ScaleTo(p3);
        p1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u38) -- Line: 56, Name: BeginFruitGrowth
        local PrimaryPart = u38.PrimaryPart;
        local u39 = {};

        for _, v in u38:QueryDescendants("BasePart") do
            local v40 = tonumber(v.Name);

            if v40 then
                local v41 = not v:GetAttribute("DontShow");
                local v42 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v42, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v41 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v43 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v40,
                    decals = v42
                };
                table.insert(u39, v43);
                v.CanCollide = false;

                if v41 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 91
            -- upvalues: u38 (copy), u39 (copy), PrimaryPart (copy)
            local v44 = u38:GetAttribute("Age") or 0;
            local v45 = u38:GetAttribute("MaxAge") or 1;
            local v46 = v44 / v45;

            for _, v in u39 do
                if not v.part:GetAttribute("DontShow") then
                    local v47 = math.clamp((v46 - v.partAge / v45) * v45, 0, 1);

                    if v47 ~= v.lastProgress then
                        v.lastProgress = v47;

                        if v47 > 0 then
                            local v48 = v.maxSize * v47;
                            v.part.Size = v48;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v48.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v47);
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

        u38:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p49) -- Line: 130, Name: OnFullyGrown
        local v50 = p49:GetAttribute("CorePartName");

        if v50 then
            local v51 = p49:FindFirstChild(v50);
            local v52 = v51 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v52 then
                local v53 = v52:Clone();
                v53.Name = "ProximityPrompt";
                v53.Parent = v51;
            end;
        end;

        p49:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Fruit",
        Harvestable = true
    }
};