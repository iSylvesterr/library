-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local AssetCmds = require(ReplicatedStorage.Library.Client.AssetCmds);
local Assets = require(ReplicatedStorage.Directory.Assets);
local AssetGenerationUtil = require(ReplicatedStorage.Library.Util.AssetGenerationUtil);
local AssetItemSerialization = require(ReplicatedStorage.Library.Util.AssetItemSerialization);
local BaseUpgradeClient = require(ReplicatedStorage.Library.Client.BaseUpgradeClient);
local Bases = require(ReplicatedStorage.Directory.Bases);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local ConsoleCmds = require(ReplicatedStorage.Library.Client.ConsoleCmds);
local Simple = require(ReplicatedStorage.Library.Modules.FormatNumber.Simple);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Message = require(ReplicatedStorage.Library.Client.NotificationCmds.Message);
local PetPenCapacityGuidanceController = require(script.PetPenCapacityGuidanceController);
local Save = require(ReplicatedStorage.Library.Client.Save);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local u1 = Color3.fromRGB(255, 70, 70);
local u2 = Color3.fromRGB(85, 255, 85);
local u3 = Color3.new(0.760784, 0, 0);
local LocalPlayer = Players.LocalPlayer;
local u4 = GUI.PetList();
local v5 = GUI.SideButtons();
local Frame = u4.Frame;
local TextLabel = Frame.Header.TextLabel;
local TextLabel2 = TextLabel.TextLabel;
local MaxSlot = Frame.Header.MaxSlot;
local TextLabel3 = MaxSlot.Purchase.TextLabel;
local TextLabel4 = TextLabel3.TextLabel;
local ScrollingFrame = Frame.Notepad.ScrollingFrame;
local Template = ScrollingFrame.Template;
local Close = Frame.Close;
local EquipBest = Frame.EquipBest;
local Pets = v5.Tabs.Pets;
local BackgroundColor3 = MaxSlot.BackgroundColor3;
local u6 = MaxSlot:FindFirstChildOfClass("UIGradient");
local u7;

if u6 == nil then
    u7 = false;
else
    u7 = u6.Enabled;
end;

local u8 = Trove.new();
local u9 = 0;
local u10 = false;
local u11 = 0;
local v12 = u4:IsA("ScreenGui");
assert(v12, "PlayerGui.PetList must be a ScreenGui");
local v13 = Frame:IsA("GuiObject");
assert(v13, "PetList.Frame must be a GuiObject");
local v14 = TextLabel:IsA("TextLabel");
assert(v14, "PetList.Frame.Header.TextLabel must be a TextLabel");
local v15 = TextLabel2:IsA("TextLabel");
assert(v15, "PetList.Frame.Header.TextLabel.TextLabel must be a TextLabel");
local v16 = MaxSlot:IsA("GuiButton");
assert(v16, "PetList.Frame.Header.MaxSlot must be a GuiButton");
local v17 = TextLabel3:IsA("TextLabel");
assert(v17, "PetList.Frame.Header.MaxSlot.Purchase.TextLabel must be a TextLabel");
local v18 = TextLabel4:IsA("TextLabel");
assert(v18, "PetList.Frame.Header.MaxSlot.Purchase.TextLabel.TextLabel must be a TextLabel");
local v19 = ScrollingFrame:IsA("ScrollingFrame");
assert(v19, "PetList.Frame.Notepad.ScrollingFrame must be a ScrollingFrame");
local v20 = Template:IsA("GuiObject");
assert(v20, "PetList.Frame.Notepad.ScrollingFrame.Template must be a GuiObject");
local v21 = Close:IsA("GuiButton");
assert(v21, "PetList.Frame.Close must be a GuiButton");
local v22 = EquipBest:IsA("GuiButton");
assert(v22, "PetList.Frame.EquipBest.TextButton must be a GuiButton");
local v23 = Pets:IsA("GuiButton");
assert(v23, "Elements.Tabs.Pets must be a GuiButton");
MaxSlot.AutoButtonColor = false;
ConsoleCmds.RegisterCloseButton(Close);

local function setOpen(p24) -- Line: 122
    -- upvalues: u4 (copy), Pets (copy)
    u4.Enabled = p24;
    Pets.Visible = not p24;
end;

local function getCapacity(p25) -- Line: 127
    -- upvalues: Bases (copy)
    local v26;

    if p25 == nil then
        v26 = nil;
    else
        v26 = p25.BaseUpgradeLevel;
    end;

    return Bases.GetAssetEquipCapacity(v26);
end;

local function setTextWithShadow(p27, p28, p29) -- Line: 131
    p27.Text = p29;
    p28.Text = p29;
end;

local function formatDisplayNameWithRate(p30) -- Line: 136
    -- upvalues: Simple (copy)
    return p30.DisplayName .. " ($" .. Simple.FormatCompact(p30.Rate, ".#") .. "/s)";
end;

