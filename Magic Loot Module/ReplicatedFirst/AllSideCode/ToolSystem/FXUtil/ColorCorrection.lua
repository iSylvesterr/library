-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 9
    local TweenService = game:GetService("TweenService");
    local RunService = game:GetService("RunService");
    local Lighting = game:GetService("Lighting");
    local u2 = nil;
    local u3 = nil;
    local u4 = false;
    local u5 = nil;
    local u6 = 0;

    local function _ccResolveEffect() -- Line: 27
        -- upvalues: Lighting (copy)
        local ColorCorrection = Lighting:FindFirstChild("ColorCorrection");

        if ColorCorrection and ColorCorrection:IsA("ColorCorrectionEffect") then
            return ColorCorrection;
        end;

        return Lighting:FindFirstChildWhichIsA("ColorCorrectionEffect");
    end;

    local function _ccAbortKeyframeAnim() -- Line: 38
        -- upvalues: u5 (ref), u6 (ref)
        if u5 then
            u5:Disconnect();
            u5 = nil;
        end;

        u6 = u6 + 1;
    end;

    function p1.Set_ColorCorrection(p7, p8, p9) -- Line: 48
        -- upvalues: u5 (ref), u6 (ref), Lighting (copy), u4 (ref), u2 (ref), u3 (ref)
        if u5 then
            u5:Disconnect();
            u5 = nil;
        end;

        u6 = u6 + 1;
        local ColorCorrection = Lighting:FindFirstChild("ColorCorrection");

        if not (ColorCorrection and ColorCorrection:IsA("ColorCorrectionEffect")) then
            ColorCorrection = Lighting:FindFirstChildWhichIsA("ColorCorrectionEffect");
        end;

        local v10 = false;

        if ColorCorrection then
            if u3 ~= ColorCorrection then
                u2 = nil;
                u4 = false;
            end;
        else
            ColorCorrection = Instance.new("ColorCorrectionEffect");
            ColorCorrection.Name = "FXUtil_ColorCorrection_Temp";
            ColorCorrection.Parent = Lighting;
            v10 = true;
            u4 = true;
            u2 = nil;
        end;

        u3 = ColorCorrection;

        if not v10 and u2 == nil then
            u2 = {
                Brightness = ColorCorrection.Brightness,
                Contrast = ColorCorrection.Contrast,
                Saturation = ColorCorrection.Saturation,
                TintColor = ColorCorrection.TintColor,
                Enabled = ColorCorrection.Enabled
            };
        end;

        ColorCorrection.Brightness = p7;
        ColorCorrection.TintColor = p8;

        if p9 ~= nil then
            ColorCorrection.Saturation = p9;
        end;
    end;

    function p1.Reset_ColorCorrection() -- Line: 87
        -- upvalues: u5 (ref), u6 (ref), u3 (ref), u2 (ref), u4 (ref)
        if u5 then
            u5:Disconnect();
            u5 = nil;
        end;

        u6 = u6 + 1;
        local v11 = u3;

        if not (v11 and v11.Parent) then
            u2 = nil;
            u3 = nil;
            u4 = false;

            return;
        end;

        if u4 then
            v11:Destroy();
            u4 = false;
            u3 = nil;
            u2 = nil;

            return;
        end;

        local v12 = u2;

        if v12 then
            v11.Brightness = v12.Brightness;
            v11.Contrast = v12.Contrast;
            v11.Saturation = v12.Saturation;
            v11.TintColor = v12.TintColor;
            v11.Enabled = v12.Enabled;
        end;

        u2 = nil;
        u3 = nil;
    end;

    local function _ccExtractKeyframes(p13, p14) -- Line: 124
        local v15 = p13[p14];

        if type(v15) ~= "table" then
            return nil;
        end;

        local v16 = {};

        for _, v in ipairs(v15) do
            if type(v) == "table" and (type(v.time) == "number" and v.time >= 0) then
                table.insert(v16, v);
            end;
        end;

        table.sort(v16, function(p17, p18) -- Line: 135
            return p17.time < p18.time;
        end);

        return #v16 > 0 and v16 and v16 or nil;
    end;

    local function _ccChannelMaxTime(p19) -- Line: 146
        local v20 = 0;

        for _, v in ipairs(p19) do
            if v20 < v.time then
                v20 = v.time;
            end;
        end;

        return v20;
    end;

    local function _ccSampleNumeric(p21, p22, p23) -- Line: 163
        -- upvalues: TweenService (copy)
        local v24 = 0;

        for _, v in ipairs(p22) do
            local time = v.time;
            local value = v.value;

            if type(value) == "number" then
                if p21 <= time then
                    local v25 = time - v24;

                    if v25 <= 0.00001 then
                        return value;
                    end;

                    local v26 = TweenService:GetValue(math.clamp((p21 - v24) / v25, 0, 1), v.easingStyle or Enum.EasingStyle.Linear, v.easingDir or Enum.EasingDirection.In);

                    return p23 + (value - p23) * v26;
                end;

                p23 = value;
                v24 = time;
            end;
        end;

        return p23;
    end;

    local function _ccSampleColor3(p27, p28, p29) -- Line: 197
        -- upvalues: TweenService (copy)
        local v30 = 0;

        for _, v in ipairs(p28) do
            local time = v.time;
            local value = v.value;

            if typeof(value) == "Color3" then
                if p27 <= time then
                    local v31 = time - v30;

                    if v31 <= 0.00001 then
                        return value;
                    end;

                    local v32 = TweenService:GetValue(math.clamp((p27 - v30) / v31, 0, 1), v.easingStyle or Enum.EasingStyle.Linear, v.easingDir or Enum.EasingDirection.In);

                    return Color3.new(p29.R + (value.R - p29.R) * v32, p29.G + (value.G - p29.G) * v32, p29.B + (value.B - p29.B) * v32);
                end;

                p29 = value;
                v30 = time;
            end;
        end;

        return p29;
    end;

    function p1.Tween_ColorCorrection(p33) -- Line: 270
        -- upvalues: _ccExtractKeyframes (copy), u5 (ref), u6 (ref), Lighting (copy), u4 (ref), u2 (ref), u3 (ref), RunService (copy), _ccSampleNumeric (copy), _ccSampleColor3 (copy)
        if not p33 then
            return;
        end;

        local u34 = _ccExtractKeyframes(p33, "brightness");
        local u35 = _ccExtractKeyframes(p33, "tintColor");
        local u36 = _ccExtractKeyframes(p33, "saturation");

        if not (u34 or (u35 or u36)) then
            return;
        end;

        local u37 = 0;

        if u34 then
            local v38 = 0;

            for _, v in ipairs(u34) do
                if v38 < v.time then
                    v38 = v.time;
                end;
            end;

            u37 = math.max(u37, v38);
        end;

        if u35 then
            local v39 = 0;

            for _, v in ipairs(u35) do
                if v39 < v.time then
                    v39 = v.time;
                end;
            end;

            u37 = math.max(u37, v39);
        end;

        if u36 then
            local v40 = 0;

            for _, v in ipairs(u36) do
                if v40 < v.time then
                    v40 = v.time;
                end;
            end;

            u37 = math.max(u37, v40);
        end;

        if u37 <= 0 then
            return;
        end;

        if u5 then
            u5:Disconnect();
            u5 = nil;
        end;

        u6 = u6 + 1;
        local ColorCorrection = Lighting:FindFirstChild("ColorCorrection");

        if not (ColorCorrection and ColorCorrection:IsA("ColorCorrectionEffect")) then
            ColorCorrection = Lighting:FindFirstChildWhichIsA("ColorCorrectionEffect");
        end;

        local v41 = false;

        if ColorCorrection then
            if u3 ~= ColorCorrection then
                u2 = nil;
                u4 = false;
            end;
        else
            ColorCorrection = Instance.new("ColorCorrectionEffect");
            ColorCorrection.Name = "FXUtil_ColorCorrection_Temp";
            ColorCorrection.Parent = Lighting;
            v41 = true;
            u4 = true;
            u2 = nil;
        end;

        u3 = ColorCorrection;

        if not v41 and u2 == nil then
            u2 = {
                Brightness = ColorCorrection.Brightness,
                Contrast = ColorCorrection.Contrast,
                Saturation = ColorCorrection.Saturation,
                TintColor = ColorCorrection.TintColor,
                Enabled = ColorCorrection.Enabled
            };
        end;

        local Brightness = ColorCorrection.Brightness;
        local Saturation = ColorCorrection.Saturation;
        local TintColor = ColorCorrection.TintColor;
        local onComplete = p33.onComplete;
        local u42 = u2;
        local u43 = u4;
        local u44 = ColorCorrection;
        local u45 = u6;
        local u46 = 0;

        local function finishAndCleanup() -- Line: 337
            -- upvalues: u45 (copy), u6 (ref), u5 (ref), u44 (copy), u2 (ref), u3 (ref), u4 (ref), u43 (copy), u42 (copy), onComplete (copy)
            if u45 ~= u6 then
                return;
            end;

            if u5 then
                u5:Disconnect();
                u5 = nil;
            end;

            u6 = u6 + 1;

            if u44.Parent then
                if u43 then
                    u44:Destroy();
                    u4 = false;
                    u3 = nil;
                    u2 = nil;
                else
                    if u42 then
                        u44.Brightness = u42.Brightness;
                        u44.Contrast = u42.Contrast;
                        u44.Saturation = u42.Saturation;
                        u44.TintColor = u42.TintColor;
                        u44.Enabled = u42.Enabled;
                    end;

                    u2 = nil;
                    u3 = nil;
                end;
            else
                u2 = nil;
                u3 = nil;
                u4 = false;
            end;

            if type(onComplete) == "function" then
                task.defer(function() -- Line: 369
                    -- upvalues: onComplete (ref)
                    local success, result = pcall(onComplete);

                    if not success then
                        warn("[FXUtil] Tween_ColorCorrection onComplete:", result);
                    end;
                end);
            end;
        end;

        u5 = RunService.Heartbeat:Connect(function(p47) -- Line: 378
            -- upvalues: u45 (copy), u6 (ref), ColorCorrection (ref), finishAndCleanup (copy), u46 (ref), u37 (ref), u34 (copy), _ccSampleNumeric (ref), Brightness (copy), u35 (copy), _ccSampleColor3 (ref), TintColor (copy), u36 (copy), Saturation (copy)
            if u45 ~= u6 then
                return;
            end;

            if not ColorCorrection.Parent then
                finishAndCleanup();

                return;
            end;

            u46 = u46 + p47;
            local v48 = math.min(u46, u37);

            if u34 then
                ColorCorrection.Brightness = _ccSampleNumeric(v48, u34, Brightness);
            end;

            if u35 then
                ColorCorrection.TintColor = _ccSampleColor3(v48, u35, TintColor);
            end;

            if u36 then
                ColorCorrection.Saturation = _ccSampleNumeric(v48, u36, Saturation);
            end;

            if u37 <= u46 then
                finishAndCleanup();
            end;
        end);
    end;
end;