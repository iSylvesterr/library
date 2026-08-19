-- Decompiled with Potassium's decompiler.

return function() -- Line: 6
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "letterbox_Moon2Cutscene";
    ScreenGui.IgnoreGuiInset = true;

    local function createFrame() -- Line: 15
        -- upvalues: ScreenGui (copy)
        local Frame = Instance.new("Frame");
        Frame.Name = "Letterbox";
        Frame.Size = UDim2.fromScale(1, 0.122);
        Frame.BackgroundTransparency = 1;
        Frame.ZIndex = -499;
        Frame.Selectable = false;
        Frame.BackgroundColor3 = Color3.new(0, 0, 0);
        Frame.Parent = ScreenGui;

        return Frame;
    end;

    local u1 = createFrame();
    local u2 = createFrame();
    u2.Position = UDim2.fromScale(0, 1);
    u2.AnchorPoint = Vector2.new(0, 1);
    u2.Changed:Connect(function(u3) -- Line: 37
        -- upvalues: u1 (copy), u2 (copy)
        pcall(function() -- Line: 38
            -- upvalues: u1 (ref), u3 (copy), u2 (ref)
            u1[u3] = u2[u3];
        end);
    end);
    ScreenGui.Parent = game:GetService("Players").LocalPlayer.PlayerGui;

    return u2;
end;