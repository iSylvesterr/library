-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");
local Assets = require(ReplicatedStorage.Directory.Assets);
local AreaEggResetTimeUtil = require(ReplicatedStorage.Library.Util.AreaEggResetTimeUtil);
local ConsoleCmds = require(ReplicatedStorage.Library.Client.ConsoleCmds);
local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds);
require(ReplicatedStorage.Library.Client.Eggs.Types);
local EggItemUtil = require(ReplicatedStorage.Library.Util.EggItemUtil);
require(ReplicatedStorage.Library.Types.Eggs);
local FormatDurationSymbol = require(ReplicatedStorage.Library.Functions.FormatDurationSymbol);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local GrowingEggListRow = require(ReplicatedStorage.Library.Client.Eggs.GrowingEggListRow);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Message = require(ReplicatedStorage.Library.Client.NotificationCmds.Message);
local PlacedEggRenderer = require(ReplicatedStorage.Library.Client.Eggs.PlacedEggRenderer);
local Products = require(ReplicatedStorage.Directory.Products);
local PromptPurchase = require(ReplicatedStorage.Library.Shared.Functions.PromptPurchase);
local LocalPlayer = Players.LocalPlayer;
local u1 = GUI.GrowingEggList();
local v2 = GUI.SideButtons();
local Frame = u1.Frame;
local Close = Frame.Close;
local GrowAll = Frame.Header.GrowAll;
local ScrollingFrame = Frame.Notepad.ScrollingFrame;
local Template = ScrollingFrame.Template;
local GrowingEggs = v2.Tabs.GrowingEggs;
local NightImage = GrowingEggs.NightImage;
local NightText = GrowingEggs.NightText;
local Notification = GrowingEggs.Notification;
local InletTexture = Notification.InletTexture;
local TextLabel = InletTexture.TextLabel;
local Shadow = TextLabel.Shadow;
local ReadyNotification = GrowingEggs.ReadyNotification;
local InletTexture2 = ReadyNotification.InletTexture;
local TextLabel2 = InletTexture2.TextLabel;
local Shadow2 = TextLabel2.Shadow;
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = {};
local u7 = {};
local u8 = {};
local u9 = 0;
local u10 = 0;
local u11 = 0;
local v12 = u1:IsA("ScreenGui");
assert(v12, "PlayerGui.GrowingEggList must be a ScreenGui");
local v13 = Frame:IsA("GuiObject");
assert(v13, "GrowingEggList.Frame must be a GuiObject");
local v14 = Close:IsA("GuiButton");
assert(v14, "GrowingEggList.Frame.Close must be a GuiButton");
local v15 = GrowAll:IsA("GuiButton");
assert(v15, "GrowingEggList.Frame.Header.GrowAll must be a GuiButton");
local v16 = ScrollingFrame:IsA("ScrollingFrame");
assert(v16, "GrowingEggList.Frame.Notepad.ScrollingFrame must be a ScrollingFrame");
local v17 = Template:IsA("GuiObject");
assert(v17, "GrowingEggList.Frame.Notepad.ScrollingFrame.Template must be a GuiObject");
local v18 = GrowingEggs:IsA("GuiButton");
assert(v18, "Elements.Tabs.GrowingEggs must be a GuiButton");
local v19 = NightImage:IsA("ImageLabel");
assert(v19, "Elements.Tabs.GrowingEggs.NightImage must be an ImageLabel");
local v20 = NightText:IsA("TextLabel");
assert(v20, "Elements.Tabs.GrowingEggs.NightText must be a TextLabel");
ConsoleCmds.RegisterCloseButton(Close);
local v21 = Notification:IsA("GuiObject");
assert(v21, "Elements.Tabs.GrowingEggs.Notification must be a GuiObject");
local v22 = InletTexture:IsA("GuiObject");
assert(v22, "Elements.Tabs.GrowingEggs.Notification.InletTexture must be a GuiObject");
local v23 = TextLabel:IsA("TextLabel");
assert(v23, "Elements.Tabs.GrowingEggs.Notification.InletTexture.TextLabel must be a TextLabel");
local v24 = Shadow:IsA("TextLabel");
assert(v24, "Elements.Tabs.GrowingEggs.Notification.InletTexture.Shadow must be a TextLabel");
local v25 = ReadyNotification:IsA("GuiObject");
assert(v25, "Elements.Tabs.GrowingEggs.ReadyNotification must be a GuiObject");
local v26 = InletTexture2:IsA("GuiObject");
assert(v26, "Elements.Tabs.GrowingEggs.ReadyNotification.InletTexture must be a GuiObject");
local v27 = TextLabel2:IsA("TextLabel");
assert(v27, "Elements.Tabs.GrowingEggs.ReadyNotification.InletTexture.TextLabel must be a TextLabel");
local v28 = Shadow2:IsA("TextLabel");
assert(v28, "Elements.Tabs.GrowingEggs.ReadyNotification.InletTexture.Shadow must be a TextLabel");
local u29 = Log.new();

