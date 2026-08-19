-- Decompiled with Potassium's decompiler.

local ServerStorage = game:GetService("ServerStorage");
local EnumMgr = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).EnumMgr;
local Config = require(script.Parent.Parent.Config);
local u3 = {
    isStunBuff = function(p1, p2) -- Line: 16, Name: isStunBuff
        -- upvalues: EnumMgr (copy)
        if p1 and p1.RuntimeTag == EnumMgr.SkillBuffRuntimeTag.Stun then
            return true;
        end;

        if p1 then
            p1 = p1.BuffTp;
        end;

        return tonumber(p1) == EnumMgr.SkillBuffTypeTp.HardControl;
    end
};

function u3.tryApply(p4, p5, p6) -- Line: 28
    -- upvalues: u3 (copy), ServerStorage (copy), Config (copy)
    if not (p4 and p4.Parent) then
        return;
    end;

    if not u3.isStunBuff(p5, p6) then
        return;
    end;

    local success, result = pcall(function() -- Line: 35
        -- upvalues: ServerStorage (ref)
        return require(ServerStorage.ServerSideCode.AI.Shared.NPCStun);
    end);

    if success and (result and (result.isImmune and result.isImmune(p4))) then
        return;
    end;

    local v7 = Config.durFromRow(p5);

    if v7 <= 0 then
        return;
    end;

    local success2, result2 = pcall(function() -- Line: 45
        -- upvalues: ServerStorage (ref)
        return require(ServerStorage.ServerSideCode.AI.Shared.NPCStun);
    end);

    if success2 and (result2 and result2.applyToModel) then
        result2.applyToModel(p4, v7);
    end;
end;

return u3;