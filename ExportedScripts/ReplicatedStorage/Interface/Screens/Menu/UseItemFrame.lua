-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Cases = require(ReplicatedStorage.Database.Components.Libraries.Cases);
local Collections = require(ReplicatedStorage.Database.Components.Libraries.Collections);
local GetResolvedSkinInformation = require(ReplicatedStorage.Components.Common.GetResolvedSkinInformation);
local Router = require(ReplicatedStorage.Database.Security.Router);
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry);
local Signal = require(ReplicatedStorage.Packages.Signal);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local Sort = require(ReplicatedStorage.Database.Custom.GameStats.UI.Inventory.Sort);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local Grenades = require(ReplicatedStorage.Database.Custom.GameStats.Grenades);
local Actions = require(script.Actions);
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = false;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = false;
local u10 = {};
local u11 = 0;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;
u1.OnItemSelected = Signal.new();
u1.OnClosed = Signal.new();

local function MultiplyUdim2(p18, p19) -- Line: 93
    return UDim2.new(p18.X.Scale * p19, p18.X.Offset, p18.Y.Scale * p19, p18.Y.Offset);
end;

local function ClearFrame(p20, p21) -- Line: 99
    -- upvalues: Collections (copy), u7 (ref)
    local v22 = p20:GetChildren();

    for _, v in ipairs(v22) do
        if v.ClassName == p21 or v:IsA("GuiButton") then
            v:Destroy();
        end;
    end;

    Collections.ObserveAvailableCollections(function(p23) -- Line: 108
        -- upvalues: u7 (ref)
        u7 = p23;
    end);
end;

local function AnimateSortButton(u24, u25, p26, u27, u28, p29) -- Line: 115
    -- upvalues: TweenService (copy), Router (copy), u8 (ref), u1 (copy)
    u25.MouseEnter:Connect(function() -- Line: 123
        -- upvalues: TweenService (ref), u25 (copy)
        TweenService:Create(u25, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.85
        }):Play();
    end);
    u25.MouseLeave:Connect(function() -- Line: 131
        -- upvalues: TweenService (ref), u25 (copy)
        TweenService:Create(u25, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 1
        }):Play();
    end);
    u25.MouseButton1Click:Connect(function() -- Line: 139
        -- upvalues: Router (ref), u8 (ref), u27 (copy), u1 (ref), u28 (copy), u24 (copy), u25 (copy)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        u8 = u27;
        u1.PopulateItems();
        u28.Text = u27;

        for _, child in ipairs(u24:GetChildren()) do
            if child:IsA("TextButton") then
                child.Frame.BackgroundTransparency = child == u25 and 0 or 1;
            end;
        end;

        u24.Visible = false;
    end);
end;

local function AnimateButton(u30) -- Line: 155
    -- upvalues: TweenService (copy)
    local Size = u30.Size;
    u30.MouseEnter:Connect(function() -- Line: 159
        -- upvalues: TweenService (ref), u30 (copy), Size (copy)
        local v31 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        local v32 = {};
        local v33 = Size;
        v32.Size = UDim2.new(v33.X.Scale * 0.95, v33.X.Offset, v33.Y.Scale * 0.95, v33.Y.Offset);
        TweenService:Create(u30, v31, v32):Play();
    end);
    u30.MouseLeave:Connect(function() -- Line: 167
        -- upvalues: TweenService (ref), u30 (copy), Size (copy)
        local v34 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        local v35 = {};
        local v36 = Size;
        v35.Size = UDim2.new(v36.X.Scale * 1, v36.X.Offset, v36.Y.Scale * 1, v36.Y.Offset);
        TweenService:Create(u30, v34, v35):Play();
    end);
    u30.MouseButton1Down:Connect(function() -- Line: 175
        -- upvalues: TweenService (ref), u30 (copy), Size (copy)
        local v37 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        local v38 = {};
        local v39 = Size;
        v38.Size = UDim2.new(v39.X.Scale * 0.9, v39.X.Offset, v39.Y.Scale * 0.9, v39.Y.Offset);
        TweenService:Create(u30, v37, v38):Play();
    end);
    u30.MouseButton1Up:Connect(function() -- Line: 183
        -- upvalues: TweenService (ref), u30 (copy), Size (copy)
        local v40 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        local v41 = {};
        local v42 = Size;
        v41.Size = UDim2.new(v42.X.Scale * 0.95, v42.X.Offset, v42.Y.Scale * 0.95, v42.Y.Offset);
        TweenService:Create(u30, v40, v41):Play();
    end);
