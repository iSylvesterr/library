-- Decompiled with Potassium's decompiler.

return {
    Name = "qagivechestloot",
    Description = "QA: grant one of EVERY line in a chest\'s loot pool, through the same grant the chest itself uses. Admin Chest by default, whose Jandel Monkey is a 1-in-5,000 roll nobody can reach by opening. Reports each line pass/fail, so a reward type that resolves no inventory bucket shows up here instead of silently granting nothing. Dev place only.",
    Group = "DefaultAdmin",
    Aliases = { "qachestloot" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "Who receives the pool. Defaults to you.",
            Optional = true
        }, {
            Type = "chestName",
            Name = "ChestName",
            Description = "Which chest\'s pool to hand out. Defaults to Admin Chest.",
            Optional = true
        } }
};