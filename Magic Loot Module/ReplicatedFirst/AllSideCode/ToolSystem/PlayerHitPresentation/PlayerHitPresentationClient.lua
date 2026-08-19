-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AnimationModule = UtilsSystem.AnimationModule;
local LocalPlayer = UtilsSystem.LocalPlayer;
local SoundModule = UtilsSystem.SoundModule;
local VisibleMgr = UtilsSystem.VisibleMgr;
local v1 = {};
local u2 = Color3.new(1, 0, 0);

function v1.handleIncoming(p3) -- Line: 32
    -- upvalues: Players (copy), VisibleMgr (copy), u2 (copy), SoundModule (copy), LocalPlayer (copy), AnimationModule (copy)
    local v4 = tonumber(p3);

    if not v4 then
        return;
    end;

    local v5 = Players:GetPlayerByUserId(v4);

    if not v5 then
        return;
    end;

    local Character = v5.Character;

    if not Character then
        return;
    end;

    VisibleMgr.HighLight_FillColor_Blink(Character, u2, 0.2);
    SoundModule:PlaySoundLocal({
        SoundName = "通用受击",
        Is2D = false,
        PlayPosition = Character:GetPivot().Position
    });

    if v5 == LocalPlayer then
        local v6 = "人型受击R6-" .. math.random(1, 2);
        AnimationModule.PlayAnimByModel(Character, v6, 2);
    end;
end;

return v1;