end;

local function CalculateUseItemFrameInitialRenderCount() -- Line: 194
    -- upvalues: u13 (ref)
    if not (u13 and u13.Visible) then
        return 50;
    end;

    local v43 = u13:FindFirstChildOfClass("UIGridLayout");

    if not v43 then
        return 50;
    end;

    local AbsoluteSize = u13.AbsoluteSize;
    local Y = AbsoluteSize.Y;
    local X = AbsoluteSize.X;
    local CellSize = v43.CellSize;
    local CellPadding = v43.CellPadding;
    local v44 = CellSize.Y.Scale * Y + CellSize.Y.Offset;
    local v45 = CellPadding.Y.Scale * Y + CellPadding.Y.Offset;
    local v46 = CellSize.X.Scale * X + CellSize.X.Offset;
    local v47 = CellPadding.X.Scale * X + CellPadding.X.Offset;
    local v48 = u13:FindFirstChildOfClass("UIPadding");
    local v49, v50, v51, v52;

    if v48 then
        v49 = v48.PaddingTop.Scale * Y + v48.PaddingTop.Offset;
        v50 = v48.PaddingBottom.Scale * Y + v48.PaddingBottom.Offset;
        v51 = v48.PaddingLeft.Scale * X + v48.PaddingLeft.Offset;
        v52 = v48.PaddingRight.Scale * X + v48.PaddingRight.Offset;
    else
        v49 = 0;
        v50 = 0;
        v51 = 0;
        v52 = 0;
    end;

    local v53 = Y - v49 - v50;
    local v54 = X - v51 - v52;
    local v55 = v46 + v47;
    local v56;

    if v55 > 0 then
        local v57 = math.floor((v54 + v47) / v55);
        v56 = math.max(1, v57);
    else
        v56 = 1;
    end;

    local v58 = v44 + v45;
    local v59;

    if v58 > 0 then
        local v60 = math.floor((v53 + v45) / v58);
        v59 = math.max(1, v60);
    else
        v59 = 1;
    end;

    return v59 * v56 + v56;
end;

