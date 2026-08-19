-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
game:GetService("InsertService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local Settings = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("UI"):WaitForChild("Settings");
local DataController = require(ReplicatedStorage.Controllers.DataController);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Pages = require(ReplicatedStorage.Database.Custom.GameStats.UI.Settings.Pages);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local EditMobile = require(ReplicatedStorage.Interface.Screens.Menu.Dashboard.EditMobile);
local CrosshairPreview = require(script.Templates.CrosshairPreview);
local Dropdown = require(script.Templates.Dropdown);
local Keybind = require(script.Templates.Keybind);
local Number = require(script.Templates.Number);
local Toggle = require(script.Templates.Toggle);
local Slider = require(script.Templates.Slider);
TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
Color3.fromRGB(34, 38, 47);
local u2 = Color3.fromRGB(34, 38, 47);
local u3 = Color3.fromRGB(125, 206, 243);
local u4 = { "Keyboard & Mouse Settings", "Movement Keys", "Weapon Keys", "UI Keys", "Communication Options" };
local u5 = { "Item", "HUD", "Crosshair", "Viewmodel", "Radar/Tablet", "Other" };
local u6 = { "Audio", "Music", "Voice Chat", "Other" };
local u7 = {
    Video = "Video",
    Audio = "Audio",
    Game = "Game",
    Keybinds = "Keyboard/Mouse"
};
local u8 = {
    Video = "Video",
    Audio = "Audio",
    Game = "Game",
    ["Keyboard/Mouse"] = "Keybinds"
};
local u9 = nil;
local u10 = {};
local u11 = {};
local u12 = {};
local u13 = {};
local u14 = {};
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = nil;
local u19 = nil;
local u20 = 0;
local u21 = "Video";
local u22 = {
    CrosshairPreviewTemplate = nil,
    DropdownTemplate = nil,
    KeybindTemplate = nil,
    NumberTemplate = nil,
    ToggleTemplate = nil,
    SliderTemplate = nil
};

local function DeepEqual(p23, p24) -- Line: 178
    -- upvalues: DeepEqual (copy)
    if p23 == p24 then
        return true;
    end;

    if type(p23) ~= type(p24) then
        return false;
    end;

    if type(p23) ~= "table" then
        return false;
    end;

    local v25 = {};

    for i, v in pairs(p23) do
        if not DeepEqual(v, p24[i]) then
            return false;
        end;

        v25[i] = true;
    end;

    for i in pairs(p24) do
        if not v25[i] then
            return false;
        end;
    end;

    return true;
end;

local function GetDatabasePageName(p26) -- Line: 215
    -- upvalues: u7 (copy)
    return u7[p26] or p26;
end;

local function _GetUIPageName(p27) -- Line: 222
    -- upvalues: u8 (copy)
    return u8[p27] or p27;
end;

local function BuildSettingPath(p28, p29, p30) -- Line: 233
    -- upvalues: u7 (copy)
    return `Settings.{u7[p28] or p28}.{p29}.{p30}`;
end;

local function RegisterSettingMetadata(p31, p32, p33) -- Line: 241
    -- upvalues: u7 (copy), u12 (copy)
    u12[p33] = {
        pageName = p31,
        categoryName = p32,
        settingName = p33,
        settingPath = `Settings.{u7[p31] or p31}.{p32}.{p33}`
    };
end;

local function ClearContainer(p34) -- Line: 255
    -- upvalues: u21 (ref), u13 (copy), u14 (copy), u9 (ref)
    local v35 = u21;

    if u13[v35] then
        u13[v35]:Cleanup();
        u13[v35] = nil;
    end;

    if v35 == "Keybinds" then
        table.clear(u14);
        u9 = nil;
    end;

    for _, child in ipairs(p34:GetChildren()) do
        if child:IsA("GuiObject") and (child.Name ~= "Header" and child.Name ~= "Title") then
            child:Destroy();
        end;
    end;
end;

local function GetSettingValue(p36, u37) -- Line: 283
    -- upvalues: u15 (ref), u7 (copy)
    if not u15 then
        return nil;
    end;

    local v38 = u15[u7[p36] or p36];

    if not v38 then
        return nil;
    end;

    local function searchInTable(p39) -- Line: 297
        -- upvalues: u37 (copy), searchInTable (copy)
        for i, v in pairs(p39) do
            if i == u37 then
                return v;
            end;

            if type(v) == "table" then
                local v40 = searchInTable(v);

                if v40 ~= nil then
                    return v40;
                end;
            end;
        end;

        return nil;
    end;

    return searchInTable(v38);
end;

local function CreateCategoryHeader(p41, p42, p43) -- Line: 317
    -- upvalues: u3 (copy)
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = `Category_{p41}`;
    TextLabel.Text = string.upper(p41);
    TextLabel.Font = Enum.Font.GothamBold;
    TextLabel.TextSize = 14;
    TextLabel.TextColor3 = u3;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Size = UDim2.new(1, 0, 0, 35);
    TextLabel.LayoutOrder = p43;
    TextLabel.Parent = p42;

    return TextLabel;
end;

local function CreateDivider(p44, p45) -- Line: 336
    -- upvalues: Settings (copy)
    local v46 = Settings:WaitForChild("Divider"):Clone();
    v46.LayoutOrder = p45;
    v46.Parent = p44;

    return v46;
end;

local function UpdateCanvasSize(p47) -- Line: 346
    local v48 = p47:FindFirstChildOfClass("UIListLayout");

    if v48 then
        p47.CanvasSize = UDim2.new(0, 0, 0, v48.AbsoluteContentSize.Y + 50);
    end;
end;

local function CheckKeybindConflict(p49, p50, p51) -- Line: 357
    -- upvalues: u14 (copy)
    if p49 == "" or p49 == "None" then
        return nil;
    end;

    local v52 = u14[`{p51}:{p49}`];

    if v52 and v52 ~= p50 then
        return v52;
    end;

    return nil;
end;

local function RegisterKeybind(p53, p54, p55) -- Line: 375
    -- upvalues: u14 (copy)
    if p53 == "" or p53 == "None" then
        return;
    end;

    u14[`{p55}:{p53}`] = p54;
end;

local function UnregisterKeybind(p56, p57) -- Line: 387
    -- upvalues: u14 (copy)
    if p56 == "" or p56 == "None" then
        return;
    end;

    u14[`{p57}:{p56}`] = nil;
end;

local function GetKeybindPlatformFrame(p58, p59) -- Line: 396
    local Right = p58:FindFirstChild("Right");

    if not (Right and Right:IsA("Frame")) then
        return nil;
    end;

    local v60 = Right:FindFirstChild(p59);

    if v60 and v60:IsA("Frame") then
        return v60;
    end;

    return nil;
end;

local function GetKeybindSettingTemplate(p61) -- Line: 410
    -- upvalues: u11 (copy)
    local Parent = p61.Parent;

    if not Parent or Parent.Name ~= "Right" then
        return nil;
    end;

    local Parent2 = Parent.Parent;

    if not (Parent2 and Parent2:IsA("GuiObject")) then
        return nil;
    end;

    local Keybinds = u11.Keybinds;

    if Keybinds and Keybinds[Parent2.Name] == Parent2 then
        return Parent2;
    end;

    return nil;
end;

local function HighlightReplacedKeybind(p62, p63) -- Line: 433
    -- upvalues: u11 (copy)
    if not (u11.Keybinds and u11.Keybinds[p62]) then
        return;
    end;

    local Right = u11.Keybinds[p62]:FindFirstChild("Right");
    local v64;

    if Right and Right:IsA("Frame") then
        v64 = Right:FindFirstChild(p63);

        if not (v64 and v64:IsA("Frame")) then
            v64 = nil;
        end;
    else
        v64 = nil;
    end;

    if not (v64 and v64.TextBox) then
        return;
    end;

    v64.TextBox.TextColor3 = Color3.fromRGB(255, 90, 90);
end;

local function ClearKeybindHighlight(p65, p66) -- Line: 455
    -- upvalues: u11 (copy), TweenService (copy), u2 (copy)
    if not (u11.Keybinds and u11.Keybinds[p65]) then
        return;
    end;

    local Right = u11.Keybinds[p65]:FindFirstChild("Right");
    local v67;

    if Right and Right:IsA("Frame") then
        v67 = Right:FindFirstChild(p66);

        if not (v67 and v67:IsA("Frame")) then
            v67 = nil;
        end;
    else
        v67 = nil;
    end;

    if not (v67 and v67.TextBox) then
        return;
    end;

    TweenService:Create(v67.TextBox, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextColor3 = u2
    }):Play();
