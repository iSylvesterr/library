-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");

local function adjustBrightness(p1, p2) -- Line: 3
    local v3, v4, v5 = p1:ToHSV();
    local v6 = math.clamp(v5 + p2, 0, 1);

    return Color3.fromHSV(v3, v4, v6);
end;

return function(p7) -- Line: 9
    -- upvalues: TweenService (copy)
    local InletTexture = p7:FindFirstChild("InletTexture", true);

    if not p7:GetAttribute("DefaultColor") then
        p7:SetAttribute("DefaultColor", InletTexture.ImageColor3);
    end;

    local v8 = p7:GetAttribute("DefaultColor");
    local v9, v10, v11 = v8:ToHSV();
    local v12 = math.clamp(v11 + 0.1, 0, 1);
    local v13 = Color3.fromHSV(v9, v10, v12);
    local SENSOR = p7:FindFirstChild("SENSOR", true);
    p7:FindFirstChild("UIScale", true);
    local u14 = TweenService:Create(InletTexture, TweenInfo.new(0.25), {
        ImageColor3 = v13
    });
    local u15 = TweenService:Create(InletTexture, TweenInfo.new(0.25), {
        ImageColor3 = v8
    });
    SENSOR.MouseEnter:Connect(function() -- Line: 26
        -- upvalues: u14 (copy)
        u14:Play();
    end);
    SENSOR.MouseLeave:Connect(function() -- Line: 29
        -- upvalues: u15 (copy)
        u15:Play();
    end);

    return SENSOR;
end;