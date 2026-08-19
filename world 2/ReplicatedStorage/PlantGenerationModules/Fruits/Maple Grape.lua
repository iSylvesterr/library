-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        GrowRate = 0.0513,
        BaseWeight = 2,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(u1, p2, p3) -- Line: 9, Name: InitFruit
        local u4 = Random.new(p2);
        local v5 = p3 * 0.25 + 0.75;
        local u6 = 1 * (math.random(8, 12) * 0.1);
        local v7 = 2 * (math.random(8, 12) * 0.1);
        local v8 = 0.25 * (math.random(8, 12) * 0.1);
        local v9 = 5 * (math.random(8, 12) * 0.1);
        local v10 = Color3.fromRGB(76, 51, 34);
        local u11 = Vector3.new(0, 0, 0);
        local u12 = 0;

        local function CreateBasePart() -- Line: 30
            local Part = Instance.new("Part");
            Part.Material = Enum.Material.Glacier;
            Part.MaterialVariant = "2022 Stud";
            Part.Anchored = true;
            Part.CanCollide = false;

            return Part;
        end;

        local Part = Instance.new("Part");
        Part.Material = Enum.Material.Glacier;
        Part.MaterialVariant = "2022 Stud";
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.Size = Vector3.new(v8, v7, v8);
        Part.Color = v10;
        Part.Position = u1.PrimaryPart.Position + Vector3.new(0, v7 / 2, 0);
        local u13 = 0 + 1;
        Part.Name = tostring(u13);
        Part.Parent = u1;

        local function GenerateCircle(p14, p15, p16, p17) -- Line: 49
            -- upvalues: u4 (copy), u6 (copy), u13 (ref), u1 (copy), u11 (ref), u12 (ref)
            local v18 = 6.283185307179586 / p16;

            for i = 1, p16 do
                local v19 = v18 * i + p17;
                local v20 = math.cos(v19) * p15;
                local v21 = math.sin(v19) * p15;
                local Part2 = Instance.new("Part");
                Part2.Material = Enum.Material.Glacier;
                Part2.MaterialVariant = "2022 Stud";
                Part2.Anchored = true;
                Part2.CanCollide = false;
                Part2.Shape = Enum.PartType.Ball;
                local v22 = u4:NextInteger(90, 110) * 0.01;
                Part2.Size = Vector3.new(u6, u6, u6) * v22;
                local v23 = v20 + u4:NextInteger(-5, 5) * 0.01;
                local v24 = u4:NextInteger(-5, 5) * 0.01;
                local v25 = v21 + u4:NextInteger(-5, 5) * 0.01;
                Part2.Position = p14 + Vector3.new(v23, v24, v25);
                local v26 = u4:NextNumber(5, 8.5) * 0.01;
                Part2.Color = Color3.fromHSV(v26, 0.87, 0.96);
                u13 = u13 + 1;
                Part2.Name = tostring(u13);
                Part2.Parent = u1;
                u11 = u11 + Part2.Position;
                u12 = u12 + 1;
            end;
        end;

        local v27 = Part.Position + Vector3.new(0, -Part.Size.Y / 2, 0);
        local v28 = 0;

        for i = v9 - 1, 0, -1 do
            local v29 = i * 0.25;
            local v30 = i + 4;
            local v31 = u4:NextInteger(-180, 180);
            local v32 = 1;

            while v29 * v32 >= 0.2 or v32 == 1 do
                if v30 * v32 >= 1 then
                    GenerateCircle(v27 - Vector3.new(0, v28, 0), v29 * v32, math.floor(v30 * v32), v31);
                end;

                v32 = v32 * 0.4;

                if v32 < 0.4 then
                    break;
                end;
            end;

            v28 = v28 + u6 * 0.75;
        end;

        local Part2 = Instance.new("Part");
        Part2.Size = Vector3.new(0.1, 0.1, 0.1);
        Part2.Position = Vector3.new(Part.Position.X, u11.Y / u12 + 2, Part.Position.Z);
        Part2.Anchored = true;
        Part2.CanCollide = false;
        Part2.Transparency = 1;
        Part2:SetAttribute("DontShow", true);
        u13 = u13 + 1;
        Part2.Name = tostring(u13);
        Part2.Parent = u1;
        u1:ScaleTo(v5 + v5 ^ 3 * 0.00001);
        u1:SetAttribute("CorePartName", "Grape");
        u1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u33) -- Line: 126, Name: BeginFruitGrowth
        local PrimaryPart = u33.PrimaryPart;
        local u34 = {};

        for _, v in u33:QueryDescendants("BasePart") do
            local v35 = tonumber(v.Name);

            if v35 then
                local v36 = not v:GetAttribute("DontShow");
                local v37 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v35,
                    v.Shape == Enum.PartType.Ball
                };
                table.insert(u34, v37);
                v.CanCollide = false;

                if v36 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 151
            -- upvalues: u33 (copy), u34 (copy), PrimaryPart (copy)
            local v38 = u33:GetAttribute("Age") or 0;
            local v39 = u33:GetAttribute("MaxAge") or 1;
            local v40 = v38 / v39;

            for _, v in u34 do
                local v41 = v[1];
                local v42 = v[2];
                local v43 = v[3];
                local v44 = v[4];
                local v45 = v[5];

                if not v41:GetAttribute("DontShow") then
                    local v46 = math.min((v40 - v44 / v39) * v39, 1);
                    local v47 = math.clamp(v46, 0, 1);

                    if v47 ~= v.lastProgress then
                        v.lastProgress = v47;

                        if v46 > 0 then
                            if v45 then
                                v41.Size = v42 * v46;
                                v41.CFrame = PrimaryPart.CFrame * v43;
                            else
                                v41.Size = Vector3.new(v42.X, v42.Y * v46, v42.Z);
                                v41.CFrame = PrimaryPart.CFrame * v43 * CFrame.new(0, (v41.Size.Y - v42.Y) / 2, 0);
                            end;

                            v41.Transparency = v41:GetAttribute("OG_Transparency") or 0;
                            v41.CanCollide = true;
                        else
                            v41.Transparency = 1;
                            v41.CanCollide = false;
                        end;
                    end;
                end;
            end;
        end;

        u33:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p48) -- Line: 201, Name: OnFullyGrown
        local v49 = p48:GetAttribute("CorePartName");

        if v49 then
            local v50 = p48:FindFirstChild(v49);
            local v51 = v50 and game.ServerStorage:FindFirstChild("Collect_PROX_Grape");

            if v51 then
                local v52 = v51:Clone();
                v52.Name = "ProximityPrompt";
                v52.Parent = v50;
            end;
        end;

        p48:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Grape",
        Harvestable = true
    }
};