-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local Players = game:GetService("Players");
local u1 = {
    SKILL_DOT_MAX_CATCHUP = 24,
    SKILL_DOT_MIN_INTERVAL = require(script.Parent.Parent.Config).getDotMinInterval(),
    SKILL_DOT_MIN_FINAL_DMG = 1,
    ENV_HAZARD_ACTIVE_LEASE_SEC = 24,
    ENV_VFX_RENEW_SEC = 20
};

function u1.resolveCasterPlayer(p2) -- Line: 34
    -- upvalues: Players (copy), u1 (copy)
    if p2 == nil then
        return nil;
    end;

    if type(p2) == "table" and typeof(p2) ~= "Instance" then
        local v3 = tonumber(p2.casterUserId) or tonumber(p2.attackerPlayerId);

        return v3 and (v3 > 0 and Players:GetPlayerByUserId(v3)) or u1.resolveCasterPlayer(p2.attacker);
    end;

    if typeof(p2) ~= "Instance" then
        return nil;
    end;

    if p2:IsA("Player") then
        return p2;
    end;

    if p2:IsA("Model") then
        return Players:GetPlayerFromCharacter(p2);
    end;

    return nil;
end;

function u1.dotDmgPlr(p4, p5) -- Line: 63
    -- upvalues: u1 (copy), UtilsSystem (copy)
    if p5 <= 0 then
        return;
    end;

    local SKILL_DOT_MIN_FINAL_DMG = u1.SKILL_DOT_MIN_FINAL_DMG;
    local v6 = math.floor(p5 + 0.5);
    local v7 = math.max(SKILL_DOT_MIN_FINAL_DMG, v6);
    local SystemPlrAttr = UtilsSystem.SystemPlrAttr;

    if SystemPlrAttr and SystemPlrAttr.ChangeHP then
        SystemPlrAttr.ChangeHP(p4, -v7, false);
    end;
end;

return u1;