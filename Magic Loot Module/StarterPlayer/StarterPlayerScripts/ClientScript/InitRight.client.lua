-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local CfgFind = UtilsSystem.CfgFind;
local GetData = UtilsSystem.GetData;
local LocalPlayer = UtilsSystem.LocalPlayer;
local Log = UtilsSystem.Log;
local MathMgr = UtilsSystem.MathMgr;
local PlayerData = UtilsSystem.PlayerData;
local SystemBuyRoblox = UtilsSystem.SystemBuyRoblox;
local TranslationHelper = UtilsSystem.TranslationHelper;
local UIMgr = UtilsSystem.UIMgr;
local u1 = { "Power1", "Power2", "Power3" };
local u2 = {
    Power1 = true,
    Power2 = true,
    Power3 = true
};
local u3 = { "x2Power", "x4Power", "x8Power", "x16Power", "x32Power", "x64Power" };
local GamePass = UtilsSystem.EnumMgr.RobuxType.GamePass;
local BLOCK_BUY_LIMIT = GetData.Shop.BLOCK_BUY_LIMIT;
local u4 = utf8.char(57346);
local Window = LocalPlayer:WaitForChild("PlayerGui", (1 / 0)):WaitForChild("ScreenGui", (1 / 0)):WaitForChild("Main", (1 / 0)):WaitForChild("Right", (1 / 0)):WaitForChild("Window", (1 / 0));
local u5 = {};
local u6 = false;
local u7 = false;

local function _readOnlyTag(p8) -- Line: 90
    -- upvalues: u2 (copy)
    local v9 = p8:FindFirstChild("付费项");

    if v9 and v9:IsA("StringValue") then
        local Value = v9.Value;

        if type(Value) == "string" and Value ~= "" then
            return Value;
        end;
    end;

    if u2[p8.Name] then
        return p8.Name;
    end;

    return nil;
end;

local function _getNextTrainPowerOnlyTag() -- Line: 109
    -- upvalues: u3 (copy), GetData (copy), LocalPlayer (copy)
    for _, v in ipairs(u3) do
        if not GetData.HasBoughtShopItem(LocalPlayer, v) then
            return v;
        end;
    end;

    return nil;
end;

local function _isDoubleMagicBtn(p10) -- Line: 124
    return p10.Name == "双倍魔力";
end;

local function _findImageButton(p11) -- Line: 134
    -- upvalues: Window (copy)
    local v12 = Window:FindFirstChild(p11);

    if v12 and v12:IsA("ImageButton") then
        return v12;
    end;

    local v13 = Window:WaitForChild(p11, 15);

    if v13 and v13:IsA("ImageButton") then
        return v13;
    end;

    for _, descendant in ipairs(Window:GetDescendants()) do
        if descendant.Name == p11 and descendant:IsA("ImageButton") then
            return descendant;
        end;
    end;

    return nil;
end;

local function _collectPaidButtons() -- Line: 156
    -- upvalues: u1 (copy), _findImageButton (copy), Log (copy), Window (copy), u2 (copy)
    local u14 = {};
    local u15 = {};

    local function tryAdd(p16) -- Line: 160
        -- upvalues: u15 (copy), u14 (copy)
        if not p16 or u15[p16] then
            return;
        end;

        u15[p16] = true;
        table.insert(u14, p16);
    end;

    for _, v in ipairs(u1) do
        local v17 = _findImageButton(v);

        if v17 then
            if v17 then
                if not u15[v17] then
                    u15[v17] = true;
                    table.insert(u14, v17);
                end;
            end;
        else
            Log.warn("[InitRight] 未找到 ImageButton:", v);
        end;
    end;

    for _, child in ipairs(Window:GetChildren()) do
        if child:IsA("ImageButton") then
            local v18 = child:FindFirstChild("付费项");
            local v19;

            if v18 and v18:IsA("StringValue") then
                v19 = v18.Value;

                if type(v19) ~= "string" or v19 == "" then
                    if u2[child.Name] then
                        v19 = child.Name;
                    else
                        v19 = nil;
                    end;
                end;
            elseif u2[child.Name] then
                v19 = child.Name;
            else
                v19 = nil;
            end;

            if v19 and (u2[v19] and child) then
                if not u15[child] then
                    u15[child] = true;
                    table.insert(u14, child);
                end;
            end;
        end;
    end;

    local v20 = _findImageButton("双倍魔力");

    if v20 then
        if v20 then
            if u15[v20] then
                return u14;
            end;

            u15[v20] = true;
            table.insert(u14, v20);

            return u14;
        end;
    else
        Log.warn("[InitRight] 未找到 ImageButton:", "双倍魔力");
    end;

    return u14;
