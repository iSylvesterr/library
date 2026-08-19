-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        GrowRate = 0.007,
        BaseWeight = 1.5,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(u1, p2, p3) -- Line: 8, Name: InitFruit
        local v4 = Random.new(p2);
        local PrimaryPart = u1.PrimaryPart;
        local u5 = (p3 or 1) * 0.75;
        local u6 = v4:NextInteger(3, 4);
        local u7 = 2 * u5;
        local u8 = v4:NextInteger(40, 50);
        local u9 = v4:NextInteger(65, 75);
        local u10 = v4:NextInteger(10, 20);
        local u11 = 0;
        local u12 = 0;

        local function generateRing(p13) -- Line: 26
            -- upvalues: u6 (copy), u9 (copy), u10 (copy), u8 (copy), u11 (ref), u12 (ref), u5 (ref), PrimaryPart (copy), u7 (copy), u1 (copy)
            local v14 = (p13 - 1) / math.max(u6 - 1, 1);
            local v15 = u9 + (u10 - u9) * v14;
            local v16 = (p13 - 1) * u8;
            u11 = u11 + 1;
            u12 = u12 + 0.02;
            local v17 = Color3.fromHSV(0.8 - u12, 0.580392, 1);

            for i = 0, 3 do
                local v18 = script.Leaf:Clone();
                v18.Name = tostring(u11);
                v18.Size = Vector3.new(1 * u5, 5 * u5, 5 * u5);
                v18.CFrame = PrimaryPart.CFrame * CFrame.Angles(0, math.rad(i * 90 + v16), 0) * CFrame.new(0, 0, -u7) * CFrame.Angles(math.rad(v15 - 90), 0, 0) * CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.new(0, v18.Size.Y / 2, 0);
                v18.Color = v17;
                v18.Parent = u1;
            end;
        end;

        generateRing(1);
        local v19 = v4:NextInteger(3, 5);
        local v20 = 4 * u5;

        for _ = 1, v19 do
            local v21 = script.Stud_Part:Clone();
            v21.Size = Vector3.new(v20, v20, v20);
            v21.Material = Enum.Material.Neon;
            v21.Shape = Enum.PartType.Ball;
            v21.CFrame = PrimaryPart.CFrame * CFrame.new(0, v21.Size.Y / 3 + PrimaryPart.Size.Y / 2, 0);
            v21.Transparency = 0.75;
            u11 = u11 + 1;
            v21.Name = tostring(u11);
            v21.Parent = u1;
            v20 = v20 * 1.075;
        end;

        for i = 2, u6 do
            generateRing(i);
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u22) -- Line: 84, Name: BeginFruitGrowth
        local PrimaryPart = u22.PrimaryPart;
        local u23 = {};

        for _, v in u22:QueryDescendants("BasePart") do
            local v24 = tonumber(v.Name);

            if v24 then
                local v25 = not v:GetAttribute("DontShow");
                local v26 = PrimaryPart.CFrame:ToObjectSpace(v.CFrame);
                local v27 = v26 * CFrame.new(0, -v.Size.Y / 2, 0);
                local v28 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Texture") or child:IsA("Decal") then
                        table.insert(v28, {
                            instance = child,
                            originalTransparency = child.Transparency
                        });

                        if v25 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v29 = v:GetAttribute("OG_Transparency");

                if v29 == nil then
                    v29 = v.Transparency;
                end;

                local v30 = v.Material == Enum.Material.Neon and 0.5 or v29;
                v:SetAttribute("OG_Transparency", v30);
                table.insert(u23, {
                    part = v,
                    maxSizeY = v.Size.Y,
                    fullSize = v.Size,
                    bottomCF = v27,
                    rotation = v26.Rotation,
                    partAge = v24,
                    originalTransparency = v30,
                    textures = v28
                });
                v.CanCollide = false;

                if v25 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 133
            -- upvalues: u22 (copy), u23 (copy), PrimaryPart (copy)
            local v31 = u22:GetAttribute("Age") or 0;
            local v32 = u22:GetAttribute("MaxAge") or 1;
            local v33 = v31 / v32;

            for _, v in u23 do
                if not v.part:GetAttribute("DontShow") then
                    local v34 = math.clamp((v33 - v.partAge / v32) * v32, 0, 1);

                    if v34 ~= v.lastProgress then
                        v.lastProgress = v34;

                        if v34 > 0 then
                            local v35 = v.maxSizeY * v34;
                            v.part.Size = Vector3.new(v.fullSize.X, v35, v.fullSize.Z);
                            local v36 = v.bottomCF * CFrame.new(0, v35 / 2, 0);
                            v.part.CFrame = PrimaryPart.CFrame * CFrame.new(v36.Position) * v.rotation;
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

        u22:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p37) -- Line: 171, Name: OnFullyGrown
        local v38 = p37:GetAttribute("CorePartName");

        if v38 then
            local v39 = p37:FindFirstChild(v38);
            local v40 = v39 and game.ServerStorage:FindFirstChild("Collect_PROX_Flower");

            if v40 then
                local v41 = v40:Clone();
                v41.Name = "ProximityPrompt";
                v41.Parent = v39;
            end;
        end;

        p37:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Sunflower",
        Harvestable = true
    }
};