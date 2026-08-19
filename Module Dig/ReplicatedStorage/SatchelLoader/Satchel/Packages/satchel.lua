-- Decompiled with Potassium's decompiler.

local ContextActionService = game:GetService("ContextActionService");
local TextChatService = game:GetService("TextChatService");
local UserInputService = game:GetService("UserInputService");
local StarterGui = game:GetService("StarterGui");
local GuiService = game:GetService("GuiService");
local RunService = game:GetService("RunService");
local VRService = game:GetService("VRService");
local Players = game:GetService("Players");
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local u1 = {
    OpenClose = nil,
    IsOpen = false,
    StateChanged = Instance.new("BindableEvent"),
    ModuleName = "Backpack",
    KeepVRTopbarOpen = true,
    VRIsExclusive = true,
    VRClosesNonExclusive = true,
    BackpackEmpty = Instance.new("BindableEvent")
};
u1.BackpackEmpty.Name = "BackpackEmpty";
u1.BackpackItemAdded = Instance.new("BindableEvent");
u1.BackpackItemAdded.Name = "BackpackAdded";
u1.BackpackItemRemoved = Instance.new("BindableEvent");
u1.BackpackItemRemoved.Name = "BackpackRemoved";
local v2 = script;
require(script.Attribution);
local v3 = GuiService.PreferredTransparency or 1;
local u4 = not v2:GetAttribute("OutlineEquipBorder") or false;
local u5 = v2:GetAttribute("InsetIconPadding");
local u6 = v2:GetAttribute("BackgroundTransparency") or 0.3;
local u7 = u6 * v3;
local v8 = UDim.new(0, 8);
local u9 = v2:GetAttribute("BackgroundColor3") or Color3.new(0.09803921568627451, 0.10588235294117647, 0.11372549019607843);
local u10 = v2:GetAttribute("EquipBorderColor3") or Color3.new(0, 0.6352941176470588, 1);
local u11 = v2:GetAttribute("BackgroundTransparency") or 0.3;
local u12 = u11 * v3;
local u13 = v2:GetAttribute("EquipBorderSizePixel") or 5;
local u14 = v2:GetAttribute("CornerRadius") or UDim.new(0, 8);
local u15 = Color3.new(1, 1, 1);
local u16 = u14 - UDim.new(0, 5) or UDim.new(0, 3);
local u17 = v2:GetAttribute("BackgroundColor3") or Color3.new(0.09803921568627451, 0.10588235294117647, 0.11372549019607843);
local u18 = v2:GetAttribute("TextColor3") or Color3.new(1, 1, 1);
local u19 = v2:GetAttribute("TextStrokeTransparency") or 0.5;
local u20 = v2:GetAttribute("TextStrokeColor3") or Color3.new(0, 0, 0);
local v21 = Color3.new(0.09803921568627451, 0.10588235294117647, 0.11372549019607843);
local u22 = v3 * 0.2;
local v23 = Color3.new(1, 1, 1);
local v24 = UDim.new(0, 3);
local u25 = v2:GetAttribute("FontFace") or Font.new("rbxasset://fonts/families/BuilderSans.json");
local u26 = v2:GetAttribute("TextSize") or 16;
local Value = Enum.KeyCode.Backspace.Value;
local Value2 = Enum.KeyCode.Zero.Value;
local u27 = {
    [Enum.UserInputType.MouseButton1] = true,
    [Enum.UserInputType.MouseButton2] = true,
    [Enum.UserInputType.MouseButton3] = true,
    [Enum.UserInputType.MouseMovement] = true,
    [Enum.UserInputType.MouseWheel] = true
};
local u28 = {
    [Enum.UserInputType.Gamepad1] = true,
    [Enum.UserInputType.Gamepad2] = true,
    [Enum.UserInputType.Gamepad3] = true,
    [Enum.UserInputType.Gamepad4] = true,
    [Enum.UserInputType.Gamepad5] = true,
    [Enum.UserInputType.Gamepad6] = true,
    [Enum.UserInputType.Gamepad7] = true,
    [Enum.UserInputType.Gamepad8] = true
};
local u29 = true;
local u30 = require(script.Parent.topbarplus).new():setName("Inventory"):setImage("rbxasset://textures/ui/TopBar/inventoryOn.png", "Selected"):setImage("rbxasset://textures/ui/TopBar/inventoryOff.png", "Deselected"):setImageScale(1):setCaption("Inventory"):bindToggleKey(Enum.KeyCode.Backquote):autoDeselect(false):setOrder(-1);
u30.toggled:Connect(function() -- Line: 156
    -- upvalues: GuiService (copy), u1 (copy)
    if not GuiService.MenuIsOpen then
        u1.OpenClose();
    end;
end);
local ScreenGui = Instance.new("ScreenGui");
ScreenGui.DisplayOrder = 120;
ScreenGui.IgnoreGuiInset = true;
ScreenGui.ResetOnSpawn = false;
ScreenGui.Name = "BackpackGui";
ScreenGui.Parent = PlayerGui;
local u31 = GuiService:IsTenFootInterface();
local u32;

if u31 then
    u26 = 24;
    u32 = 100;
else
    u32 = 60;
end;

local u33 = false;
local v34 = UserInputService.TouchEnabled and workspace.CurrentCamera.ViewportSize.X < 1024;
local LocalPlayer = Players.LocalPlayer;
local u35 = nil;
local u36 = nil;
local u37 = nil;
local u38 = nil;
local u39 = nil;
local u40 = nil;
local u41 = nil;
local u42 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
local Humanoid = u42:WaitForChild("Humanoid");
local Backpack = LocalPlayer:WaitForChild("Backpack");
local u43 = {};
local u44 = nil;
local u45 = {};
local u46 = {};
local u47 = {};
local u48 = 0;
local u49 = nil;
local u50 = false;
local u51 = false;
local u52 = false;
local u53 = false;
local u54 = {};
local u55 = false;
local VREnabled = VRService.VREnabled;
local u56 = VREnabled and 6 or (v34 and 6 or 10);
local u57 = VREnabled and 3 or (v34 and 2 or 4);
local u58 = nil;

local function EvaluateBackpackPanelVisibility(p59) -- Line: 219
    -- upvalues: u30 (copy), u29 (ref), VRService (copy)
    return p59 and (u30.enabled and u29) and VRService.VREnabled;
end;

local function ShowVRBackpackPopup() -- Line: 223
end;

local function FindLowestEmpty() -- Line: 229
    -- upvalues: u56 (copy), u43 (copy)
    for i = 1, u56 do
        local v60 = u43[i];

        if not v60.Tool then
            return v60;
        end;
    end;

    return nil;
end;

function u1.IsInventoryEmpty() -- Line: 239
    -- upvalues: u56 (copy), u43 (copy)
    for i = u56 + 1, #u43 do
        local v61 = u43[i];

        if v61 and v61.Tool then
            return false;
        end;
    end;

    return true;
end;

local function UseGazeSelection() -- Line: 251
    return false;
end;

local function AdjustHotbarFrames() -- Line: 255
    -- upvalues: u37 (ref), u56 (copy), u48 (ref), u43 (copy)
    local Visible = u37.Visible;
    local v62 = Visible and u56 or u48;
    local v63 = 0;

    for i = 1, u56 do
        local v64 = u43[i];

        if v64.Tool or Visible then
            v63 = v63 + 1;
            v64:Readjust(v63, v62);
            v64.Frame.Visible = true;
        else
            v64.Frame.Visible = false;
        end;
    end;
end;

