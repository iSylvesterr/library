-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ResourceUtil = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).ResourceUtil;
local v1 = {
    MAX_SHOW_NUMBER = 3,
    DISPLAY_DURATION = 3,
    TEMPLATE_NORMAL = "通用提示",
    TEMPLATE_ERROR = "通用警告",
    TEMPLATE_RAINBOW = "彩虹提示",
    TWEEN_SHOW_DURATION = 0.5,
    TWEEN_TEXT_DURATION = 0.4,
    POOL_BG_TEMP = "Tips/BGTemp",
    POOL_TEXT_TEMP = "Tips/TextTemp",
    SERVER_TEMPLATE_VEHICLE_FUSE = "载具合成",
    SERVER_TEMPLATE_REWARD = "获得奖励",
    SERVER_TEMPLATE_POTION_OBTAIN = "你已获得药水",
    SOUND_ERROR = "音效-UI-通用消极点击",
    GRADIENT_RAINBOW = "彩虹Tips",
    GRADIENT_TIP_YELLOW = "提示黄",
    TEXT_BOUNDS = Vector2.new(1920, 1080)
};
local u2 = {
    ["通用提示"] = {
        Text = "",
        TextSize = 43,
        UIStorke = 3,
        UIStorkeTransparency = 0,
        Font = Enum.Font.MontserratBold,
        TextColor = Color3.fromHex("#35da48"),
        UIStorkeColor = Color3.new(0, 0, 0)
    },
    ["通用警告"] = {
        Text = "",
        TextSize = 43,
        UIStorke = 3,
        UIStorkeTransparency = 0,
        Font = Enum.Font.MontserratBold,
        TextColor = Color3.fromHex("#ee4f4f"),
        UIStorkeColor = Color3.new(0, 0, 0)
    },
    ["彩虹提示"] = {
        Text = "",
        TextSize = 43,
        UIStorke = 3,
        UIStorkeTransparency = 0,
        Font = Enum.Font.MontserratBold,
        UIGradientString = v1.GRADIENT_RAINBOW,
        UIStorkeColor = Color3.new(0, 0, 0)
    }
};
local u3 = {};

local function _resolveTemplate(p4) -- Line: 82
    -- upvalues: ResourceUtil (copy), ReplicatedStorage (copy)
    local v5 = ResourceUtil.GetTemplate(p4);

    if v5 then
        return v5;
    end;

    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if not Assets then
        return nil;
    end;

    for _, v in string.split(p4, "/") do
        if v ~= "" then
            Assets = Assets:FindFirstChild(v);

            if not Assets then
                return nil;
            end;
        end;
    end;

    return Assets;
end;

function v1.getPoolTemplate(p6) -- Line: 113
    -- upvalues: u3 (copy), _resolveTemplate (copy)
    if u3[p6] == nil then
        local v7 = _resolveTemplate(p6);
        u3[p6] = v7 or false;

        return v7;
    end;

    local v8 = u3[p6];

    if v8 == false then
        return nil;
    end;

    return v8;
end;

function v1.copyTemplate(p9) -- Line: 132
    -- upvalues: u2 (copy)
    local v10 = u2[p9];

    if not v10 then
        return nil;
    end;

    local v11 = {};

    for i, v in pairs(v10) do
        v11[i] = v;
    end;

    return v11;
end;

return v1;