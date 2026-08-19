-- Decompiled with Potassium's decompiler.

local Click = game:GetService("SoundService").Click;

return function() -- Line: 4, Name: PlayClickSound
    -- upvalues: Click (copy)
    Click.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
    Click.Playing = true;
    Click.TimePosition = 0;
end;