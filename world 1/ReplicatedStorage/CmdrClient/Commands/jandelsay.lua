-- Decompiled with Potassium's decompiler.

return {
    Name = "jandelsay",
    Description = "GLOBAL: push a Jandel commentary line to EVERY player on EVERY live server. Quote multi-word messages, e.g. jandelsay \"Bamboo Bonk starts now!\". Pass a User to speak as someone else (their name + avatar).",
    Group = "DefaultAdmin",
    Aliases = { "jandelsay", "commentary" },
    Args = { {
            Type = "string",
            Name = "Message",
            Description = "What the speaker says (quote multi-word messages)."
        }, {
            Type = "playerId",
            Name = "User",
            Description = "Username, or #<userId>, to speak as instead of Jandel.",
            Optional = true
        } }
};