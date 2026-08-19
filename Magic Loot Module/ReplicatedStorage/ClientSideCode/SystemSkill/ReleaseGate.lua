-- Decompiled with Potassium's decompiler.

local Tests = require(script.Parent.Tests);
local SkillModuleValidator = require(script.Parent.BaseSkill.SkillModuleValidator);
local SkillDataSchema = require(script.Parent.BaseSkill.SkillDataSchema);
local SkillModule = script.Parent.SkillModule;
local GroupSkillModule = script.Parent.GroupSkillModule;
local v1 = {};

local function classifyBaseSkillType(p2) -- Line: 22
    return p2.States and p2.States.ProjectileFlying and "Projectile" or "Base";
end;

local function hasFunctionCondition(p3, p4) -- Line: 29
    -- upvalues: SkillModuleValidator (copy)
    if p4 == "GroupSkill" then
        return (SkillModuleValidator.countFunctionConditions(p3) or 0) > 0;
    end;

    if p3.Transitions then
        for _, v in ipairs(p3.Transitions) do
            if type(v.Condition) == "function" then
                return true;
            end;
        end;
    end;

    return false;
end;

local function collectAuditRow(p5, p6, p7, p8, p9) -- Line: 41
    -- upvalues: SkillDataSchema (copy), hasFunctionCondition (copy)
    local Name = p5.Name;
    local v10 = p7 == "GroupSkill" and "Group" or (p6.States and p6.States.ProjectileFlying and "Projectile" or "Base");
    local v11 = p6.Data or {};
    local v12 = SkillDataSchema.normalizeSkillData(v11).syncRadius or 120;
    local v13 = hasFunctionCondition(p6, p7);
    local v14;

    if type(v11.suppressions) == "table" then
        v14 = next(v11.suppressions) ~= nil;
    else
        v14 = false;
    end;

    local v15, _ = p8(p6, p9);

    return {
        skillName = Name,
        moduleType = v10,
        syncRadius = v12,
        hasFuncCond = v13,
        hasSuppressions = v14,
        strictOk = v15
    };
end;

