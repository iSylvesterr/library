-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Player = require(ReplicatedStorage.Library.Player);
local WaitFor = require(ReplicatedStorage.Library.Modules.Packages.WaitFor);
local u1 = {};
u1.__index = u1;
u1.__class = "GuardWakeLookAt";
local u2 = {
    Jungle = {
        AuthoredPitchAxis = Vector3.new(-0, -0, -1),
        BasePitch = 0.7853981633974483,
        MaxPitch = 1.3962634015954636,
        MinPitch = 0.17453292519943295,
        TargetPitchScale = -1
    }
};

function u1.new(u3) -- Line: 79
    -- upvalues: Asserts (copy), u1 (copy), WaitFor (copy), u2 (copy)
    Asserts.Model(u3);
    local v4 = setmetatable({}, u1);
    local v5, v6 = WaitFor.Descendant(u3, "Head"):await();
    local HumanoidRootPart = u3:WaitForChild("HumanoidRootPart");
    local Parent = u3.Parent;

    if v5 then
        v5 = v6 ~= nil;
    end;

    local v7 = `{u3:GetFullName()} requires a Head descendant for wake look-at`;
    assert(v5, v7);
    local v8 = v6:IsA("BasePart");
    local v9 = `{v6:GetFullName()} must be a BasePart`;
    assert(v8, v9);
    local v10 = HumanoidRootPart:IsA("BasePart");
    local v11 = `{HumanoidRootPart:GetFullName()} must be a BasePart`;
    assert(v10, v11);
    local v12;

    if Parent == nil then
        v12 = false;
    else
        v12 = Parent:IsA("Model");
    end;

    local v13 = `{u3:GetFullName()} requires an area Model parent`;
    assert(v12, v13);
    local u14 = u3:GetAttribute("HeadLookAtBoneName");
    local v15 = nil;
    local v16 = nil;

    if u14 == nil then
        local v17 = u3:GetAttribute("HeadLookAtMotorName");
        Asserts.optional.string(v17);
        local u18 = v17 or "Head";
        local v19;
        v19, v16 = WaitFor.Custom(function() -- Line: 114
            -- upvalues: u3 (copy), u18 (copy)
            for _, descendant in ipairs(u3:GetDescendants()) do
                if descendant:IsA("Motor6D") and descendant.Name == u18 then
                    return descendant;
                end;
            end;

            return nil;
        end):await();

        if v19 then
            v19 = v16 ~= nil;
        end;

        local v20 = `{u3:GetFullName()} requires Motor6D "{u18}" for wake look-at`;
        assert(v19, v20);
        local v21 = v16:IsA("Motor6D");
        local v22 = `{v16:GetFullName()} must be a Motor6D`;
        assert(v21, v22);
    else
        Asserts.string(u14);
        local v23;
        v23, v15 = WaitFor.Custom(function() -- Line: 96
            -- upvalues: u3 (copy), u14 (copy)
            for _, descendant in ipairs(u3:GetDescendants()) do
                if descendant:IsA("Bone") and descendant.Name == u14 then
                    return descendant;
                end;
            end;

            return nil;
        end):await();

        if v23 then
            v23 = v15 ~= nil;
        end;

        local v24 = `{u3:GetFullName()} requires Bone "{u14}" for HeadLookAtBoneName`;
        assert(v23, v24);
        local v25 = v15:IsA("Bone");
        local v26 = `{v15:GetFullName()} must be a Bone`;
        assert(v25, v26);
    end;

    local v27;

    if v15 == nil then
        local v28 = `{u3:GetFullName()} wake look-at requires a Motor6D or Bone`;
        assert(v16 ~= nil, v28);
        local Part0 = v16.Part0;
        local v29 = `{v16:GetFullName()} requires Part0 for wake look-at`;
        assert(Part0 ~= nil, v29);
        v27 = Part0.CFrame * v16.C0;
    else
        v27 = v15.WorldCFrame;
    end;

    local v30 = u2[Parent.Name];
    local v31 = v27.Rotation:ToObjectSpace(HumanoidRootPart.CFrame.Rotation);

    if v30 ~= nil then
        local v32 = `{u3:GetFullName()} area look override requires a Bone`;
        assert(v15 ~= nil, v32);
    end;

    v4._areaLookOverride = v30;
    v4._appliedOffset = CFrame.identity;
    v4._bone = v15;
    v4._currentOffset = CFrame.identity;
    v4._guardModel = u3;
    v4._isWaking = false;
    v4._jointToFacingRotation = v31;
    v4._motor = v16;
    v4._preAnimationConnection = nil;
    v4._preSimulationConnection = nil;
    v4._root = HumanoidRootPart;
    v4._targetPitchReference = nil;
    v4._targetUserId = nil;

    return v4;