local function setOpen(p30) -- Line: 148
    -- upvalues: u1 (copy), GrowingEggs (copy)
    u1.Enabled = p30;
    GrowingEggs.Visible = not p30;
end;

local function getGrowthAlpha(p31) -- Line: 153
    -- upvalues: Workspace (copy), EggItemUtil (copy), LocalPlayer (copy)
    local v32 = Workspace:GetServerTimeNow();

    return EggItemUtil.GetGrowthAlpha(p31, v32, p31.GrowthSpeedMultiplier, EggItemUtil.GetCurrentNightGrowthCreditSeconds(p31, v32, p31.GrowthSpeedMultiplier), LocalPlayer);
end;

local function isReady(p33) -- Line: 164
    -- upvalues: Workspace (copy), EggItemUtil (copy), LocalPlayer (copy)
    local v34 = Workspace:GetServerTimeNow();

    return EggItemUtil.GetGrowthAlpha(p33, v34, p33.GrowthSpeedMultiplier, EggItemUtil.GetCurrentNightGrowthCreditSeconds(p33, v34, p33.GrowthSpeedMultiplier), LocalPlayer) >= 1;
end;

local function getRemainingSeconds(p35) -- Line: 168
    -- upvalues: Workspace (copy), EggItemUtil (copy), LocalPlayer (copy)
    if p35.Placement ~= nil then
        local v36 = Workspace:GetServerTimeNow();

        if EggItemUtil.GetGrowthAlpha(p35, v36, p35.GrowthSpeedMultiplier, EggItemUtil.GetCurrentNightGrowthCreditSeconds(p35, v36, p35.GrowthSpeedMultiplier), LocalPlayer) < 1 then
            local v37 = Workspace:GetServerTimeNow();

            return EggItemUtil.GetRemainingGrowthSeconds(p35, v37, p35.GrowthSpeedMultiplier, EggItemUtil.GetCurrentNightGrowthCreditSeconds(p35, v37, p35.GrowthSpeedMultiplier), LocalPlayer);
        end;
    end;

    return 0;
end;

local function getRemainingText(p38) -- Line: 184
    -- upvalues: Workspace (copy), EggItemUtil (copy), LocalPlayer (copy), FormatDurationSymbol (copy)
    local Placement = p38.Placement;

    if Placement == nil or Placement.ReadyAt ~= nil then
        return "Ready!";
    end;

    local v39;

    if p38.Placement == nil then
        v39 = 0;
    else
        local v40 = Workspace:GetServerTimeNow();

        if EggItemUtil.GetGrowthAlpha(p38, v40, p38.GrowthSpeedMultiplier, EggItemUtil.GetCurrentNightGrowthCreditSeconds(p38, v40, p38.GrowthSpeedMultiplier), LocalPlayer) >= 1 then
            v39 = 0;
        else
            local v41 = Workspace:GetServerTimeNow();
            v39 = EggItemUtil.GetRemainingGrowthSeconds(p38, v41, p38.GrowthSpeedMultiplier, EggItemUtil.GetCurrentNightGrowthCreditSeconds(p38, v41, p38.GrowthSpeedMultiplier), LocalPlayer);
        end;
    end;

    return v39 <= 0 and "Ready!" or FormatDurationSymbol(v39);
end;

