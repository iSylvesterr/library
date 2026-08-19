-- Decompiled with Potassium's decompiler.

local MaterialService = game:GetService("MaterialService");

local function GetRandomHSV(p1, p2, p3) -- Line: 4
    local v4, v5, v6 = p2:ToHSV();
    local v7 = p3 or 0.05;
    local v8 = v4 + p1:NextNumber(-v7, v7);

    return Color3.fromHSV(v8, v5, v6), v8, v5, v6;
end;

local function CreatePart(p9, p10, p11, p12) -- Line: 13
    -- upvalues: MaterialService (copy)
    local Part = Instance.new("Part");
    local v13 = p10 or "Studs";
    Part.Parent = p9;
    Part.TopSurface = Enum.SurfaceType[v13];
    Part.BackSurface = Enum.SurfaceType[v13];
    Part.FrontSurface = Enum.SurfaceType[v13];
    Part.BottomSurface = Enum.SurfaceType[v13];
    Part.LeftSurface = Enum.SurfaceType[v13];
    Part.RightSurface = Enum.SurfaceType[v13];
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.Transparency = 0;

    if p12 then
        Part.Shape = Enum.PartType[p12];
    end;

    if p11 then
        Part.MaterialVariant = p11;
        local v14 = MaterialService:FindFirstChild(p11, true);

        if not v14 then
            return Part;
        end;

        Part.Material = v14.BaseMaterial;
    end;

    return Part;
end;

local function CreateMeshPart(p15, p16, p17) -- Line: 40
    local v18 = p16:Clone();
    v18.Parent = p15;
    v18.Anchored = true;
    v18.CanCollide = false;
    v18.Transparency = 0;

    if p17 then
        v18.MaterialVariant = p17;
    end;

    return v18;
