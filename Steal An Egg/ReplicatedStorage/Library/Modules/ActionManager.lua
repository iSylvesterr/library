-- Decompiled with Potassium's decompiler.

local ContextActionService = game:GetService("ContextActionService");
local UserInputService = game:GetService("UserInputService");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local InputCategorizer = require(script.Parent.InputCategorizer);
local InputMetadata = require(script.InputMetadata);
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local Instances = script.Instances;
local ActionGui = Instances.ActionGui;
local u1 = {
    KeyboardAndMouse = "KeyboardAndMouse",
    Gamepad = "Gamepad",
    Touch = "Touch",
    Unknown = "Unknown"
};
local u2 = {
    _initialized = false,
    InputCategory = u1,
    _bindings = {}
};

function u2.bindAction(u3, u4, p5, p6, p7) -- Line: 43
    -- upvalues: u2 (copy), Instances (copy), ActionGui (copy), InputCategorizer (copy), ContextActionService (copy)
    if u2._bindings[u3] then
        warn(string.format("\'%s\' is already bound!", u3));

        return;
    end;

    local v8 = {
        connections = {},
        keyboardAndMouseInput = p5,
        gamepadInput = p6
    };
    local u9 = Instances.ActionFrame:Clone();
    u9.ContentFrame.ActionLabel.Text = u3;
    u9.LayoutOrder = p7 or 0;
    u9.Parent = ActionGui.ListFrame;
    v8.frame = u9;
    u2._updateInputDisplay(v8, InputCategorizer.getLastInputCategory());

    local function u12(...) -- Line: 72
        -- upvalues: u3 (copy), u9 (copy), u4 (copy)
        local v10, v11 = ...;

        if v10 == u3 then
            if v11 == Enum.UserInputState.Begin then
                u9.ContentFrame.ActionLabel.BackgroundColor3 = Color3.new(1, 1, 1);
                u9.ContentFrame.ActionLabel.TextColor3 = Color3.new(0, 0, 0);
            elseif v11 == Enum.UserInputState.End then
                u9.ContentFrame.ActionLabel.BackgroundColor3 = Color3.new(0, 0, 0);
                u9.ContentFrame.ActionLabel.TextColor3 = Color3.new(1, 1, 1);
            end;
        end;

        u4(...);
    end;

    table.insert(v8.connections, u9.TouchButton.InputBegan:Connect(function(p13) -- Line: 91
        -- upvalues: u12 (copy), u3 (copy)
        if p13.UserInputType == Enum.UserInputType.Touch then
            u12(u3, Enum.UserInputState.Begin, p13);
        end;
    end));
    table.insert(v8.connections, u9.TouchButton.InputEnded:Connect(function(p14) -- Line: 100
        -- upvalues: u12 (copy), u3 (copy)
        if p14.UserInputType == Enum.UserInputType.Touch then
            u12(u3, Enum.UserInputState.End, p14);
        end;
    end));
    ContextActionService:BindAction(u3, u12, false, p5, p6);
    u2._bindings[u3] = v8;
end;

function u2.unbindAction(p15) -- Line: 113
    -- upvalues: u2 (copy), ContextActionService (copy)
    local v16 = u2._bindings[p15];

    if v16 then
        for _, v in v16.connections do
            v:Disconnect();
        end;

        v16.frame:Destroy();
        u2._bindings[p15] = nil;
    end;

    ContextActionService:UnbindAction(p15);
end;

function u2._updateInputDisplay(p17, p18) -- Line: 129
    -- upvalues: u1 (copy), u2 (copy)
    local ButtonDisplayFrame = p17.frame.ContentFrame.InputFrame:FindFirstChild("ButtonDisplayFrame");

    if ButtonDisplayFrame then
        ButtonDisplayFrame:Destroy();
    end;

    local v19 = nil;

    if p18 == u1.KeyboardAndMouse then
        v19 = u2._getButtonDisplayForInput(p17.keyboardAndMouseInput);
    elseif p18 == u1.Gamepad then
        v19 = u2._getButtonDisplayForInput(p17.gamepadInput);
    elseif p18 == u1.Touch then
        v19 = u2._getButtonDisplayForInput(Enum.UserInputType.Touch);
    end;

    v19.Parent = p17.frame.ContentFrame.InputFrame;
    p17.frame.TouchButton.Visible = p18 == u1.Touch;
end;