end;

function u1._getJointTransform(p33) -- Line: 165
    local _bone = p33._bone;

    if _bone ~= nil then
        return _bone.Transform;
    end;

    local _motor = p33._motor;
    local v34 = `{p33._guardModel:GetFullName()} wake look-at requires a Motor6D or Bone`;
    assert(_motor ~= nil, v34);

    return _motor.Transform;
end;

function u1._setJointTransform(p35, p36) -- Line: 176
    local _bone = p35._bone;

    if _bone ~= nil then
        _bone.Transform = p36;

        return;
    end;

    local _motor = p35._motor;
    local v37 = `{p35._guardModel:GetFullName()} wake look-at requires a Motor6D or Bone`;
    assert(_motor ~= nil, v37);
    _motor.Transform = p36;
end;

function u1._getAnimationJointWorldCFrame(p38) -- Line: 188
    local _bone = p38._bone;

    if _bone ~= nil then
        return _bone.TransformedWorldCFrame * p38._appliedOffset:Inverse();
    end;

    local _motor = p38._motor;
    local v39 = `{p38._guardModel:GetFullName()} wake look-at requires a Motor6D or Bone`;
    assert(_motor ~= nil, v39);
    local Part0 = _motor.Part0;
    local v40 = `{_motor:GetFullName()} requires Part0 for wake look-at`;
    assert(Part0 ~= nil, v40);
    local v41 = _motor.Transform * p38._appliedOffset:Inverse();

    return Part0.CFrame * _motor.C0 * v41;
end;

function u1._getAnimationJointTransform(p42) -- Line: 202
    return p42:_getJointTransform() * p42._appliedOffset:Inverse();
end;

function u1._getTargetOffset(p43) -- Line: 206
    -- upvalues: Player (copy), Players (copy)
    if not p43._isWaking then
        return CFrame.identity;
    end;

    local v44 = Player.Optional.HumanoidRootPart(Players.LocalPlayer);

    if v44 == nil or (v44.Position - p43._root.Position).Magnitude > 400 then
        return CFrame.identity;
    end;

    local _targetUserId = p43._targetUserId;

    if _targetUserId == nil then
        return CFrame.identity;
    end;

    local v45 = tonumber(_targetUserId);
    local v46 = `{p43._guardModel:GetFullName()}.WakeTargetPlayer must be a user id`;
    assert(v45 ~= nil, v46);
    local v47 = Players:GetPlayerByUserId(v45);

    if v47 == nil then
        return CFrame.identity;
    end;

    local v48 = Player.Optional.Head(v47);

    if v48 == nil then
        return CFrame.identity;
    end;

    local v49 = p43:_getAnimationJointWorldCFrame();
    local v50 = CFrame.new(v49.Position) * p43._root.CFrame.Rotation;
    local v51 = v48.Position - v50.Position;

    if v51.Magnitude <= 0.001 then
        return CFrame.identity;
    end;

    local v52 = v50:VectorToObjectSpace(v51.Unit);
    local v53 = math.asin(v52.Y);
    local v54 = -math.atan2(v52.X, -v52.Z);
    local v55 = math.clamp(v54, -1.0471975511965976, 1.0471975511965976);
    local _areaLookOverride = p43._areaLookOverride;

    if _areaLookOverride == nil then
        local v56 = math.clamp(v53, -0.6108652381980153, 0.6108652381980153);
        local v57 = (v50 * CFrame.Angles(v56, v55, 0)).Rotation * p43._jointToFacingRotation:Inverse();

        return v49.Rotation:ToObjectSpace(v57);
    end;

    local _targetPitchReference = p43._targetPitchReference;

    if _targetPitchReference == nil then
        p43._targetPitchReference = v53;
        _targetPitchReference = v53;
    end;

    local v58 = p43:_getAnimationJointTransform();
    local v59 = v49.Rotation * v58.Rotation:Inverse();
    local v60 = math.clamp(_areaLookOverride.BasePitch + (v53 - _targetPitchReference) * _areaLookOverride.TargetPitchScale, _areaLookOverride.MinPitch, _areaLookOverride.MaxPitch);
    local v61 = CFrame.fromAxisAngle(_areaLookOverride.AuthoredPitchAxis, v60);
    local v62 = CFrame.fromAxisAngle(p43._root.CFrame.UpVector, v55) * v59 * v61 * v58.Rotation;

    return v49.Rotation:ToObjectSpace(v62);
