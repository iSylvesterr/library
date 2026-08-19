-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        GrowRate = 0.3,
        BaseWeight = 1,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(p1, p2, p3) -- Line: 8, Name: InitFruit
        Random.new(p2);
        local v4 = p3 * 0.5 + 0.5;
        local v5 = v4 + v4 ^ 3 * 1e-6;
        local v6 = script.Strawberry:Clone();
        local CFrame2 = v6.PrimaryPart.CFrame;
        local CFrame3 = p1.PrimaryPart.CFrame;

        for _, child in v6:GetChildren() do
            if child:IsA("BasePart") then
                child.CFrame = CFrame3 * CFrame2:ToObjectSpace(child.CFrame);
            end;
        end;

        local PrimaryPart = p1.PrimaryPart;
        v6.PrimaryPart:Destroy();

        for _, child in pairs(v6:GetChildren()) do
            if child:IsA("BasePart") then
                if child.BrickColor == BrickColor.new("Really red") then
                    child:AddTag("Red");
                end;

                child.Parent = p1;
            end;
        end;

        if v5 ~= 1 then
            local CFrame4 = PrimaryPart.CFrame;

            for _, v in p1:QueryDescendants("BasePart") do
                v.Size = v.Size * v5;
                local v7 = CFrame4:ToObjectSpace(v.CFrame);
                v.CFrame = CFrame4 * CFrame.new(v7.Position * v5) * v7.Rotation;
            end;
        end;

        p1:SetAttribute("CorePartName", "Strawberry");
        p1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u8) -- Line: 57, Name: BeginFruitGrowth
        local PrimaryPart = u8.PrimaryPart;
        local u9 = {};

        for _, v in u8:QueryDescendants("BasePart") do
            local v10 = tonumber(v.Name);

            if v10 then
                local v11 = not v:GetAttribute("DontShow");
                local v12 = {};

                for _, descendant in v:GetDescendants() do
                    if descendant:IsA("Decal") then
                        table.insert(v12, descendant);
                        descendant.Transparency = 1;
                    elseif descendant:IsA("ImageLabel") then
                        table.insert(v12, descendant);
                        descendant.ImageTransparency = 1;
                    end;
                end;

                local v13 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v10,
                    decorations = v12
                };
                table.insert(u9, v13);
                v.CanCollide = false;

                if v11 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 90
            -- upvalues: u8 (copy), u9 (copy), PrimaryPart (copy)
            local v14 = u8:GetAttribute("Age") or 0;
            local v15 = u8:GetAttribute("MaxAge") or 1;
            local v16 = v14 / v15;

            for _, v in u9 do
                if not v.part:GetAttribute("DontShow") then
                    local v17 = math.clamp((v16 - v.partAge / v15) * v15, 0, 1);

                    if v17 ~= v.lastProgress then
                        v.lastProgress = v17;

                        if v17 > 0 then
                            local v18 = v.maxSize * v17;
                            v.part.Size = v18;
                            local v19 = v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v18.Y) / 2), 0);
                            v.part.CFrame = PrimaryPart.CFrame * v19;
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;
                        else
                            v.part.Transparency = 1;
                            v.part.CanCollide = false;
                        end;

                        local v20 = v17 >= 1 and 0 or 1;

                        for _, v2 in v.decorations do
                            if v2:IsA("Decal") then
                                v2.Transparency = v20;
                            else
                                v2.ImageTransparency = v20;
                            end;
                        end;
                    end;
                end;
            end;
        end;

        u8:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p21) -- Line: 136, Name: OnFullyGrown
        local v22 = p21:GetAttribute("CorePartName");

        if v22 then
            local v23 = p21:FindFirstChild(v22);
            local v24 = v23 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v24 then
                local v25 = v24:Clone();
                v25.Name = "ProximityPrompt";
                v25.Parent = v23;
            end;
        end;

        p21:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Apple",
        Harvestable = true
    }
};