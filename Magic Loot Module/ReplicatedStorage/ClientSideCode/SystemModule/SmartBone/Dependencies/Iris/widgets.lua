-- Decompiled with Potassium's decompiler.

require(script.Parent.Types);
local u1 = {};

return function(u2) -- Line: 5
    -- upvalues: u1 (copy)
    u1.GuiService = game:GetService("GuiService");
    u1.RunService = game:GetService("RunService");
    u1.UserInputService = game:GetService("UserInputService");
    u1.ContextActionService = game:GetService("ContextActionService");
    u1.TextService = game:GetService("TextService");
    u1.ICONS = {
        RIGHT_POINTING_TRIANGLE = "rbxasset://textures/DeveloperFramework/button_arrow_right.png",
        DOWN_POINTING_TRIANGLE = "rbxasset://textures/DeveloperFramework/button_arrow_down.png",
        MULTIPLICATION_SIGN = "rbxasset://textures/AnimationEditor/icon_close.png",
        BOTTOM_RIGHT_CORNER = "◢",
        CHECK_MARK = "rbxasset://textures/AnimationEditor/icon_checkmark.png",
        ALPHA_BACKGROUND_TEXTURE = "rbxasset://textures/meshPartFallback.png"
    };
    u1.GuiInset = u1.GuiService:GetGuiInset();
    u1.IS_STUDIO = u1.RunService:IsStudio();

    function u1.getTime() -- Line: 24
        -- upvalues: u1 (ref)
        if u1.IS_STUDIO then
            return os.clock();
        end;

        return time();
    end;

    function u1.getMouseLocation() -- Line: 33
        -- upvalues: u1 (ref)
        return u1.UserInputService:GetMouseLocation() - u1.GuiInset;
    end;

    function u1.findBestWindowPosForPopup(p3, p4, p5, p6) -- Line: 37
        local v7;

        if p3.X + p4.X + 20 > p6.X then
            if p3.Y + p4.Y + 20 > p6.Y then
                v7 = p3 + Vector2.new(0, -(20 + p4.Y));
            else
                v7 = p3 + Vector2.new(0, 20);
            end;
        else
            v7 = p3 + Vector2.new(20, 0);
        end;

        local new = Vector2.new;
        local v8 = math.min(v7.X + p4.X, p6.X) - p4.X;
        local v9 = math.max(v8, p5.X);
        local v10 = math.min(v7.Y + p4.Y, p6.Y) - p4.Y;

        return new(v9, (math.max(v10, p5.Y)));
    end;

    function u1.isPosInsideRect(p11, p12, p13) -- Line: 57
        local v14;

        if p11.X > p12.X and (p11.X < p13.X and p11.Y > p12.Y) then
            v14 = p11.Y < p13.Y;
        else
            v14 = false;
        end;

        return v14;
    end;

    function u1.extend(p15, p16) -- Line: 61
        local v17 = table.clone(p15);

        for i, v in p16 do
            v17[i] = v;
        end;

        return v17;
    end;

    function u1.UIPadding(p18, p19) -- Line: 69
        local UIPadding = Instance.new("UIPadding");
        UIPadding.PaddingLeft = UDim.new(0, p19.X);
        UIPadding.PaddingRight = UDim.new(0, p19.X);
        UIPadding.PaddingTop = UDim.new(0, p19.Y);
        UIPadding.PaddingBottom = UDim.new(0, p19.Y);
        UIPadding.Parent = p18;

        return UIPadding;
    end;

    function u1.UIListLayout(p20, p21, p22) -- Line: 79
        local UIListLayout = Instance.new("UIListLayout");
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
        UIListLayout.Padding = p22;
        UIListLayout.FillDirection = p21;
        UIListLayout.Parent = p20;

        return UIListLayout;
    end;

    function u1.UIStroke(p23, p24, p25, p26) -- Line: 88
        local UIStroke = Instance.new("UIStroke");
        UIStroke.Thickness = p24;
        UIStroke.Color = p25;
        UIStroke.Transparency = p26;
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
        UIStroke.LineJoinMode = Enum.LineJoinMode.Round;
        UIStroke.Parent = p23;

        return UIStroke;
    end;

    function u1.UICorner(p27, p28) -- Line: 99
        local UICorner = Instance.new("UICorner");
        UICorner.CornerRadius = UDim.new(p28 and 0 or 1, p28 or 0);
        UICorner.Parent = p27;

        return UICorner;
    end;

    function u1.UISizeConstraint(p29, p30, p31) -- Line: 106
        local UISizeConstraint = Instance.new("UISizeConstraint");
        UISizeConstraint.MinSize = p30 or UISizeConstraint.MinSize;
        UISizeConstraint.MaxSize = p31 or UISizeConstraint.MaxSize;
        UISizeConstraint.Parent = p29;

        return UISizeConstraint;
    end;

    function u1.UIReference(p32, p33, p34) -- Line: 114
        local ObjectValue = Instance.new("ObjectValue");
        ObjectValue.Name = p34;
        ObjectValue.Value = p33;
        ObjectValue.Parent = p32;

        return ObjectValue;
    end;

    function u1.getScreenSizeForWindow(p35) -- Line: 123
        if p35.usesScreenGUI then
            return p35.Instance.AbsoluteSize;
        end;

        local Parent = p35.Instance.Parent;

        if Parent:IsA("GuiBase2d") then
            return Parent.AbsoluteSize;
        end;

        if Parent.Parent:IsA("GuiBase2d") then
            return Parent.AbsoluteSize;
        end;

        return workspace.CurrentCamera.ViewportSize;
    end;

    local GetTextBoundsParams = Instance.new("GetTextBoundsParams");
    GetTextBoundsParams.Font = u2._config.TextFont;
    GetTextBoundsParams.Size = u2._config.TextSize;
    GetTextBoundsParams.Width = (1 / 0);

    function u1.calculateTextSize(p36, p37) -- Line: 148
        -- upvalues: GetTextBoundsParams (copy), u1 (ref)
        if p37 then
            GetTextBoundsParams.Width = p37;
        end;

        GetTextBoundsParams.Text = p36;
        local v38 = u1.TextService:GetTextBoundsAsync(GetTextBoundsParams);

        if p37 then
            GetTextBoundsParams.Width = (1 / 0);
        end;

        return v38;
    end;

    function u1.applyTextStyle(p39) -- Line: 163
        -- upvalues: u2 (copy)
        p39.FontFace = u2._config.TextFont;
        p39.TextSize = u2._config.TextSize;
        p39.TextColor3 = u2._config.TextColor;
        p39.TextTransparency = u2._config.TextTransparency;
        p39.TextXAlignment = Enum.TextXAlignment.Left;
        p39.AutoLocalize = false;
        p39.RichText = false;
    end;

    function u1.applyInteractionHighlights(p40, u41, u42) -- Line: 174
        -- upvalues: u2 (copy)
        local u43 = false;
        p40.MouseEnter:Connect(function() -- Line: 176
            -- upvalues: u41 (copy), u42 (copy), u43 (ref)
            u41.BackgroundColor3 = u42.ButtonHoveredColor;
            u41.BackgroundTransparency = u42.ButtonHoveredTransparency;
            u43 = false;
        end);
        p40.MouseLeave:Connect(function() -- Line: 183
            -- upvalues: u41 (copy), u42 (copy), u43 (ref)
            u41.BackgroundColor3 = u42.ButtonColor;
            u41.BackgroundTransparency = u42.ButtonTransparency;
            u43 = true;
        end);
        p40.InputBegan:Connect(function(p44) -- Line: 190
            -- upvalues: u41 (copy), u42 (copy)
            if p44.UserInputType ~= Enum.UserInputType.MouseButton1 and p44.UserInputType ~= Enum.UserInputType.Gamepad1 then
                return;
            end;

            u41.BackgroundColor3 = u42.ButtonActiveColor;
            u41.BackgroundTransparency = u42.ButtonActiveTransparency;
        end);
        p40.InputEnded:Connect(function(p45) -- Line: 198
            -- upvalues: u43 (ref), u41 (copy), u42 (copy)
            if p45.UserInputType ~= Enum.UserInputType.MouseButton1 and p45.UserInputType ~= Enum.UserInputType.Gamepad1 or u43 then
                return;
            end;

            if p45.UserInputType == Enum.UserInputType.MouseButton1 then
                u41.BackgroundColor3 = u42.ButtonHoveredColor;
                u41.BackgroundTransparency = u42.ButtonHoveredTransparency;
            end;

            if p45.UserInputType == Enum.UserInputType.Gamepad1 then
                u41.BackgroundColor3 = u42.ButtonColor;
                u41.BackgroundTransparency = u42.ButtonTransparency;
            end;
        end);
        p40.SelectionImageObject = u2.SelectionImageObject;
    end;

    function u1.applyInteractionHighlightsWithMultiHighlightee(p46, u47) -- Line: 215
        -- upvalues: u2 (copy)
        local u48 = false;
        p46.MouseEnter:Connect(function() -- Line: 217
            -- upvalues: u47 (copy), u48 (ref)
            for _, v in u47 do
                v[1].BackgroundColor3 = v[2].ButtonHoveredColor;
                v[1].BackgroundTransparency = v[2].ButtonHoveredTransparency;
                u48 = false;
            end;
        end);
        p46.MouseLeave:Connect(function() -- Line: 226
            -- upvalues: u47 (copy), u48 (ref)
            for _, v in u47 do
                v[1].BackgroundColor3 = v[2].ButtonColor;
                v[1].BackgroundTransparency = v[2].ButtonTransparency;
                u48 = true;
            end;
        end);
        p46.InputBegan:Connect(function(p49) -- Line: 235
            -- upvalues: u47 (copy)
            if p49.UserInputType ~= Enum.UserInputType.MouseButton1 and p49.UserInputType ~= Enum.UserInputType.Gamepad1 then
                return;
            end;

            for _, v in u47 do
                v[1].BackgroundColor3 = v[2].ButtonActiveColor;
                v[1].BackgroundTransparency = v[2].ButtonActiveTransparency;
            end;
        end);
        p46.InputEnded:Connect(function(p50) -- Line: 245
            -- upvalues: u48 (ref), u47 (copy)
            if p50.UserInputType ~= Enum.UserInputType.MouseButton1 and p50.UserInputType ~= Enum.UserInputType.Gamepad1 or u48 then
                return;
            end;

            for _, v in u47 do
                if p50.UserInputType == Enum.UserInputType.MouseButton1 then
                    v[1].BackgroundColor3 = v[2].ButtonHoveredColor;
                    v[1].BackgroundTransparency = v[2].ButtonHoveredTransparency;
                end;

                if p50.UserInputType == Enum.UserInputType.Gamepad1 then
                    v[1].BackgroundColor3 = v[2].ButtonColor;
                    v[1].BackgroundTransparency = v[2].ButtonTransparency;
                end;
            end;
        end);
        p46.SelectionImageObject = u2.SelectionImageObject;
    end;

    function u1.applyTextInteractionHighlights(p51, u52, u53) -- Line: 264
        -- upvalues: u2 (copy)
        local u54 = false;
        p51.MouseEnter:Connect(function() -- Line: 266
            -- upvalues: u52 (copy), u53 (copy), u54 (ref)
            u52.TextColor3 = u53.ButtonHoveredColor;
            u52.TextTransparency = u53.ButtonHoveredTransparency;
            u54 = false;
        end);
        p51.MouseLeave:Connect(function() -- Line: 273
            -- upvalues: u52 (copy), u53 (copy), u54 (ref)
            u52.TextColor3 = u53.ButtonColor;
            u52.TextTransparency = u53.ButtonTransparency;
            u54 = true;
        end);
        p51.InputBegan:Connect(function(p55) -- Line: 280
            -- upvalues: u52 (copy), u53 (copy)
            if p55.UserInputType ~= Enum.UserInputType.MouseButton1 and p55.UserInputType ~= Enum.UserInputType.Gamepad1 then
                return;
            end;

            u52.TextColor3 = u53.ButtonActiveColor;
            u52.TextTransparency = u53.ButtonActiveTransparency;
        end);
        p51.InputEnded:Connect(function(p56) -- Line: 288
            -- upvalues: u54 (ref), u52 (copy), u53 (copy)
            if p56.UserInputType ~= Enum.UserInputType.MouseButton1 and p56.UserInputType ~= Enum.UserInputType.Gamepad1 or u54 then
                return;
            end;

            if p56.UserInputType == Enum.UserInputType.MouseButton1 then
                u52.TextColor3 = u53.ButtonHoveredColor;
                u52.TextTransparency = u53.ButtonHoveredTransparency;
            end;

            if p56.UserInputType == Enum.UserInputType.Gamepad1 then
                u52.TextColor3 = u53.ButtonColor;
                u52.TextTransparency = u53.ButtonTransparency;
            end;
        end);
        p51.SelectionImageObject = u2.SelectionImageObject;
    end;

    function u1.applyFrameStyle(p57, p58, p59) -- Line: 305
        -- upvalues: u2 (copy), u1 (ref)
        local FramePadding = u2._config.FramePadding;
        local FrameBorderSize = u2._config.FrameBorderSize;
        local BorderColor = u2._config.BorderColor;
        local ButtonTransparency = u2._config.ButtonTransparency;
        local FrameRounding = u2._config.FrameRounding;

        if FrameBorderSize > 0 and FrameRounding > 0 then
            p57.BorderSizePixel = 0;
            local UIStroke = Instance.new("UIStroke");
            UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
            UIStroke.LineJoinMode = Enum.LineJoinMode.Round;
            UIStroke.Transparency = ButtonTransparency;
            UIStroke.Thickness = FrameBorderSize;
            UIStroke.Color = BorderColor;
            u1.UICorner(p57, FrameRounding);
            UIStroke.Parent = p57;

            if not p58 then
                u1.UIPadding(p57, u2._config.FramePadding);
            end;
        elseif FrameBorderSize < 1 and FrameRounding > 0 then
            p57.BorderSizePixel = 0;
            u1.UICorner(p57, FrameRounding);

            if not p58 then
                u1.UIPadding(p57, u2._config.FramePadding);
            end;
        elseif FrameRounding < 1 then
            p57.BorderSizePixel = FrameBorderSize;
            p57.BorderColor3 = BorderColor;
            p57.BorderMode = Enum.BorderMode.Inset;

            if not p58 then
                u1.UIPadding(p57, FramePadding - Vector2.new(FrameBorderSize, FrameBorderSize));

                return;
            end;

            if not p59 then
                u1.UIPadding(p57, -Vector2.new(FrameBorderSize, FrameBorderSize));
            end;
        end;
    end;

    function u1.discardState(p60) -- Line: 350
        for _, v in p60.state do
            v.ConnectedWidgets[p60.ID] = nil;
        end;
    end;

    u1.EVENTS = {
        hover = function(u61) -- Line: 357, Name: hover
            return {
                Init = function(u62) -- Line: 359
                    -- upvalues: u61 (copy)
                    local v63 = u61(u62);
                    v63.MouseEnter:Connect(function() -- Line: 361
                        -- upvalues: u62 (copy)
                        u62.isHoveredEvent = true;
                    end);
                    v63.MouseLeave:Connect(function() -- Line: 364
                        -- upvalues: u62 (copy)
                        u62.isHoveredEvent = false;
                    end);
                    u62.isHoveredEvent = false;
                end,

                Get = function(p64) -- Line: 369
                    return p64.isHoveredEvent;
                end
            };
        end,

        click = function(u65) -- Line: 375, Name: click
            -- upvalues: u2 (copy)
            return {
                Init = function(u66) -- Line: 377
                    -- upvalues: u65 (copy), u2 (ref)
                    local v67 = u65(u66);
                    u66.lastClickedTick = -1;
                    v67.MouseButton1Click:Connect(function() -- Line: 381
                        -- upvalues: u66 (copy), u2 (ref)
                        u66.lastClickedTick = u2._cycleTick + 1;
                    end);
                end,

                Get = function(p68) -- Line: 385
                    -- upvalues: u2 (ref)
                    return p68.lastClickedTick == u2._cycleTick;
                end
            };
        end,

        rightClick = function(u69) -- Line: 391, Name: rightClick
            -- upvalues: u2 (copy)
            return {
                Init = function(u70) -- Line: 393
                    -- upvalues: u69 (copy), u2 (ref)
                    local v71 = u69(u70);
                    u70.lastRightClickedTick = -1;
                    v71.MouseButton2Click:Connect(function() -- Line: 397
                        -- upvalues: u70 (copy), u2 (ref)
                        u70.lastRightClickedTick = u2._cycleTick + 1;
                    end);
                end,

                Get = function(p72) -- Line: 401
                    -- upvalues: u2 (ref)
                    return p72.lastRightClickedTick == u2._cycleTick;
                end
            };
        end,

        doubleClick = function(u73) -- Line: 407, Name: doubleClick
            -- upvalues: u1 (ref), u2 (copy)
            return {
                Init = function(u74) -- Line: 409
                    -- upvalues: u73 (copy), u1 (ref), u2 (ref)
                    local v75 = u73(u74);
                    u74.lastClickedTime = -1;
                    u74.lastClickedPosition = Vector2.zero;
                    u74.lastDoubleClickedTick = -1;
                    v75.MouseButton1Down:Connect(function(p76, p77) -- Line: 415
                        -- upvalues: u1 (ref), u74 (copy), u2 (ref)
                        local v78 = u1.getTime();

                        if v78 - u74.lastClickedTime < u2._config.MouseDoubleClickTime and (Vector2.new(p76, p77) - u74.lastClickedPosition).Magnitude < u2._config.MouseDoubleClickMaxDist then
                            u74.lastDoubleClickedTick = u2._cycleTick + 1;

                            return;
                        end;

                        u74.lastClickedTime = v78;
                        u74.lastClickedPosition = Vector2.new(p76, p77);
                    end);
                end,

                Get = function(p79) -- Line: 426
                    -- upvalues: u2 (ref)
                    return p79.lastDoubleClickedTick == u2._cycleTick;
                end
            };
        end,

        ctrlClick = function(u80) -- Line: 432, Name: ctrlClick
            -- upvalues: u1 (ref), u2 (copy)
            return {
                Init = function(u81) -- Line: 434
                    -- upvalues: u80 (copy), u1 (ref), u2 (ref)
                    local v82 = u80(u81);
                    u81.lastCtrlClickedTick = -1;
                    v82.MouseButton1Click:Connect(function() -- Line: 438
                        -- upvalues: u1 (ref), u81 (copy), u2 (ref)
                        if u1.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or u1.UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
                            u81.lastCtrlClickedTick = u2._cycleTick + 1;
                        end;
                    end);
                end,

                Get = function(p83) -- Line: 444
                    -- upvalues: u2 (ref)
                    return p83.lastCtrlClickedTick == u2._cycleTick;
                end
            };
        end,

        shortcut = function(u84) -- Line: 450, Name: shortcut
            -- upvalues: u1 (ref), u2 (copy)
            return {
                Init = function(u85) -- Line: 452
                    -- upvalues: u84 (copy), u1 (ref), u2 (ref)
                    local v86, u87 = u84(u85);
                    u85.lastShortcutTick = -1;
                    u1.ContextActionService:BindAction(u85.ID, function(p88, p89, p90) -- Line: 456
                        -- upvalues: u87 (copy), u85 (copy), u2 (ref)
                        if p89 == Enum.UserInputState.Begin and p90:IsModifierKeyDown(u87) then
                            u85.lastShortcutTick = u2._cycleTick + 1;
                        end;
                    end, false, v86);
                end,

                Get = function(p91) -- Line: 464
                    -- upvalues: u2 (ref)
                    return p91.lastShortcutTick == u2._cycleTick;
                end
            };
        end
    };
    require(script.Root)(u2, u1);
    require(script.Window)(u2, u1);
    require(script.Menu)(u2, u1);
    require(script.Format)(u2, u1);
    require(script.Text)(u2, u1);
    require(script.Button)(u2, u1);
    require(script.Checkbox)(u2, u1);
    require(script.RadioButton)(u2, u1);
    require(script.Tree)(u2, u1);
    require(script.Input)(u2, u1);
    require(script.Combo)(u2, u1);
    require(script.Table)(u2, u1);
end;