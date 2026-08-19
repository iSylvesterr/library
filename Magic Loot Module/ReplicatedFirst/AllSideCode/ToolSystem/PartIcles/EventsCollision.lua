-- Decompiled with Potassium's decompiler.

local PartConstants = require(script.Parent.PartConstants);
local Graph = require(script.Parent.Graph);
local v1 = {};
local u2 = { Vector3.new(1, 0, 0), Vector3.new(-1, 0, 0), Vector3.new(0, 1, 0), Vector3.new(0, -1, 0), Vector3.new(0, 0, 1), Vector3.new(0, 0, -1) };

local function _snapshotPData(p3, p4) -- Line: 62
    return {
        time = p3._effectiveElapsed or 0,
        kind = p4,
        BaseDirection = p3.BaseDirection,
        SpeedMultiplier = p3.SpeedMultiplier,
        _accelVel = p3._accelVel,
        TargetVel = p3.TargetVel,
        _spinRate = p3._spinRate,
        _spinAccumX = p3._spinAccumX,
        _spinAccumY = p3._spinAccumY,
        _spinAccumZ = p3._spinAccumZ,
        AccRotX = p3.AccRotX,
        AccRotY = p3.AccRotY,
        AccRotZ = p3.AccRotZ,
        LocalCF = p3.LocalCF,
        _localWorldCF = p3._localWorldCF,
        CurrentPosition = p3.CurrentPosition,
        _hitFired = p3._hitFired,
        LastHitCheckPos = p3.LastHitCheckPos,
        _collisionStopped = p3._collisionStopped,
        CurrentStep = p3.CurrentStep,
        AccumulatedDT = p3.AccumulatedDT,
        _displacementMirrorX = p3._displacementMirrorX,
        _displacementMirrorY = p3._displacementMirrorY,
        _displacementMirrorZ = p3._displacementMirrorZ,
        _prevWorldOff = p3._prevWorldOff,
        _settleEngaged = p3._settleEngaged,
        _restTimer = p3._restTimer,
        _settleRotDamp = p3._settleRotDamp,
        _settleContactPos = p3._settleContactPos,
        _settleSpawnHalf = p3._settleSpawnHalf,
        _lastHitNormal = p3._lastHitNormal
    };
end;

local function _pushHit(p5, p6) -- Line: 104
    p5._hitHistory = p5._hitHistory or {};

    if #p5._hitHistory >= 16 then
        table.remove(p5._hitHistory, 1);
    end;

    table.insert(p5._hitHistory, p6);
end;

function v1.restoreHitsOnReverse(p7, p8, p9) -- Line: 114
    local _hitHistory = p7._hitHistory;

    if not _hitHistory then
        return;
    end;

    for i = #_hitHistory, 1, -1 do
        local v10 = _hitHistory[i];

        if p9 < v10.time and v10.time <= p8 then
            p7.BaseDirection = v10.BaseDirection;
            p7.SpeedMultiplier = v10.SpeedMultiplier;
            p7._accelVel = v10._accelVel;
            p7.TargetVel = v10.TargetVel;
            p7._spinRate = v10._spinRate;
            p7._spinAccumX = v10._spinAccumX;
            p7._spinAccumY = v10._spinAccumY;
            p7._spinAccumZ = v10._spinAccumZ;
            p7.AccRotX = v10.AccRotX;
            p7.AccRotY = v10.AccRotY;
            p7.AccRotZ = v10.AccRotZ;
            p7.LocalCF = v10.LocalCF;
            p7._localWorldCF = v10._localWorldCF;
            p7.CurrentPosition = v10.CurrentPosition;
            p7._hitFired = v10._hitFired;
            p7.LastHitCheckPos = v10.LastHitCheckPos;
            p7._collisionStopped = v10._collisionStopped;
            p7.CurrentStep = v10.CurrentStep;
            p7.AccumulatedDT = v10.AccumulatedDT;
            p7._displacementMirrorX = v10._displacementMirrorX;
            p7._displacementMirrorY = v10._displacementMirrorY;
            p7._displacementMirrorZ = v10._displacementMirrorZ;
            p7._prevWorldOff = v10._prevWorldOff;
            p7._settleEngaged = v10._settleEngaged;
            p7._restTimer = v10._restTimer;
            p7._settleRotDamp = v10._settleRotDamp;
            p7._settleContactPos = v10._settleContactPos;
            p7._settleSpawnHalf = v10._settleSpawnHalf;
            p7._lastHitNormal = v10._lastHitNormal;
            table.remove(_hitHistory, i);
        end;
    end;
end;

