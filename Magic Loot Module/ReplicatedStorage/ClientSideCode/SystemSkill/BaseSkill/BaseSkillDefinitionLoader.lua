-- Decompiled with Potassium's decompiler.

local SkillModuleValidator = require(script.Parent.SkillModuleValidator);
local v1 = {};
local u2 = {};

local function getBaseSkillFolder() -- Line: 16
    return script.Parent.Parent.SkillModule;
end;

function v1.load(p3) -- Line: 25
    -- upvalues: u2 (copy), SkillModuleValidator (copy)
    if u2[p3] then
        return u2[p3];
    end;

    local v4 = script.Parent.Parent.SkillModule:FindFirstChild(p3);

    if not (v4 and v4:IsA("ModuleScript")) then
        return nil, ("技能模块 \'%s\' 未找到（目录或资源未同步）"):format(p3);
    end;

    local success, result = pcall(require, v4);

    if not success then
        return nil, ("技能模块 \'%s\' require 失败: %s"):format(p3, (tostring(result)));
    end;

    local v5, v6 = SkillModuleValidator.validateForRelease("BaseSkill", result, {
        env = "production",
        skillName = p3,
        moduleScriptName = v4.Name,
        suppressions = result.suppressions
    });

    if v5 then
        local v7 = {
            skillModule = result,
            skillName = p3
        };
        u2[p3] = v7;

        return v7;
    end;

    SkillModuleValidator.failOnError(p3, v6, true);
    local v8 = false;

    for _, v in ipairs(v6 or {}) do
        if type(v) == "string" and (v:find("States") or v:find("InitialState")) then
            v8 = true;
            break;
        end;
    end;

    local v9 = nil;

    if v8 then
        return v9, "校验失败：仅支持状态机范式，必须定义 States + InitialState";
    end;

    return v9, ("校验失败：%s"):format(v6 and v6[1] or "未知");
end;

function v1.clearCache() -- Line: 70
    -- upvalues: u2 (copy)
    table.clear(u2);
end;

return v1;