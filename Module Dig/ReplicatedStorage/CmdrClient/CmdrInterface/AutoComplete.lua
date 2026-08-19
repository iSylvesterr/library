-- Decompiled with Potassium's decompiler.

local LocalPlayer = game:GetService("Players").LocalPlayer;

return function(p1) -- Line: 5
    -- upvalues: LocalPlayer (copy)
    local u2 = {
        SelectedItem = 0,
        Items = {},
        ItemOptions = {}
    };
    local Util = p1.Util;
    local Autocomplete = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Cmdr"):WaitForChild("Autocomplete");
    local TextButton = Autocomplete:WaitForChild("TextButton");
    local Title = Autocomplete:WaitForChild("Title");
    local Description = Autocomplete:WaitForChild("Description");
    local Entry = Autocomplete.Parent:WaitForChild("Frame"):WaitForChild("Entry");
    TextButton.Parent = nil;
    local ScrollBarThickness = Autocomplete.ScrollBarThickness;

    local function SetText(p3, p4, p5, p6) -- Line: 24
        -- upvalues: Util (copy)
        p3.Visible = p5 ~= nil;
        p4.Text = p5 or "";

        if p6 then
            p4.Size = UDim2.new(0, Util.GetTextSize(p5 or "", p4, Vector2.new(1000, 1000), 1, 0).X, p3.Size.Y.Scale, p3.Size.Y.Offset);
        end;
    end;

    local function UpdateContainerSize() -- Line: 38
        -- upvalues: Autocomplete (copy), Title (copy)
        Autocomplete.Size = UDim2.new(0, math.max(Title.Field.TextBounds.X + Title.Field.Type.TextBounds.X, Autocomplete.Size.X.Offset), 0, (math.min(Autocomplete.UIListLayout.AbsoluteContentSize.Y, Autocomplete.Parent.AbsoluteSize.Y - Autocomplete.AbsolutePosition.Y - 10)));
    end;

    local function UpdateInfoDisplay(p7) -- Line: 48
        -- upvalues: SetText (copy), Title (copy), Description (copy), Autocomplete (copy), UpdateContainerSize (copy), ScrollBarThickness (copy)
        SetText(Title, Title.Field, p7.name, true);
        local Type = Title.Field.Type;
        local Type2 = Title.Field.Type;
        local v8 = p7.type and ": " .. p7.type:sub(1, 1):upper() .. p7.type:sub(2);
        Type.Visible = v8 ~= nil;
        Type2.Text = v8 or "";
        local Label = Description.Label;
        local description = p7.description;
        Description.Visible = description ~= nil;
        Label.Text = description or "";
        Description.Label.TextColor3 = p7.invalid and Color3.fromRGB(255, 73, 73) or Color3.fromRGB(255, 255, 255);
        Description.Size = UDim2.new(1, 0, 0, 40);

        while not Description.Label.TextFits do
            Description.Size = Description.Size + UDim2.new(0, 0, 0, 2);

            if Description.Size.Y.Offset > 500 then
                break;
            end;
        end;

        task.wait();
        Autocomplete.UIListLayout:ApplyLayout();
        UpdateContainerSize();
        Autocomplete.ScrollBarThickness = ScrollBarThickness;
    end;

    function u2.Show(p9, p10, p11) -- Line: 88
        -- upvalues: Autocomplete (copy), TextButton (copy), Entry (copy), Util (copy), UpdateInfoDisplay (copy)
        local v12 = p11 or {};

        for _, v in pairs(p9.Items) do
            if v.gui then
                v.gui:Destroy();
            end;
        end;

        p9.SelectedItem = 1;
        p9.Items = p10;
        p9.Prefix = v12.prefix or "";
        p9.LastItem = v12.isLast or false;
        p9.Command = v12.command;
        p9.Arg = v12.arg;
        p9.NumArgs = v12.numArgs;
        p9.IsPartial = v12.isPartial;
        Autocomplete.ScrollBarThickness = 0;
        local v13 = 200;

        for i, v in pairs(p9.Items) do
            local v14 = v[1];
            local v15 = v[2];
            local v16 = TextButton:Clone();
            v16.Name = v14 .. v15;
            v16.BackgroundTransparency = i == p9.SelectedItem and 0.5 or 1;
            local v17, v18 = string.find(v15:lower(), v14:lower(), 1, true);
            v16.Typed.Text = string.rep(" ", v17 - 1) .. v14;
            v16.Suggest.Text = string.sub(v15, 0, v17 - 1) .. string.rep(" ", #v14) .. string.sub(v15, v18 + 1);
            v16.Parent = Autocomplete;
            v16.LayoutOrder = i;
            local v19 = math.max(v16.Typed.TextBounds.X, v16.Suggest.TextBounds.X) + 20;

            if v13 < v19 then
                v13 = v19;
            end;

            v.gui = v16;
        end;

        Autocomplete.UIListLayout:ApplyLayout();
        local Text = Entry.TextBox.Text;
        local v20 = Util.SplitString(Text);

        if Text:sub(#Text, #Text) == " " and not v12.at then
            v20[#v20 + 1] = "e";
        end;

        table.remove(v20, #v20);
        local v21 = v12.at and v12.at or #table.concat(v20, " ") + 1;
        Autocomplete.Position = UDim2.new(0, Entry.TextBox.AbsolutePosition.X - 10 + v21 * 7, 0, Entry.TextBox.AbsolutePosition.Y + 30);
        Autocomplete.Size = UDim2.new(0, v13, 0, Autocomplete.UIListLayout.AbsoluteContentSize.Y);
        Autocomplete.Visible = true;

        if p9.Items[1] then
            v12 = p9.Items[1].options or v12;
        end;

        UpdateInfoDisplay(v12);
    end;

    function u2.GetSelectedItem(p22) -- Line: 161
        -- upvalues: Autocomplete (copy), u2 (copy)
        if Autocomplete.Visible == false then
            return nil;
        end;

        return u2.Items[u2.SelectedItem];
    end;

    function u2.Hide(p23) -- Line: 170
        -- upvalues: Autocomplete (copy)
        Autocomplete.Visible = false;
    end;

    function u2.IsVisible(p24) -- Line: 175
        -- upvalues: Autocomplete (copy)
        return Autocomplete.Visible;
    end;

    function u2.Select(p25, p26) -- Line: 180
        -- upvalues: Autocomplete (copy), Title (copy), Description (copy), TextButton (copy), UpdateInfoDisplay (copy)
        if not Autocomplete.Visible then
            return;
        end;

        p25.SelectedItem = p25.SelectedItem + p26;

        if p25.SelectedItem > #p25.Items then
            p25.SelectedItem = 1;
        elseif p25.SelectedItem < 1 then
            p25.SelectedItem = #p25.Items;
        end;

        for i, v in pairs(p25.Items) do
            v.gui.BackgroundTransparency = i == p25.SelectedItem and 0.5 or 1;
        end;

        Autocomplete.CanvasPosition = Vector2.new(0, (math.max(0, Title.Size.Y.Offset + Description.Size.Y.Offset + p25.SelectedItem * TextButton.Size.Y.Offset - Autocomplete.Size.Y.Offset)));

        if p25.Items[p25.SelectedItem] and p25.Items[p25.SelectedItem].options then
            UpdateInfoDisplay(p25.Items[p25.SelectedItem].options or {});
        end;
    end;

    Autocomplete.Parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateContainerSize);

    return u2;
end;