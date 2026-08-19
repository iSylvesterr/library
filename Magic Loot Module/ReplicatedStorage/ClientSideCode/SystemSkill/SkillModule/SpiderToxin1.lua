-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local HitResolver = require(script.Parent.Parent.BaseSkill.HitResolver);
local SkillDamageRateFromCfg = require(script.Parent.Parent.BaseSkill.SkillDamageRateFromCfg);
local PlayerAimSync = require(script.Parent.Parent.BaseSkill.PlayerAimSync);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local ProjectileImpact = require(script.Parent._Templates.Projectile.ProjectileImpact);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local MathMgr = UtilsSystem.MathMgr;
local RunService = UtilsSystem.RunService;
local SoundModule = UtilsSystem.SoundModule;
local u1 = {
    flightSec = 1.5,
    trackDurationSec = 2,
    easingStyle = Enum.EasingStyle.Quad,
    easingDirection = Enum.EasingDirection.In
};
local u2 = {
    clientMotion = "蜘蛛毒素客户端弹道",
    serverMotion = "蜘蛛毒素服务端弹道"
};
local v3 = SkillDamageRateFromCfg.get(10300038, 1);
local u4 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2.7,
    skillElementType = ElementTp.Poison,
    skillDistanceLimit = 64
};

local function _resolveLiveStrikePos(p5, p6) -- Line: 113
    -- upvalues: SkillCommon (copy)
    if p5 then
        p5 = SkillCommon.resolveTrackTargetHrp(p5);
    end;

    if p5 and p5.Parent then
        return p5.Position;
    end;

    return p6;
end;

local function _resolveHeadSpawnCF(p7, p8) -- Line: 128
    local v9 = p7:FindFirstChild("头");

    if v9 and v9:IsA("BasePart") then
        local CFrame2 = v9.CFrame;
        local LookVector = CFrame2.LookVector;
        local v10 = CFrame2.Position + LookVector * 3 * p8;

        return CFrame.lookAt(v10, v10 + LookVector, Vector3.new(0, 1, 0));
    end;

    local HumanoidRootPart = p7:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return nil;
    end;

    local CFrame2 = HumanoidRootPart.CFrame;
    local LookVector = CFrame2.LookVector;
    local v11 = CFrame2.Position + LookVector * 3 * p8;

    return CFrame.lookAt(v11, v11 + LookVector, Vector3.new(0, 1, 0));
end;

local function _disconnectMotionKeys(p12) -- Line: 151
    -- upvalues: SkillCommon (copy)
    SkillCommon.disconnectRunEventKeys(p12, { "蜘蛛毒素客户端弹道", "蜘蛛毒素服务端弹道" });
end;

local function _sameRun(p13, p14) -- Line: 158
    return p13.runGeneration == p14;
end;

local function _hasActiveClientProjectiles(p15) -- Line: 162
    local v16 = p15.SpiderToxinClient and p15.SpiderToxinClient.projectiles;

    if not v16 then
        return false;
    end;

    for _, v in v16 do
        if v and not v.impacted then
            return true;
        end;
    end;

    return false;
end;

local function _hasActiveServerProjectiles(p17) -- Line: 175
    local v18 = p17.SpiderToxinServer and p17.SpiderToxinServer.projectiles;

    if not v18 then
        return false;
    end;

    for _, v in v18 do
        if v and not v.impacted then
            return true;
        end;
    end;

    return false;
end;

local function _shouldKeepClientProjectileMotion(p19, p20, p21) -- Line: 188
    if p19.runGeneration ~= p20 then
        return false;
    end;

    if p19:isRunningFlow() then
        return true;
    end;

    local v22 = p21.SpiderToxinClient and p21.SpiderToxinClient.projectiles;

    if not v22 then
        return false;
    end;

    for _, v in v22 do
        if v and not v.impacted then
            return true;
        end;
    end;

    return false;
end;

local function _shouldKeepServerProjectileMotion(p23, p24, p25) -- Line: 198
    if p23.runGeneration ~= p24 then
        return false;
    end;

    if p23:isRunningFlow() then
        return true;
    end;

    local v26 = p25.SpiderToxinServer and p25.SpiderToxinServer.projectiles;

    if not v26 then
        return false;
    end;

    for _, v in v26 do
        if v and not v.impacted then
            return true;
        end;
    end;

    return false;
end;

local function _strikePosAfterRefresh(p27) -- Line: 208
    -- upvalues: SkillCommon (copy)
    SkillCommon.refreshSkillAimSnapshot(p27);
    local skillInputData = p27.skillInputData;

    if skillInputData then
        return SkillCommon.resolveStrikeWorldPos(skillInputData);
    end;

    return p27:getTargetCF().Position;
end;

local function _resolveLiveEndForProjectile(p28, p29) -- Line: 217
    -- upvalues: SkillCommon (copy)
    if p29.frozenEnd then
        return p29.frozenEnd;
    end;

    local v30;

    if p28 then
        v30 = p29.snapEnd0;

        if p28 then
            p28 = SkillCommon.resolveTrackTargetHrp(p28);
        end;

        if p28 and p28.Parent then
            v30 = p28.Position;
        end;
    else
        v30 = p29.snapEnd0;
    end;

    if (p29.trackDurationSec or 2) < p29.moveT then
        p29.frozenEnd = v30;
    end;

    return v30;
end;

local function _evaluateCubicBezier(p31, p32, p33, p34, p35) -- Line: 236
    local v36 = math.clamp(p35, 0, 1);
    local v37 = 1 - v36;

    return v37 * v37 * v37 * p31 + v37 * 3 * v37 * v36 * p32 + v37 * 3 * v36 * v36 * p33 + v36 * v36 * v36 * p34;
end;

local function _cubicBezierTangent(p38, p39, p40, p41, p42) -- Line: 242
    local v43 = math.clamp(p42 - 0.002, 0, 1);
    local v44 = math.clamp(p42 + 0.002, 0, 1);

    if v44 - v43 < 1e-6 then
        local v45 = p41 - p38;

        return v45.Magnitude <= 0.0001 and Vector3.new(0, 0, -1) or v45.Unit;
    end;

    local v46 = math.clamp(v44, 0, 1);
    local v47 = 1 - v46;
    local v48 = math.clamp(v43, 0, 1);
    local v49 = 1 - v48;
    local v50 = v47 * v47 * v47 * p38 + v47 * 3 * v47 * v46 * p39 + v47 * 3 * v46 * v46 * p40 + v46 * v46 * v46 * p41 - (v49 * v49 * v49 * p38 + v49 * 3 * v49 * v48 * p39 + v49 * 3 * v48 * v48 * p40 + v48 * v48 * v48 * p41);

    return v50.Magnitude <= 0.0001 and Vector3.new(0, 0, -1) or v50.Unit;
end;

