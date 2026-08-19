-- Decompiled with Potassium's decompiler.

local Hover = game:GetService("SoundService").Hover;

return ({
    PlayHoverSound = function() -- Line: 6, Name: PlayHoverSound
        -- upvalues: Hover (copy)
        Hover.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        Hover.Playing = true;
        Hover.Volume = 1;
        Hover.TimePosition = 0;
    end
}).PlayHoverSound;