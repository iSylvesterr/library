-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        GrowRate = 0.031,
        BaseWeight = 3,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(u1, p2, p3) -- Line: 8, Name: InitFruit
        local v4 = Random.new(p2);
        local Stud_Part = script.Stud_Part;
        local v5 = 1 * (p3 * 0.5 + 0.5);
        local v6 = Color3.new(0.654902, 0.47451, 0.294118);
        local v7 = Stud_Part:Clone();
        v7.Size = Vector3.new(v5, 1 + p3 * 0.25, v5);
        v7.CFrame = u1.PrimaryPart.CFrame * CFrame.new(0, -(u1.PrimaryPart.Size.Y / 2 + v7.Size.Y / 2), 0);
        local u8 = 0 + 1;
        v7.Color = v6;
        v7.Name = tostring(u8);
        v7.Parent = u1;
        local v9 = 1.5 + p3;
        local v10 = 0.75 * (p3 * 0.5 + 0.5);
        local v11 = v9 * 0.4;
        local v12 = v9 * 1.35;
        local v13 = v9 * 0.95;
        local v14 = 1 * (10 + (p3 * 0.1 - 0.9));
        local v15 = v4:NextNumber();
        local v16, v17;

        if v15 < 1e-7 then
            v16 = 0.92;
            v17 = 0.92;
        elseif v15 < 0.00001 then
            v16 = 0.6;
            v17 = 0.6;
        else
            local v18 = v4:NextNumber();

            if v18 < 0.6 then
                v16 = 0.09;
                v17 = 0.02;
            elseif v18 < 0.8 then
                v16 = 0.075;
                v17 = 0.02;
            elseif v18 < 0.95 then
                v16 = 0.15;
                v17 = 0.2;
            else
                v16 = 0.03;
                v17 = 0.05;
            end;

            local v19 = v4:NextInteger(1, 3);

            if v19 == 1 then
                local v20 = v17;
                v17 = v16;
                v16 = v20;
            elseif v19 ~= 2 then
                v16 = (v16 + v17) * 0.5;
                v17 = v16;
            end;
        end;

        local CFrame2 = v7.CFrame;
        local Size = v7.Size;

        for i = 1, v14 do
            local v21 = i / v14;
            local v22;

            if v21 <= 0.65 then
                v22 = v11 + (v12 - v11) * math.sin(v21 / 0.65 * 3.141592653589793 * 0.5);
            else
                local v23 = (v21 - 0.65) / 0.35;
                v22 = v12 - (v12 - v13) * (v23 * v23);
            end;

            local v24 = Stud_Part:Clone();
            v24.Color = Color3.fromHSV(v17 + (v16 - v17) * v21, 1, 1);
            v24.Size = Vector3.new(v22, v10 * (0.3 + 0.6 * ((v22 - v11) / (v12 - v11))), v22);
            u8 = u8 + 1;
            v24.Name = tostring(u8);
            v24.CFrame = CFrame2 * CFrame.new(0, -(Size.Y / 2 + v24.Size.Y / 2), 0);
            v24.Parent = u1;
            CFrame2 = v24.CFrame;
            Size = v24.Size;
        end;

        local function AttachWedge_1(p25) -- Line: 112
            -- upvalues: u8 (ref), Stud_Part (copy), u1 (copy)
            u8 = u8 + 1;
            local v26 = Stud_Part:Clone();
            v26.Size = Vector3.new(p25.Size.Z, p25.Size.Y * 0.5, p25.Size.X / 2);
            v26.Shape = Enum.PartType.Wedge;
            v26.CFrame = p25.CFrame * CFrame.new(-p25.Size.X / 4, -(p25.Size.Y / 2 + v26.Size.Y / 2), 0);
            v26.Parent = u1;
            v26.Color = p25.Color;
            v26.CFrame = v26.CFrame * CFrame.Angles(0, 1.5707963267948966, 0);
            v26.CFrame = v26.CFrame * CFrame.Angles(0, 0, 3.141592653589793);
            v26.Name = tostring(u8);
            local v27 = Stud_Part:Clone();
            v27.Size = Vector3.new(p25.Size.Z, p25.Size.Y * 0.5, p25.Size.X / 2);
            v27.Shape = Enum.PartType.Wedge;
            v27.CFrame = p25.CFrame * CFrame.new(p25.Size.X / 4, -(p25.Size.Y / 2 + v27.Size.Y / 2), 0);
            v27.Parent = u1;
            v27.Color = p25.Color;
            v27.CFrame = v27.CFrame * CFrame.Angles(0, -1.5707963267948966, 0);
            v27.CFrame = v27.CFrame * CFrame.Angles(0, 0, 3.141592653589793);
            v27.Name = tostring(u8);
        end;

        local v28 = Stud_Part:Clone();
        local v29 = 3 + (p3 * 0.5 + 0.5);
        v28.Size = Vector3.new(v29, v29, v29 * 0.25);
        v28.CFrame = v7.CFrame * CFrame.new(0, v7.Size.Y / 2, 0);
        local CFrame3 = v28.CFrame;
        local Angles = CFrame.Angles;
        local v30 = v4:NextInteger(-180, 180);
        v28.CFrame = CFrame3 * Angles(0, math.rad(v30), 0);
        local CFrame4 = v28.CFrame;
        local Angles2 = CFrame.Angles;
        local v31 = v4:NextInteger(47, 56);
        v28.CFrame = CFrame4 * Angles2(math.rad(v31), 0, 0);
        v28.CFrame = v28.CFrame * CFrame.new(0, -(v28.Size.Y / 2), 0);
        v28.Color = Color3.fromRGB(177, 77, 0);
        u8 = u8 + 1;
        v28.Name = tostring(u8);
        v28.Parent = u1;
        AttachWedge_1(v28);
        u1:ScaleTo(p3 * 0.1 + 0.9);
        u1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u32) -- Line: 160, Name: BeginFruitGrowth
        local PrimaryPart = u32.PrimaryPart;
        local u33 = {};

        for _, v in u32:QueryDescendants("BasePart") do
            local v34 = tonumber(v.Name);

            if v34 then
                local v35 = not v:GetAttribute("DontShow");
                local v36 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v34
                };
                table.insert(u33, v36);
                v.CanCollide = false;

                if v35 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 183
            -- upvalues: u32 (copy), u33 (copy), PrimaryPart (copy)
            local v37 = u32:GetAttribute("Age") or 0;
            local v38 = u32:GetAttribute("MaxAge") or 1;
            local v39 = v37 / v38;

            for _, v in u33 do
                if not v.part:GetAttribute("DontShow") then
                    local v40 = math.clamp((v39 - v.partAge / v38) * v38, 0, 1);

                    if v40 ~= v.lastProgress then
                        v.lastProgress = v40;

                        if v40 > 0 then
                            v.part.Size = v.maxSize * v40;
                            local v41 = CFrame.new(0, v.maxSize.Y / 2 * (1 - v40), 0);
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * v41;
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

        u32:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p42) -- Line: 219, Name: OnFullyGrown
        local v43 = p42:GetAttribute("CorePartName");

        if v43 then
            local v44 = p42:FindFirstChild(v43);
            local v45 = v44 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v45 then
                local v46 = v45:Clone();
                v46.Name = "ProximityPrompt";
                v46.Parent = v44;
            end;
        end;

        p42:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Apple",
        Harvestable = true
    }
};