-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");

return {
    Name = "bind",
    Description = "Binds a command string to a key or mouse input.",
    Group = "DefaultUtil",
    Aliases = {},
    Args = { {
            Type = "userInput ! bindableResource @ player",
            Name = "Input",
            Description = "The key or input type you\'d like to bind the command to."
        }, {
            Type = "command",
            Name = "Command",
            Description = "The command you want to run on this input"
        }, {
            Type = "string",
            Name = "Arguments",
            Description = "The arguments for the command",
            Default = ""
        } },

    ClientRun = function(u1, u2, p3, p4) -- Line: 27, Name: ClientRun
        -- upvalues: UserInputService (copy)
        local v5 = u1:GetStore("CMDR_Binds");
        local u6 = p3 .. " " .. p4;

        if v5[u2] then
            v5[u2]:Disconnect();
        end;

        local Name = u1:GetArgument(1).Type.Name;

        if Name == "userInput" then
            v5[u2] = UserInputService.InputBegan:Connect(function(p7, p8) -- Line: 39
                -- upvalues: u2 (copy), u1 (copy), u6 (ref)
                if p8 then
                    return;
                end;

                if p7.UserInputType == u2 or p7.KeyCode == u2 then
                    u1:Reply(u1.Dispatcher:EvaluateAndRun(u1.Cmdr.Util.RunEmbeddedCommands(u1.Dispatcher, u6)));
                end;
            end);
        else
            if Name == "bindableResource" then
                return "Unimplemented...";
            end;

            if Name == "player" then
                v5[u2] = u2.Chatted:Connect(function(p9) -- Line: 51
                    -- upvalues: u1 (copy), u6 (ref), u2 (copy)
                    local v10 = u1.Cmdr.Util.RunEmbeddedCommands(u1.Dispatcher, u1.Cmdr.Util.SubstituteArgs(u6, { p9 }));
                    u1:Reply(("%s $ %s : %s"):format(u2.Name, v10, u1.Dispatcher:EvaluateAndRun(v10)), Color3.fromRGB(244, 92, 66));
                end);
            end;
        end;

        return "Bound command to input.";
    end
};