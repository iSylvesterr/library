-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        GrowRate = 0.0333,
        BaseWeight = 1.5,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(p1, p2, p3) -- Line: 9, Name: InitFruit
        Random.new(p2);
        local v4 = p1.PrimaryPart or p1.Part;
        local CFrame2 = v4.CFrame;

        for _, v in ipairs(p1:QueryDescendants("BasePart, DataModelMesh")) do
            if v:IsA("BasePart") then
                v.Size = v.Size * p3;

                if v ~= v4 then
                    local v5 = CFrame2:ToObjectSpace(v.CFrame);
                    v.CFrame = CFrame2 * (CFrame.new(v5.Position * p3) * (v5 - v5.Position));
                end;
            elseif v:IsA("SpecialMesh") or v:IsA("DataModelMesh") then
                v.Scale = v.Scale * p3;
            end;
        end;

        for _, v in ipairs(p1:QueryDescendants("Attachment")) do
            v.Position = v.Position * p3;
        end;

        p1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u6) -- Line: 39, Name: BeginFruitGrowth
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

        local function updateGrowth() -- Line: 62
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
                            v.part.Size = v.maxSize * v14;
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

        u6:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p15) -- Line: 95, Name: OnFullyGrown
        local v16 = p15:GetAttribute("CorePartName");

        if v16 then
            local v17 = p15:FindFirstChild(v16);
            local v18 = v17 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v18 then
                local v19 = v18:Clone();
                v19.Name = "ProximityPrompt";
                v19.Parent = v17;
            end;
        end;

        p15:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Apple",
        Harvestable = true
    }
};