-- Decompiled with Potassium's decompiler.

local GuiService = game:GetService("GuiService");
local UserInputService = game:GetService("UserInputService");
local TextChatService = game:GetService("TextChatService");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local u1 = { Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2, Enum.UserInputType.Touch };
local u2 = {
    Valid = true,
    AutoComplete = nil,
    ProcessEntry = nil,
    OnTextChanged = nil,
    Cmdr = nil,
    HistoryState = nil
};
local Frame = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Cmdr"):WaitForChild("Frame");
local Line = Frame:WaitForChild("Line");
local Entry = Frame:WaitForChild("Entry");
Line.Parent = nil;

function u2.UpdateLabel(p3) -- Line: 29
    -- upvalues: Entry (copy), LocalPlayer (copy)
    Entry.TextLabel.Text = LocalPlayer.Name .. "@" .. p3.Cmdr.PlaceName .. "$";
end;

function u2.GetLabel(p4) -- Line: 34
    -- upvalues: Entry (copy)
    return Entry.TextLabel.Text;
end;

function u2.UpdateWindowHeight(p5) -- Line: 39
    -- upvalues: Frame (copy)
    local v6 = Frame.UIListLayout.AbsoluteContentSize.Y + Frame.UIPadding.PaddingTop.Offset + Frame.UIPadding.PaddingBottom.Offset;
    Frame.Size = UDim2.new(Frame.Size.X.Scale, Frame.Size.X.Offset, 0, (math.clamp(v6, 0, 300)));
    Frame.CanvasPosition = Vector2.new(0, v6);
end;

function u2.AddLine(p7, p8, p9) -- Line: 48
    -- upvalues: u2 (copy), Line (copy), Frame (copy)
    local v10 = p9 or {};
    local v11 = tostring(p8);
    local v12 = typeof(v10) == "Color3" and {
        Color = v10
    } or v10;

    if #v11 == 0 then
        u2:UpdateWindowHeight();

        return;
    end;

    local v13 = p7.Cmdr.Util.EmulateTabstops(v11 or "nil", 8);
    local v14 = Line:Clone();
    v14.Text = v13;
    v14.TextColor3 = v12.Color or v14.TextColor3;
    v14.RichText = v12.RichText or false;
    v14.Parent = Frame;
end;

function u2.IsVisible(p15) -- Line: 71
    -- upvalues: Frame (copy)
    return Frame.Visible;
end;

function u2.SetVisible(p16, p17) -- Line: 76
    -- upvalues: Frame (copy), TextChatService (copy), Entry (copy), UserInputService (copy)
    Frame.Visible = p17;

    if p17 then
        p16.PreviousChatWindowConfigurationEnabled = TextChatService.ChatWindowConfiguration.Enabled;
        p16.PreviousChatInputBarConfigurationEnabled = TextChatService.ChatInputBarConfiguration.Enabled;
        TextChatService.ChatWindowConfiguration.Enabled = false;
        TextChatService.ChatInputBarConfiguration.Enabled = false;
        Entry.TextBox:CaptureFocus();
        p16:SetEntryText("");

        if p16.Cmdr.ActivationUnlocksMouse then
            p16.PreviousMouseBehavior = UserInputService.MouseBehavior;
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
        end;
    else
        TextChatService.ChatWindowConfiguration.Enabled = p16.PreviousChatWindowConfigurationEnabled == nil and true or p16.PreviousChatWindowConfigurationEnabled;
        TextChatService.ChatInputBarConfiguration.Enabled = p16.PreviousChatInputBarConfigurationEnabled == nil and true or p16.PreviousChatInputBarConfigurationEnabled;
        Entry.TextBox:ReleaseFocus();
        p16.AutoComplete:Hide();

        if p16.PreviousMouseBehavior then
            UserInputService.MouseBehavior = p16.PreviousMouseBehavior;
            p16.PreviousMouseBehavior = nil;
        end;
    end;
end;

function u2.Hide(p18) -- Line: 109
    return p18:SetVisible(false);
end;

function u2.Show(p19) -- Line: 114
    return p19:SetVisible(true);
end;

function u2.SetEntryText(p20, p21) -- Line: 119
    -- upvalues: Entry (copy), u2 (copy)
    Entry.TextBox.Text = p21;

    if p20:IsVisible() then
        Entry.TextBox:CaptureFocus();
        Entry.TextBox.CursorPosition = #p21 + 1;
        u2:UpdateWindowHeight();
    end;
end;

function u2.GetEntryText(p22) -- Line: 130
    -- upvalues: Entry (copy)
    return Entry.TextBox.Text:gsub("\t", "");
end;

function u2.SetIsValidInput(p23, p24, p25) -- Line: 136
    -- upvalues: Entry (copy)
    Entry.TextBox.TextColor3 = p24 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 73, 73);
    p23.Valid = p24;
    p23._errorText = p25;
end;

function u2.HideInvalidState(p26) -- Line: 142
    -- upvalues: Entry (copy)
    Entry.TextBox.TextColor3 = Color3.fromRGB(255, 255, 255);
end;

function u2.LoseFocus(p27, p28) -- Line: 147
    -- upvalues: Entry (copy), Frame (copy), GuiService (copy)
    local Text = Entry.TextBox.Text;
    p27:ClearHistoryState();

    if Frame.Visible and not GuiService.MenuIsOpen then
        Entry.TextBox:CaptureFocus();
    elseif GuiService.MenuIsOpen and Frame.Visible then
        p27:Hide();
    end;

    if not (p28 and p27.Valid) then
        if p28 then
            p27:AddLine(p27._errorText, Color3.fromRGB(255, 153, 153));
        end;

        return;
    end;

    wait();
    p27:SetEntryText("");
    p27.ProcessEntry(Text);
