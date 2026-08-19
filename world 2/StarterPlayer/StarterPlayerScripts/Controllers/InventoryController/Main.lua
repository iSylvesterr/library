-- Decompiled with Potassium's decompiler.

local u1 = {
    OpenClose = nil,
    IsOpen = false,
    StateChanged = Instance.new("BindableEvent")
};
local SideBar = script.SideBar;
local GuiController = require(game.Players.LocalPlayer.PlayerScripts.Controllers.GuiController);
MushroomData = require(game.ReplicatedStorage.SharedModules.MushroomData);
GnomeData = require(game.ReplicatedStorage.SharedModules.GnomeData);
RaccoonData = require(game.ReplicatedStorage.SharedModules.RaccoonData);
CrateData = require(game.ReplicatedStorage.SharedModules.CrateData);
ChestData = require(game.ReplicatedStorage.SharedModules.ChestData);
SeedPackData = require(game.ReplicatedStorage.SharedModules.SeedPackData);
CornucopiaData = require(game.ReplicatedStorage.SharedModules.CornucopiaData);
EggData = require(game.ReplicatedStorage.SharedModules.EggData);
TeleporterData = require(game.ReplicatedStorage.SharedModules.TeleporterData);
PowerHoseData = require(game.ReplicatedStorage.SharedModules.PowerHoseData);
MutationData = require(game.ReplicatedStorage.SharedModules.MutationData);
WeightFormat = require(game.ReplicatedStorage.SharedModules.WeightFormat);
PetData = require(game.ReplicatedStorage.SharedData.PetData);
u1.ModuleName = "Backpack";
u1.KeepVRTopbarOpen = true;
u1.VRIsExclusive = true;
u1.VRClosesNonExclusive = true;
ImageData = game.ReplicatedStorage.SharedModules.SeedData;
FruitImages = ImageData.FruitImages;
PlantImages = ImageData.PlantImages;
SeedImages = ImageData.SeedImages;
BuildIMG = "rbxassetid://123856554248782";
ICON_SIZE = 60;
FONT_SIZE = script:GetAttribute("TextSize");
ICON_BUFFER = 5;
BACKGROUND_FADE = script:GetAttribute("BackgroundTransparency");
BACKGROUND_COLOR = script:GetAttribute("BackgroundColor");
VR_FADE_TIME = 1;
VR_PANEL_RESOLUTION = 100;
SLOT_DRAGGABLE_COLOR = script:GetAttribute("DraggableColor");
SLOT_EQUIP_COLOR = script:GetAttribute("EquippedColor");
SLOT_EQUIP_THICKNESS = 3;
SLOT_FADE_LOCKED = script:GetAttribute("SlotLockedTransparency");
SLOT_BORDER_COLOR = script:GetAttribute("BorderColor");
TOOLTIP_BUFFER = 24;
TOOLTIP_HEIGHT = 24;
TOOLTIP_OFFSET = -28;
ARROW_HOTKEY = { Enum.KeyCode.Backquote, Enum.KeyCode.DPadUp };
HOTBAR_SLOTS_FULL = script:GetAttribute("FullSlots");
HOTBAR_SLOTS_VR = script:GetAttribute("EmptySlots");
HOTBAR_SLOTS_MINI = 5;
HOTBAR_SLOTS_WIDTH_CUTOFF = 1024;
HOTBAR_OFFSET_FROMBOTTOM = -30;
INVENTORY_ROWS_FULL = 4;
INVENTORY_ROWS_VR = 3;
INVENTORY_ROWS_MINI = 2;
INVENTORY_HEADER_SIZE = 40;
INVENTORY_ARROWS_BUFFER_VR = 40;
local v2 = script:GetAttribute("SearchBoxColor");
local v3 = script:GetAttribute("SearchBoxTransparency");
local Api = script:WaitForChild("Api");
Api.Parent = game.ReplicatedStorage;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local FruitProxyUtil = require(ReplicatedStorage.SharedModules.FruitProxyUtil);
local AnimatedGradient = require(ReplicatedStorage.SharedModules.AnimatedGradient);
local u4 = true;
local u5 = false;

local function _() -- Line: 106
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
local u6 = {
    [Enum.UserInputType.Gamepad1] = true,
    [Enum.UserInputType.Gamepad2] = true,
    [Enum.UserInputType.Gamepad3] = true,
    [Enum.UserInputType.Gamepad4] = true,
    [Enum.UserInputType.Gamepad5] = true,
    [Enum.UserInputType.Gamepad6] = true,
    [Enum.UserInputType.Gamepad7] = true,
    [Enum.UserInputType.Gamepad8] = true
};
local UserInputService = game:GetService("UserInputService");
local Players = game:GetService("Players");
game:GetService("ReplicatedStorage");
local StarterGui = game:GetService("StarterGui");
local GuiService = game:GetService("GuiService");
local ScreenGui = Instance.new("ScreenGui", Players.LocalPlayer.PlayerGui);
ScreenGui.DisplayOrder = 120;
ScreenGui.IgnoreGuiInset = true;
ScreenGui.ResetOnSpawn = false;
ScreenGui.Name = "BackpackGui";
local ContextActionService = game:GetService("ContextActionService");
local ProximityPromptService = game:GetService("ProximityPromptService");
local RunService = game:GetService("RunService");
local VRService = game:GetService("VRService");
local Utility = require(script.Utility);
require(script.GameTranslator);
local topbarplus = require(game:GetService("ReplicatedStorage").ClientModules.topbarplus);
require(game.ReplicatedStorage.SharedModules.SeedData);
local SprinklerData = require(game.ReplicatedStorage.SharedModules.SprinklerData);
local RakeData = require(game.ReplicatedStorage.SharedModules.RakeData);
local WateringcanData = require(game.ReplicatedStorage.SharedModules.WateringcanData);
local ShovelData = require(game.ReplicatedStorage.SharedModules.ShovelData);
local TrowelData = require(game.ReplicatedStorage.SharedModules.TrowelData);
local BuildData = require(game.ReplicatedStorage.SharedModules.BuildData);
local CrowbarData = require(game.ReplicatedStorage.SharedModules.CrowbarData);
local IMG = ShovelData.Data.IMG;
local IMG2 = TrowelData.Data.IMG;
local IMG3 = BuildData.Data.IMG;
local IMG4 = CrowbarData.Data.IMG;
local u7 = GuiService:IsTenFootInterface();

if u7 then
    ICON_SIZE = 100;
    FONT_SIZE = 24;
end;

local u8 = false;
local u9 = false;
local u10 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled;

local function GetHotbarBottomMargin() -- Line: 182
    -- upvalues: u10 (copy)
    if not u10 then
        return 0;
    end;

    local ViewportSize = game.Workspace.Camera.ViewportSize;

    return math.max(ViewportSize.X, ViewportSize.Y) >= 1000 and 18 or 0;
end;

local LocalPlayer = Players.LocalPlayer;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
local u19 = u18:FindFirstChildOfClass("Humanoid");
local Backpack = LocalPlayer:WaitForChild("Backpack");
local u20 = topbarplus.new();
u20:setImage("rbxasset://textures/ui/TopBar/inventoryOff.png", "deselected");
u20:setImage("rbxasset://textures/ui/TopBar/inventoryOn.png", "selected");
u20:bindToggleKey(ARROW_HOTKEY[1], ARROW_HOTKEY[2]);
u20:setName("InventoryIcon");
u20:setImageScale(1.12);
u20:setOrder(0);
u20:setCaption("Toggle the backpack.");
u20.deselectWhenOtherIconSelected = false;
local u21 = topbarplus.new();
u21:setImage("rbxassetid://125872769879713", "deselected");
u21:setImage("rbxassetid://125872769879713", "selected");
u21:setName("ShopIcon");
u21:bindToggleKey(Enum.KeyCode.P);
u21:setImageScale(1.12);
u21:setOrder(1);
u21:setCaption("Open the shop.");
u21:setEnabled(true);
u21.deselectWhenOtherIconSelected = false;
local u22 = topbarplus.new();
u22:setImage("rbxassetid://96480124490680", "deselected");
u22:setImage("rbxassetid://96480124490680", "selected");
u22:setName("SettingIcon");
u22:bindToggleKey(Enum.KeyCode.L);
u22:setImageScale(1.12);
u22:setOrder(1);
u22:setCaption("Open the settings.");
u22:setEnabled(true);
u22.deselectWhenOtherIconSelected = false;
local u23 = topbarplus.new();
u23:setImage(IMG3, "deselected");
u23:setImage(IMG3, "selected");
u23:setName("BuildIcon");
u23:bindToggleKey(Enum.KeyCode.B);
u23:setImageScale(1.12);
u23:setOrder(2);
u23:setCaption("Equip build tool.");
u23:setEnabled(false);
u23.deselectWhenOtherIconSelected = false;
local u24 = {};
local u25 = nil;
local u26 = {};
local u27 = {};
local u28 = {};
local u29 = 0;
local u30 = false;
local u31 = false;
local u32 = false;
local u33 = false;
local u34 = {};
local u35 = {};
local u36 = false;
local u37 = 0;
local VREnabled = VRService.VREnabled;
local u38 = VREnabled and HOTBAR_SLOTS_VR or (u9 and HOTBAR_SLOTS_MINI or HOTBAR_SLOTS_FULL);
local u39 = VREnabled and INVENTORY_ROWS_VR or (u9 and INVENTORY_ROWS_MINI or INVENTORY_ROWS_FULL);
local u40 = nil;
local u41 = "All";
local u42 = 0;

local function PassesFavoriteFilter(p43) -- Line: 282
    -- upvalues: u42 (ref)
    if u42 == 0 then
        return true;
    end;

    local v44 = p43:GetAttribute("IsFavorite") == true;

    if u42 == 1 then
        return v44;
    end;

    return not v44;
end;

local u45 = nil;
local u46 = nil;
local u47 = nil;
local u48 = nil;

local function ToggleFavorite(p49) -- Line: 303
    -- upvalues: Networking (copy), FruitProxyUtil (copy)
    local Tool = p49.Tool;

    if not Tool then
        return;
    end;

    local u50 = Tool:GetAttribute("IsFavorite") ~= true;
    local u51 = Tool:GetAttribute("PetId");

    if u51 then
        Tool:SetAttribute("IsFavorite", u50 and true or nil);
        task.spawn(function() -- Line: 313
            -- upvalues: Networking (ref), u51 (copy), u50 (copy)
            Networking.Backpack.SetPetFavorite:Fire(u51, u50);
        end);

        return;
    end;

    if not FruitProxyUtil.IsFruitInstance(Tool) then
        return;
    end;

    local u52 = Tool:GetAttribute("Id");

    if not u52 then
        return;
    end;

    Tool:SetAttribute("IsFavorite", u50 and true or nil);
    task.spawn(function() -- Line: 323
        -- upvalues: Networking (ref), u52 (copy), u50 (copy)
        Networking.Backpack.SetFruitFavorite:Fire(u52, u50);
    end);
end;

local u53 = nil;
local u54 = false;
local u55 = false;
local u56 = true;
local u57 = 0;

function GetToolKey(p58)
    -- upvalues: FruitProxyUtil (copy)
    if not p58 then
        return nil;
    end;

    if not (p58:IsA("Tool") or FruitProxyUtil.IsFruitProxy(p58)) then
        return nil;
    end;

    if p58:GetAttribute("PetId") then
        return "Pet:" .. p58:GetAttribute("PetId");
    end;

    if p58:GetAttribute("SeedTool") then
        return "Seed:" .. p58:GetAttribute("SeedTool");
    end;

    if p58:GetAttribute("Fruit") then
        local v59 = p58:GetAttribute("Id");

        if v59 then
            return "Fruit:" .. v59;
        end;

        return "Fruit:" .. p58:GetAttribute("Fruit");
    end;

    if p58:GetAttribute("Sprinkler") then
        return "Sprinkler:" .. p58:GetAttribute("Sprinkler");
    end;

    if p58:GetAttribute("Rake") then
        return "Rake:" .. p58:GetAttribute("Rake");
    end;

    if p58:GetAttribute("WateringCan") then
        return "WateringCan:" .. p58:GetAttribute("WateringCan");
    end;

    if p58:GetAttribute("Shovel") then
        return "Shovel:" .. p58:GetAttribute("Shovel");
    end;

    if p58:GetAttribute("Trowel") then
        return "Trowel:" .. p58:GetAttribute("Trowel");
    end;

    if p58:GetAttribute("Crowbar") then
        return "Crowbar:" .. p58:GetAttribute("Crowbar");
    end;

    if p58:GetAttribute("Build") then
        return "Build:" .. p58:GetAttribute("Build");
    end;

    if p58:GetAttribute("Mushroom") then
        return "Mushroom:" .. p58:GetAttribute("Mushroom");
    end;

    if p58:GetAttribute("Gnome") then
        return "Gnome:" .. p58:GetAttribute("Gnome");
    end;

    if p58:GetAttribute("SeedPack") then
        return "SeedPack:" .. p58:GetAttribute("SeedPack");
    end;

    if p58:GetAttribute("Cornucopia") then
        return "Cornucopia:" .. p58:GetAttribute("Cornucopia");
    end;

    if p58:GetAttribute("Egg") then
        return "Egg:" .. p58:GetAttribute("Egg");
    end;

    if p58:GetAttribute("Crate") then
        return "Crate:" .. p58:GetAttribute("Crate");
    end;

    if p58:GetAttribute("Chest") then
        return "Chest:" .. p58:GetAttribute("Chest");
    end;

    if p58:GetAttribute("Teleporter") then
        return "Teleporter:" .. p58:GetAttribute("Teleporter");
    end;

    if p58:GetAttribute("PlayerMagnet") then
        return "PlayerMagnet:" .. p58:GetAttribute("PlayerMagnet");
    end;

    if p58:GetAttribute("FruitMagnet") then
        return "FruitMagnet:" .. p58:GetAttribute("FruitMagnet");
    end;

    if p58:GetAttribute("PetTeleporter") then
        return "PetTeleporter:" .. p58:GetAttribute("PetTeleporter");
    end;

    if p58:GetAttribute("MagicMail") then
        return "MagicMail:" .. p58:GetAttribute("MagicMail");
    end;

    if p58:GetAttribute("PowerHose") then
        return "PowerHose:" .. p58:GetAttribute("PowerHose");
    end;

    if p58:GetAttribute("Wheelbarrow") then
        return "Wheelbarrow:" .. p58:GetAttribute("Wheelbarrow");
    end;

    if p58:GetAttribute("Ladder") then
        return "Ladder:" .. p58:GetAttribute("Ladder");
    end;

    if p58:GetAttribute("FreezeRay") then
        return "FreezeRay:" .. p58:GetAttribute("FreezeRay");
    end;

    if p58:GetAttribute("Flashbang") then
        return "Flashbang:" .. p58:GetAttribute("Flashbang");
    end;

    if p58:GetAttribute("MagicDice") then
        return "MagicDice:" .. p58:GetAttribute("MagicDice");
    end;

    if p58:GetAttribute("WeatherStaff") then
        return "WeatherStaff:" .. p58:GetAttribute("WeatherStaff");
    end;

    if p58:GetAttribute("WindStaff") then
        return "WindStaff:" .. p58:GetAttribute("WindStaff");
    end;

    if p58:GetAttribute("StrawberrySniper") then
        return "StrawberrySniper:" .. p58:GetAttribute("StrawberrySniper");
    end;

    if p58:GetAttribute("Harp") then
        return "Harp:" .. p58:GetAttribute("Harp");
    end;

    if p58:GetAttribute("Bird") then
        return "Bird:" .. p58:GetAttribute("Bird");
    end;

    return "Name:" .. p58.Name;
end;

local function SendHotbarLayoutToServer() -- Line: 421
    -- upvalues: u56 (ref), u55 (ref), u38 (ref), u24 (ref), Networking (copy)
    if u56 then
        return;
    end;

    if u55 then
        return;
    end;

    u55 = true;
    task.delay(1, function() -- Line: 426
        -- upvalues: u56 (ref), u55 (ref), u38 (ref), u24 (ref), Networking (ref)
        if u56 then
            u55 = false;

            return;
        end;

        local v60 = {};
        local v61 = 0;

        for i = 1, u38 do
            local v62 = u24[i];

            if v62 and v62.Tool then
                local v63 = GetToolKey(v62.Tool);

                if v63 then
                    v60[i] = v63;
                    v61 = v61 + 1;
                end;
            end;
        end;

        if v61 == 0 then
            u55 = false;

            return;
        end;

        Networking.Backpack.SaveLayout:Fire(v60);
        u55 = false;
    end);
end;

function WaitForToolsToSettle()
    -- upvalues: u57 (ref)
    local v64 = tick() + 30;
    u57 = tick();

    while tick() < v64 do
        if tick() - u57 >= 2 then
            return;
        end;

        task.wait(0.1);
    end;
end;

local function ApplySavedLayout() -- Line: 469
    -- upvalues: u53 (ref), u54 (ref), u38 (ref), u24 (ref), u46 (ref), u16 (ref), FruitProxyUtil (copy), u25 (ref), u45 (ref), u47 (ref), u48 (ref)
    if not u53 or u54 then
        return;
    end;

    local v65 = 0;

    for _ in pairs(u53) do
        v65 = v65 + 1;
    end;

    if v65 == 0 then
        u54 = true;

        return;
    end;

    u54 = true;
    local v66 = {};

    for i = 1, u38 do
        local v67 = u24[i];

        if v67 and v67.Tool then
            table.insert(v66, v67.Tool);
            v67:Clear();
        end;
    end;

    local v68 = {};

    for i = #u24, u38 + 1, -1 do
        local v69 = u24[i];

        if v69 and v69.Tool then
            table.insert(v68, v69.Tool);
            v69:Clear();
            v69:Delete();
        end;
    end;

    local v70 = {};

    for _, v in v66 do
        table.insert(v70, v);
    end;

    for _, v in v68 do
        table.insert(v70, v);
    end;

    local v71 = {};

    for i, v in pairs(u53) do
        local v72 = tonumber(i);

        if v72 and (v72 >= 1 and v72 <= u38) then
            for _, v4 in v70 do
                if not v71[v4] and GetToolKey(v4) == v then
                    u24[v72]:Fill(v4);
                    v71[v4] = true;
                    break;
                end;
            end;
        end;
    end;

    for _, v in v70 do
        if not v71[v] then
            u46(u16):Fill(v);
            v71[v] = true;
        end;
    end;

    for i = 1, u38 do
        local v73 = u24[i];

        if v73 and (v73.Tool and FruitProxyUtil.IsFruitProxy(v73.Tool)) then
            local v74 = v73.Tool:GetAttribute("Id");

            if v74 then
                FruitProxyUtil.Pending.Slots[v74] = i;
                FruitProxyUtil.RequestPromote(v74);
            end;
        end;
    end;

    u25 = u45();
    u47();
    u48();