end;

local function ScrollToTemplate(p68) -- Line: 477
    -- upvalues: u11 (copy), TweenService (copy)
    if not (u11.Keybinds and u11.Keybinds[p68]) then
        return;
    end;

    local v69 = u11.Keybinds[p68];
    local Parent = v69.Parent;

    if not (Parent and Parent:IsA("ScrollingFrame")) then
        return;
    end;

    local Y = Parent.AbsoluteSize.Y;
    local v70 = math.max(0, v69.AbsolutePosition.Y - Parent.AbsolutePosition.Y + Parent.CanvasPosition.Y - Y / 2 + v69.AbsoluteSize.Y / 2);
    local v71 = math.min(v70, Parent.CanvasSize.Y.Offset - Y);
    TweenService:Create(Parent, TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        CanvasPosition = Vector2.new(0, v71)
    }):Play();
end;

local function SwapKeybinds(u72, u73, p74, p75) -- Line: 509
    -- upvalues: u15 (ref), u7 (copy), u1 (copy), u14 (copy), u11 (copy), HighlightReplacedKeybind (copy), ScrollToTemplate (copy)
    local v76;

    if u15 then
        local v77 = u15[u7.Keybinds or "Keybinds"];

        if v77 then
            local function u80(p78) -- Line: 297
                -- upvalues: u72 (copy), u80 (copy)
                for i, v in pairs(p78) do
                    if i == u72 then
                        return v;
                    end;

                    if type(v) == "table" then
                        local v79 = u80(v);

                        if v79 ~= nil then
                            return v79;
                        end;
                    end;
                end;

                return nil;
            end;

            v76 = u80(v77);
        else
            v76 = nil;
        end;
    else
        v76 = nil;
    end;

    local v81 = v76 or {};
    local v82;

    if type(v81) == "table" then
        v82 = v81[p75];
    else
        v82 = nil;
    end;

    local v83;

    if u15 then
        local v84 = u15[u7.Keybinds or "Keybinds"];

        if v84 then
            local function u87(p85) -- Line: 297
                -- upvalues: u73 (copy), u87 (copy)
                for i, v in pairs(p85) do
                    if i == u73 then
                        return v;
                    end;

                    if type(v) == "table" then
                        local v86 = u87(v);

                        if v86 ~= nil then
                            return v86;
                        end;
                    end;
                end;

                return nil;
            end;

            v83 = u87(v84);
        else
            v83 = nil;
        end;
    else
        v83 = nil;
    end;

    local v88 = v83 or {};
    local v89 = type(v88) ~= "table" and {} or v88;
    v89[p75] = v82 or "";
    u1.SettingChanged("Keybinds", u73, v89);

    if p74 ~= "" and p74 ~= "None" then
        u14[`{p75}:{p74}`] = nil;
    end;

    if v82 and (v82 ~= "" and (v82 ~= "" and v82 ~= "None")) then
        u14[`{p75}:{v82}`] = u73;
    end;

    if u11.Keybinds and u11.Keybinds[u73] then
        local Right = u11.Keybinds[u73]:FindFirstChild("Right");
        local v90;

        if Right and Right:IsA("Frame") then
            v90 = Right:FindFirstChild(p75);

            if not (v90 and v90:IsA("Frame")) then
                v90 = nil;
            end;
        else
            v90 = nil;
        end;

        if v90 and v90.TextBox then
            v90.TextBox.Text = v82 and v82 ~= "" and (v82:gsub("Enum%.KeyCode%.", ""):gsub("Enum%.UserInputType%.", ""):gsub("Enum%.CustomInputType%.", "") or "None") or "None";
        end;
    end;

    HighlightReplacedKeybind(u72, p75);
    HighlightReplacedKeybind(u73, p75);
    ScrollToTemplate(u73);
end;

local function ReenableScrolling() -- Line: 560
    -- upvalues: u21 (ref), u17 (ref)
    if u21 == "Keybinds" then
        local Keybinds = u17.Frame.List:FindFirstChild("Keybinds");
        local v91 = Keybinds and Keybinds.Bottom.Scroll;

        if v91 then
            v91.ScrollingEnabled = true;
        end;
    end;
end;

local function HandleKeybindCapture(p92, p93) -- Line: 575
    -- upvalues: u19 (ref), u11 (copy), u16 (ref), u21 (ref), u17 (ref), u14 (copy), u15 (ref), u7 (copy), u2 (copy), ClearKeybindHighlight (copy), u1 (copy), SwapKeybinds (copy)
    if not u19 then
        return;
    end;

    local Parent = p92.Parent;
    local v94;

    if Parent and Parent.Name == "Right" then
        v94 = Parent.Parent;

        if v94 and v94:IsA("GuiObject") then
            local Keybinds = u11.Keybinds;

            if not Keybinds or Keybinds[v94.Name] ~= v94 then
                v94 = nil;
            end;
        else
            v94 = nil;
        end;
    else
        v94 = nil;
    end;

    if not v94 then
        u19:ReleaseFocus();
        u16 = nil;
        u19 = nil;

        if u21 == "Keybinds" then
            local Keybinds = u17.Frame.List:FindFirstChild("Keybinds");
            local v95 = Keybinds and Keybinds.Bottom.Scroll;

            if v95 then
                v95.ScrollingEnabled = true;
            end;
        end;

        return;
    end;

    local Name = v94.Name;
    local Name2 = p92.Name;
    local v96;

    if p93 == "" or p93 == "None" then
        v96 = nil;
    else
        v96 = u14[`{Name2}:{p93}`];

        if not v96 or v96 == Name then
            v96 = nil;
        end;
    end;

    local v97 = v96 ~= nil;
    local v98 = u21;
    local v99;

    if u15 then
        local v100 = u15[u7[v98] or v98];

        if v100 then
            local function u103(p101) -- Line: 297
                -- upvalues: Name (copy), u103 (copy)
                for i, v in pairs(p101) do
                    if i == Name then
                        return v;
                    end;

                    if type(v) == "table" then
                        local v102 = u103(v);

                        if v102 ~= nil then
                            return v102;
                        end;
                    end;
                end;

                return nil;
            end;

            v99 = u103(v100);
        else
            v99 = nil;
        end;
    else
        v99 = nil;
    end;

    local v104 = v99 or {};
    local v105 = {
        Computer = type(v104) ~= "table" and "" or v104.Computer,
        Console = type(v104) ~= "table" and "" or v104.Console
    };
    local v106 = v105[Name2];

    if v106 and (v106 ~= "" and (v106 ~= "" and v106 ~= "None")) then
        u14[`{Name2}:{v106}`] = nil;
    end;

    v105[Name2] = p93;

    if p93 ~= "" and p93 ~= "None" then
        u14[`{Name2}:{p93}`] = Name;
    end;

    u19.Text = p93:gsub("Enum%.KeyCode%.", ""):gsub("Enum%.UserInputType%.", ""):gsub("Enum%.CustomInputType%.", "");
    local Reset = p92:FindFirstChild("Reset");

    if Reset then
        Reset.Visible = true;
    end;

    if v97 then
        u19.TextColor3 = Color3.fromRGB(255, 90, 90);
    else
        u19.TextColor3 = u2;
        ClearKeybindHighlight(Name, Name2);
    end;

    u1.SettingChanged(u21, Name, v105, false, v97);

    if v97 and v96 then
        SwapKeybinds(Name, v96, p93, Name2);
    end;

    u19:ReleaseFocus();
    u16 = nil;
    u19 = nil;

    if u21 == "Keybinds" then
        local Keybinds = u17.Frame.List:FindFirstChild("Keybinds");
        local v107 = Keybinds and Keybinds.Bottom.Scroll;

        if v107 then
            v107.ScrollingEnabled = true;
        end;
    end;
