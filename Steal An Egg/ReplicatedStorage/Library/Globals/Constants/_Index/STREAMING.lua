-- Decompiled with Potassium's decompiler.

local v1 = {
    TARGET_RADIUS = 300,
    DELETE_COUNT_BUFFER = 50,
    DELETE_COUNT_BUFFER_FAST = 75,
    INSERT_DELETE_COUNT_BUFFER = 550,
    CREATE_INSTANCE_COUNT_BUFFER = 550,
    STREAM_DIR_STACKING_WEIGHT_BUFFER = 950,
    STREAM_DIR_REPLICATION_WEIGHT_BUFFER = 950
};
local v2 = v1.TARGET_RADIUS * 2.4;
local v3 = {
    Star = {
        NormalMode = v2 * 2
    },
    Default = {
        NormalMode = v2
    }
};
v3.Star.PerfMode = v3.Star.NormalMode;
v3.Default.PerfMode = v2 * 0.85;
v1.COLLECTABLES_RANGE_BY_TYPE = v3;

return v1;