local function printSkillAudit(p16, p17) -- Line: 60
    local v18 = {};

    for _, v in ipairs(p16) do
        table.insert(v18, v);
    end;

    for _, v in ipairs(p17) do
        table.insert(v18, v);
    end;

    table.sort(v18, function(p19, p20) -- Line: 64
        return (p19.skillName or "") < (p20.skillName or "");
    end);
    local v21 = { 20, 12, 10, 8, 10, 8 };
    local v22 = { "技能名", "Base/Group/Projectile", "syncRadius", "funcCond", "suppressions", "strictOk" };

    local function pad(p23, p24) -- Line: 68
        local v25 = tostring(p23);

        return v25 .. string.rep(" ", (math.max(0, p24 - #v25)));
    end;

    local v26 = string.rep("-", 70);
    print("\n[ReleaseGate] 技能审计输出");
    print(v26);
    local v27 = print;
    local concat = table.concat;
    local v28 = {};
    local v29 = v21[1];
    local v30 = tostring(v22[1]);
    local v31 = v30 .. string.rep(" ", (math.max(0, v29 - #v30)));
    local v32 = v21[2];
    local v33 = tostring(v22[2]);
    local v34 = v33 .. string.rep(" ", (math.max(0, v32 - #v33)));
    local v35 = v21[3];
    local v36 = tostring(v22[3]);
    local v37 = v36 .. string.rep(" ", (math.max(0, v35 - #v36)));
    local v38 = v21[4];
    local v39 = tostring(v22[4]);
    local v40 = v39 .. string.rep(" ", (math.max(0, v38 - #v39)));
    local v41 = v21[5];
    local v42 = tostring(v22[5]);
    local v43 = v42 .. string.rep(" ", (math.max(0, v41 - #v42)));
    local v44 = v21[6];
    local v45 = tostring(v22[6]);
    v28[1], v28[2], v28[3], v28[4], v28[5], v28[6] = v31, v34, v37, v40, v43, v45 .. string.rep(" ", (math.max(0, v44 - #v45)));
    v27(concat(v28));
    print(v26);

    for _, v in ipairs(v18) do
        local v46 = print;
        local concat2 = table.concat;
        local v47 = {};
        local v48 = v21[1];
        local v49 = tostring(v.skillName);
        local v50 = v49 .. string.rep(" ", (math.max(0, v48 - #v49)));
        local v51 = v21[2];
        local v52 = tostring(v.moduleType);
        local v53 = v52 .. string.rep(" ", (math.max(0, v51 - #v52)));
        local v54 = v21[3];
        local v55 = tostring(v.syncRadius);
        local v56 = v55 .. string.rep(" ", (math.max(0, v54 - #v55)));
        local v57 = v21[4];
        local v58 = tostring(v.hasFuncCond and "Y" or "N");
        local v59 = v58 .. string.rep(" ", (math.max(0, v57 - #v58)));
        local v60 = v21[5];
        local v61 = tostring(v.hasSuppressions and "Y" or "N");
        local v62 = v61 .. string.rep(" ", (math.max(0, v60 - #v61)));
        local v63 = v21[6];
        local v64 = tostring(v.strictOk and "Y" or "N");
        v47[1], v47[2], v47[3], v47[4], v47[5], v47[6] = v50, v53, v56, v59, v62, v64 .. string.rep(" ", (math.max(0, v63 - #v64)));
        v46(concat2(v47));
    end;

    print(v26);
end;

local function validateAllModules(p65, p66, p67, p68, p69) -- Line: 97
    -- upvalues: SkillModule (copy), SkillModuleValidator (copy), collectAuditRow (copy)
    local v70 = {};
    local v71 = p68 or {};

    for _, child in ipairs(p65:GetChildren()) do
        if child:IsA("ModuleScript") then
            local success, result = pcall(require, child);

            if success then
                local v72 = {
                    env = "production",
                    suppressions = nil,
                    skillName = child.Name,
                    moduleScriptName = child.Name
                };

                if p67 == "GroupSkill" then
                    function v72.resolveBaseSkill(p73) -- Line: 113
                        -- upvalues: SkillModule (ref)
                        local v74 = SkillModule:FindFirstChild(p73);

                        if not (v74 and v74:IsA("ModuleScript")) then
                            return nil;
                        end;

                        local success2, result2 = pcall(require, v74);

                        return success2 and result2 and result2 or nil;
                    end;

                    local v75;

                    if result.Data then
                        v75 = result.Data.suppressions or nil;
                    else
                        v75 = nil;
                    end;

                    v72.suppressions = v75;
                    local v76 = SkillModuleValidator.countFunctionConditions(result);

                    if v76 > 0 then
                        v71.functionConditionCount = (v71.functionConditionCount or 0) + v76;
                        v71.functionConditionModules = v71.functionConditionModules or {};
                        table.insert(v71.functionConditionModules, {
                            name = child.Name,
                            count = v76
                        });
                    end;
                end;

                local v77, v78 = p66(result, v72);

                if not v77 then
                    table.insert(v70, ("%s 校验失败: %s"):format(child.Name, table.concat(v78, " | ")));
                end;

                if p69 then
                    local v79 = collectAuditRow(child, result, p67, p66, v72);
                    table.insert(p69, v79);
                end;
            else
                local Name = child.Name;
                local v80 = tostring(result);
                table.insert(v70, ("%s require 失败: %s"):format(Name, v80));
            end;
        end;
    end;

    return v70;
end;

function v1.run() -- Line: 140
    -- upvalues: Tests (copy), validateAllModules (copy), SkillModule (copy), SkillModuleValidator (copy), GroupSkillModule (copy), printSkillAudit (copy)
    local v81 = {};
    local v82 = {
        functionConditionCount = 0,
        functionConditionModules = {}
    };
    local v83 = {};
    local v84 = {};
    local v85 = Tests.runAll();

    if v85.failed ~= 0 then
        table.insert(v81, ("自动化测试失败: %d"):format(v85.failed));
    end;

    local v88 = validateAllModules(SkillModule, function(p86, p87) -- Line: 156
        -- upvalues: SkillModuleValidator (ref)
        return SkillModuleValidator.validateBaseSkillStrict(p86, p87);
    end, "BaseSkill", v82, v83);
    local v91 = validateAllModules(GroupSkillModule, function(p89, p90) -- Line: 166
        -- upvalues: SkillModuleValidator (ref)
        return SkillModuleValidator.validateGroupSkillStrict(p89, p90);
    end, "GroupSkill", v82, v84);

    for _, v in ipairs(v88) do
        table.insert(v81, v);
    end;

    for _, v in ipairs(v91) do
        table.insert(v81, v);
    end;

    printSkillAudit(v83, v84);

    if v82.functionConditionCount and v82.functionConditionCount > 0 then
        local v92 = {};

        for _, v in ipairs(v82.functionConditionModules or {}) do
            table.insert(v92, ("%s(%d)"):format(v.name, v.count));
        end;

        print(("[ReleaseGate] function condition 统计: 共 %d 处，涉及 %s"):format(v82.functionConditionCount, table.concat(v92, ", ")));
    end;

    return {
        ok = #v81 == 0,
        failures = v81,
        testResult = v85,
        functionConditionCount = v82.functionConditionCount or 0,
        functionConditionModules = v82.functionConditionModules or {}
    };
end;

return v1;