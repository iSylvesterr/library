-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u1, p2, p3) -- Line: 6, Name: InitPlant
        local v4 = p3 or 1;
        local u5 = Random.new(p2);
        local PrimaryPart = u1.PrimaryPart;
        local FruitSpawnLocations = u1.FruitSpawnLocations;
        local Stud_Part = script.Stud_Part;
        local v6 = 4 + v4;
        local u7 = u5:NextInteger(4, 11);
        local u8 = Color3.new(0.92549, 0.580392, 0.0941176);
        local u9 = Color3.new(0.686275, 0.341176, 0.113725);
        local u10 = 0;

        local function Brach(p11, p12, p13) -- Line: 27
            -- upvalues: u8 (copy), u9 (copy), u7 (ref), u1 (copy), u10 (ref)
            local v14 = 1;

            for _ = 1, p12 do
                local v15 = script.Stud_Part:Clone();
                v15.Name = tostring(v14);
                v15.Size = p13;
                v15.Color = u8:Lerp(u9, (v14 - 1) / math.max(p12 - 1, 1));
                v15.CFrame = p11 * CFrame.new(0, v15.Size.Y / 2 + p13.Y / 2, 0) * CFrame.new(0, -v15.Size.Y / 2, 0) * CFrame.Angles(math.rad(u7), 0, 0) * CFrame.new(0, v15.Size.Y / 2, 0);
                v15.Parent = u1;
                p11 = v15.CFrame;
                p13 = v15.Size;
                v14 = v14 + 1;

                if u10 < v14 then
                    u10 = v14;
                end;
            end;
        end;

        local v16 = (360 + 360 / v6) / v6;
        local v17 = u5:NextInteger(1, 10) == 1 and 3 or 1.25;
        local v18 = Vector3.new(v17, 0.5 + v4 * 0.2, 1);
        local v19 = 1;

        if u5:NextInteger(1, 10) == 1 then
            v19 = v19 + 1;
        end;

        local v20 = -u5:NextInteger(13, 15);
        local v21;

        if u5:NextInteger(1, 700) == 1 then
            v21 = 2;

            while u5:NextInteger(1, 500) == 1 do
                v21 = v21 * 2;
            end;
        else
            v21 = 1;
        end;

        if v21 > 1 then
            u7 = u7 / (v21 * 1.5);
        end;

        for i = 0, v19 do
            for i2 = 1, v6 do
                local v22 = PrimaryPart.CFrame * CFrame.new(0, -PrimaryPart.Size.Y / 2, 0) * CFrame.new(0, -v18.Y / 2, 0) * CFrame.Angles(0, math.rad(v16 * i2 + i * 90), 0);
                local Angles = CFrame.Angles;
                local v23 = u5:NextInteger(7, 15) + v20 * i;
                Brach(v22 * Angles(math.rad(v23), 0, 0), v21 * 11, v18);
            end;
        end;

        local function Branch(p24, p25, p26) -- Line: 93
            -- upvalues: u10 (ref), u5 (copy), u8 (copy), u1 (copy), Stud_Part (copy), FruitSpawnLocations (copy)
            local v27 = u10;
            local v28 = u5:NextInteger(-5, 5);
            local v29 = u5:NextInteger(-5, 5);
            local v30 = nil;

            for _ = 1, p26 do
                v30 = script.Stud_Part:Clone();
                v30.Name = tostring(v27);
                v30.Size = p24;
                v30.Color = u8;
                v30.CFrame = p25 * CFrame.new(0, v30.Size.Y / 2 + p24.Y / 2, 0) * CFrame.new(0, -v30.Size.Y / 2, 0) * CFrame.Angles(math.rad(v28), 0, (math.rad(v29))) * CFrame.new(0, v30.Size.Y / 2, 0);
                v30.Name = tostring(v27);
                v30.Parent = u1;
                p25 = v30.CFrame;
                p24 = v30.Size;
                v27 = v27 + 1;

                if u10 < v27 then
                    u10 = v27;
                end;
            end;

            local v31 = Stud_Part:Clone();
            v31.Size = Vector3.new(1, 1, 1);
            v31.Transparency = 1;
            v31.CanCollide = false;
            v31.CFrame = v30.CFrame * CFrame.new(0, v30.Size.Y / 2, 0) * CFrame.new(0, v31.Size.Y / 2, 0);
            v31.Parent = FruitSpawnLocations;
        end;

        if u5:NextInteger(1, 10) == 1 then
            local v32 = u5:NextInteger(2, 5);
            local v33 = (360 + 360 / v32) / v32;

            for i = 1, v32 do
                local v34 = u5:NextInteger(3, 5);
                local v35 = Vector3.new(2, v34, 2);
                local v36 = PrimaryPart.CFrame * CFrame.new(0, -PrimaryPart.Size.Y / 2, 0) * CFrame.new(0, -v35.Y / 2, 0) * CFrame.Angles(0, math.rad(v33 * i), 0);
                local Angles = CFrame.Angles;
                local v37 = u5:NextInteger(1, 3);
                Branch(v35, v36 * Angles(math.rad(v37), 0, 0), u5:NextInteger(3, 4));
            end;
        else
            local v38 = Stud_Part:Clone();
            v38.Parent = u1;
            v38.Size = Vector3.new(2, 7 + v4, 2);
            v38.CFrame = PrimaryPart.CFrame * CFrame.new(0, -PrimaryPart.Size.Y / 2, 0) * CFrame.new(0, v38.Size.Y / 2, 0);
            v38.Name = tostring(u10);
            v38.Color = u8;
            v38.Parent = u1;
            local v39 = Stud_Part:Clone();
            v39.Size = Vector3.new(1, 1, 1);
            v39.Transparency = 1;
            v39.CanCollide = false;
            v39.CFrame = v38.CFrame * CFrame.new(0, v38.Size.Y / 2, 0) * CFrame.new(0, v39.Size.Y / 2, 0);
            v39.Parent = FruitSpawnLocations;
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u40) -- Line: 171, Name: BeginPlantGrowth
        local PrimaryPart = u40.PrimaryPart;
        local u41 = {};

        for _, v in u40:QueryDescendants("BasePart") do
            local v42 = tonumber(v.Name);

            if v42 then
                local v43 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v42
                };
                table.insert(u41, v43);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        table.sort(u41, function(p44, p45) -- Line: 190
            return p44[4] < p45[4];
        end);

        local function updateGrowth() -- Line: 192
            -- upvalues: u40 (copy), u41 (copy), PrimaryPart (copy)
            local v46 = u40:GetAttribute("Age") or 0;

            for _, v in u41 do
                local v47 = v[1];
                local v48 = v[2];
                local v49 = v[3];
                local v50 = math.clamp(v46 - v[4], 0, 1);

                if v50 ~= v.lastProgress then
                    v.lastProgress = v50;

                    if v50 > 0 then
                        v47.Size = Vector3.new(v48.X, v48.Y * v50, v48.Z);
                        v47.CFrame = PrimaryPart.CFrame * v49 * CFrame.new(0, (v47.Size.Y - v48.Y) / 2, 0);
                        v47.Transparency = v47:GetAttribute("OG_Transparency") or 0;
                        v47.CanCollide = true;
                    else
                        v47.Transparency = 1;
                        v47.CanCollide = false;
                    end;
                end;
            end;
        end;

        u40:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};