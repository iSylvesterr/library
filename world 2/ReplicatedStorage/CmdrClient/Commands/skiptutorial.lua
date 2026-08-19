-- Decompiled with Potassium's decompiler.

return {
    Name = "skiptutorial",
    Description = "QA: skip the tutorial. Flips a player\'s tutorial-completed flag, which is what every tutorial gate reads (the Starter Pack promo toast, gifting, mailing, dropping items, Gold/Rainbow/Mega seed spawns), AND exempts the account from cohort routing so a fresh tester stops being teleported to the First Session shard on every join (run it on a shard and it sends you home to the primary place). Setting it false does NOT replay the tutorial -- that only starts at data load -- it just puts the gates and the routing back. Account-scoped, so it follows the player between worlds. Dev place only.",
    Group = "DefaultAdmin",
    Aliases = { "qatutorialcomplete" },
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Whose tutorial flag to change.",
            Default = "me"
        }, {
            Type = "boolean",
            Name = "Completed",
            Description = "true (default) marks the tutorial finished so the gates open and cohort routing leaves them alone; false marks it unfinished and puts both back.",
            Optional = true
        } }
};