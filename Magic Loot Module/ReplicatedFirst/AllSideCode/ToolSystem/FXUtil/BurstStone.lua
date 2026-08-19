-- Decompiled with Potassium's decompiler.

local v1 = {};
game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
local RunService = game:GetService("RunService");
local RayCast = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).RayCast;
local BurstStoneConfig = require(script.Parent.BurstStoneConfig);

local function _applyGroundMaterial(p2, p3) -- Line: 37
    if not p3 then
        return;
    end;

    if p3.Instance:IsA("BasePart") then
        p2.Color = p3.Instance.Color;
    end;

    p2.Material = p3.Material;

    if p2.Material == Enum.Material.Plastic then
        p2.Material = Enum.Material.SmoothPlastic;
    end;

    if p3.Instance.MaterialVariant then
        p2.MaterialVariant = p3.Instance.MaterialVariant;
    end;

    p2.CastShadow = false;
end;

local function _createBaseStone(p4) -- Line: 63
    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanTouch = false;
    Part.CanQuery = false;
    Part.CanCollide = false;
    Part.Material = Enum.Material.SmoothPlastic;
    Part.Size = p4;

    return Part;
end;

local function _stoneRise(p5, p6, p7, u8, p9, p10, p11, p12, p13, p14, p15, p16) -- Line: 83
    -- upvalues: RayCast (copy), _applyGroundMaterial (copy), TweenService (copy), Debris (copy)
    local v17 = p12 or Enum.EasingStyle.Back;
    local v18 = p13 or Enum.EasingDirection.In;
    local v19 = p15 or 1;
    local v20 = p16 or Vector3.new(15, 360, 20);
    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanTouch = false;
    Part.CanQuery = false;
    Part.CanCollide = false;
    Part.Material = Enum.Material.SmoothPlastic;
    Part.Size = p6;

    if p14 then
        local v21 = p14.Position * v19;
        local v22 = (1 - 2 * math.random()) * v21.X;
        local v23 = (1 - 2 * math.random()) * v21.Y;
        local v24 = (1 - 2 * math.random()) * v21.Z;
        p5 = p5 + Vector3.new(v22, v23, v24);
    end;

    local v25 = CFrame.new(p5 + Vector3.new(0, 10, 0));
    local Angles = CFrame.Angles;
    local v26 = v20.X * (1 - 2 * math.random());
    local v27 = math.rad(v26);
    local v28 = v20.Y * math.random();
    local v29 = math.rad(v28);
    local v30 = v20.Z * (1 - 2 * math.random());
    local v31 = v25 * Angles(v27, v29, (math.rad(v30)));

    if p14 then
        local v32, v33, v34 = p14:ToEulerAnglesXYZ();
        v31 = v31 * CFrame.Angles((1 - 2 * math.random()) * v32, (1 - 2 * math.random()) * v33, (1 - 2 * math.random()) * v34);
    end;

    local v35 = RayCast.RayCastDirection(p5 + Vector3.new(0, 10, 0), Vector3.new(0, -1, 0), 100, "Ground");

    if v35 then
        _applyGroundMaterial(Part, v35);
        v31 = v31.Rotation + v35.Position;
    end;

    local v36 = (2.5 + 0.5 * math.random()) * (p6.X + p6.Y + p6.Z) / 3;
    Part:PivotTo(v31 - Vector3.new(0, v36, 0));
    Part.Parent = workspace.Debris;
    local v37 = v31 - Vector3.new(0, v36, 0);
    local v38 = TweenService:Create(Part, TweenInfo.new(p7, p9, p10), {
        CFrame = v31
    });
    local u39 = TweenService:Create(Part, TweenInfo.new(p11 or 0.1, v17, v18), {
        CFrame = v37
    });
    u39.Completed:Once(function() -- Line: 164
        -- upvalues: Debris (ref), Part (copy)
        Debris:AddItem(Part, 0);
    end);
    v38.Completed:Once(function() -- Line: 168
        -- upvalues: u8 (copy), u39 (copy)
        task.delay(u8, function() -- Line: 169
            -- upvalues: u39 (ref)
            u39:Play();
        end);
    end);
    v38:Play();
