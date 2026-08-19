-- Decompiled with Potassium's decompiler.

local TextService = game:GetService("TextService");
local Parent = script.Parent;
Parent.TextScaled = false;
Parent.TextWrapped = false;

local function setSize() -- Line: 8
    -- upvalues: TextService (copy), Parent (copy)
    local v1 = TextService:GetTextSize(Parent.Text, Parent.TextSize, Parent.Font, Vector2.new((1 / 0), 1)) + Vector2.new(1, 1);
    Parent.Size = UDim2.new(0, v1.X, 0, v1.Y);
end;

setSize();
Parent.Changed:Connect(function(p2) -- Line: 16
    -- upvalues: setSize (copy)
    if p2 == "Text" then
        setSize();
    end;
end);