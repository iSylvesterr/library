-- Decompiled with Potassium's decompiler.

local v1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local GetData = UtilsSystem.GetData;
local InsMgr = UtilsSystem.InsMgr;
local Log = UtilsSystem.Log;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local TranslationHelper = UtilsSystem.TranslationHelper;
local UIMgr = UtilsSystem.UIMgr;
local AllUI = require(script.AllUI);
local UIRoot = AllUI.UIRoot;
local Scroll = AllUI.Scroll;
local Temp = AllUI.Temp;
local Event = UIRoot.Parent:FindFirstChild("Event");
local u2 = UDim2.fromOffset(800, 400);
local u3 = UDim2.fromOffset(910, 496);
local u4 = false;
Temp.Visible = false;

local function _ensureHideMainMarker() -- Line: 56
    -- upvalues: InsMgr (copy), UIRoot (copy)
    InsMgr.GetIns("隐藏主界面", "BoolValue", UIRoot).Value = true;
end;

local function _requestClose() -- Line: 64
    -- upvalues: NetWork (copy), NetMsg (copy)
    NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "HatchPop", nil, false, true);
end;

local v5 = UIMgr.FindButtonInFrame(AllUI.Exit);

if v5 then
    AddListen.AddMouseCLick(v5, _requestClose, AllUI.Exit);
end;

local function _applyWindowSize(p6) -- Line: 77
    -- upvalues: UIRoot (copy), u3 (copy), u2 (copy)
    if p6 >= 10 then
        UIRoot.Size = u3;

        return;
    end;

    UIRoot.Size = u2;
end;

local function _decorateItem(p7, p8, p9) -- Line: 91
    -- upvalues: TranslationHelper (copy), UIMgr (copy), GetData (copy), EnumMgr (copy)
    local Top = p7:FindFirstChild("Top");

    if Top and Top:IsA("Frame") then
        local Name = Top:FindFirstChild("Name");

        if Name and Name:IsA("TextLabel") then
            TranslationHelper.SetText(Name, p9.ZhName or "");
        end;

        local Xyd = Top:FindFirstChild("Xyd");

        if Xyd and Xyd:IsA("TextLabel") then
            UIMgr.setXydLabel(Xyd, p9.xyd or 1);
        end;

        local v10 = Top:FindFirstChild("永久");

        if v10 and v10:IsA("GuiObject") then
            local v11 = GetData.Alchemy.ShouldGrantEventPotionAsPay(p8);
            v10.Visible = v11;

            if v11 and v10:IsA("TextLabel") then
                TranslationHelper.SetText(v10, "永久");
            end;
        end;
    end;

    UIMgr.ApplyItemIconOrViewport(p7, p8, (tostring(p9.Icon or "")));
    local ViewportFrame = p7:FindFirstChild("ViewportFrame");

    if ViewportFrame and ViewportFrame:IsA("GuiObject") then
        if tonumber(p9.tp) == EnumMgr.ItemType.Armor then
            ViewportFrame.Position = UDim2.new(0.5, 0, 0.65, 0);
        else
            ViewportFrame.Position = UDim2.new(0.5, 0, 0.5, 0);
        end;
    end;

    local BG = p7:FindFirstChild("BG");

    if BG and BG:IsA("Frame") then
        UIMgr.ApplyEquipmentItemBg(BG, p9.xyd or 1);
    end;
end;

local function _rebuildList(p12) -- Line: 135
    -- upvalues: UIMgr (copy), Scroll (copy), Temp (copy), CfgFind (copy), Log (copy), _decorateItem (copy)
    UIMgr.ClearScrollItems(Scroll, {
        keepInstances = { Temp }
    });
    local v13 = {};

    for _, v in ipairs(p12) do
        local v14 = tonumber(v) or 0;

        if v14 > 0 then
            local v15 = CfgFind.FindCfgByID(v14);

            if v15 then
                local v16 = {
                    itemId = v14,
                    xyd = tonumber(v15.xyd) or 1,
                    cfg = v15
                };
                table.insert(v13, v16);
            else
                Log.warn("[HatchPop] 无物品配置:", v14);
            end;
        end;
    end;

    table.sort(v13, function(p17, p18) -- Line: 155
        if p17.xyd == p18.xyd then
            return p17.itemId < p18.itemId;
        end;

        return p17.xyd > p18.xyd;
    end);

    for i, v in ipairs(v13) do
        local v19 = Temp:Clone();
        v19.Name = "HatchResult_" .. tostring(i);
        v19.Visible = true;
        v19.LayoutOrder = i;
        v19.Parent = Scroll;
        _decorateItem(v19, v.itemId, v.cfg);
    end;

    UIMgr.SetUIlistSize(Scroll);
end;

function v1.updateUi(p20, p21) -- Line: 180
    -- upvalues: UIRoot (copy), u3 (copy), u2 (copy), _rebuildList (copy)
    if type(p21) ~= "table" then
        return;
    end;

    local itemIds = p21.itemIds;

    if type(itemIds) ~= "table" then
        return;
    end;

    if (tonumber(p21.times) or (#itemIds >= 10 and 10 or 3)) >= 10 then
        UIRoot.Size = u3;
    else
        UIRoot.Size = u2;
    end;

    _rebuildList(itemIds);
end;

function v1.openUi(p22) -- Line: 203
    -- upvalues: UIRoot (copy), InsMgr (copy), UIMgr (copy), u4 (ref), Event (copy)
    UIRoot.Visible = true;
    InsMgr.GetIns("隐藏主界面", "BoolValue", UIRoot).Value = true;
    UIMgr.SetMainUIVisible(false);
    UIMgr.UpdateBlurVisible();
    u4 = false;

    if Event and Event.Visible then
        Event.Visible = false;
        u4 = true;
    end;
end;

function v1.closeUi(p23) -- Line: 220
    -- upvalues: UIRoot (copy), UIMgr (copy), Scroll (copy), Temp (copy), u4 (ref), Event (copy)
    UIRoot.Visible = false;
    UIMgr.ClearScrollItems(Scroll, {
        keepInstances = { Temp }
    });

    if u4 and Event then
        Event.Visible = true;
        u4 = false;
        UIMgr.SetMainUIVisible(false);
    else
        UIMgr.SetMainUIVisible(nil);
    end;

    UIMgr.UpdateBlurVisible();
end;

return v1;