local function UpdateScrollingFrameCanvasSize() -- Line: 272
    -- upvalues: u39 (ref), u32 (ref), u40 (ref)
    local v65 = math.floor(u39.AbsoluteSize.X / (u32 + 5));
    local v66 = (#u40:GetChildren() - 1) / v65;
    local v67 = math.ceil(v66) * (u32 + 5) + 5;
    u39.CanvasSize = UDim2.fromOffset(0, v67);
end;

local function AdjustInventoryFrames() -- Line: 279
    -- upvalues: u56 (copy), u43 (copy), u39 (ref), u32 (ref), u40 (ref)
    for i = u56 + 1, #u43 do
        local v68 = u43[i];
        v68.Frame.LayoutOrder = v68.Index;
        v68.Frame.Visible = v68.Tool ~= nil;
    end;

    local v69 = math.floor(u39.AbsoluteSize.X / (u32 + 5));
    local v70 = (#u40:GetChildren() - 1) / v69;
    local v71 = math.ceil(v70) * (u32 + 5) + 5;
    u39.CanvasSize = UDim2.fromOffset(0, v71);
end;

local function UpdateBackpackLayout() -- Line: 288
    -- upvalues: u36 (ref), u56 (copy), u32 (ref), u37 (ref), u57 (copy), VREnabled (copy), u39 (ref), AdjustHotbarFrames (copy), AdjustInventoryFrames (copy)
    u36.Size = UDim2.new(0, u56 * (u32 + 5) + 5, 0, u32 + 5 + 5);
    u36.Position = UDim2.new(0.5, -u36.Size.X.Offset / 2, 1, -u36.Size.Y.Offset);
    u37.Size = UDim2.new(0, u36.Size.X.Offset, 0, u36.Size.Y.Offset * u57 + 40 + (VREnabled and 80 or 0));
    u37.Position = UDim2.new(0.5, -u37.Size.X.Offset / 2, 1, u36.Position.Y.Offset - u37.Size.Y.Offset);
    u39.Size = UDim2.new(1, u39.ScrollBarThickness + 1, 1, -40 - (VREnabled and 80 or 0));
    u39.Position = UDim2.fromOffset(0, 40 + (VREnabled and 40 or 0));
    AdjustHotbarFrames();
    AdjustInventoryFrames();
end;

local function Clamp(p72, p73, p74) -- Line: 322
    local v75 = math.max(p72, p74);

    return math.min(p73, v75);
end;

local function CheckBounds(p76, p77, p78) -- Line: 326
    local AbsolutePosition = p76.AbsolutePosition;
    local AbsoluteSize = p76.AbsoluteSize;
    local v79;

    if AbsolutePosition.X < p77 and (p77 <= AbsolutePosition.X + AbsoluteSize.X and AbsolutePosition.Y < p78) then
        v79 = p78 <= AbsolutePosition.Y + AbsoluteSize.Y;
    else
        v79 = false;
    end;

    return v79;
end;

local function GetOffset(p80, p81) -- Line: 332
    return (p80.AbsolutePosition + p80.AbsoluteSize / 2 - p81).Magnitude;
end;

local function DisableActiveHopper() -- Line: 337
    -- upvalues: u49 (ref), u45 (copy)
    u49:ToggleSelect();
    u45[u49]:UpdateEquipView();
    u49 = nil;
end;

local function UnequipAllTools() -- Line: 343
    -- upvalues: Humanoid (ref), u49 (ref), u45 (copy)
    if Humanoid then
        Humanoid:UnequipTools();

        if u49 then
            u49:ToggleSelect();
            u45[u49]:UpdateEquipView();
            u49 = nil;
        end;
    end;
end;

local function EquipNewTool(p82) -- Line: 352
    -- upvalues: Humanoid (ref), u49 (ref), u45 (copy)
    if Humanoid then
        Humanoid:UnequipTools();

        if u49 then
            u49:ToggleSelect();
            u45[u49]:UpdateEquipView();
            u49 = nil;
        end;
    end;

    Humanoid:EquipTool(p82);
end;

local function IsEquipped(p83) -- Line: 358
    -- upvalues: u42 (ref)
    if p83 then
        p83 = p83.Parent == u42;
    end;

    return p83;
end;

local function MakeSlot(p84, p85) -- Line: 363
    -- upvalues: u43 (copy), u12 (ref), u36 (ref), u32 (ref), u56 (copy), u37 (ref), UserInputService (copy), u48 (ref), u51 (ref), u33 (ref), ContextActionService (copy), u41 (ref), u45 (copy), u44 (ref), u42 (ref), u58 (ref), u13 (copy), u10 (copy), u4 (copy), u39 (ref), u40 (ref), Humanoid (ref), u49 (ref), Backpack (ref), u9 (copy), u15 (copy), u14 (copy), u5 (copy), u18 (copy), u19 (copy), u20 (copy), u25 (copy), u26 (ref), u17 (copy), u16 (copy), MakeSlot (copy), u53 (ref), u46 (copy), Value2 (copy), u47 (copy), u30 (copy)
    local v86 = p85 or #u43 + 1;
    local u87 = {
        Tool = nil,
        Index = v86,
        Frame = nil
    };
    local u88 = nil;
    local u89 = nil;
    local u90 = nil;
    local u91 = nil;
    local u92 = nil;
    local u93 = nil;
    local u94 = nil;
    local u95 = nil;

    local function UpdateSlotFading() -- Line: 388
        -- upvalues: u88 (ref), u12 (ref)
        u88.SelectionImageObject = nil;
        u88.BackgroundTransparency = u88.Draggable and 0 or u12;
    end;

    function u87.Readjust(p96, p97, p98) -- Line: 394
        -- upvalues: u36 (ref), u32 (ref), u88 (ref)
        u88.Position = UDim2.fromOffset(u36.Size.X.Offset / 2 - u32 / 2 + (u32 + 5) * (p97 - (p98 / 2 + 0.5)), 5);
    end;

    function u87.Fill(p99, u100) -- Line: 404
        -- upvalues: u90 (ref), u91 (ref), u94 (ref), u92 (ref), u56 (ref), u37 (ref), UserInputService (ref), u88 (ref), u48 (ref), u51 (ref), u33 (ref), ContextActionService (ref), u41 (ref), u45 (ref), u44 (ref), u43 (ref)
        if not u100 then
            return p99:Clear();
        end;

        p99.Tool = u100;

        local function assignToolData() -- Line: 413
            -- upvalues: u100 (copy), u90 (ref), u91 (ref), u94 (ref)
            local TextureId = u100.TextureId;
            u90.Image = TextureId;

            if TextureId == "" then
                u91.Visible = true;
            else
                u91.Visible = false;
            end;

            u91.Text = u100.Name;

            if u94 and u100:IsA("Tool") then
                u94.Text = u100.ToolTip;
                u94.Size = UDim2.fromOffset(0, 16);
                u94.Position = UDim2.new(0.5, 0, 0, -5);
            end;
        end;

        assignToolData();

        if u92 then
            u92:Disconnect();
            u92 = nil;
        end;

        u92 = u100.Changed:Connect(function(p101) -- Line: 442
            -- upvalues: assignToolData (copy)
            if p101 == "TextureId" or (p101 == "Name" or p101 == "ToolTip") then
                assignToolData();
            end;
        end);
        local v102 = p99.Index <= u56;

        if (not v102 or u37.Visible) and not UserInputService.VREnabled then
            u88.Draggable = true;
        end;

        p99:UpdateEquipView();

        if v102 then
            u48 = u48 + 1;

            if u51 and (u48 >= 1 and not u33) then
                u33 = true;
                ContextActionService:BindAction("BackpackHotbarEquip", u41, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1);
            end;
        end;

        u45[u100] = p99;
        local v103;

        for i = 1, u56 do
            v103 = u43[i];

            if not v103.Tool then
                break;
            end;
        end;

        u44 = v103;
    end;

    function u87.Clear(p104) -- Line: 478
        -- upvalues: u92 (ref), u90 (ref), u91 (ref), u94 (ref), u88 (ref), u56 (ref), u48 (ref), u33 (ref), ContextActionService (ref), u45 (ref), u44 (ref), u43 (ref)
        if not p104.Tool then
            return;
        end;

        if u92 then
            u92:Disconnect();
            u92 = nil;
        end;

        u90.Image = "";
        u91.Text = "";

        if u94 then
            u94.Text = "";
            u94.Visible = false;
        end;

        u88.Draggable = false;
        p104:UpdateEquipView(true);

        if p104.Index <= u56 then
            u48 = u48 - 1;

            if u48 < 1 then
                u33 = false;
                ContextActionService:UnbindAction("BackpackHotbarEquip");
            end;
        end;

        u45[p104.Tool] = nil;
        p104.Tool = nil;
        local v105;

        for i = 1, u56 do
            v105 = u43[i];

            if not v105.Tool then
                break;
            end;
        end;

        u44 = v105;
    end;

    function u87.UpdateEquipView(p106, p107) -- Line: 513
        -- upvalues: u42 (ref), u58 (ref), u87 (copy), u93 (ref), u13 (ref), u10 (ref), u4 (ref), u90 (ref), u88 (ref), u12 (ref)
        if p107 or false then
            if u93 then
                u93.Parent = nil;
            end;
        else
            local Tool = p106.Tool;

            if Tool then
                Tool = Tool.Parent == u42;
            end;

            if Tool then
                u58 = u87;

                if not u93 then
                    u93 = Instance.new("UIStroke");
                    u93.Name = "Border";
                    u93.Thickness = u13;
                    u93.Color = u10;
                    u93.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                end;

                if u4 == true then
                    u93.Parent = u90;
                else
                    u93.Parent = u88;
                end;
            elseif u93 then
                u93.Parent = nil;
            end;
        end;

        u88.SelectionImageObject = nil;
        u88.BackgroundTransparency = u88.Draggable and 0 or u12;
    end;

    function u87.IsEquipped(p108) -- Line: 537
        -- upvalues: u42 (ref)
        local Tool = p108.Tool;

        if Tool then
            Tool = Tool.Parent == u42;
        end;

        return Tool;
    end;

    function u87.Delete(p109) -- Line: 541
        -- upvalues: u88 (ref), u43 (ref), u39 (ref), u32 (ref), u40 (ref)
        u88:Destroy();
        table.remove(u43, p109.Index);

        for i = p109.Index, #u43 do
            u43[i]:SlideBack();
        end;

        local v110 = math.floor(u39.AbsoluteSize.X / (u32 + 5));
        local v111 = (#u40:GetChildren() - 1) / v110;
        local v112 = math.ceil(v111) * (u32 + 5) + 5;
        u39.CanvasSize = UDim2.fromOffset(0, v112);
    end;

    function u87.Swap(p113, p114) -- Line: 554
        local Tool = p113.Tool;
        local Tool2 = p114.Tool;
        p113:Clear();

        if Tool2 then
            p114:Clear();
            p113:Fill(Tool2);
        end;

        if Tool then
            p114:Fill(Tool);

            return;
        end;

        p114:Clear();
    end;

    function u87.SlideBack(p115) -- Line: 568
        -- upvalues: u88 (ref)
        p115.Index = p115.Index - 1;
        u88.Name = p115.Index;
        u88.LayoutOrder = p115.Index;
    end;

    function u87.TurnNumber(p116, p117) -- Line: 574
        -- upvalues: u95 (ref)
        if u95 then
            u95.Visible = p117;
        end;
    end;

    function u87.SetClickability(p118, p119) -- Line: 580
        -- upvalues: UserInputService (ref), u88 (ref), u12 (ref)
        if p118.Tool then
            if UserInputService.VREnabled then
                u88.Draggable = false;
            else
                u88.Draggable = not p119;
            end;

            u88.SelectionImageObject = nil;
            u88.BackgroundTransparency = u88.Draggable and 0 or u12;
        end;
    end;

    function u87.CheckTerms(p120, p121) -- Line: 591
        -- upvalues: u91 (ref), u94 (ref)
        local u122 = 0;

        local function checkEm(p123, p124) -- Line: 593
            -- upvalues: u122 (ref)
            local _, v125 = p123:lower():gsub(p124, "");
            u122 = u122 + v125;
        end;

        local Tool = p120.Tool;

        if Tool then
            for i in pairs(p121) do
                local _, v126 = u91.Text:lower():gsub(i, "");
                u122 = u122 + v126;

                if Tool:IsA("Tool") then
                    local _, v127 = (u94 and u94.Text or ""):lower():gsub(i, "");
                    u122 = u122 + v127;
                end;
            end;
        end;

        return u122;
    end;

    function u87.Select(p128) -- Line: 611
        -- upvalues: u87 (copy), u42 (ref), Humanoid (ref), u49 (ref), u45 (ref), Backpack (ref)
        local Tool = u87.Tool;

        if Tool then
            local v129;

            if Tool then
                v129 = Tool.Parent == u42;
            else
                v129 = Tool;
            end;

            if v129 then
                if Humanoid then
                    Humanoid:UnequipTools();

                    if u49 then
                        u49:ToggleSelect();
                        u45[u49]:UpdateEquipView();
                        u49 = nil;
                    end;
                end;
            elseif Tool.Parent == Backpack then
                if Humanoid then
                    Humanoid:UnequipTools();

                    if u49 then
                        u49:ToggleSelect();
                        u45[u49]:UpdateEquipView();
                        u49 = nil;
                    end;
                end;

                Humanoid:EquipTool(Tool);
            end;
        end;
    end;

    u88 = Instance.new("TextButton");
    u88.Name = tostring(v86);
    u88.BackgroundColor3 = u9;
    u88.BorderColor3 = u15;
    u88.Text = "";
    u88.BorderSizePixel = 0;
    u88.Size = UDim2.fromOffset(u32, u32);
    u88.Active = true;
    u88.Draggable = false;
    u88.BackgroundTransparency = u12;
    u88.MouseButton1Click:Connect(function() -- Line: 634
        -- upvalues: u87 (copy)
        changeSlot(u87);
    end);
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "Corner";
    UICorner.CornerRadius = u14;
    UICorner.Parent = u88;
    u87.Frame = u88;
    local Frame = Instance.new("Frame");
    Frame.Name = "SelectionObjectClipper";
    Frame.BackgroundTransparency = 1;
    Frame.Visible = false;
    Frame.Parent = u88;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Selector";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.Image = "rbxasset://textures/ui/Keyboard/key_selection_9slice.png";
    ImageLabel.ScaleType = Enum.ScaleType.Slice;
    ImageLabel.SliceCenter = Rect.new(12, 12, 52, 52);
    ImageLabel.Parent = Frame;
    u90 = Instance.new("ImageLabel");
    u90.BackgroundTransparency = 1;
    u90.Name = "Icon";
    u90.Size = UDim2.fromScale(1, 1);
    u90.Position = UDim2.fromScale(0.5, 0.5);
    u90.AnchorPoint = Vector2.new(0.5, 0.5);

    if u5 == true then
        u90.Size = UDim2.new(1, -u13 * 2, 1, -u13 * 2);
    else
        u90.Size = UDim2.fromScale(1, 1);
    end;

    u90.Parent = u88;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "Corner";

    if u5 == true then
        UICorner2.CornerRadius = u14 - UDim.new(0, u13);
    else
        UICorner2.CornerRadius = u14;
    end;

    UICorner2.Parent = u90;
    u91 = Instance.new("TextLabel");
    u91.BackgroundTransparency = 1;
    u91.Name = "ToolName";
    u91.Text = "";
    u91.TextColor3 = u18;
    u91.TextStrokeTransparency = u19;
    u91.TextStrokeColor3 = u20;
    u91.FontFace = Font.new(u25.Family, Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    u91.TextSize = u26;
    u91.Size = UDim2.new(1, -u13 * 2, 1, -u13 * 2);
    u91.Position = UDim2.fromScale(0.5, 0.5);
    u91.AnchorPoint = Vector2.new(0.5, 0.5);
    u91.TextWrapped = true;
    u91.TextTruncate = Enum.TextTruncate.AtEnd;
    u91.Parent = u88;
    u87.Frame.LayoutOrder = u87.Index;

    if v86 <= u56 then
        u94 = Instance.new("TextLabel");
        u94.Name = "ToolTip";
        u94.Text = "";
        u94.Size = UDim2.fromScale(1, 1);
        u94.TextColor3 = u18;
        u94.TextStrokeTransparency = u19;
        u94.TextStrokeColor3 = u20;
        u94.FontFace = Font.new(u25.Family, Enum.FontWeight.Medium, Enum.FontStyle.Normal);
        u94.TextSize = u26;
        u94.ZIndex = 2;
        u94.TextWrapped = false;
        u94.TextYAlignment = Enum.TextYAlignment.Center;
        u94.BackgroundColor3 = u17;
        u94.BackgroundTransparency = u12;
        u94.AnchorPoint = Vector2.new(0.5, 1);
        u94.BorderSizePixel = 0;
        u94.Visible = false;
        u94.AutomaticSize = Enum.AutomaticSize.X;
        u94.Parent = u88;
        local UICorner3 = Instance.new("UICorner");
        UICorner3.Name = "Corner";
        UICorner3.CornerRadius = u16;
        UICorner3.Parent = u94;
        local UIPadding = Instance.new("UIPadding");
        UIPadding.PaddingLeft = UDim.new(0, 4);
        UIPadding.PaddingRight = UDim.new(0, 4);
        UIPadding.PaddingTop = UDim.new(0, 4);
        UIPadding.PaddingBottom = UDim.new(0, 4);
        UIPadding.Parent = u94;
        u88.MouseEnter:Connect(function() -- Line: 733
            -- upvalues: u94 (ref)
            if u94.Text ~= "" then
                u94.Visible = true;
            end;
        end);
        u88.MouseLeave:Connect(function() -- Line: 738
            -- upvalues: u94 (ref)
            u94.Visible = false;
        end);

        function u87.MoveToInventory(p130) -- Line: 742
            -- upvalues: u87 (copy), u56 (ref), MakeSlot (ref), u40 (ref), u42 (ref), Humanoid (ref), u49 (ref), u45 (ref), u53 (ref), u37 (ref)
            if u87.Index <= u56 then
                local Tool = u87.Tool;
                p130:Clear();
                local v131 = MakeSlot(u40);
                v131:Fill(Tool);

                if Tool then
                    Tool = Tool.Parent == u42;
                end;

                if Tool and Humanoid then
                    Humanoid:UnequipTools();

                    if u49 then
                        u49:ToggleSelect();
                        u45[u49]:UpdateEquipView();
                        u49 = nil;
                    end;
                end;

                if u53 then
                    v131.Frame.Visible = false;
                    v131.Parent = u37;
                end;
            end;
        end;

        if v86 < 10 or v86 == u56 then
            local v132 = v86 < 10 and (v86 or 0) or 0;
            u95 = Instance.new("TextLabel");
            u95.BackgroundTransparency = 1;
            u95.Name = "Number";
            u95.TextColor3 = u18;
            u95.TextStrokeTransparency = u19;
            u95.TextStrokeColor3 = u20;
            u95.TextSize = u26;
            u95.Text = tostring(v132);
            u95.FontFace = Font.new(u25.Family, Enum.FontWeight.Heavy, Enum.FontStyle.Normal);
            u95.Size = UDim2.fromScale(0.4, 0.4);
            u95.Visible = false;
            u95.Parent = u88;
            u46[Value2 + v132] = u87.Select;
        end;
    end;

    local Position = u88.Position;
    local u133 = 0;
    local u134 = nil;
    u88.DragBegin:Connect(function(p135) -- Line: 783
        -- upvalues: u47 (ref), u88 (ref), Position (ref), u30 (ref), u90 (ref), u91 (ref), u95 (ref), u134 (ref), u40 (ref), u37 (ref), u89 (ref)
        u47[u88] = true;
        Position = p135;
        u88.BorderSizePixel = 2;
        u30:lock();
        u88.ZIndex = 2;
        u90.ZIndex = 2;
        u91.ZIndex = 2;
        u88.Parent.ZIndex = 2;

        if u95 then
            u95.ZIndex = 2;
        end;

        u134 = u88.Parent;

        if u134 == u40 then
            local v136 = UDim2.new(0, u88.AbsolutePosition.X - u37.AbsolutePosition.X, 0, u88.AbsolutePosition.Y - u37.AbsolutePosition.Y);
            u88.Parent = u37;
            u88.Position = v136;
            u89 = Instance.new("Frame");
            u89.Name = "FakeSlot";
            u89.LayoutOrder = u88.LayoutOrder;
            u89.Size = u88.Size;
            u89.BackgroundTransparency = 1;
            u89.Parent = u40;
        end;
    end);
    u88.DragStopped:Connect(function(p137, p138) -- Line: 826
        -- upvalues: u89 (ref), u88 (ref), Position (ref), u134 (ref), u30 (ref), u90 (ref), u91 (ref), u95 (ref), u47 (ref), u87 (copy), u37 (ref), u56 (ref), u133 (ref), u44 (ref), u36 (ref), u43 (ref), u42 (ref), Humanoid (ref), u49 (ref), u45 (ref), u53 (ref)
        if u89 then
            u89:Destroy();
        end;

        local v139 = os.clock();
        u88.Position = Position;
        u88.Parent = u134;
        u88.BorderSizePixel = 0;
        u30:unlock();
        u88.ZIndex = 1;
        u90.ZIndex = 1;
        u91.ZIndex = 1;
        u134.ZIndex = 1;

        if u95 then
            u95.ZIndex = 1;
        end;

        u47[u88] = nil;

        if not u87.Tool then
            return;
        end;

        local v140 = u37;
        local AbsolutePosition = v140.AbsolutePosition;
        local AbsoluteSize = v140.AbsoluteSize;
        local v141;

        if AbsolutePosition.X < p137 and (p137 <= AbsolutePosition.X + AbsoluteSize.X and AbsolutePosition.Y < p138) then
            v141 = p138 <= AbsolutePosition.Y + AbsoluteSize.Y;
        else
            v141 = false;
        end;

        if v141 then
            if u87.Index <= u56 then
                u87:MoveToInventory();
            end;

            if u56 < u87.Index and v139 - u133 < 0.5 then
                if u44 then
                    local Tool = u87.Tool;
                    u87:Clear();
                    u44:Fill(Tool);
                    u87:Delete();
                    v139 = 0;
                else
                    v139 = 0;
                end;
            end;
        else
            local v142 = u36;
            local AbsolutePosition2 = v142.AbsolutePosition;
            local AbsoluteSize2 = v142.AbsoluteSize;
            local v143;

            if AbsolutePosition2.X < p137 and (p137 <= AbsolutePosition2.X + AbsoluteSize2.X and AbsolutePosition2.Y < p138) then
                v143 = p138 <= AbsolutePosition2.Y + AbsoluteSize2.Y;
            else
                v143 = false;
            end;

            if v143 then
                local v144 = { (1 / 0), nil };

                for i = 1, u56 do
                    local v145 = u43[i];
                    local Frame2 = v145.Frame;
                    local v146 = Vector2.new(p137, p138);
                    local Magnitude = (Frame2.AbsolutePosition + Frame2.AbsoluteSize / 2 - v146).Magnitude;

                    if Magnitude < v144[1] then
                        v144 = { Magnitude, v145 };
                    end;
                end;

                local v147 = v144[2];

                if v147 ~= u87 then
                    u87:Swap(v147);

                    if u56 < u87.Index then
                        local Tool = u87.Tool;

                        if Tool then
                            if Tool then
                                Tool = Tool.Parent == u42;
                            end;

                            if Tool and Humanoid then
                                Humanoid:UnequipTools();

                                if u49 then
                                    u49:ToggleSelect();
                                    u45[u49]:UpdateEquipView();
                                    u49 = nil;
                                end;
                            end;

                            if u53 then
                                u87.Frame.Visible = false;
                                u87.Frame.Parent = u37;
                            end;
                        else
                            u87:Delete();
                        end;
                    end;
                end;
            elseif u87.Index <= u56 then
                u87:MoveToInventory();
            end;
        end;

        u133 = v139;
    end);
    u88.Parent = p84;
    u43[v86] = u87;

    if u56 < v86 then
        local v148 = math.floor(u39.AbsoluteSize.X / (u32 + 5));
        local v149 = (#u40:GetChildren() - 1) / v148;
        local v150 = math.ceil(v149) * (u32 + 5) + 5;
        u39.CanvasSize = UDim2.fromOffset(0, v150);

        if u37.Visible and not u53 then
            u39.CanvasPosition = Vector2.new(0, (math.max(0, u39.CanvasSize.Y.Offset - u39.AbsoluteSize.Y)));
        end;
    end;

    return u87;
end;

local function OnChildAdded(p151) -- Line: 936
    -- upvalues: u42 (ref), Humanoid (ref), u49 (ref), u45 (copy), u50 (ref), LocalPlayer (ref), u44 (ref), MakeSlot (copy), u40 (ref), u43 (copy), Backpack (ref), AdjustHotbarFrames (copy), u56 (copy), u37 (ref), u1 (copy)
    if not (p151:IsA("Tool") or p151:IsA("HopperBin")) then
        if p151:IsA("Humanoid") and p151.Parent == u42 then
            Humanoid = p151;
        end;

        return;
    end;

    local _ = p151.Parent == u42;

    if u49 and p151.Parent == u42 then
        u49:ToggleSelect();
        u45[u49]:UpdateEquipView();
        u49 = nil;
    end;

    if not u50 and (p151.Parent == u42 and not u45[p151]) then
        local StarterGear = LocalPlayer:FindFirstChild("StarterGear");

        if StarterGear and StarterGear:FindFirstChild(p151.Name) then
            u50 = true;

            for i = (u44 or MakeSlot(u40)).Index, 1, -1 do
                local v152 = u43[i];
                local v153 = i - 1;

                if v153 > 0 then
                    u43[v153]:Swap(v152);
                else
                    v152:Fill(p151);
                end;
            end;

            for _, child in pairs(u42:GetChildren()) do
                if child:IsA("Tool") and child ~= p151 then
                    child.Parent = Backpack;
                end;
            end;

            AdjustHotbarFrames();

            return;
        end;
    end;

    local v154 = u45[p151];

    if v154 then
        v154:UpdateEquipView();
    else
        local v155 = u44 or MakeSlot(u40);
        v155:Fill(p151);

        if v155.Index <= u56 and not u37.Visible then
            AdjustHotbarFrames();
        end;

        if p151:IsA("HopperBin") and p151.Active then
            if Humanoid then
                Humanoid:UnequipTools();

                if u49 then
                    u49:ToggleSelect();
                    u45[u49]:UpdateEquipView();
                    u49 = nil;
                end;
            end;

            u49 = p151;
        end;
    end;

    u1.BackpackItemAdded:Fire();
end;

local function OnChildRemoved(p156) -- Line: 1003
    -- upvalues: u42 (ref), Backpack (ref), u45 (copy), u56 (copy), u37 (ref), AdjustHotbarFrames (copy), u49 (ref), u1 (copy), u43 (copy)
    if not (p156:IsA("Tool") or p156:IsA("HopperBin")) then
        return;
    end;

    local Parent = p156.Parent;

    if Parent == u42 or Parent == Backpack then
        return;
    end;

    local v157 = u45[p156];

    if v157 then
        v157:Clear();

        if u56 < v157.Index then
            v157:Delete();
        elseif not u37.Visible then
            AdjustHotbarFrames();
        end;
    end;

    if p156 == u49 then
        u49 = nil;
    end;

    u1.BackpackItemRemoved:Fire();
    local v158 = true;

    for i = u56 + 1, #u43 do
        local v159 = u43[i];

        if v159 and v159.Tool then
            v158 = false;
            break;
        end;
    end;

    if v158 then
        u1.BackpackEmpty:Fire();
    end;
end;

local function OnCharacterAdded(p160) -- Line: 1037
    -- upvalues: u43 (copy), u56 (copy), u49 (ref), u54 (ref), u42 (ref), OnChildRemoved (copy), OnChildAdded (copy), Backpack (ref), LocalPlayer (ref), AdjustHotbarFrames (copy)
    for i = #u43, 1, -1 do
        local v161 = u43[i];

        if v161.Tool then
            v161:Clear();
        end;

        if u56 < i then
            v161:Delete();
        end;
    end;

    u49 = nil;

    for _, v in pairs(u54) do
        v:Disconnect();
    end;

    u54 = {};
    u42 = p160;
    table.insert(u54, p160.ChildRemoved:Connect(OnChildRemoved));
    table.insert(u54, p160.ChildAdded:Connect(OnChildAdded));

    for _, child in pairs(p160:GetChildren()) do
        OnChildAdded(child);
    end;

    Backpack = LocalPlayer:WaitForChild("Backpack");
    table.insert(u54, Backpack.ChildRemoved:Connect(OnChildRemoved));
    table.insert(u54, Backpack.ChildAdded:Connect(OnChildAdded));

    for _, child in pairs(Backpack:GetChildren()) do
        OnChildAdded(child);
    end;

    AdjustHotbarFrames();
end;

local function OnInputBegan(p162, p163) -- Line: 1076
    -- upvalues: TextChatService (copy), u52 (ref), u51 (ref), Value (copy), u46 (copy), u37 (ref), u30 (copy)
    local v164 = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration");
    local v165 = p162.UserInputType == Enum.UserInputType.Keyboard and (not u52 and (not v164.IsFocused and (u51 or p162.KeyCode.Value == Value))) and u46[p162.KeyCode.Value];

    if v165 then
        v165(p163);
    end;

    local UserInputType = p162.UserInputType;

    if not p163 and (UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch) and u37.Visible then
        u30:deselect();
    end;
end;

local function OnUISChanged() -- Line: 1102
    -- upvalues: UserInputService (copy), u56 (copy), u43 (copy), u27 (copy), u28 (copy)
    if UserInputService:GetLastInputType() == Enum.UserInputType.Touch then
        for i = 1, u56 do
            u43[i]:TurnNumber(false);
        end;

        return;
    end;

    if UserInputService:GetLastInputType() == Enum.UserInputType.Keyboard then
        for i = 1, u56 do
            u43[i]:TurnNumber(true);
        end;

        return;
    end;

    for _, v in pairs(u27) do
        if UserInputService:GetLastInputType() == v then
            for i = 1, u56 do
                u43[i]:TurnNumber(true);
            end;

            return;
        end;
    end;

    for _, v in pairs(u28) do
        if UserInputService:GetLastInputType() == v then
            for i = 1, u56 do
                u43[i]:TurnNumber(false);
            end;

            return;
        end;
    end;
end;

local u166 = nil;
local u167 = nil;

local function u168() -- Line: 1143
end;

function unbindAllGamepadEquipActions()
    -- upvalues: ContextActionService (copy)
    ContextActionService:UnbindAction("BackpackHasGamepadFocus");
    ContextActionService:UnbindAction("BackpackCloseInventory");
end;

u41 = function(p169, p170, u171) -- Line: 1222
    -- upvalues: u166 (ref), u167 (ref), Humanoid (ref), u49 (ref), u45 (copy), u56 (copy), u43 (copy), u58 (ref)
    if p170 ~= Enum.UserInputState.Begin then
        return;
    end;

    if u166 and (u166.KeyCode == Enum.KeyCode.ButtonR1 and u171.KeyCode == Enum.KeyCode.ButtonL1 or u166.KeyCode == Enum.KeyCode.ButtonL1 and u171.KeyCode == Enum.KeyCode.ButtonR1) and os.clock() - u167 <= 0.06 then
        if Humanoid then
            Humanoid:UnequipTools();

            if u49 then
                u49:ToggleSelect();
                u45[u49]:UpdateEquipView();
                u49 = nil;
            end;
        end;

        u166 = u171;
        u167 = os.clock();

        return;
    end;

    u166 = u171;
    u167 = os.clock();
    task.delay(0.06, function() -- Line: 1250
        -- upvalues: u166 (ref), u171 (copy), u56 (ref), u43 (ref), Humanoid (ref), u49 (ref), u45 (ref), u58 (ref)
        if u166 ~= u171 then
            return;
        end;

        local v172 = u171.KeyCode == Enum.KeyCode.ButtonL1 and -1 or 1;

        for i = 1, u56 do
            if u43[i]:IsEquipped() then
                local v173 = v172 + i;
                local v174 = false;

                if u56 < v173 then
                    v173 = 1;
                    v174 = true;
                elseif v173 < 1 then
                    v173 = u56;
                    v174 = true;
                end;

                local v175 = v173;

                while not u43[v173].Tool do
                    v173 = v173 + v172;

                    if v173 == v175 then
                        return;
                    end;

                    if u56 < v173 then
                        v173 = 1;
                        v174 = true;
                    elseif v173 < 1 then
                        v173 = u56;
                        v174 = true;
                    end;
                end;

                if not v174 then
                    u43[v173]:Select();

                    return;
                end;

                if Humanoid then
                    Humanoid:UnequipTools();

                    if u49 then
                        u49:ToggleSelect();
                        u45[u49]:UpdateEquipView();
                        u49 = nil;
                    end;
                end;

                u58 = nil;

                return;
            end;
        end;

        if u58 and u58.Tool then
            u58:Select();

            return;
        end;

        for i = v172 == -1 and (u56 or 1) or 1, v172 == -1 and 1 or u56, v172 do
            if u43[i].Tool then
                u43[i]:Select();

                return;
            end;
        end;
    end);
end;

function getGamepadSwapSlot()
    -- upvalues: u43 (copy)
    for i = 1, #u43 do
        if u43[i].Frame.BorderSizePixel > 0 then
            return u43[i];
        end;
    end;
end;

function changeSlot(u176)
    -- upvalues: VRService (copy), u37 (ref), GuiService (copy), u38 (ref), u56 (copy)
    if u176.Frame == GuiService.SelectedObject and (not VRService.VREnabled or u37.Visible) then
        local v177 = getGamepadSwapSlot();

        if not v177 then
            local Size = u176.Frame.Size;
            local Position = u176.Frame.Position;
            u176.Frame:TweenSizeAndPosition(Size + UDim2.fromOffset(10, 10), Position - UDim2.fromOffset(5, 5), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true, function() -- Line: 1363
                -- upvalues: u176 (copy), Size (copy), Position (copy)
                u176.Frame:TweenSizeAndPosition(Size, Position, Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.1, true);
            end);
            u176.Frame.BorderSizePixel = 3;
            u38.SelectionImageObject.Visible = true;

            return;
        end;

        v177.Frame.BorderSizePixel = 0;

        if v177 ~= u176 then
            u176:Swap(v177);
            u38.SelectionImageObject.Visible = false;

            if u56 < u176.Index and not u176.Tool then
                if GuiService.SelectedObject == u176.Frame then
                    GuiService.SelectedObject = v177.Frame;
                end;

                u176:Delete();
            end;

            if u56 < v177.Index and not v177.Tool then
                if GuiService.SelectedObject == v177.Frame then
                    GuiService.SelectedObject = u176.Frame;
                end;

                v177:Delete();
            end;
        end;
    else
        u176:Select();
        u38.SelectionImageObject.Visible = false;
    end;
end;

function vrMoveSlotToInventory()
    -- upvalues: VRService (copy), u38 (ref)
    if not VRService.VREnabled then
        return;
    end;

    local v178 = getGamepadSwapSlot();

    if v178 and v178.Tool then
        v178.Frame.BorderSizePixel = 0;
        v178:MoveToInventory();
        u38.SelectionImageObject.Visible = false;
    end;
end;

function enableGamepadInventoryControl()
    -- upvalues: u37 (ref), u30 (copy), ContextActionService (copy), u168 (copy), GuiService (copy), u36 (ref)
    local function v180() -- Line: 1397
        -- upvalues: u37 (ref), u30 (ref)
        if getGamepadSwapSlot() then
            local v179 = getGamepadSwapSlot();

            if v179 then
                v179.Frame.BorderSizePixel = 0;
            end;
        elseif u37.Visible then
            u30:deselect();
        end;
    end;

    ContextActionService:BindAction("BackpackHasGamepadFocus", u168, false, Enum.UserInputType.Gamepad1);
    ContextActionService:BindAction("BackpackCloseInventory", v180, false, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonStart);

    if true then
        GuiService.SelectedObject = u36:FindFirstChild("1");
    end;
end;

function disableGamepadInventoryControl()
    -- upvalues: u56 (copy), u43 (copy), GuiService (copy), u35 (ref)
    unbindAllGamepadEquipActions();

    for i = 1, u56 do
        local v181 = u43[i];

        if v181 and v181.Frame then
            v181.Frame.BorderSizePixel = 0;
        end;
    end;

    if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(u35) then
        GuiService.SelectedObject = nil;
    end;
end;

local function bindBackpackHotbarAction() -- Line: 1445
    -- upvalues: u51 (ref), u33 (ref), ContextActionService (copy), u41 (ref)
    if u51 and not u33 then
        u33 = true;
        ContextActionService:BindAction("BackpackHotbarEquip", u41, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1);
    end;
end;

local function unbindBackpackHotbarAction() -- Line: 1458
    -- upvalues: u33 (ref), ContextActionService (copy)
    disableGamepadInventoryControl();
    u33 = false;
    ContextActionService:UnbindAction("BackpackHotbarEquip");
end;

function gamepadDisconnected()
    -- upvalues: u55 (ref)
    u55 = false;
    disableGamepadInventoryControl();
end;

function gamepadConnected()
    -- upvalues: u55 (ref), GuiService (copy), u35 (ref), u48 (ref), u51 (ref), u33 (ref), ContextActionService (copy), u41 (ref), u37 (ref)
    u55 = true;
    GuiService:AddSelectionParent("BackpackSelection", u35);

    if u48 >= 1 and (u51 and not u33) then
        u33 = true;
        ContextActionService:BindAction("BackpackHotbarEquip", u41, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1);
    end;

    if u37.Visible then
        enableGamepadInventoryControl();
    end;
end;

local function OnIconChanged(u182) -- Line: 1482
    -- upvalues: StarterGui (copy), u51 (ref), u35 (ref), u48 (ref), u33 (ref), ContextActionService (copy), u41 (ref)
    local success, _ = pcall(function() -- Line: 1484
        -- upvalues: u182 (copy), StarterGui (ref)
        local v183 = u182 and StarterGui:GetCore("TopbarEnabled");

        return v183;
    end);

    if not success then
        return;
    end;

    u51 = u182;
    u35.Visible = u182;

    if u182 then
        if u48 >= 1 and (u51 and not u33) then
            u33 = true;
            ContextActionService:BindAction("BackpackHotbarEquip", u41, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1);
        end;
    else
        disableGamepadInventoryControl();
        u33 = false;
        ContextActionService:UnbindAction("BackpackHotbarEquip");
    end;
end;

local function MakeVRRoundButton(p184, p185) -- Line: 1513
    local ImageButton = Instance.new("ImageButton");
    ImageButton.BackgroundTransparency = 1;
    ImageButton.Name = p184;
    ImageButton.Size = UDim2.fromOffset(40, 40);
    ImageButton.Image = "rbxasset://textures/ui/Keyboard/close_button_background.png";
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Icon";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Size = UDim2.fromScale(0.5, 0.5);
    ImageLabel.Position = UDim2.fromScale(0.25, 0.25);
    ImageLabel.Image = p185;
    ImageLabel.Parent = ImageButton;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Name = "Selection";
    ImageLabel2.Size = UDim2.fromScale(0.9, 0.9);
    ImageLabel2.Position = UDim2.fromScale(0.05, 0.05);
    ImageLabel2.Image = "rbxasset://textures/ui/Keyboard/close_button_selection.png";
    ImageButton.SelectionImageObject = ImageLabel2;

    return ImageButton, ImageLabel, ImageLabel2;
end;

u35 = Instance.new("Frame");
u35.BackgroundTransparency = 1;
u35.Name = "Backpack";
u35.Size = UDim2.fromScale(1, 1);
u35.Visible = false;
u35.Parent = ScreenGui;
u36 = Instance.new("Frame");
u36.BackgroundTransparency = 1;
u36.Name = "Hotbar";
u36.Size = UDim2.fromScale(1, 1);
u36.Parent = u35;

for i = 1, u56 do
    local v186 = MakeSlot(u36, i);
    v186.Frame.Visible = false;

    if not u44 then
        u44 = v186;
    end;
end;

local ImageLabel = Instance.new("ImageLabel");
ImageLabel.BackgroundTransparency = 1;
ImageLabel.Name = "LeftBumper";
ImageLabel.Size = UDim2.fromOffset(40, 40);
ImageLabel.Position = UDim2.new(0, -ImageLabel.Size.X.Offset, 0.5, -ImageLabel.Size.Y.Offset / 2);
local ImageLabel2 = Instance.new("ImageLabel");
ImageLabel2.BackgroundTransparency = 1;
ImageLabel2.Name = "RightBumper";
ImageLabel2.Size = UDim2.fromOffset(40, 40);
ImageLabel2.Position = UDim2.new(1, 0, 0.5, -ImageLabel2.Size.Y.Offset / 2);
u37 = Instance.new("Frame");
u37.Name = "Inventory";
u37.Size = UDim2.fromScale(1, 1);
u37.BackgroundTransparency = u7;
u37.BackgroundColor3 = u9;
u37.Active = true;
u37.Visible = false;
u37.Parent = u35;
local UICorner = Instance.new("UICorner");
UICorner.Name = "Corner";
UICorner.CornerRadius = v8;
UICorner.Parent = u37;
u38 = Instance.new("TextButton");
u38.Name = "VRInventorySelector";
u38.Position = UDim2.new(0, 0, 0, 0);
u38.Size = UDim2.fromScale(1, 1);
u38.BackgroundTransparency = 1;
u38.Text = "";
u38.Parent = u37;
local ImageLabel3 = Instance.new("ImageLabel");
ImageLabel3.BackgroundTransparency = 1;
ImageLabel3.Name = "Selector";
ImageLabel3.Size = UDim2.fromScale(1, 1);
ImageLabel3.Image = "rbxasset://textures/ui/Keyboard/key_selection_9slice.png";
ImageLabel3.ScaleType = Enum.ScaleType.Slice;
ImageLabel3.SliceCenter = Rect.new(12, 12, 52, 52);
ImageLabel3.Visible = false;
u38.SelectionImageObject = ImageLabel3;
u38.MouseButton1Click:Connect(function() -- Line: 1610
    vrMoveSlotToInventory();
end);
u39 = Instance.new("ScrollingFrame");
u39.BackgroundTransparency = 1;
u39.Name = "ScrollingFrame";
u39.Size = UDim2.fromScale(1, 1);
u39.Selectable = false;
u39.ScrollingDirection = Enum.ScrollingDirection.Y;
u39.BorderSizePixel = 0;
u39.ScrollBarThickness = 8;
u39.ScrollBarImageColor3 = Color3.new(1, 1, 1);
u39.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
u39.CanvasSize = UDim2.new(0, 0, 0, 0);
u39.Parent = u37;
u40 = Instance.new("Frame");
u40.BackgroundTransparency = 1;
u40.Name = "UIGridFrame";
u40.Selectable = false;
u40.Size = UDim2.new(1, -10, 1, 0);
u40.Position = UDim2.fromOffset(5, 0);
u40.Parent = u39;
local UIGridLayout = Instance.new("UIGridLayout");
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder;
UIGridLayout.CellSize = UDim2.fromOffset(u32, u32);
UIGridLayout.CellPadding = UDim2.fromOffset(5, 5);
UIGridLayout.Parent = u40;
local u187 = MakeVRRoundButton("ScrollUpButton", "rbxasset://textures/ui/Backpack/ScrollUpArrow.png");
u187.Size = UDim2.fromOffset(34, 34);
u187.Position = UDim2.new(0.5, -u187.Size.X.Offset / 2, 0, 43);
u187.Icon.Position = u187.Icon.Position - UDim2.fromOffset(0, 2);
u187.MouseButton1Click:Connect(function() -- Line: 1647
    -- upvalues: u39 (ref), u32 (ref)
    local new = Vector2.new;
    local X = u39.CanvasPosition.X;
    local v188 = u39.CanvasSize.Y.Offset - u39.AbsoluteWindowSize.Y;
    local v189 = math.max(0, u39.CanvasPosition.Y - (u32 + 5));
    u39.CanvasPosition = new(X, (math.min(v188, v189)));
end);
local u190 = MakeVRRoundButton("ScrollDownButton", "rbxasset://textures/ui/Backpack/ScrollUpArrow.png");
u190.Rotation = 180;
u190.Icon.Position = u190.Icon.Position - UDim2.fromOffset(0, 2);
u190.Size = UDim2.fromOffset(34, 34);
u190.Position = UDim2.new(0.5, -u190.Size.X.Offset / 2, 1, -u190.Size.Y.Offset - 3);
u190.MouseButton1Click:Connect(function() -- Line: 1664
    -- upvalues: u39 (ref), u32 (ref)
    local new = Vector2.new;
    local X = u39.CanvasPosition.X;
    local v191 = u39.CanvasSize.Y.Offset - u39.AbsoluteWindowSize.Y;
    local v192 = math.max(0, u39.CanvasPosition.Y + (u32 + 5));
    u39.CanvasPosition = new(X, (math.min(v191, v192)));
end);
u39.Changed:Connect(function(p193) -- Line: 1675
    -- upvalues: u39 (ref), u187 (ref), u190 (ref)
    if p193 == "AbsoluteWindowSize" or (p193 == "CanvasPosition" or p193 == "CanvasSize") then
        local v194 = u39.CanvasPosition.Y < u39.CanvasSize.Y.Offset - u39.AbsoluteWindowSize.Y;
        u187.Visible = u39.CanvasPosition.Y ~= 0;
        u190.Visible = v194;
    end;
end);
UpdateBackpackLayout();
local Frame = Instance.new("Frame");
Frame.Name = "GamepadHintsFrame";
Frame.Size = UDim2.fromOffset(u36.Size.X.Offset, u31 and 95 or 60);
Frame.BackgroundTransparency = u7;
Frame.BackgroundColor3 = u9;
Frame.Visible = false;
Frame.Parent = u35;
local UIListLayout = Instance.new("UIListLayout");
UIListLayout.Name = "Layout";
UIListLayout.Padding = UDim.new(0, 25);
UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
UIListLayout.Parent = Frame;
local UICorner2 = Instance.new("UICorner");
UICorner2.Name = "Corner";
UICorner2.CornerRadius = v8;
UICorner2.Parent = Frame;

local function addGamepadHint(p195, p196) -- Line: 1711
    -- upvalues: Frame (copy), u31 (copy), u25 (copy)
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "HintFrame";
    Frame2.AutomaticSize = Enum.AutomaticSize.XY;
    Frame2.BackgroundTransparency = 1;
    Frame2.Parent = Frame;
    local UIListLayout2 = Instance.new("UIListLayout");
    UIListLayout2.Name = "Layout";
    UIListLayout2.Padding = u31 and UDim.new(0, 20) or UDim.new(0, 12);
    UIListLayout2.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout2.Parent = Frame2;
    local ImageLabel4 = Instance.new("ImageLabel");
    ImageLabel4.Name = "HintImage";
    ImageLabel4.Size = u31 and UDim2.fromOffset(60, 60) or UDim2.fromOffset(30, 30);
    ImageLabel4.BackgroundTransparency = 1;
    ImageLabel4.Image = p195;
    ImageLabel4.Parent = Frame2;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "HintText";
    TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
    TextLabel.FontFace = Font.new(u25.Family, Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel.TextSize = u31 and 32 or 19;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Text = p196;
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.TextYAlignment = Enum.TextYAlignment.Center;
    TextLabel.TextWrapped = true;
    TextLabel.Parent = Frame2;
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint");
    UITextSizeConstraint.MaxTextSize = TextLabel.TextSize;
    UITextSizeConstraint.Parent = TextLabel;
end;

addGamepadHint(UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonX), "Remove From Hotbar");
addGamepadHint(UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonA), "Select/Swap");
addGamepadHint(UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonB), "Close Backpack");

local function resizeGamepadHintsFrame() -- Line: 1755
    -- upvalues: Frame (copy), u36 (ref), u31 (copy), u37 (ref)
    Frame.Size = UDim2.new(u36.Size.X.Scale, u36.Size.X.Offset, 0, u31 and 95 or 60);
    Frame.Position = UDim2.new(u36.Position.X.Scale, u36.Position.X.Offset, u37.Position.Y.Scale, u37.Position.Y.Offset - Frame.Size.Y.Offset - 5);
    local v197 = Frame:GetChildren();
    local v198 = {};
    local v199 = 0;

    for _, v in pairs(v197) do
        if v:IsA("GuiObject") then
            table.insert(v198, v);
        end;
    end;

    for i = 1, #v198 do
        if v198[i]:IsA("GuiObject") then
            v198[i].Size = UDim2.new(1, 0, 1, -5);
            v198[i].Position = UDim2.new(0, 0, 0, 0);
            v199 = v199 + (v198[i].HintText.Position.X.Offset + v198[i].HintText.TextBounds.X);
        end;
    end;

    local v200 = (Frame.AbsoluteSize.X - v199) / (#v198 - 1);

    for i = 1, #v198 do
        v198[i].Position = i == 1 and UDim2.new(0, 0, 0, 0) or UDim2.new(0, v198[i - 1].Position.X.Offset + v198[i - 1].Size.X.Offset + v200, 0, 0);
        v198[i].Size = UDim2.new(0, v198[i].HintText.Position.X.Offset + v198[i].HintText.TextBounds.X, 1, -5);
    end;
end;

local Frame2 = Instance.new("Frame");
Frame2.Name = "Search";
Frame2.BackgroundColor3 = v21;
Frame2.BackgroundTransparency = u22;
Frame2.Size = UDim2.new(0, 190, 0, 30);
Frame2.Position = UDim2.new(1, -Frame2.Size.X.Offset - 5, 0, 5);
Frame2.Parent = u37;
local UICorner3 = Instance.new("UICorner");
UICorner3.Name = "Corner";
UICorner3.CornerRadius = v24;
UICorner3.Parent = Frame2;
local UIStroke = Instance.new("UIStroke");
UIStroke.Name = "Border";
UIStroke.Color = v23;
UIStroke.Thickness = 1;
UIStroke.Transparency = 0.8;
UIStroke.Parent = Frame2;
local TextBox = Instance.new("TextBox");
TextBox.BackgroundTransparency = 1;
TextBox.Name = "TextBox";
TextBox.Text = "";
TextBox.TextColor3 = u18;
TextBox.TextStrokeTransparency = u19;
TextBox.TextStrokeColor3 = u20;
TextBox.FontFace = Font.new(u25.Family, Enum.FontWeight.Medium, Enum.FontStyle.Normal);
TextBox.PlaceholderText = "Search";
TextBox.TextColor3 = u18;
TextBox.TextTransparency = u19;
TextBox.TextStrokeColor3 = u20;
TextBox.ClearTextOnFocus = false;
TextBox.TextTruncate = Enum.TextTruncate.AtEnd;
TextBox.TextSize = u26;
TextBox.TextXAlignment = Enum.TextXAlignment.Left;
TextBox.TextYAlignment = Enum.TextYAlignment.Center;
TextBox.Size = UDim2.new(0, 154, 0, 14);
TextBox.AnchorPoint = Vector2.new(0, 0.5);
TextBox.Position = UDim2.new(0, 8, 0.5, 0);
TextBox.ZIndex = 2;
TextBox.Parent = Frame2;
local TextButton = Instance.new("TextButton");
TextButton.Name = "X";
TextButton.Text = "";
TextButton.Size = UDim2.fromOffset(30, 30);
TextButton.Position = UDim2.new(1, -TextButton.Size.X.Offset, 0.5, -TextButton.Size.Y.Offset / 2);
TextButton.ZIndex = 4;
TextButton.Visible = false;
TextButton.BackgroundTransparency = 1;
TextButton.Parent = Frame2;
local ImageButton = Instance.new("ImageButton");
ImageButton.Name = "X";
ImageButton.Image = "rbxasset://textures/ui/InspectMenu/x.png";
ImageButton.BackgroundTransparency = 1;
ImageButton.Size = UDim2.new(0, Frame2.Size.Y.Offset - 20, 0, Frame2.Size.Y.Offset - 20);
ImageButton.AnchorPoint = Vector2.new(0.5, 0.5);
ImageButton.Position = UDim2.fromScale(0.5, 0.5);
ImageButton.ZIndex = 1;
ImageButton.BorderSizePixel = 0;
ImageButton.Parent = TextButton;

local function search() -- Line: 1892
    -- upvalues: TextBox (copy), u56 (copy), u43 (copy), u37 (ref), u53 (ref), u40 (ref), u39 (ref), u32 (ref), TextButton (copy)
    local v201 = {};

    for i in TextBox.Text:gmatch("%S+") do
        v201[i:lower()] = true;
    end;

    local v202 = {};

    for i = u56 + 1, #u43 do
        local v203 = u43[i];
        local v204 = { v203, (v203:CheckTerms(v201)) };
        table.insert(v202, v204);
        v203.Frame.Visible = false;
        v203.Frame.Parent = u37;
    end;

    table.sort(v202, function(p205, p206) -- Line: 1907
        return p205[2] > p206[2];
    end);
    u53 = true;
    local v207 = 0;

    for _, v in ipairs(v202) do
        local v208 = v[1];

        if v[2] > 0 then
            v208.Frame.Visible = true;
            v208.Frame.Parent = u40;
            v208.Frame.LayoutOrder = u56 + v207;
            v207 = v207 + 1;
        end;
    end;

    u39.CanvasPosition = Vector2.new(0, 0);
    local v209 = math.floor(u39.AbsoluteSize.X / (u32 + 5));
    local v210 = (#u40:GetChildren() - 1) / v209;
    local v211 = math.ceil(v210) * (u32 + 5) + 5;
    u39.CanvasSize = UDim2.fromOffset(0, v211);
    TextButton.ZIndex = 3;
end;

local function clearResults() -- Line: 1929
    -- upvalues: TextButton (copy), u53 (ref), u56 (copy), u43 (copy), u40 (ref), u39 (ref), u32 (ref)
    if TextButton.ZIndex > 0 then
        u53 = false;

        for i = u56 + 1, #u43 do
            local v212 = u43[i];
            v212.Frame.LayoutOrder = v212.Index;
            v212.Frame.Parent = u40;
            v212.Frame.Visible = true;
        end;

        TextButton.ZIndex = 0;
    end;

    local v213 = math.floor(u39.AbsoluteSize.X / (u32 + 5));
    local v214 = (#u40:GetChildren() - 1) / v213;
    local v215 = math.ceil(v214) * (u32 + 5) + 5;
    u39.CanvasSize = UDim2.fromOffset(0, v215);
end;

TextButton.MouseButton1Click:Connect(function() -- Line: 1943, Name: reset
    -- upvalues: clearResults (copy), TextBox (copy)
    clearResults();
    TextBox.Text = "";
end);
TextBox.Changed:Connect(function(p216) -- Line: 1948, Name: onChanged
    -- upvalues: TextBox (copy), u19 (copy), clearResults (copy), search (copy), TextButton (copy)
    if p216 == "Text" then
        local Text = TextBox.Text;

        if Text == "" then
            TextBox.TextTransparency = u19;
            clearResults();
        elseif Text ~= "" then
            TextBox.TextTransparency = 0;
            search();
        end;

        local v217;

        if Text == "" then
            v217 = false;
        else
            v217 = Text ~= "";
        end;

        TextButton.Visible = v217;
    end;
end);
TextBox.FocusLost:Connect(function(p218) -- Line: 1962, Name: focusLost
    -- upvalues: search (copy)
    if p218 then
        search();
    end;
end);
u1.StateChanged.Event:Connect(function(p219) -- Line: 1973
    -- upvalues: clearResults (copy), TextBox (copy)
    if not p219 then
        clearResults();
        TextBox.Text = "";
    end;
end);

u46[Enum.KeyCode.Escape.Value] = function(p220) -- Line: 1981
    -- upvalues: clearResults (copy), TextBox (copy)
    if p220 then
        clearResults();
        TextBox.Text = "";
    end;
end;

UserInputService.LastInputTypeChanged:Connect(function(p221) -- Line: 1986, Name: detectGamepad
    -- upvalues: UserInputService (copy), Frame2 (copy)
    if p221 == Enum.UserInputType.Gamepad1 and not UserInputService.VREnabled then
        Frame2.Visible = false;

        return;
    end;

    Frame2.Visible = true;
end);
GuiService.MenuOpened:Connect(function() -- Line: 1997
    -- upvalues: ScreenGui (copy), u30 (copy)
    ScreenGui.Enabled = false;
    u30:setEnabled(false);
end);
GuiService.MenuClosed:Connect(function() -- Line: 2003
    -- upvalues: ScreenGui (copy), u30 (copy)
    ScreenGui.Enabled = true;
    u30:setEnabled(true);
end);

local function u225(p222, p223, p224) -- Line: 2010
    -- upvalues: GuiService (copy), u56 (copy), u43 (copy)
    if p223 ~= Enum.UserInputState.Begin then
        return;
    end;

    if not GuiService.SelectedObject then
        return;
    end;

    for i = 1, u56 do
        if u43[i].Frame == GuiService.SelectedObject and u43[i].Tool then
            u43[i]:MoveToInventory();

            return;
        end;
    end;
end;

local function openClose() -- Line: 2026
    -- upvalues: u47 (copy), u37 (ref), AdjustHotbarFrames (copy), u36 (ref), u56 (copy), u43 (copy), u55 (ref), u28 (copy), UserInputService (copy), resizeGamepadHintsFrame (copy), Frame (copy), ContextActionService (copy), u225 (copy), u1 (copy)
    if not next(u47) then
        u37.Visible = not u37.Visible;
        local Visible = u37.Visible;
        AdjustHotbarFrames();
        u36.Active = not u36.Active;

        for i = 1, u56 do
            u43[i]:SetClickability(not Visible);
        end;
    end;

    if u37.Visible then
        if u55 then
            if u28[UserInputService:GetLastInputType()] then
                resizeGamepadHintsFrame();
                Frame.Visible = not UserInputService.VREnabled;
            end;

            enableGamepadInventoryControl();
        end;
    else
        if u55 then
            Frame.Visible = false;
        end;

        disableGamepadInventoryControl();
    end;

    if u37.Visible then
        ContextActionService:BindAction("BackpackRemoveSlot", u225, false, Enum.KeyCode.ButtonX);
    else
        ContextActionService:UnbindAction("BackpackRemoveSlot");
    end;

    u1.IsOpen = u37.Visible;
    u1.StateChanged:Fire(u37.Visible);
end;

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false);
u1.OpenClose = openClose;

while not LocalPlayer do
    task.wait();
    LocalPlayer = Players.LocalPlayer;
end;

LocalPlayer.CharacterAdded:Connect(OnCharacterAdded);

if LocalPlayer.Character then
    OnCharacterAdded(LocalPlayer.Character);
end;

UserInputService.InputBegan:Connect(OnInputBegan);
UserInputService.TextBoxFocused:Connect(function() -- Line: 2089
    -- upvalues: u52 (ref)
    u52 = true;
end);
UserInputService.TextBoxFocusReleased:Connect(function() -- Line: 2092
    -- upvalues: u52 (ref)
    u52 = false;
end);

u46[Value] = function() -- Line: 2097
    -- upvalues: u49 (ref), Humanoid (ref), u45 (copy)
    if u49 and Humanoid then
        Humanoid:UnequipTools();

        if u49 then
            u49:ToggleSelect();
            u45[u49]:UpdateEquipView();
            u49 = nil;
        end;
    end;
end;

UserInputService.LastInputTypeChanged:Connect(OnUISChanged);
OnUISChanged();

if UserInputService:GetGamepadConnected(Enum.UserInputType.Gamepad1) then
    gamepadConnected();
end;

UserInputService.GamepadConnected:Connect(function(p226) -- Line: 2111
    if p226 == Enum.UserInputType.Gamepad1 then
        gamepadConnected();
    end;
end);
UserInputService.GamepadDisconnected:Connect(function(p227) -- Line: 2116
    if p227 == Enum.UserInputType.Gamepad1 then
        gamepadDisconnected();
    end;
end);

function u1.SetBackpackEnabled(p228, p229) -- Line: 2124
    -- upvalues: u29 (ref)
    u29 = p229;
end;

function u1.IsOpened(p230) -- Line: 2129
    -- upvalues: u1 (copy)
    return u1.IsOpen;
end;

function u1.GetBackpackEnabled(p231) -- Line: 2134
    -- upvalues: u29 (ref)
    return u29;
end;

function u1.GetStateChangedEvent(p232) -- Line: 2139
    -- upvalues: u1 (copy)
    return u1.StateChanged;
end;

RunService.Heartbeat:Connect(function() -- Line: 2144
    -- upvalues: OnIconChanged (copy), u29 (ref)
    OnIconChanged(u29);
end);

local function OnPreferredTransparencyChanged() -- Line: 2149
    -- upvalues: GuiService (copy), u7 (ref), u6 (copy), u37 (ref), u12 (ref), u11 (copy), u43 (copy), u22 (ref), Frame2 (copy)
    local PreferredTransparency = GuiService.PreferredTransparency;
    u7 = u6 * PreferredTransparency;
    u37.BackgroundTransparency = u7;
    u12 = u11 * PreferredTransparency;

    for _, v in ipairs(u43) do
        v.Frame.BackgroundTransparency = u12;
    end;

    u22 = PreferredTransparency * 0.2;
    Frame2.BackgroundTransparency = u22;
end;

GuiService:GetPropertyChangedSignal("PreferredTransparency"):Connect(OnPreferredTransparencyChanged);

return u1;