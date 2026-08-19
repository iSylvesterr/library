-- Decompiled with Potassium's decompiler.

local MaterialService = game:GetService("MaterialService");

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u1, p2, p3) -- Line: 14, Name: InitPlant
        -- upvalues: MaterialService (copy)
        local u4 = Random.new(p2);
        local _ = u1.FruitSpawnLocations;
        local Base = u1.Base;

        local function GetRandomHSV(p5, p6) -- Line: 21
            -- upvalues: u4 (copy)
            local v7, v8, v9 = p5:ToHSV();
            local v10 = p6 or 0.05;
            local v11 = v7 + u4:NextNumber(-v10, v10);

            return Color3.fromHSV(v11, v8, v9), v11, v8, v9;
        end;

        local function CreatePart(p12, p13, p14) -- Line: 29
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

        local _ = Base.CFrame;
        local u17 = Color3.fromRGB(63, 85, 28);
        local u18 = Color3.fromRGB(113, 150, 50);
        local v19 = u4:NextNumber(3, 4);
        local u20 = nil;
        local u21 = 3;

        for i = 1, v19 do
            local v22 = script.Leaf:Clone();
            local CFrame2 = u1.Base.CFrame;
            local Angles = CFrame.Angles;
            local v23 = 360 / v19 * i + u4:NextNumber(-22, 22);
            v22:PivotTo(CFrame2 * Angles(0, math.rad(v23), 0));
            local WorldPivot = v22.WorldPivot;
            local Angles2 = CFrame.Angles;
            local v24 = u4:NextNumber(75, 95);
            v22:PivotTo(WorldPivot * Angles2(math.rad(v24), 0, 0));
            v22:ScaleTo(u4:NextNumber(1, 1.2));
            local v25 = v22["1"];
            v25.Parent = u1;
            v25:AddTag("Honeysuckle");
            v22:Destroy();
        end;

        local function generateTrunk(p26, p27, p28) -- Line: 86
            -- upvalues: u4 (copy), u17 (copy), u18 (copy), u20 (ref), u1 (copy), CreatePart (copy), u21 (ref)
            local v29 = p26:GetPivot() * CFrame.new(0, p26.Size.Y / 2, 0);

            for i = 1, p27 do
                local v30 = script.Stud_Part:Clone();
                local v31 = 2.0999999046325684 + u4:NextNumber(-2, 3);
                local Angles = CFrame.Angles;
                local v32 = u4:NextNumber(-15, 15);
                local v33 = math.rad(v32);
                local v34 = u4:NextNumber(-15, 15);
                local v35 = math.rad(v34);
                local v36 = u4:NextNumber(-15, 15);
                local v37 = Angles(v33, v35, (math.rad(v36)));
                local new = CFrame.new;
                local Position = v29.Position;
                local v38 = u4:NextNumber(-15, 15);
                local v39 = u4:NextNumber(-15, 15);
                new(Position + Vector3.new(v38, v39, u4:NextNumber(-15, 15)));
                v30.Color = u17:Lerp(u18, (math.clamp(i / p27, 0, 1)));
                v30.Size = Vector3.new(1.7000000476837158, v31, 1.7000000476837158);
                local v40;

                if u20 then
                    v40 = u20.Size.Y;
                    v29 = u20:GetPivot();
                else
                    v40 = 0;
                end;

                v30.CFrame = v29 * CFrame.new(0, v40 / 2.1, 0) * v37 * CFrame.new(0, v31 / 2.1, 0);
                v30.Name = i;
                v30.Parent = u1;

                if i == p27 then
                    local v41 = u4:NextNumber(2, 3);

                    for i2 = 1, v41 do
                        local v42 = script.Leaf:Clone();
                        local v43 = v30.CFrame * CFrame.new(0, v30.Size.Y / 2, 0);
                        local Angles2 = CFrame.Angles;
                        local v44 = 360 / v41 * i2 + u4:NextNumber(-23, 23);
                        v42:PivotTo(v43 * Angles2(0, math.rad(v44), 0));
                        local WorldPivot = v42.WorldPivot;
                        local Angles3 = CFrame.Angles;
                        local v45 = u4:NextNumber(110, 130);
                        v42:PivotTo(WorldPivot * Angles3(math.rad(v45), 0, 0));
                        v42:ScaleTo(u4:NextNumber(0.8, 0.9));
                        local v46 = v42["1"];
                        v46.Name = tonumber(v30.Name) + 1;
                        v46.Parent = u1;
                        v46:AddTag("Honeysuckle");
                        v42:Destroy();
                    end;

                    local v47 = CreatePart();
                    v47.Size = Vector3.new(1, 1, 1);
                    v47.CFrame = v30:GetPivot() * CFrame.new(0, v30.Size.Y / 2, 0) * CFrame.Angles(3.141592653589793, 0, 0);
                    v47.Parent = u1.FruitSpawnLocations;
                elseif u4:NextInteger(1, 2) == 1 then
                    local v48 = script.Leaf:Clone();
                    local v49 = v30:GetPivot();
                    local Angles2 = CFrame.Angles;
                    local v50 = u4:NextInteger(-22, 22);
                    local v51 = math.rad(v50);
                    local v52 = u4:NextInteger(0, 360);
                    local v53 = math.rad(v52);
                    local v54 = u4:NextInteger(70, 100);
                    v48:PivotTo(v49 * Angles2(v51, v53, (math.rad(v54))));
                    v48:ScaleTo(u4:NextNumber(0.2, 0.35));
                    local v55 = v48["1"];
                    v55.Name = tonumber(v30.Name) + 1;
                    v55.Parent = u1;
                    v55:AddTag("Honeysuckle");
                    v48:Destroy();
                end;

                u21 = u21 + 1;
                u20 = v30;
            end;

            u20 = nil;
        end;

        local v56 = u4:NextInteger(4, 6);

        while u4:NextInteger(1, 7) == 1 and v56 < 150 do
            v56 = v56 + 1;
        end;

        generateTrunk(Base, math.floor(v56), Base:GetPivot());
        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u57) -- Line: 176, Name: BeginPlantGrowth
        local PrimaryPart = u57.PrimaryPart;
        local u58 = {};

        for _, v in u57:QueryDescendants("BasePart") do
            local v59 = tonumber(v.Name);

            if v59 then
                local v60 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") then
                        table.insert(v60, { child, child.Transparency });
                        child.Transparency = 1;
                    end;
                end;

                local v61 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v59,
                    v60
                };
                table.insert(u58, v61);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 204
            -- upvalues: u57 (copy), u58 (copy), PrimaryPart (copy)
            local v62 = u57:GetAttribute("Age") or 0;

            for _, v in u58 do
                local v63 = v[1];
                local v64 = v[2];
                local v65 = v[3];
                local v66 = v[5];
                local v67 = math.min(v62 - v[4], 1);
                local v68 = math.clamp(v67, 0, 1);

                if v68 ~= v.lastProgress then
                    v.lastProgress = v68;

                    if v67 > 0 then
                        v63.Size = Vector3.new(v64.X, v64.Y * v67, v64.Z);
                        v63.CFrame = PrimaryPart.CFrame * v65 * CFrame.new(0, (v63.Size.Y - v64.Y) / 2, 0);
                        v63.Transparency = v63:GetAttribute("OG_Transparency") or 0;
                        v63.CanCollide = true;
                    else
                        v63.Transparency = 1;
                        v63.CanCollide = false;
                    end;

                    local v69 = v67 >= 1;

                    for _, v2 in v66 do
                        v2[1].Transparency = v69 and v2[2] or 1;
                    end;
                end;
            end;
        end;

        u57:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};