local function UseItemFrameLoadMoreItems() -- Line: 265
    -- upvalues: u13 (ref), u2 (ref), u1 (copy), Collections (copy), u7 (ref), u11 (ref), u10 (ref)
    if not u13 then
        return;
    end;

    local function onItemSelected(p61) -- Line: 270
        -- upvalues: u2 (ref), u1 (ref)
        if u2 then
            u1.OnItemSelected:Fire(p61, u2);
            u1.Hide();
        end;
    end;

    Collections.ObserveAvailableCollections(function(p62) -- Line: 280
        -- upvalues: u7 (ref)
        u7 = p62;
    end);
    local v63 = math.min(u11 + 25, #u10);

    for i = u11 + 1, v63 do
        local v64 = u10[i];

        if v64 and not u13:FindFirstChild(v64._id) then
            u1.CreateItemTemplate(v64, onItemSelected);
        end;
    end;

    Collections.ObserveAvailableCollections(function(p65) -- Line: 295
        -- upvalues: u7 (ref)
        u7 = p65;
    end);
    u11 = v63;
end;

local function UseItemFrameOnScrollPositionChanged() -- Line: 304
    -- upvalues: u13 (ref), u11 (ref), u10 (ref), UseItemFrameLoadMoreItems (copy), Collections (copy), u7 (ref)
    if not u13 then
        return;
    end;

    local v66 = u13.AbsoluteCanvasSize.Y - u13.AbsoluteSize.Y;

    if v66 > 0 and (u11 < #u10 and v66 - u13.CanvasPosition.Y < 200) then
        UseItemFrameLoadMoreItems();
    end;

    Collections.ObserveAvailableCollections(function(p67) -- Line: 320
        -- upvalues: u7 (ref)
        u7 = p67;
    end);
end;

local function EnsureInitialized() -- Line: 328
    -- upvalues: u5 (ref), u16 (ref), PlayerGui (copy), u12 (ref), u13 (ref), u17 (ref), Collections (copy), u7 (ref), u8 (ref), Router (copy), AnimateSortButton (copy), u9 (ref), u1 (copy), u14 (ref), u15 (ref), CloseButtonRegistry (copy), u2 (ref), DataController (copy), LocalPlayer (copy), MenuState (copy), UseItemFrameOnScrollPositionChanged (copy)
    if u5 then
        return true;
    end;

    print("Initializing");
    u16 = PlayerGui:FindFirstChild("MainGui");

    if not u16 then
        warn("[UseItemFrame] MainGui not found");

        return false;
    end;

    local Menu = u16:FindFirstChild("Menu");

    if not Menu then
        warn("[UseItemFrame] Menu frame not found");

        return false;
    end;

    u12 = Menu:FindFirstChild("UseItemFrame");

    if not u12 then
        warn("[UseItemFrame] UseItemFrame not found in Menu");

        return false;
    end;

    local Tabs = u12:FindFirstChild("Tabs");
    local v68 = Tabs and Tabs:FindFirstChild("Inventory");

    if v68 then
        u13 = v68:FindFirstChild("Container");
        u17 = v68:FindFirstChild("Sort");
    end;

    Collections.ObserveAvailableCollections(function(p69) -- Line: 366
        -- upvalues: u7 (ref)
        u7 = p69;
    end);

    if u17 then
        local Button = u17:FindFirstChild("Button");

        if Button then
            local TextLabel = Button:FindFirstChild("Frame"):FindFirstChild("TextLabel");

            if TextLabel then
                TextLabel.Text = "Newest";
                u8 = "Newest";
            end;

            Button.MouseButton1Click:Connect(function() -- Line: 381
                -- upvalues: Button (copy), Router (ref)
                local Options = Button:FindFirstChild("Options");

                if Options then
                    Options.Visible = not Options.Visible;
                    Router.broadcastRouter("RunInterfaceSound", "UI Click");
                end;
            end);
            local Options = Button:FindFirstChild("Options");
            local TextLabel2 = Button:FindFirstChild("Frame"):FindFirstChild("TextLabel");

            if Options and TextLabel2 then
                for _, v in { "Alphabetical", "Collection", "Equipped", "Newest", "Quality", "Type", "Float" } do
                    local v70 = Options:FindFirstChild(v);

                    if v70 then
                        AnimateSortButton(Options, v70, nil, v, TextLabel2, u13);
                    end;
                end;
            end;
        end;

        local ReverseSort = u17:FindFirstChild("ReverseSort");

        if ReverseSort then
            local u71 = ReverseSort:FindFirstChildOfClass("ImageLabel");

            local function handleReverseSortButtonClick() -- Line: 412
                -- upvalues: u9 (ref), u71 (copy), u1 (ref), Router (ref)
                u9 = not u9;

                if u71 then
                    u71.Rotation = u9 and 180 or 0;
                end;

                u1.PopulateItems();
                Router.broadcastRouter("RunInterfaceSound", "UI Click");
            end;

            ReverseSort.Selectable = true;
            ReverseSort.MouseButton1Click:Connect(handleReverseSortButtonClick);
            ReverseSort.Activated:Connect(function(p72) -- Line: 424
                -- upvalues: u9 (ref), u71 (copy), u1 (ref), Router (ref)
                if p72 and p72.UserInputType == Enum.UserInputType.Gamepad1 then
                    u9 = not u9;

                    if u71 then
                        u71.Rotation = u9 and 180 or 0;
                    end;

                    u1.PopulateItems();
                    Router.broadcastRouter("RunInterfaceSound", "UI Click");
                end;
            end);
        end;
    end;

    Collections.ObserveAvailableCollections(function(p73) -- Line: 433
        -- upvalues: u7 (ref)
        u7 = p73;
    end);
    local Top = u12:FindFirstChild("Top");

    if Top then
        u14 = Top:FindFirstChild("TextLabel");
        u15 = Top:FindFirstChild("Close");

        if not u15 then
            return;
        end;

        CloseButtonRegistry.Add(u12, u15, function() -- Line: 447
            -- upvalues: Router (ref), u1 (ref), u2 (ref)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            u1.OnClosed:Fire(u2);
            u1.Hide();
        end);
    end;

    Collections.ObserveAvailableCollections(function(p74) -- Line: 455
        -- upvalues: u7 (ref)
        u7 = p74;
    end);
    DataController.CreateListener(LocalPlayer, "Inventory", function(p75) -- Line: 460
        -- upvalues: u1 (ref)
        if u1.IsVisible() then
            u1.PopulateItems();
        end;
    end);
    MenuState.OnScreenChanged:Connect(function(p76, p77) -- Line: 467
        -- upvalues: u1 (ref), u2 (ref)
        if u1.IsVisible() then
            u1.OnClosed:Fire(u2);
            u1.Hide();
        end;
    end);
    MenuState.OnInspectStateChanged:Connect(function(p78) -- Line: 475
        -- upvalues: u1 (ref), u2 (ref)
        if p78 and u1.IsVisible() then
            u1.OnClosed:Fire(u2);
            u1.Hide();
        end;
    end);
    MenuState.OnCaseSceneStateChanged:Connect(function(p79) -- Line: 483
        -- upvalues: u1 (ref), u2 (ref)
        if p79 and u1.IsVisible() then
            u1.OnClosed:Fire(u2);
            u1.Hide();
        end;
    end);

    if u13 then
        u13:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- Line: 492
            -- upvalues: UseItemFrameOnScrollPositionChanged (ref)
            UseItemFrameOnScrollPositionChanged();
        end);
    end;

    u5 = true;

    return true;
end;

function u1.CreateItemTemplate(u80, u81) -- Line: 504
    -- upvalues: u13 (ref), Cases (copy), GetResolvedSkinInformation (copy), Rarities (copy), Skins (copy), ReplicatedStorage (copy), Router (copy), u4 (ref), u6 (ref), AnimateButton (copy)
    if not (u80 and u80._id) then
        return;
    end;

    if not u13 then
        return;
    end;

    local v82 = u80.Type == "Case";
    local v83 = v82 and Cases.GetCaseByName(u80.Skin) or GetResolvedSkinInformation(u80.Name, u80.Skin);

    if not v83 then
        return;
    end;

    local v84 = Rarities[v82 and v83.caseRarity or v83.rarity];
    local v85 = nil;

    if v82 then
        v85 = v83.imageAssetId or "";
    elseif u80.Type == "Charm" then
        local Pattern = u80.Pattern;

        if Pattern and v83.charmImages then
            for _, v in ipairs(v83.charmImages) do
                if v.pattern == Pattern then
                    v85 = v.assetId;
                    break;
                end;
            end;
        end;

        if not v85 then
            v85 = v83.imageAssetId or "";
        end;
    else
        v85 = Skins.GetWearImageForFloat(v83, u80.Float or 0.9999) or (v83.imageAssetId or "");
    end;

    local u86 = ReplicatedStorage.Assets.UI.Inventory.ItemTemplate:Clone();
    u86.ItemContent.Rarity.BackgroundColor3 = v84.Color;
    u86.Parent = u13;
    u86.ItemContent.Content.Icon.Image = v85;
    u86.Name = u80._id;
    local Charm = u86.ItemContent:FindFirstChild("Charm");

    if Charm and Charm:IsA("ImageLabel") then
        Charm.Visible = false;
        Charm.Image = "";
    end;

    u86.Bottom.Footer.WeaponName.Text = u80.StatTrack and "KillTrak™ " .. u80.Name or u80.Name;
    u86.Bottom.Footer.SkinName.Text = v82 and v83.skin or u80.Skin;

    if u80.Type == "Charm" then
        u86.MouseButton2Click:Connect(function() -- Line: 580
            -- upvalues: Router (ref), u80 (copy)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            Router.broadcastRouter("WeaponInspect", u80.Name, u80.Skin, u80.Float, u80.StatTrack, u80.NameTag, u80.Charm, u80.Stickers, u80.Type, u80.Pattern, u80._id, u80.Serial, u80.IsTradeable);
        end);
    end;

    u86.MouseButton1Click:Connect(function() -- Line: 602
        -- upvalues: Router (ref), u81 (copy), u80 (copy)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        u81(u80);
    end);
    u86.MouseEnter:Connect(function() -- Line: 608
        -- upvalues: u4 (ref), u86 (copy), u6 (ref)
        u4 = u86;
        u6 = tick();
    end);
    u86.MouseLeave:Connect(function() -- Line: 614
        -- upvalues: u4 (ref), u6 (ref)
        u4 = nil;
        u6 = nil;
    end);
    AnimateButton(u86);
end;

function u1.PopulateItems() -- Line: 625
    -- upvalues: u13 (ref), ClearFrame (copy), u11 (ref), u10 (ref), DataController (copy), LocalPlayer (copy), Grenades (copy), u3 (ref), u2 (ref), Collections (copy), u7 (ref), u8 (ref), u17 (ref), Sort (copy), u9 (ref), u1 (copy), CalculateUseItemFrameInitialRenderCount (copy)
    if not u13 then
        return;
    end;

    ClearFrame(u13, "Frame");
    u11 = 0;
    u10 = {};
    local v87 = DataController.Get(LocalPlayer, "Inventory");

    if not v87 or type(v87) ~= "table" then
        return;
    end;

    for _, v in ipairs(v87) do
        local v88;

        if v then
            v88 = Grenades[v.Name];
        else
            v88 = v;
        end;

        local v89;

        if v then
            v89 = v.Type == "Case";
        else
            v89 = v;
        end;

        if v and (v._id and v.Name) and (v89 or v.Skin) and not (v88 or v89) and (not (u3 and u2) or u3(v, u2)) then
            table.insert(u10, v);
        end;
    end;

    Collections.ObserveAvailableCollections(function(p90) -- Line: 669
        -- upvalues: u7 (ref)
        u7 = p90;
    end);
    local u91 = Sort.GetSortComparisonFunction(u8 or u17 and u17.Button.Frame.TextLabel.Text or "Newest", LocalPlayer, function() -- Line: 675
        -- upvalues: u7 (ref)
        return u7;
    end);

    if u91 then
        if u9 then
            table.sort(u10, function(p92, p93) -- Line: 682
                -- upvalues: u91 (copy)
                local v94, v95 = u91(p92, p93);

                if v95 then
                    return v94;
                end;

                return u91(p93, p92);
            end);
        else
            table.sort(u10, u91);
        end;
    end;

    local function v97(p96) -- Line: 698
        -- upvalues: u2 (ref), u1 (ref)
        if u2 then
            u1.OnItemSelected:Fire(p96, u2);
            u1.Hide();
        end;
    end;

    Collections.ObserveAvailableCollections(function(p98) -- Line: 708
        -- upvalues: u7 (ref)
        u7 = p98;
    end);
    local v99 = CalculateUseItemFrameInitialRenderCount();
    local v100 = math.max(v99, 50);
    local v101 = math.min(v100, #u10);

    for i = 1, v101 do
        local v102 = u10[i];

        if v102 then
            u1.CreateItemTemplate(v102, v97);
        end;
    end;

    Collections.ObserveAvailableCollections(function(p103) -- Line: 726
        -- upvalues: u7 (ref)
        u7 = p103;
    end);
    u11 = v101;
end;

function u1.Show(p104, p105) -- Line: 735
    -- upvalues: EnsureInitialized (copy), u12 (ref), u2 (ref), u3 (ref), u14 (ref), Collections (copy), u7 (ref), u1 (copy)
    if not EnsureInitialized() then
        warn("[UseItemFrame] Failed to initialize");

        return;
    end;

    if not u12 then
        return;
    end;

    u2 = p104;
    u3 = p105;

    if u14 then
        if p104.SourceItem then
            local SourceItem = p104.SourceItem;
            local Name = SourceItem.Name;

            if SourceItem.StatTrack then
                Name = "KillTrak™ " .. Name;
            end;

            if SourceItem.Skin then
                Name = Name .. " | " .. SourceItem.Skin;
            end;

            u14.Text = `Select an item to use with {Name}`;
        elseif p104.Title then
            u14.Text = p104.Title;
        else
            u14.Text = "Select an item";
        end;
    end;

    Collections.ObserveAvailableCollections(function(p106) -- Line: 775
        -- upvalues: u7 (ref)
        u7 = p106;
    end);
    u1.PopulateItems();
    u12.Visible = true;
end;

function u1.Hide() -- Line: 788
    -- upvalues: u12 (ref), u2 (ref), u3 (ref)
    if u12 then
        u12.Visible = false;
    end;

    u2 = nil;
    u3 = nil;
end;

function u1.IsVisible() -- Line: 800
    -- upvalues: u12 (ref)
    return u12 and u12.Visible or false;
end;

function u1.GetCurrentContext() -- Line: 806
    -- upvalues: u2 (ref)
    return u2;
end;

u1.Filters = {};

function u1.Filters.WeaponsWithoutCharm(p107, p108) -- Line: 816
    if p107.Type ~= "Weapon" then
        return false;
    end;

    local v109;

    if p107.Charm == nil or p107.Charm == false then
        v109 = false;
    else
        v109 = (type(p107.Charm) == "string" or p107.Charm == true) and true or type(p107.Charm) == "table";
    end;

    return not v109;
end;

function u1.Filters.AllCharms(p110, p111) -- Line: 829
    -- upvalues: DataController (copy), LocalPlayer (copy), Collections (copy), u7 (ref)
    if p110.Type ~= "Charm" then
        return false;
    end;

    local v112 = DataController.Get(LocalPlayer, "Inventory");

    if v112 then
        for _, v in ipairs(v112) do
            if v.Charm then
                local v113 = type(v.Charm) == "table" and v.Charm._id;

                if not v113 then
                    if type(v.Charm) == "string" then
                        v113 = v.Charm;
                    else
                        v113 = false;
                    end;
                end;

                if v113 == p110._id then
                    return false;
                end;
            end;
        end;
    end;

    Collections.ObserveAvailableCollections(function(p114) -- Line: 849
        -- upvalues: u7 (ref)
        u7 = p114;
    end);

    return true;
end;

function u1.Filters.AllWeapons(p115, p116) -- Line: 857
    return p115.Type == "Weapon";
end;

function u1.Filters.AllMelees(p117, p118) -- Line: 862
    return p117.Type == "Melee";
end;

function u1.Filters.AllGloves(p119, p120) -- Line: 867
    return p119.Type == "Glove";
end;

function u1.Initialize(p121, p122) -- Line: 877
    -- upvalues: u16 (ref), u12 (ref), u13 (ref), u17 (ref), Collections (copy), u7 (ref), u8 (ref), Router (copy), AnimateSortButton (copy), u14 (ref), u15 (ref), CloseButtonRegistry (copy), u1 (copy), u2 (ref), UseItemFrameOnScrollPositionChanged (copy), u5 (ref)
    u16 = p121;
    u12 = p122;
    local Tabs = p122:FindFirstChild("Tabs");
    local v123 = Tabs and Tabs:FindFirstChild("Inventory");

    if v123 then
        u13 = v123:FindFirstChild("Container");
        u17 = v123:FindFirstChild("Sort");
    end;

    Collections.ObserveAvailableCollections(function(p124) -- Line: 893
        -- upvalues: u7 (ref)
        u7 = p124;
    end);

    if u17 then
        local Button = u17:FindFirstChild("Button");

        if Button then
            local TextLabel = Button:FindFirstChild("Frame"):FindFirstChild("TextLabel");

            if TextLabel then
                TextLabel.Text = "Newest";
                u8 = "Newest";
            end;

            Button.MouseButton1Click:Connect(function() -- Line: 908
                -- upvalues: Button (copy), Router (ref)
                local Options = Button:FindFirstChild("Options");

                if Options then
                    Options.Visible = not Options.Visible;
                    Router.broadcastRouter("RunInterfaceSound", "UI Click");
                end;
            end);
            local Options = Button:FindFirstChild("Options");
            local TextLabel2 = Button:FindFirstChild("Frame"):FindFirstChild("TextLabel");

            if Options and TextLabel2 then
                for _, v in { "Alphabetical", "Collection", "Equipped", "Newest", "Quality", "Type", "Float" } do
                    local v125 = Options:FindFirstChild(v);

                    if v125 then
                        AnimateSortButton(Options, v125, nil, v, TextLabel2, u13);
                    end;
                end;
            end;
        end;
    end;

    Collections.ObserveAvailableCollections(function(p126) -- Line: 938
        -- upvalues: u7 (ref)
        u7 = p126;
    end);
    local Top = p122:FindFirstChild("Top");

    if Top then
        u14 = Top:FindFirstChild("TextLabel");
        u15 = Top:FindFirstChild("Close");

        if not u15 then
            return;
        end;

        CloseButtonRegistry.Add(u12, u15, function() -- Line: 951
            -- upvalues: Router (ref), u1 (ref), u2 (ref)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            u1.OnClosed:Fire(u2);
            u1.Hide();
        end);
    end;

    Collections.ObserveAvailableCollections(function(p127) -- Line: 959
        -- upvalues: u7 (ref)
        u7 = p127;
    end);

    if u13 then
        u13:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- Line: 965
            -- upvalues: UseItemFrameOnScrollPositionChanged (ref)
            UseItemFrameOnScrollPositionChanged();
        end);
    end;

    p122.Visible = false;
    u5 = true;
end;

function u1.Start() -- Line: 977
    -- upvalues: Actions (copy), DataController (copy), LocalPlayer (copy), u1 (copy), MenuState (copy), u2 (ref)
    Actions.InitializeAll();
    DataController.CreateListener(LocalPlayer, "Inventory", function(p128) -- Line: 982
        -- upvalues: u1 (ref)
        if u1.IsVisible() then
            u1.PopulateItems();
        end;
    end);
    MenuState.OnScreenChanged:Connect(function(p129, p130) -- Line: 989
        -- upvalues: u1 (ref), u2 (ref)
        if u1.IsVisible() then
            u1.OnClosed:Fire(u2);
            u1.Hide();
        end;
    end);
    MenuState.OnInspectStateChanged:Connect(function(p131) -- Line: 998
        -- upvalues: u1 (ref), u2 (ref)
        if p131 and u1.IsVisible() then
            u1.OnClosed:Fire(u2);
            u1.Hide();
        end;
    end);
    MenuState.OnCaseSceneStateChanged:Connect(function(p132) -- Line: 1006
        -- upvalues: u1 (ref), u2 (ref)
        if p132 and u1.IsVisible() then
            u1.OnClosed:Fire(u2);
            u1.Hide();
        end;
    end);
end;

function u1.TriggerAction(p133, p134) -- Line: 1017
    -- upvalues: Actions (copy), u1 (copy)
    local v135 = Actions.Get(p133);

    if not v135 then
        warn((`[UseItemFrame] Unknown action type: {p133}`));

        return;
    end;

    local v136 = v135.GetContext(p134);
    local v137 = v135.GetFilter(p134);
    u1.Show(v136, v137);
end;

function u1.GetActions() -- Line: 1033
    -- upvalues: Actions (copy)
    return Actions;
end;

return u1;