-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local Copy = UtilsSystem.Copy;
local LocalPlayer = UtilsSystem.LocalPlayer;
local Log = UtilsSystem.Log;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local ShowDetail = UtilsSystem.ShowDetail;
local TranslationHelper = UtilsSystem.TranslationHelper;
local PlayerData = UtilsSystem.PlayerData;
local UIMgr = UtilsSystem.UIMgr;
local AllUI = require(script.AllUI);
local IndexIcon = require(script.IndexIcon);
local IndexView = require(script.IndexView);
local v1 = {};
local UIRoot = AllUI.UIRoot;
local v2 = AllUI["材料"];
local v3 = AllUI["药水"];
local v4 = AllUI["收集进度条"];
local u5 = "Material";
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = false;
local u10 = {};

local function _getTabSnapshot(p11) -- Line: 61
    -- upvalues: u6 (ref)
    return u6[p11];
end;

local function _mergeIndexSaveWithRewardPatch(p12) -- Line: 75
    -- upvalues: u10 (copy), Copy (copy)
    if next(u10) == nil then
        return p12;
    end;

    local v13 = Copy.deepCopy(p12);
    local Reward = v13.Reward;

    if type(Reward) ~= "table" then
        Reward = {};
        v13.Reward = Reward;
    end;

    for i, v in pairs(u10) do
        Reward[i] = v;
    end;

    return v13;
end;

local function _buildSnapshotFromPlayerData() -- Line: 96
    -- upvalues: PlayerData (copy), LocalPlayer (copy), Log (copy), _mergeIndexSaveWithRewardPatch (copy), IndexView (copy), u6 (ref)
    local v14 = PlayerData.GetPlrDataByKey(LocalPlayer, "Index");

    if type(v14) ~= "table" then
        Log.warn("Index: PlayerData.Index 未同步");

        return false;
    end;

    local v15 = _mergeIndexSaveWithRewardPatch(v14);
    local v16 = IndexView.buildAllTabSnapshots(v15);

    if v16 == nil then
        Log.warn("Index: 图鉴快照拼装失败");

        return false;
    end;

    u6 = v16;

    return true;
end;

local function _drawTabRedDots() -- Line: 117
    -- upvalues: u6 (ref), IndexIcon (copy)
    local v17 = u6;

    if v17 == nil then
        IndexIcon.DrawTabRedDots(false, false);

        return;
    end;

    local Material = v17.Material;
    local Potion = v17.Potion;
    local v18;

    if Material == nil then
        v18 = false;
    else
        v18 = Material.progress.canClaim;
    end;

    local v19;

    if Potion == nil then
        v19 = false;
    else
        v19 = Potion.progress.canClaim;
    end;

    IndexIcon.DrawTabRedDots(v18, v19);
end;

local function _showTab(p20) -- Line: 137
    -- upvalues: u5 (ref), ShowDetail (copy), u6 (ref), IndexIcon (copy), u7 (ref), u8 (ref)
    if u5 ~= p20 then
        ShowDetail.HideAllDetail();
    end;

    u5 = p20;
    local v21 = u6[p20];
    IndexIcon.DrawTabs(p20);
    local v22 = u6;

    if v22 == nil then
        IndexIcon.DrawTabRedDots(false, false);
    else
        local Material = v22.Material;
        local Potion = v22.Potion;
        local v23;

        if Material == nil then
            v23 = false;
        else
            v23 = Material.progress.canClaim;
        end;

        local v24;

        if Potion == nil then
            v24 = false;
        else
            v24 = Potion.progress.canClaim;
        end;

        IndexIcon.DrawTabRedDots(v23, v24);
    end;

    IndexIcon.DrawTitleProgress(v21.progress);
    IndexIcon.DrawMilestoneProgress(p20, v21.progress);

    if u7 ~= p20 and true or u8 ~= v21.unlockSet then
        IndexIcon.DrawList(p20, v21.unlockSet);
        u7 = p20;
        u8 = v21.unlockSet;
    end;
end;

local function _refreshCurrentTabProgressOnly(p25) -- Line: 163
    -- upvalues: u5 (ref), u6 (ref), IndexIcon (copy)
    local v26 = u6[u5];
    IndexIcon.DrawTitleProgress(v26.progress);
    IndexIcon.DrawMilestoneProgress(u5, v26.progress, p25);
    local v27 = u6;

    if v27 == nil then
        IndexIcon.DrawTabRedDots(false, false);

        return;
    end;

    local Material = v27.Material;
    local Potion = v27.Potion;
    local v28;

    if Material == nil then
        v28 = false;
    else
        v28 = Material.progress.canClaim;
    end;

    local v29;

    if Potion == nil then
        v29 = false;
    else
        v29 = Potion.progress.canClaim;
    end;

    IndexIcon.DrawTabRedDots(v28, v29);
end;

