-- Decompiled with Potassium's decompiler.

local v1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SocialService = game:GetService("SocialService");
local AddListen = UtilsSystem.AddListen;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local GetData = UtilsSystem.GetData;
local Log = UtilsSystem.Log;
local MathMgr = UtilsSystem.MathMgr;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local PlayerData = UtilsSystem.PlayerData;
local TranslationHelper = UtilsSystem.TranslationHelper;
local UIMgr = UtilsSystem.UIMgr;
local LocalPlayer = UtilsSystem.LocalPlayer;
local AllUI = require(script.AllUI);
local ItemType = EnumMgr.ItemType;
local Alchemy = GetData.Alchemy;
local UIRoot = AllUI.UIRoot;
local u2 = false;
local u3 = false;
local u4 = nil;

local function _isItemLocked(p5) -- Line: 55
    local lock = p5.lock;

    return lock == 1 and true or lock == true;
end;

local function _isAlchemyProtectedMaterial(p6, p7) -- Line: 67
    -- upvalues: Alchemy (copy)
    local v8 = tonumber(p7.id);

    if v8 then
        return Alchemy.IsMarkedRecipeMaterial(p6, v8);
    end;

    return false;
end;

local function _collectMaterialItems(p9) -- Line: 81
    -- upvalues: PlayerData (copy), ItemType (copy), Alchemy (copy)
    local v10 = PlayerData.GetPlrDataByKey(p9, "Bag");

    if type(v10) ~= "table" then
        return {};
    end;

    local v11 = {};

    for _, v in pairs(v10) do
        if type(v) == "table" and tonumber(v.tp) == ItemType.Material then
            local lock = v.lock;

            if lock ~= 1 and lock ~= true then
                local v12 = tonumber(v.id);
                local v13;

                if v12 then
                    v13 = Alchemy.IsMarkedRecipeMaterial(p9, v12);
                else
                    v13 = false;
                end;

                if not v13 then
                    table.insert(v11, v);
                end;
            end;
        end;
    end;

    return v11;
end;

local function _getMaterialUnitPrice(p14, p15) -- Line: 107
    -- upvalues: CfgFind (copy), ItemType (copy), GetData (copy)
    local v16 = tonumber(p15.id);

    if not v16 then
        return 0;
    end;

    local v17 = CfgFind.FindCfgByID(v16, ItemType.Material);

    return not v17 and 0 or GetData.GetSellPrice(p14, v17);
end;

local function _sortMaterialItemsByUnitPrice(u18, p19) -- Line: 126
    -- upvalues: CfgFind (copy), ItemType (copy), GetData (copy)
    table.sort(p19, function(p20, p21) -- Line: 127
        -- upvalues: u18 (copy), CfgFind (ref), ItemType (ref), GetData (ref)
        local v22 = u18;
        local v23 = tonumber(p20.id);
        local v24;

        if v23 then
            local v25 = CfgFind.FindCfgByID(v23, ItemType.Material);
            v24 = not v25 and 0 or GetData.GetSellPrice(v22, v25);
        else
            v24 = 0;
        end;

        local v26 = u18;
        local v27 = tonumber(p21.id);
        local v28;

        if v27 then
            local v29 = CfgFind.FindCfgByID(v27, ItemType.Material);
            v28 = not v29 and 0 or GetData.GetSellPrice(v26, v29);
        else
            v28 = 0;
        end;

        if v24 == v28 then
            return (tonumber(p20.onlyID) or 0) < (tonumber(p21.onlyID) or 0);
        end;

        return v24 < v28;
    end);
end;

local function _onlyIDSetFromList(p30) -- Line: 143
    local v31 = {};

    for _, v in ipairs(p30) do
        local v32 = tonumber(v);

        if v32 then
            v31[v32] = true;
        end;
    end;

    return v31;
end;

local function _bagStillHasSellWaitItems() -- Line: 159
    -- upvalues: u4 (ref), PlayerData (copy), LocalPlayer (copy), ItemType (copy)
    if not u4 then
        return false;
    end;

    local v33 = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag");

    if type(v33) ~= "table" then
        return false;
    end;

    for i in u4 do
        local v34 = v33[tostring(i)];

        if type(v34) == "table" and tonumber(v34.tp) == ItemType.Material then
            return true;
        end;
    end;

    return false;
end;

local u35 = nil;
local u36 = nil;

