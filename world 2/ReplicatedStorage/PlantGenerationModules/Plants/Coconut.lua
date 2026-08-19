-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(p1, p2, p3) -- Line: 6, Name: InitPlant
        local function safeUnit(p4, p5) -- Line: 9
            if p4.Magnitude < 1e-6 then
                return p5;
            end;

            return p4.Unit;
        end;

        local v6 = Random.new(p2);
        local FruitSpawnLocations = p1.FruitSpawnLocations;
        local Base = p1.Base;
        local v7 = p3 or 1;
        local v8 = 0.75;

        while v6:NextInteger(1, 100) == 1 do
            v8 = v8 * 0.5;
        end;

        local v9 = v8 * (v7 * 0.05 + 0.95);

        while v6:NextInteger(1, 100) == 1 do
            v9 = v9 + 1;
        end;

        local v10 = v6:NextInteger(1, 1000) == 1;
        local v11 = 0;
        local Stud_Part = script.Stud_Part;
        local v12 = Base.CFrame * CFrame.new(0, -Base.Size.Y / 2, 0);
        local Size = Base.Size;
        local v13 = math.round(v7 * 0.5) + 3;

        if v10 == true then
            v13 = v13 * 3;
        end;

        while v6:NextInteger(1, 50) == 1 do
            v13 = v13 + 1;
        end;

        while v6:NextInteger(1, 100) == 1 do
            v13 = v13 + v6:NextInteger(3, 4);
        end;

        local v14 = Color3.new(0.611765, 0.462745, 0.356863);
        local v15 = v6:NextInteger(90, 110) * 0.01;
        local _ = v6:NextInteger(90, 110) * 0.01;
        local v16 = v6:NextInteger(90, 110) * 0.01;
        local v17 = Color3.fromHSV(0.333333 * v15, 1, 0.666667 * v16);
        local v18 = 2 + v7 * 3;
        local v19 = 7;

        if v10 == true then
            v19 = v19 * 0.5;
            v18 = v18 * 0.5;
        end;

        while v6:NextInteger(1, 100) == 1 do
            v19 = v19 + 1;
        end;

        while v6:NextInteger(1, 100) == 1 do
            v19 = v19 + v6:NextInteger(1, 2);
            v18 = v18 + v6:NextInteger(1, 2);
            v13 = v13 + v6:NextInteger(1, 2);
        end;

        local v20 = nil;
        local v21 = v6:NextInteger(2, 7) - math.clamp(v7, 0, 3);
        local v22 = math.clamp(v21, 1, 7);
        local v23 = v6:NextInteger(2, 7) - math.clamp(v7, 0, 3);
        local v24 = math.clamp(v23, 1, 7);

        if v10 == true then
            v22 = v22 * 0.1;
            v24 = v24 * 0.1;
        end;

        if v6:NextInteger(0, 1) == 1 then
            v22 = -v22;
        end;

        if v6:NextInteger(1, 2) == 1 then
            v24 = -v24;
        end;

        local _ = v6:NextInteger(110, 120) * 0.01;
        local v25 = v6:NextInteger(80, 95) * 0.01;

        if v10 == true then
            v25 = v6:NextInteger(97, 99) * 0.01;
        end;

        if v10 == true then
            local v26 = v6:NextInteger(25, 45);
            local v27 = math.sign(v22);
            local v28 = v27 == 0 and 1 or v27;
            local v29 = (4 + v7) * v9;
            local v30 = v19 * 0.6 * v9;
            local v31 = Base.CFrame * CFrame.new(0, -Base.Size.Y / 2, 0);
            local Position = v31.Position;
            local v32 = v18;
            local v33 = v19;
            local v34 = 0;

            for i = 1, v13 do
                v11 = v11 + 1;

                if v18 * 0.1 < v32 then
                    v32 = v32 * v25;
                end;

                v33 = v33 + v19 * 0.5;
                local v35 = i / v13;
                local v36 = math.sin(v35 * 3.141592653589793);
                v34 = v34 + math.rad(v26) * v28 * v36;
                local v37 = v29 * v36 * (v35 * 0.5 + 1);
                local Position2 = v31.Position;
                local v38 = math.cos(v34) * v37;
                local v39 = math.sin(v34) * v37;
                local v40 = Position2 + Vector3.new(v38, i * v30, v39);
                local v41 = v40 - Position;
                local Magnitude = v41.Magnitude;

                if Magnitude < 1e-6 then
                    Position = v40;
                else
                    local Unit = v41.Unit;
                    local v42 = Unit:Cross(Vector3.new(0, 1, 0));
                    local v43 = v42.Magnitude < 1e-6 and Vector3.new(1, 0, 0) or v42.Unit;
                    local v44 = v43:Cross(Unit);
                    local v45 = CFrame.fromMatrix((Position + v40) * 0.5, v43, Unit, v44);
                    v20 = Stud_Part:Clone();
                    v20.Size = Vector3.new(v32 * v9, Magnitude, v32 * v9);
                    v20.CFrame = v45;
                    v20.Color = v14;
                    v20.Name = tostring(v11);
                    v20.Parent = p1;
                    Position = v40;
                end;
            end;
        else
            local v46 = v18;
            local v47 = v19;
            local v48 = 0;
            local v49 = 0;

            for i = 1, v13 do
                v20 = Stud_Part:Clone();
                v11 = v11 + 1;

                if i == 2 then
                    v48 = math.rad(v22);
                    v49 = math.rad(v24);
                end;

                if v18 * 0.1 < v46 then
                    v46 = v46 * v25;
                end;

                v19 = v19 + v47 * 0.5;
                v20.Size = Vector3.new(v46 * v9, v19 * v9, v46 * v9);
                v20.CFrame = v12 * CFrame.new(0, Size.Y / 2, 0) * CFrame.Angles(v48, 0, v49) * CFrame.new(0, v20.Size.Y / 2, 0);
                v20.Color = v14;
                v20.Name = tostring(v11);
                v20.Parent = p1;
                v12 = v20.CFrame;
                Size = v20.Size;
            end;
        end;

        local v50 = v6:NextInteger(6, 7);
        local v51 = v6:NextInteger(5, 6) + math.round(v7 * 0.5);

        while v6:NextInteger(1, 100) == 1 do
            v50 = v50 + v6:NextInteger(1, 3);
        end;

        while v6:NextInteger(1, 100) == 1 do
            v51 = v51 + v6:NextInteger(3, 4);
        end;

        local v52 = 360 - 360 / v50;
        local v53 = math.clamp(15 - v7, 7, 15);

        for i = 1, v50 do
            local v54 = v20.CFrame * CFrame.new(0, v20.Size.Y / 2, 0);
            local v55 = CFrame.Angles(0, math.rad(v52 * i), 0);
            local v56 = CFrame.Angles(0.7853981633974483, 0, 0);
            local v57 = v54 * v55 * v56;

            for i2 = 1, v51 do
                local v58 = Stud_Part:Clone();
                v58.Size = Vector3.new((5 + v7) * v9, (7 + v7) * v9, (2 + v7) * v9);
                v58.CFrame = v57 * CFrame.new(0, v58.Size.Y / 2, 0);
                v58.CFrame = v58.CFrame * CFrame.new(0, -v58.Size.Y / 2, 0) * CFrame.Angles(math.rad(v53), 0, 0) * CFrame.new(0, v58.Size.Y / 2, 0);
                v58.Name = tostring(v11 + i2);
                v58.Color = v17;
                v58.Parent = p1;
                v57 = v58.CFrame * CFrame.new(0, v58.Size.Y / 2, 0);
                local Size2 = v58.Size;
                local CFrame2 = v58.CFrame;
                local v59 = math.floor(Size2.Y / 8);

                for i3 = 0, math.max(1, v59) - 1 do
                    local v60 = -Size2.Y / 2 + i3 * 8 + 4;
                    local Part = Instance.new("Part");
                    Part.Anchored = true;
                    Part.CanCollide = false;
                    Part.Transparency = 1;
                    Part.Size = Vector3.new(1, 1, 1);
                    Part.Parent = FruitSpawnLocations;
                    Part.Name = "SpawnPoint";
                    Part.CFrame = CFrame2 * CFrame.new(0, v60, Size2.Z / 2 + 1);
                end;
            end;
        end;

        p1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u61) -- Line: 253, Name: BeginPlantGrowth
        local PrimaryPart = u61.PrimaryPart;
        local u62 = {};
        local u63 = {};

        for _, v in u61:QueryDescendants("BasePart") do
            if v:HasTag("PlantTruss") then
                table.insert(u62, v);
            else
                local v64 = tonumber(v.Name);

                if v64 then
                    local v65 = {
                        v,
                        v.Size,
                        PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                        v64
                    };
                    table.insert(u63, v65);
                    v.CanCollide = false;
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 276
            -- upvalues: u61 (copy), u63 (copy), PrimaryPart (copy), u62 (copy)
            local v66 = u61:GetAttribute("Age") or 0;

            for _, v in u63 do
                local v67 = v[1];
                local v68 = v[2];
                local v69 = v[3];
                local v70 = math.min(v66 - v[4], 1);
                local v71 = math.clamp(v70, 0, 1);

                if v71 ~= v.lastProgress then
                    v.lastProgress = v71;

                    if v70 > 0 then
                        v67.Size = Vector3.new(v68.X, v68.Y * v70, v68.Z);
                        v67.CFrame = PrimaryPart.CFrame * v69 * CFrame.new(0, (v67.Size.Y - v68.Y) / 2, 0);
                        v67.Transparency = v67:GetAttribute("OG_Transparency") or 0;
                        v67.CanCollide = true;
                    else
                        v67.Transparency = 1;
                        v67.CanCollide = false;
                    end;
                end;
            end;

            for _, v in u62 do
                local v72 = v:GetAttribute("LeafReference");
                local v73 = tonumber(v72);

                if v73 then
                    if math.min(v66 - v73, 1) >= 1 then
                        v.Transparency = 1;
                        v.CanCollide = true;
                    else
                        v.Transparency = 1;
                        v.CanCollide = false;
                    end;
                end;
            end;
        end;

        u61:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};