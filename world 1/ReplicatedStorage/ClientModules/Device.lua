-- Decompiled with Potassium's decompiler.

game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local u3 = {
    DeviceChanged = require(script.Parent.Signal).new(),

    GetCurrentDevice = function(p1) -- Line: 13, Name: GetCurrentDevice
        -- upvalues: UserInputService (copy)
        local v2 = UserInputService:GetLastInputType();

        return v2 == Enum.UserInputType.Touch and "Touch" or ((v2 == Enum.UserInputType.Keyboard or string.find(v2.Name, "Mouse", 1, true)) and "PC" or (string.find(v2.Name, "Gamepad", 1, true) and "Gamepad" or "PC"));
    end
};

function u3.Observe(p4, u5) -- Line: 26
    -- upvalues: u3 (copy)
    local u6 = u3.DeviceChanged:Connect(function() -- Line: 27
        -- upvalues: u5 (copy), u3 (ref)
        task.spawn(u5, u3:GetCurrentDevice());
    end);
    task.spawn(u5, u3:GetCurrentDevice());

    return function() -- Line: 33
        -- upvalues: u6 (copy)
        u6:Disconnect();
    end;
end;

function u3.Start(p7) -- Line: 38
    -- upvalues: u3 (copy), UserInputService (copy)
    local u8 = nil;
    UserInputService.LastInputTypeChanged:Connect(function() -- Line: 40, Name: updateInput
        -- upvalues: u3 (ref), u8 (ref)
        local v9 = u3:GetCurrentDevice();

        if v9 == u8 then
            return;
        end;

        u8 = v9;
        u3.DeviceChanged:Fire(v9);
    end);
    local v10 = u3:GetCurrentDevice();

    if v10 ~= u8 then
        u8 = v10;
        u3.DeviceChanged:Fire(v10);
    end;
end;

task.spawn(u3.Start, u3);

return u3;