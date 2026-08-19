-- Decompiled with Potassium's decompiler.

return {
    Name = "auctionbutton",
    Description = "Force-show/hide the left-side Auction shop button for a player (QA), overriding the Game.Auctioneer.Enabled/OpenEnabled flags. Use \'clear\' to revert to the flag-driven default.",
    Group = "DefaultAdmin",
    Aliases = { "auctionbutton", "auctionbtn" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to override"
        }, {
            Type = "string",
            Name = "Mode",
            Description = "show | hide | clear"
        } }
};