end;

local function ToolMatchesFilter(p75, p76) -- Line: 552
    if p76 == "All" then
        return true;
    end;

    local v77 = p75:GetAttribute("MainCategory");

    if p76 == "Seeds" then
        return v77 == "Seed" and true or p75:GetAttribute("SeedTool") ~= nil;
    end;

    if p76 == "Fruits" then
        return v77 == "Fruit" and true or p75:GetAttribute("Fruit") ~= nil;
    end;

    if p76 == "Pets" then
        return v77 == "Pet" and true or p75:GetAttribute("Pet") ~= nil;
    end;

    return p76 ~= "Gears" and true or ((v77 == "Gear" or v77 == "Egg") and true or ((p75:GetAttribute("Egg") ~= nil or (p75:GetAttribute("Sprinkler") ~= nil or (p75:GetAttribute("WateringCan") ~= nil or (p75:GetAttribute("Shovel") ~= nil or (p75:GetAttribute("Trowel") ~= nil or (p75:GetAttribute("Crowbar") ~= nil or (p75:GetAttribute("Build") ~= nil or (p75:GetAttribute("Mushroom") ~= nil or (p75:GetAttribute("Gnome") ~= nil or (p75:GetAttribute("Crate") ~= nil or (p75:GetAttribute("Chest") ~= nil or (p75:GetAttribute("Teleporter") ~= nil or (p75:GetAttribute("PowerHose") ~= nil or (p75:GetAttribute("Wheelbarrow") ~= nil or (p75:GetAttribute("Ladder") ~= nil or (p75:GetAttribute("FreezeRay") ~= nil or (p75:GetAttribute("Rake") ~= nil or p75:GetAttribute("Flashbang") ~= nil))))))))))))))))) and true or p75:GetAttribute("Bird") ~= nil));
end;

local function EvaluateBackpackPanelVisibility(p78) -- Line: 603
    -- upvalues: u20 (copy), u4 (ref), VRService (copy)
    return p78 and (u20.enabled and u4) and VRService.VREnabled;
end;

local function ShowVRBackpackPopup() -- Line: 607
end;

local function NewGui(p79, p80) -- Line: 613
    local v81 = Instance.new(p79);
    v81.Name = p80;
    v81.BackgroundColor3 = Color3.new(0, 0, 0);
    v81.BackgroundTransparency = 1;
    v81.BorderColor3 = Color3.new(0, 0, 0);
    v81.BorderSizePixel = 0;
    v81.Size = UDim2.new(1, 0, 1, 0);

    if p79:match("Text") then
        v81.TextColor3 = Color3.new(1, 1, 1);
        v81.Text = "";
        v81.FontFace = script:GetAttribute("LabelFont");
        v81.TextSize = FONT_SIZE;
        v81.TextWrapped = true;

        if p79 == "TextButton" then
            v81.FontFace = script:GetAttribute("SlotFont");
        end;
    end;

    return v81;
end;

u45 = function() -- Line: 635
    -- upvalues: u38 (ref), u24 (ref)
    for i = 1, u38 do
        local v82 = u24[i];

        if not v82.Tool then
            return v82;
        end;
    end;

    return nil;
end;

local function isInventoryEmpty() -- Line: 645
    -- upvalues: u38 (ref), u24 (ref)
    for i = u38 + 1, #u24 do
        local v83 = u24[i];

        if v83 and v83.Tool then
            return false;
        end;
    end;

    return true;
end;

local function UseGazeSelection() -- Line: 655
    -- upvalues: UserInputService (copy)
    return UserInputService.VREnabled;
end;

local function GetBuildTool() -- Line: 660
    -- upvalues: Backpack (ref), u18 (ref)
    if Backpack then
        for _, child in Backpack:GetChildren() do
            if child:IsA("Tool") and child:GetAttribute("Build") then
                return child;
            end;
        end;
    end;

    if u18 then
        for _, child in u18:GetChildren() do
            if child:IsA("Tool") and child:GetAttribute("Build") then
                return child;
            end;
        end;
    end;

    return nil;
end;

local function IsBuildToolEquipped() -- Line: 680
    -- upvalues: u18 (ref)
    if not u18 then
        return false;
    end;

    for _, child in u18:GetChildren() do
        if child:IsA("Tool") and child:GetAttribute("Build") then
            return true;
        end;
    end;

    return false;
end;

local function UpdateBuildIcon() -- Line: 692
    -- upvalues: GetBuildTool (copy), u23 (copy), u5 (ref), u9 (ref), IsBuildToolEquipped (copy)
    local v84 = GetBuildTool();
    local v85;

    if v84 == nil then
        v85 = false;
    else
        v85 = not u5 and not u9;
    end;

    u23:setEnabled(v85);

    if v84 then
        if IsBuildToolEquipped() then
            u23:select();

            return;
        end;

        u23:deselect();
    end;
end;

u23.selected:Connect(function() -- Line: 708
    -- upvalues: GetBuildTool (copy), IsBuildToolEquipped (copy), u19 (ref), u18 (ref)
    local v86 = GetBuildTool();

    if v86 and not IsBuildToolEquipped() then
        if u19 then
            u19:UnequipTools();
        end;

        v86.Parent = u18;
    end;
end);
u23.deselected:Connect(function() -- Line: 718
    -- upvalues: IsBuildToolEquipped (copy), u19 (ref)
    if IsBuildToolEquipped() and u19 then
        u19:UnequipTools();
    end;
end);
task.spawn(function() -- Line: 726
    -- upvalues: u21 (copy), u22 (copy), u13 (ref), u1 (copy), u5 (ref), u23 (copy), UpdateBuildIcon (ref)
    local LocalPlayer2 = game.Players.LocalPlayer;

    repeat
        task.wait();
    until LocalPlayer2:HasTag("ControllersStarted");

    local GuiController2 = require(LocalPlayer2.PlayerScripts:WaitForChild("Controllers"):WaitForChild("GuiController"));
    u21.selected:Connect(function() -- Line: 732
        -- upvalues: GuiController2 (copy)
        if GuiController2:IsOpen("RobuxShop") then
            GuiController2:Close("RobuxShop");

            return;
        end;

        GuiController2:Open("RobuxShop", nil, { "HUD" });
    end);
    u21.deselected:Connect(function() -- Line: 740
        -- upvalues: GuiController2 (copy)
        if GuiController2:IsOpen("RobuxShop") then
            GuiController2:Close("RobuxShop");

            return;
        end;

        GuiController2:Open("RobuxShop", nil, { "HUD" });
    end);
    u22.selected:Connect(function() -- Line: 748
        -- upvalues: GuiController2 (copy)
        if GuiController2:IsOpen("Settings") then
            GuiController2:Close("Settings");

            return;
        end;

        GuiController2:Open("Settings", nil, { "HUD" });
    end);
    u22.deselected:Connect(function() -- Line: 756
        -- upvalues: GuiController2 (copy)
        if GuiController2:IsOpen("Settings") then
            GuiController2:Close("Settings");

            return;
        end;

        GuiController2:Open("Settings", nil, { "HUD" });
    end);
    GuiController2.GuiFocusedSignal:Connect(function() -- Line: 764
        -- upvalues: u13 (ref), u1 (ref), u5 (ref), u21 (ref), u22 (ref), u23 (ref)
        if u13 and u13.Visible then
            u1.OpenClose();
        end;

        u5 = true;
        u21:setEnabled(false);
        u22:setEnabled(false);
        u23:setEnabled(false);
    end);
    GuiController2.GuiUnfocusedSignal:Connect(function() -- Line: 775
        -- upvalues: u5 (ref), u21 (ref), u22 (ref), UpdateBuildIcon (ref)
        u5 = false;
        u21:setEnabled(true);
        u22:setEnabled(true);
        UpdateBuildIcon();
    end);
end);

u47 = function() -- Line: 784
    -- upvalues: u13 (ref), u38 (ref), u29 (ref), u24 (ref)
    local Visible = u13.Visible;
    local v87 = Visible and u38 or u29;
    local _ = v87 >= 1;
    local v88 = 0;

    for i = 1, u38 do
        local v89 = u24[i];

        if v89.Tool or Visible then
            v88 = v88 + 1;
            v89:Readjust(v88, v87);
            v89.Frame.Visible = true;
        else
            v89.Frame.Visible = false;
        end;
    end;
end;

local u90 = 0;

local function UpdateScrollingFrameCanvasSize() -- Line: 810
    -- upvalues: u15 (ref), u90 (ref)
    local v91 = math.floor(u15.AbsoluteSize.X / (ICON_SIZE + ICON_BUFFER));
    local v92 = math.ceil(u90 / (v91 < 1 and 1 or v91)) * (ICON_SIZE + ICON_BUFFER) + ICON_BUFFER;
    u15.CanvasSize = UDim2.new(0, 0, 0, v92);
end;

u48 = function() -- Line: 819
    -- upvalues: u1 (copy), u33 (ref), u38 (ref), u24 (ref), ToolMatchesFilter (copy), u41 (ref), u42 (ref), u90 (ref), UpdateScrollingFrameCanvasSize (ref)
    local _ApplySearch = u1._ApplySearch;

    if u33 and _ApplySearch then
        _ApplySearch();

        return;
    end;

    local v93 = 0;

    for i = u38 + 1, #u24 do
        local v94 = u24[i];
        v94.Frame.LayoutOrder = v94.Index;
        local v95;

        if v94.Tool == nil then
            v95 = false;
        else
            v95 = ToolMatchesFilter(v94.Tool, u41);

            if v95 then
                local Tool = v94.Tool;

                if u42 == 0 then
                    v95 = true;
                else
                    v95 = Tool:GetAttribute("IsFavorite") == true;

                    if u42 ~= 1 then
                        v95 = not v95;
                    end;
                end;
            end;
        end;

        v94.Frame.Visible = v95;

        if v95 then
            v93 = v93 + 1;
        end;
    end;

    u90 = v93;
    UpdateScrollingFrameCanvasSize();
end;

local function AddInventorySlotIncremental(p96) -- Line: 846
    -- upvalues: u1 (copy), u33 (ref), ToolMatchesFilter (copy), u41 (ref), u42 (ref), u90 (ref), UpdateScrollingFrameCanvasSize (ref)
    local _ApplySearch = u1._ApplySearch;

    if u33 and _ApplySearch then
        _ApplySearch();

        return;
    end;

    p96.Frame.LayoutOrder = p96.Index;
    local v97;

    if p96.Tool == nil then
        v97 = false;
    else
        v97 = ToolMatchesFilter(p96.Tool, u41);

        if v97 then
            local Tool = p96.Tool;

            if u42 == 0 then
                v97 = true;
            else
                v97 = Tool:GetAttribute("IsFavorite") == true;

                if u42 ~= 1 then
                    v97 = not v97;
                end;
            end;
        end;
    end;

    p96.Frame.Visible = v97;

    if v97 then
        u90 = u90 + 1;
    end;

    UpdateScrollingFrameCanvasSize();
end;

local u98 = false;
local u99 = UpdateBuildIcon;
local u100 = false;

UpdateBuildIcon = function() -- Line: 867
    -- upvalues: u100 (ref), u99 (copy)
    if u100 then
        return;
    end;

    u100 = true;
    task.defer(function() -- Line: 870
        -- upvalues: u100 (ref), u99 (ref)
        u100 = false;
        u99();
    end);
end;

local u101 = u47;
local u102 = false;

u47 = function() -- Line: 878
    -- upvalues: u102 (ref), u101 (copy)
    if u102 then
        return;
    end;

    u102 = true;
    task.defer(function() -- Line: 881
        -- upvalues: u102 (ref), u101 (ref)
        u102 = false;
        u101();
    end);
end;

local u103 = UpdateScrollingFrameCanvasSize;
local u104 = false;

UpdateScrollingFrameCanvasSize = function() -- Line: 889
    -- upvalues: u104 (ref), u103 (copy)
    if u104 then
        return;
    end;

    u104 = true;
    task.defer(function() -- Line: 892
        -- upvalues: u104 (ref), u103 (ref)
        u104 = false;
        u103();
    end);
end;

local u105 = {};
local u106 = false;
local u107 = nil;

