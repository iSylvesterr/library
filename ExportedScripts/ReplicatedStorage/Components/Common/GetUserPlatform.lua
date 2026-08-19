-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");

return function() -- Line: 12
    -- upvalues: UserInputService (copy)
    local v1 = {};

    if UserInputService.GamepadEnabled then
        table.insert(v1, "Console");
    end;

    if UserInputService.VREnabled then
        table.insert(v1, "VR");
    end;

    if UserInputService.MouseEnabled or UserInputService.KeyboardEnabled then
        table.insert(v1, "PC");
    end;

    if UserInputService.TouchEnabled and not table.find(v1, "PC") then
        table.insert(v1, "Mobile");
    end;

    return v1;
end;