-- Decompiled with Potassium's decompiler.

local PartConstants = require(script.Parent.Parent.PartConstants);
local VerletSim = require(script.Parent.VerletSim);
local u1 = {};

local function applySpawnOff(p2, p3) -- Line: 23
    local _spawnOff = p2._spawnOff;

    if not _spawnOff or _spawnOff.Magnitude == 0 then
        return p3;
    end;

    if p2._spawnOffMode == "Global" then
        return p3 + _spawnOff;
    end;

    local _spawnRot = p2._spawnRot;

    if _spawnRot then
        return p3 + (p3.Rotation * _spawnRot):VectorToWorldSpace(_spawnOff);
    end;

    return p3 * CFrame.new(_spawnOff);
end;

function u1.resolveStart(p4) -- Line: 39
    -- upvalues: PartConstants (copy)
    local v5;

    if p4._startCFOverride then
        v5 = p4._startCFOverride;
    else
        local _parentLink = p4._parentLink;

        if _parentLink and _parentLink.Parent then
            v5 = PartConstants.resolveLinkCFrame(_parentLink);
        else
            local _sourceItem = p4._sourceItem;
            v5 = _sourceItem and (_sourceItem.Parent and _sourceItem.CFrame) or (p4._lastStartCF or CFrame.new());
        end;

        p4._lastStartCF = v5;
    end;

    if p4._spawnTarget ~= "End" then
        local _spawnOff = p4._spawnOff;

        if not _spawnOff or _spawnOff.Magnitude == 0 then
            return v5;
        end;

        if p4._spawnOffMode == "Global" then
            return v5 + _spawnOff;
        end;

        local _spawnRot = p4._spawnRot;

        if _spawnRot then
            return v5 + (v5.Rotation * _spawnRot):VectorToWorldSpace(_spawnOff);
        end;

        v5 = v5 * CFrame.new(_spawnOff);
    end;

    return v5;
end;

function u1.resolveEnd(p6) -- Line: 63
    -- upvalues: PartConstants (copy), VerletSim (copy)
    if not p6._pinEnd then
        return nil;
    end;

    if p6._pinMode == "Launch" then
        return p6._launchPos or p6._launchOrigin;
    end;

    local _target = p6._target;

    if _target and _target.Parent then
        local v7 = PartConstants.resolveLinkCFrame(_target);

        if p6._spawnTarget == "End" then
            local _spawnOff = p6._spawnOff;

            if _spawnOff and _spawnOff.Magnitude ~= 0 then
                if p6._spawnOffMode == "Global" then
                    v7 = v7 + _spawnOff;
                else
                    local _spawnRot = p6._spawnRot;

                    if _spawnRot then
                        v7 = v7 + (v7.Rotation * _spawnRot):VectorToWorldSpace(_spawnOff);
                    else
                        v7 = v7 * CFrame.new(_spawnOff);
                    end;
                end;
            end;
        end;

        p6._lastEndPos = v7.Position;

        return v7.Position;
    end;

    p6._pinEnd = false;
    local _rig = p6._rig;
    VerletSim.calm(_rig.posBuf, _rig.prevPosBuf, p6._segCount);

    return nil;
end;

function u1.repin(p8) -- Line: 86
    -- upvalues: u1 (copy), VerletSim (copy)
    local _rig = p8._rig;
    local posBuf = _rig.posBuf;
    local prevPosBuf = _rig.prevPosBuf;
    local _segCount = p8._segCount;
    local _anchorOffWorld = p8._anchorOffWorld;

    if p8._pinStart ~= false then
        local Position = u1.resolveStart(p8).Position;

        if _anchorOffWorld and p8._motionTarget == "Start" then
            Position = Position + _anchorOffWorld;
        end;

        local v9 = Position - posBuf[1];

        if v9.Magnitude > 50 then
            VerletSim.translate(posBuf, prevPosBuf, _segCount, v9);
        end;

        posBuf[1] = Position;
        prevPosBuf[1] = Position;
    end;

    local v10 = u1.resolveEnd(p8);

    if v10 then
        if _anchorOffWorld and p8._motionTarget == "End" then
            v10 = v10 + _anchorOffWorld;
        end;

        posBuf[_segCount + 1] = v10;
        prevPosBuf[_segCount + 1] = v10;
    end;
end;

function u1.seedPose(p11) -- Line: 121
    -- upvalues: u1 (copy), VerletSim (copy)
    local _rig = p11._rig;
    local posBuf = _rig.posBuf;
    local _segCount = p11._segCount;
    local Position = u1.resolveStart(p11).Position;

    if (p11._growIn or 0) > 0 and p11._pinMode ~= "Launch" then
        local v12 = p11._motionDir or Vector3.new(0, -1, 0);
        local v13 = p11._restLen * 0.02;

        for i = 1, _segCount + 1 do
            posBuf[i] = Position + v12 * (v13 * (i - 1));
        end;

        VerletSim.calm(posBuf, _rig.prevPosBuf, _segCount);

        return;
    end;

    if p11._pinMode ~= "Launch" then
        local v14 = u1.resolveEnd(p11);

        if v14 then
            local v15 = v14 - Position;
            local v16 = math.max(p11._restLen * _segCount - v15.Magnitude, 0);

            for i = 1, _segCount + 1 do
                local v17 = (i - 1) / _segCount;
                posBuf[i] = Position + v15 * v17 - Vector3.new(0, v16 * 0.5 * 4 * v17 * (1 - v17), 0);
            end;
        else
            local v18 = p11._motionDir or Vector3.new(0, -1, 0);

            for i = 1, _segCount + 1 do
                posBuf[i] = Position + v18 * (p11._restLen * (i - 1));
            end;
        end;

        VerletSim.calm(posBuf, _rig.prevPosBuf, _segCount);

        return;
    end;

    local _launchVel = p11._launchVel;
    local v19 = _launchVel and (_launchVel.Magnitude > 0.0001 and _launchVel.Unit) or Vector3.new(0, 1, 0);
    local v20 = p11._restLen * 0.05;

    for i = 1, _segCount + 1 do
        posBuf[i] = Position + v19 * (v20 * (i - 1));
    end;

    VerletSim.calm(posBuf, _rig.prevPosBuf, _segCount);
end;

return u1;