-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        GrowRate = 0.0061,
        BaseWeight = 6,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(p1, p2, p3) -- Line: 9, Name: InitFruit
        local u4 = Random.new(p2);
        local v5 = Color3.fromRGB(237, 164, 42);
        local v6 = Color3.fromRGB(228, 143, 73);

        local function GetRandomHSV(p7, p8) -- Line: 24
            -- upvalues: u4 (copy)
            local v9, v10, v11 = p7:ToHSV();
            local v12 = p8 or 0.05;
            local v13 = v9 + u4:NextNumber(-v12, v12);
            local v14 = math.clamp(v13, 0.01, 0.99);

            return Color3.fromHSV(v14, v10, v11);
        end;

        local v15, v16, v17 = v5:ToHSV();
        local v18 = 0.02 or 0.05;
        local v19 = v15 + u4:NextNumber(-v18, v18);
        local v20 = math.clamp(v19, 0.01, 0.99);
        local v21 = Color3.fromHSV(v20, v16, v17);
        local v22, v23, v24 = v6:ToHSV();
        local v25 = 0.02 or 0.05;
        local v26 = v22 + u4:NextNumber(-v25, v25);
        local v27 = math.clamp(v26, 0.01, 0.99);
        local v28 = Color3.fromHSV(v27, v23, v24);
        local Middle = p1.Middle;
        local v29 = Middle:GetPivot();
        local Angles = CFrame.Angles;
        local v30 = u4:NextNumber(-180, 180);
        Middle:PivotTo(v29 * Angles(0, math.rad(v30), 0));
        local v31 = 0 + 1;
        Middle.Name = tostring(v31);
        local v32 = { p1:FindFirstChild("3"), p1:FindFirstChild("4") };
        local v33 = v32[2];

        for _, v in v32 do
            if v then
                local CFrame2 = v.CFrame;
                local Angles2 = CFrame.Angles;
                local v34 = u4:NextNumber(-30, 30);
                v.CFrame = CFrame2 * Angles2(0, math.rad(v34), 0);
                v31 = v31 + 1;
                v.Name = tostring(v31);
            end;
        end;

        local Petal = script.Petal;
        local v35 = u4:NextInteger(6, 8);
        local v36 = {};

        for i = 1, v35 do
            local v37 = Petal:Clone();
            local v38 = v33.CFrame * CFrame.Angles(0, math.rad(360 / v35 * i), 0);
            local Angles2 = CFrame.Angles;
            local v39 = u4:NextNumber(75, 110);
            v37:PivotTo(v38 * Angles2(math.rad(v39), 0, 0) * CFrame.new(0, v33.Size.X / 2, 0));
            local TopPetal = v37.TopPetal;
            local v40 = v37.TopPetal:GetPivot();
            local Angles3 = CFrame.Angles;
            local v41 = u4:NextNumber(-25, 25);
            TopPetal:PivotTo(v40 * Angles3(math.rad(v41), 0, 0));
            local v42 = v37:GetPivot();
            local v43 = {};

            for _, v in v37:QueryDescendants("BasePart") do
                local v44 = {
                    part = v,
                    dist = v42:ToObjectSpace(v.CFrame).Position.Magnitude
                };
                table.insert(v43, v44);
            end;

            table.sort(v43, function(p45, p46) -- Line: 91
                return p45.dist < p46.dist;
            end);

            for i2, v in v43 do
                if not v36[i2] then
                    v36[i2] = {};
                end;

                v.part.Parent = p1;
                table.insert(v36[i2], v.part);
            end;

            v37:Destroy();
        end;

        for i = 1, #v36 do
            v31 = v31 + 1;

            for _, v in v36[i] do
                v.Name = tostring(v31);
            end;
        end;

        for _, v in p1:QueryDescendants("BasePart") do
            if v.Color == Color3.fromRGB(246, 178, 10) then
                v.Color = v28;
            elseif v.Color == Color3.fromRGB(221, 126, 57) then
                v.Color = v21;
            end;

            if v.Parent ~= p1 then
                v.Parent = p1;
            end;
        end;

        local v47 = p3 * 0.5 + 0.5;
        p1:ScaleTo(v47 + v47 ^ 3 * 0.00005);
        p1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u48) -- Line: 140, Name: BeginFruitGrowth
        local PrimaryPart = u48.PrimaryPart;
        local u49 = {};

        for _, v in u48:QueryDescendants("BasePart") do
            local v50 = tonumber(v.Name);

            if v50 then
                local v51 = not v:GetAttribute("DontShow");
                local v52 = PrimaryPart.CFrame:ToObjectSpace(v.CFrame);
                local v53 = v52 * CFrame.new(0, -v.Size.Y / 2, 0);
                table.insert(u49, {
                    part = v,
                    maxSizeY = v.Size.Y,
                    fullSize = v.Size,
                    bottomCF = v53,
                    rotation = v52.Rotation,
                    partAge = v50
                });
                v.CanCollide = false;

                if v51 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 173
            -- upvalues: u48 (copy), u49 (copy), PrimaryPart (copy)
            local v54 = u48:GetAttribute("Age") or 0;
            local v55 = u48:GetAttribute("MaxAge") or 1;
            local v56 = v54 / v55;

            for _, v in u49 do
                if not v.part:GetAttribute("DontShow") then
                    local v57 = math.clamp((v56 - v.partAge / v55) * v55, 0, 1);

                    if v57 ~= v.lastProgress then
                        v.lastProgress = v57;

                        if v57 > 0 then
                            local v58 = v.maxSizeY * v57;
                            v.part.Size = Vector3.new(v.fullSize.X, v58, v.fullSize.Z);
                            local v59 = v.bottomCF * CFrame.new(0, v58 / 2, 0);
                            v.part.CFrame = PrimaryPart.CFrame * CFrame.new(v59.Position) * v.rotation;
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

        u48:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p60) -- Line: 215, Name: OnFullyGrown
        local v61 = p60:GetAttribute("CorePartName");

        if v61 then
            local v62 = p60:FindFirstChild(v61);
            local v63 = v62 and game.ServerStorage:FindFirstChild("Collect_PROX_Flower");

            if v63 then
                local v64 = v63:Clone();
                v64.Name = "ProximityPrompt";
                v64.Parent = v62;
            end;
        end;

        p60:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Sunflower",
        Harvestable = true
    }
};