local function _flatDirToTarget(p51, p52) -- Line: 253
    local v53 = Vector3.new(p52.X - p51.X, 0, p52.Z - p51.Z);

    return v53.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v53.Unit;
end;

local function _resolveInitialTangent(p54, p55) -- Line: 261
    local v56 = p55 - p54;

    if v56.Magnitude > 0.0001 then
        return v56.Unit;
    end;

    local v57 = Vector3.new(p55.X - p54.X, 0, p55.Z - p54.Z);

    return v57.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v57.Unit;
end;

local function _ensureBezierState(p58, p59) -- Line: 269
    if p58.bezierP0 then
        return;
    end;

    local bubbleStart = p58.bubbleStart;
    local v60 = p59 - bubbleStart;
    local initialTangent = p58.initialTangent;

    if not initialTangent or initialTangent.Magnitude < 0.0001 then
        initialTangent = v60.Magnitude <= 0.0001 and Vector3.new(0, 0, -1) or v60.Unit;
    end;

    local v61 = math.max(v60.Magnitude * 0.6666666666666666, 0.001);
    p58.bezierP0 = bubbleStart;
    p58.bezierP1 = bubbleStart + initialTangent * v61;
    p58.bezierArmLen = v61;
end;

local function _sampleProjectileMotion(p62, p63, p64) -- Line: 295
    -- upvalues: TweenService (copy), _cubicBezierTangent (copy)
    if not p62.bezierP0 then
        local bubbleStart = p62.bubbleStart;
        local v65 = p64 - bubbleStart;
        local initialTangent = p62.initialTangent;

        if not initialTangent or initialTangent.Magnitude < 0.0001 then
            initialTangent = v65.Magnitude <= 0.0001 and Vector3.new(0, 0, -1) or v65.Unit;
        end;

        local v66 = math.max(v65.Magnitude * 0.6666666666666666, 0.001);
        p62.bezierP0 = bubbleStart;
        p62.bezierP1 = bubbleStart + initialTangent * v66;
        p62.bezierArmLen = v66;
    end;

    local bezierP0 = p62.bezierP0;
    local bezierP1 = p62.bezierP1;
    local v67 = p64 - bezierP0;
    local v68;

    if v67.Magnitude > 0.0001 then
        v68 = v67.Unit;
    else
        v68 = (bezierP1 - bezierP0).Unit;
    end;

    local v69 = p64 - (v68.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v68) * p62.bezierArmLen;
    local v70 = TweenService:GetValue(p63, p62.easingStyle, p62.easingDirection);
    local v71 = math.clamp(v70, 0, 1);
    local v72 = 1 - v71;

    return v72 * v72 * v72 * bezierP0 + v72 * 3 * v72 * v71 * bezierP1 + v72 * 3 * v71 * v71 * v69 + v71 * v71 * v71 * p64, _cubicBezierTangent(bezierP0, bezierP1, v69, p64, v70);
end;

local function _buildBubbleTrajectory(p73, p74, p75) -- Line: 315
    -- upvalues: u1 (copy)
    local v76 = u1;

    return {
        flightSec = v76.flightSec,
        trackDurationSec = v76.trackDurationSec,
        easingStyle = v76.easingStyle,
        easingDirection = v76.easingDirection
    };
end;

local function _ensureClientProjectileList(p77) -- Line: 325
    p77.SpiderToxinClient = p77.SpiderToxinClient or {};
    p77.SpiderToxinClient.projectiles = p77.SpiderToxinClient.projectiles or {};

    return p77.SpiderToxinClient.projectiles;
end;

local function _ensureServerProjectileList(p78) -- Line: 331
    p78.SpiderToxinServer = p78.SpiderToxinServer or {};
    p78.SpiderToxinServer.projectiles = p78.SpiderToxinServer.projectiles or {};

    return p78.SpiderToxinServer.projectiles;
end;

local function _enableBubbleVfx(p79) -- Line: 337
    -- upvalues: FXUtil (copy)
    FXUtil.Emit_Particles_GetDescendants(p79, false);
    FXUtil.SetEnableNameVfx(p79, true);
    FXUtil.SetEmittersTrailsBeamsEnabled(p79, true);
end;

local function _playConfiguredSound3D(p80, p81) -- Line: 343
    -- upvalues: SkillCommon (copy)
    if p80 and p80 ~= "" then
        SkillCommon.playSoundLocal3D(p80, p81);
    end;
end;

local function _makeBubbleFlightSoundTag(p82, p83) -- Line: 349
    -- upvalues: SkillCommon (copy)
    local v84 = SkillCommon.resolveSkillCastSoundTag(p82);

    if v84 then
        return v84 .. "_bubbleFly_" .. p83;
    end;

    return nil;
end;

local function _playBubbleFlightSound(p85, u86, p87, u88, u89) -- Line: 357
    -- upvalues: SkillCommon (copy), SoundModule (copy)
    if not u86 or u86 == "" then
        return;
    end;

    if u88 then
        u88 = SkillCommon.resolveModelAttachPart(u88);
    end;

    if u88 then
        u89 = u88.Position;
    end;

    local function buildPayload(p90) -- Line: 371
        -- upvalues: u89 (copy), u86 (copy), u88 (copy)
        if not u89 then
            return nil;
        end;

        local v91 = {
            Is2D = false,
            Looped = true,
            SoundName = u86,
            PlayPosition = u89
        };

        if u88 then
            v91.AttachPart = u88;
        end;

        if p90 then
            v91.SoundTag = p90;
        end;

        return v91;
    end;

    if p87 then
        local v92;

        if u89 then
            v92 = {
                Is2D = false,
                Looped = true,
                SoundName = u86,
                PlayPosition = u89
            };

            if u88 then
                v92.AttachPart = u88;
            end;

            if p87 then
                v92.SoundTag = p87;
            end;
        else
            v92 = nil;
        end;

        if v92 then
            SoundModule:PlaySoundLocal(v92);
        end;

        return;
    end;

    local v93;

    if u89 then
        v93 = {
            Is2D = false,
            Looped = true,
            SoundName = u86,
            PlayPosition = u89
        };

        if u88 then
            v93.AttachPart = u88;
        end;
    else
        v93 = nil;
    end;

    if v93 then
        SoundModule:PlaySoundLocal(v93);
    end;
end;

local function _stopBubbleFlightSound(p94) -- Line: 404
    -- upvalues: SoundModule (copy)
    if not p94 or p94.flightSoundStopped then
        return;
    end;

    local flightSoundName = p94.flightSoundName;
    local flightSoundTag = p94.flightSoundTag;

    if not flightSoundName or (flightSoundName == "" or not flightSoundTag) then
        return;
    end;

    SoundModule:StopSoundLocal({
        FadeTime = 0.15,
        SoundName = flightSoundName,
        SoundTag = flightSoundTag
    });
    p94.flightSoundStopped = true;
