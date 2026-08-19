-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(u1, u2) -- Line: 3
    local v4 = {
        hasState = false,
        hasChildren = false,
        Args = {
            Image = 1,
            Size = 2,
            Rect = 3,
            ScaleType = 4,
            ResampleMode = 5,
            TileSize = 6,
            SliceCenter = 7,
            SliceScale = 8
        },

        Discard = function(p3) -- Line: 17, Name: Discard
            p3.Instance:Destroy();
        end
    };
    u1.WidgetConstructor("Image", u2.extend(v4, {
        Events = {
            hovered = u2.EVENTS.hover(function(p5) -- Line: 25
                return p5.Instance;
            end)
        },

        Generate = function(p6) -- Line: 29, Name: Generate
            -- upvalues: u1 (copy), u2 (copy)
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.Name = "Iris_Image";
            ImageLabel.BackgroundTransparency = 1;
            ImageLabel.BorderSizePixel = 0;
            ImageLabel.ImageColor3 = u1._config.ImageColor;
            ImageLabel.ImageTransparency = u1._config.ImageTransparency;
            u2.applyFrameStyle(ImageLabel, true);

            return ImageLabel;
        end,

        Update = function(p7) -- Line: 41, Name: Update
            -- upvalues: u2 (copy)
            local Instance2 = p7.Instance;
            Instance2.Image = p7.arguments.Image or u2.ICONS.UNKNOWN_TEXTURE;
            Instance2.Size = p7.arguments.Size;

            if p7.arguments.ScaleType then
                Instance2.ScaleType = p7.arguments.ScaleType;

                if p7.arguments.ScaleType == Enum.ScaleType.Tile and p7.arguments.TileSize then
                    Instance2.TileSize = p7.arguments.TileSize;
                elseif p7.arguments.ScaleType == Enum.ScaleType.Slice then
                    if p7.arguments.SliceCenter then
                        Instance2.SliceCenter = p7.arguments.SliceCenter;
                    end;

                    if p7.arguments.SliceScale then
                        Instance2.SliceScale = p7.arguments.SliceScale;
                    end;
                end;
            end;

            if p7.arguments.Rect then
                Instance2.ImageRectOffset = p7.arguments.Rect.Min;
                Instance2.ImageRectSize = Vector2.new(p7.arguments.Rect.Width, p7.arguments.Rect.Height);
            end;

            if p7.arguments.ResampleMode then
                Instance2.ResampleMode = p7.arguments.ResampleMode;
            end;
        end
    }));
    u1.WidgetConstructor("ImageButton", u2.extend(v4, {
        Events = {
            clicked = u2.EVENTS.click(function(p8) -- Line: 75
                return p8.Instance;
            end),
            rightClicked = u2.EVENTS.rightClick(function(p9) -- Line: 78
                return p9.Instance;
            end),
            doubleClicked = u2.EVENTS.doubleClick(function(p10) -- Line: 81
                return p10.Instance;
            end),
            ctrlClicked = u2.EVENTS.ctrlClick(function(p11) -- Line: 84
                return p11.Instance;
            end),
            hovered = u2.EVENTS.hover(function(p12) -- Line: 87
                return p12.Instance;
            end)
        },

        Generate = function(p13) -- Line: 91, Name: Generate
            -- upvalues: u1 (copy), u2 (copy)
            local ImageButton = Instance.new("ImageButton");
            ImageButton.Name = "Iris_ImageButton";
            ImageButton.AutomaticSize = Enum.AutomaticSize.XY;
            ImageButton.BackgroundColor3 = u1._config.FrameBgColor;
            ImageButton.BackgroundTransparency = u1._config.FrameBgTransparency;
            ImageButton.BorderSizePixel = 0;
            ImageButton.Image = "";
            ImageButton.ImageTransparency = 1;
            ImageButton.AutoButtonColor = false;
            u2.applyFrameStyle(ImageButton, true);
            u2.UIPadding(ImageButton, Vector2.new(u1._config.ImageBorderSize, u1._config.ImageBorderSize));
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.Name = "ImageLabel";
            ImageLabel.BackgroundTransparency = 1;
            ImageLabel.BorderSizePixel = 0;
            ImageLabel.ImageColor3 = u1._config.ImageColor;
            ImageLabel.ImageTransparency = u1._config.ImageTransparency;
            ImageLabel.Parent = ImageButton;
            u2.applyInteractionHighlights("Background", ImageButton, ImageButton, {
                Color = u1._config.FrameBgColor,
                Transparency = u1._config.FrameBgTransparency,
                HoveredColor = u1._config.FrameBgHoveredColor,
                HoveredTransparency = u1._config.FrameBgHoveredTransparency,
                ActiveColor = u1._config.FrameBgActiveColor,
                ActiveTransparency = u1._config.FrameBgActiveTransparency
            });

            return ImageButton;
        end,

        Update = function(p14) -- Line: 124, Name: Update
            -- upvalues: u2 (copy)
            local ImageLabel = p14.Instance.ImageLabel;
            ImageLabel.Image = p14.arguments.Image or u2.ICONS.UNKNOWN_TEXTURE;
            ImageLabel.Size = p14.arguments.Size;

            if p14.arguments.ScaleType then
                ImageLabel.ScaleType = p14.arguments.ScaleType;

                if p14.arguments.ScaleType == Enum.ScaleType.Tile and p14.arguments.TileSize then
                    ImageLabel.TileSize = p14.arguments.TileSize;
                elseif p14.arguments.ScaleType == Enum.ScaleType.Slice then
                    if p14.arguments.SliceCenter then
                        ImageLabel.SliceCenter = p14.arguments.SliceCenter;
                    end;

                    if p14.arguments.SliceScale then
                        ImageLabel.SliceScale = p14.arguments.SliceScale;
                    end;
                end;
            end;

            if p14.arguments.Rect then
                ImageLabel.ImageRectOffset = p14.arguments.Rect.Min;
                ImageLabel.ImageRectSize = Vector2.new(p14.arguments.Rect.Width, p14.arguments.Rect.Height);
            end;

            if p14.arguments.ResampleMode then
                ImageLabel.ResampleMode = p14.arguments.ResampleMode;
            end;
        end
    }));
end;