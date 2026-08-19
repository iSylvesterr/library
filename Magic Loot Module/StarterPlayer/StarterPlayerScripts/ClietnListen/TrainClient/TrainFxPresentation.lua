-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local CfgFind = UtilsSystem.CfgFind;
local CollectionService = UtilsSystem.CollectionService;
local FXUtil = UtilsSystem.FXUtil;
local GetData = UtilsSystem.GetData;
local GetSkillData = UtilsSystem.GetSkillData;
local LocalMagicMissilePresentation = UtilsSystem.LocalMagicMissilePresentation;
local LocalPlayer = UtilsSystem.LocalPlayer;
local SoundModule = UtilsSystem.SoundModule;
local u1 = {};
local u2 = 1;
local u3 = nil;
local u4 = 0;
local u5 = nil;
local u6 = 0;
local u7 = 0;
local u8 = 0;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = 0;
local u14 = false;
local u15 = false;
local u16 = nil;
local u17 = nil;
local u18 = false;
local u19 = 0;
local u20 = 0;
local u21 = false;
local u22 = nil;

local function _parseTrainColor(p23) -- Line: 86
    if typeof(p23) == "Color3" then
        return p23;
    end;

    if type(p23) ~= "string" or p23 == "" then
        return nil;
    end;

    if string.sub(p23, 1, 1) == "#" then
        p23 = string.sub(p23, 2);
    end;

    local success, result = pcall(Color3.fromHex, p23);

    if success and typeof(result) == "Color3" then
        return result;
    end;

    return nil;
end;

local function _applyVfxColor(p24, p25) -- Line: 111
    local v26 = ColorSequence.new(p25);

    if p24:IsA("ParticleEmitter") or (p24:IsA("Trail") or p24:IsA("Beam")) then
        p24.Color = v26;
    end;

    for _, descendant in p24:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or (descendant:IsA("Trail") or descendant:IsA("Beam")) then
            descendant.Color = v26;
        end;
    end;

    return nil;
end;

local function _applyTrainColorToVfx(p27, p28) -- Line: 131
    -- upvalues: CfgFind (copy), _parseTrainColor (copy), _applyVfxColor (copy)
    local v29 = CfgFind.FindTrainCfgById(p28);

    if v29 then
        v29 = v29.Color;
    end;

    local v30 = _parseTrainColor(v29);

    if v30 then
        _applyVfxColor(p27, v30);
    end;

    return nil;
end;

local function _resolveCrystalFromTrainPart(p31) -- Line: 146
    if not (p31 and p31.Parent) then
        return nil;
    end;

    local Parent = p31.Parent;

    if Parent:IsA("BasePart") and (Parent.Parent and Parent.Parent:IsA("Model")) then
        Parent = Parent.Parent;
    end;

    if not Parent:IsA("Model") then
        return nil;
    end;

    local v32 = Parent:FindFirstChild("水晶");

    if v32 and v32:IsA("Model") then
        return v32;
    end;

    return nil;
end;

local function _resolveCrystalModel() -- Line: 169
    -- upvalues: _resolveCrystalFromTrainPart (copy), u3 (ref)
    return _resolveCrystalFromTrainPart(u3);
end;

local function _ensureCrystalFxMounted(p33, p34, p35) -- Line: 181
    -- upvalues: CfgFind (copy), _parseTrainColor (copy), _applyVfxColor (copy), FXUtil (copy)
    local v36 = p33:FindFirstChild(p34);

    if v36 then
        local v37 = CfgFind.FindTrainCfgById(p35);

        if v37 then
            v37 = v37.Color;
        end;

        local v38 = _parseTrainColor(v37);

        if v38 then
            _applyVfxColor(v36, v38);
        end;

        return v36;
    end;

    local v39 = FXUtil.CloneModelResEffectModel(p34);

    if not v39 then
        return nil;
    end;

    v39.Name = p34;
    FXUtil.PrepEffectForWorldShared(v39, false);
    v39:PivotTo(p33:GetPivot());
    v39.Parent = p33;
    local v40 = CfgFind.FindTrainCfgById(p35);

    if v40 then
        v40 = v40.Color;
    end;

    local v41 = _parseTrainColor(v40);

    if v41 then
        _applyVfxColor(v39, v41);
    end;

    return v39;
