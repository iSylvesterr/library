-- Decompiled with Potassium's decompiler.

local ProximityPromptService = game:GetService("ProximityPromptService");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local AssetRegistry = UtilsSystem.AssetRegistry;
local Log = UtilsSystem.Log;
local ResourceUtil = UtilsSystem.ResourceUtil;
local TranslationHelper = UtilsSystem.TranslationHelper;
local UIanima = UtilsSystem.UIanima;
local LocalPlayer = UtilsSystem.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", (1 / 0));
local u1 = AssetRegistry.BuildCatalogPath("BillBoard", "Default");
local ModelRes = game.ReplicatedStorage:FindFirstChild("ModelRes");
local u2;

if ModelRes then
    u2 = ModelRes:FindFirstChild("ProximityPromptHighLight");
else
    u2 = nil;
end;

if not u2 then
    Log.warn("[CustomEUI] 缺少 ModelRes.ProximityPromptHighLight，请从 RP17 复制");
end;

local u3 = nil;
local u4 = {
    [Enum.KeyCode.Backspace] = "rbxasset://textures/ui/Controls/backspace.png",
    [Enum.KeyCode.Return] = "rbxasset://textures/ui/Controls/return.png",
    [Enum.KeyCode.LeftShift] = "rbxasset://textures/ui/Controls/shift.png",
    [Enum.KeyCode.RightShift] = "rbxasset://textures/ui/Controls/shift.png",
    [Enum.KeyCode.Tab] = "rbxasset://textures/ui/Controls/tab.png"
};
local u5 = {
    ["\'"] = "rbxasset://textures/ui/Controls/apostrophe.png",
    [","] = "rbxasset://textures/ui/Controls/comma.png",
    ["`"] = "rbxasset://textures/ui/Controls/graveaccent.png",
    ["."] = "rbxasset://textures/ui/Controls/period.png",
    [" "] = "rbxasset://textures/ui/Controls/spacebar.png"
};
local u6 = {
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

local function _getPromptBillboardTemplate(p7) -- Line: 90
    -- upvalues: AssetRegistry (copy), ResourceUtil (copy)
    local v8 = AssetRegistry.BuildCatalogPath("BillBoard", p7 or "Default");
    local v9 = ResourceUtil.GetTemplate(v8);

    if v9 and v9:IsA("BillboardGui") then
        return v9;
    end;

    return nil;
end;

local function _getScreenGui() -- Line: 105
    -- upvalues: PlayerGui (copy)
    local v10 = PlayerGui:FindFirstChild(script.Name);

    if v10 == nil then
        v10 = Instance.new("ScreenGui");
        v10.Name = script.Name;
        v10.ResetOnSpawn = false;
        v10.Parent = PlayerGui;
    end;

    return v10;
end;

local function _setHighlightAdornee(p11) -- Line: 122
    -- upvalues: u2 (copy)
    if not u2 then
        return;
    end;

    u2.Adornee = p11;

    if p11 then
        u2.Enabled = true;
    end;
end;

local function _setUpCircularProgressBar(p12) -- Line: 138
    local ProgressBarImage = p12.LeftGradient.ProgressBarImage;
    local ProgressBarImage2 = p12.RightGradient.ProgressBarImage;
    local UIGradient = ProgressBarImage.UIGradient;
    local UIGradient2 = ProgressBarImage2.UIGradient;
    ProgressBarImage.ImageTransparency = 0;
    ProgressBarImage2.ImageTransparency = 0;
    ProgressBarImage.Visible = false;
    ProgressBarImage2.Visible = false;
    p12.Progress.Changed:Connect(function(p13) -- Line: 150
        -- upvalues: UIGradient (copy), UIGradient2 (copy), ProgressBarImage (copy), ProgressBarImage2 (copy)
        local v14 = math.clamp(p13 * 360, 0, 360);
        UIGradient.Rotation = math.clamp(v14, 180, 360);
        UIGradient2.Rotation = math.clamp(v14, 0, 180);
        ProgressBarImage.Visible = UIGradient.Rotation > 180;
        ProgressBarImage2.Visible = UIGradient2.Rotation > 0;
    end);
end;

local function _getPromptLocalizationArgs(p15) -- Line: 166
    local v16 = p15:GetAttribute("_maxIndex");

    if typeof(v16) ~= "number" or v16 <= 0 then
        return nil;
    end;

    local v17 = {};

    for i = 1, v16 do
        local v18 = p15:GetAttribute("_arg_table" .. i);

        if v18 == nil then
            v17[i] = p15:GetAttribute("_arg" .. i);
        else
            v17[i] = { v18 };
        end;
    end;

    return v17;
end;

local function _getPromptActionKey(p19) -- Line: 190
    local v20 = p19:GetAttribute("_key");

    if typeof(v20) == "string" and v20 ~= "" then
        return v20;
    end;

    local ActionText = p19.ActionText;

    return typeof(ActionText) ~= "string" and "" or ActionText;
end;

local function _createPrompt(u21, p22, p23) -- Line: 210
    -- upvalues: AssetRegistry (copy), ResourceUtil (copy), Log (copy), u1 (copy), TranslationHelper (copy), _getPromptLocalizationArgs (copy), TweenService (copy), UserInputService (copy), u4 (copy), u5 (copy), u6 (copy), AddListen (copy), UIanima (copy), u2 (copy), u3 (ref)
    local u24 = {};
    local u25 = {};
    local u26 = {};
    local u27 = {};
    local v28 = TweenInfo.new(u21.HoldDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
    local u29 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local u30 = TweenInfo.new(0.06, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
    local v31 = TweenInfo.new(0, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
    local u32 = nil;
    local v33 = u21:GetAttribute("Theme");

    if typeof(v33) == "string" and v33 ~= "" then
        local v34 = AssetRegistry.BuildCatalogPath("BillBoard", v33 or "Default");
        local v35 = ResourceUtil.GetTemplate(v34);

        if not (v35 and v35:IsA("BillboardGui")) then
            v35 = nil;
        end;

        if v35 then
            u32 = v35:Clone();
        end;
    end;

    if u32 == nil then
        local v36 = AssetRegistry.BuildCatalogPath("BillBoard", "Default");
        local v37 = ResourceUtil.GetTemplate(v36);

        if not (v37 and v37:IsA("BillboardGui")) then
            v37 = nil;
        end;

        if not v37 then
            Log.warn("[CustomEUI] 缺少 Assets.BillBoard.Default，路径:", u1);

            return function() -- Line: 235
            end;
        end;

        u32 = v37:Clone();
    end;

    u32.Enabled = true;
    local PromptFrame = u32.PromptFrame;
    local InputFrame = PromptFrame.InputFrame;
    local PromTextBg = u32.PromTextBg;
    local ButtonText = PromTextBg.ButtonText;
    local v38 = u21:GetAttribute("_key");

    if typeof(v38) ~= "string" or v38 == "" then
        local ActionText = u21.ActionText;
        v38 = typeof(ActionText) ~= "string" and "" or ActionText;
    end;

    if v38 == "" then
        PromTextBg.Visible = false;
        PromptFrame.Position = UDim2.new(0.5, 0, 0.5, 0);
    else
        PromTextBg.Visible = true;
        PromptFrame.Position = UDim2.new(0.25, 0, 0.5, 0);
        TranslationHelper.SetText(ButtonText, v38, (_getPromptLocalizationArgs(u21)));
    end;

    local BackgroundTransparency = PromptFrame.BackgroundTransparency;
    local ImageTransparency = PromptFrame.ImageTransparency;
    PromptFrame.BackgroundTransparency = 1;
    PromptFrame.ImageTransparency = 1;
    table.insert(u26, TweenService:Create(PromptFrame, u29, {
        BackgroundTransparency = 1,
        ImageTransparency = 1
    }));
    table.insert(u27, TweenService:Create(PromptFrame, u29, {
        BackgroundTransparency = BackgroundTransparency,
        ImageTransparency = ImageTransparency
    }));

    local function setupUIStrokeTweens(p39) -- Line: 269
        -- upvalues: u24 (copy), TweenService (ref), u29 (copy), u25 (copy), u26 (copy), u27 (copy)
        local Transparency = p39.Transparency;
        p39.Transparency = 1;
        table.insert(u24, TweenService:Create(p39, u29, {
            Transparency = 1
        }));
        table.insert(u25, TweenService:Create(p39, u29, {
            Transparency = Transparency
        }));
        table.insert(u26, TweenService:Create(p39, u29, {
            Transparency = 1
        }));
        table.insert(u27, TweenService:Create(p39, u29, {
            Transparency = Transparency
        }));
    end;

    local function setupGUIObjectTweens(p40) -- Line: 278
        -- upvalues: u24 (copy), TweenService (ref), u29 (copy), u25 (copy), u26 (copy), u27 (copy)
        local BackgroundTransparency2 = p40.BackgroundTransparency;
        p40.BackgroundTransparency = 1;
        table.insert(u24, TweenService:Create(p40, u29, {
            BackgroundTransparency = 1
        }));
        table.insert(u25, TweenService:Create(p40, u29, {
            BackgroundTransparency = BackgroundTransparency2
        }));
        table.insert(u26, TweenService:Create(p40, u29, {
            BackgroundTransparency = 1
        }));
        table.insert(u27, TweenService:Create(p40, u29, {
            BackgroundTransparency = BackgroundTransparency2
        }));
    end;

    local function setupTextLabelTweens(p41) -- Line: 293
        -- upvalues: u24 (copy), TweenService (ref), u29 (copy), u25 (copy), u26 (copy), u27 (copy)
        local TextTransparency = p41.TextTransparency;
        local TextStrokeTransparency = p41.TextStrokeTransparency;
        p41.TextTransparency = 1;
        p41.TextStrokeTransparency = 1;
        table.insert(u24, TweenService:Create(p41, u29, {
            TextTransparency = 1,
            TextStrokeTransparency = 1
        }));
        table.insert(u25, TweenService:Create(p41, u29, {
            TextTransparency = TextTransparency,
            TextStrokeTransparency = TextStrokeTransparency
        }));
        table.insert(u26, TweenService:Create(p41, u29, {
            TextTransparency = 1,
            TextStrokeTransparency = 1
        }));
        table.insert(u27, TweenService:Create(p41, u29, {
            TextTransparency = TextTransparency,
            TextStrokeTransparency = TextStrokeTransparency
        }));
    end;

    local function setupImageLabelTweens(p42) -- Line: 316
        -- upvalues: u24 (copy), TweenService (ref), u29 (copy), u25 (copy), u26 (copy), u27 (copy)
        local ImageTransparency2 = p42.ImageTransparency;
        p42.ImageTransparency = 1;
        table.insert(u24, TweenService:Create(p42, u29, {
            ImageTransparency = 1
        }));
        table.insert(u25, TweenService:Create(p42, u29, {
            ImageTransparency = ImageTransparency2
        }));
        table.insert(u26, TweenService:Create(p42, u29, {
            ImageTransparency = 1
        }));
        table.insert(u27, TweenService:Create(p42, u29, {
            ImageTransparency = ImageTransparency2
        }));
    end;

    local function setupUnexpectedChildTweens(p43) -- Line: 325
        -- upvalues: setupUIStrokeTweens (copy), setupGUIObjectTweens (copy), setupTextLabelTweens (copy), setupImageLabelTweens (copy), setupUnexpectedChildTweens (copy)
        if p43:IsA("UIStroke") then
            setupUIStrokeTweens(p43);
        elseif p43:IsA("GuiObject") then
            setupGUIObjectTweens(p43);

            if p43:IsA("TextLabel") then
                setupTextLabelTweens(p43);
            elseif p43:IsA("ImageLabel") then
                setupImageLabelTweens(p43);
            end;
        end;

        for _, child in p43:GetChildren() do
            setupUnexpectedChildTweens(child);
        end;
    end;

    local v44 = {
        [InputFrame] = false
    };

    for _, child in PromptFrame:GetChildren() do
        if v44[child] == nil then
            setupUnexpectedChildTweens(child);
        elseif v44[child] == true then
            for _, child2 in child:GetChildren() do
                setupUnexpectedChildTweens(child2);
            end;
        end;
    end;

    local Frame = InputFrame.Frame;
    local UIScale = InputFrame.Parent.UIScale;
    table.insert(u24, TweenService:Create(UIScale, u29, {
        Scale = p22 == Enum.ProximityPromptInputType.Touch and 1.6 or 1.33
    }));
    table.insert(u25, TweenService:Create(UIScale, u29, {
        Scale = 1
    }));
    local ButtonText2 = Frame.ButtonText;
    local ButtonImage = Frame.ButtonImage;
    local GamePadImg = ButtonImage.Parent:FindFirstChild("GamePadImg");
    local TouchImg = ButtonImage.Parent:FindFirstChild("TouchImg");

    local function setupButtonTextTweens() -- Line: 363
        -- upvalues: ButtonText2 (copy), u26 (copy), TweenService (ref), u30 (copy), u27 (copy)
        local TextTransparency = ButtonText2.TextTransparency;
        local TextStrokeTransparency = ButtonText2.TextStrokeTransparency;
        local BackgroundTransparency2 = ButtonText2.BackgroundTransparency;
        ButtonText2.BackgroundTransparency = 1;
        ButtonText2.TextStrokeTransparency = 1;
        ButtonText2.TextTransparency = 1;
        table.insert(u26, TweenService:Create(ButtonText2, u30, {
            TextTransparency = 1,
            TextStrokeTransparency = 1,
            BackgroundTransparency = 1
        }));
        table.insert(u27, TweenService:Create(ButtonText2, u30, {
            TextTransparency = TextTransparency,
            TextStrokeTransparency = TextStrokeTransparency,
            BackgroundTransparency = BackgroundTransparency2
        }));

        for _, child in ButtonText2:GetChildren() do
            if child:IsA("UIStroke") then
                local Transparency = child.Transparency;
                table.insert(u26, TweenService:Create(child, u30, {
                    Transparency = 1
                }));
                table.insert(u27, TweenService:Create(child, u30, {
                    Transparency = Transparency
                }));
            end;
        end;
    end;

    if p22 == Enum.ProximityPromptInputType.Gamepad then
        if GamePadImg then
            ButtonText2.Visible = false;
            ButtonImage.Visible = false;
            GamePadImg.Visible = true;

            if TouchImg then
                TouchImg.Visible = false;
            end;
        end;
    elseif p22 == Enum.ProximityPromptInputType.Touch then
        u32.Size = UDim2.new(0, 200, 0, 50);

        if GamePadImg then
            GamePadImg.Visible = false;
        end;

        if TouchImg then
            TouchImg.Visible = true;
        end;

        ButtonText2.Visible = false;
        ButtonImage.Visible = false;
    else
        ButtonImage.Visible = true;

        if GamePadImg then
            GamePadImg.Visible = false;
        end;

        local v45 = UserInputService:GetStringForKeyCode(u21.KeyboardKeyCode);
        local v46 = u4[u21.KeyboardKeyCode];

        if v46 == nil then
            v46 = u5[v45];
        end;

        if v46 == nil then
            v45 = u6[u21.KeyboardKeyCode] or v45;
        end;

        if v46 then
            ButtonText2.Visible = false;
        elseif v45 == nil or v45 == "" then
            Log.warn("[CustomEUI] ProximityPrompt 不支持的键位:", u21.Name, (tostring(u21.KeyboardKeyCode)));
        else
            if string.len(v45) > 2 then
                ButtonText2.TextSize = math.round(ButtonText2.TextSize * 6 / 7);
            end;

            setupButtonTextTweens();
            ButtonText2.Text = v45;
            ButtonText2.Visible = true;
        end;
    end;

    if p22 == Enum.ProximityPromptInputType.Touch or u21.ClickablePrompt then
        local TextButton = u32.TextButton;
        local u47 = false;
        TextButton.InputBegan:Connect(function(p48) -- Line: 449
            -- upvalues: u21 (copy), u47 (ref)
            if (p48.UserInputType == Enum.UserInputType.Touch or p48.UserInputType == Enum.UserInputType.MouseButton1) and p48.UserInputState ~= Enum.UserInputState.Change then
                u21:InputHoldBegin();
                u47 = true;
            end;
        end);
        TextButton.InputEnded:Connect(function(p49) -- Line: 458
            -- upvalues: u47 (ref), u21 (copy)
            if (p49.UserInputType == Enum.UserInputType.Touch or p49.UserInputType == Enum.UserInputType.MouseButton1) and u47 then
                u47 = false;
                u21:InputHoldEnd();
            end;
        end);
        u32.Active = true;
    end;

    if u21.HoldDuration > 0 then
        local ProgressBar = Frame.ProgressBar;
        local ProgressBarImage = ProgressBar.LeftGradient.ProgressBarImage;
        local ProgressBarImage2 = ProgressBar.RightGradient.ProgressBarImage;
        local UIGradient = ProgressBarImage.UIGradient;
        local UIGradient2 = ProgressBarImage2.UIGradient;
        ProgressBarImage.ImageTransparency = 0;
        ProgressBarImage2.ImageTransparency = 0;
        ProgressBarImage.Visible = false;
        ProgressBarImage2.Visible = false;
        ProgressBar.Progress.Changed:Connect(function(p50) -- Line: 150
            -- upvalues: UIGradient (copy), UIGradient2 (copy), ProgressBarImage (copy), ProgressBarImage2 (copy)
            local v51 = math.clamp(p50 * 360, 0, 360);
            UIGradient.Rotation = math.clamp(v51, 180, 360);
            UIGradient2.Rotation = math.clamp(v51, 0, 180);
            ProgressBarImage.Visible = UIGradient.Rotation > 180;
            ProgressBarImage2.Visible = UIGradient2.Rotation > 0;
        end);
        table.insert(u24, TweenService:Create(ProgressBar.Progress, v28, {
            Value = 1
        }));
        table.insert(u25, TweenService:Create(ProgressBar.Progress, v31, {
            Value = 0
        }));
    end;

    local u52, u53;

    if u21.HoldDuration > 0 then
        u52 = u21.PromptButtonHoldBegan:Connect(function() -- Line: 482
            -- upvalues: u24 (copy)
            for _, v in u24 do
                v:Play();
            end;
        end);
        u53 = u21.PromptButtonHoldEnded:Connect(function() -- Line: 487
            -- upvalues: u25 (copy)
            for _, v in u25 do
                v:Play();
            end;
        end);
    else
        u52 = nil;
        u53 = nil;
    end;

    local u54 = AddListen.AddProximityPrompt(u21, function() -- Line: 494
        -- upvalues: u26 (copy), PromptFrame (copy), TweenService (ref)
        for _, v in u26 do
            v:Play();
        end;

        local UIScale2 = PromptFrame:FindFirstChild("UIScale");

        if UIScale2 and UIScale2:IsA("UIScale") then
            TweenService:Create(UIScale2, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Scale = 0
            }):Play();
        end;
    end);
    local u55 = u21.TriggerEnded:Connect(function() -- Line: 504
        -- upvalues: u27 (copy), UIanima (ref), PromptFrame (copy)
        for _, v in u27 do
            v:Play();
        end;

        if UIanima and UIanima.UIScaleOut then
            UIanima.UIScaleOut(PromptFrame, 0.18);
        end;
    end);
    u32.Adornee = u21.Parent;
    local v56;

    if u21.Parent then
        v56 = u21.Parent.Parent;
    else
        v56 = nil;
    end;

    if u2 then
        u2.Adornee = v56;

        if v56 then
            u2.Enabled = true;
        end;
    end;

    u32.Parent = p23;

    for _, v in u27 do
        v:Play();
    end;

    if UIanima and UIanima.UIScaleOut then
        UIanima.UIScaleOut(PromptFrame, 0.18);
    end;

    u3 = u32;

    return function() -- Line: 527
        -- upvalues: u52 (ref), u53 (ref), u54 (ref), u55 (ref), u2 (ref), u32 (ref), u3 (ref)
        if u52 then
            u52:Disconnect();
        end;

        if u53 then
            u53:Disconnect();
        end;

        if u54 then
            u54:Disconnect();
        end;

        if u55 then
            u55:Disconnect();
        end;

        if u2 then
            u2.Adornee = nil;
        end;

        u32.Parent = nil;
        u32:Destroy();
        u3 = nil;
    end;
end;

local u57 = not u2 and 1 or u2.OutlineTransparency;
local CurrentCamera = workspace.CurrentCamera;

local function _updatePromptVisibility() -- Line: 556
    -- upvalues: u3 (ref), LocalPlayer (copy), CurrentCamera (copy), u2 (copy), u57 (copy)
    if not u3 then
        return;
    end;

    local v58 = LocalPlayer:FindFirstChild("是否弹窗打开中");
    local v59 = v58 and (v58:IsA("BoolValue") and v58.Value) and true or false;
    local v60 = CurrentCamera.CameraType == Enum.CameraType.Scriptable and true or v59;
    local v61 = LocalPlayer:FindFirstChild("飞行状态");

    if v61 and (v61:IsA("BoolValue") and v61.Value) and true or v60 then
        if not u3:GetAttribute("MaxDis") then
            u3:SetAttribute("MaxDis", u3.MaxDistance);
        end;

        u3.MaxDistance = 0.001;

        if u2 then
            u2.OutlineTransparency = 1;
        end;
    else
        local v62 = u3:GetAttribute("MaxDis");

        if v62 then
            u3.MaxDistance = v62;
        end;

        if u2 then
            u2.OutlineTransparency = u57;
        end;
    end;
end;

ProximityPromptService.PromptShown:Connect(function(p63, p64) -- Line: 593
    -- upvalues: PlayerGui (copy), _createPrompt (copy), _updatePromptVisibility (copy)
    if p63.Style == Enum.ProximityPromptStyle.Default then
        return;
    end;

    local v65 = PlayerGui:FindFirstChild(script.Name);

    if v65 == nil then
        v65 = Instance.new("ScreenGui");
        v65.Name = script.Name;
        v65.ResetOnSpawn = false;
        v65.Parent = PlayerGui;
    end;

    local v66 = _createPrompt(p63, p64, v65);
    _updatePromptVisibility();
    p63.PromptHidden:Wait();
    v66();
end);
local u67 = LocalPlayer:WaitForChild("是否弹窗打开中", (1 / 0));
AddListen.NumValueAdd(u67, function() -- Line: 607
    -- upvalues: _updatePromptVisibility (copy), PlayerGui (copy), u67 (copy)
    _updatePromptVisibility();
    local TouchGui = PlayerGui:FindFirstChild("TouchGui");

    if TouchGui and TouchGui:IsA("ScreenGui") then
        TouchGui.Enabled = not u67.Value;
    end;
end, false);
CurrentCamera:GetPropertyChangedSignal("CameraType"):Connect(function() -- Line: 615
    -- upvalues: _updatePromptVisibility (copy)
    _updatePromptVisibility();
end);