-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        GrowRate = 0.2308,
        BaseWeight = 1.15,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(p1, p2, p3) -- Line: 8, Name: InitFruit
        Random.new(p2);
        local v4 = p3 * 0.5 + 0.5;
        local v5 = script.Blueberry:Clone();
        v5:PivotTo(p1.PrimaryPart.CFrame);
        v5:ScaleTo(v4 + v4 ^ 3 * 0.00001);
        v5.PrimaryPart = nil;

        for _, child in pairs(v5:GetChildren()) do
            if child:IsA("BasePart") then
                child:AddTag("Blue");
                child.Parent = p1;
            end;
        end;

        p1:SetAttribute("CorePartName", "Blueberry");
        p1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u6) -- Line: 30, Name: BeginFruitGrowth
        local PrimaryPart = u6.PrimaryPart;
        local u7 = {};

        for _, v in u6:QueryDescendants("BasePart") do
            local v8 = tonumber(v.Name);

            if v8 then
                local v9 = not v:GetAttribute("DontShow");
                local v10 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v8
                };
                table.insert(u7, v10);
                v.CanCollide = false;

                if v9 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 53
            -- upvalues: u6 (copy), u7 (copy), PrimaryPart (copy)
            local v11 = u6:GetAttribute("Age") or 0;
            local v12 = u6:GetAttribute("MaxAge") or 1;
            local v13 = v11 / v12;

            for _, v in u7 do
                if not v.part:GetAttribute("DontShow") then
                    local v14 = math.clamp((v13 - v.partAge / v12) * v12, 0, 1);

                    if v14 ~= v.lastProgress then
                        v.lastProgress = v14;

                        if v14 > 0 then
                            local v15 = v.maxSize * v14;
                            v.part.Size = v15;
                            local v16 = v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v15.Y) / 2), 0);
                            v.part.CFrame = PrimaryPart.CFrame * v16;
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

        u6:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p17) -- Line: 97, Name: OnFullyGrown
        local v18 = p17:GetAttribute("CorePartName");

        if v18 then
            local v19 = p17:FindFirstChild(v18);
            local v20 = v19 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v20 then
                local v21 = v20:Clone();
                v21.Name = "ProximityPrompt";
                v21.Parent = v19;
            end;
        end;

        p17:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Apple",
        Harvestable = true
    }
};