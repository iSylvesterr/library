-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Database.Custom.Types);
local u2 = {};
local u3 = {};

function v1.GetMissionDefinition(p4) -- Line: 22
    -- upvalues: u2 (copy)
    return u2[p4];
end;

function v1.GetMissionCategory(p5) -- Line: 28
    -- upvalues: u2 (copy)
    local v6 = u2[p5];

    if v6 and v6.Category then
        return v6.Category;
    end;

    return nil;
end;

function v1.GetMissionDisplayName(p7) -- Line: 40
    -- upvalues: u2 (copy)
    local v8 = u2[p7];

    if v8 then
        p7 = v8.DisplayName or p7;
    end;

    return p7;
end;

function v1.GetMissionDefinitions() -- Line: 47
    -- upvalues: u3 (copy)
    return table.clone(u3);
end;

function v1.IsMissionAvailableForGamemode(p9, p10, p11) -- Line: 53
    if not p9.Gamemodes then
        return true;
    end;

    if not p10 then
        return p11 == true;
    end;

    for _, v in ipairs(p9.Gamemodes) do
        if v == p10 then
            return true;
        end;
    end;

    return false;
end;

for _, descendant in ipairs(script:GetDescendants()) do
    if descendant:IsA("ModuleScript") then
        local v12 = require(descendant);

        if v12 and v12.MissionId then
            u2[v12.MissionId] = v12;
            table.insert(u3, v12);
        end;
    end;
end;

return v1;