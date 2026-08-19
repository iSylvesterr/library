-- Decompiled with Potassium's decompiler.

local v1 = {
    Funnels = {
        ONBOARDING = {
            id = "ONBOARDING",
            steps = {
                JOINED_GAME = {
                    id = "JOINED_GAME",
                    name = "Joined game",
                    step = 1
                },
                BOUGHT_OAK_SEED = {
                    id = "BOUGHT_OAK_SEED",
                    name = "Bought an Oak Seed",
                    step = 2
                },
                PLANTED_SEED = {
                    id = "PLANTED_SEED",
                    name = "Planted Seed",
                    step = 3
                },
                HARVESTED_TREE = {
                    id = "HARVESTED_TREE",
                    name = "Harvested Tree",
                    step = 4
                },
                SOLD_TREE = {
                    id = "SOLD_TREE",
                    name = "Sold Tree",
                    step = 5
                },
                REACHED_REBIRTH_1 = {
                    id = "REACHED_REBIRTH_1",
                    name = "Reached Rebirth 1",
                    step = 6
                },
                HARVESTED_FRUIT = {
                    id = "HARVESTED_FRUIT",
                    name = "Harvested a fruit",
                    step = 7
                },
                REACHED_REBIRTH_2 = {
                    id = "REACHED_REBIRTH_2",
                    name = "Reached Rebirth 2",
                    step = 8
                },
                OPENED_FARMERS_MARKET = {
                    id = "OPENED_FARMERS_MARKET",
                    name = "Opened Farmers Market",
                    step = 9
                },
                ACQUIRED_TICKETS = {
                    id = "ACQUIRED_TICKETS",
                    name = "Acquired Tickets",
                    step = 10
                },
                REACHED_REBIRTH_3 = {
                    id = "REACHED_REBIRTH_3",
                    name = "Reached Rebirth 3",
                    step = 11
                },
                REACHED_REBIRTH_4 = {
                    id = "REACHED_REBIRTH_4",
                    name = "Reached Rebirth 4",
                    step = 12
                },
                REACHED_REBIRTH_5 = {
                    id = "REACHED_REBIRTH_5",
                    name = "Reached Rebirth 5",
                    step = 13
                }
            }
        }
    },
    CustomEvents = {
        PLOT_FRUIT_VALUE = "PLOT_FRUIT_VALUE"
    }
};
local u2 = {};

function v1.GetOrderedSteps(p3, p4) -- Line: 37
    -- upvalues: u2 (copy)
    local v5 = p3.Funnels[p4];

    if v5 then
        local steps = v5.steps;

        if not u2[p4] then
            u2[p4] = {};

            for i, v in steps do
                u2[p4][v.step] = i;
            end;
        end;

        return u2[p4];
    end;

    warn("INVALID FUNNEL " .. tostring(p4));
end;

return v1;