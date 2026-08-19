-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(u1, u2) -- Line: 3
    local function relocateTooltips() -- Line: 4
        -- upvalues: u1 (copy), u2 (copy)
        if u1._rootInstance == nil then
            return;
        end;

        local PopupScreenGui = u1._rootInstance:FindFirstChild("PopupScreenGui");

        if not PopupScreenGui then
            return;
        end;

        local TooltipContainer = PopupScreenGui.TooltipContainer;
        local v3 = u2.getMouseLocation();
        local v4 = u2.findBestWindowPosForPopup(v3, TooltipContainer.AbsoluteSize, u1._config.DisplaySafeAreaPadding, PopupScreenGui.AbsoluteSize);
        TooltipContainer.Position = UDim2.fromOffset(v4.X, v4.Y);
    end;

    u2.UserInputService.InputChanged:Connect(relocateTooltips);
    u1.WidgetConstructor("Tooltip", {
        hasState = false,
        hasChildren = false,
        Args = {
            Text = 1
        },
        Events = {},

        Generate = function(p5) -- Line: 32, Name: Generate
            -- upvalues: u1 (copy), u2 (copy)
            p5.parentWidget = u1._rootWidget;
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_Tooltip";
            Frame.Size = UDim2.new(u1._config.ContentWidth, UDim.new(0, 0));
            Frame.AutomaticSize = Enum.AutomaticSize.Y;
            Frame.BorderSizePixel = 0;
            Frame.BackgroundTransparency = 1;
            Frame.ZIndex = p5.ZIndex + 1;
            Frame.LayoutOrder = p5.ZIndex + 1;
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "TooltipText";
            TextLabel.Size = UDim2.fromOffset(0, 0);
            TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
            TextLabel.BackgroundColor3 = u1._config.WindowBgColor;
            TextLabel.BackgroundTransparency = u1._config.WindowBgTransparency;
            TextLabel.BorderSizePixel = u1._config.PopupBorderSize;
            TextLabel.TextWrapped = true;
            TextLabel.ZIndex = p5.ZIndex + 1;
            TextLabel.LayoutOrder = p5.ZIndex + 1;
            u2.applyTextStyle(TextLabel);
            u2.UIStroke(TextLabel, u1._config.WindowBorderSize, u1._config.BorderActiveColor, u1._config.BorderActiveTransparency);
            u2.UIPadding(TextLabel, u1._config.WindowPadding);

            if u1._config.PopupRounding > 0 then
                u2.UICorner(TextLabel, u1._config.PopupRounding);
            end;

            TextLabel.Parent = Frame;

            return Frame;
        end,

        Update = function(p6) -- Line: 66, Name: Update
            -- upvalues: relocateTooltips (copy)
            local TooltipText = p6.Instance.TooltipText;

            if p6.arguments.Text == nil then
                error("Iris.Text Text Argument is required", 5);
            end;

            TooltipText.Text = p6.arguments.Text;
            relocateTooltips();
        end,

        Discard = function(p7) -- Line: 75, Name: Discard
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

    local function quickSwapWindows() -- Line: 99
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

        if v21.state.isUncollapsed.value == false then
            v21.state.isUncollapsed:set(true);
        end;

        u1.SetFocusedWindow(v21);
    end;

    local function fitSizeToWindowBounds(p22, p23) -- Line: 126
        -- upvalues: u1 (copy), u2 (copy)
        local v24 = Vector2.new(p22.state.position.value.X, p22.state.position.value.Y);
        local v25 = (u1._config.TextSize + u1._config.FramePadding.Y * 2) * 2;
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

    local function fitPositionToWindowBounds(p32, p33) -- Line: 142
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

    function u1.SetFocusedWindow(p39) -- Line: 164
        -- upvalues: u17 (ref), u18 (ref), u19 (copy), u1 (copy), u8 (ref), u2 (copy)
        if u17 == p39 then
            return;
        end;

        if u18 and u17 ~= nil then
            if u19[u17.ID] then
                local WindowButton = u17.Instance.WindowButton;
                local TitleBar = WindowButton.TitleBar;

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
            local TitleBar = WindowButton.TitleBar;
            TitleBar.BackgroundColor3 = u1._config.TitleBgActiveColor;
            TitleBar.BackgroundTransparency = u1._config.TitleBgActiveTransparency;
            WindowButton.UIStroke.Color = u1._config.BorderActiveColor;
            u8 = u8 + 1;

            if p39.usesScreenGUI then
                Instance2.DisplayOrder = u8 + u1._config.DisplayOrderOffset;
            end;

            if p39.state.isUncollapsed.value == false then
                p39.state.isUncollapsed:set(true);
            end;

            if u2.GuiService.SelectedObject then
                if TitleBar.Visible then
                    u2.GuiService:Select(TitleBar);

                    return;
                end;

                u2.GuiService:Select(Instance2.ChildContainer);
            end;
        end;
    end;

    u2.UserInputService.InputBegan:Connect(function(p40, p41) -- Line: 221
        -- upvalues: u1 (copy), u2 (copy), quickSwapWindows (copy), u14 (ref), u15 (ref), u18 (ref), u17 (ref), Top (ref), Left (ref), u13 (ref), u12 (ref)
        if not p41 and p40.UserInputType == Enum.UserInputType.MouseButton1 then
            u1.SetFocusedWindow(nil);
        end;

        if p40.KeyCode == Enum.KeyCode.Tab and (u2.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or u2.UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) then
            quickSwapWindows();
        end;

        if p40.UserInputType == Enum.UserInputType.MouseButton1 and (u14 and (not u15 and (u18 and u17))) then
            local v42 = u17.state.position.value + u17.state.size.value * 0.5;
            local v43 = u2.getMouseLocation() - v42;

            if math.abs(v43.X) * u17.state.size.value.Y >= math.abs(v43.Y) * u17.state.size.value.X then
                Top = Enum.TopBottom.Center;
                local v44;

                if math.sign(v43.X) == -1 then
                    v44 = Enum.LeftRight.Left;
                else
                    v44 = Enum.LeftRight.Right;
                end;

                Left = v44;
            else
                Left = Enum.LeftRight.Center;
                local v45;

                if math.sign(v43.Y) == -1 then
                    v45 = Enum.TopBottom.Top;
                else
                    v45 = Enum.TopBottom.Bottom;
                end;

                Top = v45;
            end;

            u13 = true;
            u12 = u17;
        end;
    end);
    u2.UserInputService.TouchTapInWorld:Connect(function(p46, p47) -- Line: 252
        -- upvalues: u1 (copy)
        if not p47 then
            u1.SetFocusedWindow(nil);
        end;
    end);
    u2.UserInputService.InputChanged:Connect(function(p48) -- Line: 258
        -- upvalues: u10 (ref), u9 (ref), u2 (copy), u11 (ref), fitPositionToWindowBounds (copy), u13 (ref), u12 (ref), u16 (ref), Left (ref), Top (ref), fitSizeToWindowBounds (copy)
        if u10 and u9 then
            local v49;

            if p48.UserInputType == Enum.UserInputType.Touch then
                local Position = p48.Position;
                v49 = Vector2.new(Position.X, Position.Y);
            else
                v49 = u2.getMouseLocation();
            end;

            local WindowButton = u9.Instance.WindowButton;
            local v50 = fitPositionToWindowBounds(u9, v49 - u11);
            WindowButton.Position = UDim2.fromOffset(v50.X, v50.Y);
            u9.state.position.value = v50;
        end;

        if u13 and (u12 and u12.arguments.NoResize ~= true) then
            local WindowButton = u12.Instance.WindowButton;
            local v51 = Vector2.new(WindowButton.Position.X.Offset, WindowButton.Position.Y.Offset);
            local v52 = Vector2.new(WindowButton.Size.X.Offset, WindowButton.Size.Y.Offset);
            local v53;

            if p48.UserInputType == Enum.UserInputType.Touch then
                v53 = p48.Delta;
            else
                v53 = u2.getMouseLocation() - u16;
            end;

            local v54 = v51 + Vector2.new(Left ~= Enum.LeftRight.Left and 0 or v53.X, Top ~= Enum.TopBottom.Top and 0 or v53.Y);
            local v55;

            if Left == Enum.LeftRight.Left then
                v55 = -v53.X;
            else
                v55 = Left ~= Enum.LeftRight.Right and 0 or v53.X;
            end;

            local v56;

            if Top == Enum.TopBottom.Top then
                v56 = -v53.Y;
            else
                v56 = Top ~= Enum.TopBottom.Bottom and 0 or v53.Y;
            end;

            local v57 = fitSizeToWindowBounds(u12, v52 + Vector2.new(v55, v56));
            local v58 = fitPositionToWindowBounds(u12, v54);
            WindowButton.Size = UDim2.fromOffset(v57.X, v57.Y);
            u12.state.size.value = v57;
            WindowButton.Position = UDim2.fromOffset(v58.X, v58.Y);
            u12.state.position.value = v58;
        end;

        u16 = u2.getMouseLocation();
    end);
    u2.UserInputService.InputEnded:Connect(function(p59, p60) -- Line: 319
        -- upvalues: u10 (ref), u9 (ref), u13 (ref), u12 (ref), quickSwapWindows (copy)
        if (p59.UserInputType == Enum.UserInputType.MouseButton1 or p59.UserInputType == Enum.UserInputType.Touch) and (u10 and u9) then
            local WindowButton = u9.Instance.WindowButton;
            u10 = false;
            u9.state.position:set(Vector2.new(WindowButton.Position.X.Offset, WindowButton.Position.Y.Offset));
        end;

        if (p59.UserInputType == Enum.UserInputType.MouseButton1 or p59.UserInputType == Enum.UserInputType.Touch) and (u13 and u12) then
            u13 = false;
            u12.state.size:set(u12.Instance.WindowButton.AbsoluteSize);
        end;

        if p59.KeyCode == Enum.KeyCode.ButtonX then
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
                Init = function(p61) -- Line: 362
                end,

                Get = function(p62) -- Line: 363
                    -- upvalues: u1 (copy)
                    return p62.lastClosedTick == u1._cycleTick;
                end
            },
            opened = {
                Init = function(p63) -- Line: 368
                end,

                Get = function(p64) -- Line: 369
                    -- upvalues: u1 (copy)
                    return p64.lastOpenedTick == u1._cycleTick;
                end
            },
            collapsed = {
                Init = function(p65) -- Line: 374
                end,

                Get = function(p66) -- Line: 375
                    -- upvalues: u1 (copy)
                    return p66.lastCollapsedTick == u1._cycleTick;
                end
            },
            uncollapsed = {
                Init = function(p67) -- Line: 380
                end,

                Get = function(p68) -- Line: 381
                    -- upvalues: u1 (copy)
                    return p68.lastUncollapsedTick == u1._cycleTick;
                end
            },
            hovered = u2.EVENTS.hover(function(p69) -- Line: 385
                return p69.Instance.WindowButton;
            end)
        },

        Generate = function(u70) -- Line: 390, Name: Generate
            -- upvalues: u1 (copy), u19 (copy), u2 (copy), u9 (ref), u10 (ref), u11 (ref), u18 (ref), u17 (ref), u13 (ref), Top (ref), Left (ref), u12 (ref), u14 (ref), u15 (ref)
            u70.parentWidget = u1._rootWidget;
            u70.usesScreenGUI = u1._config.UseScreenGUIs;
            u19[u70.ID] = u70;
            local v71;

            if u70.usesScreenGUI then
                v71 = Instance.new("ScreenGui");
                v71.ResetOnSpawn = false;
                v71.DisplayOrder = u1._config.DisplayOrderOffset;
                v71.IgnoreGuiInset = u1._config.IgnoreGuiInset;
            else
                v71 = Instance.new("Folder");
            end;

            v71.Name = "Iris_Window";
            local TextButton = Instance.new("TextButton");
            TextButton.Name = "WindowButton";
            TextButton.Size = UDim2.fromOffset(0, 0);
            TextButton.BackgroundTransparency = 1;
            TextButton.BorderSizePixel = 0;
            TextButton.Text = "";
            TextButton.ClipsDescendants = false;
            TextButton.AutoButtonColor = false;
            TextButton.Selectable = false;
            TextButton.SelectionImageObject = u1.SelectionImageObject;
            TextButton.ZIndex = u70.ZIndex + 1;
            TextButton.LayoutOrder = u70.ZIndex + 1;
            TextButton.SelectionGroup = true;
            TextButton.SelectionBehaviorUp = Enum.SelectionBehavior.Stop;
            TextButton.SelectionBehaviorDown = Enum.SelectionBehavior.Stop;
            TextButton.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop;
            TextButton.SelectionBehaviorRight = Enum.SelectionBehavior.Stop;
            u2.UIStroke(TextButton, u1._config.WindowBorderSize, u1._config.BorderColor, u1._config.BorderTransparency);
            TextButton.Parent = v71;
            TextButton.InputBegan:Connect(function(p72) -- Line: 430
                -- upvalues: u70 (copy), u1 (ref), u9 (ref), u10 (ref), u11 (ref), u2 (ref)
                if p72.UserInputType == Enum.UserInputType.MouseMovement or p72.UserInputType == Enum.UserInputType.Keyboard then
                    return;
                end;

                if u70.state.isUncollapsed.value then
                    u1.SetFocusedWindow(u70);
                end;

                if not u70.arguments.NoMove and p72.UserInputType == Enum.UserInputType.MouseButton1 then
                    u9 = u70;
                    u10 = true;
                    u11 = u2.getMouseLocation() - u70.state.position.value;
                end;
            end);
            local ScrollingFrame = Instance.new("ScrollingFrame");
            ScrollingFrame.Name = "ChildContainer";
            ScrollingFrame.Size = UDim2.fromScale(1, 1);
            ScrollingFrame.Position = UDim2.fromOffset(0, 0);
            ScrollingFrame.BackgroundColor3 = u1._config.WindowBgColor;
            ScrollingFrame.BackgroundTransparency = u1._config.WindowBgTransparency;
            ScrollingFrame.BorderSizePixel = 0;
            ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
            ScrollingFrame.ScrollBarImageTransparency = u1._config.ScrollbarGrabTransparency;
            ScrollingFrame.ScrollBarImageColor3 = u1._config.ScrollbarGrabColor;
            ScrollingFrame.CanvasSize = UDim2.fromScale(0, 1);
            ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
            ScrollingFrame.ZIndex = u70.ZIndex + 3;
            ScrollingFrame.LayoutOrder = u70.ZIndex + 3;
            ScrollingFrame.ClipsDescendants = true;
            u2.UIPadding(ScrollingFrame, u1._config.WindowPadding);
            ScrollingFrame.Parent = TextButton;
            ScrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- Line: 466
                -- upvalues: u70 (copy), ScrollingFrame (copy)
                u70.state.scrollDistance.value = ScrollingFrame.CanvasPosition.Y;
            end);
            ScrollingFrame.InputBegan:Connect(function(p73) -- Line: 471
                -- upvalues: u70 (copy), u1 (ref)
                if p73.UserInputType == Enum.UserInputType.MouseMovement or p73.UserInputType == Enum.UserInputType.Keyboard then
                    return;
                end;

                if u70.state.isUncollapsed.value then
                    u1.SetFocusedWindow(u70);
                end;
            end);
            local Frame = Instance.new("Frame");
            Frame.Name = "TerminatingFrame";
            Frame.Size = UDim2.fromOffset(0, u1._config.WindowPadding.Y + u1._config.FramePadding.Y);
            Frame.BackgroundTransparency = 1;
            Frame.BorderSizePixel = 0;
            Frame.LayoutOrder = 2147483632;
            u2.UIListLayout(ScrollingFrame, Enum.FillDirection.Vertical, UDim.new(0, u1._config.ItemSpacing.Y)).VerticalAlignment = Enum.VerticalAlignment.Top;
            Frame.Parent = ScrollingFrame;
            local Frame2 = Instance.new("Frame");
            Frame2.Name = "TitleBar";
            Frame2.Size = UDim2.fromScale(1, 0);
            Frame2.AutomaticSize = Enum.AutomaticSize.Y;
            Frame2.BorderSizePixel = 0;
            Frame2.ZIndex = u70.ZIndex + 1;
            Frame2.LayoutOrder = u70.ZIndex + 1;
            Frame2.ClipsDescendants = true;
            Frame2.Parent = TextButton;
            Frame2.InputBegan:Connect(function(p74) -- Line: 504
                -- upvalues: u70 (copy), u9 (ref), u10 (ref), u11 (ref)
                if p74.UserInputType == Enum.UserInputType.Touch and not u70.arguments.NoMove then
                    u9 = u70;
                    u10 = true;
                    local Position = p74.Position;
                    u11 = Vector2.new(Position.X, Position.Y) - u70.state.position.value;
                end;
            end);
            local v75 = u1._config.TextSize + (u1._config.FramePadding.Y - 1) * 2;
            local TextButton2 = Instance.new("TextButton");
            TextButton2.Name = "CollapseButton";
            TextButton2.AnchorPoint = Vector2.new(0, 0.5);
            TextButton2.Size = UDim2.fromOffset(v75, v75);
            TextButton2.Position = UDim2.new(0, u1._config.FramePadding.X + 1, 0.5, 0);
            TextButton2.AutomaticSize = Enum.AutomaticSize.None;
            TextButton2.BackgroundTransparency = 1;
            TextButton2.BorderSizePixel = 0;
            TextButton2.AutoButtonColor = false;
            TextButton2.Text = "";
            TextButton2.ZIndex = u70.ZIndex + 4;
            u2.UICorner(TextButton2);
            TextButton2.Parent = Frame2;
            TextButton2.MouseButton1Click:Connect(function() -- Line: 533
                -- upvalues: u70 (copy)
                u70.state.isUncollapsed:set(not u70.state.isUncollapsed.value);
            end);
            u2.applyInteractionHighlights(TextButton2, TextButton2, {
                ButtonTransparency = 1,
                ButtonColor = u1._config.ButtonColor,
                ButtonHoveredColor = u1._config.ButtonHoveredColor,
                ButtonHoveredTransparency = u1._config.ButtonHoveredTransparency,
                ButtonActiveColor = u1._config.ButtonActiveColor,
                ButtonActiveTransparency = u1._config.ButtonActiveTransparency
            });
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.Name = "Arrow";
            ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
            ImageLabel.Size = UDim2.fromOffset(math.floor(v75 * 0.7), (math.floor(v75 * 0.7)));
            ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
            ImageLabel.BackgroundTransparency = 1;
            ImageLabel.BorderSizePixel = 0;
            ImageLabel.Image = u2.ICONS.MULTIPLICATION_SIGN;
            ImageLabel.ImageColor3 = u1._config.TextColor;
            ImageLabel.ImageTransparency = u1._config.TextTransparency;
            ImageLabel.ZIndex = u70.ZIndex + 5;
            ImageLabel.Parent = TextButton2;
            local TextButton3 = Instance.new("TextButton");
            TextButton3.Name = "CloseButton";
            TextButton3.AnchorPoint = Vector2.new(1, 0.5);
            TextButton3.Size = UDim2.fromOffset(v75, v75);
            TextButton3.Position = UDim2.new(1, -(u1._config.FramePadding.X + 1), 0.5, 0);
            TextButton3.AutomaticSize = Enum.AutomaticSize.None;
            TextButton3.BackgroundTransparency = 1;
            TextButton3.BorderSizePixel = 0;
            TextButton3.Text = "";
            TextButton3.ZIndex = u70.ZIndex + 4;
            TextButton3.AutoButtonColor = false;
            u2.UICorner(TextButton3);
            TextButton3.MouseButton1Click:Connect(function() -- Line: 574
                -- upvalues: u70 (copy)
                u70.state.isOpened:set(false);
            end);
            u2.applyInteractionHighlights(TextButton3, TextButton3, {
                ButtonTransparency = 1,
                ButtonColor = u1._config.ButtonColor,
                ButtonHoveredColor = u1._config.ButtonHoveredColor,
                ButtonHoveredTransparency = u1._config.ButtonHoveredTransparency,
                ButtonActiveColor = u1._config.ButtonActiveColor,
                ButtonActiveTransparency = u1._config.ButtonActiveTransparency
            });
            TextButton3.Parent = Frame2;
            local ImageLabel2 = Instance.new("ImageLabel");
            ImageLabel2.Name = "Icon";
            ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
            ImageLabel2.Size = UDim2.fromOffset(math.floor(v75 * 0.7), (math.floor(v75 * 0.7)));
            ImageLabel2.Position = UDim2.fromScale(0.5, 0.5);
            ImageLabel2.BackgroundTransparency = 1;
            ImageLabel2.BorderSizePixel = 0;
            ImageLabel2.Image = u2.ICONS.MULTIPLICATION_SIGN;
            ImageLabel2.ImageColor3 = u1._config.TextColor;
            ImageLabel2.ImageTransparency = u1._config.TextTransparency;
            ImageLabel2.ZIndex = u70.ZIndex + 5;
            ImageLabel2.Parent = TextButton3;
            local v76 = u1._config.WindowTitleAlign == Enum.LeftRight.Left and 0 or (u1._config.WindowTitleAlign == Enum.LeftRight.Center and 0.5 or 1);
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "Title";
            TextLabel.AnchorPoint = Vector2.new(v76, 0);
            TextLabel.Position = UDim2.fromScale(v76, 0);
            TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
            TextLabel.BorderSizePixel = 0;
            TextLabel.BackgroundTransparency = 1;
            TextLabel.ZIndex = u70.ZIndex + 3;
            u2.applyTextStyle(TextLabel);
            u2.UIPadding(TextLabel, u1._config.FramePadding);
            TextLabel.Parent = Frame2;
            local v77 = u1._config.TextSize + u1._config.FramePadding.X;
            local TextButton4 = Instance.new("TextButton");
            TextButton4.Name = "ResizeGrip";
            TextButton4.AnchorPoint = Vector2.new(1, 1);
            TextButton4.Size = UDim2.fromOffset(v77, v77);
            TextButton4.Position = UDim2.fromScale(1, 1);
            TextButton4.AutoButtonColor = false;
            TextButton4.BorderSizePixel = 0;
            TextButton4.BackgroundTransparency = 1;
            TextButton4.Text = u2.ICONS.BOTTOM_RIGHT_CORNER;
            TextButton4.TextSize = v77;
            TextButton4.TextColor3 = u1._config.ButtonColor;
            TextButton4.TextTransparency = u1._config.ButtonTransparency;
            TextButton4.LineHeight = 1.1;
            TextButton4.Selectable = false;
            TextButton4.ZIndex = u70.ZIndex + 3;
            TextButton4.Parent = TextButton;
            u2.applyTextInteractionHighlights(TextButton4, TextButton4, {
                ButtonColor = u1._config.ButtonColor,
                ButtonTransparency = u1._config.ButtonTransparency,
                ButtonHoveredColor = u1._config.ButtonHoveredColor,
                ButtonHoveredTransparency = u1._config.ButtonHoveredTransparency,
                ButtonActiveColor = u1._config.ButtonActiveColor,
                ButtonActiveTransparency = u1._config.ButtonActiveTransparency
            });
            TextButton4.MouseButton1Down:Connect(function() -- Line: 655
                -- upvalues: u18 (ref), u17 (ref), u70 (copy), u1 (ref), u13 (ref), Top (ref), Left (ref), u12 (ref)
                if not u18 or u17 ~= u70 then
                    u1.SetFocusedWindow(u70);
                end;

                u13 = true;
                Top = Enum.TopBottom.Bottom;
                Left = Enum.LeftRight.Right;
                u12 = u70;
            end);
            local TextButton5 = Instance.new("TextButton");
            TextButton5.Name = "ResizeBorder";
            TextButton5.Size = UDim2.new(1, u1._config.WindowResizePadding.X * 2, 1, u1._config.WindowResizePadding.Y * 2);
            TextButton5.Position = UDim2.fromOffset(-u1._config.WindowResizePadding.X, -u1._config.WindowResizePadding.Y);
            TextButton5.BackgroundTransparency = 1;
            TextButton5.BorderSizePixel = 0;
            TextButton5.Text = "";
            TextButton5.AutoButtonColor = false;
            TextButton5.Active = true;
            TextButton5.Selectable = false;
            TextButton5.ZIndex = u70.ZIndex;
            TextButton5.LayoutOrder = u70.ZIndex;
            TextButton5.ClipsDescendants = false;
            TextButton5.Parent = TextButton;
            TextButton5.MouseEnter:Connect(function() -- Line: 681
                -- upvalues: u17 (ref), u70 (copy), u14 (ref)
                if u17 == u70 then
                    u14 = true;
                end;
            end);
            TextButton5.MouseLeave:Connect(function() -- Line: 686
                -- upvalues: u17 (ref), u70 (copy), u14 (ref)
                if u17 == u70 then
                    u14 = false;
                end;
            end);
            TextButton.MouseEnter:Connect(function() -- Line: 692
                -- upvalues: u17 (ref), u70 (copy), u15 (ref)
                if u17 == u70 then
                    u15 = true;
                end;
            end);
            TextButton.MouseLeave:Connect(function() -- Line: 697
                -- upvalues: u17 (ref), u70 (copy), u15 (ref)
                if u17 == u70 then
                    u15 = false;
                end;
            end);

            return v71;
        end,

        Update = function(p78) -- Line: 705, Name: Update
            -- upvalues: u1 (copy)
            local WindowButton = p78.Instance.WindowButton;
            local TitleBar = WindowButton.TitleBar;
            local Title = TitleBar.Title;
            local MenuBar = WindowButton:FindFirstChild("MenuBar");
            local ChildContainer = WindowButton.ChildContainer;
            local ResizeGrip = WindowButton.ResizeGrip;
            local v79 = 0;
            local v80 = 0;

            if p78.arguments.NoResize == true then
                ResizeGrip.Visible = false;
            else
                ResizeGrip.Visible = true;
            end;

            if p78.arguments.NoScrollbar then
                ChildContainer.ScrollBarThickness = 0;
            else
                ChildContainer.ScrollBarThickness = u1._config.ScrollbarSize;
            end;

            if p78.arguments.NoTitleBar then
                TitleBar.Visible = false;
            else
                TitleBar.Visible = true;
                local Y = TitleBar.AbsoluteSize.Y;
                v79 = v79 + Y;
                v80 = v80 + Y;
            end;

            if MenuBar then
                if p78.arguments.NoMenu then
                    MenuBar.Visible = false;
                else
                    MenuBar.Visible = true;
                    v79 = v79 + MenuBar.AbsoluteSize.Y;
                end;

                MenuBar.Position = UDim2.fromOffset(0, v80);
            end;

            if p78.arguments.NoBackground then
                ChildContainer.BackgroundTransparency = 1;
            else
                ChildContainer.BackgroundTransparency = u1._config.WindowBgTransparency;
            end;

            local v81 = u1._config.FramePadding.X + u1._config.TextSize + u1._config.FramePadding.X * 2;

            if p78.arguments.NoCollapse then
                TitleBar.CollapseButton.Visible = false;
                TitleBar.Title.UIPadding.PaddingLeft = UDim.new(0, u1._config.FramePadding.X);
            else
                TitleBar.CollapseButton.Visible = true;
                TitleBar.Title.UIPadding.PaddingLeft = UDim.new(0, v81);
            end;

            if p78.arguments.NoClose then
                TitleBar.CloseButton.Visible = false;
                TitleBar.Title.UIPadding.PaddingRight = UDim.new(0, u1._config.FramePadding.X);
            else
                TitleBar.CloseButton.Visible = true;
                TitleBar.Title.UIPadding.PaddingRight = UDim.new(0, v81);
            end;

            ChildContainer.Size = UDim2.new(1, 0, 1, -v79);
            ChildContainer.CanvasSize = UDim2.new(0, 0, 1, -v79);
            ChildContainer.Position = UDim2.fromOffset(0, v79);
            Title.Text = p78.arguments.Title or "";
        end,

        Discard = function(p82) -- Line: 775, Name: Discard
            -- upvalues: u17 (ref), u18 (ref), u9 (ref), u10 (ref), u12 (ref), u13 (ref), u19 (copy), u2 (copy)
            if u17 == p82 then
                u17 = nil;
                u18 = false;
            end;

            if u9 == p82 then
                u9 = nil;
                u10 = false;
            end;

            if u12 == p82 then
                u12 = nil;
                u13 = false;
            end;

            u19[p82.ID] = nil;
            p82.Instance:Destroy();
            u2.discardState(p82);
        end,

        ChildAdded = function(p83) -- Line: 792, Name: ChildAdded
            return p83.Instance.WindowButton.ChildContainer;
        end,

        UpdateState = function(p84) -- Line: 797, Name: UpdateState
            -- upvalues: u1 (copy), u2 (copy)
            local value = p84.state.size.value;
            local value2 = p84.state.position.value;
            local value3 = p84.state.isUncollapsed.value;
            local value4 = p84.state.isOpened.value;
            local value5 = p84.state.scrollDistance.value;
            local Instance2 = p84.Instance;
            local WindowButton = Instance2.WindowButton;
            local TitleBar = WindowButton.TitleBar;
            local ChildContainer = WindowButton.ChildContainer;
            local ResizeGrip = WindowButton.ResizeGrip;
            WindowButton.Size = UDim2.fromOffset(value.X, value.Y);
            WindowButton.Position = UDim2.fromOffset(value2.X, value2.Y);

            if value4 then
                if p84.usesScreenGUI then
                    Instance2.Enabled = true;
                    WindowButton.Visible = true;
                else
                    WindowButton.Visible = true;
                end;

                p84.lastOpenedTick = u1._cycleTick + 1;
            else
                if p84.usesScreenGUI then
                    Instance2.Enabled = false;
                    WindowButton.Visible = false;
                else
                    WindowButton.Visible = false;
                end;

                p84.lastClosedTick = u1._cycleTick + 1;
            end;

            if value3 then
                TitleBar.CollapseButton.Arrow.Image = u2.ICONS.DOWN_POINTING_TRIANGLE;
                ChildContainer.Visible = true;

                if p84.arguments.NoResize ~= true then
                    ResizeGrip.Visible = true;
                end;

                WindowButton.AutomaticSize = Enum.AutomaticSize.None;
                p84.lastUncollapsedTick = u1._cycleTick + 1;
            else
                local Y = TitleBar.AbsoluteSize.Y;
                TitleBar.CollapseButton.Arrow.Image = u2.ICONS.RIGHT_POINTING_TRIANGLE;
                ChildContainer.Visible = false;
                ResizeGrip.Visible = false;
                WindowButton.Size = UDim2.fromOffset(value.X, Y);
                p84.lastCollapsedTick = u1._cycleTick + 1;
            end;

            if value4 and value3 then
                u1.SetFocusedWindow(p84);
            else
                TitleBar.BackgroundColor3 = u1._config.TitleBgCollapsedColor;
                TitleBar.BackgroundTransparency = u1._config.TitleBgCollapsedTransparency;
                WindowButton.UIStroke.Color = u1._config.BorderColor;
                u1.SetFocusedWindow(nil);
            end;

            if value5 and value5 ~= 0 then
                local u85 = #u1._postCycleCallbacks + 1;
                local u86 = u1._cycleTick + 1;

                u1._postCycleCallbacks[u85] = function() -- Line: 863
                    -- upvalues: u1 (ref), u86 (copy), ChildContainer (copy), value5 (copy), u85 (copy)
                    if u1._cycleTick == u86 then
                        ChildContainer.CanvasPosition = Vector2.new(0, value5);
                        u1._postCycleCallbacks[u85] = nil;
                    end;
                end;
            end;
        end,

        GenerateState = function(p87) -- Line: 871, Name: GenerateState
            -- upvalues: u1 (copy), u18 (ref), u17 (ref), fitPositionToWindowBounds (copy), fitSizeToWindowBounds (copy)
            if p87.state.size == nil then
                p87.state.size = u1._widgetState(p87, "size", Vector2.new(400, 300));
            end;

            if p87.state.position == nil then
                local state = p87.state;
                local _widgetState = u1._widgetState;
                local v88;

                if u18 and u17 then
                    v88 = u17.state.position.value + Vector2.new(15, 45);
                else
                    v88 = Vector2.new(150, 250);
                end;

                state.position = _widgetState(p87, "position", v88);
            end;

            p87.state.position.value = fitPositionToWindowBounds(p87, p87.state.position.value);
            p87.state.size.value = fitSizeToWindowBounds(p87, p87.state.size.value);

            if p87.state.isUncollapsed == nil then
                p87.state.isUncollapsed = u1._widgetState(p87, "isUncollapsed", true);
            end;

            if p87.state.isOpened == nil then
                p87.state.isOpened = u1._widgetState(p87, "isOpened", true);
            end;

            if p87.state.scrollDistance == nil then
                p87.state.scrollDistance = u1._widgetState(p87, "scrollDistance", 0);
            end;
        end
    });
end;