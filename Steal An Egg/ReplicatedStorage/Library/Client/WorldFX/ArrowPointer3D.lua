-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local Interface = require(script.Types.Interface);
local FuncWrapper = require(ReplicatedStorage.Library.Modules.FuncWrapper);
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new():LimitUnderLevel("Warning");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local TableUtil = require(ReplicatedStorage.Library.Modules.Packages.TableUtil);
local MediumArrow = ReplicatedStorage.Assets.Models.Arrows.MediumArrow;
local __DEBRIS = workspace:WaitForChild("__DEBRIS");
local X = MediumArrow:WaitForChild("Meshes_arrow_arrow_outline").Size.X;
local u2 = X / 1.5;
local u3 = CFrame.Angles(1.5707963267948966, 0, 1.5707963267948966);
local u4 = {
    Amplitude = 4,
    Radius = 4,
    Blink = false,
    Highlight = false,
    RotationSpeed = 0,
    CleanupOnPartDestroyed = false,
    OscillationSpeed = 3.75,
    BlinkFrequency = 0.3,
    OriginOffset = Vector3.new(0, 0, 0),
    TargetOffset = Vector3.new(0, 0, 0),
    ProximityThreshold = X * 1.5,
    Color = Color3.fromRGB(255, 255, 255)
};
local u5 = t.optional(t.union(t.instanceIsA("BasePart"), t.Vector3));
local u6 = {};
local u7 = {};
u7.__index = u7;
u7.__class = "ArrowPointer3D";
u7.__types = Interface;
u7.__constants = {
    ARROW_MID_OFFSET = u2,
    ARROW_SIZE = X,
    DEFAULT_CONFIG = u4
};

function u7.new(p8, p9, p10) -- Line: 89
    -- upvalues: Interface (copy), u5 (copy), TableUtil (copy), u4 (copy), u7 (copy), FuncWrapper (copy), Trove (copy), MediumArrow (copy), __DEBRIS (copy)
    assert(Interface.OptionalConfig(p10));
    assert(u5(p8));
    assert(u5(p9));
    local v11 = TableUtil.ShallowReconcile(p10 or {}, u4);
    local v12 = setmetatable({}, u7);
    v12.Config = v11;
    v12._funcWrapper = FuncWrapper.CreateWrapper(v12);
    v12._trove = Trove.new();
    v12._trackedPartTroves = {};
    v12._trackedOrigin = p9;
    v12._target = p8;
    v12._arrowModel = v12._trove:Clone(MediumArrow);
    v12._arrowParent = __DEBRIS;
    v12._arrowModel.main.Color = v11.Color;
    v12._timeElapsed = 0;
    v12._started = false;
    v12._active = true;
    v12._lastOrigin = nil;
    v12._lastTarget = nil;
    v12:_init();

    return v12;
end;

local function getPosition(p13, p14) -- Line: 126
    if typeof(p13) == "Instance" then
        p13 = p13.Position or p13;
    end;

    return p13 + p14;
end;

local function isValid(p15) -- Line: 131
    if p15 then
        return typeof(p15) == "Vector3" and true or p15.Parent ~= nil;
    end;

    return false;
end;

function u7._onAncestryChanged(p16, p17, p18) -- Line: 142
    -- upvalues: u1 (copy)
    u1:AtTrace():Log("Ancestry changed of one of the tracked parts:", p18);

    if p18 then
        return p16:Start();
    end;

    return p16:Stop();
end;

function u7._update(p19, p20) -- Line: 151
    -- upvalues: u2 (copy), u3 (copy)
    p19._timeElapsed = p19._timeElapsed + p20;

    if not p19:AreTrackedPartsValid() then
        return;
    end;

    local _target = p19._target;
    local TargetOffset = p19.Config.TargetOffset;

    if typeof(_target) == "Instance" then
        _target = _target.Position or _target;
    end;

    local v21 = _target + TargetOffset;
    local _trackedOrigin = p19._trackedOrigin;
    local OriginOffset = p19.Config.OriginOffset;

    if typeof(_trackedOrigin) == "Instance" then
        _trackedOrigin = _trackedOrigin.Position or _trackedOrigin;
    end;

    local v22 = _trackedOrigin + OriginOffset;
    local Unit = (v21 - v22).Unit;
    local v23 = p19.Config.Amplitude * math.sin(p19._timeElapsed * p19.Config.OscillationSpeed);
    local v24 = math.fmod(p19._timeElapsed, p19.Config.OscillationSpeed) < p19.Config.BlinkFrequency;
    local Magnitude = (v22 - v21).Magnitude;
    local v25 = p19.Config.Radius + v23 + u2;
    local v26 = CFrame.fromAxisAngle(Vector3.new(1, 0, 0), p19._timeElapsed * p19.Config.RotationSpeed);
    local _arrowModel = p19._arrowModel;

    if p19.Config.Blink then
        _arrowModel.main.Color = v24 and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255);
    else
        _arrowModel.main.Color = p19.Config.Color;
    end;

    if Magnitude < p19.Config.ProximityThreshold then
        p19._arrowModel.Parent = nil;

        return;
    end;

    if not p19._arrowModel.Parent then
        p19._arrowModel.Parent = p19._arrowParent;
    end;

    p19._arrowModel:PivotTo(CFrame.new(v22 + Unit * v25, v21) * u3 * v26);