end;

local function _kickModelBack(p40, p41, p42, p43, p44, p45) -- Line: 184
    if not p40 then
        return;
    end;

    local v46;

    if p40:IsA("Model") then
        v46 = p40.PrimaryPart;
    else
        v46 = nil;
    end;

    if p40:IsA("BasePart") then
        v46 = p40;
    end;

    if not v46 then
        return;
    end;

    local v47 = p40:GetDescendants();
    table.insert(v47, v46);
    local v48 = 0;

    for _, v in pairs(v47) do
        if v:IsA("BasePart") then
            v48 = v48 + v:GetMass();
        end;
    end;

    local _ = v46.AssemblyMass;
    v46.AssemblyLinearVelocity = v46.AssemblyLinearVelocity + p41 * 4.8 * p42 * p43;
    v46.AssemblyAngularVelocity = v46.AssemblyAngularVelocity + Vector3.new(360, 0, 360) * math.random() * 0.15;
end;

local function _stoneFly(p49, p50, p51, p52) -- Line: 232
    -- upvalues: RayCast (copy), _applyGroundMaterial (copy), _kickModelBack (copy), Debris (copy)
    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanTouch = false;
    Part.CanQuery = false;
    Part.CanCollide = false;
    Part.Material = Enum.Material.SmoothPlastic;
    Part.Size = p50;
    local v53 = RayCast.RayCastDirection(p49 + Vector3.new(0, 10, 0), Vector3.new(0, -1, 0), 100, "Ground");

    if v53 then
        _applyGroundMaterial(Part, v53);
    end;

    Part.Parent = workspace.Debris;
    Part:PivotTo(CFrame.new(p49) * CFrame.Angles(6.283185307179586 * math.random(), 0, 6.283185307179586 * math.random()));
    Part.Anchored = false;
    local v54 = 1 - 2 * math.random();
    local v55 = 1 - 2 * math.random();
    local Unit = Vector3.new(v54, 4, v55).Unit;
    local v56 = 1 - 2 * math.random();
    local v57 = 1 - 2 * math.random();
    _kickModelBack(Part, Unit, 0.1, p52, Vector3.new(v56, v57, 0), true);
    task.delay(p51, function() -- Line: 252
        -- upvalues: Debris (ref), Part (copy)
        Debris:AddItem(Part, 0);
    end);
end;

