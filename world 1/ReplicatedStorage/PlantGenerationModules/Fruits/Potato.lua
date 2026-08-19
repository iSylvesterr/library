-- Decompiled with Potassium's decompiler.

game:GetService("MaterialService");

return {
    GrowData = {
        GrowRate = 0.0333,
        BaseWeight = 1.125,
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

        local v12 = u4:NextNumber(0.1, 0.35) * (p3 * 0.45);

        while u4:NextInteger(1, 7) == 1 do
            v12 = v12 + 0.12;
        end;

        local v13 = v12 / 2;

        for _, child in p1:GetChildren() do
            if tonumber(child.Name) and child.Name ~= "1" then
                child.Size = child.Size + Vector3.new(0, v12, 0);
                child:PivotTo(child.CFrame * CFrame.new(0, v13, 0));
            end;
        end;

        p1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u14) -- Line: 42, Name: BeginFruitGrowth
        local PrimaryPart = u14.PrimaryPart;
        local u15 = {};

        for _, v in u14:QueryDescendants("BasePart") do
            local v16 = tonumber(v.Name);

            if v16 then
                local v17 = not v:GetAttribute("DontShow");
                local v18 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v16
                };
                table.insert(u15, v18);
                v.CanCollide = false;

                if v17 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 63
            -- upvalues: u14 (copy), u15 (copy), PrimaryPart (copy)
            local v19 = u14:GetAttribute("Age") or 0;
            local v20 = u14:GetAttribute("MaxAge") or 1;
            local v21 = v19 / v20;

            for _, v in u15 do
                if not v.part:GetAttribute("DontShow") then
                    local v22 = math.clamp((v21 - v.partAge / v20) * v20, 0, 1);

                    if v22 ~= v.lastProgress then
                        v.lastProgress = v22;

                        if v22 > 0 then
                            local v23 = v.maxSize * v22;
                            v.part.Size = v23;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v23.Y) / 2), 0);
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

        u14:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p24) -- Line: 99, Name: OnFullyGrown
        local v25 = p24:GetAttribute("CorePartName");

        if v25 then
            local v26 = p24:FindFirstChild(v25);
            local v27 = v26 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v27 then
                local v28 = v27:Clone();
                v28.Name = "ProximityPrompt";
                v28.Parent = v26;
            end;
        end;

        p24:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Acorn",
        Harvestable = true
    }
};