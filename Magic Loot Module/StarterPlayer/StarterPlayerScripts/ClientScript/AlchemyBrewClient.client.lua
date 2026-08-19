-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local GetData = UtilsSystem.GetData;
local InsMgr = UtilsSystem.InsMgr;
local LocalPlayer = UtilsSystem.LocalPlayer;
local Log = UtilsSystem.Log;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local ResourceUtil = UtilsSystem.ResourceUtil;
local TimeTransfer = UtilsSystem.TimeTransfer;
local TipsModule = UtilsSystem.TipsModule;
local TranslationHelper = UtilsSystem.TranslationHelper;
local VisibleMgr = UtilsSystem.VisibleMgr;
local PotionBrewingGame = require(game.ReplicatedStorage.ClientSideCode.GuiScripts.ModuleScript.PotionBrewingGame);
local Alchemy = GetData.Alchemy;
local ItemType = EnumMgr.ItemType;
local ModelCategory = ResourceUtil.ModelCategory;
local v1 = Alchemy.GetAlchemyRootTagName();
local u2 = false;
local u3 = 0;
local u4 = 0;
local u5 = 0;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = {};

local function _getNowUnix() -- Line: 94
    -- upvalues: Workspace (copy)
    local v16 = Workspace:GetServerTimeNow();

    return math.floor(v16);
end;

local function _getBrewPotionId() -- Line: 103
    -- upvalues: LocalPlayer (copy), Alchemy (copy)
    local v17 = LocalPlayer:FindFirstChild(Alchemy.GetBrewPotionIdValueName());

    return not (v17 and v17:IsA("NumberValue")) and 0 or math.floor(v17.Value);
end;

local function _bindHeadTagUi() -- Line: 116
    -- upvalues: Alchemy (copy), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref)
    local v18 = Alchemy.FindAlchemyHeadTagGui();

    if not v18 then
        u6 = nil;
        u7 = nil;
        u8 = nil;
        u9 = nil;
        u10 = nil;

        return false;
    end;

    local Frame = v18:FindFirstChild("Frame");

    if not (Frame and Frame:IsA("GuiObject")) then
        return false;
    end;

    local Rebirth = Frame:FindFirstChild("Rebirth");
    local v19;

    if Rebirth then
        v19 = Rebirth:FindFirstChild("Rebirth");
    else
        v19 = nil;
    end;

    local v20 = Frame:FindFirstChild("倒计时");
    local v21;

    if v20 then
        v21 = v20:FindFirstChild("Text");
    else
        v21 = nil;
    end;

    u6 = v18;

    if not (Rebirth and Rebirth:IsA("GuiObject")) then
        Rebirth = nil;
    end;

    u7 = Rebirth;

    if not (v19 and v19:IsA("TextLabel")) then
        v19 = nil;
    end;

    u8 = v19;

    if not (v20 and v20:IsA("GuiObject")) then
        v20 = nil;
    end;

    u9 = v20;

    if not (v21 and v21:IsA("TextLabel")) then
        v21 = nil;
    end;

    u10 = v21;
    local v22;

    if u7 == nil or u9 == nil then
        v22 = false;
    else
        v22 = u10 ~= nil;
    end;

    return v22;
end;

local function _setAlchemyOpenUIEnabled(p23) -- Line: 167
    -- upvalues: u15 (copy)
    for _, v in u15 do
        if v.Parent then
            local OpenUIPrompt_OpenUI = v:FindFirstChild("OpenUIPrompt_OpenUI");

            if OpenUIPrompt_OpenUI and OpenUIPrompt_OpenUI:IsA("ProximityPrompt") then
                OpenUIPrompt_OpenUI.Enabled = p23;
            end;
        end;
    end;

    return nil;
end;

local function _unbindPickupPrompt() -- Line: 184
    -- upvalues: u13 (ref), u12 (ref), u14 (ref)
    if u13 then
        u13:Disconnect();
        u13 = nil;
    end;

    if u12 and u12.Parent then
        u12:Destroy();
    end;

    u12 = nil;
    u14 = nil;

    return nil;
end;

local function _destroyLocalFinishModel() -- Line: 202
    -- upvalues: u13 (ref), u12 (ref), u14 (ref), u11 (ref)
    if u13 then
        u13:Disconnect();
        u13 = nil;
    end;

    if u12 and u12.Parent then
        u12:Destroy();
    end;

    u12 = nil;
    u14 = nil;

    if u11 and u11.Parent then
        u11:Destroy();
    end;

    u11 = nil;

    return nil;