end;

local function _shouldShowOwned(p21, p22, p23) -- Line: 207
    -- upvalues: GamePass (copy), GetData (copy), LocalPlayer (copy), BLOCK_BUY_LIMIT (copy)
    if p23 then
        return tonumber(p21.cost) == GamePass and GetData.IsHasPass(LocalPlayer, p22) and true or GetData.GetShopBuyBlockReason(LocalPlayer, p21) == BLOCK_BUY_LIMIT;
    end;

    return false;
end;

local function _setRobuxBuyBtnOwnedState(p24, p25) -- Line: 226
    local v26 = p24:FindFirstChild("已拥有");

    if not (v26 and v26:IsA("GuiObject")) then
        return;
    end;

    for _, child in ipairs(p24:GetChildren()) do
        if child:IsA("GuiObject") then
            if child.Name == "已拥有" then
                child.Visible = p25;
            else
                child.Visible = not p25;
            end;
        end;
    end;
end;

local function _resolveClickTarget(p27) -- Line: 249
    -- upvalues: UIMgr (copy)
    local RobuxBuyBtn = p27:FindFirstChild("RobuxBuyBtn");
    local v28 = RobuxBuyBtn and (RobuxBuyBtn:IsA("Frame") and UIMgr.FindButtonInFrame(RobuxBuyBtn));

    if v28 then
        return v28, RobuxBuyBtn;
    end;

    local v29 = UIMgr.FindButtonInFrame(p27);

    if v29 and v29 ~= p27 then
        return v29, p27;
    end;

    local Frame = p27:FindFirstChild("Frame");

    if Frame and Frame:IsA("GuiObject") then
        return p27, Frame;
    end;

    return p27, p27;
end;

local function _findPriceLabel(p30) -- Line: 274
    local Price = p30:FindFirstChild("Price");

    if not Price then
        return nil;
    end;

    if Price:IsA("TextLabel") then
        return Price;
    end;

    local PriceNum = Price:FindFirstChild("PriceNum");

    if PriceNum and PriceNum:IsA("TextLabel") then
        return PriceNum;
    end;

    return nil;
end;

local function _refreshBtnRobuxPrice(p31, p32, p33, u34) -- Line: 298
    -- upvalues: UIMgr (copy), u4 (copy)
    local Price = p31:FindFirstChild("Price");

    if Price then
        if not Price:IsA("TextLabel") then
            Price = Price:FindFirstChild("PriceNum");

            if not (Price and Price:IsA("TextLabel")) then
                Price = nil;
            end;
        end;
    else
        Price = nil;
    end;

    if not Price then
        return;
    end;

    UIMgr.SetRobuxPriceLabel(Price, p32, {
        fallbackPrice = p33,

        format = function(p35) -- Line: 306, Name: format
            -- upvalues: u34 (copy), u4 (ref)
            local v36 = math.floor(p35);
            local v37 = tostring(v36);

            if u34 then
                return v37 .. u4;
            end;

            return u4 .. v37;
        end
    });
end;

local function _refreshPowerPackBtn(p38, p39, p40) -- Line: 324
    -- upvalues: TranslationHelper (copy), GetData (copy), LocalPlayer (copy), MathMgr (copy), _refreshBtnRobuxPrice (copy), GamePass (copy), BLOCK_BUY_LIMIT (copy), _setRobuxBuyBtnOwnedState (copy)
    local Name = p38:FindFirstChild("Name");

    if Name and Name:IsA("TextLabel") then
        TranslationHelper.SetText(Name, p40.ZhName or "");
    end;

    local v41 = GetData.CalcPaidPowerGrant(LocalPlayer, p39);
    local Power = p38:FindFirstChild("Power");

    if Power and Power:IsA("TextLabel") then
        if v41 == nil then
            TranslationHelper.SetText_UnTrans(Power, "");
        else
            local SetText_UnTrans = TranslationHelper.SetText_UnTrans;
            local getNumStr = MathMgr.getNumStr;
            local v42 = math.floor(v41);
            SetText_UnTrans(Power, "+" .. getNumStr((math.max(0, v42))));
        end;
    end;

    _refreshBtnRobuxPrice(p38, p39, tonumber(p40.price), false);
    local RobuxBuyBtn = p38:FindFirstChild("RobuxBuyBtn");

    if RobuxBuyBtn and RobuxBuyBtn:IsA("Frame") then
        local v43 = RobuxBuyBtn:FindFirstChild("已拥有");
        local v44;

        if v43 == nil then
            v44 = false;
        else
            v44 = v43:IsA("GuiObject");
        end;

        local v45;

        if v44 then
            v45 = tonumber(p40.cost) == GamePass and GetData.IsHasPass(LocalPlayer, p39) and true or GetData.GetShopBuyBlockReason(LocalPlayer, p40) == BLOCK_BUY_LIMIT;
        else
            v45 = false;
        end;

        _setRobuxBuyBtnOwnedState(RobuxBuyBtn, v45);
    end;