function v1.CreateShock(u58, u59, u60, u61, u62, u63, p64, p65, p66) -- Line: 277
    -- upvalues: RunService (copy), TweenService (copy), _stoneFly (copy), _stoneRise (copy)
    local u67 = p64 or 0.3;
    local u68 = p65 or 2;
    local u69 = p66 or 0.1;
    local u70 = nil;
    local u71 = 0;
    local u72 = 0;
    local u73 = 0;
    u70 = RunService.RenderStepped:Connect(function(p74) -- Line: 298
        -- upvalues: u71 (ref), u63 (copy), TweenService (ref), u72 (ref), u70 (ref), u73 (ref), u62 (copy), u58 (copy), u60 (copy), u61 (copy), u59 (copy), _stoneFly (ref), _stoneRise (ref), u67 (ref), u68 (ref), u69 (ref)
        local v75 = TweenService:GetValue(math.clamp(u71 / u63, 0, 1), Enum.EasingStyle.Circular, Enum.EasingDirection.Out);

        if u63 <= u71 and u72 > 0 then
            u70:Disconnect();
            u70 = nil;

            return;
        end;

        if u63 <= u71 then
            u72 = u72 + 1;
        end;

        while u73 / u62 <= v75 do
            u73 = u73 + 1;
            local v76 = TweenService:GetValue(math.clamp(u73 / u62, 0, 1), Enum.EasingStyle.Linear, Enum.EasingDirection.In);
            local v77 = u58:ToWorldSpace(CFrame.new(u60, 0, 0)) * CFrame.Angles(0, math.rad(u61), 0):ToWorldSpace(CFrame.new(0, 0, -u59 * u73 / u62));
            local v78 = u58:ToWorldSpace(CFrame.new(-u60, 0, 0)) * CFrame.Angles(0, math.rad(-u61), 0):ToWorldSpace(CFrame.new(0, 0, -u59 * u73 / u62));
            local v79 = Vector3.new(0.7, 0.7, 0.7) + Vector3.new(6.3, 6.3, 6.3) * v76;
            local v80 = (v77.Position + v78.Position) / 2;
            local v81 = 1 - 2 * math.random();
            local v82 = 1 - 2 * math.random();
            local v83 = 1 - 2 * math.random();
            local v84 = Vector3.new(v81, v82, v83);
            _stoneFly(v80 + v84, Vector3.new(2, 2, 2), 3, 160 + 100 * math.random());
            _stoneFly(v80 + v84, Vector3.new(2, 2, 2), 3, 160 + 100 * math.random());
            _stoneRise(v77.Position, v79, u67, u68, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, u69);
            _stoneRise(v78.Position, v79, u67, u68, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, u69);

            if u73 == u62 then
                for _ = 1, 12 do
                    _stoneFly(v80 + v84, Vector3.new(3, 3, 3) + Vector3.new(1, 1, 1) * math.random(), 3, 250 + 100 * math.random());
                end;
            end;
        end;

        u71 = u71 + p74;
    end);
end;

