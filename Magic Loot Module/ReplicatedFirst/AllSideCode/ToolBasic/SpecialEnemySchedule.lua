-- Decompiled with Potassium's decompiler.

local u3 = {
    getIntervalMinutes = function(p1) -- Line: 30, Name: getIntervalMinutes
        local v2 = tonumber(p1);

        return (not v2 or v2 <= 0) and 0 or v2;
    end
};

function u3.getIntervalSec(p4) -- Line: 44
    -- upvalues: u3 (copy)
    local v5 = u3.getIntervalMinutes(p4);

    return v5 <= 0 and 0 or v5 * 60;
end;

local function _getLocalMinutesAndSecondsSinceMidnight(p6) -- Line: 58
    local date = os.date;
    local v7 = math.floor(p6);
    local v8 = date("*t", (math.max(0, v7)));

    return v8.hour * 60 + v8.min, v8.sec;
end;

local function _getLocalDayKey(p9) -- Line: 70
    local date = os.date;
    local v10 = math.floor(p9);
    local v11 = date("*t", (math.max(0, v10)));

    return v11.year * 10000 + v11.month * 100 + v11.day;
end;

local function _getSlotsPerDay(p12) -- Line: 81
    return math.floor(1440 / p12);
end;

function u3.getCompletedWave(p13, p14) -- Line: 92
    -- upvalues: u3 (copy)
    local v15 = u3.getIntervalMinutes(p14);

    if v15 <= 0 then
        return 0;
    end;

    local date = os.date;
    local v16 = math.floor(p13);
    local v17 = date("*t", (math.max(0, v16)));
    local _ = v17.sec;
    local v18 = math.floor((v17.hour * 60 + v17.min) / v15);
    local date2 = os.date;
    local v19 = math.floor(p13);
    local v20 = date2("*t", (math.max(0, v19)));

    return (v20.year * 10000 + v20.month * 100 + v20.day) * math.floor(1440 / v15) + v18;
end;

function u3.getRemainingSec(p21, p22) -- Line: 111
    -- upvalues: u3 (copy)
    local v23 = u3.getIntervalMinutes(p22);

    if v23 <= 0 then
        return 0;
    end;

    local date = os.date;
    local v24 = math.floor(p21);
    local v25 = date("*t", (math.max(0, v24)));
    local v26 = v25.hour * 60 + v25.min;
    local sec = v25.sec;
    local v27 = (math.floor(v26 / v23) + 1) * v23;

    if v27 >= 1440 then
        return (1440 - v26) * 60 - sec;
    end;

    return (v27 - v26) * 60 - sec;
end;

function u3.countSpawnTriggers(p28, p29, p30) -- Line: 134
    -- upvalues: u3 (copy)
    local v31 = u3.getCompletedWave(p29, p30);

    if p28 == nil then
        return 0, v31;
    end;

    if v31 <= p28 then
        return 0, v31;
    end;

    local v32 = 0;

    for _ = p28 + 1, v31 do
        v32 = v32 + 1;
    end;

    return v32, v31;
end;

return u3;