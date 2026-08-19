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
                Init = function(p3) -- Line: 12
                end,

                Get = function(p4) -- Line: 13
                    -- upvalues: u1 (copy)
                    return p4.lastCheckedTick == u1._cycleTick;
                end
            },
            unchecked = {
                Init = function(p5) -- Line: 18
                end,

                Get = function(p6) -- Line: 19
                    -- upvalues: u1 (copy)
                    return p6.lastUncheckedTick == u1._cycleTick;
                end
            },
            hovered = u2.EVENTS.hover(function(p7) -- Line: 23
                return p7.Instance;
            end)
        },

        Generate = function(u8) -- Line: 27, Name: Generate
            -- upvalues: u1 (copy), u2 (copy)
            local TextButton = Instance.new("TextButton");
            TextButton.Name = "Iris_Checkbox";
            TextButton.BackgroundTransparency = 1;
            TextButton.BorderSizePixel = 0;
            TextButton.Size = UDim2.fromOffset(0, 0);
            TextButton.Text = "";
            TextButton.AutomaticSize = Enum.AutomaticSize.XY;
            TextButton.ZIndex = u8.ZIndex;
            TextButton.AutoButtonColor = false;
            TextButton.LayoutOrder = u8.ZIndex;
            local v9 = u1._config.TextSize + 2 * u1._config.FramePadding.Y;
            local Frame = Instance.new("Frame");
            Frame.Name = "CheckboxBox";
            Frame.Size = UDim2.fromOffset(v9, v9);
            Frame.BackgroundColor3 = u1._config.FrameBgColor;
            Frame.BackgroundTransparency = u1._config.FrameBgTransparency;
            Frame.ZIndex = u8.ZIndex + 1;
            Frame.LayoutOrder = u8.ZIndex + 1;
            u2.applyFrameStyle(Frame, true);
            u2.applyInteractionHighlights(TextButton, Frame, {
                ButtonColor = u1._config.FrameBgColor,
                ButtonTransparency = u1._config.FrameBgTransparency,
                ButtonHoveredColor = u1._config.FrameBgHoveredColor,
                ButtonHoveredTransparency = u1._config.FrameBgHoveredTransparency,
                ButtonActiveColor = u1._config.FrameBgActiveColor,
                ButtonActiveTransparency = u1._config.FrameBgActiveTransparency
            });
            Frame.Parent = TextButton;
            local v10 = math.ceil(v9 * 0.1);
            local v11 = v9 - v10 * 2;
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.Name = "Checkmark";
            ImageLabel.Size = UDim2.fromOffset(v11, v11);
            ImageLabel.Position = UDim2.fromOffset(v10, v10);
            ImageLabel.BackgroundTransparency = 1;
            ImageLabel.ImageColor3 = u1._config.CheckMarkColor;
            ImageLabel.ImageTransparency = u1._config.CheckMarkTransparency;
            ImageLabel.ScaleType = Enum.ScaleType.Fit;
            ImageLabel.ZIndex = u8.ZIndex + 2;
            ImageLabel.LayoutOrder = u8.ZIndex + 2;
            ImageLabel.Parent = TextButton;
            TextButton.MouseButton1Click:Connect(function() -- Line: 77
                -- upvalues: u8 (copy)
                u8.state.isChecked:set(not u8.state.isChecked.value);
            end);
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "TextLabel";
            u2.applyTextStyle(TextLabel);
            TextLabel.AnchorPoint = Vector2.new(0, 0.5);
            TextLabel.Position = UDim2.new(0, v9 + u1._config.ItemInnerSpacing.X, 0.5, 0);
            TextLabel.ZIndex = u8.ZIndex + 1;
            TextLabel.LayoutOrder = u8.ZIndex + 1;
            TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
            TextLabel.BackgroundTransparency = 1;
            TextLabel.BorderSizePixel = 0;
            TextLabel.Parent = TextButton;

            return TextButton;
        end,

        Update = function(p12) -- Line: 96, Name: Update
            p12.Instance.TextLabel.Text = p12.arguments.Text or "Checkbox";
        end,

        Discard = function(p13) -- Line: 100, Name: Discard
            -- upvalues: u2 (copy)
            p13.Instance:Destroy();
            u2.discardState(p13);
        end,

        GenerateState = function(p14) -- Line: 104, Name: GenerateState
            -- upvalues: u1 (copy)
            if p14.state.isChecked == nil then
                p14.state.isChecked = u1._widgetState(p14, "checked", false);
            end;
        end,

        UpdateState = function(p15) -- Line: 109, Name: UpdateState
            -- upvalues: u2 (copy), u1 (copy)
            local Checkmark = p15.Instance.Checkmark;

            if p15.state.isChecked.value then
                Checkmark.Image = u2.ICONS.CHECK_MARK;
                p15.lastCheckedTick = u1._cycleTick + 1;

                return;
            end;

            Checkmark.Image = "";
            p15.lastUncheckedTick = u1._cycleTick + 1;
        end
    });
end;