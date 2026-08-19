-- Decompiled with Potassium's decompiler.

local v1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local CfgFind = UtilsSystem.CfgFind;
local GetData = UtilsSystem.GetData;
local EnumMgr = UtilsSystem.EnumMgr;
local Log = UtilsSystem.Log;
local MathMgr = UtilsSystem.MathMgr;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local PlayerData = UtilsSystem.PlayerData;
local TimeTransfer = UtilsSystem.TimeTransfer;
local TranslationHelper = UtilsSystem.TranslationHelper;
local UIMgr = UtilsSystem.UIMgr;
local LocalPlayer = UtilsSystem.LocalPlayer;
local AllUI = require(script.AllUI);
local UIRoot = AllUI.UIRoot;
local BigTemp = AllUI.BigTemp;
local Temp = AllUI.Temp;
local Parent = Temp.Parent;
local u2 = false;
local u3 = false;
local u4 = false;
local u5 = false;
local u6 = 0;
local u7 = CfgFind.GetLoginMaxDays();
Temp.Visible = false;

local function _calcRebirthScaledAwardCount(p8, p9) -- Line: 71
    -- upvalues: EnumMgr (copy), GetData (copy), LocalPlayer (copy)
    local v10 = tonumber(p9) or 0;
    local v11 = math.max(0, v10);

    if v11 <= 0 then
        return 0;
    end;

    local v12 = tonumber(p8);

    if not v12 then
        return math.floor(v11);
    end;

    local v13;

    if v12 == EnumMgr.ItemID.Coin then
        v13 = GetData.GetGoldAdd(LocalPlayer);
    else
        if v12 ~= EnumMgr.ItemID.Power then
            return math.floor(v11);
        end;

        v13 = GetData.GetRebirthExpAddMul(LocalPlayer);
    end;

    local v14 = (type(v13) ~= "number" or (v13 ~= v13 or v13 <= 0)) and 1 or v13;

    return math.ceil(v11 * v14);
end;

local function _child(p15, p16) -- Line: 100
    local v17 = p15:FindFirstChild(p16);

    if v17 and v17:IsA("GuiObject") then
        return v17;
    end;

    return nil;
end;

local function _getClaimBtnRoot(p18) -- Line: 113
    local Btns = p18:FindFirstChild("Btns");

    if not Btns then
        return nil;
    end;

    local ClaimBtn = Btns:FindFirstChild("ClaimBtn");

    if ClaimBtn and ClaimBtn:IsA("Frame") then
        return ClaimBtn;
    end;

    return nil;
end;

local function _getClaimClickBtn(p19) -- Line: 130
    local Btns = p19:FindFirstChild("Btns");
    local v20;

    if Btns then
        v20 = Btns:FindFirstChild("ClaimBtn");

        if not (v20 and v20:IsA("Frame")) then
            v20 = nil;
        end;
    else
        v20 = nil;
    end;

    if not v20 then
        return nil;
    end;

    local Btn = v20:FindFirstChild("Btn");

    if Btn and Btn:IsA("GuiButton") then
        return Btn;
    end;

    return nil;
end;

local function _getDayState(p21, p22) -- Line: 148
    if p22 then
        p22 = p22[tostring(p21)];
    end;

    return type(p22) == "table" and (tonumber(p22.State) or 0) or 0;
end;

local function _fillSlotCount(p23, p24) -- Line: 162
    -- upvalues: _calcRebirthScaledAwardCount (copy), TranslationHelper (copy), MathMgr (copy)
    local v25 = _calcRebirthScaledAwardCount(tonumber(p24.AwardID) or 0, tonumber(p24.CountID) or 1);
    local Count = p23:FindFirstChild("Count");

    if not (Count and Count:IsA("GuiObject")) then
        Count = nil;
    end;

    if not Count then
        return;
    end;

    if v25 <= 1 then
        Count.Visible = false;

        return;
    end;

    Count.Visible = true;
    TranslationHelper.SetText_UnTrans(Count, "x" .. MathMgr.getNumStr(v25));
end;

