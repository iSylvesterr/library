-- Decompiled with Potassium's decompiler.

local v1 = {};

local function asRange(p2, p3) -- Line: 11
    if typeof(p2) == "NumberRange" then
        return p2;
    end;

    if typeof(p2) == "number" then
        return NumberRange.new(p2);
    end;

    return p3;
end;

function v1.readRocks(p4, p5, p6, p7) -- Line: 17
    p4.PartLife = p6:GetAttribute("PartLife") or 0;
    p4.Lifetime = p6:GetAttribute("Lifetime") or NumberRange.new(3);
    p4.Rate = p6:GetAttribute("Rate") or 2;
    p4.BurstMode = p6:GetAttribute("BurstMode") or "Directional";
    p4.EmissionDirection = p7(Enum.NormalId, p6:GetAttribute("EmissionDirection"), Enum.NormalId.Top);
    p4.SpreadAngle = p6:GetAttribute("SpreadAngle") or Vector2.new(25, 25);
    p4.Speed = p6:GetAttribute("Speed");
    local v8 = p6:GetAttribute("ChunkCount");
    local v9 = NumberRange.new(6, 10);

    if typeof(v8) == "NumberRange" then
        v9 = v8;
    elseif typeof(v8) == "number" then
        v9 = NumberRange.new(v8);
    end;

    p4.ChunkCount = v9;
    local v10 = p6:GetAttribute("ChunkScale");
    local v11 = NumberRange.new(0.5, 1.5);

    if typeof(v10) == "NumberRange" then
        v11 = v10;
    elseif typeof(v10) == "number" then
        v11 = NumberRange.new(v10);
    end;

    p4.ChunkScale = v11;
    local v12 = p6:GetAttribute("PosX");
    local v13 = NumberRange.new(0);

    if typeof(v12) == "NumberRange" then
        v13 = v12;
    elseif typeof(v12) == "number" then
        v13 = NumberRange.new(v12);
    end;

    p4.PosX = v13;
    local v14 = p6:GetAttribute("PosY");
    local v15 = NumberRange.new(0);

    if typeof(v14) == "NumberRange" then
        v15 = v14;
    elseif typeof(v14) == "number" then
        v15 = NumberRange.new(v14);
    end;

    p4.PosY = v15;
    local v16 = p6:GetAttribute("PosZ");
    local v17 = NumberRange.new(0);

    if typeof(v16) == "NumberRange" then
        v17 = v16;
    elseif typeof(v16) == "number" then
        v17 = NumberRange.new(v16);
    end;

    p4.PosZ = v17;
    p4.PosMode = p6:GetAttribute("PosMode") or "Local";
    p4.PosXEven = p6:GetAttribute("PosXEven") == true;
    p4.PosYEven = p6:GetAttribute("PosYEven") == true;
    p4.PosZEven = p6:GetAttribute("PosZEven") == true;
    p4.Gravity = p6:GetAttribute("Gravity") or 196.2;
    local v18 = p6:GetAttribute("Bounciness");
    local v19 = NumberRange.new(0.3, 0.5);

    if typeof(v18) == "NumberRange" then
        v19 = v18;
    elseif typeof(v18) == "number" then
        v19 = NumberRange.new(v18);
    end;

    p4.Bounciness = v19;
    p4.Friction = p6:GetAttribute("Friction") or 0.3;
    local v20 = p6:GetAttribute("TumbleSpeed");
    local v21 = NumberRange.new(90, 360);

    if typeof(v20) == "NumberRange" then
        v21 = v20;
    elseif typeof(v20) == "number" then
        v21 = NumberRange.new(v20);
    end;

    p4.TumbleSpeed = v21;
    p4.SinkOut = p6:GetAttribute("SinkOut") ~= false;
    p4.InheritFloor = p6:GetAttribute("InheritFloor") == true;
    p4.Scale = p6:GetAttribute("Scale");
    p4.Color = p6:GetAttribute("Color");
    p4.Brightness = p6:GetAttribute("Brightness");
    p4.Transparency = p6:GetAttribute("Transparency");
    p4.Timescale = p6:GetAttribute("Timescale");
    p4.Pool = p6:GetAttribute("Pool");

    return p4;
end;

