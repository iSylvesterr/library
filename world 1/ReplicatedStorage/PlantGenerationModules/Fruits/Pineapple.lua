-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        GrowRate = 0.01,
        BaseWeight = 5,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(p1, p2, p3) -- Line: 8, Name: InitFruit
        local v4 = Random.new(p2);
        local PrimaryPart = p1.PrimaryPart;
        local v5 = (p3 or 1) - 0.25;
        p1["1"].Color = Color3.fromHSV(v4:NextInteger(125, 165) * 0.001, 1, 1);

        if v5 ~= 1 then
            local CFrame2 = PrimaryPart.CFrame;

            for _, v in p1:QueryDescendants("BasePart") do
                v.Size = v.Size * v5;
                local v6 = CFrame2:ToObjectSpace(v.CFrame);
                v.CFrame = CFrame2 * CFrame.new(v6.Position * v5) * v6.Rotation;
            end;
        end;

        p1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u7) -- Line: 33, Name: BeginFruitGrowth
        local PrimaryPart = u7.PrimaryPart;
        local u8 = {};

        for _, v in u7:QueryDescendants("BasePart") do
            local v9 = tonumber(v.Name);

            if v9 then
                local v10 = not v:GetAttribute("DontShow");
                local v11 = PrimaryPart.CFrame:ToObjectSpace(v.CFrame);
                local v12 = v11 * CFrame.new(0, -v.Size.Y / 2, 0);
                local v13 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Texture") or child:IsA("Decal") then
                        table.insert(v13, {
                            instance = child,
                            originalTransparency = child.Transparency
                        });

                        if v10 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v14 = v:GetAttribute("OG_Transparency");

                if v14 == nil then
                    v14 = v.Transparency;
                end;

                local v15 = v.Material == Enum.Material.Neon and 0.5 or v14;
                v:SetAttribute("OG_Transparency", v15);
                table.insert(u8, {
                    part = v,
                    maxSizeY = v.Size.Y,
                    fullSize = v.Size,
                    bottomCF = v12,
                    rotation = v11.Rotation,
                    partAge = v9,
                    originalTransparency = v15,
                    textures = v13
                });
                v.CanCollide = false;

                if v10 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 82
            -- upvalues: u7 (copy), u8 (copy), PrimaryPart (copy)
            local v16 = u7:GetAttribute("Age") or 0;
            local v17 = u7:GetAttribute("MaxAge") or 1;
            local v18 = v16 / v17;

            for _, v in u8 do
                if not v.part:GetAttribute("DontShow") then
                    local v19 = math.clamp((v18 - v.partAge / v17) * v17, 0, 1);

                    if v19 ~= v.lastProgress then
                        v.lastProgress = v19;

                        if v19 > 0 then
                            local v20 = v.maxSizeY * v19;
                            v.part.Size = Vector3.new(v.fullSize.X, v20, v.fullSize.Z);
                            local v21 = v.bottomCF * CFrame.new(0, v20 / 2, 0);
                            v.part.CFrame = PrimaryPart.CFrame * CFrame.new(v21.Position) * v.rotation;
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

        u7:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {
        FruitType = "Sunflower",
        Harvestable = true
    }
};