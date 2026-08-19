-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
require(ReplicatedStorage.Library.Types.AssetItem);
local AssetItemUtil = require(ReplicatedStorage.Library.Util.AssetItemUtil);
local AssetOddsDisplay = require(ReplicatedStorage.Library.Util.AssetOddsDisplay);
local Personalities = require(ReplicatedStorage.Directory.Assets.Personalities);
local AreaIndexProgressComponent = require(script.AreaIndexProgressComponent);
local Areas = require(ReplicatedStorage.Directory.Areas);
local Assets = require(ReplicatedStorage.Directory.Assets);
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local ClaimRewardPanel = require(script.ClaimRewardPanel);
local Simple = require(ReplicatedStorage.Library.Modules.FormatNumber.Simple);
local GetOrCreateUIScale = require(ReplicatedStorage.Library.Functions.GetOrCreateUIScale);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local GradientSwap = require(ReplicatedStorage.Library.Functions.GradientSwap);
require(script.Types.Interface);
local ItemDisplay = require(ReplicatedStorage.Library.Modules.ItemDisplay);
local LimitedEgg = require(ReplicatedStorage.Directory.LimitedEgg);
local Lock = require(ReplicatedStorage.Library.Functions.Lock);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Save = require(ReplicatedStorage.Library.Client.Save);
local TabController = require(ReplicatedStorage.Library.Client.TabController);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local AutoGridLayout = require(ReplicatedStorage.Library.Client.AutoGridLayout);
local UpdateTextAndShadow = require(ReplicatedStorage.Library.Functions.UpdateTextAndShadow);
local u1 = {};
u1.__index = u1;
u1.__class = "IndexController";
local Index = Network.NET_MAP.Index;
local u2 = { "Base" };
local u3 = Color3.fromRGB(255, 55, 55);
local u4 = Color3.fromRGB(255, 255, 255);
local u5 = Color3.fromRGB(0, 0, 0);
local u6 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u7 = TweenInfo.new(0.7, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, -1, true);
local u8 = UDim2.fromOffset(0, 0);
local u9 = Log.new();
local u10 = Lock();
local Index2 = GUI.Index().Index;
local Button = GUI.SideButtonTools().Index.Button;
local NotificationBadge = Button.NotificationBadge;
local TextLabel = NotificationBadge.Frame.BadgeFrame.TextLabelFrame.TextLabel;
local IndexPage = Index2.Content.IndexPage;
local IndexEntries = IndexPage.IndexListFrame.IndexEntries;
local Template = IndexEntries.Template;
local LimitedEggSeparation = IndexEntries.LimitedEggSeparation;
local IndexInfoFrame = IndexPage.IndexInfoFrame;
local ImageLabel = IndexInfoFrame.Icon.ImageLabel;
local MutationIcon = IndexInfoFrame.Icon.MutationIcon;
local TextLabel2 = IndexInfoFrame.DisplayName.TextLabel;
local TextLabel3 = IndexInfoFrame.Rarity.TextLabel;
local TextLabel4 = IndexInfoFrame.RarityOdds.TextLabel;
local UIGradient = TextLabel4.UIGradient;
local TextLabel5 = IndexInfoFrame.EarningRate.TextLabel;
local IndexRewardsFrame = IndexPage.IndexRewardsFrame;
local ClaimButton = IndexRewardsFrame.ClaimButton;
local ClaimAllButton = IndexPage.ClaimAllButton;
local UIGradient2 = ClaimAllButton.TextButton.UIGradient;
local ProgressBar = IndexPage.ProgressBar;
local TextLabel6 = ProgressBar.ProgressText.TextLabel;
local Fill = ProgressBar.Progress.Fill;
local RarityGlow = IndexInfoFrame.Frame.RarityGlow;
local UIStroke = RarityGlow.UIStroke;

