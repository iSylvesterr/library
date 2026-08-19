-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        GrowRate = 0.06,
        BaseWeight = 1.5,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(p1, p2, p3) -- Line: 9, Name: InitFruit
        local v4 = Random.new(p2);
        local v5 = p1:FindFirstChild("1");
        v5.Name = "2";
        local v6 = 2 + p3 * 0.25;
        local v7 = 3 + p3 * 5;
        local v8 = 2 + p3 * 0.25;
        v5.CFrame = v5.CFrame * CFrame.new(0, -v7 / 2, 0);
        v5.Size = Vector3.new(v8, 0.5, v7);
        local v9 = v5:Clone();
        v9.Size = Vector3.new(0.25 * p3, v6, v7);
        v9.CFrame = v5.CFrame * CFrame.new(v9.Size.X / 2 + v5.Size.X / 2, (v9.Size.Y - v5.Size.Y) / 2, 0);
        v9.Name = "3";
        v9.Parent = p1;
        local v10 = v5:Clone();
        v10.Size = Vector3.new(0.25 * p3, v6, v7);
        v10.CFrame = v5.CFrame * CFrame.new(-(v10.Size.X / 2 + v5.Size.X / 2), (v10.Size.Y - v5.Size.Y) / 2, 0);
        v10.Name = "4";
        v10.Parent = p1;
        local v11 = v5:Clone();
        v11.Size = Vector3.new(v8, v6, 0.25 * p3);
        v11.CFrame = v5.CFrame * CFrame.new(0, (v11.Size.Y - v5.Size.Y) / 2, -(v11.Size.Z / 2 + v5.Size.Z / 2));
        v11.Name = "5";
        v11.Parent = p1;
        local v12 = v5:Clone();
        v12.Size = Vector3.new(v8, v6, 0.25 * p3);
        v12.CFrame = v5.CFrame * CFrame.new(0, (v12.Size.Y - v5.Size.Y) / 2, v12.Size.Z / 2 + v5.Size.Z / 2);
        local v13 = 0 + 1 + 1 + 1 + 1;
        v12.Name = "6";
        v12.Parent = p1;
        local v14 = v4:NextInteger(27, 34) * 0.01;
        local Size = v5.Size;
        local v15 = math.round(Size.Z / Size.X);
        local v16 = math.max(1, v15);
        local v17 = Size.Z / v16;
        local v18 = Size.Z / 2;
        local v19 = v17;
        local v20 = 0;

        for i = 1, v16 do
            v20 = v20 + 1;
            local Part = Instance.new("Part");
            Part.Shape = Enum.PartType.Ball;
            Part.Size = Vector3.new(v17, v17, v17);
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Material = v5.Material;
            Part.Color = v5.Color;
            local v21 = v20 * 0.1 % 2;
            local v22 = v21 <= 1 and v21 and v21 or 2 - v21;
            Part.Color = Color3.fromHSV(v14 - 0.025 + v22 * 0.025, 0.5 + v22 * 0.175, 0.5 + v22 * 0.25);
            Part.CFrame = v5.CFrame * CFrame.new(0, v17 / 2 - v5.Size.Y / 4, -v18 + v19 / 2 + (i - 1) * v19);
            v13 = v13 + 1;
            Part.Name = tostring(v13);
            Part.Parent = p1;
        end;

        v5.CFrame = v5.CFrame * CFrame.Angles(1.5707963267948966, 0, 0);
        v5.Size = Vector3.new(v5.Size.X, v5.Size.Z, v5.Size.Y);
        v5.CFrame = v5.CFrame * CFrame.Angles(0, 0, 3.141592653589793);

        for _, v in p1:QueryDescendants("BasePart") do
            v.Anchored = true;
        end;

        p1:SetAttribute("CorePartName", "Beanstalk");
        p1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u23) -- Line: 119, Name: BeginFruitGrowth
        local PrimaryPart = u23.PrimaryPart;
        local u24 = {};

        for _, v in u23:QueryDescendants("BasePart") do
            local v25 = tonumber(v.Name);

            if v25 then
                local v26 = not v:GetAttribute("DontShow");
                local v27 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v25
                };
                table.insert(u24, v27);
                v.CanCollide = false;

                if v26 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 142
            -- upvalues: u23 (copy), u24 (copy), PrimaryPart (copy)
            local v28 = (u23:GetAttribute("Age") or 0) / (u23:GetAttribute("MaxAge") or 1);
            local v29 = math.clamp(v28, 0, 1);

            for _, v in u24 do
                if not v.part:GetAttribute("DontShow") then
                    local v30 = math.clamp(v29, 0, 1);

                    if v30 ~= v.lastProgress then
                        v.lastProgress = v30;

                        if v29 > 0 then
                            v.part.Size = v.maxSize * v29;
                            v.part.CFrame = PrimaryPart.CFrame * CFrame.new(v.centerOffset.Position * v29) * v.centerOffset.Rotation;
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

        u23:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {
        FruitType = "Beanstalk",
        Harvestable = true
    }
};