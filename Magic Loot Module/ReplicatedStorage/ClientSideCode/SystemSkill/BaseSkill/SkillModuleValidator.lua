-- Decompiled with Potassium's decompiler.

local SkillStateMachine = require(script.Parent.SkillStateMachine);
local u1 = {
    WARNING_CODES = {
        TransitionFuncCondition = "TransitionFuncCondition",
        SkillFuncCondition = "SkillFuncCondition",
        SkillLiteralTrueAlways = "SkillLiteralTrueAlways",
        WindowOrderRisk = "WindowOrderRisk"
    },
    WARNING_SEVERITY = {
        warn = "warn",
        block_production = "block_production"
    }
};

local function addError(p2, p3) -- Line: 38
    table.insert(p2, p3);
end;

local function addWarning(p4, p5, p6, p7) -- Line: 49
    -- upvalues: u1 (copy)
    if not p4 then
        return;
    end;

    table.insert(p4, {
        code = p5,
        message = p6,
        severity = p7 or u1.WARNING_SEVERITY.warn
    });
end;

local function formatWarning(p8) -- Line: 58
    if type(p8) == "string" then
        return p8;
    end;

    if type(p8) == "table" and p8.message then
        return ("[%s] %s"):format(p8.code or "?", p8.message);
    end;

    return tostring(p8);
end;

local function isWarningSuppressed(p9, p10) -- Line: 67
    if type(p9) ~= "table" or not p9.code then
        return false;
    end;

    if not p10 then
        return false;
    end;

    local v11 = p10[p9.code];
    local v12;

    if v11 == true then
        v12 = true;
    elseif type(v11) == "string" then
        v12 = v11 ~= "";
    else
        v12 = false;
    end;

    return v12;
end;

local function shouldBlockInProduction(p13, p14) -- Line: 74
    -- upvalues: u1 (copy)
    if p14 ~= "production" then
        return false;
    end;

    local v15;

    if type(p13) == "table" then
        v15 = p13.severity == u1.WARNING_SEVERITY.block_production;
    else
        v15 = false;
    end;

    return v15;
end;

local function validateModuleNameConsistency(p16, p17, p18) -- Line: 85
    if type(p16) ~= "string" then
        return;
    end;

    if p17 then
        p17 = p17.Data;
    end;

    if not p17 then
        return;
    end;

    local skillName = p17.skillName;

    if type(skillName) == "string" and skillName ~= "" then
        if skillName ~= p16 then
            table.insert(p18, ("Data.skillName 与模块名不一致：module=%s data=%s"):format(p16, skillName));
        end;

        return;
    end;

    table.insert(p18, ("Data.skillName 缺失：期望=%s"):format(p16));
end;

function u1.validateStates(p19, p20) -- Line: 107
    if not p19.States then
        table.insert(p20, "States 缺失");

        return false;
    end;

    if type(p19.States) == "table" then
        return true;
    end;

    table.insert(p20, "States 必须为 table");

    return false;
end;

function u1.validateInitialState(p21, p22) -- Line: 122
    if not p21.InitialState then
        table.insert(p22, "InitialState 缺失");

        return false;
    end;

    if p21.States and p21.States[p21.InitialState] then
        return true;
    end;

    local v23 = ("InitialState \'%s\' 不存在于 States"):format((tostring(p21.InitialState)));
    table.insert(p22, v23);

    return false;
end;

function u1.validateTransitions(p24, p25, p26) -- Line: 139
    -- upvalues: u1 (copy)
    local v27 = p24.States or {};
    local Transitions = p24.Transitions;

    if not Transitions then
        return true;
    end;

    if type(Transitions) ~= "table" then
        table.insert(p25, "Transitions 必须为 table");

        return false;
    end;

    local v28 = false;

    for _, v in ipairs(Transitions) do
        if v.From and not v27[v.From] then
            local v29 = ("Transition From \'%s\' 不存在于 States"):format((tostring(v.From)));
            table.insert(p25, v29);
            v28 = true;
        end;

        if v.To and not v27[v.To] then
            local v30 = ("Transition To \'%s\' 不存在于 States"):format((tostring(v.To)));
            table.insert(p25, v30);
            v28 = true;
        end;

        if type(v.Condition) == "function" then
            local TransitionFuncCondition = u1.WARNING_CODES.TransitionFuncCondition;
            local v31 = ("Transition %s->%s Event=%s 使用 function Condition，无法静态验证"):format(tostring(v.From), tostring(v.To), (tostring(v.Event)));
            local warn2 = u1.WARNING_SEVERITY.warn;

            if p26 then
                table.insert(p26, {
                    code = TransitionFuncCondition,
                    message = v31,
                    severity = warn2 or u1.WARNING_SEVERITY.warn
                });
            end;
        end;
    end;

    return not v28;
