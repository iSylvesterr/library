-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local u1 = {};
local u2 = {};
local u3 = {};

local function assertServer() -- Line: 38
    -- upvalues: RunService (copy)
    if not RunService:IsServer() then
        error("[SkillReleaseCrossCheck] 仅服务端可调用", 2);
    end;
end;

local function getCheckFn(p4) -- Line: 44
    local checkOnOtherGroupSkillRelease = p4.checkOnOtherGroupSkillRelease;

    if type(checkOnOtherGroupSkillRelease) == "function" then
        return checkOnOtherGroupSkillRelease;
    end;

    return nil;
end;

local function removeEntryAt(p5, p6) -- Line: 52
    local v7 = #p5;

    if p6 < v7 then
        p5[p6] = p5[v7];
    end;

    p5[v7] = nil;
end;

local function findEntryIndex(p8, p9) -- Line: 60
    for i, v in ipairs(p8) do
        if v.handle == p9 then
            return i;
        end;
    end;

    return nil;
end;

function u3.registerProvider(p10) -- Line: 73
    -- upvalues: u1 (copy)
    if u1[p10] then
        return;
    end;

    local checkOnOtherGroupSkillRelease = p10.checkOnOtherGroupSkillRelease;

    if type(checkOnOtherGroupSkillRelease) ~= "function" then
        checkOnOtherGroupSkillRelease = nil;
    end;

    if checkOnOtherGroupSkillRelease == nil then
        warn("[SkillReleaseCrossCheck] registerProvider 跳过：缺少 checkOnOtherGroupSkillRelease");

        return;
    end;

    u1[p10] = true;
end;

function u3.registerActive(p11, p12, p13) -- Line: 88
    -- upvalues: RunService (copy), u1 (copy), u3 (copy), u2 (copy)
    if not RunService:IsServer() then
        error("[SkillReleaseCrossCheck] 仅服务端可调用", 2);
    end;

    if type(p11) ~= "number" or p12 == nil then
        return;
    end;

    if not u1[p13] then
        u3.registerProvider(p13);
    end;

    if not u1[p13] then
        return;
    end;

    local v14 = u2[p11];

    if not v14 then
        v14 = {};
        u2[p11] = v14;
    end;

    for i, v in ipairs(v14) do
        if v.handle == p12 then
            break;
        end;
    end;

    if i then
        local v15 = #v14;

        if i < v15 then
            v14[i] = v14[v15];
        end;

        v14[v15] = nil;
    end;

    table.insert(v14, {
        handle = p12,
        provider = p13
    });
end;

function u3.unregisterActive(p16, p17) -- Line: 124
    -- upvalues: RunService (copy), u2 (copy)
    if not RunService:IsServer() then
        error("[SkillReleaseCrossCheck] 仅服务端可调用", 2);
    end;

    if type(p16) ~= "number" or p17 == nil then
        return;
    end;

    local v18 = u2[p16];

    if not v18 then
        return;
    end;

    for i, v in ipairs(v18) do
        if v.handle == p17 then
            break;
        end;
    end;

    if not i then
        return;
    end;

    local v19 = #v18;

    if i < v19 then
        v18[i] = v18[v19];
    end;

    v18[v19] = nil;

    if #v18 == 0 then
        u2[p16] = nil;
    end;
end;

function u3.clearCharacter(p20) -- Line: 146
    -- upvalues: RunService (copy), u2 (copy)
    if not RunService:IsServer() then
        error("[SkillReleaseCrossCheck] 仅服务端可调用", 2);
    end;

    if type(p20) ~= "number" then
        return;
    end;

    u2[p20] = nil;
end;

function u3.hasActiveForCharacter(p21) -- Line: 157
    -- upvalues: u2 (copy)
    local v22 = u2[p21];
    local v23;

    if v22 == nil then
        v23 = false;
    else
        v23 = #v22 > 0;
    end;

    return v23;
end;

function u3.runAll(p24) -- Line: 165
    -- upvalues: RunService (copy), u2 (copy)
    if not RunService:IsServer() then
        error("[SkillReleaseCrossCheck] 仅服务端可调用", 2);
    end;

    if type(p24.characterId) ~= "number" then
        return;
    end;

    local v25 = u2[p24.characterId];

    if not v25 or #v25 == 0 then
        return;
    end;

    for i = #v25, 1, -1 do
        local v26 = v25[i];

        if v26 then
            local checkOnOtherGroupSkillRelease = v26.provider.checkOnOtherGroupSkillRelease;

            if type(checkOnOtherGroupSkillRelease) ~= "function" then
                checkOnOtherGroupSkillRelease = nil;
            end;

            if checkOnOtherGroupSkillRelease then
                checkOnOtherGroupSkillRelease(p24);
            end;
        end;
    end;
end;

return u3;