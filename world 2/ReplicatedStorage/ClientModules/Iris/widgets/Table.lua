-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(u1, u2) -- Line: 32
    local u3 = {};
    local u4 = {};
    local u5 = false;
    local u6 = nil;
    local u7 = 0;
    local u8 = -1;
    local u9 = -1;
    local u10 = 0;

    local function CalculateMinColumnWidth(p11, p12) -- Line: 42
        -- upvalues: u1 (copy)
        local v13 = 0;

        for _, v in p11._cellInstances do
            for _, child in v[p12]:GetChildren() do
                if child:IsA("GuiObject") then
                    v13 = math.max(v13, child.AbsoluteSize.X);
                end;
            end;
        end;

        p11._minWidths[p12] = v13 + 2 * u1._config.CellPadding.X;
    end;

    table.insert(u1._postCycleCallbacks, function() -- Line: 56
        -- upvalues: u3 (copy), u1 (copy), u4 (copy), CalculateMinColumnWidth (copy)
        for _, v in u3 do
            for i, v2 in v._rowCycles do
                if v2 < u1._cycleTick - 1 then
                    local v14 = v._rowInstances[i];
                    local v15 = v._rowBorders[i - 1];

                    if v14 ~= nil then
                        v14:Destroy();
                    end;

                    if v15 ~= nil then
                        v15:Destroy();
                    end;

                    v._rowInstances[i] = nil;
                    v._rowBorders[i - 1] = nil;
                    v._cellInstances[i] = nil;
                    v._rowCycles[i] = nil;
                end;
            end;

            v._rowIndex = 1;
            v._columnIndex = 1;
            v.Instance.BorderContainer.Size = UDim2.new(1, 0, 0, v._rowContainer.AbsoluteSize.Y);
            v._columnBorders[0].Size = UDim2.fromOffset(5, v._rowContainer.AbsoluteSize.Y);
        end;

        for i, v in u4 do
            local v16 = false;

            for i2, _ in v do
                CalculateMinColumnWidth(i, i2);
                v16 = true;
            end;

            if v16 then
                table.clear(v);
                u1._widgets.Table.UpdateState(i);
            end;
        end;
    end);

    local function UpdateActiveColumn() -- Line: 98
        -- upvalues: u5 (ref), u6 (ref), u1 (copy), u8 (ref), u7 (ref), u9 (ref), u2 (copy), u10 (ref)
        if u5 == false or u6 == nil then
            return;
        end;

        local widths = u6.state.widths;
        local NumColumns = u6.arguments.NumColumns;
        local Instance2 = u6.Instance;
        local BorderContainer = Instance2.BorderContainer;
        local FixedWidth = u6.arguments.FixedWidth;
        local v17 = 2 * u1._config.CellPadding.X;

        if u8 == -1 then
            u8 = widths.value[u7];

            if u8 == 0 then
                u8 = v17 / Instance2.AbsoluteSize.X;
            end;

            u9 = widths.value[u7 + 1] or -1;

            if u9 == 0 then
                u9 = v17 / Instance2.AbsoluteSize.X;
            end;
        end;

        local X = Instance2.AbsolutePosition.X;
        local v18;

        if u7 == 1 then
            v18 = 0;
        else
            local v19 = BorderContainer:FindFirstChild((`Border_{u7 - 1}`)).AbsolutePosition.X + 3 - X;
            v18 = math.floor(v19);
        end;

        local v20;

        if u7 >= NumColumns - 1 then
            v20 = Instance2.AbsoluteSize.X;
        else
            local v21 = BorderContainer:FindFirstChild((`Border_{u7 + 1}`)).AbsolutePosition.X + 3 - X;
            v20 = math.floor(v21);
        end;

        local v22 = X - u2.GuiOffset.X;
        local X2 = u2.getMouseLocation().X;
        local v23 = math.clamp(X2, v18 + v22 + v17, v20 + v22 - v17) - u10;
        local v24 = u8 / (u10 - v22 - v18);

        if FixedWidth then
            local value = widths.value;
            local v25 = math.round(u8 + v23);
            value[u7] = math.clamp(v25, v17, Instance2.AbsoluteSize.X - v18);
        else
            local v26 = v24 * v23;
            widths.value[u7] = math.clamp(u8 + v26, 0, (v20 - v18 - v17) / Instance2.AbsoluteSize.X);

            if u7 < NumColumns then
                widths.value[u7 + 1] = math.clamp(u9 - v26, 0, 1);
            end;
        end;

        widths:set(widths.value, true);
    end;

    local function ColumnMouseDown(p27, p28) -- Line: 154
        -- upvalues: u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref), u2 (copy)
        u5 = true;
        u6 = p27;
        u7 = p28;
        u8 = -1;
        u9 = -1;
        u10 = u2.getMouseLocation().X;
    end;

    u2.registerEvent("InputChanged", function() -- Line: 163
        -- upvalues: u1 (copy), UpdateActiveColumn (copy)
        if not u1._started then
            return;
        end;

        UpdateActiveColumn();
    end);
    u2.registerEvent("InputEnded", function(p29) -- Line: 170
        -- upvalues: u1 (copy), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref)
        if not u1._started then
            return;
        end;

        if p29.UserInputType == Enum.UserInputType.MouseButton1 and u5 then
            u5 = false;
            u6 = nil;
            u7 = 0;
            u8 = -1;
            u9 = -1;
            u10 = 0;
        end;
    end);

    local function GenerateCell(p30, p31, p32, p33) -- Line: 184
        -- upvalues: u2 (copy), u1 (copy)
        local v34;

        if p33 then
            v34 = Instance.new("TextButton");
            v34.Text = "";
            v34.AutoButtonColor = false;
        else
            v34 = Instance.new("Frame");
        end;

        v34.Name = `Cell_{p31}`;
        v34.AutomaticSize = Enum.AutomaticSize.Y;
        v34.Size = UDim2.new(p32, UDim.new());
        v34.BackgroundTransparency = 1;
        v34.ZIndex = p31;
        v34.LayoutOrder = p31;
        v34.ClipsDescendants = true;

        if p33 then
            u2.applyInteractionHighlights("Background", v34, v34, {
                Transparency = 1,
                Color = u1._config.HeaderColor,
                HoveredColor = u1._config.HeaderHoveredColor,
                HoveredTransparency = u1._config.HeaderHoveredTransparency,
                ActiveColor = u1._config.HeaderActiveColor,
                ActiveTransparency = u1._config.HeaderActiveTransparency
            });
        end;

        u2.UIPadding(v34, u1._config.CellPadding);
        u2.UIListLayout(v34, Enum.FillDirection.Vertical, UDim.new());
        u2.UISizeConstraint(v34, Vector2.new(2 * u1._config.CellPadding.X, 0));

        return v34;
    end;

    local function GenerateColumnBorder(u35, u36, p37) -- Line: 219
        -- upvalues: u1 (copy), u2 (copy), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref)
        local ImageButton = Instance.new("ImageButton");
        ImageButton.Name = `Border_{u36}`;
        ImageButton.Size = UDim2.new(0, 5, 1, 0);
        ImageButton.BackgroundTransparency = 1;
        ImageButton.Image = "";
        ImageButton.ImageTransparency = 1;
        ImageButton.AutoButtonColor = false;
        ImageButton.ZIndex = u36;
        ImageButton.LayoutOrder = u36 * 2;
        local v38 = u36 == u35.arguments.NumColumns and 3 or 2;
        local Frame = Instance.new("Frame");
        Frame.Name = "Line";
        Frame.Size = UDim2.new(0, 1, 1, 0);
        Frame.Position = UDim2.fromOffset(v38, 0);
        Frame.BackgroundColor3 = u1._config[`TableBorder{p37}Color`];
        Frame.BackgroundTransparency = u1._config[`TableBorder{p37}Transparency`];
        Frame.BorderSizePixel = 0;
        Frame.Parent = ImageButton;
        local Frame2 = Instance.new("Frame");
        Frame2.Name = "Hover";
        Frame2.Position = UDim2.fromOffset(v38, 0);
        Frame2.Size = UDim2.new(0, 1, 1, 0);
        Frame2.BackgroundColor3 = u1._config[`TableBorder{p37}Color`];
        Frame2.BackgroundTransparency = u1._config[`TableBorder{p37}Transparency`];
        Frame2.BorderSizePixel = 0;
        Frame2.Visible = u35.arguments.Resizable;
        Frame2.Parent = ImageButton;
        u2.applyInteractionHighlights("Background", ImageButton, Frame2, {
            Transparency = 1,
            Color = u1._config.ResizeGripColor,
            HoveredColor = u1._config.ResizeGripHoveredColor,
            HoveredTransparency = u1._config.ResizeGripHoveredTransparency,
            ActiveColor = u1._config.ResizeGripActiveColor,
            ActiveTransparency = u1._config.ResizeGripActiveTransparency
        });
        u2.applyButtonDown(ImageButton, function() -- Line: 263
            -- upvalues: u35 (copy), u36 (copy), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref), u2 (ref)
            if u35.arguments.Resizable then
                u5 = true;
                u6 = u35;
                u7 = u36;
                u8 = -1;
                u9 = -1;
                u10 = u2.getMouseLocation().X;
            end;
        end);

        return ImageButton;
    end;

    local function GenerateRow(p39, p40) -- Line: 273
        -- upvalues: u1 (copy), u2 (copy), GenerateCell (copy)
        local Frame = Instance.new("Frame");
        Frame.Name = `Row_{p40}`;
        Frame.AutomaticSize = Enum.AutomaticSize.Y;
        Frame.Size = UDim2.fromScale(1, 0);

        if p40 == 0 then
            Frame.BackgroundColor3 = u1._config.TableHeaderColor;
            Frame.BackgroundTransparency = u1._config.TableHeaderTransparency;
        elseif p39.arguments.RowBackground == true then
            if p40 % 2 == 0 then
                Frame.BackgroundColor3 = u1._config.TableRowBgAltColor;
                Frame.BackgroundTransparency = u1._config.TableRowBgAltTransparency;
            else
                Frame.BackgroundColor3 = u1._config.TableRowBgColor;
                Frame.BackgroundTransparency = u1._config.TableRowBgTransparency;
            end;
        else
            Frame.BackgroundTransparency = 1;
        end;

        Frame.BorderSizePixel = 0;
        Frame.ZIndex = p40 * 2 - 1;
        Frame.LayoutOrder = p40 * 2 - 1;
        Frame.ClipsDescendants = true;
        u2.UIListLayout(Frame, Enum.FillDirection.Horizontal, UDim.new());
        p39._cellInstances[p40] = table.create(p39.arguments.NumColumns);

        for i = 1, p39.arguments.NumColumns do
            local v41 = GenerateCell(p39, i, p39._widths[i], p40 == 0);
            v41.Parent = Frame;
            p39._cellInstances[p40][i] = v41;
        end;

        p39._rowInstances[p40] = Frame;

        return Frame;
    end;

    local function GenerateRowBorder(p42, p43, p44) -- Line: 311
        -- upvalues: u1 (copy)
        local Frame = Instance.new("Frame");
        Frame.Name = `Border_{p43}`;
        Frame.Size = UDim2.fromScale(1, 0);
        Frame.BackgroundTransparency = 1;
        Frame.ZIndex = p43 * 2;
        Frame.LayoutOrder = p43 * 2;
        local Frame2 = Instance.new("Frame");
        Frame2.Name = "Line";
        Frame2.AnchorPoint = Vector2.new(0, 0.5);
        Frame2.Size = UDim2.new(1, 0, 0, 1);
        Frame2.BackgroundColor3 = u1._config[`TableBorder{p44}Color`];
        Frame2.BackgroundTransparency = u1._config[`TableBorder{p44}Transparency`];
        Frame2.BorderSizePixel = 0;
        Frame2.Parent = Frame;

        return Frame;
    end;

    u1.WidgetConstructor("Table", {
        hasState = true,
        hasChildren = true,
        Args = {
            NumColumns = 1,
            Header = 2,
            RowBackground = 3,
            OuterBorders = 4,
            InnerBorders = 5,
            Resizable = 6,
            FixedWidth = 7,
            ProportionalWidth = 8,
            LimitTableWidth = 9
        },
        Events = {},

        Generate = function(u45) -- Line: 348, Name: Generate
            -- upvalues: u3 (copy), u4 (copy), u2 (copy), u1 (copy)
            u3[u45.ID] = u45;
            u4[u45] = {};
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_Table";
            Frame.AutomaticSize = Enum.AutomaticSize.Y;
            Frame.Size = UDim2.fromScale(1, 0);
            Frame.BackgroundTransparency = 1;
            local Frame2 = Instance.new("Frame");
            Frame2.Name = "RowContainer";
            Frame2.AutomaticSize = Enum.AutomaticSize.Y;
            Frame2.Size = UDim2.fromScale(1, 0);
            Frame2.BackgroundTransparency = 1;
            Frame2.ZIndex = 1;
            u2.UISizeConstraint(Frame2);
            u2.UIListLayout(Frame2, Enum.FillDirection.Vertical, UDim.new());
            Frame2.Parent = Frame;
            u45._rowContainer = Frame2;
            local Frame3 = Instance.new("Frame");
            Frame3.Name = "BorderContainer";
            Frame3.Size = UDim2.fromScale(1, 1);
            Frame3.BackgroundTransparency = 1;
            Frame3.ZIndex = 2;
            Frame3.ClipsDescendants = true;
            u2.UISizeConstraint(Frame3);
            u2.UIListLayout(Frame3, Enum.FillDirection.Horizontal, UDim.new());
            u2.UIStroke(Frame3, 1, u1._config.TableBorderStrongColor, u1._config.TableBorderStrongTransparency);
            Frame3.Parent = Frame;
            u45._columnIndex = 1;
            u45._rowIndex = 1;
            u45._rowInstances = {};
            u45._cellInstances = {};
            u45._rowBorders = {};
            u45._columnBorders = {};
            u45._rowCycles = {};
            local u46 = #u1._postCycleCallbacks + 1;
            local u47 = u1._cycleTick + 1;

            u1._postCycleCallbacks[u46] = function() -- Line: 394
                -- upvalues: u1 (ref), u47 (copy), u45 (copy), u46 (copy)
                if u47 <= u1._cycleTick then
                    if u45.lastCycleTick ~= -1 then
                        u45.state.widths.lastChangeTick = u1._cycleTick;
                        u1._widgets.Table.UpdateState(u45);
                    end;

                    u1._postCycleCallbacks[u46] = nil;
                end;
            end;

            return Frame;
        end,

        GenerateState = function(p48) -- Line: 406, Name: GenerateState
            -- upvalues: u1 (copy), GenerateColumnBorder (copy), GenerateCell (copy)
            local NumColumns = p48.arguments.NumColumns;

            if p48.state.widths == nil then
                local v49 = table.create(NumColumns, 1 / NumColumns);
                p48.state.widths = u1._widgetState(p48, "widths", v49);
            end;

            p48._widths = table.create(NumColumns, UDim.new());
            p48._minWidths = table.create(NumColumns, 0);
            local Instance2 = p48.Instance;
            local BorderContainer = Instance2.BorderContainer;
            p48._cellInstances[-1] = table.create(NumColumns);

            for i = 1, NumColumns do
                local v50 = GenerateColumnBorder(p48, i, "Light");
                v50.Visible = p48.arguments.InnerBorders;
                p48._columnBorders[i] = v50;
                v50.Parent = BorderContainer;
                local v51 = GenerateCell(p48, i, p48._widths[i], false);
                v51:FindFirstChild("UISizeConstraint").MinSize = Vector2.new(2 * u1._config.CellPadding.X + (i > 1 and -2 or 0) + (i < NumColumns and -3 or 0), 0);
                v51.LayoutOrder = i * 2 - 1;
                p48._cellInstances[-1][i] = v51;
                v51.Parent = BorderContainer;
            end;

            local v52 = GenerateColumnBorder(p48, NumColumns, "Strong");
            p48._columnBorders[0] = v52;
            v52.Parent = Instance2;
        end,

        Update = function(p53) -- Line: 440, Name: Update
            -- upvalues: u1 (copy), u4 (copy)
            local NumColumns = p53.arguments.NumColumns;
            assert(NumColumns >= 1, "Iris.Table must have at least one column.");

            if p53._widths ~= nil and #p53._widths ~= NumColumns then
                p53.arguments.NumColumns = #p53._widths;
                warn("NumColumns cannot change once set. See documentation.");
            end;

            for i, v in p53._rowInstances do
                if i == 0 then
                    v.BackgroundColor3 = u1._config.TableHeaderColor;
                    v.BackgroundTransparency = u1._config.TableHeaderTransparency;
                elseif p53.arguments.RowBackground == true then
                    if i % 2 == 0 then
                        v.BackgroundColor3 = u1._config.TableRowBgAltColor;
                        v.BackgroundTransparency = u1._config.TableRowBgAltTransparency;
                    else
                        v.BackgroundColor3 = u1._config.TableRowBgColor;
                        v.BackgroundTransparency = u1._config.TableRowBgTransparency;
                    end;
                else
                    v.BackgroundTransparency = 1;
                end;
            end;

            for _, v in p53._rowBorders do
                v.Visible = p53.arguments.InnerBorders;
            end;

            for _, v in p53._columnBorders do
                v.Visible = p53.arguments.InnerBorders or p53.arguments.Resizable;
            end;

            for _, v in p53._columnBorders do
                local Hover = v:FindFirstChild("Hover");

                if Hover then
                    Hover.Visible = p53.arguments.Resizable;
                end;
            end;

            if p53._columnBorders[NumColumns] ~= nil then
                p53._columnBorders[NumColumns].Visible = not p53.arguments.LimitTableWidth and (p53.arguments.Resizable or p53.arguments.InnerBorders);
                p53._columnBorders[0].Visible = p53.arguments.LimitTableWidth and (p53.arguments.Resizable or p53.arguments.OuterBorders);
            end;

            local v54 = p53._rowInstances[0];
            local v55 = p53._rowBorders[0];

            if v54 ~= nil then
                v54.Visible = p53.arguments.Header;
            end;

            if v55 ~= nil then
                v55.Visible = p53.arguments.Header and p53.arguments.InnerBorders;
            end;

            p53.Instance.BorderContainer.UIStroke.Enabled = p53.arguments.OuterBorders;

            for i = 1, p53.arguments.NumColumns do
                u4[p53][i] = true;
            end;

            if p53._widths ~= nil then
                u1._widgets.Table.UpdateState(p53);
            end;
        end,

        UpdateState = function(p56) -- Line: 512, Name: UpdateState
            local Instance2 = p56.Instance;
            local BorderContainer = Instance2.BorderContainer;
            local RowContainer = Instance2.RowContainer;
            local NumColumns = p56.arguments.NumColumns;
            local value = p56.state.widths.value;
            local _minWidths = p56._minWidths;
            local FixedWidth = p56.arguments.FixedWidth;
            local ProportionalWidth = p56.arguments.ProportionalWidth;

            if not p56.arguments.Resizable then
                if FixedWidth then
                    if ProportionalWidth then
                        for i = 1, NumColumns do
                            value[i] = _minWidths[i];
                        end;
                    else
                        local v57 = 0;

                        for _, v in _minWidths do
                            v57 = math.max(v57, v);
                        end;

                        for i = 1, NumColumns do
                            value[i] = v57;
                        end;
                    end;
                elseif ProportionalWidth then
                    local v58 = 0;

                    for _, v in _minWidths do
                        v58 = v58 + v;
                    end;

                    local v59 = 1 / v58;

                    for i = 1, NumColumns do
                        value[i] = v59 * _minWidths[i];
                    end;
                else
                    local v60 = 1 / NumColumns;

                    for i = 1, NumColumns do
                        value[i] = v60;
                    end;
                end;
            end;

            local v61 = UDim.new();

            for i = 1, NumColumns do
                local v62 = value[i];
                local v63 = UDim.new(FixedWidth and 0 or math.clamp(v62, 0, 1), not FixedWidth and 0 or math.max(v62, 0));
                p56._widths[i] = v63;
                v61 = v61 + v63;

                for _, v in p56._cellInstances do
                    v[i].Size = UDim2.new(v63, UDim.new());
                end;

                p56._cellInstances[-1][i].Size = UDim2.new(v63 + UDim.new(0, (i > 1 and -2 or 0) - 3), UDim.new());
            end;

            local v64 = not (p56.arguments.FixedWidth and p56.arguments.LimitTableWidth) and (1 / 0) or v61.Offset;
            BorderContainer.UISizeConstraint.MaxSize = Vector2.new(v64, (1 / 0));
            RowContainer.UISizeConstraint.MaxSize = Vector2.new(v64, (1 / 0));
            p56._columnBorders[0].Position = UDim2.fromOffset(v64 - 3, 0);
        end,

        ChildAdded = function(p65, p66) -- Line: 587, Name: ChildAdded
            -- upvalues: u1 (copy), u4 (copy), GenerateRow (copy), GenerateRowBorder (copy)
            local _rowIndex = p65._rowIndex;
            local _columnIndex = p65._columnIndex;
            local v67 = p65._rowInstances[_rowIndex];
            p65._rowCycles[_rowIndex] = u1._cycleTick;
            u4[p65][_columnIndex] = true;

            if v67 ~= nil then
                return p65._cellInstances[_rowIndex][_columnIndex];
            end;

            local v68 = GenerateRow(p65, _rowIndex);

            if _rowIndex == 0 then
                v68.Visible = p65.arguments.Header;
            end;

            v68.Parent = p65._rowContainer;

            if _rowIndex > 0 then
                local v69 = GenerateRowBorder(p65, _rowIndex - 1, _rowIndex == 1 and "Strong" or "Light");
                local InnerBorders = p65.arguments.InnerBorders;

                if InnerBorders then
                    if _rowIndex == 1 then
                        InnerBorders = p65.arguments.Header and p65.arguments.InnerBorders and p65._rowInstances[0] ~= nil;
                    else
                        InnerBorders = true;
                    end;
                end;

                v69.Visible = InnerBorders;
                p65._rowBorders[_rowIndex - 1] = v69;
                v69.Parent = p65._rowContainer;
            end;

            return p65._cellInstances[_rowIndex][_columnIndex];
        end,

        ChildDiscarded = function(p70, p71) -- Line: 614, Name: ChildDiscarded
            -- upvalues: u4 (copy)
            local Parent = p71.Instance.Parent;
            local v72 = Parent ~= nil and tonumber(Parent.Name:sub(6));

            if v72 then
                u4[p70][v72] = true;
            end;
        end,

        Discard = function(p73) -- Line: 625, Name: Discard
            -- upvalues: u3 (copy), u4 (copy), u2 (copy)
            u3[p73.ID] = nil;
            u4[p73] = nil;
            p73.Instance:Destroy();
            u2.discardState(p73);
        end
    });
end;