-- Decompiled with Potassium's decompiler.

local Graph = require(script.Parent.Graph);
local Range = require(script.Parent.Range);
local Pool = require(script.Parent.Pool);
local NestedEmit = require(script.Parent.NestedEmit);
local Particles = require(script.Parent.Particles);
local Turbulence = require(script.Parent.Turbulence);
local PartConstants = require(script.Parent.PartConstants);
local VerletSim = require(script.VerletSim);
local Anchors = require(script.Anchors);
local PDataBuilder = require(script.PDataBuilder);
local u1 = CFrame.new(1000000000, 1000000000, 1000000000);
local u2 = setmetatable({}, {
    __mode = "k"
});

return function(u3) -- Line: 32
    -- upvalues: Pool (copy), u1 (copy), u2 (copy), Graph (copy), Range (copy), PDataBuilder (copy), Anchors (copy), Particles (copy), NestedEmit (copy), Turbulence (copy), PartConstants (copy), VerletSim (copy)
    function u3._isRope(p4) -- Line: 35
        local v5 = p4:IsA("BasePart") and p4:GetAttribute("IsRope") == true;

        return v5;
    end;

    local function buildSegment(p6) -- Line: 41
        -- upvalues: Pool (ref)
        local v7 = Pool.copyBare(p6);
        v7.Anchored = true;
        v7.CanCollide = false;
        v7.CanQuery = false;
        v7.CanTouch = false;
        v7.Massless = true;
        v7.Locked = true;
        v7.Archivable = false;

        return v7, v7:FindFirstChildWhichIsA("Decal") or v7:FindFirstChildWhichIsA("Texture");
    end;

    local function segCapFor(p8) -- Line: 54
        local v9 = math.floor((p8.SegmentCount and p8.SegmentCount.Max or 12) + 0.5);

        return math.clamp(v9, 2, 48);
    end;

    local function buildRig(p10) -- Line: 58
        -- upvalues: Pool (ref), u1 (ref), u2 (ref)
        local v11 = math.floor((p10.SegmentCount and (p10.SegmentCount.Max or 12) or 12) + 0.5);
        local v12 = math.clamp(v11, 2, 48);
        local Model = Instance.new("Model");
        Model.Name = "Rope";
        Model.Archivable = false;
        Model:SetAttribute("_lightningBolt", true);
        local v13 = {
            segCap = v12,
            partCount = v12,
            parts = table.create(v12),
            decals = table.create(v12),
            segLen = table.create(v12),
            widthScale = table.create(v12),
            writeCFs = table.create(v12),
            posBuf = table.create(v12 + 1),
            prevPosBuf = table.create(v12 + 1)
        };

        for i = 1, v12 do
            local v14 = Pool.copyBare(p10.RenderTemplate);
            v14.Anchored = true;
            v14.CanCollide = false;
            v14.CanQuery = false;
            v14.CanTouch = false;
            v14.Massless = true;
            v14.Locked = true;
            v14.Archivable = false;
            local v15 = v14:FindFirstChildWhichIsA("Decal") or v14:FindFirstChildWhichIsA("Texture");
            v14.Name = "Seg" .. i;
            v14.CFrame = u1;
            v14.Parent = Model;
            v13.parts[i] = v14;
            v13.decals[i] = v15;
            v13.segLen[i] = 0.05;
            v13.widthScale[i] = 1;
            v13.writeCFs[i] = u1;
        end;

        u2[Model] = v13;

        return Model, v13;
    end;

    local function acquireRope(p16) -- Line: 92
        -- upvalues: Pool (ref), u2 (ref), buildRig (copy)
        local v17 = math.floor((p16.SegmentCount and (p16.SegmentCount.Max or 12) or 12) + 0.5);
        local v18 = math.clamp(v17, 2, 48);
        local u19 = p16.Pool == true and Pool.acquire(p16.RenderTemplate, "Rope");

        if u19 then
            local v20 = u2[u19];

            if v20 and (v20.segCap == v18 and (v20.parts[1] and v20.parts[1].Parent == u19)) then
                u19:SetAttribute("_PartIcleEmit", true);

                return u19, v20;
            end;

            pcall(function() -- Line: 102
                -- upvalues: u19 (copy)
                u19:Destroy();
            end);
        end;

        local v21, v22 = buildRig(p16);
        v21:SetAttribute("_PartIcleEmit", true);

        return v21, v22;
    end;

    local function writeVisuals(p23, p24) -- Line: 112
        -- upvalues: Graph (ref)
        local Graphs = p23.Graphs;
        local Seeds = p23.Seeds;
        local v25 = Graphs.Transparency and (Graph.QueryPointsWithTime(p24, Graphs.Transparency, Seeds.Transparency) or 0) or 0;

        if p23.SkipTransparency then
            v25 = p23._curTrans or v25;
        end;

        local v26 = Graphs.Brightness and (Graph.QueryPointsWithTime(p24, Graphs.Brightness, Seeds.Brightness) or 1) or 1;
        local v27;

        if Graphs.Color and not p23.SkipColor then
            local v28 = Graph.QueryColorPointWithTime(p24, Graphs.Color);
            v27 = Color3.new(math.min(v28.R * v26, 1), math.min(v28.G * v26, 1), (math.min(v28.B * v26, 1)));
        else
            v27 = nil;
        end;

        local v29 = Graphs.Thickness and Graph.QueryPointsWithTime(p24, Graphs.Thickness, Seeds.Thickness);
        local _rig = p23._rig;
        local v30;

        if v29 then
            v30 = v29 ~= p23._curThick;
        else
            v30 = v29;
        end;

        if v29 then
            p23._curThick = v29;
        end;

        p23._curTrans = v25;

        for i = 1, _rig.segCap do
            local v31 = _rig.parts[i];
            v31.Transparency = v25;

            if v27 then
                v31.Color = v27;
            end;

            local v32 = _rig.decals[i];

            if v32 then
                v32.Transparency = v25;

                if v27 then
                    v32.Color3 = v27;
                end;
            end;

            if v30 then
                local v33 = math.max(0.05, v29 * _rig.widthScale[i]);
                v31.Size = Vector3.new(v33, v33, _rig.segLen[i]);
            end;
        end;
    end;

    local function writeSegments(p34, p35) -- Line: 146
        -- upvalues: u1 (ref)
        local _rig = p34._rig;
        local posBuf = _rig.posBuf;
        local _segCount = p34._segCount;
        local v36 = p34._curThick or 0.15;

        for i = 1, _segCount do
            local v37 = posBuf[i];
            local v38 = posBuf[i + 1];
            local Magnitude = (v38 - v37).Magnitude;
            local v39 = (v37 + v38) * 0.5;

            if Magnitude > 0.0001 then
                _rig.writeCFs[i] = CFrame.lookAt(v39, v38);
            else
                _rig.writeCFs[i] = CFrame.new(v39);
            end;

            if math.abs(Magnitude - _rig.segLen[i]) > 0.01 then
                _rig.segLen[i] = math.max(Magnitude, 0.05);
                local v40 = math.max(0.05, v36 * _rig.widthScale[i]);
                _rig.parts[i].Size = Vector3.new(v40, v40, _rig.segLen[i]);
            end;
        end;

        for i = _segCount + 1, _rig.segCap do
            _rig.writeCFs[i] = u1;
        end;

        if p35 then
            for i = 1, _rig.segCap do
                _rig.parts[i].CFrame = _rig.writeCFs[i];
            end;

            return;
        end;

        workspace:BulkMoveTo(_rig.parts, _rig.writeCFs, Enum.BulkMoveMode.FireCFrameChanged);
    end;

    function u3.EmitRope(p41, p42, p43, p44) -- Line: 181
        -- upvalues: Range (ref), acquireRope (copy), PDataBuilder (ref), u3 (copy), Anchors (ref), Graph (ref), writeSegments (copy), writeVisuals (copy), Pool (ref), Particles (ref), NestedEmit (ref)
        if not (p42 and p42.Parent) then
            return;
        end;

        local v45 = p41:GetData(p42);

        if not (v45 and v45.RenderTemplate) then
            return;
        end;

        local v46 = Range.RandomValueFromRange(v45.Lifetime);
        local v47, v48 = acquireRope(v45);
        local v49 = PDataBuilder.build(p42, v45, v47, v48, v46 <= 0 and 0.001 or v46, p44, p43);
        u3._seedTsOverride(v49, p42);

        if v45.Pool == true then
            v49._sourceRT = v45.RenderTemplate;
            v49._poolKind = "Rope";
        end;

        Anchors.seedPose(v49);
        v49._curThick = v45.Thickness and (Graph.QueryPointsWithTime(0, v45.Thickness, v49.Seeds.Thickness) or 0.15) or 0.15;
        writeSegments(v49, true);
        writeVisuals(v49, 0);
        v47.Parent = v45.EmitParent or p41:GetFolder();
        Pool.restoreTrails(v47, "Rope");
        Particles.EnableEmit(v47, p41:_makeAliveCheck());
        v49._nestedAlive = { true };
        p41:_registerEmit(v49, p44);
        NestedEmit.walk(p41, v45.RenderTemplate, v47, v49._nestedAlive, p44);
    end;

    function u3.EmitRopeAnimate(p50, p51, p52, p53) -- Line: 211
        -- upvalues: Range (ref), buildRig (copy), PDataBuilder (ref), u3 (copy), Anchors (ref), Graph (ref), writeSegments (copy), writeVisuals (copy), Particles (ref), NestedEmit (ref)
        if not (p51 and p51.Parent) then
            return;
        end;

        if p50.ActiveAnimates[p51] then
            return;
        end;

        local v54 = p50:GetData(p51);

        if not (v54 and v54.RenderTemplate) then
            return;
        end;

        local v55 = Range.RandomValueFromRange(v54.Lifetime);
        local v56, v57 = buildRig(v54);
        v56:SetAttribute("_PartIcleEmit", true);
        local v58 = PDataBuilder.build(p51, v54, v56, v57, v55 <= 0 and 0.001 or v55, p53, p52);
        v58.IsAnimate = true;
        v58.AnimateItem = p51;
        u3._seedTsOverride(v58, p51);
        Anchors.seedPose(v58);
        v58._curThick = v54.Thickness and (Graph.QueryPointsWithTime(0, v54.Thickness, v58.Seeds.Thickness) or 0.15) or 0.15;
        writeSegments(v58, true);
        writeVisuals(v58, 0);
        v56.Parent = v54.EmitParent or p50:GetFolder();
        Particles.EnableEmit(v56, p50:_makeAliveCheck());
        v58._nestedAlive = { true };
        p50.ActiveAnimates[p51] = v58;
        p50:_registerEmit(v58, p53);
        NestedEmit.walk(p50, v54.RenderTemplate, v56, v58._nestedAlive, p53);
    end;

    function u3.UpdateRope(p59, p60, p61, p62) -- Line: 243
        -- upvalues: Graph (ref), Turbulence (ref), Anchors (ref), PartConstants (ref), VerletSim (ref), writeSegments (copy), writeVisuals (copy)
        local v63 = math.max((p62 - p60.StartTime) / p60.LifeTime, 0);
        local v64 = math.min(v63, 1);
        local v65;

        if p60._tsOverride == nil or p62 >= (p60._tsOverrideUntil or 0) then
            v65 = p60.Graphs.Timescale and (Graph.QueryPointsWithTime(v64, p60.Graphs.Timescale, p60.Seeds.Timescale) or 1) or 1;
        else
            v65 = p60._tsOverride;
        end;

        local v66 = p61 * v65;
        local LifeTime = p60.LifeTime;
        local v67 = p60._effectiveElapsed or 0;
        local v68 = v67 + (p60._timeFrozen and 0 or v66);
        local v69 = v68 < 0 and 0 or v68;

        if LifeTime < v69 then
            v69 = LifeTime;
        end;

        p60._effectiveElapsed = v69;
        local VisualPart = p60.VisualPart;

        if not (VisualPart and VisualPart.Parent) then
            return true;
        end;

        if p60.TotalKeyFrames <= 0 then
            return true;
        end;

        local v70;

        if v64 >= 1 then
            v70 = LifeTime <= v69 and true or v69 <= 0;
        else
            v70 = false;
        end;

        if not v70 then
            local v71;

            if p60._timeFrozen == true then
                v71 = 0;
            else
                local v72 = math.abs(v66);
                v71 = math.min(v72, 0.25);
            end;

            local v73 = math.clamp(v69 - v67, -0.25, 0.25);
            local v74 = math.max(v69 / LifeTime, 0);
            local v75 = math.min(v74, 1);
            local v76 = (p60._growIn <= 0 or v75 >= p60._growIn) and 1 or math.max(v75 / p60._growIn, 0.02);

            if p60._deathMode == "Retract" then
                local v77 = 1 - p60._deathWindow;

                if v77 < v75 then
                    v76 = v76 * math.max(1 - (v75 - v77) / p60._deathWindow, 0.02);
                end;
            elseif p60._deathMode == "Release" and (not p60._released and 1 - p60._deathWindow < v75) then
                p60._released = true;
                p60._pinStart = false;
                p60._pinEnd = false;
            end;

            p60._restLenEff = p60._restLen * v76;

            if p60._hasMotion and v73 ~= 0 then
                local v78 = p60.Graphs.Speed and (Graph.QueryPointsWithTime(v75, p60.Graphs.Speed, p60.Seeds.Speed) or 0) or 0;

                if p60._drag ~= 0 then
                    v78 = v78 * math.exp(-p60._drag * v69);
                end;

                p60._motionAccelVel = p60._motionAccelVel + p60._accel * v73;
                p60._motionOffset = p60._motionOffset + (p60._speedDir or p60._motionDir) * (v78 * v73) + p60._motionAccelVel * v73;
            end;

            if p60._hasDisp or (p60._hasTurb or p60._hasMotion) then
                local v79;

                if p60._hasDisp then
                    local Graphs = p60.Graphs;
                    local Seeds = p60.Seeds;
                    local v80 = Graphs.PosOffsetX and (Graph.QueryPointsWithTime(v75, Graphs.PosOffsetX, Seeds.PosOffsetX) or 0) or 0;
                    local v81 = Graphs.PosOffsetY and (Graph.QueryPointsWithTime(v75, Graphs.PosOffsetY, Seeds.PosOffsetY) or 0) or 0;
                    local v82 = Graphs.PosOffsetZ and (Graph.QueryPointsWithTime(v75, Graphs.PosOffsetZ, Seeds.PosOffsetZ) or 0) or 0;
                    v79 = Vector3.new(v80, v81, v82);
                else
                    v79 = Vector3.new(0, 0, 0);
                end;

                if p60._hasTurb then
                    v79 = v79 + Turbulence.sampleRaw(p60.Graphs.Turbulence, p60.Seeds.Turbulence, p60._turbSeed, p60._turbFreq, LifeTime, v75);
                end;

                if p60._dispMode ~= "Global" then
                    v79 = Anchors.resolveStart(p60).Rotation:VectorToWorldSpace(v79);
                end;

                if p60._hasMotion then
                    v79 = v79 + p60._motionOffset;
                end;

                p60._anchorOffWorld = v79;
            else
                p60._anchorOffWorld = nil;
            end;

            if p60._pinMode == "Launch" then
                if p60._launchArrived then
                    if p60._launchT then
                        local _target = p60._target;

                        if _target and _target.Parent then
                            p60._launchPos = PartConstants.resolveLinkCFrame(_target).Position;
                        end;
                    end;
                elseif p60._launchT and p60._launchT <= v69 then
                    p60._launchArrived = true;
                    local _target = p60._target;

                    if _target and _target.Parent then
                        p60._launchPos = PartConstants.resolveLinkCFrame(_target).Position;
                    end;
                else
                    local v83 = p60._launchVel * v69 + p60._gravity * (0.5 * v69 * v69);

                    if not p60._launchT then
                        local v84 = p60._restLen * p60._segCount;

                        if v84 <= v83.Magnitude then
                            v83 = v83.Unit * v84;
                            p60._launchArrived = true;
                        end;
                    end;

                    p60._launchPos = p60._launchOrigin + v83;
                end;
            end;

            if v71 > 1e-6 then
                p60._windPhase = p60._windPhase + p60._windFreq * v71;
                local _rig = p60._rig;
                local v85 = math.min(v71, VerletSim.SUBSTEP);
                local v86 = p60._accum + v71;
                local v87 = 0;

                while v85 <= v86 and v87 < VerletSim.MAX_SUBSTEPS do
                    Anchors.repin(p60);
                    VerletSim.step(_rig.posBuf, _rig.prevPosBuf, p60._segCount, p60, v85, p60._windPhase);
                    v86 = v86 - v85;
                    v87 = v87 + 1;
                end;

                p60._accum = v87 == VerletSim.MAX_SUBSTEPS and 0 or v86;
                Anchors.repin(p60);
                writeSegments(p60, false);
            end;
        end;

        local v88 = math.max(v69 / LifeTime, 0);
        local v89 = math.min(v88, 1) * p60.TotalKeyFrames;
        local v90 = math.floor(v89);

        if v90 ~= p60.CurrentStep then
            p60.CurrentStep = v90;
            writeVisuals(p60, v90 / p60.TotalKeyFrames);
        end;

        return v70;
    end;

    function u3._refreshRopeAnimate(p91, p92, p93) -- Line: 396
        -- upvalues: buildRig (copy), PDataBuilder (ref), Anchors (ref), Graph (ref), writeSegments (copy), writeVisuals (copy)
        p92.Link = nil;
        local _segCount = p92._segCount;
        local _restLen = p92._restLen;
        local v94 = math.floor((p93.SegmentCount and (p93.SegmentCount.Max or 12) or 12) + 0.5);
        local v95;

        if math.clamp(v94, 2, 48) == p92._rig.segCap or not p93.RenderTemplate then
            v95 = false;
        else
            local VisualPart = p92.VisualPart;
            local v96;

            if VisualPart then
                v96 = VisualPart.Parent;
            else
                v96 = VisualPart;
            end;

            local v97, v98 = buildRig(p93);
            v97:SetAttribute("_PartIcleEmit", true);
            p92.VisualPart = v97;
            p92._rig = v98;
            v97.Parent = v96 or p91:GetFolder();

            if VisualPart then
                pcall(function() -- Line: 412
                    -- upvalues: VisualPart (copy)
                    VisualPart:Destroy();
                end);
                v95 = true;
            else
                v95 = true;
            end;
        end;

        PDataBuilder.readRopeParams(p92, p93, p92._rig);
        p92._accum = 0;
        p92._released = false;
        p92.SkipColor = nil;

        if v95 or (p92._segCount ~= _segCount or math.abs((p92._restLen or 0) - (_restLen or 0)) > 0.0001) then
            Anchors.seedPose(p92);
            p92._launchArrived = false;
            p92._launchPos = nil;
        end;

        p92._curThick = p93.Thickness and Graph.QueryPointsWithTime(0, p93.Thickness, p92.Seeds.Thickness) or p92._curThick;
        writeSegments(p92, false);
        writeVisuals(p92, 0);
    end;
end;