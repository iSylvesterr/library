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
        local v5 = u1.Base:GetPivot();

        local function GetRandomHSV(p6, p7) -- Line: 19
            -- upvalues: u4 (copy)
            local v8, v9, v10 = p6:ToHSV();
            local v11 = p7 or 0.05;
            local v12 = v8 + u4:NextNumber(-v11, v11);

            return Color3.fromHSV(v12, v9, v10), v12, v9, v10;
        end;

        local function CreatePart(p13, p14, p15) -- Line: 28
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

        local v18 = u4:NextInteger(5, 12);

        for i = 1, v18 do
            local v19 = script.Leaf:Clone();
            v19:ScaleTo(u4:NextNumber(0.7, 1.25));
            local Angles = CFrame.Angles;
            local v20 = u4:NextInteger(-3, 3);
            local v21 = math.rad(v20);
            local v22 = 360 / v18 * i + u4:NextInteger(-22, 22);
            local v23 = math.rad(v22);
            local v24 = u4:NextInteger(-16, -9);
            v19:PivotTo(v5 * Angles(v21, v23, (math.rad(v24))));

            for _, child in v19:GetChildren() do
                child.Name = tonumber(child.Name) + i;
                child.Parent = u1;
            end;

            v19:Destroy();
        end;

        local v25 = u4:NextInteger(2, 4);

        for i = 1, v25 do
            local v26 = script.Leaf:Clone();
            v26:ScaleTo(u4:NextNumber(0.6, 0.9));
            local Angles = CFrame.Angles;
            local v27 = u4:NextInteger(-3, 3);
            local v28 = math.rad(v27);
            local v29 = 360 / v25 * i + u4:NextInteger(-45, 45);
            local v30 = math.rad(v29);
            local v31 = u4:NextInteger(-25, -15);
            v26:PivotTo(v5 * Angles(v28, v30, (math.rad(v31))));

            for _, child in v26:GetChildren() do
                child.Name = tonumber(child.Name) + i;
                child.Parent = u1;
            end;

            v26:Destroy();
        end;

        local v32 = CreatePart();
        v32.Size = Vector3.new(1, 1, 1);
        v32.Position = v5.Position;
        v32.Parent = u1.FruitSpawnLocations;
        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u33) -- Line: 117, Name: BeginPlantGrowth
        local PrimaryPart = u33.PrimaryPart;
        local u34 = {};

        for _, v in u33:QueryDescendants("BasePart") do
            local v35 = tonumber(v.Name);

            if v35 then
                local v36 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v35
                };
                table.insert(u34, v36);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 135
            -- upvalues: u33 (copy), u34 (copy), PrimaryPart (copy)
            local v37 = u33:GetAttribute("Age") or 0;

            for _, v in u34 do
                local v38 = v[1];
                local v39 = v[2];
                local v40 = v[3];
                local v41 = math.min(v37 - v[4], 1);
                local v42 = math.clamp(v41, 0, 1);

                if v42 ~= v.lastProgress then
                    v.lastProgress = v42;

                    if v41 > 0 then
                        v38.Size = Vector3.new(v39.X, v39.Y * v41, v39.Z);
                        v38.CFrame = PrimaryPart.CFrame * v40 * CFrame.new(0, (v38.Size.Y - v39.Y) / 2, 0);
                        v38.Transparency = v38:GetAttribute("OG_Transparency") or 0;
                        v38.CanCollide = true;
                    else
                        v38.Transparency = 1;
                        v38.CanCollide = false;
                    end;
                end;
            end;
        end;

        u33:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};