function v1.CreateShockOneSide(p85, p86, p87) -- Line: 361
    -- upvalues: BurstStoneConfig (copy), RunService (copy), TweenService (copy), _stoneFly (copy), _stoneRise (copy)
    local u88 = p87 or 1;
    local u89 = nil;
    local u90 = 0;
    local u91 = 0;
    local u92 = 0;
    local u93 = BurstStoneConfig.OneSideShockWaveInfo[p86];

    if not u93 then
        return;
    end;

    local RiseStoneSpawnCFrameOffset = u93.RiseStoneSpawnCFrameOffset;
    local u94 = p85:ToWorldSpace(CFrame.new(RiseStoneSpawnCFrameOffset.Position * u88) * RiseStoneSpawnCFrameOffset.Rotation);
    local MaxSize = u93.MaxSize;
    local MinSize = u93.MinSize;
    local u95 = (MinSize.X + MinSize.Y + MinSize.Z) / 3;
    local u96 = (MaxSize.X + MaxSize.Y + MaxSize.Z) / 3;
    local StoneNum = u93.StoneNum;
    local u97 = StoneNum * u95 + (u96 - u95) * (StoneNum + 1) / 2;
    u89 = RunService.RenderStepped:Connect(function(p98) -- Line: 387
        -- upvalues: u90 (ref), u93 (copy), TweenService (ref), u91 (ref), u89 (ref), u92 (ref), StoneNum (copy), u95 (copy), u96 (copy), u97 (copy), u94 (ref), MinSize (copy), MaxSize (copy), u88 (ref), _stoneFly (ref), _stoneRise (ref)
        local v99 = TweenService:GetValue(math.clamp(u90 / u93.WholeTime, 0, 1), Enum.EasingStyle.Circular, Enum.EasingDirection.Out);

        if u90 >= u93.WholeTime and u91 > 0 then
            u89:Disconnect();
            u89 = nil;

            return;
        end;

        if u90 >= u93.WholeTime then
            u91 = u91 + 1;
        end;

        while u92 / StoneNum <= v99 do
            u92 = u92 + 1;
            local v100 = TweenService:GetValue(math.clamp(u92 / StoneNum, 0, 1), Enum.EasingStyle.Linear, Enum.EasingDirection.In);
            local v101 = u94:ToWorldSpace(CFrame.new(0, 0, -u93.ShockLenth * ((u92 * u95 + (u96 - u95) * u92 * (u92 + 1) / (2 * StoneNum)) / u97)));
            local v102 = u93.RiseStoneSizeRandomRange or Vector3.new(0, 0, 0);
            local v103 = (1 - 2 * math.random()) * v102.X;
            local v104 = (1 - 2 * math.random()) * v102.Y;
            local v105 = (1 - 2 * math.random()) * v102.Z;
            local v106 = (MinSize + (MaxSize - MinSize) * v100) * u88 + Vector3.new(v103, v104, v105) * u88;
            local v107 = (u93.FlyMinSize + (u93.FlyMaxSize - u93.FlyMinSize) * math.random()) * u88;
            local FlyStoneProbability = u93.FlyStoneProbability;

            if FlyStoneProbability == nil or (FlyStoneProbability >= 1 or math.random() < FlyStoneProbability) then
                local Position = v101.Position;
                local v108 = 1 - 2 * math.random();
                local v109 = 1 - 2 * math.random();
                local v110 = 1 - 2 * math.random();
                _stoneFly(Position + Vector3.new(v108, v109, v110) * u88, v107, u93.FlyStoneLifeTime, (u93.FlyStoneForce + u93.FlyStoneForceRandomRange * math.random()) * u88);
            end;

            local Position = v101.Position;
            local RiseStonePoseOffsetRange = u93.RiseStonePoseOffsetRange;

            if RiseStonePoseOffsetRange then
                local v111 = RiseStonePoseOffsetRange.Position * u88;
                local v112 = (1 - 2 * math.random()) * v111.X;
                local v113 = (1 - 2 * math.random()) * v111.Y;
                local v114 = (1 - 2 * math.random()) * v111.Z;
                Position = Position + v101:VectorToWorldSpace((Vector3.new(v112, v113, v114)));
            end;

            local v115 = RiseStonePoseOffsetRange and CFrame.new(0, 0, 0) * RiseStonePoseOffsetRange.Rotation or nil;
            _stoneRise(Position, v106, u93.RiseTime, u93.RiseStoneLifeTime, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, u93.RiseStoneDisapearTime, u93.RiseStoneDisapearStyle, u93.RiseStoneDisapearDir, v115, 1, u93.RiseStoneOrientationRange);
        end;

        u90 = u90 + p98;
    end);
end;

