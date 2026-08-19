-- Decompiled with Potassium's decompiler.

local Value = Enum.ContextActionPriority.High.Value;
local u1 = { 0.10999999999999999, 0.30000000000000004, 0.4, 0.5, 0.6, 0.7, 0.75 };
local u2 = #u1;
local u3 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
local Players = game:GetService("Players");
local GuiService = game:GetService("GuiService");
local UserInputService = game:GetService("UserInputService");
local ContextActionService = game:GetService("ContextActionService");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local success, result = pcall(function() -- Line: 37
    return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickMoveOverButtons2");
end);
local u4 = success and result;
local success2, result2 = pcall(function() -- Line: 44
    return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickSafeAreaUpdate");
end);
local u5 = success2 and result2;
local LocalPlayer = Players.LocalPlayer;

if not LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait();
    LocalPlayer = Players.LocalPlayer;
end;

local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"));
local u6 = setmetatable({}, BaseCharacterController);
u6.__index = u6;

function u6.new() -- Line: 61
    -- upvalues: BaseCharacterController (copy), u6 (copy)
    local v7 = BaseCharacterController.new();
    local v8 = setmetatable(v7, u6);
    v8.moveTouchObject = nil;
    v8.moveTouchLockedIn = false;
    v8.moveTouchFirstChanged = false;
    v8.moveTouchStartPosition = nil;
    v8.startImage = nil;
    v8.endImage = nil;
    v8.middleImages = {};
    v8.startImageFadeTween = nil;
    v8.endImageFadeTween = nil;
    v8.middleImageFadeTweens = {};
    v8.isFirstTouch = true;
    v8.thumbstickFrame = nil;
    v8.onRenderSteppedConn = nil;
    v8.fadeInAndOutBalance = 0.5;
    v8.fadeInAndOutHalfDuration = 0.3;
    v8.hasFadedBackgroundInPortrait = false;
    v8.hasFadedBackgroundInLandscape = false;
    v8.tweenInAlphaStart = nil;
    v8.tweenOutAlphaStart = nil;

    return v8;
end;

function u6.GetIsJumping(p9) -- Line: 96
    local isJumping = p9.isJumping;
    p9.isJumping = false;

    return isJumping;
end;

function u6.Enable(p10, p11, p12) -- Line: 102
    -- upvalues: u4 (ref), ContextActionService (copy)
    if p11 == nil then
        return false;
    end;

    local v13 = p11 and true or false;

    if p10.enabled == v13 then
        return true;
    end;

    if v13 then
        if not p10.thumbstickFrame then
            p10:Create(p12);
        end;

        p10:BindContextActions();
    else
        if u4 then
            p10:UnbindContextActions();
        else
            ContextActionService:UnbindAction("DynamicThumbstickAction");
        end;

        p10:OnInputEnded();
    end;

    p10.enabled = v13;
    p10.thumbstickFrame.Visible = v13;

    return nil;
end;

function u6.OnInputEnded(p14) -- Line: 131
    p14.moveTouchObject = nil;
    p14.moveVector = Vector3.new(0, 0, 0);
    p14:FadeThumbstick(false);
end;

function u6.FadeThumbstick(p15, p16) -- Line: 137
    -- upvalues: TweenService (copy), u3 (copy), u1 (copy)
    if not p16 and p15.moveTouchObject then
        return;
    end;

    if p15.isFirstTouch then
        return;
    end;

    if p15.startImageFadeTween then
        p15.startImageFadeTween:Cancel();
    end;

    if p15.endImageFadeTween then
        p15.endImageFadeTween:Cancel();
    end;

    for i = 1, #p15.middleImages do
        if p15.middleImageFadeTweens[i] then
            p15.middleImageFadeTweens[i]:Cancel();
        end;
    end;

    if p16 then
        p15.startImageFadeTween = TweenService:Create(p15.startImage, u3, {
            ImageTransparency = 0
        });
        p15.startImageFadeTween:Play();
        p15.endImageFadeTween = TweenService:Create(p15.endImage, u3, {
            ImageTransparency = 0.2
        });
        p15.endImageFadeTween:Play();

        for i = 1, #p15.middleImages do
            p15.middleImageFadeTweens[i] = TweenService:Create(p15.middleImages[i], u3, {
                ImageTransparency = u1[i]
            });
            p15.middleImageFadeTweens[i]:Play();
        end;

        return;
    end;

    p15.startImageFadeTween = TweenService:Create(p15.startImage, u3, {
        ImageTransparency = 1
    });
    p15.startImageFadeTween:Play();
    p15.endImageFadeTween = TweenService:Create(p15.endImage, u3, {
        ImageTransparency = 1
    });
    p15.endImageFadeTween:Play();

    for i = 1, #p15.middleImages do
        p15.middleImageFadeTweens[i] = TweenService:Create(p15.middleImages[i], u3, {
            ImageTransparency = 1
        });
        p15.middleImageFadeTweens[i]:Play();
    end;
