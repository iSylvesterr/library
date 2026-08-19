-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local MedalClipper = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("MedalClipper"));
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local u2 = RunService:IsStudio();

local function triggerMedalClip(u3) -- Line: 25
    -- upvalues: u2 (copy), MedalClipper (copy)
    if u2 then
        print("[MedalAutoClipController]", "Received clip request", `eventId={u3.EventId}`, `eventName={u3.EventName}`, `duration={u3.Duration}`, (`captureDelayMs={u3.CaptureDelayMs or 0}`));
    end;

    local success, result = pcall(function() -- Line: 37
        -- upvalues: MedalClipper (ref), u3 (copy)
        MedalClipper:TriggerClip(u3.EventId, u3.EventName, {
            duration = u3.Duration,
            captureDelayMs = u3.CaptureDelayMs,
            contextTags = u3.ContextTags
        });
    end);

    if success then
        if u2 then
            print("[MedalAutoClipController]", "Medal TriggerClip completed", u3.EventName);
        end;

        return;
    end;

    warn((`[MedalAutoClipController] Failed to trigger Medal clip: {result}`));
end;

function v1.Initialize() -- Line: 52
    -- upvalues: Remotes (copy), triggerMedalClip (copy)
    Remotes.Collaborations.MedalAutoClip.Listen(triggerMedalClip);
end;

return v1;