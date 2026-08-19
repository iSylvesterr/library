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

        local function GetRandomHSV(p5, p6) -- Line: 18
            -- upvalues: u4 (copy)
            local v7, v8, v9 = p5:ToHSV();
            local v10 = p6 or 0.05;
            local v11 = v7 + u4:NextNumber(-v10, v10);

            return Color3.fromHSV(v11, v8, v9), v11, v8, v9;
        end;

        local function CreatePart(p12, p13, p14) -- Line: 26
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

        local u17 = {
            Color3.fromRGB(23, 212, 255),
            Color3.fromRGB(255, 55, 255),
            Color3.fromRGB(43, 135, 255),
            Color3.fromRGB(158, 48, 255)
        };
        local _ = Base.CFrame;
        local u18 = 3;
        local u19 = nil;
        local u20 = Color3.fromRGB(0, 29, 79);
        local u21 = Color3.fromRGB(0, 87, 163);

        local function generateTrunk(p22, p23, p24) -- Line: 74
            -- upvalues: u4 (copy), u20 (copy), u21 (copy), u19 (ref), u1 (copy), u17 (copy), CreatePart (copy), u18 (ref)
            local v25 = p22:GetPivot() * CFrame.new(0, p22.Size.Y / 2, 0);

            for i = 1, p23 do
                local v26 = script.Stud_Part:Clone();
                local v27 = 5 + u4:NextNumber(-2, 3);
                local Angles = CFrame.Angles;
                local v28 = u4:NextNumber(-15, 15);
                local v29 = math.rad(v28);
                local v30 = u4:NextNumber(-15, 15);
                local v31 = math.rad(v30);
                local v32 = u4:NextNumber(-15, 15);
                local v33 = Angles(v29, v31, (math.rad(v32)));
                local new = CFrame.new;
                local Position = v25.Position;
                local v34 = u4:NextNumber(-15, 15);
                local v35 = u4:NextNumber(-15, 15);
                new(Position + Vector3.new(v34, v35, u4:NextNumber(-15, 15)));
                v26.Color = u20:Lerp(u21, (math.clamp(i / p23, 0, 1)));
                v26.Size = Vector3.new(1.2999999523162842, v27, 1.2999999523162842);
                local v36;

                if u19 then
                    v36 = u19.Size.Y;
                    v25 = u19:GetPivot();
                else
                    v36 = 0;
                end;

                v26.CFrame = v25 * CFrame.new(0, v36 / 2.1, 0) * v33 * CFrame.new(0, v27 / 2.1, 0);
                v26.Name = i;
                v26.Parent = u1;
                local v37 = v26:Clone();
                v37.Size = Vector3.new(v26.Size.X * 1.05, v26.Size.X * 1.05, v26.Size.X * 1.05);
                v37.Color = Color3.fromRGB(110, 72, 223);
                v37.Name = i + 1;
                v37.Parent = u1;

                if i == p23 then
                    local v38 = u4:NextNumber(4, 8);

                    for i2 = 1, v38 do
                        local v39 = script.Branch:Clone();
                        local v40 = v26:GetPivot() * CFrame.new(0, v26.Size.Y / 2, 0);
                        local Angles2 = CFrame.Angles;
                        local v41 = 360 / v38 * i2 + u4:NextInteger(-15, 15);
                        local v42 = math.rad(v41);
                        local v43 = u4:NextInteger(5, 35);
                        v39:PivotTo(v40 * Angles2(0, v42, (math.rad(v43))));
                        v39:ScaleTo(u4:NextNumber(0.8, 1.1));
                        v39[4].Color = u17[math.random(1, #u17)];

                        for _, child in v39:GetChildren() do
                            child.Name = tonumber(child.Name) + tonumber(v26.Name);
                            child.Parent = u1;
                        end;

                        v39:Destroy();
                    end;

                    local v44 = CreatePart();
                    v44.Size = Vector3.new(1, 1, 1);
                    v44.CFrame = v26:GetPivot() * CFrame.new(0, v26.Size.Y / 2, 0) * CFrame.Angles(3.141592653589793, 0, 0);
                    v44.Parent = u1.FruitSpawnLocations;
                else
                    local v45 = script.Leaf:Clone();
                    local v46 = v26:GetPivot();
                    local Angles2 = CFrame.Angles;
                    local v47 = u4:NextInteger(-22, 22);
                    local v48 = math.rad(v47);
                    local v49 = u4:NextInteger(0, 360);
                    local v50 = math.rad(v49);
                    local v51 = u4:NextInteger(70, 100);
                    v45:PivotTo(v46 * Angles2(v48, v50, (math.rad(v51))));
                    v45:ScaleTo(u4:NextNumber(0.7, 1.1));

                    for _, child in v45:GetChildren() do
                        child.Name = tonumber(child.Name) + tonumber(v26.Name);
                        child.Parent = u1;
                    end;
                end;

                u18 = u18 + 1;
                u19 = v26;
            end;

            u19 = nil;
        end;

        local v52 = u4:NextInteger(6, 8);

        while u4:NextInteger(1, 30) == 1 do
            v52 = v52 + u4:NextInteger(7, 11);

            while u4:NextInteger(1, 10) == 1 do
                v52 = v52 * 2;
            end;
        end;

        generateTrunk(Base, math.floor(v52), Base:GetPivot());

        while u4:NextInteger(1, 30) == 1 do
            generateTrunk(Base, math.floor(v52), Base:GetPivot());
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u53) -- Line: 188, Name: BeginPlantGrowth
        local PrimaryPart = u53.PrimaryPart;
        local u54 = {};

        for _, v in u53:QueryDescendants("BasePart") do
            local v55 = tonumber(v.Name);

            if v55 then
                local v56 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") then
                        table.insert(v56, { child, child.Transparency });
                        child.Transparency = 1;
                    end;
                end;

                local v57 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v55,
                    v56
                };
                table.insert(u54, v57);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 216
            -- upvalues: u53 (copy), u54 (copy), PrimaryPart (copy)
            local v58 = u53:GetAttribute("Age") or 0;

            for _, v in u54 do
                local v59 = v[1];
                local v60 = v[2];
                local v61 = v[3];
                local v62 = v[5];
                local v63 = math.min(v58 - v[4], 1);
                local v64 = math.clamp(v63, 0, 1);

                if v64 ~= v.lastProgress then
                    v.lastProgress = v64;

                    if v63 > 0 then
                        v59.Size = Vector3.new(v60.X, v60.Y * v63, v60.Z);
                        v59.CFrame = PrimaryPart.CFrame * v61 * CFrame.new(0, (v59.Size.Y - v60.Y) / 2, 0);
                        v59.Transparency = v59:GetAttribute("OG_Transparency") or 0;
                        v59.CanCollide = true;
                    else
                        v59.Transparency = 1;
                        v59.CanCollide = false;
                    end;

                    local v65 = v63 >= 1;

                    for _, v2 in v62 do
                        v2[1].Transparency = v65 and v2[2] or 1;
                    end;
                end;
            end;
        end;

        u53:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};