end;

function u2.TraverseHistory(p29, p30) -- Line: 168
    local v31 = p29.Cmdr.Dispatcher:GetHistory();

    if p29.HistoryState == nil then
        p29.HistoryState = {
            Position = #v31 + 1,
            InitialText = p29:GetEntryText()
        };
    end;

    p29.HistoryState.Position = math.clamp(p29.HistoryState.Position + p30, 1, #v31 + 1);
    p29:SetEntryText(p29.HistoryState.Position == #v31 + 1 and p29.HistoryState.InitialText or v31[p29.HistoryState.Position]);
end;

function u2.ClearHistoryState(p32) -- Line: 186
    p32.HistoryState = nil;
end;

function u2.SelectVertical(p33, p34) -- Line: 190
    if p33.AutoComplete:IsVisible() and not p33.HistoryState then
        p33.AutoComplete:Select(p34);

        return;
    end;

    p33:TraverseHistory(p34);
end;

local u35 = 0;
local u36 = 0;

function u2.BeginInput(p37, p38, p39) -- Line: 201
    -- upvalues: GuiService (copy), u35 (ref), u36 (ref), u1 (copy), Frame (copy)
    if GuiService.MenuIsOpen then
        p37:Hide();
    end;

    if p39 and p37:IsVisible() == false then
        return;
    end;

    if not p37.Cmdr.ActivationKeys[p38.KeyCode] then
        if p37.Cmdr.Enabled == false or not p37:IsVisible() then
            if p37:IsVisible() then
                p37:Hide();
            end;

            return;
        end;

        if p37.Cmdr.HideOnLostFocus and table.find(u1, p38.UserInputType) then
            local Position = p38.Position;
            local AbsolutePosition = Frame.AbsolutePosition;
            local AbsoluteSize = Frame.AbsoluteSize;

            if Position.X < AbsolutePosition.X or (Position.X > AbsolutePosition.X + AbsoluteSize.X or (Position.Y < AbsolutePosition.Y or Position.Y > AbsolutePosition.Y + AbsoluteSize.Y)) then
                p37:Hide();

                return;
            end;
        else
            if p38.KeyCode == Enum.KeyCode.Down then
                p37:SelectVertical(1);

                return;
            end;

            if p38.KeyCode == Enum.KeyCode.Up then
                p37:SelectVertical(-1);

                return;
            end;

            if p38.KeyCode == Enum.KeyCode.Return then
                wait();
                p37:SetEntryText(p37:GetEntryText():gsub("\n", ""):gsub("\r", ""));

                return;
            end;

            if p38.KeyCode == Enum.KeyCode.Tab then
                local v40 = p37.AutoComplete:GetSelectedItem();
                local v41 = p37:GetEntryText();

                if not v40 or v41:sub(#v41, #v41):match("%s") and p37.AutoComplete.LastItem then
                    wait();
                    p37:SetEntryText(p37:GetEntryText());

                    return;
                end;

                local v42 = v40[2];
                local Command = p37.AutoComplete.Command;
                local v43, v44;

                if Command then
                    local Arg = p37.AutoComplete.Arg;
                    v43 = Command.Alias;

                    if p37.AutoComplete.NumArgs == #Command.ArgumentDefinitions then
                        v44 = false;
                    else
                        v44 = p37.AutoComplete.IsPartial == false;
                    end;

                    local Arguments = Command.Arguments;

                    for i = 1, #Arguments do
                        local v45 = Arguments[i];
                        local RawSegments = v45.RawSegments;

                        if v45 == Arg then
                            RawSegments[#RawSegments] = v42;
                        end;

                        local v46 = v45.Prefix .. table.concat(RawSegments, ",");

                        if v46:find(" ") or v46 == "" then
                            v46 = ("%q"):format(v46);
                        end;

                        v43 = ("%s %s"):format(v43, v46);

                        if v45 == Arg then
                            break;
                        end;
                    end;
                else
                    v43 = v42;
                    v44 = true;
                end;

                wait();
                p37:SetEntryText(v43 .. (v44 and " " or ""));

                return;
            end;

            p37:ClearHistoryState();
        end;

        return;
    end;

    if not p37.Cmdr.MashToEnable or p37.Cmdr.Enabled then
        if p37.Cmdr.Enabled then
            p37:SetVisible(not p37:IsVisible());
            wait();
            p37:SetEntryText("");

            if GuiService.MenuIsOpen then
                p37:Hide();
            end;
        end;

        return;
    end;

    if tick() - u35 < 1 then
        if u36 >= 5 then
            return p37.Cmdr:SetEnabled(true);
        end;

        u36 = u36 + 1;
    else
        u36 = 1;
    end;

    u35 = tick();
end;

Entry.TextBox.FocusLost:Connect(function(p47) -- Line: 312
    -- upvalues: u2 (copy)
    return u2:LoseFocus(p47);
end);
UserInputService.InputBegan:Connect(function(p48, p49) -- Line: 316
    -- upvalues: u2 (copy)
    return u2:BeginInput(p48, p49);
end);
Entry.TextBox:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 320
    -- upvalues: Frame (copy), Entry (copy), u2 (copy)
    Frame.CanvasPosition = Vector2.new(0, Frame.AbsoluteCanvasSize.Y);

    if Entry.TextBox.Text:match("\t") then
        Entry.TextBox.Text = Entry.TextBox.Text:gsub("\t", "");

        return;
    end;

    if u2.OnTextChanged then
        return u2.OnTextChanged(Entry.TextBox.Text);
    end;
end);
Frame.ChildAdded:Connect(function() -- Line: 332
    -- upvalues: u2 (copy)
    task.defer(u2.UpdateWindowHeight);
end);

return u2;