end;

function u1.validateStateOrder(p32, p33) -- Line: 175
    local StateOrder = p32.StateOrder;

    if not StateOrder then
        return true;
    end;

    if type(StateOrder) ~= "table" then
        table.insert(p33, "StateOrder 必须为 table");

        return false;
    end;

    local v34 = p32.States or {};
    local v35 = false;

    for i, _ in pairs(StateOrder) do
        if not v34[i] then
            local v36 = ("StateOrder 引用状态 \'%s\' 不存在于 States"):format((tostring(i)));
            table.insert(p33, v36);
            v35 = true;
        end;
    end;

    return not v35;
end;

function u1.validateStateGraph(p37, p38, p39) -- Line: 199
    -- upvalues: SkillStateMachine (copy)
    if not (p37.States and p37.InitialState) then
        return;
    end;

    SkillStateMachine.validateStateGraph(p37, p38);
end;

function u1.validateStateActions(p40, p41) -- Line: 209
    local StateActions = p40.StateActions;

    if StateActions == nil then
        return true;
    end;

    if type(StateActions) ~= "table" then
        table.insert(p41, "StateActions 必须为 table");

        return false;
    end;

    local States = p40.States;
    local SkillAction = script.Parent.SkillAction;

    for i, v in pairs(StateActions) do
        if type(i) == "string" then
            if not (States and States[i]) then
                local v42 = ("StateActions[\'%s\'] 不是合法状态名"):format(i);
                table.insert(p41, v42);
            end;
        else
            local v43 = ("StateActions 状态键必须为 string，当前为 %s"):format((tostring(i)));
            table.insert(p41, v43);
        end;

        if type(v) == "table" then
            for i2, v2 in ipairs(v) do
                if type(v2) == "table" then
                    if type(v2.action) == "string" and v2.action ~= "" then
                        local v44 = SkillAction:FindFirstChild(v2.action);

                        if not (v44 and v44:IsA("ModuleScript")) then
                            local v45 = ("StateActions[\'%s\'][%d] 未知 action \'%s\'"):format(i, i2, v2.action);
                            table.insert(p41, v45);
                        end;
                    else
                        local v46 = ("StateActions[\'%s\'][%d].action 非法"):format(i, i2);
                        table.insert(p41, v46);
                    end;
                else
                    local v47 = ("StateActions[\'%s\'][%d] 必须为 table"):format(i, i2);
                    table.insert(p41, v47);
                end;
            end;
        else
            local v48 = ("StateActions[\'%s\'] 必须为数组"):format((tostring(i)));
            table.insert(p41, v48);
        end;
    end;

    return true;
end;

local AnimationPlaySide = require(script.Parent.AnimationPlaySide);

function u1.validateAnimationPlaySide(p49, p50) -- Line: 251
    -- upvalues: AnimationPlaySide (copy)
    local animationPlaySide = p49.animationPlaySide;

    if animationPlaySide == nil then
        return true;
    end;

    if not AnimationPlaySide.isValidConfiguredSide(animationPlaySide) then
        local v51 = ("animationPlaySide 必须为 \"Client\" 或 \"Server\"，当前为 %s"):format((tostring(animationPlaySide)));
        table.insert(p50, v51);
    end;

    return true;
end;

