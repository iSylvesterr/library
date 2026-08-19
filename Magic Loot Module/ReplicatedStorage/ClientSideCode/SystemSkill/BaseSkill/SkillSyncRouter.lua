-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local GetData = UtilsSystem.GetData;
local NetWork = UtilsSystem.NetWork;
local NetMsg = UtilsSystem.NetMsg;
local EnemyVisibilityUtil = UtilsSystem.EnemyVisibilityUtil;
local SkillFxGate = UtilsSystem.SkillFxGate;
local u1 = {
    isPlayerSkillObserverSyncEnabled = function() -- Line: 37, Name: isPlayerSkillObserverSyncEnabled
        return false;
    end
};

local function getGraphicsQualitySetting(u2) -- Line: 41
    -- upvalues: GetData (copy)
    if not u2 then
        return nil;
    end;

    if type(GetData.GetSetting) ~= "function" then
        return nil;
    end;

    local success, result = pcall(function() -- Line: 48
        -- upvalues: GetData (ref), u2 (copy)
        return GetData.GetSetting(u2, "GraphicsQuality");
    end);

    if success then
        return result;
    end;

    return nil;
end;

local function isLowGraphics(u3) -- Line: 57
    -- upvalues: GetData (copy)
    local v4;

    if u3 and type(GetData.GetSetting) == "function" then
        local v5;
        v5, v4 = pcall(function() -- Line: 48
            -- upvalues: GetData (ref), u3 (copy)
            return GetData.GetSetting(u3, "GraphicsQuality");
        end);

        if not v5 then
            v4 = nil;
        end;
    else
        v4 = nil;
    end;

    return v4 == 0;
end;

local function shouldDeliverPlayerCasterFx(p6, p7) -- Line: 66
    return not p6 and true or p7 == p6;
end;

local function shouldDeliverPlayerCasterPureFx(p8, p9) -- Line: 94
    -- upvalues: SkillFxGate (copy)
    if not p8 and true or p9 == p8 then
        return (not p8 or SkillFxGate.IsEnabled(p9)) and true or false;
    end;

    return false;
end;

local function inferCasterPlayerFromPayload(p10) -- Line: 104
    -- upvalues: Players (copy)
    if type(p10) ~= "table" then
        return nil;
    end;

    if p10.characterType == "Player" and type(p10.characterId) == "number" then
        return Players:GetPlayerByUserId(p10.characterId);
    end;

    return nil;
end;

local u11 = {};
local u12 = {};
local u13 = nil;
local u14 = nil;

function u1._testSetPlayerProvider(p15) -- Line: 127
    -- upvalues: u13 (ref)
    u13 = p15;
end;

function u1._testSetEventCapture(p16) -- Line: 131
    -- upvalues: u14 (ref)
    u14 = p16;
end;

function u1._testSetAudienceLastTouched(p17, p18) -- Line: 135
    -- upvalues: u12 (copy)
    if u12[p17] then
        u12[p17].lastTouched = p18;

        return;
    end;

    u12[p17] = {
        lastTouched = p18
    };
end;

function u1._testReset() -- Line: 143
    -- upvalues: u13 (ref), u14 (ref)
    u13 = nil;
    u14 = nil;
end;

local function touchAudience(p19) -- Line: 148
    -- upvalues: u12 (copy)
    if not p19 then
        return;
    end;

    local v20 = u12[p19];

    if not v20 then
        v20 = {};
        u12[p19] = v20;
    end;

    v20.lastTouched = os.clock();
end;

local function removePlayerFromAllAudiences(p21) -- Line: 161
    -- upvalues: u11 (copy), u12 (copy)
    if not p21 then
        return;
    end;

    for i, v in pairs(u11) do
        if v[p21] then
            v[p21] = nil;

            if next(v) == nil then
                u11[i] = nil;
                u12[i] = nil;
            end;
        end;
    end;
end;

function u1._testSimulatePlayerRemoving(p22) -- Line: 177
    -- upvalues: removePlayerFromAllAudiences (copy)
    removePlayerFromAllAudiences(p22);
end;

Players.PlayerRemoving:Connect(removePlayerFromAllAudiences);
local u23 = 0;

local function sweepExpiredAudience() -- Line: 186
    -- upvalues: u23 (ref), u12 (copy), u11 (copy)
    local v24 = os.clock();

    if v24 - u23 < 30 then
        return;
    end;

    u23 = v24;

    for i, v in pairs(u12) do
        if v24 - (v.lastTouched or 0) > 120 then
            u11[i] = nil;
            u12[i] = nil;
        end;
    end;
end;

RunService.Heartbeat:Connect(function() -- Line: 198
    -- upvalues: sweepExpiredAudience (copy)
    sweepExpiredAudience();
end);

local function getCharacterRoot(p25) -- Line: 202
    if p25 then
        return p25:FindFirstChild("HumanoidRootPart") or p25.PrimaryPart;
    end;

    return nil;
end;

