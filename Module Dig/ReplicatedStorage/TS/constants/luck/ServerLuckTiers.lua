-- Decompiled with Potassium's decompiler.

local u1 = { 2, 4, 8, 16, 32, 64, 128 };

return {
    SERVER_LUCK_DURATION_MINUTES = 15,
    SERVER_LUCK_DURATION_SECONDS = 900,
    MAX_SERVER_LUCK_TIER = 128,

    nextServerLuckTier = function(p2) -- Line: 17, Name: nextServerLuckTier
        -- upvalues: u1 (copy)
        for _, v in u1 do
            if p2 < v then
                return v;
            end;
        end;

        return nil;
    end,

    SERVER_LUCK_TIERS = u1,
    SERVER_LUCK_COLOR = Color3.fromRGB(180, 0, 255),
    SERVER_LUCK_HIGHLIGHT_COLOR = Color3.fromRGB(255, 0, 223),
    SERVER_LUCK_PRODUCTS = {
        [2] = "Server Luck 2x",
        [4] = "Server Luck 4x",
        [8] = "Server Luck 8x",
        [16] = "Server Luck 16x",
        [32] = "Server Luck 32x",
        [64] = "Server Luck 64x",
        [128] = "Server Luck 128x"
    }
};