function u1.validateWindows(p52, p53, p54) -- Line: 270
    local ChainWindows = p52.ChainWindows;

    if not ChainWindows then
        return true;
    end;

    if type(ChainWindows) ~= "table" then
        table.insert(p53, "ChainWindows 必须为 table");

        return false;
    end;

    local v55 = p52.Skill or {};
    local v56 = 0;

    for i in pairs(v55) do
        if type(i) == "number" and i > 0 then
            v56 = math.max(v56, i);
        end;
    end;

    local v57 = false;

    for i, v in pairs(ChainWindows) do
        if v and type(v) == "table" then
            local open = v.open;
            local close = v.close;

            if open and type(open) == "table" then
                if not open.state then
                    local v58 = ("ChainWindows[\'%s\'].open.state 缺失"):format((tostring(i)));
                    table.insert(p53, v58);
                    v57 = true;
                end;
            else
                local v59 = ("ChainWindows[\'%s\'].open 缺失"):format((tostring(i)));
                table.insert(p53, v59);
                v57 = true;
            end;

            if close and type(close) == "table" then
                if not close.state then
                    local v60 = ("ChainWindows[\'%s\'].close.state 缺失"):format((tostring(i)));
                    table.insert(p53, v60);
                    v57 = true;
                end;
            else
                local v61 = ("ChainWindows[\'%s\'].close 缺失"):format((tostring(i)));
                table.insert(p53, v61);
                v57 = true;
            end;

            local baseSkillName = v.baseSkillName;

            if not baseSkillName and type(v.baseSkillIndex) == "number" then
                baseSkillName = v55[v.baseSkillIndex];

                if baseSkillName then
                    baseSkillName = baseSkillName.baseSkillName;
                end;
            end;

            if not baseSkillName and v56 == 1 then
                for _, v2 in pairs(v55) do
                    if v2 and v2.baseSkillName then
                        baseSkillName = v2.baseSkillName;
                        break;
                    end;
                end;
            end;

            if v56 > 1 and not baseSkillName then
                local v62 = ("ChainWindows[\'%s\'] 缺少 baseSkillName 或 baseSkillIndex，多段技能需显式指定归属"):format((tostring(i)));
                table.insert(p53, v62);
                v57 = true;
            end;

            if p54 and (baseSkillName and (open and (open.state and (close and close.state)))) then
                local v63 = p54(baseSkillName);

                if v63 and v63.StateOrder then
                    if not v63.StateOrder[open.state] then
                        local v64 = ("ChainWindows[\'%s\'].open.state \'%s\' 不存在于 %s.StateOrder"):format(tostring(i), tostring(open.state), (tostring(baseSkillName)));
                        table.insert(p53, v64);
                        v57 = true;
                    end;

                    if not v63.StateOrder[close.state] then
                        local v65 = ("ChainWindows[\'%s\'].close.state \'%s\' 不存在于 %s.StateOrder"):format(tostring(i), tostring(close.state), (tostring(baseSkillName)));
                        table.insert(p53, v65);
                        v57 = true;
                    end;

                    local v66 = v63.States or {};

                    if v66[open.state] and v66[open.state].IsTerminal == true then
                        local v67 = ("ChainWindows[\'%s\'].open.state \'%s\' 为终态，窗口不能以终态为起点"):format(tostring(i), (tostring(open.state)));
                        table.insert(p53, v67);
                        v57 = true;
                    end;

                    if v66[close.state] and v66[close.state].IsTerminal == true then
                        local v68 = ("ChainWindows[\'%s\'].close.state \'%s\' 为终态，窗口不能以终态为终点"):format(tostring(i), (tostring(close.state)));
                        table.insert(p53, v68);
                        v57 = true;
                    end;

                    local v69 = v63.StateOrder and v63.StateOrder[open.state];
                    local v70 = v63.StateOrder and v63.StateOrder[close.state];

                    if v69 ~= nil and (v70 ~= nil and (type(v69) == "number" and type(v70) == "number")) then
                        if v70 < v69 then
                            local v71 = ("ChainWindows[\'%s\'] open.state 顺序 %s >= close.state 顺序 %s，开闭倒挂"):format(tostring(i), tostring(v69), (tostring(v70)));
                            table.insert(p53, v71);
                            v57 = true;
                        elseif v69 == v70 then
                            local v72 = open.elapsed and type(open.elapsed) == "number" and (open.elapsed or 0) or 0;
                            local v73 = close.elapsed and type(close.elapsed) == "number" and (close.elapsed or 0) or 0;

                            if v73 < v72 then
                                local v74 = ("ChainWindows[\'%s\'] 同状态 open.elapsed=%s > close.elapsed=%s"):format(tostring(i), tostring(v72), (tostring(v73)));
                                table.insert(p53, v74);
                                v57 = true;
                            end;
                        end;
                    end;
                end;
            end;
        else
            local v75 = ("ChainWindows[\'%s\'] 配置缺失"):format((tostring(i)));
            table.insert(p53, v75);
            v57 = true;
        end;
    end;

    return not v57;