local function updateHeader(p31, p32) -- Line: 140
    -- upvalues: Bases (copy), TextLabel (copy), TextLabel2 (copy), BaseUpgradeClient (copy), Simple (copy), TextLabel3 (copy), TextLabel4 (copy), MaxSlot (copy), BackgroundColor3 (copy), u3 (copy), u6 (copy), u7 (copy)
    local v33;

    if p31 == nil then
        v33 = nil;
    else
        v33 = p31.BaseUpgradeLevel;
    end;

    local v34 = Bases.GetAssetEquipCapacity(v33);
    local v35 = `{p32}/{v34} Active`;
    TextLabel.Text = v35;
    TextLabel2.Text = v35;
    local v36;

    if p31 == nil then
        v36 = nil;
    else
        local _, v37 = BaseUpgradeClient.GetNextConfig(p31);

        if v37 == nil then
            v36 = nil;
        else
            v36 = v37.Cost;
        end;
    end;

    local v38 = v36 == nil and "MAX EQUIP" or `+1 EQUIP [${Simple.FormatCompact(math.floor(v36), ".#")}]`;
    TextLabel3.Text = v38;
    TextLabel4.Text = v38;
    MaxSlot.Active = v36 ~= nil;
    local v39;

    if v36 == nil or p31 == nil then
        v39 = false;
    else
        v39 = v36 <= p31.Money;
    end;

    local v40;

    if v39 then
        v40 = BackgroundColor3;
    else
        v40 = u3;
    end;

    MaxSlot.BackgroundColor3 = v40;

    if u6 ~= nil then
        if v39 then
            v39 = u7;
        end;

        u6.Enabled = v39;
    end;
end;

local function compareEntries(p41, p42) -- Line: 161
    if p41.RarityNumber ~= p42.RarityNumber then
        return p41.RarityNumber > p42.RarityNumber;
    end;

    if p41.Rate == p42.Rate then
        return p41.UID < p42.UID;
    end;

    return p41.Rate > p42.Rate;
end;

local function buildEntries(p43) -- Line: 171
    -- upvalues: AssetItemSerialization (copy), Assets (copy), AssetGenerationUtil (copy), compareEntries (copy)
    if p43 == nil then
        return {};
    end;

    local v44 = {};

    for _, v in ipairs(p43.EquippedAssets) do
        local v45 = p43.Inventory[v];

        if v45 ~= nil then
            local v46 = AssetItemSerialization.Deserialize(v45);
            local v47 = Assets.Directory[v46.Category];
            local Rarity = v47.Rarity;
            local v48 = {
                UID = v
            };
            local v49;

            if v47.DisplayName == "" then
                v49 = v46.Category;
            else
                v49 = v47.DisplayName;
            end;

            v48.DisplayName = v49;
            v48.Icon = v47.Icon;
            v48.Rate = AssetGenerationUtil.GetRate(v46, p43.Rebirth, p43.Gamepasses, p43.Products);
            v48.RarityNumber = Rarity.RarityNumber;
            v48.RarityGradient = Rarity.Gradient;
            table.insert(v44, v48);
        end;
    end;

    table.sort(v44, compareEntries);

    return v44;
end;

local function requestUnequip(p50) -- Line: 200
    -- upvalues: AssetCmds (copy), Message (copy), u1 (copy)
    local v51, v52 = AssetCmds.RequestUnequipAsset(p50);

    if not v51 and v52 ~= nil then
        Message.Bottom({
            Time = 2,
            PreventDuplicateText = true,
            Message = v52,
            Color = u1
        });
    end;
end;

local function mountRow(u53, p54) -- Line: 212
    -- upvalues: Trove (copy), u8 (copy), Template (copy), Simple (copy), AssetCmds (copy), Message (copy), u1 (copy), ScrollingFrame (copy)
    local v55 = Trove.new();
    u8:Add(v55);
    local v56 = Template:Clone();
    v56.Name = `Pet_{u53.UID}`;
    v56.LayoutOrder = p54;
    v56.Visible = true;
    v56:SetAttribute("PetListRowClone", true);
    v55:Add(v56);
    local Main_Frame = v56.Main_Frame;
    local TextLabel5 = Main_Frame.TextLabel;
    local TextLabel6 = TextLabel5.TextLabel;
    local PetImage = Main_Frame.PetImage;
    local Unequip = Main_Frame.Unequip;

    if u53.RarityGradient ~= nil then
        u53.RarityGradient:Clone().Parent = TextLabel6;
    end;

    local v57 = u53.DisplayName .. " ($" .. Simple.FormatCompact(u53.Rate, ".#") .. "/s)";
    TextLabel5.Text = v57;
    TextLabel6.Text = v57;
    PetImage.Image = u53.Icon or "";
    v55:Connect(Unequip.Activated, function() -- Line: 235
        -- upvalues: u53 (copy), AssetCmds (ref), Message (ref), u1 (ref)
        local v58, v59 = AssetCmds.RequestUnequipAsset(u53.UID);

        if not v58 and v59 ~= nil then
            Message.Bottom({
                Time = 2,
                PreventDuplicateText = true,
                Message = v59,
                Color = u1
            });
        end;
    end);
    v56.Parent = ScrollingFrame;
