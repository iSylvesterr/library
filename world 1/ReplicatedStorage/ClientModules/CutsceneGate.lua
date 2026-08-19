-- Decompiled with Potassium's decompiler.

local LocalPlayer = game:GetService("Players").LocalPlayer;

return {
    IsActive = function() -- Line: 11, Name: IsActive
        -- upvalues: LocalPlayer (copy)
        return LocalPlayer:GetAttribute("CutsceneInputBlocked") == true;
    end
};