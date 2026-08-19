-- Decompiled with Potassium's decompiler.

return {
    Name = "unbind",
    Description = "Unbinds an input previously bound with Bind",
    Group = "DefaultUtil",
    Aliases = {},
    Args = { {
            Type = "userInput ! bindableResource @ player",
            Name = "Input/Key",
            Description = "The key or input type you\'d like to unbind."
        } },

    ClientRun = function(p1, p2) -- Line: 14, Name: ClientRun
        local v3 = p1:GetStore("CMDR_Binds");

        if not v3[p2] then
            return "That input wasn\'t bound.";
        end;

        v3[p2]:Disconnect();
        v3[p2] = nil;

        return "Unbound command from input.";
    end
};