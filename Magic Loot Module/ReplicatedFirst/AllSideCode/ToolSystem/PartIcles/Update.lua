-- Decompiled with Potassium's decompiler.

local Graph = require(script.Parent.Graph);
local PartConstants = require(script.Parent.PartConstants);
local EventsCollision = require(script.Parent.EventsCollision);
local DirectionVectors = PartConstants.DirectionVectors;

local function getLinkCF(p1) -- Line: 14
    -- upvalues: PartConstants (copy)
    local Link = p1.Link;

    if not (Link and Link.Parent) then
        return CFrame.new(), false;
    end;

    local v2;

    if p1.LinkMode == "RigidLocal" then
        v2 = p1._rigidLocalParentCF or CFrame.new();
    else
        v2 = PartConstants.resolveLinkCFrame(Link);
    end;

    if p1.LinkMode == "Follow" or p1.LinkMode == "Pivot" then
        return CFrame.new(v2.Position), false;
    end;

    return v2, true;
end;

local function getAttachmentLinkCF(p3) -- Line: 32
    -- upvalues: PartConstants (copy)
    local Link = p3.Link;

    if not (Link and Link.Parent) then
        return CFrame.new(), false, false;
    end;

    local v4 = p3.VisualPart and p3.VisualPart.Parent;

    if not v4 then
        return CFrame.new(), false, false;
    end;

    local v5;

    if p3.LinkMode == "RigidLocal" then
        v5 = p3._rigidLocalParentCF or CFrame.new();
    else
        v5 = PartConstants.resolveLinkCFrame(Link);
    end;

    local v6 = (v4:IsA("BasePart") and v4.CFrame or CFrame.new()):ToObjectSpace(v5);

    if p3.LinkMode == "Follow" or p3.LinkMode == "Pivot" then
        return CFrame.new(v6.Position), false, true;
    end;

    return v6, true, true;
end;

local function getTargetPosition(p7) -- Line: 53
    if not (p7 and p7.Parent) then
        return nil;
    end;

    if p7:IsA("Bone") then
        return p7.TransformedWorldCFrame.Position;
    end;

    if p7:IsA("BasePart") then
        return p7.Position;
    end;

    if p7:IsA("Attachment") then
        return p7.WorldPosition;
    end;

    if p7:IsA("Camera") then
        return p7.CFrame.Position;
    end;

    if p7:IsA("Model") then
        local success, result = pcall(p7.GetPivot, p7);

        if success and result then
            return result.Position;
        end;
    end;

    return nil;
end;

local function _posOffsetFrameDelta(p8, p9, p10) -- Line: 75
    -- upvalues: Graph (copy), PartConstants (copy)
    if not p8.HasPosOffsetGraphs then
        return Vector3.new(0, 0, 0), false;
    end;

    local v11 = p8._staticPosOffsetX or (p8.Graphs.PosOffsetX and (Graph.QueryPointsWithTime(p9, p8.Graphs.PosOffsetX, p8.Seeds.PosOffsetX) or 0) or 0);
    local v12 = p8._staticPosOffsetY or (p8.Graphs.PosOffsetY and (Graph.QueryPointsWithTime(p9, p8.Graphs.PosOffsetY, p8.Seeds.PosOffsetY) or 0) or 0);
    local v13 = p8._staticPosOffsetZ or (p8.Graphs.PosOffsetZ and (Graph.QueryPointsWithTime(p9, p8.Graphs.PosOffsetZ, p8.Seeds.PosOffsetZ) or 0) or 0);
    local v14 = PartConstants.resolveDisplacement(Vector3.new(v11, v12, v13), p8.DisplacementMode or "Global", p8.SpawnRotation, p8.SpawnEmitterRotation, p8._displacementMirrorX, p8._displacementMirrorY, p8._displacementMirrorZ);
    local v15 = v14 - p8._prevWorldOff;
    p8._prevWorldOff = v14;

    if p10 then
        p10 = (p8.DisplacementMode or "Global") == "Local";
    end;

    return v15, p10;
end;

local function _composeLocalDelta(p16, p17, p18, p19, p20, p21) -- Line: 96
    if p17 then
        return (p16:VectorToObjectSpace(p18) + (p20 and p19 and p19 or p16:VectorToObjectSpace(p19))) * p21;
    end;

    return (p18 + p19) * p21;
end;

