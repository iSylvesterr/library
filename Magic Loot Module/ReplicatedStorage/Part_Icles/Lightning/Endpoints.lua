-- Decompiled with Potassium's decompiler.

local PartConstants = require(script.Parent.Parent.PartConstants);
local u1 = {};

local function resolveDispFrame(p2, p3, p4) -- Line: 13
    local _dispMode = p2._dispMode;

    if _dispMode == "Local" then
        if p2._originRot then
            p3 = p3.Rotation * p2._originRot or p3;
        end;

        return p3:VectorToWorldSpace(p4);
    end;

    if _dispMode == "RigidLocal" then
        return p3.Rotation:VectorToWorldSpace(p4);
    end;

    return p4;
end;

function u1.sampleShape(p5, p6, p7) -- Line: 27
    -- upvalues: PartConstants (copy)
    p5._shapeLocalOffset = nil;
    p5._shapeDirLocal = nil;
    p5._shapeUsesPart = nil;

    if not p6.UseShape then
        return;
    end;

    local v8 = PartConstants.shapeFunctions[p6.Shape];
    local ShapePart = p6.ShapePart;

    if not (ShapePart and (ShapePart:IsA("BasePart") and ShapePart)) then
        if p7 and (p7:IsA("BasePart") and p7) then
            ShapePart = p7;
        else
            ShapePart = nil;
        end;
    end;

    if not (v8 and ShapePart) then
        return;
    end;

    local v9, _, v10 = v8(ShapePart, {
        ShapePartial = p6.ShapePartial or 0
    });
    p5._shapeLocalOffset = v9;

    if ShapePart == p7 or not ShapePart then
        ShapePart = nil;
    end;

    p5._shapeUsesPart = ShapePart;

    if p6.ShapeDirection == "Radial" and (p5._endpointMode == "Directional" and v10) then
        local ShapeInOut = p6.ShapeInOut;

        if ShapeInOut == Enum.ParticleEmitterShapeInOut.Inward then
            v10 = -v10;
        elseif ShapeInOut == Enum.ParticleEmitterShapeInOut.InAndOut and math.random() < 0.5 then
            v10 = -v10;
        end;

        p5._shapeDirLocal = v10;
    end;
end;