local function _fillSlotStatic(p26, p27, p28) -- Line: 185
    -- upvalues: CfgFind (copy), TranslationHelper (copy), UIMgr (copy), _fillSlotCount (copy)
    local v29 = tonumber(p28.AwardID) or 0;
    local v30 = CfgFind.FindCfgByID(v29);
    local Name = p26:FindFirstChild("Name");

    if not (Name and Name:IsA("GuiObject")) then
        Name = nil;
    end;

    if Name and (v30 and v30.ZhName) then
        TranslationHelper.SetText(Name, v30.ZhName);
        local xyd = v30.xyd;

        if xyd then
            UIMgr.AddGradientColor(tostring(xyd), Name, true);
        end;
    end;

    _fillSlotCount(p26, p28);
    local Day = p26:FindFirstChild("Day");

    if not (Day and Day:IsA("GuiObject")) then
        Day = nil;
    end;

    if Day then
        Day.Visible = true;
        TranslationHelper.SetText(Day, "第XX天", { p27 });
    end;

    UIMgr.ApplyItemIconOrViewport(p26, v29, (tostring(p28.Icon or "")));
end;

local function _refreshSlotState(p31, p32, p33) -- Line: 216
    -- upvalues: TimeTransfer (copy), TranslationHelper (copy)
    local u34 = p31:FindFirstChild("可领取");

    if not (u34 and u34:IsA("GuiObject")) then
        u34 = nil;
    end;

    local u35 = p31:FindFirstChild("已领取");

    if not (u35 and u35:IsA("GuiObject")) then
        u35 = nil;
    end;

    local Btns = p31:FindFirstChild("Btns");
    local u36;

    if Btns then
        u36 = Btns:FindFirstChild("ClaimBtn");

        if not (u36 and u36:IsA("Frame")) then
            u36 = nil;
        end;
    else
        u36 = nil;
    end;

    local u37;

    if u36 then
        u37 = u36:FindFirstChild("Bg");
    else
        u37 = nil;
    end;

    local u38;

    if u36 then
        u38 = u36:FindFirstChild("UnBg");
    else
        u38 = nil;
    end;

    local v39;

    if u38 and u38:IsA("GuiObject") then
        v39 = u38:FindFirstChild("Text");
    else
        v39 = nil;
    end;

    local v40;

    if p33 then
        v40 = p33[tostring(p32)];
    else
        v40 = p33;
    end;

    local v41 = type(v40) == "table" and (tonumber(v40.State) or 0) or 0;

    local function _setClaimVisual(p42, p43, p44, p45) -- Line: 225
        -- upvalues: u34 (copy), u35 (copy), u36 (copy), u37 (copy), u38 (copy)
        if u34 then
            u34.Visible = p42;
        end;

        if u35 then
            u35.Visible = p43;
        end;

        if u36 then
            u36.Visible = p45;
        end;

        if u37 and u37:IsA("GuiObject") then
            u37.Visible = p44;
        end;

        if u38 and u38:IsA("GuiObject") then
            u38.Visible = not p44;
        end;
    end;

    if v41 == 2 then
        if u34 then
            u34.Visible = false;
        end;

        if u35 then
            u35.Visible = true;
        end;

        if u36 then
            u36.Visible = false;
        end;

        if u37 and u37:IsA("GuiObject") then
            u37.Visible = false;
        end;

        if u38 and u38:IsA("GuiObject") then
            u38.Visible = true;
        end;

        return;
    end;

    if v41 == 1 then
        if u34 then
            u34.Visible = true;
        end;

        if u35 then
            u35.Visible = false;
        end;

        if u36 then
            u36.Visible = true;
        end;

        if u37 and u37:IsA("GuiObject") then
            u37.Visible = true;
        end;

        if u38 and u38:IsA("GuiObject") then
            u38.Visible = false;
        end;

        return;
    end;

    if u34 then
        u34.Visible = false;
    end;

    if u35 then
        u35.Visible = false;
    end;

    if u36 then
        u36.Visible = true;
    end;

    if u37 and u37:IsA("GuiObject") then
        u37.Visible = false;
    end;

    if u38 and u38:IsA("GuiObject") then
        u38.Visible = true;
    end;

    if v39 and v39:IsA("TextLabel") then
        if p33 then
            p33 = p33.LoginDays;
        end;

        local v46 = tonumber(p33) or 0;
        local v47 = math.max(0, p32 - v46 - 1);
        local v48 = TimeTransfer.GetSecondsUntilNextDay() + v47 * 86400;
        TranslationHelper.SetText_UnTrans(v39, TimeTransfer.UniqueTimeStringRank(v48));
    end;
end;

