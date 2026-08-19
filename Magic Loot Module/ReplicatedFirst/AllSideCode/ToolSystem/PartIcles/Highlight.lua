-- Decompiled with Potassium's decompiler.

local Graph = require(script.Parent.Graph);
local Range = require(script.Parent.Range);
local Pool = require(script.Parent.Pool);

return function(u1) -- Line: 12
    -- upvalues: Graph (copy), Pool (copy), Range (copy)
    function u1.UpdateHighlight(p2, p3, p4, p5) -- Line: 17
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

    local function _resolveAdornee(p15, p16) -- Line: 70
        if p15.Adornee then
            return p15.Adornee;
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

    function u1.EmitHighlight(p17, p18, p19, p20) -- Line: 80
        -- upvalues: Pool (ref), Range (ref), Graph (ref), u1 (copy)
        if not (p18 and p18.Parent) then
            return;
        end;

        local v21 = p17:GetData(p18);

        if not (v21 and v21.RenderTemplate) then
            return;
        end;

        local v22 = Pool.acquireOrClone(v21.RenderTemplate, "Highlight", v21.Pool);
        v22.Archivable = false;
        v22.Enabled = true;

        if v21.HLDepthMode then
            v22.DepthMode = v21.HLDepthMode;
        end;

        local v23;

        if v21.Adornee then
            v23 = v21.Adornee;
        else
            v23 = p18.Adornee;

            if not v23 then
                v23 = p18.Parent;

                if not (v23 and (v23:IsA("BasePart") or v23:IsA("Model"))) then
                    v23 = nil;
                end;
            end;
        end;

        v22.Adornee = v23;
        local v24 = v21.EmitParent or p18.Parent;
        local v25 = Range.RandomValueFromRange(v21.Lifetime);
        local v26 = v25 <= 0 and 0.001 or v25;
        local v27 = v21.HLFillTransparency and (Graph.GenerateSeed(v21.HLFillTransparency) or {}) or {};
        local v28 = v21.HLOutlineTransparency and (Graph.GenerateSeed(v21.HLOutlineTransparency) or {}) or {};
        local v29 = Graph.GenerateSeed(v21.HLTimescale);

        if v21.HLFillColor then
            v22.FillColor = Graph.QueryColorPointWithTime(0, v21.HLFillColor);
        end;

        if v21.HLFillTransparency then
            v22.FillTransparency = Graph.QueryPointsWithTime(0, v21.HLFillTransparency, v27);
        end;

        if v21.HLOutlineColor then
            v22.OutlineColor = Graph.QueryColorPointWithTime(0, v21.HLOutlineColor);
        end;

        if v21.HLOutlineTransparency then
            v22.OutlineTransparency = Graph.QueryPointsWithTime(0, v21.HLOutlineTransparency, v28);
        end;

        v22.Parent = v24;
        local v30 = {
            Type = "Highlight",
            CurrentStep = 0,
            VisualPart = v22,
            Events = v21.Events,
            StartTime = os.clock(),
            TotalKeyFrames = math.max(1, v21.TotalKeyFrames),
            LifeTime = v26,
            PartLife = v21.PartLife or 0,
            Graphs = {
                HLFillColor = v21.HLFillColor,
                HLFillTransparency = v21.HLFillTransparency,
                HLOutlineColor = v21.HLOutlineColor,
                HLOutlineTransparency = v21.HLOutlineTransparency,
                Timescale = v21.HLTimescale
            },
            Seeds = {
                HLFillTransparency = v27,
                HLOutlineTransparency = v28,
                Timescale = v29
            },
            _effectiveElapsed = Graph.InitialEffectiveElapsed(v21.HLTimescale, v29, v26),
            _sourceItem = p18
        };
        u1._seedTsOverride(v30, p18);

        if v21.Pool ~= false then
            v30._sourceRT = v21.RenderTemplate;
            v30._poolKind = "Highlight";
        end;

        p17:_registerEmit(v30, p20);
    end;

    function u1.EmitHighlightAnimate(p31, p32, p33, p34) -- Line: 149
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