end;

local function _stopTriggerFx(p42) -- Line: 205
    -- upvalues: FXUtil (copy)
    if not p42 then
        return nil;
    end;

    FXUtil.Stop_All_Emit(p42);
    FXUtil.Stop_All_Particles(p42);
    FXUtil.SetEmittersTrailsBeamsEnabled(p42, false);

    return nil;
end;

local function _emitCrystalBurstFx(p43, p44) -- Line: 222
    -- upvalues: _ensureCrystalFxMounted (copy), FXUtil (copy), SoundModule (copy)
    local v45 = _ensureCrystalFxMounted(p43, "水晶爆发特效", p44);

    if not v45 then
        return nil;
    end;

    FXUtil.Emit_Particles_GetDescendants(v45, true);
    local v46 = p43.PrimaryPart or p43:FindFirstChildWhichIsA("BasePart");

    if v46 then
        SoundModule:PlaySoundLocal({
            SoundName = "水晶爆发",
            Is2D = false,
            PlayPosition = v46.Position
        });
    end;

    return nil;
end;

local function _initCrystalVfxOnCrystal(p47, p48) -- Line: 246
    -- upvalues: _ensureCrystalFxMounted (copy), FXUtil (copy)
    local v49 = _ensureCrystalFxMounted(p47, "水晶触发特效", p48);

    if v49 and v49 then
        FXUtil.Stop_All_Emit(v49);
        FXUtil.Stop_All_Particles(v49);
        FXUtil.SetEmittersTrailsBeamsEnabled(v49, false);
    end;

    local v50 = _ensureCrystalFxMounted(p47, "水晶爆发特效", p48);

    if v50 and v50 then
        FXUtil.Stop_All_Emit(v50);
        FXUtil.Stop_All_Particles(v50);
        FXUtil.SetEmittersTrailsBeamsEnabled(v50, false);
    end;

    return nil;
end;

local function _getCrystalFloatParams() -- Line: 268
    -- upvalues: GetData (copy)
    local v51 = GetData.Train.GetTrainValue("水晶浮动幅度");
    local v52 = GetData.Train.GetTrainValue("水晶浮动周期");
    local v53 = (type(v51) ~= "number" or v51 < 0) and 0.35 or v51;

    if type(v52) == "number" and v52 > 0.1 then
        return v53, v52;
    end;

    return v53, 2;
end;

local function _getCrystalCapFloorRad() -- Line: 282
    -- upvalues: GetData (copy), LocalPlayer (copy)
    local v54 = GetData.GetTotalMagicValue(LocalPlayer);
    local v55 = GetData.Train.GetCrystalRotateTierCapDeg(v54);
    local v56 = GetData.Train.GetCrystalRotateFloorDeg(v54);

    return v55 * 0.017453292519943295, v56 * 0.017453292519943295;
end;

local function _getDecayBasePerSec() -- Line: 294
    -- upvalues: GetData (copy)
    local v57 = 1 / GetData.Train.GetCrystalRotateHalfLifeSec();

    return math.pow(0.5, v57);
end;

local function _restoreCrystalBasePose(p58) -- Line: 305
    -- upvalues: u9 (ref), u10 (ref), u7 (ref)
    if not (u9 and u10) then
        return nil;
    end;

    p58:PivotTo(CFrame.new(u9) * (u10 * CFrame.Angles(0, -u7, 0)));

    return nil;
end;

local function _stopCrystalRotateLoop() -- Line: 318
    -- upvalues: u11 (ref), u12 (ref), u9 (ref), u10 (ref), u7 (ref), u6 (ref), u8 (ref), u13 (ref), u14 (ref)
    if u11 then
        u11:Disconnect();
        u11 = nil;
    end;

    if u12 and u12.Parent then
        local v59 = u12;

        if u9 and u10 then
            v59:PivotTo(CFrame.new(u9) * (u10 * CFrame.Angles(0, -u7, 0)));
        end;
    end;

    u12 = nil;
    u6 = 0;
    u7 = 0;
    u8 = 0;
    u9 = nil;
    u10 = nil;
    u13 = 0;
    u14 = false;

    return nil;
end;