end;

local function _ensureLocalFinishModel(p24) -- Line: 217
    -- upvalues: u11 (ref), u13 (ref), u12 (ref), u14 (ref), Alchemy (copy), CfgFind (copy), ItemType (copy), ResourceUtil (copy), ModelCategory (copy), Log (copy), VisibleMgr (copy), LocalPlayer (copy), Workspace (copy)
    if p24 <= 0 then
        return nil;
    end;

    if u11 and u11.Parent then
        if u11:GetAttribute("AlchemyPotionId") == p24 then
            return u11;
        end;

        if u13 then
            u13:Disconnect();
            u13 = nil;
        end;

        if u12 and u12.Parent then
            u12:Destroy();
        end;

        u12 = nil;
        u14 = nil;

        if u11 and u11.Parent then
            u11:Destroy();
        end;

        u11 = nil;
    end;

    local v25 = Alchemy.ResolveFinishSpawnCFrame(p24);

    if not v25 then
        return nil;
    end;

    local v26 = CfgFind.FindCfgByID(p24, ItemType.Potion);

    if not v26 or (type(v26.Model) ~= "string" or v26.Model == "") then
        return nil;
    end;

    local v27 = ResourceUtil.GetModel(ModelCategory.Potion, v26.Model);

    if not v27 then
        Log.warn("[AlchemyBrewClient] 本地成品模型克隆失败", p24, v26.Model);

        return nil;
    end;

    VisibleMgr.AnchoredAll(v27);
    v27.Name = Alchemy.GetFinishModelName(LocalPlayer.UserId);
    v27:SetAttribute("OwnerUserId", LocalPlayer.UserId);
    v27:SetAttribute("AlchemyPotionId", p24);
    v27:PivotTo(v25);
    v27.Parent = Workspace:FindFirstChild("场景") or Workspace;
    local v28 = v27.PrimaryPart or v27:FindFirstChildWhichIsA("BasePart", true);

    if not v28 then
        v27:Destroy();

        return nil;
    end;

    v28:SetAttribute("AlchemyPickupMaxDistance", 10);
    u11 = v27;

    return v27;
end;

local function _bindPickupPrompt(p29) -- Line: 273
    -- upvalues: u14 (ref), u12 (ref), u13 (ref), InsMgr (copy), TranslationHelper (copy), AddListen (copy), LocalPlayer (copy), Alchemy (copy), GetData (copy), ItemType (copy), TipsModule (copy), NetWork (copy), NetMsg (copy), Log (copy)
    if u14 == p29 and (u12 and u12.Parent) then
        return nil;
    end;

    if u13 then
        u13:Disconnect();
        u13 = nil;
    end;

    if u12 and u12.Parent then
        u12:Destroy();
    end;

    u12 = nil;
    u14 = nil;
    local v30 = p29.PrimaryPart or p29:FindFirstChildWhichIsA("BasePart", true);

    if not v30 then
        return nil;
    end;

    local v31 = v30:GetAttribute("AlchemyPickupMaxDistance");
    local v32 = (type(v31) ~= "number" or v31 <= 0) and 10 or v31;
    local v33 = InsMgr.GetIns("AlchemyPickupPrompt", "ProximityPrompt", v30);
    v33.Enabled = true;
    v33.HoldDuration = 0.1;
    v33.Style = Enum.ProximityPromptStyle.Custom;
    v33.MaxActivationDistance = v32;
    v33.RequiresLineOfSight = false;
    TranslationHelper.SetText(v33, "拾取");
    local v36 = AddListen.AddProximityPrompt(v33, function() -- Line: 301
        -- upvalues: LocalPlayer (ref), Alchemy (ref), GetData (ref), ItemType (ref), TipsModule (ref), NetWork (ref), NetMsg (ref), Log (ref)
        task.spawn(function() -- Line: 302
            -- upvalues: LocalPlayer (ref), Alchemy (ref), GetData (ref), ItemType (ref), TipsModule (ref), NetWork (ref), NetMsg (ref), Log (ref)
            local v34 = LocalPlayer:FindFirstChild(Alchemy.GetBrewPotionIdValueName());
            local v35 = not (v34 and v34:IsA("NumberValue")) and 0 or math.floor(v34.Value);

            if v35 > 0 and GetData.IsBagFullForItem(LocalPlayer, v35, ItemType.Potion) then
                TipsModule.ErrorTips(LocalPlayer, "背包容量不足无法获得药水");

                return;
            end;

            local success, result = pcall(function() -- Line: 310
                -- upvalues: NetWork (ref), NetMsg (ref)
                return NetWork.InvokeServer(NetMsg.ALCHEMY_PICKUP_FINISH_POTION);
            end);

            if success then
                if result == true and v35 > 0 then
                    TipsModule.NewShowTipsTemplate(LocalPlayer, {
                        Type = "你已获得药水",
                        ID = v35
                    });
                end;

                return;
            end;

            Log.warn("[AlchemyBrewClient] pickup invoke failed:", result);
        end);
    end);

    if not v36 then
        return nil;
    end;

    u12 = v33;
    u13 = v36;
    u14 = p29;

    return nil;
