-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(u1, u2) -- Line: 3
    local v13 = {
        hasState = true,
        hasChildren = true,
        Events = {
            collapsed = {
                Init = function(p3) -- Line: 9
                end,

                Get = function(p4) -- Line: 10
                    -- upvalues: u1 (copy)
                    return p4.lastCollapsedTick == u1._cycleTick;
                end
            },
            uncollapsed = {
                Init = function(p5) -- Line: 15
                end,

                Get = function(p6) -- Line: 16
                    -- upvalues: u1 (copy)
                    return p6.lastUncollapsedTick == u1._cycleTick;
                end
            },
            hovered = u2.EVENTS.hover(function(p7) -- Line: 20
                return p7.Instance;
            end)
        },

        Discard = function(p8) -- Line: 24, Name: Discard
            -- upvalues: u2 (copy)
            p8.Instance:Destroy();
            u2.discardState(p8);
        end,

        ChildAdded = function(p9, p10) -- Line: 28, Name: ChildAdded
            local ChildContainer = p9.ChildContainer;
            ChildContainer.Visible = p9.state.isUncollapsed.value;

            return ChildContainer;
        end,

        UpdateState = function(p11) -- Line: 35, Name: UpdateState
            -- upvalues: u2 (copy), u1 (copy)
            local value = p11.state.isUncollapsed.value;
            local ChildContainer = p11.ChildContainer;
            p11.Instance.Header.Button.Arrow.Image = value and u2.ICONS.DOWN_POINTING_TRIANGLE or u2.ICONS.RIGHT_POINTING_TRIANGLE;

            if value then
                p11.lastUncollapsedTick = u1._cycleTick + 1;
            else
                p11.lastCollapsedTick = u1._cycleTick + 1;
            end;

            ChildContainer.Visible = value;
        end,

        GenerateState = function(p12) -- Line: 52, Name: GenerateState
            -- upvalues: u1 (copy)
            if p12.state.isUncollapsed == nil then
                p12.state.isUncollapsed = u1._widgetState(p12, "isUncollapsed", p12.arguments.DefaultOpen or false);
            end;
        end
    };
    u1.WidgetConstructor("Tree", u2.extend(v13, {
        Args = {
            Text = 1,
            SpanAvailWidth = 2,
            NoIndent = 3,
            DefaultOpen = 4
        },

        Generate = function(u14) -- Line: 69, Name: Generate
            -- upvalues: u1 (copy), u2 (copy)
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_Tree";
            Frame.AutomaticSize = Enum.AutomaticSize.Y;
            Frame.Size = UDim2.new(u1._config.ItemWidth, UDim.new(0, 0));
            Frame.BackgroundTransparency = 1;
            Frame.BorderSizePixel = 0;
            u2.UIListLayout(Frame, Enum.FillDirection.Vertical, UDim.new(0, 0));
            local Frame2 = Instance.new("Frame");
            Frame2.Name = "TreeContainer";
            Frame2.AutomaticSize = Enum.AutomaticSize.Y;
            Frame2.Size = UDim2.fromScale(1, 0);
            Frame2.BackgroundTransparency = 1;
            Frame2.BorderSizePixel = 0;
            Frame2.LayoutOrder = 1;
            Frame2.Visible = false;
            u2.UIListLayout(Frame2, Enum.FillDirection.Vertical, UDim.new(0, u1._config.ItemSpacing.Y));
            u2.UIPadding(Frame2, Vector2.zero).PaddingTop = UDim.new(0, u1._config.ItemSpacing.Y);
            Frame2.Parent = Frame;
            local Frame3 = Instance.new("Frame");
            Frame3.Name = "Header";
            Frame3.AutomaticSize = Enum.AutomaticSize.Y;
            Frame3.Size = UDim2.fromScale(1, 0);
            Frame3.BackgroundTransparency = 1;
            Frame3.BorderSizePixel = 0;
            Frame3.Parent = Frame;
            local TextButton = Instance.new("TextButton");
            TextButton.Name = "Button";
            TextButton.BackgroundTransparency = 1;
            TextButton.BorderSizePixel = 0;
            TextButton.Text = "";
            TextButton.AutoButtonColor = false;
            u2.applyInteractionHighlights("Background", TextButton, Frame3, {
                Transparency = 1,
                Color = Color3.fromRGB(0, 0, 0),
                HoveredColor = u1._config.HeaderHoveredColor,
                HoveredTransparency = u1._config.HeaderHoveredTransparency,
                ActiveColor = u1._config.HeaderActiveColor,
                ActiveTransparency = u1._config.HeaderActiveTransparency
            });
            u2.UIPadding(TextButton, Vector2.zero).PaddingLeft = UDim.new(0, u1._config.FramePadding.X);
            u2.UIListLayout(TextButton, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.FramePadding.X)).VerticalAlignment = Enum.VerticalAlignment.Center;
            TextButton.Parent = Frame3;
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.Name = "Arrow";
            ImageLabel.Size = UDim2.fromOffset(u1._config.TextSize, (math.floor(u1._config.TextSize * 0.7)));
            ImageLabel.BackgroundTransparency = 1;
            ImageLabel.BorderSizePixel = 0;
            ImageLabel.ImageColor3 = u1._config.TextColor;
            ImageLabel.ImageTransparency = u1._config.TextTransparency;
            ImageLabel.ScaleType = Enum.ScaleType.Fit;
            ImageLabel.Parent = TextButton;
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "TextLabel";
            TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
            TextLabel.Size = UDim2.fromOffset(0, 0);
            TextLabel.BackgroundTransparency = 1;
            TextLabel.BorderSizePixel = 0;
            u2.UIPadding(TextLabel, Vector2.zero).PaddingRight = UDim.new(0, 21);
            u2.applyTextStyle(TextLabel);
            TextLabel.Parent = TextButton;
            u2.applyButtonClick(TextButton, function() -- Line: 146
                -- upvalues: u14 (copy)
                u14.state.isUncollapsed:set(not u14.state.isUncollapsed.value);
            end);
            u14.ChildContainer = Frame2;

            return Frame;
        end,

        Update = function(p15) -- Line: 153, Name: Update
            -- upvalues: u1 (copy)
            local Button = p15.Instance.Header.Button;
            local UIPadding = p15.ChildContainer.UIPadding;
            Button.TextLabel.Text = p15.arguments.Text or "Tree";

            if p15.arguments.SpanAvailWidth then
                Button.AutomaticSize = Enum.AutomaticSize.Y;
                Button.Size = UDim2.fromScale(1, 0);
            else
                Button.AutomaticSize = Enum.AutomaticSize.XY;
                Button.Size = UDim2.fromScale(0, 0);
            end;

            if p15.arguments.NoIndent then
                UIPadding.PaddingLeft = UDim.new(0, 0);

                return;
            end;

            UIPadding.PaddingLeft = UDim.new(0, u1._config.IndentSpacing);
        end
    }));
    u1.WidgetConstructor("CollapsingHeader", u2.extend(v13, {
        Args = {
            Text = 1,
            DefaultOpen = 2
        },

        Generate = function(u16) -- Line: 187, Name: Generate
            -- upvalues: u1 (copy), u2 (copy)
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_CollapsingHeader";
            Frame.AutomaticSize = Enum.AutomaticSize.Y;
            Frame.Size = UDim2.new(u1._config.ItemWidth, UDim.new(0, 0));
            Frame.BackgroundTransparency = 1;
            Frame.BorderSizePixel = 0;
            u2.UIListLayout(Frame, Enum.FillDirection.Vertical, UDim.new(0, 0));
            local Frame2 = Instance.new("Frame");
            Frame2.Name = "CollapsingHeaderContainer";
            Frame2.AutomaticSize = Enum.AutomaticSize.Y;
            Frame2.Size = UDim2.fromScale(1, 0);
            Frame2.BackgroundTransparency = 1;
            Frame2.BorderSizePixel = 0;
            Frame2.LayoutOrder = 1;
            Frame2.Visible = false;
            u2.UIListLayout(Frame2, Enum.FillDirection.Vertical, UDim.new(0, u1._config.ItemSpacing.Y));
            u2.UIPadding(Frame2, Vector2.zero).PaddingTop = UDim.new(0, u1._config.ItemSpacing.Y);
            Frame2.Parent = Frame;
            local Frame3 = Instance.new("Frame");
            Frame3.Name = "Header";
            Frame3.AutomaticSize = Enum.AutomaticSize.Y;
            Frame3.Size = UDim2.fromScale(1, 0);
            Frame3.BackgroundTransparency = 1;
            Frame3.BorderSizePixel = 0;
            Frame3.Parent = Frame;
            local TextButton = Instance.new("TextButton");
            TextButton.Name = "Button";
            TextButton.AutomaticSize = Enum.AutomaticSize.Y;
            TextButton.Size = UDim2.fromScale(1, 0);
            TextButton.BackgroundColor3 = u1._config.HeaderColor;
            TextButton.BackgroundTransparency = u1._config.HeaderTransparency;
            TextButton.BorderSizePixel = 0;
            TextButton.Text = "";
            TextButton.AutoButtonColor = false;
            TextButton.ClipsDescendants = true;
            u2.UIPadding(TextButton, u1._config.FramePadding);
            u2.applyFrameStyle(TextButton, true);
            u2.UIListLayout(TextButton, Enum.FillDirection.Horizontal, UDim.new(0, 2 * u1._config.FramePadding.X)).VerticalAlignment = Enum.VerticalAlignment.Center;
            u2.applyInteractionHighlights("Background", TextButton, TextButton, {
                Color = u1._config.HeaderColor,
                Transparency = u1._config.HeaderTransparency,
                HoveredColor = u1._config.HeaderHoveredColor,
                HoveredTransparency = u1._config.HeaderHoveredTransparency,
                ActiveColor = u1._config.HeaderActiveColor,
                ActiveTransparency = u1._config.HeaderActiveTransparency
            });
            TextButton.Parent = Frame3;
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.Name = "Arrow";
            ImageLabel.AutomaticSize = Enum.AutomaticSize.Y;
            ImageLabel.Size = UDim2.fromOffset(u1._config.TextSize, (math.ceil(u1._config.TextSize * 0.8)));
            ImageLabel.BackgroundTransparency = 1;
            ImageLabel.BorderSizePixel = 0;
            ImageLabel.ImageColor3 = u1._config.TextColor;
            ImageLabel.ImageTransparency = u1._config.TextTransparency;
            ImageLabel.ScaleType = Enum.ScaleType.Fit;
            ImageLabel.Parent = TextButton;
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "TextLabel";
            TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
            TextLabel.Size = UDim2.fromOffset(0, 0);
            TextLabel.BackgroundTransparency = 1;
            TextLabel.BorderSizePixel = 0;
            u2.UIPadding(TextLabel, Vector2.zero).PaddingRight = UDim.new(0, 21);
            u2.applyTextStyle(TextLabel);
            TextLabel.Parent = TextButton;
            u2.applyButtonClick(TextButton, function() -- Line: 270
                -- upvalues: u16 (copy)
                u16.state.isUncollapsed:set(not u16.state.isUncollapsed.value);
            end);
            u16.ChildContainer = Frame2;

            return Frame;
        end,

        Update = function(p17) -- Line: 277, Name: Update
            p17.Instance.Header.Button.TextLabel.Text = p17.arguments.Text or "Collapsing Header";
        end
    }));
end;