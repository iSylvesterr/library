-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        GrowRate = 0.5,
        BaseWeight = 1.5,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(p1, p2, p3) -- Line: 9, Name: InitFruit
        local v4 = Random.new(p2);
        local v5 = 1.6 * p3;
        local v6 = 0.6 * p3;
        local v7 = 0.18 * p3;
        local v8 = 0.7 * p3;
        local v9 = 0.4 * p3;
        local v10 = 0.1 * p3;
        local v11 = Color3.fromRGB(90, 60, 40);
        local v12 = Color3.fromRGB(70, 45, 30);
        local v13 = Color3.fromRGB(50, 170, 50);
        local v14 = Color3.fromRGB(35, 140, 35);
        local v15 = {
            Color3.fromRGB(200, 35, 35),
            Color3.fromRGB(170, 0, 0),
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(100, 170, 50),
            Color3.fromRGB(255, 0, 0)
        };

        local function CreateBasePart() -- Line: 36
            local Part = Instance.new("Part");
            Part.Material = Enum.Material.Glacier;
            Part.MaterialVariant = "2022 Stud";
            Part.Anchored = true;
            Part.CanCollide = false;

            return Part;
        end;

        local v16 = v4:NextInteger(1, 3);

        if v4:NextInteger(1, 5) == 1 then
            v16 = v4:NextInteger(4, 5);
        end;

        local v17, v18, v19 = v15[v16]:ToHSV();
        local v20 = v17 + v4:NextNumber(-0.02, 0.02);
        local v21 = v18 + v4:NextNumber(-0.1, 0.1);
        local v22 = math.clamp(v21, 0.5, 1);
        local v23 = v19 + v4:NextNumber(-0.1, 0.1);
        local v24 = math.clamp(v23, 0.6, 1);
        local v25 = Color3.fromHSV(v20 % 1, v22, v24);
        local v26 = v4:NextNumber(0.9, 1.1);
        local v27 = v5 * v26;
        local v28 = v5 * v26 * v4:NextNumber(0.88, 0.95);
        local Part = Instance.new("Part");
        Part.Material = Enum.Material.Glacier;
        Part.MaterialVariant = "2022 Stud";
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.Shape = Enum.PartType.Ball;
        Part.Size = Vector3.new(v27, v28, v27);
        Part.Color = v25;
        Part.Position = p1.PrimaryPart.Position + Vector3.new(0, -v28 / 2, 0);
        local v29 = 0 + 1;
        Part.Name = tostring(v29 + 1);
        Part.Parent = p1;
        local Part2 = Instance.new("Part");
        Part2.Material = Enum.Material.Glacier;
        Part2.MaterialVariant = "2022 Stud";
        Part2.Anchored = true;
        Part2.CanCollide = false;
        Part2.Shape = Enum.PartType.Block;
        Part2.Size = Vector3.new(v7, v6, v7);
        Part2.Color = v11:Lerp(v12, v4:NextNumber(0, 0.4));
        Part2.Position = Part.Position + Vector3.new(0, v28 / 2 + v6 / 2 - 0.05, 0);
        Part2.Name = tostring(v29);
        Part2.Parent = p1;
        local v30 = v29 + 1;
        Part.Name = tostring(v30);
        local v31 = v30 + 1;
        local Part3 = Instance.new("Part");
        Part3.Material = Enum.Material.Glacier;
        Part3.MaterialVariant = "2022 Stud";
        Part3.Anchored = true;
        Part3.CanCollide = false;
        Part3.Shape = Enum.PartType.Block;
        Part3.Size = Vector3.new(v7 * 1.3, v6 * 0.2, v7 * 1.3);
        Part3.Color = v12;
        Part3.Position = Part2.Position + Vector3.new(0, v6 / 2 + v6 * 0.2 / 2, 0);
        Part3.Name = tostring(v31);
        Part3.Parent = p1;
        local v32 = v4:NextInteger(0, 360);
        local v33 = v4:NextInteger(35, 55);
        local Part4 = Instance.new("Part");
        Part4.Material = Enum.Material.Glacier;
        Part4.MaterialVariant = "2022 Stud";
        Part4.Anchored = true;
        Part4.CanCollide = false;
        Part4.Shape = Enum.PartType.Block;
        Part4.Size = Vector3.new(v9, v8, v10);
        Part4.Color = v13:Lerp(v14, v4:NextNumber(0, 0.3));
        Part4.CFrame = CFrame.new(Part2.Position + Vector3.new(0, v6 * 0.3, 0)) * CFrame.Angles(0, math.rad(v32), 0) * CFrame.Angles(math.rad(v33), 0, 0) * CFrame.new(0, v8 / 2, 0);
        local v34 = v31 + 1;
        Part4.Name = tostring(v34);
        Part4.Parent = p1;
        local Part5 = Instance.new("Part");
        Part5.Material = Enum.Material.Glacier;
        Part5.MaterialVariant = "2022 Stud";
        Part5.Anchored = true;
        Part5.CanCollide = false;
        Part5.Shape = Enum.PartType.Wedge;
        Part5.Size = Vector3.new(v10, v8 * 0.4, v9);
        Part5.Color = Part4.Color;
        Part5.CFrame = Part4.CFrame * CFrame.new(0, v8 / 2 + v8 * 0.4 / 2, 0) * CFrame.Angles(0, -1.5707963267948966, 0);
        local v35 = v34 + 1;
        Part5.Name = tostring(v35);
        Part5.Parent = p1;
        local Part6 = Instance.new("Part");
        Part6.Size = Vector3.new(0.1, 0.1, 0.1);
        Part6.Position = Part.Position + Vector3.new(0, v28 / 2 + 1, 0);
        Part6.Anchored = true;
        Part6.CanCollide = false;
        Part6.Transparency = 1;
        Part6:SetAttribute("DontShow", true);
        Part6.Name = tostring(v35 + 1);
        Part6.Parent = p1;
        p1:SetAttribute("CorePartName", "Apple");
        p1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u36) -- Line: 148, Name: BeginFruitGrowth
        local PrimaryPart = u36.PrimaryPart;
        local u37 = {};

        for _, v in u36:QueryDescendants("BasePart") do
            local v38 = tonumber(v.Name);

            if v38 then
                local v39 = not v:GetAttribute("DontShow");
                local v40 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v38
                };
                table.insert(u37, v40);
                v.CanCollide = false;

                if v39 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 171
            -- upvalues: u36 (copy), u37 (copy), PrimaryPart (copy)
            local v41 = u36:GetAttribute("CorePartName");
            local v42 = u36:GetAttribute("Age") or 0;
            local v43 = u36:GetAttribute("MaxAge") or 1;
            local v44 = v42 / v43;

            for _, v in u37 do
                if not v.part:GetAttribute("DontShow") then
                    local v45 = math.clamp((v44 - v.partAge / v43) * v43, 0, 1);

                    if v45 ~= v.lastProgress then
                        v.lastProgress = v45;

                        if v45 > 0 then
                            local v46 = v.maxSize * v45;
                            v.part.Size = v46;

                            if v.part.Name == v41 then
                                v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, (v.maxSize.Y - v46.Y) / 2, 0);
                            else
                                v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v46.Y) / 2), 0);
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

        u36:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p47) -- Line: 215, Name: OnFullyGrown
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
        FruitType = "Apple",
        Harvestable = true
    }
};