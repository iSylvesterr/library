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

        local u18 = 1 * v4;
        local u19 = 0.35 * v4;
        local v20 = u5:NextInteger(5, 7);

        local function generateTrunk(p21) -- Line: 62
            -- upvalues: u1 (copy), u18 (copy), u19 (copy), u5 (copy), FruitSpawnLocations (copy)
            local Segment = u1.Segment;
            Segment:ScaleTo(u18);
            local v22 = Segment;

            for i = 1, p21 do
                local v23 = math.lerp(u18, u19, i / p21);
                local v24 = Segment:Clone();
                v24:ScaleTo(v23);
                local Y = v22:FindFirstChildWhichIsA("Part").Size.Y;
                v24:PivotTo(v22:GetPivot() * CFrame.new(0, Y, 0));
                local v25 = v24:GetPivot();
                local Angles = CFrame.Angles;
                local v26 = u5:NextInteger(-15, 15);
                local v27 = math.rad(v26);
                local v28 = u5:NextInteger(-15, 15);
                local v29 = math.rad(v28);
                local v30 = u5:NextInteger(-15, 15);
                v24:PivotTo(v25 * Angles(v27, v29, (math.rad(v30))));
                v24.Parent = u1;

                for _, descendant in v24:GetDescendants() do
                    if descendant.Name == "3" and u5:NextInteger(1, 2) == 1 then
                        descendant.Color = Color3.fromRGB(79, 186, 37);
                    end;

                    if descendant:IsA("Model") then
                        local v31 = descendant:GetPivot();
                        local Angles2 = CFrame.Angles;
                        local v32 = u5:NextInteger(-10, 10);
                        local v33 = math.rad(v32);
                        local v34 = u5:NextInteger(-10, 10);
                        local v35 = math.rad(v34);
                        local v36 = u5:NextInteger(-10, 10);
                        descendant:PivotTo(v31 * Angles2(v33, v35, (math.rad(v36))));
                    end;
                end;

                for _, descendant in v24:GetDescendants() do
                    if tonumber(descendant.Name) then
                        descendant.Name = tonumber(descendant.Name) + i;
                    end;
                end;

                for _, descendant in pairs(v24:GetDescendants()) do
                    if descendant.Name == "Spawn" then
                        descendant.Parent = FruitSpawnLocations;
                    end;
                end;

                v22 = v24;
            end;

            local top = u1.top;
            top:PivotTo(v22:GetPivot() * CFrame.new(0, v22:FindFirstChildWhichIsA("Part").Size.Y, 0));
            top:ScaleTo(v22:GetScale() * 2);

            for _, descendant in top:GetDescendants() do
                if descendant.Name == "2" and u5:NextInteger(1, 2) == 1 then
                    descendant.Color = Color3.fromRGB(79, 186, 37);
                end;

                if descendant:IsA("Model") then
                    local v37 = descendant:GetPivot();
                    local Angles = CFrame.Angles;
                    local v38 = u5:NextInteger(-10, 10);
                    local v39 = math.rad(v38);
                    local v40 = u5:NextInteger(-10, 10);
                    local v41 = math.rad(v40);
                    local v42 = u5:NextInteger(-10, 10);
                    descendant:PivotTo(v37 * Angles(v39, v41, (math.rad(v42))));
                end;
            end;

            for _, descendant in top:GetDescendants() do
                if tonumber(descendant.Name) then
                    descendant.Name = tonumber(descendant.Name) + p21 + 1;
                end;
            end;
        end;

        while u5:NextInteger(1, 100) == 1 do
            v20 = v20 * 2;
        end;

        local v43 = v20 * math.clamp(v4 / 2, 1, 100);
        local v44 = math.clamp(v43, 0.5, 100);
        generateTrunk((math.floor(v44)));
        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u45) -- Line: 144, Name: BeginPlantGrowth
        local PrimaryPart = u45.PrimaryPart;
        local u46 = {};

        for _, v in u45:QueryDescendants("BasePart") do
            local v47 = tonumber(v.Name);

            if v47 then
                local v48 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") then
                        table.insert(v48, { child, child.Transparency });
                        child.Transparency = 1;
                    end;
                end;

                local v49 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v47,
                    v48
                };
                table.insert(u46, v49);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 172
            -- upvalues: u45 (copy), u46 (copy), PrimaryPart (copy)
            local v50 = u45:GetAttribute("Age") or 0;

            for _, v in u46 do
                local v51 = v[1];
                local v52 = v[2];
                local v53 = v[3];
                local v54 = v[5];
                local v55 = math.min(v50 - v[4], 1);
                local v56 = math.clamp(v55, 0, 1);

                if v56 ~= v.lastProgress then
                    v.lastProgress = v56;

                    if v55 > 0 then
                        v51.Size = Vector3.new(v52.X, v52.Y * v55, v52.Z);
                        v51.CFrame = PrimaryPart.CFrame * v53 * CFrame.new(0, (v51.Size.Y - v52.Y) / 2, 0);
                        v51.Transparency = v51:GetAttribute("OG_Transparency") or 0;
                        v51.CanCollide = true;
                    else
                        v51.Transparency = 1;
                        v51.CanCollide = false;
                    end;

                    local v57 = v55 >= 1;

                    for _, v2 in v54 do
                        v2[1].Transparency = v57 and v2[2] or 1;
                    end;
                end;
            end;
        end;

        u45:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};