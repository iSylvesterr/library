-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");

local function adjustBrightness(p1, p2) -- Line: 3
    local v3, v4, v5 = p1:ToHSV();
    local v6 = math.clamp(v5 + p2, 0, 1);

    return Color3.fromHSV(v3, v4, v6);
end;

return function(p7, p8) -- Line: 9
    -- upvalues: TweenService (copy)
    if not p7:GetAttribute("DefaultColor") then
        p7:SetAttribute("DefaultColor", p7.BackgroundColor3);
    end;

    local v9 = p7:GetAttribute("DefaultColor");
    local v10, v11, v12 = v9:ToHSV();
    local v13 = math.clamp(v12 + (p8 or 0.1), 0, 1);
    local v14 = Color3.fromHSV(v10, v11, v13);
    local SENSOR = p7:FindFirstChild("SENSOR", true);
    p7:FindFirstChild("UIScale", true);
    local u15 = TweenService:Create(p7, TweenInfo.new(0.25), {
        BackgroundColor3 = v14
    });
    local u16 = TweenService:Create(p7, TweenInfo.new(0.25), {
        BackgroundColor3 = v9
    });
    SENSOR.MouseEnter:Connect(function() -- Line: 26
        -- upvalues: u15 (copy)
        u15:Play();
    end);
    SENSOR.MouseLeave:Connect(function() -- Line: 29
        -- upvalues: u16 (copy)
        u16:Play();
    end);

    return SENSOR;
end;