end;

local function _removePaidButton(p46) -- Line: 359
    -- upvalues: u5 (ref)
    for i = #u5, 1, -1 do
        if u5[i] == p46 then
            table.remove(u5, i);

            return;
        end;
    end;
end;

local function _refreshDoubleMagicBtn(p47) -- Line: 374
    -- upvalues: _getNextTrainPowerOnlyTag (copy), _removePaidButton (copy), CfgFind (copy), Log (copy), TranslationHelper (copy), UIMgr (copy), _setRobuxBuyBtnOwnedState (copy)
    local v48 = _getNextTrainPowerOnlyTag();

    if not v48 then
        _removePaidButton(p47);
        p47:Destroy();

        return;
    end;

    local v49 = CfgFind.FindCfgByOnlyTag(v48);

    if not v49 then
        Log.warn("[InitRight] 双倍魔力档位配置缺失:", v48);

        return;
    end;

    local BG = p47:FindFirstChild("BG");

    if BG then
        BG = BG:FindFirstChild("Power");
    end;

    if BG and BG:IsA("TextLabel") then
        TranslationHelper.SetText(BG, v49.ZhName or "");
    end;

    local Price = p47:FindFirstChild("Price");

    if Price then
        if not Price:IsA("TextLabel") then
            Price = Price:FindFirstChild("PriceNum");

            if not (Price and Price:IsA("TextLabel")) then
                Price = nil;
            end;
        end;
    else
        Price = nil;
    end;

    if Price then
        UIMgr.SetRobuxPriceLabel(Price, v48, {
            fallbackPrice = tonumber(v49.price),

            write = function(p50, p51) -- Line: 399, Name: write
                -- upvalues: TranslationHelper (ref)
                if not p50.Parent then
                    return;
                end;

                p50.RichText = false;

                if p51 == nil then
                    TranslationHelper.SetText_UnTrans(p50, "");

                    return;
                end;

                local SetText = TranslationHelper.SetText;
                local v52 = {};
                local v53 = math.floor(p51);
                v52[1] = tostring(v53);
                SetText(p50, "仅需N罗宝", v52);
            end
        });
    end;

    local RobuxBuyBtn = p47:FindFirstChild("RobuxBuyBtn");

    if RobuxBuyBtn and RobuxBuyBtn:IsA("Frame") then
        _setRobuxBuyBtnOwnedState(RobuxBuyBtn, false);
    end;
end;

local function _refreshPaidBtn(p54) -- Line: 425
    -- upvalues: _refreshDoubleMagicBtn (copy), u2 (copy), CfgFind (copy), _refreshPowerPackBtn (copy)
    if not p54.Parent then
        return;
    end;

    if p54.Name == "双倍魔力" then
        _refreshDoubleMagicBtn(p54);

        return;
    end;

    local v55 = p54:FindFirstChild("付费项");
    local v56;

    if v55 and v55:IsA("StringValue") then
        v56 = v55.Value;

        if type(v56) ~= "string" or v56 == "" then
            if u2[p54.Name] then
                v56 = p54.Name;
            else
                v56 = nil;
            end;
        end;
    elseif u2[p54.Name] then
        v56 = p54.Name;
    else
        v56 = nil;
    end;

    if not (v56 and u2[v56]) then
        return;
    end;

    local v57 = CfgFind.FindCfgByOnlyTag(v56);

    if not v57 then
        return;
    end;

    _refreshPowerPackBtn(p54, v56, v57);
end;

local function _refreshAll() -- Line: 450
    -- upvalues: u5 (ref), _refreshPaidBtn (copy)
    for i = #u5, 1, -1 do
        local v58 = u5[i];

        if v58 and v58.Parent then
            _refreshPaidBtn(v58);
        else
            table.remove(u5, i);
        end;
    end;
end;

local function _resolveBuyOnlyTag(p59) -- Line: 467
    -- upvalues: _getNextTrainPowerOnlyTag (copy), u2 (copy)
    if p59.Name == "双倍魔力" then
        return _getNextTrainPowerOnlyTag();
    end;

    local v60 = p59:FindFirstChild("付费项");

    if v60 and v60:IsA("StringValue") then
        local Value = v60.Value;

        if type(Value) == "string" and Value ~= "" then
            return Value;
        end;
    end;

    if u2[p59.Name] then
        return p59.Name;
    end;

    return nil;
