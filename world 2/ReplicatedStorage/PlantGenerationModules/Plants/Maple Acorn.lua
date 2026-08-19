-- Decompiled with Potassium's decompiler.

local MaterialService = game:GetService("MaterialService");

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u1, p2, p3) -- Line: 9, Name: InitPlant
        -- upvalues: MaterialService (copy)
        local u4 = Random.new(p2);
        local FruitSpawnLocations = u1.FruitSpawnLocations;
        local Base = u1.Base;
        local u5 = (p3 or 1) * 0.25 + 0.75;

        local function GetRandomHSV(p6, p7) -- Line: 18
            -- upvalues: u4 (copy)
            local v8, v9, v10 = p6:ToHSV();
            local v11 = p7 or 0.05;
            local v12 = v8 + u4:NextNumber(-v11, v11);

            return Color3.fromHSV(v12, v9, v10), v12, v9, v10;
        end;

        local v13, v14, v15 = Color3.fromRGB(141, 94, 39):ToHSV();
        local v16 = 0.03 or 0.05;
        local v17 = v13 + u4:NextNumber(-v16, v16);
        local u18 = Color3.fromHSV(v17, v14, v15);
        local u19 = Color3.fromRGB(184, 94, 28);
        local u20 = Color3.fromRGB(171, 117, 26);

        local function Recolor(p21, p22, p23, p24) -- Line: 29
            local v25, v26, v27 = p21:ToHSV();

            return Color3.fromHSV(v25 + p22, v26 + p23, v27 + p24);
        end;

        local v28, v29, v30 = u18:ToHSV();
        local v31 = Color3.fromHSV(v28 + 0, v29 + 0, v30 + -0.075);

        local function GetLeafColor() -- Line: 35
            -- upvalues: u4 (copy), u19 (copy), u20 (copy)
            return u4:NextInteger(1, 2) == 1 and u19 or u20;
        end;

        local function CreatePart(p32, p33, p34) -- Line: 40
            -- upvalues: u1 (copy), MaterialService (ref)
            local Part = Instance.new("Part");
            local v35 = p32 or "Studs";
            Part.Parent = u1;
            Part.TopSurface = Enum.SurfaceType[v35];
            Part.BackSurface = Enum.SurfaceType[v35];
            Part.FrontSurface = Enum.SurfaceType[v35];
            Part.BottomSurface = Enum.SurfaceType[v35];
            Part.LeftSurface = Enum.SurfaceType[v35];
            Part.RightSurface = Enum.SurfaceType[v35];
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Transparency = 1;

            if p34 then
                Part.Shape = Enum.PartType[p34];
            end;

            if p33 then
                Part.MaterialVariant = p33;
                local v36 = MaterialService:FindFirstChild(p33, true);

                if not v36 then
                    return Part;
                end;

                Part.Material = v36.BaseMaterial;
            end;

            return Part;
        end;

        local v37 = u4:NextNumber(4, 4.65) * u5;
        local v38 = u4:NextNumber(4.25, 5.25) * u5;
        local v39 = u4:NextInteger(5, 6) * u5;

        while u4:NextInteger(1, 4) == 1 and v39 < 10 do
            v39 = v39 + 1;
        end;

        local v40 = Vector3.new(v37, v38, v37);
        local CFrame2 = Base.CFrame;
        local u41 = 1;
        local u42 = 1 * u5;

        local function CreateLeaves(p43, p44, p45, p46) -- Line: 85
            -- upvalues: u4 (copy), u5 (ref), CreatePart (copy), u19 (copy), u20 (copy), FruitSpawnLocations (copy)
            local v47 = u4:NextNumber(5.85, 7.25) * p45 * u5;
            local v48 = CreatePart(nil, "2022 Weld");
            v48.Size = Vector3.new(v47, v47 * 0.8, v47);
            v48.CFrame = p43;
            v48.Orientation = Vector3.new(v48.Orientation.X * 0.2, v48.Orientation.Y, v48.Orientation.Z * 0.2);
            v48.CFrame = v48.CFrame * CFrame.new(0, v48.Size.Y * 0.35, 0);
            v48.Color = u4:NextInteger(1, 2) == 1 and u19 or u20;
            v48.Name = tostring(p44 + 1);

            for i = 1, 2 do
                local v49 = CreatePart(nil, "2022 Weld");
                local v50 = v47 * u4:NextNumber(1.2, 1.35);
                v49.Size = Vector3.new(v47 * 0.75, v47 * 0.55, v50);
                local CFrame3 = v48.CFrame;
                local Angles = CFrame.Angles;
                local v51 = u4:NextNumber(-5, 5);
                local v52 = math.rad(v51);
                local v53 = math.rad(i * 90);
                local v54 = u4:NextNumber(-5, 5);
                v49.CFrame = CFrame3 * Angles(v52, v53, (math.rad(v54)));
                v49.Color = u4:NextInteger(1, 2) == 1 and u19 or u20;
                v49.Name = tostring(p44 + 2);
            end;

            if u4:NextInteger(1, 3) == 1 or p46 then
                local v55 = CreatePart(nil, "2022 Weld");
                v55.Size = Vector3.new(v47 * 0.75, v47 * 0.25, v47 * 0.75);
                local v56 = v48.CFrame * CFrame.new(0, v48.Size.Y / 2, 0);
                local Angles = CFrame.Angles;
                local v57 = u4:NextNumber(-10, 10);
                local v58 = math.rad(v57);
                local v59 = u4:NextNumber(-10, 10);
                v55.CFrame = v56 * Angles(v58, math.rad(v59), 0);
                v55.Color = u4:NextInteger(1, 2) == 1 and u19 or u20;
                v55.Name = tostring(p44 + 2);
            end;

            if u4:NextInteger(1, 3) == 1 then
                for _ = 1, u4:NextInteger(1, 3) do
                    local v60 = CreatePart(nil, "2022 Weld");
                    local v61 = u4:NextNumber(v47 * 0.65, v47 * 0.75);
                    local v62 = u4:NextNumber(-v47, v47) / 2.25;
                    local v63 = u4:NextNumber(-v47, v47) * 0.35;
                    local v64 = u4:NextNumber(-v47, v47) / 2.25;
                    v60.Size = Vector3.new(v61, v61 * 0.75, v61);
                    v60.CFrame = v48.CFrame * CFrame.new(v62, v63, v64);
                    v60.Color = u4:NextInteger(1, 2) == 1 and u19 or u20;
                    v60.Name = tostring(p44 + 2);
                end;
            end;

            if p46 then
                return v48;
            end;

            for i = 1, 3 do
                local v65 = CreatePart();
                local v66 = i * 120 + u4:NextNumber(-35, 35);
                v65.Size = Vector3.new(1, 1, 1);
                v65.CFrame = v48.CFrame * CFrame.Angles(0, math.rad(v66), 0) * CFrame.new(0, -v48.Size.Y / 2, v48.Size.Z * 0.35);
                v65.Parent = FruitSpawnLocations;
                v65.Transparency = 1;
            end;

            return v48;
        end;

        local function CreateBranch(p67, p68, p69) -- Line: 151
            -- upvalues: u41 (ref), CreatePart (copy), u4 (copy), u18 (copy), CreateLeaves (copy), u42 (ref)
            local v70 = 5;
            local Y = p68.Y;

            if u41 > 3 then
                v70 = v70 - 1;

                if u41 > 5 then
                    v70 = v70 - 1;
                end;
            end;

            for i = 1, v70 do
                local v71 = CreatePart(nil, "2022 Stud Bark");
                local v72 = u4:NextNumber(-25, -15);

                if i > 2 then
                    v72 = -v72;

                    if i == v70 then
                        v72 = v72 * 1.5;
                    end;
                end;

                v71.Size = p68;
                local Angles = CFrame.Angles;
                local v73 = math.rad(v72);
                local v74 = u4:NextNumber(-10, 10);
                v71.CFrame = p67 * Angles(v73, 0, (math.rad(v74))) * CFrame.new(0, p68.Y / 2.2, 0);
                v71.Color = u18;
                v71.Name = tostring(p69 + i);
                p67 = v71.CFrame * CFrame.new(0, p68.Y / 2.2, 0);
                local v75 = p68.X * 0.85;
                local v76 = Y * u4:NextNumber(0.925, 1.05);
                p68 = Vector3.new(v75, v76, p68.Z * 0.85);
            end;

            CreateLeaves(p67, p69 + v70, u42);
        end;

        for i = 1, v39 do
            local v77 = CreatePart(nil, "2022 Stud Bark");
            v77.Size = v40;
            local Angles = CFrame.Angles;
            local v78 = u4:NextNumber(-2, 2);
            local v79 = math.rad(v78);
            local v80 = u4:NextNumber(-2, 2);
            v77.CFrame = CFrame2 * Angles(v79, 0, (math.rad(v80))) * CFrame.new(0, v40.Y / 2.2, 0);
            v77.Color = v31:Lerp(u18, (math.min((i - 1) / 3, 1)));
            v77.Name = tostring(i);
            CFrame2 = v77.CFrame * CFrame.new(0, v40.Y / 2.2, 0);
            local v81 = v40.Y * 1.075;

            if u4:NextInteger(1, 3) == 1 and i < v39 - 2 then
                local v82 = CreatePart(nil, "2022 Stud Bark");
                v82.Size = Vector3.new(v40.X * 0.35, v40.Y * 1.25, v40.Z * 0.35);
                local CFrame3 = v77.CFrame;
                local Angles2 = CFrame.Angles;
                local v83 = u4:NextNumber(-180, 180);
                local v84 = CFrame3 * Angles2(0, math.rad(v83), 0) * CFrame.new(0, 0, -v77.Size.Z / 2);
                local Angles3 = CFrame.Angles;
                local v85 = u4:NextNumber(-60, -40);
                v82.CFrame = v84 * Angles3(math.rad(v85), 0, 0);
                v82.Color = u18;
                v82.Name = tostring(i + 1);
                CreateLeaves(v82.CFrame * CFrame.new(0, v82.Size.Y / 2, 0), i + 1, 0.5, true);
            end;

            if i == 1 then
                v81 = v81 - 1 * u5;
                local v86 = u4:NextInteger(1, 4);

                for i2 = 1, v86 do
                    local v87 = u4:NextInteger(2, 4);
                    local v88 = 360 / v86 * i2 + u4:NextNumber(-20, 20);
                    local v89 = Vector3.new(v37 * 0.65, v37 * 0.725, v37 * 0.65);
                    local v90 = v77.CFrame * CFrame.new(0, v77.Size.Y * 0.25, 0) * CFrame.Angles(0, math.rad(v88), 1.5707963267948966) * CFrame.new(0, v37 * 0.3, 0);

                    for i3 = 1, v87 do
                        local v91 = CreatePart(nil, "2022 Stud Bark");
                        local v92 = u4:NextNumber(47, 41);

                        if i3 > 1 then
                            v92 = u4:NextNumber(-20, -13);
                        end;

                        v91.Size = v89;
                        local Angles2 = CFrame.Angles;
                        local v93 = u4:NextNumber(-20, 20);
                        v91.CFrame = v90 * Angles2(math.rad(v93), 0, (math.rad(i3 == 4 and 0 or v92))) * CFrame.new(0, v91.Size.Y / 2.2, 0);
                        v91.Color = v31;
                        v91.Name = tostring(i + i3);
                        v90 = v91.CFrame * CFrame.new(0, v91.Size.Y / 2.2, 0);
                        v89 = v89 * 0.85;
                    end;
                end;
            end;

            if u41 + 2 < i then
                u41 = i;
                local v94 = u4:NextInteger(3, 5);

                for i2 = 1, v94 do
                    local v95 = 360 / v94 * i2 + u41 * u4:NextNumber(18, 25);
                    CreateBranch(v77.CFrame * CFrame.new(0, -v77.Size.Y * 0.65, 0) * CFrame.Angles(0, math.rad(v95), 0) * CFrame.Angles(-0.6108652381980153, 0, 0), v77.Size * 0.725, i);
                end;

                u42 = u42 - 0.175;
            end;

            v40 = Vector3.new(v40.X * 0.85, v81, v40.Z * 0.85);
        end;

        local v96 = CreateLeaves(CFrame2, v39, u4:NextNumber(1.475, 1.725));
        script.LeafParticle:Clone().Parent = v96;
        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u97) -- Line: 269, Name: BeginPlantGrowth
        local PrimaryPart = u97.PrimaryPart;
        local u98 = {};

        for _, v in u97:QueryDescendants("BasePart") do
            local v99 = tonumber(v.Name);

            if v99 then
                local v100 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v99
                };
                table.insert(u98, v100);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 287
            -- upvalues: u97 (copy), u98 (copy), PrimaryPart (copy)
            local v101 = u97:GetAttribute("Age") or 0;
            local v102 = u97:GetAttribute("MaxAge") or 1;

            for _, v in u98 do
                local v103 = v[1];
                local v104 = v[2];
                local v105 = v[3];
                local v106 = math.min(v101 - v[4], 1);
                local v107 = math.clamp(v106, 0, 1);

                if v107 ~= v.lastProgress then
                    v.lastProgress = v107;

                    if v106 > 0 then
                        v103.Size = Vector3.new(v104.X, v104.Y * v106, v104.Z);
                        v103.CFrame = PrimaryPart.CFrame * v105 * CFrame.new(0, (v103.Size.Y - v104.Y) / 2, 0);
                        v103.Transparency = v103:GetAttribute("OG_Transparency") or 0;
                        v103.CanCollide = true;
                    else
                        v103.Transparency = 1;
                        v103.CanCollide = false;
                    end;
                end;
            end;

            if v102 <= v101 then
                for _, v in u97:QueryDescendants("ParticleEmitter") do
                    v.Enabled = true;
                end;
            end;
        end;

        u97:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};