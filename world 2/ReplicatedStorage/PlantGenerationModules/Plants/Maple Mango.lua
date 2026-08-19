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

        local function GetRandomHSV(p12, p13) -- Line: 50
            -- upvalues: u8 (copy)
            local v14, v15, v16 = p12:ToHSV();
            local v17 = p13 or 0.05;
            local v18 = v14 + u8:NextNumber(-v17, v17);
            local v19 = math.clamp(v18, 0, 0.99);

            return Color3.fromHSV(v19, v15, v16), v19, v15, v16;
        end;

        local v20 = u8:NextInteger(1, 2);

        if u8:NextInteger(1, 10) == 1 then
            while u8:NextInteger(1, 3) == 1 do
                v20 = v20 + 1;
            end;
        end;

        local u21 = 3 + u7;
        local u22 = 0.3 + u7 * 0.25;
        local u23 = 3 + u7 * 0.5;

        while u8:NextInteger(1, 100) == 1 do
            u23 = u23 + 2;
        end;

        while u8:NextInteger(1, 100) == 1 do
            u22 = u22 + 1;
        end;

        local u24 = 7 * (u7 * 0.25 + 0.75);

        if u8:NextInteger(1, 300) == 1 then
            while u8:NextInteger(1, 2) == 1 do
                u24 = u24 * 2;
            end;
        end;

        local u25 = u8:NextInteger(90, 110) * 0.015;

        while u8:NextInteger(1, 500) == 1 do
            u25 = u25 * 2;
        end;

        local u26 = 4;

        while u8:NextInteger(1, 100) == 1 do
            u26 = u26 + 1;
        end;

        local u27 = {};
        local u28 = 0;
        local u29 = 0;
        local u30 = 0;

        local function Branch(p31, p32) -- Line: 104
            -- upvalues: u23 (ref), u21 (copy), u7 (ref), u24 (ref), u8 (copy), u28 (ref), u30 (ref), u29 (ref), Stud_Part (copy), u22 (ref), u10 (copy), u11 (ref), u9 (copy), PlantGrowthShaping (ref), u4 (copy), u25 (ref), u27 (copy), getMiddle50 (ref), u26 (ref), Branch (copy)
            if u23 <= u21 * (0.6 - math.clamp(u7 * 0.1, 0.1, 0.5)) or u24 <= 0 then
                return;
            end;

            local v33 = u8:NextNumber() * 2 - 1;
            local v34 = u8:NextNumber() * 2 - 1;

            if math.sign(u28) == math.sign(v33) then
                v33 = -v33;
            end;

            u30 = u30 + 1;

            if math.sign(u29) == math.sign(v34) then
                v34 = -v34;
            end;

            u28 = v33;
            u29 = v34;
            local v35 = {};
            u24 = u24 - 0.5;
            local v36 = v33;
            local v37 = v34;
            local v38 = nil;

            for _ = 1, u24 do
                v38 = Stud_Part:Clone();
                v38.Color = Color3.fromRGB(159, 65, 0);
                v38.Size = Vector3.new(u22 * u10, u23 * u10, u22 * u10);
                u11 = u11 + 1;
                v38.Name = tostring(u11);
                v38.CFrame = p31 * CFrame.new(0, p32.Y / 2 + v38.Size.Y / 2, 0);
                v38.CFrame = v38.CFrame * CFrame.new(0, -v38.Size.Y / 2, 0) * CFrame.Angles(math.rad(v33), 0, (math.rad(v37))) * CFrame.new(0, v38.Size.Y / 2, 0);

                if v38.Position.Y - v38.Size.Y / 2 < u9 then
                    v33 = -v33;
                    v37 = -v37;
                    v36 = -v36;
                    v34 = -v34;
                    v38.CFrame = p31 * CFrame.new(0, p32.Y / 2 + v38.Size.Y / 2, 0);
                    v38.CFrame = v38.CFrame * CFrame.new(0, -v38.Size.Y / 2, 0) * CFrame.Angles(math.rad(v33), 0, (math.rad(v37))) * CFrame.new(0, v38.Size.Y / 2, 0);
                end;

                v38.CFrame = PlantGrowthShaping.TipTowardUp(v38.CFrame, v38.Size.Y / 2, 0.15);
                v38.Parent = u4;
                p31 = v38.CFrame;
                p32 = v38.Size;
                v33 = v33 + math.clamp(v36, -0.01, 0.01) * 200 * (1 / (u7 * 0.25 + 0.75)) * u25;
                v37 = v37 + math.clamp(v34, -0.01, 0.01) * 200 * (1 / (u7 * 0.25 + 0.75)) * u25;
                table.insert(v35, v38);
            end;

            if v38 then
                table.insert(u27, v38);
            end;

            u23 = u23 * 0.9;
            u22 = u22 * 0.9;
            local v39 = getMiddle50(v35);
            local v40 = u26;

            while true do
                local v41, v42, v43, v44, v45, v46, v47, v48, v49;

                while true do
                    if v40 < 1 then
                        return;
                    end;

                    v40 = v40 - 1;
                    v41 = v39[u8:NextInteger(1, #v39)];

                    if u26 - 1 <= v40 then
                        break;
                    end;

                    local v50 = math.round(u21 / u23);

                    if u8:NextInteger(1, (math.max(1, v50))) == 1 then
                        v42 = Branch;
                        v43 = v41.CFrame;
                        v44 = CFrame.Angles;
                        v45 = u8:NextInteger(-25, 25);
                        v46 = math.rad(v45);
                        v47 = u8:NextInteger(-25, 25);
                        v48 = math.rad(v47);
                        v49 = u8:NextInteger(-25, 25);
                        v42(v43 * v44(v46, v48, (math.rad(v49))), v41.Size);
                    end;
                end;

                v42 = Branch;
                v43 = v41.CFrame;
                v44 = CFrame.Angles;
                v45 = u8:NextInteger(-25, 25);
                v46 = math.rad(v45);
                v47 = u8:NextInteger(-25, 25);
                v48 = math.rad(v47);
                v49 = u8:NextInteger(-25, 25);
                v42(v43 * v44(v46, v48, (math.rad(v49))), v41.Size);
            end;
        end;

        u11 = u11 + 1;
        local success, result = pcall(function() -- Line: 169
            -- upvalues: Branch (copy), Base (copy), u8 (copy), u27 (copy), u7 (ref), u10 (copy), u11 (ref), u4 (copy), FruitSpawnLocations (copy)
            Branch(Base.CFrame * CFrame.new(0, -Base.Size.Y / 2, 0), Base.Size);
            local v51 = 1;

            while u8:NextInteger(1, 3) == 1 do
                v51 = v51 + 0.1;
            end;

            for _, v in pairs(u27) do
                local v52 = script.Leaf_Part:Clone();
                local v53 = u8:NextInteger(11, 15);
                local v54 = v53 * (u8:NextInteger(7, 9) * 0.1);
                local v55 = (u7 * 0.25 + 0.75) * v51 * u10;
                v52.Size = Vector3.new(v53 * v55, v54 * v55, v53 * v55);
                local v56, v57 = Color3.fromRGB(237, 82, 24);
                local v58, v59, v60 = v56:ToHSV();
                local v61 = v57 or 0.05;
                local v62 = v58 + u8:NextNumber(-v61, v61);
                local v63 = math.clamp(v62, 0, 0.99);
                v52.Color = Color3.fromHSV(v63, v59, v60);
                v52.Name = tostring(u11);
                v52.CFrame = v.CFrame * CFrame.new(0, v52.Size.Y / 2, 0);
                local v64 = u8:NextInteger(-180, 180);
                v52.Orientation = Vector3.new(0, v64, 0);
                v52.Parent = u4;

                for _ = 1, 1 do
                    local Part = Instance.new("Part");
                    Part.Transparency = 1;
                    Part.Anchored = true;
                    Part.CanCollide = false;
                    Part.Size = Vector3.new(1, 1, 1);
                    Part.Parent = FruitSpawnLocations;
                    Part.CFrame = v52.CFrame * CFrame.new(u8:NextInteger(-v52.Size.X, v52.Size.X) * 0.25, -v52.Size.Y / 2, u8:NextInteger(-v52.Size.Z, v52.Size.Z) * 0.25);
                end;

                u11 = u11 + 0.25;
            end;
        end);

        if not success then
            warn((`[Mango] InitPlant generation failed: {result}`));
        end;

        u4:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u65) -- Line: 209, Name: BeginPlantGrowth
        local PrimaryPart = u65.PrimaryPart;
        local u66 = {};

        for _, v in u65:QueryDescendants("BasePart") do
            local v67 = tonumber(v.Name);

            if v67 then
                local v68 = not v:GetAttribute("DontShow");
                local v69 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v69, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v68 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v70 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v67,
                    decals = v69
                };
                table.insert(u66, v70);
                v.CanCollide = false;

                if v68 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 244
            -- upvalues: u65 (copy), u66 (copy), PrimaryPart (copy)
            local v71 = u65:GetAttribute("Age") or 0;
            local v72 = u65:GetAttribute("MaxAge") or 1;
            local v73 = v71 / v72;

            for _, v in u66 do
                if not v.part:GetAttribute("DontShow") then
                    local v74 = math.clamp((v73 - v.partAge / v72) * v72, 0, 1);

                    if v74 ~= v.lastProgress then
                        v.lastProgress = v74;

                        if v74 > 0 then
                            local v75 = v.maxSize * v74;
                            v.part.Size = v75;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v75.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v74);
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
            end;

            if v72 <= v71 then
                for _, v in u65:QueryDescendants("ParticleEmitter") do
                    v.Enabled = true;
                end;
            end;
        end;

        u65:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};