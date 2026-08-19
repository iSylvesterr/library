-- Decompiled with Potassium's decompiler.

if not game:IsLoaded() then
    game.Loaded:Wait();
end;

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local GuiService = game:GetService("GuiService");
local TweenService = game:GetService("TweenService");
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local PlotCmds = require(ReplicatedStorage.Library.Client.PlotCmds);
local TabController = require(ReplicatedStorage.Library.Client.TabController);
local Message = require(ReplicatedStorage.Library.Client.NotificationCmds.Message);
local AutoGridLayout = require(ReplicatedStorage.Library.Client.AutoGridLayout);
local Areas = require(ReplicatedStorage.Directory.Areas);
RarityDirectory = require(ReplicatedStorage.Directory.Rarity).Rarities;
MutationHandler = require(ReplicatedStorage.Library.Modules.Mutations);
InfoOverlay = require(ReplicatedStorage.Library.Client.InfoOverlay);
Variables = require(ReplicatedStorage.Library.Variables);
ActionPromptCmds = require(ReplicatedStorage.Library.Client.ActionPromptCmds);
PlatformSignal = require(ReplicatedStorage.Library.Signal);
ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
SimpleNumber = require(ReplicatedStorage.Library.Modules.FormatNumber.Simple);
local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds);
local EggItemUtil = require(ReplicatedStorage.Library.Util.EggItemUtil);
local AssetGenerationUtil = require(ReplicatedStorage.Library.Util.AssetGenerationUtil);
local AssetIconShape = require(ReplicatedStorage.Library.Client.UI.AssetIconShape);
local ItemDisplay = require(ReplicatedStorage.Library.Modules.ItemDisplay);
local ToolGameplayGuard = require(ReplicatedStorage.Library.Client.ToolGameplayGuard);
local AssetItemUtil = require(ReplicatedStorage.Library.Util.AssetItemUtil);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local PreloadAssets = require(ReplicatedStorage.Library.Functions.PreloadAssets);
local v1 = { {
        Name = "Pets",
        Image = "rbxassetid://93714449004895",
        Tags = { "Asset" }
    }, {
        Name = "Eggs",
        Image = "rbxassetid://116524274262912",
        Tags = { "AssetEgg", "PetEgg" }
    } };
local u2 = v1[1] and (v1[1].Name or "Pets") or "Pets";
local u3 = GuiService:IsTenFootInterface() or RunService:IsStudio();
local u4 = u2;
local u5 = {};
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;

for _, v in v1 do
    u5[v.Name] = v;
end;

function IsOfCategory(p11)
    -- upvalues: u5 (copy), u2 (ref)
    if not p11 then
        return false;
    end;

    local v12 = u5[u2];

    if not (v12 and v12.Tags) then
        return false;
    end;

    for _, v in v12.Tags do
        if p11:GetAttribute("ItemType") == v then
            return true;
        end;
    end;

    return false;
end;

function GetCategory(p13)
    -- upvalues: u5 (copy), u4 (copy)
    for i, v in u5 do
        if v.Tags then
            for _, v2 in v.Tags do
                if p13:GetAttribute("ItemType") == v2 then
                    return i;
                end;
            end;
        end;
    end;

    return u4;
end;

local u14 = {
    OpenClose = nil,
    IsOpen = false,
    ModuleName = "Backpack",
    KeepVRTopbarOpen = true,
    VRIsExclusive = true,
    VRClosesNonExclusive = true,
    StartFuseSelection = nil,
    EndFuseSelection = nil,
    IsFuseSelectionActive = nil,
    StateChanged = Instance.new("BindableEvent")
};
TextSizeAttribute = script:GetAttribute("TextSize");
_BackgroundTransparencyAttribute = script:GetAttribute("BackgroundTransparency");
BackgroundColorAttribute = script:GetAttribute("BackgroundColor");
DraggableColorAttribute = script:GetAttribute("DraggableColor");
EquippedColorAttribute = script:GetAttribute("EquippedColor");
SlotLockedTransparencyAttribute = script:GetAttribute("SlotLockedTransparency");
BorderColorAttribute = script:GetAttribute("BorderColor");
ToggleHotkeys = { Enum.KeyCode.Backquote, Enum.KeyCode.ButtonSelect };
EmptySlotsAttribute = script:GetAttribute("EmptySlots");
_SearchBoxColorAttribute = script:GetAttribute("SearchBoxColor");
_SearchBoxTransparencyAttribute = script:GetAttribute("SearchBoxTransparency");
ApiEvent = ReplicatedStorage:FindFirstChild("Api") or script:WaitForChild("Api");
ApiEvent.Parent = ReplicatedStorage;
SelectedSlot = nil;
BackpackEnabled = true;
local u15 = nil;
ActiveFuseSelectionState = nil;

function GetScreenResolution()
    local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui);
    local Frame = Instance.new("Frame", ScreenGui);
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.new(1, 0, 1, 0);
    local AbsoluteSize = Frame.AbsoluteSize;
    ScreenGui:Destroy();

    return AbsoluteSize;
end;

local Value = Enum.KeyCode.Zero.Value;
local Value2 = Enum.KeyCode.Backspace.Value;
local u16 = {
    [Enum.UserInputType.Gamepad1] = true,
    [Enum.UserInputType.Gamepad2] = true,
    [Enum.UserInputType.Gamepad3] = true,
    [Enum.UserInputType.Gamepad4] = true,
    [Enum.UserInputType.Gamepad5] = true,
    [Enum.UserInputType.Gamepad6] = true,
    [Enum.UserInputType.Gamepad7] = true,
    [Enum.UserInputType.Gamepad8] = true
};
UserInputService = game:GetService("UserInputService");
Players = game:GetService("Players");
PlayerGui = Players.LocalPlayer.PlayerGui;
BackpackGui = PlayerGui:WaitForChild("BackpackGui");
ContextActionService = game:GetService("ContextActionService");
VRService = game:GetService("VRService");
Utility = require(script.Utility);
require(script.GameTranslator);
TopBarPlus = require(ReplicatedStorage.Library.Modules.Packages.TopBarPlus);
CoreCall = require(ReplicatedStorage.Library.Functions.CoreCall);
Save = require(ReplicatedStorage.Library.Client.Save);
Network = require(ReplicatedStorage.Library.Client.Network);
local AssetItemSerialization = require(ReplicatedStorage.Library.Util.AssetItemSerialization);
AssetDirectoryModule = require(ReplicatedStorage.Directory.Assets);
AssetDirectory = AssetDirectoryModule.Directory;
BaseAssetConfig = require(ReplicatedStorage.Directory.Assets.BaseConfigs.Default);
local Gears = require(ReplicatedStorage.Directory.Gears);
Lock = require(ReplicatedStorage.Library.Functions.Lock);
Audio = require(ReplicatedStorage.Library.Audio);
Constants = require(ReplicatedStorage.Library.Globals.Constants);
local AssetCmds = require(ReplicatedStorage.Library.Client.AssetCmds);
local u17 = nil;
local u18 = false;
CloseButton = nil;
InventoryStroke = nil;
InventoryStrokeDefaultColor = nil;
FuseSelectionVisualTrove = nil;
FUSE_SELECTION_ASSET_CATEGORY_NAME = "Pets";
FUSE_SELECTION_BACKGROUND_COLOR = Color3.fromRGB(0, 255, 255);
FUSE_SELECTION_STROKE_COLOR = Color3.fromRGB(0, 183, 186);
FUSE_SELECTION_BACKGROUND_TRANSPARENCY = 0;
local u19 = nil;

local function isBackpackEquipInteractionBlocked() -- Line: 214
    return not BackpackEnabled or (not BackpackGui.Enabled or Variables.Locks.HideUI:IsLocked());
end;

local u20 = GuiService:IsTenFootInterface();
local u21;

if u20 then
    TextSizeAttribute = 24;
    u21 = 100;
else
    u21 = 60;
end;

local u22 = false;
local v23 = GetScreenResolution();
local v24 = UserInputService.TouchEnabled and v23.X < 1024;
local u25 = u21 * 1.5;
local LocalPlayer = Players.LocalPlayer;
local u26 = Color3.fromRGB(79, 63, 0);
local v27 = {
    {
        ResolutionThreshold = (1 / 0),
        ScalePaddingOffset = true,
        PerRow = v24 and 5 or 6,
        Padding = UDim2.new(0.02, 0, 0.04, 0)
    }
};
local u28 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
local u29 = u28:FindFirstChildOfClass("Humanoid");
local Backpack = LocalPlayer:WaitForChild("Backpack");
local u30 = TopBarPlus.new();
u30:setImage("rbxasset://textures/ui/TopBar/inventoryOff.png", "deselected");
u30:setImage("rbxasset://textures/ui/TopBar/inventoryOn.png", "selected");
local u31 = nil;
local u32 = nil;
local u33 = nil;
local u34 = nil;
local u35 = nil;
local u36 = nil;
local u37 = nil;
local u38 = nil;
local u39 = nil;
local u40 = nil;
local u41 = nil;
local u42 = nil;
local u43 = nil;
local u44 = nil;
local u45 = nil;
local u46 = nil;

for _, v in ToggleHotkeys do
    u30:bindToggleKey(v);
end;

u30:setName("InventoryIcon");
u30:setImageScale(1.12);
u30:setOrder(-5);
u30:setCaption("Toggle the backpack.");
u30.deselectWhenOtherIconSelected = false;
local u47 = {};
local u48 = nil;
local u49 = {};
local u50 = {};
local u51 = {};
local u52 = 0;
local u53 = false;
local u54 = false;
local u55 = false;
local u56 = false;
local u57 = false;
local u58 = {};
local u59 = false;
local u60 = 0;
local VREnabled = VRService.VREnabled;
local u61 = VREnabled and EmptySlotsAttribute or (v24 and 5 or 10);
local u62 = VREnabled and 3 or (v24 and 2 or 4);
local ActiveAssets = Constants.NETWORK_MAP.ActiveAssets;
local AssetInventory = Constants.NETWORK_MAP.AssetInventory;
local u63 = Lock();
local u64 = Lock();
local u65 = nil;
local u66 = {};
local u67 = {};
local u68 = {};
local u69 = {};
local u70 = {};
local u71 = {};
local u72 = false;
local u73 = {};
local u74 = {};
local u75 = {};
local u76 = {};
local u77 = {};
local u78 = false;
local u79 = nil;
local Backpack2 = Constants.NETWORK_MAP.Backpack;
local u80 = nil;
local u81 = nil;
local u82 = nil;
local u83 = Lock();
local u84 = 0;
local u85 = false;
local u86 = false;
local u87 = true;
local u88 = false;
local u89 = false;
local u90 = 0;
local Frame = GUI.AutoSell():WaitForChild("Frame"):WaitForChild("Frame");
local u91 = {};
local u92 = {};
local u93 = false;
local Template = Frame.UIGridLayout.Template;
local u94 = nil;

function invokeBackpack(u95, ...)
    local u96 = { ... };
    local success, result = pcall(function() -- Line: 348
        -- upvalues: u95 (copy), u96 (copy)
        return { Network.Invoke(u95, unpack(u96)) };
    end);

    if success then
        return result;
    end;

    warn((`[Backpack] Failed to invoke '{u95}': {result}`));

    return nil;
end;

function isLocalPlayerWithinOwnPlotBounds()
    -- upvalues: PlotCmds (copy), u28 (ref), LocalPlayer (ref)
    local v97 = PlotCmds.GetPlotData();

    if not v97 then
        return false;
    end;

    local v98 = u28 or LocalPlayer.Character;

    if not v98 then
        return false;
    end;

    local HumanoidRootPart = v98:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return false;
    end;

    local v99, v100 = v97.PlotFolder:GetBoundingBox();
    local v101 = v99:PointToObjectSpace(HumanoidRootPart.Position);
    local v102 = v100 * 0.5;
    local v103;

    if math.abs(v101.X) <= v102.X then
        v103 = math.abs(v101.Z) <= v102.Z;
    else
        v103 = false;
    end;

    return v103;
end;

function updateEquipBestButtonVisibility()
    -- upvalues: u82 (ref)
    if not u82 then
        return;
    end;

    u82.Visible = false;
end;

function requestEquipBestStatusRefresh(p104)
    -- upvalues: u82 (ref), u89 (ref), u88 (ref), u90 (ref), Backpack2 (copy), u85 (ref), u86 (ref), u87 (ref)
    if not (u82 and u89) then
        updateEquipBestButtonVisibility();

        return;
    end;

    if u88 then
        return;
    end;

    local v105 = workspace:GetServerTimeNow();

    if p104 ~= true and v105 - u90 < 0.5 then
        return;
    end;

    u90 = v105;
    u88 = true;
    task.spawn(function() -- Line: 407
        -- upvalues: Backpack2 (ref), u88 (ref), u85 (ref), u86 (ref), u87 (ref)
        local v106 = invokeBackpack(Backpack2.GET_EQUIP_BEST_STATUS);
        u88 = false;

        if not v106 then
            updateEquipBestButtonVisibility();

            return;
        end;

        u85 = v106[1] == true;
        u86 = true;
        u87 = false;
        updateEquipBestButtonVisibility();
    end);
end;

function invalidateEquipBestStatus(p107)
    -- upvalues: u87 (ref), u89 (ref)
    u87 = true;

    if u89 then
        requestEquipBestStatusRefresh(p107);

        return;
    end;

    updateEquipBestButtonVisibility();
end;

function showEquipBestDebounceNotification()
    -- upvalues: Message (copy)
    Message.Bottom({
        Message = "Please wait a bit before equipping bests again!",
        Time = 2,
        Color = Color3.fromRGB(255, 170, 0)
    });
end;

function requestEquipBest()
    -- upvalues: u84 (ref), u83 (copy), Backpack2 (copy)
    if workspace:GetServerTimeNow() - u84 < 5 then
        showEquipBestDebounceNotification();

        return;
    end;

    if not u83(function() -- Line: 447
        -- upvalues: u84 (ref), Backpack2 (ref)
        local v108 = workspace:GetServerTimeNow();

        if v108 - u84 < 5 then
            showEquipBestDebounceNotification();

            return;
        end;

        u84 = v108;
        local v109 = invokeBackpack(Backpack2.EQUIP_BEST);

        if not v109 then
            return;
        end;

        local v110 = v109[2];

        if v109[1] then
            invalidateEquipBestStatus(true);

            return;
        end;

        if v110 == "DEBOUNCE" or v110 == "LOCKED" then
            showEquipBestDebounceNotification();
        end;
    end) then
        showEquipBestDebounceNotification();
    end;
end;

function applyAutoSellSlot(p111, p112)
    -- upvalues: u91 (copy)
    local v113 = u91[p111];

    if not v113 then
        return;
    end;

    local SelectedGradient = v113.SelectedGradient;

    if SelectedGradient then
        SelectedGradient.Enabled = p112;
    end;

    local RarityGradient = v113.RarityGradient;

    if RarityGradient then
        RarityGradient.Enabled = not p112;
    end;
end;

function applyAutoSellMap(p114)
    -- upvalues: u92 (ref), u91 (copy)
    u92 = {};

    for i, v in pairs(p114) do
        if v then
            u92[i] = true;
        end;
    end;

    for i in pairs(u91) do
        applyAutoSellSlot(i, u92[i] == true);
    end;
end;

function serializeAutoSellState()
    -- upvalues: u92 (ref)
    local v115 = {};

    for i, v in pairs(u92) do
        if v then
            v115[i] = true;
        end;
    end;

    return v115;
end;

function pushAutoSellState()
    -- upvalues: Backpack2 (copy)
    local v116 = serializeAutoSellState();
    local v117 = invokeBackpack(Backpack2.SET_AUTO_SELL_STATE, v116);

    if not v117 then
        return false;
    end;

    local v118 = v117[2];

    if v117[1] then
        if typeof(v118) == "table" then
            applyAutoSellMap(v118);
        end;

        return true;
    end;

    if typeof(v118) == "string" then
        warn((`[Backpack] Failed to update auto-sell: {v118}`));
    end;

    return false;
end;

function buildAutoSellSlots(p119)
    -- upvalues: u91 (copy), Template (copy), u93 (ref), u92 (ref)
    local v120 = {};

    for _, v in pairs(AssetDirectory) do
        local Rarity = v.Rarity;

        if Rarity then
            local _id = Rarity._id;

            if typeof(_id) == "string" then
                v120[_id] = Rarity;
            end;
        end;
    end;

    local v121 = {};

    for _, v in pairs(v120) do
        table.insert(v121, v);
    end;

    table.sort(v121, function(p122, p123) -- Line: 558
        local v124 = typeof(p122.RarityNumber) == "number" and (p122.RarityNumber or 0) or 0;
        local v125 = typeof(p123.RarityNumber) == "number" and (p123.RarityNumber or 0) or 0;

        if v124 == v125 then
            return (typeof(p122.DisplayName) == "string" and p122.DisplayName or p122._id) < (typeof(p123.DisplayName) == "string" and p123.DisplayName or p123._id);
        end;

        return v124 < v125;
    end);

    for _, v in ipairs(v121) do
        local _id = v._id;

        if not u91[_id] then
            local v126 = Template:Clone();
            v126.Visible = true;
            v126.Name = _id;
            v126.LayoutOrder = typeof(v.RarityNumber) == "number" and (v.RarityNumber or 0) or 0;
            local TextButton = v126.TextButton;
            local Selected = TextButton.Selected;

            if Selected and Selected:IsA("UIGradient") then
                Selected.Enabled = false;
            else
                Selected = nil;
            end;

            local TextLabel = v126:FindFirstChild("TextLabel");

            if not (TextLabel and TextLabel:IsA("TextLabel")) then
                TextLabel = nil;
            end;

            if TextLabel then
                local DisplayName = v.DisplayName;

                if typeof(DisplayName) == "string" and DisplayName ~= "" then
                    TextLabel.Text = DisplayName;
                else
                    TextLabel.Text = _id;
                end;
            end;

            v126.Parent = p119;
            local Gradient = v.Gradient;
            local v127;

            if typeof(Gradient) == "Instance" then
                v127 = Gradient:Clone();
                v127.Name = "RarityGradient";
                v127.Parent = TextButton;
            else
                v127 = nil;
            end;

            for _, child in ipairs(TextButton:GetChildren()) do
                if child:IsA("UIGradient") then
                    if child == v127 then
                        child.Enabled = true;
                    else
                        child.Enabled = false;
                    end;
                end;
            end;

            u91[_id] = {
                Button = TextButton,
                SelectedGradient = Selected,
                RarityGradient = v127
            };
            ButtonFX(TextButton, nil, function() -- Line: 626
                -- upvalues: u93 (ref), u92 (ref), _id (copy)
                if u93 then
                    return;
                end;

                local v128 = u92[_id] == true;
                local v129 = not v128;
                u92[_id] = v129;
                applyAutoSellSlot(_id, v129);
                u93 = true;

                if not pushAutoSellState() then
                    u92[_id] = v128;
                    applyAutoSellSlot(_id, v128);
                end;

                u93 = false;
            end);
        end;
    end;
end;

function initializeAutoSellUI()
    -- upvalues: u80 (ref), TabController (copy), Backpack2 (copy), Frame (copy)
    ButtonFX(u80, nil, function() -- Line: 648
        -- upvalues: TabController (ref)
        TabController.ToggleTab("AutoSell");
    end);
    local v130 = {};
    local v131 = invokeBackpack(Backpack2.GET_AUTO_SELL_STATE);

    if v131 then
        local v132 = v131[1];

        if typeof(v132) == "table" then
            for i, v in pairs(v132) do
                if v then
                    v130[i] = true;
                end;
            end;
        end;
    end;

    buildAutoSellSlots(Frame);
    applyAutoSellMap(v130);
end;

function claimLowestEmptySlot(p133)
    -- upvalues: u48 (ref), u61 (copy), u47 (copy)
    local v134 = u48;

    if not v134 then
        return nil;
    end;

    if not canToolUseHotbarSlot(p133, v134.Index) then
        return nil;
    end;

    local v135 = nil;

    for i = 1, u61 do
        local v136 = u47[i];

        if v136 and (v136 ~= v134 and (not v136.Tool and (not v136.IsFakeSlot and canToolUseHotbarSlot(p133, i)))) then
            v135 = v136;
            break;
        end;
    end;

    u48 = v135;

    return v134;
end;

function getInsertableHotbarIndices(p137)
    -- upvalues: u61 (copy), u47 (copy)
    local v138 = {};

    for i = 1, u61 do
        local v139 = u47[i];

        if v139 and (not v139.IsFakeSlot and canToolUseHotbarSlot(p137, i)) then
            table.insert(v138, i);
        end;
    end;

    return v138;
end;

