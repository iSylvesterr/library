-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ResRestore = UtilsSystem.ResRestore;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local v1 = {};
local u2 = {};

local function getSystemSkillFolders() -- Line: 45
    -- upvalues: ReplicatedStorage (copy)
    local ClientSideCode = ReplicatedStorage:FindFirstChild("ClientSideCode");

    if ClientSideCode then
        ClientSideCode = ClientSideCode:FindFirstChild("SystemSkill");
    end;

    if ClientSideCode then
        return ClientSideCode:FindFirstChild("GroupSkillModule"), ClientSideCode:FindFirstChild("SkillModule");
    end;

    return nil, nil;
end;

local function resolvePreloadApi(p3) -- Line: 60
    -- upvalues: ReplicatedStorage (copy), ResRestore (copy)
    local ClientSideCode = ReplicatedStorage:FindFirstChild("ClientSideCode");

    if ClientSideCode then
        ClientSideCode = ClientSideCode:FindFirstChild("SystemSkill");
    end;

    local v4, v5;

    if ClientSideCode then
        v4 = ClientSideCode:FindFirstChild("GroupSkillModule");
        v5 = ClientSideCode:FindFirstChild("SkillModule");
    else
        v4 = nil;
        v5 = nil;
    end;

    if v4 and v4:FindFirstChild(p3) then
        return ResRestore.PreloadSkill;
    end;

    if v5 and v5:FindFirstChild(p3) then
        return ResRestore.PreloadBaseSkill;
    end;

    return nil;
end;

local function skillTableIdToScriptName(p6) -- Line: 77
    -- upvalues: CfgFind (copy), EnumMgr (copy)
    local v7 = CfgFind.FindCfgByID(p6, EnumMgr.ItemType.Skill);

    if v7 and (type(v7.ScriptName) == "string" and v7.ScriptName ~= "") then
        return v7.ScriptName;
    end;

    return nil;
end;

local function normalizeRequestEntry(p8) -- Line: 91
    if type(p8) == "number" then
        return "n:" .. tostring(p8);
    end;

    if p8 == "" then
        return "";
    end;

    local v9 = string.match(p8, "^%d+$") and tonumber(p8);

    if v9 then
        return "n:" .. tostring(v9);
    end;

    return "s:" .. p8;
end;

local function resolveScriptName(p10) -- Line: 114
    -- upvalues: CfgFind (copy), EnumMgr (copy)
    if type(p10) == "number" then
        local v11 = CfgFind.FindCfgByID(p10, EnumMgr.ItemType.Skill);

        if v11 and (type(v11.ScriptName) == "string" and v11.ScriptName ~= "") then
            return v11.ScriptName;
        end;

        return nil;
    end;

    local v12 = string.match(p10, "^%d+$") and tonumber(p10);

    if not v12 then
        return p10;
    end;

    local v13 = CfgFind.FindCfgByID(v12, EnumMgr.ItemType.Skill);

    if v13 and (type(v13.ScriptName) == "string" and v13.ScriptName ~= "") then
        return v13.ScriptName;
    end;

    return nil;
end;

function v1.handle(p14) -- Line: 133
    -- upvalues: u2 (copy), CfgFind (copy), EnumMgr (copy), ReplicatedStorage (copy), ResRestore (copy)
    for _, v in p14 do
        local v15;

        if type(v) == "number" then
            v15 = "n:" .. tostring(v);
        elseif v == "" then
            v15 = "";
        else
            local v16 = string.match(v, "^%d+$") and tonumber(v);

            if v16 then
                v15 = "n:" .. tostring(v16);
            else
                v15 = "s:" .. v;
            end;
        end;

        if v15 ~= "" and not u2[v15] then
            local v17;

            if type(v) == "number" then
                local v18 = CfgFind.FindCfgByID(v, EnumMgr.ItemType.Skill);

                if v18 and (type(v18.ScriptName) == "string" and v18.ScriptName ~= "") then
                    v17 = v18.ScriptName;
                else
                    v17 = nil;
                end;
            elseif string.match(v, "^%d+$") then
                local v19 = tonumber(v);

                if v19 then
                    local v20 = CfgFind.FindCfgByID(v19, EnumMgr.ItemType.Skill);

                    if v20 and (type(v20.ScriptName) == "string" and v20.ScriptName ~= "") then
                        v17 = v20.ScriptName;
                    else
                        v17 = nil;
                    end;
                else
                    v17 = v;
                end;
            else
                v17 = v;
            end;

            if v17 then
                local ClientSideCode = ReplicatedStorage:FindFirstChild("ClientSideCode");

                if ClientSideCode then
                    ClientSideCode = ClientSideCode:FindFirstChild("SystemSkill");
                end;

                local v21, v22;

                if ClientSideCode then
                    v21 = ClientSideCode:FindFirstChild("GroupSkillModule");
                    v22 = ClientSideCode:FindFirstChild("SkillModule");
                else
                    v21 = nil;
                    v22 = nil;
                end;

                local v23;

                if v21 and v21:FindFirstChild(v17) then
                    v23 = ResRestore.PreloadSkill;
                elseif v22 and v22:FindFirstChild(v17) then
                    v23 = ResRestore.PreloadBaseSkill;
                else
                    v23 = nil;
                end;

                if v23 then
                    u2[v15] = true;
                    v23(v17);
                else
                    warn("[SkillResPreload] 未找到组技能或基础技能模块:", v17);
                end;
            else
                warn("[SkillResPreload] 无法解析技能 ScriptName:", v);
            end;
        end;
    end;
end;

return v1;