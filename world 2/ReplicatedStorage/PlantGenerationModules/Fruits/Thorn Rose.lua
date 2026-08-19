-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        GrowRate = 0.5,
        BaseWeight = 1.5,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(p1, p2, p3) -- Line: 9, Name: InitFruit
        p1:ScaleTo(p3);
        p1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u4) -- Line: 16, Name: BeginFruitGrowth
        local PrimaryPart = u4.PrimaryPart;
        local u5 = {};

        for _, v in u4:QueryDescendants("BasePart") do
            local v6 = tonumber(v.Name);

            if v6 then
                local v7 = not v:GetAttribute("DontShow");
                local v8 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v6
                };
                table.insert(u5, v8);
                v.CanCollide = false;

                if v7 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 37
            -- upvalues: u4 (copy), u5 (copy), PrimaryPart (copy)
            local v9 = u4:GetAttribute("Age") or 0;
            local v10 = u4:GetAttribute("MaxAge") or 1;
            local v11 = v9 / v10;

            for _, v in u5 do
                if not v.part:GetAttribute("DontShow") then
                    local v12 = math.clamp((v11 - v.partAge / v10) * v10, 0, 1);

                    if v12 ~= v.lastProgress then
                        v.lastProgress = v12;

                        if v12 > 0 then
                            local v13 = v.maxSize * v12;
                            v.part.Size = v13;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v13.Y) / 2), 0);
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

        u4:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p14) -- Line: 73, Name: OnFullyGrown
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
        FruitType = "Thorn Rose",
        Harvestable = true
    }
};