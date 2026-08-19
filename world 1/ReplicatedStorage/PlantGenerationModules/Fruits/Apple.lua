-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        GrowRate = 0.1167,
        BaseWeight = 1.5,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(p1, p2, p3) -- Line: 9, Name: InitFruit
        local v4 = Random.new(p2);
        local v5 = p3 * 0.75 + 0.25;
        local v6 = v5 + v5 ^ 3 * 5e-7;
        local v7 = 1.6 * v6;
        local v8 = 0.6 * v6;
        local v9 = 0.18 * v6;
        local v10 = 0.7 * v6;
        local v11 = 0.4 * v6;
        local v12 = 0.1 * v6;
        local v13 = Color3.fromRGB(90, 60, 40);
        local v14 = Color3.fromRGB(70, 45, 30);
        local v15 = Color3.fromRGB(50, 170, 50);
        local v16 = Color3.fromRGB(35, 140, 35);
        local v17 = {
            Color3.fromRGB(200, 35, 35),
            Color3.fromRGB(170, 0, 0),
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(100, 170, 50),
            Color3.fromRGB(255, 0, 0)
        };

        local function CreateBasePart() -- Line: 40
            local Part = Instance.new("Part");
            Part.Material = Enum.Material.Glacier;
            Part.MaterialVariant = "2022 Stud";
            Part.Anchored = true;
            Part.CanCollide = false;

            return Part;
        end;

        local v18 = v4:NextInteger(1, 3);

        if v4:NextInteger(1, 5) == 1 then
            v18 = v4:NextInteger(4, 5);
        end;

        local v19, v20, v21 = v17[v18]:ToHSV();
        local v22 = v19 + v4:NextNumber(-0.02, 0.02);
        local v23 = v20 + v4:NextNumber(-0.1, 0.1);
        local v24 = math.clamp(v23, 0.5, 1);
        local v25 = v21 + v4:NextNumber(-0.1, 0.1);
        local v26 = math.clamp(v25, 0.6, 1);
        local v27 = Color3.fromHSV(v22 % 1, v24, v26);
        local v28 = v4:NextNumber(0.9, 1.1);
        local v29 = v7 * v28;
        local v30 = v7 * v28 * v4:NextNumber(0.88, 0.95);
        local Part = Instance.new("Part");
        Part.Material = Enum.Material.Glacier;
        Part.MaterialVariant = "2022 Stud";
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.Shape = Enum.PartType.Ball;
        Part.Size = Vector3.new(v29, v30, v29);
        Part.Color = v27;
        Part.Position = p1.PrimaryPart.Position + Vector3.new(0, -v30 / 2, 0);
        local v31 = 0 + 1;
        Part.Name = tostring(v31 + 1);
        Part.Parent = p1;
        local Part2 = Instance.new("Part");
        Part2.Material = Enum.Material.Glacier;
        Part2.MaterialVariant = "2022 Stud";
        Part2.Anchored = true;
        Part2.CanCollide = false;
        Part2.Shape = Enum.PartType.Block;
        Part2.Size = Vector3.new(v9, v8, v9);
        Part2.Color = v13:Lerp(v14, v4:NextNumber(0, 0.4));
        Part2.Position = Part.Position + Vector3.new(0, v30 / 2 + v8 / 2 - 0.05, 0);
        Part2.Name = tostring(v31);
        Part2.Parent = p1;
        local v32 = v31 + 1;
        Part.Name = tostring(v32);
        local v33 = v32 + 1;
        local Part3 = Instance.new("Part");
        Part3.Material = Enum.Material.Glacier;
        Part3.MaterialVariant = "2022 Stud";
        Part3.Anchored = true;
        Part3.CanCollide = false;
        Part3.Shape = Enum.PartType.Block;
        Part3.Size = Vector3.new(v9 * 1.3, v8 * 0.2, v9 * 1.3);
        Part3.Color = v14;
        Part3.Position = Part2.Position + Vector3.new(0, v8 / 2 + v8 * 0.2 / 2, 0);
        Part3.Name = tostring(v33);
        Part3.Parent = p1;
        local v34 = v4:NextInteger(0, 360);
        local v35 = v4:NextInteger(35, 55);
        local Part4 = Instance.new("Part");
        Part4.Material = Enum.Material.Glacier;
        Part4.MaterialVariant = "2022 Stud";
        Part4.Anchored = true;
        Part4.CanCollide = false;
        Part4.Shape = Enum.PartType.Block;
        Part4.Size = Vector3.new(v11, v10, v12);
        Part4.Color = v15:Lerp(v16, v4:NextNumber(0, 0.3));
        Part4.CFrame = CFrame.new(Part2.Position + Vector3.new(0, v8 * 0.3, 0)) * CFrame.Angles(0, math.rad(v34), 0) * CFrame.Angles(math.rad(v35), 0, 0) * CFrame.new(0, v10 / 2, 0);
        local v36 = v33 + 1;
        Part4.Name = tostring(v36);
        Part4.Parent = p1;
        local Part5 = Instance.new("Part");
        Part5.Material = Enum.Material.Glacier;
        Part5.MaterialVariant = "2022 Stud";
        Part5.Anchored = true;
        Part5.CanCollide = false;
        Part5.Shape = Enum.PartType.Wedge;
        Part5.Size = Vector3.new(v12, v10 * 0.4, v11);
        Part5.Color = Part4.Color;
        Part5.CFrame = Part4.CFrame * CFrame.new(0, v10 / 2 + v10 * 0.4 / 2, 0) * CFrame.Angles(0, -1.5707963267948966, 0);
        local v37 = v36 + 1;
        Part5.Name = tostring(v37);
        Part5.Parent = p1;
        local Part6 = Instance.new("Part");
        Part6.Size = Vector3.new(0.1, 0.1, 0.1);
        Part6.Position = Part.Position + Vector3.new(0, v30 / 2 + 1, 0);
        Part6.Anchored = true;
        Part6.CanCollide = false;
        Part6.Transparency = 1;
        Part6:SetAttribute("DontShow", true);
        Part6.Name = tostring(v37 + 1);
        Part6.Parent = p1;
        p1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u38) -- Line: 151, Name: BeginFruitGrowth
        local PrimaryPart = u38.PrimaryPart;
        local u39 = {};

        for _, v in u38:QueryDescendants("BasePart") do
            local v40 = tonumber(v.Name);

            if v40 then
                local v41 = not v:GetAttribute("DontShow");
                local v42 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v40
                };
                table.insert(u39, v42);
                v.CanCollide = false;

                if v41 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 174
            -- upvalues: u38 (copy), u39 (copy), PrimaryPart (copy)
            local v43 = u38:GetAttribute("CorePartName");
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

                            if v.part.Name == v43 then
                                v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, (v.maxSize.Y - v48.Y) / 2, 0);
                            else
                                v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v48.Y) / 2), 0);
                            end;

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

        u38:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p49) -- Line: 218, Name: OnFullyGrown
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
        FruitType = "Apple",
        Harvestable = true
    }
};