end;

function u6.FadeThumbstickFrame(p17, p18, p19) -- Line: 180
    p17.fadeInAndOutHalfDuration = p18 * 0.5;
    p17.fadeInAndOutBalance = p19;
    p17.tweenInAlphaStart = tick();
end;

function u6.InputInFrame(p20, p21) -- Line: 186
    local AbsolutePosition = p20.thumbstickFrame.AbsolutePosition;
    local v22 = AbsolutePosition + p20.thumbstickFrame.AbsoluteSize;
    local Position = p21.Position;

    return Position.X >= AbsolutePosition.X and (Position.Y >= AbsolutePosition.Y and (Position.X <= v22.X and Position.Y <= v22.Y));
end;

function u6.DoFadeInBackground(p23) -- Line: 198
    -- upvalues: LocalPlayer (ref)
    local v24 = LocalPlayer:FindFirstChildOfClass("PlayerGui");
    local v25 = false;

    if v24 then
        if v24.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft or v24.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight then
            v25 = p23.hasFadedBackgroundInLandscape;
            p23.hasFadedBackgroundInLandscape = true;
        elseif v24.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait then
            v25 = p23.hasFadedBackgroundInPortrait;
            p23.hasFadedBackgroundInPortrait = true;
        end;
    end;

    if not v25 then
        p23.fadeInAndOutHalfDuration = 0.3;
        p23.fadeInAndOutBalance = 0.5;
        p23.tweenInAlphaStart = tick();
    end;
end;

function u6.DoMove(p26, p27) -- Line: 221
    local v28;

    if p27.Magnitude < p26.radiusOfDeadZone then
        v28 = Vector3.new(0, 0, 0);
    else
        local v29 = p27.Unit * (1 - math.max(0, (p26.radiusOfMaxSpeed - p27.Magnitude) / p26.radiusOfMaxSpeed));
        v28 = Vector3.new(v29.X, 0, v29.Y);
    end;

    p26.moveVector = v28;
end;

function u6.LayoutMiddleImages(p30, p31, p32) -- Line: 239
    -- upvalues: u2 (copy)
    local v33 = p30.thumbstickSize / 2 + p30.middleSize;
    local v34 = p32 - p31;
    local v35 = v34.Magnitude - p30.thumbstickRingSize / 2 - p30.middleSize;
    local Unit = v34.Unit;
    local middleSpacing = p30.middleSpacing;

    if p30.middleSpacing * u2 < v35 then
        middleSpacing = v35 / u2;
    end;

    for i = 1, u2 do
        local v36 = p30.middleImages[i];
        local v37 = v33 + middleSpacing * (i - 1);

        if v33 + middleSpacing * (i - 2) < v35 then
            local v38 = p32 - Unit * v37;
            local v39 = math.clamp(1 - (v37 - v35) / middleSpacing, 0, 1);
            v36.Visible = true;
            v36.Position = UDim2.new(0, v38.X, 0, v38.Y);
            v36.Size = UDim2.new(0, p30.middleSize * v39, 0, p30.middleSize * v39);
        else
            v36.Visible = false;
        end;
    end;
end;

function u6.MoveStick(p40, p41) -- Line: 270
    local v42 = Vector2.new(p40.moveTouchStartPosition.X, p40.moveTouchStartPosition.Y) - p40.thumbstickFrame.AbsolutePosition;
    local v43 = Vector2.new(p41.X, p41.Y) - p40.thumbstickFrame.AbsolutePosition;
    p40.endImage.Position = UDim2.new(0, v43.X, 0, v43.Y);
    p40:LayoutMiddleImages(v42, v43);
end;

