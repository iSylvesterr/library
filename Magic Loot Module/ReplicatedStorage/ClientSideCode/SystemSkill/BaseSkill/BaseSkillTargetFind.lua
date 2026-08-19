-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local Players = UtilsSystem.Players;

return {
    findTarget = function(p1) -- Line: 20, Name: findTarget
        -- upvalues: Players (copy)
        if not p1 then
            return nil;
        end;

        local v2 = nil;

        if p1.targetType == "Player" then
            local v3 = Players:GetPlayerByUserId((tonumber(p1.targetCharacterID)));

            if v3 and (v3.Character and v3.Character.PrimaryPart) then
                return v3.Character.PrimaryPart.CFrame;
            end;
        elseif p1.targetType == "NPC" then
            local v4 = require(script.Parent.GetSkillData).getCharacter("NPC", p1.targetCharacterID);

            if v4 and v4.PrimaryPart then
                v2 = v4.PrimaryPart.CFrame;
            end;
        end;

        return v2;
    end
};