-- Decompiled with Potassium's decompiler.

local Lighting = game:GetService("Lighting");
local Graph = require(script.Parent.Graph);
local Range = require(script.Parent.Range);

return function(u1) -- Line: 8
    -- upvalues: Lighting (copy), Graph (copy), Range (copy)
    local function resolveScreenParent(p2, p3) -- Line: 11
        -- upvalues: Lighting (ref)
        if p2.EmitParent then
            return p2.EmitParent;
        end;

        return Lighting;
    end;

    local function buildGraphs(p4, p5) -- Line: 17
        return p4 == "Blur" and {
            BlurSize = p5.BlurSize,
            Timescale = p5.Timescale
        } or (p4 == "Bloom" and {
            BloomIntensity = p5.BloomIntensity,
            BloomSize = p5.BloomSize,
            BloomThreshold = p5.BloomThreshold,
            Timescale = p5.Timescale
        } or (p4 == "CC" and {
            CCBrightness = p5.CCBrightness,
            CCContrast = p5.CCContrast,
            CCSaturation = p5.CCSaturation,
            CCTintColor = p5.CCTintColor,
            Timescale = p5.Timescale
        } or (p4 == "Atmosphere" and {
            AtmDensity = p5.AtmDensity,
            AtmOffset = p5.AtmOffset,
            AtmGlare = p5.AtmGlare,
            AtmHaze = p5.AtmHaze,
            AtmColor = p5.AtmColor,
            AtmDecay = p5.AtmDecay,
            Timescale = p5.AtmTimescale
        } or {})));
    end;

    local function buildSeeds(p6) -- Line: 31
        -- upvalues: Graph (ref)
        local v7 = {};

        for i, v in pairs(p6) do
            if typeof(v) == "NumberSequence" then
                v7[i] = Graph.GenerateSeed(v);
            end;
        end;

        return v7;
    end;

    local function writeSample(p8, p9, p10, p11, p12, p13, p14) -- Line: 42
        -- upvalues: Graph (ref)
        if p8 == "Blur" and p10.BlurSize then
            p9.Size = Graph.QueryPointsWithTime(p12, p10.BlurSize, p11.BlurSize);

            return;
        end;

        if p8 == "Bloom" then
            if p10.BloomIntensity then
                p9.Intensity = Graph.QueryPointsWithTime(p12, p10.BloomIntensity, p11.BloomIntensity);
            end;

            if p10.BloomSize then
                p9.Size = Graph.QueryPointsWithTime(p12, p10.BloomSize, p11.BloomSize);
            end;

            if p10.BloomThreshold then
                p9.Threshold = Graph.QueryPointsWithTime(p12, p10.BloomThreshold, p11.BloomThreshold);
            end;
        elseif p8 == "CC" then
            if p10.CCBrightness and not p14 then
                p9.Brightness = Graph.QueryPointsWithTime(p12, p10.CCBrightness, p11.CCBrightness);
            end;

            if p10.CCContrast then
                p9.Contrast = Graph.QueryPointsWithTime(p12, p10.CCContrast, p11.CCContrast);
            end;

            if p10.CCSaturation then
                p9.Saturation = Graph.QueryPointsWithTime(p12, p10.CCSaturation, p11.CCSaturation);
            end;

            if p10.CCTintColor and not p13 then
                p9.TintColor = Graph.QueryColorPointWithTime(p12, p10.CCTintColor);
            end;
        elseif p8 == "Atmosphere" then
            if p10.AtmDensity then
                p9.Density = Graph.QueryPointsWithTime(p12, p10.AtmDensity, p11.AtmDensity);
            end;

            if p10.AtmOffset then
                p9.Offset = Graph.QueryPointsWithTime(p12, p10.AtmOffset, p11.AtmOffset);
            end;

            if p10.AtmGlare then
                p9.Glare = Graph.QueryPointsWithTime(p12, p10.AtmGlare, p11.AtmGlare);
            end;

            if p10.AtmHaze then
                p9.Haze = Graph.QueryPointsWithTime(p12, p10.AtmHaze, p11.AtmHaze);
            end;

            if p10.AtmColor and not p13 then
                p9.Color = Graph.QueryColorPointWithTime(p12, p10.AtmColor);
            end;

            if p10.AtmDecay and not p13 then
                p9.Decay = Graph.QueryColorPointWithTime(p12, p10.AtmDecay);
            end;
        end;
    end;

    local function kindHasEnabled(p15) -- Line: 65
        return p15 ~= "Atmosphere";
    end;

    local function emitClone(p16, p17, p18, p19, p20) -- Line: 70
        -- upvalues: Range (ref), buildGraphs (copy), buildSeeds (copy), writeSample (copy), Lighting (ref), Graph (ref), u1 (copy)
        local v21 = p16:GetData(p18);

        if not (v21 and v21.RenderTemplate) then
            return;
        end;

        local v22 = v21.RenderTemplate:Clone();
        v22.Archivable = false;

        if p17 ~= "Atmosphere" then
            v22.Enabled = true;
        end;

        v22:SetAttribute("_PartIcleEmit", true);
        local v23 = Range.RandomValueFromRange(v21.Lifetime);
        local v24 = v23 <= 0 and 0.001 or v23;
        local v25 = buildGraphs(p17, v21);
        local v26 = buildSeeds(v25);
        writeSample(p17, v22, v25, v26, 0);
        local v27;

        if v21.EmitParent then
            v27 = v21.EmitParent;
        else
            v27 = Lighting;
        end;

        v22.Parent = v27;
        local v28 = {
            Type = "Screen",
            CurrentStep = 0,
            Kind = p17,
            VisualPart = v22,
            Events = v21.Events,
            StartTime = os.clock(),
            TotalKeyFrames = math.max(1, v21.TotalKeyFrames or 100),
            LifeTime = v24,
            PartLife = v21.PartLife or 0,
            Graphs = v25,
            Seeds = v26,
            _effectiveElapsed = Graph.InitialEffectiveElapsed(v25.Timescale, v26.Timescale, v24),
            _sourceItem = p18
        };
        u1._seedTsOverride(v28, p18);
        p16:_registerEmit(v28, p20);
    end;

    local function emitAnimateInternal(p29, p30, p31, p32, p33) -- Line: 104
        -- upvalues: Range (ref), buildGraphs (copy), buildSeeds (copy), writeSample (copy), Lighting (ref), Graph (ref), u1 (copy)
        if p29.ActiveAnimates[p31] then
            return;
        end;

        local v34 = p29:GetData(p31);

        if not (v34 and v34.RenderTemplate) then
            return;
        end;

        local v35 = v34.RenderTemplate:Clone();
        v35.Archivable = false;

        if p30 ~= "Atmosphere" then
            v35.Enabled = true;
        end;

        v35:SetAttribute("_PartIcleEmit", true);
        local v36 = Range.RandomValueFromRange(v34.Lifetime);
        local v37 = v36 <= 0 and 0.001 or v36;
        local v38 = buildGraphs(p30, v34);
        local v39 = buildSeeds(v38);
        writeSample(p30, v35, v38, v39, 0);
        local v40;

        if v34.EmitParent then
            v40 = v34.EmitParent;
        else
            v40 = Lighting;
        end;

        v35.Parent = v40;
        local v41 = {
            Type = "Screen",
            CurrentStep = 0,
            IsAnimate = true,
            Kind = p30,
            VisualPart = v35,
            Events = v34.Events,
            StartTime = os.clock(),
            TotalKeyFrames = math.max(1, v34.TotalKeyFrames or 100),
            LifeTime = v37,
            PartLife = v34.PartLife or 0,
            Graphs = v38,
            Seeds = v39,
            _effectiveElapsed = Graph.InitialEffectiveElapsed(v38.Timescale, v39.Timescale, v37),
            AnimateItem = p31,
            _sourceItem = p31
        };
        u1._seedTsOverride(v41, p31);
        p29.ActiveAnimates[p31] = v41;
        p29:_registerEmit(v41, p33);
    end;

    function u1.EmitBlur(p42, p43, p44, p45) -- Line: 143
        -- upvalues: emitClone (copy)
        emitClone(p42, "Blur", p43, p44, p45);
    end;

    function u1.EmitBloom(p46, p47, p48, p49) -- Line: 144
        -- upvalues: emitClone (copy)
        emitClone(p46, "Bloom", p47, p48, p49);
    end;

    function u1.EmitColorCorrection(p50, p51, p52, p53) -- Line: 145
        -- upvalues: emitClone (copy)
        emitClone(p50, "CC", p51, p52, p53);
    end;

    function u1.EmitAtmosphere(p54, p55, p56, p57) -- Line: 146
        -- upvalues: emitClone (copy)
        emitClone(p54, "Atmosphere", p55, p56, p57);
    end;

    function u1.EmitBlurAnimate(p58, p59, p60, p61) -- Line: 148
        -- upvalues: emitAnimateInternal (copy)
        emitAnimateInternal(p58, "Blur", p59, p60, p61);
    end;

    function u1.EmitBloomAnimate(p62, p63, p64, p65) -- Line: 149
        -- upvalues: emitAnimateInternal (copy)
        emitAnimateInternal(p62, "Bloom", p63, p64, p65);
    end;

    function u1.EmitColorCorrectionAnimate(p66, p67, p68, p69) -- Line: 150
        -- upvalues: emitAnimateInternal (copy)
        emitAnimateInternal(p66, "CC", p67, p68, p69);
    end;

    function u1.EmitAtmosphereAnimate(p70, p71, p72, p73) -- Line: 151
        -- upvalues: emitAnimateInternal (copy)
        emitAnimateInternal(p70, "Atmosphere", p71, p72, p73);
    end;

    function u1.UpdateScreen(p74, p75, p76, p77) -- Line: 154
        -- upvalues: Graph (ref), writeSample (copy)
        if not (p75.VisualPart and p75.VisualPart.Parent) then
            return true;
        end;

        if p75.TotalKeyFrames <= 0 then
            return true;
        end;

        local v78 = math.max((p77 - p75.StartTime) / p75.LifeTime, 0);
        local v79 = math.min(v78, 1);
        local v80;

        if p75._tsOverride == nil or p77 >= (p75._tsOverrideUntil or 0) then
            v80 = p75.Graphs.Timescale and (Graph.QueryPointsWithTime(v79, p75.Graphs.Timescale, p75.Seeds.Timescale) or 1) or 1;
        else
            v80 = p75._tsOverride;
        end;

        local LifeTime = p75.LifeTime;
        local v81 = (p75._effectiveElapsed or 0) + (p75._timeFrozen and 0 or p76 * v80);
        local v82 = v81 < 0 and 0 or v81;

        if LifeTime < v82 then
            v82 = LifeTime;
        end;

        p75._effectiveElapsed = v82;
        local v83 = v82 / LifeTime;
        local v84 = v83 > 1 and 1 or v83;
        local v85 = math.floor((v84 < 0 and 0 or v84) * p75.TotalKeyFrames);

        if v85 ~= p75.CurrentStep then
            p75.CurrentStep = v85;
            writeSample(p75.Kind, p75.VisualPart, p75.Graphs, p75.Seeds, p75.CurrentStep / p75.TotalKeyFrames, p75.SkipColor, p75.SkipTransparency);
        end;

        return v79 >= 1 and (LifeTime <= v82 or v82 <= 0);
    end;
end;