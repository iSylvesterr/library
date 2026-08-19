-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LotteryCustom = require(ReplicatedStorage.Library.Functions.LotteryCustom);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local u1 = Constants.IS_STUDIO and 30 or 180;
local u2 = Constants.IS_STUDIO and 60 or 1200;
local u3 = Constants.IS_STUDIO and 60 or 2400;
local u4 = {
    {
        Id = "FrostWeather",
        Attribute = "FrostWeather",
        Weight = 45,
        PrimaryMutation = "Frozen",
        ManualApplyMutation = true,
        Boosts = {
            Frozen = 10
        }
    },
    {
        Id = "ThunderstormWeather",
        Attribute = "ThunderstormWeather",
        Weight = 45,
        PrimaryMutation = "Shocked",
        ManualApplyMutation = true,
        Boosts = {
            Shocked = 10
        }
    },
    {
        Id = "MagmaWeather",
        Attribute = "MagmaWeather",
        PrimaryMutation = "Magma",
        ManualApplyMutation = true,
        Weight = Constants.IS_STUDIO and 1000 or 45,
        Boosts = {
            Magma = 10
        }
    }
};
local u5 = {};
local u6 = {};
local u7 = { 1767225600 };
local u8 = {};

for _, v in ipairs(u4) do
    u5[v.Id] = v;
    table.insert(u6, { v.Id, v.Weight });
end;

table.freeze(u4);
table.freeze(u6);

local function getIntervalForCycle(p9) -- Line: 88
    -- upvalues: u2 (copy), u3 (copy)
    return Random.new(p9 * 7919 + 4101):NextInteger(u2, u3);
end;

local function ensureScheduleThrough(p10, p11) -- Line: 93
    -- upvalues: u3 (copy), u7 (copy), u2 (copy)
    local v12 = math.max(p10, 1767225600) + math.max(1, p11) * u3;

    while u7[#u7] <= v12 do
        local v13 = u7[#u7] + Random.new((#u7 - 1) * 7919 + 4101):NextInteger(u2, u3);
        table.insert(u7, v13);
    end;
end;

local function findFirstCycleIndexAfter(p14) -- Line: 103
    -- upvalues: u7 (copy)
    local v15 = #u7 + 1;
    local v16 = 1;

    while v16 < v15 do
        local v17 = math.floor((v16 + v15) / 2);
        local v18 = u7[v17];

        if v18 and p14 < v18 then
            v15 = v17;
        else
            v16 = v17 + 1;
        end;
    end;

    return v16 - 1;
end;

local function getCycleStartTime(p19) -- Line: 121
    -- upvalues: ensureScheduleThrough (copy), u7 (copy)
    ensureScheduleThrough(1767225600, p19 + 1);

    return u7[p19 + 1];
end;

local function chooseCycleWeathersInternal(p20, u21) -- Line: 126
    -- upvalues: u6 (copy), LotteryCustom (copy)
    local u22 = Random.new(p20 * 1543 + 9001);
    local v23 = {};

    local function chooseNextWeather(p24, p25) -- Line: 130
        -- upvalues: u22 (copy), u6 (ref), u21 (copy), LotteryCustom (ref)
        if not p25 and u22:NextNumber() >= 1 then
            return nil;
        end;

        local v26 = {};

        for _, v in ipairs(u6) do
            local v27 = v[1];

            if not (u21 and u21[v27] or p24 and p24[v27]) then
                table.insert(v26, v);
            end;
        end;

        if #v26 == 0 then
            return nil;
        end;

        local v28 = LotteryCustom(u22, v26);

        if typeof(v28) == "string" and v28 ~= "" then
            return v28;
        end;

        return nil;
    end;

    local v29 = chooseNextWeather(nil, false);

    if not v29 then
        return v23;
    end;

    table.insert(v23, v29);
    local v30 = u22:NextNumber() < 0 and chooseNextWeather({
        [v29] = true
    }, true);

    if v30 then
        table.insert(v23, v30);
    end;

    return v23;
end;

u8.DEFAULT_DURATION = u1;
u8.REFRESH_TIME = u2;
u8.MIN_INTERVAL = u2;
u8.MAX_INTERVAL = u3;
u8.WEATHER_DROP_CHANCE = 1;
u8.ADDITIONAL_WEATHER_CHANCE = 0;
u8.UPCOMING_SCHEDULE_ATTRIBUTE = "WeatherUpcomingSchedule";

function u8.GetEntries() -- Line: 179
    -- upvalues: u4 (copy)
    return table.clone(u4);
end;

function u8.GetEntry(p31) -- Line: 183
    -- upvalues: u5 (copy)
    return u5[p31];
end;

function u8.GetWeights() -- Line: 187
    -- upvalues: u6 (copy)
    return table.clone(u6);
end;

function u8.GetCycleIndex(p32) -- Line: 191
    -- upvalues: ensureScheduleThrough (copy), findFirstCycleIndexAfter (copy)
    ensureScheduleThrough(p32, 1);
    local v33 = findFirstCycleIndexAfter(p32) - 1;

    return math.max(0, v33);
end;

function u8.GetTimeIntoCycle(p34) -- Line: 196
    -- upvalues: u8 (copy), ensureScheduleThrough (copy), u7 (copy)
    local v35 = u8.GetCycleIndex(p34);
    ensureScheduleThrough(1767225600, v35 + 1);

    return p34 - u7[v35 + 1];
end;

function u8.GetSecondsToNextRefresh(p36) -- Line: 201
    -- upvalues: ensureScheduleThrough (copy), findFirstCycleIndexAfter (copy), u7 (copy)
    ensureScheduleThrough(p36, 1);
    local v37 = findFirstCycleIndexAfter(p36);
    ensureScheduleThrough(1767225600, v37 + 1);

    return math.max(0, u7[v37 + 1] - p36);
end;

function u8.ChooseCycleWeathers(p38, p39) -- Line: 209
    -- upvalues: chooseCycleWeathersInternal (copy)
    return chooseCycleWeathersInternal(p38, p39);
end;

function u8.GetUpcomingWeathers(p40, p41, p42) -- Line: 213
    -- upvalues: ensureScheduleThrough (copy), findFirstCycleIndexAfter (copy), u7 (copy), u1 (copy), chooseCycleWeathersInternal (copy)
    if p41 <= 0 then
        return {};
    end;

    ensureScheduleThrough(p40, p41);
    local v43 = findFirstCycleIndexAfter(p40);
    local v44 = {};
    local v45 = nil;

    if p42 then
        ensureScheduleThrough(1767225600, v43 + 1);

        if u7[v43 + 1] - p40 >= u1 then
            p42 = v45;
        end;
    else
        p42 = v45;
    end;

    for i = v43, v43 + p41 - 1 do
        ensureScheduleThrough(1767225600, i + 1);
        local v46 = u7[i + 1];
        local v47 = chooseCycleWeathersInternal(i, p42);
        p42 = nil;

        for _, v in ipairs(v47) do
            if p40 < v46 then
                table.insert(v44, {
                    WeatherId = v,
                    StartsAt = v46
                });

                if p41 <= #v44 then
                    return v44;
                end;
            end;
        end;
    end;

    return v44;
end;

return u8;