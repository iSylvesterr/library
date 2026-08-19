-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ObjectPoolUtil = UtilsSystem.ObjectPoolUtil;
local FXUtil = UtilsSystem.FXUtil;
local SkillTelegraphConfig = require(script.Parent.SkillTelegraphConfig);
local u1 = {};
u1.__index = u1;
local u2 = {};
local u3 = {
    update = function() -- Line: 43, Name: update
    end,

    setWarnDuration = function() -- Line: 44, Name: setWarnDuration
    end,

    activate = function() -- Line: 45, Name: activate
    end,

    destroy = function() -- Line: 46, Name: destroy
    end
};

local function _isClient() -- Line: 49
    -- upvalues: RunService (copy)
    return RunService:IsClient();
end;

local function _getPartTemplate(p4) -- Line: 59
    -- upvalues: u2 (copy), SkillTelegraphConfig (copy), UtilsSystem (copy)
    if u2[p4] then
        return u2[p4];
    end;

    local v5 = UtilsSystem.ResourceUtil.GetTemplate(SkillTelegraphConfig.RESOURCE_FOLDER .. "/" .. p4);
    local v6 = nil;

    if not (v5 and v5:IsA("BasePart")) then
        if v5 then
            v5 = v5:FindFirstChildWhichIsA("BasePart", true);

            if v5 then
                if not v5:IsA("BasePart") then
                    v5 = v6;
                end;
            else
                v5 = v6;
            end;
        else
            v5 = v6;
        end;
    end;

    if v5 then
        u2[p4] = v5;

        return v5;
    end;

    warn("[SkillTelegraph] 缺少预警部件模板:", p4);

    return nil;
end;

local function _borrowPart(p7) -- Line: 89
    -- upvalues: _getPartTemplate (copy), ObjectPoolUtil (copy)
    local v8 = _getPartTemplate(p7);

    if not v8 then
        return nil, nil;
    end;

    local v9 = ObjectPoolUtil.getObjectFromPool(v8);

    if not (v9 and v9:IsA("BasePart")) then
        return nil, nil;
    end;

    v9.Anchored = true;
    v9.CanCollide = false;
    v9.CanQuery = false;
    v9.CanTouch = false;
    v9.Parent = workspace.Debris;

    return v9, v9.Color;
end;

local function _releasePart(p10, p11) -- Line: 112
    -- upvalues: ObjectPoolUtil (copy)
    if not p10 then
        return;
    end;

    if p11 then
        p10.Color = p11;
    end;

    p10.Parent = nil;
    ObjectPoolUtil.backToPool(p10);
end;

local function _resolveGroundSize(p12, p13) -- Line: 130
    -- upvalues: SkillTelegraphConfig (copy)
    local GROUND_THICKNESS = SkillTelegraphConfig.GROUND_THICKNESS;

    if p12 ~= "Circle" then
        return Vector3.new(p13.X, GROUND_THICKNESS, p13.Z);
    end;

    local X = p13.X;

    return Vector3.new(X, GROUND_THICKNESS, X);
end;

local function _resolveAlignedCF(p14, p15, p16) -- Line: 147
    -- upvalues: FXUtil (copy)
    if p16 then
        return p14;
    end;

    local Position = p14.Position;

    if p15 and (Position - p15).Magnitude < 0.001 then
        return p14;
    end;

    return FXUtil.GetGroundAlignedCF(Position, p14.LookVector) or CFrame.new(Position) * p14.Rotation;
end;

local function _resolveRectInner(p17, p18, p19) -- Line: 171
    -- upvalues: Players (copy)
    local X = p18.X;
    local Z = p18.Z;
    local v20 = math.max(0.1, Z * p19);
    local LookVector = p17.LookVector;
    local Position = p17.Position;
    local v21 = Position + LookVector * (Z * 0.5);
    local v22 = Position - LookVector * (Z * 0.5);
    local LocalPlayer = Players.LocalPlayer;
    local v23 = LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");

    if v23 and v23:IsA("BasePart") then
        local Position2 = v23.Position;

        if (v22 - Position2).Magnitude <= (v21 - Position2).Magnitude then
            local v24 = v22;
            v22 = v21;
            v21 = v24;
        end;
    else
        local v25 = v22;
        v22 = v21;
        v21 = v25;
    end;

    local v26 = v22 + (v21 - v22).Unit * (v20 * 0.5);

    return CFrame.lookAt(v26, v26 + LookVector, p17.UpVector), Vector3.new(X, p18.Y, v20);
end;

local function _resolveCircleInnerCF(p27) -- Line: 202
    return p27;
end;

local function _applyGroundYOffset(p28, p29) -- Line: 213
    -- upvalues: SkillTelegraphConfig (copy)
    return p28 * CFrame.new(0, SkillTelegraphConfig.INNER_Y_OFFSET + p29, 0);
end;

