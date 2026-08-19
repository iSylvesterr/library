-- Decompiled with Potassium's decompiler.

local StarterGui = game:GetService("StarterGui");
task.wait(3);
local v1 = { "GUIFX Holder", "ScreenGui", "ShiftLockButton" };

for _, child in StarterGui:GetChildren() do
    if not table.find(v1, child.Name) and (child:IsA("ScreenGui") and child.ResetOnSpawn) then
        error("ScreenGui \'" .. child.Name .. "\' has ResetOnSpawn enabled, which is not allowed.");
    end;
end;