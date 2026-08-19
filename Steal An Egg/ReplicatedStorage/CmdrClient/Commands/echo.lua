-- Decompiled with Potassium's decompiler.

return {
    Name = "echo",
    Description = "Echoes your text back to you.",
    Group = "DefaultUtil",
    Aliases = { "=" },
    Args = { {
            Type = "string",
            Name = "Text",
            Description = "The text."
        } },

    Run = function(p1, p2) -- Line: 14, Name: Run
        return p2;
    end
};