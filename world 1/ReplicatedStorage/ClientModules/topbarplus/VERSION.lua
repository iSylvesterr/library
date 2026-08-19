-- Decompiled with Potassium's decompiler.

local u1 = {
    appVersion = "v3.4.0"
};

function u1.getLatestVersion() -- Line: 17
    -- upvalues: u1 (copy)
    return u1.appVersion;
end;

function u1.getAppVersion() -- Line: 21
    -- upvalues: u1 (copy)
    return u1.appVersion;
end;

function u1.isUpToDate() -- Line: 25
    -- upvalues: u1 (copy)
    local v2 = u1.getLatestVersion();
    local v3 = u1.getAppVersion();
    local v4;

    if v2 == nil then
        v4 = false;
    else
        v4 = v2 == v3;
    end;

    return v4;
end;

return u1;