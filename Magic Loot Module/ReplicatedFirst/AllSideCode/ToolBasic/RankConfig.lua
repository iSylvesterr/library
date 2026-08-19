-- Decompiled with Potassium's decompiler.

return {
    RANK_NAMES = { "Rank_Gold", "Rank_Potion", "Rank_Magic" },
    RANK_DATA_FIELDS = {
        Rank_Gold = "最高金币数量",
        Rank_Potion = "最高药水数量",
        Rank_Magic = "最高魔力值"
    },
    RANK_TIME_NAME = "N_Time",
    RANK_COLORS = { Color3.fromHex("#ECCA2C"), Color3.fromHex("#60C9FF"), Color3.fromHex("#EC8F2C") },
    RANK_TEMP_TRANSPARENCY_ODD = 1,
    RANK_TEMP_TRANSPARENCY_EVEN = 0.9,
    RANK_MIN_SCORE = 0,
    RANK_COUNTS = 100,
    RANK_SAVE_MAX_TRIES = 2,
    RANK_SAVE_RETRY_INTERVAL_SEC = 1,
    RANK_UPLOAD_INITIAL_DELAY_SEC = 5,
    WORKSPACE_CACHE_FOLDER = "排行榜缓存",
    WORKSPACE_TOP3_FOLDER = "前3名玩家",
    WORKSPACE_SHOW_FOLDER = "排行榜展示玩家"
};