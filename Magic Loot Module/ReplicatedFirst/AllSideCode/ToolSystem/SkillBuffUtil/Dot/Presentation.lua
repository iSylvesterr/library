-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local NetMsg = UtilsSystem.NetMsg;
local SkillSyncRouter = game.ReplicatedStorage.ClientSideCode.SystemSkill.BaseSkill.SkillSyncRouter;
local RemoteEvent = UtilsSystem.RemoteEvent.RemoteEvent;
local u13 = {
    broadcastDotVfx = function(p1, p2, p3, p4) -- Line: 24, Name: broadcastDotVfx
        -- upvalues: RunService (copy), Players (copy), SkillSyncRouter (copy), NetMsg (copy)
        if not RunService:IsServer() then
            return;
        end;

        if not (p1 and p1.Parent) then
            return;
        end;

        if type(p2) ~= "string" or p2 == "" then
            return;
        end;

        local v5 = tonumber(p4);

        if not v5 or (v5 <= 0 or v5 ~= v5) then
            return;
        end;

        local v6 = {
            vfxName = p2,
            durationSec = v5
        };
        local v7;

        if p1:IsA("Model") then
            v7 = Players:GetPlayerFromCharacter(p1);
        else
            v7 = nil;
        end;

        if v7 then
            v6.defenderUserId = v7.UserId;
        else
            v6.monsterId = p1.Name;
        end;

        local v8;

        if p1:IsA("BasePart") then
            v8 = p1.Position;
        else
            if not p1:IsA("Model") then
                return;
            end;

            v8 = p1:GetPivot().Position;
        end;

        local v9 = Players:GetPlayerByUserId(p3);
        require(SkillSyncRouter).broadcastPresentationRelevant(v8, 100, NetMsg.DOT_HIT_PRESENTATION, v6, v9);
    end,

    broadcastEnvDotVfxStop = function(p10, p11) -- Line: 62, Name: broadcastEnvDotVfxStop
        -- upvalues: RunService (copy), SkillSyncRouter (copy), NetMsg (copy)
        if not RunService:IsServer() then
            return;
        end;

        if type(p11) ~= "string" or (p11 == "" or not (p10 and p10.Parent)) then
            return;
        end;

        local Character = p10.Character;
        local v12;

        if Character then
            v12 = Character:GetPivot().Position;
        else
            v12 = p10:GetPivot().Position;
        end;

        require(SkillSyncRouter).broadcastPresentationRelevant(v12, 100, NetMsg.DOT_HIT_PRESENTATION_END, {
            vfxName = p11,
            defenderUserId = p10.UserId
        }, p10);
    end
};

function u13.fireDotVfxFromTypeRow(p14, p15, p16, p17) -- Line: 79
    -- upvalues: u13 (copy)
    if p14 then
        p14 = p14.Effects;
    end;

    if type(p14) == "string" and p14 ~= "" then
        u13.broadcastDotVfx(p15, p14, p16, p17);
    end;
end;

function u13.firePlayerDotHitReaction(p18) -- Line: 87
    -- upvalues: RunService (copy), Players (copy), RemoteEvent (copy)
    if not RunService:IsServer() then
        return;
    end;

    if not (p18 and p18.Parent) then
        return;
    end;

    local Character = p18.Character;

    if not Character then
        return;
    end;

    local Position = Character:GetPivot().Position;

    for _, v in Players:GetPlayers() do
        local Character2 = v.Character;

        if Character2 and (Character2:GetPivot().Position - Position).Magnitude < 150 then
            RemoteEvent:FireClient(v, "玩家受击表现", p18.UserId);
        end;
    end;
end;

return u13;