function v1.readRope(p22, p23, p24, p25) -- Line: 54
    p22.PartLife = p24:GetAttribute("PartLife") or 0;
    p22.Lifetime = p24:GetAttribute("Lifetime") or NumberRange.new(2);
    p22.Rate = p24:GetAttribute("Rate") or 1;
    local v26 = p24:GetAttribute("SegmentCount");
    local v27 = NumberRange.new(12);

    if typeof(v26) == "NumberRange" then
        v27 = v26;
    elseif typeof(v26) == "number" then
        v27 = NumberRange.new(v26);
    end;

    p22.SegmentCount = v27;
    p22.PinMode = p24:GetAttribute("PinMode") or "BothEnds";
    local Target = p23:FindFirstChild("Target");
    p22.Target = Target and (Target:IsA("ObjectValue") and Target.Value) or nil;
    local v28 = p24:GetAttribute("RopeLength");
    local v29 = NumberRange.new(0);

    if typeof(v28) == "NumberRange" then
        v29 = v28;
    elseif typeof(v28) == "number" then
        v29 = NumberRange.new(v28);
    end;

    p22.RopeLength = v29;
    p22.Slack = p24:GetAttribute("Slack") or 1.2;
    p22.Stiffness = p24:GetAttribute("Stiffness") or 4;
    p22.Damping = p24:GetAttribute("Damping") or 0.03;
    p22.Gravity = p24:GetAttribute("Gravity") or Vector3.new(0, -40, 0);
    local v30 = p24:GetAttribute("WindAmplitude");
    local v31 = NumberRange.new(0);

    if typeof(v30) == "NumberRange" then
        v31 = v30;
    elseif typeof(v30) == "number" then
        v31 = NumberRange.new(v30);
    end;

    p22.WindAmplitude = v31;
    p22.WindFrequency = p24:GetAttribute("WindFrequency") or 2;
    p22.SpawnTarget = p24:GetAttribute("SpawnTarget") or "Start";
    local v32 = p24:GetAttribute("PosX");
    local v33 = NumberRange.new(0);

    if typeof(v32) == "NumberRange" then
        v33 = v32;
    elseif typeof(v32) == "number" then
        v33 = NumberRange.new(v32);
    end;

    p22.PosX = v33;
    local v34 = p24:GetAttribute("PosY");
    local v35 = NumberRange.new(0);

    if typeof(v34) == "NumberRange" then
        v35 = v34;
    elseif typeof(v34) == "number" then
        v35 = NumberRange.new(v34);
    end;

    p22.PosY = v35;
    local v36 = p24:GetAttribute("PosZ");
    local v37 = NumberRange.new(0);

    if typeof(v36) == "NumberRange" then
        v37 = v36;
    elseif typeof(v36) == "number" then
        v37 = NumberRange.new(v36);
    end;

    p22.PosZ = v37;
    p22.PosXEven = p24:GetAttribute("PosXEven") == true;
    p22.PosYEven = p24:GetAttribute("PosYEven") == true;
    p22.PosZEven = p24:GetAttribute("PosZEven") == true;
    p22.PosMode = p24:GetAttribute("PosMode") or "Local";
    local v38 = p24:GetAttribute("RotX");
    local v39 = NumberRange.new(0);

    if typeof(v38) == "NumberRange" then
        v39 = v38;
    elseif typeof(v38) == "number" then
        v39 = NumberRange.new(v38);
    end;

    p22.RotX = v39;
    local v40 = p24:GetAttribute("RotY");
    local v41 = NumberRange.new(0);

    if typeof(v40) == "NumberRange" then
        v41 = v40;
    elseif typeof(v40) == "number" then
        v41 = NumberRange.new(v40);
    end;

    p22.RotY = v41;
    local v42 = p24:GetAttribute("RotZ");
    local v43 = NumberRange.new(0);

    if typeof(v42) == "NumberRange" then
        v43 = v42;
    elseif typeof(v42) == "number" then
        v43 = NumberRange.new(v42);
    end;

    p22.RotZ = v43;
    p22.RotXEven = p24:GetAttribute("RotXEven") == true;
    p22.RotYEven = p24:GetAttribute("RotYEven") == true;
    p22.RotZEven = p24:GetAttribute("RotZEven") == true;
    p22.RotOrder = p24:GetAttribute("RotOrder") or "Global";
    p22.GrowIn = p24:GetAttribute("GrowIn") or 0;
    p22.DeathMode = p24:GetAttribute("DeathMode") or "None";
    p22.DeathWindow = p24:GetAttribute("DeathWindow") or 0.2;
    p22.BendStiffness = p24:GetAttribute("BendStiffness") or 0;
    p22.ThicknessProfile = p24:GetAttribute("ThicknessProfile");
    p22.MotionDirection = p25(Enum.NormalId, p24:GetAttribute("MotionDirection"), Enum.NormalId.Front);
    p22.MotionTarget = p24:GetAttribute("MotionTarget") or "Start";
    p22.Speed = p24:GetAttribute("Speed");
    p22.Acceleration = p24:GetAttribute("Acceleration") or Vector3.new(0, 0, 0);
    p22.Drag = p24:GetAttribute("Drag") or 0;
    p22.PosOffsetX = p24:GetAttribute("PosOffsetX");
    p22.PosOffsetY = p24:GetAttribute("PosOffsetY");
    p22.PosOffsetZ = p24:GetAttribute("PosOffsetZ");
    p22.Turbulence = p24:GetAttribute("Turbulence");
    p22.TurbulenceFrequency = p24:GetAttribute("TurbulenceFrequency") or 1;
    p22.DisplacementMode = p24:GetAttribute("DisplacementMode") or "Global";
    local v44 = p24:GetAttribute("LaunchSpeed");
    local v45 = NumberRange.new(40);

    if typeof(v44) == "NumberRange" then
        v45 = v44;
    elseif typeof(v44) == "number" then
        v45 = NumberRange.new(v44);
    end;

    p22.LaunchSpeed = v45;
    p22.EmissionDirection = p25(Enum.NormalId, p24:GetAttribute("EmissionDirection"), Enum.NormalId.Front);
    p22.SpreadAngle = p24:GetAttribute("SpreadAngle") or Vector2.new(0, 0);
    p22.Color = p24:GetAttribute("Color");
    p22.Brightness = p24:GetAttribute("Brightness");
    p22.Transparency = p24:GetAttribute("Transparency");
    p22.Thickness = p24:GetAttribute("Thickness");
    p22.Timescale = p24:GetAttribute("Timescale");
    p22.Pool = p24:GetAttribute("Pool");

    return p22;
end;

return v1;