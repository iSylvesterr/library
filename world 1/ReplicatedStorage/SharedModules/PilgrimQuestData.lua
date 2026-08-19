-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local SeedData = require(ReplicatedStorage.SharedModules.SeedData);
local Worlds = require(ReplicatedStorage.SharedModules.Worlds);

local function TuningFlag(p1, p2) -- Line: 38
    -- upvalues: FastFlags (copy), Asserts (copy)
    return FastFlags.Private(p1, Asserts.Map(Asserts.String, Asserts.Finite), p2);
end;

local u3 = FastFlags.Private("Game.Pilgrim.Quest.MutationPool", Asserts.Array(Asserts.String), { "Gold", "Rainbow", "Frozen", "Glow", "Electric", "Aurora" });
local u4 = FastFlags.Private("Game.Pilgrim.Quest.DeliveryRarities", Asserts.Array(Asserts.String), { "Common", "Uncommon", "Rare" });
local u5 = FastFlags.Private("Game.Pilgrim.Quest.DeliverFruitCount", Asserts.Map(Asserts.String, Asserts.Finite), {
    Min = 50,
    Max = 250
});
local u6 = FastFlags.Private("Game.Pilgrim.Quest.DeliverMutation", Asserts.Map(Asserts.String, Asserts.Finite), {
    Min = 5,
    Max = 25
});
local u7 = FastFlags.Private("Game.Pilgrim.Quest.DeliverTier", Asserts.Map(Asserts.String, Asserts.Finite), {
    Min = 10,
    Max = 50
});
local u8 = FastFlags.Private("Game.Pilgrim.Quest.DeliverAboveSize", Asserts.Map(Asserts.String, Asserts.Finite), {
    Min = 3,
    Max = 15,
    WeightKgMin = 2,
    WeightKgMax = 5
});
local u9 = FastFlags.Private("Game.Pilgrim.Quest.DeliverWeightKg", Asserts.Map(Asserts.String, Asserts.Finite), {
    Min = 100,
    Max = 800
});
local u10 = FastFlags.Private("Game.Pilgrim.Quest.TamePets", Asserts.Map(Asserts.String, Asserts.Finite), {
    Min = 5,
    Max = 25
});
local u11 = FastFlags.Private("Game.Pilgrim.Quest.StealPeople", Asserts.Map(Asserts.String, Asserts.Finite), {
    Min = 3,
    Max = 15
});
local u12 = FastFlags.Private("Game.Pilgrim.Quest.GrowTall", Asserts.Map(Asserts.String, Asserts.Finite), {
    Min = 20,
    Max = 100
});
local v14 = (function() -- Line: 62, Name: DeliveryRaritySet
    -- upvalues: u4 (copy)
    local v13 = {};

    for _, v in u4:Get() do
        if type(v) == "string" then
            v13[v] = true;
        end;
    end;

    return v13;
end)();
local v15 = {};
local u16 = {};
local u17 = {};
local v18 = {};
local u19 = {};

for _, v in SeedData do
    local SeedName = v.SeedName;
    local Rarity = v.Rarity;

    if type(SeedName) == "string" and (type(Rarity) == "string" and (not v15[SeedName] and Worlds.EntryAvailableHere(v))) then
        v15[SeedName] = true;

        if not u16[Rarity] then
            u16[Rarity] = {};
        end;

        table.insert(u16[Rarity], SeedName);

        if v.RestockShop == true and v14[Rarity] then
            table.insert(u17, SeedName);

            if not v18[Rarity] then
                v18[Rarity] = true;
                table.insert(u19, Rarity);
            end;
        end;
    end;
end;

table.sort(u17);

for _, v in u16 do
    table.sort(v);
end;

table.sort(u19);

local function tune(p20, p21, p22) -- Line: 137
    local v23 = p20:Get();

    if v23 then
        v23 = v23[p21];
    end;

    if type(v23) == "number" and v23 == v23 then
        return v23;
    end;

    return p22;
end;

local function RoundPretty(p24) -- Line: 147
    local v25 = p24 <= 20 and 5 or (p24 <= 100 and 10 or (p24 <= 500 and 25 or 100));
    local v26 = math.round(p24 / v25) * v25;

    return math.max(v25, v26);
end;

local function pick(p27, p28) -- Line: 161
    local v29 = #p28;

    if v29 == 0 then
        return nil;
    end;

    return p28[p27:NextInteger(1, v29)];