local function applySnapCFrame(p11, p12) -- Line: 155
    local VisualPart = p11.VisualPart;

    if not (VisualPart and VisualPart.Parent) then
        return;
    end;

    if p11.Type == "Model" then
        VisualPart:PivotTo(p12);

        return;
    end;

    if p11.Type ~= "Attachment" then
        VisualPart.CFrame = p12;

        return;
    end;

    local Parent = VisualPart.Parent;

    if Parent and Parent:IsA("BasePart") then
        p12 = Parent.CFrame:ToObjectSpace(p12) or p12;
    end;

    VisualPart.CFrame = p12;
end;

local function readWorldCF(p13) -- Line: 168
    local VisualPart = p13.VisualPart;

    if not (VisualPart and VisualPart.Parent) then
        return CFrame.new();
    end;

    if p13.Type == "Model" then
        return VisualPart:GetPivot();
    end;

    if p13.Type ~= "Attachment" then
        return VisualPart.CFrame;
    end;

    local Parent = VisualPart.Parent;

    return Parent and Parent:IsA("BasePart") and Parent.CFrame * VisualPart.CFrame or VisualPart.CFrame;
end;

local function bounceParentCF(p14) -- Line: 181
    -- upvalues: PartConstants (copy)
    local Link = p14.Link;

    if not (Link and Link.Parent) then
        return CFrame.new();
    end;

    local v15;

    if p14.LinkMode == "RigidLocal" then
        v15 = p14._rigidLocalParentCF or CFrame.new();
    else
        v15 = PartConstants.resolveLinkCFrame(Link);
    end;

    if not v15 then
        return CFrame.new();
    end;

    if p14.LinkMode == "Follow" or p14.LinkMode == "Pivot" then
        return CFrame.new(v15.Position);
    end;

    return v15;
end;

local function attachmentBounceLocalPos(p16, p17) -- Line: 198
    -- upvalues: PartConstants (copy)
    local VisualPart = p16.VisualPart;

    if VisualPart then
        VisualPart = VisualPart.Parent;
    end;

    local v18 = VisualPart and (VisualPart:IsA("BasePart") and VisualPart.CFrame) or CFrame.new();
    local Link = p16.Link;
    local v19;

    if Link and Link.Parent then
        local v20;

        if p16.LinkMode == "RigidLocal" then
            v20 = p16._rigidLocalParentCF or CFrame.new();
        else
            v20 = PartConstants.resolveLinkCFrame(Link);
        end;

        v19 = v18:ToObjectSpace(v20);

        if p16.LinkMode == "Follow" or p16.LinkMode == "Pivot" then
            v19 = CFrame.new(v19.Position);
        end;
    else
        v19 = CFrame.new();
    end;

    return v19:PointToObjectSpace((v18:PointToObjectSpace(p17)));
end;

local function handleKillOrStop(p21, p22, p23, p24) -- Line: 226
    -- upvalues: _snapshotPData (copy), readWorldCF (copy), applySnapCFrame (copy), attachmentBounceLocalPos (copy), bounceParentCF (copy)
    local v25;

    if p24 == "Kill" then
        v25 = nil;
    else
        v25 = _snapshotPData(p22, "Stop") or nil;
    end;

    local v26 = readWorldCF(p22);
    local v27 = CFrame.new(p23.Position) * (v26 - v26.Position);
    applySnapCFrame(p22, v27);
    p22.CurrentPosition = p23.Position;

    if p24 == "Kill" then
        if p21._killParticle then
            p21:_killParticle(p22, {
                fireOnDeath = true
            });
        end;
    else
        if p22.LocalCF then
            local v28;

            if p22.Type == "Attachment" then
                v28 = attachmentBounceLocalPos(p22, p23.Position);
            else
                v28 = bounceParentCF(p22):PointToObjectSpace(p23.Position);
            end;

            p22.LocalCF = CFrame.new(v28) * (p22.LocalCF - p22.LocalCF.Position);
            p22._localWorldCF = p22.LocalCF;
        end;

        p22._postUpdateCF = v27;
        p22._collisionStopped = true;
        p22.LastHitCheckPos = p23.Position;
        p22._hitFired = true;

        if v25 then
            p22._hitHistory = p22._hitHistory or {};

            if #p22._hitHistory >= 16 then
                table.remove(p22._hitHistory, 1);
            end;

            table.insert(p22._hitHistory, v25);
        end;
    end;
end;