local function u115(p108) -- Line: 903
    -- upvalues: u105 (copy), u106 (ref), u24 (ref), u38 (ref), u90 (ref), u107 (ref), u17 (ref), u98 (ref), UpdateScrollingFrameCanvasSize (ref), RunService (copy)
    p108.Frame.Visible = false;
    table.insert(u105, p108);

    if not u106 then
        u106 = true;
        task.defer(function() -- Line: 908
            -- upvalues: u106 (ref), u105 (ref), u24 (ref), u38 (ref), u90 (ref), u107 (ref), u17 (ref), u98 (ref), UpdateScrollingFrameCanvasSize (ref), RunService (ref)
            u106 = false;
            local v109 = {};

            for _, v in u105 do
                v109[v] = true;
            end;

            table.clear(u105);
            local u110 = {};
            local v111 = 1;
            local v112 = 0;

            for i = 1, #u24 do
                local v113 = u24[i];

                if v109[v113] then
                    table.insert(u110, v113.Frame);
                else
                    v113.Index = v111;
                    v113.Frame.Name = v111;
                    v113.Frame.LayoutOrder = v111;
                    u24[v111] = v113;

                    if u38 < v111 and v113.Frame.Visible then
                        v112 = v112 + 1;
                    end;

                    v111 = v111 + 1;
                end;
            end;

            for i = v111, #u24 do
                u24[i] = nil;
            end;

            u90 = v112;

            if u107 and u17 then
                u17.Parent = u107;
                u107 = nil;
            end;

            u98 = false;
            UpdateScrollingFrameCanvasSize();
            task.spawn(function() -- Line: 947
                -- upvalues: u110 (copy), RunService (ref)
                for i = 1, #u110, 50 do
                    local v114 = math.min(i + 50 - 1, #u110);

                    for i2 = i, v114 do
                        u110[i2]:Destroy();
                    end;

                    if v114 < #u110 then
                        RunService.Heartbeat:Wait();
                    end;
                end;
            end);
        end);
    end;
end;

local u116 = false;

local function u117() -- Line: 963
    -- upvalues: u116 (ref), u17 (ref), u98 (ref), u107 (ref), u106 (ref)
    if u116 then
        return;
    end;

    if not (u17 and u17.Parent) then
        return;
    end;

    u116 = true;
    u98 = true;
    u107 = u17.Parent;
    u17.Parent = nil;
    task.defer(function() -- Line: 970
        -- upvalues: u116 (ref), u106 (ref), u107 (ref), u17 (ref), u98 (ref)
        u116 = false;

        if not u106 and (u107 and u17) then
            u17.Parent = u107;
            u107 = nil;
            u98 = false;
        end;
    end);
end;

local function UpdateBackpackLayout() -- Line: 981
    -- upvalues: u12 (ref), u38 (ref), u10 (copy), u13 (ref), u39 (ref), VREnabled (copy), u15 (ref), u47 (ref), u48 (ref)
    u12.Size = UDim2.new(0, ICON_BUFFER + u38 * (ICON_SIZE + ICON_BUFFER), 0, ICON_BUFFER + ICON_SIZE + ICON_BUFFER);
    local new = UDim2.new;
    local v118 = -u12.Size.X.Offset / 2;
    local v119 = -u12.Size.Y.Offset;
    local v120;

    if u10 then
        local ViewportSize = game.Workspace.Camera.ViewportSize;
        v120 = math.max(ViewportSize.X, ViewportSize.Y) >= 1000 and 18 or 0;
    else
        v120 = 0;
    end;

    u12.Position = new(0.5, v118, 1, v119 - v120);
    u13.Size = UDim2.new(0, u12.Size.X.Offset, 0, u12.Size.Y.Offset * u39 + INVENTORY_HEADER_SIZE + (VREnabled and 2 * INVENTORY_ARROWS_BUFFER_VR or 0));
    u13.Position = UDim2.new(0.5, -u13.Size.X.Offset / 2, 1, u12.Position.Y.Offset - u13.Size.Y.Offset);
    u15.Size = UDim2.new(1, u15.ScrollBarThickness + 1, 1, -INVENTORY_HEADER_SIZE - (VREnabled and 2 * INVENTORY_ARROWS_BUFFER_VR or 0));
    u15.Position = UDim2.new(0, 0, 0, INVENTORY_HEADER_SIZE + (VREnabled and INVENTORY_ARROWS_BUFFER_VR or 0));
    u47();
    u48();
end;

local function Clamp(p121, p122, p123) -- Line: 993
    local v124 = math.max(p121, p123);

    return math.min(p122, v124);
end;

local function CheckBounds(p125, p126, p127) -- Line: 997
    local AbsolutePosition = p125.AbsolutePosition;
    local AbsoluteSize = p125.AbsoluteSize;
    local v128;

    if AbsolutePosition.X < p126 and (p126 <= AbsolutePosition.X + AbsoluteSize.X and AbsolutePosition.Y < p127) then
        v128 = p127 <= AbsolutePosition.Y + AbsoluteSize.Y;
    else
        v128 = false;
    end;

    return v128;
end;

local function GetOffset(p129, p130) -- Line: 1003
    return (p129.AbsolutePosition + p129.AbsoluteSize / 2 - p130).magnitude;
end;

local u131 = nil;

local function UnequipAllTools() -- Line: 1012
    -- upvalues: u131 (ref), u19 (ref)
    u131 = nil;

    if u19 then
        u19:UnequipTools();
    end;
end;

local function AreToolWeldsEngaged(p132) -- Line: 1024
    for _, descendant in p132:GetDescendants() do
        if (descendant:IsA("Weld") or descendant:IsA("WeldConstraint")) and (descendant.Part0 == nil or descendant.Part1 == nil) then
            return false;
        end;
    end;

    return true;
end;

local function IsToolFullyReplicated(p133) -- Line: 1039
    -- upvalues: AreToolWeldsEngaged (copy)
    local v134 = p133:GetAttribute("ToolDescendants");

    if type(v134) == "number" and #p133:GetDescendants() < v134 then
        return false;
    end;

    return AreToolWeldsEngaged(p133);
end;

local function EquipNewTool(u135) -- Line: 1047
    -- upvalues: u131 (ref), u19 (ref), AreToolWeldsEngaged (copy), u18 (ref), RunService (copy), Backpack (ref)
    u131 = nil;

    if u19 then
        u19:UnequipTools();
    end;

    local v136 = u135:GetAttribute("ToolDescendants");
    local v137;

    if type(v136) == "number" and #u135:GetDescendants() < v136 then
        v137 = false;
    else
        v137 = AreToolWeldsEngaged(u135);
    end;

    if v137 then
        u135.Parent = u18;

        return;
    end;

    u131 = u135;
    task.spawn(function() -- Line: 1059
        -- upvalues: u131 (ref), u135 (copy), AreToolWeldsEngaged (ref), RunService (ref), Backpack (ref), u18 (ref), u19 (ref)
        local v138 = os.clock() + 1;

        while u131 == u135 do
            local v139 = u135;
            local v140 = v139:GetAttribute("ToolDescendants");
            local v141;

            if type(v140) == "number" and #v139:GetDescendants() < v140 then
                v141 = false;
            else
                v141 = AreToolWeldsEngaged(v139);
            end;

            if v141 or os.clock() >= v138 then
                break;
            end;

            RunService.Heartbeat:Wait();
        end;

        if u131 ~= u135 then
            return;
        end;

        u131 = nil;

        if u135.Parent ~= Backpack or not (u18 and u18.Parent) then
            return;
        end;

        u131 = nil;

        if u19 then
            u19:UnequipTools();
        end;

        u135.Parent = u18;
    end);
end;

local function IsEquipped(p142) -- Line: 1076
    -- upvalues: u18 (ref)
    if p142 then
        p142 = p142.Parent == u18;
    end;

    return p142;
end;

local function FormatWeight(p143) -- Line: 1080
    return WeightFormat.FormatGrams(p143);
end;

local function FormatCount(p144) -- Line: 1084
    if p144 >= 1000000000 then
        return `x{math.floor(p144 / 100000000) / 10}B`;
    end;

    if p144 >= 1000000 then
        return `x{math.floor(p144 / 100000) / 10}M`;
    end;

    if p144 >= 1000 then
        return `x{math.floor(p144 / 100) / 10}K`;
    end;

    return `x{p144}`;
end;

local function ensureItemNameSizeConstraint(p145) -- Line: 1099
    local v146 = p145:FindFirstChildOfClass("UITextSizeConstraint");

    if not v146 then
        v146 = Instance.new("UITextSizeConstraint");
        v146.Parent = p145;
    end;

    v146.MaxTextSize = 10;
    v146.MinTextSize = 7;
end;

u46 = function(p147, p148) -- Line: 1110
    -- upvalues: u24 (ref), VRService (copy), u12 (ref), FormatCount (copy), SprinklerData (copy), RakeData (copy), WateringcanData (copy), IMG (copy), IMG2 (copy), IMG4 (copy), IMG3 (copy), FruitProxyUtil (copy), AnimatedGradient (copy), u38 (ref), u13 (ref), UserInputService (copy), u29 (ref), u31 (ref), u8 (ref), ContextActionService (copy), u26 (ref), u25 (ref), u45 (ref), UpdateBuildIcon (ref), u56 (ref), u55 (ref), Networking (copy), u18 (ref), u40 (ref), NewGui (copy), UpdateScrollingFrameCanvasSize (ref), u47 (ref), u98 (ref), LocalPlayer (ref), Backpack (ref), u131 (ref), u19 (ref), AreToolWeldsEngaged (copy), RunService (copy), ToggleFavorite (copy), u46 (ref), u16 (ref), u33 (ref), u48 (ref), u27 (ref), Value (copy), u28 (copy), u20 (copy), u15 (ref), u90 (ref)
    local v149 = p148 or #u24 + 1;
    local u150 = {
        Tool = nil,
        Index = v149,
        Frame = nil
    };
    local u151 = nil;
    local u152 = nil;
    local u153 = nil;
    local u154 = nil;
    local u155 = nil;
    local u156 = nil;
    local u157 = nil;
    local u158 = nil;
    local u159 = "";
    local u160 = nil;
    local u161 = nil;
    local u162 = nil;
    local u163 = nil;

    local function UpdateSlotFading() -- Line: 1146
        -- upvalues: VRService (ref), u151 (ref)
        local _ = VRService.VREnabled;
        u151.SelectionImageObject = nil;
        u151.BackgroundTransparency = u151.Draggable and 0 or SLOT_FADE_LOCKED;
        u151.BackgroundColor3 = u151.Draggable and SLOT_DRAGGABLE_COLOR or BACKGROUND_COLOR;
    end;

    function u150.Readjust(p164, p165, p166) -- Line: 1173
        -- upvalues: u12 (ref), u151 (ref)
        u151.Position = UDim2.new(0, u12.Size.X.Offset / 2 - ICON_SIZE / 2 + (ICON_BUFFER + ICON_SIZE) * (p165 - (p166 / 2 + 0.5)), 0, ICON_BUFFER);
    end;

    function u150.Fill(p167, u168) -- Line: 1181
        -- upvalues: u154 (ref), u155 (ref), u153 (ref), u159 (ref), FormatCount (ref), SprinklerData (ref), RakeData (ref), WateringcanData (ref), IMG (ref), IMG2 (ref), IMG4 (ref), IMG3 (ref), u162 (ref), u160 (ref), u161 (ref), u151 (ref), FruitProxyUtil (ref), AnimatedGradient (ref), u156 (ref), u157 (ref), u38 (ref), u13 (ref), UserInputService (ref), u29 (ref), u31 (ref), u8 (ref), ContextActionService (ref), u26 (ref), u25 (ref), u45 (ref), UpdateBuildIcon (ref), u56 (ref), u55 (ref), u24 (ref), Networking (ref)
        if not u168 then
            return p167:Clear();
        end;

        p167.Tool = u168;

        local function assignToolData() -- Line: 1188
            -- upvalues: u168 (copy), u154 (ref), u155 (ref), u153 (ref), u159 (ref), FormatCount (ref), SprinklerData (ref), RakeData (ref), WateringcanData (ref), IMG (ref), IMG2 (ref), IMG4 (ref), IMG3 (ref), u162 (ref), u160 (ref), u161 (ref), u151 (ref), FruitProxyUtil (ref)
            local v169 = u168:GetAttribute("SeedTool");
            local v170 = u168:GetAttribute("Sprinkler");
            local v171 = u168:GetAttribute("Rake");
            local v172 = u168:GetAttribute("WateringCan");
            local v173 = u168:GetAttribute("Fruit");
            local v174 = u168:GetAttribute("Count");
            local v175 = u168:GetAttribute("Weight");

            local function styleItemName() -- Line: 1197
                -- upvalues: u154 (ref)
                u154.FontFace = Font.new(script:GetAttribute("LabelFont").Family, Enum.FontWeight.Bold);
                u154.TextSize = 10;
                u154.Size = UDim2.new(1, -4, 0, 24);
                u154.Position = UDim2.new(0, 2, 1, -26);
                u154.TextYAlignment = Enum.TextYAlignment.Bottom;
                u154.TextWrapped = true;
                u154.TextScaled = true;
                local v176 = u154;
                local v177 = v176:FindFirstChildOfClass("UITextSizeConstraint");

                if not v177 then
                    v177 = Instance.new("UITextSizeConstraint");
                    v177.Parent = v176;
                end;

                v177.MaxTextSize = 10;
                v177.MinTextSize = 7;
                u154.Visible = true;
            end;

            local function resetCount() -- Line: 1216
                -- upvalues: u155 (ref)
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;
            end;

            if v173 then
                local v178 = FruitImages:FindFirstChild(v173) or PlantImages:FindFirstChild(v173);
                u153.Image = v178 and v178.Value or (u168:IsA("Tool") and u168.TextureId or "");
                local v179 = u168:GetAttribute("Mutation");
                local v180;

                if type(v173) == "string" then
                    v180 = v173;
                else
                    v180 = tostring(v173);
                end;

                u154.Text = v180;

                if v179 and v179 ~= "" then
                    u159 = v173 .. " " .. v179;
                else
                    u159 = v173;
                end;

                u154.FontFace = Font.new(script:GetAttribute("LabelFont").Family, Enum.FontWeight.Bold);
                u154.TextScaled = false;
                u154.TextSize = 10;
                u154.Size = UDim2.new(1, -4, 0, 16);
                u154.Position = UDim2.new(0, 2, 1, -26);
                u154.TextYAlignment = Enum.TextYAlignment.Top;
                u154.TextWrapped = true;
                u154.Visible = true;
                local v181 = u154:FindFirstChildOfClass("UIGradient");

                if v181 then
                    v181:Destroy();
                end;

                if v179 then
                    local v182 = MutationData.GetMutation(v179);

                    if v182 and v182.Gradient then
                        v182.Gradient:Clone().Parent = u154;
                    end;
                end;

                u155.Text = WeightFormat.FormatGrams(v175);
                u155.Size = UDim2.new(1, -4, 0, 16);
                u155.Position = UDim2.new(0, 2, 1, -18);
                u155.TextXAlignment = Enum.TextXAlignment.Center;
                u155.Visible = v175 ~= nil;
            elseif v169 and v174 then
                local v183 = u168:GetAttribute("Count");
                local v184 = SeedImages:FindFirstChild(v169);
                u153.Image = v184 and v184.Value or u168.TextureId;
                local v185 = string.lower(v169);

                if string.sub(v185, -5) == " seed" or v185 == "seed" then
                    u154.Text = v169;
                else
                    u154.Text = v169 .. " Seed";
                end;

                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;
                u155.Text = FormatCount(v183);
                u155.Visible = true;
            elseif v170 and v174 then
                local v186 = nil;

                for _, v in SprinklerData do
                    if v.SprinklerName == v170 then
                        v186 = v;
                        break;
                    end;
                end;

                u153.Image = v186 and v186.Image or u168.TextureId;
                u154.Text = v170;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;
                u155.Text = FormatCount(v174);
                u155.Visible = true;
            elseif v171 and v174 then
                local v187 = nil;

                for _, v in RakeData do
                    if v.RakeName == v171 then
                        v187 = v;
                        break;
                    end;
                end;

                u153.Image = v187 and v187.Image or u168.TextureId;
                u154.Text = v171;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;
                u155.Text = FormatCount(v174);
                u155.Visible = true;
            elseif v172 and v174 then
                local v188 = nil;

                for _, v in WateringcanData do
                    if v.Name == v172 then
                        v188 = v;
                        break;
                    end;
                end;

                u153.Image = v188 and v188.Image or u168.TextureId;
                u154.Text = v172;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;
                u155.Text = FormatCount(v174);
                u155.Visible = true;
            elseif u168:GetAttribute("Shovel") then
                local v189 = u168:GetAttribute("Shovel");
                u153.Image = IMG;
                u154.Text = v189;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;
                u155.Visible = false;
            elseif u168:GetAttribute("Trowel") then
                local v190 = u168:GetAttribute("Trowel");
                u153.Image = IMG2;
                u154.Text = v190;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;
                u155.Visible = false;
                u155.Text = FormatCount(v174);
                u155.Visible = true;
            elseif u168:GetAttribute("Crowbar") then
                u168:GetAttribute("Crowbar");
                u153.Image = IMG4;
                u154.Text = "Door Crowbar";
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;
                u155.Visible = false;
                u155.Text = FormatCount(v174);
                u155.Visible = true;
            elseif u168:GetAttribute("Build") then
                local v191 = u168:GetAttribute("Build");
                u153.Image = IMG3;
                u154.Text = v191;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;
                u155.Visible = false;
            elseif u168:GetAttribute("EmptyPot") then
                local v192 = u168:GetAttribute("EmptyPot");
                local v193 = u168:GetAttribute("Count");
                u153.Image = u168.TextureId;
                u154.Text = v192;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;

                if v193 and v193 > 0 then
                    u155.Text = FormatCount(v193);
                    u155.Visible = true;
                else
                    u155.Visible = false;
                end;
            elseif u168:GetAttribute("Mushroom") then
                local v194 = u168:GetAttribute("Mushroom");
                local v195 = u168:GetAttribute("Count");
                local v196 = nil;

                for _, v in MushroomData.Data do
                    if v.Name == v194 then
                        v196 = v;
                        break;
                    end;
                end;

                u153.Image = v196 and v196.IMG or u168.TextureId;
                u154.Text = v194;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;

                if v195 and v195 > 0 then
                    u155.Text = FormatCount(v195);
                    u155.Visible = true;
                else
                    u155.Visible = false;
                end;

                if u162 and v196 then
                    u162.Text = v196.Description;
                    local v197 = u162.TextBounds.X + TOOLTIP_BUFFER;
                    u162.Size = UDim2.new(0, v197, 0, TOOLTIP_HEIGHT);
                    u162.Position = UDim2.new(0.5, -v197 / 2, 0, TOOLTIP_OFFSET);
                end;
            elseif u168:GetAttribute("Gnome") then
                local v198 = u168:GetAttribute("Gnome");
                local v199 = u168:GetAttribute("Count");
                local v200 = nil;

                for _, v in GnomeData.Data do
                    if v.Name == v198 then
                        v200 = v;
                        break;
                    end;
                end;

                u153.Image = v200 and v200.IMG or u168.TextureId;
                u154.Text = v198;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;

                if v199 and v199 > 0 then
                    u155.Text = FormatCount(v199);
                    u155.Visible = true;
                else
                    u155.Visible = false;
                end;

                if u162 and v200 then
                    u162.Text = v200.Description;
                    local v201 = u162.TextBounds.X + TOOLTIP_BUFFER;
                    u162.Size = UDim2.new(0, v201, 0, TOOLTIP_HEIGHT);
                    u162.Position = UDim2.new(0.5, -v201 / 2, 0, TOOLTIP_OFFSET);
                end;
            elseif u168:GetAttribute("Raccoon") then
                local v202 = u168:GetAttribute("Raccoon");
                local v203 = u168:GetAttribute("Count");
                local v204 = nil;

                for _, v in RaccoonData.Data do
                    if v.Name == v202 then
                        v204 = v;
                        break;
                    end;
                end;

                u153.Image = v204 and v204.IMG or u168.TextureId;
                u154.Text = v202;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;

                if v203 and v203 > 0 then
                    u155.Text = FormatCount(v203);
                    u155.Visible = true;
                else
                    u155.Visible = false;
                end;

                if u162 and v204 then
                    u162.Text = v204.Description;
                    local v205 = u162.TextBounds.X + TOOLTIP_BUFFER;
                    u162.Size = UDim2.new(0, v205, 0, TOOLTIP_HEIGHT);
                    u162.Position = UDim2.new(0.5, -v205 / 2, 0, TOOLTIP_OFFSET);
                end;
            elseif u168:GetAttribute("Wheelbarrow") then
                local v206 = u168:GetAttribute("Wheelbarrow");
                u168:GetAttribute("Count");
                u153.Image = u168.TextureId;
                u154.Text = v206;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;
                u155.Visible = false;
            elseif u168:GetAttribute("Ladder") then
                local v207 = u168:GetAttribute("Ladder");
                u168:GetAttribute("Count");
                u153.Image = u168.TextureId;
                u154.Text = v207;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;
                u155.Visible = false;
            elseif u168:GetAttribute("FreezeRay") then
                u168:GetAttribute("FreezeRay");
                u153.Image = u168.TextureId;
                u154.Text = "Freeze Ray";
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;
                u155.Visible = false;
            elseif u168:GetAttribute("Sign") then
                u168:GetAttribute("Sign");
                u153.Image = u168.TextureId;
                u154.Text = "Sign";
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;
                u155.Visible = false;
            elseif u168:GetAttribute("Megaphone") then
                u168:GetAttribute("Megaphone");
                u153.Image = u168.TextureId;
                u154.Text = "Megaphone";
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;
                u155.Visible = false;
            elseif u168:GetAttribute("BullHorn") then
                local v208 = u168:GetAttribute("BullHorn");
                u153.Image = u168.TextureId;
                u154.Text = v208 or "Bull Horn";
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;
                u155.Visible = false;
            elseif u168:GetAttribute("SeedPack") then
                local v209 = u168:GetAttribute("SeedPack");
                local v210 = u168:GetAttribute("Count");
                local v211 = SeedPackData.GetData(v209);
                u153.Image = v211 and v211.IMG or u168.TextureId;
                local v212 = string.lower(v209);

                if string.sub(v212, -5) == " pack" or v212 == "pack" then
                    u154.Text = v209;
                else
                    u154.Text = v209 .. " Seed Pack";
                end;

                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;

                if v210 and v210 > 0 then
                    u155.Text = FormatCount(v210);
                    u155.Visible = true;
                else
                    u155.Visible = false;
                end;
            elseif u168:GetAttribute("Cornucopia") then
                local v213 = u168:GetAttribute("Cornucopia");
                local v214 = u168:GetAttribute("Count");
                local v215 = CornucopiaData.GetData(v213);
                u153.Image = v215 and v215.IMG or u168.TextureId;
                u154.Text = v213;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;

                if v214 and v214 > 0 then
                    u155.Text = FormatCount(v214);
                    u155.Visible = true;
                else
                    u155.Visible = false;
                end;
            elseif u168:GetAttribute("Egg") then
                local v216 = u168:GetAttribute("Egg");
                local v217 = u168:GetAttribute("Count");
                local v218 = EggData.GetData(v216);
                u153.Image = v218 and v218.IMG or u168.TextureId;
                u154.Text = v216;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;

                if v217 and v217 > 0 then
                    u155.Text = FormatCount(v217);
                    u155.Visible = true;
                else
                    u155.Visible = false;
                end;
            elseif u168:GetAttribute("Crate") then
                local v219 = u168:GetAttribute("Crate");
                local v220 = u168:GetAttribute("Count");
                local v221 = CrateData.GetData(v219);
                u153.Image = v221 and v221.IMG or u168.TextureId;
                u154.Text = v219;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;

                if v220 and v220 > 0 then
                    u155.Text = FormatCount(v220);
                    u155.Visible = true;
                else
                    u155.Visible = false;
                end;
            elseif u168:GetAttribute("Chest") then
                local v222 = u168:GetAttribute("Chest");
                local v223 = u168:GetAttribute("Count");
                local v224 = ChestData.GetData(v222);
                u153.Image = v224 and v224.IMG or u168.TextureId;
                u154.Text = v222;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;

                if v223 and v223 > 0 then
                    u155.Text = FormatCount(v223);
                    u155.Visible = true;
                else
                    u155.Visible = false;
                end;
            elseif u168:GetAttribute("Teleporter") then
                local v225 = u168:GetAttribute("Teleporter");
                local v226 = u168:GetAttribute("Count");
                local v227 = nil;

                for _, v in TeleporterData do
                    if v.TeleporterName == v225 then
                        v227 = v;
                        break;
                    end;
                end;

                u153.Image = v227 and v227.Image or u168.TextureId;
                u154.Text = v225;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;

                if v226 and v226 > 0 then
                    u155.Text = FormatCount(v226);
                    u155.Visible = true;
                else
                    u155.Visible = false;
                end;
            elseif u168:GetAttribute("PlayerMagnet") then
                local v228 = u168:GetAttribute("PlayerMagnet");
                u153.Image = u168.TextureId;
                u154.Text = v228;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;
                u155.Visible = false;
            elseif u168:GetAttribute("FruitMagnet") then
                local v229 = u168:GetAttribute("FruitMagnet");
                u153.Image = u168.TextureId;
                u154.Text = v229;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;
                u155.Visible = false;
            elseif u168:GetAttribute("PetTeleporter") then
                local v230 = u168:GetAttribute("PetTeleporter");
                local v231 = u168:GetAttribute("Count");
                u153.Image = u168.TextureId;
                u154.Text = v230;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;

                if v231 and v231 > 0 then
                    u155.Text = FormatCount(v231);
                    u155.Visible = true;
                else
                    u155.Visible = false;
                end;
            elseif u168:GetAttribute("MagicMail") then
                local v232 = u168:GetAttribute("MagicMail");
                local v233 = u168:GetAttribute("Count");
                u153.Image = u168.TextureId;
                u154.Text = v232;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;

                if v233 and v233 > 0 then
                    u155.Text = FormatCount(v233);
                    u155.Visible = true;
                else
                    u155.Visible = false;
                end;
            elseif u168:GetAttribute("PowerHose") then
                local v234 = u168:GetAttribute("PowerHose");
                u168:GetAttribute("Count");

                for _, v in PowerHoseData do
                    if v.Name == v234 then
                        break;
                    end;
                end;

                u153.Image = u168.TextureId;
                u154.Text = "Power Hose";
                u159 = "Power Hose";
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;
                u155.Visible = false;
            elseif u168:GetAttribute("VineWrapper") then
                local v235 = u168:GetAttribute("VineWrapper");
                u153.Image = u168.TextureId;
                u154.Text = v235;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;
                u155.Visible = false;
            elseif u168:GetAttribute("Flashbang") then
                local v236 = u168:GetAttribute("Flashbang");
                local v237 = u168:GetAttribute("Count");
                u153.Image = u168.TextureId;
                u154.Text = v236;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;

                if v237 and v237 > 0 then
                    u155.Text = FormatCount(v237);
                    u155.Visible = true;
                else
                    u155.Visible = false;
                end;
            elseif u168:GetAttribute("MagicDice") then
                local v238 = u168:GetAttribute("MagicDice");
                local v239 = u168:GetAttribute("Count");
                u153.Image = u168.TextureId;
                u154.Text = v238;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;

                if v239 and v239 > 0 then
                    u155.Text = FormatCount(v239);
                    u155.Visible = true;
                else
                    u155.Visible = false;
                end;
            elseif u168:GetAttribute("WeatherStaff") then
                local v240 = u168:GetAttribute("WeatherStaff");
                local v241 = u168:GetAttribute("Count");
                u153.Image = u168.TextureId;
                u154.Text = v240;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;

                if v241 and v241 > 0 then
                    u155.Text = FormatCount(v241);
                    u155.Visible = true;
                else
                    u155.Visible = false;
                end;
            elseif u168:GetAttribute("WindStaff") then
                local v242 = u168:GetAttribute("WindStaff");
                u153.Image = u168.TextureId;
                u154.Text = v242;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;
                u155.Visible = false;
            elseif u168:GetAttribute("Harp") then
                local v243 = u168:GetAttribute("Harp");
                local v244 = u168:GetAttribute("Count");
                u153.Image = u168.TextureId;
                u154.Text = v243;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;

                if v244 and v244 > 0 then
                    u155.Text = FormatCount(v244);
                    u155.Visible = true;
                else
                    u155.Visible = false;
                end;
            elseif u168:GetAttribute("StrawberrySniper") then
                local v245 = u168:GetAttribute("StrawberrySniper");
                u153.Image = u168.TextureId;
                u154.Text = v245;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;
                u155.Visible = false;
            elseif u168:GetAttribute("GrapplingHook") then
                local v246 = u168:GetAttribute("GrapplingHook");
                u153.Image = u168.TextureId;
                u154.Text = v246;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;
                u155.Visible = false;
            elseif u168:GetAttribute("Bird") then
                local v247 = u168:GetAttribute("Bird");
                local v248 = u168:GetAttribute("Count");
                u153.Image = "rbxassetid://80206395781273";
                u154.Text = v247;
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;

                if v248 and v248 > 0 then
                    u155.Text = FormatCount(v248);
                    u155.Visible = true;
                else
                    u155.Visible = false;
                end;
            elseif u168:GetAttribute("Pet") then
                local v249 = u168:GetAttribute("Pet");

                if u168:IsA("Tool") and u168.TextureId ~= "" then
                    u153.Image = u168.TextureId;
                end;

                u154.Text = PetData.GetDisplayName(v249, u168:GetAttribute("PetSize"));
                u159 = u154.Text;
                styleItemName();
                u155.Size = UDim2.new(0, 30, 0, 20);
                u155.Position = UDim2.new(1, -32, 0, 2);
                u155.TextXAlignment = Enum.TextXAlignment.Right;
                u155.Visible = false;
            else
                local v250 = not u168:IsA("Tool") and "" or u168.TextureId;
                u153.Image = v250;

                if u168.Name == "Rainbow Carpet" then
                    u153.Image = v250;
                    u154.Text = "Carpet";
                    u159 = "Rainbow Carpet";
                    styleItemName();
                    u155.Size = UDim2.new(0, 30, 0, 20);
                    u155.Position = UDim2.new(1, -32, 0, 2);
                    u155.TextXAlignment = Enum.TextXAlignment.Right;
                    u155.Visible = false;
                else
                    u154.Visible = v250 == "";
                    u154.Text = u168.Name;
                    u159 = u154.Text;
                    u154.Size = UDim2.new(1, -2, 1, -2);
                    u154.Position = UDim2.new(0, 1, 0, 1);
                    u154.TextYAlignment = Enum.TextYAlignment.Center;
                    u154.TextScaled = false;
                    u154.TextSize = FONT_SIZE;
                    u155.Size = UDim2.new(0, 30, 0, 20);
                    u155.Position = UDim2.new(1, -32, 0, 2);
                    u155.TextXAlignment = Enum.TextXAlignment.Right;
                    u155.Visible = false;
                end;
            end;

            local v251 = u168:GetAttribute("CooldownEnd");

            if v251 and os.clock() < v251 then
                u160(v251);
            else
                u161();
            end;

            local FavIcon = u151:FindFirstChild("FavIcon");

            if FavIcon then
                local v252;

                if FruitProxyUtil.IsFruitInstance(u168) or u168:GetAttribute("PetId") ~= nil then
                    v252 = u168:GetAttribute("IsFavorite") == true;
                else
                    v252 = false;
                end;

                FavIcon.Visible = v252;
            end;

            if u162 and u168:IsA("Tool") then
                u162.Text = u168.ToolTip;
                local v253 = u162.TextBounds.X + TOOLTIP_BUFFER;
                u162.Size = UDim2.new(0, v253, 0, TOOLTIP_HEIGHT);
                u162.Position = UDim2.new(0.5, -v253 / 2, 0, TOOLTIP_OFFSET);
            end;
        end;

        assignToolData();

        if u168:GetAttribute("Pet") and u168:GetAttribute("PetType") == "Rainbow" then
            AnimatedGradient:AddRainbowColor(u153, "ImageColor3");
        else
            AnimatedGradient:Remove(u153);
        end;

        if u156 then
            u156:disconnect();
            u156 = nil;
        end;

        if u157 then
            u157:Disconnect();
            u157 = nil;
        end;

        if u168:IsA("Tool") then
            u156 = u168.Changed:connect(function(p254) -- Line: 2041
                -- upvalues: assignToolData (copy)
                if p254 == "TextureId" or (p254 == "Name" or p254 == "ToolTip") then
                    assignToolData();
                end;
            end);
        else
            u156 = u168:GetPropertyChangedSignal("Name"):Connect(function() -- Line: 2047
                -- upvalues: assignToolData (copy)
                assignToolData();
            end);
        end;

        u157 = u168.AttributeChanged:Connect(function(p255) -- Line: 2052
            -- upvalues: assignToolData (copy), u168 (copy), u160 (ref), u161 (ref)
            if p255 == "Count" or (p255 == "Seed" or (p255 == "Sprinkler" or (p255 == "Build" or (p255 == "Fruit" or (p255 == "Weight" or (p255 == "Mushroom" or (p255 == "Mutation" or (p255 == "Teleporter" or (p255 == "PlayerMagnet" or (p255 == "FruitMagnet" or (p255 == "PetTeleporter" or (p255 == "MagicMail" or (p255 == "SeedPack" or (p255 == "Cornucopia" or (p255 == "Egg" or (p255 == "Wheelbarrow" or (p255 == "EmptyPot" or (p255 == "Flashbang" or (p255 == "Bird" or (p255 == "Harp" or p255 == "IsFavorite")))))))))))))))))))) then
                assignToolData();

                return;
            end;

            if p255 == "CooldownEnd" then
                local v256 = u168:GetAttribute("CooldownEnd");

                if v256 and os.clock() < v256 then
                    u160(v256);

                    return;
                end;

                u161();
            end;
        end);
        local v257 = p167.Index <= u38;

        if (not v257 or u13.Visible) and not UserInputService.VREnabled then
            u151.Draggable = true;
        end;

        p167:UpdateEquipView();

        if v257 then
            u29 = u29 + 1;

            if u31 and (u29 >= 1 and not u8) then
                u8 = true;
                ContextActionService:BindAction("RBXHotbarEquip", changeToolFunc, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1);
            end;
        end;

        u26[u168] = p167;
        u25 = u45();
        UpdateBuildIcon();

        if u56 then
            return;
        end;

        if u55 then
            return;
        end;

        u55 = true;
        task.delay(1, function() -- Line: 426
            -- upvalues: u56 (ref), u55 (ref), u38 (ref), u24 (ref), Networking (ref)
            if u56 then
                u55 = false;

                return;
            end;

            local v258 = {};
            local v259 = 0;

            for i = 1, u38 do
                local v260 = u24[i];

                if v260 and v260.Tool then
                    local v261 = GetToolKey(v260.Tool);

                    if v261 then
                        v258[i] = v261;
                        v259 = v259 + 1;
                    end;
                end;
            end;

            if v259 == 0 then
                u55 = false;

                return;
            end;

            Networking.Backpack.SaveLayout:Fire(v258);
            u55 = false;
        end);
    end;

    function u150.Clear(p262) -- Line: 2095
        -- upvalues: u156 (ref), u157 (ref), AnimatedGradient (ref), u153 (ref), u154 (ref), u159 (ref), u155 (ref), u162 (ref), u151 (ref), u38 (ref), u29 (ref), u8 (ref), ContextActionService (ref), u26 (ref), u161 (ref), u25 (ref), u45 (ref), UpdateBuildIcon (ref), u56 (ref), u55 (ref), u24 (ref), Networking (ref)
        if not p262.Tool then
            return;
        end;

        if u156 then
            u156:disconnect();
            u156 = nil;
        end;

        if u157 then
            u157:Disconnect();
            u157 = nil;
        end;

        AnimatedGradient:Remove(u153);
        u153.Image = "";
        u154.Text = "";
        u159 = "";
        local v263 = u154:FindFirstChildOfClass("UIGradient");

        if v263 then
            v263:Destroy();
        end;

        u155.Text = "";
        u155.Visible = false;

        if u162 then
            u162.Text = "";
            u162.Visible = false;
        end;

        u151.Draggable = false;
        u151.FavIcon.Visible = false;
        p262:UpdateEquipView(true);

        if p262.Index <= u38 then
            u29 = u29 - 1;

            if u29 < 1 then
                u8 = false;
                ContextActionService:UnbindAction("RBXHotbarEquip");
            end;
        end;

        u26[p262.Tool] = nil;
        u161();
        p262.Tool = nil;
        u25 = u45();
        UpdateBuildIcon();

        if u56 then
            return;
        end;

        if u55 then
            return;
        end;

        u55 = true;
        task.delay(1, function() -- Line: 426
            -- upvalues: u56 (ref), u55 (ref), u38 (ref), u24 (ref), Networking (ref)
            if u56 then
                u55 = false;

                return;
            end;

            local v264 = {};
            local v265 = 0;

            for i = 1, u38 do
                local v266 = u24[i];

                if v266 and v266.Tool then
                    local v267 = GetToolKey(v266.Tool);

                    if v267 then
                        v264[i] = v267;
                        v265 = v265 + 1;
                    end;
                end;
            end;

            if v265 == 0 then
                u55 = false;

                return;
            end;

            Networking.Backpack.SaveLayout:Fire(v264);
            u55 = false;
        end);
    end;

    function u150.UpdateEquipView(p268, p269) -- Line: 2145
        -- upvalues: u18 (ref), u40 (ref), u150 (copy), u158 (ref), NewGui (ref), u151 (ref), UpdateSlotFading (copy), UpdateBuildIcon (ref)
        if p269 then
            if u158 then
                u158.Parent = nil;
            end;
        else
            local Tool = p268.Tool;

            if Tool then
                Tool = Tool.Parent == u18;
            end;

            if Tool then
                u40 = u150;

                if not u158 then
                    u158 = NewGui("Frame", "Equipped");
                    u158.ZIndex = u151.ZIndex;
                    local UICorner = Instance.new("UICorner");
                    UICorner.CornerRadius = script:GetAttribute("CornerRadius");
                    UICorner.Parent = u158;
                    local v270 = SLOT_EQUIP_THICKNESS;
                    local UIStroke = Instance.new("UIStroke");
                    UIStroke.Color = SLOT_EQUIP_COLOR;
                    UIStroke.Thickness = v270;
                    UIStroke.Parent = u158;
                end;

                u158.Parent = u151;
            elseif u158 then
                u158.Parent = nil;
            end;
        end;

        UpdateSlotFading();
        UpdateBuildIcon();
    end;

    function u150.IsEquipped(p271) -- Line: 2173
        -- upvalues: u18 (ref)
        local Tool = p271.Tool;

        if Tool then
            Tool = Tool.Parent == u18;
        end;

        return Tool;
    end;

    function u150.Delete(p272) -- Line: 2177
        -- upvalues: u151 (ref), u24 (ref), UpdateScrollingFrameCanvasSize (ref)
        u151:Destroy();
        table.remove(u24, p272.Index);

        for i = p272.Index, #u24 do
            u24[i]:SlideBack();
        end;

        UpdateScrollingFrameCanvasSize();
    end;

    function u150.Swap(p273, p274) -- Line: 2189
        -- upvalues: u38 (ref), FruitProxyUtil (ref), u56 (ref), u55 (ref), u24 (ref), Networking (ref), u47 (ref)
        local Tool = p273.Tool;
        local Tool2 = p274.Tool;
        local Index = p273.Index;
        local Index2 = p274.Index;
        local v275 = Index <= u38;
        local v276 = Index2 <= u38;
        p273:Clear();

        if Tool2 then
            p274:Clear();
            p273:Fill(Tool2);
        end;

        if Tool then
            p274:Fill(Tool);
        else
            p274:Clear();
        end;

        local v277 = Tool and (FruitProxyUtil.IsFruitProxy(Tool) and v276) and Tool:GetAttribute("Id");

        if v277 then
            FruitProxyUtil.Pending.Slots[v277] = Index2;
            FruitProxyUtil.RequestPromote(v277);
        end;

        local v278 = Tool2 and (FruitProxyUtil.IsFruitProxy(Tool2) and v275) and Tool2:GetAttribute("Id");

        if v278 then
            FruitProxyUtil.Pending.Slots[v278] = Index;
            FruitProxyUtil.RequestPromote(v278);
        end;

        local v279 = Tool and (FruitProxyUtil.IsFruitTool(Tool) and (not v276 and v275)) and Tool:GetAttribute("Id");

        if v279 then
            FruitProxyUtil.Pending.Slots[v279] = Index2;
            FruitProxyUtil.RequestDemote(v279);
        end;

        local v280 = Tool2 and FruitProxyUtil.IsFruitTool(Tool2) and (not v275 and (v276 and Tool2:GetAttribute("Id")));

        if v280 then
            FruitProxyUtil.Pending.Slots[v280] = Index;
            FruitProxyUtil.RequestDemote(v280);
        end;

        if not (u56 or u55) then
            u55 = true;
            task.delay(1, function() -- Line: 426
                -- upvalues: u56 (ref), u55 (ref), u38 (ref), u24 (ref), Networking (ref)
                if u56 then
                    u55 = false;

                    return;
                end;

                local v281 = {};
                local v282 = 0;

                for i = 1, u38 do
                    local v283 = u24[i];

                    if v283 and v283.Tool then
                        local v284 = GetToolKey(v283.Tool);

                        if v284 then
                            v281[i] = v284;
                            v282 = v282 + 1;
                        end;
                    end;
                end;

                if v282 == 0 then
                    u55 = false;

                    return;
                end;

                Networking.Backpack.SaveLayout:Fire(v281);
                u55 = false;
            end);
        end;

        u47();
    end;

    function u150.SlideBack(p285) -- Line: 2240
        -- upvalues: u98 (ref), u151 (ref)
        p285.Index = p285.Index - 1;

        if not u98 then
            u151.Name = p285.Index;
            u151.LayoutOrder = p285.Index;
        end;
    end;

    function u150.TurnNumber(p286, p287) -- Line: 2248
        -- upvalues: u163 (ref)
        if u163 then
            u163.Visible = p287;
        end;
    end;

    function u150.SetClickability(p288, p289) -- Line: 2254
        -- upvalues: UserInputService (ref), u151 (ref), UpdateSlotFading (copy)
        if p288.Tool then
            if UserInputService.VREnabled then
                u151.Draggable = false;
            else
                u151.Draggable = not p289;
            end;

            UpdateSlotFading();
        end;
    end;

    function u150.CheckTerms(p290, p291) -- Line: 2265
        -- upvalues: u159 (ref), u162 (ref)
        local u292 = 0;

        local function checkEm(p293, p294) -- Line: 2267
            -- upvalues: u292 (ref)
            local _, v295 = p293:lower():gsub(p294, "");
            u292 = u292 + v295;
        end;

        local Tool = p290.Tool;

        if Tool then
            local v296 = Tool:GetAttribute("Weight");
            local v297;

            if type(v296) == "number" then
                v297 = WeightFormat.FormatGrams(v296):gsub("kg$", "");
            else
                v297 = nil;
            end;

            for i in pairs(p291) do
                if i ~= "kg" then
                    local v298 = i:match("^(%d+%.?%d*)k?g?$") or i:match("^(%.%d+)k?g?$");

                    if v298 then
                        if v297 and v297:sub(1, #v298) == v298 then
                            u292 = u292 + 1;
                        end;
                    else
                        local v299 = i:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1");
                        local _, v300 = u159:lower():gsub(v299, "");
                        u292 = u292 + v300;

                        if Tool:IsA("Tool") then
                            local _, v301 = (u162 and u162.Text or ""):lower():gsub(v299, "");
                            u292 = u292 + v301;
                        end;
                    end;
                end;
            end;
        end;

        return u292;
    end;

    function u150.Select(p302) -- Line: 2313
        -- upvalues: LocalPlayer (ref), u150 (copy), FruitProxyUtil (ref), u18 (ref), Backpack (ref), u131 (ref), u19 (ref), AreToolWeldsEngaged (ref), RunService (ref)
        if LocalPlayer:GetAttribute("LoadingScreenActive") then
            return;
        end;

        if LocalPlayer:GetAttribute("IsStealingFruit") or LocalPlayer:GetAttribute("CarryingStolenFruit") then
            return;
        end;

        local Tool = u150.Tool;

        if Tool then
            if FruitProxyUtil.IsFruitProxy(Tool) then
                local v303 = Tool:GetAttribute("Id");

                if v303 then
                    if u18 then
                        for _, child in u18:GetChildren() do
                            if child:IsA("Tool") then
                                child.Parent = Backpack;
                            end;
                        end;
                    end;

                    FruitProxyUtil.Pending.Slots[v303] = u150.Index;
                    FruitProxyUtil.Pending.Equip = v303;
                    FruitProxyUtil.RequestPromote(v303);
                end;

                return;
            end;

            local v304;

            if Tool then
                v304 = Tool.Parent == u18;
            else
                v304 = Tool;
            end;

            if v304 then
                u131 = nil;

                if u19 then
                    u19:UnequipTools();
                end;
            elseif Tool.Parent == Backpack then
                u131 = nil;

                if u19 then
                    u19:UnequipTools();
                end;

                local v305 = Tool:GetAttribute("ToolDescendants");
                local v306;

                if type(v305) == "number" and #Tool:GetDescendants() < v305 then
                    v306 = false;
                else
                    v306 = AreToolWeldsEngaged(Tool);
                end;

                if v306 then
                    Tool.Parent = u18;

                    return;
                end;

                u131 = Tool;
                task.spawn(function() -- Line: 1059
                    -- upvalues: u131 (ref), Tool (copy), AreToolWeldsEngaged (ref), RunService (ref), Backpack (ref), u18 (ref), u19 (ref)
                    local v307 = os.clock() + 1;

                    while u131 == Tool do
                        local v308 = Tool;
                        local v309 = v308:GetAttribute("ToolDescendants");
                        local v310;

                        if type(v309) == "number" and #v308:GetDescendants() < v309 then
                            v310 = false;
                        else
                            v310 = AreToolWeldsEngaged(v308);
                        end;

                        if v310 or os.clock() >= v307 then
                            break;
                        end;

                        RunService.Heartbeat:Wait();
                    end;

                    if u131 ~= Tool then
                        return;
                    end;

                    u131 = nil;

                    if Tool.Parent ~= Backpack or not (u18 and u18.Parent) then
                        return;
                    end;

                    u131 = nil;

                    if u19 then
                        u19:UnequipTools();
                    end;

                    Tool.Parent = u18;
                end);
            end;
        end;
    end;

    u151 = NewGui("TextButton", v149);
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Parent = u151;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = script:GetAttribute("CornerRadius");
    UICorner.Parent = u151;
    UIStroke.Thickness = 0;
    u151.BackgroundColor3 = BACKGROUND_COLOR;
    UIStroke.Color = SLOT_BORDER_COLOR;
    u151.Text = "";
    u151.AutoButtonColor = false;
    u151.BorderSizePixel = 0;
    u151.Size = UDim2.new(0, ICON_SIZE, 0, ICON_SIZE);
    u151.Active = true;
    u151.Draggable = false;
    u151.BackgroundTransparency = SLOT_FADE_LOCKED;
    u151.MouseButton1Click:connect(function() -- Line: 2361
        -- upvalues: u150 (copy)
        changeSlot(u150);
    end);
    u151.MouseButton2Click:Connect(function() -- Line: 2362
        -- upvalues: ToggleFavorite (ref), u150 (copy)
        ToggleFavorite(u150);
    end);
    local u311 = nil;
    local u312 = nil;
    local u313 = nil;

    local function cancelTouch() -- Line: 2372
        -- upvalues: u313 (ref), u311 (ref), u312 (ref)
        if u313 then
            task.cancel(u313);
            u313 = nil;
        end;

        u311 = nil;
        u312 = nil;
    end;

    u151.InputBegan:Connect(function(p314) -- Line: 2381
        -- upvalues: u313 (ref), u311 (ref), u312 (ref), ToggleFavorite (ref), u150 (copy)
        if p314.UserInputType ~= Enum.UserInputType.Touch then
            return;
        end;

        if u313 then
            task.cancel(u313);
            u313 = nil;
        end;

        u311 = nil;
        u312 = nil;
        u311 = os.clock();
        u312 = p314.Position;
        u313 = task.delay(1, function() -- Line: 2386
            -- upvalues: u311 (ref), ToggleFavorite (ref), u150 (ref), u313 (ref), u312 (ref)
            if u311 and os.clock() - u311 >= 1 then
                ToggleFavorite(u150);
            end;

            u313 = nil;
            u311 = nil;
            u312 = nil;
        end);
    end);
    u151.InputChanged:Connect(function(p315) -- Line: 2396
        -- upvalues: u312 (ref), u313 (ref), u311 (ref)
        if p315.UserInputType ~= Enum.UserInputType.Touch then
            return;
        end;

        if u312 and (p315.Position - u312).Magnitude > 8 then
            if u313 then
                task.cancel(u313);
                u313 = nil;
            end;

            u311 = nil;
            u312 = nil;
        end;
    end);
    u151.InputEnded:Connect(function(p316) -- Line: 2403
        -- upvalues: u313 (ref), u311 (ref), u312 (ref)
        if p316.UserInputType ~= Enum.UserInputType.Touch then
            return;
        end;

        if u313 then
            task.cancel(u313);
            u313 = nil;
        end;

        u311 = nil;
        u312 = nil;
    end);
    u151.DragBegin:Connect(cancelTouch);
    u150.Frame = u151;
    local v317 = NewGui("Frame", "SelectionObjectClipper");
    v317.Visible = false;
    v317.Parent = u151;
    local v318 = NewGui("ImageLabel", "Selector");
    v318.Size = UDim2.new(1, 0, 1, 0);
    v318.Image = "rbxasset://textures/ui/Keyboard/key_selection_9slice.png";
    v318.ScaleType = Enum.ScaleType.Slice;
    v318.SliceCenter = Rect.new(12, 12, 52, 52);
    v318.Parent = v317;
    u153 = NewGui("ImageLabel", "Icon");
    u153.Size = UDim2.new(0.8, 0, 0.8, 0);
    u153.Position = UDim2.new(0.1, 0, 0.1, 0);
    u153.Parent = u151;
    u155 = NewGui("TextLabel", "ToolCount");
    u155.Size = UDim2.new(0, 30, 0, 20);
    u155.Position = UDim2.new(1, -32, 0, 2);
    u155.TextXAlignment = Enum.TextXAlignment.Right;
    u155.FontFace = script:GetAttribute("SlotFont");
    u155.TextSize = 14;
    u155.TextScaled = true;
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint");
    UITextSizeConstraint.MaxTextSize = 14;
    UITextSizeConstraint.Parent = u155;
    u155.Visible = false;
    u155.Parent = u151;
    local u319 = NewGui("Frame", "CooldownOverlay");
    u319.BackgroundColor3 = Color3.new(0, 0, 0);
    u319.BackgroundTransparency = 0.3;
    u319.Size = UDim2.new(1, 0, 1, 0);
    u319.ZIndex = 5;
    u319.Visible = false;
    u319.Parent = u151;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.CornerRadius = script:GetAttribute("CornerRadius");
    UICorner2.Parent = u319;
    local u320 = NewGui("TextLabel", "CooldownText");
    u320.Size = UDim2.new(1, 0, 1, 0);
    u320.TextSize = 22;
    u320.FontFace = script:GetAttribute("ToolTipFont");
    u320.TextColor3 = Color3.new(1, 1, 1);
    u320.ZIndex = 6;
    u320.Parent = u319;
    local u321 = nil;

    u161 = function() -- Line: 2471
        -- upvalues: u319 (copy), u320 (copy), u321 (ref)
        u319.Visible = false;
        u320.Text = "";

        if u321 then
            u321:Disconnect();
            u321 = nil;
        end;
    end;

    u160 = function(u322) -- Line: 2480
        -- upvalues: u161 (ref), u319 (copy), u321 (ref), RunService (ref), u320 (copy)
        u161();
        u319.Visible = true;
        u321 = RunService.Heartbeat:Connect(function() -- Line: 2483
            -- upvalues: u322 (copy), u161 (ref), u320 (ref)
            local v323 = u322 - os.clock();

            if v323 <= 0 then
                u161();

                return;
            end;

            u320.Text = math.ceil(v323) .. "s";
        end);
    end;

    local v324 = NewGui("ImageLabel", "FavIcon");
    v324.Size = UDim2.new(0.3, 0, 0.3, 0);
    v324.AnchorPoint = Vector2.new(1, 0);
    v324.Position = UDim2.new(1, -2, 0, 2);
    v324.Parent = u151;
    v324.Visible = false;
    v324.Image = "rbxassetid://102498784369651";
    v324.BackgroundTransparency = 1;
    v324.ZIndex = 10;
    u154 = NewGui("TextLabel", "ToolName");
    u154.Size = UDim2.new(1, -2, 1, -2);
    u154.Position = UDim2.new(0, 1, 0, 1);
    u154.Parent = u151;
    u150.Frame.LayoutOrder = u150.Index;

    if v149 <= u38 then
        u162 = NewGui("TextLabel", "ToolTip");
        u162.ZIndex = 2;
        u162.FontFace = script:GetAttribute("ToolTipFont");
        u162.TextWrapped = false;
        u162.TextYAlignment = Enum.TextYAlignment.Center;
        u162.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4);
        u162.BackgroundTransparency = 0;
        u162.Visible = false;
        u162.Parent = u151;
        local UICorner3 = Instance.new("UICorner");
        UICorner3.CornerRadius = script:GetAttribute("CornerRadius");
        UICorner3.Parent = u162;
        u151.MouseEnter:connect(function() -- Line: 2523
            -- upvalues: u162 (ref)
            if u162.Text ~= "" then
                u162.Visible = true;
            end;
        end);
        u151.MouseLeave:connect(function() -- Line: 2528
            -- upvalues: u162 (ref)
            u162.Visible = false;
        end);

        function u150.MoveToInventory(p325) -- Line: 2530
            -- upvalues: u150 (copy), u38 (ref), FruitProxyUtil (ref), u46 (ref), u16 (ref), u18 (ref), u131 (ref), u19 (ref), u33 (ref), u13 (ref), u48 (ref), u47 (ref), u56 (ref), u55 (ref), u24 (ref), Networking (ref)
            if u150.Index <= u38 then
                local Tool = u150.Tool;
                local v326;

                if Tool then
                    v326 = FruitProxyUtil.IsFruitTool(Tool);
                else
                    v326 = Tool;
                end;

                p325:Clear();
                local v327 = u46(u16);
                v327:Fill(Tool);

                if v326 then
                    local v328 = Tool:GetAttribute("Id");

                    if v328 then
                        FruitProxyUtil.Pending.Slots[v328] = v327.Index;
                        FruitProxyUtil.RequestDemote(v328);
                    end;
                else
                    if Tool then
                        Tool = Tool.Parent == u18;
                    end;

                    if Tool then
                        u131 = nil;

                        if u19 then
                            u19:UnequipTools();
                        end;
                    end;
                end;

                if u33 then
                    v327.Frame.Visible = false;
                    v327.Frame.Parent = u13;
                end;

                u48();
                u47();

                if u56 then
                    return;
                end;

                if u55 then
                    return;
                end;

                u55 = true;
                task.delay(1, function() -- Line: 426
                    -- upvalues: u56 (ref), u55 (ref), u38 (ref), u24 (ref), Networking (ref)
                    if u56 then
                        u55 = false;

                        return;
                    end;

                    local v329 = {};
                    local v330 = 0;

                    for i = 1, u38 do
                        local v331 = u24[i];

                        if v331 and v331.Tool then
                            local v332 = GetToolKey(v331.Tool);

                            if v332 then
                                v329[i] = v332;
                                v330 = v330 + 1;
                            end;
                        end;
                    end;

                    if v330 == 0 then
                        u55 = false;

                        return;
                    end;

                    Networking.Backpack.SaveLayout:Fire(v329);
                    u55 = false;
                end);
            end;
        end;

        if v149 < 10 or v149 == u38 then
            local v333 = v149 < 10 and (v149 or 0) or 0;
            u163 = NewGui("TextLabel", "Number");
            u163.Text = v333;
            u163.Size = UDim2.new(0, 15, 0, 15);
            u163.Visible = false;
            u163.Parent = u151;
            u27[Value + v333] = u150.Select;
        end;
    end;

    local Position = u151.Position;
    local u334 = 0;
    local u335 = nil;
    u151.DragBegin:connect(function(p336) -- Line: 2575
        -- upvalues: u28 (ref), u151 (ref), Position (ref), UIStroke (copy), u20 (ref), u153 (ref), u154 (ref), u155 (ref), u163 (ref), u158 (ref), u335 (ref), u16 (ref), u13 (ref), u152 (ref), NewGui (ref)
        u28[u151] = true;
        Position = p336;
        UIStroke.Thickness = 2;
        u20:lock();
        u151.ZIndex = 2;
        u153.ZIndex = 2;
        u154.ZIndex = 2;
        u155.ZIndex = 2;
        u151.Parent.ZIndex = 2;

        if u163 then
            u163.ZIndex = 2;
        end;

        if u158 then
            u158.ZIndex = 2;

            for _, child in pairs(u158:GetChildren()) do
                if not (child:IsA("UICorner") or child:IsA("UIStroke")) then
                    child.ZIndex = 2;
                end;
            end;
        end;

        u335 = u151.Parent;

        if u335 == u16 then
            local _ = u151.AbsolutePosition;
            local v337 = UDim2.new(0, u151.AbsolutePosition.X - u13.AbsolutePosition.X, 0, u151.AbsolutePosition.Y - u13.AbsolutePosition.Y);
            u151.Parent = u13;
            u151.Position = v337;
            u152 = NewGui("Frame", "FakeSlot");
            u152.LayoutOrder = u151.LayoutOrder;
            u152.Size = u151.Size;
            u152.BackgroundTransparency = 1;
            u152.Parent = u16;
        end;
    end);
    u151.DragStopped:connect(function(p338, p339) -- Line: 2616
        -- upvalues: u152 (ref), u151 (ref), Position (ref), u335 (ref), UIStroke (copy), u20 (ref), u153 (ref), u154 (ref), u155 (ref), u163 (ref), u158 (ref), u28 (ref), u150 (copy), u13 (ref), u38 (ref), u334 (ref), u25 (ref), u12 (ref), u24 (ref), u18 (ref), u131 (ref), u19 (ref), u48 (ref), u56 (ref), u55 (ref), Networking (ref)
        if u152 then
            u152:Destroy();
        end;

        local v340 = tick();
        u151.Position = Position;
        u151.Parent = u335;
        UIStroke.Thickness = 0;
        u20:unlock();
        u151.ZIndex = 1;
        u153.ZIndex = 1;
        u154.ZIndex = 1;
        u155.ZIndex = 1;
        u335.ZIndex = 1;

        if u163 then
            u163.ZIndex = 1;
        end;

        if u158 then
            u158.ZIndex = 1;

            for _, child in pairs(u158:GetChildren()) do
                if not (child:IsA("UICorner") or child:IsA("UIStroke")) then
                    child.ZIndex = 1;
                end;
            end;
        end;

        u28[u151] = nil;

        if not u150.Tool then
            return;
        end;

        local v341 = u13;
        local AbsolutePosition = v341.AbsolutePosition;
        local AbsoluteSize = v341.AbsoluteSize;
        local v342;

        if AbsolutePosition.X < p338 and (p338 <= AbsolutePosition.X + AbsoluteSize.X and AbsolutePosition.Y < p339) then
            v342 = p339 <= AbsolutePosition.Y + AbsoluteSize.Y;
        else
            v342 = false;
        end;

        if v342 then
            if u150.Index <= u38 then
                u150:MoveToInventory();
            end;

            if u38 < u150.Index and v340 - u334 < 0.5 then
                if u25 then
                    local Tool = u150.Tool;
                    u150:Clear();
                    u25:Fill(Tool);
                    u150:Delete();
                    v340 = 0;
                else
                    v340 = 0;
                end;
            end;
        else
            local v343 = u12;
            local AbsolutePosition2 = v343.AbsolutePosition;
            local AbsoluteSize2 = v343.AbsoluteSize;
            local v344;

            if AbsolutePosition2.X < p338 and (p338 <= AbsolutePosition2.X + AbsoluteSize2.X and AbsolutePosition2.Y < p339) then
                v344 = p339 <= AbsolutePosition2.Y + AbsoluteSize2.Y;
            else
                v344 = false;
            end;

            if v344 then
                local v345 = { (1 / 0), nil };

                for i = 1, u38 do
                    local v346 = u24[i];
                    local Frame = v346.Frame;
                    local v347 = Vector2.new(p338, p339);
                    local magnitude = (Frame.AbsolutePosition + Frame.AbsoluteSize / 2 - v347).magnitude;

                    if magnitude < v345[1] then
                        v345 = { magnitude, v346 };
                    end;
                end;

                local v348 = v345[2];

                if v348 ~= u150 then
                    u150:Swap(v348);

                    if u38 < u150.Index then
                        local Tool = u150.Tool;

                        if Tool then
                            if Tool then
                                Tool = Tool.Parent == u18;
                            end;

                            if Tool then
                                u131 = nil;

                                if u19 then
                                    u19:UnequipTools();
                                end;
                            end;

                            u48();
                        else
                            u150:Delete();
                        end;
                    end;
                end;
            elseif u150.Index <= u38 then
                u150:MoveToInventory();
            end;
        end;

        if not (u56 or u55) then
            u55 = true;
            task.delay(1, function() -- Line: 426
                -- upvalues: u56 (ref), u55 (ref), u38 (ref), u24 (ref), Networking (ref)
                if u56 then
                    u55 = false;

                    return;
                end;

                local v349 = {};
                local v350 = 0;

                for i = 1, u38 do
                    local v351 = u24[i];

                    if v351 and v351.Tool then
                        local v352 = GetToolKey(v351.Tool);

                        if v352 then
                            v349[i] = v352;
                            v350 = v350 + 1;
                        end;
                    end;
                end;

                if v350 == 0 then
                    u55 = false;

                    return;
                end;

                Networking.Backpack.SaveLayout:Fire(v349);
                u55 = false;
            end);
        end;

        u334 = v340;
    end);
    u151.Parent = p147;
    u24[v149] = u150;

    if u38 < v149 then
        local v353 = math.floor(u15.AbsoluteSize.X / (ICON_SIZE + ICON_BUFFER));
        local v354 = math.ceil(u90 / (v353 < 1 and 1 or v353)) * (ICON_SIZE + ICON_BUFFER) + ICON_BUFFER;
        u15.CanvasSize = UDim2.new(0, 0, 0, v354);

        if u13.Visible and not u33 then
            u15.CanvasPosition = Vector2.new(0, (math.max(0, u15.CanvasSize.Y.Offset - u15.AbsoluteSize.Y)));
        end;
    end;

    return u150;
end;

function OnChildAdded(u355)
    -- upvalues: FruitProxyUtil (copy), u18 (ref), u19 (ref), u57 (ref), u117 (ref), u37 (ref), u30 (ref), u26 (ref), LocalPlayer (ref), u25 (ref), u46 (ref), u16 (ref), u24 (ref), Backpack (ref), u47 (ref), UpdateBuildIcon (ref), RunService (copy), u38 (ref), u13 (ref), AddInventorySlotIncremental (copy), u56 (ref)
    local v356 = u355:IsA("Tool");
    local v357 = FruitProxyUtil.IsFruitProxy(u355);

    if not (v356 or v357) then
        if u355:IsA("Humanoid") and u355.Parent == u18 then
            u19 = u355;
        end;

        return;
    end;

    u57 = tick();
    u117();

    if u355.Parent == u18 then
        u37 = tick();
    end;

    if not u30 and (u355.Parent == u18 and not u26[u355]) then
        local StarterGear = LocalPlayer:FindFirstChild("StarterGear");

        if StarterGear and StarterGear:FindFirstChild(u355.Name) then
            u30 = true;

            for i = (u25 or u46(u16)).Index, 1, -1 do
                local v358 = u24[i];
                local v359 = i - 1;

                if v359 > 0 then
                    u24[v359]:Swap(v358);
                else
                    v358:Fill(u355);
                end;
            end;

            for _, child in pairs(u18:GetChildren()) do
                if child:IsA("Tool") and child ~= u355 then
                    child.Parent = Backpack;
                end;
            end;

            u47();

            return;
        end;
    end;

    local v360 = u355:GetAttribute("Id");
    local v361;

    if v360 then
        v361 = FruitProxyUtil.Pending.Slots[v360];
    else
        v361 = v360;
    end;

    if not v361 then
        local v362 = u26[u355];

        if v362 then
            v362:UpdateEquipView();
        else
            local v363 = u25 or u46(u16);
            v363:Fill(u355);

            if v363.Index <= u38 and not u13.Visible then
                u47();
            end;

            if u38 < v363.Index then
                AddInventorySlotIncremental(v363);
            end;

            local v364 = not u56 and (v363.Index <= u38 and (v357 and u355:GetAttribute("Id")));

            if v364 then
                FruitProxyUtil.Pending.Slots[v364] = v363.Index;
                FruitProxyUtil.RequestPromote(v364);
            end;
        end;

        UpdateBuildIcon();

        return;
    end;

    if v356 and u26[u355] then
        u26[u355]:UpdateEquipView();
        UpdateBuildIcon();

        return;
    end;

    FruitProxyUtil.Pending.Slots[v360] = nil;
    local v365 = u24[v361];

    if v365 then
        if v365.Tool then
            v365:Clear();
        end;

        v365:Fill(u355);
    end;

    if FruitProxyUtil.Pending.Equip == v360 and v356 then
        FruitProxyUtil.Pending.Equip = nil;
        task.spawn(function() -- Line: 2793
            -- upvalues: RunService (ref), u355 (copy), Backpack (ref), u18 (ref)
            RunService.Heartbeat:Wait();

            if u355 and (u355.Parent == Backpack and u18) then
                for _, child in u18:GetChildren() do
                    if child:IsA("Tool") then
                        child.Parent = Backpack;
                    end;
                end;

                u355.Parent = u18;
            end;
        end);
    end;

    UpdateBuildIcon();
end;

function OnChildRemoved(p366)
    -- upvalues: FruitProxyUtil (copy), u117 (ref), u37 (ref), u18 (ref), Backpack (ref), u26 (ref), u38 (ref), u29 (ref), u115 (ref), u13 (ref), u47 (ref), UpdateBuildIcon (ref)
    if not (p366:IsA("Tool") or FruitProxyUtil.IsFruitProxy(p366)) then
        return;
    end;

    u117();
    u37 = tick();
    local Parent = p366.Parent;

    if Parent == u18 or Parent == Backpack then
        return;
    end;

    local v367 = p366:GetAttribute("Id");

    if v367 and FruitProxyUtil.Pending.Slots[v367] then
        local v368 = u26[p366];

        if v368 then
            if v368.Index <= u38 then
                u29 = u29 - 1;
            end;

            u26[p366] = nil;
            v368.Tool = nil;
        end;

        return;
    end;

    local v369 = u26[p366];

    if v369 then
        if u38 < v369.Index then
            u26[p366] = nil;
            v369.Tool = nil;
            u115(v369);
        else
            v369:Clear();

            if not u13.Visible then
                u47();
            end;
        end;
    end;

    UpdateBuildIcon();
end;

function OnCharacterAdded(p370)
    -- upvalues: u56 (ref), FruitProxyUtil (copy), u24 (ref), u38 (ref), u90 (ref), u35 (ref), u18 (ref), Backpack (ref), LocalPlayer (ref), u47 (ref), UpdateBuildIcon (ref), u54 (ref), Networking (copy), u53 (ref), ApplySavedLayout (copy)
    u56 = true;
    table.clear(FruitProxyUtil.Pending.Slots);
    FruitProxyUtil.Pending.Equip = nil;

    for i = #u24, 1, -1 do
        local v371 = u24[i];

        if v371.Tool then
            v371:Clear();
        end;

        if u38 < i then
            v371:Delete();
        end;
    end;

    u90 = 0;

    for _, v in pairs(u35) do
        v:Disconnect();
    end;

    u35 = {};
    u18 = p370;
    table.insert(u35, p370.ChildRemoved:Connect(OnChildRemoved));
    table.insert(u35, p370.ChildAdded:Connect(OnChildAdded));

    for _, child in pairs(p370:GetChildren()) do
        OnChildAdded(child);
    end;

    Backpack = LocalPlayer:WaitForChild("Backpack");
    table.insert(u35, Backpack.ChildRemoved:Connect(OnChildRemoved));
    table.insert(u35, Backpack.ChildAdded:Connect(OnChildAdded));

    for _, child in pairs(Backpack:GetChildren()) do
        OnChildAdded(child);
    end;

    u47();
    UpdateBuildIcon();
    task.defer(function() -- Line: 2921
        -- upvalues: u54 (ref), Networking (ref), u53 (ref), ApplySavedLayout (ref), u56 (ref)
        if not u54 then
            local success, result = pcall(function() -- Line: 2923
                -- upvalues: Networking (ref)
                return Networking.Backpack.GetLayout:Fire();
            end);

            if success and (result and (typeof(result) == "table" and next(result) ~= nil)) then
                u53 = result;
            end;
        end;

        WaitForToolsToSettle();

        if u53 then
            u54 = false;
            ApplySavedLayout();
        else
            u54 = true;
        end;

        u56 = false;
    end);
end;

function OnInputBegan(p372, p373)
    -- upvalues: u32 (ref), u31 (ref), Value2 (copy), u27 (ref), u13 (ref), u20 (copy)
    if p373 == false then
        local v374 = p372.UserInputType == Enum.UserInputType.Keyboard and (not u32 and (u31 or p372.KeyCode.Value == Value2)) and u27[p372.KeyCode.Value];

        if v374 then
            v374(p373);
        end;

        local UserInputType = p372.UserInputType;

        if (UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch) and u13.Visible then
            u20:deselect();
        end;
    end;
end;

local function OnUISChanged(p375) -- Line: 2965
    -- upvalues: UserInputService (copy), u38 (ref), u24 (ref)
    if p375 == "KeyboardEnabled" or p375 == "VREnabled" then
        local v376 = UserInputService.KeyboardEnabled and not UserInputService.VREnabled;

        for i = 1, u38 do
            u24[i]:TurnNumber(v376);
        end;
    end;
end;

local u377 = nil;
local u378 = nil;

local function u379() -- Line: 2977
end;

local u380 = Vector2.new(0, 0);

function unbindAllGamepadEquipActions()
    -- upvalues: ContextActionService (copy)
    ContextActionService:UnbindAction("RBXBackpackHasGamepadFocus");
    ContextActionService:UnbindAction("RBXCloseInventory");
end;

local function setHotbarVisibility(p381, p382) -- Line: 2986
    -- upvalues: u38 (ref), u24 (ref)
    for i = 1, u38 do
        local v383 = u24[i];

        if v383 and (v383.Frame and (p382 or v383.Tool)) then
            v383.Frame.Visible = p381;
        end;
    end;
end;

local function getInputDirection(p384) -- Line: 2995
    -- upvalues: u380 (ref)
    local v385 = p384.UserInputState == Enum.UserInputState.End and -1 or 1;

    if p384.KeyCode == Enum.KeyCode.Thumbstick1 then
        local magnitude = p384.Position.magnitude;

        if magnitude > 0.98 then
            u380 = Vector2.new(p384.Position.x / magnitude, -p384.Position.y / magnitude);
        else
            u380 = Vector2.new(0, 0);
        end;
    elseif p384.KeyCode == Enum.KeyCode.DPadLeft then
        u380 = Vector2.new(u380.x - v385 * 1, u380.y);
    elseif p384.KeyCode == Enum.KeyCode.DPadRight then
        u380 = Vector2.new(u380.x + v385 * 1, u380.y);
    elseif p384.KeyCode == Enum.KeyCode.DPadUp then
        u380 = Vector2.new(u380.x, u380.y - v385 * 1);
    elseif p384.KeyCode == Enum.KeyCode.DPadDown then
        u380 = Vector2.new(u380.x, u380.y + v385 * 1);
    else
        u380 = Vector2.new(0, 0);
    end;

    return u380;
end;

local function _(p386, p387, p388) -- Line: 3024
    -- upvalues: getInputDirection (copy), u38 (ref), u24 (ref), u131 (ref), u19 (ref)
    local v389 = getInputDirection(p388);

    if v389 == Vector2.new(0, 0) then
        return;
    end;

    local v390 = math.atan2(v389.y, v389.x) - -1.5707963267948966;

    if v390 < 0 then
        v390 = v390 + 6.283185307179586;
    end;

    local v391 = math.floor(v390 / 0.7853981633974483 + 1 + 0.5);
    local v392 = u38 < v391 and 1 or v391;

    if v392 > 0 then
        local v393 = u24[v392];

        if v393 and (v393.Tool and not v393:IsEquipped()) then
            v393:Select();
        end;
    else
        u131 = nil;

        if u19 then
            u19:UnequipTools();
        end;
    end;
end;

function changeToolFunc(p394, p395, u396)
    -- upvalues: u377 (ref), u378 (ref), UserInputService (copy), u131 (ref), u19 (ref), u38 (ref), u24 (ref), u40 (ref)
    if p395 ~= Enum.UserInputState.Begin then
        return;
    end;

    if not u377 or (u377.KeyCode ~= Enum.KeyCode.ButtonR1 or u396.KeyCode ~= Enum.KeyCode.ButtonL1) and (u377.KeyCode ~= Enum.KeyCode.ButtonL1 or u396.KeyCode ~= Enum.KeyCode.ButtonR1) or (tick() - u378 > 0.06 or not UserInputService:IsGamepadButtonDown(u396.UserInputType, u377.KeyCode)) then
        u377 = u396;
        u378 = tick();
        task.delay(0.06, function() -- Line: 3080
            -- upvalues: u377 (ref), u396 (copy), u38 (ref), u24 (ref), u131 (ref), u19 (ref), u40 (ref)
            if u377 ~= u396 then
                return;
            end;

            local v397 = u396.KeyCode == Enum.KeyCode.ButtonL1 and -1 or 1;

            for i = 1, u38 do
                if u24[i]:IsEquipped() then
                    local v398 = v397 + i;
                    local v399 = false;

                    if u38 < v398 then
                        v398 = 1;
                        v399 = true;
                    elseif v398 < 1 then
                        v398 = u38;
                        v399 = true;
                    end;

                    local v400 = v398;

                    while not u24[v398].Tool do
                        v398 = v398 + v397;

                        if v398 == v400 then
                            return;
                        end;

                        if u38 < v398 then
                            v398 = 1;
                            v399 = true;
                        elseif v398 < 1 then
                            v398 = u38;
                            v399 = true;
                        end;
                    end;

                    if not v399 then
                        u24[v398]:Select();

                        return;
                    end;

                    u131 = nil;

                    if u19 then
                        u19:UnequipTools();
                    end;

                    u40 = nil;

                    return;
                end;
            end;

            if u40 and u40.Tool then
                u40:Select();

                return;
            end;

            for i = v397 == -1 and (u38 or 1) or 1, v397 == -1 and 1 or u38, v397 do
                if u24[i].Tool then
                    u24[i]:Select();

                    return;
                end;
            end;
        end);

        return;
    end;

    u131 = nil;

    if u19 then
        u19:UnequipTools();
    end;

    u377 = u396;
    u378 = tick();
end;

function getGamepadSwapSlot()
    -- upvalues: u24 (ref)
    for i = 1, #u24 do
        if u24[i].Frame:WaitForChild("UIStroke").Thickness > 0 then
            return u24[i];
        end;
    end;
end;

function changeSlot(u401)
    -- upvalues: VRService (copy), u13 (ref), GuiService (copy), u14 (ref), u38 (ref)
    if u401.Frame == GuiService.SelectedObject and (not VRService.VREnabled or u13.Visible) then
        local v402 = getGamepadSwapSlot();

        if not v402 then
            local Size = u401.Frame.Size;
            local Position = u401.Frame.Position;
            u401.Frame:TweenSizeAndPosition(Size + UDim2.new(0, 10, 0, 10), Position - UDim2.new(0, 5, 0, 5), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true, function() -- Line: 3180
                -- upvalues: u401 (copy), Size (copy), Position (copy)
                u401.Frame:TweenSizeAndPosition(Size, Position, Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.1, true);
            end);
            u401.Frame:WaitForChild("UIStroke").Thickness = 3;
            u14.SelectionImageObject.Visible = true;

            return;
        end;

        v402.Frame:WaitForChild("UIStroke").Thickness = 0;

        if v402 ~= u401 then
            u401:Swap(v402);
            u14.SelectionImageObject.Visible = false;

            if u38 < u401.Index and not u401.Tool then
                if GuiService.SelectedObject == u401.Frame then
                    GuiService.SelectedObject = v402.Frame;
                end;

                u401:Delete();
            end;

            if u38 < v402.Index and not v402.Tool then
                if GuiService.SelectedObject == v402.Frame then
                    GuiService.SelectedObject = u401.Frame;
                end;

                v402:Delete();
            end;
        end;
    else
        u401:Select();
        u14.SelectionImageObject.Visible = false;
    end;
end;

function vrMoveSlotToInventory()
    -- upvalues: VRService (copy), u14 (ref)
    if not VRService.VREnabled then
        return;
    end;

    local v403 = getGamepadSwapSlot();

    if v403 and v403.Tool then
        v403:WaitForChild("UIStroke").Thickness = 0;
        v403:MoveToInventory();
        u14.SelectionImageObject.Visible = false;
    end;
end;

function enableGamepadInventoryControl()
    -- upvalues: u13 (ref), u20 (copy), ContextActionService (copy), u379 (copy), UserInputService (copy), GuiService (copy), u12 (ref)
    local function v408(p404, p405, p406) -- Line: 3204
        -- upvalues: u13 (ref), u20 (ref)
        if p405 ~= Enum.UserInputState.Begin then
            return;
        end;

        if getGamepadSwapSlot() then
            local v407 = getGamepadSwapSlot();

            if v407 then
                v407:WaitForChild("UIStroke").Thickness = 0;
            end;
        elseif u13.Visible then
            u20:deselect();
        end;
    end;

    ContextActionService:BindAction("RBXBackpackHasGamepadFocus", u379, false, Enum.UserInputType.Gamepad1);
    ContextActionService:BindAction("RBXCloseInventory", v408, false, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonStart);

    if not UserInputService.VREnabled then
        GuiService.SelectedObject = u12:FindFirstChild("1");
    end;
end;

function disableGamepadInventoryControl()
    -- upvalues: u38 (ref), u24 (ref), GuiService (copy), u11 (ref)
    unbindAllGamepadEquipActions();

    for i = 1, u38 do
        local v409 = u24[i];

        if v409 and v409.Frame then
            v409.Frame:WaitForChild("UIStroke").Thickness = 0;
        end;
    end;

    if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(u11) then
        GuiService.SelectedObject = nil;
    end;
end;

local function bindBackpackHotbarAction() -- Line: 3244
    -- upvalues: u31 (ref), u8 (ref), ContextActionService (copy)
    if not u31 then
        return;
    end;

    if u8 and ContextActionService:GetAllBoundActionInfo().RBXHotbarEquip ~= nil then
        return;
    end;

    u8 = true;
    ContextActionService:BindAction("RBXHotbarEquip", changeToolFunc, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1);
end;

local function unbindBackpackHotbarAction() -- Line: 3259
    -- upvalues: u8 (ref), ContextActionService (copy)
    disableGamepadInventoryControl();
    u8 = false;
    ContextActionService:UnbindAction("RBXHotbarEquip");
end;

function gamepadDisconnected()
    -- upvalues: u36 (ref)
    u36 = false;
    disableGamepadInventoryControl();
end;

function gamepadConnected()
    -- upvalues: u36 (ref), GuiService (copy), u11 (ref), u29 (ref), u31 (ref), u8 (ref), ContextActionService (copy), u13 (ref)
    u36 = true;
    GuiService:AddSelectionParent("RBXBackpackSelection", u11);

    if u29 >= 1 and (u31 and (not u8 or ContextActionService:GetAllBoundActionInfo().RBXHotbarEquip == nil)) then
        u8 = true;
        ContextActionService:BindAction("RBXHotbarEquip", changeToolFunc, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1);
    end;

    if u13.Visible then
        enableGamepadInventoryControl();
    end;
end;

local function OnIconChanged(p410) -- Line: 3283
    -- upvalues: u5 (ref), StarterGui (copy), u20 (copy), GuiService (copy), u31 (ref), u11 (ref), u34 (copy), u38 (ref), u24 (ref), u8 (ref), ContextActionService (copy)
    if u5 then
        p410 = false;
    end;

    local success, result = pcall(function() -- Line: 3291
        -- upvalues: StarterGui (ref)
        return StarterGui:GetCore("TopbarEnabled");
    end);

    if p410 then
        p410 = not success or result;
    end;

    local v411;

    if p410 then
        v411 = not GuiService.MenuIsOpen;
    else
        v411 = p410;
    end;

    u20:setEnabled(v411);
    u31 = p410;
    u11.Visible = p410;

    for _, _ in pairs(u34) do

    end;

    if p410 then
        local v412 = false;

        for i = 1, u38 do
            local v413 = u24[i];

            if v413 and v413.Tool then
                v412 = true;
                break;
            end;
        end;

        if v412 then
            if not u31 then
                return;
            end;

            if u8 and ContextActionService:GetAllBoundActionInfo().RBXHotbarEquip ~= nil then
                return;
            end;

            u8 = true;
            ContextActionService:BindAction("RBXHotbarEquip", changeToolFunc, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1);
        end;
    else
        disableGamepadInventoryControl();
        u8 = false;
        ContextActionService:UnbindAction("RBXHotbarEquip");
    end;
end;

local function MakeVRRoundButton(p414, p415) -- Line: 3329
    -- upvalues: NewGui (copy)
    local v416 = NewGui("ImageButton", p414);
    v416.Size = UDim2.new(0, 40, 0, 40);
    v416.Image = "rbxasset://textures/ui/Keyboard/close_button_background.png";
    local v417 = NewGui("ImageLabel", "Icon");
    v417.Size = UDim2.new(0.5, 0, 0.5, 0);
    v417.Position = UDim2.new(0.25, 0, 0.25, 0);
    v417.Image = p415;
    v417.Parent = v416;
    local v418 = NewGui("ImageLabel", "Selection");
    v418.Size = UDim2.new(0.9, 0, 0.9, 0);
    v418.Position = UDim2.new(0.05, 0, 0.05, 0);
    v418.Image = "rbxasset://textures/ui/Keyboard/close_button_selection.png";
    v416.SelectionImageObject = v418;

    return v416, v417, v418;
end;

u11 = NewGui("Frame", "Backpack");
u11.Visible = false;
u11.Parent = ScreenGui;
u12 = NewGui("Frame", "Hotbar");
u12.Parent = u11;

for i = 1, u38 do
    local v419 = u46(u12, i);
    v419.Frame.Visible = false;

    if not u25 then
        u25 = v419;
    end;
end;

u20.selected:Connect(function() -- Line: 3369
    -- upvalues: GuiService (copy), u1 (copy)
    if not GuiService.MenuIsOpen then
        u1.OpenClose();
    end;
end);
u20.deselected:Connect(function() -- Line: 3374
    -- upvalues: u13 (ref), u1 (copy)
    if u13.Visible then
        u1.OpenClose();
    end;
end);
LeftBumperButton = NewGui("ImageLabel", "LeftBumper");
LeftBumperButton.Size = UDim2.new(0, 40, 0, 40);
LeftBumperButton.Position = UDim2.new(0, -LeftBumperButton.Size.X.Offset, 0.5, -LeftBumperButton.Size.Y.Offset / 2);
RightBumperButton = NewGui("ImageLabel", "RightBumper");
RightBumperButton.Size = UDim2.new(0, 40, 0, 40);
RightBumperButton.Position = UDim2.new(1, 0, 0.5, -RightBumperButton.Size.Y.Offset / 2);
u13 = NewGui("Frame", "Inventory");
local UICorner = Instance.new("UICorner");
UICorner.CornerRadius = script:GetAttribute("CornerRadius");
UICorner.Parent = u13;
u13.BackgroundTransparency = BACKGROUND_FADE;
u13.BackgroundColor3 = BACKGROUND_COLOR;
u13.Active = true;
u13.Visible = false;
u13.Parent = u11;
u14 = NewGui("TextButton", "VRInventorySelector");
u14.Position = UDim2.new(0, 0, 0, 0);
u14.Size = UDim2.new(1, 0, 1, 0);
u14.BackgroundTransparency = 1;
u14.Text = "";
u14.Parent = u13;
local v420 = NewGui("ImageLabel", "Selector");
v420.Size = UDim2.new(1, 0, 1, 0);
v420.Image = "rbxasset://textures/ui/Keyboard/key_selection_9slice.png";
v420.ScaleType = Enum.ScaleType.Slice;
v420.SliceCenter = Rect.new(12, 12, 52, 52);
v420.Visible = false;
u14.SelectionImageObject = v420;
u14.MouseButton1Click:Connect(function() -- Line: 3414
    vrMoveSlotToInventory();
end);
u15 = NewGui("ScrollingFrame", "ScrollingFrame");
u15.Selectable = false;
u15.CanvasSize = UDim2.new(0, 0, 0, 0);
u15.Parent = u13;
u16 = NewGui("Frame", "UIGridFrame");
u16.Selectable = false;
u16.Size = UDim2.new(1, -(ICON_BUFFER * 2), 1, 0);
u16.Position = UDim2.new(0, ICON_BUFFER, 0, 0);
u16.Parent = u15;
u17 = Instance.new("UIGridLayout");
u17.SortOrder = Enum.SortOrder.LayoutOrder;
u17.CellSize = UDim2.new(0, ICON_SIZE, 0, ICON_SIZE);
u17.CellPadding = UDim2.new(0, ICON_BUFFER, 0, ICON_BUFFER);
u17.Parent = u16;
local u421 = SideBar:Clone();
u421.Parent = u13;
local u422 = nil;
local u423 = {
    Seeds = "Seeds",
    Gears = "Gears",
    Pets = "Pets",
    All = "Inventory"
};

local function UpdateHeaderText() -- Line: 3449
    -- upvalues: u422 (ref), u41 (ref), LocalPlayer (ref), u423 (copy)
    if not u422 then
        return;
    end;

    if u41 == "Fruits" then
        u422.Text = `{LocalPlayer:GetAttribute("FruitCount") or 0}/{LocalPlayer:GetAttribute("MaxFruitCapacity") or 100} Fruits`;

        return;
    end;

    u422.Text = u423[u41] or "";
end;

u422 = script.FruitInventory:Clone();
u422.Parent = u13;
UpdateHeaderText();
LocalPlayer:GetAttributeChangedSignal("FruitCount"):Connect(UpdateHeaderText);
LocalPlayer:GetAttributeChangedSignal("MaxFruitCapacity"):Connect(UpdateHeaderText);

local function u426(p424) -- Line: 3469
    -- upvalues: u41 (ref), u421 (copy), u422 (ref), LocalPlayer (ref), u423 (copy), u48 (ref), u15 (ref)
    u41 = p424;
    u421.Gears.SelectedStroke.Enabled = p424 == "Gears";
    u421.Seeds.SelectedStroke.Enabled = p424 == "Seeds";
    u421.Fruits.SelectedStroke.Enabled = p424 == "Fruits";
    u421.All.SelectedStroke.Enabled = p424 == "All";
    local Pets = u421:FindFirstChild("Pets");
    local v425 = Pets and Pets:FindFirstChild("SelectedStroke");

    if v425 then
        v425.Enabled = p424 == "Pets";
    end;

    if u422 then
        u422.Visible = true;

        if u422 then
            if u41 == "Fruits" then
                u422.Text = `{LocalPlayer:GetAttribute("FruitCount") or 0}/{LocalPlayer:GetAttribute("MaxFruitCapacity") or 100} Fruits`;
            else
                u422.Text = u423[u41] or "";
            end;
        end;
    end;

    u48();
    u15.CanvasPosition = Vector2.new(0, 0);
end;

u421.Gears.ImageButton.MouseButton1Click:Connect(function() -- Line: 3495
    -- upvalues: u426 (ref)
    u426("Gears");
end);
u421.Seeds.ImageButton.MouseButton1Click:Connect(function() -- Line: 3496
    -- upvalues: u426 (ref)
    u426("Seeds");
end);
u421.Fruits.ImageButton.MouseButton1Click:Connect(function() -- Line: 3497
    -- upvalues: u426 (ref)
    u426("Fruits");
end);
u421.All.ImageButton.MouseButton1Click:Connect(function() -- Line: 3498
    -- upvalues: u426 (ref)
    u426("All");
end);
local Pets = u421:FindFirstChild("Pets");

if Pets then
    Pets = Pets:FindFirstChild("ImageButton");
end;

if Pets and Pets:IsA("GuiButton") then
    Pets.MouseButton1Click:Connect(function() -- Line: 3505
        -- upvalues: u426 (ref)
        u426("Pets");
    end);
end;

u426("All");
local u427 = MakeVRRoundButton("ScrollUpButton", "rbxasset://textures/ui/Backpack/ScrollUpArrow.png");
u427.Size = UDim2.new(0, 34, 0, 34);
u427.Position = UDim2.new(0.5, -u427.Size.X.Offset / 2, 0, INVENTORY_HEADER_SIZE + 3);
u427.Icon.Position = u427.Icon.Position - UDim2.new(0, 0, 0, 2);
u427.MouseButton1Click:Connect(function() -- Line: 3516
    -- upvalues: u15 (ref)
    local new = Vector2.new;
    local X = u15.CanvasPosition.X;
    local v428 = u15.CanvasSize.Y.Offset - u15.AbsoluteWindowSize.Y;
    local v429 = math.max(0, u15.CanvasPosition.Y - (ICON_BUFFER + ICON_SIZE));
    u15.CanvasPosition = new(X, (math.min(v428, v429)));
end);
local u430 = MakeVRRoundButton("ScrollDownButton", "rbxasset://textures/ui/Backpack/ScrollUpArrow.png");
u430.Rotation = 180;
u430.Icon.Position = u430.Icon.Position - UDim2.new(0, 0, 0, 2);
u430.Size = UDim2.new(0, 34, 0, 34);
u430.Position = UDim2.new(0.5, -u430.Size.X.Offset / 2, 1, -u430.Size.Y.Offset - 3);
u430.MouseButton1Click:Connect(function() -- Line: 3527
    -- upvalues: u15 (ref)
    local new = Vector2.new;
    local X = u15.CanvasPosition.X;
    local v431 = u15.CanvasSize.Y.Offset - u15.AbsoluteWindowSize.Y;
    local v432 = math.max(0, u15.CanvasPosition.Y + (ICON_BUFFER + ICON_SIZE));
    u15.CanvasPosition = new(X, (math.min(v431, v432)));
end);
u15.Changed:Connect(function(p433) -- Line: 3533
    -- upvalues: u15 (ref), u427 (ref), u430 (ref)
    if p433 == "AbsoluteWindowSize" or (p433 == "CanvasPosition" or p433 == "CanvasSize") then
        local v434 = u15.CanvasPosition.Y < u15.CanvasSize.Y.Offset - u15.AbsoluteWindowSize.Y;
        u427.Visible = u15.CanvasPosition.Y ~= 0;
        u430.Visible = v434;
    end;
end);
UpdateBackpackLayout();
local u435 = Utility:Create("Frame")({
    Name = "GamepadHintsFrame",
    BackgroundTransparency = 1,
    Visible = false,
    Size = UDim2.new(0, u12.Size.X.Offset, 0, u7 and 95 or 60),
    Parent = u11
});
local u436 = {};

local function addGamepadHint(p437, p438) -- Line: 3556
    -- upvalues: Utility (copy), u435 (copy), u7 (copy), UserInputService (copy), u436 (copy)
    local v439 = Utility:Create("Frame")({
        Name = "HintFrame",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -5),
        Position = UDim2.new(0, 0, 0, 0),
        Parent = u435
    });
    u436[Utility:Create("ImageLabel")({
        Name = "HintImage",
        BackgroundTransparency = 1,
        Size = u7 and UDim2.new(0, 90, 0, 90) or UDim2.new(0, 60, 0, 60),
        Image = UserInputService:GetImageForKeyCode(p437),
        Parent = v439
    })] = p437;
    local v440 = Utility:Create("TextLabel")({
        Name = "HintText",
        BackgroundTransparency = 1,
        TextWrapped = true,
        Position = UDim2.new(0, u7 and 100 or 70, 0, 0),
        Size = UDim2.new(1, -(u7 and 100 or 70), 1, 0),
        Font = Enum.Font.SourceSansBold,
        FontSize = u7 and Enum.FontSize.Size36 or Enum.FontSize.Size24,
        Text = p438,
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = v439
    });
    Instance.new("UITextSizeConstraint", v440).MaxTextSize = v440.TextSize;
