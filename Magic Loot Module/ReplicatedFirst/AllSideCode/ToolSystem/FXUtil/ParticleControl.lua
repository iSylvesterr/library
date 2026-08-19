-- Decompiled with Potassium's decompiler.

return function(u1) -- Line: 9
    local TweenService = game:GetService("TweenService");
    local RunService = game:GetService("RunService");

    function u1.Stop_All_Particles(p2) -- Line: 19
        -- upvalues: u1 (copy)
        for _, v in u1.GetVfxCache(p2).emitters do
            if v.Parent then
                v.Enabled = false;
            end;
        end;
    end;

    function u1.Start_All_Particles(p3) -- Line: 33
        -- upvalues: u1 (copy)
        for _, v in u1.GetVfxCache(p3).emitters do
            if v.Parent then
                v.Enabled = true;
            end;
        end;
    end;

    function u1.SetEmittersTrailsBeamsEnabled(p4, p5) -- Line: 49
        -- upvalues: u1 (copy)
        if not p4 then
            return;
        end;

        local v6 = u1.GetVfxCache(p4);

        for _, v in v6.emitters do
            if v.Parent then
                v.Enabled = p5;
            end;
        end;

        for _, v in v6.trails do
            if v.Parent then
                v.Enabled = p5;
            end;
        end;

        for _, v in v6.beams do
            if v.Parent then
                v.Enabled = p5;
            end;
        end;
    end;

    local function _emitOnceEnablePe(u7) -- Line: 75
        local v8 = u7:GetAttribute("EmitDelay");
        local u9 = type(v8) == "number" and v8 and v8 or 0;
        local v10 = u7:GetAttribute("EmitCount");
        local v11 = type(v10) == "number" and (v10 or 1) or 1;
        local u12 = v11 < 1 and 1 or v11;
        task.spawn(function() -- Line: 83
            -- upvalues: u9 (copy), u7 (copy), u12 (ref)
            if u9 > 0 then
                task.wait(u9);
            end;

            u7:Emit(u12);
            u7.Enabled = true;
        end);
    end;

    function u1.EmitOnceThenEnableContinuous(p13) -- Line: 96
        -- upvalues: u1 (copy), _emitOnceEnablePe (copy)
        local v14 = u1.GetVfxCache(p13);

        for _, v in v14.emitters do
            if v.Parent then
                _emitOnceEnablePe(v);
            end;
        end;

        for _, v in v14.trails do
            if v.Parent then
                v.Enabled = true;
            end;
        end;

        for _, v in v14.beams do
            if v.Parent then
                v.Enabled = true;
            end;
        end;
    end;

    local function _setEnableNameSubstringVfx(p15, p16, p17) -- Line: 121
        if string.find(string.lower(p15.Name), p16, 1, true) == nil then
            return;
        end;

        if p15:IsA("ParticleEmitter") or (p15:IsA("Beam") or p15:IsA("Trail")) then
            p15.Enabled = p17;
        end;
    end;

    function u1.OffEnableVfx(p18) -- Line: 131
        -- upvalues: _setEnableNameSubstringVfx (copy)
        if not p18 then
            return;
        end;

        _setEnableNameSubstringVfx(p18, "enable", false);

        for _, descendant in p18:GetDescendants() do
            _setEnableNameSubstringVfx(descendant, "enable", false);
        end;
    end;

    function u1.SetEnableNameVfx(p19, p20) -- Line: 143
        -- upvalues: _setEnableNameSubstringVfx (copy)
        if not p19 then
            return;
        end;

        _setEnableNameSubstringVfx(p19, "enable", p20);

        for _, descendant in p19:GetDescendants() do
            _setEnableNameSubstringVfx(descendant, "enable", p20);
        end;
    end;

    function u1.HideModelBasePartsStopEmit(p21) -- Line: 155
        -- upvalues: u1 (copy)
        if not p21 then
            return;
        end;

        for _, descendant in p21:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Transparency = 1;
            end;
        end;

        u1.Stop_All_Emit(p21);
    end;

    function u1.CollectModelBaseParts(p22) -- Line: 171
        local v23 = {};

        if p22:IsA("BasePart") then
            table.insert(v23, p22);
        end;

        for _, descendant in p22:GetDescendants() do
            if descendant:IsA("BasePart") then
                table.insert(v23, descendant);
            end;
        end;

        return v23;
    end;

    function u1.SetAllBasePartsSize(p24, p25) -- Line: 184
        if p24:IsA("BasePart") then
            p24.Size = p25;

            return;
        end;

        for _, descendant in p24:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Size = p25;
            end;
        end;
    end;

    function u1.SetAllBasePartsTransparency(p26, p27) -- Line: 196
        if p26:IsA("BasePart") then
            p26.Transparency = p27;
        end;

        for _, descendant in p26:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Transparency = p27;
            end;
        end;
    end;

    function u1.PivotModelOnGroundAtWorldY(p28, p29) -- Line: 208
        local v30 = p28.PrimaryPart or p28:FindFirstChildWhichIsA("BasePart", true);

        if not (v30 and v30:IsA("BasePart")) then
            return;
        end;

        local Y = v30.Size.Y;
        local Rotation = p28:GetPivot().Rotation;
        local v31 = Vector3.new(p29.X, p29.Y + Y * 0.5, p29.Z);
        p28:PivotTo(CFrame.new(v31) * Rotation);
    end;

    local function _emitBurstInNamePe(u32, p33) -- Line: 224
        if string.find(string.lower(u32.Name), "emit", 1, true) == nil then
            return;
        end;

        if p33 then
            u32.Enabled = false;
        end;

        task.spawn(function() -- Line: 232
            -- upvalues: u32 (copy)
            local v34 = u32:GetAttribute("EmitDelay");
            local v35 = u32:GetAttribute("EmitCount") or 1;

            if v34 then
                task.wait(v34);
            end;

            u32:Emit(v35);
        end);
    end;

    function u1.EmitBurstEmitInName(p36, p37) -- Line: 243
        -- upvalues: _emitBurstInNamePe (copy)
        if p36:IsA("ParticleEmitter") then
            _emitBurstInNamePe(p36, p37);
        end;

        for _, descendant in p36:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                _emitBurstInNamePe(descendant, p37);
            end;
        end;
    end;

    local function _findBeamAttachmentByName(p38, p39) -- Line: 260
        local v40 = p38:FindFirstChild(p39, true);

        if v40 and v40:IsA("Attachment") then
            return v40;
        end;

        return nil;
    end;

    function u1.WireAllBeamsBetweenAttachments(p41, p42, p43, p44) -- Line: 271
        local v45 = p41:FindFirstChild(p43, true);

        if not (v45 and v45:IsA("Attachment")) then
            v45 = nil;
        end;

        local v46 = p42:FindFirstChild(p44, true);

        if not (v46 and v46:IsA("Attachment")) then
            v46 = nil;
        end;

        if not (v45 and v46) then
            return;
        end;

        local v47 = { p41, p42 };

        for i = 1, #v47 do
            for _, descendant in v47[i]:GetDescendants() do
                if descendant:IsA("Beam") then
                    descendant.Attachment0 = v45;
                    descendant.Attachment1 = v46;
                    descendant.Enabled = true;
                end;
            end;
        end;
    end;

    local function _numSeqLerpTowardOpaque(p48, p49) -- Line: 296
        local v50 = {};

        for _, v in p48.Keypoints do
            table.insert(v50, NumberSequenceKeypoint.new(v.Time, v.Value + (1 - v.Value) * p49, v.Envelope * (1 - p49)));
        end;

        return NumberSequence.new(v50);
    end;

    function u1.FadeEmittersTrailsBeamsTransparencyOverTime(u51, u52, u53) -- Line: 314
        -- upvalues: u1 (copy), RunService (copy), TweenService (copy), _numSeqLerpTowardOpaque (copy)
        if not u51 or u52 <= 0 then
            if u53 then
                u53();
            end;

            return;
        end;

        local v54 = u1.GetVfxCache(u51);
        local emitters = v54.emitters;
        local u55 = {};

        for _, v in v54.trails do
            table.insert(u55, v);
        end;

        for _, v in v54.beams do
            table.insert(u55, v);
        end;

        local u56 = {};

        for _, v in emitters do
            u56[v] = v.Transparency;
        end;

        for _, v in u55 do
            u56[v] = v.Transparency;
        end;

        task.spawn(function() -- Line: 340
            -- upvalues: u52 (copy), u51 (copy), u53 (copy), RunService (ref), TweenService (ref), emitters (copy), u56 (copy), _numSeqLerpTowardOpaque (ref), u55 (copy), u1 (ref)
            local v57 = 0;

            while v57 < u52 do
                if not u51.Parent then
                    if u53 then
                        u53();
                    end;

                    return;
                end;

                v57 = v57 + RunService.Heartbeat:Wait();
                local v58 = TweenService:GetValue(math.clamp(v57 / u52, 0, 1), Enum.EasingStyle.Linear, Enum.EasingDirection.In);

                for _, v in emitters do
                    if v.Parent then
                        v.Transparency = _numSeqLerpTowardOpaque(u56[v], v58);
                    end;
                end;

                for _, v in u55 do
                    if v.Parent then
                        v.Transparency = _numSeqLerpTowardOpaque(u56[v], v58);
                    end;
                end;
            end;

            if u51.Parent then
                u1.SetEmittersTrailsBeamsEnabled(u51, false);
            end;

            if u53 then
                u53();
            end;
        end);
    end;

    function u1.Start_All_Trail(p59) -- Line: 376
        -- upvalues: u1 (copy)
        for _, v in u1.GetVfxCache(p59).trails do
            if v.Parent then
                v.Enabled = true;
            end;
        end;
    end;

    function u1.Start_Emit(u60, p61) -- Line: 392
        -- upvalues: RunService (copy)
        if not u60 then
            return;
        end;

        local v62 = p61 or 100;
        u60.Enabled = false;
        local AutoEmit = u60:FindFirstChild("AutoEmit");

        if not AutoEmit then
            AutoEmit = Instance.new("BoolValue", u60);
            AutoEmit.Name = "AutoEmit";
            AutoEmit.Value = false;
        end;

        if AutoEmit.Value == true then
            return;
        end;

        AutoEmit.Value = true;
        local u63 = math.max(u60.Rate, 1) * (v62 or 100);
        local u64 = (v62 or 100) / u63;
        local u65 = 0;
        local u66 = 0;
        local u67 = nil;
        u67 = RunService.Heartbeat:Connect(function(p68) -- Line: 422
            -- upvalues: u66 (ref), u65 (ref), u63 (copy), u60 (copy), AutoEmit (ref), u67 (ref), u64 (copy)
            u66 = u66 + p68;

            if u63 <= u65 or not (u60 and AutoEmit.Value) then
                if u67 then
                    u67:Disconnect();
                    u67 = nil;
                end;

                return;
            end;

            if u66 >= u65 * u64 then
                local v69 = math.ceil((u66 - u65 * u64) / u64);
                u65 = u65 + v69;
                u60:Emit(v69);
            end;
        end);
    end;

    function u1.Stop_Emit(p70) -- Line: 448
        if not p70 then
            return;
        end;

        local AutoEmit = p70:FindFirstChild("AutoEmit");

        if AutoEmit then
            AutoEmit.Value = false;
        end;
    end;

    function u1.Start_All_Emit(p71, p72) -- Line: 465
        -- upvalues: u1 (copy)
        if not p71 then
            return;
        end;

        for _, v in u1.GetVfxCache(p71).emitters do
            if v.Parent then
                u1.Start_Emit(v, p72);
            end;
        end;
    end;

    function u1.Stop_All_Emit(p73) -- Line: 483
        -- upvalues: u1 (copy)
        if not p73 then
            return;
        end;

        for _, v in u1.GetVfxCache(p73).emitters do
            if v.Parent then
                u1.Stop_Emit(v);
            end;
        end;
    end;
end;