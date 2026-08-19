-- Decompiled with Potassium's decompiler.

return {
    Name = "releasetestclear",
    Description = "DEV (local-only): clear the local test release-countdown from YOUR HUD (created by releasetest).",
    Group = "DefaultAdmin",
    Aliases = { "releasetestclear", "reltestclear" },
    Args = {},

    ClientRun = function(p1) -- Line: 15, Name: ClientRun
        local Controllers = game:GetService("Players").LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("Controllers");
        local v2 = require(Controllers:WaitForChild("ReleaseCountdownController")):DebugClear();

        return string.format("Cleared %d local test event(s) from your HUD.", v2);
    end
};