-- Decompiled with Potassium's decompiler.

return {
    Name = "releasetest",
    Description = "DEV (local-only): show a fake release-countdown on YOUR HUD to test the display. Nothing is sent to the server or other players.",
    Group = "DefaultAdmin",
    Aliases = { "releasetest", "reltest" },
    Args = { {
            Type = "string",
            Name = "Name",
            Description = "Event name shown on the HUD (default: Test Event).",
            Optional = true
        }, {
            Type = "number",
            Name = "Minutes",
            Description = "Minutes until release (default: 30; 0 = live now).",
            Optional = true
        }, {
            Type = "number",
            Name = "GraceMinutes",
            Description = "Minutes the \'OUT NOW\' state stays after release (default: 30).",
            Optional = true
        }, {
            Type = "number",
            Name = "RevealAssetId",
            Description = "Reveal icon asset id (default: example id; 0 = none).",
            Optional = true
        }, {
            Type = "number",
            Name = "SilhouetteAssetId",
            Description = "Silhouette icon asset id (default: example id; 0 = none).",
            Optional = true
        }, {
            Type = "string",
            Name = "Type",
            Description = "Drop type word in the banner (e.g. pet -> \'NEW PET IN\'; default: none).",
            Optional = true
        } },

    ClientRun = function(p1, p2, p3, p4, p5, p6, p7) -- Line: 60, Name: ClientRun
        local Controllers = game:GetService("Players").LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("Controllers");
        local ReleaseCountdownController = require(Controllers:WaitForChild("ReleaseCountdownController"));
        local v8 = typeof(p3) ~= "number" and 1800 or math.floor(p3 * 60);
        local v9 = typeof(p4) ~= "number" and 1800 or math.floor(p4 * 60);
        local v10 = typeof(p5) ~= "number" and 111661910767395 or p5;
        local v11 = typeof(p6) ~= "number" and 104030422854888 or p6;
        local v12 = {
            name = p2,
            type = p7,
            secondsUntil = v8,
            graceSeconds = v9
        };

        if v10 <= 0 then
            v10 = nil;
        end;

        v12.reveal_asset_id = v10;

        if v11 <= 0 then
            v11 = nil;
        end;

        v12.silhouette_asset_id = v11;
        local v13 = ReleaseCountdownController:DebugInject(v12);

        return string.format("Local test event \'%s\' shown on your HUD (releasing in %.0f min, grace %.0f min). Client-only. Use releasetestclear to remove.", v13.name, v8 / 60, v9 / 60);
    end
};