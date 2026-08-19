-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(u1, u2) -- Line: 3
    u1.WidgetConstructor("Separator", {
        hasState = false,
        hasChildren = false,
        Args = {},
        Events = {},

        Generate = function(p3) -- Line: 10, Name: Generate
            -- upvalues: u1 (copy), u2 (copy)
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_Separator";

            if p3.parentWidget.type == "SameLine" then
                Frame.Size = UDim2.new(0, 1, u1._config.ItemWidth.Scale, u1._config.ItemWidth.Offset);
            else
                Frame.Size = UDim2.new(u1._config.ItemWidth.Scale, u1._config.ItemWidth.Offset, 0, 1);
            end;

            Frame.BackgroundColor3 = u1._config.SeparatorColor;
            Frame.BackgroundTransparency = u1._config.SeparatorTransparency;
            Frame.BorderSizePixel = 0;
            u2.UIListLayout(Frame, Enum.FillDirection.Vertical, UDim.new(0, 0));

            return Frame;
        end,

        Update = function(p4) -- Line: 27, Name: Update
        end,

        Discard = function(p5) -- Line: 28, Name: Discard
            p5.Instance:Destroy();
        end
    });
    u1.WidgetConstructor("Indent", {
        hasState = false,
        hasChildren = true,
        Args = {
            Width = 1
        },
        Events = {},

        Generate = function(p6) -- Line: 41, Name: Generate
            -- upvalues: u1 (copy), u2 (copy)
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_Indent";
            Frame.AutomaticSize = Enum.AutomaticSize.Y;
            Frame.Size = UDim2.new(u1._config.ItemWidth, UDim.new());
            Frame.BackgroundTransparency = 1;
            Frame.BorderSizePixel = 0;
            u2.UIListLayout(Frame, Enum.FillDirection.Vertical, UDim.new(0, u1._config.ItemSpacing.Y));
            u2.UIPadding(Frame, Vector2.zero);

            return Frame;
        end,

        Update = function(p7) -- Line: 54, Name: Update
            -- upvalues: u1 (copy)
            local v8;

            if p7.arguments.Width then
                v8 = p7.arguments.Width;
            else
                v8 = u1._config.IndentSpacing;
            end;

            p7.Instance.UIPadding.PaddingLeft = UDim.new(0, v8);
        end,

        ChildAdded = function(p9, p10) -- Line: 59, Name: ChildAdded
            return p9.Instance;
        end,

        Discard = function(p11) -- Line: 62, Name: Discard
            p11.Instance:Destroy();
        end
    });
    u1.WidgetConstructor("SameLine", {
        hasState = false,
        hasChildren = true,
        Args = {
            Width = 1,
            VerticalAlignment = 2,
            HorizontalAlignment = 3
        },
        Events = {},

        Generate = function(p12) -- Line: 77, Name: Generate
            -- upvalues: u1 (copy), u2 (copy)
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_SameLine";
            Frame.AutomaticSize = Enum.AutomaticSize.Y;
            Frame.Size = UDim2.new(u1._config.ItemWidth, UDim.new());
            Frame.BackgroundTransparency = 1;
            Frame.BorderSizePixel = 0;
            u2.UIListLayout(Frame, Enum.FillDirection.Horizontal, UDim.new(0, 0));

            return Frame;
        end,

        Update = function(p13) -- Line: 89, Name: Update
            -- upvalues: u1 (copy)
            local UIListLayout = p13.Instance.UIListLayout;
            local v14;

            if p13.arguments.Width then
                v14 = p13.arguments.Width;
            else
                v14 = u1._config.ItemSpacing.X;
            end;

            UIListLayout.Padding = UDim.new(0, v14);

            if p13.arguments.VerticalAlignment then
                UIListLayout.VerticalAlignment = p13.arguments.VerticalAlignment;
            else
                UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top;
            end;

            if p13.arguments.HorizontalAlignment then
                UIListLayout.HorizontalAlignment = p13.arguments.HorizontalAlignment;

                return;
            end;

            UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left;
        end,

        ChildAdded = function(p15, p16) -- Line: 105, Name: ChildAdded
            return p15.Instance;
        end,

        Discard = function(p17) -- Line: 108, Name: Discard
            p17.Instance:Destroy();
        end
    });
    u1.WidgetConstructor("Group", {
        hasState = false,
        hasChildren = true,
        Args = {},
        Events = {},

        Generate = function(p18) -- Line: 119, Name: Generate
            -- upvalues: u2 (copy), u1 (copy)
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_Group";
            Frame.AutomaticSize = Enum.AutomaticSize.XY;
            Frame.Size = UDim2.fromOffset(0, 0);
            Frame.BackgroundTransparency = 1;
            Frame.BorderSizePixel = 0;
            Frame.ClipsDescendants = false;
            u2.UIListLayout(Frame, Enum.FillDirection.Vertical, UDim.new(0, u1._config.ItemSpacing.Y));

            return Frame;
        end,

        Update = function(p19) -- Line: 132, Name: Update
        end,

        ChildAdded = function(p20, p21) -- Line: 133, Name: ChildAdded
            return p20.Instance;
        end,

        Discard = function(p22) -- Line: 136, Name: Discard
            p22.Instance:Destroy();
        end
    });
end;