-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");
local BindableEvent = Instance.new("BindableEvent");
local u1 = {
    KeyboardAndMouse = "KeyboardAndMouse",
    Gamepad = "Gamepad",
    Touch = "Touch",
    Unknown = "Unknown"
};
local u2 = {
    _initialized = false,
    InputCategory = u1,
    lastInputCategoryChanged = BindableEvent.Event,
    _lastInputCategory = u1.Unknown
};

function u2.getLastInputCategory() -- Line: 37
    -- upvalues: u2 (copy)
    return u2._lastInputCategory;
end;

function u2._setLastInputCategory(p3) -- Line: 42
    -- upvalues: u2 (copy), BindableEvent (copy)
    if u2._lastInputCategory ~= p3 then
        u2._lastInputCategory = p3;
        BindableEvent:Fire(p3);
    end;
end;

function u2._getCategoryOfInputType(p4) -- Line: 50
    -- upvalues: u1 (copy)
    if string.find(p4.Name, "Gamepad") then
        return u1.Gamepad;
    end;

    if p4 == Enum.UserInputType.Keyboard or string.find(p4.Name, "Mouse") then
        return u1.KeyboardAndMouse;
    end;

    if p4 == Enum.UserInputType.Touch then
        return u1.Touch;
    end;

    return u1.Unknown;
end;

function u2._onInputTypeChanged(p5) -- Line: 62
    -- upvalues: u2 (copy), u1 (copy)
    local v6 = u2._getCategoryOfInputType(p5);

    if v6 ~= u1.Unknown then
        u2._setLastInputCategory(v6);
    end;
end;

function u2._getDefaultInputCategory() -- Line: 70
    -- upvalues: UserInputService (copy), u2 (copy), u1 (copy)
    local v7 = UserInputService:GetLastInputType();
    local v8 = u2._getCategoryOfInputType(v7);

    if v8 ~= u1.Unknown then
        return v8;
    end;

    if UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
        return u1.KeyboardAndMouse;
    end;

    if UserInputService.TouchEnabled then
        return u1.Touch;
    end;

    if UserInputService.GamepadEnabled then
        return u1.Gamepad;
    end;

    warn("No input devices detected!");

    return u1.Unknown;
end;

function u2._initialize() -- Line: 90
    -- upvalues: u2 (copy), UserInputService (copy)
    assert(not u2._initialized, "InputCategorizer already initialized!");
    UserInputService.LastInputTypeChanged:Connect(u2._onInputTypeChanged);
    local v9 = u2._getDefaultInputCategory();
    u2._setLastInputCategory(v9);
    u2._initialized = true;
end;

u2._initialize();

return u2;