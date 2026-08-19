-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local Workspace = game:GetService("Workspace");
local ReplicatedFirst = game:GetService("ReplicatedFirst");
local UtilsSystem = require(ReplicatedFirst.AllSideCode.UtilsSystem);
local EnemyLogicalTypes = UtilsSystem.EnemyLogicalTypes;
local v1 = {};
local u2 = { "Monster", "Summons", "SpaceMirrors" };
local u3 = EnemyLogicalTypes and EnemyLogicalTypes.LOCAL_MONSTER_FOLDER_NAME or "LocalMonster";

function v1.encode(p4) -- Line: 28
    -- upvalues: Players (copy), Workspace (copy), u3 (copy), u2 (copy)
    if not (p4 and p4:IsA("Model")) then
        return nil, nil;
    end;

    local v5 = Players:GetPlayerFromCharacter(p4);

    if v5 then
        return "Player", tostring(v5.UserId);
    end;

    local v6 = Workspace:FindFirstChild(u3);

    if v6 and p4:IsDescendantOf(v6) then
        return u3, p4.Name;
    end;

    for _, v in u2 do
        local v7 = Workspace:FindFirstChild(v);

        if v7 and p4:IsDescendantOf(v7) then
            return v, p4.Name;
        end;
    end;

    return nil, nil;
end;

function v1.decode(p8, p9) -- Line: 60
    -- upvalues: Players (copy), u3 (copy), UtilsSystem (copy), Workspace (copy)
    if typeof(p8) ~= "string" or (typeof(p9) ~= "string" or p9 == "") then
        return nil;
    end;

    if p8 == "Player" then
        local v10 = tonumber(p9);

        if not v10 then
            return nil;
        end;

        local v11 = Players:GetPlayerByUserId(v10);

        if v11 then
            v11 = v11.Character;
        end;

        return v11;
    end;

    if p8 ~= u3 then
        local v12 = Workspace:FindFirstChild(p8);

        if not v12 then
            return nil;
        end;

        local v13 = v12:FindFirstChild(p9);

        if v13 and v13:IsA("Model") then
            return v13;
        end;

        return nil;
    end;

    local SystemLogicalEnemy = UtilsSystem.SystemLogicalEnemy;
    local v14 = SystemLogicalEnemy and SystemLogicalEnemy.GetModel and SystemLogicalEnemy.GetModel(p9);

    if v14 then
        return v14;
    end;

    local v15 = Workspace:FindFirstChild(u3);

    if v15 then
        local v16 = v15:FindFirstChild(p9);

        if v16 and v16:IsA("Model") then
            return v16;
        end;
    end;

    return nil;
end;

function v1.isLocalMonsterRoot(p17) -- Line: 112
    -- upvalues: u3 (copy)
    return p17 == u3;
end;

return v1;