end;

function u1.validateDeriveList(p76, p77, p78) -- Line: 379
    -- upvalues: u1 (copy)
    local Skill = p76.Skill;

    if not Skill then
        table.insert(p77, "Skill 缺失");

        return false;
    end;

    if type(Skill) ~= "table" then
        table.insert(p77, "Skill 必须为 table");

        return false;
    end;

    local v79 = 0;

    for i, _ in pairs(Skill) do
        if type(i) == "number" and v79 < i then
            v79 = i;
        end;
    end;

    local v80 = false;

    for i = 1, v79 do
        local v81 = Skill[i];

        if v81 then
            if not v81.baseSkillName or type(v81.baseSkillName) ~= "string" then
                local v82 = ("Skill[%d].baseSkillName 缺失或非法"):format(i);
                table.insert(p77, v82);
                v80 = true;
            end;

            if v81.condition ~= nil and (type(v81.condition) ~= "function" and type(v81.condition) ~= "table") then
                local v83 = ("Skill[%d].condition 必须为 function 或声明式 table"):format(i);
                table.insert(p77, v83);
                v80 = true;
            end;

            if type(v81.condition) == "function" then
                local SkillFuncCondition = u1.WARNING_CODES.SkillFuncCondition;
                local v84 = ("Skill[%d] condition 为 function，无法静态验证"):format(i);
                local block_production = u1.WARNING_SEVERITY.block_production;

                if p78 then
                    table.insert(p78, {
                        code = SkillFuncCondition,
                        message = v84,
                        severity = block_production or u1.WARNING_SEVERITY.warn
                    });
                end;
            elseif type(v81.condition) == "table" and (v81.condition.type == "literal" and v81.condition.value == true) then
                local SkillLiteralTrueAlways = u1.WARNING_CODES.SkillLiteralTrueAlways;
                local v85 = ("Skill[%d] condition 为 literal=true，等价于 AlwaysTrue，可能覆盖后续条件"):format(i);
                local block_production = u1.WARNING_SEVERITY.block_production;

                if p78 then
                    table.insert(p78, {
                        code = SkillLiteralTrueAlways,
                        message = v85,
                        severity = block_production or u1.WARNING_SEVERITY.warn
                    });
                end;
            end;
        else
            local v86 = ("Skill[%d] 缺失"):format(i);
            table.insert(p77, v86);
            v80 = true;
        end;
    end;

    return not v80;
end;

function u1.countFunctionConditions(p87) -- Line: 426
    local v88 = 0;

    if p87 then
        p87 = p87.Skill;
    end;

    if type(p87) ~= "table" then
        return 0;
    end;

    for _, v in pairs(p87) do
        if v and type(v.condition) == "function" then
            v88 = v88 + 1;
        end;
    end;

    return v88;
end;

function u1.validateDamageProfiles(p89, p90) -- Line: 442
    local DamageProfiles = p89.DamageProfiles;

    if not DamageProfiles then
        return true;
    end;

    if type(DamageProfiles) ~= "table" then
        table.insert(p90, "DamageProfiles 必须为 table");

        return false;
    end;

    local hitboxConfig = p89.hitboxConfig;

    if type(hitboxConfig) == "table" then
        for i, v in ipairs(hitboxConfig) do
            if type(v) == "table" and type(v.damageProfileId) == "string" then
                local damageProfileId = v.damageProfileId;

                if not DamageProfiles[damageProfileId] then
                    local v91 = ("hitboxConfig[%d].damageProfileId \'%s\' 不存在于 DamageProfiles"):format(i, damageProfileId);
                    table.insert(p90, v91);
                end;
            end;
        end;
    end;

    return true;
end;

function u1.validateProjectileProfiles(p92, p93) -- Line: 470
    local ProjectileProfiles = p92.ProjectileProfiles;

    if not ProjectileProfiles then
        return true;
    end;

    if type(ProjectileProfiles) == "table" then
        for _, v in ipairs({ "projectileProfileId", "impactProfileId", "visualProfileId" }) do
            local v94 = p92[v];

            if type(v94) == "string" and (v94 ~= "" and not ProjectileProfiles[v94]) then
                local v95 = ("%s \'%s\' 不存在于 ProjectileProfiles"):format(v, v94);
                table.insert(p93, v95);
            end;
        end;

        return true;
    end;

    table.insert(p93, "ProjectileProfiles 必须为 table");

    return false;