end;

local function refresh() -- Line: 242
    -- upvalues: u8 (copy), ScrollingFrame (copy), Save (copy), LocalPlayer (copy), buildEntries (copy), u11 (ref), mountRow (copy), updateHeader (copy)
    u8:Clean();

    for _, child in ipairs(ScrollingFrame:GetChildren()) do
        if child:GetAttribute("PetListRowClone") == true then
            child:Destroy();
        end;
    end;

    local v60 = Save.Get(LocalPlayer, false);
    local v61 = buildEntries(v60);
    u11 = #v61;

    for i, v in ipairs(v61) do
        mountRow(v, i);
    end;

    updateHeader(v60, u11);
end;

local function refreshUpgradeHeader() -- Line: 260
    -- upvalues: updateHeader (copy), Save (copy), LocalPlayer (copy), u11 (ref)
    updateHeader(Save.Get(LocalPlayer, false), u11);
end;

local function showEquipBestDebounceNotification() -- Line: 264
    -- upvalues: Message (copy)
    Message.Bottom({
        Message = "Please wait a bit before equipping bests again!",
        Time = 2,
        PreventDuplicateText = true,
        Color = Color3.fromRGB(255, 170, 0)
    });
end;

local function requestEquipBest() -- Line: 273
    -- upvalues: u10 (ref), u9 (ref), Message (copy), Network (copy), Constants (copy), refresh (copy), u1 (copy)
    local v62 = workspace:GetServerTimeNow();

    if u10 or v62 - u9 < 5 then
        Message.Bottom({
            Message = "Please wait a bit before equipping bests again!",
            Time = 2,
            PreventDuplicateText = true,
            Color = Color3.fromRGB(255, 170, 0)
        });

        return;
    end;

    u9 = v62;
    u10 = true;
    local v63, v64 = Network.Invoke(Constants.NETWORK_MAP.Backpack.EQUIP_BEST);
    u10 = false;

    if v63 == true then
        refresh();

        return;
    end;

    Message.Bottom({
        Time = 2,
        PreventDuplicateText = true,
        Message = typeof(v64) ~= "string" and "Please wait a bit before equipping bests again!" or v64,
        Color = u1
    });
end;

Template.Visible = false;
u4.Enabled = false;
Pets.Visible = true;
refresh();
PetPenCapacityGuidanceController.Initialize();
GUI.ButtonActivated(Pets, function() -- Line: 310
    -- upvalues: PetPenCapacityGuidanceController (copy), u4 (copy), Pets (copy), refresh (copy)
    PetPenCapacityGuidanceController.AcknowledgePetsBadge();
    u4.Enabled = true;
    Pets.Visible = false;
    refresh();
end);
GUI.ButtonActivated(Close, function() -- Line: 315
    -- upvalues: u4 (copy), Pets (copy)
    u4.Enabled = false;
    Pets.Visible = true;
end);
GUI.ButtonActivated(MaxSlot, function() -- Line: 297, Name: requestBaseUpgrade
    -- upvalues: BaseUpgradeClient (copy)
    BaseUpgradeClient.RequestCashUpgrade();
end);
GUI.ButtonActivated(EquipBest, function() -- Line: 319
    -- upvalues: PetPenCapacityGuidanceController (copy), requestEquipBest (copy)
    PetPenCapacityGuidanceController.AcknowledgeEquipBestBadge();
    requestEquipBest();
end);
Save.ConnectForDataChanged({ "Inventory", "EquippedAssets", "BaseUpgradeLevel", "Rebirth", "Gamepasses", "Products" }, refresh);
Save.GetStatChangedSignal("Money"):Connect(refreshUpgradeHeader);
AssetCmds.RuntimeSnapshotUpdated:Connect(refresh);
AssetCmds.RuntimeOwnerUpdated:Connect(function(p65) -- Line: 330
    -- upvalues: LocalPlayer (copy), refresh (copy)
    if p65 == LocalPlayer.UserId then
        refresh();
    end;
end);
AssetCmds.RuntimeOwnerCleared:Connect(function(p66) -- Line: 335
    -- upvalues: LocalPlayer (copy), refresh (copy)
    if p66 == LocalPlayer.UserId then
        refresh();
    end;
end);
Network.Fired(Constants.NETWORK_MAP.Plots.ON_BASE_UPGRADED):Connect(function() -- Line: 340
    -- upvalues: Message (copy), u2 (copy), refresh (copy)
    Message.Bottom({
        Message = "Successfully upgraded your base!",
        Time = 0.7,
        PreventDuplicateText = true,
        Color = u2
    });
    refresh();
end);