end;

local function _stopAllClientFlightSounds(p95) -- Line: 421
    -- upvalues: _stopBubbleFlightSound (copy)
    local skillRunData = p95.skillRunData;
    local v96 = skillRunData and skillRunData.SpiderToxinClient and skillRunData.SpiderToxinClient.projectiles;

    if not v96 then
        return;
    end;

    for _, v in v96 do
        _stopBubbleFlightSound(v);
    end;
end;

local function _playBubbleAppearFx(p97, p98, p99) -- Line: 432
    -- upvalues: VisibleMgr (copy), FXUtil (copy), SkillCommon (copy)
    local v100 = p97.material and p97.material["毒素气泡出现"];

    if not v100 then
        return;
    end;

    local v101 = v100:Clone();

    if v101:IsA("Model") then
        VisibleMgr.UnQueryAll(v101);
        v101:ScaleTo(p99);
        v101:PivotTo(p98 * (v101:GetPivot() - v101:GetPivot().Position));
    elseif v101:IsA("BasePart") then
        v101.CFrame = p98;
    end;

    v101.Parent = workspace.Debris;
    FXUtil.Emit_Particles_GetDescendants(v101, true);
    SkillCommon.appendRunSpawnList(p97, "SpiderToxinSpawns", v101);
end;

local function _disableBubbleVfx(p102) -- Line: 452
    -- upvalues: FXUtil (copy)
    FXUtil.Stop_All_Emit(p102);
    FXUtil.SetEmittersTrailsBeamsEnabled(p102, false);
    FXUtil.OffEnableVfx(p102);
end;

local function _removeFromSpawnList(p103, p104) -- Line: 458
    local SpiderToxinSpawns = p103.SpiderToxinSpawns;

    if not SpiderToxinSpawns then
        return;
    end;

    for i = #SpiderToxinSpawns, 1, -1 do
        if SpiderToxinSpawns[i] == p104 then
            table.remove(SpiderToxinSpawns, i);
        end;
    end;
end;

local function _clearBigBubbleAttachmentParticles(p105) -- Line: 470
    local v106 = nil;

    if p105:IsA("Model") then
        p105 = p105.PrimaryPart;
    elseif not p105:IsA("BasePart") then
        p105 = v106;
    end;

    if not p105 then
        return;
    end;

    local v107 = p105:FindFirstChild("大泡");

    if not (v107 and v107:IsA("Attachment")) then
        return;
    end;

    local function clearPe(p108) -- Line: 486
        p108.Enabled = false;
        p108:Clear();
    end;

    for _, child in v107:GetChildren() do
        if child:IsA("ParticleEmitter") then
            child.Enabled = false;
            child:Clear();
        end;
    end;

    for _, descendant in v107:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = false;
            descendant:Clear();
        end;
    end;
end;

local function _scheduleBubbleRecycle(u109, p110) -- Line: 503
    -- upvalues: _removeFromSpawnList (copy)
    if not (u109 and u109.Parent) then
        return;
    end;

    _removeFromSpawnList(p110, u109);
    task.delay(2, function() -- Line: 508
        -- upvalues: u109 (copy)
        if u109.Parent then
            u109:Destroy();
        end;
    end);
end;

local function _onBubbleExplodedVisual(u111, p112) -- Line: 518
    -- upvalues: FXUtil (copy), _clearBigBubbleAttachmentParticles (copy), _removeFromSpawnList (copy)
    if not (u111 and u111.Parent) then
        return;
    end;

    if u111:GetAttribute("PoisonBubbleExplodeHandled") then
        return;
    end;

    u111:SetAttribute("PoisonBubbleExplodeHandled", true);
    FXUtil.Stop_All_Emit(u111);
    FXUtil.SetEmittersTrailsBeamsEnabled(u111, false);
    FXUtil.OffEnableVfx(u111);
    _clearBigBubbleAttachmentParticles(u111);

    if u111 then
        if not u111.Parent then
            return;
        end;

        _removeFromSpawnList(p112, u111);
        task.delay(2, function() -- Line: 508
            -- upvalues: u111 (copy)
            if u111.Parent then
                u111:Destroy();
            end;
        end);
    end;
end;

local function _doClientBubbleArrive(p113, p114, p115) -- Line: 532
    -- upvalues: _stopBubbleFlightSound (copy), _onBubbleExplodedVisual (copy)
    if p114.impacted then
        return;
    end;

    p114.impacted = true;
    _stopBubbleFlightSound(p114);
    local skillRunData = p113.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    skillRunData.Logic.impactPosition = p115;

    if p114.bubble and p114.bubble.Parent then
        p114.bubble:PivotTo(CFrame.new(p115) * p114.bubble:GetPivot().Rotation);
        _onBubbleExplodedVisual(p114.bubble, skillRunData);
    end;
end;

local function _doServerBubbleImpact(p116, p117, p118) -- Line: 550
    -- upvalues: SkillEventConst (copy), ProjectileImpact (copy)
    if p117.impacted then
        return;
    end;

    p117.impacted = true;
    local skillRunData = p116.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    skillRunData.Logic.impactPosition = p118;
    ProjectileImpact.resolveImpact(p116, {
        type = SkillEventConst.HitType.Timeout,
        position = p118,
        source = ProjectileImpact.ImpactSource.Lifetime
    });
end;

local function _applyHitboxVisibility(p119, p120) -- Line: 568
    if not p119 then
        return;
    end;

    p119.Transparency = 1;
end;

