-- Decompiled with Potassium's decompiler.

local Util = require(script.Parent.Parent.Shared.Util);
local Players = game:GetService("Players");
local u6 = {
    Transform = function(p1) -- Line: 5, Name: Transform
        -- upvalues: Util (copy), Players (copy)
        return Util.MakeFuzzyFinder(Players:GetPlayers())(p1);
    end,

    Validate = function(p2) -- Line: 11, Name: Validate
        return #p2 > 0, "No player with that name could be found.";
    end,

    Autocomplete = function(p3) -- Line: 15, Name: Autocomplete
        -- upvalues: Util (copy)
        return Util.GetNames(p3);
    end,

    Parse = function(p4) -- Line: 19, Name: Parse
        return p4[1];
    end,

    Default = function(p5) -- Line: 23, Name: Default
        return p5.Name;
    end,

    ArgumentOperatorAliases = {
        me = ".",
        all = "*",
        others = "**",
        random = "?"
    }
};

return function(p7) -- Line: 35
    -- upvalues: u6 (copy), Util (copy)
    p7:RegisterType("player", u6);
    p7:RegisterType("players", Util.MakeListableType(u6, {
        Prefixes = "% teamPlayers"
    }));
end;