local function updateRow(p42) -- Line: 194
    -- upvalues: Assets (copy), Workspace (copy), EggItemUtil (copy), LocalPlayer (copy), Products (copy), getRemainingSeconds (copy), GrowingEggListRow (copy), FormatDurationSymbol (copy)
    local Record = p42.Record;
    local v43 = Assets.Directory[Record.AssetCategory];
    local v44 = Workspace:GetServerTimeNow();
    local v45 = EggItemUtil.GetGrowthAlpha(Record, v44, Record.GrowthSpeedMultiplier, EggItemUtil.GetCurrentNightGrowthCreditSeconds(Record, v44, Record.GrowthSpeedMultiplier), LocalPlayer);
    local v46 = v45 >= 1;
    local v47 = not v46 and Products.GetEggSkipGrowthProduct(getRemainingSeconds(Record)) ~= nil;
    local Update = GrowingEggListRow.Update;
    local Icon = v43.Egg.Icon;
    local Placement = Record.Placement;
    local v48;

    if Placement == nil or Placement.ReadyAt ~= nil then
        v48 = "Ready!";
    else
        local v49;

        if Record.Placement == nil then
            v49 = 0;
        else
            local v50 = Workspace:GetServerTimeNow();

            if EggItemUtil.GetGrowthAlpha(Record, v50, Record.GrowthSpeedMultiplier, EggItemUtil.GetCurrentNightGrowthCreditSeconds(Record, v50, Record.GrowthSpeedMultiplier), LocalPlayer) >= 1 then
                v49 = 0;
            else
                local v51 = Workspace:GetServerTimeNow();
                v49 = EggItemUtil.GetRemainingGrowthSeconds(Record, v51, Record.GrowthSpeedMultiplier, EggItemUtil.GetCurrentNightGrowthCreditSeconds(Record, v51, Record.GrowthSpeedMultiplier), LocalPlayer);
            end;
        end;

        v48 = v49 <= 0 and "Ready!" or FormatDurationSymbol(v49);
    end;

    Update(p42, Icon, v45, v48, v46, v47);
end;

local function updateNotification(p52, p53, p54, p55) -- Line: 203
    local v56 = p55 > 0;
    p52.Visible = v56;

    if v56 then
        local v57 = tostring(p55);
        p53.Text = v57;
        p54.Text = v57;
    end;
end;

local function updatePlacedNotification() -- Line: 213
    -- upvalues: Notification (copy), TextLabel (copy), Shadow (copy), u9 (ref)
    local v58 = TextLabel;
    local v59 = Shadow;
    local v60 = u9;
    local v61 = v60 > 0;
    Notification.Visible = v61;

    if v61 then
        local v62 = tostring(v60);
        v58.Text = v62;
        v59.Text = v62;
    end;
end;

local function updateReadyNotification() -- Line: 222
    -- upvalues: ReadyNotification (copy), TextLabel2 (copy), Shadow2 (copy), u10 (ref)
    local v63 = TextLabel2;
    local v64 = Shadow2;
    local v65 = u10;
    local v66 = v65 > 0;
    ReadyNotification.Visible = v66;

    if v66 then
        local v67 = tostring(v65);
        v63.Text = v67;
        v64.Text = v67;
    end;
end;

local function clearPlacedNotification() -- Line: 226
    -- upvalues: u9 (ref), u7 (copy), Notification (copy), TextLabel (copy), Shadow (copy)
    u9 = 0;
    table.clear(u7);
    local v68 = TextLabel;
    local v69 = Shadow;
    local v70 = u9;
    local v71 = v70 > 0;
    Notification.Visible = v71;

    if v71 then
        local v72 = tostring(v70);
        v68.Text = v72;
        v69.Text = v72;
    end;
end;

local function clearReadyNotification() -- Line: 232
    -- upvalues: u10 (ref), u8 (copy), ReadyNotification (copy), TextLabel2 (copy), Shadow2 (copy)
    u10 = 0;
    table.clear(u8);
    local v73 = TextLabel2;
    local v74 = Shadow2;
    local v75 = u10;
    local v76 = v75 > 0;
    ReadyNotification.Visible = v76;

    if v76 then
        local v77 = tostring(v75);
        v73.Text = v77;
        v74.Text = v77;
    end;
end;

local function incrementPlacedNotification(p78) -- Line: 238
    -- upvalues: u1 (copy), u7 (copy), u9 (ref), Notification (copy), TextLabel (copy), Shadow (copy)
    if u1.Enabled or u7[p78] then
        return;
    end;

    u7[p78] = true;
    u9 = u9 + 1;
    local v79 = TextLabel;
    local v80 = Shadow;
    local v81 = u9;
    local v82 = v81 > 0;
    Notification.Visible = v82;

    if v82 then
        local v83 = tostring(v81);
        v79.Text = v83;
        v80.Text = v83;
    end;