local function _ensureClientMotionLoop(u121, u122, u123) -- Line: 579
    -- upvalues: RunService (copy), _ensureClientProjectileList (copy), _doClientBubbleArrive (copy), SkillCommon (copy), _sampleProjectileMotion (copy), MathMgr (copy), u2 (copy)
    local skillRunData = u121.skillRunData;

    if skillRunData.runEvent["蜘蛛毒素客户端弹道"] then
        return;
    end;

    skillRunData.runEvent["蜘蛛毒素客户端弹道"] = RunService.Heartbeat:Connect(function(p124) -- Line: 585
        -- upvalues: u121 (copy), u123 (copy), skillRunData (copy), _ensureClientProjectileList (ref), _doClientBubbleArrive (ref), SkillCommon (ref), _sampleProjectileMotion (ref), MathMgr (ref), u122 (copy), u2 (ref)
        local v125 = u121;
        local v126 = skillRunData;
        local v127;

        if u123 == v125.runGeneration then
            if v125:isRunningFlow() then
                v127 = true;
            else
                local v128 = v126.SpiderToxinClient and v126.SpiderToxinClient.projectiles;

                if v128 then
                    v127 = false;

                    for _, v in v128 do
                        if v and not v.impacted then
                            v127 = true;
                            break;
                        end;
                    end;
                else
                    v127 = false;
                end;
            end;
        else
            v127 = false;
        end;

        if not v127 then
            local v129 = skillRunData.runEvent["蜘蛛毒素客户端弹道"];

            if v129 then
                v129:Disconnect();
                skillRunData.runEvent["蜘蛛毒素客户端弹道"] = nil;
            end;

            return;
        end;

        local skillInputData = u121.skillInputData;
        local v130 = false;

        for _, v in _ensureClientProjectileList(skillRunData) do
            if v and not v.impacted then
                if v.bubble and v.bubble.Parent then
                    v130 = true;
                    v.moveT = v.moveT + p124;
                    local v131 = math.clamp(v.moveT / v.flightSec, 0, 1);
                    local v132;

                    if v.frozenEnd then
                        v132 = v.frozenEnd;
                    else
                        if skillInputData then
                            v132 = v.snapEnd0;
                            local v133;

                            if skillInputData then
                                v133 = SkillCommon.resolveTrackTargetHrp(skillInputData);
                            else
                                v133 = skillInputData;
                            end;

                            if v133 and v133.Parent then
                                v132 = v133.Position;
                            end;
                        else
                            v132 = v.snapEnd0;
                        end;

                        if (v.trackDurationSec or 2) < v.moveT then
                            v.frozenEnd = v132;
                        end;
                    end;

                    local v134, v135 = _sampleProjectileMotion(v, v131, v132);

                    if v.oriLocal then
                        local v136 = MathMgr.rotLookAtForwardSafe(v135, Vector3.new(0, 1, 0), u122.CFrame.RightVector);
                        v.bubble:PivotTo(CFrame.new(v134) * v136 * v.oriLocal);
                    else
                        v.bubble:PivotTo(CFrame.new(v134));
                    end;

                    skillRunData.Logic = skillRunData.Logic or {};
                    skillRunData.Logic.impactPosition = v134;

                    if v131 >= 1 then
                        _doClientBubbleArrive(u121, v, v132);
                    end;
                else
                    local v137;

                    if v.frozenEnd then
                        v137 = v.frozenEnd;
                    else
                        if skillInputData then
                            v137 = v.snapEnd0;
                            local v138;

                            if skillInputData then
                                v138 = SkillCommon.resolveTrackTargetHrp(skillInputData);
                            else
                                v138 = skillInputData;
                            end;

                            if v138 and v138.Parent then
                                v137 = v138.Position;
                            end;
                        else
                            v137 = v.snapEnd0;
                        end;

                        if (v.trackDurationSec or 2) < v.moveT then
                            v.frozenEnd = v137;
                        end;
                    end;

                    _doClientBubbleArrive(u121, v, v137);
                end;
            end;
        end;

        if not v130 then
            SkillCommon.disconnectRunEventKeys(skillRunData, { u2.clientMotion, u2.serverMotion });
        end;
    end);
end;

local function _ensureServerMotionLoop(u139, u140) -- Line: 634
    -- upvalues: RunService (copy), _ensureServerProjectileList (copy), SkillCommon (copy), _sampleProjectileMotion (copy), _doServerBubbleImpact (copy), u2 (copy)
    local skillRunData = u139.skillRunData;

    if skillRunData.runEvent["蜘蛛毒素服务端弹道"] then
        return;
    end;

    skillRunData.runEvent["蜘蛛毒素服务端弹道"] = RunService.Heartbeat:Connect(function(p141) -- Line: 640
        -- upvalues: u139 (copy), u140 (copy), skillRunData (copy), _ensureServerProjectileList (ref), SkillCommon (ref), _sampleProjectileMotion (ref), _doServerBubbleImpact (ref), u2 (ref)
        local v142 = u139;
        local v143 = skillRunData;
        local v144;

        if u140 == v142.runGeneration then
            if v142:isRunningFlow() then
                v144 = true;
            else
                local v145 = v143.SpiderToxinServer and v143.SpiderToxinServer.projectiles;

                if v145 then
                    v144 = false;

                    for _, v in v145 do
                        if v and not v.impacted then
                            v144 = true;
                            break;
                        end;
                    end;
                else
                    v144 = false;
                end;
            end;
        else
            v144 = false;
        end;

        if not v144 then
            local v146 = skillRunData.runEvent["蜘蛛毒素服务端弹道"];

            if v146 then
                v146:Disconnect();
                skillRunData.runEvent["蜘蛛毒素服务端弹道"] = nil;
            end;

            return;
        end;

        local skillInputData = u139.skillInputData;
        local v147 = false;

        for _, v in _ensureServerProjectileList(skillRunData) do
            if v and not v.impacted then
                v147 = true;
                v.moveT = v.moveT + p141;
                local v148 = math.clamp(v.moveT / v.flightSec, 0, 1);
                local v149;

                if v.frozenEnd then
                    v149 = v.frozenEnd;
                else
                    if skillInputData then
                        v149 = v.snapEnd0;
                        local v150;

                        if skillInputData then
                            v150 = SkillCommon.resolveTrackTargetHrp(skillInputData);
                        else
                            v150 = skillInputData;
                        end;

                        if v150 and v150.Parent then
                            v149 = v150.Position;
                        end;
                    else
                        v149 = v.snapEnd0;
                    end;

                    if (v.trackDurationSec or 2) < v.moveT then
                        v.frozenEnd = v149;
                    end;
                end;

                local v151 = select(1, _sampleProjectileMotion(v, v148, v149));
                skillRunData.Logic = skillRunData.Logic or {};
                skillRunData.Logic.impactPosition = v151;

                if v148 >= 1 then
                    _doServerBubbleImpact(u139, v, v149);
                end;
            end;
        end;

        if not v147 then
            SkillCommon.disconnectRunEventKeys(skillRunData, { u2.clientMotion, u2.serverMotion });
        end;
    end);
end;