function u1._build() -- Line: 109
    -- upvalues: u1 (copy), Trove (copy)
    local v11 = setmetatable({}, u1);
    v11._trove = Trove.new();
    v11._openTrove = nil;
    v11._sections = {};
    v11._sectionsByPage = {};
    v11._currentPage = "Base";
    v11._selectedCategory = nil;
    v11._isOpen = false;
    v11._indexNotificationTween = nil;
    v11:_buildEntries();
    v11:_init();

    return v11;
end;

function u1._buildEntries(p12) -- Line: 130
    -- upvalues: u2 (copy), Areas (copy), Assets (copy), Personalities (copy), LimitedEgg (copy)
    for _, v in ipairs(u2) do
        p12._sectionsByPage[v] = {};
    end;

    for i, v in Areas.Directory do
        for _, v2 in ipairs(u2) do
            local v13 = {};

            for _, v3 in v.DropTable do
                local v14 = v3[1];
                local v15 = Assets.Directory[v14];

                if v3[2] > 0 and v15.DontRoll ~= true then
                    table.insert(v13, {
                        Category = v14,
                        Config = v15,
                        ItemData = {
                            Scale = 1,
                            HasBeenFirstPlaced = true,
                            Category = v14,
                            Mutations = {},
                            Personality = Personalities.Personalities.Normal
                        }
                    });
                end;
            end;

            table.sort(v13, function(p16, p17) -- Line: 162
                local RarityNumber = p16.Config.Rarity.RarityNumber;
                local RarityNumber2 = p17.Config.Rarity.RarityNumber;

                if RarityNumber ~= RarityNumber2 then
                    return RarityNumber < RarityNumber2;
                end;

                if p16.Config.DropWeight == p17.Config.DropWeight then
                    return p16.Category < p17.Category;
                end;

                return p16.Config.DropWeight > p17.Config.DropWeight;
            end);

            if #v13 > 0 then
                table.insert(p12._sectionsByPage[v2], {
                    RewardKind = "AreaBat",
                    SectionId = i,
                    DisplayName = v.DisplayName,
                    Icon = v.Icon,
                    HeaderGradient = v.Rarity.Gradient,
                    SortOrder = v.Rarity.RarityNumber,
                    RewardGearId = v.IndexBatGearId,
                    Entries = v13
                });
            end;
        end;
    end;

    for _, v in ipairs(u2) do
        table.sort(p12._sectionsByPage[v], function(p18, p19) -- Line: 194
            if p18.SortOrder == p19.SortOrder then
                return p18.SectionId < p19.SectionId;
            end;

            return p18.SortOrder < p19.SortOrder;
        end);
    end;

    for _, v in ipairs(u2) do
        local v20 = {};

        for _, v2 in ipairs(LimitedEgg.Entries) do
            local AssetId = v2.AssetId;
            table.insert(v20, {
                Category = AssetId,
                Config = Assets.Directory[AssetId],
                ItemData = {
                    Scale = 1,
                    HasBeenFirstPlaced = true,
                    Category = AssetId,
                    Mutations = {},
                    Personality = Personalities.Personalities.Normal
                }
            });
        end;

        table.sort(v20, function(p21, p22) -- Line: 224
            if p21.Config.Rarity.RarityNumber == p22.Config.Rarity.RarityNumber then
                return p21.Category < p22.Category;
            end;

            return p21.Config.Rarity.RarityNumber < p22.Config.Rarity.RarityNumber;
        end);
        table.insert(p12._sectionsByPage[v], {
            SectionId = "LimitedEgg",
            DisplayName = "",
            Icon = "rbxassetid://70476079280223",
            HeaderGradient = nil,
            SortOrder = (1 / 0),
            RewardKind = "GearClaim",
            RewardGearId = "BeeLauncher",
            Entries = v20
        });
    end;
end;

function u1._getSave(p23) -- Line: 244
    -- upvalues: Save (copy)
    return Save.Get();
end;

function u1._isDiscovered(p24, p25) -- Line: 248
    local v26 = p24:_getSave();

    if v26 == nil then
        return false;
    end;

    return v26.Index[p25.Category] == true;
end;

function u1._isClaimed(p27, p28) -- Line: 257
    local v29 = p27:_getSave();
    local v30;

    if v29 == nil then
        v30 = false;
    else
        v30 = v29.IndexClaimedCategories[p28.Category] == true;
    end;

    return v30;