local function _applyHitImpulse(p60) -- Line: 343
    -- upvalues: u18 (ref), _resolveCrystalFromTrainPart (copy), u3 (ref), GetData (copy), LocalPlayer (copy), u6 (ref), u13 (ref), LocalMagicMissilePresentation (copy), u15 (ref), u4 (ref), _emitCrystalBurstFx (copy)
    if not u18 then
        return nil;
    end;

    local v61 = _resolveCrystalFromTrainPart(u3);

    if not v61 then
        return nil;
    end;

    local v62 = GetData.GetTotalMagicValue(LocalPlayer);
    local v63 = GetData.Train.GetCrystalHitImpulseDeg(v62) * 0.017453292519943295;
    local v64 = GetData.Train.GetCrystalRotateTierCapDeg(v62) * 0.017453292519943295;
    u6 = u6 + v63;
    u13 = os.clock() + GetData.Train.GetCrystalSoftCapSec();

    if p60 == LocalMagicMissilePresentation.GetStageCount() and (not u15 and (v64 < u6 and u4 > 0)) then
        u15 = true;
        _emitCrystalBurstFx(v61, u4);
    end;

    return nil;
end;

local function _ensureCrystalRotateLoop(u65) -- Line: 375
    -- upvalues: u11 (ref), u12 (ref), u9 (ref), u10 (ref), u7 (ref), u6 (ref), u8 (ref), u13 (ref), u14 (ref), _getCrystalCapFloorRad (copy), GetData (copy), RunService (copy), LocalPlayer (copy)
    if u11 and u12 == u65 then
        return nil;
    end;

    if u11 then
        u11:Disconnect();
        u11 = nil;
    end;

    if u12 and u12.Parent then
        local v66 = u12;

        if u9 and u10 then
            v66:PivotTo(CFrame.new(u9) * (u10 * CFrame.Angles(0, -u7, 0)));
        end;
    end;

    u12 = nil;
    u6 = 0;
    u7 = 0;
    u8 = 0;
    u9 = nil;
    u10 = nil;
    u13 = 0;
    u14 = false;
    u12 = u65;
    u14 = false;

    if not (u65.PrimaryPart or u65:FindFirstChildWhichIsA("BasePart")) then
        return nil;
    end;

    local v67 = u65:GetPivot();
    u9 = v67.Position;
    u10 = v67.Rotation;
    u7 = 0;
    u8 = 0;
    u6 = select(2, _getCrystalCapFloorRad());
    local v68 = GetData.Train.GetTrainValue("水晶浮动幅度");
    local v69 = GetData.Train.GetTrainValue("水晶浮动周期");
    local u70 = (type(v68) ~= "number" or v68 < 0) and 0.35 or v68;
    local u71 = (type(v69) ~= "number" or v69 <= 0.1) and 2 or v69;
    u11 = RunService.Heartbeat:Connect(function(p72) -- Line: 397
        -- upvalues: u65 (copy), u11 (ref), u12 (ref), u9 (ref), u10 (ref), u7 (ref), u6 (ref), u8 (ref), u13 (ref), u14 (ref), GetData (ref), LocalPlayer (ref), u71 (copy), u70 (copy)
        if not u65.Parent then
            if u11 then
                u11:Disconnect();
                u11 = nil;
            end;

            if u12 and u12.Parent then
                local v73 = u12;

                if u9 and u10 then
                    v73:PivotTo(CFrame.new(u9) * (u10 * CFrame.Angles(0, -u7, 0)));
                end;
            end;

            u12 = nil;
            u6 = 0;
            u7 = 0;
            u8 = 0;
            u9 = nil;
            u10 = nil;
            u13 = 0;
            u14 = false;

            return;
        end;

        if not (u9 and u10) then
            if u11 then
                u11:Disconnect();
                u11 = nil;
            end;

            if u12 and u12.Parent then
                local v74 = u12;

                if u9 and u10 then
                    v74:PivotTo(CFrame.new(u9) * (u10 * CFrame.Angles(0, -u7, 0)));
                end;
            end;

            u12 = nil;
            u6 = 0;
            u7 = 0;
            u8 = 0;
            u9 = nil;
            u10 = nil;
            u13 = 0;
            u14 = false;

            return;
        end;

        local v75 = GetData.GetTotalMagicValue(LocalPlayer);
        local v76 = GetData.Train.GetCrystalRotateTierCapDeg(v75);
        local v77 = GetData.Train.GetCrystalRotateFloorDeg(v75);
        local v78 = v76 * 0.017453292519943295;
        local v79 = u14 and 0 or v77 * 0.017453292519943295;
        local v80 = 1 / GetData.Train.GetCrystalRotateHalfLifeSec();
        local v81 = math.pow(0.5, v80);
        local v82 = u6 - v79;

        if v82 > 0 then
            u6 = v79 + v82 * v81 ^ p72;
        elseif u14 then
            u6 = math.max(0, u6 * v81 ^ p72);
        else
            u6 = math.max(v79, u6);
        end;

        if u13 <= os.clock() and not u14 then
            u6 = math.min(u6, v78);
        end;

        if not u14 or u6 > 0.02 then
            u7 = u7 + u6 * p72;
            u8 = u8 + p72;
            local v83 = math.sin(u8 * 6.283185307179586 / u71) * u70;
            local v84 = u9 + Vector3.new(0, v83, 0);
            u65:PivotTo(CFrame.new(v84) * (u10 * CFrame.Angles(0, -u7, 0)));

            return;
        end;

        if u11 then
            u11:Disconnect();
            u11 = nil;
        end;

        if u12 and u12.Parent then
            local v85 = u12;

            if u9 and u10 then
                v85:PivotTo(CFrame.new(u9) * (u10 * CFrame.Angles(0, -u7, 0)));
            end;
        end;

        u12 = nil;
        u6 = 0;
        u7 = 0;
        u8 = 0;
        u9 = nil;
        u10 = nil;
        u13 = 0;
        u14 = false;
    end);

    return nil;
