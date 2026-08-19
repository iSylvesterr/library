-- Decompiled with Potassium's decompiler.

local Graph = require(script.Parent.Graph);
local Range = require(script.Parent.Range);
local Pool = require(script.Parent.Pool);
local PartConstants = require(script.Parent.PartConstants);
local AxisLinks = require(script.Parent.AxisLinks);
local NestedEmit = require(script.Parent.NestedEmit);
local Particles = require(script.Parent.Particles);
local Turbulence = require(script.Parent.Turbulence);
local Events = require(script.Parent.Events);
local BoltGen = require(script.BoltGen);
local DirectionVectors = PartConstants.DirectionVectors;
local u1 = CFrame.new(1000000000, 1000000000, 1000000000);
local Rig = require(script.Rig);
local buildRig = Rig.buildRig;
local acquireBolt = Rig.acquireBolt;
local layoutFor = Rig.layoutFor;
local u2 = -1;
local u3 = 0;
local u4 = false;
local u5 = 0;

return function(u6) -- Line: 52
    -- upvalues: u1 (copy), BoltGen (copy), Graph (copy), Events (copy), Range (copy), acquireBolt (copy), u3 (ref), Pool (copy), Particles (copy), NestedEmit (copy), buildRig (copy), u2 (ref), u4 (ref), u5 (ref), Turbulence (copy), DirectionVectors (copy), AxisLinks (copy), PartConstants (copy), layoutFor (copy)
    function u6._isLightning(p7) -- Line: 55
        local v8 = p7:IsA("BasePart") and p7:GetAttribute("IsLightning") == true;

        return v8;
    end;

    local Endpoints = require(script.Endpoints);
    local sampleShape = Endpoints.sampleShape;
    local resolveEndpoints = Endpoints.resolveEndpoints;

    local function rebuildRevealMask(p9, p10, p11) -- Line: 69
        -- upvalues: u1 (ref)
        local v12 = p9.maxReveal or 0;
        local v13 = 0;

        for i = 1, p9.partCount do
            local v14 = p9.revealOrder[i];
            local v15 = p9.revealDist[v14];
            local v16;

            if p11 then
                if v15 == (1 / 0) then
                    v16 = false;
                else
                    v16 = v15 + p9.segLen[v14] >= v12 - p10;
                end;
            else
                v16 = v15 <= p10;
            end;

            if v16 then
                p9.writeCFs[v14] = p9.rollCFs[v14];
                v13 = i;
            else
                p9.writeCFs[v14] = u1;
            end;
        end;

        return v13;
    end;

    local function flushCFrames(p17, p18) -- Line: 94
        -- upvalues: rebuildRevealMask (copy)
        local _rig = p17._rig;
        local v19 = p17._lSpeed ~= 0;

        if v19 then
            p17._revealPtr = rebuildRevealMask(_rig, p17._tipDist or 0, p17._growReversed);
        end;

        local v20 = v19 and _rig.writeCFs or _rig.rollCFs;

        if p18 then
            for i = 1, _rig.partCount do
                _rig.parts[i].CFrame = v20[i];
            end;

            return;
        end;

        workspace:BulkMoveTo(_rig.parts, v20, Enum.BulkMoveMode.FireCFrameChanged);
    end;

    local function writeSizes(p21, p22, p23) -- Line: 111
        -- upvalues: BoltGen (ref)
        for i = 1, BoltGen.planSizes(p21, p22, p23) do
            local v24 = p21.sizeWriteIdx[i];
            local v25 = math.max(0.05, p22 * p21.widthScale[v24]);
            p21.parts[v24].Size = Vector3.new(v25, v25, p21.segLen[v24]);
        end;
    end;

    local function applyRoll(u26, p27) -- Line: 121
        -- upvalues: resolveEndpoints (copy), BoltGen (ref), u1 (ref), Graph (ref), writeSizes (copy), flushCFrames (copy)
        local _rig = u26._rig;
        local u28, u29, v30 = resolveEndpoints(u26);
        u26._totalLen = BoltGen.roll(_rig, u26, u29, v30, u1);

        if u26._shapeMode ~= "Jitter" then
            BoltGen.applyScroll(_rig, u26, u26._scrollPhase or 0);
            BoltGen.applyScrollForks(_rig, u26, u26._scrollPhase or 0);
        end;

        local v31 = BoltGen.diffLive(_rig);
        local Gradient = u26.Graphs.Gradient;

        if not p27 and v31 > 0 then
            local _curTrans = u26._curTrans;
            local v32;

            if Gradient then
                v32 = nil;
            else
                v32 = u26._curColor or nil;
            end;

            for i = 1, v31 do
                local v33 = _rig.newlyLiveIdx[i];
                local v34 = _rig.parts[v33];

                if _curTrans then
                    v34.Transparency = _curTrans;
                end;

                if v32 then
                    v34.Color = v32;
                end;

                local v35 = _rig.decals[v33];

                if v35 then
                    if _curTrans then
                        v35.Transparency = _curTrans;
                    end;

                    if v32 then
                        v35.Color3 = v32;
                    end;
                end;
            end;
        end;

        if Gradient and not u26.SkipColor then
            local v36 = 1 / math.max(_rig.maxReveal or 0, 0.0001);
            local _curTint = u26._curTint;

            for i = 1, _rig.partCount do
                if _rig.prevLive[i] then
                    local v37 = math.clamp((_rig.revealDist[i] + _rig.segLen[i] * 0.5) * v36, 0, 1);
                    local v38 = Graph.QueryColorPointWithTime(v37, Gradient);
                    _rig.gradColor[i] = v38;

                    if not p27 then
                        if _curTint then
                            v38 = Color3.new(math.min(v38.R * _curTint.R, 1), math.min(v38.G * _curTint.G, 1), (math.min(v38.B * _curTint.B, 1))) or v38;
                        end;

                        _rig.parts[i].Color = v38;
                        local v39 = _rig.decals[i];

                        if v39 then
                            v39.Color3 = v38;
                        end;
                    end;
                end;
            end;
        end;

        writeSizes(_rig, u26._curThick or 0.15, p27);
        pcall(function() -- Line: 173
            -- upvalues: u26 (copy), u29 (copy), u28 (copy)
            u26.VisualPart.WorldPivot = CFrame.new(u29) * u28.Rotation;
        end);
        flushCFrames(u26, p27);
    end;

    local function writeVisuals(p40, p41) -- Line: 180
        -- upvalues: Graph (ref), writeSizes (copy)
        local Graphs = p40.Graphs;
        local Seeds = p40.Seeds;
        local v42 = Graphs.Transparency and (Graph.QueryPointsWithTime(p41, Graphs.Transparency, Seeds.Transparency) or 0) or 0;

        if p40.SkipTransparency then
            v42 = p40._curTrans or v42;
        end;

        local v43 = Graphs.Brightness and (Graph.QueryPointsWithTime(p41, Graphs.Brightness, Seeds.Brightness) or 1) or 1;
        local v44;

        if Graphs.Color and not p40.SkipColor then
            local v45 = Graph.QueryColorPointWithTime(p41, Graphs.Color);
            v44 = Color3.new(math.min(v45.R * v43, 1), math.min(v45.G * v43, 1), (math.min(v45.B * v43, 1)));
        else
            v44 = nil;
        end;

        local v46 = Graphs.Thickness and Graph.QueryPointsWithTime(p41, Graphs.Thickness, Seeds.Thickness);
        local _rig = p40._rig;
        local v47;

        if v46 then
            v47 = v46 ~= p40._curThick;
        else
            v47 = v46;
        end;

        if v46 then
            p40._curThick = v46;
        end;

        p40._curTrans = v42;

        if v44 then
            p40._curColor = v44;
            p40._curTint = v44;
        end;

        local Gradient = Graphs.Gradient;

        for i = 1, _rig.partCount do
            if _rig.prevLive[i] then
                local v48 = _rig.parts[i];
                v48.Transparency = v42;
                local v49 = _rig.decals[i];

                if v49 then
                    v49.Transparency = v42;
                end;

                if v44 then
                    local v50;

                    if Gradient then
                        local v51 = _rig.gradColor[i];

                        if v51 then
                            v50 = Color3.new(math.min(v51.R * v44.R, 1), math.min(v51.G * v44.G, 1), (math.min(v51.B * v44.B, 1)));
                        else
                            v50 = v44;
                        end;
                    else
                        v50 = v44;
                    end;

                    v48.Color = v50;

                    if v49 then
                        v49.Color3 = v50;
                    end;
                end;
            end;
        end;

        if v47 then
            writeSizes(_rig, v46, false);
        end;
    end;

    local PDataBuilder = require(script.PDataBuilder);
    local build = PDataBuilder.build;

    local function buildSeekParams(u52, p53) -- Line: 231
        -- upvalues: Events (ref)
        if p53._endpointMode ~= "Seek" then
            return;
        end;

        local u54 = Events.makeHitParams(p53);
        u54.RespectCanCollide = true;
        pcall(function() -- Line: 235
            -- upvalues: u54 (copy), u52 (copy)
            u54:AddToFilter(u52:GetFolder());
            u54:AddToFilter(u52:GetPoolFolder());
        end);

        function p53._seekRayFn(p55, p56) -- Line: 239
            -- upvalues: u54 (copy)
            return workspace:Raycast(p55, p56, u54);
        end;
    end;

    local function fireSeekHit(p57, p58) -- Line: 247
        -- upvalues: Endpoints (copy), Events (ref)
        if not p58._seekNewHit then
            return;
        end;

        if not Endpoints.glideArrived(p58) then
            return;
        end;

        p58._seekNewHit = nil;

        if not (p58.Events and (p58.Events.OnHit and p58._seekHit)) then
            return;
        end;

        local _seekHit = p58._seekHit;
        local v59 = Events.makePayload(p57, p58, "OnHit", nil);
        v59.HitInstance = _seekHit.Instance;
        v59.Other = _seekHit.Instance;
        v59.HitPosition = _seekHit.Position;
        v59.HitNormal = _seekHit.Normal;
        Events.fire(p57, p58, "OnHit", p58.EventChainCtx, v59);
    end;

    function u6.EmitLightning(p60, p61, p62, p63) -- Line: 263
        -- upvalues: Range (ref), acquireBolt (ref), build (copy), u6 (copy), Graph (ref), buildSeekParams (copy), u3 (ref), applyRoll (copy), writeVisuals (copy), Pool (ref), Particles (ref), NestedEmit (ref), fireSeekHit (copy)
        if not (p61 and p61.Parent) then
            return;
        end;

        local v64 = p60:GetData(p61);

        if not (v64 and v64.RenderTemplate) then
            return;
        end;

        local v65 = Range.RandomValueFromRange(v64.Lifetime);
        local v66, v67 = acquireBolt(v64);
        local v68 = build(p61, v64, v66, v67, v65 <= 0 and 0.001 or v65, p63);
        v68._parentLink = p62;

        if p63 then
            local v69;

            if p63.EventOriginResolver then
                v69 = p63.EventOriginResolver();
            else
                v69 = nil;
            end;

            local v70 = v69 or p63.EventOriginCF;

            if v70 then
                v68._startCFOverride = p63.UseFullOrigin and v70 and v70 or CFrame.new(v70.Position) * p61.CFrame.Rotation;
            end;
        end;

        u6._seedTsOverride(v68, p61);

        if v64.Pool ~= false then
            v68._sourceRT = v64.RenderTemplate;
            v68._poolKind = "Lightning";
        end;

        v68._curThick = v64.Thickness and (Graph.QueryPointsWithTime(0, v64.Thickness, v68.Seeds.Thickness) or 0.15) or 0.15;
        buildSeekParams(p60, v68);
        u3 = u3 + 1;
        applyRoll(v68, true);
        writeVisuals(v68, 0);
        v66.Parent = v64.EmitParent or p60:GetFolder();
        Pool.restoreTrails(v66, "Lightning");
        Particles.EnableEmit(v66, p60:_makeAliveCheck());
        p60:_registerEmit(v68, p63);
        NestedEmit.walk(p60, v64.RenderTemplate, v66, v68._nestedAlive, p63);
        fireSeekHit(p60, v68);
    end;

    function u6.EmitLightningAnimate(p71, p72, p73, p74) -- Line: 313
        -- upvalues: Range (ref), buildRig (ref), build (copy), u6 (copy), Graph (ref), buildSeekParams (copy), u3 (ref), applyRoll (copy), writeVisuals (copy), Particles (ref), NestedEmit (ref), fireSeekHit (copy)
        if not (p72 and p72.Parent) then
            return;
        end;

        if p71.ActiveAnimates[p72] then
            return;
        end;

        local v75 = p71:GetData(p72);

        if not (v75 and v75.RenderTemplate) then
            return;
        end;

        local v76 = Range.RandomValueFromRange(v75.Lifetime);
        local v77, v78 = buildRig(v75);
        v77:SetAttribute("_PartIcleEmit", true);
        local v79 = build(p72, v75, v77, v78, v76 <= 0 and 0.001 or v76, p74);
        v79._parentLink = p73;
        v79.IsAnimate = true;
        v79.AnimateItem = p72;
        u6._seedTsOverride(v79, p72);
        v79._curThick = v75.Thickness and (Graph.QueryPointsWithTime(0, v75.Thickness, v79.Seeds.Thickness) or 0.15) or 0.15;
        buildSeekParams(p71, v79);
        u3 = u3 + 1;
        applyRoll(v79, true);
        writeVisuals(v79, 0);
        v77.Parent = v75.EmitParent or p71:GetFolder();
        Particles.EnableEmit(v77, p71:_makeAliveCheck());
        p71.ActiveAnimates[p72] = v79;
        p71:_registerEmit(v79, p74);
        NestedEmit.walk(p71, v75.RenderTemplate, v77, v79._nestedAlive, p74);
        fireSeekHit(p71, v79);
    end;

    function u6.UpdateLightning(p80, p81, p82, p83) -- Line: 349
        -- upvalues: Graph (ref), u2 (ref), u3 (ref), u4 (ref), u5 (ref), Turbulence (ref), applyRoll (copy), fireSeekHit (copy), Endpoints (copy), rebuildRevealMask (copy), u1 (ref), BoltGen (ref), writeSizes (copy), writeVisuals (copy)
        local v84 = math.max((p83 - p81.StartTime) / p81.LifeTime, 0);
        local v85 = math.min(v84, 1);
        local v86;

        if p81._tsOverride == nil or p83 >= (p81._tsOverrideUntil or 0) then
            v86 = p81.Graphs.Timescale and (Graph.QueryPointsWithTime(v85, p81.Graphs.Timescale, p81.Seeds.Timescale) or 1) or 1;
        else
            v86 = p81._tsOverride;
        end;

        local v87 = p82 * v86;
        local LifeTime = p81.LifeTime;
        local v88 = p81._effectiveElapsed or 0;
        local v89 = v88 + (p81._timeFrozen and 0 or v87);
        local v90 = v89 < 0 and 0 or v89;

        if LifeTime < v90 then
            v90 = LifeTime;
        end;

        p81._effectiveElapsed = v90;
        local VisualPart = p81.VisualPart;

        if not (VisualPart and VisualPart.Parent) then
            return true;
        end;

        if p81.TotalKeyFrames <= 0 then
            return true;
        end;

        local v91;

        if v85 >= 1 then
            v91 = LifeTime <= v90 and true or v90 <= 0;
        else
            v91 = false;
        end;

        local _rig = p81._rig;

        if p83 ~= u2 then
            u2 = p83;
            u3 = 0;

            if p82 > 0.025 then
                u4 = true;
                u5 = 0;
            elseif u4 then
                if p82 < 0.01818181818181818 then
                    u5 = u5 + 1;

                    if u5 >= 2 then
                        u4 = false;
                    end;
                else
                    u5 = 0;
                end;
            end;
        end;

        if not v91 then
            local v92 = v90 - v88;

            if p81._hasMotion and v92 ~= 0 then
                local v93 = math.max(v90 / LifeTime, 0);
                local v94 = math.min(v93, 1);
                local v95 = p81.Graphs.Speed and (Graph.QueryPointsWithTime(v94, p81.Graphs.Speed, p81.Seeds.Speed) or 0) or 0;

                if p81._drag ~= 0 then
                    v95 = v95 * math.exp(-p81._drag * v90);
                end;

                p81._motionAccelVel = p81._motionAccelVel + p81._accel * v92;
                p81._motionOffset = p81._motionOffset + (p81._lastDirWorld or Vector3.new(0, 0, 0)) * (v95 * v92) + p81._motionAccelVel * v92;
            end;

            if p81._hasDisp then
                local v96 = math.max(v90 / LifeTime, 0);
                local v97 = math.min(v96, 1);
                local v98 = p81.Graphs.PosOffsetX and (Graph.QueryPointsWithTime(v97, p81.Graphs.PosOffsetX, p81.Seeds.PosOffsetX) or 0) or 0;
                local v99 = p81.Graphs.PosOffsetY and (Graph.QueryPointsWithTime(v97, p81.Graphs.PosOffsetY, p81.Seeds.PosOffsetY) or 0) or 0;
                local v100 = p81.Graphs.PosOffsetZ and (Graph.QueryPointsWithTime(v97, p81.Graphs.PosOffsetZ, p81.Seeds.PosOffsetZ) or 0) or 0;
                p81._dispRaw = Vector3.new(v98, v99, v100);
            end;

            if p81._hasTurb then
                local v101 = math.max(v90 / LifeTime, 0);
                local v102 = math.min(v101, 1);
                p81._turbRaw = Turbulence.sampleRaw(p81.Graphs.Turbulence, p81.Seeds.Turbulence, p81._turbSeed, p81._turbFreq, LifeTime, v102);
            end;

            if p81._rollPending and p81._rollPendingStamp ~= p83 then
                p81._rollPending = nil;
                p81._rollPendingStamp = nil;
                p81._jitterAccum = 0;
                u3 = u3 + 1;
                applyRoll(p81, false);
                fireSeekHit(p80, p81);
            end;

            if Endpoints.glideStep(p81, (math.abs(v92))) and p81._jitterInterval == (1 / 0) then
                if u4 and u3 >= 8 then
                    p81._rollPending = true;
                    p81._rollPendingStamp = p83;
                else
                    u3 = u3 + 1;
                    applyRoll(p81, false);
                    fireSeekHit(p80, p81);
                end;
            end;

            p81._jitterAccum = p81._jitterAccum + math.abs(v87);

            if p81._jitterAccum >= p81._jitterInterval and not p81._rollPending then
                if u4 and u3 >= 8 then
                    p81._rollPending = true;
                    p81._rollPendingStamp = p83;
                else
                    p81._jitterAccum = 0;
                    u3 = u3 + 1;
                    applyRoll(p81, false);
                    fireSeekHit(p80, p81);
                end;
            end;

            if p81._lSpeed ~= 0 then
                local v103 = math.abs(p81._lSpeed) * v90;

                if v103 ~= p81._tipDist then
                    p81._tipDist = v103;

                    if p81._growReversed then
                        if p81._shapeMode == "Jitter" then
                            local _rig2 = p81._rig;
                            local v104 = p81._lSpeed ~= 0;

                            if v104 then
                                p81._revealPtr = rebuildRevealMask(_rig2, p81._tipDist or 0, p81._growReversed);
                            end;

                            workspace:BulkMoveTo(_rig2.parts, v104 and _rig2.writeCFs or _rig2.rollCFs, Enum.BulkMoveMode.FireCFrameChanged);
                        end;
                    elseif p81._shapeMode == "Jitter" then
                        local revealOrder = _rig.revealOrder;
                        local revealDist = _rig.revealDist;
                        local writeCFs = _rig.writeCFs;
                        local rollCFs = _rig.rollCFs;
                        local _revealPtr = p81._revealPtr;
                        local v105 = false;

                        while _revealPtr < _rig.partCount and revealDist[revealOrder[_revealPtr + 1]] <= v103 do
                            _revealPtr = _revealPtr + 1;
                            local v106 = revealOrder[_revealPtr];
                            writeCFs[v106] = rollCFs[v106];
                            v105 = true;
                        end;

                        while _revealPtr > 0 and v103 < revealDist[revealOrder[_revealPtr]] do
                            writeCFs[revealOrder[_revealPtr]] = u1;
                            _revealPtr = _revealPtr - 1;
                            v105 = true;
                        end;

                        p81._revealPtr = _revealPtr;

                        if v105 then
                            workspace:BulkMoveTo(_rig.parts, _rig.writeCFs, Enum.BulkMoveMode.FireCFrameChanged);
                        end;
                    end;
                end;
            end;

            if p81._shapeMode ~= "Jitter" then
                p81._scrollPhase = p81._scrollPhase + p81._scrollSpeed * (p81._timeFrozen and 0 or v87);
                BoltGen.applyScroll(_rig, p81, p81._scrollPhase);
                BoltGen.applyScrollForks(_rig, p81, p81._scrollPhase);
                writeSizes(_rig, p81._curThick or 0.15, false);
                local _rig2 = p81._rig;
                local v107 = p81._lSpeed ~= 0;

                if v107 then
                    p81._revealPtr = rebuildRevealMask(_rig2, p81._tipDist or 0, p81._growReversed);
                end;

                workspace:BulkMoveTo(_rig2.parts, v107 and _rig2.writeCFs or _rig2.rollCFs, Enum.BulkMoveMode.FireCFrameChanged);
            end;
        end;

        local v108 = math.max(v90 / LifeTime, 0);
        local v109 = math.min(v108, 1) * p81.TotalKeyFrames;
        local v110 = math.floor(v109);

        if v110 ~= p81.CurrentStep then
            p81.CurrentStep = v110;
            writeVisuals(p81, v110 / p81.TotalKeyFrames);
        end;

        return v91;
    end;

    function u6._refreshLightningAnimate(p111, p112, p113) -- Line: 526
        -- upvalues: Range (ref), buildSeekParams (copy), DirectionVectors (ref), AxisLinks (ref), PartConstants (ref), PDataBuilder (copy), Turbulence (ref), sampleShape (copy), layoutFor (ref), buildRig (ref), Graph (ref), u3 (ref), applyRoll (copy), writeVisuals (copy), fireSeekHit (copy)
        p112.Link = nil;
        p112._endpointMode = p113.TargetMode == "Seek" and "Seek" or (p113.TargetMode == "Point" and (p113.Target and p113.Target.Parent) and "Point" or "Directional");
        p112._target = p113.Target;
        local v114 = Range.RandomValueFromRange(p113.SeekRadius);
        p112._seekRadius = math.max(v114, 1);
        p112._seekRetarget = p113.SeekRetarget == true;
        p112._seekBias = math.clamp(p113.SeekBias or 0, 0, 1);
        p112._retargetSpeed = math.max(p113.RetargetSpeed or 0, 0);
        p112._seekHit = nil;
        p112._seekFallbackDir = nil;
        p112._seekNewHit = nil;
        p112._seekCurrentPos = nil;
        p112._seekGoalPos = nil;
        buildSeekParams(p111, p112);
        p112._length = math.max(0.1, Range.RandomValueFromRange(p113.Length));
        p112._amplitude = Range.RandomValueFromRange(p113.Amplitude);
        p112._decay = Range.RandomValueFromRange(p113.AmplitudeDecay);
        p112._forkChance = Range.RandomValueFromRange(p113.ForkChance);
        local v115 = Range.RandomValueFromRange(p113.ForkDepth) + 0.5;
        p112._forkDepth = math.floor(v115);
        p112._forkLenScale = Range.RandomValueFromRange(p113.ForkLengthScale);
        p112._sag = Range.RandomValueFromRange(p113.Sag);
        p112._sagShape = Range.RandomValueFromRange(p113.SagShape);
        p112._shapeMode = p113.ShapeMode or "Jitter";
        p112._scrollSpeed = Range.RandomValueFromRange(p113.ScrollSpeed);
        p112._waves = math.max(0.25, Range.RandomValueFromRange(p113.Waves));
        p112._scrollPhase = 0;
        p112._noiseSeedA = math.random() * 1000;
        p112._noiseSeedB = 500 + math.random() * 1000;
        local v116 = Range.RandomValueFromRange(p113.JitterRate);
        p112._jitterInterval = v116 > 0 and 1 / v116 or (1 / 0);
        p112._jitterAccum = 0;
        p112._lSpeed = p113.GrowthSpeed or 0;
        p112._growReversed = (p113.GrowthSpeed or 0) < 0;
        p112._tipDist = 0;
        p112._revealPtr = 0;
        local v117 = DirectionVectors[p113.EmissionDirection] or DirectionVectors[Enum.NormalId.Top];
        local v118 = CFrame.new()[v117.vector] * v117.multiplier;
        local v119 = p113.SpreadAngle or Vector2.new(0, 0);
        local v120 = AxisLinks.sampleRangeAxes(p113, p113.AxisLinks, { "RotX", "RotY", "RotZ" }, Range, nil);
        local v121 = PartConstants.composeRotation(p113.RotOrder or "Global", v120.RotX or 0, v120.RotY or 0, v120.RotZ or 0);
        local v122 = CFrame.lookAt(Vector3.new(0, 0, 0), v118);

        if p113.DirMode == "Local" then
            v122 = v122 * v121;
        end;

        if v119.X > 0 or v119.Y > 0 then
            local Angles = CFrame.Angles;
            local v123 = (math.random() * 2 - 1) * v119.X;
            local v124 = math.rad(v123);
            local v125 = (math.random() * 2 - 1) * v119.Y;
            v122 = v122 * Angles(v124, math.rad(v125), 0);
        end;

        p112._dirLocalVec = v122.LookVector;
        p112._dirGlobal = p113.DirMode == "Global";
        p112._originRot = v121;
        local v126 = AxisLinks.sampleRangeAxes(p113, p113.AxisLinks, { "PosX", "PosY", "PosZ" }, Range, nil);
        local v127 = v126.PosX or 0;
        local v128 = v126.PosY or 0;
        local v129 = v126.PosZ or 0;

        if v127 == 0 and (v128 == 0 and v129 == 0) then
            p112._originOffset = nil;
        else
            p112._originOffset = Vector3.new(v127, v128, v129);
            p112._originOffsetGlobal = p113.PosMode == "Global";
        end;

        p112._accel = p113.Acceleration or Vector3.new(0, 0, 0);
        p112._drag = p113.Drag or 0;
        p112._dispMode = p113.DisplacementMode or "Global";
        p112._motionOffset = Vector3.new(0, 0, 0);
        p112._motionAccelVel = Vector3.new(0, 0, 0);
        p112._dispRaw = nil;
        p112._hasMotion = PDataBuilder.liveGraph(p113.Speed) ~= nil and true or p112._accel.Magnitude > 0;
        p112._hasDisp = (PDataBuilder.liveGraph(p113.PosOffsetX) ~= nil or PDataBuilder.liveGraph(p113.PosOffsetY) ~= nil) and true or PDataBuilder.liveGraph(p113.PosOffsetZ) ~= nil;
        p112.Graphs.Gradient = PDataBuilder.liveColor(p113.Gradient);
        p112.Graphs.Turbulence = Turbulence.isLive(p113.Turbulence);
        p112._hasTurb = p112.Graphs.Turbulence ~= nil;
        p112._turbFreq = p113.TurbulenceFrequency or 1;
        p112._turbSeed = math.random() * 997 + 0.5;
        p112._turbRaw = nil;
        sampleShape(p112, p113, p112.AnimateItem);

        if layoutFor(p113) ~= p112._rig.partCount and p113.RenderTemplate then
            local VisualPart = p112.VisualPart;
            local v130;

            if VisualPart then
                v130 = VisualPart.Parent;
            else
                v130 = VisualPart;
            end;

            local v131, v132 = buildRig(p113);
            v131:SetAttribute("_PartIcleEmit", true);
            p112.VisualPart = v131;
            p112._rig = v132;
            v131.Parent = v130 or p111:GetFolder();

            if VisualPart then
                pcall(function() -- Line: 616
                    -- upvalues: VisualPart (copy)
                    VisualPart:Destroy();
                end);
            end;
        end;

        local v133 = Range.RandomValueFromRange(p113.SegmentCount) + 0.5;
        local v134 = math.floor(v133);
        p112._segCount = math.clamp(v134, 2, p112._rig.mainSegs);
        p112._curThick = p113.Thickness and Graph.QueryPointsWithTime(0, p113.Thickness, p112.Seeds.Thickness) or p112._curThick;
        p112._rollPending = nil;
        p112._rollPendingStamp = nil;
        u3 = u3 + 1;
        applyRoll(p112, false);
        writeVisuals(p112, 0);
        fireSeekHit(p111, p112);
    end;
end;