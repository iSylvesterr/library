-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local _Index = script._Index;
local NETWORK_MAP = require(_Index.NETWORK_MAP);
local v1 = {
    IS_SERVER = RunService:IsServer()
};
v1.IS_CLIENT = not v1.IS_SERVER;
v1.IS_STUDIO = RunService:IsStudio();
v1.IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.MouseEnabled or (UserInputService.GyroscopeEnabled or UserInputService.AccelerometerEnabled);
v1.IS_PRIVATE_SERVER = v1.IS_SERVER and game.PrivateServerId ~= "";
v1.ANIMATIONTRACK_PLAY_PARAMS = require(_Index.ANIMATIONTRACK_PLAY_PARAMS);
v1.SORTED_ANIMATION_PRIORITY = require(_Index.SORTED_ANIMATION_PRIORITY);
v1.CLIENT_SETTINGS = require(_Index.CLIENT_SETTINGS);
NETWORK_MAP.GuardTutorial = require(_Index.NETWORK_MAP.Endpoints.GuardTutorial);
v1.NETWORK_MAP = NETWORK_MAP;
v1.SIGNALS_MAP = require(_Index.SIGNALS_MAP);
v1.TAGS_MAP = require(_Index.TAGS_MAP);
v1.TIME_FORMAT = require(_Index.TIME_FORMAT);
v1.STREAMING = require(_Index.STREAMING);
v1.BUTTON_FX = require(_Index.BUTTON_FX);
v1.BACKPACK = require(_Index.BACKPACK);
v1.MURDER_MYSTERY_WEAPONS = require(_Index.MURDER_MYSTERY_WEAPONS);
v1.OFFLINE_ASSETS = require(_Index.OFFLINE_ASSETS);
v1.VIP_OFFER = require(_Index.VIP_OFFER);
v1.BASE_FRAME_RATE = 60;
v1.STUDIO_YIELD_TIMEOUT = v1.IS_STUDIO and 60 or 9999999;
v1.STUDIO_RESET_PLAYER_DATA_ON_UNLOAD = false;
v1.GROUP_ID = 825735094;
v1.MAIN_DEV_ID = 4035869470;
v1.TEST_PLACE_ID = 98345564489939;
v1.JOIN_BADGE = 2590480615884365;
v1.OWNER_ID = 1065906907;
v1.MIN_PLACE_GRID_SIZE = 3;
v1.CLIENT_OVERLAP_MARGIN = 0.95;
v1.SERVER_REDUCTION_FACTOR = 0.75;
v1.SERVER_MIN_GRID_SIZE = v1.MIN_PLACE_GRID_SIZE * v1.SERVER_REDUCTION_FACTOR;
v1.MAX_PET_EXTRA_SLOTS = 5;
v1.MAX_INVENTORY_SLOTS_PURCHASE = 5;
v1.INVENTORY_SLOT_PURCHASE_INCREMENT = 5;
v1.BRAINROT_MAX_HATCH_PER_REQUEST = 24;
v1.ASSET_BALANCING_PROGRESS_INCREMENT_PERCENT = 13;
v1.ASSET_BALANCING_GIGA_MULTIPLIER = 1;
v1.BLOODLIT_EVENT_WEIGHT_REQ = 5;
v1.BLOODLIT_BACKPACK_BONUS = 50;
v1.BASE_ASSETS_WALK_SPEED = 13;
v1.BASE_WALK_SPEED = 16;
v1.BASE_JUMP_HEIGHT = 7;
local _ = v1.IS_STUDIO;
v1.BASE_CARRY_POWER = 1;
v1.ASSET_DNA_STEAL_ENABLED = false;
v1.SUPPORTED_GIFTS_TYPES = {
    Asset = "Asset",
    LuckyBlock = "LuckyBlock"
};
v1.EXCLUDED_GEAR_NAMES_FROM_GIFTING = { "Slap", "DirtSlap", "DemonSlap", "DiamondSlap", "EmeraldSlap", "GoldenSlap" };
v1.DEFAULT_BASE_LOCK_DURATION = 120;
v1.LUCKY_BLOCK_TOOL_NAME = "LuckyBlockTool";
v1.ROBUX_ICON_STR = "";

return v1;