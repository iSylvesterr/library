-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local GuardChasePolicy = require(script.Parent.GuardChasePolicy);
require(script.Parent.Types.Interface);
local u1 = {};

local function resolveHorizontalDirection(p2) -- Line: 24
    -- upvalues: Asserts (copy)
    local v3 = Vector3.new(p2.X, 0, p2.Z);
    Asserts.cond(v3.Magnitude > 1e-6);

    return v3.Unit;
end;

local function resolveAtSpeed(p4, p5) -- Line: 30
    -- upvalues: GuardChasePolicy (copy), Asserts (copy)
    if p5 == 0 then
        return {
            ExitTime = (1 / 0),
            Outcome = "Caught",
            CatchTime = GuardChasePolicy.GetWakingDuration()
        };
    end;

    local v6 = p4.ExitDistance / p5;
    local v7 = GuardChasePolicy.GetWakingDuration();

    if v6 <= v7 then
        return {
            CatchTime = nil,
            Outcome = "EscapedSafely",
            ExitTime = v6
        };
    end;

    local ExitDirection = p4.ExitDirection;
    local v8 = Vector3.new(ExitDirection.X, 0, ExitDirection.Z);
    Asserts.cond(v8.Magnitude > 1e-6);
    local v9 = (p4.PlayerStartPosition - p4.GuardStartPosition):Dot(v8.Unit) + p5 * v7;

    if v9 <= p4.HitDistance then
        return {
            Outcome = "Caught",
            CatchTime = v7,
            ExitTime = v6
        };
    end;

    local v10 = GuardChasePolicy.ResolveCatchDuration(p4.BaseGuardWalkSpeed, p4.FlatRadius, p4.HitDistance, v9, p5);
    local v11;

    if v10 == nil then
        v11 = nil;
    else
        v11 = v7 + v10;
    end;

    local v12;

    if v11 == nil then
        v12 = false;
    else
        v12 = v11 < v6;
    end;

    return {
        CatchTime = v11,
        ExitTime = v6,
        Outcome = v12 and "Caught" or "EscapedSafely"
    };
end;

function u1.ResolveExitDistance(p13, p14, p15, p16) -- Line: 85
    -- upvalues: Asserts (copy)
    Asserts.CFrame(p13);
    Asserts.Vector3(p14);
    Asserts.Vector3(p15);
    Asserts.Vector3(p16);
    local v17 = Vector3.new(p16.X, 0, p16.Z);
    Asserts.cond(v17.Magnitude > 1e-6);
    local Unit = v17.Unit;
    local v18 = p13:PointToObjectSpace(p15);
    local v19 = p13:VectorToObjectSpace(Unit);
    local v20 = p14 * 0.5;
    Asserts.cond(math.abs(v18.X) <= v20.X + 1e-6);
    Asserts.cond(math.abs(v18.Z) <= v20.Z + 1e-6);
    local v21;

    if math.abs(v19.X) > 1e-6 then
        local v22;

        if v19.X > 0 then
            v22 = v20.X;
        else
            v22 = -v20.X;
        end;

        v21 = (v22 - v18.X) / v19.X;
    else
        v21 = (1 / 0);
    end;

    local v23;

    if math.abs(v19.Z) > 1e-6 then
        local v24;

        if v19.Z > 0 then
            v24 = v20.Z;
        else
            v24 = -v20.Z;
        end;

        v23 = (v24 - v18.Z) / v19.Z;
    else
        v23 = (1 / 0);
    end;

    local v25 = math.min(v21, v23);
    local v26;

    if v25 >= 0 then
        v26 = v25 < (1 / 0);
    else
        v26 = false;
    end;

    Asserts.cond(v26);

    return v25;
end;

function u1.ResolvePlayerWalkSpeedRequirement(p27, p28) -- Line: 121
    -- upvalues: Asserts (copy), GuardChasePolicy (copy), resolveAtSpeed (copy)
    Asserts.table(p27);
    Asserts.number(p28);
    Asserts.number(p27.BaseGuardWalkSpeed);
    Asserts.Vector3(p27.ExitDirection);
    Asserts.number(p27.ExitDistance);
    Asserts.number(p27.FlatRadius);
    Asserts.Vector3(p27.GuardStartPosition);
    Asserts.number(p27.HitDistance);
    Asserts.Vector3(p27.PlayerStartPosition);
    Asserts.cond(p27.BaseGuardWalkSpeed > 0);
    Asserts.cond(p27.ExitDistance >= 0);
    Asserts.cond(p27.FlatRadius > 0);
    Asserts.cond(p27.HitDistance > 0);
    local v29;

    if p28 > 0 then
        v29 = p28 <= 1;
    else
        v29 = false;
    end;

    Asserts.cond(v29);

    if p27.ExitDistance == 0 then
        return 0;
    end;

    local v30 = GuardChasePolicy.GetWakingDuration();
    local v31 = p27.ExitDistance / v30 / p28;
    local v32 = 0;

    for _ = 1, 48 do
        local v33 = (v32 + v31) * 0.5;

        if resolveAtSpeed(p27, v33 * p28).Outcome == "Caught" then
            v32 = v33;
        else
            v31 = v33;
        end;
    end;

    return v31;
end;

function u1.ResolveGreenPlayerWalkSpeedRequirement(p34) -- Line: 159
    -- upvalues: u1 (copy)
    return u1.ResolvePlayerWalkSpeedRequirement(p34, 0.6);
end;

function u1.ResolveSlowdownTolerance(p35, p36) -- Line: 165
    -- upvalues: Asserts (copy)
    Asserts.number(p35);
    Asserts.number(p36);
    Asserts.cond(p35 >= 0);
    Asserts.cond(p36 >= 0);

    return p35 == 0 and 1 or (p36 == 0 and -1 or 1 - p35 / p36);
end;

function u1.Resolve(p37) -- Line: 180
    -- upvalues: Asserts (copy), resolveAtSpeed (copy)
    Asserts.table(p37);
    Asserts.number(p37.BaseGuardWalkSpeed);
    Asserts.Vector3(p37.ExitDirection);
    Asserts.number(p37.ExitDistance);
    Asserts.number(p37.FlatRadius);
    Asserts.Vector3(p37.GuardStartPosition);
    Asserts.number(p37.HitDistance);
    Asserts.number(p37.PlayerWalkSpeed);
    Asserts.Vector3(p37.PlayerStartPosition);
    Asserts.cond(p37.BaseGuardWalkSpeed > 0);
    Asserts.cond(p37.ExitDistance >= 0);
    Asserts.cond(p37.FlatRadius > 0);
    Asserts.cond(p37.HitDistance > 0);
    Asserts.cond(p37.PlayerWalkSpeed >= 0);
    local v38 = resolveAtSpeed(p37, p37.PlayerWalkSpeed);

    if v38.Outcome == "Caught" then
        return v38;
    end;

    local v39 = resolveAtSpeed(p37, p37.PlayerWalkSpeed * 0.6);

    return {
        CatchTime = v38.CatchTime,
        ExitTime = v38.ExitTime,
        Outcome = v39.Outcome == "Caught" and "EscapedAtRisk" or "EscapedSafely"
    };
end;

return u1;