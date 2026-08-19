-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        GrowRate = 0.01,
        BaseWeight = 5,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(p1, p2, p3) -- Line: 8, Name: InitFruit
        Random.new(p2);
        local PrimaryPart = p1.PrimaryPart;
        local v4 = (p3 or 1) - 0.25;

        if v4 ~= 1 then
            local CFrame2 = PrimaryPart.CFrame;

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
                            instance = child,
                            originalTransparency = child.Transparency
                        });

                        if v9 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v13 = v:GetAttribute("OG_Transparency");

                if v13 == nil then
                    v13 = v.Transparency;
                end;

                local v14 = v.Material == Enum.Material.Neon and 0.5 or v13;
                v:SetAttribute("OG_Transparency", v14);
                table.insert(u7, {
                    part = v,
                    maxSizeY = v.Size.Y,
                    fullSize = v.Size,
                    bottomCF = v11,
                    rotation = v10.Rotation,
                    partAge = v8,
                    originalTransparency = v14,
                    textures = v12
                });
                v.CanCollide = false;

                if v9 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 82
            -- upvalues: u6 (copy), u7 (copy), PrimaryPart (copy)
            local v15 = u6:GetAttribute("Age") or 0;
            local v16 = u6:GetAttribute("MaxAge") or 1;
            local v17 = v15 / v16;

            for _, v in u7 do
                if not v.part:GetAttribute("DontShow") then
                    local v18 = math.clamp((v17 - v.partAge / v16) * v16, 0, 1);

                    if v18 ~= v.lastProgress then
                        v.lastProgress = v18;

                        if v18 > 0 then
                            local v19 = v.maxSizeY * v18;
                            v.part.Size = Vector3.new(v.fullSize.X, v19, v.fullSize.Z);
                            local v20 = v.bottomCF * CFrame.new(0, v19 / 2, 0);
                            v.part.CFrame = PrimaryPart.CFrame * CFrame.new(v20.Position) * v.rotation;
                            v.part.Transparency = v.originalTransparency;
                            v.part.CanCollide = true;

                            for _, v2 in v.textures do
                                v2.instance.Transparency = v2.originalTransparency;
                            end;
                        else
                            v.part.Transparency = 1;
                            v.part.CanCollide = false;

                            for _, v2 in v.textures do
                                v2.instance.Transparency = 1;
                            end;
                        end;
                    end;
                end;
            end;
        end;

        u6:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {
        FruitType = "Sunflower",
        Harvestable = true
    }
};