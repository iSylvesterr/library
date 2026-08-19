-- Decompiled with Potassium's decompiler.

game:GetService("MaterialService");

return {
    GrowData = {
        GrowRate = 0.03,
        BaseWeight = 1.5,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(p1, p2, p3) -- Line: 13, Name: InitFruit
        local u4 = Random.new(p2);
        local _ = p3 * 0.2;
        local _ = p1.PrimaryPart;

        local function GetRandomHSV(p5, p6) -- Line: 21
            -- upvalues: u4 (copy)
            local v7, v8, v9 = p5:ToHSV();
            local v10 = p6 or 0.05;
            local v11 = (v7 + u4:NextNumber(-v10, v10)) % 1;

            return Color3.fromHSV(v11, math.clamp(v8, 0, 1), (math.clamp(v9, 0, 1))), v11, v8, v9;
        end;

        p1.Layer1:ScaleTo(u4:NextNumber(0.85, 1.15));
        p1.Layer2:ScaleTo(u4:NextNumber(0.85, 1.15));

        for _, child in p1.Layer1:GetChildren() do
            if child:IsA("BasePart") then
                local Size = child.Size;
                local v12 = u4:NextNumber(-1, 1);
                local v13 = u4:NextNumber(-1, 1);
                child.Size = Size + Vector3.new(v12, v13, u4:NextNumber(-1, 1));
                local v14 = child:GetPivot();
                local Angles = CFrame.Angles;
                local v15 = u4:NextNumber(-5, 5);
                local v16 = math.rad(v15);
                local v17 = u4:NextNumber(-5, 5);
                local v18 = math.rad(v17);
                local v19 = u4:NextNumber(-5, 5);
                child:PivotTo(v14 * Angles(v16, v18, (math.rad(v19))));
            end;
        end;

        for _, child in p1.Layer2:GetChildren() do
            if child:IsA("BasePart") then
                local Size = child.Size;
                local v20 = u4:NextNumber(-1, 1);
                local v21 = u4:NextNumber(-1, 1);
                child.Size = Size + Vector3.new(v20, v21, u4:NextNumber(-1, 1));
                local v22 = child:GetPivot();
                local Angles = CFrame.Angles;
                local v23 = u4:NextNumber(-5, 5);
                local v24 = math.rad(v23);
                local v25 = u4:NextNumber(-5, 5);
                local v26 = math.rad(v25);
                local v27 = u4:NextNumber(-5, 5);
                child:PivotTo(v22 * Angles(v24, v26, (math.rad(v27))));
            end;
        end;

        p1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u28) -- Line: 108, Name: BeginFruitGrowth
        local PrimaryPart = u28.PrimaryPart;
        local u29 = {};

        for _, v in u28:QueryDescendants("BasePart") do
            local v30 = tonumber(v.Name);

            if v30 then
                local v31 = not v:GetAttribute("DontShow");
                local v32 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v32, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v31 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v33 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v30,
                    decals = v32
                };
                table.insert(u29, v33);
                v.CanCollide = false;

                if v31 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 143
            -- upvalues: u28 (copy), u29 (copy), PrimaryPart (copy)
            local v34 = u28:GetAttribute("Age") or 0;
            local v35 = u28:GetAttribute("MaxAge") or 1;
            local v36 = v34 / v35;

            for _, v in u29 do
                if not v.part:GetAttribute("DontShow") then
                    local v37 = math.clamp((v36 - v.partAge / v35) * v35, 0, 1);

                    if v37 ~= v.lastProgress then
                        v.lastProgress = v37;

                        if v37 > 0 then
                            local v38 = v.maxSize * v37;
                            v.part.Size = v38;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v38.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v37);
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

        u28:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p39) -- Line: 182, Name: OnFullyGrown
        local v40 = p39:GetAttribute("CorePartName");

        if v40 then
            local v41 = p39:FindFirstChild(v40);
            local v42 = v41 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v42 then
                local v43 = v42:Clone();
                v43.Name = "ProximityPrompt";
                v43.Parent = v41;
            end;
        end;

        p39:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Acorn",
        Harvestable = true
    }
};