function v1.CreateStoneFly(u116, p117, p118) -- Line: 477
    -- upvalues: BurstStoneConfig (copy), RayCast (copy), _applyGroundMaterial (copy), _kickModelBack (copy), TweenService (copy), Debris (copy)
    local u119 = p117 or "Temp";
    local u120 = p118 or 1;
    local v121 = BurstStoneConfig.stoneFlyInfo[u119];

    if not v121 or #v121 == 0 then
        return;
    end;

    local u122 = #v121;
    task.spawn(function() -- Line: 489
        -- upvalues: u122 (copy), BurstStoneConfig (ref), u119 (ref), u120 (ref), u116 (copy), RayCast (ref), _applyGroundMaterial (ref), _kickModelBack (ref), TweenService (ref), Debris (ref)
        for i = 1, u122 do
            local v123 = BurstStoneConfig.stoneFlyInfo[u119][i];

            for _ = 1, v123.StoneNum do
                local v124 = v123.MinSize.X + math.random() * (v123.MaxSize.X - v123.MinSize.X);
                local v125 = v123.MinSize.Y + math.random() * (v123.MaxSize.Y - v123.MinSize.Y);
                local v126 = v123.MinSize.Z + math.random() * (v123.MaxSize.Z - v123.MinSize.Z);
                local v127 = Vector3.new(v124, v125, v126);
                local v128 = (v123.MinSize + v127) * u120;
                local Part = Instance.new("Part");
                Part.Anchored = true;
                Part.CanTouch = false;
                Part.CanQuery = false;
                Part.CanCollide = false;
                Part.Material = Enum.Material.SmoothPlastic;
                Part.Size = v128;
                Part.Parent = workspace.Debris;

                if v123.CanCollide then
                    Part.CanCollide = true;
                    Part.CollisionGroup = "Player";
                end;

                local v129 = v123.SpawnOffset.X * (1 - 2 * math.random());
                local v130 = v123.SpawnOffset.Y * (1 - 2 * math.random());
                local v131 = v123.SpawnOffset.Z * (1 - 2 * math.random());
                local v132 = Vector3.new(v129, v130, v131) * u120;
                local v133 = CFrame.new(u116.Position):ToWorldSpace(CFrame.new(v132));
                local OrientationOffsetRange = v123.OrientationOffsetRange;

                if OrientationOffsetRange then
                    local v134, v135, v136 = OrientationOffsetRange:ToEulerAnglesXYZ();
                    v133 = v133 * CFrame.Angles((1 - 2 * math.random()) * v134, (1 - 2 * math.random()) * v135, (1 - 2 * math.random()) * v136);
                end;

                local v137 = RayCast.RayCastDirection(v133.Position + Vector3.new(0, 3, 0), Vector3.new(0, -1, 0), 100, "Ground");

                if v137 then
                    _applyGroundMaterial(Part, v137);
                end;

                Part:PivotTo(v133);
                local DirectionOffset = v123.DirectionOffset;
                local v138;

                if DirectionOffset then
                    local v139 = (1 - 2 * math.random()) * DirectionOffset.X;
                    local v140 = (1 - 2 * math.random()) * DirectionOffset.Y;
                    local v141 = (1 - 2 * math.random()) * DirectionOffset.Z;
                    local v142 = Vector3.new(0, 1, 0) + Vector3.new(v139, v140, v141);
                    v138 = v142.Magnitude > 0.001 and v142.Unit or Vector3.new(0, 1, 0);
                else
                    v138 = ((v133.Position - u116.Position).Unit + Vector3.new(0, 10, 0)).Unit;
                end;

                local v143 = (v123.Force + (1 - 2 * math.random()) * v123.ForceOffset) * u120;
                Part.Anchored = false;
                local v144 = 1 - 2 * math.random();
                local v145 = 1 - 2 * math.random();
                _kickModelBack(Part, v138, 0.1, v143, Vector3.new(v144, v145, 0) * u120);
                task.delay(v123.StayTime, function() -- Line: 553
                    -- upvalues: TweenService (ref), Part (copy), Debris (ref)
                    local v146 = TweenService:Create(Part, TweenInfo.new(0.1), {
                        Transparency = 1
                    });
                    v146.Completed:Once(function() -- Line: 555
                        -- upvalues: Debris (ref), Part (ref)
                        Debris:AddItem(Part, 0);
                    end);
                    v146:Play();
                end);
            end;
        end;
    end);
end;

