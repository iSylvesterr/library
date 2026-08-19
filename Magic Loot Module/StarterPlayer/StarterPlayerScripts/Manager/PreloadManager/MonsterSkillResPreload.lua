-- Decompiled with Potassium's decompiler.

local ReplicatedFirst = game:GetService("ReplicatedFirst");
local UtilsSystem = require(ReplicatedFirst.AllSideCode.UtilsSystem);
local ConfigInstance = require(ReplicatedFirst.AllSideCode.ToolBasic.ConfigInstance);
local SkillResPreload = require(script.Parent.SkillResPreload);
local _ = UtilsSystem.CfgFind;
local v1 = {};

local function normalizeSkillList(p2) -- Line: 21
    if p2 == nil then
        return {};
    end;

    if type(p2) == "number" then
        return { p2 };
    end;

    if type(p2) ~= "table" then
        return {};
    end;

    local v3 = {};

    for _, v in p2 do
        if type(v) == "number" and v > 0 then
            table.insert(v3, v);
        end;
    end;

    return v3;
end;

local function collectAllMonsterSkillIds() -- Line: 41
    -- upvalues: ConfigInstance (copy), normalizeSkillList (copy)
    local v4 = {};
    local v5 = {};

    for _, v in pairs(ConfigInstance.enemyConf) do
        if type(v) == "table" then
            for _, v2 in normalizeSkillList(v.skill) do
                if not v4[v2] then
                    v4[v2] = true;
                    table.insert(v5, v2);
                end;
            end;
        end;
    end;

    return v5;
end;

function v1.handle() -- Line: 63
    -- upvalues: collectAllMonsterSkillIds (copy), SkillResPreload (copy)
    local v6 = collectAllMonsterSkillIds();

    if #v6 == 0 then
        return;
    end;

    SkillResPreload.handle(v6);
end;

return v1;