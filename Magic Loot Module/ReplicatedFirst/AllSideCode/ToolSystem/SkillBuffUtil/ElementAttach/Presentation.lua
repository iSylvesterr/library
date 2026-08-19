-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local Presentation = require(script.Parent.Parent.Dot.Presentation);
local SkillSyncRouter = game.ReplicatedStorage.ClientSideCode.SystemSkill.BaseSkill.SkillSyncRouter;
local u1 = {};
local u2 = setmetatable({}, {
    __mode = "k"
});

local function tryConsumeEleTipCd(p3, p4) -- Line: 24
    -- upvalues: u2 (copy)
    local v5 = workspace:GetServerTimeNow();
    local v6 = u2[p3];

    if not v6 then
        v6 = {};
        u2[p3] = v6;
    end;

    local v7 = v6[p4];

    if v7 and v5 - v7 < 2 then
        return false;
    end;

    v6[p4] = v5;

    return true;
end;

local function defenderAnchorPos(p8) -- Line: 39
    if p8:IsA("BasePart") then
        return p8.Position;
    end;

    if p8:IsA("Model") then
        return p8:GetPivot().Position;
    end;

    return nil;
end;

local function buildDefenderPayload(p9, p10) -- Line: 49
    -- upvalues: Players (copy)
    local v11;

    if p9:IsA("Model") then
        v11 = Players:GetPlayerFromCharacter(p9);
    else
        v11 = nil;
    end;

    if v11 then
        p10.defenderUserId = v11.UserId;

        return;
    end;

    p10.monsterId = p9.Name;
end;

function u1.broadcastElementAttachTip(p12, p13, p14, p15) -- Line: 61
    -- upvalues: RunService (copy), u2 (copy), Players (copy), SkillSyncRouter (copy)
    if not RunService:IsServer() then
        return;
    end;

    if not (p12 and p12.Parent) then
        return;
    end;

    if type(p15) ~= "string" or p15 == "" then
        return;
    end;

    local v16 = tonumber(p14);

    if not v16 or v16 <= 0 then
        return;
    end;

    local v17 = workspace:GetServerTimeNow();
    local v18 = u2[p12];

    if not v18 then
        v18 = {};
        u2[p12] = v18;
    end;

    local v19 = v18[v16];
    local v20;

    if v19 and v17 - v19 < 2 then
        v20 = false;
    else
        v18[v16] = v17;
        v20 = true;
    end;

    if not v20 then
        return;
    end;

    local v21;

    if p12:IsA("BasePart") then
        v21 = p12.Position;
    elseif p12:IsA("Model") then
        v21 = p12:GetPivot().Position;
    else
        v21 = nil;
    end;

    if not v21 then
        return;
    end;

    local v22 = {
        elementTp = v16,
        tipText = p15,
        anchorPos = v21 + Vector3.new(0, 4, 0)
    };
    local v23;

    if p12:IsA("Model") then
        v23 = Players:GetPlayerFromCharacter(p12);
    else
        v23 = nil;
    end;

    if v23 then
        v22.defenderUserId = v23.UserId;
    else
        v22.monsterId = p12.Name;
    end;

    local v24 = Players:GetPlayerByUserId(p13);
    require(SkillSyncRouter).broadcastElementAttachTipRelevant(v21, 100, v22, v24);
end;

function u1.fireAttachTipFromBuffRow(p25, p26, p27, p28) -- Line: 98
    -- upvalues: u1 (copy)
    if p25 then
        p25 = p25.ZhName;
    end;

    if type(p25) ~= "string" or p25 == "" then
        return;
    end;

    u1.broadcastElementAttachTip(p26, p27, p28, p25);
end;

function u1.fireAttachVfxFromTypeRow(p29, p30, p31, p32) -- Line: 111
    -- upvalues: Presentation (copy)
    Presentation.fireDotVfxFromTypeRow(p29, p30, p31, p32);
end;

return u1;