-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(u1, u2) -- Line: 3
    u1.WidgetConstructor("Checkbox", {
        hasState = true,
        hasChildren = false,
        Args = {
            Text = 1
        },
        Events = {
            checked = {
                Init = function(p3) -- Line: 13
                end,

                Get = function(p4) -- Line: 14
                    -- upvalues: u1 (copy)
                    return p4.lastCheckedTick == u1._cycleTick;
                end
            },
            unchecked = {
                Init = function(p5) -- Line: 19
                end,

                Get = function(p6) -- Line: 20
                    -- upvalues: u1 (copy)
                    return p6.lastUncheckedTick == u1._cycleTick;
                end
            },
            hovered = u2.EVENTS.hover(function(p7) -- Line: 24
                return p7.Instance;
            end)
        },

        Generate = function(u8) -- Line: 28, Name: Generate
            -- upvalues: u2 (copy), u1 (copy)
            local TextButton = Instance.new("TextButton");
            TextButton.Name = "Iris_Checkbox";
            TextButton.AutomaticSize = Enum.AutomaticSize.XY;
            TextButton.Size = UDim2.fromOffset(0, 0);
            TextButton.BackgroundTransparency = 1;
            TextButton.BorderSizePixel = 0;
            TextButton.Text = "";
            TextButton.AutoButtonColor = false;
            u2.UIListLayout(TextButton, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.X)).VerticalAlignment = Enum.VerticalAlignment.Center;
            local v9 = u1._config.TextSize + 2 * u1._config.FramePadding.Y;
            local Frame = Instance.new("Frame");
            Frame.Name = "Box";
            Frame.Size = UDim2.fromOffset(v9, v9);
            Frame.BackgroundColor3 = u1._config.FrameBgColor;
            Frame.BackgroundTransparency = u1._config.FrameBgTransparency;
            u2.applyFrameStyle(Frame, true);
            u2.UIPadding(Frame, Vector2.new(math.floor(v9 / 10), (math.floor(v9 / 10))));
            u2.applyInteractionHighlights("Background", TextButton, Frame, {
                Color = u1._config.FrameBgColor,
                Transparency = u1._config.FrameBgTransparency,
                HoveredColor = u1._config.FrameBgHoveredColor,
                HoveredTransparency = u1._config.FrameBgHoveredTransparency,
                ActiveColor = u1._config.FrameBgActiveColor,
                ActiveTransparency = u1._config.FrameBgActiveTransparency
            });
            Frame.Parent = TextButton;
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.Name = "Checkmark";
            ImageLabel.Size = UDim2.fromScale(1, 1);
            ImageLabel.BackgroundTransparency = 1;
            ImageLabel.Image = u2.ICONS.CHECKMARK;
            ImageLabel.ImageColor3 = u1._config.CheckMarkColor;
            ImageLabel.ImageTransparency = 1;
            ImageLabel.ScaleType = Enum.ScaleType.Fit;
            ImageLabel.Parent = Frame;
            u2.applyButtonClick(TextButton, function() -- Line: 73
                -- upvalues: u8 (copy)
                u8.state.isChecked:set(not u8.state.isChecked.value);
            end);
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "TextLabel";
            TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
            TextLabel.BackgroundTransparency = 1;
            TextLabel.BorderSizePixel = 0;
            TextLabel.LayoutOrder = 1;
            u2.applyTextStyle(TextLabel);
            TextLabel.Parent = TextButton;

            return TextButton;
        end,

        GenerateState = function(p10) -- Line: 89, Name: GenerateState
            -- upvalues: u1 (copy)
            if p10.state.isChecked == nil then
                p10.state.isChecked = u1._widgetState(p10, "checked", false);
            end;
        end,

        Update = function(p11) -- Line: 94, Name: Update
            p11.Instance.TextLabel.Text = p11.arguments.Text or "Checkbox";
        end,

        UpdateState = function(p12) -- Line: 98, Name: UpdateState
            -- upvalues: u1 (copy)
            local Checkmark = p12.Instance.Box.Checkmark;

            if p12.state.isChecked.value then
                Checkmark.ImageTransparency = u1._config.CheckMarkTransparency;
                p12.lastCheckedTick = u1._cycleTick + 1;

                return;
            end;

            Checkmark.ImageTransparency = 1;
            p12.lastUncheckedTick = u1._cycleTick + 1;
        end,

        Discard = function(p13) -- Line: 110, Name: Discard
            -- upvalues: u2 (copy)
            p13.Instance:Destroy();
            u2.discardState(p13);
        end
    });
end;