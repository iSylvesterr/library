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
        local u8 = Color3.new(0, 0.666667, 0);
        local u9 = 0;

        local function Brach(p10, p11, p12) -- Line: 26
            -- upvalues: u8 (copy), u7 (ref), u1 (copy), u9 (ref)
            local v13 = 1;

            for _ = 1, p11 do
                local v14 = script.Stud_Part:Clone();
                v14.Name = tostring(v13);
                v14.Size = p12;
                v14.Color = u8;
                v14.CFrame = p10 * CFrame.new(0, v14.Size.Y / 2 + p12.Y / 2, 0) * CFrame.new(0, -v14.Size.Y / 2, 0) * CFrame.Angles(math.rad(u7), 0, 0) * CFrame.new(0, v14.Size.Y / 2, 0);
                v14.Parent = u1;
                p10 = v14.CFrame;
                p12 = v14.Size;
                v13 = v13 + 1;

                if u9 < v13 then
                    u9 = v13;
                end;
            end;
        end;

        local v15 = (360 + 360 / v6) / v6;
        local v16 = u5:NextInteger(1, 10) == 1 and 3 or 1.25;
        local v17 = Vector3.new(v16, 0.5 + v4 * 0.2, 1);
        local v18 = 1;

        if u5:NextInteger(1, 10) == 1 then
            v18 = v18 + 1;
        end;

        local v19 = -u5:NextInteger(13, 15);
        local v20;

        if u5:NextInteger(1, 700) == 1 then
            v20 = 2;

            while u5:NextInteger(1, 500) == 1 do
                v20 = v20 * 2;
            end;
        else
            v20 = 1;
        end;

        if v20 > 1 then
            u7 = u7 / (v20 * 1.5);
        end;

        for i = 0, v18 do
            for i2 = 1, v6 do
                local v21 = PrimaryPart.CFrame * CFrame.new(0, -PrimaryPart.Size.Y / 2, 0) * CFrame.new(0, -v17.Y / 2, 0) * CFrame.Angles(0, math.rad(v15 * i2 + i * 90), 0);
                local Angles = CFrame.Angles;
                local v22 = u5:NextInteger(7, 15) + v19 * i;
                Brach(v21 * Angles(math.rad(v22), 0, 0), v20 * 11, v17);
            end;
        end;

        local function Branch(p23, p24, p25) -- Line: 91
            -- upvalues: u9 (ref), u5 (copy), u8 (copy), u1 (copy), Stud_Part (copy), FruitSpawnLocations (copy)
            local v26 = u9;
            local v27 = u5:NextInteger(-5, 5);
            local v28 = u5:NextInteger(-5, 5);
            local v29 = nil;

            for _ = 1, p25 do
                v29 = script.Stud_Part:Clone();
                v29.Name = tostring(v26);
                v29.Size = p23;
                v29.Color = u8;
                v29.CFrame = p24 * CFrame.new(0, v29.Size.Y / 2 + p23.Y / 2, 0) * CFrame.new(0, -v29.Size.Y / 2, 0) * CFrame.Angles(math.rad(v27), 0, (math.rad(v28))) * CFrame.new(0, v29.Size.Y / 2, 0);
                v29.Name = tostring(v26);
                v29.Parent = u1;
                p24 = v29.CFrame;
                p23 = v29.Size;
                v26 = v26 + 1;

                if u9 < v26 then
                    u9 = v26;
                end;
            end;

            local v30 = Stud_Part:Clone();
            v30.Size = Vector3.new(1, 1, 1);
            v30.Transparency = 1;
            v30.CanCollide = false;
            v30.CFrame = v29.CFrame * CFrame.new(0, v29.Size.Y / 2, 0) * CFrame.new(0, v30.Size.Y / 2, 0);
            v30.Parent = FruitSpawnLocations;
        end;

        if u5:NextInteger(1, 10) == 1 then
            local v31 = u5:NextInteger(2, 5);
            local v32 = (360 + 360 / v31) / v31;

            for i = 1, v31 do
                local v33 = u5:NextInteger(3, 5);
                local v34 = Vector3.new(2, v33, 2);
                local v35 = PrimaryPart.CFrame * CFrame.new(0, -PrimaryPart.Size.Y / 2, 0) * CFrame.new(0, -v34.Y / 2, 0) * CFrame.Angles(0, math.rad(v32 * i), 0);
                local Angles = CFrame.Angles;
                local v36 = u5:NextInteger(1, 3);
                Branch(v34, v35 * Angles(math.rad(v36), 0, 0), u5:NextInteger(3, 4));
            end;
        else
            local v37 = Stud_Part:Clone();
            v37.Parent = u1;
            v37.Size = Vector3.new(2, 7 + v4, 2);
            v37.CFrame = PrimaryPart.CFrame * CFrame.new(0, -PrimaryPart.Size.Y / 2, 0) * CFrame.new(0, v37.Size.Y / 2, 0);
            v37.Name = tostring(u9);
            v37.Color = Color3.new(0, 0.666667, 0);
            v37.Parent = u1;
            local v38 = Stud_Part:Clone();
            v38.Size = Vector3.new(1, 1, 1);
            v38.Transparency = 1;
            v38.CanCollide = false;
            v38.CFrame = v37.CFrame * CFrame.new(0, v37.Size.Y / 2, 0) * CFrame.new(0, v38.Size.Y / 2, 0);
            v38.Parent = FruitSpawnLocations;
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u39) -- Line: 169, Name: BeginPlantGrowth
        local PrimaryPart = u39.PrimaryPart;
        local u40 = {};

        for _, v in u39:QueryDescendants("BasePart") do
            local v41 = tonumber(v.Name);

            if v41 then
                local v42 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v41
                };
                table.insert(u40, v42);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        table.sort(u40, function(p43, p44) -- Line: 188
            return p43[4] < p44[4];
        end);

        local function updateGrowth() -- Line: 190
            -- upvalues: u39 (copy), u40 (copy), PrimaryPart (copy)
            local v45 = u39:GetAttribute("Age") or 0;

            for _, v in u40 do
                local v46 = v[1];
                local v47 = v[2];
                local v48 = v[3];
                local v49 = math.clamp(v45 - v[4], 0, 1);

                if v49 ~= v.lastProgress then
                    v.lastProgress = v49;

                    if v49 > 0 then
                        v46.Size = Vector3.new(v47.X, v47.Y * v49, v47.Z);
                        v46.CFrame = PrimaryPart.CFrame * v48 * CFrame.new(0, (v46.Size.Y - v47.Y) / 2, 0);
                        v46.Transparency = v46:GetAttribute("OG_Transparency") or 0;
                        v46.CanCollide = true;
                    else
                        v46.Transparency = 1;
                        v46.CanCollide = false;
                    end;
                end;
            end;
        end;

        u39:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};