-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        GrowRate = 0.0064,
        BaseWeight = 1.5,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(p1, p2, p3) -- Line: 9, Name: InitFruit
        local v4 = Random.new(p2);
        local v5 = {
            Color3.fromRGB(179, 25, 25),
            Color3.fromRGB(179, 25, 25),
            Color3.fromRGB(255, 36, 36),
            Color3.fromRGB(234, 82, 82),
            Color3.fromRGB(134, 34, 34)
        };
        local v6 = v5[v4:NextInteger(1, #v5)];
        local v7 = v5[v4:NextInteger(1, #v5)];
        p1.Stem.m1:ScaleTo(v4:NextNumber(0.8, 1.22) * p3);
        local m1 = p1.Stem.m1;
        local v8 = p1.Stem.m1:GetPivot();
        local Angles = CFrame.Angles;
        local v9 = v4:NextInteger(-25, 25);
        local v10 = math.rad(v9);
        local v11 = v4:NextInteger(-45, 45);
        local v12 = math.rad(v11);
        local v13 = v4:NextInteger(-25, 25);
        m1:PivotTo(v8 * Angles(v10, v12, (math.rad(v13))));
        p1.Stem.m1["4"].Color = v6;
        p1.Stem.m2:ScaleTo(v4:NextNumber(0.8, 1.22) * p3);
        local m2 = p1.Stem.m2;
        local v14 = p1.Stem.m2:GetPivot();
        local Angles2 = CFrame.Angles;
        local v15 = v4:NextInteger(-25, 25);
        local v16 = math.rad(v15);
        local v17 = v4:NextInteger(-45, 45);
        local v18 = math.rad(v17);
        local v19 = v4:NextInteger(-25, 25);
        m2:PivotTo(v14 * Angles2(v16, v18, (math.rad(v19))));
        p1.Stem.m2["4"].Color = v7;
        local Stem = p1.Stem;
        local v20 = p1.Stem:GetPivot();
        local Angles3 = CFrame.Angles;
        local v21 = v4:NextInteger(-33, 33);
        local v22 = math.rad(v21);
        local v23 = v4:NextInteger(-33, 33);
        local v24 = math.rad(v23);
        local v25 = v4:NextInteger(-33, 33);
        Stem:PivotTo(v20 * Angles3(v22, v24, (math.rad(v25))));
        p1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u26) -- Line: 38, Name: BeginFruitGrowth
        local PrimaryPart = u26.PrimaryPart;
        local u27 = {};

        for _, v in u26:QueryDescendants("BasePart") do
            local v28 = tonumber(v.Name);

            if v28 then
                local v29 = not v:GetAttribute("DontShow");
                local v30 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    upVector = PrimaryPart.CFrame:VectorToObjectSpace(v.CFrame.UpVector),
                    partAge = v28
                };
                table.insert(u27, v30);
                v.CanCollide = false;

                if v29 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 62
            -- upvalues: u26 (copy), u27 (copy), PrimaryPart (copy)
            local v31 = u26:GetAttribute("Age") or 0;
            local v32 = u26:GetAttribute("MaxAge") or 1;
            local v33 = v31 / v32;

            for _, v in u27 do
                if not v.part:GetAttribute("DontShow") then
                    local v34 = math.clamp((v33 - (v.partAge - 1) / v32) * v32, 0, 1);

                    if v34 ~= v.lastProgress then
                        v.lastProgress = v34;

                        if v34 > 0 then
                            v.part.Size = v.maxSize * v34;
                            local v35 = v.part:GetAttribute("GrowUp") and -1 or 1;
                            v.part.CFrame = PrimaryPart.CFrame * (v.centerOffset + v.upVector * (v.maxSize.Y / 2 * (1 - v34)) * v35);
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

        u26:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p36) -- Line: 99, Name: OnFullyGrown
        local v37 = p36:GetAttribute("CorePartName");

        if v37 then
            local v38 = p36:FindFirstChild(v37);
            local v39 = v38 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v39 then
                local v40 = v39:Clone();
                v40.Name = "ProximityPrompt";
                v40.Parent = v38;
            end;
        end;

        p36:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Cherry",
        Harvestable = true
    }
};