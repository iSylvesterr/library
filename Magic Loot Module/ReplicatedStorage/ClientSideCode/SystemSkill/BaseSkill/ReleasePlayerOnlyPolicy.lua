-- Decompiled with Potassium's decompiler.

local u1 = {};
local LocalPlayer = game:GetService("Players").LocalPlayer;

function u1.isPlayerSubjectSkill(p2) -- Line: 21
    return p2.characterType == "Player";
end;

function u1.isMonsterOrSyncedNonPlayerSubjectSkill(p3) -- Line: 28
    -- upvalues: u1 (copy)
    return not u1.isPlayerSubjectSkill(p3);
end;

function u1.shouldRunReleasePlayerOnlyActions(p4) -- Line: 35
    -- upvalues: u1 (copy), LocalPlayer (copy)
    return not u1.isPlayerSubjectSkill(p4) and true or LocalPlayer.UserId == p4.characterId;
end;

return u1;