end;

function u1._isClaimable(p31, p32) -- Line: 262
    local v33 = p31:_isDiscovered(p32) and not p31:_isClaimed(p32);

    return v33;
end;

function u1._getEntryDisplayName(p34, p35) -- Line: 266
    -- upvalues: ItemDisplay (copy)
    return ItemDisplay.GetNameFromItemData(p35.ItemData);
end;

function u1._getEntryByCategory(p36, p37) -- Line: 270
    if p37 == nil then
        return nil;
    end;

    for _, v in ipairs(p36._sectionsByPage[p36._currentPage]) do
        for _, v2 in ipairs(v.Entries) do
            if v2.Category == p37 then
                return v2;
            end;
        end;
    end;

    return nil;
end;

function u1._stopIndexNotificationPulse(p38) -- Line: 286
    -- upvalues: GetOrCreateUIScale (copy), NotificationBadge (copy)
    local _indexNotificationTween = p38._indexNotificationTween;

    if _indexNotificationTween ~= nil then
        _indexNotificationTween:Cancel();
        _indexNotificationTween:Destroy();
        p38._indexNotificationTween = nil;
    end;

    GetOrCreateUIScale(NotificationBadge).Scale = 1;
end;

function u1._startIndexNotificationPulse(p39) -- Line: 297
    -- upvalues: GetOrCreateUIScale (copy), NotificationBadge (copy), TweenService (copy), u7 (copy)
    if p39._indexNotificationTween ~= nil then
        return;
    end;

    local v40 = GetOrCreateUIScale(NotificationBadge);
    v40.Scale = 0.8;
    local v41 = TweenService:Create(v40, u7, {
        Scale = 1.2
    });
    p39._indexNotificationTween = v41;
    v41:Play();
end;

function u1._setBadge(p42, p43, p44, p45, p46) -- Line: 311
    local v47 = p45 > 0;
    p43.Visible = v47;
    p44.Text = tostring(p45);

    if not p46 then
        return;
    end;

    if v47 then
        p42:_startIndexNotificationPulse();

        return;
    end;

    p42:_stopIndexNotificationPulse();
end;

function u1._renderHiddenIcon(p48, p49) -- Line: 332
    -- upvalues: u5 (copy)
    p49.ImageColor3 = u5;
    p49.ImageTransparency = 0.35;
end;

function u1._renderVisibleIcon(p50, p51) -- Line: 337
    p51.ImageColor3 = Color3.fromRGB(255, 255, 255);
    p51.ImageTransparency = 0;
end;

function u1._applyRarityGradient(p52, p53, p54) -- Line: 342
    p53.Color = p54.Color;
    p53.Rotation = p54.Rotation;
    p53.Transparency = p54.Transparency;
    p53.Offset = p54.Offset;
end;

function u1._renderRarityOddsGradient(p55, p56) -- Line: 353
    -- upvalues: UIGradient (copy)
    p55:_applyRarityGradient(UIGradient, p56);
end;

function u1._renderEntryIcon(p57, p58, p59, p60) -- Line: 357
    -- upvalues: Assets (copy)
    p58.Image = Assets.Directory[p59.Category].Icon or "";

    if p60 then
        p57:_renderVisibleIcon(p58);

        return;
    end;

    p57:_renderHiddenIcon(p58);
end;

