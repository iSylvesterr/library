-- Decompiled with Potassium's decompiler.

local u1 = workspace;
local u2 = UserSettings();

return function(p3, p4) -- Line: 4
    -- upvalues: u2 (copy), u1 (copy)
    local Value = u2.GameSettings.SavedQualityLevel.Value;
    local v5 = math.clamp(1 - ((u1.CurrentCamera.CFrame.Position - p4).Magnitude - 200) / 800, 0, 1);

    return p3 * ((Value == 0 and 10 or Value) / 10) * v5;
end;