function u1.registerAudience(p26, p27) -- Line: 210
    -- upvalues: u12 (copy), u11 (copy)
    if not (p26 and p27) then
        return;
    end;

    if p26 then
        local v28 = u12[p26];

        if not v28 then
            v28 = {};
            u12[p26] = v28;
        end;

        v28.lastTouched = os.clock();
    end;

    local v29 = u11[p26];

    if not v29 then
        v29 = {};
        u11[p26] = v29;
    end;

    v29[p27] = true;
end;

function u1.registerAudiences(p30, p31) -- Line: 224
    -- upvalues: u1 (copy)
    if not (p30 and p31) then
        return;
    end;

    for _, v in ipairs(p31) do
        u1.registerAudience(p30, v);
    end;
end;

function u1.getAudience(p32) -- Line: 235
    -- upvalues: u11 (copy)
    local v33 = u11[p32];

    if not v33 then
        return {};
    end;

    local v34 = {};

    for i, _ in pairs(v33) do
        if i and i.Parent then
            table.insert(v34, i);
        end;
    end;

    return v34;
end;

function u1.getAudienceCount(p35) -- Line: 250
    -- upvalues: u11 (copy)
    local v36 = u11[p35];

    if not v36 then
        return 0;
    end;

    local v37 = 0;

    for i, _ in pairs(v36) do
        if i and i.Parent then
            v37 = v37 + 1;
        end;
    end;

    return v37;
end;

function u1.getTrackedCastCount() -- Line: 263
    -- upvalues: u11 (copy)
    local v38 = 0;

    for _ in pairs(u11) do
        v38 = v38 + 1;
    end;

    return v38;
end;

function u1.debugSweepInvalidAudience() -- Line: 273
    -- upvalues: u12 (copy), u11 (copy), u23 (ref)
    local v39 = os.clock();
    local v40 = 0;

    for i, v in pairs(u12) do
        if v39 - (v.lastTouched or 0) > 120 then
            u11[i] = nil;
            u12[i] = nil;
            v40 = v40 + 1;
        end;
    end;

    u23 = v39;

    return v40;
end;

function u1.clearAudience(p41) -- Line: 290
    -- upvalues: u11 (copy), u12 (copy)
    if p41 then
        u11[p41] = nil;
        u12[p41] = nil;
    end;
end;

function u1.getRelevantPlayers(p42, p43, p44, p45) -- Line: 306
    -- upvalues: u13 (ref), Players (copy), EnemyVisibilityUtil (copy)
    local v46 = u13 and u13() or Players:GetPlayers();
    local v47 = {};

    for _, v in ipairs(v46) do
        if not p45 or EnemyVisibilityUtil.canPlayerSee(p45, v.UserId) then
            local Character = v.Character;
            local v48;

            if Character then
                v48 = Character:FindFirstChild("HumanoidRootPart") or Character.PrimaryPart;
            else
                v48 = nil;
            end;

            if v48 then
                if (v48.Position - p42).Magnitude <= p43 then
                    table.insert(v47, v);
                end;
            elseif p44 and v == p44 then
                table.insert(v47, v);
            end;
        end;
    end;

    if p44 and p44.Parent then
        local v49 = false;

        for _, v in ipairs(v47) do
            if v == p44 then
                v49 = true;
                break;
            end;
        end;

        if not v49 then
            table.insert(v47, p44);
        end;
    end;

    return v47;
end;

function u1.broadcastRelevant(p50, p51, p52, p53, p54) -- Line: 342
    -- upvalues: u1 (copy), u14 (ref), NetWork (copy), NetMsg (copy)
    local v55 = u1.getRelevantPlayers(p50, p51 or 120, p53, p54);

    for _, v in ipairs(v55) do
        if not p53 and true or v == p53 then
            if u14 then
                u14.record("SynSkillEffect", v, p52);
            else
                NetWork.FireClient(v, NetMsg.SYN_SKILL_EFFECT, p52);
            end;
        end;
    end;
end;

function u1.broadcastRelevantAndTrack(p56, p57, p58, p59, p60, p61) -- Line: 359
    -- upvalues: u1 (copy), u13 (ref), Players (copy), EnemyVisibilityUtil (copy), u14 (ref), NetWork (copy), NetMsg (copy)
    local v62;

    if p57 then
        v62 = u1.getRelevantPlayers(p57, p58 or 120, p60, p61);
    else
        v62 = u13 and u13() or Players:GetPlayers();

        if p61 then
            v62 = EnemyVisibilityUtil.filterPlayers(p61, v62);
        end;
    end;

    for _, v in ipairs(v62) do
        if not p60 and true or v == p60 then
            if u14 then
                u14.record("SynSkillEffect", v, p59);
            else
                NetWork.FireClient(v, NetMsg.SYN_SKILL_EFFECT, p59);
            end;

            u1.registerAudience(p56, v);
        end;
    end;
end;

function u1.broadcastStopRelevant(p63, p64, p65, p66, p67) -- Line: 384
    -- upvalues: u1 (copy), u14 (ref), NetWork (copy), NetMsg (copy)
    local v68 = u1.getRelevantPlayers(p63, p64 or 120, p66, p67);

    for _, v in ipairs(v68) do
        if not p66 and true or v == p66 then
            if u14 then
                u14.record("StopSkill", v, p65);
            else
                NetWork.FireClient(v, NetMsg.STOP_SKILL, p65);
            end;
        end;
    end;