end;

local function updateGamepadHintImages() -- Line: 3595
    -- upvalues: u436 (copy), UserInputService (copy)
    for i, v in u436 do
        i.Image = UserInputService:GetImageForKeyCode(v);
    end;
end;

local function resizeGamepadHintsFrame() -- Line: 3601
    -- upvalues: u435 (copy), u12 (ref), u7 (copy), u13 (ref)
    u435.Size = UDim2.new(u12.Size.X.Scale, u12.Size.X.Offset, 0, u7 and 95 or 60);
    u435.Position = UDim2.new(u12.Position.X.Scale, u12.Position.X.Offset, u13.Position.Y.Scale, u13.Position.Y.Offset - u435.Size.Y.Offset);
    local v441 = u435:GetChildren();
    local v442 = 0;

    for i = 1, #v441 do
        v441[i].Size = UDim2.new(1, 0, 1, -5);
        v441[i].Position = UDim2.new(0, 0, 0, 0);
        v442 = v442 + (v441[i].HintText.Position.X.Offset + v441[i].HintText.TextBounds.X);
    end;

    local v443 = (u435.AbsoluteSize.X - v442) / (#v441 - 1);

    for i = 1, #v441 do
        v441[i].Position = i == 1 and UDim2.new(0, 0, 0, 0) or UDim2.new(0, v441[i - 1].Position.X.Offset + v441[i - 1].Size.X.Offset + v443, 0, 0);
        v441[i].Size = UDim2.new(0, v441[i].HintText.Position.X.Offset + v441[i].HintText.TextBounds.X, 1, -5);
    end;
end;

addGamepadHint(Enum.KeyCode.ButtonX, "Remove From Hotbar");
addGamepadHint(Enum.KeyCode.ButtonA, "Select/Swap");
addGamepadHint(Enum.KeyCode.ButtonB, "Close Backpack");
local u444 = NewGui("Frame", "Search");
local UICorner2 = Instance.new("UICorner");
UICorner2.CornerRadius = script:GetAttribute("CornerRadius");
UICorner2.Parent = u444;
u444.BackgroundColor3 = v2;
u444.BackgroundTransparency = v3;
u444.Size = UDim2.new(0, 190, 0, INVENTORY_HEADER_SIZE - 10);
u444.Position = UDim2.new(1, -u444.Size.X.Offset - 5, 0, 5);
u444.Parent = u13;
local u445 = NewGui("TextBox", "TextBox");
u445.PlaceholderText = "Search";
u445.ClearTextOnFocus = false;
u445.FontSize = Enum.FontSize.Size24;
u445.TextXAlignment = Enum.TextXAlignment.Left;
local UIPadding = Instance.new("UIPadding");
UIPadding.Parent = u445;
UIPadding.PaddingLeft = UDim.new(0, 8);
u445.Size = u444.Size - UDim2.fromOffset(0, 0);
u445.Position = UDim2.new(0, 0, 0, 0);
u445.Parent = u444;
local u446 = NewGui("TextButton", "X");
local UICorner3 = Instance.new("UICorner");
UICorner3.CornerRadius = script:GetAttribute("CornerRadius");
UICorner3.Parent = u446;
u446.Text = "X";
u446.ZIndex = 10;
u446.TextColor3 = Color3.new(1, 1, 1);
u446.FontSize = Enum.FontSize.Size24;
u446.TextYAlignment = Enum.TextYAlignment.Bottom;
u446.BackgroundTransparency = 1;
u446.Size = UDim2.new(0, u444.Size.Y.Offset - 10, 0, u444.Size.Y.Offset - 10);
u446.Position = UDim2.new(1, -u446.Size.X.Offset - 10, 0.5, -u446.Size.Y.Offset / 2);
u446.Visible = false;
u446.BorderSizePixel = 0;
u446.Parent = u444;
local u447 = utf8.char(9734);
local u448 = utf8.char(9733);
local v449 = INVENTORY_HEADER_SIZE - 10;
local v450 = NewGui("ImageButton", "FavoriteFilter");
v450.Size = UDim2.new(0, v449, 0, v449);
v450.Position = UDim2.new(1, -200 - v449 - 5, 0, 5);
v450.BackgroundColor3 = v2;
v450.BackgroundTransparency = v3;
v450.Image = "";
v450.Parent = u13;
local UICorner4 = Instance.new("UICorner");
UICorner4.CornerRadius = script:GetAttribute("CornerRadius");
UICorner4.Parent = v450;
local u451 = NewGui("TextLabel", "Star");
u451.Size = UDim2.new(0.9, 0, 0.9, 0);
u451.AnchorPoint = Vector2.new(0.5, 0.5);
u451.Position = UDim2.new(0.5, 0, 0.45, 0);
u451.Text = u447;
u451.TextScaled = true;
u451.BackgroundTransparency = 1;
u451.Parent = v450;
local u452 = NewGui("Frame", "SlashLine");
u452.Size = UDim2.new(1.05, 0, 0, 3);
u452.AnchorPoint = Vector2.new(0.5, 0.5);
u452.Position = UDim2.new(0.5, 0, 0.5, 0);
u452.Rotation = 45;
u452.BackgroundColor3 = Color3.fromRGB(220, 50, 50);
u452.BackgroundTransparency = 0;
u452.BorderSizePixel = 0;
u452.ZIndex = 13;
u452.Visible = false;
u452.Parent = v450;

local function RefreshFavoriteButtonVisual() -- Line: 3703
    -- upvalues: u42 (ref), u451 (copy), u447 (copy), u452 (copy), u448 (copy)
    if u42 == 0 then
        u451.Text = u447;
        u451.TextColor3 = Color3.fromRGB(255, 255, 255);
        u451.TextTransparency = 0;
        u452.Visible = false;

        return;
    end;

    if u42 == 1 then
        u451.Text = u448;
        u451.TextColor3 = Color3.fromRGB(255, 240, 23);
        u451.TextTransparency = 0;
        u452.Visible = false;

        return;
    end;

    u451.Text = u448;
    u451.TextColor3 = Color3.fromRGB(255, 240, 23);
    u451.TextTransparency = 0;
    u452.Visible = true;
end;

RefreshFavoriteButtonVisual();
v450.MouseButton1Click:Connect(function() -- Line: 3727
    -- upvalues: u42 (ref), RefreshFavoriteButtonVisual (copy), u33 (ref), u1 (copy), u48 (ref)
    u42 = (u42 + 1) % 3;
    RefreshFavoriteButtonVisual();

    if u33 and u1._ApplySearch then
        u1._ApplySearch();

        return;
    end;

    u48();
end);

local function search() -- Line: 3740
    -- upvalues: u445 (copy), u38 (ref), u24 (ref), u13 (ref), u33 (ref), u42 (ref), u16 (ref), u90 (ref), u15 (ref), UpdateScrollingFrameCanvasSize (ref), u446 (copy)
    local v453 = {};

    for i in u445.Text:gmatch("%S+") do
        v453[i:lower()] = true;
    end;

    local v454 = {};

    for i = u38 + 1, #u24 do
        local v455 = u24[i];
        local v456 = { v455, (v455:CheckTerms(v453)) };
        table.insert(v454, v456);
        v455.Frame.Visible = false;
        v455.Frame.Parent = u13;
    end;

    table.sort(v454, function(p457, p458) -- Line: 3755
        return p457[2] > p458[2];
    end);
    u33 = true;
    local v459 = 0;

    for _, v in ipairs(v454) do
        local v460 = v[1];

        if v[2] > 0 then
            local Tool = v460.Tool;
            local v461;

            if u42 == 0 then
                v461 = true;
            else
                v461 = Tool:GetAttribute("IsFavorite") == true;

                if u42 ~= 1 then
                    v461 = not v461;
                end;
            end;

            if v461 then
                v460.Frame.Visible = true;
                v460.Frame.Parent = u16;
                v460.Frame.LayoutOrder = u38 + v459;
                v459 = v459 + 1;
            end;
        end;
    end;

    u90 = v459;
    u15.CanvasPosition = Vector2.new(0, 0);
    UpdateScrollingFrameCanvasSize();
    u446.ZIndex = 3;
end;

u1._ApplySearch = search;

local function clearResults() -- Line: 3781
    -- upvalues: u446 (copy), u33 (ref), u38 (ref), u24 (ref), u16 (ref), ToolMatchesFilter (copy), u41 (ref), u42 (ref), u90 (ref), UpdateScrollingFrameCanvasSize (ref)
    if u446.ZIndex > 0 then
        u33 = false;
        local v462 = 0;

        for i = u38 + 1, #u24 do
            local v463 = u24[i];
            v463.Frame.LayoutOrder = v463.Index;
            v463.Frame.Parent = u16;
            local v464;

            if v463.Tool == nil then
                v464 = false;
            else
                v464 = ToolMatchesFilter(v463.Tool, u41);

                if v464 then
                    local Tool = v463.Tool;

                    if u42 == 0 then
                        v464 = true;
                    else
                        v464 = Tool:GetAttribute("IsFavorite") == true;

                        if u42 ~= 1 then
                            v464 = not v464;
                        end;
                    end;
                end;
            end;

            v463.Frame.Visible = v464;

            if v464 then
                v462 = v462 + 1;
            end;
        end;

        u90 = v462;
        u446.ZIndex = 0;
    end;

    UpdateScrollingFrameCanvasSize();
end;

u446.MouseButton1Click:Connect(function() -- Line: 3803, Name: reset
    -- upvalues: clearResults (copy), u445 (copy)
    clearResults();
    u445.Text = "";
end);
u445.Changed:Connect(function(p465) -- Line: 3808, Name: onChanged
    -- upvalues: u445 (copy), clearResults (copy), search (copy), u446 (copy)
    if p465 == "Text" then
        local Text = u445.Text;

        if Text == "" then
            clearResults();
        elseif Text ~= "Search" then
            search();
        end;

        local v466;

        if Text == "" then
            v466 = false;
        else
            v466 = Text ~= "Search";
        end;

        u446.Visible = v466;
    end;
end);
u445.FocusLost:Connect(function(p467) -- Line: 3820, Name: focusLost
    -- upvalues: search (copy)
    if p467 then
        search();
    end;
end);
u1.StateChanged.Event:Connect(function(p468) -- Line: 3830
    -- upvalues: clearResults (copy), u445 (copy), u13 (ref), u20 (copy)
    if not p468 then
        clearResults();
        u445.Text = "";

        if not u13.Visible then
            u20:deselect();
        end;
    end;
end);

u27[Enum.KeyCode.Escape.Value] = function(p469) -- Line: 3839
    -- upvalues: clearResults (copy), u445 (copy), u13 (ref), u20 (copy)
    if not p469 then
        if u13.Visible then
            u20:deselect();
        end;

        return;
    end;

    clearResults();
    u445.Text = "";
end;

UserInputService.LastInputTypeChanged:Connect(function(p470) -- Line: 3847, Name: detectGamepad
    -- upvalues: UserInputService (copy), u444 (copy)
    if p470 == Enum.UserInputType.Gamepad1 and not UserInputService.VREnabled then
        u444.Visible = false;

        return;
    end;

    u444.Visible = true;
end);
GuiService.MenuOpened:Connect(function() -- Line: 3857
    -- upvalues: u13 (ref), u20 (copy)
    if u13.Visible then
        u20:deselect();
    end;
end);
local u471 = false;

local function u475(p472, p473, p474) -- Line: 3870
    -- upvalues: GuiService (copy), u38 (ref), u24 (ref)
    if p473 ~= Enum.UserInputState.Begin then
        return;
    end;

    if not GuiService.SelectedObject then
        return;
    end;

    for i = 1, u38 do
        if u24[i].Frame == GuiService.SelectedObject and u24[i].Tool then
            u24[i]:MoveToInventory();

            return;
        end;
    end;
end;

local function u478(p476, p477) -- Line: 3882
    -- upvalues: GuiService (copy), u24 (ref), ToggleFavorite (copy)
    if p477 ~= Enum.UserInputState.Begin then
        return;
    end;

    local SelectedObject = GuiService.SelectedObject;

    if not SelectedObject then
        return;
    end;

    for _, v in u24 do
        if v.Frame == SelectedObject and v.Tool then
            ToggleFavorite(v);

            return;
        end;
    end;
end;

local function openClose() -- Line: 3894
    -- upvalues: u28 (copy), u13 (ref), u426 (ref), u47 (ref), u12 (ref), u38 (ref), u24 (ref), u36 (ref), u6 (copy), UserInputService (copy), u436 (copy), resizeGamepadHintsFrame (copy), u435 (copy), ContextActionService (copy), u475 (copy), u478 (copy), ProximityPromptService (copy), u471 (ref), u1 (copy)
    if not next(u28) then
        u13.Visible = not u13.Visible;
        local Visible = u13.Visible;

        if Visible then
            u426("All");
        end;

        u47();
        u12.Active = not u12.Active;

        for i = 1, u38 do
            u24[i]:SetClickability(not Visible);
        end;
    end;

    if u13.Visible then
        if u36 then
            if u6[UserInputService:GetLastInputType()] then
                for i, v in u436 do
                    i.Image = UserInputService:GetImageForKeyCode(v);
                end;

                resizeGamepadHintsFrame();
                u435.Visible = not UserInputService.VREnabled;
            end;

            enableGamepadInventoryControl();
        end;
    else
        if u36 then
            u435.Visible = false;
        end;

        disableGamepadInventoryControl();
    end;

    if u13.Visible then
        ContextActionService:BindAction("RBXRemoveSlot", u475, false, Enum.KeyCode.ButtonX);
        ContextActionService:BindAction("RBXFavoriteFruit", u478, false, Enum.KeyCode.ButtonY);

        if u36 and (u6[UserInputService:GetLastInputType()] and ProximityPromptService.Enabled) then
            ProximityPromptService.Enabled = false;
            u471 = true;
        end;
    else
        ContextActionService:UnbindAction("RBXRemoveSlot");
        ContextActionService:UnbindAction("RBXFavoriteFruit");

        if u471 then
            u471 = false;
            ProximityPromptService.Enabled = true;
        end;
    end;

    u1.IsOpen = u13.Visible;
    u1.StateChanged:Fire(u13.Visible);
end;

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false);
u1.OpenClose = openClose;