local function _applyInnerSizeAdjust(p30) -- Line: 223
    -- upvalues: SkillTelegraphConfig (copy)
    local v31 = p30 + SkillTelegraphConfig.INNER_SIZE_OFFSET;
    local v32 = math.max(0.1, v31.X);
    local v33 = math.max(0.1, v31.Y);
    local v34 = math.max(0.1, v31.Z);

    return Vector3.new(v32, v33, v34);
end;

local function _applyVisual(p35) -- Line: 238
    -- upvalues: FXUtil (copy), SkillTelegraphConfig (copy), _resolveRectInner (copy)
    if not (p35._outer and p35._inner) then
        return;
    end;

    local _worldCF = p35._worldCF;
    local _lastPos = p35._lastPos;

    if not p35._skipGroundAlign then
        local Position = _worldCF.Position;

        if not _lastPos or (Position - _lastPos).Magnitude >= 0.001 then
            _worldCF = FXUtil.GetGroundAlignedCF(Position, _worldCF.LookVector) or CFrame.new(Position) * _worldCF.Rotation;
        end;
    end;

    p35._lastPos = _worldCF.Position;
    local _hitboxSize = p35._hitboxSize;
    local GROUND_THICKNESS = SkillTelegraphConfig.GROUND_THICKNESS;
    local v36;

    if p35._shape == "Circle" then
        local X = _hitboxSize.X;
        v36 = Vector3.new(X, GROUND_THICKNESS, X);
    else
        v36 = Vector3.new(_hitboxSize.X, GROUND_THICKNESS, _hitboxSize.Z);
    end;

    p35._outer.Size = v36;
    p35._outer.CFrame = _worldCF * CFrame.new(0, SkillTelegraphConfig.INNER_Y_OFFSET + p35._stackYOffset, 0);

    if p35._phase == "warn" then
        local v37 = p35._warnDuration <= 0 and 1 or math.clamp(p35._elapsed / p35._warnDuration, 0, 1);

        if p35._shape == "Circle" then
            v36 = SkillTelegraphConfig.INNER_START_SIZE:Lerp(v36, v37);
        else
            _worldCF, v36 = _resolveRectInner(_worldCF, v36, v37);
        end;
    elseif p35._shape ~= "Circle" then
        _worldCF, v36 = _resolveRectInner(_worldCF, v36, 1);
    end;

    local v38 = _worldCF * CFrame.new(0, SkillTelegraphConfig.INNER_Y_OFFSET + p35._stackYOffset, 0);
    local v39 = v36 + SkillTelegraphConfig.INNER_SIZE_OFFSET;
    local v40 = math.max(0.1, v39.X);
    local v41 = math.max(0.1, v39.Y);
    local v42 = math.max(0.1, v39.Z);
    local v43 = Vector3.new(v40, v41, v42);
    p35._inner.Size = v43;
    p35._inner.CFrame = v38;
end;

local function _enterActive(p44) -- Line: 282
    -- upvalues: SkillTelegraphConfig (copy), _applyVisual (copy)
    if p44._phase == "active" or p44._destroyed then
        return;
    end;

    p44._phase = "active";
    p44._activeElapsed = 0;

    if p44._inner then
        p44._inner.Color = SkillTelegraphConfig.ACTIVE_COLOR;
    end;

    _applyVisual(p44);
end;

local function _onHeartbeat(p45, p46) -- Line: 300
    -- upvalues: SkillTelegraphConfig (copy), _applyVisual (copy)
    if p45._destroyed then
        return;
    end;

    if p45._phase == "warn" then
        p45._elapsed = p45._elapsed + p46;

        if p45._elapsed >= p45._warnDuration then
            if p45._pendingActiveDuration ~= nil then
                p45._activeDuration = p45._pendingActiveDuration;
                p45._pendingActiveDuration = nil;
            end;

            if p45._phase ~= "active" and not p45._destroyed then
                p45._phase = "active";
                p45._activeElapsed = 0;

                if p45._inner then
                    p45._inner.Color = SkillTelegraphConfig.ACTIVE_COLOR;
                end;

                _applyVisual(p45);
            end;
        end;
    elseif p45._phase == "active" then
        p45._activeElapsed = p45._activeElapsed + p46;

        if p45._activeDuration > 0 and p45._activeElapsed >= p45._activeDuration then
            p45:destroy();

            return;
        end;
    end;

    _applyVisual(p45);
end;

