-- Decompiled with Potassium's decompiler.

local MaterialService = game:GetService("MaterialService");

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u1, p2, p3) -- Line: 11, Name: InitPlant
        -- upvalues: MaterialService (copy)
        local v4 = (p3 or 1) + 1;
        local u5 = Random.new(p2);
        local FruitSpawnLocations = u1.FruitSpawnLocations;
        local _ = u1.Base;

        local function GetRandomHSV(p6, p7) -- Line: 21
            -- upvalues: u5 (copy)
            local v8, v9, v10 = p6:ToHSV();
            local v11 = p7 or 0.05;
            local v12 = v8 + u5:NextNumber(-v11, v11);

            return Color3.fromHSV(v12, v9, v10), v12, v9, v10;
        end;

        local function CreatePart(p13, p14, p15) -- Line: 29
            -- upvalues: u1 (copy), MaterialService (ref)
            local Part = Instance.new("Part");
            local v16 = p13 or "Studs";
            Part.Parent = u1;
            Part.TopSurface = Enum.SurfaceType[v16];
            Part.BackSurface = Enum.SurfaceType[v16];
            Part.FrontSurface = Enum.SurfaceType[v16];
            Part.BottomSurface = Enum.SurfaceType[v16];
            Part.LeftSurface = Enum.SurfaceType[v16];
            Part.RightSurface = Enum.SurfaceType[v16];
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Transparency = 1;

            if p15 then
                Part.Shape = Enum.PartType[p15];
            end;

            if p14 then
                Part.MaterialVariant = p14;
                local v17 = MaterialService:FindFirstChild(p14, true);

                if not v17 then
                    return Part;
                end;

                Part.Material = v17.BaseMaterial;
            end;

            return Part;
        end;

        local u18 = {
            Color3.fromRGB(195, 116, 51),
            Color3.fromRGB(159, 74, 18),
            Color3.fromRGB(212, 109, 19),
            Color3.fromRGB(147, 105, 8),
            Color3.fromRGB(208, 158, 9)
        };
        local u19 = 1 * v4;
        local u20 = 0.35 * v4;
        local v21 = u18[u5:NextInteger(1, #u18)];

        for _, descendant in u1.Segment:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Color = v21;
            end;
        end;

        local v22 = u5:NextInteger(5, 7);

        local function generateTrunk(p23) -- Line: 77
            -- upvalues: u1 (copy), u19 (copy), u20 (copy), u5 (copy), u18 (copy), FruitSpawnLocations (copy)
            local Segment = u1.Segment;
            Segment:ScaleTo(u19);
            local v24 = Segment;

            for i = 1, p23 do
                local v25 = math.lerp(u19, u20, i / p23);
                local v26 = Segment:Clone();
                v26:ScaleTo(v25);
                local Y = v24:FindFirstChildWhichIsA("Part").Size.Y;
                v26:PivotTo(v24:GetPivot() * CFrame.new(0, Y, 0));
                local v27 = v26:GetPivot();
                local Angles = CFrame.Angles;
                local v28 = u5:NextInteger(-15, 15);
                local v29 = math.rad(v28);
                local v30 = u5:NextInteger(-15, 15);
                local v31 = math.rad(v30);
                local v32 = u5:NextInteger(-15, 15);
                v26:PivotTo(v27 * Angles(v29, v31, (math.rad(v32))));
                v26.Parent = u1;
                local v33 = u18[u5:NextInteger(1, #u18)];

                for _, descendant in v26:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        descendant.Color = v33;
                    end;

                    if descendant:IsA("Model") then
                        local v34 = descendant:GetPivot();
                        local Angles2 = CFrame.Angles;
                        local v35 = u5:NextInteger(-10, 10);
                        local v36 = math.rad(v35);
                        local v37 = u5:NextInteger(-10, 10);
                        local v38 = math.rad(v37);
                        local v39 = u5:NextInteger(-10, 10);
                        descendant:PivotTo(v34 * Angles2(v36, v38, (math.rad(v39))));
                    end;
                end;

                for _, descendant in v26:GetDescendants() do
                    if tonumber(descendant.Name) then
                        descendant.Name = tonumber(descendant.Name) + i;
                    end;
                end;

                for _, descendant in pairs(v26:GetDescendants()) do
                    if descendant.Name == "Spawn" then
                        descendant.Parent = FruitSpawnLocations;
                    end;
                end;

                v24 = v26;
            end;

            local top = u1.top;
            top:PivotTo(v24:GetPivot() * CFrame.new(0, v24:FindFirstChildWhichIsA("Part").Size.Y, 0));
            top:ScaleTo(v24:GetScale() * 2);

            for _, descendant in top:GetDescendants() do
                if descendant.Name == "2" and u5:NextInteger(1, 2) == 1 then
                    descendant.Color = Color3.fromRGB(79, 186, 37);
                end;

                if descendant:IsA("Model") then
                    local v40 = descendant:GetPivot();
                    local Angles = CFrame.Angles;
                    local v41 = u5:NextInteger(-10, 10);
                    local v42 = math.rad(v41);
                    local v43 = u5:NextInteger(-10, 10);
                    local v44 = math.rad(v43);
                    local v45 = u5:NextInteger(-10, 10);
                    descendant:PivotTo(v40 * Angles(v42, v44, (math.rad(v45))));
                end;
            end;

            for _, descendant in top:GetDescendants() do
                if tonumber(descendant.Name) then
                    descendant.Name = tonumber(descendant.Name) + p23 + 1;
                end;
            end;
        end;

        while u5:NextInteger(1, 100) == 1 do
            v22 = v22 * 2;
        end;

        local v46 = v22 * math.clamp(v4 / 2, 1, 100);
        local v47 = math.clamp(v46, 0.5, 100);
        generateTrunk((math.floor(v47)));
        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u48) -- Line: 161, Name: BeginPlantGrowth
        local PrimaryPart = u48.PrimaryPart;
        local u49 = {};

        for _, v in u48:QueryDescendants("BasePart") do
            local v50 = tonumber(v.Name);

            if v50 then
                local v51 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") then
                        table.insert(v51, { child, child.Transparency });
                        child.Transparency = 1;
                    end;
                end;

                local v52 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v50,
                    v51
                };
                table.insert(u49, v52);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 189
            -- upvalues: u48 (copy), u49 (copy), PrimaryPart (copy)
            local v53 = u48:GetAttribute("Age") or 0;

            for _, v in u49 do
                local v54 = v[1];
                local v55 = v[2];
                local v56 = v[3];
                local v57 = v[5];
                local v58 = math.min(v53 - v[4], 1);
                local v59 = math.clamp(v58, 0, 1);

                if v59 ~= v.lastProgress then
                    v.lastProgress = v59;

                    if v58 > 0 then
                        v54.Size = Vector3.new(v55.X, v55.Y * v58, v55.Z);
                        v54.CFrame = PrimaryPart.CFrame * v56 * CFrame.new(0, (v54.Size.Y - v55.Y) / 2, 0);
                        v54.Transparency = v54:GetAttribute("OG_Transparency") or 0;
                        v54.CanCollide = true;
                    else
                        v54.Transparency = 1;
                        v54.CanCollide = false;
                    end;

                    local v60 = v58 >= 1;

                    for _, v2 in v57 do
                        v2[1].Transparency = v60 and v2[2] or 1;
                    end;
                end;
            end;
        end;

        u48:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};