function v1.CreateLandBreak(u147, p148, p149) -- Line: 571
    -- upvalues: BurstStoneConfig (copy), RayCast (copy), _applyGroundMaterial (copy), TweenService (copy), Debris (copy)
    if not u147 then
        return;
    end;

    local v150 = p148 or "Temp";
    local u151 = p149 or 1;
    local v152 = BurstStoneConfig.landBreakInfo[v150];

    if not v152 or #v152 == 0 then
        return;
    end;

    for i = 1, #v152 do
        local u153 = BurstStoneConfig.landBreakInfo[v150][i];
        task.delay(u153.Delay, function() -- Line: 590
            -- upvalues: u153 (copy), u151 (ref), u147 (copy), RayCast (ref), _applyGroundMaterial (ref), TweenService (ref), Debris (ref)
            for i2 = 1, u153.StoneNum do
                local v154 = u153.MinSize.X + math.random() * (u153.MaxSize.X - u153.MinSize.X);
                local v155 = u153.MinSize.Y + math.random() * (u153.MaxSize.Y - u153.MinSize.Y);
                local v156 = u153.MinSize.Z + math.random() * (u153.MaxSize.Z - u153.MinSize.Z);
                local v157 = Vector3.new(v154, v155, v156);
                local v158 = (u153.MinSize + v157) * u151;
                local Part = Instance.new("Part");
                Part.Anchored = true;
                Part.CanTouch = false;
                Part.CanQuery = false;
                Part.CanCollide = false;
                Part.Material = Enum.Material.SmoothPlastic;
                Part.Size = v158;
                Part.Parent = workspace;
                local v159 = 360 / u153.StoneNum;
                local v160 = (1 - 2 * math.random()) * u153.AngleRandomOffset.X;
                local v161 = (1 - 2 * math.random()) * u153.AngleRandomOffset.Y;
                local v162 = (1 - 2 * math.random()) * u153.AngleRandomOffset.Z;
                local v163 = Vector3.new(v160, v161, v162);
                local v164 = (1 - 2 * math.random()) * u153.PositionRamdomOffset.X;
                local v165 = (1 - 2 * math.random()) * u153.PositionRamdomOffset.Y;
                local v166 = (1 - 2 * math.random()) * u153.PositionRamdomOffset.Z;
                local v167 = Vector3.new(v164, v165, v166);
                local v168 = (u153.PositionOffset + v167) * u151;
                local u169 = (CFrame.new(u147.Position) * CFrame.Angles(0, math.rad(u153.OriAngle + v159 * i2), 0)):ToWorldSpace(CFrame.new(v168) * CFrame.Angles(u153.AngleOffset.X + v163.X, u153.AngleOffset.Y + v163.Y, u153.AngleOffset.Z + v163.Z));
                local v170 = CFrame.new((1 - 2 * math.random()) * u151, -4 * u151, (1 - 2 * math.random()) * u151);
                local Angles = CFrame.Angles;
                local v171 = (1 - 2 * math.random()) * 45;
                local v172 = math.rad(v171);
                local v173 = (1 - 2 * math.random()) * 45;
                local v174 = math.rad(v173);
                local v175 = (1 - 2 * math.random()) * 45;
                Part:PivotTo(u169:ToWorldSpace(v170 * Angles(v172, v174, (math.rad(v175)))));
                local v176 = RayCast.RayCastDirection(u169.Position + Vector3.new(0, 10, 0), Vector3.new(0, -1, 0), 100, "Ground");

                if v176 then
                    _applyGroundMaterial(Part, v176);
                end;

                TweenService:Create(Part, TweenInfo.new(0.1, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {
                    CFrame = u169
                }):Play();
                task.delay(u153.LifeTime, function() -- Line: 647
                    -- upvalues: Part (copy), TweenService (ref), u169 (copy), u153 (ref), u151 (ref), Debris (ref)
                    local Size = Part.Size;
                    local v177 = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
                    local v178 = {
                        Transparency = 1
                    };
                    local v179 = -math.max(Size.X, Size.Y, Size.Z);
                    v178.CFrame = u169 + Vector3.new(0, v179, 0);
                    local v180 = TweenService:Create(Part, v177, v178);

                    if u153.ScaleOutTime then
                        TweenService:Create(Part, TweenInfo.new(u153.ScaleOutTime), {
                            Size = Vector3.new(0.1, 0.1, 0.1) * u151
                        }):Play();
                    end;

                    v180.Completed:Connect(function() -- Line: 664
                        -- upvalues: Debris (ref), Part (ref)
                        Debris:AddItem(Part, 0);
                    end);
                    v180:Play();
                end);
            end;
        end);
    end;
end;

return v1;