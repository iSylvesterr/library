-- Decompiled with Potassium's decompiler.

local u1 = nil;

return {
    Name = "confettitest",
    Description = "DEV (local-only): play screen confetti on YOUR screen for a number of seconds. Nothing is sent to the server or other players.",
    Group = "DefaultAdmin",
    Aliases = { "confettitest", "confetti" },
    Args = { {
            Type = "number",
            Name = "Duration",
            Description = "Seconds to keep spawning confetti (default: 3; 0 = one-shot burst; max 300).",
            Optional = true
        } },

    ClientRun = function(p2, p3) -- Line: 33, Name: ClientRun
        -- upvalues: u1 (ref)
        local Effects = game:GetService("ReplicatedStorage"):WaitForChild("ClientModules"):WaitForChild("Effects");
        local ScreenConfetti = require(Effects:WaitForChild("ScreenConfetti"));

        if u1 and u1:IsActive() then
            u1:Stop();
        end;

        local v4 = (typeof(p3) ~= "number" or p3 ~= p3) and 3 or math.clamp(p3, 0, 300);
        u1 = ScreenConfetti.Play({
            Duration = v4,
            Burst = v4 > 0 and 0 or 150
        });

        if v4 <= 0 then
            return string.format("Confetti burst of %d pieces on your screen. Client-only.", 150);
        end;

        return string.format("Confetti spawning for %.1fs on your screen, then falling clear. Client-only.", v4);
    end
};