end;

local function CancelKeybindListening() -- Line: 653
    -- upvalues: u19 (ref), u16 (ref), u2 (copy), u21 (ref), u17 (ref)
    if not u19 then
        return;
    end;

    u19.Text = u16 or "None";
    u19.TextColor3 = u2;
    u19:ReleaseFocus();
    u16 = nil;
    u19 = nil;

    if u21 == "Keybinds" then
        local Keybinds = u17.Frame.List:FindFirstChild("Keybinds");
        local v108 = Keybinds and Keybinds.Bottom.Scroll;

        if v108 then
            v108.ScrollingEnabled = true;
        end;
    end;
end;

local function AddToHistory(p109, p110, p111) -- Line: 669
    -- upvalues: u10 (copy)
    table.insert(u10, {
        path = p109,
        oldValue = p110,
        newValue = p111
    });

    while #u10 > 50 do
        table.remove(u10, 1);
    end;
end;

function u1.RenderPage(p112) -- Line: 688
    -- upvalues: Profiler (copy), Pages (copy), u17 (ref), ClearContainer (copy), u4 (copy), u5 (copy), u6 (copy), u11 (copy), u13 (copy), Janitor (copy), CreateCategoryHeader (copy), GetUserPlatform (copy), u7 (copy), u12 (copy), u22 (copy), CrosshairPreview (copy), u15 (ref), u21 (ref), Toggle (copy), u1 (copy), Number (copy), Slider (copy), Dropdown (copy), Settings (copy), u18 (ref), u14 (copy), u9 (ref), Keybind (copy), u19 (ref), u16 (ref), u20 (ref), u3 (copy), HighlightReplacedKeybind (copy)
    Profiler.mark((`UI.Settings.RenderPage.{p112}`));

    if not Pages.GetPage(p112) then
        warn((`[Settings] Page '{p112}' not found in configuration`));

        return;
    end;

    local v113 = u17.Frame.List:FindFirstChild(p112);

    if not v113 then
        warn((`[Settings] Page frame '{p112}' not found in UI`));

        return;
    end;

    local Scroll = v113.Bottom.Scroll;
    ClearContainer(Scroll);
    local Header = v113.Header.Heading.Header;

    if Header then
        Header.Text = string.upper(p112) .. " SETTINGS";
    end;

    local Title = v113.Header.Title;

    if Title then
        Title.Text = Pages.Descriptions[p112] or "";
    end;

    local v114 = Pages.GetCategories(p112);

    if p112 == "Keybinds" then
        table.sort(v114, function(p115, p116) -- Line: 722
            -- upvalues: u4 (ref)
            return (table.find(u4, p115) or 999) < (table.find(u4, p116) or 999);
        end);
    elseif p112 == "Game" then
        table.sort(v114, function(p117, p118) -- Line: 728
            -- upvalues: u5 (ref)
            return (table.find(u5, p117) or 999) < (table.find(u5, p118) or 999);
        end);
    elseif p112 == "Audio" then
        table.sort(v114, function(p119, p120) -- Line: 734
            -- upvalues: u6 (ref)
            return (table.find(u6, p119) or 999) < (table.find(u6, p120) or 999);
        end);
    end;

    u11[p112] = {};

    if not u13[p112] then
        u13[p112] = Janitor.new();
    end;

    local v121 = 0;

    for _, v in ipairs(v114) do
        CreateCategoryHeader(v, Scroll, v121);
        v121 = v121 + 1;
        local v122 = Pages.GetCategory(p112, v);
        local v123 = {};

        for i, v2 in pairs(v122) do
            if not i:match("^_Divider_") then
                table.insert(v123, {
                    name = i,
                    config = v2
                });
            end;
        end;

        table.sort(v123, function(p124, p125) -- Line: 769
            local v126 = p124.config.Order or 999;
            local v127 = p125.config.Order or 999;

            if v126 == v127 then
                return p124.name < p125.name;
            end;

            return v126 < v127;
        end);

        for _, v2 in ipairs(v123) do
            local config = v2.config;
            local name = v2.name;
            local v128 = nil;
            local v129 = nil;
            local v130, v131, v132, u133, v134, v135, v136, u137, v138, v139, v140, v141, u142, v143, v144, v145, v146, u147, v148, v149, v150, u151, v152, v153, v154, u155, v156, v157, v158, v159, v160;

            if config.Platform then
                local v161 = GetUserPlatform();

                if table.find(v161, config.Platform) ~= nil then
                    u12[name] = {
                        pageName = p112,
                        categoryName = v,
                        settingName = name,
                        settingPath = `Settings.{u7[p112] or p112}.{v}.{name}`
                    };

                    if config.Type == "CrosshairPreview" then
                        if u22.CrosshairPreviewTemplate then
                            v128 = u22.CrosshairPreviewTemplate:Clone();
                            v129 = CrosshairPreview(Scroll, v121, v128, u17.Share, function() -- Line: 810
                                -- upvalues: u15 (ref)
                                return u15 and u15.Game and u15.Game.Crosshair;
                            end, function() -- Line: 813
                            end, function() -- Line: 816
                            end, function() -- Line: 819
                            end);
                            v121 = v121 + 1;

                            if v128 then
                                u11[p112][name] = v128;
                            end;

                            if v129 then
                                u13[p112]:Add(v129, true, (`Template_{name}`));
                            end;

                            v130 = Settings:WaitForChild("Divider"):Clone();
                            v130.LayoutOrder = v121;
                            v130.Parent = Scroll;
                            v121 = v121 + 1;
                        end;

                        warn("[Settings] CrosshairPreviewTemplate not loaded");
                    else
                        if config.Type == "Toggle" then
                            assert(u22.ToggleTemplate, "ToggleTemplate not loaded");
                            v128 = u22.ToggleTemplate:Clone();
                            v131 = u21;

                            if u15 then
                                v132 = u15[u7[v131] or v131];

                                if v132 then
                                    u133 = function(p162) -- Line: 297, Name: searchInTable
                                        -- upvalues: name (copy), u133 (copy)
                                        for i, v3 in pairs(p162) do
                                            if i == name then
                                                return v3;
                                            end;

                                            if type(v3) == "table" then
                                                local v163 = u133(v3);

                                                if v163 ~= nil then
                                                    return v163;
                                                end;
                                            end;
                                        end;

                                        return nil;
                                    end;

                                    v134 = u133(v132);
                                else
                                    v134 = nil;
                                end;
                            else
                                v134 = nil;
                            end;

                            if v134 == nil then
                                v134 = config.Default;
                            end;

                            v129 = Toggle(name, config, Scroll, v121, v128, v134, u1.SettingChanged, u21);
                            v121 = v121 + 1;
                        elseif config.Type == "Number" then
                            assert(u22.NumberTemplate, "NumberTemplate not loaded");
                            v128 = u22.NumberTemplate:Clone();
                            v135 = u21;

                            if u15 then
                                v136 = u15[u7[v135] or v135];

                                if v136 then
                                    u137 = function(p164) -- Line: 297, Name: searchInTable
                                        -- upvalues: name (copy), u137 (copy)
                                        for i, v3 in pairs(p164) do
                                            if i == name then
                                                return v3;
                                            end;

                                            if type(v3) == "table" then
                                                local v165 = u137(v3);

                                                if v165 ~= nil then
                                                    return v165;
                                                end;
                                            end;
                                        end;

                                        return nil;
                                    end;

                                    v138 = u137(v136);
                                else
                                    v138 = nil;
                                end;
                            else
                                v138 = nil;
                            end;

                            v129 = Number(name, config, Scroll, v121, v128, tonumber(v138 or config.Default) or config.Default, u1.SettingChanged, u21);
                            v121 = v121 + 1;
                        elseif config.Type == "Slider" then
                            assert(u22.SliderTemplate, "SliderTemplate not loaded");
                            v128 = u22.SliderTemplate:Clone();
                            v139 = nil;

                            if config.HasEnabledToggle then
                                v140 = u21;

                                if u15 then
                                    v141 = u15[u7[v140] or v140];

                                    if v141 then
                                        u142 = function(p166) -- Line: 297, Name: searchInTable
                                            -- upvalues: name (copy), u142 (copy)
                                            for i, v3 in pairs(p166) do
                                                if i == name then
                                                    return v3;
                                                end;

                                                if type(v3) == "table" then
                                                    local v167 = u142(v3);

                                                    if v167 ~= nil then
                                                        return v167;
                                                    end;
                                                end;
                                            end;

                                            return nil;
                                        end;

                                        v143 = u142(v141);
                                    else
                                        v143 = nil;
                                    end;
                                else
                                    v143 = nil;
                                end;

                                if type(v143) == "table" then
                                    v144 = tonumber(v143.Value) or config.Default;
                                    v139 = v143.Enabled;

                                    if v139 == nil then
                                        if config.DefaultEnabled == nil then
                                            v139 = true;
                                        else
                                            v139 = config.DefaultEnabled;
                                        end;
                                    end;
                                else
                                    v144 = tonumber(v143) or config.Default;

                                    if config.DefaultEnabled == nil then
                                        v139 = true;
                                    else
                                        v139 = config.DefaultEnabled;
                                    end;
                                end;
                            else
                                v145 = u21;

                                if u15 then
                                    v146 = u15[u7[v145] or v145];

                                    if v146 then
                                        u147 = function(p168) -- Line: 297, Name: searchInTable
                                            -- upvalues: name (copy), u147 (copy)
                                            for i, v3 in pairs(p168) do
                                                if i == name then
                                                    return v3;
                                                end;

                                                if type(v3) == "table" then
                                                    local v169 = u147(v3);

                                                    if v169 ~= nil then
                                                        return v169;
                                                    end;
                                                end;
                                            end;

                                            return nil;
                                        end;

                                        v148 = u147(v146);
                                    else
                                        v148 = nil;
                                    end;
                                else
                                    v148 = nil;
                                end;

                                v144 = tonumber(v148 or config.Default) or config.Default;
                            end;

                            v129 = Slider(name, config, Scroll, v121, v128, v144, v139, u1.SettingChanged, u21);
                            v121 = v121 + 1;
                        elseif config.Type == "Dropdown" then
                            assert(u22.DropdownTemplate, "DropdownTemplate not loaded");
                            v128 = u22.DropdownTemplate:Clone();
                            v149 = u21;

                            if u15 then
                                v150 = u15[u7[v149] or v149];

                                if v150 then
                                    u151 = function(p170) -- Line: 297, Name: searchInTable
                                        -- upvalues: name (copy), u151 (copy)
                                        for i, v3 in pairs(p170) do
                                            if i == name then
                                                return v3;
                                            end;

                                            if type(v3) == "table" then
                                                local v171 = u151(v3);

                                                if v171 ~= nil then
                                                    return v171;
                                                end;
                                            end;
                                        end;

                                        return nil;
                                    end;

                                    v152 = u151(v150);
                                else
                                    v152 = nil;
                                end;
                            else
                                v152 = nil;
                            end;

                            v129 = Dropdown(name, config, Scroll, v121, v128, v152 or config.Default, u1.SettingChanged, u21, Settings, function() -- Line: 928
                                -- upvalues: u18 (ref)
                                return u18;
                            end, function(p172) -- Line: 931
                                -- upvalues: u18 (ref)
                                u18 = p172;
                            end);
                            v121 = v121 + 1;
                        elseif config.Type == "Keybind" then
                            assert(u22.KeybindTemplate, "KeybindTemplate not loaded");
                            v128 = u22.KeybindTemplate:Clone();
                            v153 = u21;

                            if u15 then
                                v154 = u15[u7[v153] or v153];

                                if v154 then
                                    u155 = function(p173) -- Line: 297, Name: searchInTable
                                        -- upvalues: name (copy), u155 (copy)
                                        for i, v3 in pairs(p173) do
                                            if i == name then
                                                return v3;
                                            end;

                                            if type(v3) == "table" then
                                                local v174 = u155(v3);

                                                if v174 ~= nil then
                                                    return v174;
                                                end;
                                            end;
                                        end;

                                        return nil;
                                    end;

                                    v156 = u155(v154);
                                else
                                    v156 = nil;
                                end;
                            else
                                v156 = nil;
                            end;

                            v157 = v156 or {};

                            if type(v157) == "table" then
                                for _, v3 in ipairs({ "Computer", "Console" }) do
                                    v158 = v157[v3];

                                    if v158 and v158 ~= "" then
                                        if v158 == "" or v158 == "None" then
                                            v159 = nil;
                                        else
                                            v159 = u14[`{v3}:{v158}`];

                                            if not v159 or v159 == name then
                                                v159 = nil;
                                            end;
                                        end;

                                        if v159 then
                                            if not u9 then
                                                u9 = {};
                                            end;

                                            v160 = u9;

                                            if not v160[v3] then
                                                v160[v3] = {};
                                            end;

                                            table.insert(v160[v3], {
                                                action = name,
                                                keybind = v158
                                            });
                                            table.insert(v160[v3], {
                                                action = v159,
                                                keybind = v158
                                            });
                                        end;

                                        if v158 ~= "" then
                                            if v158 ~= "None" then
                                                u14[`{v3}:{v158}`] = name;
                                            end;
                                        end;
                                    end;
                                end;
                            end;

                            v129 = Keybind(name, config, Scroll, v121, v128, v157, u1.SettingChanged, u21, function(p175, p176, p177) -- Line: 980
                                -- upvalues: u19 (ref), u16 (ref), u20 (ref), u3 (ref), Scroll (copy)
                                u19 = p175;
                                u16 = p176;
                                u20 = p177;
                                p175.Text = "Press a key...";
                                p175.TextColor3 = u3;
                                Scroll.ScrollingEnabled = false;
                            end, function(p178, p179) -- Line: 988
                            end);
                            v121 = v121 + 1;
                        end;

                        if v128 then
                            u11[p112][name] = v128;
                        end;

                        if v129 then
                            u13[p112]:Add(v129, true, (`Template_{name}`));
                        end;

                        v130 = Settings:WaitForChild("Divider"):Clone();
                        v130.LayoutOrder = v121;
                        v130.Parent = Scroll;
                        v121 = v121 + 1;
                    end;
                end;
            else
                u12[name] = {
                    pageName = p112,
                    categoryName = v,
                    settingName = name,
                    settingPath = `Settings.{u7[p112] or p112}.{v}.{name}`
                };

                if config.Type ~= "CrosshairPreview" then
                    if config.Type == "Toggle" then
                        assert(u22.ToggleTemplate, "ToggleTemplate not loaded");
                        v128 = u22.ToggleTemplate:Clone();
                        v131 = u21;

                        if u15 then
                            v132 = u15[u7[v131] or v131];

                            if v132 then
                                u133 = function(p162) -- Line: 297, Name: searchInTable
                                    -- upvalues: name (copy), u133 (copy)
                                    for i, v3 in pairs(p162) do
                                        if i == name then
                                            return v3;
                                        end;

                                        if type(v3) == "table" then
                                            local v163 = u133(v3);

                                            if v163 ~= nil then
                                                return v163;
                                            end;
                                        end;
                                    end;

                                    return nil;
                                end;

                                v134 = u133(v132);
                            else
                                v134 = nil;
                            end;
                        else
                            v134 = nil;
                        end;

                        if v134 == nil then
                            v134 = config.Default;
                        end;

                        v129 = Toggle(name, config, Scroll, v121, v128, v134, u1.SettingChanged, u21);
                        v121 = v121 + 1;
                    elseif config.Type == "Number" then
                        assert(u22.NumberTemplate, "NumberTemplate not loaded");
                        v128 = u22.NumberTemplate:Clone();
                        v135 = u21;

                        if u15 then
                            v136 = u15[u7[v135] or v135];

                            if v136 then
                                u137 = function(p164) -- Line: 297, Name: searchInTable
                                    -- upvalues: name (copy), u137 (copy)
                                    for i, v3 in pairs(p164) do
                                        if i == name then
                                            return v3;
                                        end;

                                        if type(v3) == "table" then
                                            local v165 = u137(v3);

                                            if v165 ~= nil then
                                                return v165;
                                            end;
                                        end;
                                    end;

                                    return nil;
                                end;

                                v138 = u137(v136);
                            else
                                v138 = nil;
                            end;
                        else
                            v138 = nil;
                        end;

                        v129 = Number(name, config, Scroll, v121, v128, tonumber(v138 or config.Default) or config.Default, u1.SettingChanged, u21);
                        v121 = v121 + 1;
                    elseif config.Type == "Slider" then
                        assert(u22.SliderTemplate, "SliderTemplate not loaded");
                        v128 = u22.SliderTemplate:Clone();
                        v139 = nil;

                        if config.HasEnabledToggle then
                            v140 = u21;

                            if u15 then
                                v141 = u15[u7[v140] or v140];

                                if v141 then
                                    u142 = function(p166) -- Line: 297, Name: searchInTable
                                        -- upvalues: name (copy), u142 (copy)
                                        for i, v3 in pairs(p166) do
                                            if i == name then
                                                return v3;
                                            end;

                                            if type(v3) == "table" then
                                                local v167 = u142(v3);

                                                if v167 ~= nil then
                                                    return v167;
                                                end;
                                            end;
                                        end;

                                        return nil;
                                    end;

                                    v143 = u142(v141);
                                else
                                    v143 = nil;
                                end;
                            else
                                v143 = nil;
                            end;

                            if type(v143) == "table" then
                                v144 = tonumber(v143.Value) or config.Default;
                                v139 = v143.Enabled;

                                if v139 == nil then
                                    if config.DefaultEnabled == nil then
                                        v139 = true;
                                    else
                                        v139 = config.DefaultEnabled;
                                    end;
                                end;
                            else
                                v144 = tonumber(v143) or config.Default;

                                if config.DefaultEnabled == nil then
                                    v139 = true;
                                else
                                    v139 = config.DefaultEnabled;
                                end;
                            end;
                        else
                            v145 = u21;

                            if u15 then
                                v146 = u15[u7[v145] or v145];

                                if v146 then
                                    u147 = function(p168) -- Line: 297, Name: searchInTable
                                        -- upvalues: name (copy), u147 (copy)
                                        for i, v3 in pairs(p168) do
                                            if i == name then
                                                return v3;
                                            end;

                                            if type(v3) == "table" then
                                                local v169 = u147(v3);

                                                if v169 ~= nil then
                                                    return v169;
                                                end;
                                            end;
                                        end;

                                        return nil;
                                    end;

                                    v148 = u147(v146);
                                else
                                    v148 = nil;
                                end;
                            else
                                v148 = nil;
                            end;

                            v144 = tonumber(v148 or config.Default) or config.Default;
                        end;

                        v129 = Slider(name, config, Scroll, v121, v128, v144, v139, u1.SettingChanged, u21);
                        v121 = v121 + 1;
                    elseif config.Type == "Dropdown" then
                        assert(u22.DropdownTemplate, "DropdownTemplate not loaded");
                        v128 = u22.DropdownTemplate:Clone();
                        v149 = u21;

                        if u15 then
                            v150 = u15[u7[v149] or v149];

                            if v150 then
                                u151 = function(p170) -- Line: 297, Name: searchInTable
                                    -- upvalues: name (copy), u151 (copy)
                                    for i, v3 in pairs(p170) do
                                        if i == name then
                                            return v3;
                                        end;

                                        if type(v3) == "table" then
                                            local v171 = u151(v3);

                                            if v171 ~= nil then
                                                return v171;
                                            end;
                                        end;
                                    end;

                                    return nil;
                                end;

                                v152 = u151(v150);
                            else
                                v152 = nil;
                            end;
                        else
                            v152 = nil;
                        end;

                        v129 = Dropdown(name, config, Scroll, v121, v128, v152 or config.Default, u1.SettingChanged, u21, Settings, function() -- Line: 928
                            -- upvalues: u18 (ref)
                            return u18;
                        end, function(p172) -- Line: 931
                            -- upvalues: u18 (ref)
                            u18 = p172;
                        end);
                        v121 = v121 + 1;
                    elseif config.Type == "Keybind" then
                        assert(u22.KeybindTemplate, "KeybindTemplate not loaded");
                        v128 = u22.KeybindTemplate:Clone();
                        v153 = u21;

                        if u15 then
                            v154 = u15[u7[v153] or v153];

                            if v154 then
                                u155 = function(p173) -- Line: 297, Name: searchInTable
                                    -- upvalues: name (copy), u155 (copy)
                                    for i, v3 in pairs(p173) do
                                        if i == name then
                                            return v3;
                                        end;

                                        if type(v3) == "table" then
                                            local v174 = u155(v3);

                                            if v174 ~= nil then
                                                return v174;
                                            end;
                                        end;
                                    end;

                                    return nil;
                                end;

                                v156 = u155(v154);
                            else
                                v156 = nil;
                            end;
                        else
                            v156 = nil;
                        end;

                        v157 = v156 or {};

                        if type(v157) == "table" then
                            for _, v3 in ipairs({ "Computer", "Console" }) do
                                v158 = v157[v3];

                                if v158 and v158 ~= "" then
                                    if v158 == "" or v158 == "None" then
                                        v159 = nil;
                                    else
                                        v159 = u14[`{v3}:{v158}`];

                                        if not v159 or v159 == name then
                                            v159 = nil;
                                        end;
                                    end;

                                    if v159 then
                                        if not u9 then
                                            u9 = {};
                                        end;

                                        v160 = u9;

                                        if not v160[v3] then
                                            v160[v3] = {};
                                        end;

                                        table.insert(v160[v3], {
                                            action = name,
                                            keybind = v158
                                        });
                                        table.insert(v160[v3], {
                                            action = v159,
                                            keybind = v158
                                        });
                                    end;

                                    if v158 ~= "" then
                                        if v158 ~= "None" then
                                            u14[`{v3}:{v158}`] = name;
                                        end;
                                    end;
                                end;
                            end;
                        end;

                        v129 = Keybind(name, config, Scroll, v121, v128, v157, u1.SettingChanged, u21, function(p175, p176, p177) -- Line: 980
                            -- upvalues: u19 (ref), u16 (ref), u20 (ref), u3 (ref), Scroll (copy)
                            u19 = p175;
                            u16 = p176;
                            u20 = p177;
                            p175.Text = "Press a key...";
                            p175.TextColor3 = u3;
                            Scroll.ScrollingEnabled = false;
                        end, function(p178, p179) -- Line: 988
                        end);
                        v121 = v121 + 1;
                    end;

                    if v128 then
                        u11[p112][name] = v128;
                    end;

                    if v129 then
                        u13[p112]:Add(v129, true, (`Template_{name}`));
                    end;

                    v130 = Settings:WaitForChild("Divider"):Clone();
                    v130.LayoutOrder = v121;
                    v130.Parent = Scroll;
                    v121 = v121 + 1;
                end;

                if u22.CrosshairPreviewTemplate then
                    v128 = u22.CrosshairPreviewTemplate:Clone();
                    v129 = CrosshairPreview(Scroll, v121, v128, u17.Share, function() -- Line: 810
                        -- upvalues: u15 (ref)
                        return u15 and u15.Game and u15.Game.Crosshair;
                    end, function() -- Line: 813
                    end, function() -- Line: 816
                    end, function() -- Line: 819
                    end);
                    v121 = v121 + 1;

                    if v128 then
                        u11[p112][name] = v128;
                    end;

                    if v129 then
                        u13[p112]:Add(v129, true, (`Template_{name}`));
                    end;

                    v130 = Settings:WaitForChild("Divider"):Clone();
                    v130.LayoutOrder = v121;
                    v130.Parent = Scroll;
                    v121 = v121 + 1;
                end;

                warn("[Settings] CrosshairPreviewTemplate not loaded");
            end;
        end;
    end;

    local v180 = Scroll:FindFirstChildOfClass("UIListLayout");

    if v180 then
        Scroll.CanvasSize = UDim2.new(0, 0, 0, v180.AbsoluteContentSize.Y + 50);
    end;

    if p112 == "Keybinds" and u9 then
        Profiler.defer("UI.Settings.HighlightDuplicateKeybindsDeferred", function() -- Line: 1016
            -- upvalues: u9 (ref), HighlightReplacedKeybind (ref)
            local v181 = {};

            for i, v in pairs(u9) do
                for _, v2 in ipairs(v) do
                    local v182 = `{v2.action}:{i}`;

                    if not v181[v182] then
                        HighlightReplacedKeybind(v2.action, i);
                        v181[v182] = true;
                    end;
                end;
            end;

            u9 = nil;
        end);
    end;
