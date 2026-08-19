-- Decompiled with Potassium's decompiler.

return {
    Name = "run-lines",
    Description = "Splits input by newlines and runs each line as its own command. This is used by the init-run command.",
    Group = "DefaultUtil",
    Aliases = {},
    Args = { {
            Type = "string",
            Name = "Script",
            Description = "The script to parse.",
            Default = ""
        } },

    ClientRun = function(p1, p2) -- Line: 15, Name: ClientRun
        if #p2 == 0 then
            return "";
        end;

        local v3 = p1.Dispatcher:Run("var", "INIT_PRINT_OUTPUT") ~= "";
        local v4 = p2:gsub("\n+", "\n"):split("\n");

        for _, v in ipairs(v4) do
            if v:sub(1, 1) ~= "#" then
                local v5 = p1.Dispatcher:EvaluateAndRun(v);

                if v3 then
                    p1:Reply(v5);
                end;
            end;
        end;

        return "";
    end
};