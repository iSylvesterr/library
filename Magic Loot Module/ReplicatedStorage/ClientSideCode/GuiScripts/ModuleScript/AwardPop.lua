-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local MathMgr = UtilsSystem.MathMgr;
local AddListen = UtilsSystem.AddListen;
local InsMgr = UtilsSystem.InsMgr;
local UIMgr = UtilsSystem.UIMgr;
local NetWork = UtilsSystem.NetWork;
local NetMsg = UtilsSystem.NetMsg;
local AllUI = require(script.AllUI);
local v1 = {};
local UIRoot = AllUI.UIRoot;
local u2 = nil;

local function _ensureHideMainMarker() -- Line: 38
    -- upvalues: InsMgr (copy), UIRoot (copy)
    InsMgr.GetIns("隐藏主界面", "BoolValue", UIRoot).Value = true;
end;

local function _requestClose() -- Line: 46
    -- upvalues: NetWork (copy), NetMsg (copy)
    NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "AwardPop", nil, false, true);
end;

local v3 = UIMgr.FindButtonInFrame(AllUI.Exit);

if v3 then
    AddListen.AddMouseCLick(v3, _requestClose, AllUI.Exit);
end;

local v4 = UIMgr.FindButtonInFrame(AllUI.AwardBtn);

if v4 then
    AddListen.AddMouseCLick(v4, _requestClose, AllUI.AwardBtn);
end;

function v1.updateUi(p5, p6) -- Line: 66
    -- upvalues: u2 (ref), AllUI (copy), MathMgr (copy), UIMgr (copy)
    u2 = nil;

    if type(p6) ~= "table" then
        return;
    end;

    if type(p6.nextUi) == "string" and p6.nextUi ~= "" then
        u2 = p6.nextUi;
    end;

    local v7 = tonumber(p6.magic) or 0;
    local v8 = math.floor(v7);
    AllUI.MagicAward.Visible = v8 > 0;

    if v8 > 0 then
        local Nun = AllUI.MagicAward:FindFirstChild("Nun");

        if Nun and Nun:IsA("TextLabel") then
            Nun.Text = "+" .. MathMgr.getNumStr(v8);
        end;
    end;

    local v9 = tonumber(p6.coin) or 0;
    local v10 = math.floor(v9);
    AllUI.MoneyAward.Visible = v10 > 0;

    if v10 > 0 then
        local Nun = AllUI.MoneyAward:FindFirstChild("Nun");

        if Nun and Nun:IsA("TextLabel") then
            Nun.Text = "+" .. MathMgr.getNumStr(v10);
        end;
    end;

    UIMgr.SetUIlistSize(AllUI.Scroll);
end;

function v1.openUi(p11) -- Line: 102
    -- upvalues: UIRoot (copy), InsMgr (copy), UIMgr (copy)
    UIRoot.Visible = true;
    InsMgr.GetIns("隐藏主界面", "BoolValue", UIRoot).Value = true;
    UIMgr.SetMainUIVisible(false);
    UIMgr.UpdateBlurVisible();
end;

function v1.closeUi(p12) -- Line: 115
    -- upvalues: UIRoot (copy), UIMgr (copy), u2 (ref), NetWork (copy), NetMsg (copy)
    UIRoot.Visible = false;
    UIMgr.SetMainUIVisible(nil);
    UIMgr.UpdateBlurVisible();
    local u13 = u2;
    u2 = nil;

    if u13 then
        task.defer(function() -- Line: 124
            -- upvalues: NetWork (ref), NetMsg (ref), u13 (copy)
            NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, u13, nil, true, true);
        end);
    end;
end;

return v1;