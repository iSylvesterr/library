-- Decompiled with Potassium's decompiler.

return function(u1) -- Line: 2
    local Frame = Instance.new("Frame");
    Frame.Name = "Dropdown";
    Frame.AutomaticSize = Enum.AutomaticSize.XY;
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.AnchorPoint = Vector2.new(0.5, 0);
    Frame.Position = UDim2.new(0.5, 0, 1, 10);
    Frame.ZIndex = -2;
    Frame.ClipsDescendants = true;
    Frame.Parent = u1.widget;
    local GuiService = game:GetService("GuiService");
    u1:setBehaviour("Dropdown", "BackgroundTransparency", function(p2) -- Line: 16
        -- upvalues: GuiService (copy)
        if p2 == 1 then
            return p2;
        end;

        return p2 * GuiService.PreferredTransparency;
    end);
    u1.janitor:add(GuiService:GetPropertyChangedSignal("PreferredTransparency"):Connect(function() -- Line: 24
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
    u1.dropdownChildAdded:Connect(function(u3) -- Line: 72
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
        task.defer(function() -- Line: 87
            -- upvalues: u3 (copy), u4 (copy)
            u3.joinJanitor:add(function() -- Line: 88
                -- upvalues: u3 (ref), u4 (ref)
                u3:removeModification(u4);
            end);
        end);
    end);
    u1.dropdownSet:Connect(function(p5) -- Line: 93
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
    local Utility = require(script.Parent.Parent.Utility);
    dropdownJanitor:add(u1.toggled:Connect(function() -- Line: 109, Name: updateVisibility
        -- upvalues: Utility (copy), Frame (copy), u1 (copy)
        Utility.setVisible(Frame, u1.isSelected, "InternalDropdown");
    end));
    Utility.setVisible(Frame, u1.isSelected, "InternalDropdown");
    local u6 = 0;
    local u7 = false;

    local function updateMaxIcons() -- Line: 121
        -- upvalues: u6 (ref), u7 (ref), updateMaxIcons (copy), Frame (copy), ScrollingFrame (copy), iconModule (copy), u1 (copy), UIPadding (copy)
        u6 = u6 + 1;

        if u7 then
            return;
        end;

        local u8 = u6;
        u7 = true;
        task.defer(function() -- Line: 129
            -- upvalues: u7 (ref), u6 (ref), u8 (copy), updateMaxIcons (ref)
            u7 = false;

            if u6 ~= u8 then
                updateMaxIcons();
            end;
        end);
        local v9 = Frame:GetAttribute("MaxIcons");

        if not v9 then
            return;
        end;

        local v10 = {};

        for _, child in pairs(ScrollingFrame:GetChildren()) do
            if child:IsA("GuiObject") then
                table.insert(v10, { child, child.AbsolutePosition.Y });
            end;
        end;

        table.sort(v10, function(p11, p12) -- Line: 146
            return p11[2] < p12[2];
        end);
        local v13 = math.ceil(v9);
        local v14 = 0;
        local v15 = false;

        for i = 1, v13 do
            local v16 = v10[i];

            if not v16 then
                break;
            end;

            local v17 = v16[1];
            local Y = v17.AbsoluteSize.Y;
            local v18;

            if i == v13 then
                v18 = v13 ~= v9;
            else
                v18 = false;
            end;

            if v18 then
                Y = Y * (v9 - v13 + 1);
            end;

            v14 = v14 + Y;

            if not v18 then
                local v19 = v17:GetAttribute("WidgetUID");

                if v19 then
                    v19 = iconModule.getIconByUID(v19);
                end;

                if v19 then
                    local v20;

                    if v15 then
                        v20 = nil;
                    else
                        v20 = u1:getInstance("ClickRegion");
                        v15 = true;
                    end;

                    v19:getInstance("ClickRegion").NextSelectionUp = v20;
                end;
            end;
        end;

        ScrollingFrame.Size = UDim2.fromOffset(0, v14 + UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Offset);
    end;

    dropdownJanitor:add(ScrollingFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(updateMaxIcons));
    dropdownJanitor:add(ScrollingFrame.ChildAdded:Connect(updateMaxIcons));
    dropdownJanitor:add(ScrollingFrame.ChildRemoved:Connect(updateMaxIcons));
    dropdownJanitor:add(Frame:GetAttributeChangedSignal("MaxIcons"):Connect(updateMaxIcons));
    dropdownJanitor:add(u1.childThemeModified:Connect(updateMaxIcons));
    updateMaxIcons();

    return Frame;
end;