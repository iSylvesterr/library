-- Decompiled with Potassium's decompiler.

local Util = require(script.Parent.Parent.Shared.Util);
local Players = game:GetService("Players");
local u1 = {};

local function getUserId(p2) -- Line: 5
    -- upvalues: u1 (copy), Players (copy)
    if u1[p2] then
        return u1[p2];
    end;

    if Players:FindFirstChild(p2) then
        u1[p2] = Players[p2].UserId;

        return Players[p2].UserId;
    end;

    local success, result = pcall(Players.GetUserIdFromNameAsync, Players, p2);

    if not success then
        return nil;
    end;

    u1[p2] = result;

    return result;
end;

local u11 = {
    DisplayName = "Full Player Name",
    Prefixes = "# integer",

    Transform = function(p3) -- Line: 27, Name: Transform
        -- upvalues: Util (copy), Players (copy)
        return p3, Util.MakeFuzzyFinder(Players:GetPlayers())(p3);
    end,

    ValidateOnce = function(p4) -- Line: 33, Name: ValidateOnce
        -- upvalues: u1 (copy), Players (copy)
        local v5;

        if u1[p4] then
            v5 = u1[p4];
        elseif Players:FindFirstChild(p4) then
            u1[p4] = Players[p4].UserId;
            v5 = Players[p4].UserId;
        else
            local v6;
            v6, v5 = pcall(Players.GetUserIdFromNameAsync, Players, p4);

            if v6 then
                u1[p4] = v5;
            else
                v5 = nil;
            end;
        end;

        return v5 ~= nil, "No player with that name could be found.";
    end,

    Autocomplete = function(p7, p8) -- Line: 37, Name: Autocomplete
        -- upvalues: Util (copy)
        return Util.GetNames(p8);
    end,

    Parse = function(p9) -- Line: 41, Name: Parse
        -- upvalues: u1 (copy), Players (copy)
        if u1[p9] then
            return u1[p9];
        end;

        if Players:FindFirstChild(p9) then
            u1[p9] = Players[p9].UserId;

            return Players[p9].UserId;
        end;

        local success, result = pcall(Players.GetUserIdFromNameAsync, Players, p9);

        if not success then
            return nil;
        end;

        u1[p9] = result;

        return result;
    end,

    Default = function(p10) -- Line: 45, Name: Default
        return p10.Name;
    end,

    ArgumentOperatorAliases = {
        me = ".",
        all = "*",
        others = "**",
        random = "?"
    }
};

return function(p12) -- Line: 57
    -- upvalues: u11 (copy), Util (copy)
    p12:RegisterType("playerId", u11);
    p12:RegisterType("playerIds", Util.MakeListableType(u11, {
        Prefixes = "# integers"
    }));
end;