local function handleBounce(p29, p30, p31, p32) -- Line: 259
    -- upvalues: _snapshotPData (copy), Graph (copy), PartConstants (copy), attachmentBounceLocalPos (copy), bounceParentCF (copy), readWorldCF (copy), applySnapCFrame (copy)
    local Normal = p30.Normal;
    local OnHit = p29.Events.OnHit;
    p29._bouncinessJitter = p29._bouncinessJitter or 1 + (math.random() - 0.5) * 0.4;
    p29._frictionJitter = p29._frictionJitter or 1 + (math.random() - 0.5) * 0.4;
    p29._restClampJitter = p29._restClampJitter or 1 + (math.random() - 0.5) * 0.4;
    p29._sleepTimeJitter = p29._sleepTimeJitter or 1 + (math.random() - 0.5) * 0.4;
    local v33 = (OnHit.Bounciness or 0.7) * p29._bouncinessJitter;
    local v34 = (OnHit.Friction or 0.2) * p29._frictionJitter;
    local v35 = OnHit.Spin or 0.5;
    local v36 = (not p32 or p32 <= 0) and 0.016666666666666666 or p32;
    local v37 = _snapshotPData(p29, "Bounce");
    p29._lastHitNormal = Normal;
    local v38 = (p31 / v36):Dot(Normal);
    local v39 = math.abs(v38) < 0.5 * (p29._restClampJitter or 1) and 0 or v33;
    local BaseDirection = p29.BaseDirection;

    if BaseDirection then
        local v40 = BaseDirection:Dot(Normal) * Normal;
        local v41 = -v39 * v40 + (1 - v34) * (BaseDirection - v40);
        local Magnitude = v41.Magnitude;

        if Magnitude > 0.0001 then
            p29.BaseDirection = v41.Unit;
            p29.SpeedMultiplier = (p29.SpeedMultiplier or 1) * Magnitude;
        else
            p29.SpeedMultiplier = 0;
        end;
    end;

    local _accelVel = p29._accelVel;

    if _accelVel then
        local v42 = _accelVel:Dot(Normal) * Normal;
        p29._accelVel = -v39 * v42 + (1 - v34) * (_accelVel - v42);
    end;

    local TargetVel = p29.TargetVel;

    if TargetVel then
        local v43 = TargetVel:Dot(Normal) * Normal;
        p29.TargetVel = -v39 * v43 + (1 - v34) * (TargetVel - v43);
    end;

    local v44 = p29._spinRate or Vector3.new(0, 0, 0);
    local v45 = (p31 - p31:Dot(Normal) * Normal) / v36;
    local Magnitude = (p31 / v36).Magnitude;
    local v46 = v45.Magnitude <= 0.0001 and Vector3.new(0, 0, 0) or Normal:Cross(v45) * (v35 * 3.33);
    local v47 = math.min(1, Magnitude / 1);
    p29._spinRate = v44 * (1 - v34) * v47 + v46;

    if Magnitude < 1 then
        if not p29._settleEngaged then
            local VisualPart = p29.VisualPart;

            if VisualPart and VisualPart:IsA("BasePart") then
                local v48 = VisualPart.Size.Magnitude * 0.5;
                p29._settleSpawnHalf = v48;
                p29._settleContactPos = VisualPart.Position - Normal * v48;
            end;
        end;

        p29._settleEngaged = true;
    end;

    if p29.HasPosOffsetGraphs then
        local function _reflect(p49) -- Line: 350
            -- upvalues: Normal (copy)
            return p49 - 2 * p49:Dot(Normal) * Normal;
        end;

        local v50 = p29._displacementMirrorX or Vector3.new(1, 0, 0);
        local v51 = p29._displacementMirrorY or Vector3.new(0, 1, 0);
        local v52 = p29._displacementMirrorZ or Vector3.new(0, 0, 1);
        p29._displacementMirrorX = v50 - 2 * v50:Dot(Normal) * Normal;
        p29._displacementMirrorY = v51 - 2 * v51:Dot(Normal) * Normal;
        p29._displacementMirrorZ = v52 - 2 * v52:Dot(Normal) * Normal;
        local v53 = (p29.CurrentStep or 0) / math.max(p29.TotalKeyFrames, 1);
        local v54 = p29.Graphs.PosOffsetX and (Graph.QueryPointsWithTime(v53, p29.Graphs.PosOffsetX, p29.Seeds.PosOffsetX) or 0) or 0;
        local v55 = p29.Graphs.PosOffsetY and (Graph.QueryPointsWithTime(v53, p29.Graphs.PosOffsetY, p29.Seeds.PosOffsetY) or 0) or 0;
        local v56 = p29.Graphs.PosOffsetZ and (Graph.QueryPointsWithTime(v53, p29.Graphs.PosOffsetZ, p29.Seeds.PosOffsetZ) or 0) or 0;
        p29._prevWorldOff = PartConstants.resolveDisplacement(Vector3.new(v54, v55, v56), p29.DisplacementMode or "Global", p29.SpawnRotation, p29.SpawnEmitterRotation, p29._displacementMirrorX, p29._displacementMirrorY, p29._displacementMirrorZ);
    end;

    local v57 = p30.Position + Normal * 0.05;

    if p29.LocalCF then
        local v58;

        if p29.Type == "Attachment" then
            v58 = attachmentBounceLocalPos(p29, v57);
        else
            v58 = bounceParentCF(p29):PointToObjectSpace(v57);
        end;

        p29.LocalCF = CFrame.new(v58) * (p29.LocalCF - p29.LocalCF.Position);
        p29._localWorldCF = p29.LocalCF;
    end;

    local v59 = readWorldCF(p29);
    local v60 = CFrame.new(v57) * (v59 - v59.Position);
    applySnapCFrame(p29, v60);
    p29._postUpdateCF = v60;
    p29.CurrentPosition = v57;
    p29.LastHitCheckPos = v57;
    p29._hitFired = false;
    p29._hitHistory = p29._hitHistory or {};

    if #p29._hitHistory >= 16 then
        table.remove(p29._hitHistory, 1);
    end;

    table.insert(p29._hitHistory, v37);
