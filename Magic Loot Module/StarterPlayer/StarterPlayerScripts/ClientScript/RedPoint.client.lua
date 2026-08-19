-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local GetData = UtilsSystem.GetData;
local LocalPlayer = UtilsSystem.LocalPlayer;
local PlayerData = UtilsSystem.PlayerData;
local UIanima = UtilsSystem.UIanima;
local IndexView = require(game.ReplicatedStorage.ClientSideCode.GuiScripts.ModuleScript.Index.IndexView);
local EventTaskTab = require(game.ReplicatedStorage.ClientSideCode.GuiScripts.ModuleScript.Event.EventTaskTab);
local u1 = GetData.WaitBagNumberValue(LocalPlayer, EnumMgr.ItemID.Level);
local u2 = GetData.WaitBagNumberValue(LocalPlayer, EnumMgr.ItemID.Rebirth);
local u3 = GetData.WaitRedPointValue(LocalPlayer, "在线奖励红点");
local u4 = GetData.WaitBagNumberValue(LocalPlayer, EnumMgr.ItemID.EventTicket);
local u5 = {};
local u6 = {};
local u7 = {};

local function _isIndexDataChange(p8) -- Line: 72
    return (p8 == nil or p8 == "Index") and true or type(p8) == "table" and p8[1] == "Index";
end;

local function _isEventRecordChange(p9) -- Line: 88
    return (p9 == nil or p9 == "Record") and true or type(p9) == "table" and p9[1] == "Record";
end;

local function _isEventTaskDataChange(p10) -- Line: 154
    return (p10 == nil or p10 == "Event") and true or type(p10) == "table" and p10[1] == "Event";
end;

local u18 = {
    ["重生"] = function() -- Line: 103, Name: _canShowRebirthRedPoint
        -- upvalues: u2 (copy), u1 (copy), CfgFind (copy)
        local v11 = math.floor(u2.Value);
        local v12 = math.floor(u1.Value);
        local v13 = CfgFind.GetCfgByNameAndID("rebirthConf", v11 + 1);

        if not v13 then
            return false;
        end;

        local v14 = tonumber(v13.LvNeed) or 0;

        return math.floor(v14) <= v12;
    end,

    ["图鉴"] = function() -- Line: 120, Name: _canShowIndexRedPoint
        -- upvalues: PlayerData (copy), LocalPlayer (copy), IndexView (copy)
        local v15 = PlayerData.GetPlrDataByKey(LocalPlayer, "Index");

        if type(v15) ~= "table" then
            return false;
        end;

        local v16 = IndexView.buildAllTabSnapshots(v15);

        if not v16 then
            return false;
        end;

        for _, v in v16 do
            if v.progress.canClaim then
                return true;
            end;
        end;

        return false;
    end,

    ["在线奖励"] = function() -- Line: 144, Name: _canShowOnlineAwardRedPoint
        -- upvalues: u3 (copy)
        return u3.Value > 0;
    end,

    ["活动"] = function() -- Line: 169, Name: _canShowEventRedPoint
        -- upvalues: u4 (copy), PlayerData (copy), LocalPlayer (copy), EventTaskTab (copy)
        if math.floor(u4.Value) >= 1 then
            return true;
        end;

        local v17 = PlayerData.GetPlrDataByKey(LocalPlayer, { "Record", "活动界面已打开" });

        return (tonumber(v17) or 0) <= 0 and true or EventTaskTab.HasClaimable();
    end
};

local function _applyGuiVisible(p19, p20) -- Line: 187
    -- upvalues: UIanima (copy)
    local Visible = p19.Visible;
    p19.Visible = p20;

    if p20 and not Visible then
        UIanima.RedPointAnim(p19);

        return;
    end;

    if not p20 and Visible then
        UIanima.StopRedPointAnim(p19);
    end;
end;

local function _applyVisible(p21, p22) -- Line: 204
    -- upvalues: UIanima (copy)
    if not p21:IsA("GuiObject") then
        for _, descendant in p21:GetDescendants() do
            if descendant:IsA("GuiObject") then
                local Visible = descendant.Visible;
                descendant.Visible = p22;

                if p22 and not Visible then
                    UIanima.RedPointAnim(descendant);
                elseif not p22 and Visible then
                    UIanima.StopRedPointAnim(descendant);
                end;
            end;
        end;

        return;
    end;

    local Visible = p21.Visible;
    p21.Visible = p22;

    if p22 and not Visible then
        UIanima.RedPointAnim(p21);

        return;
    end;

    if not p22 and Visible then
        UIanima.StopRedPointAnim(p21);
    end;
end;

local function _readRedPointKey(p23) -- Line: 223
    local v24 = p23:GetAttribute("RedPoint");

    if type(v24) == "string" and v24 ~= "" then
        return v24;
    end;

    return nil;
end;

