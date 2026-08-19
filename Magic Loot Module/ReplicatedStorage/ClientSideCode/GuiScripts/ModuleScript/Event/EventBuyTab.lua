-- Decompiled with Potassium's decompiler.

local v1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local CfgFind = UtilsSystem.CfgFind;
local LocalPlayer = UtilsSystem.LocalPlayer;
local Log = UtilsSystem.Log;
local MathMgr = UtilsSystem.MathMgr;
local SystemBuyRoblox = UtilsSystem.SystemBuyRoblox;
local TranslationHelper = UtilsSystem.TranslationHelper;
local UIMgr = UtilsSystem.UIMgr;
local AllUI = require(script.Parent.AllUI);
local u2 = { "DinosaurCoinsPack1", "DinosaurCoinsPack2", "DinosaurCoinsPack3" };

local function _getGrantItem(p3) -- Line: 46
    local itemID = p3.itemID;
    local itemCount = p3.itemCount;
    local v4;

    if type(itemID) == "table" then
        v4 = tonumber(itemID[1]) or 0;
    else
        v4 = tonumber(itemID) or 0;
    end;

    if type(itemCount) == "table" then
        return v4, tonumber(itemCount[1]) or 0;
    end;

    return v4, tonumber(itemCount) or 0;
end;

local function _setPrice(p5, p6) -- Line: 69
    -- upvalues: UIMgr (copy)
    UIMgr.SetRobuxBuyBtnPrice(p5, p6);
    local Price = p5:FindFirstChild("Price");

    if Price and Price:IsA("TextLabel") then
        UIMgr.SetRobuxPriceLabel(Price, p6);
    end;
end;

local function _decoratePack(p7, p8, p9) -- Line: 83
    -- upvalues: TranslationHelper (copy), UIMgr (copy), CfgFind (copy), MathMgr (copy)
    local Name = p7:FindFirstChild("Name");

    if Name and Name:IsA("TextLabel") then
        TranslationHelper.SetText(Name, p9.ZhName or "");
    end;

    local Icon = p7:FindFirstChild("Icon");

    if Icon and Icon:IsA("ImageLabel") then
        local v10 = tostring(p9.Icon or "");

        if v10 ~= "" and v10 ~= "0" then
            UIMgr.SetImage(Icon, v10);
            Icon.Visible = true;
        end;
    end;

    local itemID = p9.itemID;
    local itemCount = p9.itemCount;
    local v11;

    if type(itemID) == "table" then
        v11 = tonumber(itemID[1]) or 0;
    else
        v11 = tonumber(itemID) or 0;
    end;

    local v12;

    if type(itemCount) == "table" then
        v12 = tonumber(itemCount[1]) or 0;
    else
        v12 = tonumber(itemCount) or 0;
    end;

    local Value = p7:FindFirstChild("Value");

    if Value then
        local Icon2 = Value:FindFirstChild("Icon");

        if Icon2 and (Icon2:IsA("ImageLabel") and v11 > 0) then
            local v13 = CfgFind.FindCfgByID(v11);
            local v14 = v13 and tostring(v13.Icon or "") or "";

            if v14 ~= "" and v14 ~= "0" then
                UIMgr.SetImage(Icon2, v14);
                Icon2.Visible = true;
            end;
        end;

        local Num = Value:FindFirstChild("Num");

        if Num and Num:IsA("TextLabel") then
            TranslationHelper.SetText_UnTrans(Num, "+" .. MathMgr.getNumStr(v12));
        end;
    end;

    local RobuxBuyBtn = p7:FindFirstChild("RobuxBuyBtn");

    if RobuxBuyBtn and RobuxBuyBtn:IsA("Frame") then
        UIMgr.SetRobuxBuyBtnPrice(RobuxBuyBtn, p8);
        local Price = RobuxBuyBtn:FindFirstChild("Price");

        if Price and Price:IsA("TextLabel") then
            UIMgr.SetRobuxPriceLabel(Price, p8);
        end;
    end;
end;

local function _bindBuy(p15, u16) -- Line: 127
    -- upvalues: Log (copy), UIMgr (copy), AddListen (copy), SystemBuyRoblox (copy), LocalPlayer (copy)
    if p15:GetAttribute("EventBuyBound") == true then
        return;
    end;

    local RobuxBuyBtn = p15:FindFirstChild("RobuxBuyBtn");

    if not (RobuxBuyBtn and RobuxBuyBtn:IsA("Frame")) then
        Log.warn("[EventBuyTab] 缺少 RobuxBuyBtn:", p15:GetFullName());

        return;
    end;

    local v17 = UIMgr.FindButtonInFrame(RobuxBuyBtn);

    if not v17 then
        Log.warn("[EventBuyTab] 缺少购买 Btn:", p15:GetFullName());

        return;
    end;

    p15:SetAttribute("EventBuyBound", true);
    AddListen.AddMouseCLick(v17, function() -- Line: 142
        -- upvalues: SystemBuyRoblox (ref), LocalPlayer (ref), u16 (copy)
        SystemBuyRoblox.BuyRobloxByOnlyTag(LocalPlayer, u16);
    end, RobuxBuyBtn);
end;

function v1.Clear() -- Line: 150
    -- upvalues: UIMgr (copy), AllUI (copy)
    UIMgr.ClearScrollItems(AllUI.Buy, {
        keepInstances = { AllUI.RobuxBuyTemp }
    });
end;

function v1.Refresh() -- Line: 157
    -- upvalues: AllUI (copy), UIMgr (copy), u2 (copy), CfgFind (copy), Log (copy), _decoratePack (copy), _bindBuy (copy)
    AllUI.RobuxBuyTemp.Visible = false;
    UIMgr.ClearScrollItems(AllUI.Buy, {
        keepInstances = { AllUI.RobuxBuyTemp }
    });

    for i, v in ipairs(u2) do
        local v18 = CfgFind.FindCfgByOnlyTag(v);

        if v18 then
            local v19 = AllUI.RobuxBuyTemp:Clone();
            v19.Name = "Buy_" .. v;
            v19.Visible = true;
            v19.LayoutOrder = i;
            v19.Parent = AllUI.Buy;
            _decoratePack(v19, v, v18);
            _bindBuy(v19, v);
        else
            Log.warn("[EventBuyTab] 无付费配置:", v);
        end;
    end;
end;

function v1.RefreshStates() -- Line: 180
    -- upvalues: AllUI (copy), UIMgr (copy)
    for _, child in ipairs(AllUI.Buy:GetChildren()) do
        if child:IsA("GuiObject") and string.sub(child.Name, 1, 4) == "Buy_" then
            local v20 = string.sub(child.Name, 5);
            local RobuxBuyBtn = child:FindFirstChild("RobuxBuyBtn");

            if RobuxBuyBtn and (RobuxBuyBtn:IsA("Frame") and v20 ~= "") then
                UIMgr.SetRobuxBuyBtnPrice(RobuxBuyBtn, v20);
                local Price = RobuxBuyBtn:FindFirstChild("Price");

                if Price and Price:IsA("TextLabel") then
                    UIMgr.SetRobuxPriceLabel(Price, v20);
                end;
            end;
        end;
    end;
end;

return v1;