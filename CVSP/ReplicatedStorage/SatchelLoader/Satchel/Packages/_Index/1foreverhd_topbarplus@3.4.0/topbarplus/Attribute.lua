-- Decompiled with Potassium's decompiler.

task.defer(function() -- Line: 21
    local RunService = game:GetService("RunService");
    local VERSION = require(script.Parent.VERSION);
    local v1 = VERSION.getAppVersion();
    local v2 = VERSION.getLatestVersion();
    local v3 = not VERSION.isUpToDate();

    if not RunService:IsStudio() then
        print((`🍍 Running TopbarPlus {v1} by @ForeverHD & HD Admin`));
    end;

    if v3 then
        warn((`A new version of TopbarPlus ({v2}) is available: https://devforum.roblox.com/t/topbarplus/1017485`));
    end;
end);

return {};