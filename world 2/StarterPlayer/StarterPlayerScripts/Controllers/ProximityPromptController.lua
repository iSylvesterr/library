-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 2
};
local UserInputService = game:GetService("UserInputService");
local ProximityPromptService = game:GetService("ProximityPromptService");
local TweenService = game:GetService("TweenService");
local TextService = game:GetService("TextService");
local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui");
local u2 = {
    [Enum.KeyCode.Backspace] = "rbxasset://textures/ui/Controls/backspace.png",
    [Enum.KeyCode.Return] = "rbxasset://textures/ui/Controls/return.png",
    [Enum.KeyCode.LeftShift] = "rbxasset://textures/ui/Controls/shift.png",
    [Enum.KeyCode.RightShift] = "rbxasset://textures/ui/Controls/shift.png",
    [Enum.KeyCode.Tab] = "rbxasset://textures/ui/Controls/tab.png"
};
local u3 = {
    ["\'"] = "rbxasset://textures/ui/Controls/apostrophe.png",
    [","] = "rbxasset://textures/ui/Controls/comma.png",
    ["`"] = "rbxasset://textures/ui/Controls/graveaccent.png",
    ["."] = "rbxasset://textures/ui/Controls/period.png",
    [" "] = "rbxasset://textures/ui/Controls/spacebar.png"
};
local u4 = {
    [Enum.KeyCode.LeftControl] = "Ctrl",
    [Enum.KeyCode.RightControl] = "Ctrl",
    [Enum.KeyCode.LeftAlt] = "Alt",
    [Enum.KeyCode.RightAlt] = "Alt",
    [Enum.KeyCode.F1] = "F1",
    [Enum.KeyCode.F2] = "F2",
    [Enum.KeyCode.F3] = "F3",
    [Enum.KeyCode.F4] = "F4",
    [Enum.KeyCode.F5] = "F5",
    [Enum.KeyCode.F6] = "F6",
    [Enum.KeyCode.F7] = "F7",
    [Enum.KeyCode.F8] = "F8",
    [Enum.KeyCode.F9] = "F9",
    [Enum.KeyCode.F10] = "F10",
    [Enum.KeyCode.F11] = "F11",
    [Enum.KeyCode.F12] = "F12"
};
local u5 = nil;

function v1.Init(p6) -- Line: 50
    -- upvalues: u5 (ref)
    u5 = game:GetService("ReplicatedStorage"):FindFirstChild("ProximityPromptTemplates");
end;

function v1.Start(u7) -- Line: 56
    -- upvalues: ProximityPromptService (copy)
    ProximityPromptService.PromptShown:Connect(function(p8, p9) -- Line: 58
        -- upvalues: u7 (copy)
        if p8:GetAttribute("DontShow") == nil then
            if p8.Style == Enum.ProximityPromptStyle.Default then
                return;
            end;

            local v10 = u7:CreatePrompt(p8, p9, (u7:GetScreenGui()));
            p8.PromptHidden:Wait();
            v10();
        end;
    end);
end;

function v1.GetScreenGui(p11) -- Line: 73
    -- upvalues: PlayerGui (copy)
    local ProximityPrompts = PlayerGui:FindFirstChild("ProximityPrompts");

    if ProximityPrompts == nil then
        ProximityPrompts = Instance.new("ScreenGui");
        ProximityPrompts.Name = "ProximityPrompts";
        ProximityPrompts.ResetOnSpawn = false;
        ProximityPrompts.Parent = PlayerGui;
    end;

    return ProximityPrompts;
end;

function v1.SetUpCircularProgressBar(p12, p13) -- Line: 86
    local UIGradient = p13.LeftGradient.ProgressBarImage.UIGradient;
    local UIGradient2 = p13.RightGradient.ProgressBarImage.UIGradient;
    p13.Progress.Changed:Connect(function(p14) -- Line: 91
        -- upvalues: UIGradient (copy), UIGradient2 (copy)
        local v15 = math.clamp(p14 * 360, 0, 360);
        UIGradient.Rotation = math.clamp(v15, 180, 360);
        UIGradient2.Rotation = math.clamp(v15, 0, 180);
    end);
end;