end;

function u1.validateBaseSkill(p96, p97) -- Line: 497
    -- upvalues: validateModuleNameConsistency (copy), u1 (copy), formatWarning (copy)
    local v98 = {};
    local v99 = p97 and (p97.warnings or {}) or {};
    local v100 = p97 and (p97.skillName or "Unknown") or "Unknown";
    local v101;

    if p97 then
        v101 = p97.moduleScriptName;
    else
        v101 = p97;
    end;

    if type(v101) == "string" then
        validateModuleNameConsistency(v101, p96, v98);
    end;

    u1.validateStates(p96, v98);
    u1.validateInitialState(p96, v98);
    u1.validateTransitions(p96, v98, v99);
    u1.validateStateOrder(p96, v98);
    u1.validateStateGraph(p96, v98, v99);
    u1.validateStateActions(p96, v98);
    u1.validateAnimationPlaySide(p96, v98);
    u1.validateDamageProfiles(p96, v98);
    u1.validateProjectileProfiles(p96, v98);

    if #v98 > 0 then
        return false, v98, v99;
    end;

    local v102;

    if p97 then
        v102 = p97.suppressions;
    else
        v102 = p97;
    end;

    if p97 then
        p97 = p97.env;
    end;

    local v103 = {};

    for _, v in ipairs(v99) do
        local v104;

        if type(v) == "table" and v.code and v102 then
            local v105 = v102[v.code];

            if v105 == true then
                v104 = true;
            elseif type(v105) == "string" then
                v104 = v105 ~= "";
            else
                v104 = false;
            end;
        else
            v104 = false;
        end;

        if not v104 then
            local v106;

            if p97 == "production" and type(v) == "table" then
                v106 = v.severity == u1.WARNING_SEVERITY.block_production;
            else
                v106 = false;
            end;

            if v106 then
                table.insert(v103, formatWarning(v));
            else
                warn(("[SkillModuleValidator] %s: %s"):format(v100, formatWarning(v)));
            end;
        end;
    end;

    if #v103 > 0 then
        return false, v103, v99;
    end;

    return true, {}, v99;
end;

function u1.validateBaseSkillStrict(p107, p108) -- Line: 540
    -- upvalues: u1 (copy), formatWarning (copy)
    local v109, v110, v111 = u1.validateBaseSkill(p107, p108);

    if not v109 then
        return false, v110;
    end;

    if v111 and #v111 > 0 then
        if p108 then
            p108 = p108.suppressions;
        end;

        local v112 = {};

        for _, v in ipairs(v111) do
            local v113;

            if type(v) == "table" and v.code and p108 then
                local v114 = p108[v.code];

                if v114 == true then
                    v113 = true;
                elseif type(v114) == "string" then
                    v113 = v114 ~= "";
                else
                    v113 = false;
                end;
            else
                v113 = false;
            end;

            if not v113 then
                table.insert(v112, formatWarning(v));
            end;
        end;

        if #v112 > 0 then
            return false, v112;
        end;
    end;

    return true, {};
end;

