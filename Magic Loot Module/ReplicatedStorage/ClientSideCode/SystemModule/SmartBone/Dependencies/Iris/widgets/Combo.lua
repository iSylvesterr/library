-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(u1, u2) -- Line: 3
    local function onSelectionChange(p3) -- Line: 4
        if type(p3.state.index.value) == "boolean" then
            p3.state.index:set(not p3.state.index.value);

            return;
        end;

        p3.state.index:set(p3.arguments.Index);
    end;

    u1.WidgetConstructor("Selectable", {
        hasState = true,
        hasChildren = false,
        Args = {
            Text = 1,
            Index = 2,
            NoClick = 3
        },
        Events = {
            selected = {
                Init = function(p4) -- Line: 22
                end,

                Get = function(p5) -- Line: 23
                    -- upvalues: u1 (copy)
                    return p5.lastSelectedTick == u1._cycleTick;
                end
            },
            unselected = {
                Init = function(p6) -- Line: 28
                end,

                Get = function(p7) -- Line: 29
                    -- upvalues: u1 (copy)
                    return p7.lastUnselectedTick == u1._cycleTick;
                end
            },
            active = {
                Init = function(p8) -- Line: 34
                end,

                Get = function(p9) -- Line: 35
                    return p9.state.index.value == p9.arguments.Index;
                end
            },
            clicked = u2.EVENTS.click(function(p10) -- Line: 39
                return p10.Instance.SelectableButton;
            end),
            rightClicked = u2.EVENTS.rightClick(function(p11) -- Line: 43
                return p11.Instance.SelectableButton;
            end),
            doubleClicked = u2.EVENTS.doubleClick(function(p12) -- Line: 47
                return p12.Instance.SelectableButton;
            end),
            ctrlClicked = u2.EVENTS.ctrlClick(function(p13) -- Line: 51
                return p13.Instance.SelectableButton;
            end),
            hovered = u2.EVENTS.hover(function(p14) -- Line: 55
                return p14.Instance.SelectableButton;
            end)
        },

        Generate = function(u15) -- Line: 60, Name: Generate
            -- upvalues: u1 (copy), u2 (copy)
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_Selectable";
            Frame.Size = UDim2.new(u1._config.ItemWidth, UDim.new(0, u1._config.TextSize));
            Frame.AutomaticSize = Enum.AutomaticSize.None;
            Frame.BackgroundTransparency = 1;
            Frame.BorderSizePixel = 0;
            Frame.ZIndex = u15.ZIndex;
            Frame.LayoutOrder = u15.ZIndex;
            local TextButton = Instance.new("TextButton");
            TextButton.Name = "SelectableButton";
            TextButton.Size = UDim2.new(1, 0, 1, u1._config.ItemSpacing.Y - 1);
            TextButton.Position = UDim2.fromOffset(0, -bit32.rshift(u1._config.ItemSpacing.Y, 1));
            TextButton.BackgroundColor3 = u1._config.HeaderColor;
            TextButton.ZIndex = u15.ZIndex + 1;
            TextButton.LayoutOrder = u15.ZIndex + 1;
            u2.applyFrameStyle(TextButton);
            u2.applyTextStyle(TextButton);
            u15.ButtonColors = {
                ButtonTransparency = 1,
                ButtonColor = u1._config.HeaderColor,
                ButtonHoveredColor = u1._config.HeaderHoveredColor,
                ButtonHoveredTransparency = u1._config.HeaderHoveredTransparency,
                ButtonActiveColor = u1._config.HeaderActiveColor,
                ButtonActiveTransparency = u1._config.HeaderActiveTransparency
            };
            u2.applyInteractionHighlights(TextButton, TextButton, u15.ButtonColors);
            TextButton.MouseButton1Click:Connect(function() -- Line: 92
                -- upvalues: u15 (copy)
                if u15.arguments.NoClick ~= true then
                    local v16 = u15;

                    if type(v16.state.index.value) == "boolean" then
                        v16.state.index:set(not v16.state.index.value);

                        return;
                    end;

                    v16.state.index:set(v16.arguments.Index);
                end;
            end);
            TextButton.Parent = Frame;

            return Frame;
        end,

        Update = function(p17) -- Line: 102, Name: Update
            p17.Instance.SelectableButton.Text = p17.arguments.Text or "Selectable";
        end,

        Discard = function(p18) -- Line: 107, Name: Discard
            -- upvalues: u2 (copy)
            p18.Instance:Destroy();
            u2.discardState(p18);
        end,

        GenerateState = function(p19) -- Line: 111, Name: GenerateState
            -- upvalues: u1 (copy)
            if p19.state.index == nil then
                if p19.arguments.Index ~= nil then
                    error("a shared state index is required for Selectables with an Index argument", 5);
                end;

                p19.state.index = u1._widgetState(p19, "index", false);
            end;
        end,

        UpdateState = function(p20) -- Line: 119, Name: UpdateState
            -- upvalues: u1 (copy)
            local SelectableButton = p20.Instance.SelectableButton;

            if p20.state.index.value == (p20.arguments.Index or true) then
                p20.ButtonColors.ButtonTransparency = u1._config.HeaderTransparency;
                SelectableButton.BackgroundTransparency = u1._config.HeaderTransparency;
                p20.lastSelectedTick = u1._cycleTick + 1;

                return;
            end;

            p20.ButtonColors.ButtonTransparency = 1;
            SelectableButton.BackgroundTransparency = 1;
            p20.lastUnselectedTick = u1._cycleTick + 1;
        end
    });
    local u21 = false;
    local u22 = -1;
    local u23 = nil;

    local function UpdateChildContainerTransform(p24) -- Line: 138
        -- upvalues: u1 (copy)
        local PreviewContainer = p24.Instance.PreviewContainer;
        local PreviewLabel = PreviewContainer.PreviewLabel;
        local ChildContainer = p24.ChildContainer;
        local v25 = u1._config.TextSize + 2 * u1._config.FramePadding.Y;
        local PopupBorderSize = u1._config.PopupBorderSize;
        local v26 = v25 * math.min(p24.ComboChildrenHeight, 8) - PopupBorderSize * 2 + 3 * u1._config.FramePadding.Y;
        local v27 = UDim.new(0, PreviewContainer.AbsoluteSize.X - PopupBorderSize * 2);
        ChildContainer.Size = UDim2.new(v27, UDim.new(0, v26));

        if PreviewLabel.AbsolutePosition.Y + v25 + v26 > ChildContainer.Parent.AbsoluteSize.Y then
            ChildContainer.Position = UDim2.new(0, PreviewLabel.AbsolutePosition.X + PopupBorderSize, 0, PreviewLabel.AbsolutePosition.Y - PopupBorderSize - v26);

            return;
        end;

        ChildContainer.Position = UDim2.new(0, PreviewLabel.AbsolutePosition.X + PopupBorderSize, 0, PreviewLabel.AbsolutePosition.Y + v25 + PopupBorderSize);
    end;

    u2.UserInputService.InputBegan:Connect(function(p28) -- Line: 161
        -- upvalues: u21 (ref), u22 (ref), u1 (copy), u2 (copy), u23 (ref)
        if p28.UserInputType ~= Enum.UserInputType.MouseButton1 and (p28.UserInputType ~= Enum.UserInputType.MouseButton2 and p28.UserInputType ~= Enum.UserInputType.Touch) then
            return;
        end;

        if u21 == false then
            return;
        end;

        if u22 == u1._cycleTick then
            return;
        end;

        local v29 = u2.getMouseLocation();
        local ChildContainer = u23.ChildContainer;
        local v30 = ChildContainer.AbsolutePosition - Vector2.new(0, u23.LabelHeight);

        if not u2.isPosInsideRect(v29, v30, ChildContainer.AbsolutePosition + ChildContainer.AbsoluteSize) then
            u23.state.isOpened:set(false);
        end;
    end);
    u1.WidgetConstructor("Combo", {
        hasState = true,
        hasChildren = true,
        Args = {
            Text = 1,
            NoButton = 2,
            NoPreview = 3
        },
        Events = {
            opened = {
                Init = function(p31) -- Line: 190
                end,

                Get = function(p32) -- Line: 191
                    -- upvalues: u1 (copy)
                    return p32.lastOpenedTick == u1._cycleTick;
                end
            },
            closed = {
                Init = function(p33) -- Line: 196
                end,

                Get = function(p34) -- Line: 197
                    -- upvalues: u1 (copy)
                    return p34.lastClosedTick == u1._cycleTick;
                end
            },
            clicked = u2.EVENTS.click(function(p35) -- Line: 201
                return p35.Instance;
            end),
            hovered = u2.EVENTS.hover(function(p36) -- Line: 204
                return p36.Instance;
            end)
        },

        Generate = function(u37) -- Line: 208, Name: Generate
            -- upvalues: u1 (copy), u2 (copy), u21 (ref), u23 (ref)
            local v38 = u1._config.TextSize + 2 * u1._config.FramePadding.Y;
            u37.ComboChildrenHeight = 0;
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_Combo";
            Frame.Size = UDim2.fromScale(1, 0);
            Frame.AutomaticSize = Enum.AutomaticSize.Y;
            Frame.BackgroundTransparency = 1;
            Frame.BorderSizePixel = 0;
            Frame.ZIndex = u37.ZIndex;
            Frame.LayoutOrder = u37.ZIndex;
            u2.UIListLayout(Frame, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.Y + 1));
            local TextButton = Instance.new("TextButton");
            TextButton.Name = "PreviewContainer";
            TextButton.Size = UDim2.new(u1._config.ContentWidth, UDim.new(0, 0));
            TextButton.AutomaticSize = Enum.AutomaticSize.Y;
            TextButton.BackgroundTransparency = 1;
            TextButton.Text = "";
            TextButton.ZIndex = u37.ZIndex + 2;
            TextButton.LayoutOrder = u37.ZIndex + 2;
            TextButton.AutoButtonColor = false;
            u2.applyFrameStyle(TextButton, true, true);
            u2.UIListLayout(TextButton, Enum.FillDirection.Horizontal, UDim.new(0, 0));
            TextButton.Parent = Frame;
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "PreviewLabel";
            TextLabel.Size = UDim2.new(1, 0, 0, 0);
            TextLabel.AutomaticSize = Enum.AutomaticSize.Y;
            TextLabel.BackgroundColor3 = u1._config.FrameBgColor;
            TextLabel.BackgroundTransparency = u1._config.FrameBgTransparency;
            TextLabel.BorderSizePixel = 0;
            TextLabel.ZIndex = u37.ZIndex + 3;
            TextLabel.LayoutOrder = u37.ZIndex + 3;
            u2.applyTextStyle(TextLabel);
            u2.UIPadding(TextLabel, u1._config.FramePadding);
            TextLabel.Parent = TextButton;
            local TextLabel2 = Instance.new("TextLabel");
            TextLabel2.Name = "DropdownButton";
            TextLabel2.Size = UDim2.new(0, v38, 0, v38);
            TextLabel2.BorderSizePixel = 0;
            TextLabel2.BackgroundColor3 = u1._config.ButtonColor;
            TextLabel2.BackgroundTransparency = u1._config.ButtonTransparency;
            TextLabel2.Text = "";
            TextLabel2.ZIndex = u37.ZIndex + 4;
            TextLabel2.LayoutOrder = u37.ZIndex + 4;
            local v39 = math.round(v38 * 0.2);
            local v40 = v38 - v39 * 2;
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.Name = "Dropdown";
            ImageLabel.Size = UDim2.fromOffset(v40, v40);
            ImageLabel.Position = UDim2.fromOffset(v39, v39);
            ImageLabel.BackgroundTransparency = 1;
            ImageLabel.BorderSizePixel = 0;
            ImageLabel.ImageColor3 = u1._config.TextColor;
            ImageLabel.ImageTransparency = u1._config.TextTransparency;
            ImageLabel.ZIndex = u37.ZIndex + 5;
            ImageLabel.LayoutOrder = u37.ZIndex + 5;
            ImageLabel.Parent = TextLabel2;
            TextLabel2.Parent = TextButton;
            u2.applyInteractionHighlightsWithMultiHighlightee(TextButton, {
                {
                    TextLabel,
                    {
                        ButtonColor = u1._config.FrameBgColor,
                        ButtonTransparency = u1._config.FrameBgTransparency,
                        ButtonHoveredColor = u1._config.FrameBgHoveredColor,
                        ButtonHoveredTransparency = u1._config.FrameBgHoveredTransparency,
                        ButtonActiveColor = u1._config.FrameBgActiveColor,
                        ButtonActiveTransparency = u1._config.FrameBgActiveTransparency
                    }
                },
                {
                    TextLabel2,
                    {
                        ButtonColor = u1._config.ButtonColor,
                        ButtonTransparency = u1._config.ButtonTransparency,
                        ButtonHoveredColor = u1._config.ButtonHoveredColor,
                        ButtonHoveredTransparency = u1._config.ButtonHoveredTransparency,
                        ButtonActiveColor = u1._config.ButtonHoveredColor,
                        ButtonActiveTransparency = u1._config.ButtonHoveredColor
                    }
                }
            });
            TextButton.InputBegan:Connect(function(p41) -- Line: 308
                -- upvalues: u21 (ref), u23 (ref), u37 (copy)
                if u21 and u23 ~= u37 then
                    return;
                end;

                if p41.UserInputType == Enum.UserInputType.MouseButton1 or p41.UserInputType == Enum.UserInputType.Touch then
                    u37.state.isOpened:set(not u37.state.isOpened.value);
                end;
            end);
            local TextLabel3 = Instance.new("TextLabel");
            TextLabel3.Name = "TextLabel";
            TextLabel3.Size = UDim2.fromOffset(0, v38);
            TextLabel3.AutomaticSize = Enum.AutomaticSize.X;
            TextLabel3.BackgroundTransparency = 1;
            TextLabel3.BorderSizePixel = 0;
            TextLabel3.ZIndex = u37.ZIndex + 5;
            TextLabel3.LayoutOrder = u37.ZIndex + 5;
            u2.applyTextStyle(TextLabel3);
            TextLabel3.Parent = Frame;
            local ScrollingFrame = Instance.new("ScrollingFrame");
            ScrollingFrame.Name = "ChildContainer";
            ScrollingFrame.BackgroundColor3 = u1._config.WindowBgColor;
            ScrollingFrame.BackgroundTransparency = u1._config.WindowBgTransparency;
            ScrollingFrame.BorderSizePixel = 0;
            ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
            ScrollingFrame.ScrollBarImageTransparency = u1._config.ScrollbarGrabTransparency;
            ScrollingFrame.ScrollBarImageColor3 = u1._config.ScrollbarGrabColor;
            ScrollingFrame.ScrollBarThickness = u1._config.ScrollbarSize;
            ScrollingFrame.CanvasSize = UDim2.fromScale(0, 0);
            ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
            ScrollingFrame.ZIndex = u37.ZIndex + 6;
            ScrollingFrame.LayoutOrder = u37.ZIndex + 6;
            ScrollingFrame.ClipsDescendants = true;
            u2.UIStroke(ScrollingFrame, u1._config.WindowBorderSize, u1._config.BorderColor, u1._config.BorderTransparency);
            u2.UIPadding(ScrollingFrame, Vector2.new(2, 2 * u1._config.FramePadding.Y));
            u2.UIListLayout(ScrollingFrame, Enum.FillDirection.Vertical, UDim.new(0, u1._config.ItemSpacing.Y)).VerticalAlignment = Enum.VerticalAlignment.Top;
            local v42 = u1._rootInstance and u1._rootInstance:WaitForChild("PopupScreenGui");
            ScrollingFrame.Parent = v42;
            u37.ChildContainer = ScrollingFrame;

            return Frame;
        end,

        Update = function(p43) -- Line: 365, Name: Update
            -- upvalues: u1 (copy)
            local Instance2 = p43.Instance;
            local PreviewContainer = Instance2.PreviewContainer;
            local PreviewLabel = PreviewContainer.PreviewLabel;
            local DropdownButton = PreviewContainer.DropdownButton;
            Instance2.TextLabel.Text = p43.arguments.Text or "Combo";

            if p43.arguments.NoButton then
                DropdownButton.Visible = false;
                PreviewLabel.Size = UDim2.new(1, 0, 0, 0);
            else
                DropdownButton.Visible = true;
                PreviewLabel.Size = UDim2.new(1, -(u1._config.TextSize + 2 * u1._config.FramePadding.Y), 0, 0);
            end;

            if p43.arguments.NoPreview then
                PreviewLabel.Visible = false;
                PreviewContainer.Size = UDim2.new(0, 0, 0, 0);
                PreviewContainer.AutomaticSize = Enum.AutomaticSize.X;

                return;
            end;

            PreviewLabel.Visible = true;
            PreviewContainer.Size = UDim2.new(u1._config.ContentWidth, UDim.new(0, 0));
            PreviewContainer.AutomaticSize = Enum.AutomaticSize.Y;
        end,

        ChildAdded = function(p44, p45) -- Line: 393, Name: ChildAdded
            -- upvalues: UpdateChildContainerTransform (copy)
            if p45.type == "Selectable" then
                p44.ComboChildrenHeight = p44.ComboChildrenHeight + 1;
            else
                p44.ComboChildrenHeight = p44.ComboChildrenHeight + 10;
            end;

            UpdateChildContainerTransform(p44);

            return p44.ChildContainer;
        end,

        ChildDiscarded = function(p46, p47) -- Line: 403, Name: ChildDiscarded
            if p47.type == "Selectable" then
                p46.ComboChildrenHeight = p46.ComboChildrenHeight - 1;

                return;
            end;

            p46.ComboChildrenHeight = p46.ComboChildrenHeight - 10;
        end,

        GenerateState = function(u48) -- Line: 410, Name: GenerateState
            -- upvalues: u1 (copy)
            if u48.state.index == nil then
                u48.state.index = u1._widgetState(u48, "index", "No Selection");
            end;

            u48.state.index:onChange(function() -- Line: 414
                -- upvalues: u48 (copy)
                if u48.state.isOpened.value then
                    u48.state.isOpened:set(false);
                end;
            end);

            if u48.state.isOpened == nil then
                u48.state.isOpened = u1._widgetState(u48, "isOpened", false);
            end;
        end,

        UpdateState = function(p49) -- Line: 423, Name: UpdateState
            -- upvalues: u21 (ref), u23 (ref), u22 (ref), u1 (copy), u2 (copy), UpdateChildContainerTransform (copy)
            local PreviewContainer = p49.Instance.PreviewContainer;
            local PreviewLabel = PreviewContainer.PreviewLabel;
            local Dropdown = PreviewContainer.DropdownButton.Dropdown;
            local ChildContainer = p49.ChildContainer;

            if p49.state.isOpened.value then
                u21 = true;
                u23 = p49;
                u22 = u1._cycleTick;
                p49.lastOpenedTick = u1._cycleTick + 1;
                Dropdown.Image = u2.ICONS.RIGHT_POINTING_TRIANGLE;
                ChildContainer.Visible = true;
                UpdateChildContainerTransform(p49);
            else
                if u21 then
                    u21 = false;
                    u23 = nil;
                    p49.lastClosedTick = u1._cycleTick + 1;
                end;

                Dropdown.Image = u2.ICONS.DOWN_POINTING_TRIANGLE;
                ChildContainer.Visible = false;
            end;

            local value = p49.state.index.value;
            local v50;

            if typeof(value) == "EnumItem" then
                v50 = value.Name;
            else
                v50 = tostring(value);
            end;

            PreviewLabel.Text = v50;
        end,

        Discard = function(p51) -- Line: 455, Name: Discard
            -- upvalues: u2 (copy)
            p51.Instance:Destroy();
            u2.discardState(p51);
        end
    });
end;