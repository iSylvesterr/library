-- Decompiled with Potassium's decompiler.

local AnimationModule = require(game.ReplicatedFirst.AllSideCode.ToolSystem.AnimationModule);
local SkillActionControl = require(script.Parent.Parent.SkillActionControl);
local SkillActionLock = require(script.Parent.Parent.SkillActionLock);
local SkillAnimationTrackOwner = require(script.Parent.SkillAnimationTrackOwner);
game:GetService("Players");
game:GetService("RunService");
local v1 = {
    isReleasePlayerOnly = true
};

local function _isValidAnimationName(p2) -- Line: 20
    local v3;

    if typeof(p2) == "string" then
        v3 = p2 ~= "";
    else
        v3 = false;
    end;

    return v3;
end;

local function _warnMissingAnimationName(p4) -- Line: 27
    warn("[Animation Action] 缺少 animationName, skill:", p4 and p4.skillName or "?");
end;

function v1.Create(p5, p6) -- Line: 32
    -- upvalues: SkillActionControl (copy), AnimationModule (copy)
    p5.actionInfo = p6;
    p5.state = SkillActionControl.StateEnum.NoStart;
    p5.startTime = p5.actionInfo.startTime;
    p5.overTime = p5.actionInfo.overTime;
    local character = p5.baseSkill.character;

    if not character then
        return;
    end;

    local Animator = character:WaitForChild("Humanoid"):WaitForChild("Animator");

    if not Animator then
        return;
    end;

    p5.animator = Animator;
    p5.animationName = p6.animationName;
    p5.animationSpeed = p6.animationSpeed or 1;
    p5.animationPriority = p6.animationPriority or Enum.AnimationPriority.Action;
    p5.animationFadeTime = p6.animationFadeTime or 0;
    p5.animationKeyframeNames = p6.animationKeyframeNames or {};
    p5.animationKeyframeFunctions = p6.animationKeyframeFunctions or {};
    p5.animationLoop = p6.animationLoop or false;

    if not p5.baseSkill._skipAnimationCreatePreload then
        local animationName = p5.animationName;
        local v7;

        if typeof(animationName) == "string" then
            v7 = animationName ~= "";
        else
            v7 = false;
        end;

        if v7 then
            AnimationModule.PlayAnim(p5.animator, p5.animationName);
            AnimationModule.StopAnim(p5.animator, p5.animationName);
        end;
    end;
end;

function v1.Init(p8) -- Line: 72
    -- upvalues: SkillActionControl (copy)
    p8.state = SkillActionControl.StateEnum.NoStart;
end;

function v1.Run(p9, p10) -- Line: 76
end;

function v1.Start(u11, p12) -- Line: 79
    -- upvalues: SkillActionLock (copy), AnimationModule (copy), SkillAnimationTrackOwner (copy)
    if not u11.animator then
        return;
    end;

    local animationName = u11.animationName;
    local v13;

    if typeof(animationName) == "string" then
        v13 = animationName ~= "";
    else
        v13 = false;
    end;

    if not v13 then
        local baseSkill = u11.baseSkill;
        warn("[Animation Action] 缺少 animationName, skill:", baseSkill and baseSkill.skillName or "?");

        return;
    end;

    SkillActionLock.turn_On_Action_Lock(u11.baseSkill.character);
    AnimationModule.StopAnim(u11.animator, u11.animationName, 0);
    AnimationModule.PlayAnim(u11.animator, u11.animationName, u11.animationSpeed, u11.animationKeyframeNames, u11.animationKeyframeFunctions, u11.animationPriority, u11.animationFadeTime);
    SkillAnimationTrackOwner.claim(u11.animator, u11.animationName, u11);
    local v14 = AnimationModule.GetCachedTrack(u11.animator, u11.animationName);

    if v14 then
        v14.Looped = u11.animationLoop == true;
    end;

    local v15 = u11.actionInfo.startTime or 0;
    local u16 = (type(p12) == "number" and p12 and p12 or 0) - v15;

    if u16 > 0.001 and (u11.animator and u11.animationName) then
        AnimationModule.SetAnimationTimePosition(u11.animator, u11.animationName, u16);
        task.defer(function() -- Line: 102
            -- upvalues: u11 (copy), AnimationModule (ref), u16 (copy)
            if not (u11.animator and (u11.animator.Parent and u11.animationName)) then
                return;
            end;

            AnimationModule.SetAnimationTimePosition(u11.animator, u11.animationName, u16);
        end);
    end;
end;

function v1.OnOver(p17, p18) -- Line: 111
    -- upvalues: SkillAnimationTrackOwner (copy), SkillActionLock (copy), AnimationModule (copy)
    local animator = p17.animator;
    local animationName = p17.animationName;
    local v19;

    if animator then
        if animationName then
            v19 = SkillAnimationTrackOwner.isOwner(animator, animationName, p17);
        else
            v19 = animationName;
        end;
    else
        v19 = animator;
    end;

    if v19 then
        SkillActionLock.turn_Off_Action_Lock(p17.baseSkill.character);
    end;

    if p17.baseSkill and p17.baseSkill._presentationPredictAnimHandoff then
        p17.baseSkill._presentationPredictAnimHandoff = false;
        SkillAnimationTrackOwner.release(animator, animationName, p17);

        return;
    end;

    if not v19 then
        SkillAnimationTrackOwner.release(animator, animationName, p17);

        return;
    end;

    SkillAnimationTrackOwner.release(animator, animationName, p17);
    AnimationModule.StopAnim(animator, animationName, p17.animationFadeTime or 0);
end;

return v1;