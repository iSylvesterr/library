-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local u1 = {
    BackgroundTransparency = 0.05,
    BorderSizePixel = 20,
    ClearTextOnFocus = false,
    MultiLine = true,
    TextWrapped = true,
    TextSize = 18,
    TextXAlignment = "Left",
    TextYAlignment = "Top",
    AutoLocalize = false,
    PlaceholderText = "Right click to exit",
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Color3.fromRGB(17, 17, 17),
    BorderColor3 = Color3.fromRGB(17, 17, 17),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(0.5, 0, 0.4, 0),
    Font = Enum.Font.Code,
    TextColor3 = Color3.fromRGB(241, 241, 241)
};
local u2 = nil;

return {
    Name = "edit",
    Description = "Edit text in a TextBox",
    Group = "DefaultUtil",
    Aliases = {},
    Args = { {
            Type = "string",
            Name = "Input text",
            Description = "The text you wish to edit",
            Default = ""
        }, {
            Type = "string",
            Name = "Delimiter",
            Description = "The character that separates each line",
            Default = ","
        } },

    ClientRun = function(p3, p4, u5) -- Line: 45, Name: ClientRun
        -- upvalues: u2 (ref), u1 (copy), Players (copy)
        u2 = u2 or p3.Cmdr.Util.Mutex();
        local u6 = u2();
        p3:Reply("Right-click on the text area to exit.", Color3.fromRGB(158, 158, 158));
        local ScreenGui = Instance.new("ScreenGui");
        ScreenGui.Name = "CmdrEditBox";
        ScreenGui.ResetOnSpawn = false;
        local TextBox = Instance.new("TextBox");

        for i, v in pairs(u1) do
            TextBox[i] = v;
        end;

        TextBox.Text = p4:gsub(u5, "\n");
        TextBox.Parent = ScreenGui;
        ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui");
        local u7 = coroutine.running();
        TextBox.InputBegan:Connect(function(p8) -- Line: 69
            -- upvalues: u7 (copy), TextBox (copy), u5 (copy), ScreenGui (copy), u6 (copy)
            if p8.UserInputType == Enum.UserInputType.MouseButton2 then
                coroutine.resume(u7, TextBox.Text:gsub("\n", u5));
                ScreenGui:Destroy();
                u6();
            end;
        end);

        return coroutine.yield();
    end
};