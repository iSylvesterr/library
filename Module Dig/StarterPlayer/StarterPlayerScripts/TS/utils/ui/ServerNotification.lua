-- Decompiled with Potassium's decompiler.

local Notification = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, script.Parent, "Notification").Notification;
local u1 = setmetatable({}, {
    __tostring = function() -- Line: 8, Name: __tostring
        return "ServerNotification";
    end,

    __index = Notification
});
u1.__index = u1;

function u1.new(...) -- Line: 14
    -- upvalues: u1 (ref)
    local v2 = setmetatable({}, u1);

    return v2:constructor(...) or v2;
end;

function u1.constructor(p3, p4, p5, p6, p7, p8) -- Line: 18
    -- upvalues: Notification (copy)
    Notification.constructor(p3, p4, p5, p6 == nil and "Notification" or p6, p7 == nil and "White" or p7, p8, "ServerNotification", "SystemNotifications", Enum.FontStyle.Italic);
end;

return {
    ServerNotification = u1
};