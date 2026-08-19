-- Decompiled with Potassium's decompiler.

local v1 = {};
local Workspace = game:GetService("Workspace");

local function _formatTimeHHMMSS(p2) -- Line: 36
    local v3 = math.max(0, p2);
    local v4 = math.floor(v3 / 3600);
    local v5 = math.floor(v3 / 60) % 60;
    local v6 = math.floor(v3) % 60;

    return string.format("%02d:%02d:%02d", v4, v5, v6);
end;

local function _formatTimeHHMM(p7) -- Line: 51
    local v8 = math.max(0, p7);
    local v9 = math.floor(v8 / 3600);
    local v10 = math.floor(v8 / 60) % 60;

    return string.format("%02d:%02d", v9, v10);
end;

function v1.FormatTime(p11) -- Line: 69
    -- upvalues: _formatTimeHHMMSS (copy)
    return _formatTimeHHMMSS(p11);
end;

function v1.FormatTimeM(p12) -- Line: 79
    -- upvalues: _formatTimeHHMM (copy)
    return _formatTimeHHMM(p12);
end;

function v1.FormatTimeMMSS(p13) -- Line: 89
    local v14 = math.max(0, p13);
    local v15 = math.floor(v14 / 60);
    local v16 = math.floor(v14) % 60;

    return string.format("%02d:%02d", v15, v16);
end;

function v1.FormatTimeS(p17) -- Line: 104
    local v18 = math.max(0, p17);
    local v19 = math.floor(v18) % 60;
    local v20 = math.floor(v18 / 60) % 60;
    local v21 = math.floor(v18 / 3600) % 24;
    local v22 = math.floor(v18 / 86400);
    local v23 = "";

    if v22 > 0 then
        v23 = v23 .. string.format("%dd", v22);
    end;

    if v21 > 0 then
        v23 = v23 .. string.format("%dh", v21);
    end;

    if v20 > 0 then
        v23 = v23 .. string.format("%dm", v20);
    end;

    if v22 <= 0 and v19 > 0 then
        v23 = v23 .. string.format("%ds", v19);
    end;

    return v23;
end;

function v1.UniqueTimeString(p24) -- Line: 135
    local v25 = math.max(0, p24);

    if v25 < 60 then
        return tostring(v25) .. " Sec";
    end;

    if v25 < 3600 then
        local v26 = math.ceil(v25 / 60);

        return tostring(v26) .. " Min";
    end;

    if v25 < 86400 then
        local v27 = math.ceil(v25 / 3600);

        return tostring(v27) .. " Hour";
    end;

    local v28 = math.ceil(v25 / 86400);

    return tostring(v28) .. " Day";
end;

function v1.UniqueTimeStringRank(p29) -- Line: 155
    local v30 = math.max(0, p29);
    local v31 = math.floor(v30 / 3600) % 24;
    local v32 = math.floor(v30 / 86400);

    return string.format("%dd %dh", v32, v31);
end;

v1.UniqueTimeString_Rank = v1.UniqueTimeStringRank;

function v1.FormatTimeMins(p33) -- Line: 173
    local v34 = math.max(0, p33);
    local v35 = math.floor(v34 / 60) % 60;
    local v36 = math.floor(v34 / 3600) % 24;
    local v37 = math.floor(v34 / 86400);
    local v38 = "";

    if v37 > 0 then
        v38 = v38 .. string.format("%dd ", v37);
    end;

    if v36 > 0 then
        v38 = v38 .. string.format("%dhrs ", v36);
    end;

    if v35 > 0 then
        v38 = v38 .. string.format("%dmins", v35);
    end;

    return v38;
end;

function v1.FormatUnixTimestampToYMD(p39) -- Line: 199
    local v40 = tonumber(p39);

    if not v40 or v40 <= 0 then
        return "—";
    end;

    if v40 > 1000000000000 then
        v40 = v40 / 1000;
    end;

    local v41 = math.floor(v40);

    if v41 < 1000000000 then
        return tostring(p39);
    end;

    return os.date("%Y/%m/%d", v41);
end;

function v1.GetDayIndex(p42) -- Line: 219
    -- upvalues: Workspace (copy)
    if p42 == nil then
        p42 = Workspace:GetServerTimeNow();
    end;

    local v43 = (tonumber(p42) or 0) / 86400;

    return math.floor(v43);
end;

function v1.GetSecondsUntilNextDay(p44) -- Line: 232
    -- upvalues: Workspace (copy)
    local v45 = tonumber(p44);

    if v45 == nil then
        v45 = Workspace:GetServerTimeNow();
    end;

    local v46 = math.max(0, v45);
    local v47 = (math.floor(v46 / 86400) + 1) * 86400 - v46;

    return math.max(0, v47);
end;

return v1;