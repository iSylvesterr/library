-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(u1, u2) -- Line: 3
    local function relocateTooltips() -- Line: 4
        -- upvalues: u1 (copy), u2 (copy)
        if u1._rootInstance == nil then
            return;
        end;

        local PopupScreenGui = u1._rootInstance:FindFirstChild("PopupScreenGui");
        local TooltipContainer = PopupScreenGui.TooltipContainer;
        local v3 = u2.getMouseLocation();
        local v4 = u2.findBestWindowPosForPopup(v3, TooltipContainer.AbsoluteSize, u1._config.DisplaySafeAreaPadding, PopupScreenGui.AbsoluteSize);
        TooltipContainer.Position = UDim2.fromOffset(v4.X, v4.Y);
    end;

    u2.registerEvent("InputChanged", function() -- Line: 15
        -- upvalues: u1 (copy), relocateTooltips (copy)
        if not u1._started then
            return;
        end;

        relocateTooltips();
    end);
    u1.WidgetConstructor("Tooltip", {
        hasState = false,
        hasChildren = false,
        Args = {
            Text = 1
        },
        Events = {},

        Generate = function(p5) -- Line: 30, Name: Generate
            -- upvalues: u1 (copy), u2 (copy)
            p5.parentWidget = u1._rootWidget;
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_Tooltip";
            Frame.AutomaticSize = Enum.AutomaticSize.Y;
            Frame.Size = UDim2.new(u1._config.ContentWidth, UDim.new(0, 0));
            Frame.BorderSizePixel = 0;
            Frame.BackgroundTransparency = 1;
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "TooltipText";
            TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
            TextLabel.Size = UDim2.fromOffset(0, 0);
            TextLabel.BackgroundColor3 = u1._config.PopupBgColor;
            TextLabel.BackgroundTransparency = u1._config.PopupBgTransparency;
            u2.applyTextStyle(TextLabel);
            u2.UIStroke(TextLabel, u1._config.PopupBorderSize, u1._config.BorderActiveColor, u1._config.BorderActiveTransparency);
            u2.UIPadding(TextLabel, u1._config.WindowPadding);

            if u1._config.PopupRounding > 0 then
                u2.UICorner(TextLabel, u1._config.PopupRounding);
            end;

            TextLabel.Parent = Frame;

            return Frame;
        end,

        Update = function(p6) -- Line: 58, Name: Update
            -- upvalues: relocateTooltips (copy)
            local TooltipText = p6.Instance.TooltipText;

            if p6.arguments.Text == nil then
                error("Text argument is required for Iris.Tooltip().", 5);
            end;

            TooltipText.Text = p6.arguments.Text;
            relocateTooltips();
        end,

        Discard = function(p7) -- Line: 67, Name: Discard
            p7.Instance:Destroy();
        end
    });
    local u8 = 0;
    local u9 = nil;
    local u10 = false;
    local u11 = nil;
    local u12 = nil;
    local u13 = false;
    local u14 = false;
    local u15 = false;
    local Top = Enum.TopBottom.Top;
    local Left = Enum.LeftRight.Left;
    local u16 = nil;
    local u17 = nil;
    local u18 = false;
    local u19 = {};

    local function quickSwapWindows() -- Line: 91
        -- upvalues: u1 (copy), u19 (copy)
        if u1._config.UseScreenGUIs == false then
            return;
        end;

        local v20 = 65535;
        local v21 = nil;

        for _, v in u19 do
            if v.state.isOpened.value and (not v.arguments.NoNav and v.Instance:IsA("ScreenGui")) then
                local DisplayOrder = v.Instance.DisplayOrder;

                if DisplayOrder < v20 then
                    v21 = v;
                    v20 = DisplayOrder;
                end;
            end;
        end;

        if not v21 then
            return;
        end;

        if v21.state.isUncollapsed.value == false then
            v21.state.isUncollapsed:set(true);
        end;

        u1.SetFocusedWindow(v21);
    end;

    local function fitSizeToWindowBounds(p22, p23) -- Line: 122
        -- upvalues: u1 (copy), u2 (copy)
        local v24 = Vector2.new(p22.state.position.value.X, p22.state.position.value.Y);
        local v25 = (u1._config.TextSize + 2 * u1._config.FramePadding.Y) * 2;
        local v26 = u2.getScreenSizeForWindow(p22);
        local v27 = Vector2.new(u1._config.WindowBorderSize + u1._config.DisplaySafeAreaPadding.X, u1._config.WindowBorderSize + u1._config.DisplaySafeAreaPadding.Y);
        local v28 = v26 - v24 - v27;
        local new = Vector2.new;
        local X = p23.X;
        local v29 = math.max(v28.X, v25);
        local v30 = math.clamp(X, v25, v29);
        local Y = p23.Y;
        local v31 = math.max(v28.Y, v25);

        return new(v30, (math.clamp(Y, v25, v31)));
    end;

    local function fitPositionToWindowBounds(p32, p33) -- Line: 132
        -- upvalues: u2 (copy), u1 (copy)
        local Instance2 = p32.Instance;
        local v34 = u2.getScreenSizeForWindow(p32);
        local v35 = Vector2.new(u1._config.WindowBorderSize + u1._config.DisplaySafeAreaPadding.X, u1._config.WindowBorderSize + u1._config.DisplaySafeAreaPadding.Y);
        local new = Vector2.new;
        local X = p33.X;
        local X2 = v35.X;
        local v36 = math.max(v35.X, v34.X - Instance2.WindowButton.AbsoluteSize.X - v35.X);
        local v37 = math.clamp(X, X2, v36);
        local Y = p33.Y;
        local Y2 = v35.Y;
        local v38 = math.max(v35.Y, v34.Y - Instance2.WindowButton.AbsoluteSize.Y - v35.Y);

        return new(v37, (math.clamp(Y, Y2, v38)));
    end;

    function u1.SetFocusedWindow(p39) -- Line: 143
        -- upvalues: u17 (ref), u18 (ref), u19 (copy), u1 (copy), u8 (ref), u2 (copy)
        if u17 == p39 then
            return;
        end;

        if u18 and u17 ~= nil then
            if u19[u17.ID] then
                local WindowButton = u17.Instance.WindowButton;
                local TitleBar = WindowButton.Content.TitleBar;

                if u17.state.isUncollapsed.value then
                    TitleBar.BackgroundColor3 = u1._config.TitleBgColor;
                    TitleBar.BackgroundTransparency = u1._config.TitleBgTransparency;
                else
                    TitleBar.BackgroundColor3 = u1._config.TitleBgCollapsedColor;
                    TitleBar.BackgroundTransparency = u1._config.TitleBgCollapsedTransparency;
                end;

                WindowButton.UIStroke.Color = u1._config.BorderColor;
            end;

            u18 = false;
            u17 = nil;
        end;

        if p39 ~= nil then
            u18 = true;
            u17 = p39;
            local Instance2 = p39.Instance;
            local WindowButton = Instance2.WindowButton;
            local TitleBar = WindowButton.Content.TitleBar;
            TitleBar.BackgroundColor3 = u1._config.TitleBgActiveColor;
            TitleBar.BackgroundTransparency = u1._config.TitleBgActiveTransparency;
            WindowButton.UIStroke.Color = u1._config.BorderActiveColor;
            u8 = u8 + 1;

            if p39.usesScreenGuis then
                Instance2.DisplayOrder = u8 + u1._config.DisplayOrderOffset;
            else
                Instance2.ZIndex = u8 + u1._config.DisplayOrderOffset;
            end;

            if p39.state.isUncollapsed.value == false then
                p39.state.isUncollapsed:set(true);
            end;

            if u2.GuiService.SelectedObject then
                if TitleBar.Visible then
                    u2.GuiService:Select(TitleBar);

                    return;
                end;

                u2.GuiService:Select(p39.ChildContainer);
            end;
        end;
    end;

    u2.registerEvent("InputBegan", function(p40) -- Line: 204
        -- upvalues: u1 (copy), u2 (copy), u19 (copy), quickSwapWindows (copy), u14 (ref), u15 (ref), u18 (ref), u17 (ref), Top (ref), Left (ref), u13 (ref), u12 (ref)
        if not u1._started then
            return;
        end;

        if p40.UserInputType == Enum.UserInputType.MouseButton1 then
            local v41 = u2.getMouseLocation();
            local v42 = false;

            for _, v in u19 do
                local Instance2 = v.Instance;

                if Instance2 then
                    local ResizeBorder = Instance2.WindowButton.ResizeBorder;

                    if ResizeBorder and u2.isPosInsideRect(v41, ResizeBorder.AbsolutePosition - u2.GuiOffset, ResizeBorder.AbsolutePosition - u2.GuiOffset + ResizeBorder.AbsoluteSize) then
                        v42 = true;
                        break;
                    end;
                end;
            end;

            if not v42 then
                u1.SetFocusedWindow(nil);
            end;
        end;

        if p40.KeyCode == Enum.KeyCode.Tab and (u2.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or u2.UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) then
            quickSwapWindows();
        end;

        if p40.UserInputType == Enum.UserInputType.MouseButton1 and (u14 and (not u15 and (u18 and u17))) then
            local v43 = u17.state.position.value + u17.state.size.value / 2;
            local v44 = u2.getMouseLocation() - v43;

            if math.abs(v44.X) * u17.state.size.value.Y >= math.abs(v44.Y) * u17.state.size.value.X then
                Top = Enum.TopBottom.Center;
                local v45;

                if math.sign(v44.X) == -1 then
                    v45 = Enum.LeftRight.Left;
                else
                    v45 = Enum.LeftRight.Right;
                end;

                Left = v45;
            else
                Left = Enum.LeftRight.Center;
                local v46;

                if math.sign(v44.Y) == -1 then
                    v46 = Enum.TopBottom.Top;
                else
                    v46 = Enum.TopBottom.Bottom;
                end;

                Top = v46;
            end;

            u13 = true;
            u12 = u17;
        end;
    end);
    u2.registerEvent("TouchTapInWorld", function(p47, p48) -- Line: 257
        -- upvalues: u1 (copy)
        if not u1._started then
            return;
        end;

        if not p48 then
            u1.SetFocusedWindow(nil);
        end;
    end);
    u2.registerEvent("InputChanged", function(p49) -- Line: 266
        -- upvalues: u1 (copy), u10 (ref), u9 (ref), u2 (copy), u11 (ref), fitPositionToWindowBounds (copy), u13 (ref), u12 (ref), u16 (ref), Left (ref), Top (ref), fitSizeToWindowBounds (copy)
        if not u1._started then
            return;
        end;

        if u10 and u9 then
            local v50;

            if p49.UserInputType == Enum.UserInputType.Touch then
                local Position = p49.Position;
                v50 = Vector2.new(Position.X, Position.Y);
            else
                v50 = u2.getMouseLocation();
            end;

            local WindowButton = u9.Instance.WindowButton;
            local v51 = fitPositionToWindowBounds(u9, v50 - u11);
            WindowButton.Position = UDim2.fromOffset(v51.X, v51.Y);
            u9.state.position.value = v51;
        end;

        if u13 and (u12 and u12.arguments.NoResize ~= true) then
            local WindowButton = u12.Instance.WindowButton;
            local v52 = Vector2.new(WindowButton.Position.X.Offset, WindowButton.Position.Y.Offset);
            local v53 = Vector2.new(WindowButton.Size.X.Offset, WindowButton.Size.Y.Offset);
            local v54;

            if p49.UserInputType == Enum.UserInputType.Touch then
                v54 = p49.Delta;
            else
                v54 = u2.getMouseLocation() - u16;
            end;

            local v55 = v52 + Vector2.new(Left ~= Enum.LeftRight.Left and 0 or v54.X, Top ~= Enum.TopBottom.Top and 0 or v54.Y);
            local v56;

            if Left == Enum.LeftRight.Left then
                v56 = -v54.X;
            else
                v56 = Left ~= Enum.LeftRight.Right and 0 or v54.X;
            end;

            local v57;

            if Top == Enum.TopBottom.Top then
                v57 = -v54.Y;
            else
                v57 = Top ~= Enum.TopBottom.Bottom and 0 or v54.Y;
            end;

            local v58 = fitSizeToWindowBounds(u12, v53 + Vector2.new(v56, v57));
            local v59 = fitPositionToWindowBounds(u12, v55);
            WindowButton.Size = UDim2.fromOffset(v58.X, v58.Y);
            u12.state.size.value = v58;
            WindowButton.Position = UDim2.fromOffset(v59.X, v59.Y);
            u12.state.position.value = v59;
        end;

        u16 = u2.getMouseLocation();
    end);
    u2.registerEvent("InputEnded", function(p60, p61) -- Line: 321
        -- upvalues: u1 (copy), u10 (ref), u9 (ref), u13 (ref), u12 (ref), quickSwapWindows (copy)
        if not u1._started then
            return;
        end;

        if (p60.UserInputType == Enum.UserInputType.MouseButton1 or p60.UserInputType == Enum.UserInputType.Touch) and (u10 and u9) then
            local WindowButton = u9.Instance.WindowButton;
            u10 = false;
            u9.state.position:set(Vector2.new(WindowButton.Position.X.Offset, WindowButton.Position.Y.Offset));
        end;

        if (p60.UserInputType == Enum.UserInputType.MouseButton1 or p60.UserInputType == Enum.UserInputType.Touch) and (u13 and u12) then
            u13 = false;
            u12.state.size:set(u12.Instance.WindowButton.AbsoluteSize);
        end;

        if p60.KeyCode == Enum.KeyCode.ButtonX then
            quickSwapWindows();
        end;
    end);
    u1.WidgetConstructor("Window", {
        hasState = true,
        hasChildren = true,
        Args = {
            Title = 1,
            NoTitleBar = 2,
            NoBackground = 3,
            NoCollapse = 4,
            NoClose = 5,
            NoMove = 6,
            NoScrollbar = 7,
            NoResize = 8,
            NoNav = 9,
            NoMenu = 10
        },
        Events = {
            closed = {
                Init = function(p62) -- Line: 360
                end,

                Get = function(p63) -- Line: 361
                    -- upvalues: u1 (copy)
                    return p63.lastClosedTick == u1._cycleTick;
                end
            },
            opened = {
                Init = function(p64) -- Line: 366
                end,

                Get = function(p65) -- Line: 367
                    -- upvalues: u1 (copy)
                    return p65.lastOpenedTick == u1._cycleTick;
                end
            },
            collapsed = {
                Init = function(p66) -- Line: 372
                end,

                Get = function(p67) -- Line: 373
                    -- upvalues: u1 (copy)
                    return p67.lastCollapsedTick == u1._cycleTick;
                end
            },
            uncollapsed = {
                Init = function(p68) -- Line: 378
                end,

                Get = function(p69) -- Line: 379
                    -- upvalues: u1 (copy)
                    return p69.lastUncollapsedTick == u1._cycleTick;
                end
            },
            hovered = u2.EVENTS.hover(function(p70) -- Line: 383
                return p70.Instance.WindowButton;
            end)
        },

        Generate = function(u71) -- Line: 388, Name: Generate
            -- upvalues: u1 (copy), u19 (copy), u2 (copy), u9 (ref), u10 (ref), u11 (ref), u18 (ref), u17 (ref), u13 (ref), Top (ref), Left (ref), u12 (ref), u14 (ref), u15 (ref)
            u71.parentWidget = u1._rootWidget;
            u71.usesScreenGuis = u1._config.UseScreenGUIs;
            u19[u71.ID] = u71;
            local v72;

            if u71.usesScreenGuis then
                v72 = Instance.new("ScreenGui");
                v72.ResetOnSpawn = false;
                v72.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                v72.DisplayOrder = u1._config.DisplayOrderOffset;
                v72.ScreenInsets = u1._config.ScreenInsets;
                v72.IgnoreGuiInset = u1._config.IgnoreGuiInset;
            else
                v72 = Instance.new("Frame");
                v72.AnchorPoint = Vector2.new(0.5, 0.5);
                v72.Position = UDim2.fromScale(0.5, 0.5);
                v72.Size = UDim2.fromScale(1, 1);
                v72.BackgroundTransparency = 1;
                v72.ZIndex = u1._config.DisplayOrderOffset;
            end;

            v72.Name = "Iris_Window";
            local TextButton = Instance.new("TextButton");
            TextButton.Name = "WindowButton";
            TextButton.Size = UDim2.fromOffset(0, 0);
            TextButton.BackgroundTransparency = 1;
            TextButton.BorderSizePixel = 0;
            TextButton.Text = "";
            TextButton.AutoButtonColor = false;
            TextButton.ClipsDescendants = false;
            TextButton.Selectable = false;
            TextButton.SelectionImageObject = u1.SelectionImageObject;
            TextButton.SelectionGroup = true;
            TextButton.SelectionBehaviorUp = Enum.SelectionBehavior.Stop;
            TextButton.SelectionBehaviorDown = Enum.SelectionBehavior.Stop;
            TextButton.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop;
            TextButton.SelectionBehaviorRight = Enum.SelectionBehavior.Stop;
            u2.UIStroke(TextButton, u1._config.WindowBorderSize, u1._config.BorderColor, u1._config.BorderTransparency);
            TextButton.Parent = v72;
            u2.applyInputBegan(TextButton, function(p73) -- Line: 433
                -- upvalues: u71 (copy), u1 (ref), u9 (ref), u10 (ref), u11 (ref), u2 (ref)
                if p73.UserInputType == Enum.UserInputType.MouseMovement or p73.UserInputType == Enum.UserInputType.Keyboard then
                    return;
                end;

                if u71.state.isUncollapsed.value then
                    u1.SetFocusedWindow(u71);
                end;

                if not u71.arguments.NoMove and p73.UserInputType == Enum.UserInputType.MouseButton1 then
                    u9 = u71;
                    u10 = true;
                    u11 = u2.getMouseLocation() - u71.state.position.value;
                end;
            end);
            local Frame = Instance.new("Frame");
            Frame.Name = "Content";
            Frame.AnchorPoint = Vector2.new(0.5, 0.5);
            Frame.Position = UDim2.fromScale(0.5, 0.5);
            Frame.Size = UDim2.fromScale(1, 1);
            Frame.BackgroundTransparency = 1;
            Frame.ClipsDescendants = true;
            Frame.Parent = TextButton;
            local v74 = u2.UIListLayout(Frame, Enum.FillDirection.Vertical, UDim.new(0, 0));
            v74.HorizontalAlignment = Enum.HorizontalAlignment.Center;
            v74.VerticalAlignment = Enum.VerticalAlignment.Top;
            local ScrollingFrame = Instance.new("ScrollingFrame");
            ScrollingFrame.Name = "WindowContainer";
            ScrollingFrame.Size = UDim2.fromScale(1, 1);
            ScrollingFrame.BackgroundColor3 = u1._config.WindowBgColor;
            ScrollingFrame.BackgroundTransparency = u1._config.WindowBgTransparency;
            ScrollingFrame.BorderSizePixel = 0;
            ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
            ScrollingFrame.ScrollBarImageTransparency = u1._config.ScrollbarGrabTransparency;
            ScrollingFrame.ScrollBarImageColor3 = u1._config.ScrollbarGrabColor;
            ScrollingFrame.CanvasSize = UDim2.fromScale(0, 0);
            ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
            ScrollingFrame.TopImage = u2.ICONS.BLANK_SQUARE;
            ScrollingFrame.MidImage = u2.ICONS.BLANK_SQUARE;
            ScrollingFrame.BottomImage = u2.ICONS.BLANK_SQUARE;
            ScrollingFrame.LayoutOrder = u71.ZIndex + 65535;
            ScrollingFrame.ClipsDescendants = true;
            u2.UIPadding(ScrollingFrame, u1._config.WindowPadding);
            ScrollingFrame.Parent = Frame;
            local UIFlexItem = Instance.new("UIFlexItem");
            UIFlexItem.FlexMode = Enum.UIFlexMode.Fill;
            UIFlexItem.ItemLineAlignment = Enum.ItemLineAlignment.End;
            UIFlexItem.Parent = ScrollingFrame;
            ScrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- Line: 488
                -- upvalues: u71 (copy), ScrollingFrame (copy)
                u71.state.scrollDistance.value = ScrollingFrame.CanvasPosition.Y;
            end);
            u2.applyInputBegan(ScrollingFrame, function(p75) -- Line: 493
                -- upvalues: u71 (copy), u1 (ref)
                if p75.UserInputType == Enum.UserInputType.MouseMovement or p75.UserInputType == Enum.UserInputType.Keyboard then
                    return;
                end;

                if u71.state.isUncollapsed.value then
                    u1.SetFocusedWindow(u71);
                end;
            end);
            local Frame2 = Instance.new("Frame");
            Frame2.Name = "TerminatingFrame";
            Frame2.Size = UDim2.fromOffset(0, u1._config.WindowPadding.Y + u1._config.FramePadding.Y);
            Frame2.BackgroundTransparency = 1;
            Frame2.BorderSizePixel = 0;
            Frame2.LayoutOrder = 2147483632;
            u2.UIListLayout(ScrollingFrame, Enum.FillDirection.Vertical, UDim.new(0, u1._config.ItemSpacing.Y)).VerticalAlignment = Enum.VerticalAlignment.Top;
            Frame2.Parent = ScrollingFrame;
            local Frame3 = Instance.new("Frame");
            Frame3.Name = "TitleBar";
            Frame3.AutomaticSize = Enum.AutomaticSize.Y;
            Frame3.Size = UDim2.fromScale(1, 0);
            Frame3.BorderSizePixel = 0;
            Frame3.ClipsDescendants = true;
            Frame3.Parent = Frame;
            u2.UIPadding(Frame3, Vector2.new(u1._config.FramePadding.X));
            u2.UIListLayout(Frame3, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.X)).VerticalAlignment = Enum.VerticalAlignment.Center;
            u2.applyInputBegan(Frame3, function(p76) -- Line: 524
                -- upvalues: u71 (copy), u9 (ref), u10 (ref), u11 (ref)
                if p76.UserInputType == Enum.UserInputType.Touch and not u71.arguments.NoMove then
                    u9 = u71;
                    u10 = true;
                    local Position = p76.Position;
                    u11 = Vector2.new(Position.X, Position.Y) - u71.state.position.value;
                end;
            end);
            local v77 = u1._config.TextSize + (u1._config.FramePadding.Y - 1) * 2;
            local TextButton2 = Instance.new("TextButton");
            TextButton2.Name = "CollapseButton";
            TextButton2.AutomaticSize = Enum.AutomaticSize.None;
            TextButton2.AnchorPoint = Vector2.new(0, 0.5);
            TextButton2.Size = UDim2.fromOffset(v77, v77);
            TextButton2.Position = UDim2.fromScale(0, 0.5);
            TextButton2.BackgroundTransparency = 1;
            TextButton2.BorderSizePixel = 0;
            TextButton2.AutoButtonColor = false;
            TextButton2.Text = "";
            u2.UICorner(TextButton2);
            TextButton2.Parent = Frame3;
            u2.applyButtonClick(TextButton2, function() -- Line: 552
                -- upvalues: u71 (copy)
                u71.state.isUncollapsed:set(not u71.state.isUncollapsed.value);
            end);
            u2.applyInteractionHighlights("Background", TextButton2, TextButton2, {
                Transparency = 1,
                Color = u1._config.ButtonColor,
                HoveredColor = u1._config.ButtonHoveredColor,
                HoveredTransparency = u1._config.ButtonHoveredTransparency,
                ActiveColor = u1._config.ButtonActiveColor,
                ActiveTransparency = u1._config.ButtonActiveTransparency
            });
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.Name = "Arrow";
            ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
            ImageLabel.Size = UDim2.fromOffset(math.floor(0.7 * v77), (math.floor(0.7 * v77)));
            ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
            ImageLabel.BackgroundTransparency = 1;
            ImageLabel.BorderSizePixel = 0;
            ImageLabel.Image = u2.ICONS.MULTIPLICATION_SIGN;
            ImageLabel.ImageColor3 = u1._config.TextColor;
            ImageLabel.ImageTransparency = u1._config.TextTransparency;
            ImageLabel.Parent = TextButton2;
            local TextButton3 = Instance.new("TextButton");
            TextButton3.Name = "CloseButton";
            TextButton3.AutomaticSize = Enum.AutomaticSize.None;
            TextButton3.AnchorPoint = Vector2.new(1, 0.5);
            TextButton3.Size = UDim2.fromOffset(v77, v77);
            TextButton3.Position = UDim2.fromScale(1, 0.5);
            TextButton3.BackgroundTransparency = 1;
            TextButton3.BorderSizePixel = 0;
            TextButton3.Text = "";
            TextButton3.AutoButtonColor = false;
            TextButton3.LayoutOrder = 2;
            u2.UICorner(TextButton3);
            u2.applyButtonClick(TextButton3, function() -- Line: 591
                -- upvalues: u71 (copy)
                u71.state.isOpened:set(false);
            end);
            u2.applyInteractionHighlights("Background", TextButton3, TextButton3, {
                Transparency = 1,
                Color = u1._config.ButtonColor,
                HoveredColor = u1._config.ButtonHoveredColor,
                HoveredTransparency = u1._config.ButtonHoveredTransparency,
                ActiveColor = u1._config.ButtonActiveColor,
                ActiveTransparency = u1._config.ButtonActiveTransparency
            });
            TextButton3.Parent = Frame3;
            local ImageLabel2 = Instance.new("ImageLabel");
            ImageLabel2.Name = "Icon";
            ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
            ImageLabel2.Size = UDim2.fromOffset(math.floor(0.7 * v77), (math.floor(0.7 * v77)));
            ImageLabel2.Position = UDim2.fromScale(0.5, 0.5);
            ImageLabel2.BackgroundTransparency = 1;
            ImageLabel2.BorderSizePixel = 0;
            ImageLabel2.Image = u2.ICONS.MULTIPLICATION_SIGN;
            ImageLabel2.ImageColor3 = u1._config.TextColor;
            ImageLabel2.ImageTransparency = u1._config.TextTransparency;
            ImageLabel2.Parent = TextButton3;
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "Title";
            TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
            TextLabel.BorderSizePixel = 0;
            TextLabel.BackgroundTransparency = 1;
            TextLabel.LayoutOrder = 1;
            TextLabel.ClipsDescendants = true;
            u2.UIPadding(TextLabel, Vector2.new(0, u1._config.FramePadding.Y));
            u2.applyTextStyle(TextLabel);
            TextLabel.TextXAlignment = Enum.TextXAlignment[u1._config.WindowTitleAlign.Name];
            local UIFlexItem2 = Instance.new("UIFlexItem");
            UIFlexItem2.FlexMode = Enum.UIFlexMode.Fill;
            UIFlexItem2.ItemLineAlignment = Enum.ItemLineAlignment.Center;
            UIFlexItem2.Parent = TextLabel;
            TextLabel.Parent = Frame3;
            local v78 = u1._config.TextSize + u1._config.FramePadding.X;
            local ImageButton = Instance.new("ImageButton");
            ImageButton.Name = "LeftResizeGrip";
            ImageButton.AnchorPoint = Vector2.yAxis;
            ImageButton.Rotation = 180;
            ImageButton.Position = UDim2.fromScale(0, 1);
            ImageButton.Size = UDim2.fromOffset(v78, v78);
            ImageButton.BackgroundTransparency = 1;
            ImageButton.BorderSizePixel = 0;
            ImageButton.Image = u2.ICONS.BOTTOM_RIGHT_CORNER;
            ImageButton.ImageColor3 = u1._config.ResizeGripColor;
            ImageButton.ImageTransparency = 1;
            ImageButton.AutoButtonColor = false;
            ImageButton.ZIndex = 3;
            ImageButton.Parent = TextButton;
            u2.applyInteractionHighlights("Image", ImageButton, ImageButton, {
                Transparency = 1,
                Color = u1._config.ResizeGripColor,
                HoveredColor = u1._config.ResizeGripHoveredColor,
                HoveredTransparency = u1._config.ResizeGripHoveredTransparency,
                ActiveColor = u1._config.ResizeGripActiveColor,
                ActiveTransparency = u1._config.ResizeGripActiveTransparency
            });
            u2.applyButtonDown(ImageButton, function() -- Line: 666
                -- upvalues: u18 (ref), u17 (ref), u71 (copy), u1 (ref), u13 (ref), Top (ref), Left (ref), u12 (ref)
                if not u18 or u17 ~= u71 then
                    u1.SetFocusedWindow(u71);
                end;

                u13 = true;
                Top = Enum.TopBottom.Bottom;
                Left = Enum.LeftRight.Left;
                u12 = u71;
            end);
            local ImageButton2 = Instance.new("ImageButton");
            ImageButton2.Name = "RightResizeGrip";
            ImageButton2.AnchorPoint = Vector2.one;
            ImageButton2.Rotation = 90;
            ImageButton2.Position = UDim2.fromScale(1, 1);
            ImageButton2.Size = UDim2.fromOffset(v78, v78);
            ImageButton2.BackgroundTransparency = 1;
            ImageButton2.BorderSizePixel = 0;
            ImageButton2.Image = u2.ICONS.BOTTOM_RIGHT_CORNER;
            ImageButton2.ImageColor3 = u1._config.ResizeGripColor;
            ImageButton2.ImageTransparency = u1._config.ResizeGripTransparency;
            ImageButton2.AutoButtonColor = false;
            ImageButton2.ZIndex = 3;
            ImageButton2.Parent = TextButton;
            u2.applyInteractionHighlights("Image", ImageButton2, ImageButton2, {
                Color = u1._config.ResizeGripColor,
                Transparency = u1._config.ResizeGripTransparency,
                HoveredColor = u1._config.ResizeGripHoveredColor,
                HoveredTransparency = u1._config.ResizeGripHoveredTransparency,
                ActiveColor = u1._config.ResizeGripActiveColor,
                ActiveTransparency = u1._config.ResizeGripActiveTransparency
            });
            u2.applyButtonDown(ImageButton2, function() -- Line: 702
                -- upvalues: u18 (ref), u17 (ref), u71 (copy), u1 (ref), u13 (ref), Top (ref), Left (ref), u12 (ref)
                if not u18 or u17 ~= u71 then
                    u1.SetFocusedWindow(u71);
                end;

                u13 = true;
                Top = Enum.TopBottom.Bottom;
                Left = Enum.LeftRight.Right;
                u12 = u71;
            end);
            local ImageButton3 = Instance.new("ImageButton");
            ImageButton3.Name = "LeftResizeBorder";
            ImageButton3.AnchorPoint = Vector2.new(1, 0.5);
            ImageButton3.Position = UDim2.fromScale(0, 0.5);
            ImageButton3.Size = UDim2.new(0, u1._config.WindowResizePadding.X, 1, 2 * u1._config.WindowBorderSize);
            ImageButton3.Transparency = 1;
            ImageButton3.Image = u2.ICONS.BORDER;
            ImageButton3.ResampleMode = Enum.ResamplerMode.Pixelated;
            ImageButton3.ScaleType = Enum.ScaleType.Slice;
            ImageButton3.SliceCenter = Rect.new(0, 0, 1, 1);
            ImageButton3.ImageRectOffset = Vector2.new(2, 2);
            ImageButton3.ImageRectSize = Vector2.new(2, 1);
            ImageButton3.ImageTransparency = 1;
            ImageButton3.AutoButtonColor = false;
            ImageButton3.ZIndex = 4;
            ImageButton3.Parent = TextButton;
            local ImageButton4 = Instance.new("ImageButton");
            ImageButton4.Name = "RightResizeBorder";
            ImageButton4.AnchorPoint = Vector2.new(0, 0.5);
            ImageButton4.Position = UDim2.fromScale(1, 0.5);
            ImageButton4.Size = UDim2.new(0, u1._config.WindowResizePadding.X, 1, 2 * u1._config.WindowBorderSize);
            ImageButton4.Transparency = 1;
            ImageButton4.Image = u2.ICONS.BORDER;
            ImageButton4.ResampleMode = Enum.ResamplerMode.Pixelated;
            ImageButton4.ScaleType = Enum.ScaleType.Slice;
            ImageButton4.SliceCenter = Rect.new(1, 0, 2, 1);
            ImageButton4.ImageRectOffset = Vector2.new(1, 2);
            ImageButton4.ImageRectSize = Vector2.new(2, 1);
            ImageButton4.ImageTransparency = 1;
            ImageButton4.AutoButtonColor = false;
            ImageButton4.ZIndex = 4;
            ImageButton4.Parent = TextButton;
            local ImageButton5 = Instance.new("ImageButton");
            ImageButton5.Name = "TopResizeBorder";
            ImageButton5.AnchorPoint = Vector2.new(0.5, 1);
            ImageButton5.Position = UDim2.fromScale(0.5, 0);
            ImageButton5.Size = UDim2.new(1, 2 * u1._config.WindowBorderSize, 0, u1._config.WindowResizePadding.Y);
            ImageButton5.Transparency = 1;
            ImageButton5.Image = u2.ICONS.BORDER;
            ImageButton5.ResampleMode = Enum.ResamplerMode.Pixelated;
            ImageButton5.ScaleType = Enum.ScaleType.Slice;
            ImageButton5.SliceCenter = Rect.new(0, 0, 1, 1);
            ImageButton5.ImageRectOffset = Vector2.new(2, 2);
            ImageButton5.ImageRectSize = Vector2.new(1, 2);
            ImageButton5.ImageTransparency = 1;
            ImageButton5.AutoButtonColor = false;
            ImageButton5.ZIndex = 4;
            ImageButton5.Parent = TextButton;
            local ImageButton6 = Instance.new("ImageButton");
            ImageButton6.Name = "BottomResizeBorder";
            ImageButton6.AnchorPoint = Vector2.new(0.5, 0);
            ImageButton6.Position = UDim2.fromScale(0.5, 1);
            ImageButton6.Size = UDim2.new(1, 2 * u1._config.WindowBorderSize, 0, u1._config.WindowResizePadding.Y);
            ImageButton6.Transparency = 1;
            ImageButton6.Image = u2.ICONS.BORDER;
            ImageButton6.ResampleMode = Enum.ResamplerMode.Pixelated;
            ImageButton6.ScaleType = Enum.ScaleType.Slice;
            ImageButton6.SliceCenter = Rect.new(0, 1, 1, 2);
            ImageButton6.ImageRectOffset = Vector2.new(2, 1);
            ImageButton6.ImageRectSize = Vector2.new(1, 2);
            ImageButton6.ImageTransparency = 1;
            ImageButton6.AutoButtonColor = false;
            ImageButton6.ZIndex = 4;
            ImageButton6.Parent = TextButton;
            u2.applyInteractionHighlights("Image", ImageButton3, ImageButton3, {
                Transparency = 1,
                Color = u1._config.ResizeGripColor,
                HoveredColor = u1._config.ResizeGripHoveredColor,
                HoveredTransparency = u1._config.ResizeGripHoveredTransparency,
                ActiveColor = u1._config.ResizeGripActiveColor,
                ActiveTransparency = u1._config.ResizeGripActiveTransparency
            });
            u2.applyInteractionHighlights("Image", ImageButton4, ImageButton4, {
                Transparency = 1,
                Color = u1._config.ResizeGripColor,
                HoveredColor = u1._config.ResizeGripHoveredColor,
                HoveredTransparency = u1._config.ResizeGripHoveredTransparency,
                ActiveColor = u1._config.ResizeGripActiveColor,
                ActiveTransparency = u1._config.ResizeGripActiveTransparency
            });
            u2.applyInteractionHighlights("Image", ImageButton5, ImageButton5, {
                Transparency = 1,
                Color = u1._config.ResizeGripColor,
                HoveredColor = u1._config.ResizeGripHoveredColor,
                HoveredTransparency = u1._config.ResizeGripHoveredTransparency,
                ActiveColor = u1._config.ResizeGripActiveColor,
                ActiveTransparency = u1._config.ResizeGripActiveTransparency
            });
            u2.applyInteractionHighlights("Image", ImageButton6, ImageButton6, {
                Transparency = 1,
                Color = u1._config.ResizeGripColor,
                HoveredColor = u1._config.ResizeGripHoveredColor,
                HoveredTransparency = u1._config.ResizeGripHoveredTransparency,
                ActiveColor = u1._config.ResizeGripActiveColor,
                ActiveTransparency = u1._config.ResizeGripActiveTransparency
            });
            local Frame4 = Instance.new("Frame");
            Frame4.Name = "ResizeBorder";
            Frame4.Position = UDim2.fromOffset(-u1._config.WindowResizePadding.X, -u1._config.WindowResizePadding.Y);
            Frame4.Size = UDim2.new(1, u1._config.WindowResizePadding.X * 2, 1, u1._config.WindowResizePadding.Y * 2);
            Frame4.BackgroundTransparency = 1;
            Frame4.BorderSizePixel = 0;
            Frame4.Active = false;
            Frame4.Selectable = false;
            Frame4.ClipsDescendants = false;
            Frame4.Parent = TextButton;
            u2.applyMouseEnter(Frame4, function() -- Line: 832
                -- upvalues: u17 (ref), u71 (copy), u14 (ref)
                if u17 == u71 then
                    u14 = true;
                end;
            end);
            u2.applyMouseLeave(Frame4, function() -- Line: 837
                -- upvalues: u17 (ref), u71 (copy), u14 (ref)
                if u17 == u71 then
                    u14 = false;
                end;
            end);
            u2.applyInputBegan(Frame4, function(p79) -- Line: 842
                -- upvalues: u71 (copy), u1 (ref)
                if p79.UserInputType == Enum.UserInputType.MouseMovement or p79.UserInputType == Enum.UserInputType.Keyboard then
                    return;
                end;

                if u71.state.isUncollapsed.value then
                    u1.SetFocusedWindow(u71);
                end;
            end);
            u2.applyMouseEnter(TextButton, function() -- Line: 851
                -- upvalues: u17 (ref), u71 (copy), u15 (ref)
                if u17 == u71 then
                    u15 = true;
                end;
            end);
            u2.applyMouseLeave(TextButton, function() -- Line: 856
                -- upvalues: u17 (ref), u71 (copy), u15 (ref)
                if u17 == u71 then
                    u15 = false;
                end;
            end);
            u71.ChildContainer = ScrollingFrame;

            return v72;
        end,

        GenerateState = function(p80) -- Line: 865, Name: GenerateState
            -- upvalues: u1 (copy), u18 (ref), u17 (ref), fitPositionToWindowBounds (copy), fitSizeToWindowBounds (copy)
            if p80.state.size == nil then
                p80.state.size = u1._widgetState(p80, "size", Vector2.new(400, 300));
            end;

            if p80.state.position == nil then
                local state = p80.state;
                local _widgetState = u1._widgetState;
                local v81;

                if u18 and u17 then
                    v81 = u17.state.position.value + Vector2.new(15, 45);
                else
                    v81 = Vector2.new(150, 250);
                end;

                state.position = _widgetState(p80, "position", v81);
            end;

            p80.state.position.value = fitPositionToWindowBounds(p80, p80.state.position.value);
            p80.state.size.value = fitSizeToWindowBounds(p80, p80.state.size.value);

            if p80.state.isUncollapsed == nil then
                p80.state.isUncollapsed = u1._widgetState(p80, "isUncollapsed", true);
            end;

            if p80.state.isOpened == nil then
                p80.state.isOpened = u1._widgetState(p80, "isOpened", true);
            end;

            if p80.state.scrollDistance == nil then
                p80.state.scrollDistance = u1._widgetState(p80, "scrollDistance", 0);
            end;
        end,

        Update = function(p82) -- Line: 885, Name: Update
            -- upvalues: u1 (copy)
            local ChildContainer = p82.ChildContainer;
            local WindowButton = p82.Instance.WindowButton;
            local Content = WindowButton.Content;
            local TitleBar = Content.TitleBar;
            local Title = TitleBar.Title;
            local Iris_MenuBar = Content:FindFirstChild("Iris_MenuBar");
            local LeftResizeGrip = WindowButton.LeftResizeGrip;
            local RightResizeGrip = WindowButton.RightResizeGrip;
            local LeftResizeBorder = WindowButton.LeftResizeBorder;
            local RightResizeBorder = WindowButton.RightResizeBorder;
            local TopResizeBorder = WindowButton.TopResizeBorder;
            local BottomResizeBorder = WindowButton.BottomResizeBorder;

            if p82.arguments.NoResize == true then
                LeftResizeGrip.Visible = false;
                RightResizeGrip.Visible = false;
                LeftResizeBorder.Visible = false;
                RightResizeBorder.Visible = false;
                TopResizeBorder.Visible = false;
                BottomResizeBorder.Visible = false;
            else
                LeftResizeGrip.Visible = true;
                RightResizeGrip.Visible = true;
                LeftResizeBorder.Visible = true;
                RightResizeBorder.Visible = true;
                TopResizeBorder.Visible = true;
                BottomResizeBorder.Visible = true;
            end;

            if p82.arguments.NoScrollbar then
                ChildContainer.ScrollBarThickness = 0;
            else
                ChildContainer.ScrollBarThickness = u1._config.ScrollbarSize;
            end;

            if p82.arguments.NoTitleBar then
                TitleBar.Visible = false;
            else
                TitleBar.Visible = true;
            end;

            if Iris_MenuBar then
                if p82.arguments.NoMenu then
                    Iris_MenuBar.Visible = false;
                else
                    Iris_MenuBar.Visible = true;
                end;
            end;

            if p82.arguments.NoBackground then
                ChildContainer.BackgroundTransparency = 1;
            else
                ChildContainer.BackgroundTransparency = u1._config.WindowBgTransparency;
            end;

            if p82.arguments.NoCollapse then
                TitleBar.CollapseButton.Visible = false;
            else
                TitleBar.CollapseButton.Visible = true;
            end;

            if p82.arguments.NoClose then
                TitleBar.CloseButton.Visible = false;
            else
                TitleBar.CloseButton.Visible = true;
            end;

            Title.Text = p82.arguments.Title or "";
        end,

        UpdateState = function(u83) -- Line: 952, Name: UpdateState
            -- upvalues: u1 (copy), u2 (copy)
            local value = u83.state.size.value;
            local value2 = u83.state.position.value;
            local value3 = u83.state.isUncollapsed.value;
            local value4 = u83.state.isOpened.value;
            local value5 = u83.state.scrollDistance.value;
            local Instance2 = u83.Instance;
            local ChildContainer = u83.ChildContainer;
            local WindowButton = Instance2.WindowButton;
            local Content = WindowButton.Content;
            local TitleBar = Content.TitleBar;
            local Iris_MenuBar = Content:FindFirstChild("Iris_MenuBar");
            local LeftResizeGrip = WindowButton.LeftResizeGrip;
            local RightResizeGrip = WindowButton.RightResizeGrip;
            local LeftResizeBorder = WindowButton.LeftResizeBorder;
            local RightResizeBorder = WindowButton.RightResizeBorder;
            local TopResizeBorder = WindowButton.TopResizeBorder;
            local BottomResizeBorder = WindowButton.BottomResizeBorder;
            WindowButton.Size = UDim2.fromOffset(value.X, value.Y);
            WindowButton.Position = UDim2.fromOffset(value2.X, value2.Y);

            if value4 then
                if u83.usesScreenGuis then
                    Instance2.Enabled = true;
                    WindowButton.Visible = true;
                else
                    Instance2.Visible = true;
                    WindowButton.Visible = true;
                end;

                u83.lastOpenedTick = u1._cycleTick + 1;
            else
                if u83.usesScreenGuis then
                    Instance2.Enabled = false;
                    WindowButton.Visible = false;
                else
                    Instance2.Visible = false;
                    WindowButton.Visible = false;
                end;

                u83.lastClosedTick = u1._cycleTick + 1;
            end;

            if value3 then
                TitleBar.CollapseButton.Arrow.Image = u2.ICONS.DOWN_POINTING_TRIANGLE;

                if Iris_MenuBar then
                    Iris_MenuBar.Visible = not u83.arguments.NoMenu;
                end;

                ChildContainer.Visible = true;

                if u83.arguments.NoResize ~= true then
                    LeftResizeGrip.Visible = true;
                    RightResizeGrip.Visible = true;
                    LeftResizeBorder.Visible = true;
                    RightResizeBorder.Visible = true;
                    TopResizeBorder.Visible = true;
                    BottomResizeBorder.Visible = true;
                end;

                WindowButton.AutomaticSize = Enum.AutomaticSize.None;
                u83.lastUncollapsedTick = u1._cycleTick + 1;
            else
                local Y = TitleBar.AbsoluteSize.Y;
                TitleBar.CollapseButton.Arrow.Image = u2.ICONS.RIGHT_POINTING_TRIANGLE;

                if Iris_MenuBar then
                    Iris_MenuBar.Visible = false;
                end;

                ChildContainer.Visible = false;
                LeftResizeGrip.Visible = false;
                RightResizeGrip.Visible = false;
                LeftResizeBorder.Visible = false;
                RightResizeBorder.Visible = false;
                TopResizeBorder.Visible = false;
                BottomResizeBorder.Visible = false;
                WindowButton.Size = UDim2.fromOffset(value.X, Y);
                u83.lastCollapsedTick = u1._cycleTick + 1;
            end;

            if value4 and value3 then
                u1.SetFocusedWindow(u83);
            else
                TitleBar.BackgroundColor3 = u1._config.TitleBgCollapsedColor;
                TitleBar.BackgroundTransparency = u1._config.TitleBgCollapsedTransparency;
                WindowButton.UIStroke.Color = u1._config.BorderColor;
                u1.SetFocusedWindow(nil);
            end;

            if value5 and value5 ~= 0 then
                local u84 = #u1._postCycleCallbacks + 1;
                local u85 = u1._cycleTick + 1;

                u1._postCycleCallbacks[u84] = function() -- Line: 1043
                    -- upvalues: u1 (ref), u85 (copy), u83 (copy), ChildContainer (copy), value5 (copy), u84 (copy)
                    if u85 <= u1._cycleTick then
                        if u83.lastCycleTick ~= -1 then
                            ChildContainer.CanvasPosition = Vector2.new(0, value5);
                        end;

                        u1._postCycleCallbacks[u84] = nil;
                    end;
                end;
            end;
        end,

        ChildAdded = function(p86, p87) -- Line: 1053, Name: ChildAdded
            local Content = p86.Instance.WindowButton.Content;

            if p87.type ~= "MenuBar" then
                return p86.ChildContainer;
            end;

            local ChildContainer = p86.ChildContainer;
            p87.Instance.ZIndex = ChildContainer.ZIndex + 1;
            p87.Instance.LayoutOrder = ChildContainer.LayoutOrder - 1;

            return Content;
        end,

        Discard = function(p88) -- Line: 1065, Name: Discard
            -- upvalues: u17 (ref), u18 (ref), u9 (ref), u10 (ref), u12 (ref), u13 (ref), u19 (copy), u2 (copy)
            if u17 == p88 then
                u17 = nil;
                u18 = false;
            end;

            if u9 == p88 then
                u9 = nil;
                u10 = false;
            end;

            if u12 == p88 then
                u12 = nil;
                u13 = false;
            end;

            u19[p88.ID] = nil;
            p88.Instance:Destroy();
            u2.discardState(p88);
        end
    });
end;