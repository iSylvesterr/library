-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");
local ProximityPromptService = game:GetService("ProximityPromptService");
local TweenService = game:GetService("TweenService");
local TextService = game:GetService("TextService");
local Players = game:GetService("Players");
local Workspace = game:GetService("Workspace");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local InputIconsConfig = require(ReplicatedStorage.Library.InputIconsConfig);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local u1 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u2 = {
    prompt = nil,
    baseFov = nil,
    tween = nil
};

local function cleanupWildEggTween() -- Line: 32
    -- upvalues: u2 (copy)
    if u2.tween then
        u2.tween:Cancel();
        u2.tween = nil;
    end;
end;

local function isWildEggPrompt(p3) -- Line: 39
    if typeof(p3:GetAttribute("Progress")) ~= "number" then
        return false;
    end;

    local Parent = p3.Parent;

    if Parent then
        return Parent.Name == "WildAssetEgg";
    end;

    return false;
end;

local function applyWildEggZoom(p4, p5) -- Line: 52
    -- upvalues: Workspace (copy), u2 (copy), TweenService (copy), u1 (copy)
    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        return;
    end;

    local v6 = math.clamp(p5, 0, 1);

    if v6 <= 0 then
        if u2.prompt == p4 and u2.baseFov then
            if u2.tween then
                u2.tween:Cancel();
                u2.tween = nil;
            end;

            u2.tween = TweenService:Create(CurrentCamera, u1, {
                FieldOfView = u2.baseFov
            });
            assert(u2.tween, "luau");
            u2.tween:Play();
            u2.prompt = nil;
            u2.baseFov = nil;
        end;

        return;
    end;

    if u2.prompt ~= p4 then
        u2.prompt = p4;
        u2.baseFov = CurrentCamera.FieldOfView;
    end;

    local baseFov = u2.baseFov;

    if not baseFov then
        return;
    end;

    local v7 = baseFov + (math.max(40, baseFov - 30) - baseFov) * v6;

    if math.abs(CurrentCamera.FieldOfView - v7) < 0.001 then
        return;
    end;

    if u2.tween then
        u2.tween:Cancel();
        u2.tween = nil;
    end;

    u2.tween = TweenService:Create(CurrentCamera, u1, {
        FieldOfView = v7
    });
    assert(u2.tween, "luau");
    u2.tween:Play();
end;

local function gamepadButtonImage(p8) -- Line: 99
    -- upvalues: InputIconsConfig (copy)
    return InputIconsConfig.Image(p8);
end;