end;

function v1.applySettle(p61, p62) -- Line: 397
    -- upvalues: readWorldCF (copy), u2 (copy), applySnapCFrame (copy)
    if not p61 or p61._collisionStopped then
        return;
    end;

    if not p61._settleEngaged then
        return;
    end;

    if p61.NeedsFullIteration then
        return;
    end;

    if p62 and p62 > 0 then
        local v63 = math.exp(-6 * p62);
        p61._spinRate = (p61._spinRate or Vector3.new(0, 0, 0)) * v63;
        p61._settleRotDamp = (p61._settleRotDamp or 1) * math.exp(-6 * p62);
    end;

    local _lastHitNormal = p61._lastHitNormal;

    if not _lastHitNormal or _lastHitNormal.Magnitude < 0.0001 then
        return;
    end;

    local VisualPart = p61.VisualPart;

    if not (VisualPart and VisualPart.Parent) then
        return;
    end;

    local v64 = readWorldCF(p61);
    local v65 = -_lastHitNormal;
    local v66 = u2[1];
    local v67 = (-1 / 0);

    for _, v in ipairs(u2) do
        local v68 = v64:VectorToWorldSpace(v):Dot(v65);

        if v67 < v68 then
            v66 = v;
            v67 = v68;
        end;
    end;

    local v69 = v64:VectorToWorldSpace(v66);
    local v70 = v69:Dot(v65);
    local v71 = math.clamp(v70, -1, 1);
    local v72 = math.acos(v71);
    local v73 = v69:Cross(v65);

    if v73.Magnitude > 0.0001 and (v72 > 0.0001 and (p62 and p62 > 0)) then
        local Magnitude = (p61.Acceleration or Vector3.new(0, 0, 0)).Magnitude;

        if Magnitude > 1 then
            local v74 = math.sin(v72) * Magnitude * 0.5;
            p61._spinRate = (p61._spinRate or Vector3.new(0, 0, 0)) + v73.Unit * v74 * p62;
        end;
    end;

    if p61._settleContactPos and (p61._settleSpawnHalf and VisualPart:IsA("BasePart")) then
        applySnapCFrame(p61, CFrame.new(p61._settleContactPos + _lastHitNormal * (VisualPart.Size.Magnitude * 0.5)) * (v64 - v64.Position));
    end;

    local v75 = (p61._spinRate or Vector3.new(0, 0, 0)).Magnitude * (p61._sleepRadius or 1) * 0.017453292519943295;

    if math.abs(p61.SpeedMultiplier or 0) + (p61._accelVel or Vector3.new(0, 0, 0)).Magnitude + v75 < 0.1 then
        p61._restTimer = (p61._restTimer or 0) + p62;
    else
        p61._restTimer = 0;
    end;

    if (p61._restTimer or 0) >= 0.5 * (p61._sleepTimeJitter or 1) and v72 < 0.02 then
        p61._collisionStopped = true;
        p61._spinRate = Vector3.new(0, 0, 0);
        p61._accelVel = Vector3.new(0, 0, 0);
        p61.SpeedMultiplier = 0;
        p61.TargetVel = Vector3.new(0, 0, 0);
    end;
end;

function v1.handle(p76, p77, p78, p79, p80) -- Line: 473
    -- upvalues: handleKillOrStop (copy), handleBounce (copy)
    local v81 = p77.Events.OnHit.Collision or "Off";
    local v82 = v81 == "Bounce" and p77.InvertMotion and "Kill" or v81;
    local v83 = p77.IsAnimate and (v82 == "Kill" or (v82 == "Stop" or v82 == "Bounce")) and "Off" or v82;

    if v83 == "Kill" or v83 == "Stop" then
        handleKillOrStop(p76, p77, p78, v83);

        return "snap";
    end;

    if v83 == "Bounce" then
        handleBounce(p77, p78, p79, p80);

        return "snap";
    end;

    p77._hitFired = true;

    return "off";
end;

return v1;