end;

local function _beginCrystalCoastToZero() -- Line: 446
    -- upvalues: u11 (ref), u14 (ref), u13 (ref)
    if not u11 then
        return nil;
    end;

    u14 = true;
    u13 = 0;

    return nil;
end;

local function _setHumanoidAutoRotate(p86) -- Line: 465
    -- upvalues: LocalPlayer (copy)
    if LocalPlayer:GetAttribute("IsShiftLocked") then
        return nil;
    end;

    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid");
    end;

    if Character then
        Character.AutoRotate = p86;
    end;

    return nil;
end;

local function _tickFaceCrystal() -- Line: 482
    -- upvalues: LocalPlayer (copy), _resolveCrystalFromTrainPart (copy), u3 (ref)
    if LocalPlayer:GetAttribute("IsShiftLocked") then
        return nil;
    end;

    local Character = LocalPlayer.Character;

    if not Character then
        return nil;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return nil;
    end;

    local v87 = _resolveCrystalFromTrainPart(u3);

    if not v87 then
        return nil;
    end;

    local Position = v87:GetPivot().Position;
    local Position2 = HumanoidRootPart.Position;
    local v88 = Vector3.new(Position.X, Position2.Y, Position.Z);

    if (Position2 - v88).Magnitude <= 0.1 then
        return nil;
    end;

    local v89 = CFrame.lookAt(Position2, v88);
    local v90 = HumanoidRootPart.CFrame:Lerp(v89, 0.25);
    HumanoidRootPart.CFrame = CFrame.new(Position2) * v90.Rotation;

    return nil;
end;

local function _stopFaceCrystalLoop() -- Line: 515
    -- upvalues: u16 (ref), u17 (ref), LocalPlayer (copy)
    if u16 then
        u16:Disconnect();
        u16 = nil;
    end;

    if u17 == nil then
        if not LocalPlayer:GetAttribute("IsShiftLocked") then
            local Character = LocalPlayer.Character;

            if Character then
                Character = Character:FindFirstChildOfClass("Humanoid");
            end;

            if Character then
                Character.AutoRotate = true;
            end;
        end;
    else
        local v91 = u17;

        if not LocalPlayer:GetAttribute("IsShiftLocked") then
            local Character = LocalPlayer.Character;

            if Character then
                Character = Character:FindFirstChildOfClass("Humanoid");
            end;

            if Character then
                Character.AutoRotate = v91;
            end;
        end;

        u17 = nil;
    end;

    return nil;