end;

function u1.broadcastStopTracked(p69, p70, p71, p72, p73, p74) -- Line: 401
    -- upvalues: u1 (copy), EnemyVisibilityUtil (copy), u14 (ref), NetWork (copy), NetMsg (copy)
    local v75 = u1.getAudience(p69);
    local v76 = {};

    for _, v in ipairs(v75) do
        if (not p74 or EnemyVisibilityUtil.canPlayerSee(p74, v.UserId)) and (not p73 or v == p73) then
            if u14 then
                u14.record("StopSkill", v, p70);
            else
                NetWork.FireClient(v, NetMsg.STOP_SKILL, p70);
            end;

            v76[v] = true;
        end;
    end;

    if p71 then
        local v77 = u1.getRelevantPlayers(p71, p72 or 120, p73, p74);

        for _, v in ipairs(v77) do
            if not v76[v] and (not p73 or v == p73) then
                if u14 then
                    u14.record("StopSkill", v, p70);
                else
                    NetWork.FireClient(v, NetMsg.STOP_SKILL, p70);
                end;
            end;
        end;
    end;

    u1.clearAudience(p69);
end;

function u1.broadcastStopTrackedAndClear(u78, u79, u80, u81, u82, u83) -- Line: 436
    -- upvalues: u1 (copy)
    local success, result = pcall(function() -- Line: 437
        -- upvalues: u1 (ref), u78 (copy), u79 (copy), u80 (copy), u81 (copy), u82 (copy), u83 (copy)
        u1.broadcastStopTracked(u78, u79, u80, u81, u82, u83);
    end);
    u1.clearAudience(u78);

    if not success then
        error(result);
    end;
end;

function u1.broadcastDamageTipRelevant(p84, p85, p86, p87, p88, p89, p90, p91) -- Line: 456
    -- upvalues: u1 (copy), u14 (ref), NetWork (copy), NetMsg (copy)
    local v92 = u1.getRelevantPlayers(p84, p85 or 120, p90, p91);

    for _, v in ipairs(v92) do
        if u14 then
            u14.record("DamageTip", v, p86, p87, p88, p89);
        else
            NetWork.FireClient(v, NetMsg.DAMAGE_TIP, p86, p87, p88, p89);
        end;
    end;
end;

function u1.broadcastElementAttachTipRelevant(p93, p94, p95, p96) -- Line: 470
    -- upvalues: u1 (copy), SkillFxGate (copy), u14 (ref), NetWork (copy), NetMsg (copy)
    if type(p95) ~= "table" then
        return;
    end;

    local v97 = u1.getRelevantPlayers(p93, p94 or 120, p96);

    for _, v in ipairs(v97) do
        local v98;

        if not p96 and true or v == p96 then
            v98 = (not p96 or SkillFxGate.IsEnabled(v)) and true or false;
        else
            v98 = false;
        end;

        if v98 then
            if u14 then
                u14.record("ElementAttachTip", v, p95);
            else
                NetWork.FireClient(v, NetMsg.ELEMENT_ATTACH_TIP, p95);
            end;
        end;
    end;
end;

function u1.broadcastPresentationRelevant(p99, p100, p101, p102, p103) -- Line: 489
    -- upvalues: u1 (copy), SkillFxGate (copy), u14 (ref), NetWork (copy)
    if type(p101) ~= "string" or p101 == "" then
        return;
    end;

    local v104 = u1.getRelevantPlayers(p99, p100 or 120, p103);

    for _, v in ipairs(v104) do
        local v105;

        if not p103 and true or v == p103 then
            v105 = (not p103 or SkillFxGate.IsEnabled(v)) and true or false;
        else
            v105 = false;
        end;

        if v105 then
            if u14 then
                u14.record("RemotePresentation", v, p101, p102);
            else
                NetWork.FireClient(v, p101, p102);
            end;
        end;
    end;
end;

function u1.sendToAll(p106) -- Line: 508
    -- upvalues: Players (copy), NetWork (copy), NetMsg (copy)
    local v107;

    if type(p106) == "table" and (p106.characterType == "Player" and type(p106.characterId) == "number") then
        v107 = Players:GetPlayerByUserId(p106.characterId);
    else
        v107 = nil;
    end;

    for _, v in Players:GetPlayers() do
        if not v107 and true or v == v107 then
            NetWork.FireClient(v, NetMsg.SYN_SKILL_EFFECT, p106);
        end;
    end;
end;

function u1.sendStopToAll(p108) -- Line: 520
    -- upvalues: Players (copy), NetWork (copy), NetMsg (copy)
    local v109;

    if type(p108) == "table" and (p108.characterType == "Player" and type(p108.characterId) == "number") then
        v109 = Players:GetPlayerByUserId(p108.characterId);
    else
        v109 = nil;
    end;

    for _, v in Players:GetPlayers() do
        if not v109 and true or v == v109 then
            NetWork.FireClient(v, NetMsg.STOP_SKILL, p108);
        end;
    end;
end;

return u1;