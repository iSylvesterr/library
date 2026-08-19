-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = {
    Client = true,
    Server = true
};

function u1.isPlayerSubjectSkill(p3) -- Line: 24
    return p3.characterType == "Player";
end;

function u1.isMirrorSubjectSkill(p4) -- Line: 28
    return p4.characterType == "Mirror";
end;

function u1.isLogicalSubjectSkill(p5) -- Line: 38
    if not p5 then
        return false;
    end;

    local character = p5.character;

    if not character then
        character = p5.skillInputData;

        if character then
            character = character.character;
        end;
    end;

    if typeof(character) == "Instance" and character:IsA("Model") then
        return character:GetAttribute("IsLogicalEnemy") == true;
    end;

    return false;
end;

function u1.normalizeSide(p6) -- Line: 53
    if type(p6) ~= "string" then
        return "Client";
    end;

    local v7 = string.gsub(p6, "^%s*(.-)%s*$", "%1");

    return string.lower(v7) == "server" and "Server" or "Client";
end;

function u1.resolvePlaySide(p8) -- Line: 64
    -- upvalues: u1 (copy)
    return not p8 and "Client" or u1.normalizeSide(p8.animationPlaySide);
end;

function u1.shouldRunServerSkillAction(p9) -- Line: 71
    -- upvalues: u1 (copy)
    if u1.isPlayerSubjectSkill(p9) then
        return false;
    end;

    if u1.isMirrorSubjectSkill(p9) then
        return true;
    end;

    if u1.isLogicalSubjectSkill(p9) then
        return false;
    end;

    return u1.resolvePlaySide(p9.skillModule) == "Server";
end;

function u1.shouldSkipClientAnimation(p10) -- Line: 85
    -- upvalues: u1 (copy)
    return u1.shouldRunServerSkillAction(p10);
end;

function u1.isValidConfiguredSide(p11) -- Line: 89
    -- upvalues: u2 (copy), u1 (copy)
    return p11 == nil and true or u2[u1.normalizeSide(p11)] == true;
end;

return u1;