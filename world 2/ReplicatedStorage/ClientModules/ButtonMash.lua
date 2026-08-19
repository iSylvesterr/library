-- Decompiled with Potassium's decompiler.

local v1 = {};
local LocalPlayer = game:GetService("Players").LocalPlayer;
local ButtonMash = LocalPlayer.PlayerGui:WaitForChild("ButtonMash");
local Button = ButtonMash.Button;
local Frame = Button.ProgressBar.Frame;
local u2 = false;

function v1.Disable() -- Line: 15
    -- upvalues: u2 (ref)
    u2 = false;
end;

function v1.Start(u3, u4) -- Line: 19
    -- upvalues: u2 (ref), ButtonMash (copy), Frame (copy), Button (copy), LocalPlayer (copy)
    if not u2 then
        u2 = true;
        ButtonMash.Enabled = true;
        Frame.Size = UDim2.fromScale(0, 1);
        local u5 = 0;
        task.spawn(function() -- Line: 35
            -- upvalues: u2 (ref), u4 (copy), u5 (ref), Frame (ref)
            while u2 do
                task.wait(u4 or 0.5);
                u5 = math.clamp(u5 - 0.1, 0, 1);
                Frame.Size = UDim2.fromScale(u5, 1);
            end;
        end);
        local u6 = nil;

        local function _() -- Line: 45
            -- upvalues: u5 (ref), u3 (copy), Frame (ref), u2 (ref), u6 (ref)
            u5 = math.min(u5 + u3, 1);
            Frame.Size = UDim2.fromScale(u5, 1);

            if u5 == 1 then
                u2 = false;
                u6 = "Success";
            end;
        end;

        local v7 = {};
        local InputBegan = game:GetService("UserInputService").InputBegan;
        table.insert(v7, InputBegan:Connect(function(p8, p9) -- Line: 58
            -- upvalues: Button (ref), u5 (ref), u3 (copy), Frame (ref), u2 (ref), u6 (ref)
            if not p9 and (p8.KeyCode == Enum.KeyCode.Space or p8.KeyCode == Enum.KeyCode.ButtonA) then
                if p8.KeyCode == Enum.KeyCode.ButtonA then
                    Button.HoverOver.Visible = true;
                    task.delay(0.1, function() -- Line: 64
                        -- upvalues: Button (ref)
                        Button.HoverOver.Visible = false;
                    end);
                end;

                u5 = math.min(u5 + u3, 1);
                Frame.Size = UDim2.fromScale(u5, 1);

                if u5 == 1 then
                    u2 = false;
                    u6 = "Success";
                end;
            end;
        end));
        table.insert(v7, Button.MouseButton1Down:Connect(function() -- Line: 73
            -- upvalues: u5 (ref), u3 (copy), Frame (ref), u2 (ref), u6 (ref)
            u5 = math.min(u5 + u3, 1);
            Frame.Size = UDim2.fromScale(u5, 1);

            if u5 == 1 then
                u2 = false;
                u6 = "Success";
            end;
        end));
        table.insert(v7, LocalPlayer.CharacterAdded:Connect(function() -- Line: 77
            -- upvalues: u6 (ref)
            u6 = false;
        end));

        local function updateInput() -- Line: 83
            -- upvalues: Button (ref)
            local v10 = game:GetService("UserInputService"):GetLastInputType() == Enum.UserInputType.Touch and "PRESS ME" or (game:GetService("UserInputService"):GetLastInputType() == Enum.UserInputType.Gamepad1 and game:GetService("GuiService"):IsTenFootInterface() and "ButtonA" or "SPACE");

            if v10 == "ButtonA" then
                Button.TextGroup.Visible = false;
                Button.GamepadIcon.Visible = true;
                Button.GamepadIcon.Image = game:GetService("UserInputService"):GetImageForKeyCode(Enum.KeyCode.ButtonA);
            else
                Button.GamepadIcon.Visible = false;
                Button.TextGroup.Visible = true;
            end;

            Button.TextGroup.TextLabel.Text = v10;
            Button.TextGroup.TextLabel.TextLabel.Text = v10;
        end;

        updateInput();
        local LastInputTypeChanged = game:GetService("UserInputService").LastInputTypeChanged;
        table.insert(v7, LastInputTypeChanged:Connect(updateInput));

        repeat
            task.wait();
        until u6 or not u2;

        for _, v in v7 do
            v:Disconnect();
        end;

        ButtonMash.Enabled = false;

        return u6 or false;
    end;
end;

return v1;