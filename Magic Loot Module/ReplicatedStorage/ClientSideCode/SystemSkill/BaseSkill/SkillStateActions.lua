-- Decompiled with Potassium's decompiler.

local SkillAction = script.Parent.SkillAction;
local SkillActionControl = require(script.Parent.SkillActionControl);
local SkillActionExclusive = require(script.Parent.SkillAction.SkillActionExclusive);
local ReleasePlayerOnlyPolicy = require(script.Parent.ReleasePlayerOnlyPolicy);
local AutoCastLookAt = require(script.Parent.AutoCastLookAt);
local u1 = {};

local function getStore(p2) -- Line: 22
    local skillRunData = p2.skillRunData;

    if not skillRunData then
        error("[SkillStateActions] skillRunData 缺失");
    end;

    if not skillRunData._skillStateActions then
        skillRunData._skillStateActions = {
            activeStateName = nil,
            instances = {}
        };
    end;

    return skillRunData._skillStateActions;
end;

local function toGlobalTimeline(p3, p4) -- Line: 39
    local v5 = tonumber(p4.startTime) or 0;
    local overTime = p4.overTime;
    local v6 = p3 + v5;

    if type(overTime) ~= "number" then
        return v6, -1;
    end;

    if overTime < 0 then
        return v6, -1;
    end;

    if overTime < v5 then
        return v6, v6 + 0.001;
    end;

    return v6, p3 + overTime;
end;

local function buildInstancesForState(p7, p8) -- Line: 56
    -- upvalues: AutoCastLookAt (copy), SkillAction (copy), SkillActionControl (copy), ReleasePlayerOnlyPolicy (copy)
    local v9 = {};
    local v10 = p7.skillModule.StateActions and p7.skillModule.StateActions[p8];

    if type(v10) ~= "table" then
        return v9;
    end;

    for _, v in ipairs(v10) do
        if type(v) == "table" then
            local v11 = table.clone(v);
            local v12 = p7.skillRunData and p7.skillRunData.State and p7.skillRunData.State.enteredAt or p7.nowTime;
            local v13 = tonumber(v11.startTime) or 0;
            local overTime = v11.overTime;
            local v14 = v12 + v13;
            local v15;

            if type(overTime) == "number" and overTime >= 0 then
                if overTime < v13 then
                    v15 = v14 + 0.001;
                else
                    v15 = v12 + overTime;
                end;
            else
                v15 = -1;
            end;

            v11.startTime = v14;
            v11.overTime = v15;
            local action = v11.action;

            if type(action) == "string" then
                if action ~= "LookAt" or not AutoCastLookAt.shouldSuppressSkillLookAt() then
                    local v16 = SkillAction:FindFirstChild(action);

                    if v16 and v16:IsA("ModuleScript") then
                        local v17 = require(v16);
                        local v18 = table.clone(v17);
                        local v19 = setmetatable(v18, {
                            __index = SkillActionControl
                        });
                        local v20 = v19.playerSubjectOnly and ReleasePlayerOnlyPolicy.isMonsterOrSyncedNonPlayerSubjectSkill(p7);

                        if not v20 then
                            if not v19.isReleasePlayerOnly or ReleasePlayerOnlyPolicy.shouldRunReleasePlayerOnlyActions(p7) then
                                v19.baseSkill = p7;
                                v19.actionInfo = v11;
                                v19._skillStateOwned = p8;

                                if v19.Create then
                                    v19:Create(v11);
                                end;

                                table.insert(v9, v19);
                            end;
                        end;
                    else
                        warn("[SkillStateActions]", p7.skillName, p8, "未知 Action:", action);
                    end;
                end;
            else
                warn("[SkillStateActions]", p7.skillName, p8, "Action 条目缺少 action 字段");
            end;
        end;
    end;

    return v9;
end;

