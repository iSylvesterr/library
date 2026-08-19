-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PlantGrowthShaping = require(ReplicatedStorage.SharedModules.PlantGrowthShaping);

local function getMiddle50(p1) -- Line: 15
    local v2 = #p1;
    local v3 = {};

    for i = math.floor(v2 * 0.25) + 1, math.ceil(v2 * 0.75) do
        table.insert(v3, p1[i]);
    end;

    return v3;
end;

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u4, p5, p6) -- Line: 32, Name: InitPlant
        -- upvalues: PlantGrowthShaping (copy), getMiddle50 (copy)
        local u7 = p6 or 1;
        local u8 = Random.new(p5);
        local FruitSpawnLocations = u4.FruitSpawnLocations;
        local Base = u4.Base;
        local u9 = Base.Position.Y - Base.Size.Y / 2;
        local u10 = PlantGrowthShaping.GeometryShrink(u7, 6);
        local u11 = 0;
        local Stud_Part = script.Stud_Part;
        local v12 = u8:NextInteger(1, 2);

        if u8:NextInteger(1, 10) == 1 then
            while u8:NextInteger(1, 3) == 1 do
                v12 = v12 + 1;
            end;
        end;

        local u13 = 3 + u7;
        local u14 = 0.3 + u7 * 0.25;
        local u15 = 3 + u7 * 0.5;

        while u8:NextInteger(1, 100) == 1 do
            u15 = u15 + 2;
        end;

        while u8:NextInteger(1, 100) == 1 do
            u14 = u14 + 1;
        end;

        local u16 = 7 * (u7 * 0.25 + 0.75);

        if u8:NextInteger(1, 300) == 1 then
            while u8:NextInteger(1, 2) == 1 do
                u16 = u16 * 2;
            end;
        end;

        local u17 = u8:NextInteger(90, 110) * 0.015;

        while u8:NextInteger(1, 500) == 1 do
            u17 = u17 * 2;
        end;

        local u18 = 4;

        while u8:NextInteger(1, 100) == 1 do
            u18 = u18 + 1;
        end;

        local u19 = {};
        local u20 = 0;
        local u21 = 0;
        local u22 = 0;

        local function Branch(p23, p24) -- Line: 97
            -- upvalues: u15 (ref), u13 (copy), u7 (ref), u16 (ref), u8 (copy), u20 (ref), u22 (ref), u21 (ref), Stud_Part (copy), u14 (ref), u10 (copy), u11 (ref), u9 (copy), PlantGrowthShaping (ref), u4 (copy), u17 (ref), u19 (copy), getMiddle50 (ref), u18 (ref), Branch (copy)
            if u15 <= u13 * (0.6 - math.clamp(u7 * 0.1, 0.1, 0.5)) or u16 <= 0 then
                return;
            end;

            local v25 = u8:NextNumber() * 2 - 1;
            local v26 = u8:NextNumber() * 2 - 1;

            if math.sign(u20) == math.sign(v25) then
                v25 = -v25;
            end;

            u22 = u22 + 1;

            if math.sign(u21) == math.sign(v26) then
                v26 = -v26;
            end;

            u20 = v25;
            u21 = v26;
            local v27 = {};
            u16 = u16 - 0.5;
            local v28 = v25;
            local v29 = v26;
            local v30 = nil;

            for _ = 1, u16 do
                v30 = Stud_Part:Clone();
                v30.Color = Color3.new(0.509804, 0.372549, 0.235294);
                v30.Size = Vector3.new(u14 * u10, u15 * u10, u14 * u10);
                u11 = u11 + 1;
                v30.Name = tostring(u11);
                v30.CFrame = p23 * CFrame.new(0, p24.Y / 2 + v30.Size.Y / 2, 0);
                v30.CFrame = v30.CFrame * CFrame.new(0, -v30.Size.Y / 2, 0) * CFrame.Angles(math.rad(v25), 0, (math.rad(v29))) * CFrame.new(0, v30.Size.Y / 2, 0);

                if v30.Position.Y - v30.Size.Y / 2 < u9 then
                    v25 = -v25;
                    v29 = -v29;
                    v28 = -v28;
                    v26 = -v26;
                    v30.CFrame = p23 * CFrame.new(0, p24.Y / 2 + v30.Size.Y / 2, 0);
                    v30.CFrame = v30.CFrame * CFrame.new(0, -v30.Size.Y / 2, 0) * CFrame.Angles(math.rad(v25), 0, (math.rad(v29))) * CFrame.new(0, v30.Size.Y / 2, 0);
                end;

                v30.CFrame = PlantGrowthShaping.TipTowardUp(v30.CFrame, v30.Size.Y / 2, 0.15);
                v30.Parent = u4;
                p23 = v30.CFrame;
                p24 = v30.Size;
                v25 = v25 + math.clamp(v28, -0.01, 0.01) * 200 * (1 / (u7 * 0.25 + 0.75)) * u17;
                v29 = v29 + math.clamp(v26, -0.01, 0.01) * 200 * (1 / (u7 * 0.25 + 0.75)) * u17;
                table.insert(v27, v30);
            end;

            if v30 then
                table.insert(u19, v30);
            end;

            u15 = u15 * 0.9;
            u14 = u14 * 0.9;
            local v31 = getMiddle50(v27);
            local v32 = u18;

            while true do
                local v33, v34, v35, v36, v37, v38, v39, v40, v41;

                while true do
                    if v32 < 1 then
                        return;
                    end;

                    v32 = v32 - 1;
                    v33 = v31[u8:NextInteger(1, #v31)];

                    if u18 - 1 <= v32 then
                        break;
                    end;

                    local v42 = math.round(u13 / u15);

                    if u8:NextInteger(1, (math.max(1, v42))) == 1 then
                        v34 = Branch;
                        v35 = v33.CFrame;
                        v36 = CFrame.Angles;
                        v37 = u8:NextInteger(-25, 25);
                        v38 = math.rad(v37);
                        v39 = u8:NextInteger(-25, 25);
                        v40 = math.rad(v39);
                        v41 = u8:NextInteger(-25, 25);
                        v34(v35 * v36(v38, v40, (math.rad(v41))), v33.Size);
                    end;
                end;

                v34 = Branch;
                v35 = v33.CFrame;
                v36 = CFrame.Angles;
                v37 = u8:NextInteger(-25, 25);
                v38 = math.rad(v37);
                v39 = u8:NextInteger(-25, 25);
                v40 = math.rad(v39);
                v41 = u8:NextInteger(-25, 25);
                v34(v35 * v36(v38, v40, (math.rad(v41))), v33.Size);
            end;
        end;

        u11 = u11 + 1;
        local success, result = pcall(function() -- Line: 162
            -- upvalues: Branch (copy), Base (copy), u8 (copy), u19 (copy), u7 (ref), u10 (copy), u11 (ref), u4 (copy), FruitSpawnLocations (copy)
            Branch(Base.CFrame * CFrame.new(0, -Base.Size.Y / 2, 0), Base.Size);
            local v43 = 1;

            while u8:NextInteger(1, 3) == 1 do
                v43 = v43 + 0.1;
            end;

            for _, v in pairs(u19) do
                local v44 = script.Leaf_Part:Clone();
                local v45 = u8:NextInteger(11, 15);
                local v46 = v45 * (u8:NextInteger(7, 9) * 0.1);
                local v47 = (u7 * 0.25 + 0.75) * v43 * u10;
                v44.Size = Vector3.new(v45 * v47, v46 * v47, v45 * v47);
                v44.Color = Color3.fromHSV(u8:NextInteger(0, 160) * 0.001, 1, 1);
                v44.Name = tostring(u11);
                v44.CFrame = v.CFrame * CFrame.new(0, v44.Size.Y / 2, 0);
                local v48 = u8:NextInteger(-180, 180);
                v44.Orientation = Vector3.new(0, v48, 0);
                v44.Parent = u4;

                for _ = 1, 1 do
                    local Part = Instance.new("Part");
                    Part.Transparency = 1;
                    Part.Anchored = true;
                    Part.CanCollide = false;
                    Part.Size = Vector3.new(1, 1, 1);
                    Part.Parent = FruitSpawnLocations;
                    Part.CFrame = v44.CFrame * CFrame.new(u8:NextInteger(-v44.Size.X, v44.Size.X) * 0.25, -v44.Size.Y / 2, u8:NextInteger(-v44.Size.Z, v44.Size.Z) * 0.25);
                end;

                u11 = u11 + 0.25;
            end;
        end);

        if not success then
            warn((`[Mango] InitPlant generation failed: {result}`));
        end;

        u4:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u49) -- Line: 202, Name: BeginPlantGrowth
        local PrimaryPart = u49.PrimaryPart;
        local u50 = {};

        for _, v in u49:QueryDescendants("BasePart") do
            local v51 = tonumber(v.Name);

            if v51 then
                local v52 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v51
                };
                table.insert(u50, v52);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        table.sort(u50, function(p53, p54) -- Line: 221
            return p53[4] < p54[4];
        end);

        local function updateGrowth() -- Line: 223
            -- upvalues: u49 (copy), u50 (copy), PrimaryPart (copy)
            local v55 = u49:GetAttribute("Age") or 0;

            for _, v in u50 do
                local v56 = v[1];
                local v57 = v[2];
                local v58 = v[3];
                local v59 = math.clamp(v55 - v[4], 0, 1);

                if v59 ~= v.lastProgress then
                    v.lastProgress = v59;

                    if v59 > 0 then
                        v56.Size = Vector3.new(v57.X * v59, v57.Y * v59, v57.Z * v59);
                        v56.CFrame = PrimaryPart.CFrame * v58 * CFrame.new(0, (v56.Size.Y - v57.Y) / 2, 0);
                        v56.Transparency = v56:GetAttribute("OG_Transparency") or 0;
                        v56.CanCollide = true;
                    else
                        v56.Transparency = 1;
                        v56.CanCollide = false;
                    end;
                end;
            end;
        end;

        u49:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};