function u6.BindContextActions(u44) -- Line: 278
    -- upvalues: TweenService (copy), u4 (ref), ContextActionService (copy), Value (copy), UserInputService (copy)
    local function inputBegan(p45) -- Line: 279
        -- upvalues: u44 (copy), TweenService (ref)
        if u44.moveTouchObject then
            return Enum.ContextActionResult.Pass;
        end;

        if not u44:InputInFrame(p45) then
            return Enum.ContextActionResult.Pass;
        end;

        if u44.isFirstTouch then
            u44.isFirstTouch = false;
            local v46 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0);
            TweenService:Create(u44.startImage, v46, {
                Size = UDim2.new(0, 0, 0, 0)
            }):Play();
            TweenService:Create(u44.endImage, v46, {
                Size = UDim2.new(0, u44.thumbstickSize, 0, u44.thumbstickSize),
                ImageColor3 = Color3.new(0, 0, 0)
            }):Play();
        end;

        u44.moveTouchLockedIn = false;
        u44.moveTouchObject = p45;
        u44.moveTouchStartPosition = p45.Position;
        u44.moveTouchFirstChanged = true;
        u44:DoFadeInBackground();

        return Enum.ContextActionResult.Pass;
    end;

    local function inputChanged(p47) -- Line: 311
        -- upvalues: u44 (copy)
        if p47 ~= u44.moveTouchObject then
            return Enum.ContextActionResult.Pass;
        end;

        if u44.moveTouchFirstChanged then
            u44.moveTouchFirstChanged = false;
            local v48 = Vector2.new(p47.Position.X - u44.thumbstickFrame.AbsolutePosition.X, p47.Position.Y - u44.thumbstickFrame.AbsolutePosition.Y);
            u44.startImage.Visible = true;
            u44.startImage.Position = UDim2.new(0, v48.X, 0, v48.Y);
            u44.endImage.Visible = true;
            u44.endImage.Position = u44.startImage.Position;
            u44:FadeThumbstick(true);
            u44:MoveStick(p47.Position);
        end;

        u44.moveTouchLockedIn = true;
        local v49 = Vector2.new(p47.Position.X - u44.moveTouchStartPosition.X, p47.Position.Y - u44.moveTouchStartPosition.Y);

        if math.abs(v49.X) > 0 or math.abs(v49.Y) > 0 then
            u44:DoMove(v49);
            u44:MoveStick(p47.Position);
        end;

        return Enum.ContextActionResult.Sink;
    end;

    local function inputEnded(p50) -- Line: 344
        -- upvalues: u44 (copy)
        if p50 == u44.moveTouchObject then
            u44:OnInputEnded();

            if u44.moveTouchLockedIn then
                return Enum.ContextActionResult.Sink;
            end;
        end;

        return Enum.ContextActionResult.Pass;
    end;

    ContextActionService:BindActionAtPriority("DynamicThumbstickAction", function(p51, p52, p53) -- Line: 354, Name: handleInput
        -- upvalues: inputBegan (copy), u4 (ref), u44 (copy), inputChanged (copy)
        if p52 == Enum.UserInputState.Begin then
            return inputBegan(p53);
        end;

        if p52 == Enum.UserInputState.Change then
            if not u4 then
                return inputChanged(p53);
            end;

            if p53 == u44.moveTouchObject then
                return Enum.ContextActionResult.Sink;
            end;

            return Enum.ContextActionResult.Pass;
        end;

        if p52 == Enum.UserInputState.End then
            if p53 == u44.moveTouchObject then
                u44:OnInputEnded();

                if u44.moveTouchLockedIn then
                    return Enum.ContextActionResult.Sink;
                end;
            end;

            return Enum.ContextActionResult.Pass;
        end;

        if p52 == Enum.UserInputState.Cancel then
            u44:OnInputEnded();
        end;
    end, false, Value, Enum.UserInputType.Touch);

    if u4 then
        u44.TouchMovedCon = UserInputService.TouchMoved:Connect(function(p54, p55) -- Line: 382
            -- upvalues: inputChanged (copy)
            inputChanged(p54);
        end);
    end;
end;

function u6.UnbindContextActions(p56) -- Line: 388
    -- upvalues: ContextActionService (copy)
    ContextActionService:UnbindAction("DynamicThumbstickAction");

    if p56.TouchMovedCon then
        p56.TouchMovedCon:Disconnect();
    end;
end;