end;

local function incrementReadyNotification(p84) -- Line: 248
    -- upvalues: u1 (copy), u8 (copy), u10 (ref), ReadyNotification (copy), TextLabel2 (copy), Shadow2 (copy)
    if u1.Enabled or u8[p84] then
        return;
    end;

    u8[p84] = true;
    u10 = u10 + 1;
    local v85 = TextLabel2;
    local v86 = Shadow2;
    local v87 = u10;
    local v88 = v87 > 0;
    ReadyNotification.Visible = v88;

    if v88 then
        local v89 = tostring(v87);
        v85.Text = v89;
        v86.Text = v89;
    end;
end;

local function consumePlacedNotification(p90) -- Line: 258
    -- upvalues: u7 (copy), u9 (ref), Notification (copy), TextLabel (copy), Shadow (copy)
    if not u7[p90] then
        return;
    end;

    u7[p90] = nil;
    u9 = math.max(u9 - 1, 0);
    local v91 = TextLabel;
    local v92 = Shadow;
    local v93 = u9;
    local v94 = v93 > 0;
    Notification.Visible = v94;

    if v94 then
        local v95 = tostring(v93);
        v91.Text = v95;
        v92.Text = v95;
    end;
end;

local function consumeReadyNotification(p96) -- Line: 268
    -- upvalues: u8 (copy), u10 (ref), ReadyNotification (copy), TextLabel2 (copy), Shadow2 (copy)
    if not u8[p96] then
        return;
    end;

    u8[p96] = nil;
    u10 = math.max(u10 - 1, 0);
    local v97 = TextLabel2;
    local v98 = Shadow2;
    local v99 = u10;
    local v100 = v99 > 0;
    ReadyNotification.Visible = v100;

    if v100 then
        local v101 = tostring(v99);
        v97.Text = v101;
        v98.Text = v101;
    end;
end;

local function syncReadyState(p102, p103, p104) -- Line: 278
    -- upvalues: Workspace (copy), EggItemUtil (copy), LocalPlayer (copy), u6 (copy), u1 (copy), u8 (copy), u10 (ref), ReadyNotification (copy), TextLabel2 (copy), Shadow2 (copy)
    local v105 = Workspace:GetServerTimeNow();
    local v106 = EggItemUtil.GetGrowthAlpha(p103, v105, p103.GrowthSpeedMultiplier, EggItemUtil.GetCurrentNightGrowthCreditSeconds(p103, v105, p103.GrowthSpeedMultiplier), LocalPlayer) >= 1;

    if v106 and not u6[p102] then
        u6[p102] = true;

        if p104 and not u1.Enabled then
            if u8[p102] then
                return v106;
            end;

            u8[p102] = true;
            u10 = u10 + 1;
            local v107 = TextLabel2;
            local v108 = Shadow2;
            local v109 = u10;
            local v110 = v109 > 0;
            ReadyNotification.Visible = v110;

            if v110 then
                local v111 = tostring(v109);
                v107.Text = v111;
                v108.Text = v111;

                return v106;
            end;
        end;
    elseif not v106 and u6[p102] then
        u6[p102] = nil;

        if not u8[p102] then
            return v106;
        end;

        u8[p102] = nil;
        u10 = math.max(u10 - 1, 0);
        local v112 = TextLabel2;
        local v113 = Shadow2;
        local v114 = u10;
        local v115 = v114 > 0;
        ReadyNotification.Visible = v115;

        if v115 then
            local v116 = tostring(v114);
            v112.Text = v116;
            v113.Text = v116;
        end;
    end;

    return v106;
end;