end;

function u1.Open(p183) -- Line: 1039
    -- upvalues: Profiler (copy), u21 (ref), u17 (ref), u11 (copy), u1 (copy), u3 (copy), u2 (copy)
    Profiler.mark((`UI.Settings.Open.{p183}`));
    u21 = p183;

    for _, child in ipairs(u17.Frame.List:GetChildren()) do
        if child:IsA("Frame") then
            child.Visible = false;
        end;
    end;

    local v184 = u17.Frame.List:FindFirstChild(p183);

    if v184 then
        v184.Visible = true;

        if not u11[p183] then
            u1.RenderPage(p183);
        end;
    end;

    for _, child in ipairs(u17.Buttons:GetChildren()) do
        if child:IsA("ImageButton") then
            local v185 = child.Name == p183;
            child:SetAttribute("Selected", v185 and true or nil);

            if v185 then
                child.BackgroundColor3 = u3;
            else
                child.BackgroundColor3 = u2;
            end;
        end;
    end;
end;

function u1.SettingChanged(p186, u187, p188, p189, p190) -- Line: 1089
    -- upvalues: Profiler (copy), u15 (ref), u12 (copy), Pages (copy), u7 (copy), ReplicatedStorage (copy), DeepEqual (copy), u14 (copy), ClearKeybindHighlight (copy), AddToHistory (copy), Remotes (copy)
    Profiler.mark("UI.Settings.SettingChanged");

    if not u15 then
        warn("[Settings] CurrentSettings is nil");

        return;
    end;

    local v191 = u12[u187];

    if not v191 then
        local v192 = Pages.GetSetting(p186, u187);

        if not (v192 and v192.Category) then
            warn((`[Settings] Could not find metadata or config for setting: {u187}`));

            return;
        end;

        v191 = {
            pageName = p186,
            categoryName = v192.Category,
            settingName = u187,
            settingPath = `Settings.{u7[p186] or p186}.{v192.Category}.{u187}`
        };
    end;

    local settingPath = v191.settingPath;

    if settingPath == "Settings.Audio.Music.Bomb/Hostage Volume" then
        require(ReplicatedStorage.Controllers.SoundController).SetBombPlantedMusicVolume(p188);
    end;

    if p189 then
        return;
    end;

    local v193;

    if u15 then
        local v194 = u15[u7[p186] or p186];

        if v194 then
            local function u197(p195) -- Line: 297
                -- upvalues: u187 (copy), u197 (copy)
                for i, v in pairs(p195) do
                    if i == u187 then
                        return v;
                    end;

                    if type(v) == "table" then
                        local v196 = u197(v);

                        if v196 ~= nil then
                            return v196;
                        end;
                    end;
                end;

                return nil;
            end;

            v193 = u197(v194);
        else
            v193 = nil;
        end;
    else
        v193 = nil;
    end;

    if DeepEqual(v193, p188) and not p190 then
        return;
    end;

    local v198 = u15;
    local v199 = u7[p186] or p186;

    if not v198[v199] then
        v198[v199] = {};
    end;

    local v200 = v198[v199];

    if not v200[v191.categoryName] then
        v200[v191.categoryName] = {};
    end;

    v200[v191.categoryName][u187] = p188;
    local v201 = p186 == "Keybinds" and u15[v199];

    if v201 then
        require(ReplicatedStorage.Controllers.InputController).loadActionsFromDatabase(v201);
    end;

    if p186 == "Keybinds" and type(p188) == "table" then
        for _, v in ipairs({ "Computer", "Console" }) do
            local v202 = p188[v];

            if v202 and v202 ~= "" then
                local v203;

                if v202 == "" or v202 == "None" then
                    v203 = nil;
                else
                    v203 = u14[`{v}:{v202}`];

                    if not v203 or v203 == u187 then
                        v203 = nil;
                    end;
                end;

                if not v203 then
                    Profiler.defer("UI.Settings.ClearKeybindHighlightDeferred", ClearKeybindHighlight, u187, v);
                end;
            else
                Profiler.defer("UI.Settings.ClearKeybindHighlightDeferred", ClearKeybindHighlight, u187, v);
            end;
        end;
    end;

    AddToHistory(settingPath, v193, p188);
    Remotes.Player.UpdatePlayerSettings.Send({
        Path = settingPath,
        Value = p188
    });
