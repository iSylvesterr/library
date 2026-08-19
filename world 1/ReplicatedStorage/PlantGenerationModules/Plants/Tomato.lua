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
        local u8 = Color3.fromRGB(70, 170, 70);
        local _ = Enum.Material.Wood;
        local u9 = Color3.fromRGB(70, 170, 70);
        local CFrame2 = Base.CFrame;
        local Angles = CFrame.Angles;
        local v10 = u4:NextInteger(-180, 180);
        Base.CFrame = CFrame2 * Angles(0, math.rad(v10), 0);
        local v11 = Base.CFrame * CFrame.new(0, -Base.Size.Y / 2, 0);
        local Position = v11.Position;
        local UpVector = v11.UpVector;

        while u4:NextInteger(1, 100) == 1 do
            v5 = v5 * 2;
        end;

        local function stemStage(p12) -- Line: 60
            return p12;
        end;

        local function newPart(p13, p14, p15) -- Line: 64
            -- upvalues: Stud_Part (copy), u1 (copy)
            local v16 = Stud_Part:Clone();
            v16.Size = p13;
            v16.Color = p14;
            v16.Material = Enum.Material.Plastic;
            v16.MaterialVariant = "Studs";
            v16.Name = p15;
            v16.Parent = u1;

            return v16;
        end;

        local function safePerp(p17) -- Line: 75
            local v18 = p17:Cross(Vector3.new(1, 0, 0));

            if v18.Magnitude < 0.05 then
                v18 = p17:Cross(Vector3.new(0, 0, 1));
            end;

            return v18.Unit;
        end;

        local v19 = v11 - Position;
        local u20 = Position;
        local v21 = {};
        local u22 = {};

        local function makeStemLeaf(p23, p24, p25) -- Line: 87
            -- upvalues: u4 (copy), u9 (copy), Stud_Part (copy), u1 (copy)
            local v26 = u4:NextInteger(5, 10) * 0.015;
            local v27 = Vector3.new(v26, 1, 1);
            local v28 = Stud_Part:Clone();
            v28.Size = v27;
            v28.Color = u9;
            v28.Material = Enum.Material.Plastic;
            v28.MaterialVariant = "Studs";
            v28.Name = p24;
            v28.Parent = u1;
            v28:AddTag("DetailPart");
            local v29 = u4:NextInteger(-30, 30);
            local v30 = p25 + math.rad(v29);
            local v31 = p23.Size.X / 2 + v28.Size.X / 2;
            local v32 = math.cos(v30) * v31;
            local v33 = math.sin(v30) * v31;
            local v34 = Vector3.new(v32, 0, v33);
            v28.CFrame = p23.CFrame + v34;
            local v35 = -math.deg(v30);
            v28.Orientation = Vector3.new(0, v35, 30);
            v28.CFrame = v28.CFrame * CFrame.Angles(0, 0, 1.5707963267948966);
            v28.CFrame = v28.CFrame * CFrame.new(0, 0.2, v28.Size.Z / 2);
            v28.CFrame = v28.CFrame * CFrame.Angles(1.5707963267948966, 0, 0);

            return v28;
        end;

        for i = 1, v7 do
            local v36 = math.clamp((i - 1) / 6, 0, 1) * 0.2617993877991494;
            local v37 = v19 * CFrame.Angles(0, (i - 1) * 0.7853981633974483 * -1, 0) * CFrame.Angles(v36, 0, 0);
            local v38 = CFrame.new(Position) * v37;
            local v39 = tostring(i);
            local v40 = Stud_Part:Clone();
            v40.Size = Vector3.new(0.5, 1.5, 0.5);
            v40.Color = u8;
            v40.Material = Enum.Material.Plastic;
            v40.MaterialVariant = "Studs";
            v40.Name = v39;
            v40.Parent = u1;
            v40.CFrame = v38 * CFrame.new(0, 0.75, 0);
            v21[i] = v40.CFrame.Position;
            u22[i] = v40;
            Position = (v38 * CFrame.new(0, 1.5, 0)).Position;
        end;

        local function makeLeaf(p41, p42, p43, p44, p45) -- Line: 167
            -- upvalues: u9 (copy), Stud_Part (copy), u1 (copy), u4 (copy)
            local v46 = p41 * CFrame.new(0, p43 * p42.Y, 0) * CFrame.Angles(0, p44, 0) * CFrame.new(p42.X / 2 + 0.5, 0, 0);
            local v47 = Stud_Part:Clone();
            v47.Size = Vector3.new(1, 0.25, 1);
            v47.Color = u9;
            v47.Material = Enum.Material.Plastic;
            v47.MaterialVariant = "Studs";
            v47.Name = p45 + 1;
            v47.Parent = u1;
            v47.CFrame = v46;
            local v48 = u4:NextInteger(-25, 25);
            local v49 = 45 + u4:NextInteger(-10, 10);
            v47.Orientation = Vector3.new(v48, v49, u4:NextInteger(-25, 25));

            return v47;
        end;

        local v50 = (1 / 0);
        local v51 = (-1 / 0);

        local function makeBranch(p52, p53, p54, p55, p56) -- Line: 137
            -- upvalues: u20 (copy), UpVector (copy), u8 (copy), Stud_Part (copy), u1 (copy)
            local v57 = p52 - u20;
            local v58 = v57 - UpVector * v57:Dot(UpVector);
            local v59;

            if v58.Magnitude < 0.05 then
                local v60 = UpVector;
                local v61 = v60:Cross(Vector3.new(1, 0, 0));

                if v61.Magnitude < 0.05 then
                    v61 = v60:Cross(Vector3.new(0, 0, 1));
                end;

                v59 = v61.Unit;
            else
                v59 = v58.Unit;
            end;

            local v62 = CFrame.fromAxisAngle(UpVector, (math.rad(p55))) * v59;
            local v63 = math.rad(p54);
            local Unit = (UpVector * math.cos(v63) + v62 * math.sin(v63)).Unit;
            local v64 = UpVector;
            local v65 = Unit:Dot(v64);

            if math.abs(v65) > 0.99 then
                local v66 = Unit:Cross(Vector3.new(1, 0, 0));

                if v66.Magnitude < 0.05 then
                    v66 = Unit:Cross(Vector3.new(0, 0, 1));
                end;

                v64 = v66.Unit;
            end;

            local Unit2 = v64:Cross(Unit).Unit;
            local Unit3 = Unit2:Cross(Unit).Unit;
            local v67 = CFrame.fromMatrix(p52 + v62 * 0.25, Unit2, Unit, Unit3);
            local v68 = Stud_Part:Clone();
            v68.Size = p53;
            v68.Color = u8;
            v68.Material = Enum.Material.Plastic;
            v68.MaterialVariant = "Studs";
            v68.Name = p56;
            v68.Parent = u1;
            v68.CFrame = v67 * CFrame.new(0, p53.Y / 2, 0);

            return v67, v62;
        end;

        for i = 1, v7 do
            local Y = v21[i].Y;
            v50 = math.min(v50, Y);
            v51 = math.max(v51, Y);
        end;

        local v69 = v51 - v50;
        local v70 = v50 + v69 * 0.15;
        local v71 = v51 - v69 * 0.15;
        local v72 = {};

        for i = 1, v7 do
            local v73 = v21[i];

            if v70 <= v73.Y and v73.Y <= v71 then
                table.insert(v72, {
                    index = i,
                    pos = v73
                });
            end;
        end;

        local u74 = {};

        local function farEnough(p75) -- Line: 196
            -- upvalues: u74 (copy)
            for _, v in ipairs(u74) do
                if (v - p75).Magnitude < 5 then
                    return false;
                end;
            end;

            return true;
        end;

        local function spawnBranch(p76) -- Line: 205
            -- upvalues: u4 (copy), makeBranch (copy), makeStemLeaf (copy), u22 (copy), FruitSpawnLocations (copy), u74 (copy)
            local v77 = 4 * u4:NextNumber(0.6, 1.3);
            local v78 = 60 + u4:NextNumber(-20, 15);
            local v79 = 20 + u4:NextNumber(-45, 45);
            local v80 = Vector3.new(0.5, v77, 0.5);
            local v81 = tostring(p76.index + 0.5);
            local v82, v83 = makeBranch(p76.pos, v80, v78, v79, v81);
            local v84 = math.atan2(v83.Z, v83.X);
            makeStemLeaf(u22[p76.index], tostring(p76.index + 0.75), v84);

            if FruitSpawnLocations then
                local Position2 = (v82 * CFrame.new(0, v80.Y * 0.5, 0)).Position;
                local Part = Instance.new("Part");
                Part.Size = Vector3.new(0.5, 0.5, 0.5);
                Part.Transparency = 1;
                Part.CanCollide = false;
                Part.Anchored = true;
                Part.CFrame = CFrame.new(Position2 - Vector3.new(0, 0.5, 0));
                Part.Name = "FruitSpawn_" .. v81;
                Part.Parent = FruitSpawnLocations;
            end;

            table.insert(u74, p76.pos);
        end;

        for _, v in ipairs(v72) do
            if u4:NextNumber() < 0.4 then
                local pos = v.pos;
                local v85 = true;

                for _, v2 in ipairs(u74) do
                    if (v2 - pos).Magnitude < 5 then
                        v85 = false;
                        break;
                    end;
                end;

                if v85 then
                    spawnBranch(v);
                end;
            end;
        end;

        while true do
            if #u74 >= 1 or #v72 <= 0 then
                if not u1.PrimaryPart then
                    u1.PrimaryPart = Base;
                end;

                local v86 = tostring(v7);
                local v87 = v7 * 1.5;
                local v88 = math.ceil(v87 / 10);
                local v89 = math.max(1, v88);
                local v90 = v87 / v89;

                for i = 1, v89 do
                    local TrussPart = Instance.new("TrussPart");
                    TrussPart.Anchored = true;
                    TrussPart.Size = Vector3.new(2, v90, 2);
                    TrussPart.CFrame = CFrame.new(u20 + UpVector * ((i - 0.5) * v90));
                    TrussPart:SetAttribute("TrunkReference", v86);
                    TrussPart:AddTag("PlantTruss");
                    TrussPart.CanCollide = false;
                    TrussPart.Transparency = 1;
                    TrussPart.Parent = u1;
                end;

                u1:AddTag("InitializationComplete");

                return;
            end;

            local v91 = 0;
            local v92, v93;

            repeat
                v93 = v72[u4:NextInteger(1, #v72)];
                v91 = v91 + 1;
                local pos = v93.pos;
                v92 = true;

                for _, v in ipairs(u74) do
                    if (v - pos).Magnitude < 5 then
                        v92 = false;
                        break;
                    end;
                end;
            until v92 or #v72 * 2 <= v91;

            spawnBranch(v93);
        end;
    end,

    BeginPlantGrowth = function(u94) -- Line: 276, Name: BeginPlantGrowth
        local PrimaryPart = u94.PrimaryPart;
        local u95 = {};
        local u96 = {};

        for _, v in u94:QueryDescendants("BasePart") do
            if v:HasTag("PlantTruss") then
                table.insert(u95, v);
            else
                local v97 = tonumber(v.Name);

                if v97 then
                    local v98 = {
                        v,
                        v.Size,
                        PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                        v97
                    };
                    table.insert(u96, v98);
                    v.CanCollide = false;
                    v.Transparency = 1;
                end;
            end;
        end;

        table.sort(u96, function(p99, p100) -- Line: 298
            return p99[4] < p100[4];
        end);

        local function updateGrowth() -- Line: 300
            -- upvalues: u94 (copy), u96 (copy), PrimaryPart (copy), u95 (copy)
            local v101 = u94:GetAttribute("Age") or 0;

            for _, v in u96 do
                local v102 = v[1];
                local v103 = v[2];
                local v104 = v[3];
                local v105 = math.min(v101 - v[4], 1);
                local v106 = math.clamp(v105, 0, 1);

                if v106 ~= v.lastProgress then
                    v.lastProgress = v106;

                    if v105 > 0 then
                        v102.Size = Vector3.new(v103.X, v103.Y * v105, v103.Z);
                        v102.CFrame = PrimaryPart.CFrame * v104 * CFrame.new(0, (v102.Size.Y - v103.Y) / 2, 0);
                        v102.Transparency = v102:GetAttribute("OG_Transparency") or 0;
                        v102.CanCollide = true;
                    else
                        v102.Transparency = 1;
                        v102.CanCollide = false;
                    end;
                end;
            end;

            for _, v in u95 do
                local v107 = v:GetAttribute("TrunkReference");
                local v108 = tonumber(v107);

                if v108 then
                    if math.min(v101 - v108, 1) >= 1 then
                        v.CanCollide = true;
                    else
                        v.CanCollide = false;
                    end;
                end;
            end;
        end;

        u94:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};