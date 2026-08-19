-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SoundModule = UtilsSystem.SoundModule;
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
require(script.Parent.Parent.BaseSkill.GetSkillData);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
require(script.Parent._Templates.SkillCommon);
local _ = UtilsSystem.FXUtil;
local _ = UtilsSystem.BurstStone;
local _ = UtilsSystem.RunService;
local VisibleMgr = UtilsSystem.VisibleMgr;
local BezierCurve = UtilsSystem.BezierCurve;
local SkillTelegraph = UtilsSystem.SkillTelegraph;
local Players = UtilsSystem.Players;
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.None
};
local u2 = CFrame.new(2, 0, -3);
local u3 = CFrame.new(-2, 0, -3);
local u4 = CFrame.new(0, 0, -3);
local v5 = math.abs(u2.X - u3.X) + 8;
local u6 = Vector3.new(v5, 3, 60);
v1.InitialState = "Startup";
v1.ControlOpenState = "ThrownMoving";
v1.States = {
    Startup = {
        Duration = 0.7263157894736841,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup",
        OnExitClient = nil,
        OnExitServer = nil
    },
    ThrownMoving = {
        Duration = 1,
        OnEnterClient = "Client_EnterThrownMoving",
        OnEnterServer = "Server_EnterThrownMoving",
        OnExitClient = "Client_ExitThrownMoving",
        OnExitServer = "Server_ExitThrownMoving"
    },
    Recovery = {
        Duration = 0.2105263157894737,
        OnEnterClient = "Client_EnterRecovery",
        OnEnterServer = "Server_EnterRecovery",
        OnExitClient = nil,
        OnExitServer = nil
    },
    Finished = {
        Duration = 0,
        IsTerminal = true
    },
    Interrupted = {
        Duration = 0,
        IsTerminal = true,
        OnEnterClient = "Client_EnterInterrupted"
    }
};
v1.Transitions = {
    {
        From = "Startup",
        To = "ThrownMoving",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "ThrownMoving",
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
        From = "ThrownMoving",
        To = "Interrupted",
        Event = SkillEventConst.Interrupt
    },
    {
        From = "Startup",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "ThrownMoving",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Recovery",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    }
};

local function get_skillScale(p7) -- Line: 113
    local character = p7.skillInputData.character;

    return not character and 1 or character:GetScale();
end;

local function sampleLiveThrowAim(p8) -- Line: 130
    local v9 = p8.skillInputData and p8.skillInputData.releaseCF;

    if not v9 then
        return nil, nil, nil;
    end;

    local v10 = p8:getTargetCF();
    local v11 = (v10.Position - v9.Position) * Vector3.new(1, 0, 1);

    if v11.Magnitude < 0.0001 then
        return nil, nil, nil;
    end;

    local v12 = v10.Rotation + v9.Position + v11.Unit * 60;

    return CFrame.new(v9.Position, (Vector3.new(v12.X, v9.Y, v12.Z))), v12, v10;
end;

local function freezeThrowAimAtStartup(p13) -- Line: 151
    -- upvalues: sampleLiveThrowAim (copy)
    local skillRunData = p13.skillRunData;

    if not skillRunData then
        return nil, nil;
    end;

    skillRunData.Logic = skillRunData.Logic or {};
    local lockedThrowAim = skillRunData.Logic.lockedThrowAim;

    if lockedThrowAim and (lockedThrowAim.bodyCF and lockedThrowAim.endCF) then
        return lockedThrowAim.bodyCF, lockedThrowAim.endCF;
    end;

    local v14, v15, v16 = sampleLiveThrowAim(p13);

    if not (v14 and (v15 and v16)) then
        return nil, nil;
    end;

    skillRunData.Logic.lockedThrowAim = {
        bodyCF = v14,
        endCF = v15,
        rawTargetCF = v16
    };
    skillRunData.manualAimSnapshotCF = v16;

    if p13.skillInputData then
        p13.skillInputData.targetCF = v16;
    end;

    return v14, v15;
end;

local function getFrozenThrowAim(p17) -- Line: 186
    -- upvalues: freezeThrowAimAtStartup (copy)
    local skillRunData = p17.skillRunData;
    local v18 = skillRunData and skillRunData.Logic and skillRunData.Logic.lockedThrowAim;

    if v18 and (v18.bodyCF and v18.endCF) then
        return v18.bodyCF, v18.endCF;
    end;

    return freezeThrowAimAtStartup(p17);
end;

local function resolveMergedCorridorWorldCF(p19, p20) -- Line: 201
    -- upvalues: u4 (copy)
    local Position = p19:ToWorldSpace(u4).Position;
    local Position2 = p20.Position;
    local v21 = (Position + Position2) * 0.5;
    local v22 = Vector3.new(Position2.X - Position.X, 0, Position2.Z - Position.Z);

    if v22.Magnitude < 0.0001 then
        return nil;
    end;

    return CFrame.lookAt(v21, v21 + v22, Vector3.new(0, 1, 0));
end;

local function snapLocalCasterFacing(p23, p24) -- Line: 217
    -- upvalues: Players (copy)
    local LocalPlayer = Players.LocalPlayer;

    if not LocalPlayer or (p23.characterType ~= "Player" or p23.characterId ~= LocalPlayer.UserId) then
        return;
    end;

    if LocalPlayer:GetAttribute("IsShiftLocked") then
        return;
    end;

    local v25 = p23.skillInputData and p23.skillInputData.character;

    if not v25 then
        return;
    end;

    local HumanoidRootPart = v25:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return;
    end;

    local v26 = Vector3.new(p24.X, HumanoidRootPart.Position.Y, p24.Z);

    if (HumanoidRootPart.Position - v26).Magnitude <= 0.1 then
        return;
    end;

    HumanoidRootPart.CFrame = CFrame.lookAt(HumanoidRootPart.Position, v26);
    local v27 = v25:FindFirstChildOfClass("Humanoid");

    if v27 then
        v27.AutoRotate = false;
        local skillRunData = p23.skillRunData;
        skillRunData.Logic = skillRunData.Logic or {};
        skillRunData.Logic.hammerSpinAutoRotateLocked = true;
    end;
end;

local function restoreLocalCasterAutoRotate(p28) -- Line: 251
    -- upvalues: Players (copy)
    local skillRunData = p28.skillRunData;

    if not (skillRunData and (skillRunData.Logic and skillRunData.Logic.hammerSpinAutoRotateLocked)) then
        return;
    end;

    skillRunData.Logic.hammerSpinAutoRotateLocked = nil;
    local LocalPlayer = Players.LocalPlayer;

    if not LocalPlayer or (p28.characterType ~= "Player" or p28.characterId ~= LocalPlayer.UserId) then
        return;
    end;

    local v29 = p28.skillInputData and p28.skillInputData.character;

    if not v29 then
        return;
    end;

    local v30 = v29:FindFirstChildOfClass("Humanoid");

    if v30 then
        v30.AutoRotate = true;
    end;
end;

local function getStraightMid(p31, p32) -- Line: 277
    -- upvalues: BezierCurve (copy)
    return BezierCurve.GetMiddlePosition_OLD(p31, p32, 0, 0, 0.5);
end;

local function placeFixedCorridorHitbox(p33, p34, p35) -- Line: 287
    -- upvalues: resolveMergedCorridorWorldCF (copy), u6 (copy)
    local v36 = resolveMergedCorridorWorldCF(p34, p35);

    if not v36 then
        return;
    end;

    p33.Size = u6;
    p33:PivotTo(v36);
end;

local function playStraightRoundTrip(u37, u38, u39, u40) -- Line: 303
    -- upvalues: BezierCurve (copy)
    local v41 = BezierCurve.GetMiddlePosition_OLD(u38, u39, 0, 0, 0.5);

    local function v43() -- Line: 305
        -- upvalues: u39 (copy), u38 (copy), BezierCurve (ref), u37 (copy), u40 (copy)
        local v42 = BezierCurve.GetMiddlePosition_OLD(u39, u38, 0, 0, 0.5);
        BezierCurve.QuadraticBezierCurvesRotate(19.736842105263158, 60, u37, u39, v42, u38, CFrame.new(0, 0, 0), u40, Vector3.new(0, 760, 0));
    end;

    BezierCurve.QuadraticBezierCurvesRotate(18.157894736842106, 60, u37, u38, v41, u39, CFrame.new(0, 0, 0), v43, Vector3.new(0, 760, 0));
end;

local function setupStartupTelegraphs(p44, p45, p46) -- Line: 328
    -- upvalues: SkillTelegraph (copy), resolveMergedCorridorWorldCF (copy), u6 (copy)
    local character = p44.skillInputData.character;

    if not character then
        return;
    end;

    local skillRunData = p44.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    SkillTelegraph.destroyAllInRunData(skillRunData);
    local v47 = resolveMergedCorridorWorldCF(p45, p46);

    if not v47 then
        return;
    end;

    skillRunData.Logic.dangerTelegraph = SkillTelegraph.new({
        shape = "Rect",
        warnDuration = 0.7263157894736841,
        worldCFrame = v47,
        hitboxSize = u6,
        casterCharacter = character,
        characterType = p44.characterType
    });
    skillRunData.Logic.dangerTelegraph:update({
        lockPosition = true,
        worldCFrame = v47,
        hitboxSize = u6
    });
end;

local function activateTelegraphs(p48) -- Line: 363
    local v49 = p48.skillRunData.Logic and p48.skillRunData.Logic.dangerTelegraph;

    if not v49 then
        return;
    end;

    v49:activate(1);
end;

function v1.Client_EnterStartup(p50) -- Line: 372
    -- upvalues: freezeThrowAimAtStartup (copy), snapLocalCasterFacing (copy), setupStartupTelegraphs (copy)
    local character = p50.skillInputData.character;

    if not character then
        return;
    end;

    if not character:FindFirstChild("HumanoidRootPart") then
        return;
    end;

    if not character:FindFirstChild("Right Arm") then
        return;
    end;

    local v51, v52 = freezeThrowAimAtStartup(p50);

    if not (v51 and v52) then
        return;
    end;

    snapLocalCasterFacing(p50, v52);
    setupStartupTelegraphs(p50, v51, v52);
end;

function v1.Server_EnterStartup(p53) -- Line: 390
    -- upvalues: freezeThrowAimAtStartup (copy), u6 (copy), resolveMergedCorridorWorldCF (copy)
    local v54, v55 = freezeThrowAimAtStartup(p53);
    local v56 = p53.hitbox[1];

    if v56 and v56.hitbox then
        v56.hitbox.Size = u6;

        if v54 and v55 then
            local hitbox = v56.hitbox;
            local v57 = resolveMergedCorridorWorldCF(v54, v55);

            if not v57 then
                return;
            end;

            hitbox.Size = u6;
            hitbox:PivotTo(v57);
        end;
    end;
end;

function v1.Client_EnterThrownMoving(u58) -- Line: 403
    -- upvalues: freezeThrowAimAtStartup (copy), u2 (copy), VisibleMgr (copy), SoundModule (copy), playStraightRoundTrip (copy), u3 (copy)
    local v59 = u58.skillRunData.Logic and u58.skillRunData.Logic.dangerTelegraph;

    if v59 then
        v59:activate(1);
    end;

    if u58.skillRunData.runEvent["投掷物跟手"] then
        u58.skillRunData.runEvent["投掷物跟手"]:Disconnect();
        u58.skillRunData.runEvent["投掷物跟手"] = nil;
    end;

    local character = u58.skillInputData.character;

    if not character then
        return;
    end;

    if not character:FindFirstChild("HumanoidRootPart") then
        return;
    end;

    local v60 = character:FindFirstChild("Left Arm");
    local v61 = character:FindFirstChild("Right Arm");

    if not v60 then
        return;
    end;

    if not v61 then
        return;
    end;

    local character2 = u58.skillInputData.character;
    local u62 = not character2 and 1 or character2:GetScale();
    local skillRunData = u58.skillRunData;
    local v63 = skillRunData and skillRunData.Logic and skillRunData.Logic.lockedThrowAim;
    local u64, u65;

    if v63 and (v63.bodyCF and v63.endCF) then
        u64 = v63.bodyCF;
        u65 = v63.endCF;
    else
        u64, u65 = freezeThrowAimAtStartup(u58);
    end;

    if not (u64 and u65) then
        return;
    end;

    task.defer(function() -- Line: 427
        -- upvalues: u64 (copy), u2 (ref), u58 (copy), VisibleMgr (ref), u62 (copy), character (copy), SoundModule (ref), playStraightRoundTrip (ref), u65 (copy)
        local v66 = u64:ToWorldSpace(u2);
        local u67 = u58.skillRunData.material["矮人的战锤"];
        VisibleMgr.TransparencyAll(u67);
        u67:PivotTo(v66);
        u67:ScaleTo(u62);
        local v68 = character:FindFirstChild("当前手持");
        local v69 = v68 and v68:FindFirstChild("矮人的战锤");

        if v69 then
            VisibleMgr.UnTransparencyAll(v69);
        end;

        u67.Parent = workspace.Debris;

        if u67 and u67.PrimaryPart then
            SoundModule:PlaySoundLocal({
                SoundName = "音效-技能-武器回旋",
                Is2D = false,
                AttachPart = u67.PrimaryPart,
                PlayPosition = v66.Position
            });
        end;

        playStraightRoundTrip(u67, v66.Position, u65.Position, function() -- Line: 454
            -- upvalues: character (ref), VisibleMgr (ref), u67 (copy)
            local v70 = character:FindFirstChild("当前手持");
            local v71 = v70 and v70:FindFirstChild("矮人的战锤");

            if v71 then
                VisibleMgr.TransparencyAll(v71);

                if v71.PrimaryPart then
                    v71.PrimaryPart.Transparency = 1;
                end;
            end;

            VisibleMgr.UnTransparencyAll(u67);
        end);
    end);
    task.delay(0.3684210526315789, function() -- Line: 469
        -- upvalues: u64 (copy), u3 (ref), character (copy), VisibleMgr (ref), u58 (copy), u62 (copy), SoundModule (ref), playStraightRoundTrip (ref), u65 (copy)
        local v72 = u64:ToWorldSpace(u3);
        local v73 = character:FindFirstChild("当前手持");
        local v74 = v73 and v73:FindFirstChild("矮人的战斧");

        if v74 then
            VisibleMgr.UnTransparencyAll(v74);
        end;

        local u75 = u58.skillRunData.material["矮人的战斧"];
        VisibleMgr.TransparencyAll(u75);
        u75:PivotTo(v72);
        u75.Parent = workspace.Debris;
        u75:ScaleTo(u62);

        if u75 and u75.PrimaryPart then
            SoundModule:PlaySoundLocal({
                SoundName = "音效-技能-武器回旋",
                Is2D = false,
                AttachPart = u75.PrimaryPart,
                PlayPosition = v72.Position
            });
        end;

        playStraightRoundTrip(u75, v72.Position, u65.Position, function() -- Line: 494
            -- upvalues: character (ref), VisibleMgr (ref), u75 (copy)
            local v76 = character:FindFirstChild("当前手持");
            local v77 = v76 and v76:FindFirstChild("矮人的战斧");

            if v77 then
                VisibleMgr.TransparencyAll(v77);

                if v77.PrimaryPart then
                    v77.PrimaryPart.Transparency = 1;
                end;
            end;

            VisibleMgr.UnTransparencyAll(u75);
        end);
    end);
end;

function v1.Client_ExitThrownMoving(p78) -- Line: 511
end;

function v1.Server_EnterThrownMoving(p79) -- Line: 515
    -- upvalues: freezeThrowAimAtStartup (copy), resolveMergedCorridorWorldCF (copy), u6 (copy)
    local v80 = p79.hitbox[1];

    if not v80 then
        return;
    end;

    if not p79.skillInputData.character then
        return;
    end;

    local skillRunData = p79.skillRunData;
    local v81 = skillRunData and skillRunData.Logic and skillRunData.Logic.lockedThrowAim;
    local v82, v83;

    if v81 and (v81.bodyCF and v81.endCF) then
        v82 = v81.bodyCF;
        v83 = v81.endCF;
    else
        v82, v83 = freezeThrowAimAtStartup(p79);
    end;

    if not (v82 and v83) then
        return;
    end;

    local hitbox = v80.hitbox;
    local v84 = resolveMergedCorridorWorldCF(v82, v83);

    if v84 then
        hitbox.Size = u6;
        hitbox:PivotTo(v84);
    end;

    v80:start();
end;

function v1.Server_ExitThrownMoving(p85) -- Line: 531
    if p85.skillRunData.runEvent["投掷物伤害盒移动"] then
        p85.skillRunData.runEvent["投掷物伤害盒移动"]:Disconnect();
        p85.skillRunData.runEvent["投掷物伤害盒移动"] = nil;
    end;

    local v86 = p85.hitbox[1];

    if v86 and v86.isActive then
        v86:stop();
    end;
end;

function v1.Server_EnterRecovery(p87) -- Line: 541
    p87:releaseControl();
end;

function v1.Client_EnterRecovery(p88) -- Line: 545
    -- upvalues: restoreLocalCasterAutoRotate (copy), SkillTelegraph (copy)
    restoreLocalCasterAutoRotate(p88);
    SkillTelegraph.destroyAllInRunData(p88.skillRunData);
end;

function v1.Client_EnterInterrupted(p89) -- Line: 550
    -- upvalues: restoreLocalCasterAutoRotate (copy), SkillTelegraph (copy)
    restoreLocalCasterAutoRotate(p89);
    SkillTelegraph.destroyAllInRunData(p89.skillRunData);
end;

function v1.onEnd(p90) -- Line: 555
    -- upvalues: restoreLocalCasterAutoRotate (copy), SkillTelegraph (copy)
    restoreLocalCasterAutoRotate(p90);
    SkillTelegraph.destroyAllInRunData(p90.skillRunData);
end;

v1.SoundList = { "音效-技能-武器回旋" };
v1.AnimateList = { "回旋双锤" };
v1.ResNameList = { "矮人的战斧", "矮人的战锤" };
v1.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用长方体",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    } };
v1.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 0,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 2.1052631578947367,
        animationName = "回旋双锤",
        animationSpeed = 0.95,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;