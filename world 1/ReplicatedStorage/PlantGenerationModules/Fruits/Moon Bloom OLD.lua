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
        local PrimaryPart = p1.PrimaryPart;

        local function GetRandomHSV(p5, p6) -- Line: 21
            -- upvalues: u4 (copy)
            local v7, v8, v9 = p5:ToHSV();
            local v10 = p6 or 0.05;
            local v11 = (v7 + u4:NextNumber(-v10, v10)) % 1;

            return Color3.fromHSV(v11, math.clamp(v8, 0, 1), (math.clamp(v9, 0, 1))), v11, v8, v9;
        end;

        local v12 = u4:NextNumber(3, 4);

        for i = 1, v12 do
            local v13 = script.Layer1:Clone();
            local v14 = PrimaryPart:GetPivot();
            local Angles = CFrame.Angles;
            local v15 = 360 / v12 * i + u4:NextInteger(-15, 15);
            local v16 = v14 * Angles(0, math.rad(v15), 0);
            local Angles2 = CFrame.Angles;
            local v17 = 177 + u4:NextInteger(-4, 4);
            v13:PivotTo(v16 * Angles2(math.rad(v17), 0, 0));
            local v18 = v13["1"];
            v13:ScaleTo(u4:NextNumber(0.9, 1.1));
            v18.Name = tonumber(v18.Name) + i;
            v18.Parent = p1;
            v13:Destroy();
        end;

        local v19 = u4:NextNumber(4, 5);

        for i = 1, v19 do
            local v20 = script.Layer2:Clone();
            local v21 = PrimaryPart:GetPivot();
            local Angles = CFrame.Angles;
            local v22 = 360 / v19 * i + u4:NextInteger(-15, 15);
            local v23 = v21 * Angles(0, math.rad(v22), 0);
            local Angles2 = CFrame.Angles;
            local v24 = 190 + u4:NextInteger(-4, 4);
            v20:PivotTo(v23 * Angles2(math.rad(v24), 0, 0));
            local v25 = v20["1"];
            v20:ScaleTo(u4:NextNumber(0.9, 1.1));
            v25.Name = tonumber(v25.Name) + i + 1;
            v25.Parent = p1;
            v20:Destroy();
        end;

        local v26 = u4:NextNumber(5, 6);

        for i = 1, v26 do
            local v27 = script.Layer3:Clone();
            local v28 = PrimaryPart:GetPivot();
            local Angles = CFrame.Angles;
            local v29 = 360 / v26 * i + u4:NextInteger(-15, 15);
            local v30 = v28 * Angles(0, math.rad(v29), 0);
            local Angles2 = CFrame.Angles;
            local v31 = 205 + u4:NextInteger(-4, 4);
            v27:PivotTo(v30 * Angles2(math.rad(v31), 0, 0));
            local v32 = v27["1"];
            v27:ScaleTo(u4:NextNumber(0.9, 1.1));
            v32.Name = tonumber(v32.Name) + i + 2;
            v32.Parent = p1;
            v27:Destroy();
        end;

        local v33 = u4:NextNumber(3, 4);

        for i = 1, v33 do
            local v34 = script.Layer4:Clone();
            local v35 = PrimaryPart:GetPivot();
            local Angles = CFrame.Angles;
            local v36 = 360 / v33 * i + u4:NextInteger(-15, 15);
            local v37 = v35 * Angles(0, math.rad(v36), 0);
            local Angles2 = CFrame.Angles;
            local v38 = 236 + u4:NextInteger(-4, 4);
            v34:PivotTo(v37 * Angles2(math.rad(v38), 0, 0));
            local v39 = v34["1"];
            v34:ScaleTo(u4:NextNumber(0.8, 1));
            v39.Name = tonumber(v39.Name) + i + 3;
            v39.Parent = p1;
            v34:Destroy();
        end;

        local v40 = u4:NextNumber(3, 4);

        for i = 1, v40 do
            local v41 = script.Layer5:Clone();
            local v42 = PrimaryPart:GetPivot();
            local Angles = CFrame.Angles;
            local v43 = 360 / v40 * i + u4:NextInteger(-15, 15);
            local v44 = v42 * Angles(0, math.rad(v43), 0);
            local Angles2 = CFrame.Angles;
            local v45 = 255 + u4:NextInteger(-4, 4);
            v41:PivotTo(v44 * Angles2(math.rad(v45), 0, 0));
            local v46 = v41["1"];
            v41:ScaleTo(u4:NextNumber(0.8, 1));
            v46.Name = tonumber(v46.Name) + i + 4;
            v46.Parent = p1;
            v41:Destroy();
        end;

        p1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u47) -- Line: 117, Name: BeginFruitGrowth
        local PrimaryPart = u47.PrimaryPart;
        local u48 = {};

        for _, v in u47:QueryDescendants("BasePart") do
            local v49 = tonumber(v.Name);

            if v49 then
                local v50 = not v:GetAttribute("DontShow");
                local v51 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v51, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v50 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v52 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v49,
                    decals = v51
                };
                table.insert(u48, v52);
                v.CanCollide = false;

                if v50 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 152
            -- upvalues: u47 (copy), u48 (copy), PrimaryPart (copy)
            local v53 = u47:GetAttribute("Age") or 0;
            local v54 = u47:GetAttribute("MaxAge") or 1;
            local v55 = v53 / v54;

            for _, v in u48 do
                if not v.part:GetAttribute("DontShow") then
                    local v56 = math.clamp((v55 - v.partAge / v54) * v54, 0, 1);

                    if v56 ~= v.lastProgress then
                        v.lastProgress = v56;

                        if v56 > 0 then
                            local v57 = v.maxSize * v56;
                            v.part.Size = v57;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v57.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v56);
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

        u47:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p58) -- Line: 191, Name: OnFullyGrown
        local v59 = p58:GetAttribute("CorePartName");

        if v59 then
            local v60 = p58:FindFirstChild(v59);
            local v61 = v60 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v61 then
                local v62 = v61:Clone();
                v62.Name = "ProximityPrompt";
                v62.Parent = v60;
            end;
        end;

        p58:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Acorn",
        Harvestable = true
    }
};