while not LocalPlayer do
    wait();
    LocalPlayer = Players.LocalPlayer;
end;

LocalPlayer.CharacterAdded:Connect(OnCharacterAdded);

if LocalPlayer.Character then
    OnCharacterAdded(LocalPlayer.Character);
end;

UserInputService.InputBegan:Connect(OnInputBegan);
UserInputService.TextBoxFocused:Connect(function() -- Line: 3969
    -- upvalues: u32 (ref)
    u32 = true;
end);
UserInputService.TextBoxFocusReleased:Connect(function() -- Line: 3970
    -- upvalues: u32 (ref)
    u32 = false;
end);
UserInputService.Changed:Connect(OnUISChanged);
OnUISChanged("KeyboardEnabled");

if UserInputService:GetGamepadConnected(Enum.UserInputType.Gamepad1) then
    gamepadConnected();
end;

UserInputService.GamepadConnected:Connect(function(p479) -- Line: 3983
    if p479 == Enum.UserInputType.Gamepad1 then
        gamepadConnected();
    end;
end);
UserInputService.GamepadDisconnected:Connect(function(p480) -- Line: 3988
    if p480 == Enum.UserInputType.Gamepad1 then
        gamepadDisconnected();
    end;
end);

function u1.SetBackpackEnabled(p481, p482) -- Line: 3995
    -- upvalues: u4 (ref)
    u4 = p482;
