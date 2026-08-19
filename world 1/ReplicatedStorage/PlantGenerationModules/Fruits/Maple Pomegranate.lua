-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        GrowRate = 0.0064,
        BaseWeight = 1.5,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(p1, p2, p3) -- Line: 9, Name: InitFruit
        Random.new(p2);
        local Base = p1.Base;
        local v4 = (p3 or 1) * 0.5;

        if v4 ~= 1 then
            local CFrame2 = Base.CFrame;

            for _, v in p1:QueryDescendants("BasePart") do
                v.Size = v.Size * v4;
                local v5 = CFrame2:ToObjectSpace(v.CFrame);
                v.CFrame = CFrame2 * CFrame.new(v5.Position * v4) * v5.Rotation;
            end;
        end;

        p1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u6) -- Line: 33, Name: BeginFruitGrowth
        local PrimaryPart = u6.PrimaryPart;
        local u7 = {};

        for _, v in u6:QueryDescendants("BasePart") do
            local v8 = tonumber(v.Name);

            if v8 then
                local v9 = not v:GetAttribute("DontShow");
                local v10 = PrimaryPart.CFrame:ToObjectSpace(v.CFrame);
                local v11 = v10 * CFrame.new(0, -v.Size.Y / 2, 0);
                local v12 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Texture") or child:IsA("Decal") then
                        table.insert(v12, {
                            obj = child,
                            ogTransparency = child.Transparency
                        });
                    end;
                end;

                table.insert(u7, {
                    part = v,
                    maxSizeY = v.Size.Y,
                    fullSize = v.Size,
                    bottomCF = v11,
                    rotation = v10.Rotation,
                    partAge = v8,
                    textures = v12
                });
                v.CanCollide = false;

                if v9 then
                    v.Transparency = 1;

                    for _, v2 in v12 do
                        v2.obj.Transparency = 1;
                    end;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 72
            -- upvalues: u6 (copy), u7 (copy), PrimaryPart (copy)
            local v13 = u6:GetAttribute("Age") or 0;
            local v14 = u6:GetAttribute("MaxAge") or 1;
            local v15 = v13 / v14;

            for _, v in u7 do
                if not v.part:GetAttribute("DontShow") then
                    local v16 = math.clamp((v15 - v.partAge / v14) * v14, 0, 1);

                    if v16 ~= v.lastProgress then
                        v.lastProgress = v16;

                        if v16 > 0 then
                            local v17 = v.maxSizeY * v16;
                            v.part.Size = Vector3.new(v.fullSize.X, v17, v.fullSize.Z);
                            local v18 = v.bottomCF * CFrame.new(0, v17 / 2, 0);
                            v.part.CFrame = PrimaryPart.CFrame * CFrame.new(v18.Position) * v.rotation;
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            for _, v2 in v.textures do
                                v2.obj.Transparency = v2.ogTransparency;
                            end;
                        else
                            v.part.Transparency = 1;
                            v.part.CanCollide = false;

                            for _, v2 in v.textures do
                                v2.obj.Transparency = 1;
                            end;
                        end;
                    end;
                end;
            end;
        end;

        u6:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p19) -- Line: 109, Name: OnFullyGrown
        local v20 = p19:GetAttribute("CorePartName");

        if v20 then
            local v21 = p19:FindFirstChild(v20);
            local v22 = v21 and game.ServerStorage:FindFirstChild("Collect_PROX_Flower");

            if v22 then
                local v23 = v22:Clone();
                v23.Name = "ProximityPrompt";
                v23.Parent = v21;
            end;
        end;

        p19:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Pomegranate",
        Harvestable = true
    }
};