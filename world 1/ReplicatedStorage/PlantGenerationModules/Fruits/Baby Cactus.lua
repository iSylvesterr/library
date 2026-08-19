-- Decompiled with Potassium's decompiler.

game:GetService("MaterialService");

return {
    GrowData = {
        GrowRate = 0.4067,
        BaseWeight = 1.5,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(p1, p2, p3) -- Line: 13, Name: InitFruit
        local u4 = Random.new(p2);
        local _ = p3 * 0.2;
        local v5 = p1.Base:GetPivot();

        local function GetRandomHSV(p6, p7) -- Line: 22
            -- upvalues: u4 (copy)
            local v8, v9, v10 = p6:ToHSV();
            local v11 = p7 or 0.05;
            local v12 = (v8 + u4:NextNumber(-v11, v11)) % 1;

            return Color3.fromHSV(v12, math.clamp(v9, 0, 1), (math.clamp(v10, 0, 1))), v12, v9, v10;
        end;

        local function ApplyColorKeepBrightness(p13, p14, p15) -- Line: 30
            local v16 = p15 or 1;

            if p13:IsA("BasePart") then
                local _, _, v17 = p13.Color:ToHSV();
                local v18, v19 = p14:ToHSV();
                p13.Color = Color3.fromHSV(v18, v19 * v16, v17);
            end;
        end;

        local v20 = {
            Color3.fromRGB(254, 98, 165),
            Color3.fromRGB(160, 93, 254),
            Color3.fromRGB(254, 146, 92),
            Color3.fromRGB(108, 254, 225)
        };
        local v21, v22, v23 = v20[u4:NextInteger(1, #v20)]:ToHSV();
        local v24 = 0.1 or 0.05;
        local v25 = (v21 + u4:NextNumber(-v24, v24)) % 1;
        local v26 = Color3.fromHSV(v25, math.clamp(v22, 0, 1), (math.clamp(v23, 0, 1)));
        local v27 = u4:NextInteger(5, 9);

        for i = 1, v27 do
            local v28 = script.Petal:Clone();
            v28:ScaleTo(u4:NextNumber(1.2, 1.5));
            local Angles = CFrame.Angles;
            local v29 = u4:NextInteger(-3, 3);
            local v30 = math.rad(v29);
            local v31 = 360 / v27 * i + u4:NextInteger(-9, 9);
            local v32 = math.rad(v31);
            local v33 = u4:NextInteger(-15, -10);
            v28:PivotTo(v5 * Angles(v30, v32, (math.rad(v33))));

            for _, child in v28:GetChildren() do
                child.Name = tonumber(child.Name) + i;
                local v34 = nil or 1;

                if child:IsA("BasePart") then
                    local _, _, v35 = child.Color:ToHSV();
                    local v36, v37 = v26:ToHSV();
                    child.Color = Color3.fromHSV(v36, v37 * v34, v35);
                end;

                child.Parent = p1;
            end;

            v28:Destroy();
        end;

        local v38 = u4:NextInteger(3, 6);

        for i = 1, v38 do
            local v39 = script.Petal:Clone();
            v39:ScaleTo(u4:NextNumber(0.94, 1.2));
            local Angles = CFrame.Angles;
            local v40 = u4:NextInteger(-3, 3);
            local v41 = math.rad(v40);
            local v42 = 360 / v38 * i + u4:NextInteger(-9, 9);
            local v43 = math.rad(v42);
            local v44 = u4:NextInteger(-50, -40);
            v39:PivotTo(v5 * Angles(v41, v43, (math.rad(v44))));

            for _, child in v39:GetChildren() do
                child.Name = tonumber(child.Name) + i;
                local v45 = nil or 1;

                if child:IsA("BasePart") then
                    local _, _, v46 = child.Color:ToHSV();
                    local v47, v48 = v26:ToHSV();
                    child.Color = Color3.fromHSV(v47, v48 * v45, v46);
                end;

                child.Parent = p1;
            end;

            v39:Destroy();
        end;

        p1:ScaleTo(p3);
        p1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u49) -- Line: 104, Name: BeginFruitGrowth
        local PrimaryPart = u49.PrimaryPart;
        local u50 = {};

        for _, v in u49:QueryDescendants("BasePart") do
            local v51 = tonumber(v.Name);

            if v51 then
                local v52 = not v:GetAttribute("DontShow");
                local v53 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v51
                };
                table.insert(u50, v53);
                v.CanCollide = false;

                if v52 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 125
            -- upvalues: u49 (copy), u50 (copy), PrimaryPart (copy)
            local v54 = u49:GetAttribute("Age") or 0;
            local v55 = u49:GetAttribute("MaxAge") or 1;
            local v56 = v54 / v55;

            for _, v in u50 do
                if not v.part:GetAttribute("DontShow") then
                    local v57 = math.clamp((v56 - v.partAge / v55) * v55, 0, 1);

                    if v57 ~= v.lastProgress then
                        v.lastProgress = v57;

                        if v57 > 0 then
                            local v58 = v.maxSize * v57;
                            v.part.Size = v58;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v58.Y) / 2), 0);
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

        u49:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p59) -- Line: 161, Name: OnFullyGrown
        local v60 = p59:GetAttribute("CorePartName");

        if v60 then
            local v61 = p59:FindFirstChild(v60);
            local v62 = v61 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v62 then
                local v63 = v62:Clone();
                v63.Name = "ProximityPrompt";
                v63.Parent = v61;
            end;
        end;

        p59:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Acorn",
        Harvestable = true
    }
};