-- Decompiled with Potassium's decompiler.

local v1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local UIMgr = UtilsSystem.UIMgr;
local TranslationHelper = UtilsSystem.TranslationHelper;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local MathMgr = UtilsSystem.MathMgr;
local GetData = UtilsSystem.GetData;
local TipsModule = UtilsSystem.TipsModule;
local NetWork = UtilsSystem.NetWork;
local NetMsg = UtilsSystem.NetMsg;
local LocalPlayer = UtilsSystem.LocalPlayer;
local SystemBuyRoblox = UtilsSystem.SystemBuyRoblox;
local FXUtil = UtilsSystem.FXUtil;
local HumanModule = UtilsSystem.HumanModule;
local AllUI = require(script.AllUI);
local UIRoot = AllUI.UIRoot;
local Frame = AllUI.Frame;
local MaxRebirth = AllUI.MaxRebirth;
local RebirthBtn = AllUI.RebirthBtn;
local SkipBtn = AllUI.SkipBtn;
local u2 = AllUI["等级文本"];
local u3 = AllUI["等级进度条"];
local u4 = AllUI["重生后经验倍率"];
local u5 = AllUI["重生后金币倍率"];
local u6 = AllUI["当前经验倍率"];
local u7 = AllUI["当前金币倍率"];
local u8 = GetData.WaitBagNumberValue(LocalPlayer, EnumMgr.ItemID.Level);
local u9 = GetData.WaitBagNumberValue(LocalPlayer, EnumMgr.ItemID.Rebirth);
local u10 = false;
local u11 = nil;

local function _formatMultiplierText(p12) -- Line: 96
    -- upvalues: MathMgr (copy)
    local v13 = tonumber(p12) or 1;

    return "x" .. MathMgr.getNumStr_1(v13 <= 0 and 1 or v13);
end;

local function _getBonusByTierId(p14) -- Line: 110
    -- upvalues: CfgFind (copy)
    if p14 <= 0 then
        return 0, 0;
    end;

    local v15 = CfgFind.GetCfgByNameAndID("rebirthConf", p14);

    if v15 then
        return tonumber(v15.ExpAdd) or 0, tonumber(v15.GoldAdd) or 0;
    end;

    return 0, 0;
end;

local function _getRebirthCount() -- Line: 128
    -- upvalues: u9 (copy)
    return math.floor(u9.Value);
end;

local function _getPlayerLevel() -- Line: 137
    -- upvalues: u8 (copy)
    return math.floor(u8.Value);
end;

local function _getCurrentBonus(p16) -- Line: 147
    -- upvalues: _getBonusByTierId (copy)
    return _getBonusByTierId(p16);
end;

local function _getNextRebirthCfg(p17) -- Line: 157
    -- upvalues: CfgFind (copy)
    return CfgFind.GetCfgByNameAndID("rebirthConf", p17 + 1);
end;

local function _setBtnEnabled(p18, p19) -- Line: 168
    -- upvalues: UIMgr (copy)
    local v20 = UIMgr.FindButtonInFrame(p18);

    if v20 then
        v20.Active = p19;
        v20.AutoButtonColor = p19;
    end;

    p18.Visible = true;
end;

local function _playRebirthFx() -- Line: 182
    -- upvalues: HumanModule (copy), LocalPlayer (copy), FXUtil (copy)
    local v21 = HumanModule.GetCharacter(LocalPlayer);

    if not v21 then
        return;
    end;

    local HumanoidRootPart = v21:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        FXUtil.PlayEffect("重生", HumanoidRootPart.CFrame, 3, 3);
    end;
end;

local function _parseNextUi(p22) -- Line: 200
    if type(p22) ~= "table" then
        return nil;
    end;

    local nextUi = p22.nextUi;

    if type(nextUi) == "string" and nextUi ~= "" then
        return nextUi;
    end;

    return nil;
end;

local function _openNextUiDeferred(u23) -- Line: 217
    -- upvalues: NetWork (copy), NetMsg (copy)
    task.defer(function() -- Line: 218
        -- upvalues: NetWork (ref), NetMsg (ref), u23 (copy)
        NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, u23, nil, true, true);
    end);
end;

