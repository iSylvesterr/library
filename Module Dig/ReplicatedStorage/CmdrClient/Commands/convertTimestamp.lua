-- Decompiled with Potassium's decompiler.

return {
    Name = "convertTimestamp",
    Description = "Convert a timestamp to a human-readable format.",
    Group = "DefaultUtil",
    Aliases = { "date" },
    Args = { {
            Type = "number",
            Name = "timestamp",
            Description = "A numerical representation of a specific moment in time.",
            Optional = true
        } },

    ClientRun = function(p1, p2) -- Line: 14, Name: ClientRun
        local v3 = p2 or os.time();

        return `{os.date("%x", v3)} {os.date("%X", v3)}`;
    end
};