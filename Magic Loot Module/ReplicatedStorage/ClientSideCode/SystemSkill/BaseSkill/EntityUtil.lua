-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local GetSkillData = require(script.Parent.GetSkillData);
local u8 = {
    idsEqual = function(p1, p2) -- Line: 21, Name: idsEqual
        if p1 == p2 then
            return true;
        end;

        if p1 == nil or p2 == nil then
            return false;
        end;

        return tostring(p1) == tostring(p2);
    end,

    getEntityIdentity = function(p3) -- Line: 43, Name: getEntityIdentity
        -- upvalues: Players (copy)
        if not (p3 and p3:IsA("Model")) then
            return nil, nil;
        end;

        local v4 = p3:GetAttribute("EntityId");
        local v5 = p3:GetAttribute("EntityType");

        if v4 ~= nil and v5 ~= nil then
            return v4, tostring(v5);
        end;

        local v6 = Players:GetPlayerFromCharacter(p3);

        if v6 then
            return v6.UserId, "Player";
        end;

        if not p3:FindFirstChildOfClass("Humanoid") then
            return nil, nil;
        end;

        if p3:GetAttribute("IsLogicalEnemy") == true then
            return p3.Name, "NPC";
        end;

        local Monster = workspace:FindFirstChild("Monster");

        if Monster and p3:IsDescendantOf(Monster) then
            return p3.Name, "NPC";
        end;

        local LocalMonster = workspace:FindFirstChild("LocalMonster");

        if LocalMonster and p3:IsDescendantOf(LocalMonster) then
            return p3.Name, "NPC";
        end;

        local Summons = workspace:FindFirstChild("Summons");

        if Summons and p3:IsDescendantOf(Summons) then
            return p3.Name, "Summon";
        end;

        local SpaceMirrors = workspace:FindFirstChild("SpaceMirrors");

        if SpaceMirrors and p3:IsDescendantOf(SpaceMirrors) then
            return p3.Name, "Mirror";
        end;

        local v7 = p3:GetAttribute("EntityType") or "Summon";

        return p3.Name, tostring(v7);
    end
};

function u8.getEntityCamp(p9) -- Line: 94
    -- upvalues: u8 (copy), Players (copy)
    if not (p9 and p9:IsA("Model")) then
        return nil;
    end;

    local v10 = p9:GetAttribute("Camp");

    if v10 ~= nil and v10 ~= "" then
        return tostring(v10);
    end;

    local v11, v12 = u8.getEntityOwnerId(p9);

    if v11 and v12 then
        return u8.getCampById(v11, v12);
    end;

    local v13 = Players:GetPlayerFromCharacter(p9);

    if v13 and (v13.Team and v13.Team.Name) then
        return v13.Team.Name;
    end;

    return nil;
end;

function u8.getCampById(p14, p15) -- Line: 124
    -- upvalues: GetSkillData (copy), u8 (copy)
    if not (p14 and p15) then
        return nil;
    end;

    local v16 = GetSkillData.getCharacter(p15, p14);

    if v16 then
        return u8.getEntityCamp(v16);
    end;

    return nil;
end;

function u8.getEntityOwnerId(p17) -- Line: 138
    if not (p17 and p17:IsA("Model")) then
        return nil, nil;
    end;

    local v18 = p17:GetAttribute("OwnerId");
    local v19 = p17:GetAttribute("OwnerType");

    if v18 == nil or v19 == nil then
        return nil, nil;
    end;

    return v18, tostring(v19);
end;

function u8.getEntityOwnerIdById(p20, p21) -- Line: 156
    -- upvalues: GetSkillData (copy), u8 (copy)
    if not (p20 and p21) then
        return nil, nil;
    end;

    local v22 = GetSkillData.getCharacter(p21, p20);

    if v22 then
        return u8.getEntityOwnerId(v22);
    end;

    return nil, nil;
end;

function u8.isSameEntity(p23, p24) -- Line: 171
    -- upvalues: u8 (copy)
    if not (p23 and p24) then
        return false;
    end;

    local v25, v26 = u8.getEntityIdentity(p23);
    local v27, v28 = u8.getEntityIdentity(p24);

    if not (v25 and v27) then
        return p23 == p24;
    end;

    local v29;

    if v25 == v27 then
        v29 = v26 == v28;
    else
        v29 = false;
    end;

    return v29;
end;

function u8.isOwnedBy(p30, p31, p32) -- Line: 182
    -- upvalues: u8 (copy)
    if not (p30 and (p31 and p32)) then
        return false;
    end;

    local v33, v34 = u8.getEntityIdentity(p32);

    if not (v33 and v34) then
        return false;
    end;

    if u8.idsEqual(v33, p30) and v34 == p31 then
        return true;
    end;

    local v35, v36 = u8.getEntityOwnerIdById(p30, p31);

    if v35 and (v36 and (u8.idsEqual(v33, v35) and v34 == v36)) then
        return true;
    end;

    local v37, v38 = u8.getEntityOwnerId(p32);

    return v37 and (v38 and (u8.idsEqual(v37, p30) and v38 == p31)) and true or false;
end;

function u8.isNonHostileTarget(p39, p40, p41) -- Line: 215
    -- upvalues: u8 (copy)
    return u8.isOwnedBy(p39, p40, p41) and true or (u8.isFriendly({
        id = p39,
        type = p40
    }, p41) and true or (u8.isForeignPlayerOwnedSummon(p39, p40, p41) and true or false));
end;

function u8.isForeignPlayerOwnedSummon(p42, p43, p44) -- Line: 228
    -- upvalues: u8 (copy)
    if p43 ~= "Player" or typeof(p42) ~= "number" then
        return false;
    end;

    local v45, v46 = u8.getEntityOwnerId(p44);

    if v46 == "Player" and v45 ~= nil then
        return not u8.idsEqual(v45, p42);
    end;

    return false;
end;

function u8.isFriendly(p47, p48) -- Line: 245
    -- upvalues: u8 (copy)
    local v49;

    if type(p47) == "table" and (p47.id and p47.type) then
        v49 = u8.getCampById(p47.id, p47.type);
    else
        if typeof(p47) ~= "Instance" or not p47:IsA("Model") then
            return false;
        end;

        v49 = u8.getEntityCamp(p47);
    end;

    local v50;

    if type(p48) == "table" and (p48.id and p48.type) then
        v50 = u8.getCampById(p48.id, p48.type);
    else
        if typeof(p48) ~= "Instance" or not p48:IsA("Model") then
            return false;
        end;

        v50 = u8.getEntityCamp(p48);
    end;

    if v49 and v50 then
        return v49 == v50;
    end;

    return false;
end;

return u8;