-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PetFlags = require(ReplicatedStorage.SharedModules.Flags.PetFlags);
local u1 = {
    Big = 2,
    Huge = 4
};
local u2 = {
    Big = 2,
    Huge = 3
};
local u3 = {};

function u3.GetScale(p4, p5) -- Line: 25
    -- upvalues: u3 (copy), u1 (copy)
    if type(p4) ~= "string" then
        return 1;
    end;

    local v6 = u3.Normalize(p4);

    if v6 == nil then
        return 1;
    end;

    if p5 ~= nil then
        local v7 = p5[v6];

        if type(v7) == "number" then
            return v7;
        end;
    end;

    return u1[v6] or 1;
end;

function u3.GetBoostMultiplier(p8) -- Line: 38
    -- upvalues: u3 (copy), u2 (copy)
    local v9 = u3.Normalize(p8);

    return v9 and (u2[v9] or 1) or 1;
end;

function u3.Normalize(p10) -- Line: 45
    -- upvalues: u1 (copy)
    if type(p10) ~= "string" then
        return nil;
    end;

    for i in u1 do
        if string.lower(p10) == string.lower(i) then
            return i;
        end;
    end;

    return nil;
end;

function u3.DisplaySize(p11) -- Line: 56
    -- upvalues: u3 (copy), PetFlags (copy)
    local v12 = u3.Normalize(p11);

    if v12 == "Huge" then
        return PetFlags.HugeSizeDisplayLabel:Get();
    end;

    return v12;
end;

function u3.DisplayName(p13, p14) -- Line: 65
    -- upvalues: u3 (copy), PetFlags (copy)
    local v15 = u3.Normalize(p14);

    if not v15 then
        return p13;
    end;

    if v15 == "Huge" then
        v15 = PetFlags.HugeSizeDisplayLabel:Get();
    end;

    return `{v15} {p13}`;
end;

u3.Scales = table.freeze(u1);
u3.BoostMultipliers = table.freeze(u2);

return table.freeze(u3);