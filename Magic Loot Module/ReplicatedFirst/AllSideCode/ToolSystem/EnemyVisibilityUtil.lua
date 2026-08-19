-- Decompiled with Potassium's decompiler.

local EnumMgr = require(game.ReplicatedFirst.AllSideCode.ToolSystem.EnumMgr);
local u3 = {
    getVisibilityMode = function(p1) -- Line: 44, Name: getVisibilityMode
        -- upvalues: EnumMgr (copy)
        if not p1 then
            return EnumMgr.EnemyVisibilityMode.Shared;
        end;

        local v2 = p1:GetAttribute("VisibilityMode");

        if typeof(v2) == "number" then
            return v2;
        end;

        return EnumMgr.EnemyVisibilityMode.Shared;
    end
};

function u3.isShared(p4) -- Line: 61
    -- upvalues: u3 (copy), EnumMgr (copy)
    return u3.getVisibilityMode(p4) == EnumMgr.EnemyVisibilityMode.Shared;
end;

function u3.isPrivate(p5) -- Line: 71
    -- upvalues: u3 (copy), EnumMgr (copy)
    return u3.getVisibilityMode(p5) == EnumMgr.EnemyVisibilityMode.Private;
end;

function u3.serializeAllowedPlayerIds(p6) -- Line: 81
    local v7 = {};

    for _, v in ipairs(p6) do
        local v8 = tonumber(v);

        if v8 then
            local v9 = math.floor(v8);
            local v10 = tostring(v9);
            table.insert(v7, v10);
        end;
    end;

    return table.concat(v7, ",");
end;

function u3.parseAllowedPlayerIds(p11) -- Line: 98
    local v12 = {};

    if typeof(p11) ~= "string" or p11 == "" then
        return v12;
    end;

    for i in string.gmatch(p11, "[^,]+") do
        local v13 = tonumber(i);

        if v13 then
            v12[v13] = true;
        end;
    end;

    return v12;
end;

function u3.isPlayerInWhitelist(p14, p15) -- Line: 119
    -- upvalues: u3 (copy)
    if p14 and typeof(p15) == "number" then
        return u3.parseAllowedPlayerIds(p14:GetAttribute("AllowedPlayerIds"))[p15] == true;
    end;

    return false;
end;

function u3.countWhitelistUserIds(p16) -- Line: 133
    -- upvalues: u3 (copy)
    if not p16 then
        return 0;
    end;

    local v17 = 0;

    for _ in u3.parseAllowedPlayerIds(p16:GetAttribute("AllowedPlayerIds")) do
        v17 = v17 + 1;
    end;

    return v17;
end;

function u3.getSingleWhitelistUserId(p18) -- Line: 151
    -- upvalues: u3 (copy)
    if not p18 then
        return nil;
    end;

    local v19 = 0;
    local v20 = nil;

    for i in u3.parseAllowedPlayerIds(p18:GetAttribute("AllowedPlayerIds")) do
        v19 = v19 + 1;

        if v19 > 1 then
            return nil;
        end;

        v20 = i;
    end;

    if v19 == 1 then
        return v20;
    end;

    return nil;
end;

function u3.canPlayerSee(p21, p22) -- Line: 178
    -- upvalues: u3 (copy)
    if p21 then
        return u3.isShared(p21) and true or u3.isPlayerInWhitelist(p21, p22);
    end;

    return false;
end;

function u3.isCombatReady(p23) -- Line: 194
    if p23 then
        return p23:GetAttribute("CombatReady") ~= false;
    end;

    return false;
end;

function u3.setCombatReady(p24, p25) -- Line: 208
    if not p24 then
        return;
    end;

    p24:SetAttribute("CombatReady", p25 == true);
end;

function u3.canPlayerInteract(p26, p27) -- Line: 222
    -- upvalues: u3 (copy)
    if u3.canPlayerSee(p26, p27) then
        return u3.isCombatReady(p26);
    end;

    return false;
end;

function u3.applyCreateAttributes(p28, p29) -- Line: 236
    -- upvalues: EnumMgr (copy), u3 (copy)
    if not (p28 and p29) then
        if p28 then
            p28:SetAttribute("VisibilityMode", EnumMgr.EnemyVisibilityMode.Shared);
        end;

        return;
    end;

    local visibilityMode = p29.visibilityMode;

    if typeof(visibilityMode) ~= "number" then
        visibilityMode = EnumMgr.EnemyVisibilityMode.Shared;
    end;

    p28:SetAttribute("VisibilityMode", visibilityMode);

    if p29.combatReady == false then
        p28:SetAttribute("CombatReady", false);
    elseif p29.combatReady == true then
        p28:SetAttribute("CombatReady", true);
    end;

    if visibilityMode ~= EnumMgr.EnemyVisibilityMode.Private then
        return;
    end;

    local v30 = p29.allowedPlayerIds or p29.allowedPlayers;

    if typeof(v30) == "table" then
        p28:SetAttribute("AllowedPlayerIds", u3.serializeAllowedPlayerIds(v30));

        return;
    end;

    p28:SetAttribute("AllowedPlayerIds", "");
end;

function u3.filterPlayers(p31, p32) -- Line: 276
    -- upvalues: u3 (copy)
    if not p31 or u3.isShared(p31) then
        return p32;
    end;

    local v33 = {};

    for _, v in ipairs(p32) do
        if v and u3.canPlayerSee(p31, v.UserId) then
            table.insert(v33, v);
        end;
    end;

    return v33;
end;

return u3;