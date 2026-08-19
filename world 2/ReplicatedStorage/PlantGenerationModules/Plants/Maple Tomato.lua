-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u1, p2, p3) -- Line: 6, Name: InitPlant
        local u4 = Random.new(p2);
        local Base = u1.Base;
        local Stud_Part = script.Stud_Part;
        local FruitSpawnLocations = u1:FindFirstChild("FruitSpawnLocations");
        local v5 = u4:NextInteger(7, 11) + p3 * 10;
        local v6 = math.round(v5 / 1.5);
        local v7 = math.max(1, v6);
        local _ = Enum.Material.Wood;
        local u8 = Color3.fromRGB(177, 76, 4);
        local v9 = Color3.fromRGB(198, 126, 11);
        local u10 = Color3.fromRGB(255, 159, 14);
        local CFrame2 = Base.CFrame;
        local Angles = CFrame.Angles;
        local v11 = u4:NextInteger(-180, 180);
        Base.CFrame = CFrame2 * Angles(0, math.rad(v11), 0);
        local v12 = Base.CFrame * CFrame.new(0, -Base.Size.Y / 2, 0);
        local Position = v12.Position;
        local UpVector = v12.UpVector;

        while u4:NextInteger(1, 100) == 1 do
            v5 = v5 * 2;
        end;

        local function stemStage(p13) -- Line: 64
            return p13;
        end;

        local function newPart(p14, p15, p16) -- Line: 68
            -- upvalues: Stud_Part (copy), u1 (copy)
            local v17 = Stud_Part:Clone();
            v17.Size = p14;
            v17.Color = p15;
            v17.Material = Enum.Material.Plastic;
            v17.MaterialVariant = "Studs";
            v17.Name = p16;
            v17.Parent = u1;

            return v17;
        end;

        local function safePerp(p18) -- Line: 79
            local v19 = p18:Cross(Vector3.new(1, 0, 0));

            if v19.Magnitude < 0.05 then
                v19 = p18:Cross(Vector3.new(0, 0, 1));
            end;

            return v19.Unit;
        end;

        local v20 = v12 - Position;
        local u21 = Position;
        local v22 = {};
        local u23 = {};

        local function makeStemLeaf(p24, p25, p26) -- Line: 91
            -- upvalues: u4 (copy), u10 (copy), Stud_Part (copy), u1 (copy)
            local v27 = u4:NextInteger(5, 10) * 0.015;
            local v28 = Vector3.new(v27, 1, 1);
            local v29 = Stud_Part:Clone();
            v29.Size = v28;
            v29.Color = u10;
            v29.Material = Enum.Material.Plastic;
            v29.MaterialVariant = "Studs";
            v29.Name = p25;
            v29.Parent = u1;
            v29:AddTag("DetailPart");
            local v30 = u4:NextInteger(-30, 30);
            local v31 = p26 + math.rad(v30);
            local v32 = p24.Size.X / 2 + v29.Size.X / 2;
            local v33 = math.cos(v31) * v32;
            local v34 = math.sin(v31) * v32;
            local v35 = Vector3.new(v33, 0, v34);
            v29.CFrame = p24.CFrame + v35;
            local v36 = -math.deg(v31);
            v29.Orientation = Vector3.new(0, v36, 30);
            v29.CFrame = v29.CFrame * CFrame.Angles(0, 0, 1.5707963267948966);
            v29.CFrame = v29.CFrame * CFrame.new(0, 0.2, v29.Size.Z / 2);
            v29.CFrame = v29.CFrame * CFrame.Angles(1.5707963267948966, 0, 0);

            return v29;
        end;

        for i = 1, v7 do
            local v37 = math.clamp((i - 1) / 6, 0, 1) * 0.2617993877991494;
            local v38 = v20 * CFrame.Angles(0, (i - 1) * 0.7853981633974483 * -1, 0) * CFrame.Angles(v37, 0, 0);
            local v39 = CFrame.new(Position) * v38;
            local v40;

            if i % 2 == 0 then
                local v41 = tostring(i);
                v40 = Stud_Part:Clone();
                v40.Size = Vector3.new(0.5, 1.5, 0.5);
                v40.Color = u8;
                v40.Material = Enum.Material.Plastic;
                v40.MaterialVariant = "Studs";
                v40.Name = v41;
                v40.Parent = u1;

                for _, child in script.color1Fade:GetChildren() do
                    child:Clone().Parent = v40;
                end;
            else
                local v42 = tostring(i);
                v40 = Stud_Part:Clone();
                v40.Size = Vector3.new(0.5, 1.5, 0.5);
                v40.Color = v9;
                v40.Material = Enum.Material.Plastic;
                v40.MaterialVariant = "Studs";
                v40.Name = v42;
                v40.Parent = u1;

                for _, child in script.color2Fade:GetChildren() do
                    child:Clone().Parent = v40;
                end;
            end;

            v40.CFrame = v39 * CFrame.new(0, 0.75, 0);
            v22[i] = v40.CFrame.Position;
            u23[i] = v40;
            Position = (v39 * CFrame.new(0, 1.5, 0)).Position;
        end;

        local function makeLeaf(p43, p44, p45, p46, p47) -- Line: 186
            -- upvalues: u10 (copy), Stud_Part (copy), u1 (copy), u4 (copy)
            local v48 = p43 * CFrame.new(0, p45 * p44.Y, 0) * CFrame.Angles(0, p46, 0) * CFrame.new(p44.X / 2 + 0.5, 0, 0);
            local v49 = Stud_Part:Clone();
            v49.Size = Vector3.new(1, 0.25, 1);
            v49.Color = u10;
            v49.Material = Enum.Material.Plastic;
            v49.MaterialVariant = "Studs";
            v49.Name = p47 + 1;
            v49.Parent = u1;
            v49.CFrame = v48;
            local v50 = u4:NextInteger(-25, 25);
            local v51 = 45 + u4:NextInteger(-10, 10);
            v49.Orientation = Vector3.new(v50, v51, u4:NextInteger(-25, 25));

            return v49;
        end;

        local v52 = (1 / 0);
        local v53 = (-1 / 0);

        local function makeBranch(p54, p55, p56, p57, p58) -- Line: 153
            -- upvalues: u21 (copy), UpVector (copy), u8 (copy), Stud_Part (copy), u1 (copy)
            local v59 = p54 - u21;
            local v60 = v59 - UpVector * v59:Dot(UpVector);
            local v61;

            if v60.Magnitude < 0.05 then
                local v62 = UpVector;
                local v63 = v62:Cross(Vector3.new(1, 0, 0));

                if v63.Magnitude < 0.05 then
                    v63 = v62:Cross(Vector3.new(0, 0, 1));
                end;

                v61 = v63.Unit;
            else
                v61 = v60.Unit;
            end;

            local v64 = CFrame.fromAxisAngle(UpVector, (math.rad(p57))) * v61;
            local v65 = math.rad(p56);
            local Unit = (UpVector * math.cos(v65) + v64 * math.sin(v65)).Unit;
            local v66 = UpVector;
            local v67 = Unit:Dot(v66);

            if math.abs(v67) > 0.99 then
                local v68 = Unit:Cross(Vector3.new(1, 0, 0));

                if v68.Magnitude < 0.05 then
                    v68 = Unit:Cross(Vector3.new(0, 0, 1));
                end;

                v66 = v68.Unit;
            end;

            local Unit2 = v66:Cross(Unit).Unit;
            local Unit3 = Unit2:Cross(Unit).Unit;
            local v69 = CFrame.fromMatrix(p54 + v64 * 0.25, Unit2, Unit, Unit3);
            local v70 = Stud_Part:Clone();
            v70.Size = p55;
            v70.Color = u8;
            v70.Material = Enum.Material.Plastic;
            v70.MaterialVariant = "Studs";
            v70.Name = p58;
            v70.Parent = u1;

            for _, child in script.color1Fade:GetChildren() do
                child:Clone().Parent = v70;
            end;

            v70.CFrame = v69 * CFrame.new(0, p55.Y / 2, 0);

            return v69, v64;
        end;

        for i = 1, v7 do
            local Y = v22[i].Y;
            v52 = math.min(v52, Y);
            v53 = math.max(v53, Y);
        end;

        local v71 = v53 - v52;
        local v72 = v52 + v71 * 0.15;
        local v73 = v53 - v71 * 0.15;
        local v74 = {};

        for i = 1, v7 do
            local v75 = v22[i];

            if v72 <= v75.Y and v75.Y <= v73 then
                table.insert(v74, {
                    index = i,
                    pos = v75
                });
            end;
        end;

        local u76 = {};

        local function farEnough(p77) -- Line: 215
            -- upvalues: u76 (copy)
            for _, v in ipairs(u76) do
                if (v - p77).Magnitude < 5 then
                    return false;
                end;
            end;

            return true;
        end;

        local function spawnBranch(p78) -- Line: 224
            -- upvalues: u4 (copy), makeBranch (copy), makeStemLeaf (copy), u23 (copy), FruitSpawnLocations (copy), u76 (copy)
            local v79 = 4 * u4:NextNumber(0.6, 1.3);
            local v80 = 60 + u4:NextNumber(-20, 15);
            local v81 = 20 + u4:NextNumber(-45, 45);
            local v82 = Vector3.new(0.5, v79, 0.5);
            local v83 = tostring(p78.index + 0.5);
            local v84, v85 = makeBranch(p78.pos, v82, v80, v81, v83);
            local v86 = math.atan2(v85.Z, v85.X);
            makeStemLeaf(u23[p78.index], tostring(p78.index + 0.75), v86);

            if FruitSpawnLocations then
                local Position2 = (v84 * CFrame.new(0, v82.Y * 0.5, 0)).Position;
                local Part = Instance.new("Part");
                Part.Size = Vector3.new(0.5, 0.5, 0.5);
                Part.Transparency = 1;
                Part.CanCollide = false;
                Part.Anchored = true;
                Part.CFrame = CFrame.new(Position2 - Vector3.new(0, 0.5, 0));
                Part.Name = "FruitSpawn_" .. v83;
                Part.Parent = FruitSpawnLocations;
            end;

            table.insert(u76, p78.pos);
        end;

        for _, v in ipairs(v74) do
            if u4:NextNumber() < 0.4 then
                local pos = v.pos;
                local v87 = true;

                for _, v2 in ipairs(u76) do
                    if (v2 - pos).Magnitude < 5 then
                        v87 = false;
                        break;
                    end;
                end;

                if v87 then
                    spawnBranch(v);
                end;
            end;
        end;

        while true do
            if #u76 >= 1 or #v74 <= 0 then
                if not u1.PrimaryPart then
                    u1.PrimaryPart = Base;
                end;

                local v88 = tostring(v7);
                local v89 = v7 * 1.5;
                local v90 = math.ceil(v89 / 10);
                local v91 = math.max(1, v90);
                local v92 = v89 / v91;

                for i = 1, v91 do
                    local TrussPart = Instance.new("TrussPart");
                    TrussPart.Anchored = true;
                    TrussPart.Size = Vector3.new(2, v92, 2);
                    TrussPart.CFrame = CFrame.new(u21 + UpVector * ((i - 0.5) * v92));
                    TrussPart:SetAttribute("TrunkReference", v88);
                    TrussPart:AddTag("PlantTruss");
                    TrussPart.CanCollide = false;
                    TrussPart.Transparency = 1;
                    TrussPart.Parent = u1;
                end;

                u1:AddTag("InitializationComplete");

                return;
            end;

            local v93 = 0;
            local v94, v95;

            repeat
                v95 = v74[u4:NextInteger(1, #v74)];
                v93 = v93 + 1;
                local pos = v95.pos;
                v94 = true;

                for _, v in ipairs(u76) do
                    if (v - pos).Magnitude < 5 then
                        v94 = false;
                        break;
                    end;
                end;
            until v94 or #v74 * 2 <= v93;

            spawnBranch(v95);
        end;
    end,

    BeginPlantGrowth = function(u96) -- Line: 295, Name: BeginPlantGrowth
        local PrimaryPart = u96.PrimaryPart;
        local u97 = {};
        local u98 = {};

        for _, v in u96:QueryDescendants("BasePart") do
            if v:HasTag("PlantTruss") then
                table.insert(u97, v);
            else
                local v99 = not v:GetAttribute("DontShow");
                local v100 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v100, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v99 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v101 = tonumber(v.Name);

                if v101 then
                    local v102 = {
                        v,
                        v.Size,
                        PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                        v101,
                        decals = v100
                    };
                    table.insert(u98, v102);
                    v.CanCollide = false;
                    v.Transparency = 1;
                end;
            end;
        end;

        table.sort(u98, function(p103, p104) -- Line: 336
            return p103[4] < p104[4];
        end);

        local function updateGrowth() -- Line: 338
            -- upvalues: u96 (copy), u98 (copy), PrimaryPart (copy), u97 (copy)
            local v105 = u96:GetAttribute("Age") or 0;

            for _, v in u98 do
                local v106 = v[1];
                local v107 = v[2];
                local v108 = v[3];
                local v109 = math.min(v105 - v[4], 1);
                local v110 = math.clamp(v109, 0, 1);

                if v110 ~= v.lastProgress then
                    v.lastProgress = v110;

                    if v109 > 0 then
                        v106.Size = Vector3.new(v107.X, v107.Y * v109, v107.Z);
                        v106.CFrame = PrimaryPart.CFrame * v108 * CFrame.new(0, (v106.Size.Y - v107.Y) / 2, 0);
                        v106.Transparency = v106:GetAttribute("OG_Transparency") or 0;
                        v106.CanCollide = true;

                        for _, v2 in v.decals do
                            v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v110);
                        end;
                    else
                        v106.Transparency = 1;
                        v106.CanCollide = false;

                        for _, v2 in v.decals do
                            v2.decal.Transparency = 1;
                        end;
                    end;
                end;
            end;

            for _, v in u97 do
                local v111 = v:GetAttribute("TrunkReference");
                local v112 = tonumber(v111);

                if v112 then
                    if math.min(v105 - v112, 1) >= 1 then
                        v.CanCollide = true;
                    else
                        v.CanCollide = false;
                    end;
                end;
            end;
        end;

        u96:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};