local function seekScan(p11, p12) -- Line: 60
    local _seekRayFn = p11._seekRayFn;

    if not _seekRayFn then
        return;
    end;

    local v13 = p11._seekRadius or 30;
    local v14 = {};

    for _ = 1, 8 do
        local v15 = math.random() * 2 - 1;
        local v16 = math.random() * 2 - 1;
        local v17 = math.random() * 2 - 1;
        local v18 = Vector3.new(v15, v16, v17);

        if v18.Magnitude > 0.001 then
            local v19 = _seekRayFn(p12, v18.Unit * v13);

            if v19 then
                v14[#v14 + 1] = {
                    hit = v19,
                    dist = (v19.Position - p12).Magnitude
                };
            end;
        end;
    end;

    if #v14 <= 0 then
        p11._seekHit = nil;
        local v20 = math.random() * 2 - 1;
        local v21 = math.random() * 2 - 1;
        local v22 = math.random() * 2 - 1;
        local v23 = Vector3.new(v20, v21, v22);
        p11._seekFallbackDir = v23.Magnitude > 0.001 and v23.Unit or Vector3.new(0, 1, 0);

        return;
    end;

    table.sort(v14, function(p24, p25) -- Line: 75
        return p24.dist < p25.dist;
    end);
    local v26 = p11._seekBias or 0;
    local v27 = math.random() ^ (1 + v26 * 8) * #v14;
    local v28 = math.floor(v27) + 1;
    local hit = v14[math.clamp(v28, 1, #v14)].hit;
    p11._seekHit = {
        Position = hit.Position,
        Normal = hit.Normal,
        Instance = hit.Instance
    };
    p11._seekNewHit = true;
end;

function u1.glideStep(p29, p30) -- Line: 92
    local _seekCurrentPos = p29._seekCurrentPos;
    local _seekGoalPos = p29._seekGoalPos;

    if (p29._retargetSpeed or 0) <= 0 or not (_seekCurrentPos and _seekGoalPos) then
        return false;
    end;

    local v31 = _seekGoalPos - _seekCurrentPos;
    local Magnitude = v31.Magnitude;

    if Magnitude <= 0.001 then
        return false;
    end;

    local v32 = p29._retargetSpeed * p30;
    p29._seekCurrentPos = Magnitude <= v32 and _seekGoalPos and _seekGoalPos or _seekCurrentPos + v31 * (v32 / Magnitude);

    return true;
end;

function u1.glideArrived(p33) -- Line: 105
    if (p33._retargetSpeed or 0) <= 0 then
        return true;
    end;

    local _seekCurrentPos = p33._seekCurrentPos;
    local _seekGoalPos = p33._seekGoalPos;

    return not (_seekCurrentPos and _seekGoalPos) and true or (_seekCurrentPos - _seekGoalPos).Magnitude <= 0.01;
end;

function u1.resolveEndpoints(p34) -- Line: 115
    -- upvalues: PartConstants (copy), u1 (copy), seekScan (copy)
    local _parentLink = p34._parentLink;
    local v35;

    if p34._startCFOverride then
        v35 = p34._startCFOverride;
    elseif _parentLink and _parentLink.Parent then
        v35 = PartConstants.resolveLinkCFrame(_parentLink);
    else
        local _sourceItem = p34._sourceItem;

        if _sourceItem and _sourceItem.Parent then
            v35 = _sourceItem.CFrame;
        else
            v35 = p34._lastStartCF or CFrame.new();
        end;
    end;

    p34._lastStartCF = v35;
    local Position = v35.Position;
    local v36;

    if p34._shapeLocalOffset then
        local _shapeUsesPart = p34._shapeUsesPart;

        if _shapeUsesPart and _shapeUsesPart.Parent then
            v36 = _shapeUsesPart.CFrame or v35;
        else
            v36 = v35;
        end;

        Position = (v36 * CFrame.new(p34._shapeLocalOffset)).Position;
    else
        v36 = v35;
    end;

    local _originOffset = p34._originOffset;

    if _originOffset then
        if p34._originOffsetGlobal then
            Position = Position + _originOffset;
        else
            local v37;

            if p34._originRot then
                v37 = v35.Rotation * p34._originRot or v35;
            else
                v37 = v35;
            end;

            Position = Position + v37:VectorToWorldSpace(_originOffset);
        end;
    end;

    local _motionOffset = p34._motionOffset;

    if _motionOffset and _motionOffset ~= Vector3.new(0, 0, 0) then
        Position = Position + _motionOffset;
    end;

    local _dispRaw = p34._dispRaw;

    if _dispRaw then
        local _dispMode = p34._dispMode;

        if _dispMode == "Local" then
            local v38;

            if p34._originRot then
                v38 = v35.Rotation * p34._originRot or v35;
            else
                v38 = v35;
            end;

            _dispRaw = v38:VectorToWorldSpace(_dispRaw);
        elseif _dispMode == "RigidLocal" then
            _dispRaw = v35.Rotation:VectorToWorldSpace(_dispRaw);
        end;

        Position = Position + _dispRaw;
    end;

    local _turbRaw = p34._turbRaw;

    if _turbRaw then
        local _dispMode = p34._dispMode;

        if _dispMode == "Local" then
            local v39;

            if p34._originRot then
                v39 = v35.Rotation * p34._originRot or v35;
            else
                v39 = v35;
            end;

            _turbRaw = v39:VectorToWorldSpace(_turbRaw);
        elseif _dispMode == "RigidLocal" then
            _turbRaw = v35.Rotation:VectorToWorldSpace(_turbRaw);
        end;

        Position = Position + _turbRaw;
    end;

    local _dispMode = p34._dispMode;
    local v40;

    if _dispMode == "Local" then
        local v41;

        if p34._originRot then
            v41 = v35.Rotation * p34._originRot or v35;
        else
            v41 = v35;
        end;

        v40 = v41:VectorToWorldSpace(Vector3.new(0, 1, 0));
    else
        v40 = _dispMode ~= "RigidLocal" and Vector3.new(0, 1, 0) or v35.Rotation:VectorToWorldSpace(Vector3.new(0, 1, 0));
    end;

    p34._sagDirWorld = v40;
    local v42;

    if p34._endpointMode == "Point" then
        local _target = p34._target;

        if _target and _target.Parent then
            v42 = PartConstants.resolveLinkCFrame(_target).Position;
        else
            v42 = p34._lastEndPos or Position;
        end;

        local v43 = v42 - Position;

        if v43.Magnitude > 0.0001 then
            p34._lastDirWorld = v43.Unit;
        end;
    elseif p34._endpointMode == "Seek" then
        local v44 = not u1.glideArrived(p34);

        if p34._seekRetarget and not v44 or not (p34._seekHit or p34._seekFallbackDir) then
            seekScan(p34, Position);
        end;

        local v45;

        if p34._seekHit then
            v45 = p34._seekHit.Position;
        else
            v45 = Position + p34._seekFallbackDir * ((p34._seekRadius or 30) * 0.5);
        end;

        p34._seekGoalPos = v45;

        if (p34._retargetSpeed or 0) <= 0 or not p34._seekCurrentPos then
            p34._seekCurrentPos = v45;
        end;

        v42 = p34._seekCurrentPos;
        local v46 = v42 - Position;

        if v46.Magnitude > 0.0001 then
            p34._lastDirWorld = v46.Unit;
        end;
    else
        local v47;

        if p34._shapeDirLocal then
            v47 = v36:VectorToWorldSpace(p34._shapeDirLocal);
        elseif p34._dirGlobal then
            v47 = p34._dirLocalVec;
        else
            v47 = v35.Rotation:VectorToWorldSpace(p34._dirLocalVec);
        end;

        p34._lastDirWorld = v47;
        v42 = Position + v47 * p34._length;
    end;

    p34._lastEndPos = v42;

    return v35, Position, v42;
end;

return u1;