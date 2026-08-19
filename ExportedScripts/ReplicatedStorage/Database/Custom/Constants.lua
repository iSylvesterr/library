-- Decompiled with Potassium's decompiler.

local u1 = table.freeze({
    UnrankedComp = 89844875164241,
    Deathmatch = 107028954108065,
    Defusal = 100334860793031
});
local u2 = table.freeze({
    UnrankedComp = 108194354348181,
    Deathmatch = 135434213652028,
    Defusal = 114234929420007
});
local v3 = table.freeze({
    UnrankedComp = 0,
    Deathmatch = 0,
    Defusal = 0
});

local function isInGamemodeSubplaceSet(p4, p5) -- Line: 32
    for _, v in pairs(p5) do
        if v == p4 then
            return true;
        end;
    end;

    return false;
end;

local function getActivePlaceEnvironment(p6) -- Line: 45
    -- upvalues: u1 (copy), u2 (copy)
    local v7 = false;

    for _, v in pairs(u1) do
        if v == p6 then
            v7 = true;
            break;
        end;
    end;

    if v7 then
        return "Dev";
    end;

    local v8 = false;

    for _, v in pairs(u2) do
        if v == p6 then
            v8 = true;
            break;
        end;
    end;

    return v8 and "Prod" or (game.GameId == 7633926880 and "Prod" or "Dev");
end;

local PlaceId = game.PlaceId;
local v9 = false;

for _, v in pairs(u1) do
    if v == PlaceId then
        v9 = true;
        break;
    end;
end;

local v10;

if v9 then
    v10 = "Dev";
else
    local v11 = false;

    for _, v in pairs(u2) do
        if v == PlaceId then
            v11 = true;
            break;
        end;
    end;

    if v11 then
        v10 = "Prod";
    elseif game.GameId == 7633926880 then
        v10 = "Prod";
    else
        v10 = "Dev";
    end;
end;

local v12 = v10 == "Dev" and u1 and u1 or (v10 == "Prod" and u2 and u2 or v3);
local UnrankedComp = v12.UnrankedComp;
local v13 = (UnrankedComp == v12.Defusal or not UnrankedComp) and 0 or UnrankedComp;

return table.freeze({
    VERSION = "1.1.1",
    MINIMUM_CREDITS_FOR_SPECIAL_CREDITS_OPTION = 100000,
    DEFAULT_CAMERA_FOV = 70,
    PRODUCTION_UNIVERSE_ID = 7633926880,
    TRADING_PLACE_ID = 101836176558619,
    ACTIVE_EVENTS = {
        ["MEDAL.TV"] = false
    },
    EVENT_END_TIMES = {
        ["MEDAL.TV"] = os.time({
            year = 2026,
            month = 3,
            day = 1,
            hour = 0,
            min = 0,
            sec = 0
        })
    },
    ADMINISTRATOR_FINISHER_WHITELIST = { 3659308968, 107643044, 1243042178 },
    VIP_MENU_PANEL_WHITELIST = { 363101315, 3659308968, 1243042178, 107643044, 9236102964, 38260227, 40222641 },
    AIM_ASSIST_WHITELIST = {},
    AIM_ASSIST_CONFIGS = {
        DEVELOPER = {
            TargetSelection = {
                Enabled = true,
                MaxDistance = 200,
                MaxAngle = 0.7853981633974483
            },
            Friction = {
                Enabled = true,
                BubbleRadius = 4,
                MinSensitivity = 0.3,
                MaxSensitivity = 1
            },
            Magnetism = {
                Enabled = true,
                MaxAngleHorizontal = 0.3490658503988659,
                MaxAngleVertical = 0.17453292519943295,
                PullStrength = 0.3141592653589793,
                StopThreshold = 0.003490658503988659,
                MaxDistance = 200
            },
            VerticalMagnetism = {
                Enabled = true,
                MaxAngleHorizontal = 0.17453292519943295,
                MaxAngleVertical = 0.3490658503988659,
                PullStrength = 0.20943951023931956,
                StopThreshold = 0.008726646259971648,
                MaxDistance = 200
            },
            RecoilAssist = {
                Enabled = true,
                ReductionAmount = 0.75,
                RequiresTarget = false
            }
        },
        PLAYER = {
            TargetSelection = {
                Enabled = true,
                MaxDistance = 125,
                MaxAngle = 0.5235987755982988
            },
            Friction = {
                Enabled = true,
                BubbleRadius = 2.4,
                MinSensitivity = 0.5,
                MaxSensitivity = 1
            },
            Magnetism = {
                Enabled = true,
                MaxAngleHorizontal = 0.20943951023931956,
                MaxAngleVertical = 0.10471975511965978,
                PullStrength = 0.11344640137963143,
                StopThreshold = 0.008726646259971648,
                MaxDistance = 125
            },
            VerticalMagnetism = {
                Enabled = true,
                MaxAngleHorizontal = 0.20943951023931956,
                MaxAngleVertical = 0.10471975511965978,
                PullStrength = 0.11344640137963143,
                StopThreshold = 0.008726646259971648,
                MaxDistance = 125
            },
            RecoilAssist = {
                Enabled = true,
                ReductionAmount = 0.5,
                RequiresTarget = false
            }
        }
    },
    ACTIVE_PLACE_ENVIRONMENT = v10,
    GAMEMODE_SUBPLACE_IDS = {
        Prod = u2,
        Dev = u1
    },
    ACTIVE_GAMEMODE_SUBPLACE_IDS = v12,
    GAMEMODE_PLACE_IDS = {
        Trading = 101836176558619,
        Deathmatch = v12.Deathmatch,
        Casual = v12.Defusal,
        Competitive = v13
    }
});