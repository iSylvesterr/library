-- Decompiled with Potassium's decompiler.

local Trove = require(script.Parent.Parent.Trove);
local Signal = require(script.Parent.Parent.Signal);
local UserInputService = game:GetService("UserInputService");
local u1 = {};
u1.__index = u1;

function u1.new() -- Line: 87
    -- upvalues: u1 (copy), Trove (copy), Signal (copy), UserInputService (copy)
    local v2 = setmetatable({}, u1);
    v2._trove = Trove.new();
    v2.TouchTap = v2._trove:Construct(Signal.Wrap, UserInputService.TouchTap);
    v2.TouchTapInWorld = v2._trove:Construct(Signal.Wrap, UserInputService.TouchTapInWorld);
    v2.TouchMoved = v2._trove:Construct(Signal.Wrap, UserInputService.TouchMoved);
    v2.TouchLongPress = v2._trove:Construct(Signal.Wrap, UserInputService.TouchLongPress);
    v2.TouchPan = v2._trove:Construct(Signal.Wrap, UserInputService.TouchPan);
    v2.TouchPinch = v2._trove:Construct(Signal.Wrap, UserInputService.TouchPinch);
    v2.TouchRotate = v2._trove:Construct(Signal.Wrap, UserInputService.TouchRotate);
    v2.TouchSwipe = v2._trove:Construct(Signal.Wrap, UserInputService.TouchSwipe);
    v2.TouchStarted = v2._trove:Construct(Signal.Wrap, UserInputService.TouchStarted);
    v2.TouchEnded = v2._trove:Construct(Signal.Wrap, UserInputService.TouchEnded);

    return v2;
end;

function u1.IsTouchEnabled(p3) -- Line: 109
    -- upvalues: UserInputService (copy)
    return UserInputService.TouchEnabled;
end;

function u1.Destroy(p4) -- Line: 116
    p4._trove:Destroy();
end;

return u1;