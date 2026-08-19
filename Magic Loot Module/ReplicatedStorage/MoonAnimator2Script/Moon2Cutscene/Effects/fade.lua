-- Decompiled with Potassium's decompiler.

return function(u1, u2, u3, p4) -- Line: 10
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "fade_Moon2Cutscene";
    ScreenGui.IgnoreGuiInset = true;
    local Frame = Instance.new("Frame", ScreenGui);
    Frame.Name = "FadeFrame";
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.BackgroundTransparency = 1;
    Frame.BackgroundColor3 = p4 or Color3.new(0, 0, 0);
    ScreenGui.Parent = game:GetService("Players").LocalPlayer.PlayerGui;

    return function() -- Line: 23
        -- upvalues: u1 (copy), Frame (copy), u2 (copy), u3 (copy)
        if u1 then
            game:GetService("TweenService"):Create(Frame, TweenInfo.new(u1), {
                BackgroundTransparency = 0
            }):Play();
            task.wait(u1);
        else
            Frame.BackgroundTransparency = 0;
        end;

        task.wait(u2);

        if u3 then
            game:GetService("TweenService"):Create(Frame, TweenInfo.new(u3), {
                BackgroundTransparency = 1
            }):Play();

            return;
        end;

        Frame.BackgroundTransparency = 1;
    end, ScreenGui;
end;