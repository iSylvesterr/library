-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();
local u2 = {};
u2.__index = u2;
u2.__class = "GuardMovementRecovery";

function u2.new(p3, p4) -- Line: 37
    -- upvalues: Asserts (copy), u2 (copy)
    Asserts.BasePart(p3);
    Asserts.BasePart(p4);
    local v5 = setmetatable({}, u2);
    v5._ground = p4;
    v5._lastProgressPosition = nil;
    v5._lastProgressTime = 0;
    v5._returnHomeStartedAt = nil;
    v5._root = p3;

    return v5;
end;

function u2._getHorizontalDistance(p6, p7) -- Line: 55
    local v8 = p6._root.Position - p7;

    return Vector3.new(v8.X, 0, v8.Z).Magnitude;
end;

function u2.Reset(p9) -- Line: 64
    p9._lastProgressPosition = nil;
    p9._lastProgressTime = 0;
    p9._returnHomeStartedAt = nil;
end;

function u2.ShouldRecoverFromFall(p10) -- Line: 70
    -- upvalues: u1 (copy)
    if p10._root.Position.Y >= p10._ground.Position.Y - 5 then
        return false;
    end;

    u1:AtWarning():Log((`Guard fell below the world and requires recovery: {p10._root:GetFullName()}`));

    return true;
end;

function u2.Step(p11, p12, p13, p14) -- Line: 79
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.number(p12);
    Asserts.boolean(p13);
    Asserts.boolean(p14);

    if p14 then
        local _returnHomeStartedAt = p11._returnHomeStartedAt;

        if _returnHomeStartedAt == nil then
            p11._returnHomeStartedAt = p12;
        elseif p12 - _returnHomeStartedAt >= 20 then
            u1:AtWarning():Log((`Guard return-home timeout triggered for {p11._root:GetFullName()}`));
            p11:Reset();

            return true;
        end;
    else
        p11._returnHomeStartedAt = nil;
    end;

    if not p13 then
        p11._lastProgressPosition = nil;
        p11._lastProgressTime = 0;

        return false;
    end;

    local _lastProgressPosition = p11._lastProgressPosition;

    if _lastProgressPosition == nil then
        p11._lastProgressPosition = p11._root.Position;
        p11._lastProgressTime = p12;

        return false;
    end;

    if p11:_getHorizontalDistance(_lastProgressPosition) >= 3 then
        p11._lastProgressPosition = p11._root.Position;
        p11._lastProgressTime = p12;

        return false;
    end;

    if p12 - p11._lastProgressTime < 10 then
        return false;
    end;

    u1:AtWarning():Log((`Guard stuck recovery triggered for {p11._root:GetFullName()}`));
    p11:Reset();

    return true;
end;

return u2;