function v1.CreatePrompt(p16, u17, p18, p19) -- Line: 98
    -- upvalues: u5 (ref), TweenService (copy), UserInputService (copy), u2 (copy), u3 (copy), u4 (copy), TextService (copy)
    local u20 = {};
    local u21 = {};
    local u22 = {};
    local u23 = {};
    local v24 = TweenInfo.new(u17.HoldDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
    local u25 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local u26 = TweenInfo.new(0.06, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
    local v27 = TweenInfo.new(0, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
    local u28 = nil;
    local v29 = u17:GetAttribute("Theme");

    if v29 and u5 then
        local v30 = u5:FindFirstChild(v29);

        if v30 then
            u28 = v30:Clone();
        end;
    end;

    if u28 == nil and u5 then
        local Default = u5:FindFirstChild("Default");

        if Default then
            u28 = Default:Clone();
        end;
    end;

    if u28 == nil then
        return function() -- Line: 127
        end;
    end;

    u28.Enabled = true;
    local PromptFrame = u28.PromptFrame;
    local InputFrame = PromptFrame.InputFrame;
    local ActionText = PromptFrame.ActionText;
    local ObjectText = PromptFrame.ObjectText;
    local BackgroundTransparency = PromptFrame.BackgroundTransparency;
    local ImageTransparency = PromptFrame.ImageTransparency;
    PromptFrame.BackgroundTransparency = 1;
    PromptFrame.ImageTransparency = 1;
    local v31 = {
        BackgroundTransparency = 1,
        ImageTransparency = 1,
        Size = UDim2.fromScale(0.5, 1)
    };
    table.insert(u20, TweenService:Create(PromptFrame, u25, v31));
    local v32 = {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = BackgroundTransparency,
        ImageTransparency = ImageTransparency
    };
    table.insert(u21, TweenService:Create(PromptFrame, u25, v32));
    local v33 = {
        BackgroundTransparency = 1,
        ImageTransparency = 1,
        Size = UDim2.fromScale(0.5, 1)
    };
    table.insert(u22, TweenService:Create(PromptFrame, u25, v33));
    local v34 = {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = BackgroundTransparency,
        ImageTransparency = ImageTransparency
    };
    table.insert(u23, TweenService:Create(PromptFrame, u25, v34));

    local function setupUIStrokeTweens(p35) -- Line: 148
        -- upvalues: u20 (copy), TweenService (ref), u25 (copy), u21 (copy), u22 (copy), u23 (copy)
        local Transparency = p35.Transparency;
        p35.Transparency = 1;
        table.insert(u20, TweenService:Create(p35, u25, {
            Transparency = 1
        }));
        table.insert(u21, TweenService:Create(p35, u25, {
            Transparency = Transparency
        }));
        table.insert(u22, TweenService:Create(p35, u25, {
            Transparency = 1
        }));
        table.insert(u23, TweenService:Create(p35, u25, {
            Transparency = Transparency
        }));
    end;

    local function setupGUIObjectTweens(p36) -- Line: 157
        -- upvalues: u20 (copy), TweenService (ref), u25 (copy), u21 (copy), u22 (copy), u23 (copy)
        local BackgroundTransparency2 = p36.BackgroundTransparency;
        p36.BackgroundTransparency = 1;
        table.insert(u20, TweenService:Create(p36, u25, {
            BackgroundTransparency = 1
        }));
        table.insert(u21, TweenService:Create(p36, u25, {
            BackgroundTransparency = BackgroundTransparency2
        }));
        table.insert(u22, TweenService:Create(p36, u25, {
            BackgroundTransparency = 1
        }));
        table.insert(u23, TweenService:Create(p36, u25, {
            BackgroundTransparency = BackgroundTransparency2
        }));
    end;

    local function setupTextLabelTweens(p37) -- Line: 166
        -- upvalues: u20 (copy), TweenService (ref), u25 (copy), u21 (copy), u22 (copy), u23 (copy)
        local TextTransparency = p37.TextTransparency;
        local TextStrokeTransparency = p37.TextStrokeTransparency;
        p37.TextTransparency = 1;
        p37.TextStrokeTransparency = 1;
        table.insert(u20, TweenService:Create(p37, u25, {
            TextTransparency = 1,
            TextStrokeTransparency = 1
        }));
        table.insert(u21, TweenService:Create(p37, u25, {
            TextTransparency = TextTransparency,
            TextStrokeTransparency = TextStrokeTransparency
        }));
        table.insert(u22, TweenService:Create(p37, u25, {
            TextTransparency = 1,
            TextStrokeTransparency = 1
        }));
        table.insert(u23, TweenService:Create(p37, u25, {
            TextTransparency = TextTransparency,
            TextStrokeTransparency = TextStrokeTransparency
        }));
    end;

    local function setupImageLabelTweens(p38) -- Line: 177
        -- upvalues: u20 (copy), TweenService (ref), u25 (copy), u21 (copy), u22 (copy), u23 (copy)
        local ImageTransparency2 = p38.ImageTransparency;
        p38.ImageTransparency = 1;
        table.insert(u20, TweenService:Create(p38, u25, {
            ImageTransparency = 1
        }));
        table.insert(u21, TweenService:Create(p38, u25, {
            ImageTransparency = ImageTransparency2
        }));
        table.insert(u22, TweenService:Create(p38, u25, {
            ImageTransparency = 1
        }));
        table.insert(u23, TweenService:Create(p38, u25, {
            ImageTransparency = ImageTransparency2
        }));
    end;

    local function setupUnexpectedChildTweens(p39) -- Line: 186
        -- upvalues: setupUIStrokeTweens (copy), setupGUIObjectTweens (copy), setupTextLabelTweens (copy), setupImageLabelTweens (copy), setupUnexpectedChildTweens (copy)
        if p39:IsA("UIStroke") then
            setupUIStrokeTweens(p39);
        elseif not p39:IsA("UIGradient") and p39:IsA("GuiObject") then
            setupGUIObjectTweens(p39);

            if p39:IsA("TextLabel") then
                setupTextLabelTweens(p39);
            elseif p39:IsA("ImageLabel") then
                setupImageLabelTweens(p39);
            end;
        end;

        for _, child in p39:GetChildren() do
            setupUnexpectedChildTweens(child);
        end;
    end;

    local v40 = {
        [InputFrame] = false,
        [ActionText] = true,
        [ObjectText] = true
    };

    for _, child in PromptFrame:GetChildren() do
        if v40[child] == nil then
            setupUnexpectedChildTweens(child);
        elseif v40[child] == true then
            for _, child2 in child:GetChildren() do
                setupUnexpectedChildTweens(child2);
            end;
        end;
    end;

    local Frame = InputFrame.Frame;
    local UIScale = Frame.UIScale;
    table.insert(u20, TweenService:Create(UIScale, u25, {
        Scale = p18 == Enum.ProximityPromptInputType.Touch and 1.6 or 1.33
    }));
    table.insert(u21, TweenService:Create(UIScale, u25, {
        Scale = 1
    }));
    setupTextLabelTweens(ActionText);
    setupTextLabelTweens(ObjectText);
    local ButtonFrame = Frame.ButtonFrame;
    local ButtonImage = Frame.ButtonImage;
    local ButtonText = Frame.ButtonText;
    local ButtonTextImage = Frame.ButtonTextImage;
    (function() -- Line: 234, Name: setupButtonFrameTweens
        -- upvalues: ButtonFrame (copy), u22 (copy), TweenService (ref), u26 (copy), u23 (copy)
        local BackgroundTransparency2 = ButtonFrame.BackgroundTransparency;
        local ImageTransparency2 = ButtonFrame.ImageTransparency;
        table.insert(u22, TweenService:Create(ButtonFrame, u26, {
            BackgroundTransparency = 1,
            ImageTransparency = 1
        }));
        table.insert(u23, TweenService:Create(ButtonFrame, u26, {
            BackgroundTransparency = BackgroundTransparency2,
            ImageTransparency = ImageTransparency2
        }));

        for _, child in ButtonFrame:GetChildren() do
            if child:IsA("UIStroke") then
                local Transparency = child.Transparency;
                table.insert(u22, TweenService:Create(child, u26, {
                    Transparency = 1
                }));
                table.insert(u23, TweenService:Create(child, u26, {
                    Transparency = Transparency
                }));
            end;
        end;
    end)();

    local function setupButtonTextTweens() -- Line: 251
        -- upvalues: ButtonText (copy), u22 (copy), TweenService (ref), u26 (copy), u23 (copy)
        local TextTransparency = ButtonText.TextTransparency;
        local TextStrokeTransparency = ButtonText.TextStrokeTransparency;
        local BackgroundTransparency2 = ButtonText.BackgroundTransparency;
        ButtonText.BackgroundTransparency = 1;
        ButtonText.TextStrokeTransparency = 1;
        ButtonText.TextTransparency = 1;
        table.insert(u22, TweenService:Create(ButtonText, u26, {
            TextTransparency = 1,
            TextStrokeTransparency = 1,
            BackgroundTransparency = 1
        }));
        table.insert(u23, TweenService:Create(ButtonText, u26, {
            TextTransparency = TextTransparency,
            TextStrokeTransparency = TextStrokeTransparency,
            BackgroundTransparency = BackgroundTransparency2
        }));

        for _, child in ButtonText:GetChildren() do
            if child:IsA("UIStroke") then
                local Transparency = child.Transparency;
                table.insert(u22, TweenService:Create(child, u26, {
                    Transparency = 1
                }));
                table.insert(u23, TweenService:Create(child, u26, {
                    Transparency = Transparency
                }));
            end;
        end;
    end;

    local function setupButtonImageTweens() -- Line: 271
        -- upvalues: ButtonImage (copy), u22 (copy), TweenService (ref), u26 (copy), u23 (copy)
        local ImageTransparency2 = ButtonImage.ImageTransparency;
        local BackgroundTransparency2 = ButtonImage.BackgroundTransparency;
        ButtonImage.BackgroundTransparency = 1;
        ButtonImage.ImageTransparency = 1;
        table.insert(u22, TweenService:Create(ButtonImage, u26, {
            ImageTransparency = 1,
            BackgroundTransparency = 1
        }));
        table.insert(u23, TweenService:Create(ButtonImage, u26, {
            ImageTransparency = ImageTransparency2,
            BackgroundTransparency = BackgroundTransparency2
        }));
    end;

    local function setupIconTweens() -- Line: 281
        -- upvalues: ButtonTextImage (copy), u22 (copy), TweenService (ref), u26 (copy), u23 (copy)
        local BackgroundTransparency2 = ButtonTextImage.BackgroundTransparency;
        local ImageTransparency2 = ButtonTextImage.ImageTransparency;
        ButtonTextImage.BackgroundTransparency = 1;
        ButtonTextImage.ImageTransparency = 1;
        table.insert(u22, TweenService:Create(ButtonTextImage, u26, {
            ImageTransparency = 1,
            BackgroundTransparency = 1
        }));
        table.insert(u23, TweenService:Create(ButtonTextImage, u26, {
            ImageTransparency = ImageTransparency2,
            BackgroundTransparency = BackgroundTransparency2
        }));
    end;

    if p18 == Enum.ProximityPromptInputType.Gamepad then
        local v41 = UserInputService:GetImageForKeyCode(u17.GamepadKeyCode);

        if v41 ~= "" then
            setupIconTweens();
            ButtonTextImage.Image = v41;
            ButtonText.Visible = false;
            ButtonImage.Visible = false;
            ButtonTextImage.Visible = true;
        end;
    elseif p18 == Enum.ProximityPromptInputType.Touch then
        setupButtonImageTweens();
        ButtonImage.Image = "rbxasset://textures/ui/Controls/TouchTapIcon.png";
        ButtonText.Visible = false;
        ButtonTextImage.Visible = false;
        ButtonImage.Visible = true;
    else
        setupButtonImageTweens();
        ButtonImage.Visible = true;
        local v42 = UserInputService:GetStringForKeyCode(u17.KeyboardKeyCode);
        local v43 = u2[u17.KeyboardKeyCode];

        if v43 == nil then
            v43 = u3[v42];
        end;

        if v43 == nil then
            v42 = u4[u17.KeyboardKeyCode] or v42;
        end;

        if v43 then
            setupIconTweens();
            ButtonTextImage.Image = v43;
            ButtonText.Visible = false;
            ButtonTextImage.Visible = true;
        elseif v42 == nil or v42 == "" then
            error("ProximityPrompt \'" .. u17.Name .. "\' has an unsupported keycode for rendering UI: " .. tostring(u17.KeyboardKeyCode));
        else
            if string.len(v42) > 2 then
                ButtonText.TextSize = math.round(ButtonText.TextSize * 6 / 7);
            end;

            setupButtonTextTweens();
            ButtonText.Text = v42;
            ButtonTextImage.Visible = false;
            ButtonText.Visible = true;
        end;
    end;

    if p18 == Enum.ProximityPromptInputType.Touch or u17.ClickablePrompt then
        local TextButton = u28.TextButton;
        local u44 = false;
        TextButton.InputBegan:Connect(function(p45) -- Line: 347
            -- upvalues: u17 (copy), u44 (ref)
            if (p45.UserInputType == Enum.UserInputType.Touch or p45.UserInputType == Enum.UserInputType.MouseButton1) and p45.UserInputState ~= Enum.UserInputState.Change then
                u17:InputHoldBegin();
                u44 = true;
            end;
        end);
        TextButton.InputEnded:Connect(function(p46) -- Line: 355
            -- upvalues: u44 (ref), u17 (copy)
            if (p46.UserInputType == Enum.UserInputType.Touch or p46.UserInputType == Enum.UserInputType.MouseButton1) and u44 then
                u44 = false;
                u17:InputHoldEnd();
            end;
        end);
        u28.Active = true;
    end;

    if u17.HoldDuration > 0 then
        local ProgressBar = Frame.ProgressBar;
        p16:SetUpCircularProgressBar(ProgressBar);
        table.insert(u20, TweenService:Create(ProgressBar.Progress, v24, {
            Value = 1
        }));
        table.insert(u21, TweenService:Create(ProgressBar.Progress, v27, {
            Value = 0
        }));
    end;

    local u47, u48;

    if u17.HoldDuration > 0 then
        u47 = u17.PromptButtonHoldBegan:Connect(function() -- Line: 380
            -- upvalues: u20 (copy)
            for _, v in u20 do
                v:Play();
            end;
        end);
        u48 = u17.PromptButtonHoldEnded:Connect(function() -- Line: 386
            -- upvalues: u21 (copy)
            for _, v in u21 do
                v:Play();
            end;
        end);
    else
        u47 = nil;
        u48 = nil;
    end;

    local u49 = u17.Triggered:Connect(function() -- Line: 393
        -- upvalues: u22 (copy)
        for _, v in u22 do
            v:Play();
        end;
    end);
    local u50 = u17.TriggerEnded:Connect(function() -- Line: 399
        -- upvalues: u23 (copy)
        for _, v in u23 do
            v:Play();
        end;
    end);

    local function updateUIFromPrompt() -- Line: 405
        -- upvalues: u17 (copy), ActionText (copy), TextService (ref), ObjectText (copy), u28 (ref)
        local GetTextBoundsParams = Instance.new("GetTextBoundsParams");
        GetTextBoundsParams.Text = u17.ActionText;
        GetTextBoundsParams.Font = ActionText.FontFace;
        GetTextBoundsParams.Size = ActionText.TextSize;
        GetTextBoundsParams.Width = 1000;
        local v51 = TextService:GetTextBoundsAsync(GetTextBoundsParams);
        local GetTextBoundsParams2 = Instance.new("GetTextBoundsParams");
        GetTextBoundsParams2.Text = u17.ObjectText;
        GetTextBoundsParams2.Font = ObjectText.FontFace;
        GetTextBoundsParams2.Size = ObjectText.TextSize;
        GetTextBoundsParams2.Width = 1000;
        local v52 = TextService:GetTextBoundsAsync(GetTextBoundsParams2);
        local v53 = math.max(v51.X, v52.X);
        local v54 = (u17.ActionText == nil or u17.ActionText == "") and (u17.ObjectText == nil or u17.ObjectText == "") and 72 or v53 + 72 + 24;
        ActionText.Position = UDim2.new(0.5, 72 - v54 / 2, 0, (u17.ObjectText == nil or u17.ObjectText == "") and 0 or 9);
        ObjectText.Position = UDim2.new(0.5, 72 - v54 / 2, 0, -10);
        ActionText.Text = u17.ActionText;
        ObjectText.Text = u17.ObjectText;
        ActionText.AutoLocalize = u17.AutoLocalize;
        ActionText.RootLocalizationTable = u17.RootLocalizationTable;
        ObjectText.AutoLocalize = u17.AutoLocalize;
        ObjectText.RootLocalizationTable = u17.RootLocalizationTable;
        u28.Size = UDim2.fromOffset(v54, 72);
        u28.SizeOffset = Vector2.new(u17.UIOffset.X / u28.Size.Width.Offset, u17.UIOffset.Y / u28.Size.Height.Offset);
    end;

    local u55 = u17.Changed:Connect(updateUIFromPrompt);
    updateUIFromPrompt();
    u28.Adornee = u17.Parent;
    u28.Parent = p19;

    for _, v in u23 do
        v:Play();
    end;

    return function() -- Line: 460, Name: cleanup
        -- upvalues: u47 (ref), u48 (ref), u49 (ref), u50 (ref), u55 (copy), u22 (copy), u28 (ref)
        if u47 then
            u47:Disconnect();
        end;

        if u48 then
            u48:Disconnect();
        end;

        u49:Disconnect();
        u50:Disconnect();
        u55:Disconnect();

        for _, v in u22 do
            v:Play();
        end;

        task.wait(0.2);
        u28.Parent = nil;
    end;
end;

return v1;