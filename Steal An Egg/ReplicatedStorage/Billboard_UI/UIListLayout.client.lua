-- Decompiled with Potassium's decompiler.

local GamepadService = game:GetService("GamepadService");
local UserInputService = game:GetService("UserInputService");

if UserInputService.GamepadEnabled and not (UserInputService.KeyboardEnabled or UserInputService.MouseEnabled) and true or false then
    local Parent = script.Parent;

    local function updateGamepad() -- Line: 12
        -- upvalues: Parent (copy), GamepadService (copy)
        if #Parent:GetChildren() == 2 then
            GamepadService:DisableGamepadCursor();

            return;
        end;

        GamepadService:EnableGamepadCursor((Parent:FindFirstChildWhichIsA("Frame")));
    end;

    Parent.ChildAdded:Connect(function() -- Line: 22
        -- upvalues: Parent (copy), GamepadService (copy)
        if #Parent:GetChildren() == 2 then
            GamepadService:DisableGamepadCursor();

            return;
        end;

        GamepadService:EnableGamepadCursor((Parent:FindFirstChildWhichIsA("Frame")));
    end);
    Parent.ChildRemoved:Connect(function() -- Line: 26
        -- upvalues: Parent (copy), GamepadService (copy)
        if #Parent:GetChildren() == 2 then
            GamepadService:DisableGamepadCursor();

            return;
        end;

        GamepadService:EnableGamepadCursor((Parent:FindFirstChildWhichIsA("Frame")));
    end);
end;