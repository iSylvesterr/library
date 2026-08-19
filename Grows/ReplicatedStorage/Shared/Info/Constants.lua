-- Decompiled with Potassium's decompiler.

local v1 = {};
require(script.Parent.CustomEnum);
require(game.ReplicatedStorage.Shared.Info.GlobalVars);
v1.MOBILE_BUTTON_DATA = {
    PlantTree = {
        displayName = "PLANT TREE",
        text = "PLANT TREE",
        xScaleSize = 1.2,
        yScaleSize = 1.2,
        xOffsetScale = -1.5,
        yOffsetScale = -1.7,
        image = require(game.ReplicatedStorage.Shared.Info.Images).BLANK_BUTTON
    }
};
v1.JUMP = {
    DEFAULT = 20,
    RANGE = NumberRange.new(7.2, 30)
};
v1.SPEED = {
    DEFAULT = 32,
    RANGE = NumberRange.new(32, 64)
};
v1.SIZE = {
    DEFAULT = 1,
    RANGE = NumberRange.new(1, 10)
};
v1.RESPAWN_TIME = 0.5;
v1.SPAWN_PROTECTION_TIME = 15;
v1.FAR_AWAY_CFRAME = CFrame.new(16777216, 16777216, 16777216);
v1.CLOSE_ENOUGH_CFRAME = CFrame.new(0, 2000, 0);
v1.GROUP_ID = 830072163;
v1.STARTER_PACK_TIMER = 7200;
v1.DAY_TIME = 86400;
v1.CRATE_ROLL_TIME = 2;
v1.QUE_NORMAL_TIME = 20;
v1.QUE_FULL_TIME = 5;
v1.MAX_QUE_SIZE = 5;
v1.UI_GREEN = Color3.new(0.490196, 1, 0.172549);
v1.UI_RED = Color3.new(0.901961, 0.231373, 0.145098);
v1.UI_WHITE = Color3.new(1, 1, 1);
v1.SORTING_BUTTON_UP = Color3.new(0.333333, 1, 0);
v1.SORTING_BUTTON_DOWN = Color3.new(0.243137, 0.415686, 0.152941);
v1.COUNTDOWN_3 = Color3.new(0.380392, 0.737255, 0.160784);
v1.COUNTDOWN_2 = Color3.new(0.737255, 0.670588, 0.160784);
v1.COUNTDOWN_1 = Color3.new(0.737255, 0.247059, 0.14902);
v1.UI_LEFTMENU_OPEN_TIME = 0.4;
v1.UI_LEFTMENU_CLOSE_TIME = 0.4;
v1.UI_LEFTMENU_ROTATE_TIME = 0.1;
v1.DOUBLE_TAP_TIME = 0.25;
v1.LONG_PRESS_TIME = 0.4;
v1.FAVORITE_COOLDOWN = 0.5;
v1.PROX_PROMPT_FADE_TIME = 0.3;
v1.HOTBAR_MAX_SIZE = 10;
v1.HOTBAR_MAX_SIZE_MOBILE = 6;
v1.STORAGE_MAX_SIZE = 850;
v1.RARITY_COLORS = {
    COMMON = Color3.fromHex("1EFF00"),
    RARE = Color3.fromHex("0070DD"),
    EPIC = Color3.fromHex("A335EE"),
    LEGENDARY = Color3.fromHex("FF0000"),
    MYTHIC = Color3.fromHex("FFD700"),
    CELESTIAL = Color3.fromRGB(12, 45, 138),
    SECRET = Color3.fromRGB(180, 40, 230),
    DIVINE = Color3.fromRGB(255, 240, 180)
};
v1.EGG_HATCH_TIME = 5;

return v1;