end;

local function _refreshHeadTagUi() -- Line: 340
    -- upvalues: Alchemy (copy), LocalPlayer (copy), u7 (ref), u8 (ref), TranslationHelper (copy), Workspace (copy), u9 (ref), u10 (ref), TimeTransfer (copy)
    local v37 = Alchemy.CanUseAlchemy(LocalPlayer);

    if u7 then
        u7.Visible = not v37;

        if not v37 and u8 then
            TranslationHelper.SetText_UnTrans(u8, (tostring(Alchemy.GetAlchemyNeedRebirth())));
        end;
    end;

    local v38 = Workspace:GetServerTimeNow();
    local v39 = math.floor(v38);
    local v40 = Alchemy.IsBrewInProgress(LocalPlayer, v39);
    local v41 = v40 or Alchemy.IsBrewReadyForPickup(LocalPlayer, v39);

    if u9 then
        u9.Visible = v41;
    end;

    if v41 and u10 then
        if v40 then
            local v42 = Alchemy.GetBrewRemainingSeconds(LocalPlayer, v39);
            local v43 = { (TimeTransfer.FormatTimeMMSS(v42):gsub(":", "：")) };
            TranslationHelper.SetText(u10, "炼金倒计时", v43);
        else
            TranslationHelper.SetText(u10, "药水炼制完成");
        end;
    end;

    return nil;
end;

local function _refreshBrewPresentation() -- Line: 374
    -- upvalues: _refreshHeadTagUi (copy), Workspace (copy), Alchemy (copy), LocalPlayer (copy), _setAlchemyOpenUIEnabled (copy), _ensureLocalFinishModel (copy), _bindPickupPrompt (copy), u13 (ref), u12 (ref), u14 (ref), u11 (ref)
    _refreshHeadTagUi();
    local v44 = Workspace:GetServerTimeNow();
    local v45 = math.floor(v44);
    local v46 = Alchemy.IsBrewReadyForPickup(LocalPlayer, v45);
    _setAlchemyOpenUIEnabled(not v46);

    if v46 then
        local v47 = LocalPlayer:FindFirstChild(Alchemy.GetBrewPotionIdValueName());
        local v48 = _ensureLocalFinishModel(not (v47 and v47:IsA("NumberValue")) and 0 or math.floor(v47.Value));

        if v48 then
            _bindPickupPrompt(v48);
        end;
    else
        if u13 then
            u13:Disconnect();
            u13 = nil;
        end;

        if u12 and u12.Parent then
            u12:Destroy();
        end;

        u12 = nil;
        u14 = nil;

        if u11 and u11.Parent then
            u11:Destroy();
        end;

        u11 = nil;
    end;

    return nil;
end;

local function _onHeartbeat(p49) -- Line: 435
    -- upvalues: u2 (ref), u3 (ref), _bindHeadTagUi (copy), _refreshBrewPresentation (copy), Workspace (copy), Alchemy (copy), LocalPlayer (copy), u4 (ref), u11 (ref), u5 (ref), _ensureLocalFinishModel (copy), _bindPickupPrompt (copy)
    if not u2 then
        u3 = u3 + p49;

        if u3 >= 1 then
            u3 = 0;
            u2 = _bindHeadTagUi();

            if u2 then
                _refreshBrewPresentation();
            end;
        end;

        return;
    end;

    local v50 = Workspace:GetServerTimeNow();
    local v51 = math.floor(v50);
    local v52 = Alchemy.IsBrewInProgress(LocalPlayer, v51);
    local v53 = Alchemy.IsBrewReadyForPickup(LocalPlayer, v51);

    if v52 or v53 then
        u4 = u4 + p49;

        if u4 >= 0.1 then
            u4 = 0;
            _refreshBrewPresentation();
        end;
    end;

    if v53 and not (u11 and u11.Parent) then
        u5 = u5 + p49;

        if u5 >= 0.5 then
            u5 = 0;
            local v54 = LocalPlayer:FindFirstChild(Alchemy.GetBrewPotionIdValueName());
            local v55 = _ensureLocalFinishModel(not (v54 and v54:IsA("NumberValue")) and 0 or math.floor(v54.Value));

            if v55 then
                _bindPickupPrompt(v55);
            end;
        end;
    end;