function u1.validateGroupSkill(p115, p116) -- Line: 566
    -- upvalues: validateModuleNameConsistency (copy), u1 (copy), formatWarning (copy)
    local u117 = {};
    local v118 = p116 and (p116.warnings or {}) or {};
    local v119 = p116 and (p116.skillName or "Unknown") or "Unknown";
    local v120;

    if p116 then
        v120 = p116.moduleScriptName;
    else
        v120 = p116;
    end;

    if type(v120) == "string" then
        validateModuleNameConsistency(v120, p115, u117);
    end;

    local function checkOptionalPriorityNumber(p121, p122) -- Line: 574
        -- upvalues: u117 (copy)
        if p122 ~= nil and type(p122) ~= "number" then
            table.insert(u117, p121 .. " 必须为 number");
        end;
    end;

    local InterruptionPriority = p115.InterruptionPriority;

    if InterruptionPriority ~= nil and type(InterruptionPriority) ~= "number" then
        table.insert(u117, "InterruptionPriority 必须为 number");
    end;

    local PriorityInterruption = p115.PriorityInterruption;

    if PriorityInterruption ~= nil and type(PriorityInterruption) ~= "number" then
        table.insert(u117, "PriorityInterruption 必须为 number");
    end;

    if p115.Data and type(p115.Data) == "table" then
        local Data = p115.Data;
        local InterruptionPriority2 = Data.InterruptionPriority;

        if InterruptionPriority2 ~= nil and type(InterruptionPriority2) ~= "number" then
            table.insert(u117, "Data.InterruptionPriority 必须为 number");
        end;

        local interruptionPriority = Data.interruptionPriority;

        if interruptionPriority ~= nil and type(interruptionPriority) ~= "number" then
            table.insert(u117, "Data.interruptionPriority 必须为 number");
        end;
    end;

    u1.validateDeriveList(p115, u117, v118);
    local v123;

    if p116 then
        v123 = p116.resolveBaseSkill;
    else
        v123 = p116;
    end;

    u1.validateWindows(p115, u117, v123);

    if #u117 > 0 then
        return false, u117, v118;
    end;

    local v124;

    if p116 then
        v124 = p116.suppressions;
    else
        v124 = p116;
    end;

    if p116 then
        p116 = p116.env;
    end;

    local v125 = {};

    for _, v in ipairs(v118) do
        local v126;

        if type(v) == "table" and v.code and v124 then
            local v127 = v124[v.code];

            if v127 == true then
                v126 = true;
            elseif type(v127) == "string" then
                v126 = v127 ~= "";
            else
                v126 = false;
            end;
        else
            v126 = false;
        end;

        if not v126 then
            local v128;

            if p116 == "production" and type(v) == "table" then
                v128 = v.severity == u1.WARNING_SEVERITY.block_production;
            else
                v128 = false;
            end;

            if v128 then
                table.insert(v125, formatWarning(v));
            else
                warn(("[SkillModuleValidator] %s: %s"):format(v119, formatWarning(v)));
            end;
        end;
    end;

    if #v125 > 0 then
        return false, v125, v118;
    end;

    return true, {}, v118;
end;

function u1.validateGroupSkillStrict(p129, p130) -- Line: 612
    -- upvalues: u1 (copy), formatWarning (copy)
    local v131, v132, v133 = u1.validateGroupSkill(p129, p130);

    if not v131 then
        return false, v132;
    end;

    if v133 and #v133 > 0 then
        if p130 then
            p130 = p130.suppressions;
        end;

        local v134 = {};

        for _, v in ipairs(v133) do
            local v135;

            if type(v) == "table" and v.code and p130 then
                local v136 = p130[v.code];

                if v136 == true then
                    v135 = true;
                elseif type(v136) == "string" then
                    v135 = v136 ~= "";
                else
                    v135 = false;
                end;
            else
                v135 = false;
            end;

            if not v135 then
                table.insert(v134, formatWarning(v));
            end;
        end;

        if #v134 > 0 then
            return false, v134;
        end;
    end;

    return true, {};
end;

function u1.validateForRelease(p137, p138, p139) -- Line: 639
    -- upvalues: u1 (copy)
    if p137 == "BaseSkill" then
        return u1.validateBaseSkillStrict(p138, p139);
    end;

    if p137 == "GroupSkill" then
        return u1.validateGroupSkillStrict(p138, p139);
    end;

    error("unknown validation kind: " .. tostring(p137));
end;

function u1.validate(p140, p141) -- Line: 654
    -- upvalues: u1 (copy)
    if not p140 or type(p140) ~= "table" then
        return false, { "skillModule 必须为 table" };
    end;

    local v142;

    if p141 then
        v142 = p141.moduleType;
    else
        v142 = p141;
    end;

    if v142 == "GroupSkill" then
        return u1.validateGroupSkill(p140, p141);
    end;

    return u1.validateBaseSkill(p140, p141);
end;

function u1.failOnError(p143, p144, p145) -- Line: 672
    if not p144 or #p144 == 0 then
        return;
    end;

    local v146 = ("[SkillModuleValidator] %s 校验失败:\n  "):format((tostring(p143 or "?"))) .. table.concat(p144, "\n  ");

    if p145 == false then
        warn(v146);

        return;
    end;

    error(v146, 2);
end;

return u1;