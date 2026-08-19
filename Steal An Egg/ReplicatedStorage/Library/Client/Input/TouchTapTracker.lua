-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
require(script.Types.Interface);
local u1 = {};
u1.__index = u1;
u1.__class = "TouchTapTracker";
local u2 = Log.new();

function u1.new(p3) -- Line: 38
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.optional.table(p3);

    if p3 then
        Asserts.optional.number(p3.MaxMovement);
        Asserts.optional.number(p3.MaxDuration);
    end;

    local v4 = setmetatable({}, u1);
    v4._maxMovement = (not p3 or p3.MaxMovement == nil) and 16 or p3.MaxMovement;
    v4._maxDuration = (not p3 or p3.MaxDuration == nil) and 0.35 or p3.MaxDuration;
    v4._activeInput = nil;
    v4._startedAt = 0;
    v4._startPosition = nil;
    v4._cancelled = false;
    v4:_init();

    return v4;
end;

function u1._validateTouchInput(p5, p6) -- Line: 62
    -- upvalues: Asserts (copy)
    Asserts.cond(p6.UserInputType == Enum.UserInputType.Touch);
end;

function u1._getMovementDistance(p7, p8) -- Line: 66
    local _startPosition = p7._startPosition;

    if _startPosition then
        return (p8.Position - _startPosition).Magnitude;
    end;

    return nil;
end;

function u1.Begin(p9, p10) -- Line: 79
    p9:_validateTouchInput(p10);
    p9._activeInput = p10;
    p9._startedAt = os.clock();
    p9._startPosition = p10.Position;
    p9._cancelled = false;
end;

function u1.Update(p11, p12) -- Line: 88
    p11:_validateTouchInput(p12);

    if p11._activeInput ~= p12 or p11._cancelled then
        return false;
    end;

    local v13 = p11:_getMovementDistance(p12);

    if not v13 then
        p11._cancelled = true;

        return false;
    end;

    if p11._maxMovement >= v13 then
        return true;
    end;

    p11._cancelled = true;

    return false;
end;

function u1.Evaluate(p14, p15, p16) -- Line: 109
    p14:_validateTouchInput(p15);

    if p16 then
        p14:Reset();

        return false;
    end;

    if p14._activeInput ~= p15 or p14._cancelled then
        p14:Reset();

        return false;
    end;

    local v17 = p14:_getMovementDistance(p15);
    local _startedAt = p14._startedAt;

    if not v17 or _startedAt <= 0 then
        p14:Reset();

        return false;
    end;

    local v18;

    if os.clock() - _startedAt <= p14._maxDuration then
        v18 = v17 <= p14._maxMovement;
    else
        v18 = false;
    end;

    p14:Reset();

    return v18;
end;

function u1.Reset(p19) -- Line: 136
    p19._activeInput = nil;
    p19._startedAt = 0;
    p19._startPosition = nil;
    p19._cancelled = false;
end;

function u1.IsTrackingInput(p20, p21) -- Line: 143
    return p20._activeInput == p21;
end;

function u1.IsCancelled(p22) -- Line: 147
    return p22._cancelled;
end;

function u1._init(p23) -- Line: 155
    -- upvalues: u2 (copy)
    u2:AtDebug():Log("TouchTapTracker initialized");
end;

return u1;