-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SeedData = require(ReplicatedStorage.SharedModules.SeedData);
local v1 = {
    MAX_STACK_DEFAULT = 1000000
};
local u2 = {
    Seeds = true
};
v1.STRICT_NAME_CATEGORIES = u2;
local v3 = {};
local v4 = { "Beanstalk", "Lotus", "Pumpkin", "Thorn Rose" };
local u5 = {};

for _, v in SeedData do
    if type(v) == "table" and type(v.SeedName) == "string" then
        v3[v.SeedName] = true;
    end;
end;

for _, v in v4 do
    v3[v] = true;
end;

u5.Seeds = v3;

function v1.IsStrictNameCategory(p6) -- Line: 83
    -- upvalues: u2 (copy)
    return u2[p6] == true;
end;

function v1.IsKnownStackableItem(p7, p8) -- Line: 91
    -- upvalues: u5 (copy)
    local v9 = u5[p7];

    if not v9 then
        return true;
    end;

    local v10;

    if type(p8) == "string" then
        v10 = v9[p8] == true;
    else
        v10 = false;
    end;

    return v10;
end;

function v1.IsStackCountAllowed(p11, p12) -- Line: 109
    if p11 == nil then
        return true;
    end;

    if type(p11) ~= "number" then
        return false;
    end;

    if p11 ~= p11 then
        return false;
    end;

    if p11 <= 0 then
        return false;
    end;

    return p11 <= (p12 or 1000000);
end;

return v1;