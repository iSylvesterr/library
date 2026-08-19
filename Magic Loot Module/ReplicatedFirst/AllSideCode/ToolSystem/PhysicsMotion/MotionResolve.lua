-- Decompiled with Potassium's decompiler.

local u1 = {
    Forward = 0,
    Backward = 180,
    Left = 90,
    Right = -90
};
local u4 = {
    parseEasingStyle = function(u2) -- Line: 28, Name: parseEasingStyle
        if type(u2) ~= "string" then
            return Enum.EasingStyle.Quad;
        end;

        local success, result = pcall(function() -- Line: 32
            -- upvalues: u2 (copy)
            return Enum.EasingStyle[u2];
        end);

        return success and result and result or Enum.EasingStyle.Quad;
    end,

    parseEasingDirection = function(u3) -- Line: 47, Name: parseEasingDirection
        if type(u3) ~= "string" then
            return Enum.EasingDirection.Out;
        end;

        local success, result = pcall(function() -- Line: 51
            -- upvalues: u3 (copy)
            return Enum.EasingDirection[u3];
        end);

        return success and result and result or Enum.EasingDirection.Out;
    end
};

local function _flattenDirection(p5, p6) -- Line: 67
    if p6 == "xyz" then
        return p5.Magnitude < 0.0001 and Vector3.new(0, 0, 0) or p5.Unit;
    end;

    local v7 = Vector3.new(p5.X, 0, p5.Z);

    return v7.Magnitude < 0.0001 and Vector3.new(0, 0, 0) or v7.Unit;
end;

function u4.resolveWorldDirection(p8, p9) -- Line: 88
    -- upvalues: u1 (copy)
    local v10 = p8.plane or "xz";

    if typeof(p8.direction) == "Vector3" and p8.direction.Magnitude > 0.0001 then
        local direction = p8.direction;

        if v10 == "xyz" then
            return direction.Magnitude < 0.0001 and Vector3.new(0, 0, 0) or direction.Unit;
        end;

        local v11 = Vector3.new(direction.X, 0, direction.Z);

        return v11.Magnitude < 0.0001 and Vector3.new(0, 0, 0) or v11.Unit;
    end;

    if typeof(p8.directionFrom) == "Vector3" and typeof(p8.directionTo) == "Vector3" then
        local v12 = p8.directionTo - p8.directionFrom;

        if v10 == "xyz" then
            return v12.Magnitude < 0.0001 and Vector3.new(0, 0, 0) or v12.Unit;
        end;

        local v13 = Vector3.new(v12.X, 0, v12.Z);

        return v13.Magnitude < 0.0001 and Vector3.new(0, 0, 0) or v13.Unit;
    end;

    if type(p8.relativeYaw) ~= "number" and type(p8.relativeDirection) ~= "string" then
        if typeof(p8.directionTo) ~= "Vector3" then
            return Vector3.new(0, 0, 0);
        end;

        local v14 = p8.directionTo - p9.Position;

        if v10 == "xyz" then
            return v14.Magnitude < 0.0001 and Vector3.new(0, 0, 0) or v14.Unit;
        end;

        local v15 = Vector3.new(v14.X, 0, v14.Z);

        return v15.Magnitude < 0.0001 and Vector3.new(0, 0, 0) or v15.Unit;
    end;

    local relativeYaw = p8.relativeYaw;
    local v16 = relativeYaw == nil and type(p8.relativeDirection) == "string" and (u1[p8.relativeDirection] or 0) or relativeYaw;
    local LookVector = p9:GetPivot():ToWorldSpace(CFrame.Angles(0, math.rad(v16), 0)).LookVector;

    if v10 == "xyz" then
        return LookVector.Magnitude < 0.0001 and Vector3.new(0, 0, 0) or LookVector.Unit;
    end;

    local v17 = Vector3.new(LookVector.X, 0, LookVector.Z);

    return v17.Magnitude < 0.0001 and Vector3.new(0, 0, 0) or v17.Unit;
end;

function u4.calcMaxForce(p18, p19) -- Line: 124
    local AssemblyMass = p18.AssemblyMass;

    return (AssemblyMass < 0.001 and 1 or AssemblyMass) * (p19 or 800);
end;

function u4.normalize(p20) -- Line: 141
    -- upvalues: u4 (copy)
    if type(p20) ~= "table" then
        return nil, nil, nil;
    end;

    local subject = p20.subject;

    if not (subject and subject:IsA("Model")) then
        return nil, nil, nil;
    end;

    local HumanoidRootPart = subject:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return nil, nil, nil;
    end;

    local v21 = table.clone(p20);
    v21.subject = subject;
    v21.mode = v21.mode or "velocity";
    v21.channel = v21.channel or "default";
    v21.plane = v21.plane or "xz";
    v21.duration = tonumber(v21.duration) or 0;
    v21.endFactor = v21.endFactor == nil and 0 or v21.endFactor;
    v21.replaceSameChannel = v21.replaceSameChannel == nil and true or v21.replaceSameChannel;
    v21.preserveVertical = v21.preserveVertical == nil and true or v21.preserveVertical;
    v21.easingStyle = u4.parseEasingStyle(v21.easingStyle);
    v21.easingDirection = u4.parseEasingDirection(v21.easingDirection);
    v21.maxForceMultiplier = tonumber(v21.maxForceMultiplier) or 800;
    v21.verticalDampDuration = tonumber(v21.verticalDampDuration) or 0;
    v21.verticalDampFactor = tonumber(v21.verticalDampFactor) or 0.7;
    v21.kickSpeed = tonumber(v21.kickSpeed) or 0;
    v21.clearVelocityOnStart = v21.clearVelocityOnStart == true;
    v21.suppressCompetingVelocity = v21.suppressCompetingVelocity == true;
    v21.restoreVelocityOnEnd = v21.restoreVelocityOnEnd == true;
    v21.restoreVelocityOnCancel = v21.restoreVelocityOnCancel == nil and true or v21.restoreVelocityOnCancel;

    return v21, HumanoidRootPart, subject;
end;

return u4;