end;

function u1.IsOpened(p483) -- Line: 3999
    -- upvalues: u1 (copy)
    return u1.IsOpen;
end;

function u1.GetBackpackEnabled(p484) -- Line: 4003
    -- upvalues: u4 (ref)
    return u4;
end;

function u1.GetStateChangedEvent(p485) -- Line: 4007
    -- upvalues: Backpack (ref)
    return Backpack.StateChanged;
end;

RunService.Heartbeat:Connect(function() -- Line: 4011
    -- upvalues: OnIconChanged (copy), u4 (ref)
    OnIconChanged(u4);
end);
LocalPlayer:GetAttributeChangedSignal("LoadingScreenActive"):Connect(function() -- Line: 4019
    -- upvalues: LocalPlayer (ref), u8 (ref), ContextActionService (copy), OnIconChanged (copy), u4 (ref)
    if LocalPlayer:GetAttribute("LoadingScreenActive") then
        return;
    end;

    disableGamepadInventoryControl();
    u8 = false;
    ContextActionService:UnbindAction("RBXHotbarEquip");
    OnIconChanged(u4);
end);
Api.Event:Connect(function(p486, p487) -- Line: 4027
    -- upvalues: u1 (copy)
    if p486 == "SetBackpackEnabled" then
        u1:SetBackpackEnabled(p487);

        return;
    end;

    if p486 == "SetInventoryOpen" then
        if type(p487) == "boolean" and p487 == true then
            u1.IsOpen = true;

            return;
        end;

        if type(p487) == "boolean" then
            u1.IsOpen = false;
        end;
    elseif p486 == "ToggleBackpack" then
        u1.OpenClose();
    end;
end);
u9 = (function() -- Line: 4041, Name: UpdateIsPhone
    -- upvalues: UserInputService (copy)
    local v488;

    if game.Workspace.Camera.ViewportSize.X < 1000 then
        v488 = true;
    else
        v488 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled;
    end;

    return v488;
end)();
local v489 = VREnabled and HOTBAR_SLOTS_VR or (u9 and HOTBAR_SLOTS_MINI or HOTBAR_SLOTS_FULL);
u39 = VREnabled and INVENTORY_ROWS_VR or (u9 and INVENTORY_ROWS_MINI or INVENTORY_ROWS_FULL);

