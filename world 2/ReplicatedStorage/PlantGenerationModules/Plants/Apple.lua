-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(p1, p2, p3) -- Line: 6, Name: InitPlant
        local v4 = p3 or 1;
        local v5 = Random.new(p2);
        local FruitSpawnLocations = p1.FruitSpawnLocations;
        local Base = p1.Base;
        local Stud_Part = script.Stud_Part;
        local v6 = p1:GetAttribute("Mutation") ~= nil;
        local v7 = Color3.fromRGB(139, 90, 43);
        local v8 = 2 + v4;
        local v9 = Base.CFrame * CFrame.new(0, -Base.Size.Y / 2, 0);
        local Size = Base.Size;
        local v10 = 2 + (v4 * 0.5 + 0.5);
        local v11 = 7 + (v4 * 0.5 + 0.5);
        local v12 = v10;
        local v13 = v11;
        local v14 = 0;
        local v15 = 0.9;
        local v16 = {};
        local v17 = {};
        local v18 = nil;

        while v5:NextInteger(1, 200) == 1 do
            v8 = v8 * v5:NextInteger(7, 12);
            v10 = v10 * v5:NextInteger(5, 7);
            v15 = 0.95;

            while v5:NextInteger(1, 70) == 1 do
                v10 = v10 * v5:NextInteger(2, 3);
                v8 = v8 * v5:NextInteger(2, 3);
            end;
        end;

        for _ = 1, v8 do
            if v12 > 0.5 then
                v18 = Stud_Part:Clone();
                v18.Size = Vector3.new(v12, v13, v12);
                v18.CFrame = v9 * CFrame.new(0, v18.Size.Y / 2 + Size.Y / 2, 0);

                if not v6 then
                    v18.Color = v7;
                end;

                v18.Parent = p1;
                v14 = v14 + 1;
                v18.Name = tostring(v14);
                v9 = v18.CFrame;
                Size = v18.Size;
                v12 = v12 * v15;
                v13 = v13 * v15;
                table.insert(v16, v18);
            end;
        end;

        table.insert(v17, v18);
        local v19 = v14 + 1;
        local _ = 7 + (v4 * 0.5 + 0.5);
        local v20 = 0;

        for _, v in pairs(v16) do
            v20 = v20 + 1;

            for _ = 1, v5:NextInteger(0, v.Size.Y * 0.5) do
                local v21 = 0;
                local v22 = nil;

                while v22 == nil and v21 < 50 do
                    v21 = v21 + 1;
                    local v23 = v5:NextInteger(0, 360);
                    local v24 = math.clamp(v10 * 0.5, 0.1, v.Size.X * 0.5);
                    local v25 = Vector3.new(v24, v11, v24);
                    local v26;

                    if v18 == v then
                        local v27 = v.CFrame * CFrame.new(0, -v5:NextInteger(-v.Size.Y * 3, v.Size.Y * 10) * 0.04, 0);
                        local Angles = CFrame.Angles;
                        local v28 = math.rad(v23);
                        local v29 = v5:NextInteger(45, 70);
                        v26 = v27 * Angles(0, v28, (math.rad(v29))) * CFrame.new(0, v25.Y / 2, 0);
                    else
                        local v30 = v.CFrame * CFrame.new(0, -v5:NextInteger(-v.Size.Y * 10, v.Size.Y * 10) * 0.04, 0);
                        local Angles = CFrame.Angles;
                        local v31 = math.rad(v23);
                        local v32 = v5:NextInteger(45, 70);
                        v26 = v30 * Angles(0, v31, (math.rad(v32))) * CFrame.new(0, v25.Y / 2, 0);
                    end;

                    local Position = v26.Position;
                    local LookVector = v26.LookVector;
                    local v33 = true;

                    for _, v2 in pairs(v17) do
                        if v2 ~= v18 and not table.find(v16, v2) then
                            local Magnitude = (v2.Position - Position).Magnitude;

                            if Magnitude < 5 then
                                v33 = false;
                                break;
                            end;

                            if Magnitude < 10 then
                                local v34 = LookVector:Dot(v2.CFrame.LookVector);
                                local v35 = math.clamp(v34, -1, 1);
                                local v36 = math.acos(v35);

                                if math.deg(v36) < 20 then
                                    v33 = false;
                                    break;
                                end;
                            end;
                        end;
                    end;

                    if v33 then
                        v22 = Stud_Part:Clone();
                        v22.Size = v25;
                        v22.CFrame = v26;
                        v22.Name = tostring(v19);

                        if v18 == v and not v6 then
                            v22.Color = Color3.new(1, 1, 1);
                        end;

                        if not v6 then
                            v22.Color = v7;
                        end;

                        table.insert(v17, v22);
                        v22.Parent = p1;
                    end;
                end;
            end;
        end;

        local v37 = v19 + 1;
        local v38 = {};

        for _, v in pairs(v17) do
            local v39 = Stud_Part:Clone();
            v39.Shape = Enum.PartType.Ball;

            if v6 then
                v5:NextInteger(250, 375);
                v5:NextInteger(7, 12);
                v5:NextInteger(4, 7);
            else
                local fromHSV = Color3.fromHSV;
                local v40 = v5:NextInteger(250, 375) * 0.001;
                local v41 = v5:NextInteger(7, 12);
                v39.Color = fromHSV(v40, math.clamp(v41, 7, 10) * 0.1, v5:NextInteger(4, 7) * 0.1);
            end;

            local v42 = 10 * (v4 * 0.1 + 0.9);
            local v43;

            if v18 == v then
                v43 = v42 * 1.5;
            else
                v43 = v42 * 0.75;
            end;

            v39.Size = Vector3.new(v43, v43, v43);
            v39.CFrame = v.CFrame * CFrame.new(0, v.Size.Y / 2 + v39.Size.Y / 2 - 1, 0);
            v39.Name = tostring(v37);
            v39.Parent = p1;
            table.insert(v38, v39);
        end;

        local v44 = RaycastParams.new();
        v44.FilterType = Enum.RaycastFilterType.Include;
        v44.FilterDescendantsInstances = { p1 };

        for _, v in pairs(v38) do
            local Position = v.Position;
            local v45 = v.Size.X / 2;

            for _ = 1, math.round(v.Size.X) * 0.5 do
                local v46 = v5:NextInteger(0, 360);
                local v47 = math.rad(v46);
                local v48 = v5:NextInteger(15, 165);
                local v49 = math.rad(v48);
                local v50 = math.sin(v49) * math.cos(v47);
                local v51 = math.cos(v49);
                local v52 = math.sin(v49) * math.sin(v47);
                local Unit = Vector3.new(v50, v51, v52).Unit;
                local v53 = workspace:Raycast(Position + Unit * (v45 + 5), -Unit * (v45 + 10), v44);

                if v53 and v53.Instance == v then
                    local Part = Instance.new("Part");
                    Part.Size = Vector3.new(1, 1, 1);
                    Part.Transparency = 1;
                    Part.Anchored = true;
                    Part.CanCollide = false;
                    Part.Position = v53.Position;
                    Part.Name = "FruitSpawn";
                    Part.Parent = FruitSpawnLocations;
                end;
            end;
        end;

        p1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u54) -- Line: 224, Name: BeginPlantGrowth
        local PrimaryPart = u54.PrimaryPart;
        local u55 = {};
        local u56 = {};

        for _, v in u54:QueryDescendants("BasePart") do
            if v:HasTag("PlantTruss") then
                table.insert(u55, v);
            else
                local v57 = tonumber(v.Name);

                if v57 then
                    local v58 = {
                        v,
                        v.Size,
                        PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                        v57
                    };
                    table.insert(u56, v58);
                    v.CanCollide = false;
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 247
            -- upvalues: u54 (copy), u56 (copy), PrimaryPart (copy), u55 (copy)
            local v59 = u54:GetAttribute("Age") or 0;

            for _, v in u56 do
                local v60 = v[1];
                local v61 = v[2];
                local v62 = v[3];
                local v63 = math.min(v59 - v[4], 1);
                local v64 = math.clamp(v63, 0, 1);

                if v64 ~= v.lastProgress then
                    v.lastProgress = v64;

                    if v63 > 0 then
                        v60.Size = Vector3.new(v61.X, v61.Y * v63, v61.Z);
                        v60.CFrame = PrimaryPart.CFrame * v62 * CFrame.new(0, (v60.Size.Y - v61.Y) / 2, 0);
                        v60.Transparency = v60:GetAttribute("OG_Transparency") or 0;
                        v60.CanCollide = true;
                    else
                        v60.Transparency = 1;
                        v60.CanCollide = false;
                    end;
                end;
            end;

            for _, v in u55 do
                local v65 = v:GetAttribute("TrunkReference");
                local v66 = tonumber(v65);

                if v66 then
                    if math.min(v59 - v66, 1) >= 1 then
                        v.CanCollide = true;
                    else
                        v.CanCollide = false;
                    end;
                end;
            end;

            if game.Players.LocalPlayer and (game:GetService("RunService"):IsClient() and (not u54:GetAttribute("playedSfx") and u54:GetAttribute("MaxAge") <= v59)) then
                u54:SetAttribute("playedSfx", true);
                game.SoundService:PlayLocalSound(game.SoundService.SFX.Happy);
            end;
        end;

        u54:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};