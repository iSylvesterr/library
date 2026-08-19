-- Decompiled with Potassium's decompiler.

function RoundSize(p1)
    return math.round(p1 * 100) * 0.01;
end;

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(p2, p3, p4) -- Line: 11, Name: InitPlant
        local v5 = Random.new(p3);
        local FruitSpawnLocations = p2.FruitSpawnLocations;
        local Base = p2.Base;
        local v6 = p4 or 1;

        while v5:NextInteger(1, 200) == 1 do
            v6 = v6 * v5:NextInteger(3, 4);

            while v5:NextInteger(1, 50) == 1 do
                v6 = v6 * v5:NextInteger(3, 4);
            end;
        end;

        local v7 = v5:NextInteger(1, 100) == 1;
        local Part = script.Part;
        Color3.new(0, 0.666667, 0);
        Color3.new(0.368627, 0.784314, 0.254902);
        local v8 = v5:NextInteger(2, 3) + v6 * 0.25;
        local v9 = {};
        table.insert(v9, 2 * (v6 * 0.25 + 0.75));
        table.insert(v9, 3 * (v6 * 0.25 + 0.75));
        table.insert(v9, 4 * (v6 * 0.25 + 0.75));
        table.insert(v9, 5 * (v6 * 0.25 + 0.75));
        local v10 = 0;

        for i = #v9, 2, -1 do
            local v11 = v5:NextInteger(1, i);
            local v12 = v9[i];
            v9[i] = v9[v11];
            v9[v11] = v12;
        end;

        local v13 = math.min(v8, #v9);
        local _ = Base.CFrame;
        local CFrame2 = Base.CFrame;
        local v14 = {};

        for i = 1, v13 do
            local v15 = v9[i];
            local v16 = Part:Clone();
            v16.Size = Vector3.new(v15, v15 * 0.75, v15);
            v10 = v10 + 1;
            v16.Name = tostring(v10);
            v16.CFrame = CFrame2 * CFrame.new(v5:NextInteger(-v15 / 2, v15 / 2), v16.Size.Y / 4, v5:NextInteger(-v15 / 2, v15 / 2));
            v16.Parent = p2;
            table.insert(v14, v16);
            local _ = v16.CFrame;
        end;

        if v7 then
            p2:AddTag("StackedBlueberry");
            local v17 = v14[1];

            for _, v in v14 do
                if v.Size.X > v17.Size.X then
                    v17 = v;
                end;
            end;

            for i = 1, 50 do
                if i > 1 and v5:NextInteger(1, 3) ~= 1 then
                    break;
                end;

                local X = v17.Size.X;
                local Y = v17.Size.Y;
                local v18 = v5:NextNumber(2, 5) * (v6 * 0.25 + 0.5);
                local v19 = v18 * 0.75;
                local v20 = v5:NextNumber(-0.15, 0.15) * X;
                local v21 = v5:NextNumber(-0.15, 0.15) * X;
                local v22 = Part:Clone();
                v22.Size = Vector3.new(v18, v19, v18);
                v10 = v10 + 1;
                v22.Name = tostring(v10);
                v22.CFrame = v17.CFrame * CFrame.new(v20, Y / 2 + v19 / 2, v21);
                v22.Parent = p2;
                table.insert(v14, v22);
                local _ = v22.CFrame;
                v17 = v22;
            end;
        end;

        local v23 = RaycastParams.new();
        v23.FilterType = Enum.RaycastFilterType.Include;
        v23.FilterDescendantsInstances = { p2 };

        for _, v in pairs(v14) do
            local Position = v.Position;
            local v24 = v.Size.X / 2;

            for _ = 1, math.round(v.Size.X) * 0.5 do
                local v25 = v5:NextInteger(0, 360);
                local v26 = math.rad(v25);
                local v27 = v5:NextInteger(15, 165);
                local v28 = math.rad(v27);
                local v29 = math.sin(v28) * math.cos(v26);
                local v30 = math.cos(v28);
                local v31 = math.sin(v28) * math.sin(v26);
                local Unit = Vector3.new(v29, v30, v31).Unit;
                local v32 = workspace:Raycast(Position + Unit * (v24 + 5), -Unit * (v24 + 10), v23);

                if v32 and v32.Instance == v then
                    local Part2 = Instance.new("Part");
                    Part2.Size = Vector3.new(1, 1, 1);
                    Part2.Transparency = 1;
                    Part2.Anchored = true;
                    Part2.CanCollide = false;
                    Part2.Position = v32.Position;
                    Part2.Name = "FruitSpawn";
                    Part2.Parent = FruitSpawnLocations;
                end;
            end;
        end;

        p2:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u33) -- Line: 168, Name: BeginPlantGrowth
        local PrimaryPart = u33.PrimaryPart;
        local u34 = {};

        for _, v in u33:QueryDescendants("BasePart") do
            local v35 = tonumber(v.Name);

            if v35 then
                local v36 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v35
                };
                table.insert(u34, v36);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 186
            -- upvalues: u33 (copy), u34 (copy), PrimaryPart (copy)
            local v37 = u33:GetAttribute("Age") or 0;

            for _, v in u34 do
                local v38 = v[1];
                local v39 = v[2];
                local v40 = v[3];
                local v41 = math.min(v37 - v[4], 1);
                local v42 = math.clamp(v41, 0, 1);

                if v42 ~= v.lastProgress then
                    v.lastProgress = v42;

                    if v41 > 0 then
                        v38.Size = Vector3.new(v39.X, v39.Y * v41, v39.Z);
                        v38.CFrame = PrimaryPart.CFrame * v40 * CFrame.new(0, (v38.Size.Y - v39.Y) / 2, 0);
                        v38.Transparency = v38:GetAttribute("OG_Transparency") or 0;
                        v38.CanCollide = true;
                    else
                        v38.Transparency = 1;
                        v38.CanCollide = false;
                    end;
                end;
            end;
        end;

        u33:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};