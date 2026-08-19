-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");
local Touch = Enum.UserInputType.Touch;
local Keyboard = Enum.UserInputType.Keyboard;
local u1 = nil;
local u2 = {};
u1 = {
    Current = "MouseKeyboard",

    Observe = function(u3) -- Line: 83, Name: Observe
        -- upvalues: u2 (copy), u1 (ref)
        if table.find(u2, u3) then
            error("function already subscribed", 2);
        end;

        table.insert(u2, u3);
        task.spawn(u3, u1.Current);

        return function() -- Line: 91
            -- upvalues: u2 (ref), u3 (copy)
            local v4 = table.find(u2, u3);

            if v4 then
                local v5 = #u2;
                u2[v4] = u2[v5];
                u2[v5] = nil;
            end;
        end;
    end
};

local function SetPreferred(p6) -- Line: 101
    -- upvalues: u1 (ref), u2 (copy)
    if p6 == u1.Current then
        return;
    end;

    u1.Current = p6;

    for _, v in u2 do
        task.spawn(v, p6);
    end;
end;

local function DeterminePreferred(p7) -- Line: 112
    -- upvalues: Touch (copy), SetPreferred (copy), Keyboard (copy)
    if p7 == Touch then
        SetPreferred("Touch");

        return;
    end;

    if p7 == Keyboard or string.sub(p7.Name, 1, 5) == "Mouse" then
        SetPreferred("MouseKeyboard");

        return;
    end;

    if string.sub(p7.Name, 1, 7) == "Gamepad" then
        SetPreferred("Gamepad");
    end;
end;

local v8 = UserInputService:GetLastInputType();

if v8 == Touch then
    SetPreferred("Touch");
elseif v8 == Keyboard or string.sub(v8.Name, 1, 5) == "Mouse" then
    SetPreferred("MouseKeyboard");
elseif string.sub(v8.Name, 1, 7) == "Gamepad" then
    SetPreferred("Gamepad");
end;

UserInputService.LastInputTypeChanged:Connect(DeterminePreferred);

return u1;