end;

local function prettyTarget(p30, p31, p32) -- Line: 167
    if p32 < p31 then
        p32 = p31;
    end;

    local v33 = p30:NextNumber(p31, p32);
    local v34 = v33 <= 20 and 5 or (v33 <= 100 and 10 or (v33 <= 500 and 25 or 100));
    local v35 = math.round(v33 / v34) * v34;

    return math.max(v34, v35);
end;

local function genTame(p36) -- Line: 241
    -- upvalues: u10 (copy)
    local v37 = u10:Get();

    if v37 then
        v37 = v37.Min;
    end;

    local v38 = (type(v37) ~= "number" or v37 ~= v37) and 5 or v37;
    local v39 = u10:Get();

    if v39 then
        v39 = v39.Max;
    end;

    local v40 = (type(v39) ~= "number" or v39 ~= v39) and 25 or v39;

    if v40 < v38 then
        v40 = v38;
    end;

    local v41 = p36:NextNumber(v38, v40);
    local v42 = v41 <= 20 and 5 or (v41 <= 100 and 10 or (v41 <= 500 and 25 or 100));
    local v43 = math.round(v41 / v42) * v42;
    local v44 = math.max(v42, v43);

    return {
        Type = "TamePets",
        Kind = "passive",
        PassiveType = "tame",
        Description = `Tame {v44} pets`,
        Target = v44
    };
end;

local function genSteal(p45) -- Line: 252
    -- upvalues: u11 (copy)
    local v46 = u11:Get();

    if v46 then
        v46 = v46.Min;
    end;

    local v47 = (type(v46) ~= "number" or v46 ~= v46) and 3 or v46;
    local v48 = u11:Get();

    if v48 then
        v48 = v48.Max;
    end;

    local v49 = (type(v48) ~= "number" or v48 ~= v48) and 15 or v48;

    if v49 < v47 then
        v49 = v47;
    end;

    local v50 = p45:NextNumber(v47, v49);
    local v51 = v50 <= 20 and 5 or (v50 <= 100 and 10 or (v50 <= 500 and 25 or 100));
    local v52 = math.round(v50 / v51) * v51;
    local v53 = math.max(v51, v52);

    return {
        Type = "StealPeople",
        Kind = "passive",
        PassiveType = "steal",
        Description = `Steal from {v53} different people`,
        Target = v53
    };
end;

local function genGrowTall(p54) -- Line: 263
    -- upvalues: u12 (copy)
    local v55 = u12:Get();

    if v55 then
        v55 = v55.Min;
    end;

    local v56 = (type(v55) ~= "number" or v55 ~= v55) and 20 or v55;
    local v57 = u12:Get();

    if v57 then
        v57 = v57.Max;
    end;

    local v58 = (type(v57) ~= "number" or v57 ~= v57) and 100 or v57;

    if v58 < v56 then
        v58 = v56;
    end;

    local v59 = p54:NextNumber(v56, v58);
    local v60 = v59 <= 20 and 5 or (v59 <= 100 and 10 or (v59 <= 500 and 25 or 100));
    local v61 = math.round(v59 / v60) * v60;
    local v62 = math.max(v60, v61);

    return {
        Type = "GrowTallPlant",
        Kind = "passive",
        PassiveType = "grow",
        Target = 1,
        Description = `Grow a {v62} ft tall plant`,
        MinHeightFt = v62
    };
end;

