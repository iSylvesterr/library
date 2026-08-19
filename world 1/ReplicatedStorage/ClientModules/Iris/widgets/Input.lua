-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(u1, u2) -- Line: 6
    local u5 = {
        Init = function(p3) -- Line: 8
        end,

        Get = function(p4) -- Line: 9
            -- upvalues: u1 (copy)
            return p4.lastNumberChangedTick == u1._cycleTick;
        end
    };

    local function getValueByIndex(p6, p7, p8) -- Line: 14
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
            local v9;

            if p8.UseHSV then
                v9 = { p6:ToHSV() };
            else
                v9 = { p6.R, p6.G, p6.B };
            end;

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

        error((`Incorrect datatype or value: {p6} {typeof(p6)} {p7}.`));
    end;

    local function updateValueByIndex(p10, p11, p12, p13) -- Line: 74
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

        error((`Incorrect datatype or value {p10} {typeof(p10)} {p11}.`));
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

    local function generateAbstract(u22, u23, u24, u25) -- Line: 194
        -- upvalues: u5 (copy), u2 (copy), u1 (copy), u21 (copy), getValueByIndex (copy), u20 (copy), u17 (copy), u18 (copy), u19 (copy)
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
                hovered = u2.EVENTS.hover(function(p26) -- Line: 207
                    return p26.Instance;
                end)
            },

            GenerateState = function(p27) -- Line: 211, Name: GenerateState
                -- upvalues: u1 (ref), u25 (copy)
                if p27.state.number == nil then
                    p27.state.number = u1._widgetState(p27, "number", u25);
                end;

                if p27.state.editingText == nil then
                    p27.state.editingText = u1._widgetState(p27, "editingText", 0);
                end;
            end,

            Update = function(u28) -- Line: 219, Name: Update
                -- upvalues: u23 (copy), u24 (copy), u21 (ref), getValueByIndex (ref), u20 (ref), u22 (copy), u1 (ref), u17 (ref), u18 (ref), u19 (ref)
                local Instance2 = u28.Instance;
                Instance2.TextLabel.Text = u28.arguments.Text or `Input {u23}`;

                if u28.arguments.Format and typeof(u28.arguments.Format) ~= "table" then
                    u28.arguments.Format = { u28.arguments.Format };
                elseif not u28.arguments.Format then
                    local v29 = {};

                    for i = 1, u24 do
                        local v30 = u21[u23][i];

                        if u28.arguments.Increment then
                            local v31 = getValueByIndex(u28.arguments.Increment, i, u28.arguments);
                            local v32 = -math.log10(v31 == 0 and 1 or v31);
                            local v33 = math.ceil(v32);
                            v30 = math.max(v30, v33, v30);
                        end;

                        if u28.arguments.Max then
                            local v34 = getValueByIndex(u28.arguments.Max, i, u28.arguments);
                            local v35 = -math.log10(v34 == 0 and 1 or v34);
                            local v36 = math.ceil(v35);
                            v30 = math.max(v30, v36, v30);
                        end;

                        if u28.arguments.Min then
                            local v37 = getValueByIndex(u28.arguments.Min, i, u28.arguments);
                            local v38 = -math.log10(v37 == 0 and 1 or v37);
                            local v39 = math.ceil(v38);
                            v30 = math.max(v30, v39, v30);
                        end;

                        if v30 > 0 then
                            v29[i] = `%.{v30}f`;
                        else
                            v29[i] = "%d";
                        end;
                    end;

                    u28.arguments.Format = v29;
                    u28.arguments.Prefix = u20[u23];
                end;

                if u22 == "Input" and u23 == "Num" then
                    Instance2.SubButton.Visible = not u28.arguments.NoButtons;
                    Instance2.AddButton.Visible = not u28.arguments.NoButtons;
                    Instance2.InputField1.Size = UDim2.new(UDim.new(u1._config.ContentWidth.Scale, u1._config.ContentWidth.Offset - (u28.arguments.NoButtons and 0 or 2 * u1._config.ItemInnerSpacing.X + 2 * (u1._config.TextSize + 2 * u1._config.FramePadding.Y))), u1._config.ContentHeight);
                end;

                if u22 == "Slider" then
                    for i = 1, u24 do
                        local GrabBar = Instance2:FindFirstChild("SliderField" .. tostring(i)).GrabBar;
                        local v40 = u28.arguments.Increment and getValueByIndex(u28.arguments.Increment, i, u28.arguments) or u17[u23][i];
                        local v41 = u28.arguments.Min and getValueByIndex(u28.arguments.Min, i, u28.arguments) or u18[u23][i];
                        local v42 = u28.arguments.Max and getValueByIndex(u28.arguments.Max, i, u28.arguments) or u19[u23][i];
                        local v43 = 1 / math.floor((1 + v42 - v41) / v40);
                        GrabBar.Size = UDim2.fromScale(v43, 1);
                    end;

                    local u44 = #u1._postCycleCallbacks + 1;
                    local u45 = u1._cycleTick + 1;

                    u1._postCycleCallbacks[u44] = function() -- Line: 288
                        -- upvalues: u1 (ref), u45 (copy), u28 (copy), u23 (ref), u44 (copy)
                        if u45 <= u1._cycleTick then
                            if u28.lastCycleTick ~= -1 then
                                u28.state.number.lastChangeTick = u1._cycleTick;
                                u1._widgets[`Slider{u23}`].UpdateState(u28);
                            end;

                            u1._postCycleCallbacks[u44] = nil;
                        end;
                    end;
                end;
            end,

            Discard = function(p46) -- Line: 299, Name: Discard
                -- upvalues: u2 (ref)
                p46.Instance:Destroy();
                u2.discardState(p46);
            end
        };
    end;

    local function focusLost(p47, p48, p49, p50) -- Line: 306
        -- upvalues: getValueByIndex (copy), updateValueByIndex (copy), u1 (copy)
        local v51 = tonumber(p48.Text:match("-?%d*%.?%d*"));
        local number = p47.state.number;

        if p50 == "Color4" and p49 == 4 then
            number = p47.state.transparency;
        elseif p50 == "Color3" or p50 == "Color4" then
            number = p47.state.color;
        end;

        if v51 ~= nil then
            if p50 == "Color3" or p50 == "Color4" and not p47.arguments.UseFloats then
                v51 = v51 / 255;
            end;

            if p47.arguments.Min ~= nil then
                v51 = math.max(v51, getValueByIndex(p47.arguments.Min, p49, p47.arguments));
            end;

            if p47.arguments.Max ~= nil then
                v51 = math.min(v51, getValueByIndex(p47.arguments.Max, p49, p47.arguments));
            end;

            if p47.arguments.Increment then
                local v52 = v51 / getValueByIndex(p47.arguments.Increment, p49, p47.arguments);
                v51 = math.round(v52) * getValueByIndex(p47.arguments.Increment, p49, p47.arguments);
            end;

            number:set(updateValueByIndex(number.value, p49, v51, p47.arguments));
            p47.lastNumberChangedTick = u1._cycleTick + 1;
        end;

        local v53 = getValueByIndex(number.value, p49, p47.arguments);

        if p50 == "Color3" or p50 == "Color4" and not p47.arguments.UseFloats then
            v53 = math.round(v53 * 255);
        end;

        local v54 = p47.arguments.Format[p49] or p47.arguments.Format[1];

        if p47.arguments.Prefix then
            v54 = p47.arguments.Prefix[p49] .. v54;
        end;

        p48.Text = string.format(v54, v53);
        p47.state.editingText:set(0);
        p48:ReleaseFocus(true);
    end;

    local function generateButtons(u55, p56, p57) -- Line: 355
        -- upvalues: u2 (copy), u1 (copy), getValueByIndex (copy)
        local v58 = u2.abstractButton.Generate(u55);
        v58.Name = "SubButton";
        v58.Size = UDim2.fromOffset(u1._config.TextSize + 2 * u1._config.FramePadding.Y, u1._config.TextSize);
        v58.Text = "-";
        v58.TextXAlignment = Enum.TextXAlignment.Center;
        v58.ZIndex = 5;
        v58.LayoutOrder = 5;
        v58.Parent = p56;
        u2.applyButtonClick(v58, function() -- Line: 365
            -- upvalues: u2 (ref), u55 (copy), getValueByIndex (ref), u1 (ref)
            local v59 = u2.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or u2.UserInputService:IsKeyDown(Enum.KeyCode.RightControl);
            local v60 = u55.arguments.Increment and getValueByIndex(u55.arguments.Increment, 1, u55.arguments) or 1;
            local v61 = u55.state.number.value - v60 * (v59 and 100 or 1);

            if u55.arguments.Min ~= nil then
                v61 = math.max(v61, getValueByIndex(u55.arguments.Min, 1, u55.arguments));
            end;

            if u55.arguments.Max ~= nil then
                v61 = math.min(v61, getValueByIndex(u55.arguments.Max, 1, u55.arguments));
            end;

            u55.state.number:set(v61);
            u55.lastNumberChangedTick = u1._cycleTick + 1;
        end);
        local v62 = u2.abstractButton.Generate(u55);
        v62.Name = "AddButton";
        v62.Size = UDim2.fromOffset(u1._config.TextSize + 2 * u1._config.FramePadding.Y, u1._config.TextSize);
        v62.Text = "+";
        v62.TextXAlignment = Enum.TextXAlignment.Center;
        v62.ZIndex = 6;
        v62.LayoutOrder = 6;
        v62.Parent = p56;
        u2.applyButtonClick(v62, function() -- Line: 389
            -- upvalues: u2 (ref), u55 (copy), getValueByIndex (ref), u1 (ref)
            local v63 = u2.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or u2.UserInputService:IsKeyDown(Enum.KeyCode.RightControl);
            local v64 = u55.arguments.Increment and getValueByIndex(u55.arguments.Increment, 1, u55.arguments) or 1;
            local v65 = u55.state.number.value + v64 * (v63 and 100 or 1);

            if u55.arguments.Min ~= nil then
                v65 = math.max(v65, getValueByIndex(u55.arguments.Min, 1, u55.arguments));
            end;

            if u55.arguments.Max ~= nil then
                v65 = math.min(v65, getValueByIndex(u55.arguments.Max, 1, u55.arguments));
            end;

            u55.state.number:set(v65);
            u55.lastNumberChangedTick = u1._cycleTick + 1;
        end);

        return 2 * u1._config.ItemInnerSpacing.X + p57 * 2;
    end;

    local function generateField(u66, u67, p68, u69) -- Line: 407
        -- upvalues: u1 (copy), u2 (copy), focusLost (copy)
        local TextBox = Instance.new("TextBox");
        TextBox.Name = "InputField" .. tostring(u67);
        TextBox.AutomaticSize = Enum.AutomaticSize.Y;
        TextBox.Size = UDim2.new(p68, u1._config.ContentHeight);
        TextBox.BackgroundColor3 = u1._config.FrameBgColor;
        TextBox.BackgroundTransparency = u1._config.FrameBgTransparency;
        TextBox.TextTruncate = Enum.TextTruncate.AtEnd;
        TextBox.ClearTextOnFocus = false;
        TextBox.ZIndex = u67;
        TextBox.LayoutOrder = u67;
        TextBox.ClipsDescendants = true;
        u2.applyFrameStyle(TextBox);
        u2.applyTextStyle(TextBox);
        u2.UISizeConstraint(TextBox, Vector2.xAxis);
        TextBox.FocusLost:Connect(function() -- Line: 424
            -- upvalues: focusLost (ref), u66 (copy), TextBox (copy), u67 (copy), u69 (copy)
            focusLost(u66, TextBox, u67, u69);
        end);
        TextBox.Focused:Connect(function() -- Line: 428
            -- upvalues: TextBox (copy), u66 (copy), u67 (copy)
            TextBox.CursorPosition = #TextBox.Text + 1;
            TextBox.SelectionStart = 1;
            u66.state.editingText:set(u67);
        end);

        return TextBox;
    end;

    local function generateInputScalar(u70, u71, p72) -- Line: 439
        -- upvalues: generateAbstract (copy), u2 (copy), u1 (copy), generateButtons (copy), generateField (copy), getValueByIndex (copy)
        local v73 = generateAbstract("Input", u70, u71, p72);

        return u2.extend(v73, {
            Generate = function(p74) -- Line: 443, Name: Generate
                -- upvalues: u70 (copy), u1 (ref), u2 (ref), u71 (copy), generateButtons (ref), generateField (ref)
                local Frame = Instance.new("Frame");
                Frame.Name = "Iris_Input" .. u70;
                Frame.AutomaticSize = Enum.AutomaticSize.Y;
                Frame.Size = UDim2.new(u1._config.ItemWidth, UDim.new());
                Frame.BackgroundTransparency = 1;
                Frame.BorderSizePixel = 0;
                u2.UIListLayout(Frame, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.X)).VerticalAlignment = Enum.VerticalAlignment.Center;
                local v75 = u71 ~= 1 and 0 or generateButtons(p74, Frame, u1._config.TextSize + 2 * u1._config.FramePadding.Y);
                local v76 = UDim.new(u1._config.ContentWidth.Scale / u71, (u1._config.ContentWidth.Offset - u1._config.ItemInnerSpacing.X * (u71 - 1) - v75) / u71);
                local v77 = UDim.new(v76.Scale * (u71 - 1), v76.Offset * (u71 - 1) + u1._config.ItemInnerSpacing.X * (u71 - 1) + v75);
                local v78 = u1._config.ContentWidth - v77;

                for i = 1, u71 do
                    local v79;

                    if i == u71 then
                        v79 = v78;
                    else
                        v79 = v76;
                    end;

                    generateField(p74, i, v79, u70).Parent = Frame;
                end;

                local TextLabel = Instance.new("TextLabel");
                TextLabel.Name = "TextLabel";
                TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
                TextLabel.BackgroundTransparency = 1;
                TextLabel.BorderSizePixel = 0;
                TextLabel.LayoutOrder = 7;
                u2.applyTextStyle(TextLabel);
                TextLabel.Parent = Frame;

                return Frame;
            end,

            UpdateState = function(p80) -- Line: 492, Name: UpdateState
                -- upvalues: u71 (copy), getValueByIndex (ref)
                local Instance2 = p80.Instance;

                for i = 1, u71 do
                    local v81 = Instance2:FindFirstChild("InputField" .. tostring(i));
                    local v82 = p80.arguments.Format[i] or p80.arguments.Format[1];

                    if p80.arguments.Prefix then
                        v82 = p80.arguments.Prefix[i] .. v82;
                    end;

                    v81.Text = string.format(v82, getValueByIndex(p80.state.number.value, i, p80.arguments));
                end;
            end
        });
    end;

    local u83 = 0;
    local u84 = false;
    local u85 = nil;
    local u86 = 0;
    local u87 = "";

    local function updateActiveDrag() -- Line: 520
        -- upvalues: u2 (copy), u83 (ref), u84 (ref), u85 (ref), u87 (ref), u86 (ref), getValueByIndex (copy), u17 (copy), updateValueByIndex (copy), u1 (copy)
        local X = u2.getMouseLocation().X;
        local v88 = X - u83;
        u83 = X;

        if u84 == false then
            return;
        end;

        if u85 == nil then
            return;
        end;

        local number = u85.state.number;

        if u87 == "Color3" or u87 == "Color4" then
            local v89 = u85;
            number = v89.state.color;

            if u86 == 4 then
                number = v89.state.transparency;
            end;
        end;

        local v90 = (u85.arguments.Increment and getValueByIndex(u85.arguments.Increment, u86, u85.arguments) or u17[u87][u86]) * ((u2.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or u2.UserInputService:IsKeyDown(Enum.KeyCode.RightShift)) and 10 or 1) * ((u2.UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or u2.UserInputService:IsKeyDown(Enum.KeyCode.RightAlt)) and 0.1 or 1) * ((u87 == "Color3" or u87 == "Color4") and 5 or 1);
        local v91 = getValueByIndex(number.value, u86, u85.arguments) + v88 * v90;

        if u85.arguments.Min ~= nil then
            v91 = math.max(v91, getValueByIndex(u85.arguments.Min, u86, u85.arguments));
        end;

        if u85.arguments.Max ~= nil then
            v91 = math.min(v91, getValueByIndex(u85.arguments.Max, u86, u85.arguments));
        end;

        number:set(updateValueByIndex(number.value, u86, v91, u85.arguments));
        u85.lastNumberChangedTick = u1._cycleTick + 1;
    end;

    local function DragMouseDown(p92, p93, p94, p95, p96) -- Line: 560
        -- upvalues: u2 (copy), u1 (copy), u84 (ref), u85 (ref), u86 (ref), u87 (ref), updateActiveDrag (copy)
        local v97 = u2.getTime();
        local v98 = v97 - p92.lastClickedTime < u1._config.MouseDoubleClickTime;
        local v99 = u2.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or u2.UserInputService:IsKeyDown(Enum.KeyCode.RightControl);

        if v98 and (Vector2.new(p95, p96) - p92.lastClickedPosition).Magnitude < u1._config.MouseDoubleClickMaxDist or v99 then
            p92.state.editingText:set(p94);

            return;
        end;

        p92.lastClickedTime = v97;
        p92.lastClickedPosition = Vector2.new(p95, p96);
        u84 = true;
        u85 = p92;
        u86 = p94;
        u87 = p93;
        updateActiveDrag();
    end;

    u2.registerEvent("InputChanged", function() -- Line: 578
        -- upvalues: u1 (copy), updateActiveDrag (copy)
        if not u1._started then
            return;
        end;

        updateActiveDrag();
    end);
    u2.registerEvent("InputEnded", function(p100) -- Line: 585
        -- upvalues: u1 (copy), u84 (ref), u85 (ref), u86 (ref)
        if not u1._started then
            return;
        end;

        if p100.UserInputType == Enum.UserInputType.MouseButton1 and u84 then
            u84 = false;
            u85 = nil;
            u86 = 0;
        end;
    end);

    local function u107(u101, u102, p103, u104) -- Line: 596
        -- upvalues: u1 (copy), u2 (copy), focusLost (copy), DragMouseDown (copy)
        local TextButton = Instance.new("TextButton");
        TextButton.Name = "DragField" .. tostring(u102);
        TextButton.AutomaticSize = Enum.AutomaticSize.Y;
        TextButton.Size = p103;
        TextButton.BackgroundColor3 = u1._config.FrameBgColor;
        TextButton.BackgroundTransparency = u1._config.FrameBgTransparency;
        TextButton.Text = "";
        TextButton.AutoButtonColor = false;
        TextButton.LayoutOrder = u102;
        TextButton.ClipsDescendants = true;
        u2.applyFrameStyle(TextButton);
        u2.applyTextStyle(TextButton);
        u2.UISizeConstraint(TextButton, Vector2.xAxis);
        TextButton.TextXAlignment = Enum.TextXAlignment.Center;
        u2.applyInteractionHighlights("Background", TextButton, TextButton, {
            Color = u1._config.FrameBgColor,
            Transparency = u1._config.FrameBgTransparency,
            HoveredColor = u1._config.FrameBgHoveredColor,
            HoveredTransparency = u1._config.FrameBgHoveredTransparency,
            ActiveColor = u1._config.FrameBgActiveColor,
            ActiveTransparency = u1._config.FrameBgActiveTransparency
        });
        local TextBox = Instance.new("TextBox");
        TextBox.Name = "InputField";
        TextBox.Size = UDim2.fromScale(1, 1);
        TextBox.BackgroundTransparency = 1;
        TextBox.ClearTextOnFocus = false;
        TextBox.TextTruncate = Enum.TextTruncate.AtEnd;
        TextBox.ClipsDescendants = true;
        TextBox.Visible = false;
        u2.applyFrameStyle(TextBox, true);
        u2.applyTextStyle(TextBox);
        TextBox.Parent = TextButton;
        TextBox.FocusLost:Connect(function() -- Line: 637
            -- upvalues: focusLost (ref), u101 (copy), TextBox (copy), u102 (copy), u104 (copy)
            focusLost(u101, TextBox, u102, u104);
        end);
        TextBox.Focused:Connect(function() -- Line: 641
            -- upvalues: TextBox (copy), u101 (copy), u102 (copy)
            TextBox.CursorPosition = #TextBox.Text + 1;
            TextBox.SelectionStart = 1;
            u101.state.editingText:set(u102);
        end);
        u2.applyButtonDown(TextButton, function(p105, p106) -- Line: 649
            -- upvalues: DragMouseDown (ref), u101 (copy), u104 (copy), u102 (copy)
            DragMouseDown(u101, u104, u102, p105, p106);
        end);

        return TextButton;
    end;

    local function generateDragScalar(u108, u109, p110) -- Line: 656
        -- upvalues: generateAbstract (copy), u2 (copy), u1 (copy), u107 (copy), getValueByIndex (copy)
        local v111 = generateAbstract("Drag", u108, u109, p110);

        return u2.extend(v111, {
            Generate = function(p112) -- Line: 660, Name: Generate
                -- upvalues: u108 (copy), u1 (ref), u2 (ref), u109 (copy), u107 (ref)
                p112.lastClickedTime = -1;
                p112.lastClickedPosition = Vector2.zero;
                local Frame = Instance.new("Frame");
                Frame.Name = "Iris_Drag" .. u108;
                Frame.AutomaticSize = Enum.AutomaticSize.Y;
                Frame.Size = UDim2.new(u1._config.ItemWidth, UDim.new());
                Frame.BackgroundTransparency = 1;
                Frame.BorderSizePixel = 0;
                u2.UIListLayout(Frame, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.X)).VerticalAlignment = Enum.VerticalAlignment.Center;
                local v113 = 0;
                local v114 = u1._config.TextSize + 2 * u1._config.FramePadding.Y;

                if u108 == "Color3" or u108 == "Color4" then
                    v113 = v113 + (u1._config.ItemInnerSpacing.X + v114);
                    local ImageLabel = Instance.new("ImageLabel");
                    ImageLabel.Name = "ColorBox";
                    ImageLabel.Size = UDim2.fromOffset(v114, v114);
                    ImageLabel.BorderSizePixel = 0;
                    ImageLabel.Image = u2.ICONS.ALPHA_BACKGROUND_TEXTURE;
                    ImageLabel.ImageTransparency = 1;
                    ImageLabel.LayoutOrder = 5;
                    u2.applyFrameStyle(ImageLabel, true);
                    ImageLabel.Parent = Frame;
                end;

                local v115 = UDim.new(u1._config.ContentWidth.Scale / u109, (u1._config.ContentWidth.Offset - u1._config.ItemInnerSpacing.X * (u109 - 1) - v113) / u109);
                local v116 = UDim.new(v115.Scale * (u109 - 1), v115.Offset * (u109 - 1) + u1._config.ItemInnerSpacing.X * (u109 - 1) + v113);
                local v117 = u1._config.ContentWidth - v116;

                for i = 1, u109 do
                    local v118;

                    if i == u109 then
                        v118 = UDim2.new(v117, u1._config.ContentHeight);
                    else
                        v118 = UDim2.new(v115, u1._config.ContentHeight);
                    end;

                    u107(p112, i, v118, u108).Parent = Frame;
                end;

                local TextLabel = Instance.new("TextLabel");
                TextLabel.Name = "TextLabel";
                TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
                TextLabel.BackgroundTransparency = 1;
                TextLabel.BorderSizePixel = 0;
                TextLabel.LayoutOrder = 6;
                u2.applyTextStyle(TextLabel);
                TextLabel.Parent = Frame;

                return Frame;
            end,

            UpdateState = function(p119) -- Line: 731, Name: UpdateState
                -- upvalues: u109 (copy), u108 (copy), getValueByIndex (ref), u1 (ref)
                local Instance2 = p119.Instance;

                for i = 1, u109 do
                    local number = p119.state.number;

                    if u108 == "Color3" or u108 == "Color4" then
                        number = p119.state.color;

                        if i == 4 then
                            number = p119.state.transparency;
                        end;
                    end;

                    local v120 = Instance2:FindFirstChild("DragField" .. tostring(i));
                    local InputField = v120.InputField;
                    local v121 = getValueByIndex(number.value, i, p119.arguments);

                    if (u108 == "Color3" or u108 == "Color4") and not p119.arguments.UseFloats then
                        v121 = math.round(v121 * 255);
                    end;

                    local v122 = p119.arguments.Format[i] or p119.arguments.Format[1];

                    if p119.arguments.Prefix then
                        v122 = p119.arguments.Prefix[i] .. v122;
                    end;

                    v120.Text = string.format(v122, v121);
                    InputField.Text = tostring(v121);

                    if p119.state.editingText.value == i then
                        InputField.Visible = true;
                        InputField:CaptureFocus();
                        v120.TextTransparency = 1;
                    else
                        InputField.Visible = false;
                        v120.TextTransparency = u1._config.TextTransparency;
                    end;
                end;

                if u108 == "Color3" or u108 == "Color4" then
                    local ColorBox = Instance2.ColorBox;
                    ColorBox.BackgroundColor3 = p119.state.color.value;

                    if u108 == "Color4" then
                        ColorBox.ImageTransparency = 1 - p119.state.transparency.value;
                    end;
                end;
            end
        });
    end;

    local function generateColorDragScalar(u123, ...) -- Line: 780
        -- upvalues: generateDragScalar (ref), u2 (copy), u20 (copy), u1 (copy)
        local u124 = { ... };
        local v125 = generateDragScalar(u123, u123 == "Color4" and 4 or 3, u124[1]);

        return u2.extend(v125, {
            Args = {
                Text = 1,
                UseFloats = 2,
                UseHSV = 3,
                Format = 4
            },

            Update = function(p126) -- Line: 791, Name: Update
                -- upvalues: u123 (copy), u20 (ref), u1 (ref)
                p126.Instance.TextLabel.Text = p126.arguments.Text or `Drag {u123}`;

                if p126.arguments.Format and typeof(p126.arguments.Format) ~= "table" then
                    p126.arguments.Format = { p126.arguments.Format };
                elseif not p126.arguments.Format then
                    if p126.arguments.UseFloats then
                        p126.arguments.Format = { "%.3f" };
                    else
                        p126.arguments.Format = { "%d" };
                    end;

                    p126.arguments.Prefix = u20[u123 .. (p126.arguments.UseHSV and "_HSV" or "_RGB")];
                end;

                p126.arguments.Min = { 0, 0, 0, 0 };
                p126.arguments.Max = { 1, 1, 1, 1 };
                p126.arguments.Increment = { 0.001, 0.001, 0.001, 0.001 };

                if p126.state then
                    p126.state.color.lastChangeTick = u1._cycleTick;

                    if u123 == "Color4" then
                        p126.state.transparency.lastChangeTick = u1._cycleTick;
                    end;

                    u1._widgets[p126.type].UpdateState(p126);
                end;
            end,

            GenerateState = function(p127) -- Line: 822, Name: GenerateState
                -- upvalues: u1 (ref), u124 (copy), u123 (copy)
                if p127.state.color == nil then
                    p127.state.color = u1._widgetState(p127, "color", u124[1]);
                end;

                if u123 == "Color4" and p127.state.transparency == nil then
                    p127.state.transparency = u1._widgetState(p127, "transparency", u124[2]);
                end;

                if p127.state.editingText == nil then
                    p127.state.editingText = u1._widgetState(p127, "editingText", false);
                end;
            end
        });
    end;

    local u128 = false;
    local u129 = nil;
    local u130 = 0;
    local u131 = "";

    local function updateActiveSlider() -- Line: 850
        -- upvalues: u128 (ref), u129 (ref), u130 (ref), getValueByIndex (copy), u17 (copy), u131 (ref), u18 (copy), u19 (copy), u2 (copy), updateValueByIndex (copy), u1 (copy)
        if u128 == false then
            return;
        end;

        if u129 == nil then
            return;
        end;

        local v132 = u129.Instance:FindFirstChild("SliderField" .. tostring(u130));
        local GrabBar = v132.GrabBar;
        local v133 = u129.arguments.Increment and getValueByIndex(u129.arguments.Increment, u130, u129.arguments) or u17[u131][u130];
        local v134 = u129.arguments.Min and getValueByIndex(u129.arguments.Min, u130, u129.arguments) or u18[u131][u130];
        local v135 = u129.arguments.Max and getValueByIndex(u129.arguments.Max, u130, u129.arguments) or u19[u131][u130];
        local X = GrabBar.AbsoluteSize.X;
        local v136 = (u2.getMouseLocation().X - (v132.AbsolutePosition.X - u2.GuiOffset.X + X / 2)) / (v132.AbsoluteSize.X - X) * math.floor((v135 - v134) / v133);
        local v137 = math.round(v136) * v133 + v134;
        local v138 = math.clamp(v137, v134, v135);
        u129.state.number:set(updateValueByIndex(u129.state.number.value, u130, v138, u129.arguments));
        u129.lastNumberChangedTick = u1._cycleTick + 1;
    end;

    local function SliderMouseDown(p139, p140, p141) -- Line: 877
        -- upvalues: u2 (copy), u128 (ref), u129 (ref), u130 (ref), u131 (ref), updateActiveSlider (copy)
        if u2.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or u2.UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
            p139.state.editingText:set(p141);

            return;
        end;

        u128 = true;
        u129 = p139;
        u130 = p141;
        u131 = p140;
        updateActiveSlider();
    end;

    u2.registerEvent("InputChanged", function() -- Line: 890
        -- upvalues: u1 (copy), updateActiveSlider (copy)
        if not u1._started then
            return;
        end;

        updateActiveSlider();
    end);
    u2.registerEvent("InputEnded", function(p142) -- Line: 897
        -- upvalues: u1 (copy), u128 (ref), u129 (ref), u130 (ref), u131 (ref)
        if not u1._started then
            return;
        end;

        if p142.UserInputType == Enum.UserInputType.MouseButton1 and u128 then
            u128 = false;
            u129 = nil;
            u130 = 0;
            u131 = "";
        end;
    end);

    local function u147(u143, u144, p145, u146) -- Line: 909
        -- upvalues: u1 (copy), u2 (copy), focusLost (copy), SliderMouseDown (copy)
        local TextButton = Instance.new("TextButton");
        TextButton.Name = "SliderField" .. tostring(u144);
        TextButton.AutomaticSize = Enum.AutomaticSize.Y;
        TextButton.Size = p145;
        TextButton.BackgroundColor3 = u1._config.FrameBgColor;
        TextButton.BackgroundTransparency = u1._config.FrameBgTransparency;
        TextButton.Text = "";
        TextButton.AutoButtonColor = false;
        TextButton.LayoutOrder = u144;
        TextButton.ClipsDescendants = true;
        u2.applyFrameStyle(TextButton);
        u2.applyTextStyle(TextButton);
        u2.UISizeConstraint(TextButton, Vector2.xAxis);
        local TextLabel = Instance.new("TextLabel");
        TextLabel.Name = "OverlayText";
        TextLabel.Size = UDim2.fromScale(1, 1);
        TextLabel.BackgroundTransparency = 1;
        TextLabel.BorderSizePixel = 0;
        TextLabel.ZIndex = 10;
        TextLabel.ClipsDescendants = true;
        u2.applyTextStyle(TextLabel);
        TextLabel.TextXAlignment = Enum.TextXAlignment.Center;
        TextLabel.Parent = TextButton;
        u2.applyInteractionHighlights("Background", TextButton, TextButton, {
            Color = u1._config.FrameBgColor,
            Transparency = u1._config.FrameBgTransparency,
            HoveredColor = u1._config.FrameBgHoveredColor,
            HoveredTransparency = u1._config.FrameBgHoveredTransparency,
            ActiveColor = u1._config.FrameBgActiveColor,
            ActiveTransparency = u1._config.FrameBgActiveTransparency
        });
        local TextBox = Instance.new("TextBox");
        TextBox.Name = "InputField";
        TextBox.Size = UDim2.fromScale(1, 1);
        TextBox.BackgroundTransparency = 1;
        TextBox.ClearTextOnFocus = false;
        TextBox.TextTruncate = Enum.TextTruncate.AtEnd;
        TextBox.ClipsDescendants = true;
        TextBox.Visible = false;
        u2.applyFrameStyle(TextBox, true);
        u2.applyTextStyle(TextBox);
        TextBox.Parent = TextButton;
        TextBox.FocusLost:Connect(function() -- Line: 962
            -- upvalues: focusLost (ref), u143 (copy), TextBox (copy), u144 (copy), u146 (copy)
            focusLost(u143, TextBox, u144, u146);
        end);
        TextBox.Focused:Connect(function() -- Line: 966
            -- upvalues: TextBox (copy), u143 (copy), u144 (copy)
            TextBox.CursorPosition = #TextBox.Text + 1;
            TextBox.SelectionStart = 1;
            u143.state.editingText:set(u144);
        end);
        u2.applyButtonDown(TextButton, function() -- Line: 974
            -- upvalues: SliderMouseDown (ref), u143 (copy), u146 (copy), u144 (copy)
            SliderMouseDown(u143, u146, u144);
        end);
        local Frame = Instance.new("Frame");
        Frame.Name = "GrabBar";
        Frame.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame.Position = UDim2.fromScale(0, 0.5);
        Frame.BackgroundColor3 = u1._config.SliderGrabColor;
        Frame.Transparency = u1._config.SliderGrabTransparency;
        Frame.BorderSizePixel = 0;
        Frame.ZIndex = 5;
        u2.applyInteractionHighlights("Background", TextButton, Frame, {
            Color = u1._config.SliderGrabColor,
            Transparency = u1._config.SliderGrabTransparency,
            HoveredColor = u1._config.SliderGrabColor,
            HoveredTransparency = u1._config.SliderGrabTransparency,
            ActiveColor = u1._config.SliderGrabActiveColor,
            ActiveTransparency = u1._config.SliderGrabActiveTransparency
        });

        if u1._config.GrabRounding > 0 then
            u2.UICorner(Frame, u1._config.GrabRounding);
        end;

        u2.UISizeConstraint(Frame, Vector2.new(u1._config.GrabMinSize, 0));
        Frame.Parent = TextButton;

        return TextButton;
    end;

    local function generateSliderScalar(u148, u149, p150) -- Line: 1007
        -- upvalues: generateAbstract (copy), u2 (copy), u1 (copy), u147 (copy), getValueByIndex (copy), u17 (copy), u18 (copy), u19 (copy)
        local v151 = generateAbstract("Slider", u148, u149, p150);

        return u2.extend(v151, {
            Generate = function(p152) -- Line: 1011, Name: Generate
                -- upvalues: u148 (copy), u1 (ref), u2 (ref), u149 (copy), u147 (ref)
                local Frame = Instance.new("Frame");
                Frame.Name = "Iris_Slider" .. u148;
                Frame.AutomaticSize = Enum.AutomaticSize.Y;
                Frame.Size = UDim2.new(u1._config.ItemWidth, UDim.new());
                Frame.BackgroundTransparency = 1;
                Frame.BorderSizePixel = 0;
                u2.UIListLayout(Frame, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.X)).VerticalAlignment = Enum.VerticalAlignment.Center;
                local v153 = UDim.new(u1._config.ContentWidth.Scale / u149, (u1._config.ContentWidth.Offset - u1._config.ItemInnerSpacing.X * (u149 - 1)) / u149);
                local v154 = UDim.new(v153.Scale * (u149 - 1), v153.Offset * (u149 - 1) + u1._config.ItemInnerSpacing.X * (u149 - 1));
                local v155 = u1._config.ContentWidth - v154;

                for i = 1, u149 do
                    local v156;

                    if i == u149 then
                        v156 = UDim2.new(v155, u1._config.ContentHeight);
                    else
                        v156 = UDim2.new(v153, u1._config.ContentHeight);
                    end;

                    u147(p152, i, v156, u148).Parent = Frame;
                end;

                local TextLabel = Instance.new("TextLabel");
                TextLabel.Name = "TextLabel";
                TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
                TextLabel.BackgroundTransparency = 1;
                TextLabel.BorderSizePixel = 0;
                TextLabel.LayoutOrder = 5;
                u2.applyTextStyle(TextLabel);
                TextLabel.Parent = Frame;

                return Frame;
            end,

            UpdateState = function(p157) -- Line: 1059, Name: UpdateState
                -- upvalues: u149 (copy), getValueByIndex (ref), u17 (ref), u148 (copy), u18 (ref), u19 (ref)
                local Instance2 = p157.Instance;

                for i = 1, u149 do
                    local v158 = Instance2:FindFirstChild("SliderField" .. tostring(i));
                    local InputField = v158.InputField;
                    local OverlayText = v158.OverlayText;
                    local GrabBar = v158.GrabBar;
                    local v159 = getValueByIndex(p157.state.number.value, i, p157.arguments);
                    local v160 = p157.arguments.Format[i] or p157.arguments.Format[1];

                    if p157.arguments.Prefix then
                        v160 = p157.arguments.Prefix[i] .. v160;
                    end;

                    OverlayText.Text = string.format(v160, v159);
                    InputField.Text = tostring(v159);
                    local v161 = p157.arguments.Increment and getValueByIndex(p157.arguments.Increment, i, p157.arguments) or u17[u148][i];
                    local v162 = p157.arguments.Min and getValueByIndex(p157.arguments.Min, i, p157.arguments) or u18[u148][i];
                    local v163 = p157.arguments.Max and getValueByIndex(p157.arguments.Max, i, p157.arguments) or u19[u148][i];
                    local X = v158.AbsoluteSize.X;
                    local v164 = X - GrabBar.AbsoluteSize.X;
                    local v165 = math.floor((v163 - v162) / v161);
                    local v166 = math.floor((v159 - v162) / (v163 - v162) * v165) / v165;
                    local v167 = math.clamp(v166, 0, 1);
                    GrabBar.Position = UDim2.fromScale(v164 / X * v167 + (1 - v164 / X) / 2, 0.5);

                    if p157.state.editingText.value == i then
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
        });
    end;

    local function generateEnumSliderScalar(u168, u169) -- Line: 1108
        -- upvalues: generateSliderScalar (ref), u2 (copy), u1 (copy)
        local v170 = generateSliderScalar("Enum", 1, u169.Value);
        local v171 = { string };

        for _, v in u168:GetEnumItems() do
            v171[v.Value] = v.Name;
        end;

        return u2.extend(v170, {
            Args = {
                Text = 1
            },

            Update = function(p172) -- Line: 1120, Name: Update
                -- upvalues: u168 (copy)
                local Instance2 = p172.Instance;
                Instance2.TextLabel.Text = p172.arguments.Text or "Input Enum";
                p172.arguments.Increment = 1;
                p172.arguments.Min = 0;
                p172.arguments.Max = #u168:GetEnumItems() - 1;
                local GrabBar = Instance2:FindFirstChild("SliderField1").GrabBar;
                local v173 = #u168:GetEnumItems();
                local v174 = 1 / math.floor(v173);
                GrabBar.Size = UDim2.fromScale(v174, 1);
            end,

            GenerateState = function(p175) -- Line: 1136, Name: GenerateState
                -- upvalues: u1 (ref), u169 (copy)
                if p175.state.number == nil then
                    p175.state.number = u1._widgetState(p175, "number", u169.Value);
                end;

                if p175.state.enumItem == nil then
                    p175.state.enumItem = u1._widgetState(p175, "enumItem", u169);
                end;

                if p175.state.editingText == nil then
                    p175.state.editingText = u1._widgetState(p175, "editingText", false);
                end;
            end
        });
    end;

    local v176 = generateInputScalar("Num", 1, 0);
    v176.Args.NoButtons = 6;
    u1.WidgetConstructor("InputNum", v176);
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
            TextHint = 2,
            ReadOnly = 3,
            MultiLine = 4
        },
        Events = {
            textChanged = {
                Init = function(p177) -- Line: 1192
                    p177.lastTextChangedTick = 0;
                end,

                Get = function(p178) -- Line: 1195
                    -- upvalues: u1 (copy)
                    return p178.lastTextChangedTick == u1._cycleTick;
                end
            },
            hovered = u2.EVENTS.hover(function(p179) -- Line: 1199
                return p179.Instance;
            end)
        },

        Generate = function(u180) -- Line: 1203, Name: Generate
            -- upvalues: u1 (copy), u2 (copy)
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_InputText";
            Frame.AutomaticSize = Enum.AutomaticSize.Y;
            Frame.Size = UDim2.new(u1._config.ItemWidth, UDim.new());
            Frame.BackgroundTransparency = 1;
            Frame.BorderSizePixel = 0;
            u2.UIListLayout(Frame, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.X)).VerticalAlignment = Enum.VerticalAlignment.Center;
            local TextBox = Instance.new("TextBox");
            TextBox.Name = "InputField";
            TextBox.AutomaticSize = Enum.AutomaticSize.Y;
            TextBox.Size = UDim2.new(u1._config.ContentWidth, u1._config.ContentHeight);
            TextBox.BackgroundColor3 = u1._config.FrameBgColor;
            TextBox.BackgroundTransparency = u1._config.FrameBgTransparency;
            TextBox.Text = "";
            TextBox.TextYAlignment = Enum.TextYAlignment.Top;
            TextBox.PlaceholderColor3 = u1._config.TextDisabledColor;
            TextBox.ClearTextOnFocus = false;
            TextBox.ClipsDescendants = true;
            u2.applyFrameStyle(TextBox);
            u2.applyTextStyle(TextBox);
            u2.UISizeConstraint(TextBox, Vector2.xAxis);
            TextBox.Parent = Frame;
            TextBox.FocusLost:Connect(function() -- Line: 1231
                -- upvalues: u180 (copy), TextBox (copy), u1 (ref)
                u180.state.text:set(TextBox.Text);
                u180.lastTextChangedTick = u1._cycleTick + 1;
            end);
            local v181 = u1._config.TextSize + 2 * u1._config.FramePadding.Y;
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "TextLabel";
            TextLabel.AutomaticSize = Enum.AutomaticSize.X;
            TextLabel.Size = UDim2.fromOffset(0, v181);
            TextLabel.BackgroundTransparency = 1;
            TextLabel.BorderSizePixel = 0;
            TextLabel.LayoutOrder = 1;
            u2.applyTextStyle(TextLabel);
            TextLabel.Parent = Frame;

            return Frame;
        end,

        GenerateState = function(p182) -- Line: 1252, Name: GenerateState
            -- upvalues: u1 (copy)
            if p182.state.text == nil then
                p182.state.text = u1._widgetState(p182, "text", "");
            end;
        end,

        Update = function(p183) -- Line: 1257, Name: Update
            local Instance2 = p183.Instance;
            local InputField = Instance2.InputField;
            Instance2.TextLabel.Text = p183.arguments.Text or "Input Text";
            InputField.PlaceholderText = p183.arguments.TextHint or "";
            InputField.TextEditable = not p183.arguments.ReadOnly;
            InputField.MultiLine = p183.arguments.MultiLine or false;
        end,

        UpdateState = function(p184) -- Line: 1267, Name: UpdateState
            p184.Instance.InputField.Text = p184.state.text.value;
        end,

        Discard = function(p185) -- Line: 1273, Name: Discard
            -- upvalues: u2 (copy)
            p185.Instance:Destroy();
            u2.discardState(p185);
        end
    });
end;