-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local PlayerAimSync = UtilsSystem.PlayerAimSync;
local _ = UtilsSystem.DeviceType;
local LocalPlayer = UtilsSystem.LocalPlayer;
local HitCameraShake = UtilsSystem.HitCameraShake;
local HitPhysics = UtilsSystem.HitPhysics;
local SkillHitPresentation = UtilsSystem.SkillHitPresentation;
local NPCCosmeticHit = UtilsSystem.NPCCosmeticHit;
local MonsterLocomotion = UtilsSystem.MonsterLocomotion;
local PlayerHitPresentation = UtilsSystem.PlayerHitPresentation;
local FXUtil = UtilsSystem.FXUtil;
local PlayerSkillBinding = require(script.PlayerSkillBinding);
local PlayerSkillInput = require(script.PlayerSkillInput);
local PlayerSkillSynSkillRouter = require(script.PlayerSkillSynSkillRouter);
local PlayerSkillRemoteSync = require(script.PlayerSkillRemoteSync);
local PlayerSkillPresentationSync = require(script.PlayerSkillPresentationSync);
local PlayerSkillControlHub = require(script.PlayerSkillControlHub);
local PlayerSkillDataSync = require(script.PlayerSkillDataSync);
PlayerAimSync.initClient();
PlayerSkillSynSkillRouter.setMagicBlockDebugFn(PlayerSkillInput.getMagicBlockDebugFn());
task.spawn(function() -- Line: 51
    -- upvalues: LocalPlayer (copy), PlayerSkillBinding (copy)
    LocalPlayer:WaitForChild("技能相关", (1 / 0));
    PlayerSkillBinding.initFromNumberValues();
end);
LocalPlayer.CharacterAdded:Connect(function() -- Line: 50, Name: _spawnPlayerSkillBindingInit
    -- upvalues: LocalPlayer (copy), PlayerSkillBinding (copy)
    task.spawn(function() -- Line: 51
        -- upvalues: LocalPlayer (ref), PlayerSkillBinding (ref)
        LocalPlayer:WaitForChild("技能相关", (1 / 0));
        PlayerSkillBinding.initFromNumberValues();
    end);
end);
LocalPlayer.CharacterRemoving:Connect(function() -- Line: 61
    -- upvalues: PlayerSkillBinding (copy)
    PlayerSkillBinding.destroyAll();
end);
PlayerSkillInput.connect();
PlayerSkillDataSync.connect();
PlayerSkillRemoteSync.connect();
PlayerSkillPresentationSync.connect();
PlayerSkillPresentationSync.setHitCameraShakeHandler(function(p1, p2) -- Line: 69
    -- upvalues: HitCameraShake (copy)
    HitCameraShake.handleIncoming(p1, p2);
end);
PlayerSkillPresentationSync.setHitPhysicsHandler(function(p3) -- Line: 72
    -- upvalues: HitPhysics (copy)
    HitPhysics.handleIncoming(p3);
end);
PlayerSkillPresentationSync.setSkillHitPresentationHandler(function(p4) -- Line: 75
    -- upvalues: SkillHitPresentation (copy)
    SkillHitPresentation.handleIncoming(p4);
end);
PlayerSkillPresentationSync.setNpcCosmeticHitHandler(function(p5) -- Line: 78
    -- upvalues: NPCCosmeticHit (copy)
    NPCCosmeticHit.handleIncoming(p5);
end);
PlayerSkillPresentationSync.setNpcLocomotionHandler(function(p6) -- Line: 81
    -- upvalues: MonsterLocomotion (copy)
    MonsterLocomotion.handleIncoming(p6);
end);
PlayerSkillPresentationSync.setPlayerHitPresentationHandler(function(p7) -- Line: 84
    -- upvalues: PlayerHitPresentation (copy)
    PlayerHitPresentation.handleIncoming(p7);
end);
PlayerSkillPresentationSync.setDotHitPresentationHandler(function(p8) -- Line: 87
    -- upvalues: FXUtil (copy)
    if type(p8) ~= "table" then
        return;
    end;

    local vfxName = p8.vfxName;

    if type(vfxName) ~= "string" or vfxName == "" then
        return;
    end;

    FXUtil.PlayModelResSkillBuffDotHitFx(vfxName, p8.defenderUserId, p8.monsterId, p8.durationSec);
end);
PlayerSkillPresentationSync.setDotHitPresentationEndHandler(function(p9) -- Line: 97
    -- upvalues: FXUtil (copy)
    if type(p9) ~= "table" then
        return;
    end;

    local vfxName = p9.vfxName;

    if type(vfxName) ~= "string" or vfxName == "" then
        return;
    end;

    FXUtil.StopModelResSkillBuffDotHitFx(vfxName, p9.defenderUserId, p9.monsterId);
end);
PlayerSkillSynSkillRouter.connect();
PlayerSkillControlHub.start();