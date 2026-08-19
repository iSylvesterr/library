-- Decompiled with Potassium's decompiler.

local VoodooDomain = require(script.VoodooDomain);
local ShadowLight = require(script.ShadowLight);
local v1 = {
    VoodooDomain = VoodooDomain,
    ShadowLight = ShadowLight
};
local u2 = {
    VoodooDomain = VoodooDomain,
    ShadowLight = ShadowLight
};

function v1.Has(p3) -- Line: 48
    -- upvalues: u2 (copy)
    return u2[p3] ~= nil;
end;

function v1.Play(p4, p5) -- Line: 59
    -- upvalues: u2 (copy)
    local v6 = u2[p4];

    if v6 and v6.Play then
        return v6.Play(p5) == true;
    end;

    return false;
end;

function v1.Stop(p7, p8) -- Line: 74
    -- upvalues: u2 (copy)
    local v9 = u2[p7];

    if v9 and v9.Stop then
        v9.Stop(p8);
    end;

    return nil;
end;

return v1;