end;

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u19, p20, p21) -- Line: 57, Name: InitPlant
        -- upvalues: CreatePart (copy)
        local v22 = p21 or 1;
        local u23 = Random.new(p20);
        local FruitSpawnLocations = u19.FruitSpawnLocations;
        local Base = u19.Base;
        local Leaf = script.Leaf;
        local GoopEnd = script.GoopEnd;
        local v24, v25, v26 = Color3.fromRGB(128, 90, 56):ToHSV();
        local v27 = 0.015 or 0.05;
        local v28 = v24 + u23:NextNumber(-v27, v27);
        local u29 = Color3.fromHSV(v28, v25, v26);
        local v30, v31, v32 = Color3.fromRGB(218, 85, 34):ToHSV();
        local v33 = 0.04 or 0.05;
        local v34 = v30 + u23:NextNumber(-v33, v33);
        local u35 = Color3.fromHSV(v34, v31, v32);
        local v36, v37, v38 = Color3.fromRGB(218, 85, 34):ToHSV();
        local v39 = 0.04 or 0.05;
        local v40 = v36 + u23:NextNumber(-v39, v39);
        local u41 = Color3.fromHSV(v40, v37, v38);
        local v42, v43 = Color3.fromRGB(247, 64, 42);
        local v44, v45, v46 = v42:ToHSV();
        local v47 = v43 or 0.05;
        local v48 = v44 + u23:NextNumber(-v47, v47);
        local v49 = Color3.fromHSV(v48, v45, v46);
        local v50 = u23:NextNumber(4, 5) * (v22 * 0.25 + 0.75);
        local v51 = u23:NextNumber(4.25, 5) * (v22 * 0.25 + 0.75);
        local v52 = u23:NextInteger(5, 8);
        local u53 = 1;

        while u23:NextInteger(1, 30) == 1 do
            v52 = v52 + u23:NextInteger(7, 12);
            u53 = u53 + 0.5;
        end;

        local v54 = u23:NextInteger(1, 6) == 1;
        local v55 = Vector3.new(v50, v51, v50);
        local CFrame2 = Base.CFrame;

        local function CreateLeaves(p56, p57, p58) -- Line: 91
            -- upvalues: Leaf (copy), u19 (copy), u23 (copy), u53 (ref), u35 (copy), u41 (copy), FruitSpawnLocations (copy)
            local v59 = Leaf:Clone();
            v59.Parent = u19;
            local v60 = u23:NextNumber(7, 13) * p58 * u53;
            local v61 = u23:NextNumber(4, 7) * p58 * u53;
            local v62 = u23:NextNumber(7, 13) * p58 * u53;
            v59.Size = Vector3.new(v60, v61, v62);
            v59.CFrame = p56 * CFrame.new(u23:NextNumber(-v59.Size.X, v59.Size.X) * 0.25, v59.Size.Y / 2.25, u23:NextNumber(-v59.Size.Z, v59.Size.Z) * 0.25);
            v59.Name = p57 + 1;
            v59.Color = u35;
            script.LeafParticle:Clone().Parent = v59;
            local v63 = u23:NextInteger(2, 4);
            local v64 = Leaf:Clone();
            v64.Parent = u19;
            local v65 = v59.Size.X * 0.75;
            local v66 = v59.Size.Y * u23:NextNumber(0.75, 1);
            v64.Size = Vector3.new(v65, v66, v59.Size.Z * 0.75);
            local v67 = v59.CFrame * CFrame.new(0, v59.Size.Y / 2.2 + v64.Size.Y / 2.2, 0);
            local Angles = CFrame.Angles;
            local v68 = u23:NextNumber(-5, 5);
            local v69 = math.rad(v68);
            local v70 = u23:NextNumber(-5, 5);
            v64.CFrame = v67 * Angles(0, v69, (math.rad(v70)));
            v64.Name = p57 + 2;
            v64.Color = u35;

            for i = 1, v63 do
                local v71 = Leaf:Clone();
                local v72 = u23:NextNumber(0.5, v59.Size.X) * 0.6;
                local v73 = u23:NextNumber(0, v59.Size.Y) * 0.6;
                local v74 = u23:NextNumber(0.5, v59.Size.Z) * 0.6;

                if i % 2 == 0 then
                    v72 = -v72;

                    if u23:NextInteger(1, 2) == 1 then
                        v74 = -v74;
                    end;
                end;

                v71.Parent = u19;
                local v75 = v59.Size.X * u23:NextNumber(0.65, 0.85);
                local v76 = v59.Size.Y * u23:NextNumber(0.75, 1.4);
                local v77 = v59.Size.X * u23:NextNumber(0.65, 0.85);
                v71.Size = Vector3.new(v75, v76, v77);
                v71.CFrame = v59.CFrame * CFrame.new(v72, v73, v74);
                v71.Name = p57 + 2;
                local v78;

                if i % 2 == 0 then
                    v78 = u41;
                else
                    v78 = u35;
                end;

                v71.Color = v78;
            end;

            for _ = 1, u23:NextInteger(2, 3) do
                local Part = Instance.new("Part");
                local v79 = nil or "Studs";
                Part.Parent = u19;
                Part.TopSurface = Enum.SurfaceType[v79];
                Part.BackSurface = Enum.SurfaceType[v79];
                Part.FrontSurface = Enum.SurfaceType[v79];
                Part.BottomSurface = Enum.SurfaceType[v79];
                Part.LeftSurface = Enum.SurfaceType[v79];
                Part.RightSurface = Enum.SurfaceType[v79];
                Part.Anchored = true;
                Part.CanCollide = false;
                Part.Transparency = 0;
                Part.Size = Vector3.new(1, 1, 1);
                Part.CFrame = v59.CFrame * CFrame.new(u23:NextNumber(-v59.Size.X, v59.Size.X) * 0.4, -v59.Size.Y / 2, u23:NextNumber(-v59.Size.Z, v59.Size.Z) * 0.4);
                Part.Parent = FruitSpawnLocations;
                Part.Transparency = 1;
            end;
        end;

        local function CreateBranch(p80, p81, p82, p83) -- Line: 147
            -- upvalues: u23 (copy), CreatePart (ref), u19 (copy), u29 (copy), CreateLeaves (copy)
            local v84 = u23:NextInteger(2, 3);
            local Angles = CFrame.Angles;
            local v85 = u23:NextNumber(45, 70);
            local v86 = p80 * Angles(0, 0, (math.rad(v85)));

            for i = 1, v84 do
                local v87 = CreatePart(u19, nil, "2022 Stud Bark");
                v87.Size = p81;
                local Angles2 = CFrame.Angles;
                local v88 = u23:NextNumber(-25, -10);
                v87.CFrame = v86 * Angles2(0, 0, (math.rad(v88))) * CFrame.new(0, p81.Y / 2.15, 0);
                v87.Color = u29;
                v87.Name = p82 + i;
                v86 = v87.CFrame * CFrame.new(0, p81.Y / 2.15, 0);
                p81 = p81 * 0.85;

                if i == v84 then
                    CreateLeaves(CFrame.new(v86.Position) * CFrame.Angles(0, math.rad(v87.Orientation.Y), 0), i + p82, p83 or 1);
                end;
            end;
        end;

        local v89 = {};

        for i = 1, v52 do
            local v90 = CreatePart(u19, nil, "2022 Stud Bark");
            local v91 = u23:NextNumber(-5, 5);
            local v92 = u23:NextNumber(-5, 5);

            if v54 then
                v91 = u23:NextNumber(-15, 15);
                v92 = u23:NextNumber(-15, 15);
            end;

            if i == 1 then
                v91 = 0;
                v92 = 0;
            end;

            v90.Size = v55;
            v90.CFrame = CFrame2 * CFrame.Angles(math.rad(v91), 0, (math.rad(v92))) * CFrame.new(0, v55.Y / 2.2, 0);
            v90.Color = u29;
            v90.Name = i;

            if i < v52 then
                table.insert(v89, v90);
            else
                local v93 = u23:NextInteger(2, 4);

                for i2 = 1, v93 do
                    local v94 = 360 / v93 * i2 + u23:NextNumber(-20, 20);
                    CreateBranch(v90.CFrame * CFrame.new(0, v55.Y / 2.2, 0) * CFrame.Angles(0, math.rad(v94), 0), Vector3.new(v90.Size.X * 0.7, v90.Size.Y * 0.8, v90.Size.Z * 0.7), i, 1.25);
                end;
            end;

            if u23:NextInteger(1, 3) == 1 then
                local v95 = CreatePart(u19, nil, "Stripes");
                local v96 = u23:NextNumber(1.5, 3.5);
                v95.Size = Vector3.new(0.15, v96, 0.15);
                local v97 = CFrame.new(v90.CFrame.Position) * CFrame.Angles(0, 0, 3.141592653589793) * CFrame.new(0, v90.Size.X / 2 + v95.Size.Y / 2, 0);
                local Angles = CFrame.Angles;
                local v98 = u23:NextNumber(-30, 30);
                v95.CFrame = v97 * Angles(0, math.rad(v98), 0);
                v95.Color = v49;
                v95.Name = i + 1;
                local v99 = GoopEnd:Clone();
                v99.Parent = u19;
                v99:PivotTo(v95.CFrame * CFrame.new(0, v95.Size.Y / 2, 0));

                for _, child in v99:GetChildren() do
                    child.Name = tonumber(child.Name) + i + 1;
                    child.Parent = u19;
                end;
            end;

            CFrame2 = v90.CFrame * CFrame.new(0, v55.Y / 2.2, 0);
            local v100 = math.clamp(v55.X * 0.875, 1, v50);
            local v101 = v55.Y * 1.05;
            local v102 = v51 + u23:NextNumber(0.75, 1.1);
            local v103 = math.clamp(v101, 0, v102);
            local v104 = math.clamp(v55.Z * 0.875, 1, v50);
            v55 = Vector3.new(v100, v103, v104);
        end;

        for i = 1, 2 do
            local v105 = 360 / v52;

            if i == 1 then
                v105 = v105 + 180;
            end;

            local CFrame3 = Base.CFrame;
            local new = CFrame.new;
            local v106 = math.rad(v105);
            local v107 = math.cos(v106) * v50;
            local v108 = math.sin(v105);
            local v109 = CFrame3 * new(v107, 0, math.rad(v108) * v50);

            for i2, v in v89 do
                local CFrame4 = v.CFrame;
                local new2 = CFrame.new;
                local v110 = math.rad(v105);
                local v111 = math.cos(v110) * v50;
                local v112 = math.rad(v105);
                local v113 = CFrame4 * new2(v111, 0, math.sin(v112) * v50);
                local v114 = CreatePart(u19, nil, "2022 Stud Bark");
                local v115 = (v109.Position - v113.Position).Magnitude * 1.1;
                v114.Size = Vector3.new(v50 * 0.6, v50 * 0.6, v115);
                v114.CFrame = CFrame.lookAt(v109.Position, v113.Position) * CFrame.new(0, 0, -v115 / 2);
                v114.Color = u29;
                v114.Name = i2;
                v114:SetAttribute("GrowSide", true);

                if i2 == 2 then
                    local v116 = Vector3.new(v50 * 0.55, v115, v50 * 0.55);
                    local v117 = v114.CFrame * CFrame.Angles(-0.4363323129985824, 0, 1.5707963267948966) * CFrame.new(0, 0, u23:NextNumber(-v.Size.Z, v.Size.Z) * 0.3);

                    for i3 = 1, 2 do
                        local v118 = CreatePart(u19, nil, "2022 Stud Bark");
                        v118.Size = v116;
                        local Angles = CFrame.Angles;
                        local v119 = u23:NextNumber(25, 35);
                        v118.CFrame = v117 * Angles(0, 0, (math.rad(v119))) * CFrame.new(0, v118.Size.Y / 2.25, 0);
                        v118.Color = u29;
                        v118.Name = i3 + 2;
                        v117 = v118.CFrame * CFrame.new(0, v118.Size.Y / 2.25, 0);
                        v116 = v116 * 0.85;
                        local CFrame5 = v118.CFrame;
                        local Angles2 = CFrame.Angles;
                        local v120 = u23:NextNumber(-25, 25);
                        v118.CFrame = CFrame5 * Angles2(0, math.rad(v120), 0);
                    end;
                end;

                v105 = v105 + 360 / v52;

                if i2 == #v89 then
                    local v121 = u23:NextInteger(2, 3);
                    local v122 = v114.CFrame * CFrame.new(0, 0, -v114.Size.Z / 2) * CFrame.Angles(-1.5707963267948966, 1.5707963267948966, 0);
                    v109 = v113;

                    for i3 = 1, v121 do
                        local v123 = 360 / v121 * i3 + u23:NextNumber(-20, 20);
                        CreateBranch(v122 * CFrame.Angles(0, math.rad(v123), 0), Vector3.new(v114.Size.X * 0.7, v114.Size.Z * 0.8, v114.Size.Y * 0.7), i2, 0.85);
                        v113 = v109;
                        v109 = v113;
                    end;
                else
                    v109 = v113;
                end;
            end;
        end;

        u19:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u124) -- Line: 296, Name: BeginPlantGrowth
        local PrimaryPart = u124.PrimaryPart;
        local u125 = {};

        for _, v in u124:QueryDescendants("BasePart") do
            local v126 = tonumber(v.Name);

            if v126 then
                local v127 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v127, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });
                        child.Transparency = 1;
                    end;
                end;

                local v128 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v126,
                    decals = v127,
                    growSide = v:GetAttribute("GrowSide") == true
                };
                table.insert(u125, v128);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 328
            -- upvalues: u124 (copy), u125 (copy), PrimaryPart (copy)
            local v129 = u124:GetAttribute("Age") or 0;
            local v130 = u124:GetAttribute("MaxAge") or 1;

            for _, v in u125 do
                local v131 = math.min(v129 - v.partAge, 1);
                local v132 = math.clamp(v131, 0, 1);

                if v132 ~= v.lastProgress then
                    v.lastProgress = v132;

                    if v131 > 0 then
                        if v.growSide then
                            local v133 = v.maxSize.Z * v131;
                            v.part.Size = Vector3.new(v.maxSize.X, v.maxSize.Y, v133);
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, 0, (v.maxSize.Z - v133) / 2);
                        else
                            local v134 = v.maxSize.Y * v131;
                            v.part.Size = Vector3.new(v.maxSize.X, v134, v.maxSize.Z);
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v134) / 2), 0);
                        end;

                        v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                        v.part.CanCollide = true;

                        for _, v2 in v.decals do
                            v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v131);
                        end;
                    else
                        v.part.Transparency = 1;
                        v.part.CanCollide = false;

                        for _, v2 in v.decals do
                            v2.decal.Transparency = 1;
                        end;
                    end;
                end;
            end;

            if v130 <= v129 then
                for _, v in u124:QueryDescendants("ParticleEmitter") do
                    v.Enabled = true;
                end;
            end;

            if game.Players.LocalPlayer and (game:GetService("RunService"):IsClient() and (not u124:GetAttribute("playedSfx") and u124:GetAttribute("MaxAge") <= v129)) then
                u124:SetAttribute("playedSfx", true);
                game.SoundService:PlayLocalSound(game.SoundService.SFX.Happy);
            end;
        end;

        u124:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};