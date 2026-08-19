-- Decompiled with Potassium's decompiler.

local MarketplaceService = game:GetService("MarketplaceService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local GetData = UtilsSystem.GetData;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local TipsModule = UtilsSystem.TipsModule;
local TranslationHelper = UtilsSystem.TranslationHelper;
local v1 = {};

local function _promptRobloxItem(p2, p3) -- Line: 61
    -- upvalues: MarketplaceService (copy)
    MarketplaceService:PromptProductPurchase(p2, p3);
end;

local function _promptGamePass(p4, p5) -- Line: 72
    -- upvalues: MarketplaceService (copy)
    MarketplaceService:PromptGamePassPurchase(p4, p5);
end;

local function _tipShopBuyBlocked(p6, p7, p8) -- Line: 83
    -- upvalues: CfgFind (copy), TipsModule (copy)
    if p8 ~= "Before" then
        TipsModule.ErrorTips(p6, "购买次数已达上限");

        return;
    end;

    if p7 then
        p7 = p7.Before;
    end;

    local v9;

    if type(p7) == "string" and p7 ~= "" then
        v9 = CfgFind.FindCfgByOnlyTag(p7);
    else
        v9 = nil;
    end;

    TipsModule.ErrorTips(p6, "需要先购买前置商品", { v9 and v9.ZhName or (p7 or "") });
end;

local function _ensureCanBuyShopItem(p10, p11) -- Line: 102
    -- upvalues: GetData (copy), _tipShopBuyBlocked (copy)
    local v12 = GetData.GetShopBuyBlockReason(p10, p11);

    if not v12 then
        return true;
    end;

    _tipShopBuyBlocked(p10, p11, v12);

    return false;
end;

function v1.BuyRobloxByOnlyTag(u13, p14) -- Line: 122
    -- upvalues: CfgFind (copy), GetData (copy), _tipShopBuyBlocked (copy), TranslationHelper (copy), MarketplaceService (copy), NetWork (copy), NetMsg (copy), EnumMgr (copy)
    if not (u13 and p14) then
        return false;
    end;

    local v15 = CfgFind.FindCfgByOnlyTag(p14);

    if not v15 then
        return false;
    end;

    local GiftPlayer = u13:FindFirstChild("GiftPlayer");

    if GiftPlayer then
        GiftPlayer = GiftPlayer.Value;
    end;

    if not (GiftPlayer and GiftPlayer:IsA("Player")) then
        local v16 = GetData.GetShopBuyBlockReason(u13, v15);
        local v17;

        if v16 then
            _tipShopBuyBlocked(u13, v15, v16);
            v17 = false;
        else
            v17 = true;
        end;

        if not v17 then
            return false;
        end;

        if v15.passID and v15.price then
            if v15.cost == EnumMgr.RobuxType.GamePass then
                MarketplaceService:PromptGamePassPurchase(u13, v15.passID);

                return true;
            end;

            if v15.cost == EnumMgr.RobuxType.RobuxItem then
                MarketplaceService:PromptProductPurchase(u13, v15.passID);

                return true;
            end;
        end;

        return false;
    end;

    local v18 = GetData.GetShopBuyBlockReason(GiftPlayer, v15);
    local v19;

    if v18 then
        _tipShopBuyBlocked(GiftPlayer, v15, v18);
        v19 = false;
    else
        v19 = true;
    end;

    if not v19 then
        return false;
    end;

    local u20 = v15.GiftID and tonumber(v15.GiftID);

    if u20 then
        local v21 = {
            Tips = {
                "赠送确认",
                { TranslationHelper.TranslateByKey(v15.ZhName), GiftPlayer.DisplayName }
            },

            func = function() -- Line: 143, Name: func
                -- upvalues: u13 (copy), u20 (copy), MarketplaceService (ref)
                MarketplaceService:PromptProductPurchase(u13, u20);
            end
        };
        NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "警告弹窗", v21, true);
    end;

    return u20 ~= nil;
end;

return v1;