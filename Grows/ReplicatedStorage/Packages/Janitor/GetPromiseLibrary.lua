-- Decompiled with Potassium's decompiler.

local ReplicatedFirst = game:GetService("ReplicatedFirst");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local ServerStorage = game:GetService("ServerStorage");
local u1 = {
    script.Parent.Parent,
    ReplicatedFirst,
    ReplicatedStorage,
    ServerScriptService,
    ServerStorage
};

local function FindFirstDescendantWithNameAndClassName(p2, p3, p4) -- Line: 9
    for _, descendant in ipairs(p2:GetDescendants()) do
        if descendant:IsA(p4) and descendant.Name == p3 then
            return descendant;
        end;
    end;

    return nil;
end;

return function() -- Line: 19, Name: GetPromiseLibrary
    -- upvalues: FindFirstDescendantWithNameAndClassName (copy), u1 (copy)
    local v5 = script:FindFirstAncestorOfClass("Plugin");

    if v5 then
        local v6 = FindFirstDescendantWithNameAndClassName(v5, "Promise", "ModuleScript");

        if v6 then
            return true, require(v6);
        end;

        return false;
    end;

    local v7 = nil;

    for _, v in ipairs(u1) do
        v7 = FindFirstDescendantWithNameAndClassName(v, "Promise", "ModuleScript");

        if v7 then
            break;
        end;
    end;

    if v7 then
        return true, require(v7);
    end;

    return false;
end;