local function _refreshFromPlayerData(p30) -- Line: 176
    -- upvalues: UIRoot (copy), u6 (ref), _buildSnapshotFromPlayerData (copy), u5 (ref), IndexIcon (copy)
    if not UIRoot.Visible or u6 == nil then
        return;
    end;

    if not _buildSnapshotFromPlayerData() then
        return;
    end;

    local v31 = u6[u5];
    IndexIcon.DrawTitleProgress(v31.progress);
    IndexIcon.DrawMilestoneProgress(u5, v31.progress, p30);
    local v32 = u6;

    if v32 == nil then
        IndexIcon.DrawTabRedDots(false, false);

        return;
    end;

    local Material = v32.Material;
    local Potion = v32.Potion;
    local v33;

    if Material == nil then
        v33 = false;
    else
        v33 = Material.progress.canClaim;
    end;

    local v34;

    if Potion == nil then
        v34 = false;
    else
        v34 = Potion.progress.canClaim;
    end;

    IndexIcon.DrawTabRedDots(v33, v34);
end;

local function _applyClaimRewardState(p35, p36, p37) -- Line: 197
    -- upvalues: u10 (copy), PlayerData (copy), LocalPlayer (copy)
    local u38 = {};

    local function _mergeStateMap(p39) -- Line: 200
        -- upvalues: u38 (copy)
        if type(p39) ~= "table" then
            return;
        end;

        for i, v in pairs(p39) do
            local v40 = tonumber(i);
            local v41 = tonumber(v);

            if v40 ~= nil and v41 ~= nil then
                local v42 = u38[v40];

                if v42 == nil or v42 < v41 then
                    u38[v40] = v41;
                end;
            end;
        end;
    end;

    _mergeStateMap(u10[p35]);
    local v43 = PlayerData.GetPlrDataByKey(LocalPlayer, "Index");

    if type(v43) == "table" and type(v43.Reward) == "table" then
        _mergeStateMap(v43.Reward[p35]);
    end;

    _mergeStateMap(p36);

    if p37 ~= nil then
        u38[p37] = 1;
    end;

    u10[p35] = u38;
end;

local function _handleClaimMilestoneReward() -- Line: 236
    -- upvalues: UIRoot (copy), u6 (ref), u9 (ref), u5 (ref), NetWork (copy), NetMsg (copy), Log (copy), _buildSnapshotFromPlayerData (copy), IndexIcon (copy), _applyClaimRewardState (copy)
    if not UIRoot.Visible or (u6 == nil or u9) then
        return;
    end;

    local progress = u6[u5].progress;

    if not progress.canClaim or progress.targetProgress == nil then
        return;
    end;

    local u44 = u5;
    local targetProgress = progress.targetProgress;
    u9 = true;
    local success, result = pcall(function() -- Line: 250
        -- upvalues: NetWork (ref), NetMsg (ref), u44 (copy), targetProgress (copy)
        return NetWork.InvokeServer(NetMsg.INDEX_CLAIM_REWARD, {
            tag = u44,
            progress = targetProgress
        });
    end);
    u9 = false;

    if not success then
        Log.warn("Index: 领取请求异常", result);

        if UIRoot.Visible then
            if u6 == nil then
                return;
            end;

            if not _buildSnapshotFromPlayerData() then
                return;
            end;

            local v45 = u6[u5];
            IndexIcon.DrawTitleProgress(v45.progress);
            IndexIcon.DrawMilestoneProgress(u5, v45.progress, true);
            local v46 = u6;

            if v46 == nil then
                IndexIcon.DrawTabRedDots(false, false);

                return;
            end;

            local Material = v46.Material;
            local Potion = v46.Potion;
            local v47;

            if Material == nil then
                v47 = false;
            else
                v47 = Material.progress.canClaim;
            end;

            local v48;

            if Potion == nil then
                v48 = false;
            else
                v48 = Potion.progress.canClaim;
            end;

            IndexIcon.DrawTabRedDots(v47, v48);
        end;

        return;
    end;

    if type(result) ~= "table" or type(result.tag) ~= "string" then
        if UIRoot.Visible then
            if u6 == nil then
                return;
            end;

            if not _buildSnapshotFromPlayerData() then
                return;
            end;

            local v49 = u6[u5];
            IndexIcon.DrawTitleProgress(v49.progress);
            IndexIcon.DrawMilestoneProgress(u5, v49.progress, true);
            local v50 = u6;

            if v50 == nil then
                IndexIcon.DrawTabRedDots(false, false);

                return;
            end;

            local Material = v50.Material;
            local Potion = v50.Potion;
            local v51;

            if Material == nil then
                v51 = false;
            else
                v51 = Material.progress.canClaim;
            end;

            local v52;

            if Potion == nil then
                v52 = false;
            else
                v52 = Potion.progress.canClaim;
            end;

            IndexIcon.DrawTabRedDots(v51, v52);
        end;

        return;
    end;

    local v53 = tonumber(result.claimedProgress) or targetProgress;
    _applyClaimRewardState(result.tag, result.rewardState, v53);

    if UIRoot.Visible then
        if u6 == nil then
            return;
        end;

        if not _buildSnapshotFromPlayerData() then
            return;
        end;

        local v54 = u6[u5];
        IndexIcon.DrawTitleProgress(v54.progress);
        IndexIcon.DrawMilestoneProgress(u5, v54.progress, true);
        local v55 = u6;

        if v55 == nil then
            IndexIcon.DrawTabRedDots(false, false);

            return;
        end;

        local Material = v55.Material;
        local Potion = v55.Potion;
        local v56;

        if Material == nil then
            v56 = false;
        else
            v56 = Material.progress.canClaim;
        end;

        local v57;

        if Potion == nil then
            v57 = false;
        else
            v57 = Potion.progress.canClaim;
        end;

        IndexIcon.DrawTabRedDots(v56, v57);
    end;
