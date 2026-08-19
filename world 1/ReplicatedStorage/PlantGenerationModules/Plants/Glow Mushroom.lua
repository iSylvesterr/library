-- Decompiled with Potassium's decompiler.

game:GetService("MaterialService");

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u1, p2, p3) -- Line: 9, Name: InitPlant
        local MaterialService = game:GetService("MaterialService");
        local v4 = p3 or 1;
        local u5 = Random.new(p2);
        local FruitSpawnLocations = u1.FruitSpawnLocations;
        local Base = u1.Base;

        local function GetRandomHSV(p6, p7) -- Line: 20
            -- upvalues: u5 (copy)
            local v8, v9, v10 = p6:ToHSV();
            local v11 = p7 or 0.05;
            local v12 = v8 + u5:NextNumber(-v11, v11);
            local v13 = math.clamp(v12, 0, 0.99);

            return Color3.fromHSV(v13, v9, v10), v13, v9, v10;
        end;

        local u14 = Color3.fromRGB(180, 170, 158);
        local v15, v16, v17 = Color3.fromRGB(100, 0, 192):ToHSV();
        local v18 = 0.1 or 0.05;
        local v19 = v15 + u5:NextNumber(-v18, v18);
        local v20 = math.clamp(v19, 0, 0.99);
        local u21 = Color3.fromHSV(v20, v16, v17);

        local function CreatePart(p22, p23, p24) -- Line: 31
            -- upvalues: u1 (copy), MaterialService (copy)
            local Part = Instance.new("Part");
            local v25 = p22 or "Studs";
            Part.Parent = u1;
            Part.TopSurface = Enum.SurfaceType[v25];
            Part.BackSurface = Enum.SurfaceType[v25];
            Part.FrontSurface = Enum.SurfaceType[v25];
            Part.BottomSurface = Enum.SurfaceType[v25];
            Part.LeftSurface = Enum.SurfaceType[v25];
            Part.RightSurface = Enum.SurfaceType[v25];
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Transparency = 0;

            if p24 then
                Part.Shape = Enum.PartType[p24];
            end;

            if p23 then
                Part.MaterialVariant = p23;
                local v26 = MaterialService:FindFirstChild(p23, true);

                if not v26 then
                    return Part;
                end;

                Part.Material = v26.BaseMaterial;
            end;

            return Part;
        end;

        local u27 = 0.8;

        local function CreateStem(p28, p29, p30, p31, p32) -- Line: 63
            -- upvalues: CreatePart (copy), u5 (copy), u14 (copy), FruitSpawnLocations (copy), u1 (copy), u21 (copy), CreateStem (copy), u27 (ref)
            local Y = p29.Y;
            local v33 = Y;

            for i = 1, p28 do
                local v34 = CreatePart(nil, "2022 Inlet");
                v34.Size = p29;
                local Angles = CFrame.Angles;
                local v35 = u5:NextNumber(-6, 6);
                local v36 = math.rad(v35);
                local v37 = u5:NextNumber(-6, 6);
                v34.CFrame = p30 * Angles(v36, 0.2617993877991494, (math.rad(v37))) * CFrame.new(0, p29.Y / 2.2, 0);
                v34.Color = u14;
                v34.Name = tostring(i + p31);

                if p32 and i ~= p28 then
                    local v38 = CreatePart();
                    v38.Parent = FruitSpawnLocations;
                    local v39 = v34.CFrame * CFrame.new(0, p29.Y / 2, 0);
                    local Angles2 = CFrame.Angles;
                    local v40 = u5:NextNumber(-180, 180);
                    v38.CFrame = v39 * Angles2(0, math.rad(v40), 0.7853981633974483);
                    v38.Size = Vector3.new(1, 1, 1);
                    v38.Transparency = 1;
                end;

                p30 = v34.CFrame * CFrame.new(0, p29.Y / 2.2, 0);
                Y = math.clamp(Y * 1.15, 0, v33 * 2);

                if u5:NextInteger(1, 4) == 1 or i == p28 then
                    local v41 = script.MushroomTop:Clone();
                    v41.Parent = u1;
                    v41:ScaleTo((i == p28 and u5:NextNumber(0.65, 0.75) or u5:NextNumber(0.19, 0.27)) * p29.X);
                    v41:PivotTo(p30);

                    if i ~= p28 then
                        v41["3"]:Destroy();
                    end;

                    for _, child in v41:GetChildren() do
                        local v42 = tonumber(child.Name);

                        if v42 then
                            if v42 > 1 then
                                child.Color = u21;
                            end;

                            if v42 == 3 then
                                local CFrame2 = child.CFrame;
                                local Angles2 = CFrame.Angles;
                                local v43 = u5:NextNumber(-10, 10);
                                child.CFrame = CFrame2 * Angles2(0, math.rad(v43), 0);
                            end;

                            if v42 > 1 and i == p28 then
                                local v44 = 90;

                                for _ = 1, 2 do
                                    for _ = 1, u5:NextInteger(3, 6) do
                                        local v45 = u5:NextNumber(p29.X * 0.15, p29.X * 0.2);
                                        local v46 = CreatePart();
                                        local v47 = {
                                            X = 0,
                                            Y = u5:NextNumber(-child.Size.Y, child.Size.Y) * 0.35,
                                            Z = u5:NextNumber(-child.Size.Z, child.Size.Z) * 0.3
                                        };
                                        v46.Material = Enum.Material.Neon;
                                        v46.Size = Vector3.new(v45, child.Size.Z + 0.2, v45);
                                        v46.CFrame = child.CFrame * CFrame.Angles(0, math.rad(v44), 0) * CFrame.new(v47.X, v47.Y, v47.Z) * CFrame.Angles(0, 0, 1.5707963267948966);
                                        v46.Color = Color3.fromRGB(180, 170, 158);
                                        v46.Name = i + p31 + v42 + 1;
                                    end;

                                    v44 = v44 * 2;
                                end;
                            end;

                            child.Name = v42 + i + p31;
                            child.Parent = u1;
                        end;
                    end;
                end;

                if u5:NextInteger(1, 5) == 1 and (p32 and i ~= p28) then
                    local v48 = u5:NextInteger(2, 3);
                    local v49 = Vector3.new(p29.X, p29.Y * 0.75, p29.Z) * 0.7;
                    local Angles2 = CFrame.Angles;
                    local v50 = u5:NextNumber(-180, 180);
                    CreateStem(v48, v49, p30 * Angles2(0, math.rad(v50), 0.7853981633974483), i);
                end;

                p29 = Vector3.new(p29.X * u27, Y, p29.Z * u27);
            end;
        end;

        local v51 = u5:NextNumber(1.9, 2.3) * v4;
        local v52 = u5:NextNumber(4.5, 6) * v4;
        local v53 = u5:NextInteger(3, 4);

        while u5:NextInteger(1, 100) == 1 do
            v53 = v53 * 2;
            v51 = v51 * 2;
            u27 = 0.9;
        end;

        local v54 = Vector3.new(v51, v52, v51);
        local _ = 1 * v4;
        CreateStem(v53, v54, Base.CFrame, 0, true);
        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u55) -- Line: 173, Name: BeginPlantGrowth
        local PrimaryPart = u55.PrimaryPart;
        local u56 = {};

        for _, v in u55:QueryDescendants("BasePart") do
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

        local function updateGrowth() -- Line: 191
            -- upvalues: u55 (copy), u56 (copy), PrimaryPart (copy)
            local v59 = u55:GetAttribute("Age") or 0;

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
        end;

        u55:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};