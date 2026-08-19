-- Decompiled with Potassium's decompiler.

return {
    Name = "givefullinventory",
    Description = "Fills a player\'s harvested fruit inventory to max capacity",
    Group = "DefaultAdmin",
    Aliases = { "fillinventory", "fullinv" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to fill inventory for"
        }, {
            Type = "string",
            Name = "FruitName",
            Description = "The fruit name to fill with"
        }, {
            Type = "number",
            Name = "Weight",
            Description = "Weight per fruit (default 100)",
            Optional = true
        }, {
            Type = "boolean",
            Name = "AutoSell",
            Description = "Auto-sell after filling (default false)",
            Optional = true
        }, {
            Type = "number",
            Name = "MaxBackpack",
            Description = "MaxBackpack skill level to set (default 40)",
            Optional = true
        } }
};