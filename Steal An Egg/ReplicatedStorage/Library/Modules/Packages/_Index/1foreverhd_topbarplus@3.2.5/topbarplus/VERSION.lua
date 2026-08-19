-- Decompiled with Potassium's decompiler.

local u1 = {
    appVersion = "v3.2.5",
    latestVersion = nil
};

function u1.getLatestVersion() -- Line: 10
    -- upvalues: u1 (copy)
    local latestVersion = u1.latestVersion;

    if latestVersion then
        return latestVersion;
    end;

    local v2;

    while true do
        local v3;
        v3, v2 = pcall(function() -- Line: 18
            return game:GetService("MarketplaceService"):GetProductInfo(117501901079852);
        end);

        if v3 and v2 then
            break;
        end;

        task.wait(1);
    end;

    local v4 = string.match(v2.Name, "^TopbarPlus (.*)$");

    if v4 then
        v4 = v4:gsub("%s+", "");
    end;

    u1.latestVersion = v4;

    return v4;
end;

function u1.getAppVersion() -- Line: 35
    -- upvalues: u1 (copy)
    return u1.appVersion;
end;

function u1.isUpToDate() -- Line: 39
    -- upvalues: u1 (copy)
    local v5 = u1.getLatestVersion();
    local v6 = u1.getAppVersion();
    local v7;

    if v5 == nil then
        v7 = false;
    else
        v7 = v5 == v6;
    end;

    return v7;
end;

return u1;