function u1._ensureSectionPool(u61, p62) -- Line: 373
    -- upvalues: Template (copy), IndexEntries (copy), AreaIndexProgressComponent (copy), u10 (copy), AutoGridLayout (copy), u8 (copy)
    if u61._openTrove == nil then
        return;
    end;

    while #u61._sections < p62 do
        local v63 = Template:Clone();
        v63.Name = `IndexArea{#u61._sections + 1}`;
        v63.Visible = false;
        v63.Parent = IndexEntries;
        v63.Main.Template.Visible = false;
        local u65 = {
            Section = nil,
            Frame = v63,
            Slots = {},
            ProgressComponent = AreaIndexProgressComponent.new(v63.Frame, function(u64) -- Line: 389
                -- upvalues: u10 (ref), u61 (copy)
                u10(function() -- Line: 390
                    -- upvalues: u64 (copy), u61 (ref)
                    if u64 == "LimitedEgg" then
                        u61:_claimLimitedEggReward();

                        return;
                    end;

                    u61:_equipAreaBat(u64);
                end);
            end),
            GridUpdater = AutoGridLayout(v63.Main, {
                {
                    ResolutionThreshold = (1 / 0),
                    PerRow = 4,
                    Padding = u8
                }
            })
        };
        table.insert(u61._sections, u65);
        u61._openTrove:Add(v63);
        u61._openTrove:Add(function() -- Line: 408
            -- upvalues: u65 (copy)
            u65.ProgressComponent:Destroy();
        end);
    end;
end;

function u1._ensureSlotPool(u66, p67, p68) -- Line: 414
    -- upvalues: ButtonFX (copy)
    if u66._openTrove == nil then
        return;
    end;

    while #p67.Slots < p68 do
        local v69 = p67.Frame.Main.Template:Clone();
        v69.Name = `IndexEntry{#p67.Slots + 1}`;
        v69.Visible = false;
        v69.Parent = p67.Frame.Main;
        local u70 = {
            Entry = nil,
            Frame = v69
        };
        table.insert(p67.Slots, u70);
        local v71 = ButtonFX(v69.Button, nil, function() -- Line: 435
            -- upvalues: u70 (copy), u66 (copy)
            local Entry = u70.Entry;

            if Entry == nil or u66._selectedCategory == Entry.Category then
                return;
            end;

            u66:_selectEntry(Entry.Category);
        end);
        local v72 = ButtonFX(v69.Button);
        u66._openTrove:Add(v71);
        u66._openTrove:Add(v72);
        u66._openTrove:Add(v69);
    end;
end;

function u1._renderSlot(p73, p74, p75) -- Line: 450
    -- upvalues: AssetOddsDisplay (copy), GradientSwap (copy), UpdateTextAndShadow (copy), u3 (copy), u4 (copy)
    local Frame = p74.Frame;
    p74.Entry = p75;

    if p75 == nil then
        Frame.Visible = false;

        return;
    end;

    local v76 = p73:_isDiscovered(p75);
    local v77 = p73:_isClaimed(p75);
    local v78 = p73._selectedCategory == p75.Category;
    Frame.Visible = true;
    Frame.Name = p75.Category;
    Frame.Button.TextLabelFrame.TextLabel.Text = AssetOddsDisplay.GetDisplayForItemData(p75.Config, p75.ItemData, false);
    GradientSwap(Frame, p75.Config.Rarity.Gradient);
    p73:_renderEntryIcon(Frame.Button.Icon.ImageLabel, p75, v76);
    Frame.Button.MutationIcon.Visible = false;

    if v76 then
        local v79 = p73:_getEntryDisplayName(p75);
        UpdateTextAndShadow(Frame.DisplayName.TextLabel, v79);
        Frame.DisplayName.DropShadow.Text = v79;
    else
        UpdateTextAndShadow(Frame.DisplayName.TextLabel, "???");
        Frame.DisplayName.DropShadow.Text = "???";
    end;

    if v76 then
        v76 = not v77;
    end;

    Frame.Outline.Visible = v78 or v76;
    local v80;

    if v76 then
        v80 = u3;
    else
        v80 = u4;
    end;

    Frame.Outline.ImageColor3 = v80;
end;