local function _fireClientBubble(u152) -- Line: 678
    -- upvalues: SkillCommon (copy), _resolveHeadSpawnCF (copy), u1 (copy), MathMgr (copy), _playBubbleAppearFx (copy), VisibleMgr (copy), FXUtil (copy), _playBubbleFlightSound (copy), _ensureClientProjectileList (copy), u2 (copy), RunService (copy), _doClientBubbleArrive (copy), _sampleProjectileMotion (copy)
    local skillInputData = u152.skillInputData;

    if not skillInputData then
        return;
    end;

    local character = skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local runGeneration = u152.runGeneration;

    if u152.runGeneration ~= runGeneration then
        return;
    end;

    local skillRunData = u152.skillRunData;
    local v153 = SkillCommon.scaleBandFromData(u152, SkillCommon.bandScaleOptsFromSkillData(u152));
    local v154 = _resolveHeadSpawnCF(character, v153);

    if not v154 then
        return;
    end;

    local Position = v154.Position;
    SkillCommon.refreshSkillAimSnapshot(u152);
    SkillCommon.refreshSkillAimSnapshot(u152);
    local skillInputData2 = u152.skillInputData;
    local v155;

    if skillInputData2 then
        v155 = SkillCommon.resolveStrikeWorldPos(skillInputData2);
    else
        v155 = u152:getTargetCF().Position;
    end;

    local v156 = u1;
    local v157 = {
        flightSec = v156.flightSec,
        trackDurationSec = v156.trackDurationSec,
        easingStyle = v156.easingStyle,
        easingDirection = v156.easingDirection
    };
    local v158 = v155 - Position;
    local v159;

    if v158.Magnitude > 0.0001 then
        v159 = v158.Unit;
    else
        local v160 = Vector3.new(v155.X - Position.X, 0, v155.Z - Position.Z);
        v159 = v160.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v160.Unit;
    end;

    local v161 = MathMgr.rotLookAtForwardSafe(v159, Vector3.new(0, 1, 0), HumanoidRootPart.CFrame.RightVector);
    _playBubbleAppearFx(skillRunData, CFrame.new(Position) * v161, v153);
    SkillCommon.playSoundLocal3D("音效-技能-毒素气泡-发射", Position);
    local v162 = skillRunData.material and skillRunData.material["毒素气泡"];
    local v163;

    if v162 and v162:IsA("Model") then
        VisibleMgr.UnQueryAll(v162);
        v162:ScaleTo(v153);
        v163 = v162:GetPivot() - v162:GetPivot().Position;

        if v163 then
            v162:PivotTo(CFrame.new(Position) * v161 * v163);
        else
            v162:PivotTo(v154);
        end;

        v162.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v162, false);
        FXUtil.SetEnableNameVfx(v162, true);
        FXUtil.SetEmittersTrailsBeamsEnabled(v162, true);
        skillRunData.Visual = skillRunData.Visual or {};
        skillRunData.Visual.projectileModel = v162;
        SkillCommon.appendRunSpawnList(skillRunData, "SpiderToxinSpawns", v162);
    else
        v163 = nil;
    end;

    local v164 = SkillCommon.resolveSkillCastSoundTag(u152);
    local v165;

    if v164 then
        v165 = v164 .. "_bubbleFly_1";
    else
        v165 = nil;
    end;

    _playBubbleFlightSound(u152, "音效-技能-毒素气泡-飞行", v165, v162, Position);
    local v166 = skillRunData.material and skillRunData.material["毒素爆炸"];

    if v166 then
        v166.Parent = workspace.Debris;

        if v166:IsA("Model") then
            v166:ScaleTo(v153);
        end;
    end;

    local v167 = _ensureClientProjectileList(skillRunData);
    table.insert(v167, {
        flightSoundName = "音效-技能-毒素气泡-飞行",
        moveT = 0,
        impacted = false,
        bubble = v162,
        bubbleStart = Position,
        snapEnd0 = v155,
        initialTangent = v159,
        flightSec = v157.flightSec,
        trackDurationSec = v157.trackDurationSec,
        easingStyle = v157.easingStyle,
        easingDirection = v157.easingDirection,
        oriLocal = v163,
        flightSoundTag = v165
    });
    local skillRunData2 = u152.skillRunData;

    if skillRunData2.runEvent[u2.clientMotion] then
        return;
    end;

    skillRunData2.runEvent[u2.clientMotion] = RunService.Heartbeat:Connect(function(p168) -- Line: 585
        -- upvalues: u152 (copy), runGeneration (copy), skillRunData2 (copy), _ensureClientProjectileList (ref), _doClientBubbleArrive (ref), SkillCommon (ref), _sampleProjectileMotion (ref), MathMgr (ref), HumanoidRootPart (copy), u2 (ref)
        local v169 = u152;
        local v170 = skillRunData2;
        local v171;

        if runGeneration == v169.runGeneration then
            if v169:isRunningFlow() then
                v171 = true;
            else
                local v172 = v170.SpiderToxinClient and v170.SpiderToxinClient.projectiles;

                if v172 then
                    v171 = false;

                    for _, v in v172 do
                        if v and not v.impacted then
                            v171 = true;
                            break;
                        end;
                    end;
                else
                    v171 = false;
                end;
            end;
        else
            v171 = false;
        end;

        if not v171 then
            local v173 = skillRunData2.runEvent["蜘蛛毒素客户端弹道"];

            if v173 then
                v173:Disconnect();
                skillRunData2.runEvent["蜘蛛毒素客户端弹道"] = nil;
            end;

            return;
        end;

        local skillInputData3 = u152.skillInputData;
        local v174 = false;

        for _, v in _ensureClientProjectileList(skillRunData2) do
            if v and not v.impacted then
                if v.bubble and v.bubble.Parent then
                    v174 = true;
                    v.moveT = v.moveT + p168;
                    local v175 = math.clamp(v.moveT / v.flightSec, 0, 1);
                    local v176;

                    if v.frozenEnd then
                        v176 = v.frozenEnd;
                    else
                        if skillInputData3 then
                            v176 = v.snapEnd0;
                            local v177;

                            if skillInputData3 then
                                v177 = SkillCommon.resolveTrackTargetHrp(skillInputData3);
                            else
                                v177 = skillInputData3;
                            end;

                            if v177 and v177.Parent then
                                v176 = v177.Position;
                            end;
                        else
                            v176 = v.snapEnd0;
                        end;

                        if (v.trackDurationSec or 2) < v.moveT then
                            v.frozenEnd = v176;
                        end;
                    end;

                    local v178, v179 = _sampleProjectileMotion(v, v175, v176);

                    if v.oriLocal then
                        local v180 = MathMgr.rotLookAtForwardSafe(v179, Vector3.new(0, 1, 0), HumanoidRootPart.CFrame.RightVector);
                        v.bubble:PivotTo(CFrame.new(v178) * v180 * v.oriLocal);
                    else
                        v.bubble:PivotTo(CFrame.new(v178));
                    end;

                    skillRunData2.Logic = skillRunData2.Logic or {};
                    skillRunData2.Logic.impactPosition = v178;

                    if v175 >= 1 then
                        _doClientBubbleArrive(u152, v, v176);
                    end;
                else
                    local v181;

                    if v.frozenEnd then
                        v181 = v.frozenEnd;
                    else
                        if skillInputData3 then
                            v181 = v.snapEnd0;
                            local v182;

                            if skillInputData3 then
                                v182 = SkillCommon.resolveTrackTargetHrp(skillInputData3);
                            else
                                v182 = skillInputData3;
                            end;

                            if v182 and v182.Parent then
                                v181 = v182.Position;
                            end;
                        else
                            v181 = v.snapEnd0;
                        end;

                        if (v.trackDurationSec or 2) < v.moveT then
                            v.frozenEnd = v181;
                        end;
                    end;

                    _doClientBubbleArrive(u152, v, v181);
                end;
            end;
        end;

        if not v174 then
            SkillCommon.disconnectRunEventKeys(skillRunData2, { u2.clientMotion, u2.serverMotion });
        end;
    end);