end;

function u1.UpdateSettings(p204) -- Line: 1218
    -- upvalues: Profiler (copy), u15 (ref), u21 (ref), u11 (copy), u1 (copy)
    Profiler.mark("UI.Settings.UpdateSettings");
    u15 = p204;

    if u21 and u11[u21] then
        u1.RenderPage(u21);
    end;
end;

function u1.ResetCrosshair() -- Line: 1231
    -- upvalues: u1 (copy)
    for i, v in pairs({
        ["Crosshair Style"] = "Classic",
        ["Crosshair Image"] = 0,
        ["Follow Recoil"] = true,
        ["Center Dot"] = true,
        ["T Style"] = false,
        Red = 0,
        Green = 255,
        Blue = 0,
        Length = 5,
        Thickness = 1,
        Gap = 0,
        Outline = {
            Enabled = true,
            Value = 1
        },
        Alpha = {
            Enabled = false,
            Value = 200
        },
        ["Friendly Fire Reticle Warning"] = true,
        ["Use Crosshair Color for Scope Dot"] = true,
        ["Show my crosshair when spectating bots"] = false,
        ["Show Player Crosshairs"] = false
    }) do
        u1.SettingChanged("Game", i, v);
    end;

    u1.RenderPage("Game");
end;

function u1.ShareCrosshair() -- Line: 1263
    -- upvalues: u15 (ref), u17 (ref)
    if not (u15 and (u15.Game and u15.Game.Crosshair)) then
        warn("[Settings] No crosshair settings to share");

        return;
    end;

    local HttpService = game:GetService("HttpService");
    game:GetService("InsertService");
    local Crosshair = u15.Game.Crosshair;
    local success, result = pcall(function() -- Line: 1274
        -- upvalues: HttpService (copy), Crosshair (copy)
        return HttpService:JSONEncode(Crosshair);
    end);

    if not (success and result) then
        warn("[Settings] Failed to encode crosshair settings:", result);

        return;
    end;

    u17.Share.Visible = true;
    u17.Share.TextBox.Text = result;
    u17.Share.TextBox:CaptureFocus();
    u17.Share.TextBox.CursorPosition = #result + 1;
