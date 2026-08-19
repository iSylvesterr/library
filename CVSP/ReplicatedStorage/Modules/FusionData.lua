-- Decompiled with Potassium's decompiler.

local u1 = {
    SKIP_PRODUCT_ID = 3612591518,
    INHERIT_CHANCE = 0.25,
    Fusions = { {
            Capybara = "Magic Capybara",
            Plant = "Watermelon",
            Time = 600,
            Outcomes = { {
                    Name = "Wizardmelon",
                    Weight = 100
                } }
        }, {
            Capybara = "Ghost Capybara",
            Plant = "Fancy Avocado",
            Time = 1200,
            Outcomes = { {
                    Name = "Fancy Ghost Capybara",
                    Weight = 50
                }, {
                    Name = "Fancy Ghost Avocado",
                    Weight = 50
                } }
        }, {
            Capybara = "Robot Capybara",
            Plant = "Magic Mushroom",
            Time = 3600,
            Outcomes = { {
                    Name = "Robot Mushroom",
                    Weight = 100
                } }
        }, {
            Capybara = "Angel Capybara",
            Plant = "Pumpking",
            Time = 7200,
            Outcomes = { {
                    Name = "Shinigami Capybara",
                    Weight = 80
                }, {
                    Name = "Pumpkin",
                    Weight = 20
                } }
        }, {
            Capybara = "Disco Capybara",
            Plant = "True Carrot",
            Time = 10800,
            Outcomes = { {
                    Name = "Disco True Carrot",
                    Weight = 100
                } }
        } }
};

function u1.getFusion(p2, p3) -- Line: 71
    -- upvalues: u1 (copy)
    for _, v in ipairs(u1.Fusions) do
        if v.Capybara == p2 and v.Plant == p3 then
            return v;
        end;
    end;

    return nil;
end;

function u1.isEligibleCapybara(p4) -- Line: 81
    -- upvalues: u1 (copy)
    for _, v in ipairs(u1.Fusions) do
        if v.Capybara == p4 then
            return true;
        end;
    end;

    return false;
end;

function u1.isEligiblePlant(p5) -- Line: 88
    -- upvalues: u1 (copy)
    for _, v in ipairs(u1.Fusions) do
        if v.Plant == p5 then
            return true;
        end;
    end;

    return false;
end;

function u1.isValidPair(p6, p7) -- Line: 97
    -- upvalues: u1 (copy)
    return not (p6 and p7) and true or u1.getFusion(p6, p7) ~= nil;
end;

function u1.rollOutcome(p8) -- Line: 105
    local v9 = 0;

    for _, v in ipairs(p8.Outcomes) do
        v9 = v9 + v.Weight;
    end;

    local v10 = math.random() * v9;
    local v11 = 0;

    for _, v in ipairs(p8.Outcomes) do
        v11 = v11 + v.Weight;

        if v10 <= v11 then
            return v.Name;
        end;
    end;

    return p8.Outcomes[#p8.Outcomes].Name;
end;

function u1.formatTime(p12) -- Line: 129
    local v13 = math.floor(p12);
    local v14 = math.max(0, v13);
    local v15 = math.floor(v14 / 3600);
    local v16 = math.floor(v14 % 3600 / 60);
    local v17 = v14 % 60;

    if v15 > 0 then
        if v16 > 0 then
            return v15 .. "h " .. v16 .. "m";
        end;

        return v15 .. "h";
    end;

    if v16 <= 0 then
        return v17 .. "s";
    end;

    if v17 > 0 then
        return v16 .. "m " .. v17 .. "s";
    end;

    return v16 .. "m";
end;

return u1;