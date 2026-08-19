-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(u1, u2) -- Line: 3
    local u5 = {
        Init = function(p3) -- Line: 5
        end,

        Get = function(p4) -- Line: 6
            -- upvalues: u1 (copy)
            return p4.lastNumberChangedTick == u1._cycleTick;
        end
    };

    local function getValueByIndex(p6, p7, p8) -- Line: 11
        if typeof(p6) == "number" then
            return p6;
        end;

        if typeof(p6) == "Vector2" then
            if p7 == 1 then
                return p6.X;
            end;

            if p7 == 2 then
                return p6.Y;
            end;
        elseif typeof(p6) == "Vector3" then
            if p7 == 1 then
                return p6.X;
            end;

            if p7 == 2 then
                return p6.Y;
            end;

            if p7 == 3 then
                return p6.Z;
            end;
        elseif typeof(p6) == "UDim" then
            if p7 == 1 then
                return p6.Scale;
            end;

            if p7 == 2 then
                return p6.Offset;
            end;
        elseif typeof(p6) == "UDim2" then
            if p7 == 1 then
                return p6.X.Scale;
            end;

            if p7 == 2 then
                return p6.X.Offset;
            end;

            if p7 == 3 then
                return p6.Y.Scale;
            end;

            if p7 == 4 then
                return p6.Y.Offset;
            end;
        elseif typeof(p6) == "Color3" then
            local v9 = p8.UseHSV and { p6:ToHSV() } or { p6.R, p6.G, p6.B };

            if p7 == 1 then
                return v9[1];
            end;

            if p7 == 2 then
                return v9[2];
            end;

            if p7 == 3 then
                return v9[3];
            end;
        elseif typeof(p6) == "Rect" then
            if p7 == 1 then
                return p6.Min.X;
            end;

            if p7 == 2 then
                return p6.Min.Y;
            end;

            if p7 == 3 then
                return p6.Max.X;
            end;

            if p7 == 4 then
                return p6.Max.Y;
            end;
        elseif typeof(p6) == "table" then
            return p6[p7];
        end;

        error((`Incorrect datatype or value: {p6} {typeof(p6)} {p7}`));
    end;

    local function updateValueByIndex(p10, p11, p12, p13) -- Line: 70
        if typeof(p10) == "number" then
            return p12;
        end;

        if typeof(p10) == "Vector2" then
            if p11 == 1 then
                return Vector2.new(p12, p10.Y);
            end;

            if p11 == 2 then
                return Vector2.new(p10.X, p12);
            end;
        elseif typeof(p10) == "Vector3" then
            if p11 == 1 then
                return Vector3.new(p12, p10.Y, p10.Z);
            end;

            if p11 == 2 then
                return Vector3.new(p10.X, p12, p10.Z);
            end;

            if p11 == 3 then
                return Vector3.new(p10.X, p10.Y, p12);
            end;
        elseif typeof(p10) == "UDim" then
            if p11 == 1 then
                return UDim.new(p12, p10.Offset);
            end;

            if p11 == 2 then
                return UDim.new(p10.Scale, p12);
            end;
        elseif typeof(p10) == "UDim2" then
            if p11 == 1 then
                return UDim2.new(UDim.new(p12, p10.X.Offset), p10.Y);
            end;

            if p11 == 2 then
                return UDim2.new(UDim.new(p10.X.Scale, p12), p10.Y);
            end;

            if p11 == 3 then
                return UDim2.new(p10.X, UDim.new(p12, p10.Y.Offset));
            end;

            if p11 == 4 then
                return UDim2.new(p10.X, UDim.new(p10.Y.Scale, p12));
            end;
        elseif typeof(p10) == "Rect" then
            if p11 == 1 then
                return Rect.new(Vector2.new(p12, p10.Min.Y), p10.Max);
            end;

            if p11 == 2 then
                return Rect.new(Vector2.new(p10.Min.X, p12), p10.Max);
            end;

            if p11 == 3 then
                return Rect.new(p10.Min, Vector2.new(p12, p10.Max.Y));
            end;

            if p11 == 4 then
                return Rect.new(p10.Min, Vector2.new(p10.Max.X, p12));
            end;
        elseif typeof(p10) == "Color3" then
            if p13.UseHSV then
                local v14, v15, v16 = p10:ToHSV();

                if p11 == 1 then
                    return Color3.fromHSV(p12, v15, v16);
                end;

                if p11 == 2 then
                    return Color3.fromHSV(v14, p12, v16);
                end;

                if p11 == 3 then
                    return Color3.fromHSV(v14, v15, p12);
                end;
            end;

            if p11 == 1 then
                return Color3.new(p12, p10.G, p10.B);
            end;

            if p11 == 2 then
                return Color3.new(p10.R, p12, p10.B);
            end;

            if p11 == 3 then
                return Color3.new(p10.R, p10.G, p12);
            end;
        end;

        error((`Incorrect datatype or value {p10} {typeof(p10)} {p11}`));
    end;

    local u17 = {
        Num = { 1 },
        Vector2 = { 1, 1 },
        Vector3 = { 1, 1, 1 },
        UDim = { 0.01, 1 },
        UDim2 = { 0.01, 1, 0.01, 1 },
        Color3 = { 1, 1, 1 },
        Color4 = { 1, 1, 1, 1 },
        Rect = { 1, 1, 1, 1 }
    };
    local u18 = {
        Num = { 0 },
        Vector2 = { 0, 0 },
        Vector3 = { 0, 0, 0 },
        UDim = { 0, 0 },
        UDim2 = { 0, 0, 0, 0 },
        Rect = { 0, 0, 0, 0 }
    };
    local u19 = {
        Num = { 100 },
        Vector2 = { 100, 100 },
        Vector3 = { 100, 100, 100 },
        UDim = { 1, 960 },
        UDim2 = { 1, 960, 1, 960 },
        Rect = { 960, 960, 960, 960 }
    };
    local u20 = {
        Num = { "" },
        Vector2 = { "X: ", "Y: " },
        Vector3 = { "X: ", "Y: ", "Z: " },
        UDim = { "", "" },
        UDim2 = { "", "", "", "" },
        Color3_RGB = { "R: ", "G: ", "B: " },
        Color3_HSV = { "H: ", "S: ", "V: " },
        Color4_RGB = { "R: ", "G: ", "B: ", "T: " },
        Color4_HSV = { "H: ", "S: ", "V: ", "T: " },
        Rect = { "X: ", "Y: ", "X: ", "Y: " }
    };
    local u21 = {
        Num = { 0 },
        Vector2 = { 0, 0 },
        Vector3 = { 0, 0, 0 },
        UDim = { 3, 0 },
        UDim2 = { 3, 0, 3, 0 },
        Color3 = { 0, 0, 0 },
        Color4 = { 0, 0, 0, 0 },
        Rect = { 0, 0, 0, 0 }
    };

    local function generateButtons(u22, p23, p24, p25) -- Line: 199
        -- upvalues: u1 (copy), u2 (copy), getValueByIndex (copy)
        local v26 = p24 + (2 * u1._config.ItemInnerSpacing.X + p25 * 2);
        local v27 = u2.abstractButton.Generate(u22);
        v27.Name = "SubButton";
        v27.ZIndex = u22.ZIndex + 5;
        v27.LayoutOrder = u22.ZIndex + 5;
        v27.TextXAlignment = Enum.TextXAlignment.Center;
        v27.Text = "-";
        v27.Size = UDim2.fromOffset(u1._config.TextSize + 2 * u1._config.FramePadding.Y, u1._config.TextSize);
        v27.Parent = p23;
        v27.MouseButton1Click:Connect(function() -- Line: 217
            -- upvalues: u2 (ref), u22 (copy), getValueByIndex (ref), u1 (ref)
            local v28 = u2.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or u2.UserInputService:IsKeyDown(Enum.KeyCode.RightControl);
            local v29 = u22.arguments.Increment and getValueByIndex(u22.arguments.Increment, 1, u22.arguments) or 1;
            local v30 = u22.state.number.value - v29 * (v28 and 100 or 1);

            if u22.arguments.Min ~= nil then
                v30 = math.max(v30, getValueByIndex(u22.arguments.Min, 1, u22.arguments));
            end;

            if u22.arguments.Max ~= nil then
                v30 = math.min(v30, getValueByIndex(u22.arguments.Max, 1, u22.arguments));
            end;

            u22.state.number:set(v30);
            u22.lastNumberChangedTick = u1._cycleTick + 1;
        end);
        local v31 = u2.abstractButton.Generate(u22);
        v31.Name = "AddButton";
        v31.ZIndex = u22.ZIndex + 6;
        v31.LayoutOrder = u22.ZIndex + 6;
        v31.TextXAlignment = Enum.TextXAlignment.Center;
        v31.Text = "+";
        v31.Size = UDim2.fromOffset(u1._config.TextSize + 2 * u1._config.FramePadding.Y, u1._config.TextSize);
        v31.Parent = p23;
        v31.MouseButton1Click:Connect(function() -- Line: 246
            -- upvalues: u2 (ref), u22 (copy), getValueByIndex (ref), u1 (ref)
            local v32 = u2.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or u2.UserInputService:IsKeyDown(Enum.KeyCode.RightControl);
            local v33 = u22.arguments.Increment and getValueByIndex(u22.arguments.Increment, 1, u22.arguments) or 1;
            local v34 = u22.state.number.value + v33 * (v32 and 100 or 1);

            if u22.arguments.Min ~= nil then
                v34 = math.max(v34, getValueByIndex(u22.arguments.Min, 1, u22.arguments));
            end;

            if u22.arguments.Max ~= nil then
                v34 = math.min(v34, getValueByIndex(u22.arguments.Max, 1, u22.arguments));
            end;

            u22.state.number:set(v34);
            u22.lastNumberChangedTick = u1._cycleTick + 1;
        end);

        return v26;
    end;

    local function generateInputScalar(u35, u36, u37) -- Line: 268
        -- upvalues: u5 (copy), u2 (copy), u1 (copy), generateButtons (copy), getValueByIndex (copy), updateValueByIndex (copy), u21 (copy), u20 (copy)
        return {
            hasState = true,
            hasChildren = false,
            Args = {
                Text = 1,
                Increment = 2,
                Min = 3,
                Max = 4,
                Format = 5
            },
            Events = {
                numberChanged = u5,
                hovered = u2.EVENTS.hover(function(p38) -- Line: 281
                    return p38.Instance;
                end)
            },

            Generate = function(u39) -- Line: 285, Name: Generate
                -- upvalues: u35 (copy), u2 (ref), u1 (ref), u36 (copy), generateButtons (ref), getValueByIndex (ref), updateValueByIndex (ref)
                local Frame = Instance.new("Frame");
                Frame.Name = "Iris_Input" .. u35;
                Frame.Size = UDim2.fromScale(1, 0);
                Frame.BackgroundTransparency = 1;
                Frame.BorderSizePixel = 0;
                Frame.ZIndex = u39.ZIndex;
                Frame.LayoutOrder = u39.ZIndex;
                Frame.AutomaticSize = Enum.AutomaticSize.Y;
                u2.UIListLayout(Frame, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.X));
                local v40 = 0;
                local v41 = u1._config.TextSize + 2 * u1._config.FramePadding.Y;

                if u36 == 1 then
                    v40 = generateButtons(u39, Frame, v40, v41);
                end;

                local v42 = UDim.new(u1._config.ContentWidth.Scale / u36, (u1._config.ContentWidth.Offset - u1._config.ItemInnerSpacing.X * (u36 - 1) - v40) / u36);
                local v43 = UDim.new(v42.Scale * (u36 - 1), v42.Offset * (u36 - 1) + u1._config.ItemInnerSpacing.X * (u36 - 1) + v40);
                local v44 = u1._config.ContentWidth - v43;

                for i = 1, u36 do
                    local TextBox = Instance.new("TextBox");
                    TextBox.Name = "InputField" .. tostring(i);
                    TextBox.ZIndex = u39.ZIndex + i;
                    TextBox.LayoutOrder = u39.ZIndex + i;

                    if i == u36 then
                        TextBox.Size = UDim2.new(v44, UDim.new());
                    else
                        TextBox.Size = UDim2.new(v42, UDim.new());
                    end;

                    TextBox.AutomaticSize = Enum.AutomaticSize.Y;
                    TextBox.BackgroundColor3 = u1._config.FrameBgColor;
                    TextBox.BackgroundTransparency = u1._config.FrameBgTransparency;
                    TextBox.ClearTextOnFocus = false;
                    TextBox.TextTruncate = Enum.TextTruncate.AtEnd;
                    TextBox.ClipsDescendants = true;
                    u2.applyFrameStyle(TextBox);
                    u2.applyTextStyle(TextBox);
                    u2.UISizeConstraint(TextBox, Vector2.new(1, 0));
                    TextBox.Parent = Frame;
                    TextBox.FocusLost:Connect(function() -- Line: 351
                        -- upvalues: TextBox (copy), u39 (copy), getValueByIndex (ref), i (copy), updateValueByIndex (ref), u1 (ref)
                        local v45 = tonumber(TextBox.Text:match("-?%d*%.?%d*"));

                        if v45 ~= nil then
                            if u39.arguments.Min ~= nil then
                                v45 = math.max(v45, getValueByIndex(u39.arguments.Min, i, u39.arguments));
                            end;

                            if u39.arguments.Max ~= nil then
                                v45 = math.min(v45, getValueByIndex(u39.arguments.Max, i, u39.arguments));
                            end;

                            if u39.arguments.Increment then
                                local v46 = v45 / getValueByIndex(u39.arguments.Increment, i, u39.arguments);
                                v45 = math.round(v46) * getValueByIndex(u39.arguments.Increment, i, u39.arguments);
                            end;

                            u39.state.number:set(updateValueByIndex(u39.state.number.value, i, v45, u39.arguments));
                            u39.lastNumberChangedTick = u1._cycleTick + 1;
                        end;

                        local v47 = u39.arguments.Format[i] or u39.arguments.Format[1];

                        if u39.arguments.Prefix then
                            v47 = u39.arguments.Prefix[i] .. v47;
                        end;

                        TextBox.Text = string.format(v47, getValueByIndex(u39.state.number.value, i, u39.arguments));
                        u39.state.editingText:set(0);
                    end);
                    TextBox.Focused:Connect(function() -- Line: 404
                        -- upvalues: TextBox (copy), u39 (copy), i (copy)
                        TextBox.CursorPosition = #TextBox.Text + 1;
                        TextBox.SelectionStart = 1;
                        u39.state.editingText:set(i);
                    end);
                end;

                local TextLabel = Instance.new("TextLabel");
                TextLabel.Name = "TextLabel";
                TextLabel.Size = UDim2.fromOffset(0, v41);
                TextLabel.BackgroundTransparency = 1;
                TextLabel.BorderSizePixel = 0;
                TextLabel.ZIndex = u39.ZIndex + 7;
                TextLabel.LayoutOrder = u39.ZIndex + 7;
                TextLabel.AutomaticSize = Enum.AutomaticSize.X;
                u2.applyTextStyle(TextLabel);
                TextLabel.Parent = Frame;

                return Frame;
            end,

            Update = function(p48) -- Line: 428, Name: Update
                -- upvalues: u35 (copy), u36 (copy), u21 (ref), getValueByIndex (ref), u20 (ref)
                local Instance2 = p48.Instance;
                Instance2.TextLabel.Text = p48.arguments.Text or `Input {u35}`;

                if u36 == 1 then
                    Instance2.SubButton.Visible = not p48.arguments.NoButtons;
                    Instance2.AddButton.Visible = not p48.arguments.NoButtons;
                end;

                if p48.arguments.Format and typeof(p48.arguments.Format) ~= "table" then
                    p48.arguments.Format = { p48.arguments.Format };

                    return;
                end;

                local v49 = {};

                for i = 1, u36 do
                    local v50 = u21[u35][i];

                    if p48.arguments.Increment then
                        local v51 = getValueByIndex(p48.arguments.Increment, i, p48.arguments);
                        local v52 = -math.log10(v51 == 0 and 1 or v51);
                        local v53 = math.ceil(v52);
                        v50 = math.max(v50, v53, v50);
                    end;

                    if p48.arguments.Max then
                        local v54 = getValueByIndex(p48.arguments.Max, i, p48.arguments);
                        local v55 = -math.log10(v54 == 0 and 1 or v54);
                        local v56 = math.ceil(v55);
                        v50 = math.max(v50, v56, v50);
                    end;

                    if p48.arguments.Min then
                        local v57 = getValueByIndex(p48.arguments.Min, i, p48.arguments);
                        local v58 = -math.log10(v57 == 0 and 1 or v57);
                        local v59 = math.ceil(v58);
                        v50 = math.max(v50, v59, v50);
                    end;

                    if v50 > 0 then
                        v49[i] = `%.{v50}f`;
                    else
                        v49[i] = "%d";
                    end;
                end;

                p48.arguments.Format = v49;
                p48.arguments.Prefix = u20[u35];
            end,

            Discard = function(p60) -- Line: 476, Name: Discard
                -- upvalues: u2 (ref)
                p60.Instance:Destroy();
                u2.discardState(p60);
            end,

            GenerateState = function(p61) -- Line: 480, Name: GenerateState
                -- upvalues: u1 (ref), u37 (copy)
                if p61.state.number == nil then
                    p61.state.number = u1._widgetState(p61, "number", u37);
                end;

                if p61.state.editingText == nil then
                    p61.state.editingText = u1._widgetState(p61, "editingText", 0);
                end;
            end,

            UpdateState = function(p62) -- Line: 488, Name: UpdateState
                -- upvalues: u36 (copy), getValueByIndex (ref)
                local Instance2 = p62.Instance;

                for i = 1, u36 do
                    local v63 = Instance2:FindFirstChild("InputField" .. tostring(i));
                    local v64 = p62.arguments.Format[i] or p62.arguments.Format[1];

                    if p62.arguments.Prefix then
                        v64 = p62.arguments.Prefix[i] .. v64;
                    end;

                    v63.Text = string.format(v64, getValueByIndex(p62.state.number.value, i, p62.arguments));
                end;
            end
        };
    end;

    local u65 = 0;
    local u66 = false;
    local u67 = nil;
    local u68 = 0;
    local u69 = "";

    local function updateActiveDrag() -- Line: 519
        -- upvalues: u2 (copy), u65 (ref), u66 (ref), u67 (ref), u69 (ref), u68 (ref), getValueByIndex (copy), u17 (copy), updateValueByIndex (copy), u1 (copy)
        local X = u2.getMouseLocation().X;
        local v70 = X - u65;
        u65 = X;

        if u66 == false then
            return;
        end;

        if u67 == nil then
            return;
        end;

        local number = u67.state.number;

        if u69 == "Color3" or u69 == "Color4" then
            number = u67.state.color;

            if u68 == 4 then
                number = u67.state.transparency;
            end;
        end;

        local v71 = (u67.arguments.Increment and getValueByIndex(u67.arguments.Increment, u68, u67.arguments) or u17[u69][u68]) * ((u2.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or u2.UserInputService:IsKeyDown(Enum.KeyCode.RightShift)) and 10 or 1) * ((u2.UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or u2.UserInputService:IsKeyDown(Enum.KeyCode.RightAlt)) and 0.1 or 1) * ((u69 == "Color3" or u69 == "Color4") and 5 or 1);
        local v72 = getValueByIndex(number.value, u68, u67.arguments) + v70 * v71;

        if u67.arguments.Min ~= nil then
            v72 = math.max(v72, getValueByIndex(u67.arguments.Min, u68, u67.arguments));
        end;

        if u67.arguments.Max ~= nil then
            v72 = math.min(v72, getValueByIndex(u67.arguments.Max, u68, u67.arguments));
        end;

        number:set(updateValueByIndex(number.value, u68, v72, u67.arguments));
        u67.lastNumberChangedTick = u1._cycleTick + 1;
    end;

    local function DragMouseDown(p73, p74, p75, p76, p77) -- Line: 566
        -- upvalues: u2 (copy), u1 (copy), u66 (ref), u67 (ref), u68 (ref), u69 (ref), updateActiveDrag (copy)
        local v78 = u2.getTime();
        local v79 = v78 - p73.lastClickedTime < u1._config.MouseDoubleClickTime;
        local v80 = u2.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or u2.UserInputService:IsKeyDown(Enum.KeyCode.RightControl);

        if v79 and (Vector2.new(p76, p77) - p73.lastClickedPosition).Magnitude < u1._config.MouseDoubleClickMaxDist or v80 then
            p73.state.editingText:set(p75);

            return;
        end;

        p73.lastClickedTime = v78;
        p73.lastClickedPosition = Vector2.new(p76, p77);
        u66 = true;
        u67 = p73;
        u68 = p75;
        u69 = p74;
        updateActiveDrag();
    end;

    u2.UserInputService.InputChanged:Connect(updateActiveDrag);
    u2.UserInputService.InputEnded:Connect(function(p81) -- Line: 599
        -- upvalues: u66 (ref), u67 (ref), u68 (ref)
        if p81.UserInputType == Enum.UserInputType.MouseButton1 and u66 then
            u66 = false;
            u67 = nil;
            u68 = 0;
        end;
    end);

    local function generateDragScalar(u82, u83, u84) -- Line: 607
        -- upvalues: u5 (copy), u2 (copy), u1 (copy), getValueByIndex (copy), updateValueByIndex (copy), DragMouseDown (copy), u21 (copy), u20 (copy)
        return {
            hasState = true,
            hasChildren = false,
            Args = {
                Text = 1,
                Increment = 2,
                Min = 3,
                Max = 4,
                Format = 5
            },
            Events = {
                numberChanged = u5,
                hovered = u2.EVENTS.hover(function(p85) -- Line: 620
                    return p85.Instance;
                end)
            },

            Generate = function(u86) -- Line: 624, Name: Generate
                -- upvalues: u82 (copy), u2 (ref), u1 (ref), u83 (copy), getValueByIndex (ref), updateValueByIndex (ref), DragMouseDown (ref)
                u86.lastClickedTime = -1;
                u86.lastClickedPosition = Vector2.zero;
                local Frame = Instance.new("Frame");
                Frame.Name = "Iris_Drag" .. u82;
                Frame.Size = UDim2.fromScale(1, 0);
                Frame.BackgroundTransparency = 1;
                Frame.BorderSizePixel = 0;
                Frame.ZIndex = u86.ZIndex;
                Frame.LayoutOrder = u86.ZIndex;
                Frame.AutomaticSize = Enum.AutomaticSize.Y;
                u2.UIListLayout(Frame, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.X));
                local v87 = 0;
                local v88 = u1._config.TextSize + 2 * u1._config.FramePadding.Y;

                if u82 == "Color3" or u82 == "Color4" then
                    v87 = v87 + (u1._config.ItemInnerSpacing.X + v88);
                    local ImageLabel = Instance.new("ImageLabel");
                    ImageLabel.Name = "ColorBox";
                    ImageLabel.BorderSizePixel = 0;
                    ImageLabel.Size = UDim2.fromOffset(v88, v88);
                    ImageLabel.ZIndex = u86.ZIndex + 5;
                    ImageLabel.LayoutOrder = u86.ZIndex + 5;
                    ImageLabel.Image = u2.ICONS.ALPHA_BACKGROUND_TEXTURE;
                    ImageLabel.ImageTransparency = 1;
                    u2.applyFrameStyle(ImageLabel, true, true);
                    ImageLabel.Parent = Frame;
                end;

                local v89 = UDim.new(u1._config.ContentWidth.Scale / u83, (u1._config.ContentWidth.Offset - u1._config.ItemInnerSpacing.X * (u83 - 1) - v87) / u83);
                local v90 = UDim.new(v89.Scale * (u83 - 1), v89.Offset * (u83 - 1) + u1._config.ItemInnerSpacing.X * (u83 - 1) + v87);
                local v91 = u1._config.ContentWidth - v90;

                for i = 1, u83 do
                    local TextButton = Instance.new("TextButton");
                    TextButton.Name = "DragField" .. tostring(i);
                    TextButton.ZIndex = u86.ZIndex + i;
                    TextButton.LayoutOrder = u86.ZIndex + i;

                    if i == u83 then
                        TextButton.Size = UDim2.new(v91, UDim.new());
                    else
                        TextButton.Size = UDim2.new(v89, UDim.new());
                    end;

                    TextButton.AutomaticSize = Enum.AutomaticSize.Y;
                    TextButton.BackgroundColor3 = u1._config.FrameBgColor;
                    TextButton.BackgroundTransparency = u1._config.FrameBgTransparency;
                    TextButton.AutoButtonColor = false;
                    TextButton.Text = "";
                    TextButton.ClipsDescendants = true;
                    u2.applyFrameStyle(TextButton);
                    u2.applyTextStyle(TextButton);
                    u2.UISizeConstraint(TextButton, Vector2.new(1, 0));
                    TextButton.TextXAlignment = Enum.TextXAlignment.Center;
                    TextButton.Parent = Frame;
                    u2.applyInteractionHighlights(TextButton, TextButton, {
                        ButtonColor = u1._config.FrameBgColor,
                        ButtonTransparency = u1._config.FrameBgTransparency,
                        ButtonHoveredColor = u1._config.FrameBgHoveredColor,
                        ButtonHoveredTransparency = u1._config.FrameBgHoveredTransparency,
                        ButtonActiveColor = u1._config.FrameBgActiveColor,
                        ButtonActiveTransparency = u1._config.FrameBgActiveTransparency
                    });
                    local TextBox = Instance.new("TextBox");
                    TextBox.Name = "InputField";
                    TextBox.ZIndex = u86.ZIndex + 5;
                    TextBox.LayoutOrder = u86.ZIndex + 2;
                    TextBox.Size = UDim2.new(1, 0, 1, 0);
                    TextBox.BackgroundTransparency = 1;
                    TextBox.ClearTextOnFocus = false;
                    TextBox.TextTruncate = Enum.TextTruncate.AtEnd;
                    TextBox.ClipsDescendants = true;
                    TextBox.Visible = false;
                    u2.applyFrameStyle(TextBox, true);
                    u2.applyTextStyle(TextBox);
                    TextBox.Parent = TextButton;
                    TextBox.FocusLost:Connect(function() -- Line: 732
                        -- upvalues: TextBox (copy), u86 (copy), u82 (ref), i (copy), getValueByIndex (ref), updateValueByIndex (ref), u1 (ref)
                        local v92 = tonumber(TextBox.Text:match("-?%d*%.?%d*"));
                        local number = u86.state.number;

                        if u82 == "Color4" and i == 4 then
                            number = u86.state.transparency;
                        elseif u82 == "Color3" or u82 == "Color4" then
                            number = u86.state.color;
                        end;

                        if v92 ~= nil then
                            if u82 == "Color3" or u82 == "Color4" and not u86.arguments.UseFloats then
                                v92 = v92 / 255;
                            end;

                            if u86.arguments.Min ~= nil then
                                v92 = math.max(v92, getValueByIndex(u86.arguments.Min, i, u86.arguments));
                            end;

                            if u86.arguments.Max ~= nil then
                                v92 = math.min(v92, getValueByIndex(u86.arguments.Max, i, u86.arguments));
                            end;

                            if u86.arguments.Increment then
                                local v93 = v92 / getValueByIndex(u86.arguments.Increment, i, u86.arguments);
                                v92 = math.round(v93) * getValueByIndex(u86.arguments.Increment, i, u86.arguments);
                            end;

                            number:set(updateValueByIndex(number.value, i, v92, u86.arguments));
                            u86.lastNumberChangedTick = u1._cycleTick + 1;
                        end;

                        local v94 = getValueByIndex(number.value, i, u86.arguments);

                        if u82 == "Color3" or u82 == "Color4" and not u86.arguments.UseFloats then
                            v94 = math.round(v94 * 255);
                        end;

                        local v95 = u86.arguments.Format[i] or u86.arguments.Format[1];

                        if u86.arguments.Prefix then
                            v95 = u86.arguments.Prefix[i] .. v95;
                        end;

                        TextBox.Text = string.format(v95, v94);
                        u86.state.editingText:set(0);
                        TextBox:ReleaseFocus(true);
                    end);
                    TextBox.Focused:Connect(function() -- Line: 794
                        -- upvalues: TextBox (copy), u86 (copy), i (copy)
                        TextBox.CursorPosition = #TextBox.Text + 1;
                        TextBox.SelectionStart = 1;
                        u86.state.editingText:set(i);
                    end);
                    TextButton.MouseButton1Down:Connect(function(p96, p97) -- Line: 802
                        -- upvalues: DragMouseDown (ref), u86 (copy), u82 (ref), i (copy)
                        DragMouseDown(u86, u82, i, p96, p97);
                    end);
                end;

                local TextLabel = Instance.new("TextLabel");
                TextLabel.Name = "TextLabel";
                TextLabel.Size = UDim2.fromOffset(0, v88);
                TextLabel.BackgroundTransparency = 1;
                TextLabel.BorderSizePixel = 0;
                TextLabel.ZIndex = u86.ZIndex + 5;
                TextLabel.LayoutOrder = u86.ZIndex + 5;
                TextLabel.AutomaticSize = Enum.AutomaticSize.X;
                u2.applyTextStyle(TextLabel);
                TextLabel.Parent = Frame;

                return Frame;
            end,

            Update = function(p98) -- Line: 822, Name: Update
                -- upvalues: u82 (copy), u83 (copy), u21 (ref), getValueByIndex (ref), u20 (ref)
                p98.Instance.TextLabel.Text = p98.arguments.Text or `Drag {u82}`;

                if p98.arguments.Format and typeof(p98.arguments.Format) ~= "table" then
                    p98.arguments.Format = { p98.arguments.Format };

                    return;
                end;

                if not p98.arguments.Format then
                    local v99 = {};

                    for i = 1, u83 do
                        local v100 = u21[u82][i];

                        if p98.arguments.Increment then
                            local v101 = getValueByIndex(p98.arguments.Increment, i, p98.arguments);
                            local v102 = -math.log10(v101 == 0 and 1 or v101);
                            local v103 = math.ceil(v102);
                            v100 = math.max(v100, v103, v100);
                        end;

                        if p98.arguments.Max then
                            local v104 = getValueByIndex(p98.arguments.Max, i, p98.arguments);
                            local v105 = -math.log10(v104 == 0 and 1 or v104);
                            local v106 = math.ceil(v105);
                            v100 = math.max(v100, v106, v100);
                        end;

                        if p98.arguments.Min then
                            local v107 = getValueByIndex(p98.arguments.Min, i, p98.arguments);
                            local v108 = -math.log10(v107 == 0 and 1 or v107);
                            local v109 = math.ceil(v108);
                            v100 = math.max(v100, v109, v100);
                        end;

                        if v100 > 0 then
                            v99[i] = `%.{v100}f`;
                        else
                            v99[i] = "%d";
                        end;
                    end;

                    p98.arguments.Format = v99;
                    p98.arguments.Prefix = u20[u82];
                end;
            end,

            Discard = function(p110) -- Line: 865, Name: Discard
                -- upvalues: u2 (ref)
                p110.Instance:Destroy();
                u2.discardState(p110);
            end,

            GenerateState = function(p111) -- Line: 869, Name: GenerateState
                -- upvalues: u1 (ref), u84 (copy)
                if p111.state.number == nil then
                    p111.state.number = u1._widgetState(p111, "number", u84);
                end;

                if p111.state.editingText == nil then
                    p111.state.editingText = u1._widgetState(p111, "editingText", false);
                end;
            end,

            UpdateState = function(p112) -- Line: 877, Name: UpdateState
                -- upvalues: u83 (copy), u82 (copy), getValueByIndex (ref), u1 (ref)
                local Instance2 = p112.Instance;

                for i = 1, u83 do
                    local number = p112.state.number;

                    if u82 == "Color3" or u82 == "Color4" then
                        number = p112.state.color;

                        if i == 4 then
                            number = p112.state.transparency;
                        end;
                    end;

                    local v113 = Instance2:FindFirstChild("DragField" .. tostring(i));
                    local InputField = v113.InputField;
                    local v114 = getValueByIndex(number.value, i, p112.arguments);

                    if (u82 == "Color3" or u82 == "Color4") and not p112.arguments.UseFloats then
                        v114 = math.round(v114 * 255);
                    end;

                    local v115 = p112.arguments.Format[i] or p112.arguments.Format[1];

                    if p112.arguments.Prefix then
                        v115 = p112.arguments.Prefix[i] .. v115;
                    end;

                    v113.Text = string.format(v115, v114);
                    InputField.Text = tostring(v114);

                    if p112.state.editingText.value == i then
                        InputField.Visible = true;
                        InputField:CaptureFocus();
                        v113.TextTransparency = 1;
                    else
                        InputField.Visible = false;
                        v113.TextTransparency = u1._config.TextTransparency;
                    end;
                end;

                if u82 == "Color3" or u82 == "Color4" then
                    local ColorBox = Instance2.ColorBox;
                    ColorBox.BackgroundColor3 = p112.state.color.value;

                    if u82 == "Color4" then
                        ColorBox.ImageTransparency = 1 - p112.state.transparency.value;
                    end;
                end;
            end
        };
    end;

    local function generateColorDragScalar(u116, ...) -- Line: 925
        -- upvalues: generateDragScalar (ref), u2 (copy), u20 (copy), u1 (copy)
        local u117 = { ... };
        local v118 = generateDragScalar(u116, u116 == "Color4" and 4 or 3, u117[1]);

        return u2.extend(v118, {
            Args = {
                Text = 1,
                UseFloats = 2,
                UseHSV = 3,
                Format = 4
            },

            Update = function(p119) -- Line: 937, Name: Update
                -- upvalues: u116 (copy), u20 (ref), u1 (ref)
                p119.Instance.TextLabel.Text = p119.arguments.Text or `Drag {u116}`;

                if p119.arguments.Format and typeof(p119.arguments.Format) ~= "table" then
                    p119.arguments.Format = { p119.arguments.Format };
                else
                    if p119.arguments.UseFloats then
                        p119.arguments.Format = { "%.3f" };
                    else
                        p119.arguments.Format = { "%d" };
                    end;

                    p119.arguments.Prefix = u20[u116 .. (p119.arguments.UseHSV and "_HSV" or "_RGB")];
                end;

                p119.arguments.Min = { 0, 0, 0, 0 };
                p119.arguments.Max = { 1, 1, 1, 1 };
                p119.arguments.Increment = { 0.001, 0.001, 0.001, 0.001 };

                if p119.state then
                    u1._widgets[p119.type].UpdateState(p119);
                end;
            end,

            GenerateState = function(p120) -- Line: 965, Name: GenerateState
                -- upvalues: u1 (ref), u117 (copy), u116 (copy)
                if p120.state.color == nil then
                    p120.state.color = u1._widgetState(p120, "color", u117[1]);
                end;

                if u116 == "Color4" and p120.state.transparency == nil then
                    p120.state.transparency = u1._widgetState(p120, "transparency", u117[2]);
                end;

                if p120.state.editingText == nil then
                    p120.state.editingText = u1._widgetState(p120, "editingText", false);
                end;
            end
        });
    end;

    local u121 = false;
    local u122 = nil;
    local u123 = 0;
    local u124 = "";

    local function updateActiveSlider() -- Line: 994
        -- upvalues: u121 (ref), u122 (ref), u123 (ref), getValueByIndex (copy), u17 (copy), u124 (ref), u18 (copy), u19 (copy), u1 (copy), u2 (copy), updateValueByIndex (copy)
        if u121 == false then
            return;
        end;

        if u122 == nil then
            return;
        end;

        local v125 = u122.Instance:FindFirstChild("SliderField" .. tostring(u123));
        local v126 = u122.arguments.Increment and getValueByIndex(u122.arguments.Increment, u123, u122.arguments) or u17[u124][u123];
        local v127 = u122.arguments.Min and getValueByIndex(u122.arguments.Min, u123, u122.arguments) or u18[u124][u123];
        local v128 = u122.arguments.Max and getValueByIndex(u122.arguments.Max, u123, u122.arguments) or u19[u124][u123];
        local X = u1._config.FramePadding.X;
        local v129 = math.floor(((v126 < 1 and 0 or 1) + v128 - v127) / v126);
        local v130 = (u2.getMouseLocation().X - (v125.AbsolutePosition.X + X)) / (v125.AbsoluteSize.X - X * 2) * v129;
        local v131 = math.floor(v130) * v126 + v127;
        local v132 = math.clamp(v131, v127, v128);
        u122.state.number:set(updateValueByIndex(u122.state.number.value, u123, v132, u122.arguments));
        u122.lastNumberChangedTick = u1._cycleTick + 1;
    end;

    local function SliderMouseDown(p133, p134, p135) -- Line: 1030
        -- upvalues: u2 (copy), u121 (ref), u122 (ref), u123 (ref), u124 (ref), updateActiveSlider (copy)
        if u2.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or u2.UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
            p133.state.editingText:set(p135);

            return;
        end;

        u121 = true;
        u122 = p133;
        u123 = p135;
        u124 = p134;
        updateActiveSlider();
    end;

    u2.UserInputService.InputChanged:Connect(updateActiveSlider);
    u2.UserInputService.InputEnded:Connect(function(p136) -- Line: 1046
        -- upvalues: u121 (ref), u122 (ref), u123 (ref), u124 (ref)
        if p136.UserInputType == Enum.UserInputType.MouseButton1 and u121 then
            u121 = false;
            u122 = nil;
            u123 = 0;
            u124 = "";
        end;
    end);

    local function generateSliderScalar(u137, u138, u139, ...) -- Line: 1055
        -- upvalues: u5 (copy), u2 (copy), u1 (copy), getValueByIndex (copy), updateValueByIndex (copy), SliderMouseDown (copy), u21 (copy), u20 (copy), u17 (copy), u18 (copy), u19 (copy)
        return {
            hasState = true,
            hasChildren = false,
            Args = {
                Text = 1,
                Increment = 2,
                Min = 3,
                Max = 4,
                Format = 5
            },
            Events = {
                numberChanged = u5,
                hovered = u2.EVENTS.hover(function(p140) -- Line: 1068
                    return p140.Instance;
                end)
            },

            Generate = function(u141) -- Line: 1072, Name: Generate
                -- upvalues: u137 (copy), u2 (ref), u1 (ref), u138 (copy), getValueByIndex (ref), updateValueByIndex (ref), SliderMouseDown (ref)
                local Frame = Instance.new("Frame");
                Frame.Name = "Iris_Slider" .. u137;
                Frame.Size = UDim2.fromScale(1, 0);
                Frame.BackgroundTransparency = 1;
                Frame.BorderSizePixel = 0;
                Frame.ZIndex = u141.ZIndex;
                Frame.LayoutOrder = u141.ZIndex;
                Frame.AutomaticSize = Enum.AutomaticSize.Y;
                u2.UIListLayout(Frame, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.X));
                local v142 = u1._config.TextSize + 2 * u1._config.FramePadding.Y;
                local v143 = UDim.new(u1._config.ContentWidth.Scale / u138, (u1._config.ContentWidth.Offset - u1._config.ItemInnerSpacing.X * (u138 - 1)) / u138);
                local v144 = UDim.new(v143.Scale * (u138 - 1), v143.Offset * (u138 - 1) + u1._config.ItemInnerSpacing.X * (u138 - 1));
                local v145 = u1._config.ContentWidth - v144;

                for i = 1, u138 do
                    local TextButton = Instance.new("TextButton");
                    TextButton.Name = "SliderField" .. tostring(i);
                    TextButton.ZIndex = u141.ZIndex + i;
                    TextButton.LayoutOrder = u141.ZIndex + i;

                    if i == u138 then
                        TextButton.Size = UDim2.new(v145, UDim.new());
                    else
                        TextButton.Size = UDim2.new(v143, UDim.new());
                    end;

                    TextButton.AutomaticSize = Enum.AutomaticSize.Y;
                    TextButton.BackgroundColor3 = u1._config.FrameBgColor;
                    TextButton.BackgroundTransparency = u1._config.FrameBgTransparency;
                    TextButton.AutoButtonColor = false;
                    TextButton.Text = "";
                    TextButton.ClipsDescendants = true;
                    u2.applyFrameStyle(TextButton);
                    u2.applyTextStyle(TextButton);
                    u2.UISizeConstraint(TextButton, Vector2.new(1, 0));
                    TextButton.Parent = Frame;
                    local TextLabel = Instance.new("TextLabel");
                    TextLabel.Name = "OverlayText";
                    TextLabel.Size = UDim2.fromScale(1, 1);
                    TextLabel.BackgroundTransparency = 1;
                    TextLabel.BorderSizePixel = 0;
                    TextLabel.ZIndex = u141.ZIndex + 10;
                    TextLabel.ClipsDescendants = true;
                    u2.applyTextStyle(TextLabel);
                    TextLabel.TextXAlignment = Enum.TextXAlignment.Center;
                    TextLabel.Parent = TextButton;
                    u2.applyInteractionHighlights(TextButton, TextButton, {
                        ButtonColor = u1._config.FrameBgColor,
                        ButtonTransparency = u1._config.FrameBgTransparency,
                        ButtonHoveredColor = u1._config.FrameBgHoveredColor,
                        ButtonHoveredTransparency = u1._config.FrameBgHoveredTransparency,
                        ButtonActiveColor = u1._config.FrameBgActiveColor,
                        ButtonActiveTransparency = u1._config.FrameBgActiveTransparency
                    });
                    local TextBox = Instance.new("TextBox");
                    TextBox.Name = "InputField";
                    TextBox.ZIndex = u141.ZIndex + 5;
                    TextBox.LayoutOrder = u141.ZIndex + 2;
                    TextBox.Size = UDim2.new(1, 0, 1, 0);
                    TextBox.BackgroundTransparency = 1;
                    TextBox.ClearTextOnFocus = false;
                    TextBox.TextTruncate = Enum.TextTruncate.AtEnd;
                    TextBox.ClipsDescendants = true;
                    TextBox.Visible = false;
                    u2.applyFrameStyle(TextBox, true);
                    u2.applyTextStyle(TextBox);
                    TextBox.Parent = TextButton;
                    TextBox.FocusLost:Connect(function() -- Line: 1166
                        -- upvalues: TextBox (copy), u141 (copy), getValueByIndex (ref), i (copy), updateValueByIndex (ref), u1 (ref)
                        local v146 = tonumber(TextBox.Text:match("-?%d*%.?%d*"));

                        if v146 ~= nil then
                            if u141.arguments.Min ~= nil then
                                v146 = math.max(v146, getValueByIndex(u141.arguments.Min, i, u141.arguments));
                            end;

                            if u141.arguments.Max ~= nil then
                                v146 = math.min(v146, getValueByIndex(u141.arguments.Max, i, u141.arguments));
                            end;

                            if u141.arguments.Increment then
                                local v147 = v146 / getValueByIndex(u141.arguments.Increment, i, u141.arguments);
                                v146 = math.round(v147) * getValueByIndex(u141.arguments.Increment, i, u141.arguments);
                            end;

                            u141.state.number:set(updateValueByIndex(u141.state.number.value, i, v146, u141.arguments));
                            u141.lastNumberChangedTick = u1._cycleTick + 1;
                        end;

                        local v148 = u141.arguments.Format[i] or u141.arguments.Format[1];

                        if u141.arguments.Prefix then
                            v148 = u141.arguments.Prefix[i] .. v148;
                        end;

                        TextBox.Text = string.format(v148, getValueByIndex(u141.state.number.value, i, u141.arguments));
                        u141.state.editingText:set(0);
                        TextBox:ReleaseFocus(true);
                    end);
                    TextBox.Focused:Connect(function() -- Line: 1222
                        -- upvalues: TextBox (copy), u141 (copy), i (copy)
                        TextBox.CursorPosition = #TextBox.Text + 1;
                        TextBox.SelectionStart = 1;
                        u141.state.editingText:set(i);
                    end);
                    TextButton.MouseButton1Down:Connect(function() -- Line: 1230
                        -- upvalues: SliderMouseDown (ref), u141 (copy), u137 (ref), i (copy)
                        SliderMouseDown(u141, u137, i);
                    end);
                    local Frame2 = Instance.new("Frame");
                    Frame2.Name = "GrabBar";
                    Frame2.ZIndex = u141.ZIndex + 5;
                    Frame2.LayoutOrder = u141.ZIndex + 5;
                    Frame2.AnchorPoint = Vector2.new(0, 0.5);
                    Frame2.Position = UDim2.new(0, 0, 0.5, 0);
                    Frame2.BorderSizePixel = 0;
                    Frame2.BackgroundColor3 = u1._config.SliderGrabColor;
                    Frame2.Transparency = u1._config.SliderGrabTransparency;

                    if u1._config.GrabRounding > 0 then
                        u2.UICorner(Frame2, u1._config.GrabRounding);
                    end;

                    Frame2.Parent = TextButton;
                end;

                local TextLabel = Instance.new("TextLabel");
                TextLabel.Name = "TextLabel";
                TextLabel.Size = UDim2.fromOffset(0, v142);
                TextLabel.BackgroundTransparency = 1;
                TextLabel.BorderSizePixel = 0;
                TextLabel.ZIndex = u141.ZIndex + 5;
                TextLabel.LayoutOrder = u141.ZIndex + 5;
                TextLabel.AutomaticSize = Enum.AutomaticSize.X;
                u2.applyTextStyle(TextLabel);
                TextLabel.Parent = Frame;

                return Frame;
            end,

            Update = function(p149) -- Line: 1265, Name: Update
                -- upvalues: u137 (copy), u138 (copy), u21 (ref), getValueByIndex (ref), u20 (ref), u17 (ref), u18 (ref), u19 (ref), u1 (ref)
                local Instance2 = p149.Instance;
                Instance2.TextLabel.Text = p149.arguments.Text or `Slider {u137}`;

                if p149.arguments.Format and typeof(p149.arguments.Format) ~= "table" then
                    p149.arguments.Format = { p149.arguments.Format };
                else
                    local v150 = {};

                    for i = 1, u138 do
                        local v151 = u21[u137][i];

                        if p149.arguments.Increment then
                            local v152 = getValueByIndex(p149.arguments.Increment, i, p149.arguments);
                            local v153 = -math.log10(v152 == 0 and 1 or v152);
                            local v154 = math.ceil(v153);
                            v151 = math.max(v151, v154, v151);
                        end;

                        if p149.arguments.Max then
                            local v155 = getValueByIndex(p149.arguments.Max, i, p149.arguments);
                            local v156 = -math.log10(v155 == 0 and 1 or v155);
                            local v157 = math.ceil(v156);
                            v151 = math.max(v151, v157, v151);
                        end;

                        if p149.arguments.Min then
                            local v158 = getValueByIndex(p149.arguments.Min, i, p149.arguments);
                            local v159 = -math.log10(v158 == 0 and 1 or v158);
                            local v160 = math.ceil(v159);
                            v151 = math.max(v151, v160, v151);
                        end;

                        if v151 > 0 then
                            v150[i] = `%.{v151}f`;
                        else
                            v150[i] = "%d";
                        end;
                    end;

                    p149.arguments.Format = v150;
                    p149.arguments.Prefix = u20[u137];
                end;

                for i = 1, u138 do
                    local v161 = Instance2:FindFirstChild("SliderField" .. tostring(i));
                    local GrabBar = v161.GrabBar;
                    local v162 = p149.arguments.Increment and getValueByIndex(p149.arguments.Increment, i, p149.arguments) or u17[u137][i];
                    local v163 = p149.arguments.Min and getValueByIndex(p149.arguments.Min, i, p149.arguments) or u18[u137][i];
                    local v164 = p149.arguments.Max and getValueByIndex(p149.arguments.Max, i, p149.arguments) or u19[u137][i];
                    local v165 = 1 / math.floor((v164 + 1 - v163) / v162);
                    local v166 = math.max(v165, u1._config.GrabMinSize / v161.AbsoluteSize.X);
                    GrabBar.Size = UDim2.new(v166, 0, 1, 0);
                end;
            end,

            Discard = function(p167) -- Line: 1330, Name: Discard
                -- upvalues: u2 (ref)
                p167.Instance:Destroy();
                u2.discardState(p167);
            end,

            GenerateState = function(p168) -- Line: 1334, Name: GenerateState
                -- upvalues: u1 (ref), u139 (copy)
                if p168.state.number == nil then
                    p168.state.number = u1._widgetState(p168, "number", u139);
                end;

                if p168.state.editingText == nil then
                    p168.state.editingText = u1._widgetState(p168, "editingText", false);
                end;
            end,

            UpdateState = function(p169) -- Line: 1342, Name: UpdateState
                -- upvalues: u138 (copy), getValueByIndex (ref), u17 (ref), u137 (copy), u18 (ref), u19 (ref), u1 (ref)
                local Instance2 = p169.Instance;

                for i = 1, u138 do
                    local v170 = Instance2:FindFirstChild("SliderField" .. tostring(i));
                    local InputField = v170.InputField;
                    local OverlayText = v170.OverlayText;
                    local GrabBar = v170.GrabBar;
                    local v171 = getValueByIndex(p169.state.number.value, i, p169.arguments);
                    local v172 = p169.arguments.Format[i] or p169.arguments.Format[1];

                    if p169.arguments.Prefix then
                        v172 = p169.arguments.Prefix[i] .. v172;
                    end;

                    OverlayText.Text = string.format(v172, v171);
                    InputField.Text = tostring(v171);
                    local v173 = p169.arguments.Increment and getValueByIndex(p169.arguments.Increment, i, p169.arguments) or u17[u137][i];
                    local v174 = p169.arguments.Min and getValueByIndex(p169.arguments.Min, i, p169.arguments) or u18[u137][i];
                    local v175 = p169.arguments.Max and getValueByIndex(p169.arguments.Max, i, p169.arguments) or u19[u137][i];
                    local X = u1._config.FramePadding.X;
                    local v176 = math.floor(((v173 < 1 and 0 or 1) + v175 - v174) / v173);
                    local v177 = 1 - GrabBar.AbsoluteSize.X / (v170.AbsoluteSize.X - X * 2);
                    local v178 = math.floor((v171 - v174) / (v175 - v174) * v176) / v176;
                    local v179 = math.clamp(v178, 0, v177);
                    GrabBar.Position = UDim2.new(v179, 0, 0.5, 0);

                    if p169.state.editingText.value == i then
                        InputField.Visible = true;
                        OverlayText.Visible = false;
                        GrabBar.Visible = false;
                        InputField:CaptureFocus();
                    else
                        InputField.Visible = false;
                        OverlayText.Visible = true;
                        GrabBar.Visible = true;
                    end;
                end;
            end
        };
    end;

    local function generateEnumSliderScalar(u180, u181) -- Line: 1399
        -- upvalues: generateSliderScalar (ref), u2 (copy), u1 (copy)
        local v182 = generateSliderScalar("Enum", 1, u181.Value);
        local v183 = { string };

        for _, v in u180:GetEnumItems() do
            v183[v.Value] = v.Name;
        end;

        return u2.extend(v182, {
            Args = {
                Text = 1
            },

            Update = function(p184) -- Line: 1411, Name: Update
                -- upvalues: u180 (copy), u1 (ref)
                local Instance2 = p184.Instance;
                Instance2.TextLabel.Text = p184.arguments.Text or "Input Enum";
                p184.arguments.Increment = 1;
                p184.arguments.Min = 0;
                p184.arguments.Max = #u180:GetEnumItems() - 1;
                local SliderField1 = Instance2:FindFirstChild("SliderField1");
                local GrabBar = SliderField1.GrabBar;
                local v185 = #u180:GetEnumItems();
                local v186 = 1 / math.floor(v185);
                local v187 = math.max(v186, u1._config.GrabMinSize / SliderField1.AbsoluteSize.X);
                GrabBar.Size = UDim2.new(v187, 0, 1, 0);
            end,

            GenerateState = function(p188) -- Line: 1430, Name: GenerateState
                -- upvalues: u1 (ref), u181 (copy)
                if p188.state.number == nil then
                    p188.state.number = u1._widgetState(p188, "number", u181.Value);
                end;

                if p188.state.enumItem == nil then
                    p188.state.enumItem = u1._widgetState(p188, "enumItem", u181);
                end;

                if p188.state.editingText == nil then
                    p188.state.editingText = u1._widgetState(p188, "editingText", false);
                end;
            end
        });
    end;

    local v189 = generateInputScalar("Num", 1, 0);
    v189.Args.NoButtons = 6;
    u1.WidgetConstructor("InputNum", v189);
    u1.WidgetConstructor("InputVector2", generateInputScalar("Vector2", 2, Vector2.zero));
    u1.WidgetConstructor("InputVector3", generateInputScalar("Vector3", 3, Vector3.new(0, 0, 0)));
    u1.WidgetConstructor("InputUDim", generateInputScalar("UDim", 2, UDim.new()));
    u1.WidgetConstructor("InputUDim2", generateInputScalar("UDim2", 4, UDim2.new()));
    u1.WidgetConstructor("InputRect", generateInputScalar("Rect", 4, Rect.new(0, 0, 0, 0)));
    u1.WidgetConstructor("DragNum", generateDragScalar("Num", 1, 0));
    u1.WidgetConstructor("DragVector2", generateDragScalar("Vector2", 2, Vector2.zero));
    u1.WidgetConstructor("DragVector3", generateDragScalar("Vector3", 3, Vector3.new(0, 0, 0)));
    u1.WidgetConstructor("DragUDim", generateDragScalar("UDim", 2, UDim.new()));
    u1.WidgetConstructor("DragUDim2", generateDragScalar("UDim2", 4, UDim2.new()));
    u1.WidgetConstructor("DragRect", generateDragScalar("Rect", 4, Rect.new(0, 0, 0, 0)));
    u1.WidgetConstructor("InputColor3", generateColorDragScalar("Color3", Color3.fromRGB(0, 0, 0)));
    u1.WidgetConstructor("InputColor4", generateColorDragScalar("Color4", Color3.fromRGB(0, 0, 0), 0));
    u1.WidgetConstructor("SliderNum", generateSliderScalar("Num", 1, 0));
    u1.WidgetConstructor("SliderVector2", generateSliderScalar("Vector2", 2, Vector2.zero));
    u1.WidgetConstructor("SliderVector3", generateSliderScalar("Vector3", 3, Vector3.new(0, 0, 0)));
    u1.WidgetConstructor("SliderUDim", generateSliderScalar("UDim", 2, UDim.new()));
    u1.WidgetConstructor("SliderUDim2", generateSliderScalar("UDim2", 4, UDim2.new()));
    u1.WidgetConstructor("SliderRect", generateSliderScalar("Rect", 4, Rect.new(0, 0, 0, 0)));
    u1.WidgetConstructor("InputText", {
        hasState = true,
        hasChildren = false,
        Args = {
            Text = 1,
            TextHint = 2
        },
        Events = {
            textChanged = {
                Init = function(p190) -- Line: 1485
                    p190.lastTextchangeTick = 0;
                end,

                Get = function(p191) -- Line: 1488
                    -- upvalues: u1 (copy)
                    return p191.lastTextchangeTick == u1._cycleTick;
                end
            },
            hovered = u2.EVENTS.hover(function(p192) -- Line: 1492
                return p192.Instance;
            end)
        },

        Generate = function(u193) -- Line: 1496, Name: Generate
            -- upvalues: u1 (copy), u2 (copy)
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_InputText";
            Frame.Size = UDim2.new(u1._config.ContentWidth, UDim.new(0, 0));
            Frame.BackgroundTransparency = 1;
            Frame.BorderSizePixel = 0;
            Frame.ZIndex = u193.ZIndex;
            Frame.LayoutOrder = u193.ZIndex;
            Frame.AutomaticSize = Enum.AutomaticSize.Y;
            u2.UIListLayout(Frame, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.X));
            local TextBox = Instance.new("TextBox");
            TextBox.Name = "InputField";
            TextBox.Size = UDim2.new(1, 0, 0, 0);
            TextBox.AutomaticSize = Enum.AutomaticSize.Y;
            TextBox.BackgroundColor3 = u1._config.FrameBgColor;
            TextBox.BackgroundTransparency = u1._config.FrameBgTransparency;
            TextBox.Text = "";
            TextBox.PlaceholderColor3 = u1._config.TextDisabledColor;
            TextBox.TextTruncate = Enum.TextTruncate.AtEnd;
            TextBox.ClearTextOnFocus = false;
            TextBox.ZIndex = u193.ZIndex + 1;
            TextBox.LayoutOrder = u193.ZIndex + 1;
            TextBox.ClipsDescendants = true;
            u2.applyFrameStyle(TextBox);
            u2.applyTextStyle(TextBox);
            u2.UISizeConstraint(TextBox, Vector2.new(1, 0));
            TextBox.Parent = Frame;
            TextBox.FocusLost:Connect(function() -- Line: 1532
                -- upvalues: u193 (copy), TextBox (copy), u1 (ref)
                u193.state.text:set(TextBox.Text);
                u193.lastTextchangeTick = u1._cycleTick + 1;
            end);
            local v194 = u1._config.TextSize + u1._config.FramePadding.Y * 2;
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "TextLabel";
            TextLabel.Size = UDim2.fromOffset(0, v194);
            TextLabel.AutomaticSize = Enum.AutomaticSize.X;
            TextLabel.BackgroundTransparency = 1;
            TextLabel.BorderSizePixel = 0;
            TextLabel.ZIndex = u193.ZIndex + 4;
            TextLabel.LayoutOrder = u193.ZIndex + 4;
            u2.applyTextStyle(TextLabel);
            TextLabel.Parent = Frame;

            return Frame;
        end,

        Update = function(p195) -- Line: 1554, Name: Update
            local Instance2 = p195.Instance;
            local InputField = Instance2.InputField;
            Instance2.TextLabel.Text = p195.arguments.Text or "Input Text";
            InputField.PlaceholderText = p195.arguments.TextHint or "";
        end,

        Discard = function(p196) -- Line: 1562, Name: Discard
            -- upvalues: u2 (copy)
            p196.Instance:Destroy();
            u2.discardState(p196);
        end,

        GenerateState = function(p197) -- Line: 1566, Name: GenerateState
            -- upvalues: u1 (copy)
            if p197.state.text == nil then
                p197.state.text = u1._widgetState(p197, "text", "");
            end;
        end,

        UpdateState = function(p198) -- Line: 1571, Name: UpdateState
            p198.Instance.InputField.Text = p198.state.text.value;
        end
    });
end;