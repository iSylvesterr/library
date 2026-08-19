-- Decompiled with Potassium's decompiler.

local u1 = {};
local UserInputService = game:GetService("UserInputService");
local u2 = {};
local u3 = 0;

function u1.IsDoublePressed() -- Line: 27
    -- upvalues: u3 (ref)
    return tick() - u3 < 0.1;
end;

function u1.Add(u4, u5, u6) -- Line: 33
    -- upvalues: u2 (copy)
    table.insert(u2, {
        closeButton = u5,
        onClose = u6,
        frame = u4
    });

    if not u5 then
        return;
    end;

    u5.MouseButton1Click:Connect(function() -- Line: 37
        -- upvalues: u6 (copy), u4 (copy), u5 (copy)
        u6(u4, u5);
    end);
    u5.Activated:Connect(function(p7) -- Line: 41
        -- upvalues: u6 (copy), u4 (copy), u5 (copy)
        if p7 and p7.UserInputType == Enum.UserInputType.Gamepad1 then
            u6(u4, u5);
        end;
    end);
end;

function u1.CloseFrame() -- Line: 50
    -- upvalues: u2 (copy), u3 (ref)
    for i = #u2, 1, -1 do
        local v8 = u2[i];

        if v8.frame.Parent and v8.frame.Visible then
            v8.onClose(v8.frame, v8.closeButton);
            u3 = tick();

            return true;
        end;
    end;

    return false;
end;

UserInputService.InputBegan:Connect(function(p9) -- Line: 67
    -- upvalues: u1 (copy)
    if p9.UserInputType ~= Enum.UserInputType.Gamepad1 or p9.KeyCode ~= Enum.KeyCode.ButtonB then
        return;
    end;

    u1.CloseFrame();
end);

return u1;