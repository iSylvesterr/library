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
        -- upvalues: u1 (copy)
        local v9 = p8.parentWidget.type == "Menu";
        local Instance2 = p8.Instance;
        local ChildContainer = p8.ChildContainer;
        ChildContainer.Size = UDim2.fromOffset(math.max(ChildContainer.AbsoluteSize.X, Instance2.AbsoluteSize.X), (math.max(ChildContainer.AbsoluteSize.Y, Instance2.AbsoluteSize.Y)));

        if ChildContainer.Parent == nil then
            return;
        end;

        local AbsolutePosition = Instance2.AbsolutePosition;
        local AbsoluteSize = Instance2.AbsoluteSize;
        local AbsoluteSize2 = ChildContainer.AbsoluteSize;
        local PopupBorderSize = u1._config.PopupBorderSize;
        local AbsoluteSize3 = ChildContainer.Parent.AbsoluteSize;
        local v10 = AbsolutePosition.X + PopupBorderSize;

        if p8.parentWidget.type == "Menu" then
            if AbsolutePosition.X + AbsoluteSize2.X > AbsoluteSize3.X then
                v10 = AbsolutePosition.X - PopupBorderSize - (v9 and (AbsoluteSize2.X or 0) or 0);
            else
                v10 = AbsolutePosition.X + PopupBorderSize + (v9 and (AbsoluteSize.X or 0) or 0);
            end;
        end;

        local v11;

        if AbsolutePosition.Y + AbsoluteSize2.Y > AbsoluteSize3.Y then
            v11 = AbsolutePosition.Y - PopupBorderSize - AbsoluteSize2.Y + (v9 and AbsoluteSize.Y or 0);
        else
            v11 = AbsolutePosition.Y + PopupBorderSize + (v9 and 0 or AbsoluteSize.Y);
        end;

        ChildContainer.Position = UDim2.fromOffset(v10, v11);
    end;

    u2.UserInputService.InputBegan:Connect(function(p12) -- Line: 62
        -- upvalues: u3 (ref), u4 (ref), u2 (copy), u5 (copy), EmptyMenuStack (copy)
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
                local AbsolutePosition = v2.AbsolutePosition;

                if u2.isPosInsideRect(v13, AbsolutePosition, AbsolutePosition + v2.AbsoluteSize) then
                    v14 = true;
                    break;
                end;
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

        Generate = function(p15) -- Line: 97, Name: Generate
            -- upvalues: u1 (copy), u2 (copy)
            local Frame = Instance.new("Frame");
            Frame.Name = "MenuBar";
            Frame.Size = UDim2.fromScale(1, 0);
            Frame.AutomaticSize = Enum.AutomaticSize.Y;
            Frame.BackgroundColor3 = u1._config.MenubarBgColor;
            Frame.BackgroundTransparency = u1._config.MenubarBgTransparency;
            Frame.BorderSizePixel = 0;
            Frame.ZIndex = p15.ZIndex;
            Frame.LayoutOrder = p15.ZIndex;
            Frame.ClipsDescendants = true;
            u2.UIPadding(Frame, Vector2.new(u1._config.ItemSpacing.X, 2));
            u2.UIListLayout(Frame, Enum.FillDirection.Horizontal, UDim.new()).VerticalAlignment = Enum.VerticalAlignment.Center;

            return Frame;
        end,

        Update = function(p16) -- Line: 114, Name: Update
            -- upvalues: u1 (copy)
            local parentWidget = p16.parentWidget;

            if parentWidget.type ~= "Window" then
                if parentWidget.type == "Root" then
                    return;
                end;

                error("The MenuBar was not created directly under a window or root.");

                return;
            end;

            local v17 = parentWidget.Instance and parentWidget.Instance:FindFirstChild("WindowButton");

            if v17 then
                p16.Instance.Parent = v17;
                local u18 = #u1._postCycleCallbacks + 1;
                local u19 = u1._cycleTick + 1;

                u1._postCycleCallbacks[u18] = function() -- Line: 125
                    -- upvalues: u1 (ref), u19 (copy), parentWidget (copy), u18 (copy)
                    if u1._cycleTick == u19 then
                        u1._widgets.Window.Update(parentWidget);
                        u1._postCycleCallbacks[u18] = nil;
                    end;
                end;
            end;
        end,

        ChildAdded = function(p20) -- Line: 139, Name: ChildAdded
            return p20.Instance;
        end,

        Discard = function(p21) -- Line: 142, Name: Discard
            -- upvalues: u1 (copy)
            local parentWidget = p21.parentWidget;
            p21.Instance:Destroy();
            u1._widgets.Window.Update(parentWidget);
        end
    });
    u1.WidgetConstructor("Menu", {
        hasState = true,
        hasChildren = true,
        Args = {
            Text = 1
        },
        Events = {
            clicked = u2.EVENTS.click(function(p22) -- Line: 157
                return p22.Instance;
            end),
            hovered = u2.EVENTS.hover(function(p23) -- Line: 160
                return p23.Instance;
            end),
            opened = {
                Init = function(p24) -- Line: 164
                end,

                Get = function(p25) -- Line: 165
                    -- upvalues: u1 (copy)
                    return p25.lastOpenedTick == u1._cycleTick;
                end
            },
            closed = {
                Init = function(p26) -- Line: 170
                end,

                Get = function(p27) -- Line: 171
                    -- upvalues: u1 (copy)
                    return p27.lastClosedTick == u1._cycleTick;
                end
            }
        },

        Generate = function(u28) -- Line: 176, Name: Generate
            -- upvalues: u1 (copy), u2 (copy), u5 (copy), u3 (ref), u4 (ref), EmptyMenuStack (copy)
            u28.ButtonColors = {
                ButtonTransparency = 1,
                ButtonColor = u1._config.HeaderColor,
                ButtonHoveredColor = u1._config.HeaderHoveredColor,
                ButtonHoveredTransparency = u1._config.HeaderHoveredTransparency,
                ButtonActiveColor = u1._config.HeaderHoveredColor,
                ButtonActiveTransparency = u1._config.HeaderHoveredTransparency
            };
            local v29;

            if u28.parentWidget.type == "Menu" then
                v29 = Instance.new("TextButton");
                v29.Name = "Menu";
                v29.BackgroundColor3 = u1._config.HeaderColor;
                v29.BackgroundTransparency = 1;
                v29.BorderSizePixel = 0;
                v29.Size = UDim2.fromScale(1, 0);
                v29.Text = "";
                v29.AutomaticSize = Enum.AutomaticSize.Y;
                v29.ZIndex = u28.ZIndex;
                v29.LayoutOrder = u28.ZIndex;
                v29.AutoButtonColor = false;
                local v30 = u2.UIPadding(v29, u1._config.FramePadding);
                v30.PaddingTop = v30.PaddingTop - UDim.new(0, 1);
                u2.UIListLayout(v29, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.X)).VerticalAlignment = Enum.VerticalAlignment.Center;
                local TextLabel = Instance.new("TextLabel");
                TextLabel.Name = "TextLabel";
                TextLabel.AnchorPoint = Vector2.new(0, 0);
                TextLabel.BackgroundTransparency = 1;
                TextLabel.BorderSizePixel = 0;
                TextLabel.ZIndex = u28.ZIndex + 2;
                TextLabel.LayoutOrder = u28.ZIndex + 2;
                TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
                u2.applyTextStyle(TextLabel);
                TextLabel.Parent = v29;
                local v31 = u1._config.TextSize + 2 * u1._config.FramePadding.Y;
                local v32 = v31 - math.round(v31 * 0.2) * 2;
                local ImageLabel = Instance.new("ImageLabel");
                ImageLabel.Name = "Icon";
                ImageLabel.Size = UDim2.fromOffset(v32, v32);
                ImageLabel.BackgroundTransparency = 1;
                ImageLabel.BorderSizePixel = 0;
                ImageLabel.ImageColor3 = u1._config.TextColor;
                ImageLabel.ImageTransparency = u1._config.TextTransparency;
                ImageLabel.Image = u2.ICONS.RIGHT_POINTING_TRIANGLE;
                ImageLabel.ZIndex = u28.ZIndex + 3;
                ImageLabel.LayoutOrder = u28.ZIndex + 3;
                ImageLabel.Parent = v29;
            else
                v29 = Instance.new("TextButton");
                v29.Name = "Menu";
                v29.Size = UDim2.fromScale(0, 0);
                v29.AutomaticSize = Enum.AutomaticSize.XY;
                v29.BackgroundColor3 = u1._config.HeaderColor;
                v29.BackgroundTransparency = 1;
                v29.BorderSizePixel = 0;
                v29.Text = "";
                v29.LayoutOrder = u28.ZIndex;
                v29.ZIndex = u28.ZIndex;
                v29.AutoButtonColor = false;
                v29.ClipsDescendants = true;
                u2.applyTextStyle(v29);
                u2.UIPadding(v29, Vector2.new(u1._config.ItemSpacing.X, u1._config.FramePadding.Y));
            end;

            u2.applyInteractionHighlights(v29, v29, u28.ButtonColors);
            v29.MouseButton1Click:Connect(function() -- Line: 252
                -- upvalues: u5 (ref), u28 (copy), u3 (ref), u4 (ref)
                local v33 = #u5 > 1 and true or not u28.state.isOpened.value;
                u28.state.isOpened:set(v33);
                u3 = v33;
                u4 = v33 and u28 or nil;

                if #u5 <= 1 then
                    if v33 then
                        table.insert(u5, u28);

                        return;
                    end;

                    table.remove(u5);
                end;
            end);
            v29.MouseEnter:Connect(function() -- Line: 267
                -- upvalues: u3 (ref), u4 (ref), u28 (copy), u5 (ref), EmptyMenuStack (ref)
                if u3 and (u4 and u4 ~= u28) then
                    EmptyMenuStack((table.find(u5, u28.parentWidget)));
                    u28.state.isOpened:set(true);
                    u4 = u28;
                    u3 = true;
                    table.insert(u5, u28);
                end;
            end);
            local ScrollingFrame = Instance.new("ScrollingFrame");
            ScrollingFrame.Name = "ChildContainer";
            ScrollingFrame.BackgroundColor3 = u1._config.WindowBgColor;
            ScrollingFrame.BackgroundTransparency = u1._config.WindowBgTransparency;
            ScrollingFrame.BorderSizePixel = 0;
            ScrollingFrame.Size = UDim2.fromOffset(0, 0);
            ScrollingFrame.AutomaticSize = Enum.AutomaticSize.XY;
            ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
            ScrollingFrame.ScrollBarImageTransparency = u1._config.ScrollbarGrabTransparency;
            ScrollingFrame.ScrollBarImageColor3 = u1._config.ScrollbarGrabColor;
            ScrollingFrame.ScrollBarThickness = u1._config.ScrollbarSize;
            ScrollingFrame.CanvasSize = UDim2.fromScale(0, 0);
            ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
            ScrollingFrame.ZIndex = u28.ZIndex + 6;
            ScrollingFrame.LayoutOrder = u28.ZIndex + 6;
            ScrollingFrame.ClipsDescendants = true;
            u2.UIListLayout(ScrollingFrame, Enum.FillDirection.Vertical, UDim.new(0, 1)).VerticalAlignment = Enum.VerticalAlignment.Top;
            local v34 = u1._rootInstance and u1._rootInstance:FindFirstChild("PopupScreenGui");
            ScrollingFrame.Parent = v34;
            u28.ChildContainer = ScrollingFrame;
            u2.UIStroke(ScrollingFrame, u1._config.WindowBorderSize, u1._config.BorderColor, u1._config.BorderTransparency);
            u2.UIPadding(ScrollingFrame, Vector2.new(2, u1._config.WindowPadding.Y - u1._config.ItemSpacing.Y));

            return v29;
        end,

        Update = function(p35) -- Line: 316, Name: Update
            local Instance2 = p35.Instance;

            if p35.parentWidget.type == "Menu" then
                Instance2 = Instance2.TextLabel;
            end;

            Instance2.Text = p35.arguments.Text or "Menu";
        end,

        ChildAdded = function(p36, p37) -- Line: 326, Name: ChildAdded
            -- upvalues: UpdateChildContainerTransform (copy)
            UpdateChildContainerTransform(p36);

            return p36.ChildContainer;
        end,

        ChildDiscarded = function(p38, p39) -- Line: 330, Name: ChildDiscarded
            -- upvalues: UpdateChildContainerTransform (copy)
            UpdateChildContainerTransform(p38);
        end,

        GenerateState = function(p40) -- Line: 333, Name: GenerateState
            -- upvalues: u1 (copy)
            if p40.state.isOpened == nil then
                p40.state.isOpened = u1._widgetState(p40, "isOpened", false);
            end;
        end,

        UpdateState = function(p41) -- Line: 338, Name: UpdateState
            -- upvalues: u1 (copy), UpdateChildContainerTransform (copy)
            local ChildContainer = p41.ChildContainer;

            if not p41.state.isOpened.value then
                p41.lastClosedTick = u1._cycleTick + 1;
                p41.ButtonColors.ButtonTransparency = 1;
                ChildContainer.Visible = false;

                return;
            end;

            p41.lastOpenedTick = u1._cycleTick + 1;
            p41.ButtonColors.ButtonTransparency = u1._config.HeaderTransparency;
            ChildContainer.Visible = true;
            UpdateChildContainerTransform(p41);
        end,

        Discard = function(p42) -- Line: 353, Name: Discard
            -- upvalues: u2 (copy)
            p42.Instance:Destroy();
            u2.discardState(p42);
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
            clicked = u2.EVENTS.click(function(p43) -- Line: 368
                return p43.Instance;
            end),
            hovered = u2.EVENTS.hover(function(p44) -- Line: 371
                return p44.Instance;
            end)
        },

        Generate = function(u45) -- Line: 375, Name: Generate
            -- upvalues: u2 (copy), u1 (copy), EmptyMenuStack (copy), u3 (ref), u4 (ref), u5 (copy)
            local TextButton = Instance.new("TextButton");
            TextButton.Name = "MenuItem";
            TextButton.BackgroundTransparency = 1;
            TextButton.BorderSizePixel = 0;
            TextButton.Size = UDim2.fromScale(1, 0);
            TextButton.Text = "";
            TextButton.AutomaticSize = Enum.AutomaticSize.Y;
            TextButton.ZIndex = u45.ZIndex;
            TextButton.LayoutOrder = u45.ZIndex;
            TextButton.AutoButtonColor = false;
            local v46 = u2.UIPadding(TextButton, u1._config.FramePadding);
            v46.PaddingTop = v46.PaddingTop - UDim.new(0, 1);
            u2.UIListLayout(TextButton, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.X));
            u2.applyInteractionHighlights(TextButton, TextButton, {
                ButtonTransparency = 1,
                ButtonColor = u1._config.HeaderColor,
                ButtonHoveredColor = u1._config.HeaderHoveredColor,
                ButtonHoveredTransparency = u1._config.HeaderHoveredTransparency,
                ButtonActiveColor = u1._config.HeaderHoveredColor,
                ButtonActiveTransparency = u1._config.HeaderHoveredTransparency
            });
            TextButton.MouseButton1Click:Connect(function() -- Line: 400
                -- upvalues: EmptyMenuStack (ref)
                EmptyMenuStack();
            end);
            TextButton.MouseEnter:Connect(function() -- Line: 404
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
            TextLabel.AnchorPoint = Vector2.new(0, 0);
            TextLabel.BackgroundTransparency = 1;
            TextLabel.BorderSizePixel = 0;
            TextLabel.ZIndex = u45.ZIndex + 2;
            TextLabel.LayoutOrder = u45.ZIndex + 2;
            TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
            u2.applyTextStyle(TextLabel);
            TextLabel.Parent = TextButton;
            local TextLabel2 = Instance.new("TextLabel");
            TextLabel2.Name = "Shortcut";
            TextLabel2.AnchorPoint = Vector2.new(0, 0);
            TextLabel2.BackgroundTransparency = 1;
            TextLabel2.BorderSizePixel = 0;
            TextLabel2.ZIndex = u45.ZIndex + 3;
            TextLabel2.LayoutOrder = u45.ZIndex + 3;
            TextLabel2.AutomaticSize = Enum.AutomaticSize.XY;
            u2.applyTextStyle(TextLabel2);
            TextLabel2.Text = "";
            TextLabel2.TextColor3 = u1._config.TextDisabledColor;
            TextLabel2.TextTransparency = u1._config.TextDisabledTransparency;
            TextLabel2.Parent = TextButton;

            return TextButton;
        end,

        Update = function(p47) -- Line: 447, Name: Update
            local Instance2 = p47.Instance;
            local Shortcut = Instance2.Shortcut;
            Instance2.TextLabel.Text = p47.arguments.Text;

            if p47.arguments.KeyCode then
                Shortcut.Text = p47.arguments.ModifierKey.Name .. " + " .. p47.arguments.KeyCode.Name;
            end;
        end,

        Discard = function(p48) -- Line: 457, Name: Discard
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
                Init = function(p49) -- Line: 472
                end,

                Get = function(p50) -- Line: 473
                    -- upvalues: u1 (copy)
                    return p50.lastCheckedTick == u1._cycleTick;
                end
            },
            unchecked = {
                Init = function(p51) -- Line: 478
                end,

                Get = function(p52) -- Line: 479
                    -- upvalues: u1 (copy)
                    return p52.lastUncheckedTick == u1._cycleTick;
                end
            },
            hovered = u2.EVENTS.hover(function(p53) -- Line: 483
                return p53.Instance;
            end)
        },

        Generate = function(u54) -- Line: 487, Name: Generate
            -- upvalues: u2 (copy), u1 (copy), EmptyMenuStack (copy), u3 (ref), u4 (ref), u5 (copy)
            local TextButton = Instance.new("TextButton");
            TextButton.Name = "MenuItem";
            TextButton.BackgroundTransparency = 1;
            TextButton.BorderSizePixel = 0;
            TextButton.Size = UDim2.fromScale(1, 0);
            TextButton.Text = "";
            TextButton.AutomaticSize = Enum.AutomaticSize.Y;
            TextButton.ZIndex = u54.ZIndex;
            TextButton.LayoutOrder = u54.ZIndex;
            TextButton.AutoButtonColor = false;
            local v55 = u2.UIPadding(TextButton, u1._config.FramePadding);
            v55.PaddingTop = v55.PaddingTop - UDim.new(0, 1);
            u2.UIListLayout(TextButton, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.X)).VerticalAlignment = Enum.VerticalAlignment.Center;
            u2.applyInteractionHighlights(TextButton, TextButton, {
                ButtonTransparency = 1,
                ButtonColor = u1._config.HeaderColor,
                ButtonHoveredColor = u1._config.HeaderHoveredColor,
                ButtonHoveredTransparency = u1._config.HeaderHoveredTransparency,
                ButtonActiveColor = u1._config.HeaderHoveredColor,
                ButtonActiveTransparency = u1._config.HeaderHoveredTransparency
            });
            TextButton.MouseButton1Click:Connect(function() -- Line: 512
                -- upvalues: u54 (copy), EmptyMenuStack (ref)
                u54.state.isChecked:set(not u54.state.isChecked.value);
                EmptyMenuStack();
            end);
            TextButton.MouseEnter:Connect(function() -- Line: 518
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
            TextLabel.AnchorPoint = Vector2.new(0, 0);
            TextLabel.BackgroundTransparency = 1;
            TextLabel.BorderSizePixel = 0;
            TextLabel.ZIndex = u54.ZIndex + 2;
            TextLabel.LayoutOrder = u54.ZIndex + 2;
            TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
            u2.applyTextStyle(TextLabel);
            TextLabel.Parent = TextButton;
            local TextLabel2 = Instance.new("TextLabel");
            TextLabel2.Name = "Shortcut";
            TextLabel2.AnchorPoint = Vector2.new(0, 0);
            TextLabel2.BackgroundTransparency = 1;
            TextLabel2.BorderSizePixel = 0;
            TextLabel2.ZIndex = u54.ZIndex + 3;
            TextLabel2.LayoutOrder = u54.ZIndex + 3;
            TextLabel2.AutomaticSize = Enum.AutomaticSize.XY;
            u2.applyTextStyle(TextLabel2);
            TextLabel2.Text = "";
            TextLabel2.TextColor3 = u1._config.TextDisabledColor;
            TextLabel2.TextTransparency = u1._config.TextDisabledTransparency;
            TextLabel2.Parent = TextButton;
            local v56 = u1._config.TextSize + 2 * u1._config.FramePadding.Y;
            local v57 = v56 - math.round(v56 * 0.2) * 2;
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.Name = "Icon";
            ImageLabel.Size = UDim2.fromOffset(v57, v57);
            ImageLabel.BackgroundTransparency = 1;
            ImageLabel.BorderSizePixel = 0;
            ImageLabel.ImageColor3 = u1._config.TextColor;
            ImageLabel.ImageTransparency = u1._config.TextTransparency;
            ImageLabel.Image = u2.ICONS.CHECK_MARK;
            ImageLabel.ZIndex = u54.ZIndex + 4;
            ImageLabel.LayoutOrder = u54.ZIndex + 4;
            ImageLabel.Parent = TextButton;

            return TextButton;
        end,

        GenerateState = function(p58) -- Line: 578, Name: GenerateState
            -- upvalues: u1 (copy)
            if p58.state.isChecked == nil then
                p58.state.isChecked = u1._widgetState(p58, "isChecked", false);
            end;
        end,

        Update = function(p59) -- Line: 583, Name: Update
            local Instance2 = p59.Instance;
            local Shortcut = Instance2.Shortcut;
            Instance2.TextLabel.Text = p59.arguments.Text;

            if p59.arguments.KeyCode then
                Shortcut.Text = p59.arguments.ModifierKey.Name .. " + " .. p59.arguments.KeyCode.Name;
            end;
        end,

        UpdateState = function(p60) -- Line: 593, Name: UpdateState
            -- upvalues: u2 (copy), u1 (copy)
            local Icon = p60.Instance.Icon;

            if p60.state.isChecked.value then
                Icon.Image = u2.ICONS.CHECK_MARK;
                p60.lastCheckedTick = u1._cycleTick + 1;

                return;
            end;

            Icon.Image = "";
            p60.lastUncheckedTick = u1._cycleTick + 1;
        end,

        Discard = function(p61) -- Line: 605, Name: Discard
            -- upvalues: u2 (copy)
            p61.Instance:Destroy();
            u2.discardState(p61);
        end
    });
end;