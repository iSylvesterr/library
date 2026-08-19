-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Modules = ReplicatedStorage:WaitForChild("Library"):WaitForChild("Modules");
local FFlags = require(Modules.FFlags);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local u1 = {
    Options = FFlags.Options,
    Keys = FFlags.Keys,
    currentData = {},
    currentDataSaved = {}
};
local u2 = {};

function u1.BulkGet(p3, p4, p5) -- Line: 21
    return true;
end;

function u1.Get(p6) -- Line: 48
    -- upvalues: FFlags (copy), u1 (copy)
    local v7 = assert(p6.Key, "Key must be provided to FastFlags.Get()");

    if typeof(v7) ~= "string" then
        error("Key must be string (was \'" .. typeof(v7) .. "\')");
    end;

    local v8 = FFlags.Options[v7];

    if not v8 then
        error("Missing Key: " .. v7);
    end;

    local v9 = u1.currentData[v7];

    if v9 == nil and not v8.Nullable then
        v9 = v8.Default;
    end;

    return v9;
end;

function u1.CanBypass(p10) -- Line: 64
    -- upvalues: u1 (copy), Players (copy), Asserts (copy), u2 (copy), FFlags (copy)
    if not u1.Keys.AdminFFlagBypass and u1.Get(u1.Keys.AdminFFlagBypass) then
        return false;
    end;

    local v11 = p10 or Players.LocalPlayer;
    Asserts.Player(v11);
    assert(v11, "luau");

    if u2[v11] ~= nil then
        return u2[v11];
    end;

    local v12 = FFlags.Admins[v11.UserId] and true or false;
    u2[v11] = v12;

    return v12;
end;

return u1;