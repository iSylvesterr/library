-- Decompiled with Potassium's decompiler.

local AssetWanderArea = require(script.Parent.AssetWanderArea);
local u7 = {
    YawFromFlatDirection = function(p1) -- Line: 18, Name: YawFromFlatDirection
        return math.atan2(-p1.X, -p1.Z);
    end,

    ShortestYawDelta = function(p2, p3) -- Line: 22, Name: ShortestYawDelta
        local v4 = p3 - p2;
        local v5 = math.sin(v4);
        local v6 = math.cos(v4);

        return math.atan2(v5, v6);
    end
};

function u7.StepYawToward(p8, p9, p10) -- Line: 28
    -- upvalues: u7 (copy)
    local v11 = u7.ShortestYawDelta(p8, p9);
    local v12 = p10 * 3.839724354387525;
    local v13 = math.clamp(v11, -v12, v12);

    return p8 + v13, v13;
end;

function u7.StepMoveToward(p14, p15, p16, p17) -- Line: 36
    -- upvalues: u7 (copy)
    local Position = p15.Position;
    local v18 = p16 - Position;
    local v19 = Vector3.new(v18.X, 0, v18.Z);
    local Magnitude = v19.Magnitude;

    if Magnitude <= 0 then
        return p15, false, 0;
    end;

    local v20 = math.min(Magnitude, p17 * p14);
    local Unit = v19.Unit;
    local LookVector = p15.LookVector;
    local v21 = Vector3.new(LookVector.X, 0, LookVector.Z);
    local v22;

    if v21.Magnitude > 0 then
        v22 = v21.Unit;
    else
        v22 = Unit;
    end;

    local v23 = u7.YawFromFlatDirection(v22);
    local v24 = u7.YawFromFlatDirection(Unit);
    local v25, v26 = u7.StepYawToward(v23, v24, p14);
    local v27 = u7.ShortestYawDelta(v25, v24);
    local v28 = math.abs(v27);
    local v29 = (math.cos(v28) - 0.2) / 0.8;
    local v30 = math.clamp(v29, 0, 1);

    return CFrame.new(Position + Unit * v20 * v30) * CFrame.Angles(0, v25, 0), v30 > 0 and true or math.abs(v26) > 0.008726646259971648, p17 * v30;
end;

function u7.FaceOwnerCFrame(p31, p32, p33, p34) -- Line: 69
    -- upvalues: u7 (copy)
    local Position = p31.Position;
    local v35 = Vector3.new(p32.X - Position.X, 0, p32.Z - Position.Z);

    if v35.Magnitude <= 0 then
        return p31;
    end;

    local LookVector = p31.LookVector;
    local v36 = Vector3.new(LookVector.X, 0, LookVector.Z);
    assert(v36.Magnitude > 0, "Asset wander CFrame must have a horizontal facing direction");
    local v37 = u7.YawFromFlatDirection(v36.Unit);
    local v38 = u7.YawFromFlatDirection(v35.Unit);

    if p34 ~= true then
        v38 = u7.StepYawToward(v37, v38, p33);
    end;

    return CFrame.new(Position) * CFrame.Angles(0, v38, 0);
end;

function u7.StepFollowOwner(p39, p40, p41, p42, p43, p44, p45) -- Line: 92
    -- upvalues: AssetWanderArea (copy), u7 (copy)
    local v46 = AssetWanderArea.PointNearOwner(p39, p42, p43);
    local v47, v48, v49 = u7.StepMoveToward(p40, p41, v46, p44);

    if Vector3.new(v46.X - v47.Position.X, 0, v46.Z - v47.Position.Z).Magnitude <= p45 then
        v47 = u7.FaceOwnerCFrame(v47, p42, p40);
    end;

    return v47, v48, v49;
end;

function u7.OwnerMoveVector(p50, p51, p52) -- Line: 111
    if p51 == nil then
        return Vector3.new(0, 0, 0), nil;
    end;

    if p52 == nil or p50 <= 0 then
        return Vector3.new(0, 0, 0), p51;
    end;

    local v53 = p51 - p52;

    return Vector3.new(v53.X, 0, v53.Z) / p50, p51;
end;

function u7.OrbitGreetingCFrame(p54, p55, p56, p57, p58, p59, p60, p61) -- Line: 127
    -- upvalues: AssetWanderArea (copy), u7 (copy)
    local Position = p56.Position;
    local v62 = Vector3.new(Position.X - p57.X, 0, Position.Z - p57.Z);
    local v63;

    if v62.Magnitude == 0 then
        local LookVector = p54.CFrame.LookVector;
        local v64 = Vector3.new(LookVector.X, 0, LookVector.Z);
        assert(v64.Magnitude > 0, "Asset area must provide a horizontal orbit greeting direction");
        v63 = v64.Unit;
    else
        local Unit = v62.Unit;
        v63 = (Vector3.new(-Unit.Z, 0, Unit.X) + Unit * math.clamp((p59 - v62.Magnitude) / p59, -p61, p61)).Unit;
    end;

    local v65 = v63 * p60 + p58;
    local v66 = Vector3.new(v65.X, 0, v65.Z);
    local Magnitude = v65.Magnitude;

    if v66.Magnitude <= 0 then
        return p56, false, 0;
    end;

    local v67 = AssetWanderArea.ClampedPointToward(p54, Position + v65 * p55);
    local v68 = Vector3.new(v67.X - Position.X, 0, v67.Z - Position.Z);

    if v68.Magnitude <= 0 then
        return p56, false, 0;
    end;

    local v69 = u7.YawFromFlatDirection(v68.Unit);

    return CFrame.new(v67) * CFrame.Angles(0, v69, 0), true, Magnitude;
end;

return u7;