-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        GrowRate = 0.0013,
        BaseWeight = 3,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(p1, p2, p3) -- Line: 9, Name: InitFruit
        local v4 = Random.new(p2);
        p1["1"].Color = Color3.fromHSV(v4:NextInteger(70, 90) * 0.01, 0.666667, 1);
        p1:ScaleTo(p3);
        p1:SetAttribute("CorePartName", "Venus Fly Trap");
        p1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u5) -- Line: 20, Name: BeginFruitGrowth
        local PrimaryPart = u5.PrimaryPart;
        local u6 = {};

        for _, v in u5:QueryDescendants("BasePart") do
            local v7 = tonumber(v.Name);

            if v7 then
                local v8 = not v:GetAttribute("DontShow");
                local v9 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v7
                };
                table.insert(u6, v9);
                v.CanCollide = false;

                if v8 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 43
            -- upvalues: u5 (copy), u6 (copy), PrimaryPart (copy)
            local v10 = u5:GetAttribute("Age") or 0;
            local v11 = u5:GetAttribute("MaxAge") or 1;
            local v12 = v10 / v11;

            for _, v in u6 do
                if not v.part:GetAttribute("DontShow") then
                    local v13 = math.clamp((v12 - v.partAge / v11) * v11, 0, 1);

                    if v13 ~= v.lastProgress then
                        v.lastProgress = v13;

                        if v13 > 0 then
                            v.part.Size = v.maxSize * v13;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset;
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

        u5:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p14) -- Line: 76, Name: OnFullyGrown
        local v15 = p14:GetAttribute("CorePartName");

        if v15 then
            local v16 = p14:FindFirstChild(v15);
            local v17 = v16 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v17 then
                local v18 = v17:Clone();
                v18.Name = "ProximityPrompt";
                v18.Parent = v16;
            end;
        end;

        p14:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Venus Fly Trap",
        Harvestable = true
    }
};