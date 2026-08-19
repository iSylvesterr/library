-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local Themes = require(script.Parent.Parent.Features.Themes);

return function(u1) -- Line: 5
    -- upvalues: Themes (copy), TweenService (copy), RunService (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "Dropdown";
    Frame.AutomaticSize = Enum.AutomaticSize.X;
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.AnchorPoint = Vector2.new(0.5, 0);
    Frame.Position = UDim2.new(0.5, 0, 1, 10);
    Frame.ZIndex = -2;
    Frame.ClipsDescendants = true;
    Frame.Parent = u1.widget;
    local GuiService = game:GetService("GuiService");
    u1:setBehaviour("Dropdown", "BackgroundTransparency", function(p2) -- Line: 20
        -- upvalues: GuiService (copy)
        if p2 == 1 then
            return p2;
        end;

        return p2 * GuiService.PreferredTransparency;
    end);
    u1.janitor:add(GuiService:GetPropertyChangedSignal("PreferredTransparency"):Connect(function() -- Line: 28
        -- upvalues: u1 (copy), Frame (copy)
        u1:refreshAppearance(Frame, "BackgroundTransparency");
    end));
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "DropdownCorner";
    UICorner.CornerRadius = UDim.new(0, 10);
    UICorner.Parent = Frame;
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame.Name = "DropdownScroller";
    ScrollingFrame.AutomaticSize = Enum.AutomaticSize.X;
    ScrollingFrame.BackgroundTransparency = 1;
    ScrollingFrame.BorderSizePixel = 0;
    ScrollingFrame.AnchorPoint = Vector2.new(0, 0);
    ScrollingFrame.Position = UDim2.new(0, 0, 0, 0);
    ScrollingFrame.ZIndex = -1;
    ScrollingFrame.ClipsDescendants = true;
    ScrollingFrame.Visible = true;
    ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.None;
    ScrollingFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right;
    ScrollingFrame.Active = false;
    ScrollingFrame.ScrollingEnabled = true;
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    ScrollingFrame.ScrollBarThickness = 5;
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255);
    ScrollingFrame.ScrollBarImageTransparency = 0.8;
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0);
    ScrollingFrame.Selectable = false;
    ScrollingFrame.Active = true;
    ScrollingFrame.Parent = Frame;
    local NumberValue = Instance.new("NumberValue");
    NumberValue.Name = "DropdownSpeed";
    NumberValue.Value = 0.07;
    NumberValue.Parent = Frame;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "DropdownPadding";
    UIPadding.PaddingTop = UDim.new(0, 0);
    UIPadding.PaddingBottom = UDim.new(0, 0);
    UIPadding.Parent = ScrollingFrame;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "DropdownList";
    UIListLayout.FillDirection = Enum.FillDirection.Vertical;
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.HorizontalFlex = Enum.UIFlexAlignment.SpaceEvenly;
    UIListLayout.Parent = ScrollingFrame;
    local dropdownJanitor = u1.dropdownJanitor;
    local iconModule = require(u1.iconModule);
    u1.dropdownChildAdded:Connect(function(u3) -- Line: 81
        local _, u4 = u3:modifyTheme({
            { "Widget", "BorderSize", 0 },
            { "IconCorners", "CornerRadius", UDim.new(0, 10) },
            { "Widget", "MinimumWidth", 190 },
            { "Widget", "MinimumHeight", 58 },
            { "IconLabel", "TextSize", 20 },
            { "IconOverlay", "Size", UDim2.new(1, 0, 1, 0) },
            { "PaddingLeft", "Size", UDim2.fromOffset(25, 0) },
            { "Notice", "Position", UDim2.new(1, -24, 0, 5) },
            { "ContentsList", "HorizontalAlignment", Enum.HorizontalAlignment.Left },
            { "Selection", "Size", UDim2.new(1, -0, 1, -0) },
            { "Selection", "Position", UDim2.new(0, 0, 0, 0) }
        });
        task.defer(function() -- Line: 95
            -- upvalues: u3 (copy), u4 (copy)
            u3.joinJanitor:add(function() -- Line: 96
                -- upvalues: u3 (ref), u4 (ref)
                u3:removeModification(u4);
            end);
        end);
    end);
    u1.dropdownSet:Connect(function(p5) -- Line: 101
        -- upvalues: u1 (copy), iconModule (copy)
        for _, v in pairs(u1.dropdownIcons) do
            iconModule.getIconByUID(v):destroy();
        end;

        if type(p5) == "table" then
            for _, v in pairs(p5) do
                v:joinDropdown(u1);
            end;
        end;
    end);

    local function updateMaxIcons() -- Line: 113
        -- upvalues: Frame (copy), ScrollingFrame (copy), UIPadding (copy)
        local v6 = Frame:GetAttribute("MaxIcons");

        if not v6 then
            return 0;
        end;

        local v7 = {};

        for _, child in pairs(ScrollingFrame:GetChildren()) do
            if child:IsA("GuiObject") and child.Visible then
                table.insert(v7, child);
            end;
        end;

        table.sort(v7, function(p8, p9) -- Line: 124
            return p8.AbsolutePosition.Y < p9.AbsolutePosition.Y;
        end);
        local v10 = math.ceil(v6);
        local v11 = 0;

        for i = 1, v10 do
            local v12 = v7[i];

            if not v12 then
                break;
            end;

            local Y = v12.AbsoluteSize.Y;
            local v13;

            if i == v10 then
                v13 = v10 ~= v6;
            else
                v13 = false;
            end;

            if v13 then
                Y = Y * (v6 - v10 + 1);
            end;

            v11 = v11 + Y;
        end;

        return v11 + (UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Offset);
    end;

    local u14 = nil;
    local u15 = nil;
    local u16 = nil;
    local u17 = nil;

    local function getTweenInfo() -- Line: 145
        -- upvalues: Themes (ref), Frame (copy), u16 (ref), u17 (ref), NumberValue (copy)
        local v18 = Themes.getInstanceValue(Frame, "MaxIcons") or 1;

        if u16 and (u16 == v18 and u17) then
            return u17;
        end;

        local v19 = TweenInfo.new(NumberValue.Value * v18, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out);
        u17 = v19;
        u16 = v18;

        return v19;
    end;

    local function updateVisibility() -- Line: 159
        -- upvalues: Themes (ref), Frame (copy), u16 (ref), u17 (ref), NumberValue (copy), u14 (ref), u15 (ref), u1 (copy), updateMaxIcons (copy), TweenService (ref)
        local v20 = Themes.getInstanceValue(Frame, "MaxIcons") or 1;
        local v21;

        if u16 and (u16 == v20 and u17) then
            v21 = u17;
        else
            v21 = TweenInfo.new(NumberValue.Value * v20, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out);
            u17 = v21;
            u16 = v20;
        end;

        if u14 then
            u14:Cancel();
            u14:Destroy();
            u14 = nil;
        end;

        if u15 then
            u15:Cancel();
            u15:Destroy();
            u15 = nil;
        end;

        if not u1.isSelected then
            local u22 = TweenService:Create(Frame, TweenInfo.new(0), {
                Size = UDim2.new(0, Frame.Size.X.Offset, 0, 0)
            });
            u15 = u22;
            u22:Play();
            u22.Completed:Connect(function() -- Line: 193
                -- upvalues: u15 (ref), u22 (copy)
                if u15 == u22 then
                    u15 = nil;
                end;

                u22:Destroy();
            end);

            return;
        end;

        local v23 = updateMaxIcons();
        Frame.Visible = true;
        Frame.BackgroundTransparency = 0;
        Frame.Size = UDim2.new(0, Frame.Size.X.Offset, 0, 0);
        local u24 = TweenService:Create(Frame, v21, {
            Size = UDim2.new(0, Frame.Size.X.Offset, 0, v23)
        });
        u14 = u24;
        u24:Play();
        u24.Completed:Connect(function() -- Line: 184
            -- upvalues: u14 (ref), u24 (copy)
            if u14 == u24 then
                u14 = nil;
            end;

            u24:Destroy();
        end);
    end;

    dropdownJanitor:add(u1.toggled:Connect(updateVisibility));
    updateVisibility();

    local function updateChildSize() -- Line: 204
        -- upvalues: Themes (ref), Frame (copy), u16 (ref), u17 (ref), NumberValue (copy), u1 (copy), u14 (ref), u15 (ref), RunService (ref), updateMaxIcons (copy), TweenService (ref)
        local v25 = Themes.getInstanceValue(Frame, "MaxIcons") or 1;
        local v26;

        if u16 and (u16 == v25 and u17) then
            v26 = u17;
        else
            v26 = TweenInfo.new(NumberValue.Value * v25, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out);
            u17 = v26;
            u16 = v25;
        end;

        if not u1.isSelected then
            return;
        end;

        if u14 then
            u14:Cancel();
            u14:Destroy();
            u14 = nil;
        end;

        if u15 then
            u15:Cancel();
            u15:Destroy();
            u15 = nil;
        end;

        RunService.Heartbeat:Wait();
        local v27 = updateMaxIcons();
        local u28 = TweenService:Create(Frame, v26, {
            Size = UDim2.new(0, Frame.Size.X.Offset, 0, v27)
        });
        u14 = u28;
        u28:Play();
        u28.Completed:Connect(function() -- Line: 226
            -- upvalues: u14 (ref), u28 (copy)
            if u14 == u28 then
                u14 = nil;
            end;

            u28:Destroy();
        end);
    end;

    dropdownJanitor:add(u1.toggled:Connect(updateVisibility));
    local u29 = 0;
    local u30 = false;

    local function updateMaxIconsListener() -- Line: 240
        -- upvalues: u29 (ref), u30 (ref), updateMaxIconsListener (copy), Frame (copy), ScrollingFrame (copy), iconModule (copy), u1 (copy), UIPadding (copy)
        u29 = u29 + 1;

        if u30 then
            return;
        end;

        local u31 = u29;
        u30 = true;
        task.defer(function() -- Line: 245
            -- upvalues: u30 (ref), u29 (ref), u31 (copy), updateMaxIconsListener (ref)
            u30 = false;

            if u29 ~= u31 then
                updateMaxIconsListener();
            end;
        end);
        local v32 = Frame:GetAttribute("MaxIcons");

        if not v32 then
            return;
        end;

        local v33 = {};

        for _, child in pairs(ScrollingFrame:GetChildren()) do
            if child:IsA("GuiObject") and child.Visible then
                table.insert(v33, { child, child.AbsolutePosition.Y });
            end;
        end;

        table.sort(v33, function(p34, p35) -- Line: 260
            return p34[2] < p35[2];
        end);
        local v36 = math.ceil(v32);
        local v37 = 0;
        local v38 = false;

        for i = 1, v36 do
            local v39 = v33[i];

            if not v39 then
                break;
            end;

            local v40 = v39[1];
            local Y = v40.AbsoluteSize.Y;
            local v41;

            if i == v36 then
                v41 = v36 ~= v32;
            else
                v41 = false;
            end;

            if v41 then
                Y = Y * (v32 - v36 + 1);
            end;

            v37 = v37 + Y;

            if not v41 then
                local v42 = v40:GetAttribute("WidgetUID");

                if v42 then
                    v42 = iconModule.getIconByUID(v42);
                end;

                if v42 then
                    local v43;

                    if v38 then
                        v43 = nil;
                    else
                        v43 = u1:getInstance("ClickRegion");
                        v38 = true;
                    end;

                    v42:getInstance("ClickRegion").NextSelectionUp = v43;
                end;
            end;
        end;

        ScrollingFrame.Size = UDim2.fromOffset(0, v37 + (UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Offset));
    end;

    dropdownJanitor:add(ScrollingFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(updateMaxIconsListener));
    dropdownJanitor:add(ScrollingFrame.ChildAdded:Connect(updateMaxIconsListener));
    dropdownJanitor:add(ScrollingFrame.ChildRemoved:Connect(updateChildSize));
    dropdownJanitor:add(ScrollingFrame.ChildRemoved:Connect(updateMaxIconsListener));
    dropdownJanitor:add(Frame:GetAttributeChangedSignal("MaxIcons"):Connect(updateMaxIconsListener));
    dropdownJanitor:add(Frame:GetAttributeChangedSignal("MaxIcons"):Connect(updateChildSize));
    dropdownJanitor:add(u1.childThemeModified:Connect(updateMaxIconsListener));
    updateMaxIconsListener();

    local function connectVisibilityListeners(p44) -- Line: 305
        -- upvalues: updateChildSize (copy)
        if p44:IsA("GuiObject") then
            p44:GetPropertyChangedSignal("Visible"):Connect(updateChildSize);
            p44:GetPropertyChangedSignal("Size"):Connect(updateChildSize);
        end;
    end;

    for _, child in pairs(ScrollingFrame:GetChildren()) do
        if child:IsA("GuiObject") then
            child:GetPropertyChangedSignal("Visible"):Connect(updateChildSize);
            child:GetPropertyChangedSignal("Size"):Connect(updateChildSize);
        end;
    end;

    dropdownJanitor:add(ScrollingFrame.ChildAdded:Connect(function(p45) -- Line: 318
        -- upvalues: RunService (ref), updateChildSize (copy)
        RunService.Heartbeat:Wait();

        if p45:IsA("GuiObject") then
            p45:GetPropertyChangedSignal("Visible"):Connect(updateChildSize);
            p45:GetPropertyChangedSignal("Size"):Connect(updateChildSize);
        end;

        updateChildSize();
    end));
    Frame.Visible = false;

    return Frame;
end;