function u6.Create(u57, u58) -- Line: 396
    -- upvalues: u5 (ref), u2 (copy), u1 (copy), RunService (copy), UserInputService (copy), GuiService (copy), LocalPlayer (ref)
    if u57.thumbstickFrame then
        u57.thumbstickFrame:Destroy();
        u57.thumbstickFrame = nil;

        if u57.onRenderSteppedConn then
            u57.onRenderSteppedConn:Disconnect();
            u57.onRenderSteppedConn = nil;
        end;

        if u57.absoluteSizeChangedConn then
            u57.absoluteSizeChangedConn:Disconnect();
            u57.absoluteSizeChangedConn = nil;
        end;
    end;

    local u59 = u5 and 100 or 0;
    u57.thumbstickFrame = Instance.new("Frame");
    u57.thumbstickFrame.BorderSizePixel = 0;
    u57.thumbstickFrame.Name = "DynamicThumbstickFrame";
    u57.thumbstickFrame.Visible = false;
    u57.thumbstickFrame.BackgroundTransparency = 1;
    u57.thumbstickFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
    u57.thumbstickFrame.Active = false;
    u57.thumbstickFrame.Size = UDim2.new(0.4, u59, 0.6666666666666666, u59);
    u57.thumbstickFrame.Position = UDim2.new(0, -u59, 0.3333333333333333, 0);
    u57.startImage = Instance.new("ImageLabel");
    u57.startImage.Name = "ThumbstickStart";
    u57.startImage.Visible = true;
    u57.startImage.BackgroundTransparency = 1;
    u57.startImage.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png";
    u57.startImage.ImageRectOffset = Vector2.new(1, 1);
    u57.startImage.ImageRectSize = Vector2.new(144, 144);
    u57.startImage.ImageColor3 = Color3.new(0, 0, 0);
    u57.startImage.AnchorPoint = Vector2.new(0.5, 0.5);
    u57.startImage.ZIndex = 10;
    u57.startImage.Parent = u57.thumbstickFrame;
    u57.endImage = Instance.new("ImageLabel");
    u57.endImage.Name = "ThumbstickEnd";
    u57.endImage.Visible = true;
    u57.endImage.BackgroundTransparency = 1;
    u57.endImage.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png";
    u57.endImage.ImageRectOffset = Vector2.new(1, 1);
    u57.endImage.ImageRectSize = Vector2.new(144, 144);
    u57.endImage.AnchorPoint = Vector2.new(0.5, 0.5);
    u57.endImage.ZIndex = 10;
    u57.endImage.Parent = u57.thumbstickFrame;

    local function layoutThumbstickFrame(p60) -- Line: 411
        -- upvalues: u57 (copy), u59 (copy)
        if p60 then
            u57.thumbstickFrame.Size = UDim2.new(1, u59, 0.4, u59);
            u57.thumbstickFrame.Position = UDim2.new(0, -u59, 0.6, 0);

            return;
        end;

        u57.thumbstickFrame.Size = UDim2.new(0.4, u59, 0.6666666666666666, u59);
        u57.thumbstickFrame.Position = UDim2.new(0, -u59, 0.3333333333333333, 0);
    end;

    for i = 1, u2 do
        u57.middleImages[i] = Instance.new("ImageLabel");
        u57.middleImages[i].Name = "ThumbstickMiddle";
        u57.middleImages[i].Visible = false;
        u57.middleImages[i].BackgroundTransparency = 1;
        u57.middleImages[i].Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png";
        u57.middleImages[i].ImageRectOffset = Vector2.new(1, 1);
        u57.middleImages[i].ImageRectSize = Vector2.new(144, 144);
        u57.middleImages[i].ImageTransparency = u1[i];
        u57.middleImages[i].AnchorPoint = Vector2.new(0.5, 0.5);
        u57.middleImages[i].ZIndex = 9;
        u57.middleImages[i].Parent = u57.thumbstickFrame;
    end;

    local function ResizeThumbstick() -- Line: 467
        -- upvalues: u58 (copy), u57 (copy), u59 (copy)
        local AbsoluteSize = u58.AbsoluteSize;

        if math.min(AbsoluteSize.X, AbsoluteSize.Y) > 500 then
            u57.thumbstickSize = 90;
            u57.thumbstickRingSize = 40;
            u57.middleSize = 20;
            u57.middleSpacing = 28;
            u57.radiusOfDeadZone = 4;
            u57.radiusOfMaxSpeed = 40;
        else
            u57.thumbstickSize = 45;
            u57.thumbstickRingSize = 20;
            u57.middleSize = 10;
            u57.middleSpacing = 14;
            u57.radiusOfDeadZone = 2;
            u57.radiusOfMaxSpeed = 20;
        end;

        u57.startImage.Position = UDim2.new(0, u57.thumbstickRingSize * 3.3 + u59, 1, -u57.thumbstickRingSize * 2.8 - u59);
        u57.startImage.Size = UDim2.new(0, u57.thumbstickRingSize * 3.7, 0, u57.thumbstickRingSize * 3.7);
        u57.endImage.Position = u57.startImage.Position;
        u57.endImage.Size = UDim2.new(0, u57.thumbstickSize * 0.8, 0, u57.thumbstickSize * 0.8);
    end;

    ResizeThumbstick();
    u57.absoluteSizeChangedConn = u58:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeThumbstick);
    local u61 = nil;

    local function onCurrentCameraChanged() -- Line: 505
        -- upvalues: u61 (ref), layoutThumbstickFrame (copy)
        if u61 then
            u61:Disconnect();
            u61 = nil;
        end;

        local CurrentCamera = workspace.CurrentCamera;

        if CurrentCamera then
            local function onViewportSizeChanged() -- Line: 512
                -- upvalues: CurrentCamera (copy), layoutThumbstickFrame (ref)
                local ViewportSize = CurrentCamera.ViewportSize;
                layoutThumbstickFrame(ViewportSize.X < ViewportSize.Y);
            end;

            u61 = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(onViewportSizeChanged);
            local ViewportSize = CurrentCamera.ViewportSize;
            layoutThumbstickFrame(ViewportSize.X < ViewportSize.Y);
        end;
    end;

    workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(onCurrentCameraChanged);

    if workspace.CurrentCamera then
        onCurrentCameraChanged();
    end;

    u57.moveTouchStartPosition = nil;
    u57.startImageFadeTween = nil;
    u57.endImageFadeTween = nil;
    u57.middleImageFadeTweens = {};
    u57.onRenderSteppedConn = RunService.RenderStepped:Connect(function() -- Line: 532
        -- upvalues: u57 (copy)
        if u57.tweenInAlphaStart == nil then
            if u57.tweenOutAlphaStart ~= nil then
                local v62 = tick() - u57.tweenOutAlphaStart;
                local v63 = u57.fadeInAndOutHalfDuration * 2 - u57.fadeInAndOutHalfDuration * 2 * u57.fadeInAndOutBalance;
                u57.thumbstickFrame.BackgroundTransparency = math.min(v62 / v63, 1) * 0.35 + 0.65;

                if v63 < v62 then
                    u57.tweenOutAlphaStart = nil;
                end;
            end;
        else
            local v64 = tick() - u57.tweenInAlphaStart;
            local v65 = u57.fadeInAndOutHalfDuration * 2 * u57.fadeInAndOutBalance;
            u57.thumbstickFrame.BackgroundTransparency = 1 - math.min(v64 / v65, 1) * 0.35;

            if v65 < v64 then
                u57.tweenOutAlphaStart = tick();
                u57.tweenInAlphaStart = nil;
            end;
        end;
    end);
    u57.onTouchEndedConn = UserInputService.TouchEnded:connect(function(p66) -- Line: 551
        -- upvalues: u57 (copy)
        if p66 == u57.moveTouchObject then
            u57:OnInputEnded();
        end;
    end);
    GuiService.MenuOpened:connect(function() -- Line: 557
        -- upvalues: u57 (copy)
        if u57.moveTouchObject then
            u57:OnInputEnded();
        end;
    end);
    local u67 = LocalPlayer:FindFirstChildOfClass("PlayerGui");

    while not u67 do
        LocalPlayer.ChildAdded:wait();
        u67 = LocalPlayer:FindFirstChildOfClass("PlayerGui");
    end;

    local u68 = nil;
    local u69 = u67.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft and true or u67.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight;

    local function longShowBackground() -- Line: 573
        -- upvalues: u57 (copy)
        u57.fadeInAndOutHalfDuration = 2.5;
        u57.fadeInAndOutBalance = 0.05;
        u57.tweenInAlphaStart = tick();
    end;

    u68 = u67:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(function() -- Line: 579
        -- upvalues: u69 (copy), u67 (ref), u68 (ref), u57 (copy)
        if u69 and u67.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait or not u69 and u67.CurrentScreenOrientation ~= Enum.ScreenOrientation.Portrait then
            u68:disconnect();
            u57.fadeInAndOutHalfDuration = 2.5;
            u57.fadeInAndOutBalance = 0.05;
            u57.tweenInAlphaStart = tick();

            if u69 then
                u57.hasFadedBackgroundInPortrait = true;

                return;
            end;

            u57.hasFadedBackgroundInLandscape = true;
        end;
    end);
    u57.thumbstickFrame.Parent = u58;

    if game:IsLoaded() then
        u57.fadeInAndOutHalfDuration = 2.5;
        u57.fadeInAndOutBalance = 0.05;
        u57.tweenInAlphaStart = tick();
    else
        coroutine.wrap(function() -- Line: 599
            -- upvalues: u57 (copy)
            game.Loaded:Wait();
            u57.fadeInAndOutHalfDuration = 2.5;
            u57.fadeInAndOutBalance = 0.05;
            u57.tweenInAlphaStart = tick();
        end)();
    end;
end;

return u6;