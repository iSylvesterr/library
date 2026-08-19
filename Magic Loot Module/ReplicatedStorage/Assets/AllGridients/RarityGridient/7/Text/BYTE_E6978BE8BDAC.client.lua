-- Decompiled with Potassium's decompiler.

local Parent = script.Parent;
local Rotation = Parent.Rotation;

while wait(0.1) do
    local v1 = Rotation + 5;
    Parent.Rotation = v1;
    Rotation = v1 > 360 and 0 or v1;
end;