end;

function u1.ImportCrosshair(u205) -- Line: 1292
    -- upvalues: u1 (copy), u17 (ref)
    local HttpService = game:GetService("HttpService");
    local success, result = pcall(function() -- Line: 1295
        -- upvalues: HttpService (copy), u205 (copy)
        return HttpService:JSONDecode(u205);
    end);

    if not success or (not result or type(result) ~= "table") then
        warn("[Settings] Failed to import crosshair settings - invalid code");

        return;
    end;

    for i, v in pairs(result) do
        u1.SettingChanged("Game", i, v);
    end;

    u1.RenderPage("Game");
    u17.Share.Visible = false;
end;

function u1.ResetPage(p206) -- Line: 1316
    -- upvalues: Pages (copy), u1 (copy)
    local v207 = Pages.GetPage(p206);

    if not v207 then
        warn((`[Settings] Page '{p206}' not found`));

        return;
    end;

    for i, v in pairs(v207) do
        if not i:match("^_Divider_") and v.Default ~= nil then
            u1.SettingChanged(p206, i, v.HasEnabledToggle and {
                Enabled = v.DefaultEnabled or false,
                Value = v.Default
            } or v.Default);
        end;
    end;

    u1.RenderPage(p206);
end;

function u1.UndoLastChange() -- Line: 1347
    -- upvalues: u10 (copy), Remotes (copy), u15 (ref), u21 (ref), u1 (copy)
    if #u10 == 0 then
        warn("[Settings] No changes to undo");

        return;
    end;

    local v208 = table.remove(u10);

    if not v208 then
        return;
    end;

    Remotes.Player.UpdatePlayerSettings.Send({
        Path = v208.path,
        Value = v208.oldValue
    });
    local v209 = string.split(v208.path, ".");

    if #v209 >= 3 then
        local v210 = u15;

        for i = 2, #v209 - 1 do
            local v211 = v209[i];

            if not v210[v211] then
                return;
            end;

            v210 = v210[v211];
        end;

        v210[v209[#v209]] = v208.oldValue;
    end;

    if u21 then
        u1.RenderPage(u21);
    end;
end;

local function SetupEditMobileTabButton(u212) -- Line: 1392
    -- upvalues: EditMobile (copy), UserInputService (copy), ActivateButton (copy), ReplicatedStorage (copy), MenuState (copy)
    local function UpdateButtonVisibility(p213) -- Line: 1393
        -- upvalues: u212 (copy), EditMobile (ref)
        u212.Visible = EditMobile.ShouldShowEntryButton(p213);
    end;

    u212.Visible = EditMobile.ShouldShowEntryButton(nil);
    UserInputService.LastInputTypeChanged:Connect(UpdateButtonVisibility);
    ActivateButton(u212);
    u212.MouseButton1Click:Connect(function() -- Line: 1401
        -- upvalues: ReplicatedStorage (ref), MenuState (ref), EditMobile (ref)
        require(ReplicatedStorage.Interface.Screens.Menu.Top).openFrame("Dashboard");

        if MenuState.GetCurrentScreen() ~= "Dashboard" then
            return;
        end;

        EditMobile.Open();
    end);
end;

function u1.Initialize(p214, p215) -- Line: 1415
    -- upvalues: Profiler (copy), u17 (ref), u22 (copy), Settings (copy), SetupEditMobileTabButton (copy), ActivateButton (copy), u1 (copy), u21 (ref), UserInputService (copy), u19 (ref), u20 (ref), u16 (ref), u2 (copy), HandleKeybindCapture (copy), u18 (ref)
    Profiler.mark("UI.Settings.Initialize");
    u17 = p215;
    u22.CrosshairPreviewTemplate = Settings:WaitForChild("CrosshairPreviewTemplate");
    u22.ToggleTemplate = Settings:WaitForChild("ToggleTemplate");
    u22.DropdownTemplate = Settings:WaitForChild("DropdownTemplate");
    u22.NumberTemplate = Settings:WaitForChild("NumberTemplate");
    u22.SliderTemplate = Settings:WaitForChild("SliderTemplate");
    u22.KeybindTemplate = Settings:WaitForChild("KeybindTemplate");

    for _, child in ipairs(u17.Buttons:GetChildren()) do
        if child:IsA("ImageButton") then
            if child.Name == "EditMobile" then
                SetupEditMobileTabButton(child);
            else
                ActivateButton(child);
                child.MouseButton1Click:Connect(function() -- Line: 1441
                    -- upvalues: u1 (ref), child (copy)
                    u1.Open(child.Name);
                end);
            end;
        end;
    end;

    u17.Reset.MouseButton1Click:Connect(function() -- Line: 1447
        -- upvalues: u1 (ref), u21 (ref)
        u1.ResetPage(u21);
    end);

    if u17:FindFirstChild("Share") then
        u17.Share.Visible = false;
        u17.Share.List.Cancel.MouseButton1Click:Connect(function() -- Line: 1455
            -- upvalues: u17 (ref)
            u17.Share.Visible = false;
        end);
        u17.Share.List.Copy.MouseButton1Click:Connect(function() -- Line: 1459
            -- upvalues: u17 (ref)
            u17.Share.TextBox:CaptureFocus();
            u17.Share.TextBox.CursorPosition = #u17.Share.TextBox.Text + 1;
        end);
        u17.Share.List.Import.MouseButton1Click:Connect(function() -- Line: 1465
            -- upvalues: u1 (ref), u17 (ref)
            u1.ImportCrosshair(u17.Share.TextBox.Text);
        end);
    end;

    UserInputService.InputBegan:Connect(function(p216, p217) -- Line: 1471
        -- upvalues: u19 (ref), u20 (ref), u16 (ref), u21 (ref), u17 (ref), u2 (ref), HandleKeybindCapture (ref)
        if not u19 then
            return;
        end;

        if p216.UserInputState ~= Enum.UserInputState.Begin then
            return;
        end;

        if tick() - u20 < 0.1 then
            return;
        end;

        if not u19.Parent then
            u19 = nil;
            u16 = nil;

            if u21 == "Keybinds" then
                local Keybinds = u17.Frame.List:FindFirstChild("Keybinds");
                local v218 = Keybinds and Keybinds.Bottom.Scroll;

                if v218 then
                    v218.ScrollingEnabled = true;
                end;
            end;

            return;
        end;

        local Parent = u19.Parent;
        local v219 = "";

        if p216.UserInputType == Enum.UserInputType.Keyboard then
            if p216.KeyCode == Enum.KeyCode.Escape then
                if not u19 then
                    return;
                end;

                u19.Text = u16 or "None";
                u19.TextColor3 = u2;
                u19:ReleaseFocus();
                u16 = nil;
                u19 = nil;

                if u21 == "Keybinds" then
                    local Keybinds = u17.Frame.List:FindFirstChild("Keybinds");
                    local v220 = Keybinds and Keybinds.Bottom.Scroll;

                    if v220 then
                        v220.ScrollingEnabled = true;
                    end;
                end;

                return;
            end;

            v219 = `Enum.KeyCode.{p216.KeyCode.Name}`;
        elseif p216.UserInputType == Enum.UserInputType.MouseButton1 then
            v219 = "Enum.UserInputType.MouseButton1";
        elseif p216.UserInputType == Enum.UserInputType.MouseButton2 then
            v219 = "Enum.UserInputType.MouseButton2";
        elseif p216.UserInputType == Enum.UserInputType.MouseButton3 then
            v219 = "Enum.UserInputType.MouseButton3";
        elseif string.match(p216.UserInputType.Name, "^Gamepad%d+$") then
            v219 = `Enum.KeyCode.{p216.KeyCode.Name}`;
        end;

        if v219 ~= "" then
            HandleKeybindCapture(Parent, v219);
        end;
    end);
    UserInputService.InputChanged:Connect(function(p221, p222) -- Line: 1519
        -- upvalues: u19 (ref), u20 (ref), u16 (ref), u21 (ref), u17 (ref), HandleKeybindCapture (ref)
        if not u19 then
            return;
        end;

        if p221.UserInputType ~= Enum.UserInputType.MouseWheel then
            return;
        end;

        if tick() - u20 < 0.1 then
            return;
        end;

        if not u19.Parent then
            u16 = nil;
            u19 = nil;

            if u21 == "Keybinds" then
                local Keybinds = u17.Frame.List:FindFirstChild("Keybinds");
                local v223 = Keybinds and Keybinds.Bottom.Scroll;

                if v223 then
                    v223.ScrollingEnabled = true;
                end;
            end;

            return;
        end;

        local Parent = u19.Parent;
        local Z = p221.Position.Z;

        if Z > 0 then
            HandleKeybindCapture(Parent, "Enum.CustomInputType.ScrollWheelUp");

            return;
        end;

        if Z < 0 then
            HandleKeybindCapture(Parent, "Enum.CustomInputType.ScrollWheelDown");
        end;
    end);
    UserInputService.InputBegan:Connect(function(p224, p225) -- Line: 1557
        -- upvalues: u18 (ref)
        if p224.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        local v226 = u18;

        if not (v226 and v226.Visible) then
            return;
        end;

        local Position = p224.Position;

        if not (v226.Parent and v226.Parent.Parent) then
            return;
        end;

        local Options = v226.Parent.Parent:FindFirstChild("Options");

        if not Options then
            return;
        end;

        local Button = Options.Button;

        if not Button then
            return;
        end;

        local AbsolutePosition = Button.AbsolutePosition;
        local AbsoluteSize = Button.AbsoluteSize;
        local AbsolutePosition2 = v226.AbsolutePosition;
        local AbsoluteSize2 = v226.AbsoluteSize;
        local v227;

        if Position.X >= AbsolutePosition.X and (Position.X <= AbsolutePosition.X + AbsoluteSize.X and Position.Y >= AbsolutePosition.Y) then
            v227 = Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
        else
            v227 = false;
        end;

        local v228;

        if Position.X >= AbsolutePosition2.X and (Position.X <= AbsolutePosition2.X + AbsoluteSize2.X and Position.Y >= AbsolutePosition2.Y) then
            v228 = Position.Y <= AbsolutePosition2.Y + AbsoluteSize2.Y;
        else
            v228 = false;
        end;

        if not (v227 or v228) then
            v226.Visible = false;
            u18 = nil;
        end;
    end);
end;

function u1.Start() -- Line: 1612
    -- upvalues: Profiler (copy), u1 (copy), DataController (copy), LocalPlayer (copy)
    debug.setmemorycategory("UI.Settings.Start");
    Profiler.mark("UI.Settings.Start");
    u1.Open("Video");
    DataController.CreateListener(LocalPlayer, "Settings", function(p229) -- Line: 1618
        -- upvalues: u1 (ref)
        u1.UpdateSettings(p229);
    end);
end;

return u1;