end;

local function _startFaceCrystalLoop() -- Line: 534
    -- upvalues: u16 (ref), u17 (ref), LocalPlayer (copy), GetData (copy), RunService (copy), u18 (ref), _tickFaceCrystal (copy)
    if u16 then
        u16:Disconnect();
        u16 = nil;
    end;

    if u17 == nil then
        if not LocalPlayer:GetAttribute("IsShiftLocked") then
            local Character = LocalPlayer.Character;

            if Character then
                Character = Character:FindFirstChildOfClass("Humanoid");
            end;

            if Character then
                Character.AutoRotate = true;
            end;
        end;
    else
        local v92 = u17;

        if not LocalPlayer:GetAttribute("IsShiftLocked") then
            local Character = LocalPlayer.Character;

            if Character then
                Character = Character:FindFirstChildOfClass("Humanoid");
            end;

            if Character then
                Character.AutoRotate = v92;
            end;
        end;

        u17 = nil;
    end;

    if GetData.GetIsFly(LocalPlayer) then
        return nil;
    end;

    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid");
    end;

    if Character then
        u17 = Character.AutoRotate;
    end;

    if not LocalPlayer:GetAttribute("IsShiftLocked") then
        local Character2 = LocalPlayer.Character;

        if Character2 then
            Character2 = Character2:FindFirstChildOfClass("Humanoid");
        end;

        if Character2 then
            Character2.AutoRotate = false;
        end;
    end;

    u16 = RunService.Heartbeat:Connect(function() -- Line: 546
        -- upvalues: u18 (ref), u16 (ref), u17 (ref), LocalPlayer (ref), GetData (ref), _tickFaceCrystal (ref)
        if not u18 then
            if u16 then
                u16:Disconnect();
                u16 = nil;
            end;

            if u17 ~= nil then
                local v93 = u17;

                if not LocalPlayer:GetAttribute("IsShiftLocked") then
                    local Character2 = LocalPlayer.Character;

                    if Character2 then
                        Character2 = Character2:FindFirstChildOfClass("Humanoid");
                    end;

                    if Character2 then
                        Character2.AutoRotate = v93;
                    end;
                end;

                u17 = nil;

                return;
            end;

            if LocalPlayer:GetAttribute("IsShiftLocked") then
                return;
            end;

            local Character2 = LocalPlayer.Character;

            if Character2 then
                Character2 = Character2:FindFirstChildOfClass("Humanoid");
            end;

            if Character2 then
                Character2.AutoRotate = true;
            end;

            return;
        end;

        if not GetData.GetIsFly(LocalPlayer) then
            _tickFaceCrystal();

            return;
        end;

        if u16 then
            u16:Disconnect();
            u16 = nil;
        end;

        if u17 ~= nil then
            local v94 = u17;

            if not LocalPlayer:GetAttribute("IsShiftLocked") then
                local Character2 = LocalPlayer.Character;

                if Character2 then
                    Character2 = Character2:FindFirstChildOfClass("Humanoid");
                end;

                if Character2 then
                    Character2.AutoRotate = v94;
                end;
            end;

            u17 = nil;

            return;
        end;

        if LocalPlayer:GetAttribute("IsShiftLocked") then
            return;
        end;

        local Character2 = LocalPlayer.Character;

        if Character2 then
            Character2 = Character2:FindFirstChildOfClass("Humanoid");
        end;

        if Character2 then
            Character2.AutoRotate = true;
        end;
    end);

    return nil;
end;

local function _nextStageIndex() -- Line: 571
    -- upvalues: u2 (ref), u15 (ref), LocalMagicMissilePresentation (copy)
    local v95 = u2;

    if v95 == 1 then
        u15 = false;
    end;

    u2 = u2 + 1;

    if u2 > LocalMagicMissilePresentation.GetStageCount() then
        u2 = 1;
    end;

    return v95;
end;