local function _scheduleRefresh() -- Line: 186
    -- upvalues: u3 (ref), UIRoot (copy), u35 (ref)
    if u3 then
        return;
    end;

    u3 = true;
    task.defer(function() -- Line: 191
        -- upvalues: u3 (ref), UIRoot (ref), u35 (ref)
        u3 = false;

        if UIRoot.Visible then
            u35();
        end;
    end);
end;

local function _classifyMaterialBagSync(p37, p38) -- Line: 207
    -- upvalues: ItemType (copy), PlayerData (copy), LocalPlayer (copy), Alchemy (copy), AllUI (copy), u4 (ref)
    if type(p37) ~= "table" or (p37[1] ~= "Bag" or not p37[2]) then
        return false, nil;
    end;

    local v39 = tonumber(p37[2]);

    if not v39 then
        return false, nil;
    end;

    if #p37 ~= 2 then
        if p37[3] == "count" or p37[3] == "lock" then
            local v40 = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag");
            local v41;

            if type(v40) == "table" then
                v41 = v40[tostring(v39)];
            else
                v41 = false;
            end;

            if type(v41) == "table" and tonumber(v41.tp) == ItemType.Material then
                return true, "full";
            end;
        end;

        return false, nil;
    end;

    if type(p38) == "table" then
        if tonumber(p38.tp) == ItemType.Material then
            local lock = p38.lock;

            if lock ~= 1 and lock ~= true then
                local v42 = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag");
                local v43;

                if type(v42) == "table" then
                    v43 = v42[tostring(v39)];
                else
                    v43 = false;
                end;

                if type(v43) == "table" then
                    local v44 = LocalPlayer;
                    local v45 = tonumber(v43.id);
                    local v46;

                    if v45 then
                        v46 = Alchemy.IsMarkedRecipeMaterial(v44, v45);
                    else
                        v46 = false;
                    end;

                    if not v46 then
                        return true, "full";
                    end;
                end;
            end;
        end;

        return false, nil;
    end;

    if p38 == nil then
        local BagScrollFrame = AllUI.BagScrollFrame;

        if BagScrollFrame and BagScrollFrame:FindFirstChild("Material_" .. tostring(v39)) then
            return true, "remove";
        end;

        if u4 and u4[v39] then
            return true, "remove";
        end;
    end;

    return false, nil;
end;

local function _invokeSell(u47) -- Line: 255
    -- upvalues: u2 (ref), NetWork (copy), NetMsg (copy), Log (copy)
    if u2 then
        return false;
    end;

    u2 = true;
    local success, result = pcall(function() -- Line: 260
        -- upvalues: NetWork (ref), NetMsg (ref), u47 (copy)
        return NetWork.InvokeServer(NetMsg.SELL_MATERIAL, {
            onlyIDList = u47
        });
    end);
    u2 = false;

    if success then
        return result == true;
    end;

    Log.warn("[SellUI] InvokeServer error:", result);

    return false;
end;

local function _refreshAllPrice(p48) -- Line: 281
    -- upvalues: AllUI (copy), CfgFind (copy), ItemType (copy), GetData (copy), LocalPlayer (copy), TranslationHelper (copy), MathMgr (copy)
    local PriceNum = AllUI.AllPrice:FindFirstChild("PriceNum");

    if not (PriceNum and PriceNum:IsA("TextLabel")) then
        return;
    end;

    local v49 = 0;

    for _, v in ipairs(p48) do
        local v50 = CfgFind.FindCfgByID(v.id, ItemType.Material);

        if v50 then
            v49 = v49 + GetData.GetSellPrice(LocalPlayer, v50);
        end;
    end;

    TranslationHelper.SetText_UnTrans(PriceNum, "+" .. MathMgr.getNumStr(v49));
end;