function insertToolIntoFrontHotbar(p140)
    -- upvalues: u47 (copy), u48 (ref)
    local v141 = getInsertableHotbarIndices(p140);
    local v142 = v141[1];

    if not v142 then
        return nil;
    end;

    local v143 = u47[v142];

    if not v143 then
        return nil;
    end;

    if v143.Tool and (getLockedHotbarSlotForTool(p140) == v142 and canToolUseHotbarSlot(v143.Tool, v142)) then
        return nil;
    end;

    local v144 = u48;
    local v145 = v144 and table.find(v141, v144.Index);

    if v145 then
        for i = v145, 2, -1 do
            local v146 = u47[v141[i]];
            local v147 = u47[v141[i - 1]];

            if v146 and v147 then
                v147:Swap(v146);
            end;
        end;

        v143:Fill(p140);

        return v143;
    end;

    local v148 = v141[#v141];

    if v148 then
        v148 = u47[v148];
    end;

    if v148 and v148.Tool then
        v148:MoveToInventory();
    end;

    for i = #v141, 2, -1 do
        local v149 = u47[v141[i]];
        local v150 = u47[v141[i - 1]];

        if v149 and v150 then
            v150:Swap(v149);
        end;
    end;

    v143:Fill(p140);

    return v143;
end;

function _getAssetUID(p151)
    if typeof(p151) == "table" and (p151.IsVirtualAsset or p151.IsVirtualEgg) then
        return p151.UID;
    end;

    if typeof(p151) == "Instance" then
        return p151:GetAttribute("UID");
    end;

    return nil;
end;

function getAttribute(p152, p153)
    if not p152 then
        return nil;
    end;

    if typeof(p152) == "table" and p152.GetAttribute then
        return p152:GetAttribute(p153);
    end;

    if typeof(p152) == "Instance" then
        return p152:GetAttribute(p153);
    end;

    return nil;
end;

function parseMutations(p154)
    if typeof(p154) == "table" then
        return table.clone(p154);
    end;

    if typeof(p154) ~= "string" then
        return {};
    end;

    local v155 = {};

    for i in string.gmatch(p154, "[^,]+") do
        local v156 = string.match(i, "^%s*(.-)%s*$");

        if v156 ~= "" then
            table.insert(v155, v156);
        end;
    end;

    return v155;
end;

function isAssetUIDFavorite(p157)
    -- upvalues: AssetItemSerialization (copy)
    if typeof(p157) ~= "string" or p157 == "" then
        return false;
    end;

    local v158 = Save.Get();

    if v158 then
        v158 = v158.Inventory;
    end;

    local v159;

    if typeof(v158) == "table" then
        v159 = v158[p157];
    else
        v159 = nil;
    end;

    if typeof(v159) == "table" then
        return AssetItemSerialization.Deserialize(v159).IsFavorite == true;
    end;

    return false;
end;

function isToolFavorite(p160)
    if not isAssetTool(p160) then
        return getAttribute(p160, "Favorite") == true;
    end;

    local v161 = getAttribute(p160, "Favorite");

    if typeof(v161) == "boolean" then
        return v161;
    end;

    local v162 = getAttribute(p160, "ItemData");

    return typeof(v162) == "table" and v162.IsFavorite == true and true or isAssetUIDFavorite(_getAssetUID(p160));
end;

function getAssetItemData(p163)
    local v164 = getAttribute(p163, "ItemData");

    if typeof(v164) == "table" then
        return v164;
    end;

    local v165 = getAttribute(p163, "Category");

    if not v165 then
        return nil;
    end;

    local v166 = getAttribute(p163, "Scale");

    return {
        Category = v165,
        Mutations = parseMutations(getAttribute(p163, "Mutations")),
        BaseMutation = getAttribute(p163, "BaseMutation"),
        Scale = typeof(v166) == "number" and v166 and v166 or 1,
        IsFavorite = isAssetUIDFavorite(_getAssetUID(p163))
    };
end;

function getAssetItemDisplayName(p167, p168)
    -- upvalues: ItemDisplay (copy)
    local v169 = typeof(p167) == "table";

    if v169 and (typeof(p167.Category) == "string" and AssetDirectory[p167.Category]) then
        return ItemDisplay.GetNameFromItemData(p167);
    end;

    local v170;

    if v169 then
        v170 = p167.DisplayName;
    else
        v170 = nil;
    end;

    local v171;

    if v169 then
        v171 = p167.Category;
    else
        v171 = nil;
    end;

    return v170 or p168 and p168.DisplayName or (v171 or "Asset");
end;

function getAssetItemDisplayNameWithVisualWeight(p172, p173)
    -- upvalues: AssetItemUtil (copy)
    return `{getAssetItemDisplayName(p172, p173)} ({AssetItemUtil.GetVisualWeightKgDisplay(p172)})`;
end;

function isAssetTool(p174)
    return getAttribute(p174, "ItemType") == "Asset";
end;

function getGearName(p175)
    local v176 = getAttribute(p175, "GearName");

    if typeof(v176) == "string" and v176 ~= "" then
        return v176;
    end;

    return nil;
end;

function getGearConfig(p177)
    -- upvalues: Gears (copy)
    local v178 = getGearName(p177);

    if v178 then
        return Gears.Directory[v178];
    end;

    return nil;
end;

function getGearUses(p179)
    local v180 = getAttribute(p179, "Uses");

    return typeof(v180) ~= "number" and 0 or math.max(v180, 0);
end;

function shouldDisplayGearUses(p181)
    local v182 = getGearConfig(p181);

    if not v182 then
        return false;
    end;

    local v183;

    if typeof(v182.ActiveDeploymentAttribute) == "string" then
        v183 = v182.ActiveDeploymentAttribute ~= "";
    else
        v183 = false;
    end;

    return v183;
end;

function getGearUsesText(p184)
    return `x{getGearUses(p184)}`;
end;

function getHotbarFillTool(p185)
    if typeof(p185) == "table" and (p185.IsVirtualAsset or p185.IsVirtualEgg) then
        return p185;
    end;

    return p185;
end;

function virtualAssetMatchesUID(p186, p187)
    if typeof(p186) == "table" and (p186.IsVirtualAsset and typeof(p187) == "string") then
        return p186.UID == p187;
    end;

    return false;
end;

function getVirtualAssetUID(p188)
    if typeof(p188) == "table" and p188.IsVirtualAsset then
        return p188.UID;
    end;

    return nil;
end;

function getVirtualEggUID(p189)
    if typeof(p189) == "table" and p189.IsVirtualEgg then
        return p189.UID;
    end;

    return nil;
end;

function virtualEggSlotMatchesUID(p190, p191)
    if p190 and not p190.IsDeleted then
        return getVirtualEggUID(p190.Tool) == p191;
    end;

    return false;
end;

function findVirtualEggSlotByUID(p192)
    -- upvalues: u47 (copy)
    for _, v in pairs(u47) do
        if virtualEggSlotMatchesUID(v, p192) then
            return v;
        end;
    end;

    return nil;
end;

function clearVirtualEggSlotsByUID(p193)
    -- upvalues: u47 (copy), u61 (copy)
    for i = #u47, 1, -1 do
        local v194 = u47[i];

        if virtualEggSlotMatchesUID(v194, p193) then
            v194:Clear();

            if u61 < v194.Index then
                v194:Delete();
            end;
        end;
    end;
end;

function clearDuplicateVirtualEggSlotsByUID(p195, p196)
    -- upvalues: u47 (copy), u61 (copy)
    for i = #u47, 1, -1 do
        local v197 = u47[i];

        if v197 ~= p196 and virtualEggSlotMatchesUID(v197, p195) then
            v197:Clear();

            if u61 < v197.Index then
                v197:Delete();
            end;
        end;
    end;
end;

function getRegisteredBackpackSlot(p198)
    -- upvalues: u66 (copy), u73 (copy), u49 (copy)
    local v199 = getVirtualAssetUID(p198);

    if v199 then
        return u66[v199];
    end;

    local v200 = getVirtualEggUID(p198);

    if v200 then
        return u73[v200];
    end;

    return u49[p198];
end;

function registeredSlotContainsTool(p201, p202)
    if not p201 or p201.IsDeleted then
        return false;
    end;

    local Tool = p201.Tool;
    local v203 = getVirtualAssetUID(p202);

    if v203 then
        return getVirtualAssetUID(Tool) == v203;
    end;

    local v204 = getVirtualEggUID(p202);

    if v204 then
        return getVirtualEggUID(Tool) == v204;
    end;

    return Tool == p202;
end;

function unregisterVirtualBackpackSlot(p205, p206)
    -- upvalues: u66 (copy), u67 (copy), u73 (copy), u74 (copy)
    local v207 = getVirtualAssetUID(p206);

    if v207 and u66[v207] == p205 then
        u66[v207] = nil;
    end;

    if v207 and u67[v207] == p206 then
        u67[v207] = nil;
    end;

    local v208 = getVirtualEggUID(p206);

    if v208 and u73[v208] == p205 then
        u73[v208] = nil;
    end;

    if v208 and u74[v208] == p206 then
        u74[v208] = nil;
    end;
end;

function unregisterBackpackSlotTool(p209, p210)
    -- upvalues: u49 (copy)
    unregisterVirtualBackpackSlot(p209, p210);

    if p210 and u49[p210] == p209 then
        u49[p210] = nil;
    end;
end;

function registerVirtualBackpackSlot(p211, p212)
    -- upvalues: u66 (copy), u67 (copy), u73 (copy), u74 (copy)
    local v213 = getVirtualAssetUID(p212);

    if v213 then
        u66[v213] = p211;
        u67[v213] = p212;
    end;

    local v214 = getVirtualEggUID(p212);

    if v214 then
        u73[v214] = p211;
        u74[v214] = p212;
    end;
end;

function createVirtualAsset(u215, p216)
    local Category = p216.Category;
    local v217 = AssetDirectory[Category] or BaseAssetConfig;
    local u218 = table.clone(p216);
    local u219 = getAssetItemDisplayName(u218, v217);

    return {
        IsVirtualAsset = true,
        ToolTip = "",
        UID = u215,
        Name = u219,
        TextureId = v217.Icon or "",

        GetAttribute = function(p220, p221) -- Line: 1071, Name: GetAttribute
            -- upvalues: u215 (copy), Category (copy), u219 (copy), u218 (copy)
            if p221 == "ItemType" then
                return "Asset";
            end;

            if p221 == "UID" then
                return u215;
            end;

            if p221 == "Category" then
                return Category;
            end;

            if p221 == "DisplayName" then
                return u219;
            end;

            if p221 == "Mutations" then
                return table.concat(u218.Mutations or {}, ", ");
            end;

            if p221 == "BaseMutation" then
                return u218.BaseMutation;
            end;

            if p221 == "Scale" then
                return u218.Scale;
            end;

            if p221 == "ItemData" then
                return u218;
            end;

            if p221 ~= "Favorite" then
                return nil;
            end;

            local v222 = Save.Get();

            if v222 and typeof(v222.Inventory) == "table" then
                return isAssetUIDFavorite(u215);
            end;

            return u218.IsFavorite == true;
        end,

        IsA = function(p223, p224) -- Line: 1099, Name: IsA
            return p224 == "Tool";
        end
    };
end;

function isAssetUIDPlaced(p225)
    -- upvalues: u68 (ref)
    local v226;

    if typeof(p225) == "string" then
        v226 = u68[p225] == true;
    else
        v226 = false;
    end;

    return v226;
end;

function hasLocalAssetToolUID(p227)
    return findAssetToolByUID(p227) ~= nil;
end;

function refreshPlacedAssetUIDs(p228)
    -- upvalues: u68 (ref)
    local v229 = {};

    for i in pairs(p228) do
        if typeof(i) == "string" then
            v229[i] = true;
        end;
    end;

    u68 = v229;
end;

function assetSignatureField(p230)
    return p230 == nil and "" or tostring(p230);
end;

function getAssetItemSignature(p231)
    return table.concat({
        assetSignatureField(p231.Category),
        table.concat(p231.Mutations or {}, ","),
        assetSignatureField(p231.BaseMutation),
        assetSignatureField(p231.Scale),
        assetSignatureField(p231.Gender),
        assetSignatureField(p231.EyeColor),
        assetSignatureField(p231.ColorSeed),
        assetSignatureField(p231.ColorIndex),
        assetSignatureField(p231.GeneratedMoney),
        assetSignatureField(p231.PendingEggName),
        assetSignatureField(p231.Claimed),
        assetSignatureField(p231.HasBeenFirstPlaced)
    }, "\31");
end;

function buildEligibleAssetDataFromSave()
    -- upvalues: AssetItemSerialization (copy)
    local v232 = Save.Get();

    if not v232 or typeof(v232.Inventory) ~= "table" then
        return {}, {};
    end;

    local v233 = {};
    local v234 = {};

    for i, v in pairs(v232.Inventory) do
        if typeof(i) == "string" and typeof(v) == "table" then
            local v235 = AssetItemSerialization.Deserialize(v);
            local v236 = table.find(v232.EquippedAssets or {}, i) ~= nil;

            if v235.InFuse ~= true and (not v236 or hasLocalAssetToolUID(i)) and not isAssetUIDPlaced(i) then
                v233[i] = v235;
                v234[i] = getAssetItemSignature(v235);
            end;
        end;
    end;

    return v233, v234;
end;

function isSerializedAssetEligibleForBackpack(p237, p238)
    -- upvalues: AssetItemSerialization (copy)
    if typeof(p238) ~= "table" then
        return false;
    end;

    local v239 = AssetItemSerialization.Deserialize(p238);
    local v240 = Save.Get();

    if v240 then
        v240 = table.find(v240.EquippedAssets or {}, p237) ~= nil;
    end;

    return v239.InFuse ~= true and (not v240 or hasLocalAssetToolUID(p237)) and not isAssetUIDPlaced(p237) and true or false;
end;

function captureEligibleAssetUIDs()
    local v241 = Save.Get();
    local v242 = {};

    if not v241 or typeof(v241.Inventory) ~= "table" then
        return v242;
    end;

    for i, v in pairs(v241.Inventory) do
        if typeof(i) == "string" and isSerializedAssetEligibleForBackpack(i, v) then
            v242[i] = true;
        end;
    end;

    return v242;
end;

function queueNewEligibleAssetsForHotbar(p243, p244)
    -- upvalues: u70 (copy)
    for i in pairs(p244) do
        if p243[i] ~= true then
            u70[i] = true;
        end;
    end;
end;

function getEggConfigForRecord(p245)
    if typeof(p245) ~= "table" or typeof(p245.AssetCategory) ~= "string" then
        return nil, nil;
    end;

    local v246 = AssetDirectory[p245.AssetCategory];

    if v246 then
        return v246.Egg, v246;
    end;

    return nil, nil;
end;

function getAreaForEggRecord(p247)
    -- upvalues: Areas (copy)
    local _, v248 = getEggConfigForRecord(p247);

    if not (v248 and v248.Rarity) then
        return nil;
    end;

    local AssetCategory = p247.AssetCategory;
    local v249 = v248.Rarity._id or v248.Rarity.DisplayName;

    for _, v in pairs(Areas.Directory) do
        for _, v2 in ipairs(v.DropTable) do
            local v250 = v2[1];

            if v250 == AssetCategory or v250 == v249 then
                return v;
            end;
        end;
    end;

    return nil;
end;

function getEggDisplayName(p251)
    local v252 = getAreaForEggRecord(p251);

    return not v252 and "Egg" or `{v252.DisplayName} Egg`;
end;

function getEggDisplayNameWithWeight(p253)
    -- upvalues: EggItemUtil (copy)
    return `{getEggDisplayName(p253)} ({EggItemUtil.GetWeightKgDisplay(p253)})`;
end;

function getEggRecordFromTool(p254)
    local v255 = getAttribute(p254, "EggRecord");

    if typeof(v255) == "table" then
        return v255;
    end;

    local v256 = getAttribute(p254, "AssetCategory") or getAttribute(p254, "Category");
    local v257 = getAttribute(p254, "AssetScale") or getAttribute(p254, "Scale");

    return typeof(v256) == "string" and typeof(v257) == "number" and {
        AssetCategory = v256,
        AssetScale = v257,
        Mutations = parseMutations(getAttribute(p254, "Mutations")),
        BaseMutation = getAttribute(p254, "BaseMutation")
    } or nil;
end;

function createVirtualEgg(u258, u259)
    -- upvalues: EggItemUtil (copy)
    local v260, v261 = getEggConfigForRecord(u259);

    if not (v260 and v261) then
        return nil;
    end;

    local u262 = getEggDisplayNameWithWeight(u259);
    local u263 = EggItemUtil.GetWeightKg(u259);

    return {
        IsVirtualEgg = true,
        UID = u258,
        Name = u262,
        TextureId = v260.Icon or "",
        ToolTip = u262,

        GetAttribute = function(p264, p265) -- Line: 1298, Name: GetAttribute
            -- upvalues: u258 (copy), u259 (copy), u262 (copy), u263 (copy)
            if p265 == "ItemType" then
                return "AssetEgg";
            end;

            if p265 == "UID" then
                return u258;
            end;

            if p265 == "AssetCategory" or p265 == "Category" then
                return u259.AssetCategory;
            end;

            if p265 == "DisplayName" then
                return u262;
            end;

            if p265 == "EggDisplayName" then
                return u262;
            end;

            if p265 == "EggRecord" then
                return table.clone(u259);
            end;

            if p265 == "Mutations" then
                return table.concat(u259.Mutations or {}, ", ");
            end;

            if p265 == "BaseMutation" then
                return u259.BaseMutation;
            end;

            if p265 == "Weight" or p265 == "WeightKg" then
                return u263;
            end;

            if p265 == "Favorite" then
                return false;
            end;

            return nil;
        end,

        IsA = function(p266, p267) -- Line: 1323, Name: IsA
            return p267 == "Tool";
        end
    };
end;

function buildVirtualEggsFromSave()
    local v268 = Save.Get();

    if v268 then
        v268 = v268.EggInventory;
    end;

    local v269 = {};

    if typeof(v268) ~= "table" then
        return v269;
    end;

    for i, v in pairs(v268) do
        if typeof(i) == "string" and (typeof(v) == "table" and v.Placement == nil) then
            local v270 = createVirtualEgg(i, v);

            if v270 then
                v269[i] = v270;
            end;
        end;
    end;

    return v269;
end;

function captureEggUIDs()
    local v271 = Save.Get();

    if v271 then
        v271 = v271.EggInventory;
    end;

    local v272 = {};

    if typeof(v271) ~= "table" then
        return v272;
    end;

    for i, v in pairs(v271) do
        if typeof(i) == "string" and (typeof(v) == "table" and v.Placement == nil) then
            v272[i] = true;
        end;
    end;

    return v272;
end;

function queueNewEggsForHotbar(p273, p274)
    -- upvalues: u75 (copy)
    for i in pairs(p274) do
        if not p273[i] then
            u75[i] = true;
        end;
    end;
end;

function clearInstanceAssetSlots()
    -- upvalues: u47 (copy), u61 (copy)
    local v275 = false;

    for _, v in pairs(u47) do
        local v276;

        if v then
            v276 = v.Tool;
        else
            v276 = v;
        end;

        if v and (typeof(v276) == "Instance" and (v276:IsA("Tool") and isAssetTool(v276))) then
            v:Clear();
            v275 = true;

            if u61 < v.Index then
                v:Delete();
            end;
        end;
    end;

    return v275;
end;

function clearPlacedAssetBackpackSlot(p277)
    -- upvalues: u70 (copy), u69 (copy), u47 (copy), u61 (copy), u66 (copy), u67 (copy)
    u70[p277] = nil;
    u69[p277] = nil;
    local v278 = false;

    for i = #u47, 1, -1 do
        local v279 = u47[i];
        local v280;

        if v279 then
            v280 = v279.Tool;
        else
            v280 = v279;
        end;

        if v279 and (v280 and (getAttribute(v280, "ItemType") == "Asset" and _getAssetUID(v280) == p277)) then
            v279:Clear();
            v278 = true;

            if u61 < v279.Index then
                v279:Delete();
            end;
        end;
    end;

    u66[p277] = nil;
    u67[p277] = nil;

    return v278;
end;

function clearPlacedAssetBackpackSlots(p281)
    local v282 = false;

    for i in pairs(p281) do
        if typeof(i) == "string" and clearPlacedAssetBackpackSlot(i) then
            v282 = true;
        end;
    end;

    return v282;
end;

function syncAssetsFromSave()
    -- upvalues: u40 (ref), u66 (copy), u61 (copy), u69 (copy), u67 (copy)
    if not u40 then
        return false;
    end;

    local v283, v284 = buildEligibleAssetDataFromSave();
    local v285 = clearInstanceAssetSlots();

    for i, v in pairs(u66) do
        if not v283[i] then
            if v and not v.IsDeleted then
                v:Clear();

                if u61 < v.Index then
                    v:Delete();
                end;
            end;

            u66[i] = nil;
            u69[i] = nil;
            v285 = true;
        end;
    end;

    for i, v in pairs(v283) do
        local v286 = v284[i];
        local v287 = u66[i];
        local v288 = v287 and not v287.IsDeleted and virtualAssetMatchesUID(v287.Tool, i);

        if not v288 or u69[i] ~= v286 then
            if not v288 then
                v287 = FindEmptyInventorySlot() or MakeSlot(u40);
            end;

            u66[i] = v287;
            u67[i] = createVirtualAsset(i, v);
            u69[i] = v286;
            v287:Fill(u67[i]);
            v285 = true;
        elseif v287 then
            u67[i] = v287.Tool;
            u69[i] = v286;

            if v287.UpdateFavoriteVisual and v287:UpdateFavoriteVisual() then
                v285 = true;
            end;
        end;
    end;

    for i in pairs(u67) do
        if not v283[i] then
            u67[i] = nil;
        end;
    end;

    if v285 then
        AdjustHotbarFrames();
        UpdateInventorySlots();
    end;

    return v285;
end;

function syncEggsFromSave()
    -- upvalues: u40 (ref), u73 (copy), u74 (copy)
    if not u40 then
        return;
    end;

    local v289 = buildVirtualEggsFromSave();

    for i in pairs(u73) do
        if not v289[i] then
            clearVirtualEggSlotsByUID(i);
            u73[i] = nil;
        end;
    end;

    for i, v in pairs(v289) do
        local v290 = u73[i];

        if not virtualEggSlotMatchesUID(v290, i) then
            v290 = findVirtualEggSlotByUID(i);
        end;

        if not v290 or v290.IsDeleted then
            v290 = FindEmptyInventorySlot() or MakeSlot(u40);
        end;

        u73[i] = v290;
        u74[i] = v;
        clearDuplicateVirtualEggSlotsByUID(i, v290);
        v290:Fill(v);
    end;

    for i in pairs(u74) do
        if not v289[i] then
            u74[i] = nil;
        end;
    end;

    AdjustHotbarFrames();
    UpdateInventorySlots();
end;

function getAssetRarityNumber(p291)
    local v292 = getAttribute(p291, "Category");
    local v293 = v292 and AssetDirectory[v292] or BaseAssetConfig;

    if v293 then
        v293 = v293.Rarity;
    end;

    if v293 then
        if v293.RarityNumber then
            return v293.RarityNumber;
        end;

        if RarityDirectory[v293] and RarityDirectory[v293].RarityNumber then
            return RarityDirectory[v293].RarityNumber;
        end;
    end;

    return (1 / 0);
end;

function getAssetDropWeight(p294)
    local v295 = getAttribute(p294, "Category");
    local v296 = v295 and AssetDirectory[v295] or BaseAssetConfig;

    return (not v296 or typeof(v296.DropWeight) ~= "number") and (1 / 0) or v296.DropWeight;
end;

function getAssetOddsDenominator(p297)
    if getAttribute(p297, "ItemType") ~= "Asset" then
        return 0;
    end;

    local v298 = getAttribute(p297, "Category");
    local v299 = v298 and AssetDirectory[v298] or BaseAssetConfig;

    if v299 then
        v299 = v299.DropWeight;
    end;

    if typeof(v299) ~= "number" or v299 <= 0 then
        return 0;
    end;

    local v300 = getAssetItemData(p297);

    return not v300 and 0 or 1 / v299 * MutationHandler.GetVisualOddsMultiplier(v300.Mutations, v300.BaseMutation);
end;

function getAssetEarningRate(p301)
    -- upvalues: AssetGenerationUtil (copy)
    if getAttribute(p301, "ItemType") ~= "Asset" then
        return 0;
    end;

    local v302 = getAssetItemData(p301);

    return not v302 and 0 or AssetGenerationUtil.GetBaseRateMutationOnly(v302);
end;

function getEggAssetConfig(p303)
    local v304 = getEggRecordFromTool(p303);
    local _, v305 = getEggConfigForRecord(v304);

    if v305 then
        return v305;
    end;

    local v306 = getAttribute(p303, "AssetCategory") or getAttribute(p303, "Category");

    return v306 and AssetDirectory[v306] or nil;
end;

function getEggRarityNumber(p307)
    local v308 = getEggAssetConfig(p307);

    if v308 then
        v308 = v308.Rarity;
    end;

    if v308 then
        if v308.RarityNumber then
            return v308.RarityNumber;
        end;

        if RarityDirectory[v308] and RarityDirectory[v308].RarityNumber then
            return RarityDirectory[v308].RarityNumber;
        end;
    end;

    return (1 / 0);
end;

function getEggBaseEarningRate(p309)
    local v310 = getEggAssetConfig(p309);

    return (not v310 or typeof(v310.EarningRate) ~= "number") and 0 or v310.EarningRate;
end;

function requestFavoriteToggle(p311)
    -- upvalues: u64 (copy), AssetInventory (copy)
    if ActiveFuseSelectionState then
        return;
    end;

    if not isAssetTool(p311) then
        return;
    end;

    local u312 = _getAssetUID(p311);

    if typeof(u312) ~= "string" or u312 == "" then
        return;
    end;

    local u313 = not isToolFavorite(p311);
    u64(function() -- Line: 1628
        -- upvalues: AssetInventory (ref), u312 (copy), u313 (copy)
        Network.Fire(AssetInventory.SET_FAVORITE, u312, u313);
    end);
end;

function getStackQuantity(p314)
    local v315 = getAttribute(p314, "StackQuantity");

    return (typeof(v315) ~= "number" or v315 <= 1) and 1 or math.floor(v315);
end;

function clearMutationIconFrame(p316, p317)
    if not (p316 and p317) then
        return;
    end;

    for _, child in ipairs(p316:GetChildren()) do
        if child:IsA("ImageLabel") and child ~= p317 then
            child:Destroy();
        end;
    end;

    p316.Visible = false;
end;

function populateMutationIconFrame(p318, p319, p320, p321)
    if not (p318 and p319) then
        return;
    end;

    clearMutationIconFrame(p318, p319);
    p318.Visible = false;
end;

function updateEquipSelectionVisuals()
    -- upvalues: u47 (copy)
    for _, v in pairs(u47) do
        if v then
            v:UpdateEquipView();
        end;
    end;
end;

function findVirtualAssetSlotContainingUID(p322)
    -- upvalues: u47 (copy)
    for _, v in pairs(u47) do
        if v and virtualAssetMatchesUID(v.Tool, p322) then
            return v;
        end;
    end;

    return nil;
end;

function getCharacterAssetToolUID()
    -- upvalues: u28 (ref)
    for _, child in ipairs(u28:GetChildren()) do
        if child:IsA("Tool") and child:GetAttribute("ItemType") == "Asset" then
            local v323 = child:GetAttribute("UID");

            if typeof(v323) == "string" then
                return v323;
            end;
        end;
    end;

    return nil;
end;

function findAssetToolByUID(u324)
    -- upvalues: u28 (ref), Backpack (ref)
    local function searchContainer(p325) -- Line: 1716
        -- upvalues: u324 (copy)
        if not p325 then
            return nil;
        end;

        for _, child in ipairs(p325:GetChildren()) do
            if child:IsA("Tool") and (child:GetAttribute("ItemType") == "Asset" and child:GetAttribute("UID") == u324) then
                return child;
            end;
        end;

        return nil;
    end;

    return searchContainer(u28) or (searchContainer(Backpack) or nil);
end;

function applyVirtualAssetEquipUID(p326)
    -- upvalues: u65 (ref)
    u65 = p326;

    if typeof(p326) == "string" then
        SelectedSlot = findVirtualAssetSlotContainingUID(p326);
    elseif SelectedSlot and getAttribute(SelectedSlot.Tool, "ItemType") == "Asset" then
        SelectedSlot = nil;
    end;

    updateEquipSelectionVisuals();
end;

function reconcileVirtualAssetEquipState()
    -- upvalues: u65 (ref)
    local v327 = getCharacterAssetToolUID();

    if v327 == u65 then
        if typeof(v327) == "string" and not SelectedSlot then
            SelectedSlot = findVirtualAssetSlotContainingUID(v327);
            updateEquipSelectionVisuals();
        end;

        return v327;
    end;

    applyVirtualAssetEquipUID(v327);

    return v327;
end;

function syncVirtualAssetEquipStateFromTool(p328)
    -- upvalues: u28 (ref), Backpack (ref), u65 (ref)
    local v329 = p328:GetAttribute("UID");

    if typeof(v329) ~= "string" then
        return;
    end;

    if p328.Parent == u28 then
        applyVirtualAssetEquipUID(v329);

        return;
    end;

    if p328.Parent == Backpack and u65 == v329 then
        task.defer(reconcileVirtualAssetEquipState);
    end;
end;

function getCharacterEggToolUID()
    -- upvalues: u28 (ref)
    for _, child in ipairs(u28:GetChildren()) do
        if child:IsA("Tool") and child:GetAttribute("ItemType") == "AssetEgg" then
            local v330 = child:GetAttribute("UID");

            if typeof(v330) == "string" then
                return v330;
            end;
        end;
    end;

    return nil;
end;

function applyVirtualEggEquipUID(p331)
    -- upvalues: u79 (ref)
    u79 = p331;

    if typeof(p331) == "string" then
        SelectedSlot = findVirtualEggSlotByUID(p331);
    elseif SelectedSlot and getAttribute(SelectedSlot.Tool, "ItemType") == "AssetEgg" then
        SelectedSlot = nil;
    end;

    updateEquipSelectionVisuals();
end;

function reconcileVirtualEggEquipState()
    -- upvalues: u79 (ref)
    local v332 = getCharacterEggToolUID();

    if v332 == u79 then
        if typeof(v332) == "string" and not SelectedSlot then
            SelectedSlot = findVirtualEggSlotByUID(v332);
            updateEquipSelectionVisuals();
        end;

        return v332;
    end;

    applyVirtualEggEquipUID(v332);

    return v332;
end;

function syncVirtualEggEquipStateFromTool(p333)
    -- upvalues: u28 (ref), Backpack (ref), u79 (ref)
    local v334 = p333:GetAttribute("UID");

    if typeof(v334) ~= "string" then
        return;
    end;

    if p333.Parent == u28 then
        applyVirtualEggEquipUID(v334);

        return;
    end;

    if p333.Parent == Backpack and u79 == v334 then
        task.defer(reconcileVirtualEggEquipState);
    end;
end;

function requestUnequipVirtualEgg()
    -- upvalues: u79 (ref), u63 (copy), EggCmds (copy), Message (copy)
    reconcileVirtualEggEquipState();

    if not u79 then
        return true;
    end;

    local u335 = false;
    u63(function() -- Line: 1835
        -- upvalues: u79 (ref), EggCmds (ref), u335 (ref), Message (ref)
        local v336 = u79;
        local v337, v338 = EggCmds.RequestUnequipTool(v336);

        if not v337 then
            if v338 then
                Message.Bottom({
                    Time = 2,
                    Message = v338,
                    Color = Color3.fromRGB(255, 64, 64)
                });
            end;

            return;
        end;

        u79 = nil;

        if SelectedSlot and getAttribute(SelectedSlot.Tool, "UID") == v336 then
            SelectedSlot = nil;
        end;

        updateEquipSelectionVisuals();
        u335 = true;
    end);

    return u335;
end;

function requestEquipVirtualEgg(u339, u340)
    -- upvalues: u63 (copy), u29 (ref), EggCmds (copy), u79 (ref), Message (copy)
    if not BackpackEnabled or (not BackpackGui.Enabled or Variables.Locks.HideUI:IsLocked()) then
        return;
    end;

    if reconcileVirtualEggEquipState() ~= u339 then
        u63(function() -- Line: 1871
            -- upvalues: u29 (ref), EggCmds (ref), u339 (copy), u79 (ref), u340 (copy), Message (ref)
            requestUnequipVirtualAsset();

            if u29 then
                u29:UnequipTools();
            end;

            local v341, v342 = EggCmds.RequestEquipTool(u339);

            if not v341 then
                if v342 then
                    Message.Bottom({
                        Time = 2,
                        Message = v342,
                        Color = Color3.fromRGB(255, 64, 64)
                    });
                end;

                return;
            end;

            u79 = u339;
            SelectedSlot = u340;
            updateEquipSelectionVisuals();
        end);

        return;
    end;

    SelectedSlot = u340;
    updateEquipSelectionVisuals();
end;

function requestUnequipVirtualAsset()
    -- upvalues: u65 (ref), u63 (copy), ActiveAssets (copy), Message (copy)
    reconcileVirtualAssetEquipState();

    if not u65 then
        return true;
    end;

    local u343 = false;
    u63(function() -- Line: 1902
        -- upvalues: u65 (ref), ActiveAssets (ref), u343 (ref), Message (ref)
        local v344 = u65;
        local v345, v346 = Network.Invoke(ActiveAssets.REQUEST_UNEQUIP, v344);

        if v345 == false then
            if v346 and v346 ~= "Asset is not available." then
                Message.Bottom({
                    Time = 2,
                    Message = v346,
                    Color = Color3.fromRGB(255, 64, 64)
                });
            end;

            return;
        end;

        u65 = nil;

        if SelectedSlot and virtualAssetMatchesUID(SelectedSlot.Tool, v344) then
            SelectedSlot = nil;
        end;

        updateEquipSelectionVisuals();
        u343 = true;
    end);

    return u343;
end;

function addVirtualAssetOverlay(u347, p348, p349, p350, p351)
    -- upvalues: AssetGenerationUtil (copy), ItemDisplay (copy), AssetItemUtil (copy)
    if not (u347:GetAttribute("IsInventorySlot") or p351) then
        return;
    end;

    if u347:GetAttribute("HasAssetOverlay") and not p351 then
        return;
    end;

    local u352 = not p349.Rarity and "Unknown" or (p349.Rarity.DisplayName or (p349.Rarity._id or p349.Rarity.Name));
    local u353 = getAssetItemDisplayName(p348, p349);
    local u354;

    if typeof(p348) == "table" and (typeof(p348.Category) == "string" and AssetDirectory[p348.Category]) then
        u354 = AssetGenerationUtil.GetBaseRateMutationOnly(p348);
    else
        u354 = AssetGenerationUtil.ComputeBaseRateFromDropWeight(p349.DropWeight);
    end;

    local u355;

    if typeof(p348) == "table" and typeof(p348.Mutations) == "table" then
        u355 = ItemDisplay.GetMutationRichTextLine(p348.Mutations, p348.BaseMutation);
    else
        u355 = nil;
    end;

    local u356;

    if typeof(p348) == "table" and (typeof(p348.Category) == "string" and typeof(p348.Scale) == "number") then
        u356 = AssetItemUtil.GetVisualWeightKgDisplay(p348);
    else
        u356 = nil;
    end;

    local function show() -- Line: 1954
        -- upvalues: u347 (copy), u353 (copy), u352 (copy), u354 (copy), u356 (copy), u355 (copy)
        if not u347:GetAttribute("IsInventorySlot") then
            return;
        end;

        local v357 = {
            { "Title", u353 },
            { "Div" },
            { "Rarity", u352 },
            { "Div" },
            {
                "Title",
                "$" .. SimpleNumber.FormatCompact(u354, ".#") .. "/s",
                nil,
                Color3.new(0, 1, 0)
            }
        };

        if u356 then
            table.insert(v357, 2, { "Desc", u356 });
        end;

        if u355 then
            table.insert(v357, { "Div" });
            table.insert(v357, { "Desc", u355 });
        end;

        InfoOverlay.Add(u347, unpack(v357));
    end;

    if p350 then
        p350:Add(u347.MouseEnter:Connect(function() -- Line: 1979
            -- upvalues: show (copy)
            if not Variables.DisableInfoOverlay then
                show();
            end;
        end));
        p350:Add(u347.SelectionGained:Connect(function() -- Line: 1984
            -- upvalues: show (copy)
            if not Variables.DisableInfoOverlay then
                show();
            end;
        end));
    else
        u347.MouseEnter:Connect(function() -- Line: 1990
            -- upvalues: show (copy)
            if not Variables.DisableInfoOverlay then
                show();
            end;
        end);
        u347.SelectionGained:Connect(function() -- Line: 1996
            -- upvalues: show (copy)
            if not Variables.DisableInfoOverlay then
                show();
            end;
        end);
    end;

    u347:SetAttribute("HasAssetOverlay", true);
end;

function addVirtualEggOverlay(u358, p359, p360)
    if not u358:GetAttribute("IsInventorySlot") then
        return;
    end;

    if u358:GetAttribute("HasEggOverlay") then
        return;
    end;

    local u361 = getEggDisplayNameWithWeight(p359);
    local _, v362 = getEggConfigForRecord(p359);
    local v363;

    if v362 then
        v363 = v362.Rarity;
    else
        v363 = v362;
    end;

    local u364;

    if v362 == nil then
        u364 = false;
    else
        u364 = v362.Egg.HideRarity == true;
    end;

    local u365 = not v363 and "Egg" or (v363.DisplayName or (v363._id or v363.Name));
    local u366;

    if v363 then
        u366 = v363.Color;
    else
        u366 = Color3.new(1, 1, 1);
    end;

    local function u368() -- Line: 2022
        -- upvalues: u358 (copy), u361 (copy), u364 (copy), u365 (copy), u366 (copy)
        if not u358:GetAttribute("IsInventorySlot") then
            return;
        end;

        local v367 = {
            { "Title", u361 }
        };

        if not u364 then
            table.insert(v367, { "Div" });
            table.insert(v367, {
                "Title",
                u365,
                nil,
                u366
            });
        end;

        InfoOverlay.Add(u358, unpack(v367));
    end;

    if p360 then
        p360:Add(u358.MouseEnter:Connect(function() -- Line: 2040
            -- upvalues: u368 (copy)
            if not Variables.DisableInfoOverlay then
                u368();
            end;
        end));
        p360:Add(u358.SelectionGained:Connect(function() -- Line: 2045
            -- upvalues: u368 (copy)
            if not Variables.DisableInfoOverlay then
                u368();
            end;
        end));
    else
        u358.MouseEnter:Connect(function() -- Line: 2051
            -- upvalues: u368 (copy)
            if not Variables.DisableInfoOverlay then
                u368();
            end;
        end);
        u358.SelectionGained:Connect(function() -- Line: 2057
            -- upvalues: u368 (copy)
            if not Variables.DisableInfoOverlay then
                u368();
            end;
        end);
    end;

    u358:SetAttribute("HasEggOverlay", true);
end;

function NewGui(p369, p370)
    local v371 = Instance.new(p369);
    v371.Name = p370;
    v371.BackgroundColor3 = Color3.new(0, 0, 0);
    v371.BackgroundTransparency = 1;
    v371.BorderColor3 = Color3.new(0, 0, 0);
    v371.BorderSizePixel = 0;
    v371.Size = UDim2.new(1, 0, 1, 0);

    if p369:match("Text") then
        v371.TextColor3 = Color3.new(1, 1, 1);
        v371.Text = "";
        v371.FontFace = script:GetAttribute("LabelFont");
        v371.TextSize = TextSizeAttribute;
        v371.TextWrapped = true;

        if p369 == "TextButton" then
            v371.FontFace = script:GetAttribute("SlotFont");
        end;
    end;

    return v371;
end;

function FindLowestEmpty(p372)
    -- upvalues: u61 (copy), u47 (copy)
    for i = 1, u61 do
        local v373 = u47[i];

        if v373 and (not v373.IsFakeSlot and (not v373.Tool and canToolUseHotbarSlot(p372, i))) then
            return v373;
        end;
    end;

    return nil;
end;

function FindEmptyInventorySlot()
    -- upvalues: u61 (copy), u47 (copy)
    for i = u61 + 1, #u47 do
        local v374 = u47[i];

        if v374 and not v374.Tool then
            return v374;
        end;
    end;

    return nil;
end;

function cancelPendingBackpackRoundRestore()
    -- upvalues: u94 (ref)
    if u94 then
        task.cancel(u94);
        u94 = nil;
    end;
end;

function moveRestrictedHotbarToolsToInventory()
    -- upvalues: u61 (copy), u47 (copy)
    for i = 1, u61 do
        local v375 = u47[i];

        if v375 and (not v375.IsFakeSlot and (v375.Tool and not isToolLockedToCurrentHotbarSlot(v375))) then
            v375:MoveToInventory();
        end;
    end;
end;

function isGearTool(p376)
    return getAttribute(p376, "ItemType") == "Gear" and true or typeof(getAttribute(p376, "GearName")) == "string";
end;

function isBatGearTool(p377)
    local v378 = getGearConfig(p377);
    local v379;

    if v378 == nil then
        v379 = false;
    else
        v379 = v378.BatControllerData ~= nil;
    end;

    return v379;
end;

function isTrapGearTool(p380)
    return getGearName(p380) == "Trap";
end;

function isBeeLauncherGearTool(p381)
    return getGearName(p381) == "BeeLauncher";
end;

function getLockedHotbarSlotForTool(p382)
    if typeof(p382) == "Instance" and (p382:IsA("Tool") and isGearTool(p382)) then
        return isBatGearTool(p382) and 1 or (isTrapGearTool(p382) and 2 or (isBeeLauncherGearTool(p382) and 3 or nil));
    end;

    return nil;
end;

function canToolUseHotbarSlot(p383, p384)
    if p384 == 1 then
        local v385;

        if typeof(p383) == "Instance" then
            v385 = p383:IsA("Tool") and isGearTool(p383) and isBatGearTool(p383);
        else
            v385 = false;
        end;

        return v385;
    end;

    if p384 == 2 then
        local v386;

        if typeof(p383) == "Instance" then
            v386 = p383:IsA("Tool") and isGearTool(p383) and isTrapGearTool(p383);
        else
            v386 = false;
        end;

        return v386;
    end;

    if p384 == 3 then
        return typeof(p383) == "Instance" and (p383:IsA("Tool") and (isGearTool(p383) and isBeeLauncherGearTool(p383))) and true or findGearSlot(isBeeLauncherGearTool) == nil;
    end;

    local v387 = getLockedHotbarSlotForTool(p383);

    return v387 == nil and true or v387 == p384;
end;

function isToolLockedToCurrentHotbarSlot(p388)
    if not p388 or (p388.IsFakeSlot or not p388.Tool) then
        return false;
    end;

    local v389 = getLockedHotbarSlotForTool(p388.Tool);
    local v390;

    if v389 == nil then
        v390 = false;
    else
        v390 = v389 == p388.Index;
    end;

    return v390;
end;

function findGearSlot(p391)
    -- upvalues: u47 (copy)
    for _, v in pairs(u47) do
        if v and (not v.IsFakeSlot and (v.Tool and (isGearTool(v.Tool) and p391(v.Tool)))) then
            return v;
        end;
    end;

    return nil;
end;

function moveGameplayGearToHotbarSlot(p392, p393)
    -- upvalues: u47 (copy), u61 (copy)
    local v394 = findGearSlot(p392);

    if not v394 then
        return false;
    end;

    local v395 = u47[p393];

    if not v395 or v395.IsFakeSlot then
        return false;
    end;

    if v394 == v395 then
        return false;
    end;

    if v395.Tool and canToolUseHotbarSlot(v395.Tool, p393) then
        return false;
    end;

    v394:Swap(v395);

    if u61 < v394.Index and not v394.Tool then
        v394:Delete();
    end;

    return true;
end;

function moveInvalidLockedHotbarSlotToolToInventory(p396)
    -- upvalues: u47 (copy)
    local v397 = u47[p396];

    if not v397 or (v397.IsFakeSlot or not v397.Tool) then
        return false;
    end;

    if canToolUseHotbarSlot(v397.Tool, p396) then
        return false;
    end;

    v397:MoveToInventory();

    return true;
end;

function ensureGameplayGearHotbarSlots()
    -- upvalues: u6 (ref)
    local v398 = moveGameplayGearToHotbarSlot(isBatGearTool, 1) and true or false;
    local v399 = moveGameplayGearToHotbarSlot(isTrapGearTool, 2) and true or v398;
    local v400 = moveGameplayGearToHotbarSlot(isBeeLauncherGearTool, 3) and true or v399;
    local v401 = moveInvalidLockedHotbarSlotToolToInventory(1) and true or v400;
    local v402 = moveInvalidLockedHotbarSlotToolToInventory(2) and true or v401;

    if not (moveInvalidLockedHotbarSlotToolToInventory(3) or v402) then
        return;
    end;

    AdjustHotbarFrames();
    UpdateInventorySlots();

    if u6 then
        u6(true);
    end;
end;

function isToolInCharacterOrBackpack(p403)
    -- upvalues: u28 (ref), Backpack (ref)
    if typeof(p403) ~= "Instance" or not p403:IsA("Tool") then
        return false;
    end;

    local Parent = p403.Parent;

    return Parent == u28 and true or Parent == Backpack;
end;

function _isInventoryEmpty()
    -- upvalues: u61 (copy), u47 (copy)
    for i = u61 + 1, #u47 do
        local v404 = u47[i];

        if v404 and v404.Tool then
            return false;
        end;
    end;

    return true;
end;

function _UseGazeSelection()
    return UserInputService.VREnabled;
end;

function AdjustHotbarFrames()
    -- upvalues: u61 (copy), u47 (copy), u33 (ref), u52 (ref)
    debug.profilebegin("BackpackController :: AdjustHotbarFrames");

    for i = 1, u61 do
        local v405 = u47[i];

        if v405 then
            v405:SetNumberText(nil);
        end;
    end;

    local Visible = u33.Visible;
    local v406 = {};

    for i = 1, u61 do
        local v407 = u47[i];
        local v408;

        if v407 then
            v408 = v407.IsFakeSlot or (v407.Tool or Visible);
        else
            v408 = v407;
        end;

        if v408 then
            table.insert(v406, {
                Kind = "Slot",
                Slot = v407
            });
        end;
    end;

    local v409 = math.max(1, #v406);
    u52 = v409;
    local v410 = 0;

    for i = 1, u61 do
        local v411 = u47[i];

        if v411 then
            v411.Frame.Visible = false;
        end;
    end;

    for _, v in ipairs(v406) do
        v410 = v410 + 1;
        local Slot = v.Slot;

        if Slot then
            Slot.Frame.LayoutOrder = v410;
            Slot:Readjust(v410, v409);
            Slot.Frame.Visible = true;
        end;
    end;

    PositionInventoryAffordances();
    debug.profileend();
end;

function UpdateScrollingFrameCanvasSize()
    -- upvalues: u44 (ref)
    debug.profilebegin("BackpackController :: UpdateScrollingFrameCanvasSize");

    if u44 then
        u44();
    end;

    debug.profileend();
end;

function UpdateInventorySlots()
    -- upvalues: u57 (ref), u6 (ref), u61 (copy), u47 (copy)
    debug.profilebegin("BackpackController :: UpdateInventorySlots");

    if u57 then
        if u6 then
            u6();
        end;

        return;
    end;

    local v412 = {};
    local v413 = {};
    local v414 = {};
    local v415 = {};
    local v416 = {};

    for i = u61 + 1, #u47 do
        local v417 = u47[i];
        local Tool = v417.Tool;

        if Tool then
            if IsOfCategory(Tool) then
                local v418 = getAttribute(Tool, "ItemType");

                if v418 == "Asset" then
                    table.insert(v415, v417);
                elseif v418 == "AssetEgg" then
                    table.insert(v414, v417);
                elseif v418 == "Sword" then
                    table.insert(v413, v417);
                else
                    table.insert(v412, v417);
                end;

                v417.Frame.Visible = true;
            else
                v417.Frame.Visible = false;
            end;
        else
            table.insert(v416, v417);
            v417.Frame.Visible = false;
        end;
    end;

    table.sort(v415, function(p419, p420) -- Line: 2381
        local Tool = p419.Tool;
        local Tool2 = p420.Tool;
        local v421;

        if Tool then
            v421 = isToolFavorite(Tool);
        else
            v421 = Tool;
        end;

        local v422;

        if Tool2 then
            v422 = isToolFavorite(Tool2);
        else
            v422 = Tool2;
        end;

        if v421 ~= v422 then
            return v421;
        end;

        local v423 = Tool and (getAssetRarityNumber(Tool) or (1 / 0)) or (1 / 0);
        local v424 = Tool2 and (getAssetRarityNumber(Tool2) or (1 / 0)) or (1 / 0);

        if v423 ~= v424 then
            return v424 < v423;
        end;

        local v425 = Tool and (getAssetEarningRate(Tool) or 0) or 0;
        local v426 = Tool2 and (getAssetEarningRate(Tool2) or 0) or 0;

        if v425 ~= v426 then
            return v426 < v425;
        end;

        local v427 = Tool and (getAssetOddsDenominator(Tool) or 0) or 0;
        local v428 = Tool2 and (getAssetOddsDenominator(Tool2) or 0) or 0;

        if v427 ~= v428 then
            return v428 < v427;
        end;

        local v429 = Tool and (getAssetDropWeight(Tool) or (1 / 0)) or (1 / 0);
        local v430 = Tool2 and (getAssetDropWeight(Tool2) or (1 / 0)) or (1 / 0);

        if v429 ~= v430 then
            return v429 < v430;
        end;

        local v431 = Tool and (getAttribute(Tool, "Weight") or 0) or 0;
        local v432 = Tool2 and (getAttribute(Tool2, "Weight") or 0) or 0;

        if v431 == v432 then
            return (Tool and getAttribute(Tool, "UID") or "") < (Tool2 and getAttribute(Tool2, "UID") or "");
        end;

        return v432 < v431;
    end);
    table.sort(v414, function(p433, p434) -- Line: 2429
        local Tool = p433.Tool;
        local Tool2 = p434.Tool;
        local v435 = Tool and (getEggRarityNumber(Tool) or (1 / 0)) or (1 / 0);
        local v436 = Tool2 and (getEggRarityNumber(Tool2) or (1 / 0)) or (1 / 0);

        if v435 ~= v436 then
            return v436 < v435;
        end;

        local v437 = Tool and (getEggBaseEarningRate(Tool) or 0) or 0;
        local v438 = Tool2 and (getEggBaseEarningRate(Tool2) or 0) or 0;

        if v437 == v438 then
            return (Tool and getAttribute(Tool, "UID") or "") < (Tool2 and getAttribute(Tool2, "UID") or "");
        end;

        return v438 < v437;
    end);
    table.sort(v413, function(p439, p440) -- Line: 2450
        return (getAttribute(p439.Tool, "MoneyCost") or 0) > (getAttribute(p440.Tool, "MoneyCost") or 0);
    end);
    local v441 = u61;

    for _, v in ipairs(v415) do
        v441 = v441 + 1;
        v.Frame.LayoutOrder = v441;
    end;

    for _, v in ipairs(v414) do
        v441 = v441 + 1;
        local v442;

        if v.Tool then
            v442 = getEggAssetConfig(v.Tool);
        else
            v442 = nil;
        end;

        v.Frame.LayoutOrder = v442 and v442.Egg.HideRarity and -2147483648 or v441;
    end;

    for _, v in ipairs(v413) do
        v441 = v441 + 1;
        v.Frame.LayoutOrder = v441;
    end;

    for _, v in ipairs(v412) do
        v441 = v441 + 1;
        v.Frame.LayoutOrder = v441;
    end;

    for _, v in ipairs(v416) do
        v441 = v441 + 1;
        v.Frame.LayoutOrder = v441;
    end;

    UpdateScrollingFrameCanvasSize();
    debug.profileend();
end;

function ResizeContainers()
    -- upvalues: u42 (ref), u61 (copy), u21 (ref), u45 (ref), u62 (copy), VREnabled (copy)
    u42.Size = UDim2.new(0, 5 + u61 * (u21 + 5), 0, u21 + 5 + 5);
    u42.Position = UDim2.new(0.5, -u42.Size.X.Offset / 2, 1, -u42.Size.Y.Offset);
    u45.Size = UDim2.new(0, u42.Size.X.Offset, 0, u42.Size.Y.Offset * u62 + 40 + (VREnabled and 80 or 0));
    u45.Position = UDim2.new(0.5, -u45.Size.X.Offset / 2, 1, u42.Position.Y.Offset - u45.Size.Y.Offset);
    PositionInventoryAffordances();
    AdjustHotbarFrames();
    UpdateInventorySlots();
end;

INVENTORY_AFFORDANCE_GAP = 8;
PROMPT_HOTBAR_GAP = 28;

function PositionInventoryAffordances()
    -- upvalues: u21 (ref), u52 (ref), u54 (ref)
    local v443 = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X or 0;

    if v443 > 0 then
        local v444 = 2.5 - (u21 + 5) * math.max(1, u52) * 0.5;
        ActionPromptCmds.SetRightBoundary(0.5 + (v444 - PROMPT_HOTBAR_GAP) / v443);
    end;

    if Variables.Console and u54 then
        ActionPromptCmds.Show("Backpack", Enum.KeyCode.ButtonSelect, "Backpack");

        return;
    end;

    ActionPromptCmds.Hide("Backpack");
end;

function _Clamp(p445, p446, p447)
    local v448 = math.max(p445, p447);

    return math.min(p446, v448);
end;

function CheckBounds(p449, p450, p451)
    local AbsolutePosition = p449.AbsolutePosition;
    local AbsoluteSize = p449.AbsoluteSize;
    local v452;

    if AbsolutePosition.X < p450 and (p450 <= AbsolutePosition.X + AbsoluteSize.X and AbsolutePosition.Y < p451) then
        v452 = p451 <= AbsolutePosition.Y + AbsoluteSize.Y;
    else
        v452 = false;
    end;

    return v452;
end;

function GetOffset(p453, p454)
    return (p453.AbsolutePosition + p453.AbsoluteSize / 2 - p454).magnitude;
end;

function UnequipAllTools(p455, p456)
    -- upvalues: u29 (ref)
    requestUnequipVirtualAsset();
    requestUnequipVirtualEgg();

    if u29 then
        u29:UnequipTools();
    end;
end;

function _EquipNewTool(p457)
    -- upvalues: u29 (ref), u28 (ref)
    if not BackpackEnabled or (not BackpackGui.Enabled or Variables.Locks.HideUI:IsLocked()) then
        return;
    end;

    if u29 then
        UnequipAllTools();
    end;

    p457.Parent = u28;
end;

function _ToggleFavoriteTool(p458)
    local Tool = p458.Tool;

    if not Tool then
        return;
    end;

    requestFavoriteToggle(Tool);
end;

function _IsEquipped(p459)
    -- upvalues: u28 (ref)
    if p459 then
        p459 = p459.Parent == u28;
    end;

    return p459;
end;

function MakeSlot(p460, p461)
    -- upvalues: u47 (copy), u40 (ref), u61 (copy), Trove (copy), u33 (ref), u3 (copy), RunService (copy), u42 (ref), u21 (ref), AssetIconShape (copy), u52 (ref), u54 (ref), u22 (ref), u49 (copy), u48 (ref), u57 (ref), u65 (ref), u79 (ref), u28 (ref), u51 (copy), u30 (copy), u10 (ref), u15 (ref), u14 (copy), u29 (ref), Backpack (ref), u25 (copy), u18 (ref), u50 (copy), Value (copy), LocalPlayer (ref), u2 (ref), u4 (copy), u8 (ref), u7 (ref), u6 (ref)
    local v462 = p461 or #u47 + 1;
    local u463 = {
        Tool = nil,
        Frame = nil,
        IsFakeSlot = false,
        FakeType = nil,
        IsDeleted = false,
        Index = v462
    };
    local u464 = p460 == u40 and true or u61 < v462;
    local u465 = nil;
    local u466 = nil;
    local u467 = nil;
    local u468 = nil;
    local u469 = nil;
    local u470 = nil;
    local u471 = nil;
    local u472 = nil;
    local u473 = nil;
    local u474 = {};
    local u475 = nil;
    local u476 = nil;
    local u477 = nil;
    local u478 = nil;
    local u479 = nil;
    local u480 = nil;
    local u481 = nil;
    local u482 = nil;
    local u483 = nil;
    local v484;

    if u464 then
        v484 = script.InventoryTemplate;
    else
        v484 = script.HotbarTemplate;
    end;

    local u485 = v484:Clone();
    u485.Name = v462;
    u485.ZIndex = 20;
    local Icon = u485.Icon;
    local u486 = NewGui("Frame", "CooldownOverlay");
    u486.BackgroundColor3 = Color3.new(0, 0, 0);
    u486.BackgroundTransparency = 0.35;
    u486.BorderSizePixel = 0;
    u486.Size = UDim2.fromScale(1, 1);
    u486.Visible = false;
    u486.ZIndex = 20;
    u486.Parent = u485;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = script:GetAttribute("CornerRadius");
    UICorner.Parent = u486;
    local u487 = NewGui("TextLabel", "CooldownLabel");
    u487.BackgroundTransparency = 1;
    u487.Size = UDim2.new(1, -4, 1, -4);
    u487.Position = UDim2.fromOffset(2, 2);
    u487.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold);
    u487.TextColor3 = Color3.new(1, 1, 1);
    u487.TextStrokeColor3 = Color3.new(0, 0, 0);
    u487.TextStrokeTransparency = 0.4;
    u487.TextScaled = true;
    u487.TextXAlignment = Enum.TextXAlignment.Center;
    u487.TextYAlignment = Enum.TextYAlignment.Center;
    u487.Visible = false;
    u487.ZIndex = u486.ZIndex + 1;
    u487.Text = "";
    u487.Parent = u486;
    local u488 = Trove.new();

    local function restoreAssetIconHover(p489) -- Line: 2644
    end;

    local function clearSlotOverlays() -- Line: 2646
        -- upvalues: u488 (copy), u469 (ref), u470 (ref), u485 (ref)
        u488:Clean();
        clearMutationIconFrame(u469, u470);

        if u485 then
            u485:SetAttribute("HasAssetOverlay", nil);
            u485:SetAttribute("HasEggOverlay", nil);
            u485:SetAttribute("HasSwordOverlay", nil);
        end;
    end;

    local function isDragRestrictedItemType(p490) -- Line: 2656
        return false;
    end;

    local function canPlaceToolInSlot(p491, p492) -- Line: 2660
        -- upvalues: u61 (ref)
        if p491.IsFakeSlot then
            return false;
        end;

        if not p492 then
            return true;
        end;

        if u61 < p491.Index then
            return true;
        end;

        if not canToolUseHotbarSlot(p492, p491.Index) then
            return false;
        end;

        if typeof(p492) == "table" and (p492.IsVirtualAsset or p492.IsVirtualEgg) then
            return getHotbarFillTool(p492) ~= nil;
        end;

        getAttribute(p492, "ItemType");

        return true;
    end;

    local function shouldAllowSlotDragging(p493) -- Line: 2686
        -- upvalues: u463 (copy), canPlaceToolInSlot (copy), u61 (ref), u33 (ref)
        local v494 = p493 or u463.Tool;

        if not v494 then
            return false;
        end;

        if typeof(v494) ~= "Instance" and (typeof(v494) ~= "table" or not (v494.IsVirtualAsset or v494.IsVirtualEgg)) then
            return false;
        end;

        getAttribute(v494, "ItemType");

        if false then
            return false;
        end;

        if not canPlaceToolInSlot(u463, v494) then
            return false;
        end;

        if UserInputService.VREnabled then
            return false;
        end;

        return u463.Index > u61 or u33.Visible;
    end;

    local function applySlotDraggableState(p495) -- Line: 2714
        -- upvalues: u3 (ref), u485 (ref)
        if u3 then
            u485:SetAttribute("Draggable", p495);

            return;
        end;

        u485.Draggable = p495;
    end;

    local function stopCooldownHeartbeat() -- Line: 2722
        -- upvalues: u475 (ref)
        if u475 then
            u475:Disconnect();
            u475 = nil;
        end;
    end;

    local function disconnectCooldownConnections() -- Line: 2729
        -- upvalues: u474 (ref)
        for _, v in ipairs(u474) do
            v:Disconnect();
        end;

        u474 = {};
    end;

    local function hideCooldownOverlay() -- Line: 2736
        -- upvalues: u475 (ref), u486 (ref), u487 (ref)
        if u475 then
            u475:Disconnect();
            u475 = nil;
        end;

        if u486 then
            u486.Visible = false;
        end;

        if u487 then
            u487.Visible = false;
            u487.Text = "";
        end;
    end;

    local function updateCooldownDisplay() -- Line: 2747
        -- upvalues: u463 (copy), u475 (ref), u486 (ref), u487 (ref)
        local Tool = u463.Tool;

        if not Tool then
            if u475 then
                u475:Disconnect();
                u475 = nil;
            end;

            if u486 then
                u486.Visible = false;
            end;

            if u487 then
                u487.Visible = false;
                u487.Text = "";
            end;

            return false;
        end;

        local v496 = Tool:GetAttribute("CooldownEndTime");

        if typeof(v496) ~= "number" or v496 <= 0 then
            if u475 then
                u475:Disconnect();
                u475 = nil;
            end;

            if u486 then
                u486.Visible = false;
            end;

            if u487 then
                u487.Visible = false;
                u487.Text = "";
            end;

            return false;
        end;

        if not Tool:GetAttribute("CooldownActive") then
            if u475 then
                u475:Disconnect();
                u475 = nil;
            end;

            if u486 then
                u486.Visible = false;
            end;

            if u487 then
                u487.Visible = false;
                u487.Text = "";
            end;

            return false;
        end;

        local v497 = v496 - workspace:GetServerTimeNow();

        if v497 > 1 then
            if u486 then
                u486.Visible = true;
            end;

            if u487 then
                u487.Visible = true;
                local v498 = math.ceil(v497);
                local v499 = math.max(v498, 0);
                u487.Text = tostring(v499);
            end;

            return true;
        end;

        if u475 then
            u475:Disconnect();
            u475 = nil;
        end;

        if u486 then
            u486.Visible = false;
        end;

        if u487 then
            u487.Visible = false;
            u487.Text = "";
        end;

        return false;
    end;

    local function ensureCooldownHeartbeat(u500) -- Line: 2784
        -- upvalues: u475 (ref), RunService (ref), u463 (copy), u486 (ref), u487 (ref), updateCooldownDisplay (copy)
        if u475 then
            return;
        end;

        u475 = RunService.Heartbeat:Connect(function() -- Line: 2789
            -- upvalues: u463 (ref), u500 (copy), u475 (ref), u486 (ref), u487 (ref), updateCooldownDisplay (ref)
            if u463.Tool == u500 then
                if not updateCooldownDisplay() and u475 then
                    u475:Disconnect();
                    u475 = nil;
                end;

                return;
            end;

            if u475 then
                u475:Disconnect();
                u475 = nil;
            end;

            if u486 then
                u486.Visible = false;
            end;

            if u487 then
                u487.Visible = false;
                u487.Text = "";
            end;

            if u475 then
                u475:Disconnect();
                u475 = nil;
            end;
        end);
    end;

    local function connectCooldownListeners(u501) -- Line: 2802
        -- upvalues: disconnectCooldownConnections (copy), u475 (ref), u486 (ref), u487 (ref), updateCooldownDisplay (copy), RunService (ref), u463 (copy), u474 (ref)
        disconnectCooldownConnections();

        if u475 then
            u475:Disconnect();
            u475 = nil;
        end;

        if u486 then
            u486.Visible = false;
        end;

        if u487 then
            u487.Visible = false;
            u487.Text = "";
        end;

        if not u501 then
            return;
        end;

        local function onAttributeChanged() -- Line: 2810
            -- upvalues: updateCooldownDisplay (ref), u501 (copy), u475 (ref), RunService (ref), u463 (ref), u486 (ref), u487 (ref)
            if not updateCooldownDisplay() then
                if u475 then
                    u475:Disconnect();
                    u475 = nil;
                end;

                return;
            end;

            local u502 = u501;

            if u475 then
                return;
            end;

            u475 = RunService.Heartbeat:Connect(function() -- Line: 2789
                -- upvalues: u463 (ref), u502 (copy), u475 (ref), u486 (ref), u487 (ref), updateCooldownDisplay (ref)
                if u463.Tool == u502 then
                    if not updateCooldownDisplay() and u475 then
                        u475:Disconnect();
                        u475 = nil;
                    end;

                    return;
                end;

                if u475 then
                    u475:Disconnect();
                    u475 = nil;
                end;

                if u486 then
                    u486.Visible = false;
                end;

                if u487 then
                    u487.Visible = false;
                    u487.Text = "";
                end;

                if u475 then
                    u475:Disconnect();
                    u475 = nil;
                end;
            end);
        end;

        local v503 = u501:GetAttributeChangedSignal("CooldownEndTime");
        table.insert(u474, v503:Connect(onAttributeChanged));
        local v504 = u501:GetAttributeChangedSignal("CooldownActive");
        table.insert(u474, v504:Connect(onAttributeChanged));
        local v505 = u501:GetAttributeChangedSignal("CooldownDuration");
        table.insert(u474, v505:Connect(onAttributeChanged));

        if not updateCooldownDisplay() then
            if u475 then
                u475:Disconnect();
                u475 = nil;
            end;

            return;
        end;

        if u475 then
            return;
        end;

        u475 = RunService.Heartbeat:Connect(function() -- Line: 2789
            -- upvalues: u463 (ref), u501 (copy), u475 (ref), u486 (ref), u487 (ref), updateCooldownDisplay (ref)
            if u463.Tool == u501 then
                if not updateCooldownDisplay() and u475 then
                    u475:Disconnect();
                    u475 = nil;
                end;

                return;
            end;

            if u475 then
                u475:Disconnect();
                u475 = nil;
            end;

            if u486 then
                u486.Visible = false;
            end;

            if u487 then
                u487.Visible = false;
                u487.Text = "";
            end;

            if u475 then
                u475:Disconnect();
                u475 = nil;
            end;
        end);
    end;

    function u463.updateDragAppearance(p506) -- Line: 2835
        -- upvalues: u463 (copy), u485 (ref), u464 (copy), u3 (ref)
        if u463.IsFakeSlot then
            u485.BackgroundTransparency = SlotLockedTransparencyAttribute;
            u485.BackgroundColor3 = BackgroundColorAttribute;

            return;
        end;

        u485.SelectionImageObject = nil;
        local v507 = p506.Tool and getAttribute(p506.Tool, "ItemType");

        if not u464 then
            local v508 = u3 and u485:GetAttribute("Draggable") or u485.Draggable;
            u485.BackgroundTransparency = SlotLockedTransparencyAttribute;
            u485.BackgroundColor3 = v508 and DraggableColorAttribute or BackgroundColorAttribute;

            return;
        end;

        local _ = v507 == "Asset" and true or v507 == "Sword";
        u485.BackgroundTransparency = 0.5;
        u485.BackgroundColor3 = Color3.new(0, 0, 0);
    end;

    function u463.Readjust(p509, p510, p511) -- Line: 2857
        -- upvalues: u42 (ref), u21 (ref), u485 (ref)
        u485.Position = UDim2.new(0, u42.Size.X.Offset / 2 - u21 / 2 + (u21 + 5) * (p510 - (p511 / 2 + 0.5)), 0, 5);
    end;

    function u463.SetNumberText(p512, p513) -- Line: 2863
        -- upvalues: u479 (ref), u481 (ref)
        if u479 then
            u479.Text = p513 or (u481 or "");
        end;
    end;

    function u463.Fill(u514, u515) -- Line: 2868
        -- upvalues: canPlaceToolInSlot (copy), clearSlotOverlays (copy), u472 (ref), u473 (ref), disconnectCooldownConnections (copy), u475 (ref), u486 (ref), u487 (ref), u61 (ref), AssetIconShape (ref), Icon (ref), u467 (ref), u482 (ref), u483 (ref), u466 (ref), u469 (ref), u470 (ref), u468 (ref), u464 (copy), u477 (ref), u478 (ref), u463 (copy), u471 (ref), connectCooldownListeners (copy), shouldAllowSlotDragging (copy), u3 (ref), u485 (ref), u52 (ref), u54 (ref), u22 (ref), u49 (ref), u488 (copy), u48 (ref), u33 (ref), u57 (ref)
        if u514.IsFakeSlot and u514.FakeType ~= "SwordEquip" then
            return;
        end;

        if u515 and not canPlaceToolInSlot(u514, u515) then
            return;
        end;

        clearSlotOverlays();

        if u472 then
            u472:Disconnect();
            u472 = nil;
        end;

        if u473 then
            u473:Disconnect();
            u473 = nil;
        end;

        disconnectCooldownConnections();

        if u475 then
            u475:Disconnect();
            u475 = nil;
        end;

        if u486 then
            u486.Visible = false;
        end;

        if u487 then
            u487.Visible = false;
            u487.Text = "";
        end;

        if not u515 then
            return u514:Clear();
        end;

        if u514.Tool and u514.Tool ~= u515 then
            u514:Clear();
        end;

        local v516 = typeof(u515) == "Instance";
        local u517 = getAttribute(u515, "ItemType");
        local v518 = getRegisteredBackpackSlot(u515);

        if v518 and (v518 ~= u514 and registeredSlotContainsTool(v518, u515)) then
            v518:Clear();

            if u61 < v518.Index then
                v518:Delete();
            end;
        end;

        u514.Tool = u515;
        registerVirtualBackpackSlot(u514, u515);
        u514:UpdateFavoriteVisual();

        if v516 then
            u472 = u515:GetAttributeChangedSignal("Favorite"):Connect(function() -- Line: 2908
                -- upvalues: u514 (copy), u515 (copy)
                u514:UpdateFavoriteVisual();

                if isAssetTool(u515) then
                    UpdateInventorySlots();
                end;
            end);
        end;

        function u463.UpdateVisuals() -- Line: 2915
            -- upvalues: u515 (copy), AssetIconShape (ref), Icon (ref), u467 (ref), u482 (ref), u483 (ref), u466 (ref), u469 (ref), u470 (ref), u468 (ref), u517 (copy), u464 (ref), u477 (ref), u478 (ref), u514 (copy), u61 (ref)
            local TextureId = u515.TextureId;
            AssetIconShape.Clear(Icon);
            Icon.Image = TextureId;
            Icon.ScaleType = Enum.ScaleType.Fit;
            u467.TextXAlignment = u482;
            u467.TextYAlignment = u483;
            u466.Visible = false;
            clearMutationIconFrame(u469, u470);

            for _, child in ipairs(u466:GetChildren()) do
                if child:IsA("UIGradient") then
                    child:Destroy();
                end;
            end;

            for _, child in ipairs(u467:GetChildren()) do
                if child:IsA("UIGradient") then
                    child:Destroy();
                end;
            end;

            for _, child in ipairs(u468:GetChildren()) do
                if child:IsA("UIGradient") then
                    child:Destroy();
                end;
            end;

            local v519 = string.match(u515.Name, "%[X(%d+)%]");
            local Name = u515.Name;
            local v520 = true;
            local v521 = "";
            local v522 = false;
            local v523;

            if u517 == "Asset" then
                local v524 = getAttribute(u515, "Category");

                if v524 then
                    v524 = AssetDirectory[v524];
                end;

                if v524 then
                    local v525 = getAssetItemData(u515);

                    if v525 then
                        AssetIconShape.Apply(Icon, v525);
                    else
                        Icon.Image = v524.Icon or TextureId;
                    end;

                    Icon.ImageColor3 = Color3.new(1, 1, 1);

                    if v524.Rarity and v524.Rarity.Gradient then
                        v524.Rarity.Gradient:Clone().Parent = u467;

                        if u464 then
                            v524.Rarity.Gradient:Clone().Parent = u466;
                        end;
                    end;
                end;

                u466.Visible = u464;
                local v526 = getAssetItemData(u515);

                if v526 then
                    Name = getAssetItemDisplayNameWithVisualWeight(v526, v524 or BaseAssetConfig);
                else
                    Name = getAttribute(u515, "DisplayName") or u515.Name;
                end;

                local v527 = parseMutations(getAttribute(u515, "Mutations"));
                local v528 = getAttribute(u515, "BaseMutation");
                v520 = true;

                if u464 or typeof(u515) == "table" and u515.IsVirtualAsset then
                    populateMutationIconFrame(u469, u470, v528, v527);
                    v521 = "";
                    v522 = false;

                    if not u464 then
                        v520 = false;
                    end;
                else
                    Name = "";
                end;

                v523 = Name;
            elseif u517 == "AssetEgg" then
                local v529 = getEggRecordFromTool(u515);
                local v530, v531 = getEggConfigForRecord(v529);

                if v530 and v531 then
                    if v530.Icon ~= "" then
                        TextureId = v530.Icon or TextureId;
                    end;

                    Icon.Image = TextureId;
                    Icon.ImageColor3 = Color3.new(1, 1, 1);

                    if not v530.HideRarity and (v531.Rarity and v531.Rarity.Gradient) then
                        v531.Rarity.Gradient:Clone().Parent = u467;

                        if u464 then
                            v531.Rarity.Gradient:Clone().Parent = u466;
                        end;
                    end;
                end;

                u466.Visible = u464;

                if v529 then
                    Name = getEggDisplayNameWithWeight(v529);
                else
                    Name = getAttribute(u515, "DisplayName") or u515.Name;
                end;

                v523 = Name;
                v520 = true;
                v521 = "";
                v522 = false;
            elseif u517 == "Gear" then
                local v532 = getGearConfig(u515);
                Icon.Image = (not TextureId or (TextureId == "" or not TextureId)) and (v532 and v532.Icon or "") or TextureId;
                Icon.ImageColor3 = Color3.new(1, 1, 1);
                u466.Visible = false;
                v523 = "";
                Name = not shouldDisplayGearUses(u515) and "" or getGearUsesText(u515);
                v520 = Name ~= "";

                if v520 then
                    u467.TextXAlignment = Enum.TextXAlignment.Center;
                    u467.TextYAlignment = Enum.TextYAlignment.Center;
                    v521 = "";
                    v522 = false;
                else
                    v521 = "";
                    v522 = false;
                end;
            elseif TextureId == "" then
                v523 = Name;
                v522 = false;
            else
                v522 = false;

                if v519 then
                    Name = "";
                    v523 = "";
                else
                    v523 = Name;
                    v520 = false;
                end;
            end;

            if not u464 then
                if u517 ~= "Gear" or not shouldDisplayGearUses(u515) then
                    Name = "";
                    v523 = "";
                    v520 = false;
                end;

                v521 = "";
                v522 = false;
            end;

            u467.Text = Name or v523;
            u467.Visible = v520;
            u468.Text = v521;
            u468.Visible = v522;

            if u477 then
                u477.Visible = true;
            end;

            if u478 and u515:IsA("Tool") then
                local v533;

                if u514.Index <= u61 then
                    v533 = (u517 == "Asset" or (u517 == "Pet" or u517 == "AssetEgg")) and true or u517 == "Gear";
                else
                    v533 = false;
                end;

                if v533 then
                    u478.Text = "";
                    u478.Visible = false;

                    return;
                end;

                local ToolTip = u515.ToolTip;

                if ToolTip == "" then
                    ToolTip = u515.Name;
                end;

                u478.Text = ToolTip;
            end;
        end;

        u463.UpdateVisuals();

        if u471 then
            u471:Disconnect();
            u471 = nil;
        end;

        if v516 then
            u471 = u515.Changed:Connect(function(p534) -- Line: 3087
                -- upvalues: u463 (ref)
                if p534 == "TextureId" or (p534 == "Name" or p534 == "ToolTip") then
                    u463.UpdateVisuals();
                end;
            end);
        end;

        if v516 and u517 == "Asset" then
            u473 = u515:GetAttributeChangedSignal("Weight"):Connect(function() -- Line: 3094
                UpdateInventorySlots();
            end);
        elseif v516 and u517 == "Gear" then
            u473 = u515:GetAttributeChangedSignal("Uses"):Connect(function() -- Line: 3098
                -- upvalues: u463 (ref)
                u463.UpdateVisuals();
            end);
            connectCooldownListeners(u515);
        end;

        local v535 = u514.Index <= u61;
        local v536 = shouldAllowSlotDragging(u515);

        if u3 then
            u485:SetAttribute("Draggable", v536);
        else
            u485.Draggable = v536;
        end;

        u514:UpdateEquipView();

        if v535 and not u514.IsFakeSlot then
            u52 = u52 + 1;

            if u54 and (u52 >= 1 and not u22) then
                u22 = true;
                ContextActionService:BindAction("RBXHotbarEquip", changeTool, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1);
            end;
        end;

        if typeof(u515) == "Instance" then
            u49[u515] = u514;
        end;

        if u517 == "Asset" then
            local v537 = AssetDirectory[getAttribute(u515, "Category")] or BaseAssetConfig;
            local v538 = getAssetItemData(u515) or {};
            addVirtualAssetOverlay(u485, v538, v537, u488);
        else
            local v539 = u517 == "AssetEgg" and getEggRecordFromTool(u515);

            if v539 then
                addVirtualEggOverlay(u485, v539, u488);
            end;
        end;

        u48 = FindLowestEmpty();

        if u464 and (u33.Visible and not u57) then
            u485.Visible = IsOfCategory(u515);
        end;
    end;

    function u463.Clear(p540) -- Line: 3142
        -- upvalues: clearSlotOverlays (copy), u471 (ref), u472 (ref), u473 (ref), disconnectCooldownConnections (copy), u475 (ref), u486 (ref), u487 (ref), u466 (ref), AssetIconShape (ref), Icon (ref), u467 (ref), u468 (ref), u478 (ref), u3 (ref), u485 (ref), u480 (ref), u61 (ref), u52 (ref), u22 (ref), u48 (ref)
        if not p540.Tool then
            return;
        end;

        if p540.IsFakeSlot then
            return;
        end;

        clearSlotOverlays();

        if u471 then
            u471:Disconnect();
            u471 = nil;
        end;

        if u472 then
            u472:Disconnect();
            u472 = nil;
        end;

        if u473 then
            u473:Disconnect();
            u473 = nil;
        end;

        disconnectCooldownConnections();

        if u475 then
            u475:Disconnect();
            u475 = nil;
        end;

        if u486 then
            u486.Visible = false;
        end;

        if u487 then
            u487.Visible = false;
            u487.Text = "";
        end;

        for _, child in ipairs(u466:GetChildren()) do
            if child:IsA("UIGradient") then
                child:Destroy();
            end;
        end;

        u466.Visible = false;
        AssetIconShape.Clear(Icon);
        Icon.Image = "";
        u467.Text = "";
        u467.Visible = true;
        u468.Text = "";
        u468.Visible = false;

        if u478 then
            u478.Text = "";
            u478.Visible = false;
        end;

        if u3 then
            u485:SetAttribute("Draggable", false);
        else
            u485.Draggable = false;
        end;

        u480.Visible = false;
        p540:UpdateEquipView(true);

        if p540.Index <= u61 and not p540.IsFakeSlot then
            u52 = u52 - 1;

            if u52 < 1 then
                u22 = false;
                ContextActionService:UnbindAction("RBXHotbarEquip");
            end;
        end;

        unregisterBackpackSlotTool(p540, p540.Tool);
        p540.Tool = nil;
        u48 = FindLowestEmpty();
    end;

    function u463.UpdateEquipView(p541, p542) -- Line: 3199
        -- upvalues: u65 (ref), u79 (ref), u28 (ref), u476 (ref), u485 (ref)
        if p541.IsFakeSlot then
            return;
        end;

        local v543 = false;
        local v544 = getAttribute(p541.Tool, "ItemType");

        if v544 == "Asset" and (typeof(p541.Tool) == "table" and p541.Tool.IsVirtualAsset) then
            v543 = not p542 and virtualAssetMatchesUID(p541.Tool, u65);
        elseif v544 == "AssetEgg" and (typeof(p541.Tool) == "table" and p541.Tool.IsVirtualEgg) then
            v543 = not p542;

            if v543 then
                if typeof(u79) == "string" then
                    v543 = p541.Tool.UID == u79;
                else
                    v543 = false;
                end;
            end;
        elseif not p542 then
            local Tool = p541.Tool;
            v543 = Tool and (typeof(Tool) == "Instance" and Tool.Parent == u28) and true or v543;
        end;

        if not v543 then
            if u476 then
                u476.Parent = nil;
            end;

            return;
        end;

        if not u476 then
            u476 = NewGui("Frame", "Equipped");
            u476.ZIndex = 3;
            u476.Size = UDim2.fromScale(1, 1);
            u476.AnchorPoint = Vector2.new(0.5, 0.5);
            u476.Position = UDim2.fromScale(0.5, 0.5);
            local UICorner2 = Instance.new("UICorner");
            UICorner2.CornerRadius = script:GetAttribute("CornerRadius");
            UICorner2.Parent = u476;
            local UIStroke = Instance.new("UIStroke");
            UIStroke.Color = EquippedColorAttribute;
            UIStroke.Thickness = 3.8;
            UIStroke.Parent = u476;
        end;

        u476.Parent = u485;
    end;

    function u463.Delete(p545) -- Line: 3237
        -- upvalues: clearSlotOverlays (copy), disconnectCooldownConnections (copy), u475 (ref), u486 (ref), u487 (ref), u51 (ref), u485 (ref), u30 (ref), u10 (ref), u47 (ref)
        if p545.IsFakeSlot or p545.IsDeleted then
            return;
        end;

        p545.IsDeleted = true;

        if p545.Tool then
            p545:Clear();
        end;

        clearSlotOverlays();
        disconnectCooldownConnections();

        if u475 then
            u475:Disconnect();
            u475 = nil;
        end;

        if u486 then
            u486.Visible = false;
        end;

        if u487 then
            u487.Visible = false;
            u487.Text = "";
        end;

        if u51[u485] then
            u51[u485] = nil;
            u30:unlock();

            if u10 then
                u10:Destroy();
            end;
        end;

        u485:Destroy();
        local v546 = table.find(u47, p545);

        if v546 then
            table.remove(u47, v546);

            for i = v546, #u47 do
                u47[i]:SlideBack();
            end;
        end;

        UpdateScrollingFrameCanvasSize();
    end;

    function u463.UpdateFavoriteVisual(p547) -- Line: 3269
        -- upvalues: u480 (ref)
        if u480 and p547.Tool then
            local v548 = isToolFavorite(p547.Tool);

            if u480.Visible ~= v548 then
                u480.Visible = v548;

                return true;
            end;
        end;

        return false;
    end;

    function u463.Swap(p549, p550) -- Line: 3280
        -- upvalues: canPlaceToolInSlot (copy)
        if p549.IsFakeSlot or p550.IsFakeSlot then
            return;
        end;

        local Tool = p549.Tool;
        local Tool2 = p550.Tool;

        if Tool and (isToolLockedToCurrentHotbarSlot(p549) and p550 ~= p549) then
            return;
        end;

        if Tool2 and (isToolLockedToCurrentHotbarSlot(p550) and p549 ~= p550) then
            return;
        end;

        if Tool and not canPlaceToolInSlot(p550, Tool) then
            return;
        end;

        if Tool2 and not canPlaceToolInSlot(p549, Tool2) then
            return;
        end;

        p549:Clear();

        if Tool2 then
            p550:Clear();
            p549:Fill(Tool2);
        end;

        if Tool then
            p550:Fill(Tool);

            return;
        end;

        p550:Clear();
    end;

    function u463.SlideBack(p551) -- Line: 3314
        -- upvalues: u485 (ref)
        p551.Index = p551.Index - 1;
        u485.Name = p551.Index;
        u485.LayoutOrder = p551.Index;
    end;

    function u463.TurnNumber(p552, p553) -- Line: 3319
        -- upvalues: u479 (ref)
        if u479 then
            u479.Visible = p553;
        end;
    end;

    local u554 = nil;

    function u463.SetClickability(p555, p556) -- Line: 3327
        -- upvalues: shouldAllowSlotDragging (copy), u51 (ref), u485 (ref), u554 (ref), u3 (ref)
        if p555.IsFakeSlot then
            return;
        end;

        if p555.Tool then
            local v557 = not p556 and shouldAllowSlotDragging(p555.Tool);

            if not v557 and u51[u485] then
                u554(UserInputService:GetMouseLocation());
            end;

            if u3 then
                u485:SetAttribute("Draggable", v557);
            else
                u485.Draggable = v557;
            end;

            p555:updateDragAppearance();
        end;
    end;

    function u463.CheckTerms(p558, p559) -- Line: 3341
        -- upvalues: u467 (ref), u478 (ref)
        local v560 = 0;
        local Tool = p558.Tool;

        if Tool then
            local v561 = {};

            if u467 and u467.Text ~= "" then
                table.insert(v561, u467.Text:lower());
            end;

            local v562 = typeof(Tool) == "table" and Tool.Name or Tool.Name;

            if v562 then
                local v563 = tostring(v562);
                table.insert(v561, v563:lower());
            end;

            local v564 = u478 and u478.Text;

            if v564 and v564 ~= "" then
                table.insert(v561, v564:lower());
            end;

            local v565 = typeof(Tool) == "table" and Tool.ToolTip or Tool.ToolTip;

            if v565 and v565 ~= "" then
                local v566 = tostring(v565);
                table.insert(v561, v566:lower());
            end;

            for i in pairs(p559) do
                for _, v in ipairs(v561) do
                    local _, v567 = v:gsub(i, "");
                    v560 = v560 + v567;
                end;
            end;
        end;

        return v560;
    end;

    function u463.Select(p568) -- Line: 3374
        -- upvalues: u15 (ref), u61 (ref), u14 (ref), u29 (ref), u28 (ref), u65 (ref), Backpack (ref)
        local Tool = p568.Tool;

        if Tool and u15 then
            if u15.ItemType == getAttribute(Tool, "ItemType") and (u61 < p568.Index or u15.AllowHotbar) then
                local Validator = u15.Validator;

                if not Validator or Validator(Tool) ~= false then
                    local v569 = u15;

                    if ActiveFuseSelectionState then
                        u14:EndFuseSelection();
                        task.spawn(v569.Callback, Tool);

                        return;
                    end;

                    v569.Callback(Tool);

                    if v569.Preserve ~= true then
                        u15 = nil;
                    end;

                    return;
                end;
            end;

            if ActiveFuseSelectionState then
                return;
            end;
        end;

        if Tool then
            if not BackpackEnabled or (not BackpackGui.Enabled or Variables.Locks.HideUI:IsLocked()) then
                return;
            end;

            if typeof(Tool) == "table" and Tool.IsVirtualAsset then
                local v570 = _getAssetUID(Tool);

                if typeof(v570) ~= "string" then
                    return;
                end;

                SelectedSlot = p568;
                local v571 = findAssetToolByUID(v570);

                if v571 and u29 then
                    if v571.Parent == u28 then
                        u29:UnequipTools();
                    else
                        u29:UnequipTools();
                        u29:EquipTool(v571);
                    end;
                elseif u65 == v570 then
                    requestUnequipVirtualAsset();
                end;

                updateEquipSelectionVisuals();

                return;
            end;

            if typeof(Tool) == "table" and Tool.IsVirtualEgg then
                local v572 = reconcileVirtualEggEquipState();
                local v573 = getAttribute(Tool, "UID");

                if typeof(v573) ~= "string" then
                    return;
                end;

                if v572 == v573 then
                    requestUnequipVirtualEgg();

                    return;
                end;

                requestEquipVirtualEgg(v573, p568);

                return;
            end;

            SelectedSlot = p568;

            if Tool.Parent == u28 then
                SelectedSlot = nil;

                if u29 then
                    UnequipAllTools();
                end;
            elseif Tool.Parent == Backpack then
                if u29 then
                    UnequipAllTools();
                end;

                Tool.Parent = u28;
            end;
        end;
    end;

    u463.MainImage = u485.ImageLabel;
    local BaseTemplate = u485.BaseTemplate;
    BaseTemplate.Amount.Visible = false;
    BaseTemplate.Amount.Text = "";
    u469 = BaseTemplate:FindFirstChild("Mutations");
    local v574 = u469 and u469:FindFirstChild("Template");
    u470 = v574;
    clearMutationIconFrame(u469, u470);
    local UIStroke = u485.UIStroke;
    UIStroke.Thickness = 0;
    u485.BackgroundColor3 = u464 and Color3.new(0, 0, 0) or BackgroundColorAttribute;
    UIStroke.Color = BorderColorAttribute;
    u485.Text = "";
    u485.AutoButtonColor = false;
    u485.BorderSizePixel = 0;
    local v575 = p460 == u40 and u25 or u21;
    u485.Size = UDim2.new(0, v575, 0, v575);
    u485.Active = true;
    u485.Draggable = false;

    if u3 then
        u485:SetAttribute("Draggable", false);
    end;

    u485:SetAttribute("IsInventorySlot", u464);
    u485.BackgroundTransparency = u464 and 0.5 or SlotLockedTransparencyAttribute;
    ButtonFX(u485, 1.015, nil, true);
    u485.MouseButton1Click:Connect(function() -- Line: 3489
        -- upvalues: u463 (copy), u18 (ref)
        if os.clock() < 0 then
            return;
        end;

        local Tool = u463.Tool;

        if u18 and (Tool and isAssetTool(Tool)) then
            requestFavoriteToggle(Tool);

            return;
        end;

        changeSlot(u463);
    end);

    if UserInputService.TouchEnabled then
        u485.TouchLongPress:Connect(function(p576, p577, p578) -- Line: 3503
            -- upvalues: u463 (copy)
            if p577 == Enum.UserInputState.End then
                local Tool = u463.Tool;

                if Tool and isAssetTool(Tool) then
                    requestFavoriteToggle(Tool);
                end;
            end;
        end);
    else
        u485.MouseButton2Click:Connect(function() -- Line: 3512
            -- upvalues: u463 (copy)
            local Tool = u463.Tool;

            if Tool and isAssetTool(Tool) then
                requestFavoriteToggle(Tool);
            end;
        end);
    end;

    u463.Frame = u485;
    u477 = u485.SelectionObjectClipper.Selector;
    u466 = u485.Shadow;
    u466.Visible = false;
    u463.IconImage = Icon;
    u480 = u485.FavIcon;
    u480.Visible = false;
    u467 = u485.ToolName;
    u482 = u467.TextXAlignment;
    u483 = u467.TextYAlignment;
    u468 = u485.Weight;
    u468.Visible = false;
    u463.Frame.LayoutOrder = u463.Index;

    if v462 <= u61 then
        u485.StrokeFrame.Visible = false;
        u478 = u485.ToolTip;
        u478.Visible = false;
        u463.TooltipLabel = u478;
        u485.MouseEnter:Connect(function() -- Line: 3544
            -- upvalues: u478 (ref)
            if u478.Text ~= "" then
                u478.Visible = false;
            end;
        end);
        u485.MouseLeave:Connect(function() -- Line: 3549
            -- upvalues: u478 (ref)
            u478.Visible = false;
        end);

        function u463.MoveToInventory(p579) -- Line: 3552
            -- upvalues: u61 (ref), u40 (ref), u28 (ref), u29 (ref), u57 (ref), u33 (ref)
            if p579.IsFakeSlot then
                return;
            end;

            if isToolLockedToCurrentHotbarSlot(p579) then
                return;
            end;

            if p579.Index <= u61 then
                local Tool = p579.Tool;
                p579:Clear();
                local v580 = MakeSlot(u40);
                v580:Fill(Tool);

                if Tool and (Tool.Parent == u28 and u29) then
                    UnequipAllTools();
                end;

                if Tool and (typeof(Tool) == "Instance" and getAttribute(Tool, "ItemType") == "Asset") then
                    task.defer(syncAssetsFromSave);
                end;

                if u57 then
                    v580.Frame.Visible = false;
                    v580.Frame.Parent = u33;
                end;
            end;
        end;

        if v462 <= 10 then
            local v581 = v462 <= 10 and (v462 or 0) or 0;
            u479 = u485.Number;
            u479.Text = v581;
            u481 = tostring(v581);
            u479.Visible = false;

            u50[Value + v581] = function() -- Line: 3583
                -- upvalues: u463 (copy)
                changeSlot(u463);
            end;
        end;
    end;

    local Position = u485.Position;
    local u582 = 0;
    local u583 = nil;
    local u584 = nil;

    local function startDrag(p585) -- Line: 3592
        -- upvalues: u463 (copy), shouldAllowSlotDragging (copy), u3 (ref), u485 (ref), u51 (ref), Position (ref), UIStroke (copy), u30 (ref), u584 (ref), LocalPlayer (ref), u465 (ref), u476 (ref), u583 (ref), u40 (ref), u33 (ref), u10 (ref)
        if not (u463.Tool and shouldAllowSlotDragging(u463.Tool)) then
            if u3 then
                u485:SetAttribute("Draggable", false);
            else
                u485.Draggable = false;
            end;

            u463:updateDragAppearance();

            return;
        end;

        u51[u485] = true;
        Position = p585;
        UIStroke.Thickness = 2;
        u30:lock();

        if u584 then
            u584:Disconnect();
            u584 = nil;
        end;

        if u463.Tool and typeof(u463.Tool) == "Instance" then
            u584 = u463.Tool.AncestryChanged:Connect(function(p586, p587) -- Line: 3608
                -- upvalues: u463 (ref), u584 (ref), LocalPlayer (ref), u465 (ref)
                if u463.Tool and p586 == u463.Tool then
                    local Parent = u463.Tool.Parent;

                    if Parent ~= LocalPlayer.Backpack and Parent ~= LocalPlayer.Character then
                        if u465 then
                            u465:Destroy();
                            u465 = nil;
                        end;

                        if u584 then
                            u584:Disconnect();
                            u584 = nil;
                        end;
                    end;
                elseif u584 then
                    u584:Disconnect();
                    u584 = nil;
                end;
            end);
        end;

        u485.ZIndex = 22;
        u485.Parent.ZIndex = 22;

        if u476 then
            u476.ZIndex = 22;

            for _, child in u476:GetChildren() do
                if not (child:IsA("UICorner") or child:IsA("UIStroke")) then
                    child.ZIndex = 22;
                end;
            end;
        end;

        u583 = u485.Parent;

        if u583 == u40 then
            local v588 = UDim2.new(0, u485.AbsolutePosition.X - u33.AbsolutePosition.X, 0, u485.AbsolutePosition.Y - u33.AbsolutePosition.Y);
            u485.Parent = u33;
            u485.Position = v588;
            u465 = NewGui("Frame", "FakeSlot");
            u465.LayoutOrder = u485.LayoutOrder;
            u465.Size = u485.Size;
            u465.BackgroundTransparency = 1;
            u465.Parent = u40;
            u10 = u465;
        end;
    end;

    u554 = function(p589) -- Line: 3658
        -- upvalues: u51 (ref), u485 (ref), u465 (ref), u584 (ref), Position (ref), u583 (ref), UIStroke (copy), u30 (ref), u476 (ref), u463 (copy), shouldAllowSlotDragging (copy), u3 (ref), u33 (ref), u61 (ref), u2 (ref), u4 (ref), u8 (ref), u7 (ref), u6 (ref), u582 (ref), u48 (ref), canPlaceToolInSlot (copy), u42 (ref), u47 (ref), u28 (ref), u29 (ref), u57 (ref)
        u51[u485] = nil;

        if u465 then
            u465:Destroy();
            u465 = nil;
        end;

        if u584 then
            u584:Disconnect();
            u584 = nil;
        end;

        local v590 = tick();
        u485.Position = Position;

        if u583 and u485.Parent ~= u583 then
            u485.Parent = u583;
        end;

        UIStroke.Thickness = 0;
        u30:unlock();
        u485.ZIndex = 20;

        if u583 then
            u583.ZIndex = 20;
        end;

        if u476 then
            u476.ZIndex = 20;

            for _, child in u476:GetChildren() do
                if not (child:IsA("UICorner") or child:IsA("UIStroke")) then
                    child.ZIndex = 20;
                end;
            end;
        end;

        if not u463.Tool then
            return;
        end;

        if not shouldAllowSlotDragging(u463.Tool) then
            if u3 then
                u485:SetAttribute("Draggable", false);
            else
                u485.Draggable = false;
            end;

            u463:updateDragAppearance();

            return;
        end;

        if CheckBounds(u33, p589.X, p589.Y) then
            if u463.Index <= u61 then
                if u2 ~= u4 then
                    u8((GetCategory(u463.Tool)));
                end;

                u463:MoveToInventory();
                u7.Text = "";
                task.delay(0.01, function() -- Line: 3704
                    -- upvalues: u6 (ref)
                    if u6 then
                        u6(true);
                    end;
                end);
            end;

            if u61 < u463.Index and v590 - u582 < 0.5 then
                if u48 and canPlaceToolInSlot(u48, u463.Tool) then
                    local Tool = u463.Tool;
                    u463:Clear();
                    u48:Fill(Tool);
                    u463:Delete();
                    v590 = 0;
                else
                    v590 = 0;
                end;
            end;
        elseif CheckBounds(u42, p589.X, p589.Y) then
            local v591 = { (1 / 0), nil };

            for i = 1, u61 do
                local v592 = u47[i];
                local v593 = GetOffset(v592.Frame, p589);

                if v593 < v591[1] then
                    v591 = { v593, v592 };
                end;
            end;

            local v594 = v591[2];

            if v594 ~= u463 then
                u463:Swap(v594);

                if u61 < u463.Index then
                    local Tool = u463.Tool;

                    if Tool then
                        if Tool.Parent == u28 and u29 then
                            UnequipAllTools();
                        end;

                        if u57 then
                            u463.Frame.Visible = false;
                            u463.Frame.Parent = u33;
                        end;
                    else
                        u463:Delete();
                    end;
                end;
            end;
        elseif u463.Index <= u61 then
            u463:MoveToInventory();
            task.delay(0.01, function() -- Line: 3751
                -- upvalues: u6 (ref)
                if u6 then
                    u6(true);
                end;
            end);
        elseif u463.Tool and (u463.Tool:IsA("Tool") and u463.Tool.CanBeDropped) then
            u463.Tool.Parent = workspace;
        end;

        u582 = v590;
        task.delay(0.01, function() -- Line: 3761
            -- upvalues: u6 (ref)
            if u6 then
                u6(true);
            end;
        end);
    end;

    if u3 then
        local u595 = false;
        local u596 = false;
        local u597 = nil;
        local u598 = nil;

        local function drag(p599) -- Line: 3772
            -- upvalues: u598 (ref), u597 (ref), u596 (ref), u595 (ref), u51 (ref), u485 (ref)
            if u598 and u597 then
                local v600 = p599 - u597;
                u485.Position = UDim2.new(u598.X.Scale, u598.X.Offset + v600.X, u598.Y.Scale, u598.Y.Offset + v600.Y);

                return;
            end;

            u596 = false;
            u595 = false;
            u51[u485] = nil;
        end;

        u485.InputBegan:Connect(function(u601) -- Line: 3787
            -- upvalues: u485 (ref), u596 (ref), startDrag (copy), u595 (ref), u597 (ref), u598 (ref), u51 (ref), u554 (ref)
            if not u485:GetAttribute("Draggable") then
                return;
            end;

            if u601.UserInputType == Enum.UserInputType.MouseButton1 or (u601.UserInputType == Enum.UserInputType.Touch or u601.KeyCode == Enum.KeyCode.ButtonA) then
                u596 = true;
                local u605 = UserInputService.InputChanged:Connect(function(p602) -- Line: 3798
                    -- upvalues: u596 (ref), startDrag (ref), u485 (ref), u595 (ref), u597 (ref), u598 (ref), u51 (ref)
                    if u596 then
                        u596 = false;
                        startDrag(u485.Position);
                        u595 = true;
                        u597 = UserInputService:GetMouseLocation();
                        u598 = u485.Position;
                    end;

                    if u595 and (p602.UserInputType == Enum.UserInputType.MouseMovement or (p602.UserInputType == Enum.UserInputType.Touch or string.find(p602.UserInputType.Name, "Gamepad"))) then
                        local v603 = UserInputService:GetMouseLocation();

                        if not (u598 and u597) then
                            u596 = false;
                            u595 = false;
                            u51[u485] = nil;

                            return;
                        end;

                        local v604 = v603 - u597;
                        u485.Position = UDim2.new(u598.X.Scale, u598.X.Offset + v604.X, u598.Y.Scale, u598.Y.Offset + v604.Y);
                    end;
                end);
                local u606 = nil;
                u606 = u601:GetPropertyChangedSignal("UserInputState"):Connect(function() -- Line: 3818
                    -- upvalues: u595 (ref), u596 (ref), u606 (ref), u601 (copy), u605 (ref), u597 (ref), u598 (ref), u554 (ref)
                    if u595 or u596 then
                        if u601.UserInputState == Enum.UserInputState.End then
                            u605:Disconnect();
                            local v607 = u595;
                            u596 = false;
                            u595 = false;
                            u597 = nil;
                            u598 = nil;

                            if u606 then
                                u606:Disconnect();
                                u606 = nil;
                            end;

                            if v607 then
                                u554(Vector2.new(u601.Position.X, u601.Position.Y));
                            end;
                        end;

                        return;
                    end;

                    if u606 then
                        u606:Disconnect();
                        u606 = nil;
                    end;
                end);
            end;
        end);
    else
        u485.DragBegin:Connect(function(p608) -- Line: 3845
            -- upvalues: startDrag (copy)
            startDrag(p608);
        end);
        u485.DragStopped:Connect(function(p609, p610) -- Line: 3848
            -- upvalues: u554 (ref)
            u554(Vector2.new(p609, p610));
        end);
    end;

    u485.Parent = p460;
    u47[v462] = u463;

    if u61 < v462 then
        local CanvasPosition = u40.CanvasPosition;
        UpdateScrollingFrameCanvasSize();
        local v611 = u40.CanvasSize.Y.Offset - u40.AbsoluteSize.Y;

        if u33.Visible and not u57 then
            local new = Vector2.new;
            local X = CanvasPosition.X;
            local Y = CanvasPosition.Y;
            local v612 = math.max(0, v611);
            u40.CanvasPosition = new(X, (math.min(Y, v612)));
        else
            u40.CanvasPosition = CanvasPosition;
        end;
    end;

    return u463;
end;

function moveStackSlotIntoFrontHotbar(p613)
    -- upvalues: u61 (copy), u47 (copy), u48 (ref)
    if not p613 or p613.IsDeleted then
        return nil;
    end;

    if p613.Index <= u61 then
        return p613;
    end;

    local v614 = getInsertableHotbarIndices(p613.Tool);
    local v615 = v614[1];

    if not v615 then
        return nil;
    end;

    local v616 = u47[v615];

    if not v616 then
        return nil;
    end;

    local v617 = u48;

    if v617 then
        v617 = table.find(v614, v617.Index);
    end;

    if not v617 then
        local v618 = v614[#v614];

        if v618 then
            v618 = u47[v618];
        end;

        if v618 and v618.Tool then
            v618:MoveToInventory();
            v617 = #v614;
        end;
    end;

    if not v617 then
        return nil;
    end;

    for i = v617, 2, -1 do
        local v619 = u47[v614[i]];
        local v620 = u47[v614[i - 1]];

        if v619 and v620 then
            v620:Swap(v619);
        end;
    end;

    p613:Swap(v616);

    if u61 < p613.Index and not p613.Tool then
        p613:Delete();
    end;

    return v616;
end;

function movePendingHotbarAssets()
    -- upvalues: u70 (copy), u66 (copy), u6 (ref)
    local v621 = false;

    for i in pairs(u70) do
        local v622 = u66[i];

        if v622 then
            local v623 = moveStackSlotIntoFrontHotbar(v622);

            if v623 then
                u66[i] = v623;
                u70[i] = nil;
                v621 = true;
            end;
        end;
    end;

    if v621 then
        AdjustHotbarFrames();
        UpdateInventorySlots();

        if u6 then
            u6(true);
        end;
    end;

    return v621;
end;

function movePendingHotbarEggs()
    -- upvalues: u75 (copy), u73 (copy), u6 (ref), u76 (copy), u14 (copy)
    local v624 = false;

    for i in pairs(u75) do
        local v625 = u73[i];

        if v625 then
            local v626 = moveStackSlotIntoFrontHotbar(v625);

            if v626 then
                u73[i] = v626;
                u75[i] = nil;
                v624 = true;
            end;
        end;
    end;

    if v624 then
        AdjustHotbarFrames();
        UpdateInventorySlots();

        if u6 then
            u6(true);
        end;
    end;

    for i in pairs(u76) do
        if u14:ForceEggIntoTutorialHotbar(i) ~= nil then
            u76[i] = nil;
        end;
    end;

    return v624;
end;

function OnChildAdded(p627, p628)
    -- upvalues: u28 (ref), u29 (ref), u60 (ref), u40 (ref), u53 (ref), u49 (copy), LocalPlayer (ref), Backpack (ref), u6 (ref), u61 (copy), u33 (ref)
    if not p627:IsA("Tool") then
        if p627:IsA("Humanoid") and p627.Parent == u28 then
            u29 = p627;
        end;

        return;
    end;

    if p627.Parent == u28 then
        u60 = tick();
    end;

    local v629 = p627:GetAttribute("ItemType");

    if v629 == "Asset" then
        invalidateEquipBestStatus();
        syncVirtualAssetEquipStateFromTool(p627);
        task.defer(syncAssetsFromSave);

        return;
    end;

    if v629 == "AssetEgg" then
        syncVirtualEggEquipStateFromTool(p627);

        return;
    end;

    local v630 = u40;
    local CanvasPosition = u40.CanvasPosition;

    if not u53 and (p627.Parent == u28 and not u49[p627]) then
        local StarterGear = LocalPlayer:FindFirstChild("StarterGear");

        if StarterGear and StarterGear:FindFirstChild(p627.Name) then
            u53 = true;
            local v631 = insertToolIntoFrontHotbar(p627) or (claimLowestEmptySlot(p627) or MakeSlot(u40));

            if v631.Tool ~= p627 then
                v631:Fill(p627);
            end;

            if isGearTool(p627) then
                ensureGameplayGearHotbarSlots();
            end;

            for _, child in pairs(u28:GetChildren()) do
                if child:IsA("Tool") and child ~= p627 then
                    child.Parent = Backpack;
                end;
            end;

            AdjustHotbarFrames();

            if u6 then
                u6(true);
            end;

            UpdateInventorySlots();
            local new = Vector2.new;
            local X = CanvasPosition.X;
            local Y = CanvasPosition.Y;
            local v632 = math.max(0, v630.CanvasSize.Y.Offset - v630.AbsoluteSize.Y);
            v630.CanvasPosition = new(X, (math.min(Y, v632)));

            return;
        end;
    end;

    local v633 = u49[p627];

    if v633 then
        v633:UpdateEquipView();

        return;
    end;

    local v634 = insertToolIntoFrontHotbar(p627) or (claimLowestEmptySlot(p627) or MakeSlot(u40));

    if v634.Tool ~= p627 then
        v634:Fill(p627);
    end;

    if isGearTool(p627) then
        ensureGameplayGearHotbarSlots();
    end;

    if v634.Index <= u61 and not u33.Visible then
        AdjustHotbarFrames();
    end;

    UpdateInventorySlots();
    local new = Vector2.new;
    local X = CanvasPosition.X;
    local Y = CanvasPosition.Y;
    local v635 = math.max(0, v630.CanvasSize.Y.Offset - v630.AbsoluteSize.Y);
    v630.CanvasPosition = new(X, (math.min(Y, v635)));
    task.delay(0.05, function() -- Line: 4047
        -- upvalues: u6 (ref)
        if u6 then
            u6(true);
        end;
    end);
end;

function OnChildRemoved(p636)
    -- upvalues: u60 (ref), u49 (copy), u61 (copy), u33 (ref), u28 (ref), Backpack (ref), u47 (copy)
    if not p636:IsA("Tool") then
        return;
    end;

    u60 = tick();
    local v637 = p636:GetAttribute("ItemType");

    if v637 == "Asset" then
        invalidateEquipBestStatus();
        task.defer(reconcileVirtualAssetEquipState);
        task.defer(syncAssetsFromSave);
        local v638 = u49[p636];

        if v638 and v638.Tool == p636 then
            v638:Clear();

            if u61 < v638.Index then
                v638:Delete();
            end;

            if v638.Index <= u61 and not u33.Visible then
                AdjustHotbarFrames();
            end;

            UpdateInventorySlots();
        end;

        return;
    end;

    if v637 == "AssetEgg" then
        task.defer(reconcileVirtualEggEquipState);

        return;
    end;

    local v639 = u49[p636];
    local Parent = p636.Parent;

    if Parent ~= u28 and Parent ~= Backpack then
        if not v639 or v639.Tool ~= p636 then
            for _, v in pairs(u47) do
                if v.Tool == p636 then
                    v639 = v;
                    break;
                end;
            end;
        end;

        if v639 and v639.Tool == p636 then
            v639:Clear();

            if u61 < v639.Index then
                v639:Delete();
            end;

            if v639.Index <= u61 and not u33.Visible then
                AdjustHotbarFrames();
            end;

            UpdateInventorySlots();
        end;
    end;
end;

function SetupCharacter(p640)
    -- upvalues: u65 (ref), u79 (ref), u47 (copy), u58 (ref), u28 (ref), Backpack (ref), LocalPlayer (ref)
    u65 = nil;
    u79 = nil;

    for i = #u47, 1, -1 do
        local v641 = u47[i];

        if v641.Tool then
            if typeof(v641.Tool) == "Instance" then
                v641:Clear();
            else
                v641:UpdateEquipView(true);
            end;
        end;
    end;

    for _, v in pairs(u58) do
        v:Disconnect();
    end;

    u58 = {};
    u28 = p640;
    table.insert(u58, p640.ChildRemoved:Connect(OnChildRemoved));
    table.insert(u58, p640.ChildAdded:Connect(function(p642) -- Line: 4135
        if p642:IsA("Tool") and (p642.Name == Constants.LUCKY_BLOCK_TOOL_NAME or p642:GetAttribute("HideFromBackpackUI") == true) then
            return;
        end;

        OnChildAdded(p642, false);
    end));

    for _, child in pairs(p640:GetChildren()) do
        task.spawn(OnChildAdded, child, false);
    end;

    Backpack = LocalPlayer:WaitForChild("Backpack");
    table.insert(u58, Backpack.ChildRemoved:Connect(OnChildRemoved));
    table.insert(u58, Backpack.ChildAdded:Connect(function(p643) -- Line: 4152
        if p643:IsA("Tool") and (p643.Name == Constants.LUCKY_BLOCK_TOOL_NAME or p643:GetAttribute("HideFromBackpackUI") == true) then
            return;
        end;

        OnChildAdded(p643, true);
    end));

    for _, child in pairs(Backpack:GetChildren()) do
        task.spawn(OnChildAdded, child, false);
    end;

    AdjustHotbarFrames();
    invalidateEquipBestStatus(true);
    reconcileVirtualAssetEquipState();
end;

local PlayerGui2 = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui");

function HandleInputBegan(p644, p645)
    -- upvalues: u56 (ref), u54 (ref), Value2 (copy), u50 (copy), u33 (ref), PlayerGui2 (copy), u30 (copy)
    if p645 == false then
        local v646 = (p644.KeyCode == Enum.KeyCode.ButtonL2 or p644.UserInputType == Enum.UserInputType.Keyboard and (not u56 and (u54 or p644.KeyCode.Value == Value2))) and u50[p644.KeyCode.Value];

        if v646 then
            if ActiveFuseSelectionState then
                return;
            end;

            v646(p645);
        end;

        local UserInputType = p644.UserInputType;

        if (UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch) and (u33.Visible and not ActiveFuseSelectionState) then
            local v647 = UserInputService:GetMouseLocation();

            for _, v in PlayerGui2:GetGuiObjectsAtPosition(v647.X, v647.Y) do
                if v.Name:find("CategoryFrame") then
                    break;
                end;
            end;

            if not v then
                u30:deselect();
            end;
        end;
    end;
end;

function OnInputServiceChanged(p648)
    -- upvalues: u61 (copy), u47 (copy)
    if p648 == "KeyboardEnabled" or p648 == "VREnabled" then
        local v649 = UserInputService.KeyboardEnabled and not UserInputService.VREnabled;

        for i = 1, u61 do
            u47[i]:TurnNumber(v649);
        end;
    end;
end;

function OnGamepadFocus()
end;

function unbindAllGamepadEquipActions()
    ContextActionService:UnbindAction("RBXBackpackHasGamepadFocus");
    ContextActionService:UnbindAction("RBXCloseInventory");
end;

function _setHotbarVisibility(p650, p651)
    -- upvalues: u61 (copy), u47 (copy)
    for i = 1, u61 do
        local v652 = u47[i];

        if v652 and (v652.Frame and (p651 or v652.Tool)) then
            v652.Frame.Visible = p650;
        end;
    end;
end;

function getEquippedHotbarSlot()
    -- upvalues: u66 (copy), u61 (copy), u73 (copy), u28 (ref), u49 (copy)
    local v653 = reconcileVirtualAssetEquipState();

    if typeof(v653) == "string" then
        local v654 = u66[v653];

        if v654 and (not v654.IsDeleted and (v654.Index <= u61 and v654.Tool)) then
            return v654;
        end;
    end;

    local v655 = reconcileVirtualEggEquipState();

    if typeof(v655) == "string" then
        local v656 = u73[v655];

        if v656 and (not v656.IsDeleted and (v656.Index <= u61 and v656.Tool)) then
            return v656;
        end;
    end;

    if u28 then
        for _, child in ipairs(u28:GetChildren()) do
            if child:IsA("Tool") then
                local v657 = u49[child];

                if v657 and (v657.Index <= u61 and v657.Tool) then
                    return v657;
                end;
            end;
        end;
    end;

    return nil;
end;

function changeTool(p658, p659, p660)
    -- upvalues: u61 (copy), u47 (copy)
    if p659 ~= Enum.UserInputState.Begin then
        return;
    end;

    local v661 = p660.KeyCode == Enum.KeyCode.ButtonL1 and -1 or 1;
    local v662 = getEquippedHotbarSlot();
    local v663;

    if v662 then
        v663 = v662.Index;
    else
        v663 = v661 == -1 and 1 or u61;
    end;

    for _ = 1, u61 do
        v663 = v663 + v661;

        if u61 < v663 then
            v663 = 1;
        elseif v663 < 1 then
            v663 = u61;
        end;

        local v664 = u47[v663];

        if v664.Tool and v664 ~= v662 then
            v664:Select();

            return;
        end;
    end;
end;

function getGamepadSwapSlot()
    -- upvalues: u47 (copy)
    for i = 1, #u47 do
        if u47[i].Frame:WaitForChild("UIStroke").Thickness > 0 then
            return u47[i];
        end;
    end;
end;

function changeSlot(u665)
    -- upvalues: u33 (ref), GuiService (copy), u46 (ref), u61 (copy)
    if u665.IsFakeSlot then
        u665:Select();

        return;
    end;

    if u665.Frame == GuiService.SelectedObject and (not VRService.VREnabled or u33.Visible) then
        local v666 = getGamepadSwapSlot();

        if not v666 then
            local Size = u665.Frame.Size;
            local Position = u665.Frame.Position;
            u665.Frame:TweenSizeAndPosition(Size + UDim2.new(0, 10, 0, 10), Position - UDim2.new(0, 5, 0, 5), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true, function() -- Line: 4327
                -- upvalues: u665 (copy), Size (copy), Position (copy)
                u665.Frame:TweenSizeAndPosition(Size, Position, Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.1, true);
            end);
            u665.Frame:WaitForChild("UIStroke").Thickness = 3;
            u46.SelectionImageObject.Visible = true;

            return;
        end;

        v666.Frame:WaitForChild("UIStroke").Thickness = 0;

        if v666 ~= u665 then
            u665:Swap(v666);
            u46.SelectionImageObject.Visible = false;

            if u61 < u665.Index and not u665.Tool then
                if GuiService.SelectedObject == u665.Frame then
                    GuiService.SelectedObject = v666.Frame;
                end;

                u665:Delete();
            end;

            if u61 < v666.Index and not v666.Tool then
                if GuiService.SelectedObject == v666.Frame then
                    GuiService.SelectedObject = u665.Frame;
                end;

                v666:Delete();
            end;
        end;
    else
        u665:Select();
        u46.SelectionImageObject.Visible = false;
    end;
end;

function vrMoveSlotToInventory()
    -- upvalues: u46 (ref)
    if not VRService.VREnabled then
        return;
    end;

    local v667 = getGamepadSwapSlot();

    if v667 and v667.Tool then
        v667:WaitForChild("UIStroke").Thickness = 0;
        v667:MoveToInventory();
        u46.SelectionImageObject.Visible = false;
    end;
end;

function enableGamepadInventoryControl()
    -- upvalues: u33 (ref), u30 (copy), GuiService (copy), u42 (ref)
    local function handleBackAction(p668, p669) -- Line: 4359
        -- upvalues: u33 (ref), u30 (ref)
        if p669 ~= Enum.UserInputState.Begin then
            return;
        end;

        local v670 = getGamepadSwapSlot();

        if v670 then
            v670.Frame:WaitForChild("UIStroke").Thickness = 0;

            return;
        end;

        if u33.Visible then
            u30:deselect();
        end;
    end;

    ContextActionService:BindAction("RBXBackpackHasGamepadFocus", OnGamepadFocus, false, Enum.UserInputType.Gamepad1);
    ContextActionService:BindAction("RBXCloseInventory", handleBackAction, false, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonStart, Enum.KeyCode.ButtonSelect);

    if not UserInputService.VREnabled then
        GuiService.SelectedObject = u42:FindFirstChild("1");
    end;
end;

function disableGamepadInventoryControl()
    -- upvalues: u61 (copy), u47 (copy), GuiService (copy), u36 (ref)
    unbindAllGamepadEquipActions();

    for i = 1, u61 do
        local v671 = u47[i];

        if v671 and v671.Frame then
            v671.Frame:WaitForChild("UIStroke").Thickness = 0;
        end;
    end;

    if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(u36) then
        GuiService.SelectedObject = nil;
    end;
end;

function _bindBackpackHotbarAction()
    -- upvalues: u54 (ref), u22 (ref)
    if u54 and not u22 then
        u22 = true;
        ContextActionService:BindAction("RBXHotbarEquip", changeTool, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1);
    end;
end;

function _unbindBackpackHotbarAction()
    -- upvalues: u22 (ref)
    disableGamepadInventoryControl();
    u22 = false;
    ContextActionService:UnbindAction("RBXHotbarEquip");
end;

function gamepadDisconnected()
    -- upvalues: u59 (ref)
    u59 = false;
    disableGamepadInventoryControl();
end;

function gamepadConnected()
    -- upvalues: u59 (ref), GuiService (copy), u36 (ref), u52 (ref), u54 (ref), u22 (ref), u33 (ref)
    u59 = true;
    GuiService:AddSelectionParent("RBXBackpackSelection", u36);

    if u52 >= 1 and (u54 and not u22) then
        u22 = true;
        ContextActionService:BindAction("RBXHotbarEquip", changeTool, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1);
    end;

    if u33.Visible then
        enableGamepadInventoryControl();
    end;
end;

function OnIconChanged(p672)
    -- upvalues: u30 (copy), GuiService (copy), u54 (ref), u36 (ref), u52 (ref), u22 (ref)
    if p672 then
        p672 = CoreCall("GetCore", "TopbarEnabled");
    end;

    u30:setEnabled(p672 and not GuiService.MenuIsOpen and not ActiveFuseSelectionState);
    u54 = p672;
    u36.Visible = p672;
    PositionInventoryAffordances();

    if p672 then
        if u52 >= 1 and (u54 and not u22) then
            u22 = true;
            ContextActionService:BindAction("RBXHotbarEquip", changeTool, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1);
        end;
    else
        disableGamepadInventoryControl();
        u22 = false;
        ContextActionService:UnbindAction("RBXHotbarEquip");
    end;
end;

function createScrollButton(p673, p674)
    local v675 = NewGui("ImageButton", p673);
    v675.Size = UDim2.new(0, 40, 0, 40);
    v675.Image = "rbxasset://textures/ui/Keyboard/close_button_background.png";
    local v676 = NewGui("ImageLabel", "Icon");
    v676.Size = UDim2.new(0.5, 0, 0.5, 0);
    v676.Position = UDim2.new(0.25, 0, 0.25, 0);
    v676.Image = p674;
    v676.Parent = v675;
    local v677 = NewGui("ImageLabel", "Selection");
    v677.Size = UDim2.new(0.9, 0, 0.9, 0);
    v677.Position = UDim2.new(0.05, 0, 0.05, 0);
    v677.Image = "rbxasset://textures/ui/Keyboard/close_button_selection.png";
    v675.SelectionImageObject = v677;

    return v675, v676, v677;
end;

u36 = BackpackGui:WaitForChild("Backpack");
u36.Visible = false;
u42 = NewGui("Frame", "Hotbar");
u42.Parent = u36;
local RoundChoices = script:FindFirstChild("RoundChoices");

if RoundChoices then
    RoundChoices.Parent = u42;

    if v24 then
        RoundChoices.Size = UDim2.fromScale(1, 0.4);
    end;
elseif RunService:IsStudio() then
    error("RoundChoices frame not found in Backpack script");
end;

for i = 1, u61 do
    MakeSlot(u42, i).Frame.Visible = false;
end;

u45 = u36:WaitForChild("Main");
u33 = u45:WaitForChild("Inventory");
local Loading = u33:WaitForChild("Loading");
Loading.Visible = false;
task.spawn(PreloadAssets, u33.ImageLabel.ImageLabel);
u80 = u33.AutoSell;
u80.Visible = false;
task.spawn(initializeAutoSellUI);
u48 = FindLowestEmpty();
AdjustHotbarFrames();
u30.selected:Connect(function() -- Line: 4510
    -- upvalues: GuiService (copy), u14 (copy)
    if not GuiService.MenuIsOpen then
        u14.OpenClose();
    end;
end);
u30.deselected:Connect(function() -- Line: 4515
    -- upvalues: u33 (ref), u14 (copy)
    if u33.Visible then
        u14.OpenClose();
    end;
end);
local v678 = NewGui("ImageLabel", "LeftBumper");
v678.Size = UDim2.new(0, 40, 0, 40);
v678.Position = UDim2.new(0, -v678.Size.X.Offset, 0.5, -v678.Size.Y.Offset / 2);
local v679 = NewGui("ImageLabel", "RightBumper");
v679.Size = UDim2.new(0, 40, 0, 40);
v679.Position = UDim2.new(1, 0, 0.5, -v679.Size.Y.Offset / 2);
local BackgroundColor3 = u33.BackgroundColor3;
InventoryStroke = u33:FindFirstChildWhichIsA("UIStroke");
InventoryStrokeDefaultColor = InventoryStroke and InventoryStroke.Color or nil;
InventoryStrokeDefaultTransparency = u33.BackgroundTransparency;
u33.Visible = false;

function refreshInventoryFrameVisuals()
    -- upvalues: u33 (ref), u18 (ref), u26 (copy), BackgroundColor3 (copy)
    if ActiveFuseSelectionState then
        u33.BackgroundColor3 = FUSE_SELECTION_BACKGROUND_COLOR;

        if InventoryStroke then
            InventoryStroke.Color = FUSE_SELECTION_STROKE_COLOR;
        end;

        u33.BackgroundTransparency = FUSE_SELECTION_BACKGROUND_TRANSPARENCY;

        return;
    end;

    u33.BackgroundColor3 = u18 and u26 or BackgroundColor3;

    if InventoryStroke and InventoryStrokeDefaultColor then
        InventoryStroke.Color = InventoryStrokeDefaultColor;
    end;

    u33.BackgroundTransparency = InventoryStrokeDefaultTransparency;
end;

local UIStroke = Instance.new("UIStroke");
UIStroke.Name = "FavoriteMode";
UIStroke.Thickness = 4.5;
UIStroke.Color = Color3.fromRGB(255, 170, 0);
UIStroke.Enabled = false;
UIStroke.ZIndex = 2;
UIStroke.Parent = u33;

function updateFavoriteModeVisuals()
    -- upvalues: u17 (ref), u18 (ref), UIStroke (ref)
    local v680 = u17 and u17:FindFirstChildWhichIsA("TextLabel");

    if v680 then
        v680.Text = u18 and "Favorite: ON" or "Favorite: OFF";
    end;

    if UIStroke then
        UIStroke.Enabled = u18 and not ActiveFuseSelectionState;
    end;

    refreshInventoryFrameVisuals();
end;

function setFavoriteModeActive(p681)
    -- upvalues: u18 (ref), u17 (ref), UIStroke (ref)
    u18 = p681;

    if u17 then
        updateFavoriteModeVisuals();

        return;
    end;

    refreshInventoryFrameVisuals();

    if UIStroke then
        UIStroke.Enabled = u18 and not ActiveFuseSelectionState;
    end;
end;

function hideFavoriteModeButton()
    -- upvalues: u18 (ref), u17 (ref), u80 (ref), u81 (ref)
    if u18 then
        setFavoriteModeActive(false);
    end;

    if u17 then
        u17.Visible = false;

        if u80 then
            u80.Visible = false;
        end;

        if u81 then
            u81.Visible = false;
        end;
    end;
end;

function refreshFavoriteModeVisibility()
    -- upvalues: u17 (ref), u5 (copy), u2 (ref), u4 (copy), u80 (ref), u81 (ref)
    if not u17 then
        return;
    end;

    local v682 = u5[u2];
    local v683 = u2 == u4;

    if v682 and v682.Tags then
        for _, v in v682.Tags do
            if v == "Asset" then
                v683 = true;
                break;
            end;
        end;
    end;

    if v683 then
        u17.Visible = false;

        if u80 then
            u80.Visible = false;
        end;

        if u81 then
            u81.Visible = false;
        end;
    else
        hideFavoriteModeButton();
    end;

    updateEquipBestButtonVisibility();
end;

u17 = u33:FindFirstChild("FavoriteMode") or script:FindFirstChild("FavoriteMode");

if u17 then
    u17.Parent = u33;
    u17.Visible = false;
    updateFavoriteModeVisuals();
    ButtonFX(u17, nil, function() -- Line: 4633
        -- upvalues: u18 (ref)
        setFavoriteModeActive(not u18);
    end);
end;

u81 = u33:FindFirstChild("EquipBest");

if u81 then
    u81.Visible = false;
    ButtonFX(u81, nil, requestEquipBest);
end;

local EquipBest = script:FindFirstChild("EquipBest");

if EquipBest and EquipBest:IsA("GuiButton") then
    u82 = EquipBest:Clone();
    assert(u82, "missing hotbar");
    u82.Parent = u42;
    u82.Visible = false;
    ButtonFX(u82, nil, requestEquipBest);
end;

local u684 = u33:FindFirstChild("CategoryLabel") or script.CategoryTemplate:Clone();
u684.Parent = u33;

if not u684:IsA("TextLabel") then
    u684 = u684:FindFirstChildWhichIsA("TextLabel", true);
end;

local v685;

if u684 then
    v685 = u684:IsA("TextLabel");
else
    v685 = u684;
end;

assert(v685, "Category label template must contain a TextLabel");
local u686 = {};
local u687 = {};

local function u691() -- Line: 4661
    -- upvalues: u687 (copy)
    local v688 = ActiveFuseSelectionState;
    local v689 = v688 ~= nil;

    for i, v in u687 do
        local v690 = not v689 and true or v688.AllowedCategories[i] == true;
        v.Visible = v690;
        local ImageButton = v:FindFirstChild("ImageButton");

        if ImageButton and ImageButton:IsA("GuiButton") then
            ImageButton.Active = v690;
        end;
    end;
end;

function updateCategorySelectionVisuals()
    -- upvalues: u686 (copy), u2 (ref)
    for i, v in u686 do
        v.Enabled = i == u2;
    end;
end;

function updateCategoryLabel(p692)
    -- upvalues: u684 (copy)
    u684.Text = p692;
end;

function applyCategoryLayout()
    -- upvalues: u43 (ref), u40 (ref), u34 (ref), u41 (ref), u39 (ref), u38 (ref), u35 (ref), u32 (ref), u31 (ref), u37 (ref)
    if not (u43 and u40) then
        return;
    end;

    if not u34 then
        u34 = u43.CellSize;
    end;

    u41 = not u41 and (u43:FindFirstChildWhichIsA("UIAspectRatioConstraint") or u40:FindFirstChildWhichIsA("UIAspectRatioConstraint"));

    if u41 then
        u39 = u41.AspectRatio;
    end;

    if not u38 then
        u38 = u40.ScrollingDirection;
    end;

    if not u35 then
        u35 = u43.FillDirection;
    end;

    if not u32 then
        u32 = u43.HorizontalAlignment;
    end;

    if u31 and not u37 then
        u37 = u31.PaddingLeft;
    end;

    u43.CellSize = u34;

    if u41 and u39 then
        u41.AspectRatio = u39;
    end;

    u40.AutomaticCanvasSize = Enum.AutomaticSize.None;
    u40.ScrollingDirection = u38;
    u43.FillDirection = u35;
    u43.HorizontalAlignment = u32;

    if u31 and u37 then
        u31.PaddingLeft = u37;
    end;
end;

u8 = function(p693) -- Line: 4734, Name: SetCategory
    -- upvalues: u2 (ref), u7 (ref), u9 (ref), u4 (copy), u18 (ref), Loading (ref), u40 (ref), u6 (ref)
    if ActiveFuseSelectionState and ActiveFuseSelectionState.AllowedCategories[p693] ~= true then
        p693 = ActiveFuseSelectionState.PreferredCategory;
    end;

    if u2 == p693 then
        updateCategoryLabel(p693);
        updateCategorySelectionVisuals();

        return;
    end;

    u2 = p693;
    applyCategoryLayout();

    if u7 and u7.Text ~= "" then
        if u9 then
            u9();
        end;

        u7.Text = "";
    end;

    if u2 ~= u4 and u18 then
        setFavoriteModeActive(false);
    end;

    if Loading and u2 ~= u4 then
        Loading.Visible = false;
    end;

    refreshFavoriteModeVisibility();
    updateCategoryLabel(p693);

    if u40 then
        u40.CanvasPosition = Vector2.new(0, 0);
    end;

    u6();
    updateCategorySelectionVisuals();
end;

local CategoryFrame = u33:WaitForChild("CategoryFrame");
local CategoryTemplate = CategoryFrame.CategoryTemplate;

if not CategoryFrame:FindFirstChildWhichIsA("UIGridLayout") then
    CategoryFrame:FindFirstChildWhichIsA("UIListLayout");
end;

function createHintForCategory(p694, p695)
    local v696, v697, v698 = p694:ToHSV();
    local v699 = math.clamp(v698 + p695, 0, 1);

    return Color3.fromHSV(v696, v697, v699);
end;

for _, v in v1 do
    local Name = v.Name;
    local v700 = CategoryTemplate:Clone();
    local ImageButton = v700.ImageButton;
    local CategoryName = v700:FindFirstChild("CategoryName");

    if CategoryName and CategoryName:IsA("TextLabel") then
        CategoryName.Text = Name;
    end;

    local BackgroundColor32 = v700.BackgroundColor3;
    local u701 = TweenService:Create(v700, TweenInfo.new(0.2), {
        BackgroundColor3 = createHintForCategory(BackgroundColor32, 0.2)
    });
    local u702 = TweenService:Create(v700, TweenInfo.new(0.2), {
        BackgroundColor3 = BackgroundColor32
    });
    ImageButton.MouseEnter:Connect(function() -- Line: 4791
        -- upvalues: u701 (copy)
        u701:Play();
    end);
    ImageButton.MouseLeave:Connect(function() -- Line: 4794
        -- upvalues: u702 (copy)
        u702:Play();
    end);
    ImageButton.MouseButton1Down:Connect(function() -- Line: 4797
        -- upvalues: u702 (copy)
        u702:Play();
    end);
    ImageButton.MouseButton1Up:Connect(function() -- Line: 4800
        -- upvalues: u701 (copy), u8 (ref), Name (copy)
        u701:Play();
        u8(Name);
    end);
    local UIStroke2 = v700.UIStroke;
    local v703 = UIStroke2:IsA("UIStroke");
    assert(v703, "Category button UIStroke must be a UIStroke");
    UIStroke2.Enabled = false;
    u686[Name] = UIStroke2;
    u687[Name] = v700;
    ImageButton.Image = v.Image;
    v700.Visible = true;
    v700.Parent = CategoryFrame;
end;

u691();
updateCategoryLabel(u2);
updateCategorySelectionVisuals();
refreshFavoriteModeVisibility();
u46 = NewGui("TextButton", "VRInventorySelector");
u46.Position = UDim2.new(0, 0, 0, 0);
u46.Size = UDim2.new(1, 0, 1, 0);
u46.BackgroundTransparency = 1;
u46.Text = "";
u46.Parent = u33;
local v704 = NewGui("ImageLabel", "Selector");
v704.Size = UDim2.new(1, 0, 1, 0);
v704.Image = "rbxasset://textures/ui/Keyboard/key_selection_9slice.png";
v704.ScaleType = Enum.ScaleType.Slice;
v704.SliceCenter = Rect.new(12, 12, 52, 52);
v704.Visible = false;
u46.SelectionImageObject = v704;
u46.MouseButton1Click:Connect(function() -- Line: 4830
    vrMoveSlotToInventory();
end);
u40 = u33:WaitForChild("ScrollingFrame");
u43 = u40:WaitForChild("UIGridLayout");
u31 = u40:FindFirstChildWhichIsA("UIPadding");
u44 = AutoGridLayout(u40, v27);
u41 = u43:FindFirstChildWhichIsA("UIAspectRatioConstraint") or u40:FindFirstChildWhichIsA("UIAspectRatioConstraint");

if u41 then
    u39 = u41.AspectRatio;
end;

u38 = u40.ScrollingDirection;

if u31 then
    u37 = u31.PaddingLeft;
end;

if v24 then
    u43.CellSize = UDim2.new(u43.CellSize.X.Scale, u43.CellSize.X.Offset, u43.CellSize.Y.Scale, u43.CellSize.Y.Offset / 2);
end;

u34 = u43.CellSize;
applyCategoryLayout();
local u705 = createScrollButton("ScrollUpButton", "rbxasset://textures/ui/Backpack/ScrollUpArrow.png");
u705.Size = UDim2.new(0, 34, 0, 34);
u705.Position = UDim2.new(0.5, -u705.Size.X.Offset / 2, 0, 43);
u705.Icon.Position = u705.Icon.Position - UDim2.new(0, 0, 0, 2);
u705.MouseButton1Click:Connect(function() -- Line: 4869
    -- upvalues: u40 (ref), u25 (copy)
    local new = Vector2.new;
    local X = u40.CanvasPosition.X;
    local v706 = u40.CanvasSize.Y.Offset - u40.AbsoluteWindowSize.Y;
    local v707 = math.max(0, u40.CanvasPosition.Y - (u25 + 5));
    u40.CanvasPosition = new(X, (math.min(v706, v707)));
end);
local u708 = createScrollButton("ScrollDownButton", "rbxasset://textures/ui/Backpack/ScrollUpArrow.png");
u708.Rotation = 180;
u708.Icon.Position = u708.Icon.Position - UDim2.new(0, 0, 0, 2);
u708.Size = UDim2.new(0, 34, 0, 34);
u708.Position = UDim2.new(0.5, -u708.Size.X.Offset / 2, 1, -u708.Size.Y.Offset - 3);
u708.MouseButton1Click:Connect(function() -- Line: 4886
    -- upvalues: u40 (ref), u25 (copy)
    local new = Vector2.new;
    local X = u40.CanvasPosition.X;
    local v709 = u40.CanvasSize.Y.Offset - u40.AbsoluteWindowSize.Y;
    local v710 = math.max(0, u40.CanvasPosition.Y + (u25 + 5));
    u40.CanvasPosition = new(X, (math.min(v709, v710)));
end);
u40.Changed:Connect(function(p711) -- Line: 4897
    -- upvalues: u40 (ref), u705 (ref), u708 (ref)
    if p711 == "AbsoluteWindowSize" or (p711 == "CanvasPosition" or p711 == "CanvasSize") then
        local v712 = u40.CanvasPosition.Y < u40.CanvasSize.Y.Offset - u40.AbsoluteWindowSize.Y;
        u705.Visible = u40.CanvasPosition.Y ~= 0;
        u708.Visible = v712;
    end;
end);
ResizeContainers();
u33:GetPropertyChangedSignal("Visible"):Connect(PositionInventoryAffordances);
PlatformSignal.Fired("Changed Platform"):Connect(PositionInventoryAffordances);
PositionInventoryAffordances();
local u713 = Utility:Create("Frame")({
    Name = "GamepadHintsFrame",
    BackgroundTransparency = 1,
    Visible = false,
    Size = UDim2.new(0, u42.Size.X.Offset, 0, u20 and 95 or 60),
    Parent = u36
});

function createHint(p714, p715, p716)
    -- upvalues: u713 (ref), u20 (copy)
    local v717 = Utility:Create("Frame")({
        Name = "HintFrame",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -5),
        Position = UDim2.new(0, 0, 0, 0),
        Parent = u713
    });
    local v718 = Utility:Create("ImageLabel");
    local v719 = {
        Name = "HintImage",
        BackgroundTransparency = 1,
        Size = u20 and UDim2.new(0, 90, 0, 90) or UDim2.new(0, 60, 0, 60)
    };

    if u20 then
        p714 = p715 or p714;
    end;

    v719.Image = p714;
    v719.Parent = v717;
    v718(v719);
    local v720 = Utility:Create("TextLabel")({
        Name = "HintText",
        BackgroundTransparency = 1,
        TextWrapped = true,
        Position = UDim2.new(0, u20 and 100 or 70, 0, 0),
        Size = UDim2.new(1, -(u20 and 100 or 70), 1, 0),
        Font = Enum.Font.SourceSansBold,
        FontSize = u20 and Enum.FontSize.Size36 or Enum.FontSize.Size24,
        Text = p716,
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = v717
    });
    Instance.new("UITextSizeConstraint", v720).MaxTextSize = v720.TextSize;
end;

function PositionHintFrame()
    -- upvalues: u713 (ref), u42 (ref), u20 (copy), u33 (ref)
    u713.Size = UDim2.new(u42.Size.X.Scale, u42.Size.X.Offset, 0, u20 and 95 or 60);
    u713.Position = UDim2.new(u42.Position.X.Scale, u42.Position.X.Offset, u33.Position.Y.Scale, u33.Position.Y.Offset - u713.Size.Y.Offset);
    local v721 = u713:GetChildren();
    local v722 = 0;

    for i = 1, #v721 do
        v721[i].Size = UDim2.new(1, 0, 1, -5);
        v721[i].Position = UDim2.new(0, 0, 0, 0);
        v722 = v722 + (v721[i].HintText.Position.X.Offset + v721[i].HintText.TextBounds.X);
    end;

    local v723 = (u713.AbsoluteSize.X - v722) / (#v721 - 1);

    for i = 1, #v721 do
        v721[i].Position = i == 1 and UDim2.new(0, 0, 0, 0) or UDim2.new(0, v721[i - 1].Position.X.Offset + v721[i - 1].Size.X.Offset + v723, 0, 0);
        v721[i].Size = UDim2.new(0, v721[i].HintText.Position.X.Offset + v721[i].HintText.TextBounds.X, 1, -5);
    end;
end;

createHint(
    "rbxasset://textures/ui/Settings/Help/XButtonDark.png",
    "rbxasset://textures/ui/Settings/Help/XButtonDark@2x.png",
    "Remove From Hotbar "
);
createHint(
    "rbxasset://textures/ui/Settings/Help/AButtonDark.png",
    "rbxasset://textures/ui/Settings/Help/AButtonDark@2x.png",
    "Select/Swap"
);
createHint(
    "rbxasset://textures/ui/Settings/Help/BButtonDark.png",
    "rbxasset://textures/ui/Settings/Help/BButtonDark@2x.png",
    "Close Backpack"
);
local Search = u33:WaitForChild("Search");
u7 = Search:WaitForChild("TextBox");
u7.ClearTextOnFocus = false;
u7.TextXAlignment = Enum.TextXAlignment.Left;
CloseButton = u33:FindFirstChild("Close");

if CloseButton and CloseButton:IsA("GuiButton") then
    ButtonFX(CloseButton, nil, function() -- Line: 4997
        -- upvalues: u33 (ref), u14 (copy)
        if u33.Visible then
            u14.OpenClose();
        end;
    end);
end;

local u724 = Search:FindFirstChild("StrokeTemplate") or (Search:FindFirstChildWhichIsA("UIStroke") or script.StrokeTemplate:Clone());
u724.Enabled = false;
u724.Parent = Search;
task.spawn(function() -- Line: 5008
    -- upvalues: u724 (copy), TweenService (copy)
    while true do
        repeat
            task.wait();
        until u724.Enabled;

        local v725 = TweenService:Create(u724.UIGradient, TweenInfo.new(0.05), {
            Rotation = u724.UIGradient.Rotation + 1
        });
        v725:Play();
        v725.Completed:Wait();
    end;
end);
local u726 = Search:FindFirstChild("X") or (Search:FindFirstChild("ClearSearch") or Search:WaitForChild("X"));
u726.Visible = false;

function PerformSearch()
    -- upvalues: u7 (ref), u61 (copy), u47 (copy), u33 (ref), u57 (ref), u40 (ref), u726 (copy)
    if u7.Text == "" then
        ResetSearchResults();

        return;
    end;

    local v727 = {};

    for i in u7.Text:gmatch("%S+") do
        v727[i:lower()] = true;
    end;

    local v728 = {};

    for i = u61 + 1, #u47 do
        local u729 = u47[i];

        if u729 and u729.Tool then
            if IsOfCategory(u729.Tool) then
                local v730 = { u729, u729:CheckTerms(v727) };
                table.insert(v728, v730);
                u729.Frame.Visible = false;
                pcall(function() -- Line: 5047
                    -- upvalues: u729 (copy), u33 (ref)
                    u729.Frame.Parent = u33;
                end);
            else
                u729.Frame.Visible = false;
            end;
        end;
    end;

    table.sort(v728, function(p731, p732) -- Line: 5052
        return p731[2] > p732[2];
    end);
    u57 = true;
    local v733 = 0;

    for _, v in ipairs(v728) do
        local v734 = v[1];

        if v[2] > 0 then
            v734.Frame.Visible = true;
            v734.Frame.Parent = u40;
            v734.Frame.LayoutOrder = u61 + v733;
            v733 = v733 + 1;
        else
            v734.Frame.Visible = false;
        end;
    end;

    UpdateScrollingFrameCanvasSize();
    u726.ZIndex = 2000;
end;

u6 = PerformSearch;

function ResetSearchResults()
    -- upvalues: u57 (ref), u61 (copy), u47 (copy), u40 (ref), u726 (copy)
    u57 = false;

    for i = u61 + 1, #u47 do
        local v735 = u47[i];

        if v735 and v735.Tool then
            if IsOfCategory(v735.Tool) then
                v735.Frame.Parent = u40;
                v735.Frame.Visible = true;
            else
                v735.Frame.Visible = false;
            end;
        end;
    end;

    u726.ZIndex = 0;
    UpdateInventorySlots();
end;

u9 = ResetSearchResults;

function ClearSearchText()
    -- upvalues: u7 (ref)
    ResetSearchResults();
    u7.Text = "";
end;

function OnSearchTextChanged(p736)
    -- upvalues: u7 (ref), u726 (copy), u724 (copy)
    if p736 == "Text" then
        PerformSearch();
        local v737 = u7.Text ~= "";
        u726.Visible = v737;
        u724.Enabled = v737;
    end;
end;

function OnSearchFocusLost(p738)
    if p738 then
        PerformSearch();
    end;
end;

u726.MouseButton1Click:Connect(ClearSearchText);
u7.Changed:Connect(OnSearchTextChanged);
u7.FocusLost:Connect(OnSearchFocusLost);
u14.StateChanged.Event:Connect(function(p739) -- Line: 5111
    -- upvalues: u33 (ref), u30 (copy)
    if not (p739 or u33.Visible) then
        u30:deselect();
    end;
end);

function OnEscapePressed(p740)
    -- upvalues: u33 (ref), u30 (copy)
    if p740 then
        return;
    end;

    if ActiveFuseSelectionState then
        return;
    end;

    if u33.Visible then
        u30:deselect();
    end;
end;

function OnFavoritePressed()
    if ActiveFuseSelectionState then
        return;
    end;

    if not SelectedSlot then
        return;
    end;

    local Tool = SelectedSlot.Tool;

    if Tool then
        requestFavoriteToggle(Tool);
    end;
end;

u50[Enum.KeyCode.Escape.Value] = OnEscapePressed;
u50[Enum.KeyCode.ButtonL2.Value] = OnFavoritePressed;
UserInputService.LastInputTypeChanged:Connect(function(p741) -- Line: 5141
    -- upvalues: Search (copy)
    if p741 ~= Enum.UserInputType.Gamepad1 or UserInputService.VREnabled then
        return;
    end;

    Search.Visible = false;
end);
GuiService.MenuOpened:Connect(function() -- Line: 5150
    -- upvalues: u33 (ref), u30 (copy)
    if u33.Visible then
        u30:deselect();
    end;
end);

function RemoveSlotAction(p742, p743, p744)
    -- upvalues: GuiService (copy), u61 (copy), u47 (copy), u9 (ref)
    if p743 ~= Enum.UserInputState.Begin then
        return;
    end;

    if not GuiService.SelectedObject then
        return;
    end;

    for i = 1, u61 do
        if u47[i].Frame == GuiService.SelectedObject and u47[i].Tool then
            u47[i]:MoveToInventory();
            u9();

            return;
        end;
    end;

    u9();
end;

function setInventoryVisibility(p745)
    -- upvalues: u33 (ref), u42 (ref), u61 (copy), u47 (copy), u59 (ref), u16 (copy), u713 (ref), u14 (copy), u19 (ref), u15 (ref), u18 (ref)
    u33.Visible = p745;
    AdjustHotbarFrames();
    u42.Active = not p745;

    for i = 1, u61 do
        u47[i]:SetClickability(not p745);
    end;

    if u33.Visible then
        if u59 then
            if u16[UserInputService:GetLastInputType()] then
                PositionHintFrame();
                u713.Visible = not UserInputService.VREnabled;
            end;

            enableGamepadInventoryControl();
        end;
    else
        if u59 then
            u713.Visible = false;
        end;

        disableGamepadInventoryControl();
    end;

    if u33.Visible then
        ContextActionService:BindAction("RBXRemoveSlot", RemoveSlotAction, false, Enum.KeyCode.ButtonX);
    else
        ContextActionService:UnbindAction("RBXRemoveSlot");
    end;

    u14.IsOpen = u33.Visible;
    u14.StateChanged:Fire(u33.Visible);

    if not u33.Visible then
        local v746;

        if ActiveFuseSelectionState and u19 then
            u19(false);
            v746 = true;
        else
            v746 = false;
        end;

        if not v746 then
            u15 = nil;

            if u18 then
                setFavoriteModeActive(false);
            end;
        end;
    end;
end;

function u14.OpenClose() -- Line: 5221
    -- upvalues: u33 (ref), u14 (copy), u51 (copy)
    if ActiveFuseSelectionState then
        if u33.Visible then
            setInventoryVisibility(false);

            return;
        end;

        u14.IsOpen = u33.Visible;

        return;
    end;

    if next(u51) then
        return;
    end;

    setInventoryVisibility(not u33.Visible);
end;

function setFuseSelectionSlotClickability(p747)
    -- upvalues: u47 (copy)
    for _, v in u47 do
        if v and v.Tool then
            v:SetClickability(not p747);
        end;
    end;
end;

function captureFuseHotbarSnapshot()
    -- upvalues: u61 (copy), u47 (copy)
    local v748 = {};

    for i = 1, u61 do
        local v749 = u47[i];
        local v750;

        if v749 then
            v750 = v749.Tool;
        else
            v750 = v749;
        end;

        if v749 and (not v749.IsFakeSlot and (typeof(v750) == "Instance" and (v750:IsA("Tool") and isAssetTool(v750)))) then
            v748[i] = v750;
        end;
    end;

    return v748;
end;

function moveFuseHotbarAssetsToInventory()
    -- upvalues: u61 (copy), u47 (copy)
    for i = 1, u61 do
        local v751 = u47[i];

        if v751 and (not v751.IsFakeSlot and (v751.Tool and isAssetTool(v751.Tool))) then
            v751:MoveToInventory();
        end;
    end;
end;

function restoreFuseHotbarSnapshot(p752)
    -- upvalues: u61 (copy), u47 (copy), u49 (copy)
    local v753 = {};

    for i, v in p752 do
        if typeof(v) == "Instance" and (v:IsA("Tool") and v.Parent) then
            v753[v] = i;
        end;
    end;

    for i = 1, u61 do
        local v754 = u47[i];

        if v754 and (not v754.IsFakeSlot and (v754.Tool and (isAssetTool(v754.Tool) and not v753[v754.Tool]))) then
            v754:MoveToInventory();
        end;
    end;

    for i, v in p752 do
        if typeof(v) == "Instance" and (v:IsA("Tool") and v.Parent) then
            local v755 = u47[i];
            local v756 = u49[v];

            if v755 and (not v755.IsFakeSlot and (v756 and (not v756.IsFakeSlot and (v756.Tool == v and v755 ~= v756)))) then
                if v755.Tool then
                    v755:MoveToInventory();
                end;

                v756:Swap(v755);
            end;
        end;
    end;
end;

function stopFuseSelectionVisuals()
    if FuseSelectionVisualTrove then
        FuseSelectionVisualTrove:Clean();
        FuseSelectionVisualTrove = nil;
    end;

    refreshInventoryFrameVisuals();
end;

function startFuseSelectionVisuals()
    -- upvalues: Trove (copy), RunService (copy)
    stopFuseSelectionVisuals();

    if not InventoryStroke then
        refreshInventoryFrameVisuals();

        return;
    end;

    FuseSelectionVisualTrove = Trove.new();
    local u757 = 0;
    FuseSelectionVisualTrove:Add(RunService.Heartbeat:Connect(function(p758) -- Line: 5327
        -- upvalues: u757 (ref)
        if not ActiveFuseSelectionState then
            return;
        end;

        u757 = u757 + p758 * 3;
        local v759 = (math.sin(u757) + 1) / 2;
        InventoryStroke.Color = FUSE_SELECTION_STROKE_COLOR:Lerp(Color3.fromRGB(255, 255, 255), v759);
    end));
    refreshInventoryFrameVisuals();
end;

function u14.StartMachineSelection(p760, p761, p762, p763, p764, p765) -- Line: 5339
    -- upvalues: u2 (ref), u18 (ref), u7 (ref), u9 (ref), u17 (ref), u80 (ref), u81 (ref), u57 (ref), u691 (ref), u8 (ref)
    local v766 = type(p761) == "string";
    assert(v766, "Expected machine selection item type to be a string");
    local v767 = type(p762) == "function";
    assert(v767, "Expected fuse selection callback to be a function");
    local v768 = type(p765) == "string";
    assert(v768, "Expected preferred category to be a string");

    if ActiveFuseSelectionState then
        p760:EndFuseSelection();
    end;

    ActiveFuseSelectionState = {
        AllowedCategories = p764,
        ItemType = p761,
        PreviousCategory = u2,
        PreviousFavoriteModeActive = u18,
        PreferredCategory = p765,
        HotbarSnapshot = captureFuseHotbarSnapshot()
    };
    p760:RequestSelection(p761, p762, false, false, p763);

    if u18 then
        setFavoriteModeActive(false);
    end;

    if u7 and u7.Text ~= "" then
        if u9 then
            u9();
        end;

        u7.Text = "";
    end;

    if u17 then
        u17.Visible = false;

        if u80 then
            u80.Visible = false;
        end;

        if u81 then
            u81.Visible = false;
        end;
    end;

    if u57 and u9 then
        u9();
    end;

    if u7 and u7.Text ~= "" then
        u7.Text = "";
    end;

    u691();
    updateEquipBestButtonVisibility();
    u8(p765);

    if p761 == "Asset" then
        moveFuseHotbarAssetsToInventory();
    end;

    AdjustHotbarFrames();
    setInventoryVisibility(true);
    setFuseSelectionSlotClickability(false);
    UpdateInventorySlots();
    startFuseSelectionVisuals();
    OnIconChanged(BackpackEnabled);

    return true;
end;

u19 = function(p769) -- Line: 5409
    -- upvalues: u15 (ref), u17 (ref), u80 (ref), u81 (ref), u691 (ref), u8 (ref)
    local v770 = ActiveFuseSelectionState;

    if not v770 then
        return;
    end;

    ActiveFuseSelectionState = nil;
    stopFuseSelectionVisuals();
    u15 = nil;

    if p769 then
        setInventoryVisibility(false);
    end;

    setFuseSelectionSlotClickability(true);

    if CloseButton then
        CloseButton.Active = true;
        CloseButton.Visible = true;
    end;

    if u17 then
        u17.Visible = false;

        if u80 then
            u80.Visible = false;
        end;

        if u81 then
            u81.Visible = false;
        end;
    end;

    u691();

    if v770.ItemType == "Asset" then
        restoreFuseHotbarSnapshot(v770.HotbarSnapshot);
    end;

    u8(v770.PreviousCategory);
    refreshFavoriteModeVisibility();

    if v770.PreviousFavoriteModeActive then
        setFavoriteModeActive(true);
    else
        refreshInventoryFrameVisuals();
    end;

    UpdateInventorySlots();
    OnIconChanged(BackpackEnabled);
    updateEquipBestButtonVisibility();
end;

function u14.EndFuseSelection(p771) -- Line: 5453
    -- upvalues: u19 (ref)
    u19(true);
end;

function u14.StartFuseSelection(p772, p773, p774) -- Line: 5457
    return p772:StartMachineSelection("Asset", p773, p774, {
        [FUSE_SELECTION_ASSET_CATEGORY_NAME] = true
    }, FUSE_SELECTION_ASSET_CATEGORY_NAME);
end;

function u14.IsFuseSelectionActive(p775) -- Line: 5463
    return ActiveFuseSelectionState ~= nil;
end;

CoreCall("SetCoreGuiEnabled", Enum.CoreGuiType.Backpack, false);

while not LocalPlayer do
    wait();
    LocalPlayer = Players.LocalPlayer;
end;

LocalPlayer.CharacterAdded:Connect(SetupCharacter);

if LocalPlayer.Character then
    SetupCharacter(LocalPlayer.Character);
end;

local function handleLocalActiveAssetRecords(p776) -- Line: 5477
    refreshPlacedAssetUIDs(p776);

    if clearPlacedAssetBackpackSlots(p776) and not syncAssetsFromSave() then
        AdjustHotbarFrames();
        UpdateInventorySlots();
    end;

    reconcileVirtualAssetEquipState();
end;

refreshPlacedAssetUIDs(AssetCmds.GetOwnerRuntimeRecords(LocalPlayer.UserId));
AssetCmds.RuntimeOwnerUpdated:Connect(function(p777, p778) -- Line: 5490
    -- upvalues: LocalPlayer (ref), handleLocalActiveAssetRecords (copy)
    if p777 == LocalPlayer.UserId then
        handleLocalActiveAssetRecords(p778);
    end;
end);
AssetCmds.RuntimeOwnerCleared:Connect(function(p779) -- Line: 5496
    -- upvalues: LocalPlayer (ref), handleLocalActiveAssetRecords (copy)
    if p779 == LocalPlayer.UserId then
        handleLocalActiveAssetRecords({});
    end;
end);
task.spawn(function() -- Line: 5502
    -- upvalues: u71 (ref), u77 (ref), u72 (ref), u78 (ref)
    if not Save.IsLocalDataLoaded() then
        Save.LoadedStats:Wait();
    end;

    syncAssetsFromSave();
    syncEggsFromSave();
    reconcileVirtualAssetEquipState();
    reconcileVirtualEggEquipState();
    u71 = captureEligibleAssetUIDs();
    u77 = captureEggUIDs();
    u72 = true;
    u78 = true;
end);
Save.ConnectForDataChanged({ "Inventory", "AssetFavoriteCategories" }, function() -- Line: 5517
    -- upvalues: u72 (ref), u71 (ref)
    local v780 = captureEligibleAssetUIDs();

    if u72 then
        queueNewEligibleAssetsForHotbar(u71, v780);
    end;

    u71 = v780;
    u72 = true;
    syncAssetsFromSave();
    reconcileVirtualAssetEquipState();
    movePendingHotbarAssets();
end);
Save.ConnectForDataChanged({ "EquippedAssets", "BaseUpgradeLevel", "Rebirth", "Gamepasses", "Products" }, function() -- Line: 5529
    syncAssetsFromSave();
    reconcileVirtualAssetEquipState();
end);
Save.ConnectForDataChanged("EggInventory", function() -- Line: 5534
    -- upvalues: u78 (ref), u77 (ref)
    local v781 = captureEggUIDs();

    if u78 then
        queueNewEggsForHotbar(u77, v781);
    end;

    u77 = v781;
    u78 = true;
    syncEggsFromSave();
    reconcileVirtualEggEquipState();
    movePendingHotbarEggs();
end);
EggCmds.RuntimeSnapshotUpdated:Connect(function() -- Line: 5546
    syncEggsFromSave();
    reconcileVirtualEggEquipState();
end);
PlotCmds.OnLocalPlotUpdated:Connect(function() -- Line: 5551
    invalidateEquipBestStatus(true);
end);
PlotCmds.OnPlotsFolderUpdated:Connect(function() -- Line: 5554
    invalidateEquipBestStatus(true);
end);
UserInputService.InputBegan:Connect(HandleInputBegan);
UserInputService.TextBoxFocused:Connect(function() -- Line: 5559
    -- upvalues: u56 (ref)
    u56 = true;
end);
UserInputService.TextBoxFocusReleased:Connect(function() -- Line: 5562
    -- upvalues: u56 (ref)
    u56 = false;
end);

u50[Value2] = function() -- Line: 5565
    -- upvalues: u29 (ref)
    if u29 then
        UnequipAllTools();
    end;
end;

UserInputService.Changed:Connect(OnInputServiceChanged);
OnInputServiceChanged("KeyboardEnabled");

if UserInputService:GetGamepadConnected(Enum.UserInputType.Gamepad1) then
    gamepadConnected();
end;

UserInputService.GamepadConnected:Connect(function(p782) -- Line: 5575
    if p782 == Enum.UserInputType.Gamepad1 then
        gamepadConnected();
    end;
end);
UserInputService.GamepadDisconnected:Connect(function(p783) -- Line: 5580
    if p783 == Enum.UserInputType.Gamepad1 then
        gamepadDisconnected();
    end;
end);

function u14.RequestSelection(p784, p785, p786, p787, p788, p789) -- Line: 5585
    -- upvalues: u15 (ref)
    u15 = {
        ItemType = p785,
        Callback = p786,
        AllowHotbar = p787 == true,
        Preserve = p788 == true,
        Validator = p789
    };
end;

function u14.ClearSelectionRequest(p790) -- Line: 5600
    -- upvalues: u15 (ref)
    u15 = nil;
end;

function u14.SetCategory(p791, p792) -- Line: 5603
    -- upvalues: u8 (ref)
    u8(p792);
end;

function u14.OpenInventory(p793) -- Line: 5606
    -- upvalues: u14 (copy)
    if not u14.IsOpen then
        u14.OpenClose();
    end;
end;

function u14.SetBackpackEnabled(p794, p795) -- Line: 5611
    BackpackEnabled = p795;
end;

function u14.IsOpened(p796) -- Line: 5614
    -- upvalues: u14 (copy)
    return u14.IsOpen;
end;

function u14.GetBackpackEnabled(p797) -- Line: 5617
    return BackpackEnabled;
end;

function u14.GetCategory(p798) -- Line: 5620
    -- upvalues: u2 (ref)
    return u2;
end;

function u14.RefreshInventory(p799) -- Line: 5623
    -- upvalues: u6 (ref)
    if u6 then
        u6();

        return;
    end;

    UpdateInventorySlots();
end;

function u14.GetStateChangedEvent(p800) -- Line: 5631
    -- upvalues: u14 (copy)
    return u14.StateChanged.Event;
end;

function u14.ForceEggIntoTutorialHotbar(p801, p802) -- Line: 5635
    -- upvalues: u73 (copy), u76 (copy), u75 (copy), u47 (copy), u6 (ref)
    local v803 = u73[p802] or findVirtualEggSlotByUID(p802);

    if not v803 or v803.IsDeleted then
        u76[p802] = true;

        return nil;
    end;

    u75[p802] = nil;
    u76[p802] = nil;
    local v804 = u47[4];
    local v805;

    if v804 then
        v805 = not v804.IsFakeSlot;
    else
        v805 = v804;
    end;

    assert(v805, "Tutorial egg hotbar slot 4 must be available");
    local v806 = canToolUseHotbarSlot(v803.Tool, 4);
    assert(v806, "Tutorial egg must be insertable in slot 4");

    if v804.Tool and v804 ~= v803 then
        v804:MoveToInventory();
    end;

    if v803 ~= v804 then
        v803:Swap(v804);
    end;

    u73[p802] = v804;
    AdjustHotbarFrames();
    UpdateInventorySlots();

    if u6 then
        u6(true);
    end;

    if reconcileVirtualEggEquipState() ~= p802 then
        v804:Select();
    end;

    return v804.Frame;
end;

function u14.GetEggSlotFrame(p807, p808) -- Line: 5671
    -- upvalues: u73 (copy)
    local v809 = u73[p808] or findVirtualEggSlotByUID(p808);

    if v809 == nil or v809.IsDeleted then
        return nil;
    end;

    return v809.Frame;
end;

RunService.Heartbeat:Connect(function() -- Line: 5682
    -- upvalues: ToolGameplayGuard (copy), u55 (ref), u89 (ref), u87 (ref), u86 (ref)
    OnIconChanged(BackpackEnabled);
    local v810 = ToolGameplayGuard.IsLocalPlayerInGameplayArea();

    if v810 and not u55 then
        ensureGameplayGearHotbarSlots();
    end;

    u55 = v810;
    local v811 = isLocalPlayerWithinOwnPlotBounds();

    if u89 == v811 then
        if u89 and (u87 or not u86) then
            requestEquipBestStatusRefresh();

            return;
        end;

        updateEquipBestButtonVisibility();

        return;
    end;

    u89 = v811;

    if v811 then
        requestEquipBestStatusRefresh(true);

        return;
    end;

    updateEquipBestButtonVisibility();
end);
ApiEvent.Event:Connect(function(p812, p813) -- Line: 5707
    -- upvalues: u14 (copy)
    if p812 == "SetBackpackEnabled" then
        u14:SetBackpackEnabled(p813);

        return;
    end;

    if p812 == "SetInventoryOpen" then
        if type(p813) == "boolean" and p813 == true then
            u14.IsOpen = true;

            return;
        end;

        if type(p813) == "boolean" then
            u14.IsOpen = false;
        end;
    elseif p812 == "ToggleBackpack" then
        u14.OpenClose();
    end;
end);

return u14;