function u1.exitForState(p21, p22) -- Line: 106
    if p21._destroyed or not p22 then
        return;
    end;

    local skillRunData = p21.skillRunData;

    if not (skillRunData and skillRunData._skillStateActions) then
        return;
    end;

    local _skillStateActions = skillRunData._skillStateActions;

    if _skillStateActions.activeStateName ~= p22 then
        return;
    end;

    for _, v in ipairs(_skillStateActions.instances) do
        pcall(function() -- Line: 119
            -- upvalues: v (copy)
            v:Destroy();
        end);
    end;

    _skillStateActions.instances = {};
    _skillStateActions.activeStateName = nil;
end;

function u1.enterForState(p23, p24) -- Line: 127
    -- upvalues: getStore (copy), u1 (copy), buildInstancesForState (copy), SkillActionExclusive (copy), SkillActionControl (copy)
    if p23._destroyed then
        return;
    end;

    if not p24 or type(p23.skillModule.StateActions) ~= "table" then
        return;
    end;

    local skillRunData = p23.skillRunData;

    if not (skillRunData and skillRunData.State) then
        return;
    end;

    local v25 = getStore(p23);

    if v25.activeStateName == p24 and #v25.instances > 0 then
        return;
    end;

    u1.exitForState(p23, v25.activeStateName);
    v25.instances = buildInstancesForState(p23, p24);
    v25.activeStateName = p24;

    if #v25.instances == 0 then
        v25.activeStateName = nil;

        return;
    end;

    for _, v in ipairs(v25.instances) do
        v:Init();
        v._destroyed = false;
    end;

    local nowTime = p23.nowTime;

    for _, v in ipairs(v25.instances) do
        SkillActionExclusive.beforeStart(v);
        v:Start(nowTime);
        v.state = SkillActionControl.StateEnum.Play;
    end;
end;

function u1.run(p26, p27) -- Line: 166
    -- upvalues: SkillActionControl (copy), SkillActionExclusive (copy)
    local skillRunData = p26.skillRunData;

    if not (skillRunData and skillRunData._skillStateActions) then
        return;
    end;

    for _, v in ipairs(skillRunData._skillStateActions.instances) do
        if v.state == SkillActionControl.StateEnum.NoStart then
            if (v.startTime or 0) <= p27 then
                local overTime = v.overTime;

                if (overTime == nil or type(overTime) ~= "number") and true or overTime < 0 or p27 < overTime then
                    SkillActionExclusive.beforeStart(v);
                    v:Start(p27);
                    v.state = SkillActionControl.StateEnum.Play;
                end;
            end;
        elseif v.state == SkillActionControl.StateEnum.Play then
            local overTime = v.overTime;

            if (overTime == nil or type(overTime) ~= "number") and true or overTime < 0 or (overTime <= 0 or overTime > p27) then
                if v.Run then
                    v:Run(p27);
                end;
            else
                v:Over(p27);
            end;
        end;
    end;
end;

function u1.overAll(p28, p29) -- Line: 199
    local u30 = p29 or p28.nowTime;
    local skillRunData = p28.skillRunData;

    if p28._destroyed or not (skillRunData and skillRunData._skillStateActions) then
        return;
    end;

    for _, v in ipairs(skillRunData._skillStateActions.instances) do
        pcall(function() -- Line: 207
            -- upvalues: v (copy), u30 (copy)
            v:Over(u30);
        end);
    end;
end;

function u1.destroyAll(p31) -- Line: 213
    local skillRunData = p31.skillRunData;

    if not (skillRunData and skillRunData._skillStateActions) then
        return;
    end;

    local _skillStateActions = skillRunData._skillStateActions;

    for _, v in ipairs(_skillStateActions.instances) do
        pcall(function() -- Line: 220
            -- upvalues: v (copy)
            v:Destroy();
        end);
    end;

    _skillStateActions.instances = {};
    _skillStateActions.activeStateName = nil;
end;

function u1.areAllOver(p32) -- Line: 231
    -- upvalues: SkillActionControl (copy)
    local skillRunData = p32.skillRunData;

    if not (skillRunData and skillRunData._skillStateActions) then
        return true;
    end;

    for _, v in ipairs(skillRunData._skillStateActions.instances) do
        if v.state ~= SkillActionControl.StateEnum.Over then
            return false;
        end;
    end;

    return true;
end;

return u1;