end;

local function _fireServerBubble(u183) -- Line: 764
    -- upvalues: SkillCommon (copy), _resolveHeadSpawnCF (copy), u1 (copy), _ensureServerProjectileList (copy), u2 (copy), RunService (copy), _sampleProjectileMotion (copy), _doServerBubbleImpact (copy)
    local skillInputData = u183.skillInputData;

    if not skillInputData then
        return;
    end;

    local character = skillInputData.character;

    if not character then
        return;
    end;

    local runGeneration = u183.runGeneration;

    if u183.runGeneration ~= runGeneration then
        return;
    end;

    local v184 = _resolveHeadSpawnCF(character, (SkillCommon.scaleBandFromData(u183, SkillCommon.bandScaleOptsFromSkillData(u183))));

    if not v184 then
        return;
    end;

    local Position = v184.Position;
    SkillCommon.refreshSkillAimSnapshot(u183);
    SkillCommon.refreshSkillAimSnapshot(u183);
    local skillInputData2 = u183.skillInputData;
    local v185;

    if skillInputData2 then
        v185 = SkillCommon.resolveStrikeWorldPos(skillInputData2);
    else
        v185 = u183:getTargetCF().Position;
    end;

    local v186 = u1;
    local v187 = {
        flightSec = v186.flightSec,
        trackDurationSec = v186.trackDurationSec,
        easingStyle = v186.easingStyle,
        easingDirection = v186.easingDirection
    };
    local v188 = v185 - Position;
    local v189;

    if v188.Magnitude > 0.0001 then
        v189 = v188.Unit;
    else
        local v190 = Vector3.new(v185.X - Position.X, 0, v185.Z - Position.Z);
        v189 = v190.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v190.Unit;
    end;

    local skillRunData = u183.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    skillRunData.Logic.projectileFlyingStartTime = os.clock();
    skillRunData.Logic.projectileLastPosition = Position;
    local v191 = _ensureServerProjectileList(skillRunData);
    table.insert(v191, {
        moveT = 0,
        impacted = false,
        bubbleStart = Position,
        snapEnd0 = v185,
        initialTangent = v189,
        flightSec = v187.flightSec,
        trackDurationSec = v187.trackDurationSec,
        easingStyle = v187.easingStyle,
        easingDirection = v187.easingDirection
    });
    local skillRunData2 = u183.skillRunData;

    if skillRunData2.runEvent[u2.serverMotion] then
        return;
    end;

    skillRunData2.runEvent[u2.serverMotion] = RunService.Heartbeat:Connect(function(p192) -- Line: 640
        -- upvalues: u183 (copy), runGeneration (copy), skillRunData2 (copy), _ensureServerProjectileList (ref), SkillCommon (ref), _sampleProjectileMotion (ref), _doServerBubbleImpact (ref), u2 (ref)
        local v193 = u183;
        local v194 = skillRunData2;
        local v195;

        if runGeneration == v193.runGeneration then
            if v193:isRunningFlow() then
                v195 = true;
            else
                local v196 = v194.SpiderToxinServer and v194.SpiderToxinServer.projectiles;

                if v196 then
                    v195 = false;

                    for _, v in v196 do
                        if v and not v.impacted then
                            v195 = true;
                            break;
                        end;
                    end;
                else
                    v195 = false;
                end;
            end;
        else
            v195 = false;
        end;

        if not v195 then
            local v197 = skillRunData2.runEvent["蜘蛛毒素服务端弹道"];

            if v197 then
                v197:Disconnect();
                skillRunData2.runEvent["蜘蛛毒素服务端弹道"] = nil;
            end;

            return;
        end;

        local skillInputData3 = u183.skillInputData;
        local v198 = false;

        for _, v in _ensureServerProjectileList(skillRunData2) do
            if v and not v.impacted then
                v198 = true;
                v.moveT = v.moveT + p192;
                local v199 = math.clamp(v.moveT / v.flightSec, 0, 1);
                local v200;

                if v.frozenEnd then
                    v200 = v.frozenEnd;
                else
                    if skillInputData3 then
                        v200 = v.snapEnd0;
                        local v201;

                        if skillInputData3 then
                            v201 = SkillCommon.resolveTrackTargetHrp(skillInputData3);
                        else
                            v201 = skillInputData3;
                        end;

                        if v201 and v201.Parent then
                            v200 = v201.Position;
                        end;
                    else
                        v200 = v.snapEnd0;
                    end;

                    if (v.trackDurationSec or 2) < v.moveT then
                        v.frozenEnd = v200;
                    end;
                end;

                local v202 = select(1, _sampleProjectileMotion(v, v199, v200));
                skillRunData2.Logic = skillRunData2.Logic or {};
                skillRunData2.Logic.impactPosition = v202;

                if v199 >= 1 then
                    _doServerBubbleImpact(u183, v, v200);
                end;
            end;
        end;

        if not v198 then
            SkillCommon.disconnectRunEventKeys(skillRunData2, { u2.clientMotion, u2.serverMotion });
        end;
    end);
end;

local function _flushClientProjectiles(p203) -- Line: 812
    -- upvalues: _doClientBubbleArrive (copy), SkillCommon (copy)
    local skillRunData = p203.skillRunData;

    if not (skillRunData and (skillRunData.SpiderToxinClient and skillRunData.SpiderToxinClient.projectiles)) then
        return;
    end;

    local skillInputData = p203.skillInputData;

    for _, v in skillRunData.SpiderToxinClient.projectiles do
        if v and not v.impacted then
            local v204;

            if v.frozenEnd then
                v204 = v.frozenEnd;
            else
                if skillInputData then
                    v204 = v.snapEnd0;
                    local v205;

                    if skillInputData then
                        v205 = SkillCommon.resolveTrackTargetHrp(skillInputData);
                    else
                        v205 = skillInputData;
                    end;

                    if v205 and v205.Parent then
                        v204 = v205.Position;
                    end;
                else
                    v204 = v.snapEnd0;
                end;

                if (v.trackDurationSec or 2) < v.moveT then
                    v.frozenEnd = v204;
                end;
            end;

            _doClientBubbleArrive(p203, v, v204);
        end;
    end;
end;

