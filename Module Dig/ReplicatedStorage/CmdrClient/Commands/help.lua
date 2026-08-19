-- Decompiled with Potassium's decompiler.

return {
    Name = "help",
    Description = "Displays a list of all commands, or inspects one command.",
    Group = "Help",
    Args = { {
            Type = "command",
            Name = "Command",
            Description = "The command to view information on",
            Optional = true
        } },

    ClientRun = function(p1, p2) -- Line: 31, Name: ClientRun
        if p2 then
            local v3 = p1.Cmdr.Registry:GetCommand(p2);
            p1:Reply(`Command: {v3.Name}`, Color3.fromRGB(230, 126, 34));

            if v3.Aliases and #v3.Aliases > 0 then
                p1:Reply(`Aliases: {table.concat(v3.Aliases, ", ")}`, Color3.fromRGB(230, 230, 230));
            end;

            p1:Reply(v3.Description, Color3.fromRGB(230, 230, 230));

            for i, v in ipairs(v3.Args) do
                p1:Reply((`#{i} {v.Name}{v.Optional == true and "?" or ""}: {v.Type} - {v.Description}`));
            end;
        else
            p1:Reply("Argument Shorthands\n-------------------\n.   Me/Self\n*   All/Everyone\n**  Others\n?   Random\n?N  List of N random values\n");
            p1:Reply("Tips\n----\n• Utilize the Tab key to automatically complete commands\n• Easily select and copy command output\n");
            local v4 = p1.Cmdr.Registry:GetCommands();
            table.sort(v4, function(p5, p6) -- Line: 49
                if p5.Group and p6.Group then
                    return p5.Group < p6.Group;
                end;

                return p5.Group;
            end);
            local v7 = nil;

            for _, v in ipairs(v4) do
                v.Group = v.Group or "No Group";

                if v7 ~= v.Group then
                    p1:Reply((`\n{v.Group}\n{string.rep("-", #v.Group)}`));
                    v7 = v.Group;
                end;

                local v8;

                if v.Description then
                    v8 = `{v.Name} - {v.Description}`;
                else
                    v8 = v.Name;
                end;

                p1:Reply(v8);
            end;
        end;

        return "";
    end
};