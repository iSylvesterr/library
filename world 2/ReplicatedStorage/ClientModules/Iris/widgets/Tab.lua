-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(u1, u2) -- Line: 3
    local function openTab(p3, p4) -- Line: 4
        if p3.state.index.value > 0 then
            return;
        end;

        p3.state.index:set(p4);
    end;

    local function closeTab(p5, p6) -- Line: 12
        if p5.state.index.value ~= p6 then
            return;
        end;

        for i = p6 - 1, 1, -1 do
            if p5.Tabs[i].state.isOpened.value == true then
                p5.state.index:set(i);

                return;
            end;
        end;

        for i = p6, #p5.Tabs do
            if p5.Tabs[i].state.isOpened.value == true then
                p5.state.index:set(i);

                return;
            end;
        end;

        p5.state.index:set(0);
    end;

    u1.WidgetConstructor("TabBar", {
        hasState = true,
        hasChildren = true,
        Args = {},
        Events = {},

        Generate = function(p7) -- Line: 43, Name: Generate
            -- upvalues: u2 (copy), u1 (copy)
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_TabBar";
            Frame.AutomaticSize = Enum.AutomaticSize.Y;
            Frame.Size = UDim2.fromScale(1, 0);
            Frame.BackgroundTransparency = 1;
            Frame.BorderSizePixel = 0;
            u2.UIListLayout(Frame, Enum.FillDirection.Vertical, UDim.new()).VerticalAlignment = Enum.VerticalAlignment.Bottom;
            local Frame2 = Instance.new("Frame");
            Frame2.Name = "Bar";
            Frame2.AutomaticSize = Enum.AutomaticSize.Y;
            Frame2.Size = UDim2.fromScale(1, 0);
            Frame2.BackgroundTransparency = 1;
            Frame2.BorderSizePixel = 0;
            u2.UIListLayout(Frame2, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.X));
            Frame2.Parent = Frame;
            local Frame3 = Instance.new("Frame");
            Frame3.Name = "Underline";
            Frame3.Size = UDim2.new(1, 0, 0, 1);
            Frame3.BackgroundColor3 = u1._config.TabActiveColor;
            Frame3.BackgroundTransparency = u1._config.TabActiveTransparency;
            Frame3.BorderSizePixel = 0;
            Frame3.LayoutOrder = 1;
            Frame3.Parent = Frame;
            local Frame4 = Instance.new("Frame");
            Frame4.Name = "TabContainer";
            Frame4.AutomaticSize = Enum.AutomaticSize.Y;
            Frame4.Size = UDim2.fromScale(1, 0);
            Frame4.BackgroundTransparency = 1;
            Frame4.BorderSizePixel = 0;
            Frame4.LayoutOrder = 2;
            Frame4.ClipsDescendants = true;
            Frame4.Parent = Frame;
            p7.ChildContainer = Frame4;
            p7.Tabs = {};

            return Frame;
        end,

        Update = function(p8) -- Line: 90, Name: Update
        end,

        ChildAdded = function(p9, p10) -- Line: 91, Name: ChildAdded
            assert(p10.type == "Tab", "Only Iris.Tab can be parented to Iris.TabBar.");
            local Instance2 = p9.Instance;
            p10.ChildContainer.Parent = p9.ChildContainer;
            p10.Index = #p9.Tabs + 1;
            p9.state.index.ConnectedWidgets[p10.ID] = p10;
            table.insert(p9.Tabs, p10);

            return Instance2.Bar;
        end,

        ChildDiscarded = function(p11, p12) -- Line: 101, Name: ChildDiscarded
            -- upvalues: closeTab (copy)
            local Index = p12.Index;
            table.remove(p11.Tabs, Index);

            for i = Index, #p11.Tabs do
                p11.Tabs[i].Index = i;
            end;

            closeTab(p11, Index);
        end,

        GenerateState = function(p13) -- Line: 111, Name: GenerateState
            -- upvalues: u1 (copy)
            if p13.state.index == nil then
                p13.state.index = u1._widgetState(p13, "index", 1);
            end;
        end,

        UpdateState = function(p14) -- Line: 116, Name: UpdateState
        end,

        Discard = function(p15) -- Line: 118, Name: Discard
            p15.Instance:Destroy();
        end
    });
    u1.WidgetConstructor("Tab", {
        hasState = true,
        hasChildren = true,
        Args = {
            Text = 1,
            Hideable = 2
        },
        Events = {
            clicked = u2.EVENTS.click(function(p16) -- Line: 132
                return p16.Instance;
            end),
            hovered = u2.EVENTS.hover(function(p17) -- Line: 135
                return p17.Instance;
            end),
            selected = {
                Init = function(p18) -- Line: 139
                end,

                Get = function(p19) -- Line: 140
                    -- upvalues: u1 (copy)
                    return p19.lastSelectedTick == u1._cycleTick;
                end
            },
            unselected = {
                Init = function(p20) -- Line: 145
                end,

                Get = function(p21) -- Line: 146
                    -- upvalues: u1 (copy)
                    return p21.lastUnselectedTick == u1._cycleTick;
                end
            },
            active = {
                Init = function(p22) -- Line: 151
                end,

                Get = function(p23) -- Line: 152
                    return p23.state.index.value == p23.Index;
                end
            },
            opened = {
                Init = function(p24) -- Line: 157
                end,

                Get = function(p25) -- Line: 158
                    -- upvalues: u1 (copy)
                    return p25.lastOpenedTick == u1._cycleTick;
                end
            },
            closed = {
                Init = function(p26) -- Line: 163
                end,

                Get = function(p27) -- Line: 164
                    -- upvalues: u1 (copy)
                    return p27.lastClosedTick == u1._cycleTick;
                end
            }
        },

        Generate = function(u28) -- Line: 169, Name: Generate
            -- upvalues: u1 (copy), u2 (copy), closeTab (copy)
            local TextButton = Instance.new("TextButton");
            TextButton.Name = "Iris_Tab";
            TextButton.AutomaticSize = Enum.AutomaticSize.XY;
            TextButton.BackgroundColor3 = u1._config.TabColor;
            TextButton.BackgroundTransparency = u1._config.TabTransparency;
            TextButton.BorderSizePixel = 0;
            TextButton.Text = "";
            TextButton.AutoButtonColor = false;
            u28.ButtonColors = {
                Color = u1._config.TabColor,
                Transparency = u1._config.TabTransparency,
                HoveredColor = u1._config.TabHoveredColor,
                HoveredTransparency = u1._config.TabHoveredTransparency,
                ActiveColor = u1._config.TabActiveColor,
                ActiveTransparency = u1._config.TabActiveTransparency
            };
            u2.UIPadding(TextButton, Vector2.new(u1._config.FramePadding.X, 0));
            u2.applyFrameStyle(TextButton, true, true);
            u2.UIListLayout(TextButton, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.X)).VerticalAlignment = Enum.VerticalAlignment.Center;
            u2.applyInteractionHighlights("Background", TextButton, TextButton, u28.ButtonColors);
            u2.applyButtonClick(TextButton, function() -- Line: 192
                -- upvalues: u28 (copy)
                u28.state.index:set(u28.Index);
            end);
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "TextLabel";
            TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
            TextLabel.BackgroundTransparency = 1;
            TextLabel.BorderSizePixel = 0;
            u2.applyTextStyle(TextLabel);
            u2.UIPadding(TextLabel, Vector2.new(0, u1._config.FramePadding.Y));
            TextLabel.Parent = TextButton;
            local v29 = u1._config.TextSize + (u1._config.FramePadding.Y - 1) * 2;
            local TextButton2 = Instance.new("TextButton");
            TextButton2.Name = "CloseButton";
            TextButton2.Size = UDim2.fromOffset(v29, v29);
            TextButton2.BackgroundTransparency = 1;
            TextButton2.BorderSizePixel = 0;
            TextButton2.Text = "";
            TextButton2.AutoButtonColor = false;
            TextButton2.LayoutOrder = 1;
            u2.UICorner(TextButton2);
            u2.applyButtonClick(TextButton2, function() -- Line: 219
                -- upvalues: u28 (copy), closeTab (ref)
                u28.state.isOpened:set(false);
                closeTab(u28.parentWidget, u28.Index);
            end);
            u2.applyInteractionHighlights("Background", TextButton2, TextButton2, {
                Transparency = 1,
                Color = u1._config.TabColor,
                HoveredColor = u1._config.ButtonHoveredColor,
                HoveredTransparency = u1._config.ButtonHoveredTransparency,
                ActiveColor = u1._config.ButtonActiveColor,
                ActiveTransparency = u1._config.ButtonActiveTransparency
            });
            TextButton2.Parent = TextButton;
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.Name = "Icon";
            ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
            ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
            ImageLabel.Size = UDim2.fromOffset(math.floor(0.7 * v29), (math.floor(0.7 * v29)));
            ImageLabel.BackgroundTransparency = 1;
            ImageLabel.BorderSizePixel = 0;
            ImageLabel.Image = u2.ICONS.MULTIPLICATION_SIGN;
            ImageLabel.ImageTransparency = 1;
            u2.applyInteractionHighlights("Image", TextButton, ImageLabel, {
                Transparency = 1,
                Color = u1._config.TextColor,
                HoveredColor = u1._config.TextColor,
                HoveredTransparency = u1._config.TextTransparency,
                ActiveColor = u1._config.TextColor,
                ActiveTransparency = u1._config.TextTransparency
            });
            ImageLabel.Parent = TextButton2;
            local Frame = Instance.new("Frame");
            Frame.Name = "TabContainer";
            Frame.AutomaticSize = Enum.AutomaticSize.Y;
            Frame.Size = UDim2.fromScale(1, 0);
            Frame.BackgroundTransparency = 1;
            Frame.BorderSizePixel = 0;
            Frame.ClipsDescendants = true;
            u2.UIListLayout(Frame, Enum.FillDirection.Vertical, UDim.new(0, u1._config.ItemSpacing.Y));
            u2.UIPadding(Frame, Vector2.new(0, u1._config.ItemSpacing.Y)).PaddingBottom = UDim.new();
            u28.ChildContainer = Frame;

            return TextButton;
        end,

        Update = function(p30) -- Line: 270, Name: Update
            local Instance2 = p30.Instance;
            local CloseButton = Instance2.CloseButton;
            Instance2.TextLabel.Text = p30.arguments.Text;
            CloseButton.Visible = p30.arguments.Hideable == true;
        end,

        ChildAdded = function(p31, p32) -- Line: 278, Name: ChildAdded
            return p31.ChildContainer;
        end,

        GenerateState = function(p33) -- Line: 281, Name: GenerateState
            -- upvalues: u1 (copy)
            p33.state.index = p33.parentWidget.state.index;
            p33.state.index.ConnectedWidgets[p33.ID] = p33;

            if p33.state.isOpened == nil then
                p33.state.isOpened = u1._widgetState(p33, "isOpened", true);
            end;
        end,

        UpdateState = function(p34) -- Line: 289, Name: UpdateState
            -- upvalues: u1 (copy), closeTab (copy)
            local Instance2 = p34.Instance;
            local ChildContainer = p34.ChildContainer;

            if p34.state.isOpened.lastChangeTick == u1._cycleTick then
                if p34.state.isOpened.value == true then
                    p34.lastOpenedTick = u1._cycleTick + 1;
                    local parentWidget = p34.parentWidget;
                    local Index = p34.Index;

                    if parentWidget.state.index.value <= 0 then
                        parentWidget.state.index:set(Index);
                    end;

                    Instance2.Visible = true;
                else
                    p34.lastClosedTick = u1._cycleTick + 1;
                    closeTab(p34.parentWidget, p34.Index);
                    Instance2.Visible = false;
                end;
            end;

            if p34.state.index.lastChangeTick == u1._cycleTick then
                if p34.state.index.value == p34.Index then
                    p34.ButtonColors.Color = u1._config.TabActiveColor;
                    p34.ButtonColors.Transparency = u1._config.TabActiveTransparency;
                    Instance2.BackgroundColor3 = u1._config.TabActiveColor;
                    Instance2.BackgroundTransparency = u1._config.TabActiveTransparency;
                    ChildContainer.Visible = true;
                    p34.lastSelectedTick = u1._cycleTick + 1;

                    return;
                end;

                p34.ButtonColors.Color = u1._config.TabColor;
                p34.ButtonColors.Transparency = u1._config.TabTransparency;
                Instance2.BackgroundColor3 = u1._config.TabColor;
                Instance2.BackgroundTransparency = u1._config.TabTransparency;
                ChildContainer.Visible = false;
                p34.lastUnselectedTick = u1._cycleTick + 1;
            end;
        end,

        Discard = function(p35) -- Line: 323, Name: Discard
            -- upvalues: closeTab (copy), u2 (copy)
            if p35.state.isOpened.value == true then
                closeTab(p35.parentWidget, p35.Index);
            end;

            p35.Instance:Destroy();
            p35.ChildContainer:Destroy();
            u2.discardState(p35);
        end
    });
end;