end;

(function() -- Line: 151, Name: _collectAlchemyOpenUIParts
    -- upvalues: u15 (copy), CollectionService (copy)
    table.clear(u15);

    for _, v in CollectionService:GetTagged("OpenUI") do
        if v:IsA("BasePart") and v:GetAttribute("UiName") == "Alchemy" then
            table.insert(u15, v);
        end;
    end;

    return nil;
end)();
CollectionService:GetInstanceAddedSignal(v1):Connect(function(p56) -- Line: 473
    -- upvalues: u2 (ref), _bindHeadTagUi (copy), _refreshBrewPresentation (copy)
    if not u2 then
        u2 = _bindHeadTagUi();
    end;

    _refreshBrewPresentation();
end);
CollectionService:GetInstanceAddedSignal("OpenUI"):Connect(function(p57) -- Line: 479
    -- upvalues: u15 (copy), _refreshBrewPresentation (copy)
    if p57:IsA("BasePart") and p57:GetAttribute("UiName") == "Alchemy" then
        table.insert(u15, p57);
        _refreshBrewPresentation();
    end;
end);
CollectionService:GetInstanceRemovedSignal("OpenUI"):Connect(function(p58) -- Line: 485
    -- upvalues: u15 (copy)
    if not p58:IsA("BasePart") then
        return;
    end;

    for i = #u15, 1, -1 do
        if u15[i] == p58 then
            table.remove(u15, i);
        end;
    end;
end);
task.defer(function() -- Line: 398, Name: _bindBrewMirrorListen
    -- upvalues: AddListen (copy), _refreshBrewPresentation (copy), LocalPlayer (copy), Alchemy (copy)
    local function bindValue(p59) -- Line: 399
        -- upvalues: AddListen (ref), _refreshBrewPresentation (ref)
        if p59 and p59:IsA("NumberValue") then
            AddListen.NumValueAdd(p59, function(p60) -- Line: 401
                -- upvalues: _refreshBrewPresentation (ref)
                _refreshBrewPresentation();
            end, false);
        end;
    end;

    local v61 = LocalPlayer:WaitForChild(Alchemy.GetBrewPotionIdValueName());

    if v61 and v61:IsA("NumberValue") then
        AddListen.NumValueAdd(v61, function(p62) -- Line: 401
            -- upvalues: _refreshBrewPresentation (ref)
            _refreshBrewPresentation();
        end, false);
    end;

    local v63 = LocalPlayer:WaitForChild(Alchemy.GetBrewFinishUnixValueName());

    if v63 and v63:IsA("NumberValue") then
        AddListen.NumValueAdd(v63, function(p64) -- Line: 401
            -- upvalues: _refreshBrewPresentation (ref)
            _refreshBrewPresentation();
        end, false);
    end;

    _refreshBrewPresentation();

    return nil;
end);
task.defer(function() -- Line: 418, Name: _bindRebirthWatch
    -- upvalues: GetData (copy), LocalPlayer (copy), EnumMgr (copy), _refreshHeadTagUi (copy)
    task.spawn(function() -- Line: 419
        -- upvalues: GetData (ref), LocalPlayer (ref), EnumMgr (ref), _refreshHeadTagUi (ref)
        GetData.WaitBagNumberValue(LocalPlayer, EnumMgr.ItemID.Rebirth).Changed:Connect(function() -- Line: 421
            -- upvalues: _refreshHeadTagUi (ref)
            _refreshHeadTagUi();
        end);
        _refreshHeadTagUi();
    end);

    return nil;
end);
NetWork.RegisterClientRemoteEvent(NetMsg.ALCHEMY_CRAFT_PRESENT, function(p65) -- Line: 498
    -- upvalues: PotionBrewingGame (copy)
    PotionBrewingGame.StartFromCraftPresent(p65);
end);
RunService.Heartbeat:Connect(_onHeartbeat);