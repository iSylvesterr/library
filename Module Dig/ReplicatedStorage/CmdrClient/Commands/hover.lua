-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");

return {
    Name = "hover",
    Description = "Returns the name of the player you are hovering over.",
    Group = "DefaultUtil",
    Args = {},

    ClientRun = function() -- Line: 9, Name: ClientRun
        -- upvalues: Players (copy)
        local Target = Players.LocalPlayer:GetMouse().Target;

        if not Target then
            return "";
        end;

        local v1 = Players:GetPlayerFromCharacter(Target:FindFirstAncestorOfClass("Model"));

        return v1 and v1.Name or "";
    end
};