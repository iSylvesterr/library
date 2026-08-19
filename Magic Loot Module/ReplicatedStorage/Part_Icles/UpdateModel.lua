-- Decompiled with Potassium's decompiler.

local Graph = require(script.Parent.Graph);
local PartConstants = require(script.Parent.PartConstants);
local EventsCollision = require(script.Parent.EventsCollision);
local Turbulence = require(script.Parent.Turbulence);
local DirectionVectors = PartConstants.DirectionVectors;

local function _posOffsetFrameDelta(p1, p2) -- Line: 16
    -- upvalues: Graph (copy), PartConstants (copy), Turbulence (copy)
    if not (p1.HasPosOffsetGraphs or p1.HasTurbulence) then
        return Vector3.new(0, 0, 0);
    end;

    local v3;

    if p1.HasPosOffsetGraphs then
        local v4 = p1._staticPosOffsetX or (p1.Graphs.PosOffsetX and (Graph.QueryPointsWithTime(p2, p1.Graphs.PosOffsetX, p1.Seeds.PosOffsetX) or 0) or 0);
        local v5 = p1._staticPosOffsetY or (p1.Graphs.PosOffsetY and (Graph.QueryPointsWithTime(p2, p1.Graphs.PosOffsetY, p1.Seeds.PosOffsetY) or 0) or 0);
        local v6 = p1._staticPosOffsetZ or (p1.Graphs.PosOffsetZ and (Graph.QueryPointsWithTime(p2, p1.Graphs.PosOffsetZ, p1.Seeds.PosOffsetZ) or 0) or 0);
        local v7 = PartConstants.resolveDisplacement(Vector3.new(v4, v5, v6), p1.DisplacementMode or "Global", p1.SpawnRotation, p1.SpawnEmitterRotation, p1._displacementMirrorX, p1._displacementMirrorY, p1._displacementMirrorZ);
        v3 = v7 - p1._prevWorldOff;
        p1._prevWorldOff = v7;
    else
        v3 = Vector3.new(0, 0, 0);
    end;

    if p1.HasTurbulence then
        v3 = v3 + Turbulence.frameDelta(p1, p2);
    end;

    return v3;
end;

local function getLinkCF(p8) -- Line: 38
    -- upvalues: PartConstants (copy)
    local Link = p8.Link;

    if not (Link and Link.Parent) then
        return CFrame.new(), false;
    end;

    local v9;

    if p8.LinkMode == "RigidLocal" then
        v9 = p8._rigidLocalParentCF or CFrame.new();
    else
        v9 = PartConstants.resolveLinkCFrame(Link);
    end;

    if p8.LinkMode == "Follow" or p8.LinkMode == "Pivot" then
        return CFrame.new(v9.Position), false;
    end;

    return v9, true;
end;