end;

local function _bindBuyButtons() -- Line: 479
    -- upvalues: u6 (ref), u5 (ref), _resolveClickTarget (copy), AddListen (copy), _getNextTrainPowerOnlyTag (copy), u2 (copy), SystemBuyRoblox (copy), LocalPlayer (copy)
    if u6 then
        return;
    end;

    u6 = true;

    for _, v in ipairs(u5) do
        local v61, v62 = _resolveClickTarget(v);
        AddListen.AddMouseCLick(v61, function() -- Line: 487
            -- upvalues: v (copy), _getNextTrainPowerOnlyTag (ref), u2 (ref), SystemBuyRoblox (ref), LocalPlayer (ref)
            local v63 = v;
            local v64;

            if v63.Name == "双倍魔力" then
                v64 = _getNextTrainPowerOnlyTag();
            else
                local v65 = v63:FindFirstChild("付费项");

                if v65 and v65:IsA("StringValue") then
                    v64 = v65.Value;

                    if type(v64) ~= "string" or v64 == "" then
                        if u2[v63.Name] then
                            v64 = v63.Name;
                        else
                            v64 = nil;
                        end;
                    end;
                elseif u2[v63.Name] then
                    v64 = v63.Name;
                else
                    v64 = nil;
                end;
            end;

            if not v64 then
                return;
            end;

            SystemBuyRoblox.BuyRobloxByOnlyTag(LocalPlayer, v64);
        end, v62);
    end;
end;

local function _bindWatchers() -- Line: 502
    -- upvalues: u7 (ref), PlayerData (copy), _refreshAll (copy), LocalPlayer (copy), AddListen (copy)
    if u7 then
        return;
    end;

    u7 = true;
    PlayerData.ListenClientSync(function(p66, p67) -- Line: 508
        -- upvalues: _refreshAll (ref)
        if p66 == nil then
            _refreshAll();

            return;
        end;

        if type(p66) == "table" then
            p66 = p66[1];
        end;

        if p66 == "Shop" or p66 == "GamePass" then
            _refreshAll();
        end;
    end);
    task.spawn(function() -- Line: 519
        -- upvalues: LocalPlayer (ref), _refreshAll (ref), AddListen (ref)
        local GamePass2 = LocalPlayer:WaitForChild("GamePass", (1 / 0));

        local function onPassChanged() -- Line: 521
            -- upvalues: _refreshAll (ref)
            _refreshAll();
        end;

        local function bindPassValue(p68) -- Line: 524
            -- upvalues: AddListen (ref), onPassChanged (copy)
            if p68:IsA("NumberValue") then
                AddListen.NumValueAdd(p68, onPassChanged, false);
            end;
        end;

        for _, child in ipairs(GamePass2:GetChildren()) do
            if child:IsA("NumberValue") then
                AddListen.NumValueAdd(child, onPassChanged, false);
            end;
        end;

        GamePass2.ChildAdded:Connect(bindPassValue);
    end);
    task.spawn(function() -- Line: 535
        -- upvalues: LocalPlayer (ref), AddListen (ref), _refreshAll (ref)
        local ExpAdd = LocalPlayer:WaitForChild("RebirthBonus", (1 / 0)):WaitForChild("ExpAdd", (1 / 0));

        if ExpAdd:IsA("NumberValue") then
            AddListen.NumValueAdd(ExpAdd, function() -- Line: 539
                -- upvalues: _refreshAll (ref)
                _refreshAll();
            end, false);
        end;
    end);
end;

local function _logWindowChildren() -- Line: 551
    -- upvalues: Window (copy), Log (copy)
    local v69 = {};

    for _, child in ipairs(Window:GetChildren()) do
        table.insert(v69, child.ClassName .. ":" .. child.Name);
    end;

    Log.warn("[InitRight] Right/Window 子节点:", table.concat(v69, ", "));
end;

(function() -- Line: 564, Name: _init
    -- upvalues: u5 (ref), _collectPaidButtons (copy), _logWindowChildren (copy), Log (copy), _bindBuyButtons (copy), _bindWatchers (copy), _refreshAll (copy)
    u5 = _collectPaidButtons();

    if #u5 == 0 then
        _logWindowChildren();
        Log.warn("[InitRight] Right/Window 下未找到付费 ImageButton");

        return;
    end;

    if #u5 ~= 4 then
        Log.warn("[InitRight] 付费按钮数量非预期:", #u5, "期望", 4);
        _logWindowChildren();
    end;

    _bindBuyButtons();
    _bindWatchers();
    _refreshAll();
end)();