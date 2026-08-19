-- Decompiled with Potassium's decompiler.

game:GetService("MaterialService");

return {
    GrowData = {
        GrowRate = 0.0088,
        BaseWeight = 7.5,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(p1, p2, p3) -- Line: 13, Name: InitFruit
        local u4 = Random.new(p2);
        local _ = p3 * 0.2;

        local function GetRandomHSV(p5, p6) -- Line: 19
            -- upvalues: u4 (copy)
            local v7, v8, v9 = p5:ToHSV();
            local v10 = p6 or 0.05;
            local v11 = (v7 + u4:NextNumber(-v10, v10)) % 1;

            return Color3.fromHSV(v11, math.clamp(v8, 0, 1), (math.clamp(v9, 0, 1))), v11, v8, v9;
        end;

        local v12 = p3 * 0.75;
        local v13 = 0;

        for _, child in ipairs(p1.whole:GetChildren()) do
            if child:IsA("BasePart") and child.Name == "3" then
                local Y = child.Size.Y;
                local v14 = Y * v12;
                local v15 = v14 - Y;
                child.Size = Vector3.new(child.Size.X, v14, child.Size.Z);
                child.CFrame = child.CFrame * CFrame.new(0, v15 / 2, 0);
                v13 = v13 + v15;
            end;
        end;

        p1.whole:FindFirstChild("Top"):PivotTo(p1.whole:WaitForChild("3"):GetPivot() * CFrame.new(0, p1.whole["3"].Size.Y / 2, 0));

        for _, descendant in p1.whole:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Parent = p1;
            end;
        end;

        p1.whole:Destroy();
        p1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u16) -- Line: 56, Name: BeginFruitGrowth
        local PrimaryPart = u16.PrimaryPart;
        local u17 = {};

        for _, v in u16:QueryDescendants("BasePart") do
            local v18 = tonumber(v.Name);

            if v18 then
                local v19 = not v:GetAttribute("DontShow");
                local v20 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v18
                };
                table.insert(u17, v20);
                v.CanCollide = false;

                if v19 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 77
            -- upvalues: u16 (copy), u17 (copy), PrimaryPart (copy)
            local v21 = u16:GetAttribute("Age") or 0;
            local v22 = u16:GetAttribute("MaxAge") or 1;
            local v23 = v21 / v22;

            for _, v in u17 do
                if not v.part:GetAttribute("DontShow") then
                    local v24 = math.clamp((v23 - v.partAge / v22) * v22, 0, 1);

                    if v24 ~= v.lastProgress then
                        v.lastProgress = v24;

                        if v24 > 0 then
                            local v25 = v.maxSize * v24;
                            v.part.Size = v25;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v25.Y) / 2), 0);
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

        u16:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p26) -- Line: 113, Name: OnFullyGrown
        local v27 = p26:GetAttribute("CorePartName");

        if v27 then
            local v28 = p26:FindFirstChild(v27);
            local v29 = v28 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v29 then
                local v30 = v29:Clone();
                v30.Name = "ProximityPrompt";
                v30.Parent = v28;
            end;
        end;

        p26:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Acorn",
        Harvestable = true
    }
};