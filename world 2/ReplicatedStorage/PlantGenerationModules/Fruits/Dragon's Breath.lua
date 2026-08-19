-- Decompiled with Potassium's decompiler.

game:GetService("MaterialService");

return {
    GrowData = {
        GrowRate = 0.0078,
        BaseWeight = 7.5,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(p1, p2, p3) -- Line: 13, Name: InitFruit
        Random.new(p2);
        local _ = p1.PrimaryPart;
        local v4 = p3 * 0.2 + 0.8;
        p1:ScaleTo(v4 + v4 ^ 4 * 0.01);
        p1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u5) -- Line: 28, Name: BeginFruitGrowth
        local PrimaryPart = u5.PrimaryPart;
        local u6 = {};

        for _, v in u5:QueryDescendants("BasePart") do
            local v7 = tonumber(v.Name);

            if v7 then
                local v8 = not v:GetAttribute("DontShow");
                local v9 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v9, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v8 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v10 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v7,
                    decals = v9
                };
                table.insert(u6, v10);
                v.CanCollide = false;

                if v8 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 63
            -- upvalues: u5 (copy), u6 (copy), PrimaryPart (copy)
            local v11 = u5:GetAttribute("Age") or 0;
            local v12 = u5:GetAttribute("MaxAge") or 1;
            local v13 = v11 / v12;

            for _, v in u6 do
                if not v.part:GetAttribute("DontShow") then
                    local v14 = math.clamp((v13 - v.partAge / v12) * v12, 0, 1);

                    if v14 ~= v.lastProgress then
                        v.lastProgress = v14;

                        if v14 > 0 then
                            local v15 = v.maxSize * v14;
                            v.part.Size = v15;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v15.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v14);
                            end;
                        else
                            v.part.Transparency = 1;
                            v.part.CanCollide = false;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = 1;
                            end;
                        end;
                    end;
                end;
            end;
        end;

        u5:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p16) -- Line: 102, Name: OnFullyGrown
        local v17 = p16:GetAttribute("CorePartName");

        if v17 then
            local v18 = p16:FindFirstChild(v17);
            local v19 = v18 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v19 then
                local v20 = v19:Clone();
                v20.Name = "ProximityPrompt";
                v20.Parent = v18;
            end;
        end;

        p16:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Acorn",
        Harvestable = true
    }
};