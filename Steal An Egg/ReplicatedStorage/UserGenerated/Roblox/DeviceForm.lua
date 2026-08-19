-- Decompiled with Potassium's decompiler.

local GuiService = game:GetService("GuiService");
local UserInputService = game:GetService("UserInputService");

local function SafeGet(u1, u2, p3) -- Line: 30
    local success, result = pcall(function() -- Line: 31
        -- upvalues: u1 (copy), u2 (copy)
        return u1[u2];
    end);

    if success then
        return result;
    end;

    return p3;
end;

local function IsWindows() -- Line: 37
    -- upvalues: GuiService (copy)
    local u4 = GuiService;
    local u5 = "IsWindows";
    local success, result = pcall(function() -- Line: 31
        -- upvalues: u4 (copy), u5 (copy)
        return u4[u5];
    end);

    if success then
        return result;
    end;

    return false;
end;

return table.freeze({
    Get = function() -- Line: 41, Name: Get
        -- upvalues: UserInputService (copy), GuiService (copy)
        if UserInputService.VREnabled then
            return Enum.DeviceForm.VR;
        end;

        if GuiService:IsTenFootInterface() then
            return Enum.DeviceForm.Console;
        end;

        local u6 = GuiService;
        local u7 = "IsWindows";
        local success, result = pcall(function() -- Line: 31
            -- upvalues: u6 (copy), u7 (copy)
            return u6[u7];
        end);

        if not success then
            result = false;
        end;

        if result then
            return Enum.DeviceForm.Desktop;
        end;

        if UserInputService.GyroscopeEnabled or UserInputService.AccelerometerEnabled then
            return Enum.DeviceForm.Phone;
        end;

        if UserInputService.MouseEnabled then
            return Enum.DeviceForm.Desktop;
        end;

        if UserInputService.TouchEnabled then
            return Enum.DeviceForm.Phone;
        end;

        if UserInputService.GamepadEnabled then
            return Enum.DeviceForm.Console;
        end;

        return nil;
    end
});