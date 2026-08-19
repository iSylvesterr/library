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
        local _ = v4:NextInteger(27, 34) * 0.01;
        local Size = v5.Size;
        local v16 = math.round(Size.Z / Size.X);
        local v17 = math.max(1, v16);
        local v18 = Size.Z / v17;
        local v19 = Size.Z / 2;
        local v20 = {
            Color3.fromRGB(195, 116, 51),
            Color3.fromRGB(159, 74, 18),
            Color3.fromRGB(212, 109, 19),
            Color3.fromRGB(147, 105, 8),
            Color3.fromRGB(208, 158, 9)
        };
        local v21 = v18;
        local v22 = 0;

        for i = 1, v17 do
            v22 = v22 + 1;
            local Part = Instance.new("Part");
            Part.Shape = Enum.PartType.Ball;
            Part.Size = Vector3.new(v18, v18, v18);
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Material = v5.Material;
            Part.Color = v5.Color;
            local v23 = v22 * 0.1 % 2;

            if v23 > 1 or not v23 then
                local _ = 2 - v23;
            end;

            Part.Color = v20[math.random(#v20)];
            Part.CFrame = v5.CFrame * CFrame.new(0, v18 / 2 - v5.Size.Y / 4, -v19 + v21 / 2 + (i - 1) * v21);
            v15 = v15 + 1;
            Part.Name = tostring(v15);
            Part.Parent = p1;
        end;

        for _, v in p1:QueryDescendants("BasePart") do
            v.Anchored = true;
        end;

        p1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u24) -- Line: 123, Name: BeginFruitGrowth
        local PrimaryPart = u24.PrimaryPart;
        local u25 = {};

        for _, v in u24:QueryDescendants("BasePart") do
            local v26 = tonumber(v.Name);

            if v26 then
                local v27 = not v:GetAttribute("DontShow");
                local v28 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v26
                };
                table.insert(u25, v28);
                v.CanCollide = false;

                if v27 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local u29 = 0;

        for _, v in u25 do
            if not v.part:GetAttribute("DontShow") then
                local Rotation = v.centerOffset.Rotation;
                local v30 = Rotation.XVector:Dot(Vector3.new(0, 0, 1));
                local v31 = math.abs(v30) * v.maxSize.X / 2;
                local v32 = Rotation.YVector:Dot(Vector3.new(0, 0, 1));
                local v33 = v31 + math.abs(v32) * v.maxSize.Y / 2;
                local v34 = Rotation.ZVector:Dot(Vector3.new(0, 0, 1));
                local v35 = v33 + math.abs(v34) * v.maxSize.Z / 2;
                local v36 = v.centerOffset.Position:Dot(Vector3.new(0, 0, 1)) + v35;
                u29 = math.max(u29, v36);
            end;
        end;

        local u37 = Vector3.new(0, 0, 0);
        local u38 = nil;

        local function updateGrowth() -- Line: 181
            -- upvalues: u24 (copy), u38 (ref), u29 (ref), PrimaryPart (copy), u37 (ref), u25 (copy)
            local v39 = (u24:GetAttribute("Age") or 0) / (u24:GetAttribute("MaxAge") or 1);
            local v40 = math.clamp(v39, 0, 1);

            if v40 == u38 then
                return;
            end;

            u38 = v40;
            local v41 = Vector3.new(0, 0, 1) * (u29 * (1 - v40));
            local v42 = PrimaryPart.CFrame * CFrame.new(-u37);
            local v43 = false;

            for _, v in u25 do
                if not v.part:GetAttribute("DontShow") then
                    if v40 > 0 then
                        v.part.Size = v.maxSize * v40;
                        v.part.CFrame = v42 * CFrame.new(v.centerOffset.Position * v40 + v41) * v.centerOffset.Rotation;
                        v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                        v.part.CanCollide = true;
                        v43 = true;
                    else
                        v.part.Transparency = 1;
                        v.part.CanCollide = false;
                    end;
                end;
            end;

            if v43 then
                u37 = v41;
            end;
        end;

        u24:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {
        FruitType = "Beanstalk",
        Harvestable = true
    }
};