-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local TipsConfig = require(script.Parent.TipsConfig);
local TranslationHelper = UtilsSystem.TranslationHelper;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local v1 = {};

local function _buildObtainPrefixSegment() -- Line: 25
    -- upvalues: TranslationHelper (copy)
    return {
        TextSize = 35,
        UIGradientString = "提示白",
        UIStorke = 3,
        UIStorkeTransparency = 0,
        Text = TranslationHelper.TranslateByKey("获得"),
        Font = Enum.Font.MontserratBold,
        UIStorkeColor = Color3.new(0, 0, 0)
    };
end;

local function _buildCountSegment(p2) -- Line: 42
    return {
        TextSize = 35,
        UIGradientString = "黄",
        UIStorke = 3,
        UIStorkeTransparency = 0,
        Text = "x" .. tostring(p2),
        Font = Enum.Font.MontserratBold,
        UIStorkeColor = Color3.new(0, 0, 0)
    };
end;

local u13 = {
    [TipsConfig.SERVER_TEMPLATE_VEHICLE_FUSE] = function(p3) -- Line: 59, Name: _buildVehicleFuseTip
        -- upvalues: _buildObtainPrefixSegment (copy), TranslationHelper (copy), _buildCountSegment (copy)
        local Lv = p3.Lv;
        local ZhName = p3.ZhName;
        local Number = p3.Number;
        local Xyd = p3.Xyd;

        return Lv ~= nil and (ZhName ~= nil and (Number ~= nil and Xyd ~= nil)) and {
            _buildObtainPrefixSegment(),
            {
                TextSize = 40,
                UIStorke = 3,
                UIStorkeTransparency = 0,
                Text = " (Lv." .. tostring(Lv) .. ") " .. TranslationHelper.TranslateByKey(ZhName),
                Font = Enum.Font.MontserratBold,
                UIGradientString = Xyd,
                UIStorkeColor = Color3.new(0, 0, 0)
            },
            (_buildCountSegment(Number))
        } or nil;
    end,

    [TipsConfig.SERVER_TEMPLATE_REWARD] = function(p4) -- Line: 121, Name: _buildRewardTip
        -- upvalues: CfgFind (copy), EnumMgr (copy), _buildObtainPrefixSegment (copy), TranslationHelper (copy), _buildCountSegment (copy)
        local v5 = tonumber(p4.ID);
        local Count = p4.Count;

        if not v5 or Count == nil then
            return nil;
        end;

        local v6 = CfgFind.FindCfgByID(v5) or CfgFind.FindCfgByID(v5, EnumMgr.ItemType.Weapon) or CfgFind.FindCfgByID(v5, EnumMgr.ItemType.Armor);

        if not v6 then
            return nil;
        end;

        local v7 = tonumber(v6.xyd) or 1;
        local v8 = math.floor(v7);

        return {
            _buildObtainPrefixSegment(),
            {
                TextSize = 40,
                UIStorke = 3,
                UIStorkeTransparency = 0,
                Text = " " .. TranslationHelper.TranslateByKey(v6.ZhName) .. " ",
                Font = Enum.Font.MontserratBold,
                UIGradientString = v8,
                UIStorkeColor = Color3.new(0, 0, 0)
            },
            (_buildCountSegment(Count))
        };
    end,

    [TipsConfig.SERVER_TEMPLATE_POTION_OBTAIN] = function(p9) -- Line: 89, Name: _buildPotionObtainTip
        -- upvalues: CfgFind (copy), EnumMgr (copy), TranslationHelper (copy)
        local v10 = tonumber(p9.ID);

        if not v10 then
            return nil;
        end;

        local v11 = CfgFind.FindCfgByID(v10, EnumMgr.ItemType.Potion) or CfgFind.FindCfgByID(v10);

        if not v11 then
            return nil;
        end;

        local v12 = v11.xyd or 1;

        return {
            {
                TextSize = 43,
                UIStorke = 3,
                UIStorkeTransparency = 0,
                Text = TranslationHelper.TranslateByKey("你已获得药水", {
                    { v11.ZhName }
                }),
                Font = Enum.Font.MontserratBold,
                UIGradientString = v12,
                UIStorkeColor = Color3.new(0, 0, 0)
            }
        };
    end
};

function v1.buildFromServerData(p14) -- Line: 168
    -- upvalues: u13 (copy)
    local Type = p14.Type;

    if Type == nil then
        return nil;
    end;

    local v15 = u13[Type];

    if v15 then
        return v15(p14);
    end;

    return nil;
end;

return v1;