end;

for _, v in ipairs({
    {
        tab = "Material",
        tabFrame = v2
    },
    {
        tab = "Potion",
        tabFrame = v3
    }
}) do
    TranslationHelper.SetText(v2["材料"], "图鉴材料页签");
    TranslationHelper.SetText(v3["药水"], "图鉴药水页签");
    local v58 = UIMgr.FindButtonInFrame(v.tabFrame);
    AddListen.AddMouseCLick(v58, function() -- Line: 284
        -- upvalues: u5 (ref), v (copy), _showTab (copy)
        if u5 == v.tab then
            return;
        end;

        _showTab(v.tab);
    end, v.tabFrame);
end;

AddListen.AddMouseCLick(UIMgr.FindButtonInFrame(AllUI.Exit), function() -- Line: 292
    -- upvalues: ShowDetail (copy), NetWork (copy), NetMsg (copy)
    ShowDetail.HideAllDetail();
    NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "Index", nil, false, true);
end, AllUI.Exit);
AddListen.AddMouseCLick(UIMgr.FindButtonInFrame(v4), _handleClaimMilestoneReward, v4);
PlayerData.ListenClientSync(function(p59, p60) -- Line: 303
    -- upvalues: UIRoot (copy), u6 (ref), _buildSnapshotFromPlayerData (copy), u5 (ref), IndexIcon (copy)
    if not UIRoot.Visible or u6 == nil then
        return;
    end;

    local v61;

    if p59 == "Index" then
        v61 = true;
    elseif type(p59) == "table" then
        v61 = p59[1] == "Index";
    else
        v61 = false;
    end;

    if not v61 then
        return;
    end;

    if UIRoot.Visible then
        if u6 == nil then
            return;
        end;

        if not _buildSnapshotFromPlayerData() then
            return;
        end;

        local v62 = u6[u5];
        IndexIcon.DrawTitleProgress(v62.progress);
        IndexIcon.DrawMilestoneProgress(u5, v62.progress, false);
        local v63 = u6;

        if v63 == nil then
            IndexIcon.DrawTabRedDots(false, false);

            return;
        end;

        local Material = v63.Material;
        local Potion = v63.Potion;
        local v64;

        if Material == nil then
            v64 = false;
        else
            v64 = Material.progress.canClaim;
        end;

        local v65;

        if Potion == nil then
            v65 = false;
        else
            v65 = Potion.progress.canClaim;
        end;

        IndexIcon.DrawTabRedDots(v64, v65);
    end;
end);

function v1.updateUi(p66, p67) -- Line: 321
    -- upvalues: UIRoot (copy), u6 (ref), _showTab (copy), u5 (ref)
    if not UIRoot.Visible or u6 == nil then
        return;
    end;

    if p67 and p67.Tab then
        _showTab(p67.Tab);

        return;
    end;

    _showTab(u5);
end;

function v1.openUi(p68) -- Line: 337
    -- upvalues: u10 (copy), u5 (ref), _buildSnapshotFromPlayerData (copy), u7 (ref), u8 (ref), UIMgr (copy), UIRoot (copy), _showTab (copy)
    table.clear(u10);
    u5 = "Material";

    if not _buildSnapshotFromPlayerData() then
        return;
    end;

    u7 = nil;
    u8 = nil;
    UIMgr.SetMainUIVisible(false);
    UIRoot.Visible = true;
    UIMgr.UpdateBlurVisible();
    _showTab(u5);
end;

function v1.closeUi(p69) -- Line: 358
    -- upvalues: IndexIcon (copy), u10 (copy), u6 (ref), u7 (ref), u8 (ref), u9 (ref), UIMgr (copy), UIRoot (copy)
    IndexIcon.ClearList();
    IndexIcon.DrawTabRedDots(false, false);
    table.clear(u10);
    u6 = nil;
    u7 = nil;
    u8 = nil;
    u9 = false;
    UIMgr.SetMainUIVisible(true);
    UIRoot.Visible = false;
    UIMgr.UpdateBlurVisible();
end;

return v1;