local u125 = {
    function(p63) -- Line: 173, Name: genFruitCount
        -- upvalues: u17 (copy), u5 (copy)
        local v64 = u17;
        local v65 = #v64;
        local v66;

        if v65 == 0 then
            v66 = nil;
        else
            v66 = v64[p63:NextInteger(1, v65)];
        end;

        if not v66 then
            return nil;
        end;

        local v67 = u5:Get();

        if v67 then
            v67 = v67.Min;
        end;

        local v68 = (type(v67) ~= "number" or v67 ~= v67) and 50 or v67;
        local v69 = u5:Get();

        if v69 then
            v69 = v69.Max;
        end;

        local v70 = (type(v69) ~= "number" or v69 ~= v69) and 250 or v69;

        if v70 < v68 then
            v70 = v68;
        end;

        local v71 = p63:NextNumber(v68, v70);
        local v72 = v71 <= 20 and 5 or (v71 <= 100 and 10 or (v71 <= 500 and 25 or 100));
        local v73 = math.round(v71 / v72) * v72;
        local v74 = math.max(v72, v73);

        return {
            Type = "DeliverFruitCount",
            Kind = "delivery",
            Description = `Submit {v74} {v66}`,
            Target = v74,
            FruitName = v66
        };
    end,

    function(p75) -- Line: 186, Name: genMutation
        -- upvalues: u3 (copy), u6 (copy)
        local v76 = u3:Get();
        local v77 = #v76;
        local v78;

        if v77 == 0 then
            v78 = nil;
        else
            v78 = v76[p75:NextInteger(1, v77)];
        end;

        if not v78 then
            return nil;
        end;

        local v79 = u6:Get();

        if v79 then
            v79 = v79.Min;
        end;

        local v80 = (type(v79) ~= "number" or v79 ~= v79) and 5 or v79;
        local v81 = u6:Get();

        if v81 then
            v81 = v81.Max;
        end;

        local v82 = (type(v81) ~= "number" or v81 ~= v81) and 25 or v81;

        if v82 < v80 then
            v82 = v80;
        end;

        local v83 = p75:NextNumber(v80, v82);
        local v84 = v83 <= 20 and 5 or (v83 <= 100 and 10 or (v83 <= 500 and 25 or 100));
        local v85 = math.round(v83 / v84) * v84;
        local v86 = math.max(v84, v85);

        return {
            Type = "DeliverFruitMutation",
            Kind = "delivery",
            Description = `Submit {v86} {v78} fruit`,
            Target = v86,
            Mutation = v78
        };
    end,

    function(p87) -- Line: 199, Name: genTier
        -- upvalues: u19 (copy), u7 (copy)
        local v88 = u19;
        local v89 = #v88;
        local v90;

        if v89 == 0 then
            v90 = nil;
        else
            v90 = v88[p87:NextInteger(1, v89)];
        end;

        if not v90 then
            return nil;
        end;

        local v91 = u7:Get();

        if v91 then
            v91 = v91.Min;
        end;

        local v92 = (type(v91) ~= "number" or v91 ~= v91) and 10 or v91;
        local v93 = u7:Get();

        if v93 then
            v93 = v93.Max;
        end;

        local v94 = (type(v93) ~= "number" or v93 ~= v93) and 50 or v93;

        if v94 < v92 then
            v94 = v92;
        end;

        local v95 = p87:NextNumber(v92, v94);
        local v96 = v95 <= 20 and 5 or (v95 <= 100 and 10 or (v95 <= 500 and 25 or 100));
        local v97 = math.round(v95 / v96) * v96;
        local v98 = math.max(v96, v97);

        return {
            Type = "DeliverTier",
            Kind = "delivery",
            Description = `Submit {v98} {v90}-tier fruit`,
            Target = v98,
            Tier = v90
        };
    end,

    function(p99) -- Line: 212, Name: genAboveSize
        -- upvalues: u8 (copy)
        local v100 = u8:Get();

        if v100 then
            v100 = v100.Min;
        end;

        local v101 = (type(v100) ~= "number" or v100 ~= v100) and 3 or v100;
        local v102 = u8:Get();

        if v102 then
            v102 = v102.Max;
        end;

        local v103 = (type(v102) ~= "number" or v102 ~= v102) and 15 or v102;

        if v103 < v101 then
            v103 = v101;
        end;

        local v104 = p99:NextNumber(v101, v103);
        local v105 = v104 <= 20 and 5 or (v104 <= 100 and 10 or (v104 <= 500 and 25 or 100));
        local v106 = math.round(v104 / v105) * v105;
        local v107 = math.max(v105, v106);
        local v108 = u8:Get();

        if v108 then
            v108 = v108.WeightKgMin;
        end;

        local v109 = (type(v108) ~= "number" or v108 ~= v108) and 2 or v108;
        local v110 = u8:Get();

        if v110 then
            v110 = v110.WeightKgMax;
        end;

        local v111 = (type(v110) ~= "number" or v110 ~= v110) and 5 or v110;

        if v111 < v109 then
            v111 = v109;
        end;

        local v112 = p99:NextInteger(math.floor(v109), (math.floor(v111)));

        return {
            Type = "DeliverAboveSize",
            Kind = "delivery",
            Description = `Submit {v107} fruit above {v112}kg`,
            Target = v107,
            MinWeightKg = v112
        };
    end,

    function(p113) -- Line: 227, Name: genWeight
        -- upvalues: u17 (copy), u9 (copy)
        local v114 = u17;
        local v115 = #v114;
        local v116;

        if v115 == 0 then
            v116 = nil;
        else
            v116 = v114[p113:NextInteger(1, v115)];
        end;

        if not v116 then
            return nil;
        end;

        local v117 = u9:Get();

        if v117 then
            v117 = v117.Min;
        end;

        local v118 = (type(v117) ~= "number" or v117 ~= v117) and 100 or v117;
        local v119 = u9:Get();

        if v119 then
            v119 = v119.Max;
        end;

        local v120 = (type(v119) ~= "number" or v119 ~= v119) and 800 or v119;

        if v120 < v118 then
            v120 = v118;
        end;

        local v121 = p113:NextNumber(v118, v120);
        local v122 = v121 <= 20 and 5 or (v121 <= 100 and 10 or (v121 <= 500 and 25 or 100));
        local v123 = math.round(v121 / v122) * v122;
        local v124 = math.max(v122, v123);

        return {
            Type = "DeliverWeightKg",
            Kind = "delivery",
            Unit = "kg",
            Description = `Submit {v124}kg of {v116}`,
            Target = v124,
            FruitName = v116
        };
    end,

    genTame,
    genSteal,
    genGrowTall
};
local u126 = { genTame, genSteal, genGrowTall };
local u127 = FastFlags.Private("Game.Pilgrim.Quest.MinPassiveQuests", Asserts.IntegerNonNegative, 1);