local function compareRows(p117, p118) -- Line: 293
    -- upvalues: Workspace (copy), EggItemUtil (copy), LocalPlayer (copy)
    local Record = p117.Record;
    local v119 = Workspace:GetServerTimeNow();
    local v120 = EggItemUtil.GetGrowthAlpha(Record, v119, Record.GrowthSpeedMultiplier, EggItemUtil.GetCurrentNightGrowthCreditSeconds(Record, v119, Record.GrowthSpeedMultiplier), LocalPlayer) >= 1;
    local Record2 = p118.Record;
    local v121 = Workspace:GetServerTimeNow();

    if v120 ~= (EggItemUtil.GetGrowthAlpha(Record2, v121, Record2.GrowthSpeedMultiplier, EggItemUtil.GetCurrentNightGrowthCreditSeconds(Record2, v121, Record2.GrowthSpeedMultiplier), LocalPlayer) >= 1) then
        return v120;
    end;

    local Record3 = p117.Record;
    local v122;

    if Record3.Placement == nil then
        v122 = 0;
    else
        local v123 = Workspace:GetServerTimeNow();

        if EggItemUtil.GetGrowthAlpha(Record3, v123, Record3.GrowthSpeedMultiplier, EggItemUtil.GetCurrentNightGrowthCreditSeconds(Record3, v123, Record3.GrowthSpeedMultiplier), LocalPlayer) >= 1 then
            v122 = 0;
        else
            local v124 = Workspace:GetServerTimeNow();
            v122 = EggItemUtil.GetRemainingGrowthSeconds(Record3, v124, Record3.GrowthSpeedMultiplier, EggItemUtil.GetCurrentNightGrowthCreditSeconds(Record3, v124, Record3.GrowthSpeedMultiplier), LocalPlayer);
        end;
    end;

    local Record4 = p118.Record;
    local v125;

    if Record4.Placement == nil then
        v125 = 0;
    else
        local v126 = Workspace:GetServerTimeNow();

        if EggItemUtil.GetGrowthAlpha(Record4, v126, Record4.GrowthSpeedMultiplier, EggItemUtil.GetCurrentNightGrowthCreditSeconds(Record4, v126, Record4.GrowthSpeedMultiplier), LocalPlayer) >= 1 then
            v125 = 0;
        else
            local v127 = Workspace:GetServerTimeNow();
            v125 = EggItemUtil.GetRemainingGrowthSeconds(Record4, v127, Record4.GrowthSpeedMultiplier, EggItemUtil.GetCurrentNightGrowthCreditSeconds(Record4, v127, Record4.GrowthSpeedMultiplier), LocalPlayer);
        end;
    end;

    if v122 == v125 then
        return tostring(p117.Uid) < tostring(p118.Uid);
    end;

    return v122 < v125;
end;

local function relayoutRows() -- Line: 309
    -- upvalues: u3 (copy), compareRows (copy)
    local v128 = {};

    for _, v in pairs(u3) do
        table.insert(v128, v);
    end;

    table.sort(v128, compareRows);

    for i, v in ipairs(v128) do
        v.Root.LayoutOrder = i;
    end;
end;

local function destroyRow(p129) -- Line: 321
    -- upvalues: u3 (copy), GrowingEggListRow (copy)
    local v130 = u3[p129];

    if v130 == nil then
        return;
    end;

    u3[p129] = nil;
    GrowingEggListRow.Destroy(v130);
end;

local function requestGrow(p131) -- Line: 331
    -- upvalues: PlacedEggRenderer (copy), u29 (copy)
    local v132, v133 = PlacedEggRenderer.RequestSkipGrowthForLocalEgg(p131);

    if not v132 then
        u29:AtWarning():Log((`Failed to request egg growth skip from list for {p131}: {v133 or "unknown"}`));
    end;
end;

local function showNoGrowingEggs(p134) -- Line: 338
    -- upvalues: Message (copy)
    Message.Bottom({
        Time = 2,
        Message = p134 or "You have no growing eggs!",
        Color = Color3.fromRGB(255, 80, 80)
    });
end;

local function requestGrowAll() -- Line: 346
    -- upvalues: EggCmds (copy), Message (copy), PromptPurchase (copy), Products (copy)
    local v135, v136 = EggCmds.CanPurchaseGrowAll();

    if not v135 then
        Message.Bottom({
            Time = 2,
            Message = v136 or "You have no growing eggs!",
            Color = Color3.fromRGB(255, 80, 80)
        });

        return;
    end;

    EggCmds.ClearSelectedSkipGrowthUid();
    PromptPurchase.Prompt(Products.Directory.EggGrowAll.ProductId, true);
end;

local function requestHatch(p137) -- Line: 357
    -- upvalues: PlacedEggRenderer (copy), u29 (copy)
    local v138, v139 = PlacedEggRenderer.ActivateLocalEgg(p137);

    if not v138 then
        u29:AtWarning():Log((`Failed to hatch egg from list for {p137}: {v139 or "unknown"}`));
    end;
