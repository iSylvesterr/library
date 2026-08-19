-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");

return {
    Name = "clear",
    Description = "Clear all lines above the entry line of the Cmdr window.",
    Group = "DefaultUtil",
    Aliases = {},
    Args = {},

    ClientRun = function() -- Line: 9, Name: ClientRun
        -- upvalues: Players (copy)
        local Cmdr = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Cmdr");
        local Frame = Cmdr:WaitForChild("Frame");

        if Cmdr and Frame then
            for _, child in pairs(Frame:GetChildren()) do
                if child.Name == "Line" and child:IsA("TextBox") then
                    child:Destroy();
                end;
            end;
        end;

        return "";
    end
};