local function _onClaimClick(p49, p50) -- Line: 270
    -- upvalues: PlayerData (copy), LocalPlayer (copy), u3 (ref), NetWork (copy), NetMsg (copy), _refreshSlotState (copy)
    local v51 = PlayerData.GetPlrDataByKey(LocalPlayer, "Login");

    if v51 then
        v51 = v51[tostring(p49)];
    end;

    if (type(v51) == "table" and (tonumber(v51.State) or 0) or 0) ~= 1 then
        return;
    end;

    if u3 then
        return;
    end;

    u3 = true;
    local v52 = NetWork.InvokeServer(NetMsg.CLAIM_DAILY_AWARD, p49);
    u3 = false;

    if v52 then
        _refreshSlotState(p50, p49, PlayerData.GetPlrDataByKey(LocalPlayer, "Login"));
    end;
end;

local function _bindClaimClick(u53, u54) -- Line: 292
    -- upvalues: Log (copy), AddListen (copy), _onClaimClick (copy)
    local Btns = u53:FindFirstChild("Btns");
    local v55;

    if Btns then
        v55 = Btns:FindFirstChild("ClaimBtn");

        if not (v55 and v55:IsA("Frame")) then
            v55 = nil;
        end;
    else
        v55 = nil;
    end;

    local v56;

    if v55 then
        v56 = v55:FindFirstChild("Btn");

        if not (v56 and v56:IsA("GuiButton")) then
            v56 = nil;
        end;
    else
        v56 = nil;
    end;

    if v56 then
        AddListen.AddMouseCLick(v56, function() -- Line: 298
            -- upvalues: _onClaimClick (ref), u54 (copy), u53 (copy)
            _onClaimClick(u54, u53);
        end, v56);

        return;
    end;

    Log.warn("[Login] ClaimBtn.Btn 缺失", u54);
end;

local function _buildSlots() -- Line: 307
    -- upvalues: u2 (ref), u7 (ref), CfgFind (copy), BigTemp (copy), Temp (copy), Parent (copy), _fillSlotStatic (copy), _bindClaimClick (copy)
    if u2 then
        return;
    end;

    u2 = true;
    u7 = CfgFind.GetLoginMaxDays();
    local v57 = CfgFind.GetLoginAwardList();

    for _, v in ipairs(v57) do
        local v58 = tonumber(v.id) or 0;

        if v58 > 0 then
            local v59;

            if v58 == u7 then
                v59 = BigTemp;
                BigTemp.Name = tostring(v58);
                BigTemp.Visible = true;
            else
                v59 = Temp:Clone();
                v59.Name = tostring(v58);
                v59.LayoutOrder = v58;
                v59.Visible = true;
                v59.Parent = Parent;
            end;

            _fillSlotStatic(v59, v58, v);
            _bindClaimClick(v59, v58);
        end;
    end;
end;

local function _refreshAll() -- Line: 341
    -- upvalues: PlayerData (copy), LocalPlayer (copy), CfgFind (copy), u7 (ref), BigTemp (copy), Parent (copy), _fillSlotCount (copy), _refreshSlotState (copy)
    local v60 = PlayerData.GetPlrDataByKey(LocalPlayer, "Login");
    local v61 = CfgFind.GetLoginAwardList();

    for _, v in ipairs(v61) do
        local v62 = tonumber(v.id) or 0;

        if v62 > 0 then
            local v63;

            if v62 == u7 then
                v63 = BigTemp;
            else
                v63 = Parent:FindFirstChild((tostring(v62)));
            end;

            if v63 then
                _fillSlotCount(v63, v);
                _refreshSlotState(v63, v62, v60);
            end;
        end;
    end;
end;

local function _ensureRebirthListen() -- Line: 365
    -- upvalues: u5 (ref), LocalPlayer (copy), UIRoot (copy), _refreshAll (copy), AddListen (copy)
    if u5 then
        return;
    end;

    u5 = true;
    task.spawn(function() -- Line: 370
        -- upvalues: LocalPlayer (ref), UIRoot (ref), _refreshAll (ref), AddListen (ref)
        local RebirthBonus = LocalPlayer:WaitForChild("RebirthBonus", (1 / 0));

        local function onBonusChanged() -- Line: 372
            -- upvalues: UIRoot (ref), _refreshAll (ref)
            if UIRoot.Visible then
                _refreshAll();
            end;
        end;

        local ExpAdd = RebirthBonus:WaitForChild("ExpAdd", (1 / 0));

        if ExpAdd:IsA("NumberValue") then
            AddListen.NumValueAdd(ExpAdd, onBonusChanged, false);
        end;

        local GoldAdd = RebirthBonus:WaitForChild("GoldAdd", (1 / 0));

        if GoldAdd:IsA("NumberValue") then
            AddListen.NumValueAdd(GoldAdd, onBonusChanged, false);
        end;
    end);
end;