function u1.new(p47) -- Line: 325
    -- upvalues: RunService (copy), u3 (copy), u1 (copy), SkillTelegraphConfig (copy), _borrowPart (copy), _applyVisual (copy), _onHeartbeat (copy)
    if not RunService:IsClient() then
        return u3;
    end;

    local u48 = setmetatable({}, u1);
    u48._destroyed = false;
    u48._shape = p47.shape;
    u48._worldCF = p47.worldCFrame;
    u48._hitboxSize = p47.hitboxSize;
    u48._warnDuration = math.max(0, p47.warnDuration);
    u48._activeDuration = math.max(0, p47.activeDuration or 0);
    u48._pendingActiveDuration = nil;
    u48._phase = "warn";
    u48._elapsed = 0;
    u48._activeElapsed = 0;
    u48._lastPos = nil;
    u48._positionLocked = false;
    u48._skipGroundAlign = p47.skipGroundAlign == true;
    local STACK_Y_JITTER = SkillTelegraphConfig.STACK_Y_JITTER;
    u48._stackYOffset = STACK_Y_JITTER <= 0 and 0 or (math.random() * 2 - 1) * STACK_Y_JITTER;
    local v49;

    if u48._shape == "Circle" then
        v49 = SkillTelegraphConfig.PART_NAME.CircleOuter;
    else
        v49 = SkillTelegraphConfig.PART_NAME.RectOuter;
    end;

    local v50;

    if u48._shape == "Circle" then
        v50 = SkillTelegraphConfig.PART_NAME.CircleInner;
    else
        v50 = SkillTelegraphConfig.PART_NAME.RectInner;
    end;

    local v51, v52 = _borrowPart(v49);
    u48._outer = v51;
    u48._outerDefaultColor = v52;
    local v53, v54 = _borrowPart(v50);
    u48._inner = v53;
    u48._innerDefaultColor = v54;

    if not (u48._outer and u48._inner) then
        u48:destroy();

        return u3;
    end;

    _applyVisual(u48);
    u48._heartbeatConn = RunService.Heartbeat:Connect(function(p55) -- Line: 363
        -- upvalues: _onHeartbeat (ref), u48 (copy)
        _onHeartbeat(u48, p55);
    end);

    if u48._warnDuration <= 0 then
        if u48._activeDuration > 0 then
            if u48._phase ~= "active" then
                if u48._destroyed then
                    return u48;
                end;

                u48._phase = "active";
                u48._activeElapsed = 0;

                if u48._inner then
                    u48._inner.Color = SkillTelegraphConfig.ACTIVE_COLOR;
                end;

                _applyVisual(u48);

                return u48;
            end;
        else
            u48._pendingActiveDuration = 0;
        end;
    end;

    return u48;
end;

function u1.update(p56, p57) -- Line: 383
    -- upvalues: _applyVisual (copy)
    if p56._destroyed then
        return;
    end;

    if p57.lockPosition == true then
        p56._positionLocked = true;
        p56._lastPos = nil;

        if p57.worldCFrame then
            p56._worldCF = p57.worldCFrame;
        end;
    elseif not p56._positionLocked and p57.worldCFrame then
        p56._worldCF = p57.worldCFrame;
    end;

    if p57.hitboxSize then
        p56._hitboxSize = p57.hitboxSize;
    end;

    _applyVisual(p56);
end;

function u1.setWarnDuration(p58, p59) -- Line: 407
    -- upvalues: _applyVisual (copy)
    if p58._destroyed then
        return;
    end;

    p58._warnDuration = math.max(0, p59);
    _applyVisual(p58);
end;

function u1.activate(p60, p61) -- Line: 420
    -- upvalues: SkillTelegraphConfig (copy), _applyVisual (copy)
    if p60._destroyed then
        return;
    end;

    p60._activeDuration = math.max(0, p61);

    if p60._phase == "warn" and p60._elapsed < p60._warnDuration then
        p60._pendingActiveDuration = p60._activeDuration;

        return;
    end;

    if p60._phase ~= "active" then
        if p60._destroyed then
            return;
        end;

        p60._phase = "active";
        p60._activeElapsed = 0;

        if p60._inner then
            p60._inner.Color = SkillTelegraphConfig.ACTIVE_COLOR;
        end;

        _applyVisual(p60);
    end;
end;

function u1.destroy(p62) -- Line: 435
    -- upvalues: ObjectPoolUtil (copy)
    if p62._destroyed then
        return;
    end;

    p62._destroyed = true;

    if p62._heartbeatConn then
        p62._heartbeatConn:Disconnect();
        p62._heartbeatConn = nil;
    end;

    local _outer = p62._outer;
    local _outerDefaultColor = p62._outerDefaultColor;

    if _outer then
        if _outerDefaultColor then
            _outer.Color = _outerDefaultColor;
        end;

        _outer.Parent = nil;
        ObjectPoolUtil.backToPool(_outer);
    end;

    local _inner = p62._inner;
    local _innerDefaultColor = p62._innerDefaultColor;

    if _inner then
        if _innerDefaultColor then
            _inner.Color = _innerDefaultColor;
        end;

        _inner.Parent = nil;
        ObjectPoolUtil.backToPool(_inner);
    end;

    p62._outer = nil;
    p62._inner = nil;
end;

return u1;