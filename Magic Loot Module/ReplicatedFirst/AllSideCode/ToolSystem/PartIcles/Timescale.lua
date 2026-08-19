-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 23
    function p1._seedTsOverride(p2, p3) -- Line: 26
        if not p3 then
            return;
        end;

        p2._tsOverride = p3:GetAttribute("_tsOverride");
        p2._tsOverrideUntil = p3:GetAttribute("_tsOverrideUntil");
    end;

    local function _setNativePE(u4, u5, p6, p7) -- Line: 33
        if u4:GetAttribute("_origTimeScale") == nil then
            pcall(function() -- Line: 35
                -- upvalues: u4 (copy)
                u4:SetAttribute("_origTimeScale", u4.TimeScale);
            end);
        end;

        pcall(function() -- Line: 37
            -- upvalues: u4 (copy), u5 (copy)
            u4.TimeScale = u5;
        end);
        local u8 = (u4:GetAttribute("_tsGen") or 0) + 1;
        pcall(function() -- Line: 40
            -- upvalues: u4 (copy), u8 (copy)
            u4:SetAttribute("_tsGen", u8);
        end);

        if p7 == true then
            return;
        end;

        task.delay(p6, function() -- Line: 42
            -- upvalues: u4 (copy), u8 (copy)
            if not u4.Parent then
                return;
            end;

            if u4:GetAttribute("_tsGen") ~= u8 then
                return;
            end;

            local u9 = u4:GetAttribute("_origTimeScale");

            if u9 ~= nil then
                pcall(function() -- Line: 47
                    -- upvalues: u4 (ref), u9 (copy)
                    u4.TimeScale = u9;
                end);
                pcall(function() -- Line: 48
                    -- upvalues: u4 (ref)
                    u4:SetAttribute("_origTimeScale", nil);
                end);
            end;

            pcall(function() -- Line: 50
                -- upvalues: u4 (ref)
                u4:SetAttribute("_tsGen", nil);
            end);
        end);
    end;

    local function _clearNativePE(u10) -- Line: 54
        local u11 = u10:GetAttribute("_origTimeScale");

        if u11 ~= nil then
            pcall(function() -- Line: 57
                -- upvalues: u10 (copy), u11 (copy)
                u10.TimeScale = u11;
            end);
            pcall(function() -- Line: 58
                -- upvalues: u10 (copy)
                u10:SetAttribute("_origTimeScale", nil);
            end);
        end;

        local u12 = (u10:GetAttribute("_tsGen") or 0) + 1;
        pcall(function() -- Line: 62
            -- upvalues: u10 (copy), u12 (copy)
            u10:SetAttribute("_tsGen", u12);
        end);
        pcall(function() -- Line: 63
            -- upvalues: u10 (copy)
            u10:SetAttribute("_tsGen", nil);
        end);
    end;

    function p1.SetTimescale(p13, u14, u15, p16, p17) -- Line: 68
        -- upvalues: _setNativePE (copy)
        if not u14 then
            return;
        end;

        if typeof(u15) ~= "number" then
            return;
        end;

        if p17 == true then
            p16 = nil;
        elseif typeof(p16) ~= "number" or p16 <= 0 then
            p13:ClearTimescale(u14);

            return;
        end;

        if u14:IsA("ParticleEmitter") then
            _setNativePE(u14, u15, p16, p17);

            return;
        end;

        local u18 = p17 == true and (1 / 0) or os.clock() + p16;
        pcall(function() -- Line: 85
            -- upvalues: u14 (copy), u15 (copy), u18 (copy)
            u14:SetAttribute("_tsOverride", u15);
            u14:SetAttribute("_tsOverrideUntil", u18);
        end);
        local ActiveEmits = p13.ActiveEmits;

        for i = 1, #ActiveEmits do
            local v19 = ActiveEmits[i];

            if v19 and v19._sourceItem == u14 then
                v19._tsOverride = u15;
                v19._tsOverrideUntil = u18;
            end;
        end;
    end;

    function p1.ClearTimescale(p20, u21) -- Line: 101
        -- upvalues: _clearNativePE (copy)
        if not u21 then
            return;
        end;

        if u21:IsA("ParticleEmitter") then
            _clearNativePE(u21);

            return;
        end;

        pcall(function() -- Line: 107
            -- upvalues: u21 (copy)
            u21:SetAttribute("_tsOverride", nil);
            u21:SetAttribute("_tsOverrideUntil", nil);
        end);
        local ActiveEmits = p20.ActiveEmits;

        for i = 1, #ActiveEmits do
            local v22 = ActiveEmits[i];

            if v22 and v22._sourceItem == u21 then
                v22._tsOverride = nil;
                v22._tsOverrideUntil = nil;
            end;
        end;
    end;

    function p1.AbsoluteSetTimescale(p23, p24, p25, p26, p27) -- Line: 122
        if not p24 then
            return;
        end;

        if p24:GetAttribute("Transformed") then
            p23:SetTimescale(p24, p25, p26, p27);

            return;
        end;

        if p24:IsA("ParticleEmitter") then
            p23:SetTimescale(p24, p25, p26, p27);

            return;
        end;

        for _, child in p24:GetChildren() do
            if not p24:IsA("BasePart") or (not child:IsA("BasePart") or child:GetAttribute("Transformed")) then
                p23:AbsoluteSetTimescale(child, p25, p26, p27);
            end;
        end;
    end;

    function p1.AbsoluteClearTimescale(p28, p29) -- Line: 141
        if not p29 then
            return;
        end;

        if p29:GetAttribute("Transformed") then
            p28:ClearTimescale(p29);

            return;
        end;

        if p29:IsA("ParticleEmitter") then
            p28:ClearTimescale(p29);

            return;
        end;

        for _, child in p29:GetChildren() do
            if not p29:IsA("BasePart") or (not child:IsA("BasePart") or child:GetAttribute("Transformed")) then
                p28:AbsoluteClearTimescale(child);
            end;
        end;
    end;
end;