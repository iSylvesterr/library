-- Decompiled with Potassium's decompiler.

return {
    BATCH_DELAY = 0.3,
    RETRY_DELAY = 0.5,
    RETRY_THRESHOLD = 3,
    PRELOAD_TIMEOUT = 150,
    INNER_SMEAR_THRESHOLD = 15,
    GLOBAL_COUNTER_THRESHOLD = 50,
    AVERAGE_TIME_PER_ITEM = 60,
    BATCH_THRESHOLD = require(game:GetService("ReplicatedStorage").Library.Globals.Constants).IS_MOBILE and 25 or 35
};