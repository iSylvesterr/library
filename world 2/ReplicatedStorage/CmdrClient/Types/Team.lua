-- Decompiled with Potassium's decompiler.

local Teams = game:GetService("Teams");
local Util = require(script.Parent.Parent.Shared.Util);
local u5 = {
    Transform = function(p1) -- Line: 5, Name: Transform
        -- upvalues: Util (copy), Teams (copy)
        return Util.MakeFuzzyFinder(Teams:GetTeams())(p1);
    end,

    Validate = function(p2) -- Line: 11, Name: Validate
        return #p2 > 0, "No team with that name could be found.";
    end,

    Autocomplete = function(p3) -- Line: 15, Name: Autocomplete
        -- upvalues: Util (copy)
        return Util.GetNames(p3);
    end,

    Parse = function(p4) -- Line: 19, Name: Parse
        return p4[1];
    end
};
local u7 = {
    Listable = true,
    Transform = u5.Transform,
    Validate = u5.Validate,
    Autocomplete = u5.Autocomplete,

    Parse = function(p6) -- Line: 30, Name: Parse
        return p6[1]:GetPlayers();
    end
};
local u9 = {
    Transform = u5.Transform,
    Validate = u5.Validate,
    Autocomplete = u5.Autocomplete,

    Parse = function(p8) -- Line: 40, Name: Parse
        return p8[1].TeamColor;
    end
};

return function(p10) -- Line: 45
    -- upvalues: u5 (copy), Util (copy), u7 (copy), u9 (copy)
    p10:RegisterType("team", u5);
    p10:RegisterType("teams", Util.MakeListableType(u5));
    p10:RegisterType("teamPlayers", u7);
    p10:RegisterType("teamColor", u9);
    p10:RegisterType("teamColors", Util.MakeListableType(u9));
end;