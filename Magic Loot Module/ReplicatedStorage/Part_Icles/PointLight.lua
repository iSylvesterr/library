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

        if p3._parentAlive and not p3._parentAlive[1] then
            return true;
        end;

        local v11 = math.max(v10 / LifeTime, 0);
        local v12 = math.min(v11, 1) * p3.TotalKeyFrames;
        local v13 = math.floor(v12);

        if v13 ~= p3.CurrentStep then
            p3.CurrentStep = v13;
            local v14 = p3.CurrentStep / p3.TotalKeyFrames;
            local v15 = nil;
            local v16 = nil;
            local v17;

            if p3.Graphs.PLRange then
                v17 = Graph.QueryPointsWithTime(v14, p3.Graphs.PLRange, p3.Seeds.PLRange);
                p3.VisualPart.Range = v17;
            else
                v17 = nil;
            end;

            if p3.Graphs.PLBrightness and not p3.SkipTransparency then
                v15 = Graph.QueryPointsWithTime(v14, p3.Graphs.PLBrightness, p3.Seeds.PLBrightness);
                p3.VisualPart.Brightness = v15;
            end;

            if p3.Graphs.PLColor and not p3.SkipColor then
                v16 = Graph.QueryColorPointWithTime(v14, p3.Graphs.PLColor);
                p3.VisualPart.Color = v16;
            end;

            local _extraLights = p3._extraLights;

            if _extraLights then
                for i = 1, #_extraLights do
                    local v18 = _extraLights[i];

                    if v17 then
                        v18.Range = v17;
                    end;

                    if v15 then
                        v18.Brightness = v15;
                    end;

                    if v16 then
                        v18.Color = v16;
                    end;
                end;
            end;
        end;

        return v7 >= 1 and (LifeTime <= v10 or v10 <= 0);
    end;

    function u1.EmitPointLight(p19, p20, p21, p22) -- Line: 74
        -- upvalues: Pool (ref), Range (ref), Graph (ref), u1 (copy)
        if not (p20 and p20.Parent) then
            return;
        end;

        local v23 = p19:GetData(p20);

        if not (v23 and v23.RenderTemplate) then
            return;
        end;

        local v24 = Pool.acquireOrClone(v23.RenderTemplate, "PointLight", v23.Pool);
        v24.Archivable = false;
        v24.Enabled = true;

        if v23.Shadows ~= nil then
            v24.Shadows = v23.Shadows;
        end;

        local v25 = v23.EmitParent or (p21 or p20.Parent);
        local v26 = nil;
        local v27;

        if v25 and v25:IsA("Model") then
            v27 = nil;

            for _, child in ipairs(v25:GetChildren()) do
                if child:IsA("BasePart") then
                    v27 = v27 or {};
                    v27[#v27 + 1] = child;
                end;
            end;

            if v27 then
                if v25:GetAttribute("_lightningBolt") then
                    v25 = v27[1];
                else
                    v25 = v27[math.ceil(#v27 / 2)];
                    v27 = v26;
                end;
            else
                v27 = v26;
            end;
        else
            v27 = v26;
        end;

        local v28 = Range.RandomValueFromRange(v23.Lifetime);
        local v29 = v28 <= 0 and 0.001 or v28;
        local v30 = v23.PLRange and (Graph.GenerateSeed(v23.PLRange) or {}) or {};
        local v31 = v23.PLBrightness and (Graph.GenerateSeed(v23.PLBrightness) or {}) or {};
        local v32 = Graph.GenerateSeed(v23.PLTimescale);

        if v23.PLRange then
            v24.Range = Graph.QueryPointsWithTime(0, v23.PLRange, v30);
        end;

        if v23.PLBrightness then
            v24.Brightness = Graph.QueryPointsWithTime(0, v23.PLBrightness, v31);
        end;

        if v23.PLColor then
            v24.Color = Graph.QueryColorPointWithTime(0, v23.PLColor);
        end;

        v24.Parent = v25;
        local v33;

        if v27 and #v27 > 1 then
            v24.Archivable = true;
            v33 = table.create(#v27 - 1);

            for i = 2, #v27 do
                local v34 = v24:Clone();
                v34.Archivable = false;
                v34.Parent = v27[i];
                v33[i - 1] = v34;
            end;

            v24.Archivable = false;
        else
            v33 = nil;
        end;

        local v35 = {
            Type = "PointLight",
            CurrentStep = 0,
            VisualPart = v24,
            Events = v23.Events,
            StartTime = os.clock(),
            TotalKeyFrames = math.max(1, v23.TotalKeyFrames),
            LifeTime = v29,
            PartLife = v23.PartLife or 0,
            Graphs = {
                PLRange = v23.PLRange,
                PLBrightness = v23.PLBrightness,
                PLColor = v23.PLColor,
                Timescale = v23.PLTimescale
            },
            Seeds = {
                PLRange = v30,
                PLBrightness = v31,
                Timescale = v32
            },
            _effectiveElapsed = Graph.InitialEffectiveElapsed(v23.PLTimescale, v32, v29),
            _sourceItem = p20,
            _extraLights = v33
        };

        if p22 and (p22._parentAlive and not v23.EmitParent) then
            v35._parentAlive = p22._parentAlive;
        end;

        u1._seedTsOverride(v35, p20);

        if v23.Pool ~= false then
            v35._sourceRT = v23.RenderTemplate;
            v35._poolKind = "PointLight";
        end;

        p19:_registerEmit(v35, p22);
    end;
end;