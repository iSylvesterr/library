-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 1
    local v2 = 0;
    local PrimaryPart = p1.PrimaryPart;

    if PrimaryPart then
        v2 = v2 - PrimaryPart.Size.Y / 2;
    end;

    local v3 = p1:FindFirstChildOfClass("Humanoid");

    if v3 then
        v2 = v2 - v3.HipHeight;
    end;

    return CFrame.new(0, v2, 0);
end;