return function(p10) -- Line: 53
    -- upvalues: Graph (copy), EventsCollision (copy), getLinkCF (copy), PartConstants (copy), _posOffsetFrameDelta (copy), DirectionVectors (copy)
    function p10.UpdateModel(p11, p12, p13, p14) -- Line: 58
        -- upvalues: Graph (ref), EventsCollision (ref), getLinkCF (ref), PartConstants (ref), _posOffsetFrameDelta (ref), DirectionVectors (ref)
        local v15 = math.max((p14 - p12.StartTime) / p12.LifeTime, 0);
        local v16 = math.min(v15, 1);
        local v17;

        if p12._tsOverride == nil or p14 >= (p12._tsOverrideUntil or 0) then
            v17 = p12.Graphs.Timescale and (Graph.QueryPointsWithTime(v16, p12.Graphs.Timescale, p12.Seeds.Timescale) or 1) or 1;
        else
            v17 = p12._tsOverride;
        end;

        local v18 = p13 * v17;
        local LifeTime = p12.LifeTime;
        local v19 = p12._effectiveElapsed or 0;
        local v20 = v19 + (p12._timeFrozen and 0 or v18);

        if v18 < 0 and (p12._hitHistory and #p12._hitHistory > 0) then
            EventsCollision.restoreHitsOnReverse(p12, v19, v20);
        end;

        local v21 = v20 < 0 and 0 or v20;

        if LifeTime < v21 then
            v21 = LifeTime;
        end;

        p12._effectiveElapsed = v21;
        local v22 = v21 - v19;
        p12._lastEffectiveDt = v22;
        local v23 = LifeTime <= v21;
        local v24 = v21 <= 0;

        if not (p12.VisualPart and p12.VisualPart.Parent) then
            return true;
        end;

        if p12.TotalKeyFrames <= 0 then
            return true;
        end;

        local v25 = v16 >= 1;

        if p12._collisionStopped then
            if v25 then
                v25 = v23 or v24;
            end;

            return v25;
        end;

        if v25 then
            v25 = v23 or v24;
        end;

        local v26 = math.max(v21 / LifeTime, 0);
        local v27 = math.min(v26, 1);
        p12.AccumulatedDT = p12.AccumulatedDT + v22;
        local v28 = math.floor(v27 * p12.TotalKeyFrames);

        if v28 ~= p12.CurrentStep then
            local CurrentStep = p12.CurrentStep;
            local v29 = CurrentStep < v28 and 1 or -1;
            local v30 = math.abs(v28 - CurrentStep);
            local AccumulatedDT = p12.AccumulatedDT;
            local v31 = AccumulatedDT / v30;
            p12.AccumulatedDT = 0;
            local _spinRate = p12._spinRate;

            if _spinRate and (_spinRate.X ~= 0 or (_spinRate.Y ~= 0 or _spinRate.Z ~= 0)) then
                p12._spinAccumX = (p12._spinAccumX or 0) + _spinRate.X * AccumulatedDT;
                p12._spinAccumY = (p12._spinAccumY or 0) + _spinRate.Y * AccumulatedDT;
                p12._spinAccumZ = (p12._spinAccumZ or 0) + _spinRate.Z * AccumulatedDT;
            end;

            local v32 = p12.SpeedMultiplier or 1;
            local v33 = p12._spinAccumX or 0;
            local v34 = p12._spinAccumY or 0;
            local v35 = p12._spinAccumZ or 0;
            local v36 = p12.RotOrder or "Global";

            if p12.InvertMotion then
                p12.CurrentStep = v28;
                local v37 = p12.SimLocalCFrames[p12.TotalKeyFrames - v28] or p12.SimLocalCFrames[0];
                local v38 = getLinkCF(p12);
                p12.VisualPart:PivotTo(v38 * v37);
                p12._localWorldCF = v37;
                p12.CurrentPosition = p12.VisualPart:GetPivot().Position;
            elseif p12.NeedsFullIteration then
                local HasDrag = p12.HasDrag;
                local HasAccel = p12.HasAccel;
                local v39 = p12._accelVel or Vector3.new(0, 0, 0);

                for i = CurrentStep + v29, v28, v29 do
                    local v40 = i / p12.TotalKeyFrames;
                    local v41 = v40 * p12.LifeTime;
                    local v42 = p12._speedOverride or (p12._staticSpeed or Graph.QueryPointsWithTime(v40, p12.Graphs.Speed, p12.Seeds.Speed)) * v32;

                    if HasDrag then
                        v42 = v42 * math.exp(-p12.Drag * v41) or v42;
                    end;

                    local v43;

                    if HasAccel then
                        v39 = v39 + PartConstants.applyContactAccel(p12.Acceleration, p12, v31) * v31;
                        v43 = (p12.BaseDirection * v42 + v39) * v31;
                    else
                        v43 = p12.BaseDirection * (v42 * v31);
                    end;

                    local v44 = v43 + _posOffsetFrameDelta(p12, v40);
                    local v45, v46 = getLinkCF(p12);

                    if v46 then
                        v44 = v45:VectorToObjectSpace(v44) or v44;
                    end;

                    p12.LocalCF = CFrame.new(v44) * p12.LocalCF;
                    local v47 = p12._settleRotDamp or 1;
                    local v48 = (p12._staticRotSpeedX or Graph.QueryPointsWithTime(v40, p12.Graphs.RotSpeedX, p12.Seeds.RotSpeedX)) * v47;
                    local v49 = (p12._staticRotSpeedY or Graph.QueryPointsWithTime(v40, p12.Graphs.RotSpeedY, p12.Seeds.RotSpeedY)) * v47;
                    local v50 = (p12._staticRotSpeedZ or Graph.QueryPointsWithTime(v40, p12.Graphs.RotSpeedZ, p12.Seeds.RotSpeedZ)) * v47;
                    local v51;

                    if p12.RotMode == "Speed" then
                        p12.AccRotX = p12.AccRotX + v48 * v31;
                        p12.AccRotY = p12.AccRotY + v49 * v31;
                        p12.AccRotZ = p12.AccRotZ + v50 * v31;
                        v51 = PartConstants.composeRotation(v36, p12.AccRotX + v33, p12.AccRotY + v34, p12.AccRotZ + v35);
                    else
                        v51 = PartConstants.composeRotation(v36, v48 + v33, v49 + v34, v50 + v35);
                    end;

                    p12.VisualPart:PivotTo(v45 * p12.LocalCF * v51);
                    p12._localWorldCF = p12.LocalCF * v51;
                    p12.CurrentPosition = p12.VisualPart:GetPivot().Position;
                    local v52 = p12.VisualPart:GetPivot() * p12.SpreadRotation;
                    local v53 = DirectionVectors[p12.EmissionDirection] or DirectionVectors[Enum.NormalId.Top];
                    p12.BaseDirection = v52[v53.vector] * v53.multiplier;
                end;

                p12._accelVel = v39;
                p12.CurrentStep = v28;
            elseif p12.NeedsRotAccum then
                local HasDrag = p12.HasDrag;
                local HasAccel = p12.HasAccel;
                local v54 = p12._accelVel or Vector3.new(0, 0, 0);
                local v55 = Vector3.new(0, 0, 0);
                local v56 = 0;

                for i = CurrentStep + v29, v28, v29 do
                    local v57 = i / p12.TotalKeyFrames;
                    local v58 = v57 * p12.LifeTime;
                    local v59 = p12._speedOverride or (p12._staticSpeed or Graph.QueryPointsWithTime(v57, p12.Graphs.Speed, p12.Seeds.Speed)) * v32;

                    if HasDrag then
                        v59 = v59 * math.exp(-p12.Drag * v58);
                    end;

                    v56 = v56 + v59 * v31;

                    if HasAccel then
                        v54 = v54 + PartConstants.applyContactAccel(p12.Acceleration, p12, v31) * v31;
                        v55 = v55 + v54 * v31;
                    end;

                    local v60 = p12._settleRotDamp or 1;
                    local v61 = (p12._staticRotSpeedX or Graph.QueryPointsWithTime(v57, p12.Graphs.RotSpeedX, p12.Seeds.RotSpeedX)) * v60;
                    local v62 = (p12._staticRotSpeedY or Graph.QueryPointsWithTime(v57, p12.Graphs.RotSpeedY, p12.Seeds.RotSpeedY)) * v60;
                    local v63 = (p12._staticRotSpeedZ or Graph.QueryPointsWithTime(v57, p12.Graphs.RotSpeedZ, p12.Seeds.RotSpeedZ)) * v60;
                    p12.AccRotX = p12.AccRotX + v61 * v31;
                    p12.AccRotY = p12.AccRotY + v62 * v31;
                    p12.AccRotZ = p12.AccRotZ + v63 * v31;
                end;

                p12._accelVel = v54;
                local v64 = p12.BaseDirection * v56 + v55 + _posOffsetFrameDelta(p12, v28 / p12.TotalKeyFrames);
                local v65, v66 = getLinkCF(p12);

                if v66 then
                    v64 = v65:VectorToObjectSpace(v64) or v64;
                end;

                p12.LocalCF = CFrame.new(v64) * p12.LocalCF;
                local v67 = PartConstants.composeRotation(v36, p12.AccRotX + v33, p12.AccRotY + v34, p12.AccRotZ + v35);
                p12.VisualPart:PivotTo(v65 * p12.LocalCF * v67);
                p12._localWorldCF = p12.LocalCF * v67;
                p12.CurrentPosition = p12.VisualPart:GetPivot().Position;
                p12.CurrentStep = v28;
            else
                local HasDrag = p12.HasDrag;
                local HasAccel = p12.HasAccel;
                local v68 = p12._accelVel or Vector3.new(0, 0, 0);
                local v69 = Vector3.new(0, 0, 0);
                local v70 = 0;

                for i = CurrentStep + v29, v28, v29 do
                    local v71 = i / p12.TotalKeyFrames;
                    local v72 = v71 * p12.LifeTime;
                    local v73 = p12._speedOverride or (p12._staticSpeed or Graph.QueryPointsWithTime(v71, p12.Graphs.Speed, p12.Seeds.Speed)) * v32;

                    if HasDrag then
                        v73 = v73 * math.exp(-p12.Drag * v72);
                    end;

                    v70 = v70 + v73 * v31;

                    if HasAccel then
                        v68 = v68 + PartConstants.applyContactAccel(p12.Acceleration, p12, v31) * v31;
                        v69 = v69 + v68 * v31;
                    end;
                end;

                p12._accelVel = v68;
                local v74 = p12.BaseDirection * v70 + v69 + _posOffsetFrameDelta(p12, v28 / p12.TotalKeyFrames);
                local v75, v76 = getLinkCF(p12);

                if v76 then
                    v74 = v75:VectorToObjectSpace(v74) or v74;
                end;

                p12.LocalCF = CFrame.new(v74) * p12.LocalCF;
                local v77 = v28 / p12.TotalKeyFrames;
                local v78 = p12._settleRotDamp or 1;
                local v79 = (p12._staticRotSpeedX or Graph.QueryPointsWithTime(v77, p12.Graphs.RotSpeedX, p12.Seeds.RotSpeedX)) * v78;
                local v80 = (p12._staticRotSpeedY or Graph.QueryPointsWithTime(v77, p12.Graphs.RotSpeedY, p12.Seeds.RotSpeedY)) * v78;
                local v81 = p12._staticRotSpeedZ or Graph.QueryPointsWithTime(v77, p12.Graphs.RotSpeedZ, p12.Seeds.RotSpeedZ);
                local v82 = PartConstants.composeRotation(v36, v79 + v33, v80 + v34, v81 * v78 + v35);
                p12.VisualPart:PivotTo(v75 * p12.LocalCF * v82);
                p12._localWorldCF = p12.LocalCF * v82;
                p12.CurrentPosition = p12.VisualPart:GetPivot().Position;
                p12.CurrentStep = v28;
            end;

            local v83 = p12._staticScale or Graph.QueryPointsWithTime(v28 / p12.TotalKeyFrames, p12.Graphs.Scale, p12.Seeds.Scale);
            local v84 = math.max(0.001, v83) * PartConstants.getParentScaleFactor(p12.ParentScale, p14, Graph);
            p12.VisualPart:ScaleTo(v84);

            if p12._visualBeams then
                for _, v in ipairs(p12._visualBeams) do
                    if v.Parent and v.Segments < 20 then
                        v.Segments = 20;
                    end;
                end;
            end;
        end;

        return v25;
    end;
end;