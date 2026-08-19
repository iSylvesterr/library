-- Decompiled with Potassium's decompiler.

local HapticService = game:GetService("HapticService");
local UserInputService = game:GetService("UserInputService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local u1 = {
    Enum.UserInputType.Touch,
    Enum.UserInputType.Gamepad1,
    Enum.UserInputType.Gamepad2,
    Enum.UserInputType.Gamepad3,
    Enum.UserInputType.Gamepad4,
    Enum.UserInputType.Gamepad5,
    Enum.UserInputType.Gamepad6,
    Enum.UserInputType.Gamepad7,
    Enum.UserInputType.Gamepad8,
    Enum.UserInputType.Accelerometer,
    Enum.UserInputType.Gyro
};
local u2 = {};
local u3 = {};

for _, v in ipairs(u1) do
    u2[v] = true;
end;

return function(u4, p5, u6, u7) -- Line: 28
    -- upvalues: Asserts (copy), HapticService (copy), u1 (copy), UserInputService (copy), u2 (copy), u3 (copy)
    Asserts.number(u4);
    assert(u4 == u4, "strength is not NaN");
    local v8;

    if u4 > 0 then
        v8 = u4 <= 1;
    else
        v8 = false;
    end;

    assert(v8, "strength must be between 0 (exclusive) and 1 (inclusive)");

    if p5 ~= nil then
        local v9;

        if type(p5) == "number" then
            v9 = p5 >= 0;
        else
            v9 = false;
        end;

        assert(v9, "holdDuration must be a non-negative number");
    end;

    if u6 == nil then
        u6 = Enum.VibrationMotor.Small;
    else
        local v10;

        if typeof(u6) == "EnumItem" then
            v10 = u6.EnumType == Enum.VibrationMotor;
        else
            v10 = false;
        end;

        assert(v10, "motorType must be an Enum.VibrationMotor");
    end;

    assert(u6, "luau");

    if u7 ~= nil then
        local v11;

        if typeof(u7) == "EnumItem" then
            v11 = u7.EnumType == Enum.UserInputType;
        else
            v11 = false;
        end;

        assert(v11, "inputType must be an Enum.UserInputType");
    end;

    if u7 then
        if not HapticService:IsVibrationSupported(u7, u6) then
            return;
        end;
    else
        for _, v in ipairs(u1) do
            if HapticService:IsVibrationSupported(v, u6) then
                u7 = v;
                break;
            end;
        end;
    end;

    if not u7 then
        return;
    end;

    local u12 = p5 or 0;
    local v13 = UserInputService:GetLastInputType();

    if not u2[v13] then
        return;
    end;

    local u14 = 0;

    if v13.Name:find("^Gamepad") then
        u14 = math.max(u14, 0.15);
    end;

    local u15 = string.format("%d/%d", u6.Value, u7.Value);

    if not u3[u15] then
        u3[u15] = true;
        task.spawn(function() -- Line: 92
            -- upvalues: HapticService (ref), u7 (ref), u6 (ref), u4 (copy), u14 (ref), u12 (copy), u3 (ref), u15 (copy)
            HapticService:SetMotor(u7, u6, u4);
            task.wait(u14);
            task.wait(u12);
            HapticService:SetMotor(u7, u6, 0);
            task.wait(u14 * 0.5);
            u3[u15] = nil;
        end);
    end;
end;