local function _untrackInstance(p25) -- Line: 237
    -- upvalues: u5 (copy), u6 (copy), u7 (copy), _applyVisible (copy)
    local v26 = u5[p25];
    local v27 = v26 and u6[v26];

    if v27 then
        v27[p25] = nil;
    end;

    u5[p25] = nil;
    local v28 = u7[p25];

    if v28 then
        for _, v in v28 do
            v:Disconnect();
        end;

        u7[p25] = nil;
    end;

    _applyVisible(p25, false);
end;

local function _refreshKey(p29) -- Line: 264
    -- upvalues: u18 (copy), u6 (copy), _applyVisible (copy), _untrackInstance (copy)
    local v30 = u18[p29];
    local v31;

    if v30 then
        v31 = v30();
    else
        v31 = false;
    end;

    local v32 = u6[p29];

    if not v32 then
        return;
    end;

    for i in v32 do
        if i.Parent then
            _applyVisible(i, v31);
        else
            _untrackInstance(i);
        end;
    end;
end;

local function _refreshAll() -- Line: 286
    -- upvalues: u6 (copy), _refreshKey (copy)
    for i in u6 do
        _refreshKey(i);
    end;
end;

local function _trackInstance(u33) -- Line: 298
    -- upvalues: _untrackInstance (copy), _applyVisible (copy), u18 (copy), u6 (copy), u5 (copy), _trackInstance (copy), _refreshKey (copy), u7 (copy)
    if not u33:IsA("Instance") then
        return;
    end;

    _untrackInstance(u33);
    local v34 = u33:GetAttribute("RedPoint");

    if type(v34) ~= "string" or v34 == "" then
        v34 = nil;
    end;

    if not v34 then
        _applyVisible(u33, false);

        return;
    end;

    if not u18[v34] then
        _applyVisible(u33, false);

        return;
    end;

    local v35 = u6[v34];

    if not v35 then
        v35 = {};
        u6[v34] = v35;
    end;

    v35[u33] = true;
    u5[u33] = v34;
    local v36 = {};
    local v37 = u33:GetAttributeChangedSignal("RedPoint");
    table.insert(v36, v37:Connect(function() -- Line: 327
        -- upvalues: _trackInstance (ref), u33 (copy), u5 (ref), _refreshKey (ref)
        _trackInstance(u33);
        local v38 = u5[u33];

        if v38 then
            _refreshKey(v38);
        end;
    end));
    table.insert(v36, u33.Destroying:Connect(function() -- Line: 337
        -- upvalues: _untrackInstance (ref), u33 (copy)
        _untrackInstance(u33);
    end));
    u7[u33] = v36;
    _refreshKey(v34);
end;

local function _ensureLeftEventRedPointTagged() -- Line: 349
    -- upvalues: LocalPlayer (copy), CollectionService (copy)
    local v39 = LocalPlayer:WaitForChild("PlayerGui", (1 / 0)):WaitForChild("ScreenGui", (1 / 0)):WaitForChild("Main", (1 / 0)):WaitForChild("Left", (1 / 0)):WaitForChild("Event", (1 / 0)):FindFirstChild("红点");

    if not v39 then
        return;
    end;

    v39:SetAttribute("RedPoint", "活动");

    if not CollectionService:HasTag(v39, "RedPoint") then
        CollectionService:AddTag(v39, "RedPoint");
    end;
end;

for _, v in CollectionService:GetTagged("RedPoint") do
    _trackInstance(v);
end;

CollectionService:GetInstanceAddedSignal("RedPoint"):Connect(_trackInstance);
CollectionService:GetInstanceRemovedSignal("RedPoint"):Connect(_untrackInstance);
AddListen.NumValueAdd(u1, function() -- Line: 372
    -- upvalues: _refreshKey (copy)
    _refreshKey("重生");
end, true);
AddListen.NumValueAdd(u2, function() -- Line: 376
    -- upvalues: _refreshKey (copy)
    _refreshKey("重生");
end, true);
PlayerData.ListenClientSync(function(p40, p41) -- Line: 380
    -- upvalues: _refreshKey (copy)
    if (p40 == nil or p40 == "Index") and true or type(p40) == "table" and p40[1] == "Index" then
        _refreshKey("图鉴");
    end;

    if (p40 == nil or p40 == "Record") and true or type(p40) == "table" and p40[1] == "Record" then
        _refreshKey("活动");
    end;

    if (p40 == nil or p40 == "Event") and true or type(p40) == "table" and p40[1] == "Event" then
        _refreshKey("活动");
    end;
end);
AddListen.NumValueAdd(u3, function() -- Line: 392
    -- upvalues: _refreshKey (copy)
    _refreshKey("在线奖励");
end, true);
AddListen.NumValueAdd(u4, function() -- Line: 396
    -- upvalues: _refreshKey (copy)
    _refreshKey("活动");
end, true);
task.spawn(function() -- Line: 400
    -- upvalues: _ensureLeftEventRedPointTagged (copy), u6 (copy), _refreshKey (copy)
    _ensureLeftEventRedPointTagged();

    for i in u6 do
        _refreshKey(i);
    end;
end);