-- Decompiled with Potassium's decompiler.

return {
    Name = "setskillpointlevel",
    Description = "Sets a player\'s skill (BaseSpeed/BaseJump/ShovelPower/MaxBackpack) to a specific level",
    Group = "DefaultAdmin",
    Aliases = { "setskillpointlevel", "setskill", "setskilllevel" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to set the skill level for"
        }, {
            Type = "skillName",
            Name = "SkillName",
            Description = "The skill to set (BaseSpeed, BaseJump, ShovelPower, MaxBackpack)"
        }, {
            Type = "positiveInteger",
            Name = "Level",
            Description = "The level to set the skill to (>=1)"
        } }
};