return function(p22) -- Line: 103
    -- upvalues: Graph (copy), EventsCollision (copy), PartConstants (copy), getLinkCF (copy), DirectionVectors (copy), getTargetPosition (copy), _posOffsetFrameDelta (copy), getAttachmentLinkCF (copy)
    function p22.UpdatePart(p23, u24, p25, p26) -- Line: 108
        -- upvalues: Graph (ref), EventsCollision (ref), PartConstants (ref), getLinkCF (ref), DirectionVectors (ref), getTargetPosition (ref), _posOffsetFrameDelta (ref)
        local v27 = math.max((p26 - u24.StartTime) / u24.LifeTime, 0);
        local v28 = math.min(v27, 1);
        local v29;

        if u24._tsOverride == nil or p26 >= (u24._tsOverrideUntil or 0) then
            v29 = u24.Graphs.Timescale and (Graph.QueryPointsWithTime(v28, u24.Graphs.Timescale, u24.Seeds.Timescale) or 1) or 1;
        else
            v29 = u24._tsOverride;
        end;

        local v30 = p25 * v29;
        local LifeTime = u24.LifeTime;
        local v31 = u24._effectiveElapsed or 0;
        local v32 = v31 + (u24._timeFrozen and 0 or v30);

        if v30 < 0 and (u24._hitHistory and #u24._hitHistory > 0) then
            EventsCollision.restoreHitsOnReverse(u24, v31, v32);
        end;

        local v33 = v32 < 0 and 0 or v32;

        if LifeTime < v33 then
            v33 = LifeTime;
        end;

        u24._effectiveElapsed = v33;
        local v34 = v33 - v31;
        u24._lastEffectiveDt = v34;
        local v35 = LifeTime <= v33;
        local v36 = v33 <= 0;

        if not (u24.VisualPart and u24.VisualPart.Parent) then
            return true;
        end;

        if u24.TotalKeyFrames <= 0 then
            return true;
        end;

        local v37 = v28 >= 1;

        if u24._collisionStopped then
            if v37 then
                v37 = v35 or v36;
            end;

            return v37;
        end;

        local v38, v39, v40;

        if u24.ParentScale then
            v38 = PartConstants.getParentScaleFactor(u24.ParentScale, p26, Graph);
            v39 = PartConstants.getParentScaleFactor(u24.ParentScale, p26, Graph, "motion");
            v40 = PartConstants.getParentScaleFactor(u24.ParentScale, p26, Graph, "rotation");
        else
            v38 = 1;
            v40 = 1;
            v39 = 1;
        end;

        if v37 then
            v37 = v35 or v36;
        end;

        local v41 = math.max(v33 / LifeTime, 0);
        local v42 = math.min(v41, 1);
        u24.AccumulatedDT = u24.AccumulatedDT + v34;
        local v43 = math.floor(v42 * u24.TotalKeyFrames);

        if v43 ~= u24.CurrentStep then
            local CurrentStep = u24.CurrentStep;
            local v44 = CurrentStep < v43 and 1 or -1;
            local v45 = math.abs(v43 - CurrentStep);
            local v46 = u24.AccumulatedDT / v45;
            local AccumulatedDT = u24.AccumulatedDT;
            u24.AccumulatedDT = 0;
            local _spinRate = u24._spinRate;

            if _spinRate and (_spinRate.X ~= 0 or (_spinRate.Y ~= 0 or _spinRate.Z ~= 0)) then
                u24._spinAccumX = (u24._spinAccumX or 0) + _spinRate.X * AccumulatedDT;
                u24._spinAccumY = (u24._spinAccumY or 0) + _spinRate.Y * AccumulatedDT;
                u24._spinAccumZ = (u24._spinAccumZ or 0) + _spinRate.Z * AccumulatedDT;
            end;

            local v47 = u24.SpeedMultiplier or 1;

            if u24.InvertMotion then
                u24.CurrentStep = v43;
                local v48 = u24.SimLocalCFrames[u24.TotalKeyFrames - v43] or u24.SimLocalCFrames[0];
                local v49 = getLinkCF(u24);
                u24.VisualPart.CFrame = v49 * v48;
                u24._localWorldCF = v48;
                u24.CurrentPosition = u24.VisualPart.Position;
            elseif u24.NeedsFullIteration then
                local HasDrag = u24.HasDrag;
                local HasAccel = u24.HasAccel;
                local v50, v51 = getLinkCF(u24);
                local v52 = DirectionVectors[u24.EmissionDirection] or DirectionVectors[Enum.NormalId.Top];
                local LocalCF = u24.LocalCF;
                local AccRotX = u24.AccRotX;
                local AccRotY = u24.AccRotY;
                local AccRotZ = u24.AccRotZ;
                local BaseDirection = u24.BaseDirection;
                local v53 = u24._accelVel or Vector3.new(0, 0, 0);
                local TargetVel = u24.TargetVel;
                local Position = u24.VisualPart.Position;
                local RotMode = u24.RotMode;
                local v54 = u24.RotOrder or "Global";
                local v55 = nil;
                local v56 = nil;

                for i = CurrentStep + v44, v43, v44 do
                    local v57 = i / u24.TotalKeyFrames;
                    local v58 = v57 * u24.LifeTime;
                    local v59 = u24._speedOverride or (u24._staticSpeed or Graph.QueryPointsWithTime(v57, u24.Graphs.Speed, u24.Seeds.Speed)) * v47;

                    if HasDrag then
                        v59 = v59 * math.exp(-u24.Drag * v58) or v59;
                    end;

                    local v60;

                    if HasAccel then
                        v53 = v53 + PartConstants.applyContactAccel(u24.Acceleration, u24, v46) * v46;
                        v60 = (BaseDirection * v59 + v53) * v46;
                    else
                        v60 = BaseDirection * (v59 * v46);
                    end;

                    if u24.HasTargetAccel then
                        local v61 = getTargetPosition(u24.AccelTarget);

                        if v61 then
                            local v62 = v61 - Position;
                            local Magnitude = v62.Magnitude;

                            if Magnitude > 0.0001 then
                                local v63 = u24._staticAccelStrength or Graph.QueryPointsWithTime(v57, u24.Graphs.AccelStrength, u24.Seeds.AccelStrength);

                                if v63 and v63 ~= 0 then
                                    TargetVel = TargetVel + v62 * (v63 * v46 / Magnitude);
                                    v60 = v60 + TargetVel * v46;
                                end;
                            end;
                        end;
                    end;

                    local v64, v65 = _posOffsetFrameDelta(u24, v57, v51);
                    local v66;

                    if v51 then
                        v66 = (v50:VectorToObjectSpace(v60) + (v65 and v64 and v64 or v50:VectorToObjectSpace(v64))) * v39;
                    else
                        v66 = (v60 + v64) * v39;
                    end;

                    LocalCF = CFrame.new(v66) * LocalCF;
                    local v67 = (u24._settleRotDamp or 1) * v40;
                    local v68 = (u24._staticRotSpeedX or Graph.QueryPointsWithTime(v57, u24.Graphs.RotSpeedX, u24.Seeds.RotSpeedX)) * v67;
                    local v69 = (u24._staticRotSpeedY or Graph.QueryPointsWithTime(v57, u24.Graphs.RotSpeedY, u24.Seeds.RotSpeedY)) * v67;
                    local v70 = (u24._staticRotSpeedZ or Graph.QueryPointsWithTime(v57, u24.Graphs.RotSpeedZ, u24.Seeds.RotSpeedZ)) * v67;
                    local v71 = u24._spinAccumX or 0;
                    local v72 = u24._spinAccumY or 0;
                    local v73 = u24._spinAccumZ or 0;
                    local v74;

                    if RotMode == "Speed" then
                        AccRotX = AccRotX + v68 * v46;
                        AccRotY = AccRotY + v69 * v46;
                        AccRotZ = AccRotZ + v70 * v46;
                        v74 = PartConstants.composeRotation(v54, AccRotX + v71, AccRotY + v72, AccRotZ + v73);
                    else
                        v74 = PartConstants.composeRotation(v54, v68 + v71, v69 + v72, v70 + v73);
                    end;

                    v55 = v50 * LocalCF * v74;
                    v56 = LocalCF * v74;
                    Position = v55.Position;
                    BaseDirection = (v55 * u24.SpreadRotation)[v52.vector] * v52.multiplier;
                end;

                u24.LocalCF = LocalCF;
                u24.AccRotX = AccRotX;
                u24.AccRotY = AccRotY;
                u24.AccRotZ = AccRotZ;
                u24.BaseDirection = BaseDirection;
                u24._accelVel = v53;
                u24.TargetVel = TargetVel;
                u24.CurrentPosition = Position;
                u24.CurrentStep = v43;

                if v55 then
                    u24.VisualPart.CFrame = v55;
                    u24._localWorldCF = v56;
                end;
            elseif u24.NeedsRotAccum then
                local HasDrag = u24.HasDrag;
                local HasAccel = u24.HasAccel;
                local v75 = u24._accelVel or Vector3.new(0, 0, 0);
                local v76 = Vector3.new(0, 0, 0);
                local v77 = 0;

                for i = CurrentStep + v44, v43, v44 do
                    local v78 = i / u24.TotalKeyFrames;
                    local v79 = v78 * u24.LifeTime;
                    local v80 = u24._speedOverride or (u24._staticSpeed or Graph.QueryPointsWithTime(v78, u24.Graphs.Speed, u24.Seeds.Speed)) * v47;

                    if HasDrag then
                        v80 = v80 * math.exp(-u24.Drag * v79);
                    end;

                    v77 = v77 + v80 * v46;

                    if HasAccel then
                        v75 = v75 + PartConstants.applyContactAccel(u24.Acceleration, u24, v46) * v46;
                        v76 = v76 + v75 * v46;
                    end;

                    local v81 = (u24._settleRotDamp or 1) * v40;
                    local v82 = (u24._staticRotSpeedX or Graph.QueryPointsWithTime(v78, u24.Graphs.RotSpeedX, u24.Seeds.RotSpeedX)) * v81;
                    local v83 = (u24._staticRotSpeedY or Graph.QueryPointsWithTime(v78, u24.Graphs.RotSpeedY, u24.Seeds.RotSpeedY)) * v81;
                    local v84 = (u24._staticRotSpeedZ or Graph.QueryPointsWithTime(v78, u24.Graphs.RotSpeedZ, u24.Seeds.RotSpeedZ)) * v81;
                    u24.AccRotX = u24.AccRotX + v82 * v46;
                    u24.AccRotY = u24.AccRotY + v83 * v46;
                    u24.AccRotZ = u24.AccRotZ + v84 * v46;
                end;

                u24._accelVel = v75;
                local v85 = u24.BaseDirection * v77 + v76;

                if u24.HasTargetAccel then
                    local v86 = getTargetPosition(u24.AccelTarget);

                    if v86 then
                        local v87 = v86 - u24.VisualPart.Position;
                        local Magnitude = v87.Magnitude;

                        if Magnitude > 0.0001 then
                            local v88 = v46 * (v43 - CurrentStep);
                            local v89 = u24._staticAccelStrength or Graph.QueryPointsWithTime((CurrentStep + 1 + v43) * 0.5 / u24.TotalKeyFrames, u24.Graphs.AccelStrength, u24.Seeds.AccelStrength);

                            if v89 and v89 ~= 0 then
                                u24.TargetVel = u24.TargetVel + v87 * (v89 * v88 / Magnitude);
                                v85 = v85 + u24.TargetVel * v88;
                            end;
                        end;
                    end;
                end;

                local v90, v91 = getLinkCF(u24);
                local v92, v93 = _posOffsetFrameDelta(u24, v43 / u24.TotalKeyFrames, v91);
                local v94;

                if v91 then
                    v94 = (v90:VectorToObjectSpace(v85) + (v93 and v92 and v92 or v90:VectorToObjectSpace(v92))) * v39;
                else
                    v94 = (v85 + v92) * v39;
                end;

                u24.LocalCF = CFrame.new(v94) * u24.LocalCF;
                local v95 = PartConstants.composeRotation(u24.RotOrder or "Global", u24.AccRotX + (u24._spinAccumX or 0), u24.AccRotY + (u24._spinAccumY or 0), u24.AccRotZ + (u24._spinAccumZ or 0));
                u24.VisualPart.CFrame = v90 * u24.LocalCF * v95;
                u24._localWorldCF = u24.LocalCF * v95;
                u24.CurrentPosition = u24.VisualPart.Position;
                u24.CurrentStep = v43;
            else
                local HasAccel = u24.HasAccel;
                local v96 = 0;
                local v97 = Vector3.new(0, 0, 0);
                local v98 = u24._accelVel or Vector3.new(0, 0, 0);

                if u24.HasDrag then
                    for i = CurrentStep + v44, v43, v44 do
                        local v99 = i / u24.TotalKeyFrames;
                        local v100 = v99 * u24.LifeTime;
                        v96 = v96 + (u24._speedOverride or (u24._staticSpeed or Graph.QueryPointsWithTime(v99, u24.Graphs.Speed, u24.Seeds.Speed)) * v47) * math.exp(-u24.Drag * v100) * v46;

                        if HasAccel then
                            v98 = v98 + PartConstants.applyContactAccel(u24.Acceleration, u24, v46) * v46;
                            v97 = v97 + v98 * v46;
                        end;
                    end;
                else
                    local v101 = 1 / u24.TotalKeyFrames;
                    local v102 = CurrentStep * v101;
                    local v103 = v43 * v101;
                    local _speedOverride = u24._speedOverride;

                    if _speedOverride then
                        v96 = _speedOverride * (v103 - v102) * u24.LifeTime;
                    elseif u24._staticSpeed then
                        v96 = u24._staticSpeed * v47 * (v103 - v102) * u24.LifeTime;
                    else
                        v96 = u24.LifeTime * v47 * (Graph.IntegrateUpTo(v103, u24.Graphs.Speed, u24.Seeds.Speed) - Graph.IntegrateUpTo(v102, u24.Graphs.Speed, u24.Seeds.Speed));
                    end;

                    if HasAccel then
                        local v104 = (v103 - v102) * u24.LifeTime;
                        local v105 = PartConstants.applyContactAccel(u24.Acceleration, u24, v104);
                        v97 = v98 * v104 + v105 * (v104 * v104 * 0.5);
                        v98 = v98 + v105 * v104;
                    end;
                end;

                u24._accelVel = v98;
                local v106 = u24.BaseDirection * v96 + v97;

                if u24.HasTargetAccel then
                    local v107 = getTargetPosition(u24.AccelTarget);

                    if v107 then
                        local v108 = v107 - u24.VisualPart.Position;
                        local Magnitude = v108.Magnitude;

                        if Magnitude > 0.0001 then
                            local v109 = v46 * (v43 - CurrentStep);
                            local v110 = u24._staticAccelStrength or Graph.QueryPointsWithTime((CurrentStep + 1 + v43) * 0.5 / u24.TotalKeyFrames, u24.Graphs.AccelStrength, u24.Seeds.AccelStrength);

                            if v110 and v110 ~= 0 then
                                u24.TargetVel = u24.TargetVel + v108 * (v110 * v109 / Magnitude);
                                v106 = v106 + u24.TargetVel * v109;
                            end;
                        end;
                    end;
                end;

                local v111, v112 = getLinkCF(u24);
                local v113, v114 = _posOffsetFrameDelta(u24, v43 / u24.TotalKeyFrames, v112);
                local v115;

                if v112 then
                    v115 = (v111:VectorToObjectSpace(v106) + (v114 and v113 and v113 or v111:VectorToObjectSpace(v113))) * v39;
                else
                    v115 = (v106 + v113) * v39;
                end;

                u24.LocalCF = CFrame.new(v115) * u24.LocalCF;
                local v116 = v43 / u24.TotalKeyFrames;
                local v117 = (u24._settleRotDamp or 1) * v40;
                local v118 = (u24._staticRotSpeedX or Graph.QueryPointsWithTime(v116, u24.Graphs.RotSpeedX, u24.Seeds.RotSpeedX)) * v117 + (u24._spinAccumX or 0);
                local v119 = (u24._staticRotSpeedY or Graph.QueryPointsWithTime(v116, u24.Graphs.RotSpeedY, u24.Seeds.RotSpeedY)) * v117 + (u24._spinAccumY or 0);
                local v120 = u24._staticRotSpeedZ or Graph.QueryPointsWithTime(v116, u24.Graphs.RotSpeedZ, u24.Seeds.RotSpeedZ);
                local v121 = PartConstants.composeRotation(u24.RotOrder or "Global", v118, v119, v120 * v117 + (u24._spinAccumZ or 0));
                u24.VisualPart.CFrame = v111 * u24.LocalCF * v121;
                u24._localWorldCF = u24.LocalCF * v121;
                u24.CurrentPosition = u24.VisualPart.Position;
                u24.CurrentStep = v43;
            end;

            local v122 = v43 / u24.TotalKeyFrames;

            if not u24.SkipSize then
                local v123 = u24._staticSizeX or Graph.QueryPointsWithTime(v122, u24.Graphs.SizeX, u24.Seeds.SizeX);
                local v124 = u24._staticSizeY or Graph.QueryPointsWithTime(v122, u24.Graphs.SizeY, u24.Seeds.SizeY);
                local v125 = u24._staticSizeZ or Graph.QueryPointsWithTime(v122, u24.Graphs.SizeZ, u24.Seeds.SizeZ);

                if v38 ~= 1 then
                    v123 = v123 * v38;
                    v124 = v124 * v38;
                    v125 = v125 * v38;
                end;

                if u24.SpecialMesh then
                    u24.SpecialMesh.Scale = Vector3.new(v123, v124, v125);
                else
                    u24.VisualPart.Size = Vector3.new(v123, v124, v125);
                end;
            end;

            local v126 = u24._staticTransparency or Graph.QueryPointsWithTime(v122, u24.Graphs.Transparency, u24.Seeds.Transparency);

            if u24.SurfaceAppearance then
                local u127 = u24._staticBrightness or Graph.QueryPointsWithTime(v122, u24.Graphs.Brightness, u24.Seeds.Brightness);
                local u128 = Graph.QueryColorPointWithTime(v122, u24.Graphs.Color);

                if not u24.SkipTransparency then
                    u24.VisualPart.Transparency = v126;
                end;

                if not u24.SkipColor then
                    u24.VisualPart.Color = Color3.fromRGB(u128.R * 255, u128.G * 255, u128.B * 255);
                    u24.SurfaceAppearance.Color = Color3.fromRGB(u128.R * 255, u128.G * 255, u128.B * 255);
                    pcall(function() -- Line: 466
                        -- upvalues: u24 (copy), u128 (copy), u127 (copy)
                        u24.SurfaceAppearance.EmissiveTint = Color3.new(u128.R * u127, u128.G * u127, u128.B * u127);
                    end);

                    return v37;
                end;
            elseif u24.HasDecal then
                local v129 = u24._staticBrightness or Graph.QueryPointsWithTime(v122, u24.Graphs.Brightness, u24.Seeds.Brightness);
                local v130 = Graph.QueryColorPointWithTime(v122, u24.Graphs.Color);

                if not u24.SkipTransparency then
                    u24.Decal.Transparency = v126;
                end;

                if not u24.SkipColor then
                    u24.Decal.Color3 = Color3.fromRGB(v130.R * 255 * v129, v130.G * 255 * v129, v130.B * 255 * v129);

                    return v37;
                end;
            else
                local v131 = Graph.QueryColorPointWithTime(v122, u24.Graphs.Color);

                if not u24.SkipTransparency then
                    u24.VisualPart.Transparency = v126;
                end;

                if not u24.SkipColor then
                    u24.VisualPart.Color = Color3.fromRGB(v131.R * 255, v131.G * 255, v131.B * 255);
                end;
            end;
        end;

        return v37;
    end;

    function p22.UpdateAttachment(p132, p133, p134, p135) -- Line: 485
        -- upvalues: Graph (ref), EventsCollision (ref), PartConstants (ref), getAttachmentLinkCF (ref), _posOffsetFrameDelta (ref), DirectionVectors (ref)
        local v136 = math.max((p135 - p133.StartTime) / p133.LifeTime, 0);
        local v137 = math.min(v136, 1);
        local v138;

        if p133._tsOverride == nil or p135 >= (p133._tsOverrideUntil or 0) then
            v138 = p133.Graphs.Timescale and (Graph.QueryPointsWithTime(v137, p133.Graphs.Timescale, p133.Seeds.Timescale) or 1) or 1;
        else
            v138 = p133._tsOverride;
        end;

        local v139 = p134 * v138;
        local LifeTime = p133.LifeTime;
        local v140 = p133._effectiveElapsed or 0;
        local v141 = v140 + (p133._timeFrozen and 0 or v139);

        if v139 < 0 and (p133._hitHistory and #p133._hitHistory > 0) then
            EventsCollision.restoreHitsOnReverse(p133, v140, v141);
        end;

        local v142 = v141 < 0 and 0 or v141;

        if LifeTime < v142 then
            v142 = LifeTime;
        end;

        p133._effectiveElapsed = v142;
        local v143 = v142 - v140;
        p133._lastEffectiveDt = v143;
        local v144 = LifeTime <= v142;
        local v145 = v142 <= 0;

        if not (p133.VisualPart and p133.VisualPart.Parent) then
            return true;
        end;

        if p133.TotalKeyFrames <= 0 then
            return true;
        end;

        local v146 = v137 >= 1;

        if p133._collisionStopped then
            if v146 then
                v146 = v144 or v145;
            end;

            return v146;
        end;

        local v147, v148;

        if p133.ParentScale then
            PartConstants.getParentScaleFactor(p133.ParentScale, p135, Graph);
            v147 = PartConstants.getParentScaleFactor(p133.ParentScale, p135, Graph, "motion");
            v148 = PartConstants.getParentScaleFactor(p133.ParentScale, p135, Graph, "rotation");
        else
            v147 = 1;
            v148 = 1;
        end;

        if v146 then
            v146 = v144 or v145;
        end;

        local v149 = math.max(v142 / LifeTime, 0);
        local v150 = math.min(v149, 1);
        p133.AccumulatedDT = p133.AccumulatedDT + v143;
        local v151 = math.floor(v150 * p133.TotalKeyFrames);

        if v151 ~= p133.CurrentStep then
            local CurrentStep = p133.CurrentStep;
            local v152 = CurrentStep < v151 and 1 or -1;
            local v153 = math.abs(v151 - CurrentStep);
            local v154 = p133.AccumulatedDT / v153;
            local AccumulatedDT = p133.AccumulatedDT;
            p133.AccumulatedDT = 0;
            local _spinRate = p133._spinRate;

            if _spinRate and (_spinRate.X ~= 0 or (_spinRate.Y ~= 0 or _spinRate.Z ~= 0)) then
                p133._spinAccumX = (p133._spinAccumX or 0) + _spinRate.X * AccumulatedDT;
                p133._spinAccumY = (p133._spinAccumY or 0) + _spinRate.Y * AccumulatedDT;
                p133._spinAccumZ = (p133._spinAccumZ or 0) + _spinRate.Z * AccumulatedDT;
            end;

            local v155 = p133.SpeedMultiplier or 1;
            local v156, v157 = getAttachmentLinkCF(p133);

            if p133.InvertMotion then
                p133.CurrentStep = v151;
                local v158 = p133.SimLocalCFrames[p133.TotalKeyFrames - v151] or p133.SimLocalCFrames[0];
                p133.VisualPart.CFrame = v156 * v158;
                p133.LocalCF = v158;
                p133._localWorldCF = v158;

                return v146;
            end;

            if p133.NeedsFullIteration then
                local HasDrag = p133.HasDrag;
                local HasAccel = p133.HasAccel;
                local v159 = p133._accelVel or Vector3.new(0, 0, 0);
                local v160 = p133._spinAccumX or 0;
                local v161 = p133._spinAccumY or 0;
                local v162 = p133._spinAccumZ or 0;
                local v163 = p133.RotOrder or "Global";

                for i = CurrentStep + v152, v151, v152 do
                    local v164 = i / p133.TotalKeyFrames;
                    local v165 = v164 * p133.LifeTime;
                    local v166 = p133._speedOverride or (p133._staticSpeed or Graph.QueryPointsWithTime(v164, p133.Graphs.Speed, p133.Seeds.Speed)) * v155;

                    if HasDrag then
                        v166 = v166 * math.exp(-p133.Drag * v165) or v166;
                    end;

                    local v167;

                    if HasAccel then
                        v159 = v159 + PartConstants.applyContactAccel(p133.Acceleration, p133, v154) * v154;
                        v167 = (p133.BaseDirection * v166 + v159) * v154;
                    else
                        v167 = p133.BaseDirection * (v166 * v154);
                    end;

                    local v168, v169 = _posOffsetFrameDelta(p133, v164, v157);
                    local v170;

                    if v157 then
                        v170 = (v156:VectorToObjectSpace(v167) + (v169 and v168 and v168 or v156:VectorToObjectSpace(v168))) * v147;
                    else
                        v170 = (v167 + v168) * v147;
                    end;

                    p133.LocalCF = CFrame.new(v170) * p133.LocalCF;
                    local v171 = (p133._settleRotDamp or 1) * v148;
                    local v172 = (p133._staticRotSpeedX or Graph.QueryPointsWithTime(v164, p133.Graphs.RotSpeedX, p133.Seeds.RotSpeedX)) * v171;
                    local v173 = (p133._staticRotSpeedY or Graph.QueryPointsWithTime(v164, p133.Graphs.RotSpeedY, p133.Seeds.RotSpeedY)) * v171;
                    local v174 = (p133._staticRotSpeedZ or Graph.QueryPointsWithTime(v164, p133.Graphs.RotSpeedZ, p133.Seeds.RotSpeedZ)) * v171;
                    local v175;

                    if p133.RotMode == "Speed" then
                        p133.AccRotX = p133.AccRotX + v172 * v154;
                        p133.AccRotY = p133.AccRotY + v173 * v154;
                        p133.AccRotZ = p133.AccRotZ + v174 * v154;
                        v175 = PartConstants.composeRotation(v163, p133.AccRotX + v160, p133.AccRotY + v161, p133.AccRotZ + v162);
                    else
                        v175 = PartConstants.composeRotation(v163, v172 + v160, v173 + v161, v174 + v162);
                    end;

                    p133.VisualPart.CFrame = v156 * p133.LocalCF * v175;
                    p133._localWorldCF = p133.LocalCF * v175;
                    local v176 = DirectionVectors[p133.EmissionDirection] or DirectionVectors[Enum.NormalId.Top];
                    p133.BaseDirection = (p133.VisualPart.CFrame * p133.SpreadRotation)[v176.vector] * v176.multiplier;
                end;

                p133._accelVel = v159;
                p133.CurrentStep = v151;

                return v146;
            end;

            if p133.NeedsRotAccum then
                local HasDrag = p133.HasDrag;
                local HasAccel = p133.HasAccel;
                local v177 = p133._accelVel or Vector3.new(0, 0, 0);
                local v178 = Vector3.new(0, 0, 0);
                local v179 = 0;

                for i = CurrentStep + v152, v151, v152 do
                    local v180 = i / p133.TotalKeyFrames;
                    local v181 = v180 * p133.LifeTime;
                    local v182 = p133._speedOverride or (p133._staticSpeed or Graph.QueryPointsWithTime(v180, p133.Graphs.Speed, p133.Seeds.Speed)) * v155;

                    if HasDrag then
                        v182 = v182 * math.exp(-p133.Drag * v181);
                    end;

                    v179 = v179 + v182 * v154;

                    if HasAccel then
                        v177 = v177 + PartConstants.applyContactAccel(p133.Acceleration, p133, v154) * v154;
                        v178 = v178 + v177 * v154;
                    end;

                    local v183 = (p133._settleRotDamp or 1) * v148;
                    local v184 = (p133._staticRotSpeedX or Graph.QueryPointsWithTime(v180, p133.Graphs.RotSpeedX, p133.Seeds.RotSpeedX)) * v183;
                    local v185 = (p133._staticRotSpeedY or Graph.QueryPointsWithTime(v180, p133.Graphs.RotSpeedY, p133.Seeds.RotSpeedY)) * v183;
                    local v186 = (p133._staticRotSpeedZ or Graph.QueryPointsWithTime(v180, p133.Graphs.RotSpeedZ, p133.Seeds.RotSpeedZ)) * v183;
                    p133.AccRotX = p133.AccRotX + v184 * v154;
                    p133.AccRotY = p133.AccRotY + v185 * v154;
                    p133.AccRotZ = p133.AccRotZ + v186 * v154;
                end;

                p133._accelVel = v177;
                local v187 = p133.BaseDirection * v179 + v178;
                local v188, v189 = _posOffsetFrameDelta(p133, v151 / p133.TotalKeyFrames, v157);
                local v190;

                if v157 then
                    v190 = (v156:VectorToObjectSpace(v187) + (v189 and v188 and v188 or v156:VectorToObjectSpace(v188))) * v147;
                else
                    v190 = (v187 + v188) * v147;
                end;

                p133.LocalCF = CFrame.new(v190) * p133.LocalCF;
                local v191 = PartConstants.composeRotation(p133.RotOrder or "Global", p133.AccRotX + (p133._spinAccumX or 0), p133.AccRotY + (p133._spinAccumY or 0), p133.AccRotZ + (p133._spinAccumZ or 0));
                p133.VisualPart.CFrame = v156 * p133.LocalCF * v191;
                p133._localWorldCF = p133.LocalCF * v191;
                p133.CurrentStep = v151;

                return v146;
            end;

            local HasAccel = p133.HasAccel;
            local v192 = 0;
            local v193 = Vector3.new(0, 0, 0);
            local v194 = p133._accelVel or Vector3.new(0, 0, 0);

            if p133.HasDrag then
                for i = CurrentStep + v152, v151, v152 do
                    local v195 = i / p133.TotalKeyFrames;
                    local v196 = v195 * p133.LifeTime;
                    v192 = v192 + (p133._speedOverride or (p133._staticSpeed or Graph.QueryPointsWithTime(v195, p133.Graphs.Speed, p133.Seeds.Speed)) * v155) * math.exp(-p133.Drag * v196) * v154;

                    if HasAccel then
                        v194 = v194 + PartConstants.applyContactAccel(p133.Acceleration, p133, v154) * v154;
                        v193 = v193 + v194 * v154;
                    end;
                end;
            else
                local v197 = 1 / p133.TotalKeyFrames;
                local v198 = CurrentStep * v197;
                local v199 = v151 * v197;
                local _speedOverride = p133._speedOverride;

                if _speedOverride then
                    v192 = _speedOverride * (v199 - v198) * p133.LifeTime;
                elseif p133._staticSpeed then
                    v192 = p133._staticSpeed * v155 * (v199 - v198) * p133.LifeTime;
                else
                    v192 = p133.LifeTime * v155 * (Graph.IntegrateUpTo(v199, p133.Graphs.Speed, p133.Seeds.Speed) - Graph.IntegrateUpTo(v198, p133.Graphs.Speed, p133.Seeds.Speed));
                end;

                if HasAccel then
                    local v200 = (v199 - v198) * p133.LifeTime;
                    local v201 = PartConstants.applyContactAccel(p133.Acceleration, p133, v200);
                    v193 = v194 * v200 + v201 * (v200 * v200 * 0.5);
                    v194 = v194 + v201 * v200;
                end;
            end;

            p133._accelVel = v194;
            local v202 = p133.BaseDirection * v192 + v193;
            local v203, v204 = _posOffsetFrameDelta(p133, v151 / p133.TotalKeyFrames, v157);
            local v205;

            if v157 then
                v205 = (v156:VectorToObjectSpace(v202) + (v204 and v203 and v203 or v156:VectorToObjectSpace(v203))) * v147;
            else
                v205 = (v202 + v203) * v147;
            end;

            p133.LocalCF = CFrame.new(v205) * p133.LocalCF;
            local v206 = v151 / p133.TotalKeyFrames;
            local v207 = (p133._settleRotDamp or 1) * v148;
            local v208 = (p133._staticRotSpeedX or Graph.QueryPointsWithTime(v206, p133.Graphs.RotSpeedX, p133.Seeds.RotSpeedX)) * v207 + (p133._spinAccumX or 0);
            local v209 = (p133._staticRotSpeedY or Graph.QueryPointsWithTime(v206, p133.Graphs.RotSpeedY, p133.Seeds.RotSpeedY)) * v207 + (p133._spinAccumY or 0);
            local v210 = p133._staticRotSpeedZ or Graph.QueryPointsWithTime(v206, p133.Graphs.RotSpeedZ, p133.Seeds.RotSpeedZ);
            local v211 = PartConstants.composeRotation(p133.RotOrder or "Global", v208, v209, v210 * v207 + (p133._spinAccumZ or 0));
            p133.VisualPart.CFrame = v156 * p133.LocalCF * v211;
            p133._localWorldCF = p133.LocalCF * v211;
            p133.CurrentStep = v151;
        end;

        return v146;
    end;
end;