local function _startCountdownLoop() -- Line: 392
    -- upvalues: u6 (ref), UIRoot (copy), _refreshAll (copy)
    u6 = u6 + 1;
    local u64 = u6;
    task.spawn(function() -- Line: 395
        -- upvalues: u64 (copy), u6 (ref), UIRoot (ref), _refreshAll (ref)
        while u64 == u6 and UIRoot.Visible do
            _refreshAll();
            task.wait(1);
        end;
    end);
end;

function v1.updateUi(p65, p66) -- Line: 408
    -- upvalues: _buildSlots (copy), u5 (ref), LocalPlayer (copy), UIRoot (copy), _refreshAll (copy), AddListen (copy)
    _buildSlots();

    if not u5 then
        u5 = true;
        task.spawn(function() -- Line: 370
            -- upvalues: LocalPlayer (ref), UIRoot (ref), _refreshAll (ref), AddListen (ref)
            local RebirthBonus = LocalPlayer:WaitForChild("RebirthBonus", (1 / 0));

            local function v67() -- Line: 372
                -- upvalues: UIRoot (ref), _refreshAll (ref)
                if UIRoot.Visible then
                    _refreshAll();
                end;
            end;

            local ExpAdd = RebirthBonus:WaitForChild("ExpAdd", (1 / 0));

            if ExpAdd:IsA("NumberValue") then
                AddListen.NumValueAdd(ExpAdd, v67, false);
            end;

            local GoldAdd = RebirthBonus:WaitForChild("GoldAdd", (1 / 0));

            if GoldAdd:IsA("NumberValue") then
                AddListen.NumValueAdd(GoldAdd, v67, false);
            end;
        end);
    end;

    _refreshAll();
end;

function v1.openUi(p68) -- Line: 418
    -- upvalues: UIMgr (copy), UIRoot (copy), _buildSlots (copy), u5 (ref), LocalPlayer (copy), _refreshAll (copy), AddListen (copy), u6 (ref), u4 (ref), PlayerData (copy)
    UIMgr.SetMainUIVisible(false);
    UIRoot.Visible = true;
    UIMgr.UpdateBlurVisible();
    _buildSlots();

    if not u5 then
        u5 = true;
        task.spawn(function() -- Line: 370
            -- upvalues: LocalPlayer (ref), UIRoot (ref), _refreshAll (ref), AddListen (ref)
            local RebirthBonus = LocalPlayer:WaitForChild("RebirthBonus", (1 / 0));

            local function v69() -- Line: 372
                -- upvalues: UIRoot (ref), _refreshAll (ref)
                if UIRoot.Visible then
                    _refreshAll();
                end;
            end;

            local ExpAdd = RebirthBonus:WaitForChild("ExpAdd", (1 / 0));

            if ExpAdd:IsA("NumberValue") then
                AddListen.NumValueAdd(ExpAdd, v69, false);
            end;

            local GoldAdd = RebirthBonus:WaitForChild("GoldAdd", (1 / 0));

            if GoldAdd:IsA("NumberValue") then
                AddListen.NumValueAdd(GoldAdd, v69, false);
            end;
        end);
    end;

    _refreshAll();
    u6 = u6 + 1;
    local u70 = u6;
    task.spawn(function() -- Line: 395
        -- upvalues: u70 (copy), u6 (ref), UIRoot (ref), _refreshAll (ref)
        while u70 == u6 and UIRoot.Visible do
            _refreshAll();
            task.wait(1);
        end;
    end);

    if not u4 then
        u4 = true;
        PlayerData.ListenClientSync(function(p71, p72) -- Line: 429
            -- upvalues: UIRoot (ref), _refreshAll (ref)
            if not UIRoot.Visible then
                return;
            end;

            if type(p71) == "table" then
                p71 = p71[1];
            end;

            if p71 == nil or p71 == "Login" then
                _refreshAll();
            end;
        end);
    end;
end;

function v1.closeUi(p73) -- Line: 447
    -- upvalues: u6 (ref), UIRoot (copy), UIMgr (copy)
    u6 = u6 + 1;
    UIRoot.Visible = false;
    UIMgr.SetMainUIVisible(nil);
    UIMgr.UpdateBlurVisible();
end;

local v74 = UIMgr.FindButtonInFrame(AllUI.Exit);

if v74 then
    AddListen.AddMouseCLick(v74, function() -- Line: 456
        -- upvalues: NetWork (copy), NetMsg (copy)
        NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "Login", nil, false, true);
    end, AllUI.Exit);
else
    Log.warn("[Login] Exit 按钮缺失");
end;

return v1;