local function _resolveAutoGoalCF() -- Line: 588
    -- upvalues: _resolveCrystalFromTrainPart (copy), u3 (ref), GetData (copy)
    local v96 = _resolveCrystalFromTrainPart(u3);

    if not v96 then
        return nil;
    end;

    local v97 = v96.PrimaryPart or v96:FindFirstChildWhichIsA("BasePart");

    if not v97 then
        return nil;
    end;

    local v98 = GetData.Train.GetCrystalAimOffsetStud();
    local v99;

    if v98 > 0 then
        local v100 = math.random() * 2 - 1;
        local v101 = math.random() * 2 - 1;
        local v102 = math.random() * 2 - 1;
        local v103 = Vector3.new(v100, v101, v102);
        v99 = (v103.Magnitude < 0.0001 and Vector3.new(1, 0, 0) or v103).Unit * (math.random() * v98);
    else
        v99 = Vector3.new(0, 0, 0);
    end;

    return CFrame.new(v97.Position + v99);
end;

local function _resolveManualAimGoalCF() -- Line: 614
    -- upvalues: GetSkillData (copy)
    local _, v104 = GetSkillData.getLocalPlayerSkillInputData();

    if typeof(v104) == "CFrame" then
        return v104;
    end;

    return nil;
end;

local function _waitAutoPresent(p105, p106) -- Line: 629
    -- upvalues: u18 (ref), u19 (ref)
    local v107 = os.clock() + math.max(0, p106);

    while os.clock() < v107 do
        if not u18 or u19 ~= p105 then
            return false;
        end;

        local v108 = v107 - os.clock();
        task.wait(v108 > 0.08 and 0.08 or v108);
    end;

    return u18 and u19 == p105;
end;