local function _onRebirthSuccess(p24) -- Line: 229
    -- upvalues: HumanModule (copy), LocalPlayer (copy), FXUtil (copy), UIRoot (copy), u11 (ref), NetWork (copy), NetMsg (copy)
    local v25 = HumanModule.GetCharacter(LocalPlayer);

    if v25 then
        local HumanoidRootPart = v25:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
            FXUtil.PlayEffect("重生", HumanoidRootPart.CFrame, 3, 3);
        end;
    end;

    local u26;

    if type(p24) == "table" then
        u26 = p24.nextUi;

        if type(u26) ~= "string" or u26 == "" then
            u26 = nil;
        end;
    else
        u26 = nil;
    end;

    if not UIRoot.Visible then
        if u26 then
            task.defer(function() -- Line: 218
                -- upvalues: NetWork (ref), NetMsg (ref), u26 (copy)
                NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, u26, nil, true, true);
            end);
        end;

        return;
    end;

    u11 = u26;
    NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "Rebirth", nil, false, true);
end;

local function _refreshRebirthUi() -- Line: 246
    -- upvalues: u9 (copy), u8 (copy), CfgFind (copy), TranslationHelper (copy), u6 (copy), MathMgr (copy), u7 (copy), Frame (copy), MaxRebirth (copy), u4 (copy), u5 (copy), u3 (copy), u2 (copy), RebirthBtn (copy), UIMgr (copy), SkipBtn (copy)
    local v27 = math.floor(u9.Value);
    local v28 = math.floor(u8.Value);
    local v29, v30;

    if v27 <= 0 then
        v29 = 0;
        v30 = 0;
    else
        local v31 = CfgFind.GetCfgByNameAndID("rebirthConf", v27);

        if v31 then
            v29 = tonumber(v31.ExpAdd) or 0;
            v30 = tonumber(v31.GoldAdd) or 0;
        else
            v29 = 0;
            v30 = 0;
        end;
    end;

    local v32 = CfgFind.GetCfgByNameAndID("rebirthConf", v27 + 1);
    local SetText_UnTrans = TranslationHelper.SetText_UnTrans;
    local v33 = tonumber(v29) or 1;
    SetText_UnTrans(u6, "x" .. MathMgr.getNumStr_1(v33 <= 0 and 1 or v33));
    local SetText_UnTrans2 = TranslationHelper.SetText_UnTrans;
    local v34 = tonumber(v30) or 1;
    SetText_UnTrans2(u7, "x" .. MathMgr.getNumStr_1(v34 <= 0 and 1 or v34));

    if not v32 then
        Frame.Visible = false;
        MaxRebirth.Visible = true;
        local SetText_UnTrans3 = TranslationHelper.SetText_UnTrans;
        local v35 = tonumber(v29) or 1;
        SetText_UnTrans3(u4, "x" .. MathMgr.getNumStr_1(v35 <= 0 and 1 or v35));
        local SetText_UnTrans4 = TranslationHelper.SetText_UnTrans;
        local v36 = tonumber(v30) or 1;
        SetText_UnTrans4(u5, "x" .. MathMgr.getNumStr_1(v36 <= 0 and 1 or v36));

        return;
    end;

    Frame.Visible = true;
    MaxRebirth.Visible = false;
    local v37 = v27 + 1;
    local v38, v39;

    if v37 <= 0 then
        v38 = 0;
        v39 = 0;
    else
        local v40 = CfgFind.GetCfgByNameAndID("rebirthConf", v37);

        if v40 then
            v38 = tonumber(v40.ExpAdd) or 0;
            v39 = tonumber(v40.GoldAdd) or 0;
        else
            v38 = 0;
            v39 = 0;
        end;
    end;

    local v41 = tonumber(v32.LvNeed) or 0;
    local v42 = math.floor(v41);
    local SetText_UnTrans3 = TranslationHelper.SetText_UnTrans;
    local v43 = tonumber(v38) or 1;
    SetText_UnTrans3(u4, "x" .. MathMgr.getNumStr_1(v43 <= 0 and 1 or v43));
    local SetText_UnTrans4 = TranslationHelper.SetText_UnTrans;
    local v44 = tonumber(v39) or 1;
    SetText_UnTrans4(u5, "x" .. MathMgr.getNumStr_1(v44 <= 0 and 1 or v44));
    local v45 = v42 <= 0 and 0 or math.clamp(v28 / v42, 0, 1);
    u3.Size = UDim2.new(math.max(v45, 0.05), 0, 1, 0);
    TranslationHelper.SetText(u2, "等级A/B", {
        "#ffffff",
        "#ffffff",
        MathMgr.getNumStr(v28),
        "#ffffff",
        MathMgr.getNumStr(v42)
    });
    local v46 = v42 <= v28;
    local v47 = RebirthBtn;
    local v48 = UIMgr.FindButtonInFrame(v47);

    if v48 then
        v48.Active = v46;
        v48.AutoButtonColor = v46;
    end;

    v47.Visible = true;
    local v49 = SkipBtn;
    local v50 = not v46;
    local v51 = UIMgr.FindButtonInFrame(v49);

    if v51 then
        v51.Active = v50;
        v51.AutoButtonColor = v50;
    end;

    v49.Visible = true;
