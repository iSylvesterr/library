-- Decompiled with Potassium's decompiler.

local MaterialService = game:GetService("MaterialService");

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u1, p2, p3) -- Line: 11, Name: InitPlant
        -- upvalues: MaterialService (copy)
        local u4 = Random.new(p2);
        local _ = u1.FruitSpawnLocations;
        local Base = u1.Base;

        for _, v in u1:QueryDescendants("BasePart") do
            if v.Anchored == false then
                v:AddTag("OriginallyNotAnchored");
            end;

            v.Anchored = true;
        end;

        local function GetRandomHSV(p5, p6) -- Line: 28
            -- upvalues: u4 (copy)
            local v7, v8, v9 = p5:ToHSV();
            local v10 = p6 or 0.05;
            local v11 = v7 + u4:NextNumber(-v10, v10);

            return Color3.fromHSV(v11, v8, v9), v11, v8, v9;
        end;

        local function CreatePart(p12, p13, p14) -- Line: 36
            -- upvalues: u1 (copy), MaterialService (ref)
            local Part = Instance.new("Part");
            local v15 = p12 or "Studs";
            Part.Parent = u1;
            Part.TopSurface = Enum.SurfaceType[v15];
            Part.BackSurface = Enum.SurfaceType[v15];
            Part.FrontSurface = Enum.SurfaceType[v15];
            Part.BottomSurface = Enum.SurfaceType[v15];
            Part.LeftSurface = Enum.SurfaceType[v15];
            Part.RightSurface = Enum.SurfaceType[v15];
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Transparency = 1;

            if p14 then
                Part.Shape = Enum.PartType[p14];
            end;

            if p13 then
                Part.MaterialVariant = p13;
                local v16 = MaterialService:FindFirstChild(p13, true);

                if not v16 then
                    return Part;
                end;

                Part.Material = v16.BaseMaterial;
            end;

            return Part;
        end;

        local u17 = Color3.fromRGB(68, 68, 68);
        local u18 = Color3.fromRGB(163, 62, 59);
        local v19 = u4:NextInteger(6, 10);
        local v20 = math.ceil((p3 or 1) * 1.33 * 2);
        local v21 = v19 + math.clamp(v20, 0, 20);

        local function generateTrunk(p22, p23, p24) -- Line: 72
            -- upvalues: u4 (copy), u17 (copy), u18 (copy), CreatePart (copy), u1 (copy)
            local v25 = p22:GetPivot() * CFrame.new(0, p22.Size.Y / 2, 0);
            local Model = Instance.new("Model");
            local v26 = 0;

            for i = 1, p23 do
                local v27 = script.Stud_Part:Clone();
                local v28 = 4 + u4:NextNumber(-1.5, 1.5);
                local v29 = math.min(8, v26 * 0.15);
                local v30 = math.rad(i * 35 + p24);
                local v31 = math.rad((i + 1) * 35 + p24);
                local Position = v25.Position;
                local v32 = math.cos(v30) * v29;
                local v33 = math.sin(v30) * v29;
                local v34 = Position + Vector3.new(v32, v26, v33);
                v26 = v26 + v28;
                local v35 = math.min(8, v26 * 0.15);
                local Position2 = v25.Position;
                local v36 = math.cos(v31) * v35;
                local v37 = math.sin(v31) * v35;
                local v38 = Position2 + Vector3.new(v36, v26, v37);
                v27.Color = u17:Lerp(u18, (math.clamp(i / p23, 0, 1)));
                v27.Material = Enum.Material.Glacier;
                v27.MaterialVariant = "2022 Stud LavaCracks";
                v27.Size = Vector3.new(3, (v38 - v34).Magnitude * 1.12, 3);
                local v39 = v34:Lerp(v38, 0.5);
                v27.CFrame = CFrame.lookAt(v39, v38) * CFrame.Angles(1.5707963267948966, 0, 0);
                v27.CFrame = v27.CFrame * CFrame.Angles(3.141592653589793, 0, 0);
                v27.Name = i;
                v27.Parent = Model;

                if i % 4 == 0 and i ~= p23 then
                    local v40 = CreatePart();
                    local v41 = v27.CFrame * CFrame.new(0, 0, v27.Size.Z / 2.1);
                    local Angles = CFrame.Angles;
                    local v42 = u4:NextInteger(50, 66);
                    local v43 = math.rad(v42);
                    local v44 = u4:NextInteger(-15, 15);
                    local v45 = math.rad(v44);
                    local v46 = u4:NextInteger(-15, 15);
                    v40:PivotTo(v41 * Angles(v43, v45, (math.rad(v46))));
                    v40.Parent = u1.FruitSpawnLocations;
                elseif i % 2 == 0 and i ~= p23 then
                    local v47 = v27:Clone();
                    v47.MaterialVariant = "2022 Weld";
                    v47.Color = Color3.fromRGB(68, 55, 55);
                    v47.Size = Vector3.new(v27.Size.X * 1.1, v27.Size.Y * 0.5, v27.Size.Z * 1.1);
                end;

                if i == p23 then
                    local v48 = script.Dragon:Clone();
                    v48:PivotTo(v27:GetPivot() * CFrame.new(0, v27.Size.Y / 2, 0));

                    for _, descendant in v48:GetDescendants() do
                        if tonumber(descendant.Name) ~= nil then
                            descendant.Name = tonumber(descendant.Name) + i;
                        end;
                    end;

                    v48.Parent = u1;
                end;
            end;

            Model.Parent = u1;
        end;

        while u4:NextInteger(1, 5) == 1 do
            v21 = v21 + u4:NextInteger(1, 3);
        end;

        while u4:NextInteger(1, 100) == 1 do
            v21 = v21 * 2;

            if u4:NextInteger(1, 4) == 1 then
                v21 = v21 * 2;
            end;
        end;

        generateTrunk(Base, math.floor(v21), 180);
        local v49 = v21 + math.random(-1, 1);

        while u4:NextInteger(1, 5) == 1 do
            v49 = v49 + u4:NextInteger(1, 3);
        end;

        generateTrunk(Base, math.floor(v49), 0);
        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u50) -- Line: 180, Name: BeginPlantGrowth
        local PrimaryPart = u50.PrimaryPart;
        local u51 = {};

        for _, v in u50:QueryDescendants("BasePart") do
            local v52 = tonumber(v.Name);

            if v52 then
                local v53 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") then
                        table.insert(v53, { child, child.Transparency });
                        child.Transparency = 1;
                    end;
                end;

                local v54 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v52,
                    v53
                };
                table.insert(u51, v54);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 208
            -- upvalues: u50 (copy), u51 (copy), PrimaryPart (copy)
            local v55 = u50:GetAttribute("Age") or 0;

            for _, v in u51 do
                local v56 = v[1];
                local v57 = v[2];
                local v58 = v[3];
                local v59 = v[5];
                local v60 = math.min(v55 - v[4], 1);
                local v61 = math.clamp(v60, 0, 1);

                if v61 ~= v.lastProgress then
                    v.lastProgress = v61;

                    if v60 > 0 then
                        v56.Size = Vector3.new(v57.X, v57.Y * v60, v57.Z);
                        v56.CFrame = PrimaryPart.CFrame * v58 * CFrame.new(0, (v56.Size.Y - v57.Y) / 2, 0);
                        v56.Transparency = v56:GetAttribute("OG_Transparency") or 0;
                        v56.CanCollide = true;

                        for _, v2 in v56:QueryDescendants("ParticleEmitter") do
                            v2.Enabled = true;
                        end;
                    else
                        v56.Transparency = 1;
                        v56.CanCollide = false;

                        for _, v2 in v56:QueryDescendants("ParticleEmitter") do
                            v2.Enabled = false;
                        end;
                    end;

                    local v62 = v60 >= 1;

                    for _, v2 in v59 do
                        v2[1].Transparency = v62 and v2[2] or 1;
                    end;
                end;
            end;

            local v63 = u50:GetAttribute("Age");

            if math.round(v63) / u50:GetAttribute("MaxAge") >= 1 and not u50:GetAttribute("Setup") then
                for _, v in u50:QueryDescendants("BasePart.OriginallyNotAnchored") do
                    v.Anchored = false;
                end;

                u50:SetAttribute("Setup", true);
                task.spawn(function() -- Line: 255
                    -- upvalues: u50 (ref)
                    if not u50:HasTag("InitializationComplete") then
                        repeat
                            task.wait(0.2);
                        until u50:HasTag("InitializationComplete");
                    end;

                    task.wait(1);

                    for _, child in u50:GetChildren() do
                        if child.Name == "Dragon" and not child:HasTag("DragonBreath") then
                            child:AddTag("DragonBreath");
                        end;
                    end;
                end);
            end;
        end;

        u50:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};