if v489 == u38 then
    u38 = v489;
else
    u56 = true;
    local v490 = {};

    for i = 1, #u24 do
        local v491 = u24[i];

        if v491 and v491.Tool then
            table.insert(v490, v491.Tool);
            v491:Clear();
        end;
    end;

    for i = #u24, 1, -1 do
        u24[i].Frame:Destroy();
    end;

    u24 = {};
    u26 = {};
    u29 = 0;
    u25 = nil;
    u38 = v489;

    for i = 1, u38 do
        local v492 = u46(u12, i);
        v492.Frame.Visible = false;

        if not u25 then
            u25 = v492;
        end;
    end;

    for _, v in ipairs(v490) do
        u25 = u45();
        (u25 or u46(u16)):Fill(v);
    end;

    u25 = u45();

    for i = 1, u38 do
        if i < 10 then
            u27[Value + i] = u24[i].Select;
        elseif i == u38 then
            u27[Value] = u24[i].Select;
        end;
    end;

    u56 = false;
end;

OnUISChanged("KeyboardEnabled");
UpdateBackpackLayout();
game.Workspace.Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- Line: 4104
    -- upvalues: u9 (ref), UserInputService (copy), VREnabled (copy), u39 (ref), u38 (ref), UpdateBackpackLayout (copy), u56 (ref), u24 (ref), u26 (ref), u29 (ref), u25 (ref), u46 (ref), u12 (ref), u53 (ref), u45 (ref), u16 (ref), u27 (ref), Value (copy), u55 (ref), Networking (copy)
    local v493 = u9;
    local v494;

    if game.Workspace.Camera.ViewportSize.X < 1000 then
        v494 = true;
    else
        v494 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled;
    end;

    u9 = v494;

    if v493 ~= u9 then
        local v495 = VREnabled and HOTBAR_SLOTS_VR or (u9 and HOTBAR_SLOTS_MINI or HOTBAR_SLOTS_FULL);
        u39 = VREnabled and INVENTORY_ROWS_VR or (u9 and INVENTORY_ROWS_MINI or INVENTORY_ROWS_FULL);

        if v495 == u38 then
            UpdateBackpackLayout();

            return;
        end;

        u56 = true;
        local v496 = {};

        for i = 1, #u24 do
            local v497 = u24[i];

            if v497 and v497.Tool then
                table.insert(v496, v497.Tool);
                v497:Clear();
            end;
        end;

        for i = #u24, 1, -1 do
            u24[i].Frame:Destroy();
        end;

        u24 = {};
        u26 = {};
        u29 = 0;
        u25 = nil;
        u38 = v495;

        for i = 1, u38 do
            local v498 = u46(u12, i);
            v498.Frame.Visible = false;

            if not u25 then
                u25 = v498;
            end;
        end;

        if u53 then
            local v499 = {};

            for i, v in pairs(u53) do
                local v500 = tonumber(i);

                if v500 and (v500 >= 1 and v500 <= u38) then
                    for _, v4 in ipairs(v496) do
                        if not v499[v4] and GetToolKey(v4) == v then
                            u24[v500]:Fill(v4);
                            v499[v4] = true;
                            break;
                        end;
                    end;
                end;
            end;

            for _, v in ipairs(v496) do
                if not v499[v] then
                    u25 = u45();
                    (u25 or u46(u16)):Fill(v);
                    v499[v] = true;
                end;
            end;
        else
            for _, v in ipairs(v496) do
                u25 = u45();
                (u25 or u46(u16)):Fill(v);
            end;
        end;

        u25 = u45();
        UpdateBackpackLayout();
        u27 = {};
        u27[Enum.KeyCode.Escape.Value] = u27[Enum.KeyCode.Escape.Value];

        for i = 1, u38 do
            if i < 10 then
                u27[Value + i] = u24[i].Select;
            elseif i == u38 then
                u27[Value] = u24[i].Select;
            end;
        end;

        local v501 = UserInputService.KeyboardEnabled and not UserInputService.VREnabled;

        for i = 1, u38 do
            u24[i]:TurnNumber(v501);
        end;

        u56 = false;

        if u56 then
            return;
        end;

        if u55 then
            return;
        end;

        u55 = true;
        task.delay(1, function() -- Line: 426
            -- upvalues: u56 (ref), u55 (ref), u38 (ref), u24 (ref), Networking (ref)
            if u56 then
                u55 = false;

                return;
            end;

            local v502 = {};
            local v503 = 0;

            for i = 1, u38 do
                local v504 = u24[i];

                if v504 and v504.Tool then
                    local v505 = GetToolKey(v504.Tool);

                    if v505 then
                        v502[i] = v505;
                        v503 = v503 + 1;
                    end;
                end;
            end;

            if v503 == 0 then
                u55 = false;

                return;
            end;

            Networking.Backpack.SaveLayout:Fire(v502);
            u55 = false;
        end);
    end;
