-- Decompiled with Potassium's decompiler.

local Thorn = script.Thorn;

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u1, p2, p3) -- Line: 8, Name: InitPlant
        -- upvalues: Thorn (copy)
        local u4 = Random.new(p2);
        local FruitSpawnLocations = u1.FruitSpawnLocations;
        local Base = u1.Base;
        local Stud_Part = script.Stud_Part;
        local v5 = Color3.fromRGB(34, 120, 42);
        local u6 = Color3.fromRGB(180, 35, 35);
        local u7 = { u1 };
        local u8 = RaycastParams.new();
        u8.FilterDescendantsInstances = u7;
        u8.FilterType = Enum.RaycastFilterType.Exclude;
        local Position = (Base.CFrame * CFrame.new(0, Base.Size.Y / 2 + 0.5, 0)).Position;
        local v9 = Vector3.new(0, 1, 0);
        local Y = Position.Y;
        local LookVector = Base.CFrame.LookVector;
        local v10 = LookVector - LookVector:Dot(v9) * v9;

        if v10.Magnitude < 0.01 then
            v10 = Base.CFrame.RightVector;
        end;

        local Unit = v10.Unit;
        local u11 = {};

        local function getTangent(p12, p13) -- Line: 46
            local v14 = p13 - p13:Dot(p12) * p12;

            if v14.Magnitude < 0.01 then
                v14 = p12:Cross(Vector3.new(1, 0, 0));

                if v14.Magnitude < 0.01 then
                    v14 = p12:Cross(Vector3.new(0, 0, 1));
                end;
            end;

            return v14.Unit;
        end;

        local function probe(p15, p16, p17) -- Line: 55
            -- upvalues: u8 (copy)
            if p16.Magnitude < 0.01 then
                return nil;
            end;

            return workspace:Raycast(p15, p16.Unit * (p17 or 15), u8);
        end;

        local function loopPenalty(p18) -- Line: 60
            -- upvalues: u11 (copy)
            local v19 = 0;

            for _, v in u11 do
                local Magnitude = (p18 - v).Magnitude;

                if Magnitude < 8 then
                    v19 = v19 + (8 - Magnitude) * 5;
                end;
            end;

            return v19;
        end;

        local function addToHistory(p20) -- Line: 71
            -- upvalues: u11 (copy)
            table.insert(u11, p20);

            if #u11 > 12 then
                table.remove(u11, 1);
            end;
        end;

        local v21 = {};
        local u22 = 0;

        for i = -1, 1 do
            for i2 = -1, 1 do
                for i3 = -1, 1 do
                    if i ~= 0 or (i2 ~= 0 or i3 ~= 0) then
                        local Unit2 = Vector3.new(i, i2, i3).Unit;
                        table.insert(v21, Unit2);
                    end;
                end;
            end;
        end;

        local v23 = {
            (Vector3.new(1, 2, 0)).Unit,
            (Vector3.new(-1, 2, 0)).Unit,
            (Vector3.new(0, 2, 1)).Unit,
            (Vector3.new(0, 2, -1)).Unit,
            (Vector3.new(1, 2, 1)).Unit,
            (Vector3.new(-1, 2, 1)).Unit,
            (Vector3.new(1, 2, -1)).Unit,
            (Vector3.new(-1, 2, -1)).Unit,
            (Vector3.new(1, 3, 0)).Unit,
            (Vector3.new(-1, 3, 0)).Unit,
            (Vector3.new(0, 3, 1)).Unit,
            (Vector3.new(0, 3, -1)).Unit,
            Vector3.new(0, 1, 0)
        };

        local function attachThorn(p24, p25, p26, p27) -- Line: 104
            -- upvalues: u22 (ref), u4 (copy), Thorn (ref), u6 (copy), u1 (copy), u7 (copy)
            u22 = u22 + 1;
            local v28 = u4:NextNumber(-p25.Z * 0.35, p25.Z * 0.35);
            local v29 = p24.Position + p24.LookVector * v28 + p26 * p27;
            local v30 = CFrame.lookAt(v29, v29 + p26, p24.LookVector) * CFrame.Angles(-1.5707963267948966, 0, 0);
            local v31 = Thorn:Clone();
            v31.Size = v31.Size * 0.7;
            v31.CFrame = v30;
            v31.Color = u6;
            v31.Anchored = true;
            v31.CanCollide = false;
            v31.Transparency = 1;
            v31.Name = tostring(u22);
            v31.Parent = u1;
            table.insert(u7, v31);
        end;

        local function attachAllThorns(p32, p33) -- Line: 128
            -- upvalues: attachThorn (copy)
            attachThorn(p32, p33, p32.RightVector, p33.X / 2);
            attachThorn(p32, p33, -p32.RightVector, p33.X / 2);
            attachThorn(p32, p33, p32.UpVector, p33.Y / 2);
            attachThorn(p32, p33, -p32.UpVector, p33.Y / 2);
        end;

        for i = 1, 40 do
            table.insert(u11, Position);

            if #u11 > 12 then
                table.remove(u11, 1);
            end;

            u22 = i;
            local v34 = u4:NextNumber(-0.7, 0.7);
            local Position2 = (CFrame.fromAxisAngle(v9, v34) * CFrame.new(Unit)).Position;
            local v35 = Position2 - Position2:Dot(v9) * v9;

            if v35.Magnitude < 0.01 then
                v35 = v9:Cross(Vector3.new(1, 0, 0));

                if v35.Magnitude < 0.01 then
                    v35 = v9:Cross(Vector3.new(0, 0, 1));
                end;
            end;

            local Unit2 = v35.Unit;
            local v36 = Position + v9 * 0.3;
            local v37 = {};

            for _, v in v21 do
                local v38;

                if v.Magnitude < 0.01 then
                    v38 = nil;
                else
                    v38 = workspace:Raycast(v36, v.Unit * 15, u8);
                end;

                if v38 then
                    table.insert(v37, v38);
                end;
            end;

            for _, v in v23 do
                local v39;

                if v.Magnitude < 0.01 then
                    v39 = nil;
                else
                    v39 = workspace:Raycast(v36, v.Unit * 15, u8);
                end;

                if v39 then
                    table.insert(v37, v39);
                end;
            end;

            local v40 = (-1 / 0);
            local v41 = nil;
            Unit = nil;
            local v42 = nil;

            for _, v in v37 do
                local Normal = v.Normal;
                local v43 = v.Position + Normal * 0.5;
                local Magnitude = (v43 - Position).Magnitude;

                if Magnitude >= 0.3 then
                    local v44, v45, v46, v47, v48, v49, v50, v51, v52, v53, v54;

                    if Magnitude > 3.5999999999999996 then
                        v43 = Position + (v.Position - Position).Unit * 3;
                        local v55 = v43 + Normal * 2;
                        local v56 = -Normal;
                        local v57;

                        if v56.Magnitude < 0.01 then
                            v57 = nil;
                        else
                            v57 = workspace:Raycast(v55, v56.Unit * 4, u8);
                        end;

                        if v57 then
                            v43 = v57.Position + v57.Normal * 0.5;
                            Normal = v57.Normal;
                        end;

                        Magnitude = (v43 - Position).Magnitude;

                        if Magnitude >= 0.3 then
                            v44 = 1 - math.abs(Normal.Y);
                            v45 = (v43.Y - Position.Y) * 15 + v44 * 20 + (v43.Y - Y) * 2 + math.max(0, 15 - Magnitude) * 0.3;
                            v46 = v43 - Position;

                            if v46.Magnitude > 0.01 then
                                v45 = v45 + v46.Unit:Dot(Unit2) * 2;
                            end;

                            v47 = v43;
                            v48 = 0;

                            for i2, v2 in u11 do
                                v49 = (v43 - v2).Magnitude;

                                if v49 < 8 then
                                    v48 = v48 + (8 - v49) * 5;
                                end;
                            end;

                            v50 = v45 - v48;

                            if v47.Y < Y then
                                v50 = v50 - (Y - v47.Y) * 5;
                            end;

                            if v40 < v50 then
                                v51 = Vector3.new(0, 1, 0) - (Vector3.new(0, 1, 0)):Dot(Normal) * Normal;

                                if v51.Magnitude < 0.01 then
                                    v51 = Normal:Cross(Vector3.new(1, 0, 0));

                                    if v51.Magnitude < 0.01 then
                                        v51 = Normal:Cross(Vector3.new(0, 0, 1));
                                    end;
                                end;

                                Unit = v51.Unit;
                                v52 = Unit2 - Unit2:Dot(Normal) * Normal;

                                if v52.Magnitude < 0.01 then
                                    v52 = Normal:Cross(Vector3.new(1, 0, 0));

                                    if v52.Magnitude < 0.01 then
                                        v52 = Normal:Cross(Vector3.new(0, 0, 1));
                                    end;
                                end;

                                v53 = Unit * 0.7 + v52.Unit * 0.3;

                                if v53.Magnitude > 0.01 then
                                    v54 = v53 - v53:Dot(Normal) * Normal;

                                    if v54.Magnitude < 0.01 then
                                        v54 = Normal:Cross(Vector3.new(1, 0, 0));

                                        if v54.Magnitude < 0.01 then
                                            v54 = Normal:Cross(Vector3.new(0, 0, 1));
                                        end;
                                    end;

                                    Unit = v54.Unit;
                                    v42 = Normal;
                                    v41 = v47;
                                    v40 = v50;
                                else
                                    v42 = Normal;
                                    v41 = v47;
                                    v40 = v50;
                                end;
                            end;
                        end;
                    else
                        v44 = 1 - math.abs(Normal.Y);
                        v45 = (v43.Y - Position.Y) * 15 + v44 * 20 + (v43.Y - Y) * 2 + math.max(0, 15 - Magnitude) * 0.3;
                        v46 = v43 - Position;

                        if v46.Magnitude > 0.01 then
                            v45 = v45 + v46.Unit:Dot(Unit2) * 2;
                        end;

                        v47 = v43;
                        v48 = 0;

                        for i2, v2 in u11 do
                            v49 = (v43 - v2).Magnitude;

                            if v49 < 8 then
                                v48 = v48 + (8 - v49) * 5;
                            end;
                        end;

                        v50 = v45 - v48;

                        if v47.Y < Y then
                            v50 = v50 - (Y - v47.Y) * 5;
                        end;

                        if v40 < v50 then
                            v51 = Vector3.new(0, 1, 0) - (Vector3.new(0, 1, 0)):Dot(Normal) * Normal;

                            if v51.Magnitude < 0.01 then
                                v51 = Normal:Cross(Vector3.new(1, 0, 0));

                                if v51.Magnitude < 0.01 then
                                    v51 = Normal:Cross(Vector3.new(0, 0, 1));
                                end;
                            end;

                            Unit = v51.Unit;
                            v52 = Unit2 - Unit2:Dot(Normal) * Normal;

                            if v52.Magnitude < 0.01 then
                                v52 = Normal:Cross(Vector3.new(1, 0, 0));

                                if v52.Magnitude < 0.01 then
                                    v52 = Normal:Cross(Vector3.new(0, 0, 1));
                                end;
                            end;

                            v53 = Unit * 0.7 + v52.Unit * 0.3;

                            if v53.Magnitude > 0.01 then
                                v54 = v53 - v53:Dot(Normal) * Normal;

                                if v54.Magnitude < 0.01 then
                                    v54 = Normal:Cross(Vector3.new(1, 0, 0));

                                    if v54.Magnitude < 0.01 then
                                        v54 = Normal:Cross(Vector3.new(0, 0, 1));
                                    end;
                                end;

                                Unit = v54.Unit;
                                v42 = Normal;
                                v41 = v47;
                                v40 = v50;
                            else
                                v42 = Normal;
                                v41 = v47;
                                v40 = v50;
                            end;
                        end;
                    end;
                end;
            end;

            if v41 then
                v9 = v42;
            else
                for _, v in {
                    (Unit2 - Vector3.new(0, 1, 0)).Unit,
                    Vector3.new(-0, -1, -0),
                    (Unit2 * 0.5 - Vector3.new(0, 1, 0)).Unit,
                    (-Unit2 * 0.5 - Vector3.new(0, 1, 0)).Unit,
                    (CFrame.fromAxisAngle(Vector3.new(0, 1, 0), 1.5707963267948966) * CFrame.new(Unit2)).Position.Unit - Vector3.new(0, 0.5, 0),
                    (CFrame.fromAxisAngle(Vector3.new(0, 1, 0), -1.5707963267948966) * CFrame.new(Unit2)).Position.Unit - Vector3.new(0, 0.5, 0)
                } do
                    if v.Magnitude > 0.01 then
                        local v58 = Position + v9 * 0.3;
                        local Unit3 = v.Unit;
                        local v59;

                        if Unit3.Magnitude < 0.01 then
                            v59 = nil;
                        else
                            v59 = workspace:Raycast(v58, Unit3.Unit * 30, u8);
                        end;

                        if v59 then
                            local v60 = v59.Position + v59.Normal * 0.5;

                            if (v60 - Position).Magnitude >= 0.3 then
                                v42 = v59.Normal;
                                local Normal = v59.Normal;
                                local v61 = Unit2 - Unit2:Dot(Normal) * Normal;

                                if v61.Magnitude < 0.01 then
                                    v61 = Normal:Cross(Vector3.new(1, 0, 0));

                                    if v61.Magnitude < 0.01 then
                                        v61 = Normal:Cross(Vector3.new(0, 0, 1));
                                    end;
                                end;

                                Unit = v61.Unit;
                                v41 = v60;
                                break;
                            end;
                        end;
                    end;
                end;

                if v41 then
                    v9 = v42;
                else
                    v41 = Position + Vector3.new(0, 3, 0);
                    Unit = Unit2;
                    v9 = Vector3.new(0, 1, 0);
                end;
            end;

            local v62 = v41 - Position;

            if v62.Magnitude < 0.1 then
                v41 = Position + Unit2 * 3;
                v62 = v41 - Position;
            end;

            local v63 = Stud_Part:Clone();
            v63.Size = Vector3.new(1, 1, v62.Magnitude);
            v63.CFrame = CFrame.lookAt((Position + v41) / 2, v41, v9);
            v63.Anchored = true;
            v63.CanCollide = false;
            v63.Transparency = 1;
            v63.Color = v5;
            v63.Name = tostring(u22);
            v63.Parent = u1;
            table.insert(u7, v63);
            attachAllThorns(v63.CFrame, v63.Size);

            if u4:NextNumber() <= 0.1 then
                local v64 = v63.CFrame.Position + v63.CFrame.UpVector * (v63.Size.Y / 2 + 0.5);
                local Part = Instance.new("Part");
                Part.Size = Vector3.new(1, 1, 1);
                Part.Transparency = 1;
                Part.Anchored = true;
                Part.CanCollide = false;
                Part.CFrame = CFrame.new(v64);
                Part.Name = "Fruit_Spawn";
                Part.Parent = FruitSpawnLocations;
            end;

            u8.FilterDescendantsInstances = u7;
            Position = v41;
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u65) -- Line: 301, Name: BeginPlantGrowth
        local PrimaryPart = u65.PrimaryPart;
        local u66 = {};

        for _, v in u65:QueryDescendants("BasePart") do
            local v67 = tonumber(v.Name);

            if v67 then
                local v68 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v68, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });
                        child.Transparency = 1;
                    end;
                end;

                local v69 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v67,
                    decals = v68
                };
                table.insert(u66, v69);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 331
            -- upvalues: u65 (copy), u66 (copy), PrimaryPart (copy)
            local v70 = u65:GetAttribute("Age") or 0;

            for _, v in u66 do
                local v71 = math.min(v70 - v.partAge, 1);
                local v72 = math.clamp(v71, 0, 1);

                if v72 ~= v.lastProgress then
                    v.lastProgress = v72;

                    if v71 > 0 then
                        local v73 = v.maxSize.Z * v71;
                        v.part.Size = Vector3.new(v.maxSize.X, v.maxSize.Y, v73);
                        v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, 0, (v.maxSize.Z - v73) / 2);
                        v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                        v.part.CanCollide = true;

                        for _, v2 in v.decals do
                            v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v71);
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

            if game.Players.LocalPlayer and (game:GetService("RunService"):IsClient() and (not u65:GetAttribute("playedSfx") and u65:GetAttribute("MaxAge") <= v70)) then
                u65:SetAttribute("playedSfx", true);
                game.SoundService:PlayLocalSound(game.SoundService.SFX.Happy);
            end;
        end;

        u65:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};