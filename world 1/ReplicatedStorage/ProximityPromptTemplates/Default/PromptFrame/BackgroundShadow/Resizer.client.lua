-- Decompiled with Potassium's decompiler.

local function refresh() -- Line: 10
    local Parent = script.Parent.Parent.Parent;
    local Offset = Parent.Size.X.Offset;
    local Offset2 = Parent.Size.Y.Offset;

    if #script.Parent.Parent.ActionText.Text > 0 and #script.Parent.Parent.ObjectText.Text > 0 then
        script.Parent.Size = UDim2.new(0, Offset * 1.56, 0, Offset2 * 2.53);
        script.Parent.Image = "rbxassetid://80621645904046";

        return;
    end;

    script.Parent.Size = UDim2.new(0, Offset * 1.67, 0, Offset2 * 1.67);
    script.Parent.Image = "rbxassetid://130991436152844";
end;

refresh();
script.Parent.Parent.Parent:GetPropertyChangedSignal("Size"):Connect(refresh);