end;

local function removeHatchingRow(p140) -- Line: 364
    -- upvalues: u4 (copy), u7 (copy), u9 (ref), Notification (copy), TextLabel (copy), Shadow (copy), u8 (copy), u10 (ref), ReadyNotification (copy), TextLabel2 (copy), Shadow2 (copy), u3 (copy), GrowingEggListRow (copy)
    u4[p140] = true;

    if u7[p140] then
        u7[p140] = nil;
        u9 = math.max(u9 - 1, 0);
        local v141 = TextLabel;
        local v142 = Shadow;
        local v143 = u9;
        local v144 = v143 > 0;
        Notification.Visible = v144;

        if v144 then
            local v145 = tostring(v143);
            v141.Text = v145;
            v142.Text = v145;
        end;
    end;

    if u8[p140] then
        u8[p140] = nil;
        u10 = math.max(u10 - 1, 0);
        local v146 = TextLabel2;
        local v147 = Shadow2;
        local v148 = u10;
        local v149 = v148 > 0;
        ReadyNotification.Visible = v149;

        if v149 then
            local v150 = tostring(v148);
            v146.Text = v150;
            v147.Text = v150;
        end;
    end;

    local v151 = u3[p140];

    if v151 == nil then
        return;
    end;

    u3[p140] = nil;
    GrowingEggListRow.Destroy(v151);
end;

local function mountRow(p152, p153) -- Line: 371
    -- upvalues: GrowingEggListRow (copy), Template (copy), ScrollingFrame (copy), requestGrow (copy), requestHatch (copy), u3 (copy), updateRow (copy)
    local v154 = GrowingEggListRow.Mount(Template, ScrollingFrame, p152, requestGrow, requestHatch);
    v154.Record = p153;
    u3[p152] = v154;
    updateRow(v154);

    return v154;
end;

local function refreshRows(p155, p156) -- Line: 380
    -- upvalues: EggCmds (copy), LocalPlayer (copy), u5 (copy), u1 (copy), u7 (copy), u9 (ref), Notification (copy), TextLabel (copy), Shadow (copy), Workspace (copy), EggItemUtil (copy), u6 (copy), u8 (copy), u10 (ref), ReadyNotification (copy), TextLabel2 (copy), Shadow2 (copy), u4 (copy), u3 (copy), GrowingEggListRow (copy), Template (copy), ScrollingFrame (copy), requestGrow (copy), requestHatch (copy), updateRow (copy), relayoutRows (copy)
    local v157 = EggCmds.GetOwnerRuntimeRecords(LocalPlayer.UserId);
    local v158 = {};
    local v159 = {};

    for i, v in pairs(v157) do
        if v.Placement ~= nil then
            v158[i] = true;

            if not u5[i] then
                u5[i] = true;

                if p155 and not (u1.Enabled or u7[i]) then
                    u7[i] = true;
                    u9 = u9 + 1;
                    local v160 = TextLabel;
                    local v161 = Shadow;
                    local v162 = u9;
                    local v163 = v162 > 0;
                    Notification.Visible = v163;

                    if v163 then
                        local v164 = tostring(v162);
                        v160.Text = v164;
                        v161.Text = v164;
                    end;
                end;
            end;

            local v165 = Workspace:GetServerTimeNow();
            local v166 = EggItemUtil.GetGrowthAlpha(v, v165, v.GrowthSpeedMultiplier, EggItemUtil.GetCurrentNightGrowthCreditSeconds(v, v165, v.GrowthSpeedMultiplier), LocalPlayer) >= 1;

            if v166 and not u6[i] then
                u6[i] = true;

                if p156 and not (u1.Enabled or u8[i]) then
                    u8[i] = true;
                    u10 = u10 + 1;
                    local v167 = TextLabel2;
                    local v168 = Shadow2;
                    local v169 = u10;
                    local v170 = v169 > 0;
                    ReadyNotification.Visible = v170;

                    if v170 then
                        local v171 = tostring(v169);
                        v167.Text = v171;
                        v168.Text = v171;
                    end;
                end;
            elseif not v166 and u6[i] then
                u6[i] = nil;

                if u8[i] then
                    u8[i] = nil;
                    u10 = math.max(u10 - 1, 0);
                    local v172 = TextLabel2;
                    local v173 = Shadow2;
                    local v174 = u10;
                    local v175 = v174 > 0;
                    ReadyNotification.Visible = v175;

                    if v175 then
                        local v176 = tostring(v174);
                        v172.Text = v176;
                        v173.Text = v176;
                    end;
                end;
            end;

            if u4[i] then
                local v177 = u3[i];

                if v177 ~= nil then
                    u3[i] = nil;
                    GrowingEggListRow.Destroy(v177);
                end;
            else
                v159[i] = true;
                local v178 = u3[i];

                if v178 == nil then
                    local v179 = GrowingEggListRow.Mount(Template, ScrollingFrame, i, requestGrow, requestHatch);
                    v179.Record = v;
                    u3[i] = v179;
                    updateRow(v179);
                else
                    v178.Record = v;
                    updateRow(v178);
                end;
            end;
        end;
    end;

    for i in pairs(u3) do
        if not v159[i] then
            local v180 = u3[i];

            if v180 ~= nil then
                u3[i] = nil;
                GrowingEggListRow.Destroy(v180);
            end;
        end;
    end;

    for i in pairs(u5) do
        if not v158[i] then
            if u7[i] then
                u7[i] = nil;
                u9 = math.max(u9 - 1, 0);
                local v181 = TextLabel;
                local v182 = Shadow;
                local v183 = u9;
                local v184 = v183 > 0;
                Notification.Visible = v184;

                if v184 then
                    local v185 = tostring(v183);
                    v181.Text = v185;
                    v182.Text = v185;
                end;
            end;

            if u8[i] then
                u8[i] = nil;
                u10 = math.max(u10 - 1, 0);
                local v186 = TextLabel2;
                local v187 = Shadow2;
                local v188 = u10;
                local v189 = v188 > 0;
                ReadyNotification.Visible = v189;

                if v189 then
                    local v190 = tostring(v188);
                    v186.Text = v190;
                    v187.Text = v190;
                end;
            end;

            u5[i] = nil;
            u6[i] = nil;
            u4[i] = nil;
        end;
    end;

    relayoutRows();
