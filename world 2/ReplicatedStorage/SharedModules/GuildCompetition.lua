-- Decompiled with Potassium's decompiler.

local NumberUtils = require(script.Parent.NumberUtils);
local WeightFormat = require(script.Parent.WeightFormat);
local u1 = {
    Tags = {
        CarrotsHarvested = "carrots_harvested",
        GoldenCarrotsHarvested = "golden_carrots_harvested",
        PlantWeightHarvested = "plant_weight_harvested",
        PlantHeight = "plant_height",
        InventorySaleValue = "inventory_sale_value",
        CarrotWeight = "carrot_weight",
        CarrotWeightGold = "carrot_weight_gold",
        CarrotWeightRainbow = "carrot_weight_rainbow",
        ShecklesSpentSeeds = "sheckles_spent_seeds",
        ShecklesSpentGear = "sheckles_spent_gear",
        ShecklesSpentEquipGear = "sheckles_spent_equip_gear",
        ShecklesSpentCrates = "sheckles_spent_crates",
        ShecklesSpentAuction = "sheckles_spent_auction",
        ShecklesSpentPets = "sheckles_spent_pets",
        ShecklesSpentExpansions = "sheckles_spent_expansions",
        ShecklesSpentPetSlots = "sheckles_spent_pet_slots",
        ShecklesSpentGuildSlots = "sheckles_spent_guild_slots"
    }
};
local u2 = nil;

function u1._setReporter(p3) -- Line: 80
    -- upvalues: u2 (ref)
    u2 = p3;
end;

function u1.Report(p4, p5, p6) -- Line: 89
    -- upvalues: u2 (ref)
    if not u2 then
        return;
    end;

    if typeof(p4) ~= "Instance" or not p4:IsA("Player") then
        return;
    end;

    if typeof(p6) ~= "number" or (p6 ~= p6 or p6 <= 0) then
        return;
    end;

    u2(p4, p5, p6);
end;

function u1.ReportPetTamed(p7, p8, p9) -- Line: 109
    -- upvalues: u1 (copy)
    if typeof(p8) ~= "string" or p8 == "" then
        return;
    end;

    local v10 = (typeof(p9) ~= "number" or p9 <= 0) and 1 or p9;
    u1.Report(p7, "pet_tamed_" .. string.lower(p8), v10);
end;

function u1.SaleValueTag(p11) -- Line: 128
    -- upvalues: u1 (copy)
    if typeof(p11) == "string" and (p11 ~= "" and p11 ~= "Main") then
        return u1.Tags.InventorySaleValue .. "_" .. string.lower(p11);
    end;

    return u1.Tags.InventorySaleValue;
end;

function u1.DescribeHarvest(p12, p13, p14) -- Line: 148
    -- upvalues: u1 (copy)
    local v15 = {};

    if typeof(p13) ~= "number" or (p13 ~= p13 or p13 <= 0) then
        return v15;
    end;

    local Tags = u1.Tags;
    v15[Tags.PlantWeightHarvested] = p13;

    if p12 == "Carrot" then
        v15[Tags.CarrotsHarvested] = 1;

        if p14 == "Gold" then
            v15[Tags.GoldenCarrotsHarvested] = 1;
            v15[Tags.CarrotWeightGold] = p13;

            return v15;
        end;

        if p14 == "Rainbow" then
            v15[Tags.CarrotWeightRainbow] = p13;

            return v15;
        end;

        v15[Tags.CarrotWeight] = p13;
    end;

    return v15;
end;

function u1.Reduce(p16, p17, p18) -- Line: 181
    if not (p16 and p17) then
        return 0;
    end;

    local v19 = p18 == "max";
    local v20 = 0;

    for i, v in p16 do
        local v21 = p17[i];

        if typeof(v21) == "number" and typeof(v) == "number" then
            local v22 = v21 * v;

            if v19 then
                if v20 < v22 then
                    v20 = v22;
                end;
            else
                v20 = v20 + v22;
            end;
        end;
    end;

    return v20;
end;

u1.ScoreFormats = {
    integer = function(p23) -- Line: 210, Name: integer
        return string.format("%d", (math.round(p23)));
    end,

    commas = function(p24) -- Line: 214, Name: commas
        -- upvalues: NumberUtils (copy)
        return NumberUtils.FormatWithCommas((math.round(p24)));
    end,

    abbreviated = function(p25) -- Line: 218, Name: abbreviated
        -- upvalues: NumberUtils (copy)
        return NumberUtils.Abbreviate((math.floor(p25)));
    end,

    weight = function(p26) -- Line: 222, Name: weight
        -- upvalues: WeightFormat (copy)
        return WeightFormat.FormatGrams(p26);
    end,

    feet = function(p27) -- Line: 226, Name: feet
        -- upvalues: NumberUtils (copy)
        return NumberUtils.FormatWithCommas((math.round(p27))) .. " ft";
    end
};

function u1.FormatScore(p28, p29) -- Line: 235
    -- upvalues: u1 (copy)
    local v30 = typeof(p28) ~= "number" and 0 or p28;
    local ScoreFormats = u1.ScoreFormats;
    local v31;

    if p29 == nil then
        v31 = nil;
    else
        v31 = ScoreFormats[p29];
    end;

    return (v31 or ScoreFormats.integer)((v30 ~= v30 or (v30 == (1 / 0) or v30 == (-1 / 0))) and 0 or v30);
end;

return u1;