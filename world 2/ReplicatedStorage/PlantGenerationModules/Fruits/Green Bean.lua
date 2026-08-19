-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        GrowRate = 0.06,
        BaseWeight = 0.5,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(p1, p2, p3) -- Line: 8, Name: InitFruit
        local v4 = Random.new(p2);
        local v5 = p1:FindFirstChild("1");
        v5.Name = "2";
        v5.CFrame = v5.CFrame * CFrame.Angles(-1.5707963267948966, 0, 0);
        v5.CFrame = v5.CFrame * CFrame.Angles(0, 0, 1.5707963267948966);
        local v6 = 0.16 + p3 ^ 3 * 1e-6;
        local v7 = (2 + p3 * 0.25) * v6;
        local v8 = (3 + p3 * 5) * v6;
        local v9 = (2 + p3 * 0.25) * v6;
        local v10 = 0.25 * v6;
        v5.CFrame = v5.CFrame * CFrame.new(0, 0, -(v7 * 0.5));
        v5.Size = Vector3.new(v9, 0.5 * v6, v8);
        local v11 = v5:Clone();
        v11.Size = Vector3.new(v10, v7, v8);
        v11.CFrame = v5.CFrame * CFrame.new(v11.Size.X / 2 + v5.Size.X / 2, (v11.Size.Y - v5.Size.Y) / 2, 0);
        v11.Name = "3";
        v11.Parent = p1;
        local v12 = v5:Clone();
        v12.Size = Vector3.new(v10, v7, v8);
        v12.CFrame = v5.CFrame * CFrame.new(-(v12.Size.X / 2 + v5.Size.X / 2), (v12.Size.Y - v5.Size.Y) / 2, 0);
        v12.Name = "4";
        v12.Parent = p1;
        local v13 = v5:Clone();
        v13.Size = Vector3.new(v9, v7, v10);
        v13.CFrame = v5.CFrame * CFrame.new(0, (v13.Size.Y - v5.Size.Y) / 2, -(v13.Size.Z / 2 + v5.Size.Z / 2));
        v13.Name = "5";
        v13.Parent = p1;
        local v14 = v5:Clone();
        v14.Size = Vector3.new(v9, v7, v10);
        v14.CFrame = v5.CFrame * CFrame.new(0, (v14.Size.Y - v5.Size.Y) / 2, v14.Size.Z / 2 + v5.Size.Z / 2);
        local v15 = 0 + 1 + 1 + 1 + 1;
        v14.Name = "6";
        v14.Parent = p1;
        local v16 = v4:NextInteger(27, 34) * 0.01;
        local Size = v5.Size;
        local v17 = math.round(Size.Z / Size.X);
        local v18 = math.max(1, v17);
        local v19 = Size.Z / v18;
        local v20 = Size.Z / 2;
        local v21 = v19;
        local v22 = 0;

        for i = 1, v18 do
            v22 = v22 + 1;
            local Part = Instance.new("Part");
            Part.Shape = Enum.PartType.Ball;
            Part.Size = Vector3.new(v19, v19, v19);
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Material = v5.Material;
            Part.Color = v5.Color;
            local v23 = v22 * 0.1 % 2;
            local v24 = v23 <= 1 and v23 and v23 or 2 - v23;
            Part.Color = Color3.fromHSV(v16 - 0.025 + v24 * 0.025, 0.5 + v24 * 0.175, 0.5 + v24 * 0.25);
            Part.CFrame = v5.CFrame * CFrame.new(0, v19 / 2 - v5.Size.Y / 4, -v20 + v21 / 2 + (i - 1) * v21);
            v15 = v15 + 1;
            Part.Name = tostring(v15);
            Part.Parent = p1;
        end;

        for _, v in p1:QueryDescendants("BasePart") do
            v.Anchored = true;
        end;

        p1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u25) -- Line: 119, Name: BeginFruitGrowth
        local PrimaryPart = u25.PrimaryPart;
        local u26 = {};

        for _, v in u25:QueryDescendants("BasePart") do
            local v27 = tonumber(v.Name);

            if v27 then
                local v28 = not v:GetAttribute("DontShow");
                local v29 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v27
                };
                table.insert(u26, v29);
                v.CanCollide = false;

                if v28 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local u30 = 0;

        for _, v in u26 do
            if not v.part:GetAttribute("DontShow") then
                local Rotation = v.centerOffset.Rotation;
                local v31 = Rotation.XVector:Dot(Vector3.new(0, 0, 1));
                local v32 = math.abs(v31) * v.maxSize.X / 2;
                local v33 = Rotation.YVector:Dot(Vector3.new(0, 0, 1));
                local v34 = v32 + math.abs(v33) * v.maxSize.Y / 2;
                local v35 = Rotation.ZVector:Dot(Vector3.new(0, 0, 1));
                local v36 = v34 + math.abs(v35) * v.maxSize.Z / 2;
                local v37 = v.centerOffset.Position:Dot(Vector3.new(0, 0, 1)) + v36;
                u30 = math.max(u30, v37);
            end;
        end;

        local u38 = Vector3.new(0, 0, 0);
        local u39 = nil;

        local function updateGrowth() -- Line: 177
            -- upvalues: u25 (copy), u39 (ref), u30 (ref), PrimaryPart (copy), u38 (ref), u26 (copy)
            local v40 = (u25:GetAttribute("Age") or 0) / (u25:GetAttribute("MaxAge") or 1);
            local v41 = math.clamp(v40, 0, 1);

            if v41 == u39 then
                return;
            end;

            u39 = v41;
            local v42 = Vector3.new(0, 0, 1) * (u30 * (1 - v41));
            local v43 = PrimaryPart.CFrame * CFrame.new(-u38);
            local v44 = false;

            for _, v in u26 do
                if not v.part:GetAttribute("DontShow") then
                    if v41 > 0 then
                        v.part.Size = v.maxSize * v41;
                        v.part.CFrame = v43 * CFrame.new(v.centerOffset.Position * v41 + v42) * v.centerOffset.Rotation;
                        v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                        v.part.CanCollide = true;
                        v44 = true;
                    else
                        v.part.Transparency = 1;
                        v.part.CanCollide = false;
                    end;
                end;
            end;

            if v44 then
                u38 = v42;
            end;
        end;

        u25:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {
        FruitType = "Beanstalk",
        Harvestable = true
    }
};