-- Decompiled with Potassium's decompiler.

local MaterialService = game:GetService("MaterialService");

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u1, p2, p3) -- Line: 11, Name: InitPlant
        -- upvalues: MaterialService (copy)
        local u4 = p3 or 1;
        local u5 = Random.new(p2);
        local _ = u1.FruitSpawnLocations;
        local Base = u1.Base;

        local function GetRandomHSV(p6, p7) -- Line: 18
            -- upvalues: u5 (copy)
            local v8, v9, v10 = p6:ToHSV();
            local v11 = p7 or 0.05;
            local v12 = v8 + u5:NextNumber(-v11, v11);

            return Color3.fromHSV(v12, v9, v10), v12, v9, v10;
        end;

        local function CreatePart(p13, p14, p15) -- Line: 26
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

        local v18 = u5:NextInteger(1, 2) * (u4 * 0.5 + 0.5);
        local v19 = u5:NextInteger(3, 5) * (u4 * 0.5 + 0.5);
        local v20 = u5:NextInteger(4, 8);
        local v21 = 3;

        while u5:NextInteger(1, (math.round(50 / u4))) == 1 do
            v20 = v20 * u5:NextInteger(2, 3);
            v21 = v21 * u5:NextInteger(2, 3);

            while u5:NextInteger(1, 2) == 1 do
                v18 = v18 * 1.5;
                v19 = v19 * 1.5;
            end;
        end;

        local u22 = Vector3.new(v18, v19, v18);
        local _ = Base.CFrame;
        local u23 = 1;
        local u24 = nil;
        local u25 = 0;
        local u26 = {};
        local u27 = {};

        local function generateTrunk(p28, p29, p30) -- Line: 85
            -- upvalues: u22 (copy), u24 (ref), u5 (copy), u25 (ref), u23 (ref), u1 (copy), u26 (copy), u27 (copy), u4 (ref)
            local v31 = p28:GetPivot();

            for i = 1, p29 do
                local v32 = script.Stud_Part:Clone();
                local v33 = math.clamp(u22.X - i * 0.015, 1, 10);

                if u24 then
                    v33 = math.clamp(u24.Size.X - i * 0.03, 1, 10);
                elseif p30 == nil then
                    v33 = math.clamp(p28.Size.X - i * 0.03, 1, 10);
                end;

                local v34;

                if p30 then
                    v34 = u22.Y + u5:NextNumber(-3.4, 3);
                else
                    v34 = u22.Y + u5:NextNumber(-3.4, 1.5);
                end;

                local Angles = CFrame.Angles;
                local v35 = u5:NextNumber(-15, 15);
                local v36 = math.rad(v35);
                local v37 = u5:NextNumber(-20, 20);
                local v38 = math.rad(v37);
                local v39 = u5:NextNumber(-15, 15);
                local v40 = Angles(v36, v38, (math.rad(v39)));
                local new = CFrame.new;
                local Position = v31.Position;
                local v41 = u5:NextNumber(-15, 15);
                local v42 = u5:NextNumber(-15, 15);
                new(Position + Vector3.new(v41, v42, u5:NextNumber(-15, 15)));
                local v43, v44, v45 = Color3.fromRGB(101, 165, 38):ToHSV();
                local v46 = 0.03 or 0.05;
                local v47 = v43 + u5:NextNumber(-v46, v46);
                v32.Color = Color3.fromHSV(v47, v44, v45);
                v32.Size = Vector3.new(v33, v34, v33);
                local v48 = 0;

                if u24 then
                    v48 = u24.Size.Y;
                    v31 = u24:GetPivot();

                    if i == math.ceil(p29 / 2) then
                        local Angles2 = CFrame.Angles;
                        local v49 = u5:NextNumber(-15, 15);
                        local v50 = math.rad(v49);
                        local v51 = u5:NextNumber(20, 20);
                        local v52 = math.rad(v51);
                        local v53 = u5:NextNumber(-15, 15);
                        v40 = Angles2(v50, v52, (math.rad(v53)));
                    end;
                else
                    local Angles2 = CFrame.Angles;
                    local v54 = u5:NextNumber(-45, 45);
                    local v55 = math.rad(v54);
                    local v56 = u5:NextNumber(0, 360);
                    local v57 = math.rad(v56);
                    local v58 = u5:NextNumber(-45, 45);
                    v40 = Angles2(v55, v57, (math.rad(v58)));
                end;

                if p30 then
                    local Angles2 = CFrame.Angles;
                    local v59 = u5:NextNumber(-3, 3);
                    local v60 = math.rad(v59);
                    local v61 = u5:NextNumber(3, 3);
                    local v62 = math.rad(v61);
                    local v63 = u5:NextNumber(-3, 3);
                    v40 = Angles2(v60, v62, (math.rad(v63)));
                    u25 = u25 + 1;
                end;

                v32.CFrame = v31 * CFrame.new(0, v48 / 2.1, 0) * v40 * CFrame.new(0, v34 / 2.1, 0);
                v32.Name = u23;
                v32.Parent = u1;
                u23 = u23 + 1;

                if p29 - 2 <= i then
                    table.insert(u26, v32);
                elseif u23 < p29 * 0.85 then
                    table.insert(u27, v32);
                end;

                if i == p29 then
                    local v64 = u5:NextNumber(2, 4);

                    for i2 = 1, v64 do
                        local v65 = script.Leaf:Clone();
                        local v66 = v32:GetPivot() * CFrame.new(0, v32.Size.Y / 2, 0);
                        local Angles2 = CFrame.Angles;
                        local v67 = u5:NextInteger(-5, 20);
                        local v68 = math.rad(v67);
                        local v69 = 360 / v64 * i2 + u5:NextInteger(-15, 15);
                        local v70 = math.rad(v69);
                        local v71 = u5:NextInteger(-5, 20);
                        v65:PivotTo(v66 * Angles2(v68, v70, (math.rad(v71))));
                        local v72 = v65["1"];
                        local v73, v74, v75 = Color3.fromRGB(101, 165, 38):ToHSV();
                        local v76 = 0.03 or 0.05;
                        local v77 = v73 + u5:NextNumber(-v76, v76);
                        v72.Color = Color3.fromHSV(v77, v74, v75);
                        v65:ScaleTo(u5:NextNumber(0.6, 1.1) * (u4 * 0.5 + 0.5));
                        v72.Name = tostring(u23);
                        u23 = u23 + 1;
                        v72.Parent = u1;
                        v65:Destroy();
                    end;
                end;

                u24 = v32;
            end;

            u24 = nil;
        end;

        generateTrunk(Base, math.floor(v20), true);
        math.ceil(u25 / 5);
        local v78 = 0;

        while v21 > 0 do
            v21 = v21 - 1;
            local v79 = u5:NextInteger(3, 8);

            while u5:NextInteger(1, 5) == 1 do
                v79 = v79 + 1;
            end;

            generateTrunk(u27[u5:NextInteger(1, #u27)], v79);
            v78 = v78 + 1;
        end;

        local v80 = math.ceil(u23 / 7);

        while u5:NextInteger(1, 10) == 1 do
            v80 = v80 + 1;
        end;

        for _ = 1, v80 do
            local v81 = CreatePart();
            v81.Size = Vector3.new(1, 1, 1);
            local v82 = u26[u5:NextInteger(1, #u26)];
            v81.CFrame = v82:GetPivot() * CFrame.new(0, u5:NextNumber(-v82.Size.Y / 2, v82.Size.Y / 2), 0);
            v81.Orientation = Vector3.new(0, 0, 180);
            v81.Parent = u1.FruitSpawnLocations;
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u83) -- Line: 205, Name: BeginPlantGrowth
        local PrimaryPart = u83.PrimaryPart;
        local u84 = {};

        for _, v in u83:QueryDescendants("BasePart") do
            local v85 = tonumber(v.Name);

            if v85 then
                local v86 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v85
                };
                table.insert(u84, v86);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 223
            -- upvalues: u83 (copy), u84 (copy), PrimaryPart (copy)
            local v87 = u83:GetAttribute("Age") or 0;

            for _, v in u84 do
                local v88 = v[1];
                local v89 = v[2];
                local v90 = v[3];
                local v91 = math.min(v87 - v[4], 1);
                local v92 = math.clamp(v91, 0, 1);

                if v92 ~= v.lastProgress then
                    v.lastProgress = v92;

                    if v91 > 0 then
                        v88.Size = Vector3.new(v89.X, v89.Y * v91, v89.Z);
                        v88.CFrame = PrimaryPart.CFrame * v90 * CFrame.new(0, (v88.Size.Y - v89.Y) / 2, 0);
                        v88.Transparency = v88:GetAttribute("OG_Transparency") or 0;
                        v88.CanCollide = true;
                    else
                        v88.Transparency = 1;
                        v88.CanCollide = false;
                    end;
                end;
            end;
        end;

        u83:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};