local function _flushServerProjectiles(p206) -- Line: 825
    -- upvalues: _doServerBubbleImpact (copy), SkillCommon (copy)
    local skillRunData = p206.skillRunData;

    if not (skillRunData and (skillRunData.SpiderToxinServer and skillRunData.SpiderToxinServer.projectiles)) then
        return;
    end;

    local skillInputData = p206.skillInputData;

    for _, v in skillRunData.SpiderToxinServer.projectiles do
        if v and not v.impacted then
            local v207;

            if v.frozenEnd then
                v207 = v.frozenEnd;
            else
                if skillInputData then
                    v207 = v.snapEnd0;
                    local v208;

                    if skillInputData then
                        v208 = SkillCommon.resolveTrackTargetHrp(skillInputData);
                    else
                        v208 = skillInputData;
                    end;

                    if v208 and v208.Parent then
                        v207 = v208.Position;
                    end;
                else
                    v207 = v.snapEnd0;
                end;

                if (v.trackDurationSec or 2) < v.moveT then
                    v.frozenEnd = v207;
                end;
            end;

            _doServerBubbleImpact(p206, v, v207);
        end;
    end;
end;

u4.InitialState = "Startup";
u4.ControlOpenState = "ProjectileFlying";
u4.States = {
    Startup = {
        Duration = 0.6,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup"
    },
    ProjectileFlying = {
        Duration = -1,
        OnEnterClient = "Client_EnterProjectileFlying",
        OnEnterServer = "Server_EnterProjectileFlying",
        OnExitClient = "Client_ExitProjectileFlying",
        OnExitServer = "Server_ExitProjectileFlying"
    },
    Exploding = {
        Duration = 0.3,
        OnEnterClient = "Client_EnterExploding",
        OnEnterServer = "Server_EnterExploding",
        OnExitClient = "Client_ExitExploding",
        OnExitServer = nil
    },
    Recovery = {
        Duration = 0.2,
        OnEnterClient = "Client_EnterRecovery",
        OnEnterServer = "Server_EnterRecovery"
    },
    Finished = {
        Duration = 0,
        IsTerminal = true
    },
    Interrupted = {
        Duration = 0,
        IsTerminal = true
    }
};
u4.Transitions = {
    {
        From = "Startup",
        To = "ProjectileFlying",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "ProjectileFlying",
        To = "Exploding",
        Event = SkillEventConst.ObstacleHit
    },
    {
        From = "ProjectileFlying",
        To = "Exploding",
        Event = SkillEventConst.Timeout
    },
    {
        From = "Exploding",
        To = "Recovery",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "Recovery",
        To = "Finished",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "Startup",
        To = "Interrupted",
        Event = SkillEventConst.Interrupt
    },
    {
        From = "ProjectileFlying",
        To = "Interrupted",
        Event = SkillEventConst.Interrupt
    },
    {
        From = "Exploding",
        To = "Interrupted",
        Event = SkillEventConst.Interrupt
    },
    {
        From = "Recovery",
        To = "Interrupted",
        Event = SkillEventConst.Interrupt
    },
    {
        From = "Startup",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "ProjectileFlying",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Exploding",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Recovery",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    }
};

function u4.Client_EnterStartup(p209) -- Line: 892
end;

function u4.Server_EnterStartup(p210) -- Line: 895
end;

function u4.Client_EnterProjectileFlying(p211) -- Line: 901
    -- upvalues: PlayerAimSync (copy), _fireClientBubble (copy), _flushClientProjectiles (copy), SkillCommon (copy), u2 (copy), u4 (copy)
    PlayerAimSync.refreshAimSnapshot(p211);
    local skillRunData = p211.skillRunData;

    if not skillRunData then
        return;
    end;

    skillRunData.Visual = skillRunData.Visual or {};
    skillRunData.Logic = skillRunData.Logic or {};
    skillRunData.Logic.hasExploded = false;
    skillRunData.runEvent = skillRunData.runEvent or {};
    _fireClientBubble(p211);
    local pendingProjectileHitEvent = skillRunData.Visual.pendingProjectileHitEvent;

    if pendingProjectileHitEvent then
        skillRunData.Visual.pendingProjectileHitEvent = nil;
        _flushClientProjectiles(p211);
        SkillCommon.disconnectRunEventKeys(skillRunData, { u2.clientMotion, u2.serverMotion });
        u4.onServerEvent(p211, pendingProjectileHitEvent);
    end;
end;

function u4.Client_ExitProjectileFlying(p212) -- Line: 924
    -- upvalues: SkillCommon (copy), u2 (copy)
    local skillRunData = p212.skillRunData;

    if skillRunData then
        SkillCommon.disconnectRunEventKeys(skillRunData, { u2.clientMotion, u2.serverMotion });
        SkillCommon.clearSpawnIfTerminalAfterExit(p212, p212.runGeneration, skillRunData, "SpiderToxinSpawns");
    end;
end;

function u4.Server_EnterProjectileFlying(p213) -- Line: 932
    -- upvalues: PlayerAimSync (copy), _fireServerBubble (copy)
    PlayerAimSync.refreshAimSnapshot(p213);
    local v214 = p213.hitbox[1];

    if not (v214 and v214.hitbox) then
        return;
    end;

    local skillRunData = p213.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    skillRunData.Logic.hasExploded = false;
    skillRunData.runEvent = skillRunData.runEvent or {};
    local hitbox = v214.hitbox;

    if hitbox then
        hitbox.Transparency = 1;
    end;

    _fireServerBubble(p213);
end;

function u4.Server_ExitProjectileFlying(p215) -- Line: 950
    -- upvalues: SkillCommon (copy), u2 (copy)
    local skillRunData = p215.skillRunData;

    if skillRunData then
        SkillCommon.disconnectRunEventKeys(skillRunData, { u2.clientMotion, u2.serverMotion });
    end;

    local v216 = p215.hitbox[1];

    if v216 and v216.isActive then
        v216:stop();
    end;

    if v216 and v216.hitbox then
        local hitbox = v216.hitbox;

        if not hitbox then
            return;
        end;

        hitbox.Transparency = 1;
    end;
end;

function u4.Client_EnterExploding(p217, p218) -- Line: 968
    -- upvalues: _stopBubbleFlightSound (copy), FXUtil (copy), SkillCommon (copy), _onBubbleExplodedVisual (copy)
    local skillRunData = p217.skillRunData;
    local v219 = skillRunData and skillRunData.SpiderToxinClient and skillRunData.SpiderToxinClient.projectiles;

    if v219 then
        for _, v in v219 do
            _stopBubbleFlightSound(v);
        end;
    end;

    local v220 = p218 and p218.hitPosition or p217.skillRunData.Logic and p217.skillRunData.Logic.impactPosition;

    if not v220 then
        return;
    end;

    local skillRunData2 = p217.skillRunData;
    local runGeneration = p217.runGeneration;
    local v221 = skillRunData2.Visual and skillRunData2.Visual.projectileModel;
    local v222 = skillRunData2.material and skillRunData2.material["毒素爆炸"];

    if v221 and v221.Parent then
        v221:PivotTo(CFrame.new(v220) * v221:GetPivot().Rotation);
    end;

    if v222 then
        if v222:IsA("Model") then
            v222:PivotTo(CFrame.new(v220));
        elseif v222:IsA("BasePart") then
            v222.CFrame = CFrame.new(v220);
        end;

        FXUtil.Emit_Particles_GetDescendants(v222, true);
    end;

    SkillCommon.playSoundLocal3D("音效-技能-毒素气泡-爆炸", v220);

    if v221 and (v221:IsA("Model") and v221.Parent) then
        _onBubbleExplodedVisual(v221, skillRunData2);
    end;

    if skillRunData2.Visual then
        skillRunData2.Visual.projectileModel = nil;
    end;

    SkillCommon.scheduleRunSpawnClear(p217, runGeneration, skillRunData2, "SpiderToxinSpawns", 1.2);
