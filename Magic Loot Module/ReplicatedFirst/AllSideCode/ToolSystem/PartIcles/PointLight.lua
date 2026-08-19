-- Decompiled with Potassium's decompiler.

local Graph = require(script.Parent.Graph);
local Range = require(script.Parent.Range);
local Pool = require(script.Parent.Pool);

return function(u1) -- Line: 10
    -- upvalues: Graph (copy), Pool (copy), Range (copy)
    function u1.UpdatePointLight(p2, p3, p4, p5) -- Line: 12
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

            if p3.Graphs.PLRange then
                p3.VisualPart.Range = Graph.QueryPointsWithTime(v14, p3.Graphs.PLRange, p3.Seeds.PLRange);
            end;

            if p3.Graphs.PLBrightness and not p3.SkipTransparency then
                p3.VisualPart.Brightness = Graph.QueryPointsWithTime(v14, p3.Graphs.PLBrightness, p3.Seeds.PLBrightness);
            end;

            if p3.Graphs.PLColor and not p3.SkipColor then
                p3.VisualPart.Color = Graph.QueryColorPointWithTime(v14, p3.Graphs.PLColor);
            end;
        end;

        return v7 >= 1 and (LifeTime <= v10 or v10 <= 0);
    end;

    function u1.EmitPointLight(p15, p16, p17, p18) -- Line: 59
        -- upvalues: Pool (ref), Range (ref), Graph (ref), u1 (copy)
        if not (p16 and p16.Parent) then
            return;
        end;

        local v19 = p15:GetData(p16);

        if not (v19 and v19.RenderTemplate) then
            return;
        end;

        local v20 = Pool.acquireOrClone(v19.RenderTemplate, "PointLight", v19.Pool);
        v20.Archivable = false;
        v20.Enabled = true;

        if v19.Shadows ~= nil then
            v20.Shadows = v19.Shadows;
        end;

        local v21 = v19.EmitParent or (p17 or p16.Parent);
        local v22 = Range.RandomValueFromRange(v19.Lifetime);
        local v23 = v22 <= 0 and 0.001 or v22;
        local v24 = v19.PLRange and (Graph.GenerateSeed(v19.PLRange) or {}) or {};
        local v25 = v19.PLBrightness and (Graph.GenerateSeed(v19.PLBrightness) or {}) or {};
        local v26 = Graph.GenerateSeed(v19.PLTimescale);

        if v19.PLRange then
            v20.Range = Graph.QueryPointsWithTime(0, v19.PLRange, v24);
        end;

        if v19.PLBrightness then
            v20.Brightness = Graph.QueryPointsWithTime(0, v19.PLBrightness, v25);
        end;

        if v19.PLColor then
            v20.Color = Graph.QueryColorPointWithTime(0, v19.PLColor);
        end;

        v20.Parent = v21;
        local v27 = {
            Type = "PointLight",
            CurrentStep = 0,
            VisualPart = v20,
            Events = v19.Events,
            StartTime = os.clock(),
            TotalKeyFrames = math.max(1, v19.TotalKeyFrames),
            LifeTime = v23,
            PartLife = v19.PartLife or 0,
            Graphs = {
                PLRange = v19.PLRange,
                PLBrightness = v19.PLBrightness,
                PLColor = v19.PLColor,
                Timescale = v19.PLTimescale
            },
            Seeds = {
                PLRange = v24,
                PLBrightness = v25,
                Timescale = v26
            },
            _effectiveElapsed = Graph.InitialEffectiveElapsed(v19.PLTimescale, v26, v23),
            _sourceItem = p16
        };
        u1._seedTsOverride(v27, p16);

        if v19.Pool ~= false then
            v27._sourceRT = v19.RenderTemplate;
            v27._poolKind = "PointLight";
        end;

        p15:_registerEmit(v27, p18);
    end;
end;