-- Decompiled with Potassium's decompiler.

local u1 = {
    starterIsland = {
        cost = 0,
        luck = 1,
        buriedNodeCount = 11
    },
    island2 = {
        cost = 1100000,
        luck = 2,
        buriedNodeCount = 9
    }
};

return {
    ISLAND_ID_ATTRIBUTE = "islandId",
    STARTER_ISLAND_ID = "starterIsland",

    isIslandId = function(p2) -- Line: 17, Name: isIslandId
        -- upvalues: u1 (copy)
        local v3 = type(p2) == "string" and u1[p2] ~= nil;

        return v3;
    end,

    isIslandUnlocked = function(p4, p5) -- Line: 25, Name: isIslandUnlocked
        -- upvalues: u1 (copy)
        local v6 = u1[p4].cost == 0;

        if not v6 then
            if p5 ~= nil then
                p5 = table.find(p5, p4) ~= nil;
            end;

            v6 = p5 == true;
        end;

        return v6;
    end,

    Islands = u1,
    ISLAND_ORDER = { "starterIsland", "island2" }
};