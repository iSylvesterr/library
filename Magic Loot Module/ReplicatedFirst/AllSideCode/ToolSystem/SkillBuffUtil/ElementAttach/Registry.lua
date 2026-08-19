-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local EnumMgr = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).EnumMgr;
local u1 = {};
local v2 = {
    getEntries = function() -- Line: 31, Name: getEntries
        -- upvalues: u1 (copy)
        return u1;
    end
};

local function removeAllEntries(p3, p4) -- Line: 36
    -- upvalues: u1 (copy)
    local v5 = tonumber(p4);

    if not v5 or v5 <= 0 then
        return;
    end;

    for i = #u1, 1, -1 do
        local v6 = u1[i];

        if v6.owner == p3 and v6.elementTp == v5 then
            table.remove(u1, i);
        end;
    end;
end;

local function findRawEntry(p7, p8) -- Line: 50
    -- upvalues: u1 (copy)
    if typeof(p7) ~= "Instance" then
        return nil;
    end;

    local v9 = tonumber(p8);

    if not v9 or v9 <= 0 then
        return nil;
    end;

    for _, v in u1 do
        if v.owner == p7 and v.elementTp == v9 then
            return v;
        end;
    end;

    return nil;
end;

function v2.findEntry(p10, p11) -- Line: 66
    -- upvalues: u1 (copy)
    if typeof(p10) ~= "Instance" or not p10.Parent then
        return nil;
    end;

    local v12 = tonumber(p11);

    if not v12 or v12 <= 0 then
        return nil;
    end;

    local v13 = workspace:GetServerTimeNow();

    for _, v in u1 do
        if v.owner == p10 and (v.elementTp == v12 and (v13 < v.endAt and v.owner.Parent)) then
            return v;
        end;
    end;

    return nil;
end;

function v2.register(p14, p15, p16, p17, p18) -- Line: 84
    -- upvalues: RunService (copy), EnumMgr (copy), u1 (copy)
    if not RunService:IsServer() then
        return false;
    end;

    if typeof(p14) ~= "Instance" or not p14.Parent then
        return false;
    end;

    local v19 = tonumber(p15);
    local v20 = tonumber(p16);
    local v21 = tonumber(p17);

    if not v19 or (v19 <= 0 or (not v20 or (v20 <= 0 or (not v21 or v21 <= 0)))) then
        return false;
    end;

    local v22 = tonumber(p18) or 1;
    local v23 = v22 < 1 and 1 or v22;
    local v24 = workspace:GetServerTimeNow() + v20;
    local CondDmgAmp = EnumMgr.ElementTraitKind.CondDmgAmp;

    for _, v in u1 do
        if v.owner == p14 and v.elementTp == v19 then
            if v24 < v.endAt then
                v24 = v.endAt;
            end;

            v.endAt = v24;
            v.buffInstId = v21;
            v.tier = v23;
            v.traitKind = CondDmgAmp;

            return true;
        end;
    end;

    table.insert(u1, {
        owner = p14,
        elementTp = v19,
        endAt = v24,
        buffInstId = v21,
        tier = v23,
        traitKind = CondDmgAmp
    });

    return true;
end;

function v2.registerStackDotHit(p25, p26, p27, p28, p29, p30, p31, p32) -- Line: 134
    -- upvalues: RunService (copy), EnumMgr (copy), findRawEntry (copy), removeAllEntries (copy), u1 (copy)
    if not RunService:IsServer() then
        return false;
    end;

    if typeof(p25) ~= "Instance" or not p25.Parent then
        return false;
    end;

    local v33 = tonumber(p26);
    local v34 = tonumber(p27);
    local v35 = tonumber(p28);
    local v36 = tonumber(p29) or 1;
    local v37 = tonumber(p30);
    local v38 = tonumber(p31);

    if not v33 or (v33 <= 0 or (not v34 or (v34 <= 0 or (not v35 or v35 <= 0)))) then
        return false;
    end;

    if not v37 or (v37 ~= v37 or v37 <= 0) then
        return false;
    end;

    if not v38 or v38 <= 0 then
        return false;
    end;

    local v39 = v36 < 1 and 1 or v36;
    local v40 = workspace:GetServerTimeNow();
    local v41 = v40 + v34;
    local Dot = EnumMgr.ElementTraitKind.Dot;
    local v42 = findRawEntry(p25, v33);

    if not v42 or (v40 >= v42.endAt or v42.traitKind ~= Dot) then
        removeAllEntries(p25, v33);
        table.insert(u1, {
            tier = 1,
            owner = p25,
            elementTp = v33,
            endAt = v41,
            buffInstId = v35,
            traitKind = Dot,
            nextTickAt = v40 + v37,
            tickInterval = v37,
            casterUserId = v38,
            playDotHit = p32 == true
        });

        return true;
    end;

    local v43 = v42.tier + 1;

    if v39 >= v43 then
        v39 = v43;
    end;

    v42.tier = v39;
    v42.endAt = v41;
    v42.buffInstId = v35;
    v42.casterUserId = v38;
    v42.tickInterval = v37;
    v42.playDotHit = p32 == true;

    if not v42.nextTickAt or v42.nextTickAt ~= v42.nextTickAt then
        v42.nextTickAt = v40 + v37;
    end;

    return true;
end;

function v2.consume(p44, p45) -- Line: 205
    -- upvalues: RunService (copy), u1 (copy)
    if not RunService:IsServer() then
        return false;
    end;

    if typeof(p44) ~= "Instance" then
        return false;
    end;

    local v46 = tonumber(p45);

    if not v46 or v46 <= 0 then
        return false;
    end;

    for i = #u1, 1, -1 do
        local v47 = u1[i];

        if v47.owner == p44 and v47.elementTp == v46 then
            table.remove(u1, i);

            return true;
        end;
    end;

    return false;
end;

function v2.removeAtIndex(p48) -- Line: 227
    -- upvalues: u1 (copy)
    table.remove(u1, p48);
end;

function v2.pruneExpired(p49) -- Line: 231
    -- upvalues: u1 (copy)
    for i = #u1, 1, -1 do
        local v50 = u1[i];

        if not v50.owner.Parent or v50.endAt <= p49 then
            table.remove(u1, i);
        end;
    end;
end;

return v2;