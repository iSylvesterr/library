-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u1, p2, p3) -- Line: 7, Name: InitPlant
        local u4 = p3 or 1;
        local u5 = Random.new(p2);
        local FruitSpawnLocations = u1.FruitSpawnLocations;
        local Base = u1.Base;
        local Stud_Part = script.Stud_Part;
        local _ = p2 + #u1:GetChildren() * u5:NextInteger(3, 90);
        local u6 = 1 * (u4 * 0.5 + 0.5);
        local u7 = 3 * (u4 * 0.5 + 0.5);

        while u5:NextInteger(1, 100) == 1 do
            u7 = u7 * 2;
        end;

        local v8 = Color3.fromRGB(207, 160, 0);
        local u9 = Color3.fromRGB(210, 131, 12);
        local u10 = Base.Position.Y - Base.Size.Y / 2 + 7;
        local u11 = {};
        local u12 = 0;

        local function createPart(p13) -- Line: 33
            -- upvalues: Stud_Part (copy), u1 (copy)
            local v14 = Stud_Part:Clone();
            local v15 = p13 or "Studs";
            v14.TopSurface = Enum.SurfaceType[v15];
            v14.BackSurface = Enum.SurfaceType[v15];
            v14.FrontSurface = Enum.SurfaceType[v15];
            v14.BottomSurface = Enum.SurfaceType[v15];
            v14.LeftSurface = Enum.SurfaceType[v15];
            v14.RightSurface = Enum.SurfaceType[v15];
            v14.Anchored = true;
            v14.CanCollide = false;
            v14.Transparency = 0;
            v14.Parent = u1;

            return v14;
        end;

        local function Generate_Part(p16, p17, p18, p19) -- Line: 52
            -- upvalues: u6 (copy), u7 (ref), Stud_Part (copy), u12 (ref), u1 (copy)
            local v20 = Vector3.new(u6, u7, u6);
            local v21 = p16.CFrame * CFrame.new(0, p16.Size.Y / 2, 0) * CFrame.Angles(math.rad(p17), math.rad(p19), (math.rad(p18))) * CFrame.new(0, v20.Y / 2, 0);
            local v22 = Stud_Part:Clone();
            v22.Size = v20;
            v22.CFrame = v21;
            u12 = u12 + 1;
            v22.Name = tostring(u12);
            v22.Parent = u1;
            v22.Color = p16.Color;

            return v22;
        end;

        local function Generate_Wind(p23, p24) -- Line: 71
            -- upvalues: u5 (copy), Generate_Part (copy), u11 (copy)
            local v25 = 0;
            local v26 = 0;
            local v27 = u5:NextInteger(3, 20);

            if u5:NextInteger(1, 2) == 1 then
                v27 = -v27;
            end;

            local v28 = u5:NextInteger(-45, 45);
            local v29 = u5:NextInteger(-45, 45);

            while p24 > 0 do
                if v28 >= 1 and v25 < v28 then
                    v25 = v25 + 5;
                elseif v28 < 0 and v28 < v25 then
                    v25 = v25 - 5;
                end;

                if v29 >= 1 and v26 < v29 then
                    v26 = v26 + 5;
                elseif v29 < 0 and v29 < v26 then
                    v26 = v26 - 5;
                end;

                local v30 = Generate_Part(p23, v25, v26, v27);

                if v30 then
                    table.insert(u11, v30);
                else
                    v30 = p23;
                end;

                p24 = p24 - 1;
                p23 = v30;
            end;
        end;

        local function AttachWedge(p31, p32) -- Line: 105
            -- upvalues: createPart (copy), u9 (copy)
            for i = -1, 1, 2 do
                local v33 = createPart("Weld");
                v33.Size = Vector3.new(p31.Size.Z, p31.Size.Y * 0.5, p31.Size.X / 2);
                v33.Shape = Enum.PartType.Wedge;
                v33.CFrame = p31.CFrame * CFrame.new(-i * p31.Size.X / 4, p31.Size.Y / 2 + p31.Size.Y * 0.5 / 2 - 0.025, 0) * CFrame.Angles(0, math.rad(i * 90), 0);
                v33.Color = u9;
                v33.Name = tostring(p32);
                v33:AddTag("DetailPart");
            end;
        end;

        local function Add_Leaf(p34, p35) -- Line: 123
            -- upvalues: u4 (ref), u5 (copy), createPart (copy), u9 (copy), AttachWedge (copy), FruitSpawnLocations (copy), u10 (copy)
            local v36 = Vector3.new(1, 1, 0.1) * u4;
            local v37 = u5:NextInteger(1, 2) == 1 and 1 or -1;
            local v38 = createPart("Weld");
            v38.Size = v36;
            v38.CFrame = p34.CFrame * CFrame.new(v37 * (p34.Size.X / 2 + v36.Y / 2 - 0.05), 0, 0);
            v38.CFrame = v38.CFrame * CFrame.Angles(0, 0, (math.rad(v37 * -90)));
            v38.Color = u9;
            v38.Name = tostring(p35);
            v38:AddTag("DetailPart");
            local v39 = createPart("Weld");
            v39.Size = v36;
            local v40 = u5:NextInteger(25, 45);
            v39.CFrame = v38.CFrame * CFrame.new(0, v38.Size.Y / 2, 0) * CFrame.Angles(-math.rad(v40), 0, 0) * CFrame.new(0, v39.Size.Y / 2 - 0.025, 0);
            v39.Color = u9;
            v39.Name = tostring(p35);
            v39:AddTag("DetailPart");
            AttachWedge(v39, p35);
            local v41 = p34.CFrame - Vector3.new(0, 2, 0);
            local v42 = true;

            for _, child in pairs(FruitSpawnLocations:GetChildren()) do
                if (child.Position - v41.Position).Magnitude < 4 then
                    v42 = false;
                end;
            end;

            if v42 == true and v41.Position.Y > u10 + 2 then
                local Part = Instance.new("Part");
                Part.Size = Vector3.new(0.1, 0.1, 0.1) * u4;
                Part.Anchored = true;
                Part.CanCollide = false;
                Part.Transparency = 1;
                Part.Name = "Fruit_Spawn";
                Part.CFrame = v41;
                local v43 = u5:NextInteger(-180, 180);
                Part.Orientation = Vector3.new(0, v43, 0);
                Part.Parent = FruitSpawnLocations;
            end;
        end;

        u12 = 1;
        local v44 = createPart("Weld");
        v44.Color = v8;
        v44.Size = Vector3.new(u6, u7, u6);
        v44.CFrame = Base.CFrame * CFrame.new(0, v44.Size.Y / 2, 0);
        v44.Name = tostring(u12);
        table.insert(u11, v44);
        local v45 = u5:NextInteger(5, 10);

        while u5:NextInteger(1, 100) == 1 do
            v45 = v45 * 2;
        end;

        local v46 = 0;

        while v45 > 0 do
            local v47 = u5:NextInteger(1, 2) == 1;
            Generate_Wind(v44, (u5:NextInteger(2, 5)));

            if #u11 > 0 then
                v44 = u11[u5:NextInteger(1, #u11)];
            end;

            v45 = v45 - 1;

            if v47 then
                v46 = v46 + 1;
            end;
        end;

        local v48 = u12 + 1;

        while v46 > 0 do
            if #u11 > 0 then
                Add_Leaf(u11[u5:NextInteger(1, #u11)], v48);
            end;

            v46 = v46 - 1;
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u49) -- Line: 230, Name: BeginPlantGrowth
        local PrimaryPart = u49.PrimaryPart;
        local u50 = {};

        for _, v in u49:QueryDescendants("BasePart") do
            local v51 = tonumber(v.Name);

            if v51 then
                local v52 = v:HasTag("DetailPart");
                local v53;

                if v52 then
                    v53 = nil;
                else
                    local v54 = v.CFrame * CFrame.new(0, -v.Size.Y / 2, 0);
                    v53 = PrimaryPart.CFrame:ToObjectSpace(v54);
                end;

                local v55 = {
                    part = v,
                    maxSize = v.Size,
                    bottomOffset = v53,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v51,
                    isDetail = v52
                };
                table.insert(u50, v55);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 260
            -- upvalues: u49 (copy), u50 (copy), PrimaryPart (copy)
            local v56 = u49:GetAttribute("Age") or 0;

            for _, v in u50 do
                local v57 = math.clamp(v56 - v.partAge, 0, 1);

                if v57 ~= v.lastProgress then
                    v.lastProgress = v57;

                    if v57 > 0 then
                        if v.isDetail then
                            v.part.Size = Vector3.new(v.maxSize.X, v.maxSize.Y * v57, v.maxSize.Z);
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, (v.part.Size.Y - v.maxSize.Y) / 2, 0);
                        else
                            v.part.Size = Vector3.new(v.maxSize.X, v.maxSize.Y * v57, v.maxSize.Z);
                            v.part.CFrame = PrimaryPart.CFrame * v.bottomOffset * CFrame.new(0, v.part.Size.Y / 2, 0);
                        end;

                        v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                        v.part.CanCollide = true;
                    else
                        v.part.Transparency = 1;
                        v.part.CanCollide = false;
                    end;
                end;
            end;
        end;

        u49:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};