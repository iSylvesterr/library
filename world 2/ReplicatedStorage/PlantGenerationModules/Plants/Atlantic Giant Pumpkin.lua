-- Decompiled with Potassium's decompiler.

local MaterialService = game:GetService("MaterialService");

return {
    GrowData = {
        InheritPlantSizeMultiplier = 1
    },

    InitPlant = function(u1, p2, p3) -- Line: 11, Name: InitPlant
        -- upvalues: MaterialService (copy)
        local u4 = Random.new(p2);
        local _ = u1.FruitSpawnLocations;
        local Base = u1.Base;

        local function GetRandomHSV(p5, p6) -- Line: 19
            -- upvalues: u4 (copy)
            local v7, v8, v9 = p5:ToHSV();
            local v10 = p6 or 0.05;
            local v11 = v7 + u4:NextNumber(-v10, v10);

            return Color3.fromHSV(v11, v8, v9), v11, v8, v9;
        end;

        local function CreatePart(p12, p13, p14) -- Line: 27
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
        Base.Color = Color3.fromRGB(62, 159, 49);
        local u17 = Color3.fromRGB(68, 143, 47);
        local u18 = u17:Lerp(Color3.new(0, 0, 0), 0.2);

        local function BranchOut(p19, p20, p21, p22, p23) -- Line: 75
            -- upvalues: CreatePart (copy), u4 (copy), u17 (copy), u18 (copy), BranchOut (copy)
            for _ = 1, p22 do
                local v24 = CreatePart(nil, "Studs");
                local v25 = u4:NextInteger(-25, 25);
                local v26 = p21 * u4:NextNumber(0.33, 0.4);
                local v27 = p21 * u4:NextNumber(0.95, 1.5);
                v24.Size = Vector3.new(v26, v27, v26);
                v24.CFrame = p19 * CFrame.Angles(math.rad(v25), 0, 0) * CFrame.new(0, v24.Size.Y / 2.2, 0);
                v24.Color = u17:Lerp(u18, (math.clamp((p20 - 1) / 3, 0, 1)));
                v24.Name = p20;

                if u4:NextInteger(1, 3) == 1 then
                    local v28 = script.Leaf:Clone();
                    v28:PivotTo(v24:GetPivot() * CFrame.new(v24.Size.X / 2.5, v24.Size.Y / 2, 0));
                    v28.Color = v24.Color;
                    v28.Name = p20 + 1;
                    v28.Parent = v24;
                end;

                p20 = p20 + 1;

                if u4:NextInteger(1, 3) == 1 and p23 then
                    local CFrame2 = v24.CFrame;
                    local Angles = CFrame.Angles;
                    local v29 = u4:NextInteger(1, 2) == 1 and -u4:NextNumber(35, 80) or u4:NextNumber(35, 80);
                    BranchOut(CFrame2 * Angles(math.rad(v29), 0, 0), p20, p21, 1, false);
                else
                    local v30 = script.Leaf:Clone();
                    v30:PivotTo(v24:GetPivot() * CFrame.new(v24.Size.X / 2.5, v24.Size.Y / 2, 0));
                    v30.Color = v24.Color;
                    v30.Name = p20 + 1;
                    v30.Parent = v24;
                end;

                p19 = v24.CFrame * CFrame.new(0, v24.Size.Y / 2, 0);
            end;
        end;

        local _ = Base.CFrame;
        local v31 = u4:NextInteger(2, 4);
        local v32 = p3 or 1;

        for i = 1, v31 do
            BranchOut(Base.CFrame * CFrame.Angles(0, math.rad(360 / v31 * i), 1.5707963267948966), 1, u4:NextNumber(4, 5) * (v32 / 2), u4:NextInteger(2, 5), true);
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u33) -- Line: 141, Name: BeginPlantGrowth
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

        local function updateGrowth() -- Line: 159
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