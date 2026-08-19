-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);

return function(p1) -- Line: 10
    -- upvalues: Asserts (copy)
    Asserts.GuiObject(p1);
    local v2 = p1:FindFirstChildWhichIsA("UIScale");

    if v2 then
        return v2;
    end;

    local UIScale = Instance.new("UIScale");
    UIScale.Parent = p1;

    return UIScale;
end;