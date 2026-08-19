-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(p1, p2, p3) -- Line: 7, Name: InitPlant
        local v4 = p3 or 1;
        local v5 = Random.new(p2);
        local v6 = v5:NextInteger(5, 7) * v4;
        local PrimaryPart = p1.PrimaryPart;
        local v7 = 2 * v4;
        local v8 = 5;
        local v9 = 1;

        while v8 >= 1 do
            task.wait();
            v8 = v8 - 1;
            local Part = Instance.new("Part");
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Size = Vector3.new(v7, v6, v7);
            v9 = v9 + 1;
            Part.Name = tostring(v9);
            Part.CFrame = PrimaryPart.CFrame * CFrame.new(0, PrimaryPart.Size.Y / 2 + Part.Size.Y / 2, 0);
            Part.Parent = p1;
            local FruitSpawnLocations = p1.FruitSpawnLocations;
            local Part2 = Instance.new("Part");
            Part2.Parent = FruitSpawnLocations;
            Part2.Anchored = true;
            Part2.CanCollide = false;
            Part2.Size = Vector3.new(0.5, 0.5, 0.5);
            Part2.CFrame = Part.CFrame * CFrame.new(-(Part.Size.X / 2 + Part2.Size.X / 2), v5:NextInteger(-Part.Size.Y / 2, Part.Size.Y / 2), 0);
            v7 = v7 * 0.8;
            PrimaryPart = Part;
        end;

        p1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u10) -- Line: 39, Name: BeginPlantGrowth
        local PrimaryPart = u10.PrimaryPart;
        local u11 = {};

        for _, v in u10:QueryDescendants("BasePart") do
            local v12 = tonumber(v.Name);

            if v12 then
                local v13 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v12
                };
                table.insert(u11, v13);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 57
            -- upvalues: u10 (copy), u11 (copy), PrimaryPart (copy)
            local v14 = u10:GetAttribute("Age") or 0;

            for _, v in u11 do
                local v15 = v[1];
                local v16 = v[2];
                local v17 = v[3];
                local v18 = math.min(v14 - v[4], 1);
                local v19 = math.clamp(v18, 0, 1);

                if v19 ~= v.lastProgress then
                    v.lastProgress = v19;

                    if v18 > 0 then
                        v15.Size = Vector3.new(v16.X, v16.Y * v18, v16.Z);
                        v15.CFrame = PrimaryPart.CFrame * v17 * CFrame.new(0, (v15.Size.Y - v16.Y) / 2, 0);
                        v15.Transparency = v15:GetAttribute("OG_Transparency") or 0;
                        v15.CanCollide = true;
                    else
                        v15.Transparency = 1;
                        v15.CanCollide = false;
                    end;
                end;
            end;
        end;

        u10:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};