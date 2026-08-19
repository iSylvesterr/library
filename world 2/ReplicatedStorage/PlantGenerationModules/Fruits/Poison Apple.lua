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

            return Color3.fromHSV(v11, v8, v9), v11, v8, v9;
        end;

        local v12, v13 = Color3.fromRGB(0, 159, 13);
        local v14, v15, v16 = v12:ToHSV();
        local v17 = v13 or 0.05;
        local v18 = v14 + u4:NextNumber(-v17, v17);
        local v19 = Color3.fromHSV(v18, v15, v16);
        local v20, v21 = Color3.fromRGB(149, 99, 171);
        local v22, v23, v24 = v20:ToHSV();
        local v25 = v21 or 0.05;
        local v26 = v22 + u4:NextNumber(-v25, v25);
        local v27 = Color3.fromHSV(v26, v23, v24);
        local Leaf = p1:FindFirstChild("Leaf");

        if Leaf then
            local v28 = Leaf:GetPivot();
            local Angles = CFrame.Angles;
            local v29 = u4:NextNumber(-180, 180);
            Leaf:PivotTo(v28 * Angles(math.rad(v29), 0, 0));

            if u4:NextInteger(1, 6) == 1 then
                Leaf:Destroy();
            else
                Leaf.Name = "2";
            end;
        end;

        local v30 = p1:FindFirstChild("1");

        if v30 then
            local CFrame2 = v30.CFrame;
            local Angles = CFrame.Angles;
            local v31 = u4:NextNumber(-180, 180);
            local v32 = math.rad(v31);
            local v33 = u4:NextNumber(-5, 5);
            v30.CFrame = CFrame2 * Angles(0, v32, (math.rad(v33)));
        end;

        for _, child in p1:GetChildren() do
            if child:IsA("BasePart") or child:IsA("MeshPart") then
                local CFrame2 = child.CFrame;
                local Angles = CFrame.Angles;
                local v34 = u4:NextNumber(-5, 5);
                child.CFrame = CFrame2 * Angles(0, math.rad(v34), 0);

                if child.Color == Color3.fromRGB(0, 159, 13) then
                    child.Color = v19;
                end;

                if child.Color == Color3.fromRGB(149, 99, 171) then
                    child.Color = v27;
                end;

                if child:FindFirstChild("Decal") then
                    for _, child2 in child:GetChildren() do
                        if child2:IsA("Decal") then
                            child2.Color3 = v27;
                        end;
                    end;
                end;
            end;
        end;

        p1:ScaleTo(p3);
        p1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u35) -- Line: 56, Name: BeginFruitGrowth
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

        local function updateGrowth() -- Line: 91
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

    OnFullyGrown = function(p46) -- Line: 130, Name: OnFullyGrown
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
        FruitType = "Fruit",
        Harvestable = true
    }
};