end;

local function updateVisibleRows() -- Line: 431
    -- upvalues: Workspace (copy), u11 (ref), AreaEggResetTimeUtil (copy), NightImage (copy), NightText (copy), u3 (copy), u6 (copy), EggItemUtil (copy), LocalPlayer (copy), u1 (copy), u8 (copy), u10 (ref), ReadyNotification (copy), TextLabel2 (copy), Shadow2 (copy), updateRow (copy), relayoutRows (copy)
    local v191 = Workspace:GetServerTimeNow();

    if v191 - u11 < 0.25 then
        return;
    end;

    u11 = v191;
    local v192 = AreaEggResetTimeUtil.IsNight(v191);
    NightImage.Visible = v192;
    NightText.Visible = v192;
    local v193 = false;

    for _, v in pairs(u3) do
        local v194 = u6[v.Uid] == true;
        local Uid = v.Uid;
        local Record = v.Record;
        local v195 = Workspace:GetServerTimeNow();
        local v196 = EggItemUtil.GetGrowthAlpha(Record, v195, Record.GrowthSpeedMultiplier, EggItemUtil.GetCurrentNightGrowthCreditSeconds(Record, v195, Record.GrowthSpeedMultiplier), LocalPlayer) >= 1;

        if v196 and not u6[Uid] then
            u6[Uid] = true;

            if not (u1.Enabled or u8[Uid]) then
                u8[Uid] = true;
                u10 = u10 + 1;
                local v197 = TextLabel2;
                local v198 = Shadow2;
                local v199 = u10;
                local v200 = v199 > 0;
                ReadyNotification.Visible = v200;

                if v200 then
                    local v201 = tostring(v199);
                    v197.Text = v201;
                    v198.Text = v201;
                end;
            end;
        elseif not v196 and u6[Uid] then
            u6[Uid] = nil;

            if u8[Uid] then
                u8[Uid] = nil;
                u10 = math.max(u10 - 1, 0);
                local v202 = TextLabel2;
                local v203 = Shadow2;
                local v204 = u10;
                local v205 = v204 > 0;
                ReadyNotification.Visible = v205;

                if v205 then
                    local v206 = tostring(v204);
                    v202.Text = v206;
                    v203.Text = v206;
                end;
            end;
        end;

        v193 = v196 ~= v194 and true or v193;
        updateRow(v);
    end;

    if v193 then
        relayoutRows();
    end;
