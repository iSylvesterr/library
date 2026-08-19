-- Decompiled with Potassium's decompiler.

local MaterialService = game:GetService("MaterialService");

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u1, p2, p3) -- Line: 9, Name: InitPlant
        -- upvalues: MaterialService (copy)
        local v4 = p3 or 1;
        local u5 = Random.new(p2);
        local FruitSpawnLocations = u1.FruitSpawnLocations;
        local Base = u1.Base;

        if v4 < 4 then
            v4 = v4 * 0.5 + 0.5;
        end;

        local function GetRandomHSV(p6, p7) -- Line: 20
            -- upvalues: u5 (copy)
            local v8, v9, v10 = p6:ToHSV();
            local v11 = p7 or 0.05;
            local v12 = v8 + u5:NextNumber(-v11, v11);

            return Color3.fromHSV(v12, v9, v10), v12, v9, v10;
        end;

        local u13 = Color3.fromRGB(74, 112, 33);

        local function CreatePart(p14, p15, p16) -- Line: 30
            -- upvalues: u1 (copy), MaterialService (ref)
            local Part = Instance.new("Part");
            local v17 = p14 or "Studs";
            Part.Parent = u1;
            Part.TopSurface = Enum.SurfaceType[v17];
            Part.BackSurface = Enum.SurfaceType[v17];
            Part.FrontSurface = Enum.SurfaceType[v17];
            Part.BottomSurface = Enum.SurfaceType[v17];
            Part.LeftSurface = Enum.SurfaceType[v17];
            Part.RightSurface = Enum.SurfaceType[v17];
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Transparency = 0;

            if p16 then
                Part.Shape = Enum.PartType[p16];
            end;

            if p15 then
                Part.MaterialVariant = p15;
                local v18 = MaterialService:FindFirstChild(p15, true);

                if not v18 then
                    return Part;
                end;

                Part.Material = v18.BaseMaterial;
            end;

            return Part;
        end;

        local v19 = v4 > 2 and v4 < 4 and 0.925 or (v4 > 4 and 0.95 or 0.85);
        local v20 = u5:NextNumber(1.3, 1.6) * v4;
        local v21 = u5:NextInteger(5, 7) * v4;
        local v22 = u5:NextInteger(4, 5);
        local u23 = Vector3.new(v20, v20, v20);
        local CFrame2 = Base.CFrame;
        local _ = 1 * v4;

        local function AddSpikes(p24, p25) -- Line: 81
            -- upvalues: u5 (copy), u1 (copy)
            local Size = p24.Size;
            local v26 = math.min(Size.X, Size.Y, Size.Z);
            local v27 = u5:NextNumber(1, 4) * 90;
            local v28 = u5:NextNumber(75, 105);
            local v29 = script.Spike.Size * (v26 * u5:NextNumber(0.75, 0.9));
            local v30 = script.Spike:Clone();
            v30.Parent = u1;
            v30.Name = p25 + 1;
            v30.Size = v29;
            v30.CFrame = p24.CFrame * CFrame.Angles(0, math.rad(v27), (math.rad(v28))) * CFrame.new(0, Size.Z / 2 + v29.Y / 2.2, 0);
        end;

        local function AddBranch(p31, p32) -- Line: 96
            -- upvalues: u5 (copy), u23 (ref), CFrame2 (ref), CreatePart (copy), u13 (copy), AddSpikes (copy), FruitSpawnLocations (copy)
            local v33 = u5:NextInteger(2, 3);
            local v34 = u23 * 0.8;
            local v35 = u5:NextNumber(1, 2) * (p32 * 90);
            local v36 = u5:NextNumber(60, 75);
            local v37 = CFrame2 * CFrame.Angles(0, math.rad(v35), (math.rad(v36)));

            for i = 1, v33 do
                local v38 = CreatePart(nil, "2022 Weld");
                v38.Size = v34;
                local Angles = CFrame.Angles;
                local v39 = u5:NextNumber(-12, 12);
                local v40 = math.rad(v39);
                local v41 = u5:NextNumber(-12, 12);
                v38.CFrame = v37 * Angles(v40, 0.2617993877991494, (math.rad(v41))) * CFrame.new(0, v34.Y / 2.2, 0);
                v38.Color = u13;
                v38.Name = tostring(i + p32);

                if u5:NextInteger(1, 3) == 1 then
                    AddSpikes(v38, i + p32);
                end;

                v37 = v38.CFrame * CFrame.new(0, u23.Y / 2.2, 0);

                if i ~= v33 then
                    local v42 = CreatePart();
                    v42.Parent = FruitSpawnLocations;
                    v42.Name = "FruitSpawn";
                    v42.Size = Vector3.new(1, 1, 1);
                    v42.CFrame = v37;
                    v42.Orientation = v42.Orientation + Vector3.new(-90, i % 2 == 0 and 90 or -90, u5:NextNumber(5, 15));
                    v42.Transparency = 1;
                end;

                local v43 = v34.X * 0.85;
                local v44 = p31.Size.Y * u5:NextNumber(0.8, 1.1);
                v34 = Vector3.new(v43, v44, v34.Z * 0.85);
            end;
        end;

        local v45 = v20;

        for i = 1, v21 do
            local v46 = CreatePart(nil, "2022 Weld");
            v46.Size = u23;
            local Angles = CFrame.Angles;
            local v47 = u5:NextNumber(-6, 6);
            local v48 = math.rad(v47);
            local v49 = u5:NextNumber(-6, 6);
            v46.CFrame = CFrame2 * Angles(v48, 0.2617993877991494, (math.rad(v49))) * CFrame.new(0, u23.Y / 2.2, 0);
            v46.Color = u13;
            v46.Name = tostring(i);
            CFrame2 = v46.CFrame * CFrame.new(0, u23.Y / 2.2, 0);
            v20 = math.clamp(v20 * 1.15, 0, v45 * 2);

            if u5:NextInteger(1, 3) == 1 then
                AddSpikes(v46, i);
            end;

            if i > 2 and (u5:NextInteger(1, 2) == 1 or (i == v21 or i == 3)) then
                AddBranch(v46, i);
            end;

            u23 = Vector3.new(u23.X * v19, v20, u23.Z * v19);
        end;

        for i = 1, v22 do
            local v50 = CreatePart(nil, "2022 Weld");
            v50.Size = u23;
            local Angles = CFrame.Angles;
            local v51 = u5:NextNumber(-6, 6);
            local v52 = math.rad(v51);
            local v53 = u5:NextNumber(-45, -30);
            v50.CFrame = CFrame2 * Angles(v52, 0, (math.rad(v53))) * CFrame.Angles(0, 0.2617993877991494, 0) * CFrame.new(0, u23.Y / 2.2, 0);
            v50.Color = u13;
            v50.Name = tostring(i + v21);
            CFrame2 = v50.CFrame * CFrame.new(0, u23.Y / 2.2, 0);
            v20 = math.clamp(v20 * 0.9, v45 / 2, (1 / 0));

            if u5:NextInteger(1, 3) == 1 then
                AddSpikes(v50, i + v21);
            end;

            u23 = Vector3.new(u23.X * 0.9, v20, u23.Z * 0.9);
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u54) -- Line: 179, Name: BeginPlantGrowth
        local PrimaryPart = u54.PrimaryPart;
        local u55 = {};

        for _, v in u54:QueryDescendants("BasePart") do
            local v56 = tonumber(v.Name);

            if v56 then
                local v57 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v56
                };
                table.insert(u55, v57);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 197
            -- upvalues: u54 (copy), u55 (copy), PrimaryPart (copy)
            local v58 = u54:GetAttribute("Age") or 0;

            for _, v in u55 do
                local v59 = v[1];
                local v60 = v[2];
                local v61 = v[3];
                local v62 = math.min(v58 - v[4], 1);
                local v63 = math.clamp(v62, 0, 1);

                if v63 ~= v.lastProgress then
                    v.lastProgress = v63;

                    if v62 > 0 then
                        v59.Size = Vector3.new(v60.X, v60.Y * v62, v60.Z);
                        v59.CFrame = PrimaryPart.CFrame * v61 * CFrame.new(0, (v59.Size.Y - v60.Y) / 2, 0);
                        v59.Transparency = v59:GetAttribute("OG_Transparency") or 0;
                        v59.CanCollide = true;
                    else
                        v59.Transparency = 1;
                        v59.CanCollide = false;
                    end;
                end;
            end;
        end;

        u54:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};