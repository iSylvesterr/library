-- Decompiled with Potassium's decompiler.

game:GetService("UserInputService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Signal = require(ReplicatedStorage.ClientModules.Signal);
local Trove = require(ReplicatedStorage.ClientModules.Trove);
local u1 = {};
u1.__index = u1;

function u1.new(p2, p3, p4, p5) -- Line: 11
    -- upvalues: u1 (copy), Trove (copy), Signal (copy)
    local v6 = setmetatable({}, u1);
    v6.Cleaner = p4 or Trove.new();
    v6.Clicked = Signal.new();

    if p5 then
        v6.MouseDown = Signal.new();
        v6.MouseUp = Signal.new();
    end;

    v6.Button = p2;
    v6._ClickedState = false;
    v6:Init();

    return v6;
end;

function u1.Init(u7) -- Line: 30
    u7.Cleaner:Add(u7.Button.InputBegan:Connect(function(p8) -- Line: 31
        -- upvalues: u7 (copy)
        if p8.UserInputType ~= Enum.UserInputType.MouseButton1 and (p8.UserInputType ~= Enum.UserInputType.Touch or p8.UserInputState ~= Enum.UserInputState.Begin) and p8.KeyCode ~= Enum.KeyCode.ButtonA then
            return;
        end;

        if u7.MouseDown then
            u7.MouseDown:Fire();
        end;

        u7._ClickedState = true;
    end));
    u7.Cleaner:Add(u7.Button.InputEnded:Connect(function(p9) -- Line: 45
        -- upvalues: u7 (copy)
        if p9.UserInputType ~= Enum.UserInputType.MouseButton1 and p9.UserInputType ~= Enum.UserInputType.Touch and p9.KeyCode ~= Enum.KeyCode.ButtonA then
            return;
        end;

        if u7.MouseUp then
            u7.MouseUp:Fire();
        end;

        local v10 = u7:GetClickedState();
        u7._ClickedState = false;

        if v10 then
            u7.Clicked:Fire();
        end;
    end));
    u7.Cleaner:Add(u7.Button.Destroying:Once(function() -- Line: 64
        -- upvalues: u7 (copy)
        u7:Destroy();
    end));
end;

function u1.Destroy(p11) -- Line: 69
    if p11.MouseDown then
        p11.MouseDown:DisconnectAll();
        p11.MouseDown:Destroy();
    end;

    if p11.MouseUp then
        p11.MouseUp:DisconnectAll();
        p11.MouseUp:Destroy();
    end;

    p11.Clicked:DisconnectAll();
    p11.Clicked:Destroy();
    p11.Cleaner:Destroy();
end;

function u1.GetClickedState(p12) -- Line: 85
    return p12._ClickedState;
end;

return u1;