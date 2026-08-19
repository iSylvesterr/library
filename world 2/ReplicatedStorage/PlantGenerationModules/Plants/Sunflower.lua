-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u1, p2, p3) -- Line: 7, Name: InitPlant
        local v4 = p3 or 1;
        local u5 = Random.new(p2);
        local FruitSpawnLocations = u1.FruitSpawnLocations;
        local Base = u1.Base;
        local Stud_Part = script.Stud_Part;

        local function GetRandomHSV(p6, p7) -- Line: 19
            -- upvalues: u5 (copy)
            local v8, v9, v10 = p6:ToHSV();
            local v11 = p7 or 0.05;
            local v12 = v8 + u5:NextNumber(-v11, v11);
            local v13 = math.clamp(v12, 0.01, 0.99);

            return Color3.fromHSV(v13, v9, v10), v13, v9, v10;
        end;

        local v14, v15 = Color3.fromRGB(137, 191, 57);
        local v16, v17, v18 = v14:ToHSV();
        local v19 = v15 or 0.05;
        local v20 = v16 + u5:NextNumber(-v19, v19);
        local v21 = math.clamp(v20, 0.01, 0.99);
        local u22 = Color3.fromHSV(v21, v17, v18);

        local function CreatePart(p23, p24) -- Line: 29
            -- upvalues: Stud_Part (copy), u1 (copy)
            local v25 = Stud_Part:Clone();
            v25.Parent = u1;
            v25.Anchored = true;
            v25.CanCollide = false;
            v25.Transparency = 1;

            if p24 then
                v25.Shape = Enum.PartType[p24];
            end;

            return v25;
        end;

        local v26 = u5:NextNumber(2.3, 2.7) * (v4 * 0.25 + 0.75);
        local v27 = u5:NextNumber(3.25, 3.75) * (v4 * 0.25 + 0.75);
        local _ = 0 + 1;
        local u28 = Stud_Part:Clone();
        u28.Parent = u1;
        u28.Anchored = true;
        u28.CanCollide = false;
        u28.Transparency = 1;
        u28.Size = Vector3.new(v26, v27, v26);
        u28.CFrame = Base.CFrame * CFrame.new(0, v27 * u5:NextNumber(1.1, 1.5), 0);
        u28.Color = u22;
        local v29 = u28:Clone();
        v29.Parent = u1;
        v29.CFrame = u28.CFrame * CFrame.Angles(0, 0.7853981633974483, 0);
        v29.Size = Vector3.new(v29.Size.X, v29.Size.Y * 0.7, v29.Size.Z);
        local v30 = u5:NextInteger(3, (math.floor(5 + v4 * 2)));

        local function GenerateDownwardsStem(p31, p32, p33, p34) -- Line: 68
            -- upvalues: u28 (copy), u5 (copy), Base (copy), Stud_Part (copy), u1 (copy), u22 (copy)
            local Y = u28.Position.Y;
            local v35 = p31 * CFrame.Angles(3.141592653589793, 0, 0);
            local v36 = u5:NextNumber(0.8, 1) * p33;
            local v37 = u5:NextNumber(2.3, 2.85);
            local v38 = Vector3.new(v36, v37, v36);
            local v39 = 0;
            local v40 = {};
            local v41 = p34 or 0;

            while Base.Position.Y < Y do
                local v42 = Stud_Part:Clone();
                v42.Parent = u1;
                v42.Anchored = true;
                v42.CanCollide = false;
                v42.Transparency = 1;
                local v43 = u5:NextNumber(p32[1], p32[2]);
                local v44 = math.rad(v43);

                if u5:NextInteger(1, 3) == 1 then
                    v44 = v44 * 2;
                end;

                if v39 == 1 and u5:NextNumber(1, 2) == 1 then
                    v44 = -v44;
                end;

                v39 = v39 + 1;
                v42.Size = v38;
                v42.CFrame = v35 * CFrame.Angles(0, 0, v44) * CFrame.new(0, v42.Size.Y / 2.3, 0);
                v42.Color = u22;
                v42.Name = tostring(v39 + v41);
                Y = v42.Position.Y;
                v35 = v42.CFrame * CFrame.new(0, v42.Size.Y / 2.3, 0);
                local v45 = v38.X * u5:NextNumber(1.275, 1.45);
                local v46 = v38.Y * u5:NextNumber(1.05, 1.25);
                v38 = Vector3.new(v45, v46, v45);
                table.insert(v40, v42);
                local CFrame2 = v42.CFrame;
                local Angles = CFrame.Angles;
                local v47 = u5:NextNumber(-45, 45);
                v42.CFrame = CFrame2 * Angles(0, math.rad(v47), 0);
            end;

            return v40, v39;
        end;

        local v48, v49 = GenerateDownwardsStem(u28.CFrame * CFrame.new(0, -v27 / 2, 0), { -5, 5 }, 2);

        for _, v in v48 do
            local v50 = v49 - tonumber(v.Name) + 1;
            v.Name = tostring(v50);
            v.CFrame = v.CFrame * CFrame.Angles(3.141592653589793, 0, 0);
        end;

        for i = 1, v30 do
            local v51 = u28.CFrame * CFrame.new(0, -v27 * u5:NextNumber(-0.1, 0.3), 0);
            local Angles = CFrame.Angles;
            local v52 = 360 / v30 * i + u5:NextNumber(-15, 15);
            local v53 = v51 * Angles(0, math.rad(v52), 0) * CFrame.new(u28.Size.X / 2.5, 0, 0);
            local Angles2 = CFrame.Angles;
            local v54 = u5:NextNumber(42.5, 60);
            GenerateDownwardsStem(v53 * Angles2(0, 0, (math.rad(v54))), { 5, 11 }, 1, v49 + 1);
        end;

        u28.Name = tostring(v49 + 1);
        v29.Name = tostring(v49 + 1);
        u1:PivotTo(u1:GetPivot() * CFrame.new(0, 0.5, 0));
        local v55 = u5:NextInteger(1, (math.floor(2 + v4)));
        local v56 = Vector3.new(u28.Size.X * 0.875, u28.Size.Y * 0.85, u28.Size.Z * 0.875);
        local v57 = u28.CFrame * CFrame.new(0, u28.Size.Y / 2.3, 0);
        local v58 = nil;

        while u5:NextInteger(1, 6) == 1 do
            v55 = v55 + 1;
        end;

        for i = 1, v55 do
            local v59 = Stud_Part:Clone();
            v59.Parent = u1;
            v59.Anchored = true;
            v59.CanCollide = false;
            v59.Transparency = 1;
            v59.Size = v56;
            local Angles = CFrame.Angles;
            local v60 = u5:NextNumber(-10, 10);
            local v61 = math.rad(v60);
            local v62 = u5:NextNumber(-25, 25);
            local v63 = math.rad(v62);
            local v64 = u5:NextNumber(-10, 10);
            v59.CFrame = v57 * Angles(v61, v63, (math.rad(v64))) * CFrame.new(0, v59.Size.Y / 2.3, 0);
            v59.Color = u22;
            v59.Name = tostring(i + v49 + 1);
            local v65 = v59:Clone();
            v65.Parent = u1;
            v65.CFrame = v59.CFrame * CFrame.Angles(0, 0.7853981633974483, 0);
            v65.Size = Vector3.new(v65.Size.X, v65.Size.Y * 0.7, v65.Size.Z);

            if i == 1 or u5:NextInteger(1, 4) == 1 then
                for i2 = 1, 2 do
                    local v66 = script.Leaf:Clone();
                    local v67 = i2 * 180 + u5:NextNumber(-35, 35) + i * 90;
                    v66.Parent = u1;
                    v66:ScaleTo(u5:NextNumber(0.85, 1.15) * (v4 * 0.15 + 0.85));
                    v66:PivotTo(v59.CFrame * CFrame.Angles(0, math.rad(v67), -1.3962634015954636));

                    for _, child in v66:GetChildren() do
                        if child.Name == "1" or child.Name == "2" then
                            child.Color = u22;
                        else
                            child.Color = Color3.fromHSV(v21, v17, v18 - 0.15);
                        end;

                        local v68 = tonumber(child.Name);

                        if v68 then
                            child.Name = tostring(v68 + i + v49 + 1);
                            child.Parent = u1;
                        end;
                    end;
                end;
            end;

            local v69 = v56.X * 0.875;
            local v70 = u28.Size.Y * u5:NextNumber(0.875, 1.15);
            v56 = Vector3.new(v69, v70, v56.Z * 0.875);
            v57 = v59.CFrame * CFrame.new(0, v59.Size.Y / 2.3, 0);
            v58 = v59.CFrame * CFrame.new(0, v59.Size.Y / 2, 0);
        end;

        local v71 = u5:NextInteger(2, (math.floor(2 + v4)));
        local v72 = {};
        local v73 = nil;

        for i = 1, v71 do
            local v74 = Stud_Part:Clone();
            v74.Parent = u1;
            v74.Anchored = true;
            v74.CanCollide = false;
            v74.Transparency = 1;
            v74.Size = v56;
            local Angles = CFrame.Angles;
            local v75 = u5:NextNumber(-3, 3);
            local v76 = math.rad(v75);
            local v77 = u5:NextNumber(-25, 25);
            local v78 = math.rad(v77);
            local v79 = u5:NextNumber(-3, 3);
            v74.CFrame = v57 * Angles(v76, v78, (math.rad(v79))) * CFrame.new(0, v74.Size.Y / 2.3, 0);
            v74.Color = u22;
            v74.Name = tostring(i + v49 + 1 + v55);
            table.insert(v72, v74);
            v57 = v74.CFrame * CFrame.new(0, v74.Size.Y / 2.3, 0);
            v73 = v74.CFrame * CFrame.new(0, v74.Size.Y / 2, 0);
        end;

        local Magnitude = (v58.Position - v73.Position).Magnitude;

        for i = 1, 2 do
            local v80 = 360 / Magnitude;

            if i == 1 then
                v80 = v80 + 180;
            end;

            local v81 = math.floor(Magnitude);
            local v82 = v58;
            local v83 = 1;

            for i2 = 1, v81 do
                local new = CFrame.new;
                local v84 = math.rad(v80);
                local v85 = math.cos(v84) * v26;
                local v86 = math.rad(v80);
                local v87 = v58 * new(v85, v83, math.sin(v86) * v26);
                local v88 = Stud_Part:Clone();
                v88.Parent = u1;
                v88.Anchored = true;
                v88.CanCollide = false;
                v88.Transparency = 1;
                local v89 = (v82.Position - v87.Position).Magnitude * 1.1;
                local v90 = v26 * 0.5;

                if i2 % 2 == 0 then
                    v90 = v26 * 0.4;
                end;

                if i2 == v81 then
                    v89 = v89 * 1.4;
                    v87 = v73;
                end;

                v88.Size = Vector3.new(v90, v89, v90);
                v88.CFrame = CFrame.lookAt(v82.Position, v87.Position) * CFrame.Angles(-1.5707963267948966, 0, 0) * CFrame.new(0, v89 / 2, 0);
                local v91;

                if i2 % 2 == 0 then
                    v91 = Color3.fromHSV(v21, v17, v18 - 0.15) or u22;
                else
                    v91 = u22;
                end;

                v88.Color = v91;
                v88.Name = tostring(i2 + v55 + v49 + 2);
                v83 = v83 + 1;
                v80 = v80 + 360 / v71 * 0.35;
                v82 = v87;
            end;
        end;

        local v92 = v71 + v49 + 2 + v55;
        local v93 = Stud_Part:Clone();
        v93.Parent = u1;
        v93.Anchored = true;
        v93.CanCollide = false;
        v93.Transparency = 1;
        v93.Size = Vector3.new(v56.X * 1.3, v56.Y * 0.75, v56.Z * 1.3);
        v93.CFrame = v73 * CFrame.new(0, v93.Size.Y / 2, 0);
        v93.Color = u22;
        v93.Name = tostring(v92);

        for i = 1, 4 do
            local v94 = v93.CFrame * CFrame.Angles(0, math.rad(i * 90), 0) * CFrame.new(0, 0, v93.Size.Z / 1.85);
            local v95 = Stud_Part:Clone();
            v95.Parent = u1;
            v95.Anchored = true;
            v95.CanCollide = false;
            v95.Transparency = 1;
            local v96 = u5:NextNumber(v93.Size.X * 0.65, v93.Size.X * 0.85);
            local v97 = v96 * u5:NextNumber(1, 1.5);
            v95.Size = Vector3.new(v96, v97, v96 * 0.425);
            local Angles = CFrame.Angles;
            local v98 = u5:NextNumber(28, 43);
            v95.CFrame = v94 * Angles(math.rad(v98), 0, 0);
            v95.Color = u22;
            v95.Name = tostring(v92 + 1);
            local v99 = Stud_Part:Clone();
            v99.Parent = u1;
            v99.Anchored = true;
            v99.CanCollide = false;
            v99.Transparency = 1;
            local v100 = v95.Size.X * 0.8;
            local v101 = v95.Size.Y * u5:NextNumber(0.3, 0.45);
            v99.Size = Vector3.new(v100, v101, v95.Size.Z * 0.8);
            v99.CFrame = v95.CFrame * CFrame.new(0, v95.Size.Y / 2 + v99.Size.Y / 2.1, 0);
            v99.Color = Color3.fromHSV(v21, v17, v18 - 0.15);
            v99.Name = tostring(v92 + 2);
        end;

        local v102 = Stud_Part:Clone();
        v102.Parent = u1;
        v102.Anchored = true;
        v102.CanCollide = false;
        v102.Transparency = 1;
        v102.Size = Vector3.new(1, 1, 1);
        v102.CFrame = v93.CFrame * CFrame.new(0, v93.Size.Y / 2, 0);
        v102.Transparency = 1;
        v102.Parent = FruitSpawnLocations;
        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u103) -- Line: 348, Name: BeginPlantGrowth
        local PrimaryPart = u103.PrimaryPart;
        local u104 = {};

        for _, v in u103:QueryDescendants("BasePart") do
            local v105 = tonumber(v.Name);

            if v105 then
                local v106 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v105
                };
                table.insert(u104, v106);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 366
            -- upvalues: u103 (copy), u104 (copy), PrimaryPart (copy)
            local v107 = u103:GetAttribute("Age") or 0;
            u103:GetAttribute("MaxAge");

            for _, v in u104 do
                local v108 = v[1];
                local v109 = v[2];
                local v110 = v[3];
                local v111 = math.min(v107 - v[4], 1);
                local v112 = math.clamp(v111, 0, 1);

                if v112 ~= v.lastProgress then
                    v.lastProgress = v112;

                    if v111 > 0 then
                        v108.Size = Vector3.new(v109.X, v109.Y * v111, v109.Z);
                        v108.CFrame = PrimaryPart.CFrame * v110 * CFrame.new(0, (v108.Size.Y - v109.Y) / 2, 0);
                        v108.Transparency = v108:GetAttribute("OG_Transparency") or 0;
                        v108.CanCollide = true;
                    else
                        v108.Transparency = 1;
                        v108.CanCollide = false;
                    end;
                end;
            end;

            if game.Players.LocalPlayer and (game:GetService("RunService"):IsClient() and (not u103:GetAttribute("playedSfx") and u103:GetAttribute("MaxAge") <= v107)) then
                u103:SetAttribute("playedSfx", true);
                game.SoundService:PlayLocalSound(game.SoundService.SFX.Happy);
            end;
        end;

        u103:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};