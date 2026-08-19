-- Decompiled with Potassium's decompiler.

local Graph = require(script.Parent.Graph);
local Range = require(script.Parent.Range);
local TrailGraphBlender = require(script.Parent.TrailGraphBlender);
local Pool = require(script.Parent.Pool);
local Flipbook = require(script.Parent.Flipbook);

return function(u1) -- Line: 21
    -- upvalues: Graph (copy), TrailGraphBlender (copy), Pool (copy), Range (copy), Flipbook (copy)
    local u2 = { "Brightness", "LightEmission", "LightInfluence", "TextureLength", "MinLength", "MaxLength" };

    local function _writeBlenderState(p3, p4, p5, p6, p7, p8, p9) -- Line: 26
        -- upvalues: Graph (ref)
        if not p5 or #p5 == 0 then
            return;
        end;

        if #p5 == 1 then
            p3[p4] = p5[1].Graph;

            return;
        end;

        local v10 = p8[p7] or 1;
        local v11 = #p5 - 1;

        for i = p9 < p5[v10].Time and 1 or v10, #p5 - 1 do
            if p5[i].Time <= p9 and p9 <= p5[i + 1].Time then
                v11 = i;
                break;
            end;
        end;

        p8[p7] = v11;
        local v12 = p5[v11];
        local v13 = p5[v11 + 1] or p5[#p5];
        local v14 = v13.Time - v12.Time;
        local v15 = v14 > 0 and ((p9 - v12.Time) / v14 or 0) or 0;

        if p6 then
            p6 = p6[v11];
        end;

        if p6 then
            if p4 == "Color" then
                p3[p4] = Graph.LerpColorGraphFast(v12.Graph, v13.Graph, v15, p6);

                return;
            end;

            p3[p4] = Graph.LerpGraphFast(v12.Graph, v13.Graph, v15, p6);
        end;
    end;

    function u1.UpdateTrail(p16, p17, p18, p19) -- Line: 57
        -- upvalues: Graph (ref), _writeBlenderState (copy), u2 (copy)
        local v20 = math.max((p19 - p17.StartTime) / p17.LifeTime, 0);
        local v21 = math.min(v20, 1);
        local v22;

        if p17._tsOverride == nil or p19 >= (p17._tsOverrideUntil or 0) then
            v22 = p17.Graphs.Timescale and (Graph.QueryPointsWithTime(v21, p17.Graphs.Timescale, p17.Seeds.Timescale) or 1) or 1;
        else
            v22 = p17._tsOverride;
        end;

        local LifeTime = p17.LifeTime;
        local v23 = (p17._effectiveElapsed or 0) + (p17._timeFrozen and 0 or p18 * v22);
        local v24 = v23 < 0 and 0 or v23;

        if LifeTime < v24 then
            v24 = LifeTime;
        end;

        p17._effectiveElapsed = v24;

        if not (p17.VisualPart and p17.VisualPart.Parent) then
            return true;
        end;

        local v25 = math.max(v24 / LifeTime, 0);
        local v26 = math.min(v25, 1);

        if not p17.SkipColor then
            _writeBlenderState(p17.VisualPart, "WidthScale", p17.WidthStates, p17.WidthMergedTimes, "_lastWidthIdx", p17, v26);
            _writeBlenderState(p17.VisualPart, "Color", p17.ColorStates, p17.ColorMergedTimes, "_lastColorIdx", p17, v26);
        end;

        if not p17.SkipTransparency then
            _writeBlenderState(p17.VisualPart, "Transparency", p17.TransStates, p17.TransMergedTimes, "_lastTransIdx", p17, v26);
        end;

        if p17.TotalKeyFrames > 0 then
            local v27 = math.floor(v26 * p17.TotalKeyFrames);

            if v27 ~= p17.CurrentStep then
                p17.CurrentStep = v27;
                local v28 = p17.CurrentStep / p17.TotalKeyFrames;

                for _, v in ipairs(u2) do
                    local v29 = p17.Graphs[v];

                    if v29 then
                        p17.VisualPart[v] = Graph.QueryPointsWithTime(v28, v29, p17.Seeds[v]);
                    end;
                end;
            end;
        end;

        return v21 >= 1 and (LifeTime <= v24 or v24 <= 0);
    end;

    local function _collectStatesAndMergedTimes(p30) -- Line: 111
        -- upvalues: TrailGraphBlender (ref)
        local v31, v32, v33 = TrailGraphBlender.CollectStates(p30);
        local v34 = {};
        local v35 = {};
        local v36 = {};

        for i = 1, #v31 - 1 do
            v34[i] = TrailGraphBlender.PrecomputeMergedTimes(v31[i].Graph, v31[i + 1].Graph);
        end;

        for i = 1, #v32 - 1 do
            v35[i] = TrailGraphBlender.PrecomputeMergedTimes(v32[i].Graph, v32[i + 1].Graph);
        end;

        for i = 1, #v33 - 1 do
            v36[i] = TrailGraphBlender.PrecomputeMergedColorTimes(v33[i].Graph, v33[i + 1].Graph);
        end;

        return v31, v32, v33, v34, v35, v36;
    end;

    local function _buildScalarGraphs(p37) -- Line: 120
        -- upvalues: Graph (ref), u2 (copy)
        local v38 = {
            Timescale = p37.TEmitTimescale
        };
        local v39 = {
            Timescale = Graph.GenerateSeed(p37.TEmitTimescale)
        };

        for _, v in ipairs(u2) do
            local v40 = p37["TEmit" .. v] or p37[v];

            if v40 then
                v38[v] = v40;
                v39[v] = Graph.GenerateSeed(v40);
            end;
        end;

        return v38, v39;
    end;

    function u1.EmitTrail(p41, p42, p43, p44) -- Line: 135
        -- upvalues: Pool (ref), Range (ref), _collectStatesAndMergedTimes (copy), _buildScalarGraphs (copy), u2 (copy), Graph (ref), u1 (copy), Flipbook (ref)
        if not (p42 and p42.Parent) then
            return;
        end;

        local v45 = p41:GetData(p42);

        if not (v45 and v45.RenderTemplate) then
            return;
        end;

        local v46 = Pool.acquireOrClone(v45.RenderTemplate, "TrailEmitter", v45.Pool);
        v46.Archivable = false;
        v46.Enabled = true;

        if p44 and p44._parentCloneMap then
            local _parentCloneMap = p44._parentCloneMap;

            if v46.Attachment0 and _parentCloneMap[v46.Attachment0] then
                v46.Attachment0 = _parentCloneMap[v46.Attachment0];
            end;

            if v46.Attachment1 and _parentCloneMap[v46.Attachment1] then
                v46.Attachment1 = _parentCloneMap[v46.Attachment1];
            end;
        end;

        local v47 = Range.RandomValueFromRange(v45.Lifetime);
        local v48 = v47 <= 0 and 0.001 or v47;
        local v49 = Range.RandomValueFromRange(v45.TrailLife or v45.Lifetime);
        v46.Lifetime = v49 <= 0 and 0.001 or v49;
        local v50, v51, v52, v53, v54, v55 = _collectStatesAndMergedTimes(v45.GraphBlender);

        if #v50 > 0 then
            v46.WidthScale = v50[1].Graph;
        end;

        if #v51 > 0 then
            v46.Transparency = v51[1].Graph;
        end;

        if #v52 > 0 then
            v46.Color = v52[1].Graph;
        end;

        local v56, v57 = _buildScalarGraphs(v45);

        for _, v in ipairs(u2) do
            if v56[v] then
                v46[v] = Graph.QueryPointsWithTime(0, v56[v], v57[v]);
            end;
        end;

        v46.Parent = v45.EmitParent or p41:GetFolder();
        local v58 = {
            Type = "TrailEmitter",
            CurrentStep = 0,
            VisualPart = v46,
            Link = p43,
            Events = v45.Events,
            StartTime = os.clock(),
            TotalKeyFrames = math.max(1, v45.TotalKeyFrames),
            LifeTime = v48,
            PartLife = v45.PartLife or 0,
            WidthStates = v50,
            TransStates = v51,
            ColorStates = v52,
            WidthMergedTimes = v53,
            TransMergedTimes = v54,
            ColorMergedTimes = v55,
            Graphs = v56,
            Seeds = v57,
            _effectiveElapsed = Graph.InitialEffectiveElapsed(v45.TEmitTimescale, v57.Timescale, v48),
            _sourceItem = p42
        };
        u1._seedTsOverride(v58, p42);

        if v45.Pool ~= false then
            v58._sourceRT = v45.RenderTemplate;
            v58._poolKind = "TrailEmitter";
        end;

        p41:_registerEmit(v58, p44);

        if v45.TrailFlipbookMode and v45.TrailFlipbooks then
            local v59 = Flipbook.GetSortedBeamTextures(v45.TrailFlipbooks);

            if #v59 > 0 then
                Flipbook.FlipBeam(v58, {
                    FlipbookMode = v45.TrailFlipbookMode,
                    FlipbookFramerate = v45.TrailFlipbookFramerate,
                    FlipbookStartRandom = v45.TrailFlipbookStartRandom,
                    FlipbookReverse = v45.TrailFlipbookReverse
                }, v59, v46, v48);
            end;
        end;
    end;

    function u1.EmitTrailAnimate(p60, p61, p62, p63) -- Line: 218
        -- upvalues: Range (ref), _collectStatesAndMergedTimes (copy), _buildScalarGraphs (copy), u2 (copy), Graph (ref), u1 (copy), Flipbook (ref)
        if not (p61 and p61.Parent) then
            return;
        end;

        if p60.ActiveAnimates[p61] then
            return;
        end;

        local v64 = p60:GetData(p61);

        if not (v64 and v64.RenderTemplate) then
            return;
        end;

        local RenderTemplate = v64.RenderTemplate;
        local v65 = {
            Lifetime = RenderTemplate.Lifetime,
            Brightness = RenderTemplate.Brightness,
            LightEmission = RenderTemplate.LightEmission,
            LightInfluence = RenderTemplate.LightInfluence,
            TextureLength = RenderTemplate.TextureLength,
            MinLength = RenderTemplate.MinLength,
            MaxLength = RenderTemplate.MaxLength,
            Texture = RenderTemplate.Texture,
            TextureMode = RenderTemplate.TextureMode,
            FaceCamera = RenderTemplate.FaceCamera,
            WidthScale = RenderTemplate.WidthScale,
            Transparency = RenderTemplate.Transparency,
            Color = RenderTemplate.Color,
            Enabled = RenderTemplate.Enabled
        };
        RenderTemplate.Enabled = true;
        local v66 = Range.RandomValueFromRange(v64.Lifetime);
        local v67 = v66 <= 0 and 0.001 or v66;
        local v68 = Range.RandomValueFromRange(v64.TrailLife or v64.Lifetime);
        RenderTemplate.Lifetime = v68 <= 0 and 0.001 or v68;
        local v69, v70, v71, v72, v73, v74 = _collectStatesAndMergedTimes(v64.GraphBlender);

        if #v69 > 0 then
            RenderTemplate.WidthScale = v69[1].Graph;
        end;

        if #v70 > 0 then
            RenderTemplate.Transparency = v70[1].Graph;
        end;

        if #v71 > 0 then
            RenderTemplate.Color = v71[1].Graph;
        end;

        local v75, v76 = _buildScalarGraphs(v64);

        for _, v in ipairs(u2) do
            if v75[v] then
                RenderTemplate[v] = Graph.QueryPointsWithTime(0, v75[v], v76[v]);
            end;
        end;

        local v77 = {
            Type = "TrailEmitter",
            CurrentStep = 0,
            IsAnimate = true,
            VisualPart = RenderTemplate,
            Link = p62,
            Events = v64.Events,
            StartTime = os.clock(),
            TotalKeyFrames = math.max(1, v64.TotalKeyFrames),
            LifeTime = v67,
            PartLife = v64.PartLife or 0,
            AnimateItem = p61,
            TrailEmitterSnapshot = v65,
            WidthStates = v69,
            TransStates = v70,
            ColorStates = v71,
            WidthMergedTimes = v72,
            TransMergedTimes = v73,
            ColorMergedTimes = v74,
            Graphs = v75,
            Seeds = v76,
            _effectiveElapsed = Graph.InitialEffectiveElapsed(v64.TEmitTimescale, v76.Timescale, v67),
            _sourceItem = p61
        };
        u1._seedTsOverride(v77, p61);
        p60.ActiveAnimates[p61] = v77;
        p60:_registerEmit(v77, p63);

        if v64.TrailFlipbookMode and v64.TrailFlipbooks then
            local v78 = Flipbook.GetSortedBeamTextures(v64.TrailFlipbooks);

            if #v78 > 0 then
                Flipbook.FlipBeam(v77, {
                    FlipbookMode = v64.TrailFlipbookMode,
                    FlipbookFramerate = v64.TrailFlipbookFramerate,
                    FlipbookStartRandom = v64.TrailFlipbookStartRandom,
                    FlipbookReverse = v64.TrailFlipbookReverse
                }, v78, RenderTemplate, v67);
            end;
        end;
    end;
end;