end);
task.spawn(function() -- Line: 4206
    -- upvalues: LocalPlayer (ref), GuiController (copy)
    task.wait(3);
    NewsIcon = script.NewsIcon:Clone();
    Right = LocalPlayer.PlayerGui:WaitForChild("TopbarStandard"):WaitForChild("Holders"):WaitForChild("Right");
    Right.ClipsDescendants = false;
    NewsIcon.Parent = Right;
    local ScrollingFrame = LocalPlayer.PlayerGui:WaitForChild("SecretDropLog"):WaitForChild("Frame"):WaitForChild("Content"):WaitForChild("ScrollingFrame");

    function UPD()
        -- upvalues: ScrollingFrame (copy)
        if #ScrollingFrame:GetChildren() <= 3 then
            NewsIcon.Visible = false;
            NewsIcon.IconButton.Visible = false;

            return;
        end;

        NewsIcon.IconButton.Visible = true;
        NewsIcon.Visible = true;
    end;

    NewsIcon.Visible = false;
    UPD();
    ScrollingFrame.ChildAdded:Connect(function() -- Line: 4224
        UPD();
    end);
    ScrollingFrame.ChildRemoved:Connect(function() -- Line: 4227
        UPD();
    end);
    NewsIcon.IconButton.IconSpot.ClickRegion.MouseButton1Click:Connect(function() -- Line: 4230
        -- upvalues: GuiController (ref)
        if GuiController:IsOpen("SecretDropLog") then
            GuiController:Close();

            return;
        end;

        GuiController:Open("SecretDropLog");
    end);
end);

return u1;