end;

local function _requestRebirth() -- Line: 296
    -- upvalues: u10 (ref), u9 (copy), u8 (copy), CfgFind (copy), TipsModule (copy), LocalPlayer (copy), NetWork (copy), NetMsg (copy)
    if u10 then
        return;
    end;

    local v52 = math.floor(u9.Value);
    local v53 = math.floor(u8.Value);
    local v54 = CfgFind.GetCfgByNameAndID("rebirthConf", v52 + 1);

    if not v54 then
        return;
    end;

    local v55 = tonumber(v54.LvNeed) or 0;
    local v56 = math.floor(v55);

    if v53 < v56 then
        TipsModule.ErrorTips(LocalPlayer, "等阶未达到X不能购买", { v56 });

        return;
    end;

    u10 = true;
    local success, result = pcall(function() -- Line: 316
        -- upvalues: NetWork (ref), NetMsg (ref)
        return NetWork.InvokeServer(NetMsg.PLAYER_REBIRTH);
    end);
    u10 = false;

    if not success then
        return;
    end;

    if result ~= true then
        TipsModule.ErrorTips(LocalPlayer, "等阶未达到X不能购买", { v56 });
    end;
end;

AddListen.NumValueAdd(u8, _refreshRebirthUi, true);
AddListen.NumValueAdd(u9, _refreshRebirthUi, true);
NetWork.RegisterClientRemoteEvent(NetMsg.PLAYER_REBIRTH_FX, _onRebirthSuccess);
local v57 = UIMgr.FindButtonInFrame(AllUI.Exit);

if v57 then
    AddListen.AddMouseCLick(v57, function() -- Line: 341
        -- upvalues: u11 (ref), NetWork (copy), NetMsg (copy)
        u11 = nil;
        NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "Rebirth", nil, false, true);
    end, AllUI.Exit);
end;

local v58 = UIMgr.FindButtonInFrame(RebirthBtn);

if v58 then
    AddListen.AddMouseCLick(v58, _requestRebirth, RebirthBtn);
end;

local v59 = UIMgr.FindButtonInFrame(SkipBtn);

if v59 then
    AddListen.AddMouseCLick(v59, function() -- Line: 355
        -- upvalues: u9 (copy), CfgFind (copy), SystemBuyRoblox (copy), LocalPlayer (copy)
        local v60 = math.floor(u9.Value);

        if not CfgFind.GetCfgByNameAndID("rebirthConf", v60 + 1) then
            return;
        end;

        SystemBuyRoblox.BuyRobloxByOnlyTag(LocalPlayer, "SkipRebirth");
    end, SkipBtn);
end;

function v1.updateUi(p61, p62) -- Line: 373
    -- upvalues: _refreshRebirthUi (copy)
    _refreshRebirthUi();
end;

function v1.openUi(p63) -- Line: 382
    -- upvalues: UIMgr (copy), UIRoot (copy), _refreshRebirthUi (copy)
    UIMgr.SetMainUIVisible(false);
    UIRoot.Visible = true;
    UIMgr.UpdateBlurVisible();
    _refreshRebirthUi();
end;

function v1.closeUi(p64) -- Line: 395
    -- upvalues: UIRoot (copy), UIMgr (copy), u11 (ref), NetWork (copy), NetMsg (copy)
    UIRoot.Visible = false;
    UIMgr.SetMainUIVisible(nil);
    UIMgr.UpdateBlurVisible();
    local u65 = u11;
    u11 = nil;

    if u65 then
        task.defer(function() -- Line: 218
            -- upvalues: NetWork (ref), NetMsg (ref), u65 (copy)
            NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, u65, nil, true, true);
        end);
    end;
end;

return v1;