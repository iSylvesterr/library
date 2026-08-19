-- Decompiled with Potassium's decompiler.

local v1 = {};
local Modules = script.Parent.Parent.Parent.Modules;
require(Modules.Types);
local Children = require(Modules.Symbol).new("Children");

local function ApplyChildren(u2, p3) -- Line: 16
    local v4 = {};

    if typeof(p3) ~= "table" then
        error("Invalid children type! Expected table, got " .. typeof(p3));
    end;

    for _, v in p3 do
        if typeof(v) ~= "Instance" then
            error("Invalid child type! Expected Instance, got " .. typeof(v));
        end;

        if pcall(function() -- Line: 31
            -- upvalues: v (copy), u2 (copy)
            v.Parent = u2;
        end) then
            table.insert(v4, v);
        end;
    end;

    return v4;
end;

local function GetOldChildren(p5, p6) -- Line: 43
    local v7 = {};

    for _, v in p5 do
        if not table.find(p6, v) then
            table.insert(v7, v);
        end;
    end;

    return v7;
end;

function v1.__call(p8, u9, u10) -- Line: 56
    -- upvalues: ApplyChildren (copy), GetOldChildren (copy)
    if typeof(u10) ~= "table" then
        error("Invalid children type! Expected table, got " .. typeof(u10));
    end;

    if not u10.__SEAM_OBJECT or tostring(u10.__SEAM_OBJECT) ~= "ComputedInstance" then
        ApplyChildren(u9, u10);

        return;
    end;

    local u11 = ApplyChildren(u9, u10.Value);
    local u12 = u10.Changed:Connect(function() -- Line: 65
        -- upvalues: GetOldChildren (ref), u11 (ref), u10 (copy), ApplyChildren (ref), u9 (copy)
        for _, v in GetOldChildren(u11, u10.Value) do
            v:Destroy();
        end;

        u11 = ApplyChildren(u9, u10.Value);
    end);
    u9.Destroying:Connect(function() -- Line: 78
        -- upvalues: u12 (copy), u11 (ref)
        u12:Disconnect();

        for _, v in u11 do
            v:Destroy();
        end;
    end);
end;

function v1.__index(p13, p14) -- Line: 93
    -- upvalues: Children (copy)
    if p14 == "__SEAM_INDEX" then
        return Children;
    end;

    if p14 == "__SEAM_CAN_BE_SCOPED" then
        return false;
    end;

    return nil;
end;

return setmetatable({}, v1);