local function _bindMaterialRow(p51, p52) -- Line: 304
    -- upvalues: CfgFind (copy), ItemType (copy), UIMgr (copy), TranslationHelper (copy), GetData (copy), LocalPlayer (copy), MathMgr (copy), AddListen (copy), u2 (ref), NetWork (copy), NetMsg (copy), Log (copy), u36 (ref)
    local v53 = CfgFind.FindCfgByID(p52.id, ItemType.Material);

    if not v53 then
        p51.Visible = false;

        return;
    end;

    local u54 = tonumber(p52.onlyID);

    if not u54 then
        p51.Visible = false;

        return;
    end;

    p51:SetAttribute("OnlyID", u54);
    local ItemTemp = p51:FindFirstChild("ItemTemp");
    local v55 = ItemTemp and ItemTemp:FindFirstChild("Icon");

    if v55 then
        v55.Visible = true;
        UIMgr.SetImage(v55, v53.Icon);
    end;

    local detailFrame = p51:FindFirstChild("detailFrame");

    if detailFrame then
        local Name = detailFrame:FindFirstChild("Name");

        if Name then
            Name = Name:FindFirstChild("NameText");
        end;

        if Name then
            TranslationHelper.SetText(Name, v53.ZhName or "");
        end;

        local Price = detailFrame:FindFirstChild("Price");

        if Price then
            Price = Price:FindFirstChild("PriceNum");
        end;

        if Price then
            local v56 = GetData.GetSellPrice(LocalPlayer, v53);
            TranslationHelper.SetText_UnTrans(Price, "+" .. MathMgr.getNumStr(v56));
        end;

        local SellBtn = detailFrame:FindFirstChild("SellBtn");
        local v57;

        if SellBtn then
            v57 = UIMgr.FindButtonInFrame(SellBtn);
        else
            v57 = SellBtn;
        end;

        if v57 then
            AddListen.AddMouseCLick(v57, function() -- Line: 345
                -- upvalues: u54 (copy), u2 (ref), NetWork (ref), NetMsg (ref), Log (ref), u36 (ref)
                local u58 = { u54 };
                local v59;

                if u2 then
                    v59 = false;
                else
                    u2 = true;
                    local success, result = pcall(function() -- Line: 260
                        -- upvalues: NetWork (ref), NetMsg (ref), u58 (copy)
                        return NetWork.InvokeServer(NetMsg.SELL_MATERIAL, {
                            onlyIDList = u58
                        });
                    end);
                    u2 = false;

                    if success then
                        v59 = result == true;
                    else
                        Log.warn("[SellUI] InvokeServer error:", result);
                        v59 = false;
                    end;
                end;

                if v59 then
                    u36({ u54 });
                end;
            end, SellBtn);
        end;
    end;
end;

u35 = function() -- Line: 359, Name: _refresh
    -- upvalues: AllUI (copy), UIMgr (copy), _collectMaterialItems (copy), LocalPlayer (copy), CfgFind (copy), ItemType (copy), GetData (copy), _bindMaterialRow (copy), _refreshAllPrice (copy)
    local BagScrollFrame = AllUI.BagScrollFrame;
    local MaterialTemp = AllUI.MaterialTemp;

    if not (BagScrollFrame and MaterialTemp) then
        return;
    end;

    UIMgr.ClearScrollItems(BagScrollFrame, {
        keepInstances = { MaterialTemp }
    });
    MaterialTemp.Visible = false;
    local v60 = _collectMaterialItems(LocalPlayer);
    local u61 = LocalPlayer;
    table.sort(v60, function(p62, p63) -- Line: 127
        -- upvalues: u61 (copy), CfgFind (ref), ItemType (ref), GetData (ref)
        local v64 = u61;
        local v65 = tonumber(p62.id);
        local v66;

        if v65 then
            local v67 = CfgFind.FindCfgByID(v65, ItemType.Material);
            v66 = not v67 and 0 or GetData.GetSellPrice(v64, v67);
        else
            v66 = 0;
        end;

        local v68 = u61;
        local v69 = tonumber(p63.id);
        local v70;

        if v69 then
            local v71 = CfgFind.FindCfgByID(v69, ItemType.Material);
            v70 = not v71 and 0 or GetData.GetSellPrice(v68, v71);
        else
            v70 = 0;
        end;

        if v66 == v70 then
            return (tonumber(p62.onlyID) or 0) < (tonumber(p63.onlyID) or 0);
        end;

        return v66 < v70;
    end);

    for i, v in ipairs(v60) do
        local v72 = MaterialTemp:Clone();
        v72.Name = "Material_" .. tostring(v.onlyID);
        v72.LayoutOrder = i;
        v72.Visible = true;
        v72.Parent = BagScrollFrame;
        _bindMaterialRow(v72, v);
    end;

    UIMgr.SetUIlistSize(BagScrollFrame);
    _refreshAllPrice(v60);
end;

local function _removeMaterialRows(p73) -- Line: 391
    -- upvalues: AllUI (copy), UIMgr (copy), _refreshAllPrice (copy), _collectMaterialItems (copy), LocalPlayer (copy)
    local BagScrollFrame = AllUI.BagScrollFrame;

    if not (BagScrollFrame and p73) then
        return;
    end;

    local v74 = false;

    for i in p73 do
        local v75 = BagScrollFrame:FindFirstChild("Material_" .. tostring(i));

        if v75 then
            v75:Destroy();
            v74 = true;
        end;
    end;

    if v74 then
        UIMgr.SetUIlistSize(BagScrollFrame);
    end;

    _refreshAllPrice((_collectMaterialItems(LocalPlayer)));