local u9 = {
    [Enum.KeyCode.Backspace] = "rbxasset://textures/ui/Controls/backspace.png",
    [Enum.KeyCode.Return] = "rbxasset://textures/ui/Controls/return.png",
    [Enum.KeyCode.LeftShift] = "rbxasset://textures/ui/Controls/shift.png",
    [Enum.KeyCode.RightShift] = "rbxasset://textures/ui/Controls/shift.png",
    [Enum.KeyCode.Tab] = "rbxasset://textures/ui/Controls/tab.png"
};
local u10 = {
    ["\'"] = "rbxasset://textures/ui/Controls/apostrophe.png",
    [","] = "rbxasset://textures/ui/Controls/comma.png",
    ["`"] = "rbxasset://textures/ui/Controls/graveaccent.png",
    ["."] = "rbxasset://textures/ui/Controls/period.png",
    [" "] = "rbxasset://textures/ui/Controls/spacebar.png"
};
local u11 = {
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

local function getScreenGui() -- Line: 138
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

local function setUpCircularProgressBar(p12) -- Line: 149
    local UIGradient = p12.LeftGradient.ProgressBarImage.UIGradient;
    local UIGradient2 = p12.RightGradient.ProgressBarImage.UIGradient;
    p12.Progress.Changed:Connect(function(p13) -- Line: 154
        -- upvalues: UIGradient (copy), UIGradient2 (copy)
        local v14 = math.clamp(p13 * 360, 0, 360);
        UIGradient.Rotation = math.clamp(v14, 180, 360);
        UIGradient2.Rotation = math.clamp(v14, 0, 180);
    end);
end;

local function createPrompt(u15, p16, p17) -- Line: 161
    -- upvalues: TweenService (copy), InputIconsConfig (copy), UserInputService (copy), u9 (copy), u10 (copy), u11 (copy), LocalPlayer (copy), applyWildEggZoom (copy), Workspace (copy), u2 (copy), u1 (copy), TextService (copy)
    local u18 = {};
    local u19 = {};
    local u20 = {};
    local u21 = {};
    local v22 = TweenInfo.new(u15.HoldDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
    TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local u23 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local u24 = TweenInfo.new(0.06, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
    local v25 = TweenInfo.new(0, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
    local u26 = nil;
    local v27 = u15:GetAttribute("Theme");

    if v27 then
        local v28 = script:FindFirstChild(v27);

        if v28 then
            u26 = v28:Clone();
        end;
    end;

    if u26 == nil then
        u26 = script.Default:Clone();
    end;

    u26.Enabled = true;
    local PromptFrame = u26.PromptFrame;
    local InputFrame = PromptFrame.InputFrame;
    local ActionText = PromptFrame.ActionText;
    local ObjectText = PromptFrame.ObjectText;
    local BackgroundTransparency = PromptFrame.BackgroundTransparency;
    local ImageTransparency = PromptFrame.ImageTransparency;
    PromptFrame.BackgroundTransparency = 1;
    PromptFrame.ImageTransparency = 1;
    local v29 = {
        BackgroundTransparency = 1,
        ImageTransparency = 1,
        Size = UDim2.fromScale(0.5, 1)
    };
    table.insert(u18, TweenService:Create(PromptFrame, u23, v29));
    local v30 = {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = BackgroundTransparency,
        ImageTransparency = ImageTransparency
    };
    table.insert(u19, TweenService:Create(PromptFrame, u23, v30));
    local v31 = {
        BackgroundTransparency = 1,
        ImageTransparency = 1,
        Size = UDim2.fromScale(0.5, 1)
    };
    table.insert(u20, TweenService:Create(PromptFrame, u23, v31));
    local v32 = {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = BackgroundTransparency,
        ImageTransparency = ImageTransparency
    };
    table.insert(u21, TweenService:Create(PromptFrame, u23, v32));

    local function setupUIStrokeTweens(p33) -- Line: 233
        -- upvalues: u18 (copy), TweenService (ref), u23 (copy), u19 (copy), u20 (copy), u21 (copy)
        local Transparency = p33.Transparency;
        p33.Transparency = 1;
        table.insert(u18, TweenService:Create(p33, u23, {
            Transparency = 1
        }));
        table.insert(u19, TweenService:Create(p33, u23, {
            Transparency = Transparency
        }));
        table.insert(u20, TweenService:Create(p33, u23, {
            Transparency = 1
        }));
        table.insert(u21, TweenService:Create(p33, u23, {
            Transparency = Transparency
        }));
    end;

    local function setupGUIObjectTweens(p34) -- Line: 245
        -- upvalues: u18 (copy), TweenService (ref), u23 (copy), u19 (copy), u20 (copy), u21 (copy)
        local BackgroundTransparency2 = p34.BackgroundTransparency;
        p34.BackgroundTransparency = 1;
        table.insert(u18, TweenService:Create(p34, u23, {
            BackgroundTransparency = 1
        }));
        table.insert(u19, TweenService:Create(p34, u23, {
            BackgroundTransparency = BackgroundTransparency2
        }));
        table.insert(u20, TweenService:Create(p34, u23, {
            BackgroundTransparency = 1
        }));
        table.insert(u21, TweenService:Create(p34, u23, {
            BackgroundTransparency = BackgroundTransparency2
        }));
    end;

    local function setupTextLabelTweens(p35) -- Line: 263
        -- upvalues: u18 (copy), TweenService (ref), u23 (copy), u19 (copy), u20 (copy), u21 (copy)
        local TextTransparency = p35.TextTransparency;
        local TextStrokeTransparency = p35.TextStrokeTransparency;
        p35.TextTransparency = 1;
        p35.TextStrokeTransparency = 1;
        table.insert(u18, TweenService:Create(p35, u23, {
            TextTransparency = 1,
            TextStrokeTransparency = 1
        }));
        table.insert(u19, TweenService:Create(p35, u23, {
            TextTransparency = TextTransparency,
            TextStrokeTransparency = TextStrokeTransparency
        }));
        table.insert(u20, TweenService:Create(p35, u23, {
            TextTransparency = 1,
            TextStrokeTransparency = 1
        }));
        table.insert(u21, TweenService:Create(p35, u23, {
            TextTransparency = TextTransparency,
            TextStrokeTransparency = TextStrokeTransparency
        }));
    end;

    local function setupImageLabelTweens(p36) -- Line: 294
        -- upvalues: u18 (copy), TweenService (ref), u23 (copy), u19 (copy), u20 (copy), u21 (copy)
        local ImageTransparency2 = p36.ImageTransparency;
        p36.ImageTransparency = 1;
        table.insert(u18, TweenService:Create(p36, u23, {
            ImageTransparency = 1
        }));
        table.insert(u19, TweenService:Create(p36, u23, {
            ImageTransparency = ImageTransparency2
        }));
        table.insert(u20, TweenService:Create(p36, u23, {
            ImageTransparency = 1
        }));
        table.insert(u21, TweenService:Create(p36, u23, {
            ImageTransparency = ImageTransparency2
        }));
    end;

    local function setupUnexpectedChildTweens(p37) -- Line: 312
        -- upvalues: setupUIStrokeTweens (copy), setupGUIObjectTweens (copy), setupTextLabelTweens (copy), setupImageLabelTweens (copy), setupUnexpectedChildTweens (copy)
        if p37:IsA("UIStroke") then
            setupUIStrokeTweens(p37);
        elseif not p37:IsA("UIGradient") and p37:IsA("GuiObject") then
            setupGUIObjectTweens(p37);

            if p37:IsA("TextLabel") then
                setupTextLabelTweens(p37);
            elseif p37:IsA("ImageLabel") then
                setupImageLabelTweens(p37);
            end;
        end;

        for _, child in pairs(p37:GetChildren()) do
            setupUnexpectedChildTweens(child);
        end;
    end;

    local v38 = {
        [InputFrame] = false,
        [ActionText] = true,
        [ObjectText] = true
    };

    for _, child in pairs(PromptFrame:GetChildren()) do
        if v38[child] == nil then
            setupUnexpectedChildTweens(child);
        elseif v38[child] == true then
            for _, child2 in pairs(child:GetChildren()) do
                setupUnexpectedChildTweens(child2);
            end;
        end;
    end;

    local Frame = InputFrame.Frame;
    local UIScale = Frame.UIScale;
    table.insert(u18, TweenService:Create(UIScale, u23, {
        Scale = p16 == Enum.ProximityPromptInputType.Touch and 1.6 or 1.33
    }));
    table.insert(u19, TweenService:Create(UIScale, u23, {
        Scale = 1
    }));
    setupTextLabelTweens(ActionText);
    setupTextLabelTweens(ObjectText);
    local ButtonFrame = Frame.ButtonFrame;
    (function() -- Line: 362, Name: setupButtonFrameTweens
        -- upvalues: ButtonFrame (copy), u20 (copy), TweenService (ref), u24 (copy), u21 (copy)
        local BackgroundTransparency2 = ButtonFrame.BackgroundTransparency;
        local ImageTransparency2 = ButtonFrame.ImageTransparency;
        table.insert(u20, TweenService:Create(ButtonFrame, u24, {
            BackgroundTransparency = 1,
            ImageTransparency = 1
        }));
        table.insert(u21, TweenService:Create(ButtonFrame, u24, {
            BackgroundTransparency = BackgroundTransparency2,
            ImageTransparency = ImageTransparency2
        }));

        for _, v in pairs(ButtonFrame:getChildren()) do
            if v:IsA("UIStroke") then
                local Transparency = v.Transparency;
                table.insert(u20, TweenService:Create(v, u24, {
                    Transparency = 1
                }));
                table.insert(u21, TweenService:Create(v, u24, {
                    Transparency = Transparency
                }));
            end;
        end;
    end)();
    local ButtonImage = Frame.ButtonImage;
    local ButtonText = Frame.ButtonText;
    local ButtonTextImage = Frame.ButtonTextImage;

    local function setupButtonTextTweens() -- Line: 396
        -- upvalues: ButtonText (copy), u20 (copy), TweenService (ref), u24 (copy), u21 (copy)
        local TextTransparency = ButtonText.TextTransparency;
        local TextStrokeTransparency = ButtonText.TextStrokeTransparency;
        local BackgroundTransparency2 = ButtonText.BackgroundTransparency;
        ButtonText.BackgroundTransparency = 1;
        ButtonText.TextStrokeTransparency = 1;
        ButtonText.TextTransparency = 1;
        table.insert(u20, TweenService:Create(ButtonText, u24, {
            TextTransparency = 1,
            TextStrokeTransparency = 1,
            BackgroundTransparency = 1
        }));
        table.insert(u21, TweenService:Create(ButtonText, u24, {
            TextTransparency = TextTransparency,
            TextStrokeTransparency = TextStrokeTransparency,
            BackgroundTransparency = BackgroundTransparency2
        }));

        for _, v in pairs(ButtonText:getChildren()) do
            if v:IsA("UIStroke") then
                local Transparency = v.Transparency;
                table.insert(u20, TweenService:Create(v, u24, {
                    Transparency = 1
                }));
                table.insert(u21, TweenService:Create(v, u24, {
                    Transparency = Transparency
                }));
            end;
        end;
    end;

    local function setupButtonImageTweens() -- Line: 433
        -- upvalues: ButtonImage (copy), u20 (copy), TweenService (ref), u24 (copy), u21 (copy)
        local ImageTransparency2 = ButtonImage.ImageTransparency;
        local BackgroundTransparency2 = ButtonImage.BackgroundTransparency;
        ButtonImage.BackgroundTransparency = 1;
        ButtonImage.ImageTransparency = 1;
        table.insert(u20, TweenService:Create(ButtonImage, u24, {
            ImageTransparency = 1,
            BackgroundTransparency = 1
        }));
        table.insert(u21, TweenService:Create(ButtonImage, u24, {
            ImageTransparency = ImageTransparency2,
            BackgroundTransparency = BackgroundTransparency2
        }));
    end;

    local function setupIconTweens() -- Line: 451
        -- upvalues: ButtonTextImage (copy), u20 (copy), TweenService (ref), u24 (copy), u21 (copy)
        local BackgroundTransparency2 = ButtonTextImage.BackgroundTransparency;
        local ImageTransparency2 = ButtonTextImage.ImageTransparency;
        ButtonTextImage.BackgroundTransparency = 1;
        ButtonTextImage.ImageTransparency = 1;
        table.insert(u20, TweenService:Create(ButtonTextImage, u24, {
            ImageTransparency = 1,
            BackgroundTransparency = 1
        }));
        table.insert(u21, TweenService:Create(ButtonTextImage, u24, {
            ImageTransparency = ImageTransparency2,
            BackgroundTransparency = BackgroundTransparency2
        }));
    end;

    if p16 == Enum.ProximityPromptInputType.Gamepad then
        local v39 = InputIconsConfig.Image(u15.GamepadKeyCode);

        if v39 then
            setupIconTweens();
            ButtonTextImage.Image = v39;
            ButtonText.Visible = false;
            ButtonImage.Visible = false;
            ButtonTextImage.Visible = true;
        end;
    elseif p16 == Enum.ProximityPromptInputType.Touch then
        setupButtonImageTweens();
        ButtonImage.Image = "rbxasset://textures/ui/Controls/TouchTapIcon.png";
        ButtonText.Visible = false;
        ButtonTextImage.Visible = false;
        ButtonImage.Visible = true;
    else
        setupButtonImageTweens();
        ButtonImage.Visible = true;
        local v40 = UserInputService:GetStringForKeyCode(u15.KeyboardKeyCode);
        local v41 = u9[u15.KeyboardKeyCode];

        if v41 == nil then
            v41 = u10[v40];
        end;

        if v41 == nil then
            v40 = u11[u15.KeyboardKeyCode] or v40;
        end;

        if v41 then
            setupIconTweens();
            ButtonTextImage.Image = v41;
            ButtonText.Visible = false;
            ButtonTextImage.Visible = true;
        elseif v40 == nil or v40 == "" then
            error("ProximityPrompt \'" .. u15.Name .. "\' has an unsupported keycode for rendering UI: " .. tostring(u15.KeyboardKeyCode));
        else
            if string.len(v40) > 2 then
                ButtonText.TextSize = math.round(ButtonText.TextSize * 6 / 7);
            end;

            setupButtonTextTweens();
            ButtonText.Text = v40;
            ButtonTextImage.Visible = false;
            ButtonText.Visible = true;
        end;
    end;

    if p16 == Enum.ProximityPromptInputType.Touch or u15.ClickablePrompt then
        local TextButton = u26.TextButton;
        local u42 = false;
        TextButton.InputBegan:Connect(function(p43) -- Line: 541
            -- upvalues: u15 (copy), u42 (ref)
            if (p43.UserInputType == Enum.UserInputType.Touch or p43.UserInputType == Enum.UserInputType.MouseButton1) and p43.UserInputState ~= Enum.UserInputState.Change then
                u15:InputHoldBegin();
                u42 = true;
            end;
        end);
        TextButton.InputEnded:Connect(function(p44) -- Line: 552
            -- upvalues: u42 (ref), u15 (copy)
            if (p44.UserInputType == Enum.UserInputType.Touch or p44.UserInputType == Enum.UserInputType.MouseButton1) and u42 then
                u42 = false;
                u15:InputHoldEnd();
            end;
        end);
        u26.Active = true;
    end;

    local u45;

    if typeof(u15:GetAttribute("Progress")) == "number" then
        local Parent = u15.Parent;

        if Parent then
            u45 = Parent.Name == "WildAssetEgg";
        else
            u45 = false;
        end;
    else
        u45 = false;
    end;

    local u46 = nil;
    local u47 = nil;

    if u15.HoldDuration > 0 then
        local ProgressBar = Frame.ProgressBar;
        local UIGradient = ProgressBar.LeftGradient.ProgressBarImage.UIGradient;
        local UIGradient2 = ProgressBar.RightGradient.ProgressBarImage.UIGradient;
        ProgressBar.Progress.Changed:Connect(function(p48) -- Line: 154
            -- upvalues: UIGradient (copy), UIGradient2 (copy)
            local v49 = math.clamp(p48 * 360, 0, 360);
            UIGradient.Rotation = math.clamp(v49, 180, 360);
            UIGradient2.Rotation = math.clamp(v49, 0, 180);
        end);
        local u50 = "Progress_" .. LocalPlayer.UserId;

        if typeof(u15:GetAttribute("Progress")) == "number" then
            local function syncProgress() -- Line: 577
                -- upvalues: u15 (copy), u50 (copy), ProgressBar (copy), u45 (copy), applyWildEggZoom (ref)
                local v51 = u15:GetAttribute(u50);
                local v52 = typeof(v51) ~= "number" and 0 or v51;
                ProgressBar.Progress.Value = v52;

                if u45 then
                    applyWildEggZoom(u15, v52);
                end;
            end;

            local v53 = u15:GetAttribute(u50);
            local v54 = typeof(v53) ~= "number" and 0 or v53;
            ProgressBar.Progress.Value = v54;

            if u45 then
                applyWildEggZoom(u15, v54);
            end;

            u46 = u15:GetAttributeChangedSignal(u50):Connect(syncProgress);

            if u45 then
                u47 = u15.AncestryChanged:Connect(function(p55, p56) -- Line: 593
                    -- upvalues: u15 (copy), Workspace (ref), u2 (ref), TweenService (ref), u1 (ref)
                    if p56 == nil then
                        local CurrentCamera = Workspace.CurrentCamera;

                        if not CurrentCamera then
                            return;
                        end;

                        if u2.prompt == u15 and u2.baseFov then
                            if u2.tween then
                                u2.tween:Cancel();
                                u2.tween = nil;
                            end;

                            u2.tween = TweenService:Create(CurrentCamera, u1, {
                                FieldOfView = u2.baseFov
                            });
                            assert(u2.tween, "luau");
                            u2.tween:Play();
                            u2.prompt = nil;
                            u2.baseFov = nil;
                        end;
                    end;
                end);
            end;
        else
            table.insert(u18, TweenService:Create(ProgressBar.Progress, v22, {
                Value = 1
            }));
            table.insert(u19, TweenService:Create(ProgressBar.Progress, v25, {
                Value = 0
            }));
        end;
    end;

    local u57, u58;

    if u15.HoldDuration > 0 then
        u57 = u15.PromptButtonHoldBegan:Connect(function() -- Line: 617
            -- upvalues: u18 (copy)
            for _, v in ipairs(u18) do
                v:Play();
            end;
        end);
        u58 = u15.PromptButtonHoldEnded:Connect(function() -- Line: 623
            -- upvalues: u19 (copy)
            for _, v in ipairs(u19) do
                v:Play();
            end;
        end);
    else
        u57 = nil;
        u58 = nil;
    end;

    local u59 = u15.Triggered:Connect(function() -- Line: 630
        -- upvalues: u20 (copy)
        for _, v in ipairs(u20) do
            v:Play();
        end;
    end);
    local u60 = u15.TriggerEnded:Connect(function() -- Line: 636
        -- upvalues: u21 (copy)
        for _, v in ipairs(u21) do
            v:Play();
        end;
    end);

    local function getTextBoundsForLabel(p61, p62) -- Line: 642
        -- upvalues: TextService (ref)
        local GetTextBoundsParams = Instance.new("GetTextBoundsParams");
        GetTextBoundsParams.Font = p61.FontFace;
        GetTextBoundsParams.Size = p61.TextSize;
        GetTextBoundsParams.Width = 1000;
        local v63 = p62 or "";

        if p61.RichText then
            v63 = v63:gsub("<[^>]->", "");
        end;

        GetTextBoundsParams.Text = v63;
        local v64 = TextService:GetTextBoundsAsync(GetTextBoundsParams);
        GetTextBoundsParams:Destroy();

        return v64;
    end;

    local function updateUIFromPrompt() -- Line: 661
        -- upvalues: getTextBoundsForLabel (copy), ActionText (copy), u15 (copy), ObjectText (copy), u26 (ref)
        local v65 = getTextBoundsForLabel(ActionText, u15.ActionText);
        local v66 = getTextBoundsForLabel(ObjectText, u15.ObjectText);
        local v67 = math.max(v65.X, v66.X);
        local v68 = (u15.ActionText == nil or u15.ActionText == "") and (u15.ObjectText == nil or u15.ObjectText == "") and 72 or v67 + 72 + 24;
        ActionText.Position = UDim2.new(0.5, 72 - v68 / 2, 0, (u15.ObjectText == nil or u15.ObjectText == "") and 0 or 9);
        ObjectText.Position = UDim2.new(0.5, 72 - v68 / 2, 0, -10);
        ActionText.Text = u15.ActionText;
        ObjectText.Text = u15.ObjectText;
        ActionText.AutoLocalize = u15.AutoLocalize;
        ActionText.RootLocalizationTable = u15.RootLocalizationTable;
        ObjectText.AutoLocalize = u15.AutoLocalize;
        ObjectText.RootLocalizationTable = u15.RootLocalizationTable;
        u26.Size = UDim2.fromOffset(v68, 72);
        u26.SizeOffset = Vector2.new(u15.UIOffset.X / u26.Size.Width.Offset, u15.UIOffset.Y / u26.Size.Height.Offset);
    end;

    local u69 = u15.Changed:Connect(updateUIFromPrompt);
    updateUIFromPrompt();
    u26.Adornee = u15.Parent;
    u26.Parent = p17;

    for _, v in ipairs(u21) do
        v:Play();
    end;

    return function() -- Line: 708, Name: cleanup
        -- upvalues: u57 (ref), u58 (ref), u46 (ref), u47 (ref), u59 (ref), u60 (ref), u69 (copy), u20 (copy), u45 (copy), u15 (copy), Workspace (ref), u2 (ref), TweenService (ref), u1 (ref), u26 (ref)
        if u57 then
            u57:Disconnect();
        end;

        if u58 then
            u58:Disconnect();
        end;

        if u46 then
            u46:Disconnect();
        end;

        if u47 then
            u47:Disconnect();
        end;

        u59:Disconnect();
        u60:Disconnect();
        u69:Disconnect();

        for _, v in ipairs(u20) do
            v:Play();
        end;

        if u45 then
            local CurrentCamera = Workspace.CurrentCamera;

            if CurrentCamera and (u2.prompt == u15 and u2.baseFov) then
                if u2.tween then
                    u2.tween:Cancel();
                    u2.tween = nil;
                end;

                u2.tween = TweenService:Create(CurrentCamera, u1, {
                    FieldOfView = u2.baseFov
                });
                assert(u2.tween, "luau");
                u2.tween:Play();
                u2.prompt = nil;
                u2.baseFov = nil;
            end;
        end;

        wait(0.2);
        u26.Parent = nil;
    end;
end;

local function onLoad() -- Line: 745
    -- upvalues: ProximityPromptService (copy), PlayerGui (copy), createPrompt (copy)
    ProximityPromptService.PromptShown:Connect(function(p70, p71) -- Line: 746
        -- upvalues: PlayerGui (ref), createPrompt (ref)
        if p70.Style == Enum.ProximityPromptStyle.Default then
            return;
        end;

        local ProximityPrompts = PlayerGui:FindFirstChild("ProximityPrompts");

        if ProximityPrompts == nil then
            ProximityPrompts = Instance.new("ScreenGui");
            ProximityPrompts.Name = "ProximityPrompts";
            ProximityPrompts.ResetOnSpawn = false;
            ProximityPrompts.Parent = PlayerGui;
        end;

        local v72 = createPrompt(p70, p71, ProximityPrompts);
        p70.PromptHidden:Wait();
        v72();
    end);
end;

ProximityPromptService.PromptShown:Connect(function(p73, p74) -- Line: 746
    -- upvalues: PlayerGui (copy), createPrompt (copy)
    if p73.Style == Enum.ProximityPromptStyle.Default then
        return;
    end;

    local ProximityPrompts = PlayerGui:FindFirstChild("ProximityPrompts");

    if ProximityPrompts == nil then
        ProximityPrompts = Instance.new("ScreenGui");
        ProximityPrompts.Name = "ProximityPrompts";
        ProximityPrompts.ResetOnSpawn = false;
        ProximityPrompts.Parent = PlayerGui;
    end;

    local v75 = createPrompt(p73, p74, ProximityPrompts);
    p73.PromptHidden:Wait();
    v75();
end);