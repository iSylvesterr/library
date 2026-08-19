-- Decompiled with Potassium's decompiler.

game:GetService("MaterialService");

return {
    GrowData = {
        GrowRate = 0.0413,
        BaseWeight = 1.5,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(u1, p2, p3) -- Line: 13, Name: InitFruit
        local u4 = Random.new(p2);
        local _ = p3 * 0.2;

        local function GetRandomHSV(p5, p6) -- Line: 19
            -- upvalues: u4 (copy)
            local v7, v8, v9 = p5:ToHSV();
            local v10 = p6 or 0.05;
            local v11 = (v7 + u4:NextNumber(-v10, v10)) % 1;

            return Color3.fromHSV(v11, math.clamp(v8, 0, 1), (math.clamp(v9, 0, 1))), v11, v8, v9;
        end;

        local v12 = {
            Color3.fromRGB(255, 237, 38),
            Color3.fromRGB(255, 201, 24),
            Color3.fromRGB(228, 255, 92),
            Color3.fromRGB(255, 219, 75),
            Color3.fromRGB(255, 234, 0)
        };
        local v13 = v12[math.random(1, #v12)];
        local v14 = v12[math.random(1, #v12)];
        local u15 = nil;

        while v13 == v14 do
            v14 = v12[math.random(1, #v12)];
        end;

        local function generateTrunk(p16, p17) -- Line: 46
            -- upvalues: u4 (copy), u15 (ref), u1 (copy)
            for i = 1, p17 do
                local v18 = script.Part:Clone();
                local v19 = (i - 1) / math.max(p17 - 1, 1) * 3.141592653589793;
                local v20 = (math.sin(v19) * 0.7 + 0.30000000000000004) * 1.75;
                local v21 = math.clamp(v20, 0.15, 10) * u4:NextNumber(0.9, 1.1);
                local Angles = CFrame.Angles;
                local v22 = u4:NextNumber(5, 7);
                local v23 = math.rad(v22);
                local v24 = u4:NextNumber(-5, 5);
                local v25 = math.rad(v24);
                local v26 = u4:NextNumber(5, 7);
                local v27 = Angles(v23, v25, (math.rad(v26)));
                local v28;

                if u15 then
                    v28 = u15.Size.Y;
                    p16 = u15:GetPivot();
                else
                    v28 = 0;
                end;

                local v29 = 1 + u4:NextNumber(-0.5, 0.5);
                v18.Size = Vector3.new(v21, v29, v21);
                v18.CFrame = p16 * CFrame.new(0, v28 / 3, 0) * v27 * CFrame.new(0, v29 / 3, 0);
                v18.Name = i + 2;
                v18.Parent = u1;
                v18.Color = Color3.fromRGB(255, 247, 0);

                if i == 1 or i == p17 then
                    v18.Color = Color3.fromRGB(184, 139, 84);
                    v18.Material = Enum.Material.Glacier;
                    v18.MaterialVariant = "2022 Weld";
                else
                    local _ = (i - 2) / math.max(p17 - 1 - 2, 1);
                    v18.Color = Color3.fromRGB(255, 255, 0);
                end;

                u15 = v18;
            end;

            u15 = nil;
        end;

        local v30 = u4:NextInteger(7, 9) + p3;
        local v31 = u1.Base:GetPivot();
        local Angles = CFrame.Angles;
        local v32 = u4:NextInteger(-90, 90);
        generateTrunk(v31 * Angles(3.141592653589793, math.rad(v32), 0), v30);
        local v33 = p3 * 0.5 + 0.5;
        u1:ScaleTo(v33 + v33 ^ 3 * 0.00001);
        u1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u34) -- Line: 113, Name: BeginFruitGrowth
        local PrimaryPart = u34.PrimaryPart;
        local u35 = {};

        for _, v in u34:QueryDescendants("BasePart") do
            local v36 = tonumber(v.Name);

            if v36 then
                local v37 = not v:GetAttribute("DontShow");
                local v38 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v36
                };
                table.insert(u35, v38);
                v.CanCollide = false;

                if v37 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 134
            -- upvalues: u34 (copy), u35 (copy), PrimaryPart (copy)
            local v39 = u34:GetAttribute("Age") or 0;
            local v40 = u34:GetAttribute("MaxAge") or 1;
            local v41 = v39 / v40;

            for _, v in u35 do
                if not v.part:GetAttribute("DontShow") then
                    local v42 = math.clamp((v41 - v.partAge / v40) * v40, 0, 1);

                    if v42 ~= v.lastProgress then
                        v.lastProgress = v42;

                        if v42 > 0 then
                            local v43 = v.maxSize * v42;
                            v.part.Size = v43;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v43.Y) / 2), 0);
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

        u34:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p44) -- Line: 170, Name: OnFullyGrown
        local v45 = p44:GetAttribute("CorePartName");

        if v45 then
            local v46 = p44:FindFirstChild(v45);
            local v47 = v46 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v47 then
                local v48 = v47:Clone();
                v48.Name = "ProximityPrompt";
                v48.Parent = v46;
            end;
        end;

        p44:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Acorn",
        Harvestable = true
    }
};