end;

function u1._applyOffset(p63, p64) -- Line: 275
    p63:_setJointTransform(p63:_getJointTransform() * p64);
    p63._appliedOffset = p64;
end;

function u1._restoreAppliedOffset(p65) -- Line: 280
    p65:_setJointTransform(p65:_getJointTransform() * p65._appliedOffset:Inverse());
    p65._appliedOffset = CFrame.identity;
end;

function u1._isOffsetAtRest(p66) -- Line: 285
    local v67, v68, v69 = p66._currentOffset:ToOrientation();
    local v70 = math.abs(v67);
    local v71 = math.abs(v68);
    local v72 = math.abs(v69);

    return math.max(v70, v71, v72) <= 0.001;
end;

function u1._step(p73, p74) -- Line: 290
    local v75 = p73:_getTargetOffset();
    local v76 = 1 - math.exp(p74 * -3.5);
    p73._currentOffset = p73._currentOffset:Lerp(v75, v76);
    p73:_applyOffset(p73._currentOffset);

    if p73._isWaking or not p73:_isOffsetAtRest() then
        return false;
    end;

    p73._currentOffset = CFrame.identity;
    p73:_restoreAppliedOffset();

    return true;
end;

function u1._ensureAnimation(u77) -- Line: 305
    -- upvalues: RunService (copy)
    if u77._preSimulationConnection ~= nil then
        return;
    end;

    assert(u77._preAnimationConnection == nil, "wake look-at frame connections must share a lifecycle");
    u77._preAnimationConnection = RunService.PreAnimation:Connect(function() -- Line: 311
        -- upvalues: u77 (copy)
        u77:_restoreAppliedOffset();
    end);
    u77._preSimulationConnection = RunService.PreSimulation:Connect(function(p78) -- Line: 314
        -- upvalues: u77 (copy)
        if u77:_step(p78) then
            u77:_disconnectAnimation();
        end;
    end);
end;

function u1._disconnectAnimation(p79) -- Line: 321
    local _preAnimationConnection = p79._preAnimationConnection;

    if _preAnimationConnection ~= nil then
        p79._preAnimationConnection = nil;
        _preAnimationConnection:Disconnect();
    end;

    local _preSimulationConnection = p79._preSimulationConnection;

    if _preSimulationConnection ~= nil then
        p79._preSimulationConnection = nil;
        _preSimulationConnection:Disconnect();
    end;
end;

function u1.SetWaking(p80, p81, p82) -- Line: 339
    -- upvalues: Asserts (copy)
    Asserts.boolean(p81);
    Asserts.optional.string(p82);

    if not p81 or (not p80._isWaking or p82 ~= p80._targetUserId) then
        p80._targetPitchReference = nil;
    end;

    p80._isWaking = p81;
    p80._targetUserId = p82;

    if p81 or not p80:_isOffsetAtRest() then
        p80:_ensureAnimation();
    end;
end;

function u1.Destroy(p83) -- Line: 353
    p83._isWaking = false;
    p83._targetPitchReference = nil;
    p83._targetUserId = nil;
    p83._currentOffset = CFrame.identity;
    p83:_restoreAppliedOffset();
    p83:_disconnectAnimation();
end;

return u1;