local function _playOneStrike(p109, u110) -- Line: 649
    -- upvalues: LocalPlayer (copy), u2 (ref), u15 (ref), LocalMagicMissilePresentation (copy), GetSkillData (copy), _resolveAutoGoalCF (copy), _applyHitImpulse (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return 0.35;
    end;

    local u111 = u2;

    if u111 == 1 then
        u15 = false;
    end;

    u2 = u2 + 1;

    if u2 > LocalMagicMissilePresentation.GetStageCount() then
        u2 = 1;
    end;

    local v112 = LocalMagicMissilePresentation.GetNearEndWaitSec(u111);
    local v113;

    if p109 then
        local v114;
        v114, v113 = GetSkillData.getLocalPlayerSkillInputData();

        if typeof(v113) ~= "CFrame" then
            v113 = nil;
        end;
    else
        v113 = _resolveAutoGoalCF();
    end;

    if not v113 then
        return v112;
    end;

    local v116 = LocalMagicMissilePresentation.PlayStrike({
        playExplosion = true,
        stageIndex = u111,
        character = Character,
        goalCF = v113,

        onLanded = function(p115) -- Line: 666, Name: onLanded
            -- upvalues: u110 (copy), _applyHitImpulse (ref), u111 (copy)
            if u110 then
                _applyHitImpulse(u111);
            end;
        end
    });

    if v116 then
        v112 = v116.nearEndWaitSec;
    end;

    return v112;
end;

local function _runAutoStrikeLoop(p117) -- Line: 684
    -- upvalues: u18 (ref), u19 (ref), LocalPlayer (copy), _waitAutoPresent (copy), _resolveCrystalFromTrainPart (copy), u3 (ref), _ensureCrystalRotateLoop (copy), _playOneStrike (copy)
    while u18 and u19 == p117 do
        if LocalPlayer.Character then
            local v118 = _resolveCrystalFromTrainPart(u3);

            if v118 then
                _ensureCrystalRotateLoop(v118);
            end;

            if not _waitAutoPresent(p117, (_playOneStrike(false, true))) then
                return nil;
            end;
        elseif not _waitAutoPresent(p117, 0.2) then
            return nil;
        end;
    end;

    return nil;
end;

local function _scheduleManualBusyClear(u119) -- Line: 710
    -- upvalues: u20 (ref), u21 (ref), u18 (ref), _playOneStrike (copy), _scheduleManualBusyClear (copy)
    u20 = os.clock() + u119;
    task.spawn(function() -- Line: 713
        -- upvalues: u119 (copy), u20 (ref), u21 (ref), u18 (ref), _playOneStrike (ref), _scheduleManualBusyClear (ref)
        task.wait(u119);

        if os.clock() + 0.001 < u20 then
            return;
        end;

        u20 = 0;

        if u21 and not u18 then
            u21 = false;
            _scheduleManualBusyClear((_playOneStrike(true, false)));
        end;
    end);

    return nil;
end;

function u1.SetActiveTrainPart(p120) -- Line: 738
    -- upvalues: u3 (ref), u4 (ref), u11 (ref), u14 (ref), u13 (ref)
    u3 = p120;

    if not p120 then
        u4 = 0;

        if u11 then
            u14 = true;
            u13 = 0;
        end;
    end;

    return nil;
end;

function u1.InitCrystalTriggerFx() -- Line: 752
    -- upvalues: CollectionService (copy), GetData (copy), _resolveCrystalFromTrainPart (copy), _ensureCrystalFxMounted (copy), FXUtil (copy), u22 (ref)
    for _, v in CollectionService:GetTagged("Train") do
        local v121 = GetData.Train.GetTrainIdFromInstance(v);

        if v121 then
            local v122 = _resolveCrystalFromTrainPart((GetData.Train.ResolveZonePart(v)));

            if v122 then
                local v123 = _ensureCrystalFxMounted(v122, "水晶触发特效", v121);

                if v123 and v123 then
                    FXUtil.Stop_All_Emit(v123);
                    FXUtil.Stop_All_Particles(v123);
                    FXUtil.SetEmittersTrailsBeamsEnabled(v123, false);
                end;

                local v124 = _ensureCrystalFxMounted(v122, "水晶爆发特效", v121);

                if v124 then
                    if v124 then
                        FXUtil.Stop_All_Emit(v124);
                        FXUtil.Stop_All_Particles(v124);
                        FXUtil.SetEmittersTrailsBeamsEnabled(v124, false);
                    end;
                end;
            end;
        end;
    end;

    if u22 then
        u22:Disconnect();
    end;

    u22 = CollectionService:GetInstanceAddedSignal("Train"):Connect(function(u125) -- Line: 766
        -- upvalues: GetData (ref), _resolveCrystalFromTrainPart (ref), _ensureCrystalFxMounted (ref), FXUtil (ref)
        task.defer(function() -- Line: 767
            -- upvalues: GetData (ref), u125 (copy), _resolveCrystalFromTrainPart (ref), _ensureCrystalFxMounted (ref), FXUtil (ref)
            local v126 = GetData.Train.GetTrainIdFromInstance(u125);

            if not v126 then
                return;
            end;

            local v127 = _resolveCrystalFromTrainPart((GetData.Train.ResolveZonePart(u125)));

            if v127 then
                local v128 = _ensureCrystalFxMounted(v127, "水晶触发特效", v126);

                if v128 and v128 then
                    FXUtil.Stop_All_Emit(v128);
                    FXUtil.Stop_All_Particles(v128);
                    FXUtil.SetEmittersTrailsBeamsEnabled(v128, false);
                end;

                local v129 = _ensureCrystalFxMounted(v127, "水晶爆发特效", v126);

                if v129 then
                    if not v129 then
                        return;
                    end;

                    FXUtil.Stop_All_Emit(v129);
                    FXUtil.Stop_All_Particles(v129);
                    FXUtil.SetEmittersTrailsBeamsEnabled(v129, false);
                end;
            end;
        end);
    end);

    return nil;
end;

function u1.StartCrystalTriggerFx(p130) -- Line: 788
    -- upvalues: u1 (copy), u4 (ref), _resolveCrystalFromTrainPart (copy), u3 (ref), _ensureCrystalFxMounted (copy), FXUtil (copy), u5 (ref)
    u1.StopCrystalTriggerFx();
    local v131 = tonumber(p130) or 0;
    local v132 = math.floor(v131);

    if v132 <= 0 then
        return nil;
    end;

    u4 = v132;
    local v133 = _resolveCrystalFromTrainPart(u3);

    if not v133 then
        return nil;
    end;

    local v134 = _ensureCrystalFxMounted(v133, "水晶触发特效", v132);

    if not v134 then
        return nil;
    end;

    if v134 then
        FXUtil.Stop_All_Emit(v134);
        FXUtil.Stop_All_Particles(v134);
        FXUtil.SetEmittersTrailsBeamsEnabled(v134, false);
    end;

    FXUtil.EmitOnceThenEnableContinuous(v134);
    u5 = v134;

    return nil;
end;

function u1.StopCrystalTriggerFx() -- Line: 814
    -- upvalues: u5 (ref), FXUtil (copy), u4 (ref), u11 (ref), u14 (ref), u13 (ref)
    if u5 then
        local v135 = u5;

        if v135 then
            FXUtil.Stop_All_Emit(v135);
            FXUtil.Stop_All_Particles(v135);
            FXUtil.SetEmittersTrailsBeamsEnabled(v135, false);
        end;

        u5 = nil;
    end;

    u4 = 0;

    if u11 then
        u14 = true;
        u13 = 0;
    end;

    return nil;
end;

function u1.StartAutoTrainPresentation(p136) -- Line: 830
    -- upvalues: u1 (copy), u19 (ref), u18 (ref), u21 (ref), u20 (ref), u2 (ref), u15 (ref), _resolveCrystalFromTrainPart (copy), u3 (ref), _ensureCrystalRotateLoop (copy), _startFaceCrystalLoop (copy), _runAutoStrikeLoop (copy)
    u1.StopAutoTrainPresentation();
    local v137 = tonumber(p136) or 0;
    local v138 = math.floor(v137);

    if v138 <= 0 then
        return nil;
    end;

    u19 = u19 + 1;
    local u139 = u19;
    u18 = true;
    u21 = false;
    u20 = 0;
    u2 = 1;
    u15 = false;
    u1.StartCrystalTriggerFx(v138);
    local v140 = _resolveCrystalFromTrainPart(u3);

    if v140 then
        _ensureCrystalRotateLoop(v140);
    end;

    _startFaceCrystalLoop();
    task.spawn(function() -- Line: 853
        -- upvalues: _runAutoStrikeLoop (ref), u139 (copy)
        _runAutoStrikeLoop(u139);
    end);

    return nil;
end;

function u1.StopAutoTrainPresentation() -- Line: 864
    -- upvalues: u18 (ref), u19 (ref), u16 (ref), u17 (ref), LocalPlayer (copy), u1 (copy)
    u18 = false;
    u19 = u19 + 1;

    if u16 then
        u16:Disconnect();
        u16 = nil;
    end;

    if u17 == nil then
        if not LocalPlayer:GetAttribute("IsShiftLocked") then
            local Character = LocalPlayer.Character;

            if Character then
                Character = Character:FindFirstChildOfClass("Humanoid");
            end;

            if Character then
                Character.AutoRotate = true;
            end;
        end;
    else
        local v141 = u17;

        if not LocalPlayer:GetAttribute("IsShiftLocked") then
            local Character = LocalPlayer.Character;

            if Character then
                Character = Character:FindFirstChildOfClass("Humanoid");
            end;

            if Character then
                Character.AutoRotate = v141;
            end;
        end;

        u17 = nil;
    end;

    u1.StopCrystalTriggerFx();

    return nil;
end;

function u1.TryPlayManualSelfStrike() -- Line: 877
    -- upvalues: u18 (ref), LocalPlayer (copy), u20 (ref), GetData (copy), u21 (ref), _playOneStrike (copy), _scheduleManualBusyClear (copy)
    if u18 then
        return false;
    end;

    if not LocalPlayer.Character then
        return false;
    end;

    local v142 = os.clock();

    if v142 < u20 then
        if u20 - v142 > GetData.Train.GetManualChainBufferSec() then
            return false;
        end;

        u21 = true;

        return true;
    end;

    u21 = false;
    local u143 = _playOneStrike(true, false);
    u20 = os.clock() + u143;
    task.spawn(function() -- Line: 713
        -- upvalues: u143 (copy), u20 (ref), u21 (ref), u18 (ref), _playOneStrike (ref), _scheduleManualBusyClear (ref)
        task.wait(u143);

        if os.clock() + 0.001 < u20 then
            return;
        end;

        u20 = 0;

        if u21 and not u18 then
            u21 = false;
            _scheduleManualBusyClear((_playOneStrike(true, false)));
        end;
    end);

    return true;
end;

function u1.IsAutoPresentActive() -- Line: 908
    -- upvalues: u18 (ref)
    return u18;
end;

return u1;