-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(u1, u2) -- Line: 3
    u1.WidgetConstructor("ProgressBar", {
        hasState = true,
        hasChildren = false,
        Args = {
            Text = 1,
            Format = 2
        },
        Events = {
            hovered = u2.EVENTS.hover(function(p3) -- Line: 13
                return p3.Instance;
            end),
            changed = {
                Init = function(p4) -- Line: 17
                end,

                Get = function(p5) -- Line: 18
                    -- upvalues: u1 (copy)
                    return p5.lastChangedTick == u1._cycleTick;
                end
            }
        },

        Generate = function(p6) -- Line: 23, Name: Generate
            -- upvalues: u1 (copy), u2 (copy)
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_ProgressBar";
            Frame.AutomaticSize = Enum.AutomaticSize.Y;
            Frame.Size = UDim2.new(u1._config.ItemWidth, UDim.new());
            Frame.BackgroundTransparency = 1;
            u2.UIListLayout(Frame, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.X)).VerticalAlignment = Enum.VerticalAlignment.Center;
            local Frame2 = Instance.new("Frame");
            Frame2.Name = "Bar";
            Frame2.AutomaticSize = Enum.AutomaticSize.Y;
            Frame2.Size = UDim2.new(u1._config.ContentWidth, u1._config.ContentHeight);
            Frame2.BackgroundColor3 = u1._config.FrameBgColor;
            Frame2.BackgroundTransparency = u1._config.FrameBgTransparency;
            Frame2.BorderSizePixel = 0;
            Frame2.ClipsDescendants = true;
            u2.applyFrameStyle(Frame2, true);
            Frame2.Parent = Frame;
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "Progress";
            TextLabel.AutomaticSize = Enum.AutomaticSize.Y;
            TextLabel.Size = UDim2.new(UDim.new(0, 0), u1._config.ContentHeight);
            TextLabel.BackgroundColor3 = u1._config.PlotHistogramColor;
            TextLabel.BackgroundTransparency = u1._config.PlotHistogramTransparency;
            TextLabel.BorderSizePixel = 0;
            u2.applyTextStyle(TextLabel);
            u2.UIPadding(TextLabel, u1._config.FramePadding);
            u2.UICorner(TextLabel, u1._config.FrameRounding);
            TextLabel.Text = "";
            TextLabel.Parent = Frame2;
            local TextLabel2 = Instance.new("TextLabel");
            TextLabel2.Name = "Value";
            TextLabel2.AutomaticSize = Enum.AutomaticSize.XY;
            TextLabel2.Size = UDim2.new(UDim.new(0, 0), u1._config.ContentHeight);
            TextLabel2.BackgroundTransparency = 1;
            TextLabel2.BorderSizePixel = 0;
            TextLabel2.ZIndex = 1;
            u2.applyTextStyle(TextLabel2);
            u2.UIPadding(TextLabel2, u1._config.FramePadding);
            TextLabel2.Parent = Frame2;
            local TextLabel3 = Instance.new("TextLabel");
            TextLabel3.Name = "TextLabel";
            TextLabel3.AutomaticSize = Enum.AutomaticSize.XY;
            TextLabel3.AnchorPoint = Vector2.new(0, 0.5);
            TextLabel3.BackgroundTransparency = 1;
            TextLabel3.BorderSizePixel = 0;
            TextLabel3.LayoutOrder = 1;
            u2.applyTextStyle(TextLabel3);
            u2.UIPadding(TextLabel2, u1._config.FramePadding);
            TextLabel3.Parent = Frame;

            return Frame;
        end,

        GenerateState = function(p7) -- Line: 88, Name: GenerateState
            -- upvalues: u1 (copy)
            if p7.state.progress == nil then
                p7.state.progress = u1._widgetState(p7, "Progress", 0);
            end;
        end,

        Update = function(p8) -- Line: 93, Name: Update
            local Instance2 = p8.Instance;
            local TextLabel = Instance2.TextLabel;
            local Value = Instance2.Bar.Value;

            if p8.arguments.Format ~= nil and typeof(p8.arguments.Format) == "string" then
                Value.Text = p8.arguments.Format;
            end;

            TextLabel.Text = p8.arguments.Text or "Progress Bar";
        end,

        UpdateState = function(p9) -- Line: 105, Name: UpdateState
            -- upvalues: u1 (copy)
            local Bar = p9.Instance.Bar;
            local Progress = Bar.Progress;
            local Value = Bar.Value;
            local v10 = math.clamp(p9.state.progress.value, 0, 1);

            if Value.AbsoluteSize.X > Bar.AbsoluteSize.X * (1 - v10) then
                Value.AnchorPoint = Vector2.xAxis;
                Value.Position = UDim2.fromScale(1, 0);
            else
                Value.AnchorPoint = Vector2.zero;
                Value.Position = UDim2.fromScale(v10, 0);
            end;

            Progress.Size = UDim2.new(UDim.new(v10, 0), Progress.Size.Height);

            if p9.arguments.Format == nil or typeof(p9.arguments.Format) ~= "string" then
                Value.Text = string.format("%d%%", v10 * 100);
            else
                Value.Text = p9.arguments.Format;
            end;

            p9.lastChangedTick = u1._cycleTick + 1;
        end,

        Discard = function(p11) -- Line: 130, Name: Discard
            -- upvalues: u2 (copy)
            p11.Instance:Destroy();
            u2.discardState(p11);
        end
    });

    local function createLine(p12, p13) -- Line: 136
        -- upvalues: u1 (copy)
        local Frame = Instance.new("Frame");
        Frame.Name = tostring(p13);
        Frame.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame.BackgroundColor3 = u1._config.PlotLinesColor;
        Frame.BackgroundTransparency = u1._config.PlotLinesTransparency;
        Frame.BorderSizePixel = 0;
        Frame.Parent = p12;

        return Frame;
    end;

    local function clearLine(p14) -- Line: 149
        -- upvalues: u1 (copy)
        if p14.HoveredLine then
            p14.HoveredLine.BackgroundColor3 = u1._config.PlotLinesColor;
            p14.HoveredLine.BackgroundTransparency = u1._config.PlotLinesTransparency;
            p14.HoveredLine = false;
            p14.state.hovered:set(nil);
        end;
    end;

    local function updateLine(p15, p16) -- Line: 158
        -- upvalues: u2 (copy), u1 (copy)
        local Plot = p15.Instance.Background.Plot;
        local v17 = u2.getMouseLocation();
        local v18 = math.ceil((v17.X - (Plot.AbsolutePosition - u2.GuiOffset).X) / Plot.AbsoluteSize.X * #p15.Lines);
        local v19 = p15.Lines[v18];

        if v19 then
            if v19 ~= p15.HoveredLine and (not p16 and p15.HoveredLine) then
                p15.HoveredLine.BackgroundColor3 = u1._config.PlotLinesColor;
                p15.HoveredLine.BackgroundTransparency = u1._config.PlotLinesTransparency;
                p15.HoveredLine = false;
                p15.state.hovered:set(nil);
            end;

            local v20 = p15.state.values.value[v18];
            local v21 = p15.state.values.value[v18 + 1];

            if v20 and v21 then
                if math.floor(v20) == v20 and math.floor(v21) == v21 then
                    p15.Tooltip.Text = ("%d: %d\n%d: %d"):format(v18, v20, v18 + 1, v21);
                else
                    p15.Tooltip.Text = ("%d: %.3f\n%d: %.3f"):format(v18, v20, v18 + 1, v21);
                end;
            end;

            p15.HoveredLine = v19;
            v19.BackgroundColor3 = u1._config.PlotLinesHoveredColor;
            v19.BackgroundTransparency = u1._config.PlotLinesHoveredTransparency;

            if p16 then
                p15.state.hovered.value = { v20, v21 };

                return;
            end;

            p15.state.hovered:set({ v20, v21 });
        end;
    end;

    u1.WidgetConstructor("PlotLines", {
        hasState = true,
        hasChildren = false,
        Args = {
            Text = 1,
            Height = 2,
            Min = 3,
            Max = 4,
            TextOverlay = 5
        },
        Events = {
            hovered = u2.EVENTS.hover(function(p22) -- Line: 206
                return p22.Instance;
            end)
        },

        Generate = function(u23) -- Line: 210, Name: Generate
            -- upvalues: u1 (copy), u2 (copy), updateLine (copy)
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_PlotLines";
            Frame.Size = UDim2.new(u1._config.ItemWidth, UDim.new());
            Frame.BackgroundTransparency = 1;
            Frame.BorderSizePixel = 0;
            u2.UIListLayout(Frame, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.X)).VerticalAlignment = Enum.VerticalAlignment.Center;
            local Frame2 = Instance.new("Frame");
            Frame2.Name = "Background";
            Frame2.Size = UDim2.new(u1._config.ContentWidth, UDim.new(1, 0));
            Frame2.BackgroundColor3 = u1._config.FrameBgColor;
            Frame2.BackgroundTransparency = u1._config.FrameBgTransparency;
            u2.applyFrameStyle(Frame2);
            Frame2.Parent = Frame;
            local Frame3 = Instance.new("Frame");
            Frame3.Name = "Plot";
            Frame3.Size = UDim2.fromScale(1, 1);
            Frame3.BackgroundTransparency = 1;
            Frame3.BorderSizePixel = 0;
            Frame3.ClipsDescendants = true;
            Frame3:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- Line: 235
                -- upvalues: u23 (copy), u1 (ref)
                u23.state.values.lastChangeTick = u1._cycleTick;
                u1._widgets.PlotLines.UpdateState(u23);
            end);
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "OverlayText";
            TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
            TextLabel.AnchorPoint = Vector2.new(0.5, 0);
            TextLabel.Size = UDim2.fromOffset(0, 0);
            TextLabel.Position = UDim2.fromScale(0.5, 0);
            TextLabel.BackgroundTransparency = 1;
            TextLabel.BorderSizePixel = 0;
            TextLabel.ZIndex = 2;
            u2.applyTextStyle(TextLabel);
            TextLabel.Parent = Frame3;
            local TextLabel2 = Instance.new("TextLabel");
            TextLabel2.Name = "Iris_Tooltip";
            TextLabel2.AutomaticSize = Enum.AutomaticSize.XY;
            TextLabel2.Size = UDim2.fromOffset(0, 0);
            TextLabel2.BackgroundColor3 = u1._config.PopupBgColor;
            TextLabel2.BackgroundTransparency = u1._config.PopupBgTransparency;
            TextLabel2.BorderSizePixel = 0;
            TextLabel2.Visible = false;
            u2.applyTextStyle(TextLabel2);
            u2.UIStroke(TextLabel2, u1._config.PopupBorderSize, u1._config.BorderActiveColor, u1._config.BorderActiveTransparency);
            u2.UIPadding(TextLabel2, u1._config.WindowPadding);

            if u1._config.PopupRounding > 0 then
                u2.UICorner(TextLabel2, u1._config.PopupRounding);
            end;

            local v24 = u1._rootInstance and u1._rootInstance:FindFirstChild("PopupScreenGui");

            if v24 then
                v24 = v24:FindFirstChild("TooltipContainer");
            end;

            TextLabel2.Parent = v24;
            u23.Tooltip = TextLabel2;
            u2.applyMouseMoved(Frame3, function() -- Line: 275
                -- upvalues: updateLine (ref), u23 (copy)
                updateLine(u23);
            end);
            u2.applyMouseLeave(Frame3, function() -- Line: 279
                -- upvalues: u23 (copy), u1 (ref)
                local v25 = u23;

                if v25.HoveredLine then
                    v25.HoveredLine.BackgroundColor3 = u1._config.PlotLinesColor;
                    v25.HoveredLine.BackgroundTransparency = u1._config.PlotLinesTransparency;
                    v25.HoveredLine = false;
                    v25.state.hovered:set(nil);
                end;
            end);
            Frame3.Parent = Frame2;
            u23.Lines = {};
            u23.HoveredLine = false;
            local TextLabel3 = Instance.new("TextLabel");
            TextLabel3.Name = "TextLabel";
            TextLabel3.AutomaticSize = Enum.AutomaticSize.XY;
            TextLabel3.Size = UDim2.fromOffset(0, 0);
            TextLabel3.BackgroundTransparency = 1;
            TextLabel3.BorderSizePixel = 0;
            TextLabel3.ZIndex = 3;
            TextLabel3.LayoutOrder = 3;
            u2.applyTextStyle(TextLabel3);
            TextLabel3.Parent = Frame;

            return Frame;
        end,

        GenerateState = function(p26) -- Line: 303, Name: GenerateState
            -- upvalues: u1 (copy)
            if p26.state.values == nil then
                p26.state.values = u1._widgetState(p26, "values", { 0, 1 });
            end;

            if p26.state.hovered == nil then
                p26.state.hovered = u1._widgetState(p26, "hovered", nil);
            end;
        end,

        Update = function(p27) -- Line: 311, Name: Update
            local Instance2 = p27.Instance;
            local OverlayText = Instance2.Background.Plot.OverlayText;
            Instance2.TextLabel.Text = p27.arguments.Text or "Plot Lines";
            OverlayText.Text = p27.arguments.TextOverlay or "";
            Instance2.Size = UDim2.new(1, 0, 0, p27.arguments.Height or 0);
        end,

        UpdateState = function(p28) -- Line: 322, Name: UpdateState
            -- upvalues: u1 (copy), updateLine (copy)
            if p28.state.hovered.lastChangeTick == u1._cycleTick then
                if p28.state.hovered.value then
                    p28.Tooltip.Visible = true;
                else
                    p28.Tooltip.Visible = false;
                end;
            end;

            if p28.state.values.lastChangeTick == u1._cycleTick then
                local Plot = p28.Instance.Background.Plot;
                local value = p28.state.values.value;
                local v29 = #value - 1;
                local v30 = #p28.Lines;
                local v31 = p28.arguments.Min or (1 / 0);
                local v32 = p28.arguments.Max or (-1 / 0);

                if v31 == nil or v32 == nil then
                    for _, v in value do
                        v31 = math.min(v31, v);
                        v32 = math.max(v32, v);
                    end;
                end;

                if v30 < v29 then
                    for i = v30 + 1, v29 do
                        local Lines = p28.Lines;
                        local Frame = Instance.new("Frame");
                        Frame.Name = tostring(i);
                        Frame.AnchorPoint = Vector2.new(0.5, 0.5);
                        Frame.BackgroundColor3 = u1._config.PlotLinesColor;
                        Frame.BackgroundTransparency = u1._config.PlotLinesTransparency;
                        Frame.BorderSizePixel = 0;
                        Frame.Parent = Plot;
                        table.insert(Lines, Frame);
                    end;
                elseif v29 < v30 then
                    for _ = v29 + 1, v30 do
                        local v33 = table.remove(p28.Lines);

                        if v33 then
                            v33:Destroy();
                        end;
                    end;
                end;

                local v34 = v32 - v31;
                local AbsoluteSize = Plot.AbsoluteSize;

                for i = 1, v29 do
                    local v35 = value[i + 1];
                    local v36 = AbsoluteSize * Vector2.new((i - 1) / v29, (v32 - value[i]) / v34);
                    local v37 = AbsoluteSize * Vector2.new(i / v29, (v32 - v35) / v34);
                    local v38 = (v36 + v37) / 2;
                    p28.Lines[i].Size = UDim2.fromOffset((v37 - v36).Magnitude + 1, 1);
                    p28.Lines[i].Position = UDim2.fromOffset(v38.X, v38.Y);
                    p28.Lines[i].Rotation = math.atan2(v37.Y - v36.Y, v37.X - v36.X) * 57.29577951308232;
                end;

                if p28.HoveredLine then
                    updateLine(p28, true);
                end;
            end;
        end,

        Discard = function(p39) -- Line: 385, Name: Discard
            -- upvalues: u2 (copy)
            p39.Instance:Destroy();
            p39.Tooltip:Destroy();
            u2.discardState(p39);
        end
    });

    local function createBlock(p40, p41) -- Line: 392
        -- upvalues: u1 (copy)
        local Frame = Instance.new("Frame");
        Frame.Name = tostring(p41);
        Frame.BackgroundColor3 = u1._config.PlotHistogramColor;
        Frame.BackgroundTransparency = u1._config.PlotHistogramTransparency;
        Frame.BorderSizePixel = 0;
        Frame.Parent = p40;

        return Frame;
    end;

    local function clearBlock(p42) -- Line: 404
        -- upvalues: u1 (copy)
        if p42.HoveredBlock then
            p42.HoveredBlock.BackgroundColor3 = u1._config.PlotHistogramColor;
            p42.HoveredBlock.BackgroundTransparency = u1._config.PlotHistogramTransparency;
            p42.HoveredBlock = false;
            p42.state.hovered:set(nil);
        end;
    end;

    local function updateBlock(p43, p44) -- Line: 413
        -- upvalues: u2 (copy), u1 (copy)
        local Plot = p43.Instance.Background.Plot;
        local v45 = u2.getMouseLocation();
        local v46 = math.ceil((v45.X - (Plot.AbsolutePosition - u2.GuiOffset).X) / Plot.AbsoluteSize.X * #p43.Blocks);
        local v47 = p43.Blocks[v46];

        if v47 then
            if v47 ~= p43.HoveredBlock and (not p44 and p43.HoveredBlock) then
                p43.HoveredBlock.BackgroundColor3 = u1._config.PlotHistogramColor;
                p43.HoveredBlock.BackgroundTransparency = u1._config.PlotHistogramTransparency;
                p43.HoveredBlock = false;
                p43.state.hovered:set(nil);
            end;

            local v48 = p43.state.values.value[v46];

            if v48 then
                local Tooltip = p43.Tooltip;
                local v49;

                if math.floor(v48) == v48 then
                    v49 = ("%d: %d"):format(v46, v48);
                else
                    v49 = ("%d: %.3f"):format(v46, v48);
                end;

                Tooltip.Text = v49;
            end;

            p43.HoveredBlock = v47;
            v47.BackgroundColor3 = u1._config.PlotHistogramHoveredColor;
            v47.BackgroundTransparency = u1._config.PlotHistogramHoveredTransparency;

            if p44 then
                p43.state.hovered.value = v48;

                return;
            end;

            p43.state.hovered:set(v48);
        end;
    end;

    u1.WidgetConstructor("PlotHistogram", {
        hasState = true,
        hasChildren = false,
        Args = {
            Text = 1,
            Height = 2,
            Min = 3,
            Max = 4,
            TextOverlay = 5,
            BaseLine = 6
        },
        Events = {
            hovered = u2.EVENTS.hover(function(p50) -- Line: 457
                return p50.Instance;
            end)
        },

        Generate = function(u51) -- Line: 461, Name: Generate
            -- upvalues: u1 (copy), u2 (copy), updateBlock (copy)
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_PlotHistogram";
            Frame.Size = UDim2.new(u1._config.ItemWidth, UDim.new());
            Frame.BackgroundTransparency = 1;
            Frame.BorderSizePixel = 0;
            u2.UIListLayout(Frame, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.X)).VerticalAlignment = Enum.VerticalAlignment.Center;
            local Frame2 = Instance.new("Frame");
            Frame2.Name = "Background";
            Frame2.Size = UDim2.new(u1._config.ContentWidth, UDim.new(1, 0));
            Frame2.BackgroundColor3 = u1._config.FrameBgColor;
            Frame2.BackgroundTransparency = u1._config.FrameBgTransparency;
            u2.applyFrameStyle(Frame2);
            Frame2.UIPadding.PaddingRight = UDim.new(0, u1._config.FramePadding.X - 1);
            Frame2.Parent = Frame;
            local Frame3 = Instance.new("Frame");
            Frame3.Name = "Plot";
            Frame3.Size = UDim2.fromScale(1, 1);
            Frame3.BackgroundTransparency = 1;
            Frame3.BorderSizePixel = 0;
            Frame3.ClipsDescendants = true;
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "OverlayText";
            TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
            TextLabel.AnchorPoint = Vector2.new(0.5, 0);
            TextLabel.Size = UDim2.fromOffset(0, 0);
            TextLabel.Position = UDim2.fromScale(0.5, 0);
            TextLabel.BackgroundTransparency = 1;
            TextLabel.BorderSizePixel = 0;
            TextLabel.ZIndex = 2;
            u2.applyTextStyle(TextLabel);
            TextLabel.Parent = Frame3;
            local TextLabel2 = Instance.new("TextLabel");
            TextLabel2.Name = "Iris_Tooltip";
            TextLabel2.AutomaticSize = Enum.AutomaticSize.XY;
            TextLabel2.Size = UDim2.fromOffset(0, 0);
            TextLabel2.BackgroundColor3 = u1._config.PopupBgColor;
            TextLabel2.BackgroundTransparency = u1._config.PopupBgTransparency;
            TextLabel2.BorderSizePixel = 0;
            TextLabel2.Visible = false;
            u2.applyTextStyle(TextLabel2);
            u2.UIStroke(TextLabel2, u1._config.PopupBorderSize, u1._config.BorderActiveColor, u1._config.BorderActiveTransparency);
            u2.UIPadding(TextLabel2, u1._config.WindowPadding);

            if u1._config.PopupRounding > 0 then
                u2.UICorner(TextLabel2, u1._config.PopupRounding);
            end;

            local v52 = u1._rootInstance and u1._rootInstance:FindFirstChild("PopupScreenGui");

            if v52 then
                v52 = v52:FindFirstChild("TooltipContainer");
            end;

            TextLabel2.Parent = v52;
            u51.Tooltip = TextLabel2;
            u2.applyMouseMoved(Frame3, function() -- Line: 524
                -- upvalues: updateBlock (ref), u51 (copy)
                updateBlock(u51);
            end);
            u2.applyMouseLeave(Frame3, function() -- Line: 528
                -- upvalues: u51 (copy), u1 (ref)
                local v53 = u51;

                if v53.HoveredBlock then
                    v53.HoveredBlock.BackgroundColor3 = u1._config.PlotHistogramColor;
                    v53.HoveredBlock.BackgroundTransparency = u1._config.PlotHistogramTransparency;
                    v53.HoveredBlock = false;
                    v53.state.hovered:set(nil);
                end;
            end);
            Frame3.Parent = Frame2;
            u51.Blocks = {};
            u51.HoveredBlock = false;
            local TextLabel3 = Instance.new("TextLabel");
            TextLabel3.Name = "TextLabel";
            TextLabel3.AutomaticSize = Enum.AutomaticSize.XY;
            TextLabel3.Size = UDim2.fromOffset(0, 0);
            TextLabel3.BackgroundTransparency = 1;
            TextLabel3.BorderSizePixel = 0;
            TextLabel3.ZIndex = 3;
            TextLabel3.LayoutOrder = 3;
            u2.applyTextStyle(TextLabel3);
            TextLabel3.Parent = Frame;

            return Frame;
        end,

        GenerateState = function(p54) -- Line: 552, Name: GenerateState
            -- upvalues: u1 (copy)
            if p54.state.values == nil then
                p54.state.values = u1._widgetState(p54, "values", { 1 });
            end;

            if p54.state.hovered == nil then
                p54.state.hovered = u1._widgetState(p54, "hovered", nil);
            end;
        end,

        Update = function(p55) -- Line: 560, Name: Update
            local Instance2 = p55.Instance;
            local OverlayText = Instance2.Background.Plot.OverlayText;
            Instance2.TextLabel.Text = p55.arguments.Text or "Plot Histogram";
            OverlayText.Text = p55.arguments.TextOverlay or "";
            Instance2.Size = UDim2.new(1, 0, 0, p55.arguments.Height or 0);
        end,

        UpdateState = function(p56) -- Line: 571, Name: UpdateState
            -- upvalues: u1 (copy), updateBlock (copy)
            if p56.state.hovered.lastChangeTick == u1._cycleTick then
                if p56.state.hovered.value then
                    p56.Tooltip.Visible = true;
                else
                    p56.Tooltip.Visible = false;
                end;
            end;

            if p56.state.values.lastChangeTick == u1._cycleTick then
                local Plot = p56.Instance.Background.Plot;
                local value = p56.state.values.value;
                local v57 = #value;
                local v58 = #p56.Blocks;
                local v59 = p56.arguments.Min or (1 / 0);
                local v60 = p56.arguments.Max or (-1 / 0);
                local v61 = p56.arguments.BaseLine or 0;

                if v59 == nil or v60 == nil then
                    for _, v in value do
                        v59 = math.min(v59 or v, v);
                        v60 = math.max(v60 or v, v);
                    end;
                end;

                if v58 < v57 then
                    for i = v58 + 1, v57 do
                        local Blocks = p56.Blocks;
                        local Frame = Instance.new("Frame");
                        Frame.Name = tostring(i);
                        Frame.BackgroundColor3 = u1._config.PlotHistogramColor;
                        Frame.BackgroundTransparency = u1._config.PlotHistogramTransparency;
                        Frame.BorderSizePixel = 0;
                        Frame.Parent = Plot;
                        table.insert(Blocks, Frame);
                    end;
                elseif v57 < v58 then
                    for _ = v57 + 1, v58 do
                        local v62 = table.remove(p56.Blocks);

                        if v62 then
                            v62:Destroy();
                        end;
                    end;
                end;

                local v63 = v60 - v59;
                local v64 = UDim.new(1 / v57, -1);

                for i = 1, v57 do
                    local v65 = value[i];

                    if v65 >= 0 then
                        p56.Blocks[i].Size = UDim2.new(v64, UDim.new((v65 - v61) / v63));
                        p56.Blocks[i].Position = UDim2.fromScale((i - 1) / v57, (v60 - v65) / v63);
                    else
                        p56.Blocks[i].Size = UDim2.new(v64, UDim.new((v61 - v65) / v63));
                        p56.Blocks[i].Position = UDim2.fromScale((i - 1) / v57, (v60 - v61) / v63);
                    end;
                end;

                if p56.HoveredBlock then
                    updateBlock(p56, true);
                end;
            end;
        end,

        Discard = function(p66) -- Line: 633, Name: Discard
            -- upvalues: u2 (copy)
            p66.Instance:Destroy();
            p66.Tooltip:Destroy();
            u2.discardState(p66);
        end
    });
end;