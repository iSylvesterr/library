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
        BLANK_SQUARE = "rbxassetid://83265623867126",
        RIGHT_POINTING_TRIANGLE = "rbxassetid://105541346271951",
        DOWN_POINTING_TRIANGLE = "rbxassetid://95465797476827",
        MULTIPLICATION_SIGN = "rbxassetid://133890060015237",
        BOTTOM_RIGHT_CORNER = "rbxassetid://125737344915000",
        CHECKMARK = "rbxassetid://109638815494221",
        BORDER = "rbxassetid://133803690460269",
        ALPHA_BACKGROUND_TEXTURE = "rbxassetid://114090016039876",
        UNKNOWN_TEXTURE = "rbxassetid://95045813476061"
    };
    u1.IS_STUDIO = u1.RunService:IsStudio();

    function u1.getTime() -- Line: 25
        -- upvalues: u1 (ref)
        if u1.IS_STUDIO then
            return os.clock();
        end;

        return time();
    end;

    local v3;

    if u2._config.IgnoreGuiInset then
        v3 = -u1.GuiService:GetGuiInset();
    else
        v3 = Vector2.zero;
    end;

    u1.GuiOffset = v3;
    local v4;

    if u2._config.IgnoreGuiInset then
        v4 = Vector2.zero;
    else
        v4 = u1.GuiService:GetGuiInset();
    end;

    u1.MouseOffset = v4;
    local u5 = nil;
    u5 = u1.GuiService:GetPropertyChangedSignal("TopbarInset"):Once(function() -- Line: 41
        -- upvalues: u1 (ref), u2 (copy), u5 (ref)
        local v6;

        if u2._config.IgnoreGuiInset then
            v6 = Vector2.zero;
        else
            v6 = u1.GuiService:GetGuiInset();
        end;

        u1.MouseOffset = v6;
        local v7;

        if u2._config.IgnoreGuiInset then
            v7 = -u1.GuiService:GetGuiInset();
        else
            v7 = Vector2.zero;
        end;

        u1.GuiOffset = v7;
        u5:Disconnect();
    end);
    task.delay(5, function() -- Line: 47
        -- upvalues: u5 (ref)
        u5:Disconnect();
    end);

    function u1.getMouseLocation() -- Line: 51
        -- upvalues: u1 (ref)
        return u1.UserInputService:GetMouseLocation() - u1.MouseOffset;
    end;

    function u1.isPosInsideRect(p8, p9, p10) -- Line: 55
        local v11;

        if p8.X >= p9.X and (p8.X <= p10.X and p8.Y >= p9.Y) then
            v11 = p8.Y <= p10.Y;
        else
            v11 = false;
        end;

        return v11;
    end;

    function u1.findBestWindowPosForPopup(p12, p13, p14, p15) -- Line: 59
        local v16;

        if p12.X + p13.X + 20 > p15.X then
            if p12.Y + p13.Y + 20 > p15.Y then
                v16 = p12 + Vector2.new(0, -(20 + p13.Y));
            else
                v16 = p12 + Vector2.new(0, 20);
            end;
        else
            v16 = p12 + Vector2.new(20);
        end;

        local new = Vector2.new;
        local v17 = math.min(v16.X + p13.X, p15.X) - p13.X;
        local v18 = math.max(v17, p14.X);
        local v19 = math.min(v16.Y + p13.Y, p15.Y) - p13.Y;

        return new(v18, (math.max(v19, p14.Y)));
    end;

    function u1.getScreenSizeForWindow(p20) -- Line: 78
        if p20.Instance:IsA("GuiBase2d") then
            return p20.Instance.AbsoluteSize;
        end;

        local Parent = p20.Instance.Parent;

        if Parent:IsA("GuiBase2d") then
            return Parent.AbsoluteSize;
        end;

        if Parent.Parent:IsA("GuiBase2d") then
            return Parent.AbsoluteSize;
        end;

        return workspace.CurrentCamera.ViewportSize;
    end;

    function u1.extend(p21, p22) -- Line: 95
        local v23 = table.clone(p21);

        for i, v in p22 do
            v23[i] = v;
        end;

        return v23;
    end;

    function u1.UIPadding(p24, p25) -- Line: 103
        local UIPadding = Instance.new("UIPadding");
        UIPadding.PaddingLeft = UDim.new(0, p25.X);
        UIPadding.PaddingRight = UDim.new(0, p25.X);
        UIPadding.PaddingTop = UDim.new(0, p25.Y);
        UIPadding.PaddingBottom = UDim.new(0, p25.Y);
        UIPadding.Parent = p24;

        return UIPadding;
    end;

    function u1.UIListLayout(p26, p27, p28) -- Line: 113
        local UIListLayout = Instance.new("UIListLayout");
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
        UIListLayout.Padding = p28;
        UIListLayout.FillDirection = p27;
        UIListLayout.Parent = p26;

        return UIListLayout;
    end;

    function u1.UIStroke(p29, p30, p31, p32) -- Line: 122
        local UIStroke = Instance.new("UIStroke");
        UIStroke.Thickness = p30;
        UIStroke.Color = p31;
        UIStroke.Transparency = p32;
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
        UIStroke.LineJoinMode = Enum.LineJoinMode.Round;
        UIStroke.Parent = p29;

        return UIStroke;
    end;

    function u1.UICorner(p33, p34) -- Line: 133
        local UICorner = Instance.new("UICorner");
        UICorner.CornerRadius = UDim.new(p34 and 0 or 1, p34 or 0);
        UICorner.Parent = p33;

        return UICorner;
    end;

    function u1.UISizeConstraint(p35, p36, p37) -- Line: 140
        local UISizeConstraint = Instance.new("UISizeConstraint");
        UISizeConstraint.MinSize = p36 or UISizeConstraint.MinSize;
        UISizeConstraint.MaxSize = p37 or UISizeConstraint.MaxSize;
        UISizeConstraint.Parent = p35;

        return UISizeConstraint;
    end;

    function u1.applyTextStyle(p38) -- Line: 150
        -- upvalues: u2 (copy)
        p38.FontFace = u2._config.TextFont;
        p38.TextSize = u2._config.TextSize;
        p38.TextColor3 = u2._config.TextColor;
        p38.TextTransparency = u2._config.TextTransparency;
        p38.TextXAlignment = Enum.TextXAlignment.Left;
        p38.TextYAlignment = Enum.TextYAlignment.Center;
        p38.RichText = u2._config.RichText;
        p38.TextWrapped = u2._config.TextWrapped;
        p38.AutoLocalize = false;
    end;

    function u1.applyInteractionHighlights(u39, p40, u41, u42) -- Line: 163
        -- upvalues: u1 (ref), u2 (copy)
        local u43 = false;
        u1.applyMouseEnter(p40, function() -- Line: 165
            -- upvalues: u41 (copy), u39 (copy), u42 (copy), u43 (ref)
            u41[u39 .. "Color3"] = u42.HoveredColor;
            u41[u39 .. "Transparency"] = u42.HoveredTransparency;
            u43 = false;
        end);
        u1.applyMouseLeave(p40, function() -- Line: 172
            -- upvalues: u41 (copy), u39 (copy), u42 (copy), u43 (ref)
            u41[u39 .. "Color3"] = u42.Color;
            u41[u39 .. "Transparency"] = u42.Transparency;
            u43 = true;
        end);
        u1.applyInputBegan(p40, function(p44) -- Line: 179
            -- upvalues: u41 (copy), u39 (copy), u42 (copy)
            if p44.UserInputType ~= Enum.UserInputType.MouseButton1 and p44.UserInputType ~= Enum.UserInputType.Gamepad1 then
                return;
            end;

            u41[u39 .. "Color3"] = u42.ActiveColor;
            u41[u39 .. "Transparency"] = u42.ActiveTransparency;
        end);
        u1.applyInputEnded(p40, function(p45) -- Line: 187
            -- upvalues: u43 (ref), u41 (copy), u39 (copy), u42 (copy)
            if p45.UserInputType ~= Enum.UserInputType.MouseButton1 and p45.UserInputType ~= Enum.UserInputType.Gamepad1 or u43 then
                return;
            end;

            if p45.UserInputType == Enum.UserInputType.MouseButton1 then
                u41[u39 .. "Color3"] = u42.HoveredColor;
                u41[u39 .. "Transparency"] = u42.HoveredTransparency;
            end;

            if p45.UserInputType == Enum.UserInputType.Gamepad1 then
                u41[u39 .. "Color3"] = u42.Color;
                u41[u39 .. "Transparency"] = u42.Transparency;
            end;
        end);
        p40.SelectionImageObject = u2.SelectionImageObject;
    end;

    function u1.applyInteractionHighlightsWithMultiHighlightee(u46, p47, u48) -- Line: 204
        -- upvalues: u1 (ref), u2 (copy)
        local u49 = false;
        u1.applyMouseEnter(p47, function() -- Line: 206
            -- upvalues: u48 (copy), u46 (copy), u49 (ref)
            for _, v in u48 do
                v[1][u46 .. "Color3"] = v[2].HoveredColor;
                v[1][u46 .. "Transparency"] = v[2].HoveredTransparency;
                u49 = false;
            end;
        end);
        u1.applyMouseLeave(p47, function() -- Line: 215
            -- upvalues: u48 (copy), u46 (copy), u49 (ref)
            for _, v in u48 do
                v[1][u46 .. "Color3"] = v[2].Color;
                v[1][u46 .. "Transparency"] = v[2].Transparency;
                u49 = true;
            end;
        end);
        u1.applyInputBegan(p47, function(p50) -- Line: 224
            -- upvalues: u48 (copy), u46 (copy)
            if p50.UserInputType ~= Enum.UserInputType.MouseButton1 and p50.UserInputType ~= Enum.UserInputType.Gamepad1 then
                return;
            end;

            for _, v in u48 do
                v[1][u46 .. "Color3"] = v[2].ActiveColor;
                v[1][u46 .. "Transparency"] = v[2].ActiveTransparency;
            end;
        end);
        u1.applyInputEnded(p47, function(p51) -- Line: 234
            -- upvalues: u49 (ref), u48 (copy), u46 (copy)
            if p51.UserInputType ~= Enum.UserInputType.MouseButton1 and p51.UserInputType ~= Enum.UserInputType.Gamepad1 or u49 then
                return;
            end;

            for _, v in u48 do
                if p51.UserInputType == Enum.UserInputType.MouseButton1 then
                    v[1][u46 .. "Color3"] = v[2].HoveredColor;
                    v[1][u46 .. "Transparency"] = v[2].HoveredTransparency;
                end;

                if p51.UserInputType == Enum.UserInputType.Gamepad1 then
                    v[1][u46 .. "Color3"] = v[2].Color;
                    v[1][u46 .. "Transparency"] = v[2].Transparency;
                end;
            end;
        end);
        p47.SelectionImageObject = u2.SelectionImageObject;
    end;

    function u1.applyFrameStyle(p52, p53, p54) -- Line: 253
        -- upvalues: u2 (copy), u1 (ref)
        local FrameBorderSize = u2._config.FrameBorderSize;
        local FrameRounding = u2._config.FrameRounding;
        p52.BorderSizePixel = 0;

        if FrameBorderSize > 0 then
            u1.UIStroke(p52, FrameBorderSize, u2._config.BorderColor, u2._config.BorderTransparency);
        end;

        if FrameRounding > 0 and not p54 then
            u1.UICorner(p52, FrameRounding);
        end;

        if not p53 then
            u1.UIPadding(p52, u2._config.FramePadding);
        end;
    end;

    function u1.applyButtonClick(p55, u56) -- Line: 271
        p55.MouseButton1Click:Connect(function() -- Line: 272
            -- upvalues: u56 (copy)
            u56();
        end);
    end;

    function u1.applyButtonDown(p57, u58) -- Line: 277
        -- upvalues: u1 (ref)
        p57.MouseButton1Down:Connect(function(p59, p60) -- Line: 278
            -- upvalues: u1 (ref), u58 (copy)
            local v61 = Vector2.new(p59, p60) - u1.MouseOffset;
            u58(v61.X, v61.Y);
        end);
    end;

    function u1.applyMouseEnter(p62, u63) -- Line: 284
        -- upvalues: u1 (ref)
        p62.MouseEnter:Connect(function(p64, p65) -- Line: 285
            -- upvalues: u1 (ref), u63 (copy)
            local v66 = Vector2.new(p64, p65) - u1.MouseOffset;
            u63(v66.X, v66.Y);
        end);
    end;

    function u1.applyMouseMoved(p67, u68) -- Line: 291
        -- upvalues: u1 (ref)
        p67.MouseMoved:Connect(function(p69, p70) -- Line: 292
            -- upvalues: u1 (ref), u68 (copy)
            local v71 = Vector2.new(p69, p70) - u1.MouseOffset;
            u68(v71.X, v71.Y);
        end);
    end;

    function u1.applyMouseLeave(p72, u73) -- Line: 298
        -- upvalues: u1 (ref)
        p72.MouseLeave:Connect(function(p74, p75) -- Line: 299
            -- upvalues: u1 (ref), u73 (copy)
            local v76 = Vector2.new(p74, p75) - u1.MouseOffset;
            u73(v76.X, v76.Y);
        end);
    end;

    function u1.applyInputBegan(p77, u78) -- Line: 305
        p77.InputBegan:Connect(function(...) -- Line: 306
            -- upvalues: u78 (copy)
            u78(...);
        end);
    end;

    function u1.applyInputEnded(p79, u80) -- Line: 311
        p79.InputEnded:Connect(function(...) -- Line: 312
            -- upvalues: u80 (copy)
            u80(...);
        end);
    end;

    function u1.discardState(p81) -- Line: 317
        for _, v in p81.state do
            v.ConnectedWidgets[p81.ID] = nil;
        end;
    end;

    function u1.registerEvent(u82, u83) -- Line: 323
        -- upvalues: u2 (copy), u1 (ref)
        table.insert(u2._initFunctions, function() -- Line: 324
            -- upvalues: u2 (ref), u1 (ref), u82 (copy), u83 (copy)
            table.insert(u2._connections, u1.UserInputService[u82]:Connect(u83));
        end);
    end;

    u1.EVENTS = {
        hover = function(u84) -- Line: 330, Name: hover
            -- upvalues: u1 (ref)
            return {
                Init = function(u85) -- Line: 332
                    -- upvalues: u84 (copy), u1 (ref)
                    local v86 = u84(u85);
                    u1.applyMouseEnter(v86, function() -- Line: 334
                        -- upvalues: u85 (copy)
                        u85.isHoveredEvent = true;
                    end);
                    u1.applyMouseLeave(v86, function() -- Line: 337
                        -- upvalues: u85 (copy)
                        u85.isHoveredEvent = false;
                    end);
                    u85.isHoveredEvent = false;
                end,

                Get = function(p87) -- Line: 342
                    return p87.isHoveredEvent;
                end
            };
        end,

        click = function(u88) -- Line: 348, Name: click
            -- upvalues: u1 (ref), u2 (copy)
            return {
                Init = function(u89) -- Line: 350
                    -- upvalues: u88 (copy), u1 (ref), u2 (ref)
                    local v90 = u88(u89);
                    u89.lastClickedTick = -1;
                    u1.applyButtonClick(v90, function() -- Line: 354
                        -- upvalues: u89 (copy), u2 (ref)
                        u89.lastClickedTick = u2._cycleTick + 1;
                    end);
                end,

                Get = function(p91) -- Line: 358
                    -- upvalues: u2 (ref)
                    return p91.lastClickedTick == u2._cycleTick;
                end
            };
        end,

        rightClick = function(u92) -- Line: 364, Name: rightClick
            -- upvalues: u2 (copy)
            return {
                Init = function(u93) -- Line: 366
                    -- upvalues: u92 (copy), u2 (ref)
                    local v94 = u92(u93);
                    u93.lastRightClickedTick = -1;
                    v94.MouseButton2Click:Connect(function() -- Line: 370
                        -- upvalues: u93 (copy), u2 (ref)
                        u93.lastRightClickedTick = u2._cycleTick + 1;
                    end);
                end,

                Get = function(p95) -- Line: 374
                    -- upvalues: u2 (ref)
                    return p95.lastRightClickedTick == u2._cycleTick;
                end
            };
        end,

        doubleClick = function(u96) -- Line: 380, Name: doubleClick
            -- upvalues: u1 (ref), u2 (copy)
            return {
                Init = function(u97) -- Line: 382
                    -- upvalues: u96 (copy), u1 (ref), u2 (ref)
                    local v98 = u96(u97);
                    u97.lastClickedTime = -1;
                    u97.lastClickedPosition = Vector2.zero;
                    u97.lastDoubleClickedTick = -1;
                    u1.applyButtonDown(v98, function(p99, p100) -- Line: 388
                        -- upvalues: u1 (ref), u97 (copy), u2 (ref)
                        local v101 = u1.getTime();

                        if v101 - u97.lastClickedTime < u2._config.MouseDoubleClickTime and (Vector2.new(p99, p100) - u97.lastClickedPosition).Magnitude < u2._config.MouseDoubleClickMaxDist then
                            u97.lastDoubleClickedTick = u2._cycleTick + 1;

                            return;
                        end;

                        u97.lastClickedTime = v101;
                        u97.lastClickedPosition = Vector2.new(p99, p100);
                    end);
                end,

                Get = function(p102) -- Line: 399
                    -- upvalues: u2 (ref)
                    return p102.lastDoubleClickedTick == u2._cycleTick;
                end
            };
        end,

        ctrlClick = function(u103) -- Line: 405, Name: ctrlClick
            -- upvalues: u1 (ref), u2 (copy)
            return {
                Init = function(u104) -- Line: 407
                    -- upvalues: u103 (copy), u1 (ref), u2 (ref)
                    local v105 = u103(u104);
                    u104.lastCtrlClickedTick = -1;
                    u1.applyButtonClick(v105, function() -- Line: 411
                        -- upvalues: u1 (ref), u104 (copy), u2 (ref)
                        if u1.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or u1.UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
                            u104.lastCtrlClickedTick = u2._cycleTick + 1;
                        end;
                    end);
                end,

                Get = function(p106) -- Line: 417
                    -- upvalues: u2 (ref)
                    return p106.lastCtrlClickedTick == u2._cycleTick;
                end
            };
        end
    };
    u2._utility = u1;
    require(script.Root)(u2, u1);
    require(script.Window)(u2, u1);
    require(script.Menu)(u2, u1);
    require(script.Format)(u2, u1);
    require(script.Text)(u2, u1);
    require(script.Button)(u2, u1);
    require(script.Checkbox)(u2, u1);
    require(script.RadioButton)(u2, u1);
    require(script.Image)(u2, u1);
    require(script.Tree)(u2, u1);
    require(script.Tab)(u2, u1);
    require(script.Input)(u2, u1);
    require(script.Combo)(u2, u1);
    require(script.Plot)(u2, u1);
    require(script.Table)(u2, u1);
end;