end;

local function _refreshPricesOnly() -- Line: 415
    -- upvalues: AllUI (copy), _collectMaterialItems (copy), LocalPlayer (copy), CfgFind (copy), ItemType (copy), GetData (copy), TranslationHelper (copy), MathMgr (copy), _refreshAllPrice (copy)
    local BagScrollFrame = AllUI.BagScrollFrame;

    if not BagScrollFrame then
        return;
    end;

    local v76 = _collectMaterialItems(LocalPlayer);
    local v77 = {};

    for _, v in ipairs(v76) do
        local v78 = tonumber(v.onlyID);

        if v78 then
            v77[v78] = v;
        end;
    end;

    for _, child in ipairs(BagScrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            local v79 = child:GetAttribute("OnlyID");
            local v80 = tonumber(v79);

            if v80 then
                v80 = v77[v80];
            end;

            if v80 then
                local detailFrame = child:FindFirstChild("detailFrame");

                if detailFrame then
                    detailFrame = detailFrame:FindFirstChild("Price");
                end;

                if detailFrame then
                    detailFrame = detailFrame:FindFirstChild("PriceNum");
                end;

                if detailFrame then
                    local v81 = CfgFind.FindCfgByID(v80.id, ItemType.Material);

                    if v81 then
                        local v82 = GetData.GetSellPrice(LocalPlayer, v81);
                        TranslationHelper.SetText_UnTrans(detailFrame, "+" .. MathMgr.getNumStr(v82));
                    end;
                end;
            end;
        end;
    end;

    _refreshAllPrice(v76);
end;

u36 = function(p83) -- Line: 456, Name: _onSellCommitted
    -- upvalues: u4 (ref), _onlyIDSetFromList (copy), _bagStillHasSellWaitItems (copy), _removeMaterialRows (ref)
    u4 = _onlyIDSetFromList(p83);

    if not _bagStillHasSellWaitItems() then
        local v84 = u4;
        u4 = nil;

        if v84 then
            _removeMaterialRows(v84);
        end;
    end;
end;

PlayerData.ListenClientSync(function(p85, p86) -- Line: 467
    -- upvalues: UIRoot (copy), u4 (ref), _bagStillHasSellWaitItems (copy), _removeMaterialRows (ref), _classifyMaterialBagSync (copy), u3 (ref), u35 (ref)
    if not UIRoot.Visible then
        return;
    end;

    local v87;

    if type(p85) == "table" then
        v87 = p85[1];
    else
        v87 = p85;
    end;

    if v87 ~= "Bag" then
        return;
    end;

    if u4 then
        if _bagStillHasSellWaitItems() then
            return;
        end;

        local u88 = u4;
        u4 = nil;
        task.defer(function() -- Line: 482
            -- upvalues: UIRoot (ref), u88 (copy), _removeMaterialRows (ref)
            if UIRoot.Visible and u88 then
                _removeMaterialRows(u88);
            end;
        end);

        return;
    end;

    local v89, v90 = _classifyMaterialBagSync(p85, p86);

    if not v89 then
        return;
    end;

    if v90 == "remove" then
        local u91;

        if type(p85) == "table" then
            u91 = tonumber(p85[2]);
        else
            u91 = nil;
        end;

        if u91 then
            task.defer(function() -- Line: 497
                -- upvalues: UIRoot (ref), _removeMaterialRows (ref), u91 (copy)
                if UIRoot.Visible then
                    _removeMaterialRows({
                        [u91] = true
                    });
                end;
            end);
        end;

        return;
    end;

    if u3 then
        return;
    end;

    u3 = true;
    task.defer(function() -- Line: 191
        -- upvalues: u3 (ref), UIRoot (ref), u35 (ref)
        u3 = false;

        if UIRoot.Visible then
            u35();
        end;
    end);
end);
task.spawn(function() -- Line: 508
    -- upvalues: LocalPlayer (copy), UIRoot (copy), _refreshPricesOnly (ref)
    LocalPlayer:WaitForChild("RebirthBonus", (1 / 0)):WaitForChild("GoldAdd", (1 / 0)).Changed:Connect(function() -- Line: 511
        -- upvalues: UIRoot (ref), _refreshPricesOnly (ref)
        if UIRoot.Visible then
            task.defer(function() -- Line: 513
                -- upvalues: UIRoot (ref), _refreshPricesOnly (ref)
                if UIRoot.Visible then
                    _refreshPricesOnly();
                end;
            end);
        end;
    end);
end);
task.defer(function() -- Line: 522
    -- upvalues: LocalPlayer (copy), Alchemy (copy), AddListen (copy), UIRoot (copy), u3 (ref), u35 (ref)
    local v92 = LocalPlayer:WaitForChild(Alchemy.GetMarkFolderName(), 10);

    if not (v92 and v92:IsA("Folder")) then
        return;
    end;

    local v93 = v92:WaitForChild(Alchemy.GetMarkRecipeIdValueName(), 5);

    if v93 and v93:IsA("NumberValue") then
        AddListen.NumValueAdd(v93, function(p94) -- Line: 529
            -- upvalues: UIRoot (ref), u3 (ref), u35 (ref)
            if UIRoot.Visible then
                if u3 then
                    return;
                end;

                u3 = true;
                task.defer(function() -- Line: 191
                    -- upvalues: u3 (ref), UIRoot (ref), u35 (ref)
                    u3 = false;

                    if UIRoot.Visible then
                        u35();
                    end;
                end);
            end;
        end, false);
    end;
end);
local v95 = UIMgr.FindButtonInFrame(AllUI.Exit);

if v95 then
    AddListen.AddMouseCLick(v95, function() -- Line: 539
        -- upvalues: NetWork (copy), NetMsg (copy)
        NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "Sell", nil, false, true);
    end, AllUI.Exit);