end;

Template.Visible = false;
u1.Enabled = false;
GrowingEggs.Visible = true;
local v207 = u9;
local v208 = v207 > 0;
Notification.Visible = v208;

if v208 then
    local v209 = tostring(v207);
    TextLabel.Text = v209;
    Shadow.Text = v209;
end;

local v210 = u10;
local v211 = v210 > 0;
ReadyNotification.Visible = v211;

if v211 then
    local v212 = tostring(v210);
    TextLabel2.Text = v212;
    Shadow2.Text = v212;
end;

local v213 = AreaEggResetTimeUtil.IsNight(Workspace:GetServerTimeNow());
NightImage.Visible = v213;
NightText.Visible = v213;
refreshRows(false, true);
GUI.ButtonActivated(GrowingEggs, function() -- Line: 468
    -- upvalues: u1 (copy), GrowingEggs (copy), u9 (ref), u7 (copy), Notification (copy), TextLabel (copy), Shadow (copy), u10 (ref), u8 (copy), ReadyNotification (copy), TextLabel2 (copy), Shadow2 (copy), refreshRows (copy)
    u1.Enabled = true;
    GrowingEggs.Visible = false;
    u9 = 0;
    table.clear(u7);
    local v214 = TextLabel;
    local v215 = Shadow;
    local v216 = u9;
    local v217 = v216 > 0;
    Notification.Visible = v217;

    if v217 then
        local v218 = tostring(v216);
        v214.Text = v218;
        v215.Text = v218;
    end;

    u10 = 0;
    table.clear(u8);
    local v219 = TextLabel2;
    local v220 = Shadow2;
    local v221 = u10;
    local v222 = v221 > 0;
    ReadyNotification.Visible = v222;

    if v222 then
        local v223 = tostring(v221);
        v219.Text = v223;
        v220.Text = v223;
    end;

    refreshRows(true, true);
end);
GUI.ButtonActivated(Close, function() -- Line: 474
    -- upvalues: u1 (copy), GrowingEggs (copy)
    u1.Enabled = false;
    GrowingEggs.Visible = true;
end);
GUI.ButtonActivated(GrowAll, requestGrowAll);
EggCmds.RuntimeSnapshotUpdated:Connect(function() -- Line: 478
    -- upvalues: refreshRows (copy)
    refreshRows(true, true);
end);
EggCmds.RuntimeOwnerUpdated:Connect(function(p224) -- Line: 481
    -- upvalues: LocalPlayer (copy), refreshRows (copy)
    if p224 == LocalPlayer.UserId then
        refreshRows(true, true);
    end;
end);
EggCmds.RuntimeOwnerCleared:Connect(function(p225) -- Line: 486
    -- upvalues: LocalPlayer (copy), u3 (copy), GrowingEggListRow (copy), u4 (copy), u5 (copy), u6 (copy), u9 (ref), u7 (copy), Notification (copy), TextLabel (copy), Shadow (copy), u10 (ref), u8 (copy), ReadyNotification (copy), TextLabel2 (copy), Shadow2 (copy)
    if p225 ~= LocalPlayer.UserId then
        return;
    end;

    for i in pairs(u3) do
        local v226 = u3[i];

        if v226 ~= nil then
            u3[i] = nil;
            GrowingEggListRow.Destroy(v226);
        end;
    end;

    table.clear(u4);
    table.clear(u5);
    table.clear(u6);
    u9 = 0;
    table.clear(u7);
    local v227 = TextLabel;
    local v228 = Shadow;
    local v229 = u9;
    local v230 = v229 > 0;
    Notification.Visible = v230;

    if v230 then
        local v231 = tostring(v229);
        v227.Text = v231;
        v228.Text = v231;
    end;

    u10 = 0;
    table.clear(u8);
    local v232 = TextLabel2;
    local v233 = Shadow2;
    local v234 = u10;
    local v235 = v234 > 0;
    ReadyNotification.Visible = v235;

    if v235 then
        local v236 = tostring(v234);
        v232.Text = v236;
        v233.Text = v236;
    end;
end);
PlacedEggRenderer.LocalEggHatchStarted:Connect(removeHatchingRow);
RunService.Heartbeat:Connect(updateVisibleRows);