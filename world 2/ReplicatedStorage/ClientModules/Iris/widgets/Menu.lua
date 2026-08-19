-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(u1, u2) -- Line: 3
    local u3 = false;
    local u4 = nil;
    local u5 = {};

    local function EmptyMenuStack(p6) -- Line: 8
        -- upvalues: u5 (copy), u1 (copy), u3 (ref), u4 (ref)
        for i = #u5, p6 and p6 + 1 or 1, -1 do
            local v7 = u5[i];
            v7.state.isOpened:set(false);
            v7.Instance.BackgroundColor3 = u1._config.HeaderColor;
            v7.Instance.BackgroundTransparency = 1;
            table.remove(u5, i);
        end;

        if #u5 == 0 then
            u3 = false;
            u4 = nil;
        end;
    end;

    local function UpdateChildContainerTransform(p8) -- Line: 25
        -- upvalues: u2 (copy), u1 (copy)
        local v9 = p8.parentWidget.type == "Menu";
        local Instance2 = p8.Instance;
        local ChildContainer = p8.ChildContainer;
        ChildContainer.Size = UDim2.fromOffset(Instance2.AbsoluteSize.X, 0);

        if ChildContainer.Parent == nil then
            return;
        end;

        local v10 = Instance2.AbsolutePosition - u2.GuiOffset;
        local AbsoluteSize = Instance2.AbsoluteSize;
        local AbsoluteSize2 = ChildContainer.AbsoluteSize;
        local PopupBorderSize = u1._config.PopupBorderSize;
        local AbsoluteSize3 = ChildContainer.Parent.AbsoluteSize;
        local X = v10.X;
        local zero = Vector2.zero;

        if v9 then
            if v10.X + AbsoluteSize2.X > AbsoluteSize3.X then
                zero = Vector2.xAxis;
            else
                X = v10.X + AbsoluteSize.X;
            end;
        end;

        local v11;

        if v10.Y + AbsoluteSize2.Y > AbsoluteSize3.Y then
            v11 = v10.Y - PopupBorderSize + (v9 and AbsoluteSize.Y or 0);
            zero = zero + Vector2.yAxis;
        else
            v11 = v10.Y + PopupBorderSize + (v9 and 0 or AbsoluteSize.Y);
        end;

        ChildContainer.Position = UDim2.fromOffset(X, v11);
        ChildContainer.AnchorPoint = zero;
    end;

    u2.registerEvent("InputBegan", function(p12) -- Line: 65
        -- upvalues: u1 (copy), u3 (ref), u4 (ref), u2 (copy), u5 (copy), EmptyMenuStack (copy)
        if not u1._started then
            return;
        end;

        if p12.UserInputType ~= Enum.UserInputType.MouseButton1 and p12.UserInputType ~= Enum.UserInputType.MouseButton2 then
            return;
        end;

        if u3 == false then
            return;
        end;

        if u4 == nil then
            return;
        end;

        local v13 = u2.getMouseLocation();
        local v14 = false;

        for _, v in u5 do
            for _, v2 in { v.ChildContainer, v.Instance } do
                local v15 = v2.AbsolutePosition - u2.GuiOffset;

                if u2.isPosInsideRect(v13, v15, v15 + v2.AbsoluteSize) then
                    v14 = true;
                    break;
                end;
            end;

            if v14 then
                break;
            end;
        end;

        if not v14 then
            EmptyMenuStack();
        end;
    end);
    u1.WidgetConstructor("MenuBar", {
        hasState = false,
        hasChildren = true,
        Args = {},
        Events = {},

        Generate = function(p16) -- Line: 107, Name: Generate
            -- upvalues: u1 (copy), u2 (copy)
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_MenuBar";
            Frame.AutomaticSize = Enum.AutomaticSize.Y;
            Frame.Size = UDim2.fromScale(1, 0);
            Frame.BackgroundColor3 = u1._config.MenubarBgColor;
            Frame.BackgroundTransparency = u1._config.MenubarBgTransparency;
            Frame.BorderSizePixel = 0;
            Frame.ClipsDescendants = true;
            u2.UIPadding(Frame, Vector2.new(u1._config.WindowPadding.X, 1));
            u2.UIListLayout(Frame, Enum.FillDirection.Horizontal, UDim.new()).VerticalAlignment = Enum.VerticalAlignment.Center;
            u2.applyFrameStyle(Frame, true, true);

            return Frame;
        end,

        Update = function(p17) -- Line: 123, Name: Update
        end,

        ChildAdded = function(p18, p19) -- Line: 126, Name: ChildAdded
            return p18.Instance;
        end,

        Discard = function(p20) -- Line: 129, Name: Discard
            p20.Instance:Destroy();
        end
    });
    u1.WidgetConstructor("Menu", {
        hasState = true,
        hasChildren = true,
        Args = {
            Text = 1
        },
        Events = {
            clicked = u2.EVENTS.click(function(p21) -- Line: 142
                return p21.Instance;
            end),
            hovered = u2.EVENTS.hover(function(p22) -- Line: 145
                return p22.Instance;
            end),
            opened = {
                Init = function(p23) -- Line: 149
                end,

                Get = function(p24) -- Line: 150
                    -- upvalues: u1 (copy)
                    return p24.lastOpenedTick == u1._cycleTick;
                end
            },
            closed = {
                Init = function(p25) -- Line: 155
                end,

                Get = function(p26) -- Line: 156
                    -- upvalues: u1 (copy)
                    return p26.lastClosedTick == u1._cycleTick;
                end
            }
        },

        Generate = function(u27) -- Line: 161, Name: Generate
            -- upvalues: u1 (copy), u2 (copy), u5 (copy), u3 (ref), u4 (ref), EmptyMenuStack (copy)
            u27.ButtonColors = {
                Transparency = 1,
                Color = u1._config.HeaderColor,
                HoveredColor = u1._config.HeaderHoveredColor,
                HoveredTransparency = u1._config.HeaderHoveredTransparency,
                ActiveColor = u1._config.HeaderHoveredColor,
                ActiveTransparency = u1._config.HeaderHoveredTransparency
            };
            local v28;

            if u27.parentWidget.type == "Menu" then
                v28 = Instance.new("TextButton");
                v28.Name = "Menu";
                v28.AutomaticSize = Enum.AutomaticSize.Y;
                v28.Size = UDim2.fromScale(1, 0);
                v28.BackgroundColor3 = u1._config.HeaderColor;
                v28.BackgroundTransparency = 1;
                v28.BorderSizePixel = 0;
                v28.Text = "";
                v28.AutoButtonColor = false;
                local v29 = u2.UIPadding(v28, u1._config.FramePadding);
                v29.PaddingTop = v29.PaddingTop - UDim.new(0, 1);
                u2.UIListLayout(v28, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.X)).VerticalAlignment = Enum.VerticalAlignment.Center;
                local TextLabel = Instance.new("TextLabel");
                TextLabel.Name = "TextLabel";
                TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
                TextLabel.BackgroundTransparency = 1;
                TextLabel.BorderSizePixel = 0;
                u2.applyTextStyle(TextLabel);
                TextLabel.Parent = v28;
                local v30 = u1._config.TextSize + 2 * u1._config.FramePadding.Y;
                local v31 = v30 - math.round(0.2 * v30) * 2;
                local ImageLabel = Instance.new("ImageLabel");
                ImageLabel.Name = "Icon";
                ImageLabel.Size = UDim2.fromOffset(v31, v31);
                ImageLabel.BackgroundTransparency = 1;
                ImageLabel.BorderSizePixel = 0;
                ImageLabel.ImageColor3 = u1._config.TextColor;
                ImageLabel.ImageTransparency = u1._config.TextTransparency;
                ImageLabel.Image = u2.ICONS.RIGHT_POINTING_TRIANGLE;
                ImageLabel.LayoutOrder = 1;
                ImageLabel.Parent = v28;
            else
                v28 = Instance.new("TextButton");
                v28.Name = "Menu";
                v28.AutomaticSize = Enum.AutomaticSize.XY;
                v28.Size = UDim2.fromScale(0, 0);
                v28.BackgroundColor3 = u1._config.HeaderColor;
                v28.BackgroundTransparency = 1;
                v28.BorderSizePixel = 0;
                v28.Text = "";
                v28.AutoButtonColor = false;
                v28.ClipsDescendants = true;
                u2.applyTextStyle(v28);
                u2.UIPadding(v28, Vector2.new(u1._config.ItemSpacing.X, u1._config.FramePadding.Y));
            end;

            u2.applyInteractionHighlights("Background", v28, v28, u27.ButtonColors);
            u2.applyButtonClick(v28, function() -- Line: 229
                -- upvalues: u5 (ref), u27 (copy), u3 (ref), u4 (ref)
                local v32 = #u5 > 1 and true or not u27.state.isOpened.value;
                u27.state.isOpened:set(v32);
                u3 = v32;
                u4 = v32 and u27 or nil;

                if #u5 <= 1 then
                    if v32 then
                        table.insert(u5, u27);

                        return;
                    end;

                    table.remove(u5);
                end;
            end);
            u2.applyMouseEnter(v28, function() -- Line: 245
                -- upvalues: u3 (ref), u4 (ref), u27 (copy), u5 (ref), EmptyMenuStack (ref)
                if u3 and (u4 and u4 ~= u27) then
                    EmptyMenuStack((table.find(u5, u27.parentWidget)));
                    u27.state.isOpened:set(true);
                    u4 = u27;
                    u3 = true;
                    table.insert(u5, u27);
                end;
            end);
            local ScrollingFrame = Instance.new("ScrollingFrame");
            ScrollingFrame.Name = "MenuContainer";
            ScrollingFrame.AutomaticSize = Enum.AutomaticSize.XY;
            ScrollingFrame.Size = UDim2.fromOffset(0, 0);
            ScrollingFrame.BackgroundColor3 = u1._config.PopupBgColor;
            ScrollingFrame.BackgroundTransparency = u1._config.PopupBgTransparency;
            ScrollingFrame.BorderSizePixel = 0;
            ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
            ScrollingFrame.ScrollBarImageTransparency = u1._config.ScrollbarGrabTransparency;
            ScrollingFrame.ScrollBarImageColor3 = u1._config.ScrollbarGrabColor;
            ScrollingFrame.ScrollBarThickness = u1._config.ScrollbarSize;
            ScrollingFrame.CanvasSize = UDim2.fromScale(0, 0);
            ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
            ScrollingFrame.TopImage = u2.ICONS.BLANK_SQUARE;
            ScrollingFrame.MidImage = u2.ICONS.BLANK_SQUARE;
            ScrollingFrame.BottomImage = u2.ICONS.BLANK_SQUARE;
            ScrollingFrame.ZIndex = 6;
            ScrollingFrame.LayoutOrder = 6;
            ScrollingFrame.ClipsDescendants = true;
            u2.UIStroke(ScrollingFrame, u1._config.WindowBorderSize, u1._config.BorderColor, u1._config.BorderTransparency);
            u2.UIPadding(ScrollingFrame, Vector2.new(2, u1._config.WindowPadding.Y - u1._config.ItemSpacing.Y));
            u2.UIListLayout(ScrollingFrame, Enum.FillDirection.Vertical, UDim.new(0, 1)).VerticalAlignment = Enum.VerticalAlignment.Top;
            local v33 = u1._rootInstance and u1._rootInstance:FindFirstChild("PopupScreenGui");
            ScrollingFrame.Parent = v33;
            u27.ChildContainer = ScrollingFrame;

            return v28;
        end,

        Update = function(p34) -- Line: 297, Name: Update
            local Instance2 = p34.Instance;

            if p34.parentWidget.type == "Menu" then
                Instance2 = Instance2.TextLabel;
            end;

            Instance2.Text = p34.arguments.Text or "Menu";
        end,

        ChildAdded = function(p35, p36) -- Line: 307, Name: ChildAdded
            -- upvalues: UpdateChildContainerTransform (copy)
            UpdateChildContainerTransform(p35);

            return p35.ChildContainer;
        end,

        ChildDiscarded = function(p37, p38) -- Line: 311, Name: ChildDiscarded
            -- upvalues: UpdateChildContainerTransform (copy)
            UpdateChildContainerTransform(p37);
        end,

        GenerateState = function(p39) -- Line: 314, Name: GenerateState
            -- upvalues: u1 (copy)
            if p39.state.isOpened == nil then
                p39.state.isOpened = u1._widgetState(p39, "isOpened", false);
            end;
        end,

        UpdateState = function(p40) -- Line: 319, Name: UpdateState
            -- upvalues: u1 (copy), UpdateChildContainerTransform (copy)
            local ChildContainer = p40.ChildContainer;

            if not p40.state.isOpened.value then
                p40.lastClosedTick = u1._cycleTick + 1;
                p40.ButtonColors.Transparency = 1;
                ChildContainer.Visible = false;

                return;
            end;

            p40.lastOpenedTick = u1._cycleTick + 1;
            p40.ButtonColors.Transparency = u1._config.HeaderTransparency;
            ChildContainer.Visible = true;
            UpdateChildContainerTransform(p40);
        end,

        Discard = function(p41) -- Line: 334, Name: Discard
            -- upvalues: u3 (ref), u5 (copy), EmptyMenuStack (copy), u4 (ref), u2 (copy)
            if u3 then
                local parentWidget = p41.parentWidget;
                local v42 = table.find(u5, parentWidget);

                if v42 then
                    EmptyMenuStack(v42);

                    if #u5 ~= 0 then
                        u4 = parentWidget;
                        u3 = true;
                    end;
                end;
            end;

            p41.Instance:Destroy();
            p41.ChildContainer:Destroy();
            u2.discardState(p41);
        end
    });
    u1.WidgetConstructor("MenuItem", {
        hasState = false,
        hasChildren = false,
        Args = {
            Text = 1,
            KeyCode = 2,
            ModifierKey = 3
        },
        Events = {
            clicked = u2.EVENTS.click(function(p43) -- Line: 364
                return p43.Instance;
            end),
            hovered = u2.EVENTS.hover(function(p44) -- Line: 367
                return p44.Instance;
            end)
        },

        Generate = function(u45) -- Line: 371, Name: Generate
            -- upvalues: u2 (copy), u1 (copy), EmptyMenuStack (copy), u3 (ref), u4 (ref), u5 (copy)
            local TextButton = Instance.new("TextButton");
            TextButton.Name = "Iris_MenuItem";
            TextButton.AutomaticSize = Enum.AutomaticSize.Y;
            TextButton.Size = UDim2.fromScale(1, 0);
            TextButton.BackgroundTransparency = 1;
            TextButton.BorderSizePixel = 0;
            TextButton.Text = "";
            TextButton.AutoButtonColor = false;
            local v46 = u2.UIPadding(TextButton, u1._config.FramePadding);
            v46.PaddingTop = v46.PaddingTop - UDim.new(0, 1);
            u2.UIListLayout(TextButton, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.X));
            u2.applyInteractionHighlights("Background", TextButton, TextButton, {
                Transparency = 1,
                Color = u1._config.HeaderColor,
                HoveredColor = u1._config.HeaderHoveredColor,
                HoveredTransparency = u1._config.HeaderHoveredTransparency,
                ActiveColor = u1._config.HeaderHoveredColor,
                ActiveTransparency = u1._config.HeaderHoveredTransparency
            });
            u2.applyButtonClick(TextButton, function() -- Line: 394
                -- upvalues: EmptyMenuStack (ref)
                EmptyMenuStack();
            end);
            u2.applyMouseEnter(TextButton, function() -- Line: 398
                -- upvalues: u45 (copy), u3 (ref), u4 (ref), u5 (ref), EmptyMenuStack (ref)
                local parentWidget = u45.parentWidget;

                if u3 and (u4 and u4 ~= parentWidget) then
                    EmptyMenuStack((table.find(u5, parentWidget)));
                    u4 = parentWidget;
                    u3 = true;
                end;
            end);
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "TextLabel";
            TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
            TextLabel.BackgroundTransparency = 1;
            TextLabel.BorderSizePixel = 0;
            u2.applyTextStyle(TextLabel);
            TextLabel.Parent = TextButton;
            local TextLabel2 = Instance.new("TextLabel");
            TextLabel2.Name = "Shortcut";
            TextLabel2.AutomaticSize = Enum.AutomaticSize.XY;
            TextLabel2.BackgroundTransparency = 1;
            TextLabel2.BorderSizePixel = 0;
            TextLabel2.LayoutOrder = 1;
            u2.applyTextStyle(TextLabel2);
            TextLabel2.Text = "";
            TextLabel2.TextColor3 = u1._config.TextDisabledColor;
            TextLabel2.TextTransparency = u1._config.TextDisabledTransparency;
            TextLabel2.Parent = TextButton;

            return TextButton;
        end,

        Update = function(p47) -- Line: 436, Name: Update
            local Instance2 = p47.Instance;
            local Shortcut = Instance2.Shortcut;
            Instance2.TextLabel.Text = p47.arguments.Text;

            if p47.arguments.KeyCode then
                if p47.arguments.ModifierKey then
                    Shortcut.Text = p47.arguments.ModifierKey.Name .. " + " .. p47.arguments.KeyCode.Name;

                    return;
                end;

                Shortcut.Text = p47.arguments.KeyCode.Name;
            end;
        end,

        Discard = function(p48) -- Line: 450, Name: Discard
            p48.Instance:Destroy();
        end
    });
    u1.WidgetConstructor("MenuToggle", {
        hasState = true,
        hasChildren = false,
        Args = {
            Text = 1,
            KeyCode = 2,
            ModifierKey = 3
        },
        Events = {
            checked = {
                Init = function(p49) -- Line: 466
                end,

                Get = function(p50) -- Line: 467
                    -- upvalues: u1 (copy)
                    return p50.lastCheckedTick == u1._cycleTick;
                end
            },
            unchecked = {
                Init = function(p51) -- Line: 472
                end,

                Get = function(p52) -- Line: 473
                    -- upvalues: u1 (copy)
                    return p52.lastUncheckedTick == u1._cycleTick;
                end
            },
            hovered = u2.EVENTS.hover(function(p53) -- Line: 477
                return p53.Instance;
            end)
        },

        Generate = function(u54) -- Line: 481, Name: Generate
            -- upvalues: u2 (copy), u1 (copy), EmptyMenuStack (copy), u3 (ref), u4 (ref), u5 (copy)
            local TextButton = Instance.new("TextButton");
            TextButton.Name = "Iris_MenuToggle";
            TextButton.AutomaticSize = Enum.AutomaticSize.Y;
            TextButton.Size = UDim2.fromScale(1, 0);
            TextButton.BackgroundTransparency = 1;
            TextButton.BorderSizePixel = 0;
            TextButton.Text = "";
            TextButton.AutoButtonColor = false;
            local v55 = u2.UIPadding(TextButton, u1._config.FramePadding);
            v55.PaddingTop = v55.PaddingTop - UDim.new(0, 1);
            u2.UIListLayout(TextButton, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.X)).VerticalAlignment = Enum.VerticalAlignment.Center;
            u2.applyInteractionHighlights("Background", TextButton, TextButton, {
                Transparency = 1,
                Color = u1._config.HeaderColor,
                HoveredColor = u1._config.HeaderHoveredColor,
                HoveredTransparency = u1._config.HeaderHoveredTransparency,
                ActiveColor = u1._config.HeaderHoveredColor,
                ActiveTransparency = u1._config.HeaderHoveredTransparency
            });
            u2.applyButtonClick(TextButton, function() -- Line: 504
                -- upvalues: u54 (copy), EmptyMenuStack (ref)
                u54.state.isChecked:set(not u54.state.isChecked.value);
                EmptyMenuStack();
            end);
            u2.applyMouseEnter(TextButton, function() -- Line: 509
                -- upvalues: u54 (copy), u3 (ref), u4 (ref), u5 (ref), EmptyMenuStack (ref)
                local parentWidget = u54.parentWidget;

                if u3 and (u4 and u4 ~= parentWidget) then
                    EmptyMenuStack((table.find(u5, parentWidget)));
                    u4 = parentWidget;
                    u3 = true;
                end;
            end);
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "TextLabel";
            TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
            TextLabel.BackgroundTransparency = 1;
            TextLabel.BorderSizePixel = 0;
            u2.applyTextStyle(TextLabel);
            TextLabel.Parent = TextButton;
            local TextLabel2 = Instance.new("TextLabel");
            TextLabel2.Name = "Shortcut";
            TextLabel2.AutomaticSize = Enum.AutomaticSize.XY;
            TextLabel2.BackgroundTransparency = 1;
            TextLabel2.BorderSizePixel = 0;
            TextLabel2.LayoutOrder = 1;
            u2.applyTextStyle(TextLabel2);
            TextLabel2.Text = "";
            TextLabel2.TextColor3 = u1._config.TextDisabledColor;
            TextLabel2.TextTransparency = u1._config.TextDisabledTransparency;
            TextLabel2.Parent = TextButton;
            local v56 = u1._config.TextSize + 2 * u1._config.FramePadding.Y;
            local v57 = v56 - math.round(0.2 * v56) * 2;
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.Name = "Icon";
            ImageLabel.Size = UDim2.fromOffset(v57, v57);
            ImageLabel.BackgroundTransparency = 1;
            ImageLabel.BorderSizePixel = 0;
            ImageLabel.ImageColor3 = u1._config.TextColor;
            ImageLabel.ImageTransparency = u1._config.TextTransparency;
            ImageLabel.Image = u2.ICONS.CHECKMARK;
            ImageLabel.LayoutOrder = 2;
            ImageLabel.Parent = TextButton;

            return TextButton;
        end,

        GenerateState = function(p58) -- Line: 563, Name: GenerateState
            -- upvalues: u1 (copy)
            if p58.state.isChecked == nil then
                p58.state.isChecked = u1._widgetState(p58, "isChecked", false);
            end;
        end,

        Update = function(p59) -- Line: 568, Name: Update
            local Instance2 = p59.Instance;
            local Shortcut = Instance2.Shortcut;
            Instance2.TextLabel.Text = p59.arguments.Text;

            if p59.arguments.KeyCode then
                if p59.arguments.ModifierKey then
                    Shortcut.Text = p59.arguments.ModifierKey.Name .. " + " .. p59.arguments.KeyCode.Name;

                    return;
                end;

                Shortcut.Text = p59.arguments.KeyCode.Name;
            end;
        end,

        UpdateState = function(p60) -- Line: 582, Name: UpdateState
            -- upvalues: u1 (copy)
            local Icon = p60.Instance.Icon;

            if p60.state.isChecked.value then
                Icon.ImageTransparency = u1._config.TextTransparency;
                p60.lastCheckedTick = u1._cycleTick + 1;

                return;
            end;

            Icon.ImageTransparency = 1;
            p60.lastUncheckedTick = u1._cycleTick + 1;
        end,

        Discard = function(p61) -- Line: 594, Name: Discard
            -- upvalues: u2 (copy)
            p61.Instance:Destroy();
            u2.discardState(p61);
        end
    });
end;