-- Decompiled with Potassium's decompiler.

local Graph = require(script.Parent.Graph);
local PartConstants = require(script.Parent.PartConstants);

return function(p1) -- Line: 12
    -- upvalues: Graph (copy), PartConstants (copy)
    function p1.UpdateBeam(p2, p3, p4, p5) -- Line: 17
        -- upvalues: Graph (ref), PartConstants (ref)
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

        local v11 = math.max(v10 / LifeTime, 0);
        local v12 = math.min(v11, 1);
        local TransStates = p3.TransStates;
        local ColorStates = p3.ColorStates;

        if not p3.SkipTransparency then
            if TransStates and #TransStates >= 2 then
                local v13 = p3._lastTransIdx or 1;
                local v14 = #TransStates - 1;

                for i = v12 < TransStates[v13].Time and 1 or v13, #TransStates - 1 do
                    if TransStates[i].Time <= v12 and v12 <= TransStates[i + 1].Time then
                        v14 = i;
                        break;
                    end;
                end;

                p3._lastTransIdx = v14;
                local v15 = TransStates[v14];
                local v16 = TransStates[v14 + 1] or TransStates[#TransStates];
                local v17 = v16.Time - v15.Time;
                local v18 = v17 > 0 and ((v12 - v15.Time) / v17 or 0) or 0;
                local v19 = p3.TransMergedTimes[v14];

                if v19 then
                    p3.VisualPart.Transparency = Graph.LerpGraphFast(v15.Graph, v16.Graph, v18, v19);
                else
                    p3.VisualPart.Transparency = Graph.LerpGraph(v15.Graph, v16.Graph, v18);
                end;
            elseif TransStates and #TransStates == 1 then
                p3.VisualPart.Transparency = TransStates[1].Graph;
            end;
        end;

        if not p3.SkipColor then
            if ColorStates and #ColorStates >= 2 then
                local v20 = p3._lastColorIdx or 1;
                local v21 = #ColorStates - 1;

                for i = v12 < ColorStates[v20].Time and 1 or v20, #ColorStates - 1 do
                    if ColorStates[i].Time <= v12 and v12 <= ColorStates[i + 1].Time then
                        v21 = i;
                        break;
                    end;
                end;

                p3._lastColorIdx = v21;
                local v22 = ColorStates[v21];
                local v23 = ColorStates[v21 + 1] or ColorStates[#ColorStates];
                local v24 = v23.Time - v22.Time;
                local v25 = v24 > 0 and ((v12 - v22.Time) / v24 or 0) or 0;
                local v26 = p3.ColorMergedTimes[v21];

                if v26 then
                    p3.VisualPart.Color = Graph.LerpColorGraphFast(v22.Graph, v23.Graph, v25, v26);
                else
                    p3.VisualPart.Color = Graph.LerpColorGraph(v22.Graph, v23.Graph, v25);
                end;
            elseif ColorStates and #ColorStates == 1 then
                p3.VisualPart.Color = ColorStates[1].Graph;
            end;
        end;

        local TextureSpeed = p3.AnimatedProps.TextureSpeed;

        if TextureSpeed then
            local v27 = Graph.IntegrateUpTo(v12, TextureSpeed.Sequence, TextureSpeed.Seed);
            p3.VisualPart:SetTextureOffset(-v27 * p3.LifeTime % 1);
        end;

        for i, v in pairs(p3.AnimatedProps) do
            if i ~= "TextureSpeed" then
                local v28 = Graph.QueryPointsWithTime(v12, v.Sequence, v.Seed);

                if i == "Segments" then
                    local v29 = math.round(v28);
                    v28 = math.max(20, v29);
                end;

                p3.VisualPart[i] = v28;
            end;
        end;

        if p3.ParentScale then
            local ParentScale = p3.ParentScale;
            local v30 = PartConstants.getParentScaleFactor(ParentScale, p5, Graph);
            local VisualPart = p3.VisualPart;
            local AnimatedProps = p3.AnimatedProps;
            VisualPart.Width0 = (AnimatedProps.Width0 and VisualPart.Width0 or p3._baseWidth0) * v30;
            VisualPart.Width1 = (AnimatedProps.Width1 and VisualPart.Width1 or p3._baseWidth1) * v30;
            VisualPart.CurveSize0 = (AnimatedProps.CurveSize0 and VisualPart.CurveSize0 or p3._baseCurveSize0) * v30;
            VisualPart.CurveSize1 = (AnimatedProps.CurveSize1 and VisualPart.CurveSize1 or p3._baseCurveSize1) * v30;

            if ParentScale.ScaleTextureLength ~= false then
                VisualPart.TextureLength = (AnimatedProps.TextureLength and VisualPart.TextureLength or p3._baseTextureLength) * v30;
            end;

            local v31 = math.round((AnimatedProps.Segments and VisualPart.Segments or p3._baseSegments) * v30);
            VisualPart.Segments = math.max(20, v31);
        end;

        return v7 >= 1 and (LifeTime <= v10 or v10 <= 0);
    end;
end;