end;

function u7._changePart(p27, p28, p29) -- Line: 195
    -- upvalues: Asserts (copy), Trove (copy)
    Asserts.BasePart(p28);
    local v30 = Trove.is(p29);
    assert(v30, "Invalid trove object provided, cannot change target");
    p29:Clean();

    if p27.Config.CleanupOnPartDestroyed then
        p29:Connect(p28.Destroying, p27._funcWrapper(p27.Destroy));
    end;

    p29:Connect(p28.AncestryChanged, p27._funcWrapper(p27._onAncestryChanged));
end;

function u7.AreTrackedPartsValid(p31) -- Line: 208
    local _target = p31._target;
    local v32;

    if _target then
        v32 = typeof(_target) == "Vector3" and true or _target.Parent ~= nil;
    else
        v32 = false;
    end;

    if v32 then
        local _trackedOrigin = p31._trackedOrigin;

        if not _trackedOrigin then
            return false;
        end;

        if typeof(_trackedOrigin) ~= "Vector3" then
            return _trackedOrigin.Parent ~= nil;
        end;

        v32 = true;
    end;

    return v32;
end;

function u7.Start(p33) -- Line: 212
    -- upvalues: u6 (copy)
    if p33._started then
        return false;
    end;

    local v34 = p33:AreTrackedPartsValid();
    assert(v34, "Attempt to start without the tracked part, or its parented to nil");
    p33._started = true;
    p33._arrowModel.Parent = p33._arrowParent;
    table.insert(u6, p33);

    return true;
end;

function u7.Stop(p35) -- Line: 226
    -- upvalues: u6 (copy)
    if not p35._started then
        return false;
    end;

    table.remove(u6, table.find(u6, p35));
    p35._started = false;
    p35._arrowModel.Parent = nil;

    return true;
end;

function u7.ChangeOrigin(p36, p37) -- Line: 238
    -- upvalues: u1 (copy)
    if typeof(p37) == "Vector3" then
        p36._trackedOrigin = p37;
    else
        if p37 == p36._lastOrigin then
            return;
        end;

        p36._trackedPartTroves.Origin = p36._trackedPartTroves.Origin or p36._trove:Extend();
        p36:_changePart(p37, p36._trackedPartTroves.Origin);
        p36._trackedOrigin = p37;
        p36._lastOrigin = p37;
    end;

    u1:AtTrace():Log("Tracked origin updated, origin:", p37);
end;

function u7.ChangeTarget(p38, p39) -- Line: 256
    -- upvalues: u1 (copy)
    if typeof(p39) == "Vector3" then
        p38._target = p39;
    else
        if p39 ~= p38._lastTarget then
            return;
        end;

        p38._trackedPartTroves.Target = p38._trackedPartTroves.Target or p38._trove:Extend();
        p38:_changePart(p39, p38._trackedPartTroves.Target);
        p38._target = p39;
        p38._lastTarget = p39;
    end;

    u1:AtTrace():Log("Tracked target updated, target:", p39);
end;

function u7.Destroy(p40) -- Line: 274
    p40:Stop();
    p40._trove:Destroy();
    table.clear(p40);
    setmetatable(p40, nil);
end;

function u7._init(p41) -- Line: 286
    if p41._trackedOrigin and typeof(p41._trackedOrigin) ~= "Vector3" then
        p41:ChangeOrigin(p41._trackedOrigin);
    end;

    if p41._target and typeof(p41._target) ~= "Vector3" then
        p41:ChangeTarget(p41._target);
    end;

    return p41;
end;

RunService.RenderStepped:Connect(function(p42) -- Line: 298
    -- upvalues: u6 (copy), u1 (copy)
    for i = #u6, 1, -1 do
        local v43 = u6[i];

        if v43._started then
            local success, result = pcall(v43._update, v43, p42);

            if not success then
                u1:AtError():Log((`ArrowPointer3D update failed: {result}`));
                v43:Stop();
            end;
        end;
    end;
end);

return u7;