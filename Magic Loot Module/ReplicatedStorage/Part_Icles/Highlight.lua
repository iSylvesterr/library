-- Decompiled with Potassium's decompiler.

local Graph = require(script.Parent.Graph);
local Range = require(script.Parent.Range);
local Pool = require(script.Parent.Pool);

return function(u1) -- Line: 13
    -- upvalues: Graph (copy), Pool (copy), Range (copy)
    function u1.UpdateHighlight(p2, p3, p4, p5) -- Line: 18
        -- upvalues: Graph (ref)
        local v6 = math.max((p5 - p3.StartTime) / p3.LifeTime, 0);
        local v7 = math.min(v6, 1);
        local v8;

        if p3._tsOverride == nil or p5 >= (p3._tsOverrideUntil or 0) then
            v8 = p3.Graphs.Timescale and (Graph.QueryPointsWithTime(v7, p3.Graphs.Timescale, p3.Seeds.Timescale) or 1) or 1;
        else
            v8 = p3._tsOverride;
        end;

        local LifeTime = p3.LifeTime;
        local v9 = (p3._effectiveElapsed or 0) + (p3._timeFrozen and 0 or p4 * v8);
        local v10 = v9 < 0 and 0 or v9;

        if LifeTime < v10 then
            v10 = LifeTime;
        end;

        p3._effectiveElapsed = v10;

        if not (p3.VisualPart and p3.VisualPart.Parent) then
            return true;
        end;

        if p3.TotalKeyFrames <= 0 then
            return true;
        end;

        local v11 = math.max(v10 / LifeTime, 0);
        local v12 = math.min(v11, 1) * p3.TotalKeyFrames;
        local v13 = math.floor(v12);

        if v13 ~= p3.CurrentStep then
            p3.CurrentStep = v13;
            local v14 = p3.CurrentStep / p3.TotalKeyFrames;

            if p3.Graphs.HLFillColor and not p3.SkipColor then
                p3.VisualPart.FillColor = Graph.QueryColorPointWithTime(v14, p3.Graphs.HLFillColor);
            end;

            if p3.Graphs.HLFillTransparency and not p3.SkipTransparency then
                p3.VisualPart.FillTransparency = Graph.QueryPointsWithTime(v14, p3.Graphs.HLFillTransparency, p3.Seeds.HLFillTransparency);
            end;

            if p3.Graphs.HLOutlineColor and not p3.SkipColor then
                p3.VisualPart.OutlineColor = Graph.QueryColorPointWithTime(v14, p3.Graphs.HLOutlineColor);
            end;

            if p3.Graphs.HLOutlineTransparency and not p3.SkipTransparency then
                p3.VisualPart.OutlineTransparency = Graph.QueryPointsWithTime(v14, p3.Graphs.HLOutlineTransparency, p3.Seeds.HLOutlineTransparency);
            end;
        end;

        return v7 >= 1 and (LifeTime <= v10 or v10 <= 0);
    end;

    local function _resolveAdornee(p15, p16, p17) -- Line: 73
        if p15.Adornee then
            return p15.Adornee;
        end;

        if p17 then
            if p17:IsA("BasePart") or p17:IsA("Model") then
                return p17;
            end;

            if p17:IsA("Attachment") then
                local Parent = p17.Parent;

                if Parent and (Parent:IsA("BasePart") or Parent:IsA("Model")) then
                    return Parent;
                end;
            end;
        end;

        local Adornee = p16.Adornee;

        if Adornee then
            return Adornee;
        end;

        local Parent = p16.Parent;

        if Parent and (Parent:IsA("BasePart") or Parent:IsA("Model")) then
            return Parent;
        end;

        return nil;
    end;

    function u1.EmitHighlight(p18, p19, p20, p21) -- Line: 90
        -- upvalues: Pool (ref), _resolveAdornee (copy), Range (ref), Graph (ref), u1 (copy)
        if not (p19 and p19.Parent) then
            return;
        end;

        local v22 = p18:GetData(p19);

        if not (v22 and v22.RenderTemplate) then
            return;
        end;

        local v23 = Pool.acquireOrClone(v22.RenderTemplate, "Highlight", v22.Pool);
        v23.Archivable = false;
        v23.Enabled = true;

        if v22.HLDepthMode then
            v23.DepthMode = v22.HLDepthMode;
        end;

        v23.Adornee = _resolveAdornee(v22, p19, p20);
        local v24 = v22.EmitParent or (p20 or p19.Parent);
        local v25 = Range.RandomValueFromRange(v22.Lifetime);
        local v26 = v25 <= 0 and 0.001 or v25;
        local v27 = v22.HLFillTransparency and (Graph.GenerateSeed(v22.HLFillTransparency) or {}) or {};
        local v28 = v22.HLOutlineTransparency and (Graph.GenerateSeed(v22.HLOutlineTransparency) or {}) or {};
        local v29 = Graph.GenerateSeed(v22.HLTimescale);

        if v22.HLFillColor then
            v23.FillColor = Graph.QueryColorPointWithTime(0, v22.HLFillColor);
        end;

        if v22.HLFillTransparency then
            v23.FillTransparency = Graph.QueryPointsWithTime(0, v22.HLFillTransparency, v27);
        end;

        if v22.HLOutlineColor then
            v23.OutlineColor = Graph.QueryColorPointWithTime(0, v22.HLOutlineColor);
        end;

        if v22.HLOutlineTransparency then
            v23.OutlineTransparency = Graph.QueryPointsWithTime(0, v22.HLOutlineTransparency, v28);
        end;

        v23.Parent = v24;
        local v30 = {
            Type = "Highlight",
            CurrentStep = 0,
            VisualPart = v23,
            Events = v22.Events,
            StartTime = os.clock(),
            TotalKeyFrames = math.max(1, v22.TotalKeyFrames),
            LifeTime = v26,
            PartLife = v22.PartLife or 0,
            Graphs = {
                HLFillColor = v22.HLFillColor,
                HLFillTransparency = v22.HLFillTransparency,
                HLOutlineColor = v22.HLOutlineColor,
                HLOutlineTransparency = v22.HLOutlineTransparency,
                Timescale = v22.HLTimescale
            },
            Seeds = {
                HLFillTransparency = v27,
                HLOutlineTransparency = v28,
                Timescale = v29
            },
            _effectiveElapsed = Graph.InitialEffectiveElapsed(v22.HLTimescale, v29, v26),
            _sourceItem = p19
        };
        u1._seedTsOverride(v30, p19);

        if v22.Pool ~= false then
            v30._sourceRT = v22.RenderTemplate;
            v30._poolKind = "Highlight";
        end;

        p18:_registerEmit(v30, p21);
    end;

    function u1.EmitHighlightAnimate(p31, p32, p33, p34) -- Line: 159
        -- upvalues: Range (ref), Graph (ref), u1 (copy)
        if not (p32 and p32.Parent) then
            return;
        end;

        if p31.ActiveAnimates[p32] then
            return;
        end;

        local v35 = p31:GetData(p32);

        if not (v35 and v35.RenderTemplate) then
            return;
        end;

        local RenderTemplate = v35.RenderTemplate;
        local v36 = {
            FillColor = RenderTemplate.FillColor,
            FillTransparency = RenderTemplate.FillTransparency,
            OutlineColor = RenderTemplate.OutlineColor,
            OutlineTransparency = RenderTemplate.OutlineTransparency,
            DepthMode = RenderTemplate.DepthMode,
            Adornee = RenderTemplate.Adornee,
            Enabled = RenderTemplate.Enabled
        };
        RenderTemplate.Enabled = true;

        if v35.HLDepthMode then
            RenderTemplate.DepthMode = v35.HLDepthMode;
        end;

        local v37;

        if v35.Adornee then
            v37 = v35.Adornee;
        else
            v37 = p32.Adornee;

            if not v37 then
                v37 = p32.Parent;

                if not (v37 and (v37:IsA("BasePart") or v37:IsA("Model"))) then
                    v37 = nil;
                end;
            end;
        end;

        RenderTemplate.Adornee = v37;
        local v38 = Range.RandomValueFromRange(v35.Lifetime);
        local v39 = v38 <= 0 and 0.001 or v38;
        local v40 = v35.HLFillTransparency and (Graph.GenerateSeed(v35.HLFillTransparency) or {}) or {};
        local v41 = v35.HLOutlineTransparency and (Graph.GenerateSeed(v35.HLOutlineTransparency) or {}) or {};
        local v42 = Graph.GenerateSeed(v35.HLTimescale);
        local v43 = {
            Type = "Highlight",
            CurrentStep = 0,
            IsAnimate = true,
            VisualPart = RenderTemplate,
            Events = v35.Events,
            StartTime = os.clock(),
            TotalKeyFrames = math.max(1, v35.TotalKeyFrames),
            LifeTime = v39,
            PartLife = v35.PartLife or 0,
            AnimateItem = p32,
            HighlightSnapshot = v36,
            Graphs = {
                HLFillColor = v35.HLFillColor,
                HLFillTransparency = v35.HLFillTransparency,
                HLOutlineColor = v35.HLOutlineColor,
                HLOutlineTransparency = v35.HLOutlineTransparency,
                Timescale = v35.HLTimescale
            },
            Seeds = {
                HLFillTransparency = v40,
                HLOutlineTransparency = v41,
                Timescale = v42
            },
            _effectiveElapsed = Graph.InitialEffectiveElapsed(v35.HLTimescale, v42, v39),
            _sourceItem = p32
        };
        u1._seedTsOverride(v43, p32);
        p31.ActiveAnimates[p32] = v43;
        p31:_registerEmit(v43, p34);
    end;
end;