return table.freeze({
    GetMutationPool = function() -- Line: 306, Name: GetMutationPool
        -- upvalues: u3 (copy)
        return u3:Get();
    end,

    Generate = function(u128, p129) -- Line: 317, Name: Generate
        -- upvalues: u127 (copy), u126 (copy), u125 (copy)
        local u130 = {};
        local u131 = {};
        local v132 = 0;
        local v133 = u127:Get();
        local v134 = math.min(v133, p129);
        local u135 = 0;

        local function tryAdd(p136) -- Line: 326
            -- upvalues: u128 (copy), u131 (copy), u130 (copy), u135 (ref)
            local v137 = p136(u128);

            if not v137 or u131[v137.Description] then
                return false;
            end;

            u131[v137.Description] = true;
            table.insert(u130, v137);

            if v137.Kind ~= "delivery" then
                u135 = u135 + 1;
            end;

            return true;
        end;

        while #u130 < p129 and v132 < p129 * 12 do
            v132 = v132 + 1;
            local v138;

            if p129 - #u130 <= v134 - u135 then
                v138 = u126;
            else
                v138 = u125;
            end;

            local v139 = v138[u128:NextInteger(1, #v138)](u128);

            if v139 and not u131[v139.Description] then
                u131[v139.Description] = true;
                table.insert(u130, v139);

                if v139.Kind ~= "delivery" then
                    u135 = u135 + 1;
                end;
            end;
        end;

        return u130;
    end,

    IsDelivery = function(p140) -- Line: 351, Name: IsDelivery
        return p140.Kind == "delivery";
    end,

    DeliveryContribution = function(p141, p142) -- Line: 358, Name: DeliveryContribution
        -- upvalues: u16 (copy)
        if type(p142) ~= "table" then
            return 0;
        end;

        if p141.Type == "DeliverFruitCount" then
            return p142.FruitName == p141.FruitName and 1 or 0;
        end;

        if p141.Type == "DeliverFruitMutation" then
            return p142.Mutation == p141.Mutation and 1 or 0;
        end;

        if p141.Type == "DeliverTier" then
            local v143 = u16[p141.Tier];

            return v143 and (p141.Tier and p142.FruitName) and (table.find(v143, p142.FruitName) and 1 or 0) or 0;
        end;

        if p141.Type == "DeliverAboveSize" then
            return (tonumber(p142.Weight) or 0) >= (p141.MinWeightKg or (1 / 0)) and 1 or 0;
        end;

        if p141.Type ~= "DeliverWeightKg" then
            return 0;
        end;

        if p142.FruitName ~= p141.FruitName then
            return 0;
        end;

        local v144 = tonumber(p142.Weight) or 0;

        return math.max(0, v144);
    end
});