end;

function u4.Client_ExitExploding(p223) -- Line: 1007
    -- upvalues: SkillCommon (copy)
    local skillRunData = p223.skillRunData;

    if skillRunData then
        SkillCommon.clearSpawnIfTerminalAfterExit(p223, p223.runGeneration, skillRunData, "SpiderToxinSpawns");
    end;
end;

function u4.Server_EnterExploding(p224, p225) -- Line: 1014
    -- upvalues: SkillCommon (copy), SkillEventConst (copy)
    local _, v226 = SkillCommon.scaleDualFromData(p224, SkillCommon.bandScaleOptsFromSkillData(p224));
    local v227 = p225 and p225.hitPosition or p224.skillRunData.Logic and p224.skillRunData.Logic.impactPosition;

    if not v227 then
        return;
    end;

    local u228 = p224.hitbox[1];

    if u228 and u228.hitbox then
        local hitbox = u228.hitbox;

        if hitbox:IsA("BasePart") then
            hitbox.Shape = Enum.PartType.Ball;
        end;

        hitbox.Size = Vector3.new(5, 5, 5) * v226;
        hitbox:PivotTo(CFrame.new(v227));

        if hitbox then
            hitbox.Transparency = 1;
        end;

        u228:start(true);
        task.delay(0.14, function() -- Line: 1032
            -- upvalues: u228 (copy), hitbox (copy)
            if u228.isActive then
                u228:stop();
                local v229 = hitbox;

                if not v229 then
                    return;
                end;

                v229.Transparency = 1;
            end;
        end);
    end;

    p224:fireProjectileHitConfirmed(v227, p224.skillRunData.Logic.impactType or SkillEventConst.HitType.Timeout, p224.skillRunData.Logic.impactTargetId);
end;

function u4.Server_EnterRecovery(p230) -- Line: 1050
    p230:releaseControl();
end;

function u4.Client_EnterRecovery(p231) -- Line: 1054
end;

function u4.onEndServer(p232) -- Line: 1057
    -- upvalues: _flushServerProjectiles (copy), SkillCommon (copy), u2 (copy)
    _flushServerProjectiles(p232);
    SkillCommon.disconnectRunEventKeys(p232.skillRunData, { u2.clientMotion, u2.serverMotion });
    local v233 = p232.hitbox[1];

    if v233 and v233.isActive then
        v233:stop();
    end;

    if p232.skillRunData then
        p232.skillRunData.SpiderToxinServer = nil;
    end;
end;

function u4.onEnd(p234) -- Line: 1069
    -- upvalues: _stopBubbleFlightSound (copy), _flushClientProjectiles (copy), SkillCommon (copy), u2 (copy)
    local skillRunData = p234.skillRunData;
    local v235 = skillRunData and skillRunData.SpiderToxinClient and skillRunData.SpiderToxinClient.projectiles;

    if v235 then
        for _, v in v235 do
            _stopBubbleFlightSound(v);
        end;
    end;

    _flushClientProjectiles(p234);
    SkillCommon.disconnectRunEventKeys(p234.skillRunData, { u2.clientMotion, u2.serverMotion });

    if p234.skillRunData then
        SkillCommon.clearRunSpawnList(p234.skillRunData, "SpiderToxinSpawns");
        p234.skillRunData.SpiderToxinClient = nil;
    end;
end;

function u4.onServerEvent(p236, p237) -- Line: 1079
    -- upvalues: SkillEventConst (copy)
    if p237.eventType ~= SkillEventConst.SyncEventType.ProjectileHitConfirmed then
        return;
    end;

    local skillRunData = p236.skillRunData;

    if not skillRunData then
        return;
    end;

    local hitPosition = p237.hitPosition;

    if not hitPosition then
        return;
    end;

    local v238 = p237.hitType == SkillEventConst.HitType.Obstacle and SkillEventConst.ObstacleHit or SkillEventConst.Timeout;

    if p236.GetCurrentState and p236:GetCurrentState() == "ProjectileFlying" then
        p236:TryTransition(v238, {
            hitPosition = hitPosition,
            hitType = p237.hitType,
            targetId = p237.targetId
        });

        return;
    end;

    skillRunData.Visual = skillRunData.Visual or {};
    skillRunData.Visual.pendingProjectileHitEvent = p237;
end;

function u4.onProjectileHitServer(p239, p240, p241) -- Line: 1108
    -- upvalues: HitResolver (copy)
    if not p240 or p240.hitboxIndex ~= 1 then
        return;
    end;

    local skillRunData = p239.skillRunData;

    if not skillRunData or (not skillRunData.State or skillRunData.State.current ~= "Exploding") then
        return;
    end;

    for i, v in p241 do
        HitResolver.applyHit(p239, p240, v, i, {
            damageProfileId = "ExplosionMain",
            hitboxIndex = 1,
            sourceState = "Exploding",
            skillName = p239.skillName,
            skillCastId = p239.skillCastId,
            baseSkillInstanceId = p239.baseSkillInstanceId,
            activeBaseSkillIndex = p239.activeBaseSkillIndex,
            skillPower = p239.skillPower,
            skillPurity = p239.skillPurity,
            combatSeed = p239.combatSeed
        });
    end;
end;

u4.SoundList = { "音效-技能-毒素气泡-发射", "音效-技能-毒素气泡-飞行", "音效-技能-毒素气泡-爆炸" };
u4.AnimateList = { "蜘蛛毒素" };
u4.ResNameList = { "毒素气泡", "毒素气泡出现", "毒素爆炸" };
u4.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    } };
u4.DamageProfiles = {
    ExplosionMain = {
        canCritical = false,
        showDamageText = true,
        randomOffset = 0.05,
        damageRate = v3,
        elementType = ElementTp.Poison,
        damageTags = { "Magic", "Projectile", "Explosion", "Poison" }
    }
};
u4.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 0.6,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 0.6,
        animationName = "蜘蛛毒素",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return u4;