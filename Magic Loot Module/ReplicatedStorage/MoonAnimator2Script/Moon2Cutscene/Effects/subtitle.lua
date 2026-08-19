-- Decompiled with Potassium's decompiler.

local Subtitles = script.Subtitles;

return function(p1, p2) -- Line: 9
    -- upvalues: Subtitles (copy)
    Subtitles.Parent = game:GetService("Players").LocalPlayer.PlayerGui;

    if p1 then
        for i, v in p2 or {} do
            Subtitles.Subtitles[i] = v;
        end;

        Subtitles.Subtitles.Text = p1;
    end;

    return Subtitles.Subtitles;
end;