function u2._getButtonDisplayForInput(p20) -- Line: 152
    -- upvalues: Instances (copy), UserInputService (copy), InputMetadata (copy)
    local v21 = Instances.ButtonDisplayFrame:Clone();
    local v22;

    if p20.EnumType == Enum.KeyCode then
        v22 = UserInputService:GetImageForKeyCode(p20);
    else
        v22 = nil;
    end;

    if p20 == Enum.UserInputType.Touch then
        Instances.TouchImageLabel:Clone().Parent = v21;

        return v21;
    end;

    if v22 and v22 ~= "" then
        local v23 = Instances.GamepadImageLabel:Clone();
        v23.Image = v22;
        v23.Parent = v21;

        return v21;
    end;

    if InputMetadata.MouseButtonImage[p20] then
        local v24 = Instances.MouseImageLabel:Clone();
        v24.Image = InputMetadata.MouseButtonImage[p20];
        v24.Parent = v21;

        return v21;
    end;

    Instances.KeyboardBorderImage:Clone().Parent = v21;
    local v25 = UserInputService:GetStringForKeyCode(p20);
    local v26 = InputMetadata.KeyboardButtonImage[p20] or InputMetadata.KeyboardButtonIconMapping[v25];

    if not v26 then
        v25 = InputMetadata.KeyCodeToTextMapping[p20] or v25;
    end;

    if not v26 then
        if v25 and v25 ~= "" then
            local v27 = Instances.KeyboardTextLabel:Clone();
            v27.Text = v25;
            v27.TextSize = InputMetadata.KeyCodeToFontSize[p20] or InputMetadata.DefaultFontSize;
            v27.Parent = v21;
        end;

        return v21;
    end;

    local v28 = Instances.KeyboardImageLabel:Clone();
    v28.Image = v26;
    v28.Parent = v21;

    return v21;
end;

function u2._getCategoryOfInputType(p29) -- Line: 208
    -- upvalues: u1 (copy)
    if string.find(p29.Name, "Gamepad") then
        return u1.Gamepad;
    end;

    if p29 == Enum.UserInputType.Keyboard or string.find(p29.Name, "Mouse") then
        return u1.KeyboardAndMouse;
    end;

    if p29 == Enum.UserInputType.Touch then
        return u1.Touch;
    end;

    return u1.Unknown;
end;

function u2._getDefaultInputCategory() -- Line: 221
    -- upvalues: UserInputService (copy), u1 (copy)
    if UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
        return u1.KeyboardAndMouse;
    end;

    if UserInputService.TouchEnabled then
        return u1.Touch;
    end;

    if UserInputService.GamepadEnabled then
        return u1.Gamepad;
    end;

    return u1.Unknown;
end;

function u2._updatePositionAndScale() -- Line: 234
    -- upvalues: PlayerGui (copy), ActionGui (copy), InputCategorizer (copy), u1 (copy)
    local v30 = PlayerGui:FindFirstChild("TouchGui") ~= nil;
    local v31 = math.min(ActionGui.AbsoluteSize.X, ActionGui.AbsoluteSize.Y) < 500;
    local v32 = 40;

    if v30 and InputCategorizer.getLastInputCategory() == u1.Touch then
        v32 = v32 + (v31 and 100 or 240);
    end;

    ActionGui.ListFrame.UIScale.Scale = v31 and 0.85 or 1;
    ActionGui.ListFrame.Position = UDim2.new(1, -40, 1, -v32);
end;

function u2._initialize() -- Line: 252
    -- upvalues: u2 (copy), RunService (copy), PlayerGui (copy), InputCategorizer (copy), ActionGui (copy)
    assert(not u2._initialized, "ActionManager already initialized!");
    local v33 = RunService:IsClient();
    assert(v33, "ActionManager can only be used on the client!");
    PlayerGui.ChildAdded:Connect(function(p34) -- Line: 257
        -- upvalues: u2 (ref)
        if p34.Name == "TouchGui" then
            u2._updatePositionAndScale();
        end;
    end);
    PlayerGui.ChildRemoved:Connect(function(p35) -- Line: 263
        -- upvalues: u2 (ref)
        if p35.Name == "TouchGui" then
            u2._updatePositionAndScale();
        end;
    end);
    InputCategorizer.lastInputCategoryChanged:Connect(function(p36) -- Line: 270
        -- upvalues: u2 (ref)
        for _, v in u2._bindings do
            u2._updateInputDisplay(v, p36);
        end;
    end);
    ActionGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(u2._updatePositionAndScale);
    InputCategorizer.lastInputCategoryChanged:Connect(u2._updatePositionAndScale);
    ActionGui.Parent = PlayerGui;
    u2._updatePositionAndScale();
    u2._initialized = true;
end;

u2._initialize();

return u2;