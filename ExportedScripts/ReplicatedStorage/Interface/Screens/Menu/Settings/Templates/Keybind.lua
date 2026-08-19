-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
require(ReplicatedStorage.Database.Custom.GameStats.UI.Settings.Pages);

return function(u1, p2, p3, p4, u5, p6, u7, u8, u9, p10) -- Line: 18
    -- upvalues: Janitor (copy)
    u5.LayoutOrder = p4;
    u5.Left.Label.Text = p2.DisplayName or u1;
    u5.Name = u1;
    local u11 = p6.Computer == nil and "" or p6.Computer;
    local u12 = p6.Console == nil and "" or p6.Console;
    local u13 = Janitor.new();
    u13:Add(u5, "Destroy");

    if p6.Computer == nil and p2.Default then
        local Default = p2.Default;
        u11 = typeof(Default) == "table" and (Default.Computer or "") or "";
    end;

    if p6.Console == nil and p2.Default then
        local Default = p2.Default;
        u12 = typeof(Default) == "table" and (Default.Console or "") or "";
    end;

    local function FormatKeybind(p14) -- Line: 56
        return (p14 == "" or p14 == nil) and "" or p14:gsub("Enum%.KeyCode%.", ""):gsub("Enum%.UserInputType%.", ""):gsub("Enum%.CustomInputType%.", "");
    end;

    local function UpdateKeybindUI(p15, p16) -- Line: 67
        local TextBox = p15:FindFirstChild("TextBox");
        local Reset = p15:FindFirstChild("Reset");

        if not TextBox then
            return;
        end;

        if p16 == "" then
            TextBox.Text = "";
            TextBox.PlaceholderText = "None";
            TextBox.TextEditable = false;
            TextBox.Active = true;

            if Reset then
                Reset.Visible = false;
            end;
        else
            TextBox.Text = (p16 == "" or p16 == nil) and "" or p16:gsub("Enum%.KeyCode%.", ""):gsub("Enum%.UserInputType%.", ""):gsub("Enum%.CustomInputType%.", "");
            TextBox.PlaceholderText = "";
            TextBox.TextEditable = false;
            TextBox.Active = true;

            if Reset then
                Reset.Visible = true;
            end;
        end;
    end;

    local function SaveKeybinds() -- Line: 106
        -- upvalues: u7 (copy), u8 (copy), u1 (copy), u11 (ref), u12 (ref)
        u7(u8, u1, {
            Computer = u11,
            Console = u12
        });
    end;

    if u5.Right:FindFirstChild("Computer") then
        UpdateKeybindUI(u5.Right.Computer, u11);
        u13:Add(u5.Right.Computer.TextBox.Focused:Connect(function() -- Line: 119
            -- upvalues: u9 (copy), u5 (copy), u11 (ref)
            local v17 = u11;
            u9(u5.Right.Computer.TextBox, (v17 == "" or v17 == nil) and "" or v17:gsub("Enum%.KeyCode%.", ""):gsub("Enum%.UserInputType%.", ""):gsub("Enum%.CustomInputType%.", ""), tick());
        end), "Disconnect");
        u13:Add(u5.Right.Computer.Reset.MouseButton1Click:Connect(function() -- Line: 124
            -- upvalues: u11 (ref), UpdateKeybindUI (copy), u5 (copy), u7 (copy), u8 (copy), u1 (copy), u12 (ref)
            u11 = "";
            UpdateKeybindUI(u5.Right.Computer, u11);
            u7(u8, u1, {
                Computer = u11,
                Console = u12
            });
        end), "Disconnect");
        p10("Computer", u11);
    end;

    if u5.Right:FindFirstChild("Console") then
        UpdateKeybindUI(u5.Right.Console, u12);
        u13:Add(u5.Right.Console.TextBox.Focused:Connect(function() -- Line: 141
            -- upvalues: u9 (copy), u5 (copy), u12 (ref)
            local v18 = u12;
            u9(u5.Right.Console.TextBox, (v18 == "" or v18 == nil) and "" or v18:gsub("Enum%.KeyCode%.", ""):gsub("Enum%.UserInputType%.", ""):gsub("Enum%.CustomInputType%.", ""), tick());
        end), "Disconnect");
        u13:Add(u5.Right.Console.Reset.MouseButton1Click:Connect(function() -- Line: 146
            -- upvalues: u12 (ref), UpdateKeybindUI (copy), u5 (copy), u7 (copy), u8 (copy), u1 (copy), u11 (ref)
            u12 = "";
            UpdateKeybindUI(u5.Right.Console, u12);
            u7(u8, u1, {
                Computer = u11,
                Console = u12
            });
        end), "Disconnect");
        p10("Console", u12);
    end;

    u5.Parent = p3;

    return function() -- Line: 161
        -- upvalues: u13 (copy)
        u13:Cleanup();
    end;
end;