end;

local v96 = UIMgr.FindButtonInFrame(AllUI.SellAll);

if v96 then
    AddListen.AddMouseCLick(v96, function() -- Line: 546
        -- upvalues: _collectMaterialItems (copy), LocalPlayer (copy), u2 (ref), NetWork (copy), NetMsg (copy), Log (copy), u36 (ref)
        local u97 = {};

        for _, v in ipairs((_collectMaterialItems(LocalPlayer))) do
            local v98 = tonumber(v.onlyID);

            if v98 then
                table.insert(u97, v98);
            end;
        end;

        if #u97 > 0 then
            local v99;

            if u2 then
                v99 = false;
            else
                u2 = true;
                local success, result = pcall(function() -- Line: 260
                    -- upvalues: NetWork (ref), NetMsg (ref), u97 (copy)
                    return NetWork.InvokeServer(NetMsg.SELL_MATERIAL, {
                        onlyIDList = u97
                    });
                end);
                u2 = false;

                if success then
                    v99 = result == true;
                else
                    Log.warn("[SellUI] InvokeServer error:", result);
                    v99 = false;
                end;
            end;

            if v99 then
                u36(u97);
            end;
        end;
    end, AllUI.SellAll);
end;

function v1.updateUi(p100, p101) -- Line: 560
    -- upvalues: u35 (ref)
    u35();
end;

function v1.openUi(p102) -- Line: 564
    -- upvalues: UIMgr (copy), UIRoot (copy), u4 (ref), u3 (ref), u35 (ref)
    UIMgr.SetMainUIVisible(false);
    UIRoot.Visible = true;
    UIMgr.UpdateBlurVisible();
    u4 = nil;
    u3 = false;
    u35();
end;

local u103 = false;

function v1.closeUi(p104) -- Line: 575
    -- upvalues: UIMgr (copy), AllUI (copy), u4 (ref), u3 (ref), UIRoot (copy), LocalPlayer (copy), GetData (copy), EnumMgr (copy), u103 (ref), SocialService (copy)
    UIMgr.ClearScrollItems(AllUI.BagScrollFrame, {
        keepInstances = { AllUI.MaterialTemp }
    });
    u4 = nil;
    u3 = false;
    UIMgr.SetMainUIVisible(true);
    UIRoot.Visible = false;
    UIMgr.UpdateBlurVisible();
    local IsNewPlayer = LocalPlayer:FindFirstChild("IsNewPlayer");

    if IsNewPlayer and (IsNewPlayer.Value == true and (GetData.GetItemCountByID(LocalPlayer, EnumMgr.ItemID.Coin) >= 5000 and u103 == false)) then
        u103 = true;
        local ExperienceInviteOptions = Instance.new("ExperienceInviteOptions");
        ExperienceInviteOptions.PromptMessage = "Invite Friend";
        ExperienceInviteOptions.LaunchData = tostring(LocalPlayer.UserId);
        pcall(SocialService.PromptGameInvite, SocialService, LocalPlayer, ExperienceInviteOptions);
    end;
end;

return v1;