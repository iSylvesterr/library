-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(u1, u2) -- Line: 3
    u1.WidgetConstructor("Text", {
        hasState = false,
        hasChildren = false,
        Args = {
            Text = 1,
            Wrapped = 2,
            Color = 3,
            RichText = 4
        },
        Events = {
            hovered = u2.EVENTS.hover(function(p3) -- Line: 15
                return p3.Instance;
            end)
        },

        Generate = function(p4) -- Line: 19, Name: Generate
            -- upvalues: u2 (copy)
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "Iris_Text";
            TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
            TextLabel.Size = UDim2.fromOffset(0, 0);
            TextLabel.BackgroundTransparency = 1;
            TextLabel.BorderSizePixel = 0;
            u2.applyTextStyle(TextLabel);
            u2.UIPadding(TextLabel, Vector2.new(0, 2));

            return TextLabel;
        end,

        Update = function(p5) -- Line: 32, Name: Update
            -- upvalues: u1 (copy)
            local Instance2 = p5.Instance;

            if p5.arguments.Text == nil then
                error("Text argument is required for Iris.Text().", 5);
            end;

            if p5.arguments.Wrapped == nil then
                Instance2.TextWrapped = u1._config.TextWrapped;
            else
                Instance2.TextWrapped = p5.arguments.Wrapped;
            end;

            if p5.arguments.Color then
                Instance2.TextColor3 = p5.arguments.Color;
            else
                Instance2.TextColor3 = u1._config.TextColor;
            end;

            if p5.arguments.RichText == nil then
                Instance2.RichText = u1._config.RichText;
            else
                Instance2.RichText = p5.arguments.RichText;
            end;

            Instance2.Text = p5.arguments.Text;
        end,

        Discard = function(p6) -- Line: 55, Name: Discard
            p6.Instance:Destroy();
        end
    });
    u1.WidgetConstructor("SeparatorText", {
        hasState = false,
        hasChildren = false,
        Args = {
            Text = 1
        },
        Events = {
            hovered = u2.EVENTS.hover(function(p7) -- Line: 68
                return p7.Instance;
            end)
        },

        Generate = function(p8) -- Line: 72, Name: Generate
            -- upvalues: u1 (copy), u2 (copy)
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_SeparatorText";
            Frame.AutomaticSize = Enum.AutomaticSize.Y;
            Frame.Size = UDim2.new(u1._config.ItemWidth, UDim.new());
            Frame.BackgroundTransparency = 1;
            Frame.BorderSizePixel = 0;
            Frame.ClipsDescendants = true;
            u2.UIPadding(Frame, Vector2.new(0, u1._config.SeparatorTextPadding.Y));
            u2.UIListLayout(Frame, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemSpacing.X));
            Frame.UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "TextLabel";
            TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
            TextLabel.BackgroundTransparency = 1;
            TextLabel.BorderSizePixel = 0;
            TextLabel.LayoutOrder = 1;
            u2.applyTextStyle(TextLabel);
            TextLabel.Parent = Frame;
            local Frame2 = Instance.new("Frame");
            Frame2.Name = "Left";
            Frame2.AnchorPoint = Vector2.new(1, 0.5);
            Frame2.Size = UDim2.fromOffset(u1._config.SeparatorTextPadding.X - u1._config.ItemSpacing.X, u1._config.SeparatorTextBorderSize);
            Frame2.BackgroundColor3 = u1._config.SeparatorColor;
            Frame2.BackgroundTransparency = u1._config.SeparatorTransparency;
            Frame2.BorderSizePixel = 0;
            Frame2.Parent = Frame;
            local Frame3 = Instance.new("Frame");
            Frame3.Name = "Right";
            Frame3.AnchorPoint = Vector2.new(1, 0.5);
            Frame3.Size = UDim2.new(1, 0, 0, u1._config.SeparatorTextBorderSize);
            Frame3.BackgroundColor3 = u1._config.SeparatorColor;
            Frame3.BackgroundTransparency = u1._config.SeparatorTransparency;
            Frame3.BorderSizePixel = 0;
            Frame3.LayoutOrder = 2;
            Frame3.Parent = Frame;

            return Frame;
        end,

        Update = function(p9) -- Line: 120, Name: Update
            local TextLabel = p9.Instance.TextLabel;

            if p9.arguments.Text == nil then
                error("Text argument is required for Iris.SeparatorText().", 5);
            end;

            TextLabel.Text = p9.arguments.Text;
        end,

        Discard = function(p10) -- Line: 128, Name: Discard
            p10.Instance:Destroy();
        end
    });
end;