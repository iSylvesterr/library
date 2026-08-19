-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
require(script.Parent.Parent.Types);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
require(ReplicatedStorage.Database.Custom.GameStats.UI.Settings.Pages);

return function(u1, p2, p3, p4, u5, p6, p7, u8, u9) -- Line: 20
    -- upvalues: Janitor (copy), GuiService (copy), UserInputService (copy)
    u5.Name = u1;
    u5.Left.Label.Text = p2.DisplayName or u1;
    u5.LayoutOrder = p4;
    local u10 = p2.HasEnabledToggle or false;
    local u11 = p2.Step or 1;
    local u12 = p2.Max or 100;
    local u13 = p2.Min or 0;
    local u14 = p6;
    local u15 = false;
    local u16 = p7 == nil and true or (p7 or true);
    local u17 = Janitor.new();
    u17:Add(u5, "Destroy");
    local Slider = u5.Right.Slider.Container.Left.Slider;
    local Button = Slider.Button;
    local Title = u5.Right.Slider.Container.Container.Left.Title;
    Slider.AutoButtonColor = false;
    Slider.Active = false;
    Button.AutoButtonColor = false;
    Button.Active = false;
    Title.Selectable = true;
    u5.Right.Slider.Active = false;

    if u5:FindFirstChild("Check") and not u10 then
        u5.Check.Visible = false;
    end;

    local function FormatNumber(p18) -- Line: 73
        local v19 = math.round(p18 * 100) / 100;

        if v19 ~= math.floor(v19) then
            return string.format("%.2f", v19):gsub("%.?0+$", "");
        end;

        local v20 = math.floor(v19);

        return tostring(v20);
    end;

    local function UpdateSlider(p21, p22) -- Line: 84
        -- upvalues: u13 (copy), u12 (copy), u11 (copy), u14 (ref), Slider (copy), Button (copy), Title (copy), u8 (copy), u9 (copy), u1 (copy)
        local v23 = math.clamp(p21, u13, u12) / u11;
        local v24 = math.round(v23) * u11;
        u14 = v24;
        local v25 = (v24 - u13) / (u12 - u13);
        Slider.Bar.Size = UDim2.new(v25, 0, 1, 0);
        Button.Position = UDim2.new(v25, 0, 0.5, 0);
        local v26 = math.round(v24 * 100) / 100;
        local v27;

        if v26 == math.floor(v26) then
            local v28 = math.floor(v26);
            v27 = tostring(v28);
        else
            v27 = string.format("%.2f", v26):gsub("%.?0+$", "");
        end;

        Title.Text = v27;

        if p22 then
            u8(u9, u1, u14, true);
        end;
    end;

    local function UpdateSliderFromMouse(p29, p30) -- Line: 101
        -- upvalues: Slider (copy), u13 (copy), u12 (copy), UpdateSlider (copy)
        UpdateSlider(u13 + math.clamp((p29 - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1) * (u12 - u13), p30);
    end;

    UpdateSlider(u14);
    u17:Add(Slider.InputBegan:Connect(function(p31) -- Line: 113
        -- upvalues: u16 (ref), u15 (ref), GuiService (ref), Slider (copy), u13 (copy), u12 (copy), UpdateSlider (copy)
        if (p31.UserInputType == Enum.UserInputType.MouseButton1 or p31.UserInputType == Enum.UserInputType.Touch) and u16 then
            u15 = true;
            local v32 = GuiService:GetGuiInset();
            UpdateSlider(u13 + math.clamp((p31.Position.X - v32.X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1) * (u12 - u13), nil);
        end;
    end), "Disconnect");
    u17:Add(Slider.InputEnded:Connect(function(p33) -- Line: 123
        -- upvalues: u15 (ref), u10 (copy), u8 (copy), u9 (copy), u1 (copy), u16 (ref), u14 (ref)
        if p33.UserInputType ~= Enum.UserInputType.MouseButton1 and p33.UserInputType ~= Enum.UserInputType.Touch or not u15 then
            return;
        end;

        u15 = false;

        if u10 then
            u8(u9, u1, {
                Enabled = u16,
                Value = u14
            }, false);

            return;
        end;

        u8(u9, u1, u14, false);
    end), "Disconnect");
    u17:Add(Button.InputBegan:Connect(function(p34) -- Line: 138
        -- upvalues: u16 (ref), u15 (ref), UserInputService (ref), GuiService (ref), Slider (copy), u13 (copy), u12 (copy), UpdateSlider (copy)
        if (p34.UserInputType == Enum.UserInputType.MouseButton1 or p34.UserInputType == Enum.UserInputType.Touch) and u16 then
            u15 = true;

            while task.wait(0.01) and u15 do
                local v35 = UserInputService:GetMouseLocation();
                local v36 = GuiService:GetGuiInset();
                UpdateSlider(u13 + math.clamp((v35.X - v36.X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1) * (u12 - u13), true);
            end;
        end;
    end), "Disconnect");
    u17:Add(Button.InputEnded:Connect(function(p37) -- Line: 151
        -- upvalues: u15 (ref), u10 (copy), u8 (copy), u9 (copy), u1 (copy), u16 (ref), u14 (ref)
        if p37.UserInputType ~= Enum.UserInputType.MouseButton1 and p37.UserInputType ~= Enum.UserInputType.Touch or not u15 then
            return;
        end;

        u15 = false;

        if u10 then
            u8(u9, u1, {
                Enabled = u16,
                Value = u14
            }, false);

            return;
        end;

        u8(u9, u1, u14, false);
    end), "Disconnect");
    u17:Add(UserInputService.InputChanged:Connect(function(p38) -- Line: 187
        -- upvalues: u15 (ref), Slider (copy), u13 (copy), u12 (copy), UpdateSlider (copy)
        if u15 and (p38.UserInputType == Enum.UserInputType.MouseMovement or p38.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(u13 + math.clamp((p38.Position.X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1) * (u12 - u13), true);
        end;
    end), "Disconnect");
    u17:Add(Title.FocusLost:Connect(function() -- Line: 194
        -- upvalues: u16 (ref), Title (copy), UpdateSlider (copy), u10 (copy), u8 (copy), u9 (copy), u1 (copy), u14 (ref)
        if not u16 then
            return;
        end;

        local v39 = tonumber(Title.Text);

        if v39 then
            UpdateSlider(v39);

            if u10 then
                u8(u9, u1, {
                    Enabled = u16,
                    Value = u14
                }, false);

                return;
            end;

            u8(u9, u1, u14, false);

            return;
        end;

        local v40 = math.round(u14 * 100) / 100;
        local v41;

        if v40 == math.floor(v40) then
            local v42 = math.floor(v40);
            v41 = tostring(v42);
        else
            v41 = string.format("%.2f", v40):gsub("%.?0+$", "");
        end;

        Title.Text = v41;
    end), "Disconnect");

    if u5:FindFirstChild("Check") and u10 then
        u5.Check.ImageLabel.Visible = u16;
        u5.Frame.TextBox.TextEditable = u16;
        Button.Active = u16;
        Slider.Active = u16;
        u5.Slider.Bar.BackgroundTransparency = u16 and 0 or 0.5;
        u5.Slider.Button.ImageTransparency = u16 and 0 or 0.5;
        u5.Frame.TextBox.TextTransparency = u16 and 0 or 0.5;
        u5.Slider.ImageTransparency = u16 and 0 or 0.5;
        u17:Add(u5.Check.MouseButton1Click:Connect(function() -- Line: 232
            -- upvalues: u16 (ref), u5 (copy), Slider (copy), Button (copy), u8 (copy), u9 (copy), u1 (copy), u14 (ref)
            u16 = not u16;
            u5.Check.ImageLabel.Visible = u16;
            Slider.Active = u16;
            Button.Active = u16;
            u5.Frame.TextBox.TextEditable = u16;
            u5.Slider.ImageTransparency = u16 and 0 or 0.5;
            u5.Slider.Bar.BackgroundTransparency = u16 and 0 or 0.5;
            u5.Slider.Button.ImageTransparency = u16 and 0 or 0.5;
            u5.Frame.TextBox.TextTransparency = u16 and 0 or 0.5;
            u8(u9, u1, {
                Enabled = u16,
                Value = u14
            }, false);
        end), "Disconnect");
    end;

    u5.Parent = p3;

    return function() -- Line: 254
        -- upvalues: u15 (ref), u17 (copy)
        u15 = false;
        u17:Cleanup();
    end;
end;