function u1._renderSlots(u81) -- Line: 490
    -- upvalues: LimitedEggSeparation (copy), GradientSwap (copy)
    local v82 = u81._sectionsByPage[u81._currentPage];
    u81:_ensureSectionPool(#v82);
    LimitedEggSeparation.Visible = #v82 > 0;
    LimitedEggSeparation.LayoutOrder = #v82;

    for i, v in ipairs(u81._sections) do
        local v83 = v82[i];
        v.Section = v83;

        if v83 == nil then
            v.Frame.Visible = false;

            for _, v2 in ipairs(v.Slots) do
                u81:_renderSlot(v2, nil);
            end;
        else
            v.Frame.Visible = true;
            v.Frame.Name = v83.SectionId;

            if v83.RewardKind == "GearClaim" then
                local i = i + 1;
            end;

            v.Frame.LayoutOrder = i;
            v.Frame.Frame.TextLabel.Text = v83.DisplayName;

            if v83.HeaderGradient ~= nil then
                GradientSwap(v.Frame.Frame.TextLabel, v83.HeaderGradient);
            end;

            v.Frame.Frame.Image.Image = v83.Icon;
            local v84 = 0;

            for _, v2 in v83.Entries do
                if u81:_isDiscovered(v2) then
                    v84 = v84 + 1;
                end;
            end;

            local v85 = u81:_getSave();
            local v86;

            if v85 == nil then
                v86 = false;
            else
                v86 = (v85.GearInventory[v83.RewardGearId] or 0) > 0;
            end;

            if v83.RewardKind == "AreaBat" then
                local v87;

                if v85 == nil then
                    v87 = false;
                else
                    v87 = v85.VisitedGears[v83.RewardGearId] == true;
                end;

                v.ProgressComponent:RenderAreaBat(v83.SectionId, v83.RewardGearId, v84, #v83.Entries, v87, v86);
            else
                v.ProgressComponent:RenderGearClaim(v83.SectionId, v83.RewardGearId, v84, #v83.Entries, v86);
            end;

            u81:_ensureSlotPool(v, #v83.Entries);

            for i2, v2 in ipairs(v.Slots) do
                u81:_renderSlot(v2, v83.Entries[i2]);
            end;
        end;
    end;

    u81:_updateIndexEntriesGridLayout();
    task.delay(0.2, function() -- Line: 551
        -- upvalues: u81 (copy)
        if u81._isOpen then
            u81:_updateIndexEntriesGridLayout();
        end;
    end);
end;

function u1._updateIndexEntriesGridLayout(p88) -- Line: 558
    for _, v in ipairs(p88._sections) do
        if v.Frame.Visible and v.GridUpdater ~= nil then
            v.GridUpdater();
        end;
    end;
end;

function u1._selectEntry(p89, p90) -- Line: 566
    p89._selectedCategory = p90;
    p89:_renderSlots();
    p89:_renderInfo();
    p89:_renderRewards();
end;

function u1._selectDefaultEntry(p91) -- Line: 573
    if p91:_getEntryByCategory(p91._selectedCategory) ~= nil then
        return;
    end;

    for _, v in ipairs(p91._sectionsByPage[p91._currentPage]) do
        local v92 = v.Entries[1];

        if v92 ~= nil then
            p91._selectedCategory = v92.Category;

            return;
        end;
    end;
end;

function u1._renderInfo(p93) -- Line: 588
    -- upvalues: ImageLabel (copy), MutationIcon (copy), TextLabel3 (copy), TextLabel4 (copy), AssetOddsDisplay (copy), RarityGlow (copy), UIStroke (copy), UpdateTextAndShadow (copy), TextLabel2 (copy), TextLabel5 (copy), Simple (copy), AssetItemUtil (copy)
    local v94 = p93:_getEntryByCategory(p93._selectedCategory);

    if v94 == nil then
        return;
    end;

    local v95 = p93:_isDiscovered(v94);
    p93:_renderEntryIcon(ImageLabel, v94, v95);
    MutationIcon.Visible = false;
    TextLabel3.Text = v94.Config.Rarity._id;
    TextLabel4.Text = AssetOddsDisplay.GetDisplayForItemData(v94.Config, v94.ItemData, false);
    p93:_renderRarityOddsGradient(v94.Config.Rarity.Gradient);
    RarityGlow.BackgroundColor3 = v94.Config.Rarity.Color;
    UIStroke.Color = v94.Config.Rarity.Color;

    if v95 then
        UpdateTextAndShadow(TextLabel2, p93:_getEntryDisplayName(v94));
        TextLabel5.Text = "$" .. Simple.FormatCompact(AssetItemUtil.GetIndexMoneyRewardAmount(v94.Category) / 100, ".#") .. "/s";

        return;
    end;

    UpdateTextAndShadow(TextLabel2, "???");
    TextLabel5.Text = "???";
end;

function u1._renderRewards(p96) -- Line: 615
    -- upvalues: ClaimRewardPanel (copy), IndexRewardsFrame (copy)
    local v97 = p96:_getEntryByCategory(p96._selectedCategory);
    local v98;

    if v97 == nil then
        v98 = false;
    else
        v98 = p96:_isClaimed(v97);
    end;

    local v99;

    if v97 == nil then
        v99 = false;
    else
        v99 = p96:_isClaimable(v97);
    end;

    ClaimRewardPanel.Render(IndexRewardsFrame, v97, v98, v99);
end;

function u1._countUnclaimedByPage(p100, p101) -- Line: 622
    local v102 = 0;

    for _, v in ipairs(p100._sectionsByPage[p101]) do
        for _, v2 in ipairs(v.Entries) do
            if p100:_isClaimable(v2) then
                v102 = v102 + 1;
            end;
        end;
    end;

    return v102;
end;

function u1._countDiscoveredByPage(p103, p104) -- Line: 635
    local v105 = 0;

    for _, v in ipairs(p103._sectionsByPage[p104]) do
        for _, v2 in ipairs(v.Entries) do
            if p103:_isDiscovered(v2) then
                v105 = v105 + 1;
            end;
        end;
    end;

    return v105;
end;

function u1._countEntriesByPage(p106, p107) -- Line: 648
    local v108 = 0;

    for _, v in ipairs(p106._sectionsByPage[p107]) do
        v108 = v108 + #v.Entries;
    end;

    return v108;
end;

function u1._renderProgressAndBadges(p109) -- Line: 657
    -- upvalues: u2 (copy), NotificationBadge (copy), TextLabel (copy), ClaimAllButton (copy), ProgressBar (copy), UIGradient2 (copy), TextLabel6 (copy), TweenService (copy), Fill (copy), u6 (copy)
    local v110 = p109:_countEntriesByPage(p109._currentPage);
    local v111 = p109:_countDiscoveredByPage(p109._currentPage);
    local v112 = 0;

    for _, v in ipairs(u2) do
        v112 = v112 + p109:_countUnclaimedByPage(v);
    end;

    p109:_setBadge(NotificationBadge, TextLabel, v112, true);
    p109:_setBadge(ClaimAllButton.NotificationBadge, ClaimAllButton.NotificationBadge.Frame.BadgeFrame.TextLabelFrame.TextLabel, v112, false);
    ClaimAllButton.Visible = v112 > 0;
    ProgressBar.Visible = v112 == 0;
    UIGradient2.Enabled = v112 > 0;
    TextLabel6.Text = `{v111}/{v110}`;
    local v113 = v110 == 0 and 0 or math.clamp(v111 / v110, 0, 1);
    TweenService:Create(Fill, u6, {
        Size = UDim2.fromScale(v113, 1)
    }):Play();
end;

function u1._render(p114) -- Line: 685
    if not p114._isOpen then
        p114:_renderProgressAndBadges();

        return;
    end;

    p114:_selectDefaultEntry();
    p114:_renderSlots();
    p114:_renderInfo();
    p114:_renderRewards();
    p114:_renderProgressAndBadges();
end;

function u1._open(p115) -- Line: 698
    -- upvalues: Trove (copy)
    if p115._isOpen then
        return;
    end;

    p115._isOpen = true;
    p115._currentPage = "Base";
    p115._selectedCategory = nil;
    p115._openTrove = Trove.new();
    p115:_render();
end;

function u1._close(p116) -- Line: 710
    -- upvalues: LimitedEggSeparation (copy)
    p116._isOpen = false;
    p116._currentPage = "Base";
    p116._selectedCategory = nil;
    LimitedEggSeparation.Visible = false;

    if p116._openTrove ~= nil then
        p116._openTrove:Destroy();
        p116._openTrove = nil;
    end;

    table.clear(p116._sections);
    p116:_render();
end;

function u1._processClaimResults(p117, p118) -- Line: 723
    -- upvalues: Save (copy)
    if p118 == nil then
        return;
    end;

    for _, v in ipairs(p118) do
        Save.ProcessManualTableKeyChange("IndexClaimedCategories", v.Category, true);
    end;
end;

function u1._claimSelected(p119) -- Line: 733
    -- upvalues: Network (copy), Index (copy), u9 (copy)
    local v120 = p119:_getEntryByCategory(p119._selectedCategory);

    if v120 == nil or not p119:_isClaimable(v120) then
        return;
    end;

    local v121, v122, v123 = Network.Invoke(Index.REQUEST_CLAIM, v120.Category);

    if not v121 then
        u9:AtWarning():Log((`[Index] Claim failed: {v122}`));

        return;
    end;

    p119:_processClaimResults(v123);
    p119:Refresh();
end;

function u1._claimAll(p124) -- Line: 749
    -- upvalues: Network (copy), Index (copy), u9 (copy)
    local v125, v126, v127 = Network.Invoke(Index.REQUEST_CLAIM_ALL);

    if not v125 then
        u9:AtWarning():Log((`[Index] Claim all failed: {v126}`));

        return;
    end;

    p124:_processClaimResults(v127);
    p124:Refresh();
end;

function u1._equipAreaBat(p128, p129) -- Line: 760
    -- upvalues: Network (copy), Index (copy), u9 (copy)
    local v130, v131 = Network.Invoke(Index.REQUEST_EQUIP_AREA_BAT, p129);

    if v130 then
        p128:Refresh();

        return;
    end;

    u9:AtWarning():Log((`[Index] Equip area bat failed: {v131}`));
end;

function u1._claimLimitedEggReward(p132) -- Line: 770
    -- upvalues: Network (copy), Index (copy), u9 (copy)
    local v133, v134 = Network.Invoke(Index.REQUEST_CLAIM_LIMITED_EGG_REWARD);

    if v133 then
        p132:Refresh();

        return;
    end;

    u9:AtWarning():Log((`[Index] Limited Egg reward claim failed: {v134}`));
end;

function u1.Refresh(p135) -- Line: 784
    p135:_render();
end;

function u1._init(u136) -- Line: 792
    -- upvalues: Index2 (copy), Template (copy), LimitedEggSeparation (copy), ButtonFX (copy), Button (copy), TabController (copy), ClaimButton (copy), ClaimAllButton (copy), Save (copy)
    Index2.MutationsTab.Visible = false;
    Template.Visible = false;
    Template.Main.Template.Visible = false;
    LimitedEggSeparation.Visible = false;
    u136._trove:Add(ButtonFX(Button, nil, function() -- Line: 797
        -- upvalues: TabController (ref)
        TabController.ToggleTab("Index");
    end));
    u136._trove:Add(ButtonFX(ClaimButton, nil, function() -- Line: 800
        -- upvalues: u136 (copy)
        u136:_claimSelected();
    end));
    u136._trove:Add(ButtonFX(ClaimAllButton, nil, function() -- Line: 803
        -- upvalues: u136 (copy)
        u136:_claimAll();
    end));
    u136._trove:Add(Save.ConnectForDataChanged({ "Index", "IndexClaimedCategories", "VisitedGears", "GearInventory" }, function() -- Line: 808
        -- upvalues: u136 (copy)
        u136:Refresh();
    end));
    u136._trove:Connect(TabController.Opened, function(p137) -- Line: 812
        -- upvalues: u136 (copy)
        if p137 == "Index" then
            u136:_open();
        end;
    end);
    u136._trove:Connect(TabController.Closed, function(p138) -- Line: 817
        -- upvalues: u136 (copy)
        if p138 == "Index" then
            u136:_close();
        end;
    end);
    u136:_render();
end;

return u1._build();