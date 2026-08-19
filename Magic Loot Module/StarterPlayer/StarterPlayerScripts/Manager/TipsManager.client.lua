-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local TipsRenderer = UtilsSystem.TipsRenderer;
local TipsDamageTip = UtilsSystem.TipsDamageTip;
local TipsConfig = UtilsSystem.TipsConfig;
local TranslationHelper = UtilsSystem.TranslationHelper;
local EnumMgr = UtilsSystem.EnumMgr;
local SoundModule = UtilsSystem.SoundModule;

local function _renderTranslatedTip(p1, p2, p3, p4) -- Line: 31
    -- upvalues: EnumMgr (copy), TipsRenderer (copy), TipsConfig (copy), SoundModule (copy)
    local v5 = p2 or EnumMgr.TipTp.Normal;

    if v5 == EnumMgr.TipTp.Error then
        TipsRenderer.templateTip(p1, TipsConfig.TEMPLATE_ERROR, p3);
        SoundModule:PlaySoundLocal({
            Is2D = true,
            SoundName = TipsConfig.SOUND_ERROR
        });

        return;
    end;

    if v5 == EnumMgr.TipTp.Rainbow then
        TipsRenderer.templateTip(p1, TipsConfig.TEMPLATE_RAINBOW, p3, p4);

        return;
    end;

    TipsRenderer.templateTip(p1, TipsConfig.TEMPLATE_NORMAL, p3);
end;

local function _onShowTips(p6, p7, p8, p9, p10) -- Line: 58
    -- upvalues: TranslationHelper (copy), _renderTranslatedTip (copy)
    if p6 == nil or p6 == "" then
        return;
    end;

    _renderTranslatedTip(TranslationHelper.TranslateByKey(p6, p7), p8, p9, p10);
end;

local function _onShowTips2Key(p11, p12, p13, p14) -- Line: 81
    -- upvalues: TranslationHelper (copy), _renderTranslatedTip (copy)
    if p11 == nil or p11 == "" then
        return;
    end;

    _renderTranslatedTip(TranslationHelper.TranslateByKey(p11, p13) .. (p12 and TranslationHelper.TranslateByKey(p12, p13) or ""), p14);
end;

local function _registerTipsHandler(p15, p16) -- Line: 97
    -- upvalues: NetWork (copy)
    NetWork.RegisterBindableEvent(p15, p16);
    NetWork.RegisterClientRemoteEvent(p15, p16);
end;

local function _onNewShowTips(p17) -- Line: 107
    -- upvalues: TipsRenderer (copy)
    TipsRenderer.createTip(p17);
end;

local function _onNewShowTipsWithType(p18, p19) -- Line: 117
    -- upvalues: TipsRenderer (copy)
    TipsRenderer.templateTip(p18, p19);
end;

local function _onNewShowTipsWithTemplate(p20) -- Line: 126
    -- upvalues: TipsRenderer (copy)
    TipsRenderer.showFromServerTemplate(p20);
end;

local SHOW_TIPS = NetMsg.SHOW_TIPS;
NetWork.RegisterBindableEvent(SHOW_TIPS, _onShowTips);
NetWork.RegisterClientRemoteEvent(SHOW_TIPS, _onShowTips);
local SHOW_TIPS_2KEY = NetMsg.SHOW_TIPS_2KEY;
NetWork.RegisterBindableEvent(SHOW_TIPS_2KEY, _onShowTips2Key);
NetWork.RegisterClientRemoteEvent(SHOW_TIPS_2KEY, _onShowTips2Key);
local NEW_SHOW_TIPS = NetMsg.NEW_SHOW_TIPS;
NetWork.RegisterBindableEvent(NEW_SHOW_TIPS, _onNewShowTips);
NetWork.RegisterClientRemoteEvent(NEW_SHOW_TIPS, _onNewShowTips);
local NEW_SHOW_TIPS_WITH_TYPE = NetMsg.NEW_SHOW_TIPS_WITH_TYPE;
NetWork.RegisterBindableEvent(NEW_SHOW_TIPS_WITH_TYPE, _onNewShowTipsWithType);
NetWork.RegisterClientRemoteEvent(NEW_SHOW_TIPS_WITH_TYPE, _onNewShowTipsWithType);
local NEW_SHOW_TIPS_WITH_TEMP = NetMsg.NEW_SHOW_TIPS_WITH_TEMP;
NetWork.RegisterBindableEvent(NEW_SHOW_TIPS_WITH_TEMP, _onNewShowTipsWithTemplate);
NetWork.RegisterClientRemoteEvent(NEW_SHOW_TIPS_WITH_TEMP, _onNewShowTipsWithTemplate);
NetWork.RegisterClientRemoteEvent(NetMsg.DAMAGE_TIP, function(p21, p22, p23, p24) -- Line: 136
    -- upvalues: TipsDamageTip (copy)
    TipsDamageTip.show(p21, p22, p23, p24);
end);