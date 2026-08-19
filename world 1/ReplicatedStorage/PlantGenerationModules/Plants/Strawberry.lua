-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(p1, p2, p3) -- Line: 7, Name: InitPlant
        local v4 = math.round((p3 or 1) * 10) * 0.1;
        local v5 = Random.new(p2);
        local FruitSpawnLocations = p1.FruitSpawnLocations;
        local Base = p1.Base;
        local Stud_Part = script.Stud_Part;
        local v6 = Color3.new(0, 0.666667, 0);
        Color3.new(0.368627, 0.784314, 0.254902);
        local v7 = v5:NextInteger(1, 2);
        local v8 = 1;

        while v5:NextInteger(1, 3) == 1 do
            v7 = v7 + 1;
        end;

        if v5:NextInteger(1, 100) == 1 then
            v7 = v7 + v5:NextInteger(13, 15);
        end;

        local v9 = Base.CFrame * CFrame.new(0, -Base.Size.Y / 2, 0);
        local Size = Base.Size;

        for i = 1, v7 do
            local v10 = 0.25 * v4;
            local v11 = 1.5 * v4;
            local v12 = Stud_Part:Clone();
            v12.Color = v6;
            v12.Name = tostring(v8);
            v12.Size = Vector3.new(v10, v11, v10);
            v12.CFrame = v9 * CFrame.new(0, v12.Size.Y / 2, 0);
            local CFrame2 = v12.CFrame;
            local Angles = CFrame.Angles;
            local v13 = v5:NextInteger(-15, 15);
            local v14 = math.rad(v13);
            local v15 = v5:NextInteger(-15, 15);
            local v16 = math.rad(v15);
            local v17 = v5:NextInteger(-15, 15);
            v12.CFrame = CFrame2 * Angles(v14, v16, (math.rad(v17)));
            v12.CFrame = v12.CFrame * CFrame.new(0, Size.Y / 2, 0);
            v12.CFrame = v12.CFrame * CFrame.Angles(0, math.rad(i * 5), 0);
            v12.Parent = p1;
            local v18 = v8 + 1;
            local v19 = Stud_Part:Clone();
            v19.Color = v6;
            v19.Name = tostring(v18);
            local v20 = v5:NextNumber(v11 / 4, v11 / 3.3);
            v19.Size = Vector3.new(v10 * 0.85, v20, v10 * 0.85);
            v19.CFrame = v12.CFrame * CFrame.Angles(1.5707963267948966, 0, 0);
            local CFrame3 = v19.CFrame;
            local Angles2 = CFrame.Angles;
            local v21 = v5:NextInteger(-15, 15);
            local v22 = math.rad(v21);
            local v23 = v5:NextInteger(-15, 15);
            local v24 = math.rad(v23);
            local v25 = v5:NextInteger(-15, 15);
            v19.CFrame = CFrame3 * Angles2(v22, v24, (math.rad(v25)));
            v19.CFrame = v19.CFrame * CFrame.new(0, v19.Size.Y / 2 + v12.Size.X / 2, 0);
            v19.Parent = p1;
            local v26 = Stud_Part:Clone();
            v26.Size = Vector3.new(1, 1, 1);
            v26.Parent = FruitSpawnLocations;
            v26.CFrame = v19.CFrame * CFrame.new(0, v19.Size.Y / 2, 0);
            v26.Transparency = 1;
            local v27 = v18 + 1;
            local v28 = Stud_Part:Clone();
            v28.Color = v6;
            v28.Name = tostring(v27);
            local v29 = v5:NextNumber(v11 / 4, v11 / 3.3);
            v28.Size = Vector3.new(v10 * 0.85, v29, v10 * 0.85);
            v28.CFrame = v12.CFrame * CFrame.Angles(-1.5707963267948966, 0, 0);
            local CFrame4 = v28.CFrame;
            local Angles3 = CFrame.Angles;
            local v30 = v5:NextInteger(-15, 15);
            local v31 = math.rad(v30);
            local v32 = v5:NextInteger(-15, 15);
            local v33 = math.rad(v32);
            local v34 = v5:NextInteger(-15, 15);
            v28.CFrame = CFrame4 * Angles3(v31, v33, (math.rad(v34)));
            v28.CFrame = v28.CFrame * CFrame.new(0, v28.Size.Y / 2 + v12.Size.X / 2, 0);
            v28.Parent = p1;
            local v35 = Stud_Part:Clone();
            v35.Size = Vector3.new(1, 1, 1);
            v35.Parent = FruitSpawnLocations;
            v35.CFrame = v28.CFrame * CFrame.new(0, v28.Size.Y / 2, 0);
            v35.Transparency = 1;
            local v36 = script.Leaves:Clone();
            v36:PivotTo(v12.CFrame * CFrame.new(0, v12.Size.Y / 2, 0));
            v36:ScaleTo(v4);
            v36.PrimaryPart:Destroy();
            v8 = v27 + 1;

            for _, child in pairs(v36:GetChildren()) do
                child.Parent = p1;
                child.Name = tostring(v8);
            end;

            v9 = v12.CFrame;
            Size = v12.Size;
        end;

        p1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u37) -- Line: 109, Name: BeginPlantGrowth
        local PrimaryPart = u37.PrimaryPart;
        local u38 = {};

        for _, v in u37:QueryDescendants("BasePart") do
            local v39 = tonumber(v.Name);

            if v39 then
                local v40 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v39
                };
                table.insert(u38, v40);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 127
            -- upvalues: u37 (copy), u38 (copy), PrimaryPart (copy)
            local v41 = u37:GetAttribute("Age") or 0;

            for _, v in u38 do
                local v42 = v[1];
                local v43 = v[2];
                local v44 = v[3];
                local v45 = math.min(v41 - v[4], 1);
                local v46 = math.clamp(v45, 0, 1);

                if v46 ~= v.lastProgress then
                    v.lastProgress = v46;

                    if v45 > 0 then
                        v42.Size = Vector3.new(v43.X, v43.Y * v45, v43.Z);
                        v42.CFrame = PrimaryPart.CFrame * v44 * CFrame.new(0, (v42.Size.Y - v43.Y) / 2, 0);
                        v42.Transparency = v42:GetAttribute("OG_Transparency") or 0;
                        v42.CanCollide = true;
                    else
                        v42.Transparency = 1;
                        v42.CanCollide = false;
                    end;
                end;
            end;
        end;

        u37:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};