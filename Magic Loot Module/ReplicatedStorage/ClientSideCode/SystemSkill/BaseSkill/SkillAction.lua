-- Decompiled with Potassium's decompiler.

require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillActionControl = require(script.Parent.SkillActionControl);
local SkillActionExclusive = require(script.SkillActionExclusive);
local ReleasePlayerOnlyPolicy = require(script.Parent.ReleasePlayerOnlyPolicy);
local AnimationPlaySide = require(script.Parent.AnimationPlaySide);
local SkillAction = script.Parent.SkillAction;
local AutoCastLookAt = require(script.Parent.AutoCastLookAt);
local u1 = {};
u1.__index = u1;

function u1.new(p2, p3) -- Line: 34
    -- upvalues: u1 (copy), AutoCastLookAt (copy), AnimationPlaySide (copy), SkillAction (copy), SkillActionControl (copy), ReleasePlayerOnlyPolicy (copy)
    local v4 = setmetatable({}, u1);
    local v5 = (p3 or {}).serverMode == true;
    v4.allActions = {};

    for _, v in p2.skillModule.Action or {} do
        if v5 or (v.action ~= "LookAt" or not AutoCastLookAt.shouldSuppressSkillLookAt()) then
            local v6, v7, v8;

            if v5 then
                if v.action == "Animation" then
                    v6 = require(SkillAction[v.action]);
                    v7 = table.clone(v6);
                    v8 = setmetatable(v7, {
                        __index = SkillActionControl
                    });

                    if not (v8.playerSubjectOnly and ReleasePlayerOnlyPolicy.isMonsterOrSyncedNonPlayerSubjectSkill(p2)) and (v5 or (not v8.isReleasePlayerOnly or ReleasePlayerOnlyPolicy.shouldRunReleasePlayerOnlyActions(p2))) then
                        v8.baseSkill = p2;
                        v8.actionInfo = v;

                        if v8.Create then
                            v8:Create(v);
                        end;

                        table.insert(v4.allActions, v8);
                    end;
                end;
            elseif v.action ~= "Animation" or not AnimationPlaySide.shouldSkipClientAnimation(p2) then
                v6 = require(SkillAction[v.action]);
                v7 = table.clone(v6);
                v8 = setmetatable(v7, {
                    __index = SkillActionControl
                });

                if not (v8.playerSubjectOnly and ReleasePlayerOnlyPolicy.isMonsterOrSyncedNonPlayerSubjectSkill(p2)) and (v5 or (not v8.isReleasePlayerOnly or ReleasePlayerOnlyPolicy.shouldRunReleasePlayerOnlyActions(p2))) then
                    v8.baseSkill = p2;
                    v8.actionInfo = v;

                    if v8.Create then
                        v8:Create(v);
                    end;

                    table.insert(v4.allActions, v8);
                end;
            end;
        end;
    end;

    return v4;
end;

function u1.Init(p9) -- Line: 75
    for _, v in p9.allActions do
        v:Init();
        v._destroyed = false;
    end;
end;

function u1.Start(p10, p11) -- Line: 86
    -- upvalues: SkillActionExclusive (copy), SkillActionControl (copy)
    for _, v in p10.allActions do
        SkillActionExclusive.beforeStart(v);
        v:Start(p11);
        v.state = SkillActionControl.StateEnum.Play;
    end;
end;

function u1.startOrCatchUpAtTime(p12, p13) -- Line: 97
    -- upvalues: SkillActionControl (copy), SkillActionExclusive (copy)
    local StateEnum = SkillActionControl.StateEnum;

    for _, v in p12.allActions do
        local v14 = v.startTime or 0;
        local overTime = v.overTime;

        if type(overTime) == "number" and (overTime > 0 and overTime <= p13) then
            SkillActionExclusive.beforeStart(v);
            v:Start(p13);
            v:Over(p13);
            v.state = StateEnum.Over;
        elseif v14 <= p13 then
            SkillActionExclusive.beforeStart(v);
            v:Start(p13);
            v.state = StateEnum.Play;

            if v.Run then
                v:Run(p13);
            end;

            if type(overTime) == "number" and (overTime > 0 and overTime <= p13) then
                v:Over(p13);
                v.state = StateEnum.Over;
            end;
        else
            v.state = StateEnum.NoStart;
        end;
    end;
end;

function u1.Over(p15, p16) -- Line: 128
    for _, v in p15.allActions do
        v:Over(p16);
    end;
end;

function u1.Destroy(p17) -- Line: 137
    for _, v in p17.allActions do
        v:Destroy();
    end;
end;

function u1.AreAllActionsOver(p18) -- Line: 147
    -- upvalues: SkillActionControl (copy)
    for _, v in p18.allActions do
        if v.state ~= SkillActionControl.StateEnum.Over then
            return false;
        end;
    end;

    return true;
end;

function u1.Run(p19, p20) -- Line: 161
    -- upvalues: SkillActionControl (copy), SkillActionExclusive (copy)
    for _, v in p19.allActions do
        if v.state == SkillActionControl.StateEnum.NoStart then
            if v.startTime <= p20 and p20 < v.overTime then
                SkillActionExclusive.beforeStart(v);
                v:Start(p20);
                v.state = SkillActionControl.StateEnum.Play;
            end;
        elseif v.state == SkillActionControl.StateEnum.Play then
            if v.overTime > 0 and v.overTime <= p20 then
                v:Over(p20);
            else
                v:Run(p20);
            end;
        end;
    end;
end;

return u1;