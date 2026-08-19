-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local EnumMgr = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).EnumMgr;
local u1 = {};
local u10 = {
    windowChannelForBuffTp = function(p2) -- Line: 53, Name: windowChannelForBuffTp
        -- upvalues: EnumMgr (copy)
        if p2 == EnumMgr.SkillBuffTypeTp.Reflect then
            return EnumMgr.SkillBuffRuntimeTag.ReflectThorns;
        end;

        if p2 == EnumMgr.SkillBuffTypeTp.MoveRoot then
            return EnumMgr.SkillBuffRuntimeTag.EnwindMoveRoot;
        end;

        return nil;
    end,

    windowChannelFromRuntimeTag = function(p3) -- Line: 64, Name: windowChannelFromRuntimeTag
        -- upvalues: EnumMgr (copy)
        if p3 == EnumMgr.SkillBuffRuntimeTag.ReflectThorns then
            return EnumMgr.SkillBuffRuntimeTag.ReflectThorns;
        end;

        if p3 == EnumMgr.SkillBuffRuntimeTag.EnwindMoveRoot then
            return EnumMgr.SkillBuffRuntimeTag.EnwindMoveRoot;
        end;

        return nil;
    end,

    registerSkillBuffWindow = function(p4, p5, p6) -- Line: 79, Name: registerSkillBuffWindow
        -- upvalues: RunService (copy), u1 (copy)
        if not RunService:IsServer() then
            return;
        end;

        if typeof(p4) ~= "Instance" or (not p4.Parent or (type(p5) ~= "string" or (p5 == "" or p6 <= 0))) then
            return;
        end;

        local v7 = workspace:GetServerTimeNow() + p6;

        for _, v in u1 do
            if v.owner == p4 and v.channel == p5 then
                if v7 < v.endAt then
                    v7 = v.endAt;
                end;

                v.endAt = v7;

                return;
            end;
        end;

        table.insert(u1, {
            owner = p4,
            channel = p5,
            endAt = v7
        });
    end,

    pruneExpired = function(p8) -- Line: 105, Name: pruneExpired
        -- upvalues: u1 (copy)
        for i = #u1, 1, -1 do
            local v9 = u1[i];

            if not v9.owner.Parent or v9.endAt <= p8 then
                table.remove(u1, i);
            end;
        end;
    end
};

function u10.isSkillBuffRuntimeWindowActive(p11, p12) -- Line: 119
    -- upvalues: u10 (copy), u1 (copy)
    if not p11 then
        return false;
    end;

    local v13 = u10.windowChannelFromRuntimeTag(p12);

    if not v13 then
        return false;
    end;

    local v14 = workspace:GetServerTimeNow();
    local Character = p11.Character;

    for _, v in u1 do
        if v.channel == v13 and (v14 < v.endAt and (v.owner.Parent and (v.owner == p11 or Character and v.owner == Character))) then
            return true;
        end;
    end;

    return false;
end;

function u10.isReflectThornsWindowActive(p15) -- Line: 140
    -- upvalues: u10 (copy), EnumMgr (copy)
    return u10.isSkillBuffRuntimeWindowActive(p15, EnumMgr.SkillBuffRuntimeTag.ReflectThorns);
end;

return u10;