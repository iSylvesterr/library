-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(u1, u2) -- Line: 3
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
                Init = function(p3) -- Line: 15
                end,

                Get = function(p4) -- Line: 16
                    -- upvalues: u1 (copy)
                    return p4.lastSelectedTick == u1._cycleTick;
                end
            },
            unselected = {
                Init = function(p5) -- Line: 21
                end,

                Get = function(p6) -- Line: 22
                    -- upvalues: u1 (copy)
                    return p6.lastUnselectedTick == u1._cycleTick;
                end
            },
            active = {
                Init = function(p7) -- Line: 27
                end,

                Get = function(p8) -- Line: 28
                    return p8.state.index.value == p8.arguments.Index;
                end
            },
            clicked = u2.EVENTS.click(function(p9) -- Line: 32
                return p9.Instance.SelectableButton;
            end),
            rightClicked = u2.EVENTS.rightClick(function(p10) -- Line: 36
                return p10.Instance.SelectableButton;
            end),
            doubleClicked = u2.EVENTS.doubleClick(function(p11) -- Line: 40
                return p11.Instance.SelectableButton;
            end),
            ctrlClicked = u2.EVENTS.ctrlClick(function(p12) -- Line: 44
                return p12.Instance.SelectableButton;
            end),
            hovered = u2.EVENTS.hover(function(p13) -- Line: 48
                return p13.Instance.SelectableButton;
            end)
        },

        Generate = function(u14) -- Line: 53, Name: Generate
            -- upvalues: u1 (copy), u2 (copy)
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_Selectable";
            Frame.Size = UDim2.new(u1._config.ItemWidth, UDim.new(0, u1._config.TextSize + 2 * u1._config.FramePadding.Y - u1._config.ItemSpacing.Y));
            Frame.BackgroundTransparency = 1;
            Frame.BorderSizePixel = 0;
            local TextButton = Instance.new("TextButton");
            TextButton.Name = "SelectableButton";
            TextButton.Size = UDim2.new(1, 0, 0, u1._config.TextSize + 2 * u1._config.FramePadding.Y);
            TextButton.Position = UDim2.fromOffset(0, -bit32.rshift(u1._config.ItemSpacing.Y, 1));
            TextButton.BackgroundColor3 = u1._config.HeaderColor;
            TextButton.ClipsDescendants = true;
            u2.applyFrameStyle(TextButton);
            u2.applyTextStyle(TextButton);
            u2.UISizeConstraint(TextButton, Vector2.xAxis);
            u14.ButtonColors = {
                Transparency = 1,
                Color = u1._config.HeaderColor,
                HoveredColor = u1._config.HeaderHoveredColor,
                HoveredTransparency = u1._config.HeaderHoveredTransparency,
                ActiveColor = u1._config.HeaderActiveColor,
                ActiveTransparency = u1._config.HeaderActiveTransparency
            };
            u2.applyInteractionHighlights("Background", TextButton, TextButton, u14.ButtonColors);
            u2.applyButtonClick(TextButton, function() -- Line: 82
                -- upvalues: u14 (copy)
                if u14.arguments.NoClick ~= true then
                    if type(u14.state.index.value) == "boolean" then
                        u14.state.index:set(not u14.state.index.value);

                        return;
                    end;

                    u14.state.index:set(u14.arguments.Index);
                end;
            end);
            TextButton.Parent = Frame;

            return Frame;
        end,

        GenerateState = function(p15) -- Line: 96, Name: GenerateState
            -- upvalues: u1 (copy)
            if p15.state.index == nil then
                if p15.arguments.Index ~= nil then
                    error("A shared state index is required for Iris.Selectables() with an Index argument.", 5);
                end;

                p15.state.index = u1._widgetState(p15, "index", false);
            end;
        end,

        Update = function(p16) -- Line: 104, Name: Update
            p16.Instance.SelectableButton.Text = p16.arguments.Text or "Selectable";
        end,

        UpdateState = function(p17) -- Line: 109, Name: UpdateState
            -- upvalues: u1 (copy)
            local SelectableButton = p17.Instance.SelectableButton;

            if p17.state.index.value == p17.arguments.Index or p17.state.index.value == true then
                p17.ButtonColors.Transparency = u1._config.HeaderTransparency;
                SelectableButton.BackgroundTransparency = u1._config.HeaderTransparency;
                p17.lastSelectedTick = u1._cycleTick + 1;

                return;
            end;

            p17.ButtonColors.Transparency = 1;
            SelectableButton.BackgroundTransparency = 1;
            p17.lastUnselectedTick = u1._cycleTick + 1;
        end,

        Discard = function(p18) -- Line: 123, Name: Discard
            -- upvalues: u2 (copy)
            p18.Instance:Destroy();
            u2.discardState(p18);
        end
    });
    local u19 = false;
    local u20 = -1;
    local u21 = nil;
    local u22 = 0;

    local function UpdateChildContainerTransform(p23) -- Line: 134
        -- upvalues: u2 (copy), u1 (copy), u22 (ref)
        local PreviewContainer = p23.Instance.PreviewContainer;
        local ChildContainer = p23.ChildContainer;
        local v24 = PreviewContainer.AbsolutePosition - u2.GuiOffset;
        local PopupBorderSize = u1._config.PopupBorderSize;
        local AbsoluteSize = ChildContainer.Parent.AbsoluteSize;
        local Y = p23.UIListLayout.AbsoluteContentSize.Y;
        u22 = Y;
        local v25 = Y + 2 * u1._config.WindowPadding.Y;
        local X = v24.X;
        local v26 = v24.Y + PreviewContainer.AbsoluteSize.Y + PopupBorderSize;
        local zero = Vector2.zero;
        local v27 = AbsoluteSize.Y - v26;

        if v27 < v25 and AbsoluteSize.Y / 2 < v26 then
            v26 = v24.Y - PopupBorderSize;
            zero = Vector2.yAxis;
            v27 = v26;
        end;

        ChildContainer.AnchorPoint = zero;
        ChildContainer.Position = UDim2.fromOffset(X, v26);
        local v28 = math.min(v25, v27);
        ChildContainer.Size = UDim2.fromOffset(PreviewContainer.AbsoluteSize.X, v28);
    end;

    table.insert(u1._postCycleCallbacks, function() -- Line: 169
        -- upvalues: u19 (ref), u21 (ref), u22 (ref), UpdateChildContainerTransform (copy)
        if u19 and (u21 and u21.UIListLayout.AbsoluteContentSize.Y ~= u22) then
            UpdateChildContainerTransform(u21);
        end;
    end);

    local function UpdateComboState(p29) -- Line: 178
        -- upvalues: u1 (copy), u19 (ref), u21 (ref), u20 (ref), u2 (copy)
        if not u1._started then
            return;
        end;

        if p29.UserInputType ~= Enum.UserInputType.MouseButton1 and (p29.UserInputType ~= Enum.UserInputType.MouseButton2 and (p29.UserInputType ~= Enum.UserInputType.Touch and p29.UserInputType ~= Enum.UserInputType.MouseWheel)) then
            return;
        end;

        if u19 == false or not u21 then
            return;
        end;

        if u20 == u1._cycleTick then
            return;
        end;

        local v30 = u2.getMouseLocation();
        local PreviewContainer = u21.Instance.PreviewContainer;
        local ChildContainer = u21.ChildContainer;

        if u2.isPosInsideRect(v30, PreviewContainer.AbsolutePosition - u2.GuiOffset, PreviewContainer.AbsolutePosition - u2.GuiOffset + PreviewContainer.AbsoluteSize) then
            return;
        end;

        if u2.isPosInsideRect(v30, ChildContainer.AbsolutePosition - u2.GuiOffset, ChildContainer.AbsolutePosition - u2.GuiOffset + ChildContainer.AbsoluteSize) then
            return;
        end;

        u21.state.isOpened:set(false);
    end;

    u2.registerEvent("InputBegan", UpdateComboState);
    u2.registerEvent("InputChanged", UpdateComboState);
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
                Init = function(p31) -- Line: 231
                end,

                Get = function(p32) -- Line: 232
                    -- upvalues: u1 (copy)
                    return p32.lastOpenedTick == u1._cycleTick;
                end
            },
            closed = {
                Init = function(p33) -- Line: 237
                end,

                Get = function(p34) -- Line: 238
                    -- upvalues: u1 (copy)
                    return p34.lastClosedTick == u1._cycleTick;
                end
            },
            changed = {
                Init = function(p35) -- Line: 243
                end,

                Get = function(p36) -- Line: 244
                    -- upvalues: u1 (copy)
                    return p36.lastChangedTick == u1._cycleTick;
                end
            },
            clicked = u2.EVENTS.click(function(p37) -- Line: 248
                return p37.Instance.PreviewContainer;
            end),
            hovered = u2.EVENTS.hover(function(p38) -- Line: 252
                return p38.Instance;
            end)
        },

        Generate = function(u39) -- Line: 256, Name: Generate
            -- upvalues: u1 (copy), u2 (copy), u19 (ref), u21 (ref)
            local v40 = u1._config.TextSize + 2 * u1._config.FramePadding.Y;
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_Combo";
            Frame.AutomaticSize = Enum.AutomaticSize.Y;
            Frame.Size = UDim2.new(u1._config.ItemWidth, UDim.new());
            Frame.BackgroundTransparency = 1;
            Frame.BorderSizePixel = 0;
            u2.UIListLayout(Frame, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.X)).VerticalAlignment = Enum.VerticalAlignment.Center;
            local TextButton = Instance.new("TextButton");
            TextButton.Name = "PreviewContainer";
            TextButton.AutomaticSize = Enum.AutomaticSize.Y;
            TextButton.Size = UDim2.new(u1._config.ContentWidth, UDim.new(0, 0));
            TextButton.BackgroundTransparency = 1;
            TextButton.Text = "";
            TextButton.AutoButtonColor = false;
            TextButton.ZIndex = 2;
            u2.applyFrameStyle(TextButton, true);
            u2.UIListLayout(TextButton, Enum.FillDirection.Horizontal, UDim.new(0, 0));
            u2.UISizeConstraint(TextButton, Vector2.new(v40));
            TextButton.Parent = Frame;
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "PreviewLabel";
            TextLabel.AutomaticSize = Enum.AutomaticSize.Y;
            TextLabel.Size = UDim2.new(UDim.new(1, 0), u1._config.ContentHeight);
            TextLabel.BackgroundColor3 = u1._config.FrameBgColor;
            TextLabel.BackgroundTransparency = u1._config.FrameBgTransparency;
            TextLabel.BorderSizePixel = 0;
            TextLabel.ClipsDescendants = true;
            u2.applyTextStyle(TextLabel);
            u2.UIPadding(TextLabel, u1._config.FramePadding);
            TextLabel.Parent = TextButton;
            local TextLabel2 = Instance.new("TextLabel");
            TextLabel2.Name = "DropdownButton";
            TextLabel2.Size = UDim2.new(0, v40, u1._config.ContentHeight.Scale, (math.max(u1._config.ContentHeight.Offset, v40)));
            TextLabel2.BackgroundColor3 = u1._config.ButtonColor;
            TextLabel2.BackgroundTransparency = u1._config.ButtonTransparency;
            TextLabel2.BorderSizePixel = 0;
            TextLabel2.Text = "";
            local v41 = v40 - math.round(v40 * 0.2) * 2;
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.Name = "Dropdown";
            ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
            ImageLabel.Size = UDim2.fromOffset(v41, v41);
            ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
            ImageLabel.BackgroundTransparency = 1;
            ImageLabel.BorderSizePixel = 0;
            ImageLabel.ImageColor3 = u1._config.TextColor;
            ImageLabel.ImageTransparency = u1._config.TextTransparency;
            ImageLabel.Parent = TextLabel2;
            TextLabel2.Parent = TextButton;
            u2.applyInteractionHighlightsWithMultiHighlightee("Background", TextButton, {
                {
                    TextLabel,
                    {
                        Color = u1._config.FrameBgColor,
                        Transparency = u1._config.FrameBgTransparency,
                        HoveredColor = u1._config.FrameBgHoveredColor,
                        HoveredTransparency = u1._config.FrameBgHoveredTransparency,
                        ActiveColor = u1._config.FrameBgActiveColor,
                        ActiveTransparency = u1._config.FrameBgActiveTransparency
                    }
                },
                {
                    TextLabel2,
                    {
                        Color = u1._config.ButtonColor,
                        Transparency = u1._config.ButtonTransparency,
                        HoveredColor = u1._config.ButtonHoveredColor,
                        HoveredTransparency = u1._config.ButtonHoveredTransparency,
                        ActiveColor = u1._config.ButtonHoveredColor,
                        ActiveTransparency = u1._config.ButtonHoveredTransparency
                    }
                }
            });
            u2.applyButtonClick(TextButton, function() -- Line: 350
                -- upvalues: u19 (ref), u21 (ref), u39 (copy)
                if u19 and u21 ~= u39 then
                    return;
                end;

                u39.state.isOpened:set(not u39.state.isOpened.value);
            end);
            local TextLabel3 = Instance.new("TextLabel");
            TextLabel3.Name = "TextLabel";
            TextLabel3.AutomaticSize = Enum.AutomaticSize.X;
            TextLabel3.Size = UDim2.fromOffset(0, v40);
            TextLabel3.BackgroundTransparency = 1;
            TextLabel3.BorderSizePixel = 0;
            u2.applyTextStyle(TextLabel3);
            TextLabel3.Parent = Frame;
            local ScrollingFrame = Instance.new("ScrollingFrame");
            ScrollingFrame.Name = "ComboContainer";
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
            ScrollingFrame.ClipsDescendants = true;
            u2.UIStroke(ScrollingFrame, u1._config.WindowBorderSize, u1._config.BorderColor, u1._config.BorderTransparency);
            u2.UIPadding(ScrollingFrame, Vector2.new(2, u1._config.WindowPadding.Y));
            u2.UISizeConstraint(ScrollingFrame, Vector2.new(100));
            local v42 = u2.UIListLayout(ScrollingFrame, Enum.FillDirection.Vertical, UDim.new(0, u1._config.ItemSpacing.Y));
            v42.VerticalAlignment = Enum.VerticalAlignment.Top;
            local v43 = u1._rootInstance and u1._rootInstance:WaitForChild("PopupScreenGui");
            ScrollingFrame.Parent = v43;
            u39.ChildContainer = ScrollingFrame;
            u39.UIListLayout = v42;

            return Frame;
        end,

        GenerateState = function(u44) -- Line: 406, Name: GenerateState
            -- upvalues: u1 (copy)
            if u44.state.index == nil then
                u44.state.index = u1._widgetState(u44, "index", "No Selection");
            end;

            if u44.state.isOpened == nil then
                u44.state.isOpened = u1._widgetState(u44, "isOpened", false);
            end;

            u44.state.index:onChange(function() -- Line: 414
                -- upvalues: u44 (copy), u1 (ref)
                u44.lastChangedTick = u1._cycleTick + 1;

                if u44.state.isOpened.value then
                    u44.state.isOpened:set(false);
                end;
            end);
        end,

        Update = function(p45) -- Line: 421, Name: Update
            -- upvalues: u1 (copy)
            local Instance2 = p45.Instance;
            local PreviewContainer = Instance2.PreviewContainer;
            local PreviewLabel = PreviewContainer.PreviewLabel;
            local DropdownButton = PreviewContainer.DropdownButton;
            Instance2.TextLabel.Text = p45.arguments.Text or "Combo";

            if p45.arguments.NoButton then
                DropdownButton.Visible = false;
                PreviewLabel.Size = UDim2.new(UDim.new(1, 0), PreviewLabel.Size.Height);
            else
                DropdownButton.Visible = true;
                PreviewLabel.Size = UDim2.new(UDim.new(1, -(u1._config.TextSize + 2 * u1._config.FramePadding.Y)), PreviewLabel.Size.Height);
            end;

            if p45.arguments.NoPreview then
                PreviewLabel.Visible = false;
                PreviewContainer.Size = UDim2.new(0, 0, 0, 0);
                PreviewContainer.AutomaticSize = Enum.AutomaticSize.XY;

                return;
            end;

            PreviewLabel.Visible = true;
            PreviewContainer.Size = UDim2.new(u1._config.ContentWidth, u1._config.ContentHeight);
            PreviewContainer.AutomaticSize = Enum.AutomaticSize.Y;
        end,

        UpdateState = function(p46) -- Line: 449, Name: UpdateState
            -- upvalues: u19 (ref), u21 (ref), u20 (ref), u1 (copy), u2 (copy), UpdateChildContainerTransform (copy)
            local ChildContainer = p46.ChildContainer;
            local PreviewContainer = p46.Instance.PreviewContainer;
            local PreviewLabel = PreviewContainer.PreviewLabel;
            local Dropdown = PreviewContainer.DropdownButton.Dropdown;

            if p46.state.isOpened.value then
                u19 = true;
                u21 = p46;
                u20 = u1._cycleTick;
                p46.lastOpenedTick = u1._cycleTick + 1;
                Dropdown.Image = u2.ICONS.RIGHT_POINTING_TRIANGLE;
                ChildContainer.Visible = true;
                UpdateChildContainerTransform(p46);
            else
                if u19 then
                    u19 = false;
                    u21 = nil;
                    p46.lastClosedTick = u1._cycleTick + 1;
                end;

                Dropdown.Image = u2.ICONS.DOWN_POINTING_TRIANGLE;
                ChildContainer.Visible = false;
            end;

            local value = p46.state.index.value;
            local v47;

            if typeof(value) == "EnumItem" then
                v47 = value.Name;
            else
                v47 = tostring(value);
            end;

            PreviewLabel.Text = v47;
        end,

        ChildAdded = function(p48, p49) -- Line: 481, Name: ChildAdded
            -- upvalues: UpdateChildContainerTransform (copy)
            UpdateChildContainerTransform(p48);

            return p48.ChildContainer;
        end,

        Discard = function(p50) -- Line: 485, Name: Discard
            -- upvalues: u21 (ref), u19 (ref), u2 (copy)
            if u21 and u21 == p50 then
                u21 = nil;
                u19 = false;
            end;

            p50.Instance:Destroy();
            p50.ChildContainer:Destroy();
            u2.discardState(p50);
        end
    });
end;