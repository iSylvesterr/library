-- Decompiled with Potassium's decompiler.

local StarterGui = game:GetService("StarterGui");

while true do
    local success, result = pcall(StarterGui.SetCore, StarterGui, "ResetButtonCallback", false);
    _ = result;

    if success then
        break;
    end;

    task.wait();
end;