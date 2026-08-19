-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");

return function(p1) -- Line: 3
    -- upvalues: UserInputService (copy)
    return p1 == Enum.KeyCode.LeftShift and "L Shift" or (p1 == Enum.KeyCode.RightShift and "R Shift" or (p1 == Enum.KeyCode.LeftControl and "L Ctrl" or (p1 == Enum.KeyCode.RightControl and "R Ctrl" or (p1 == Enum.KeyCode.LeftAlt and "L Alt" or (p1 == Enum.KeyCode.RightAlt and "R Alt" or (p1 == Enum.KeyCode.Tab and "Tab" or (p1 == Enum.KeyCode.Space and "Spacebar" or (p1 == Enum.KeyCode.LeftControl and "L Ctrl" or (p1 == Enum.KeyCode.RightControl and "R Ctrl" or UserInputService:GetStringForKeyCode(p1))))))))));
end;