-- Decompiled with Potassium's decompiler.

local CameraShakeInstance = require(script.Parent.CameraShakeInstance);
local u10 = {
    Bump = function() -- Line: 26, Name: Bump
        -- upvalues: CameraShakeInstance (copy)
        local v1 = CameraShakeInstance.new(2.5, 4, 0.1, 0.75);
        v1.PositionInfluence = Vector3.new(0.15, 0.15, 0.15);
        v1.RotationInfluence = Vector3.new(1, 1, 1);

        return v1;
    end,

    Landed = function() -- Line: 33, Name: Landed
        -- upvalues: CameraShakeInstance (copy)
        local v2 = CameraShakeInstance.new(2, 3, 0.1, 0.5);
        v2.PositionInfluence = Vector3.new(0, 0, 0);
        v2.RotationInfluence = Vector3.new(1, 0, 0.15);

        return v2;
    end,

    Shoot = function() -- Line: 40, Name: Shoot
        -- upvalues: CameraShakeInstance (copy)
        local v3 = CameraShakeInstance.new(0.3, 5, 0.1, 0.2);
        v3.PositionInfluence = Vector3.new(0, 0, 0.5);
        v3.RotationInfluence = Vector3.new(0.5, 0.5, 0.5);

        return v3;
    end,

    Explosion = function() -- Line: 49, Name: Explosion
        -- upvalues: CameraShakeInstance (copy)
        local v4 = CameraShakeInstance.new(5, 10, 0, 1.5);
        v4.PositionInfluence = Vector3.new(0.25, 0.25, 0.25);
        v4.RotationInfluence = Vector3.new(4, 1, 1);

        return v4;
    end,

    Earthquake = function() -- Line: 59, Name: Earthquake
        -- upvalues: CameraShakeInstance (copy)
        local v5 = CameraShakeInstance.new(0.6, 3.5, 2, 10);
        v5.PositionInfluence = Vector3.new(0.25, 0.25, 0.25);
        v5.RotationInfluence = Vector3.new(1, 1, 4);

        return v5;
    end,

    BadTrip = function() -- Line: 69, Name: BadTrip
        -- upvalues: CameraShakeInstance (copy)
        local v6 = CameraShakeInstance.new(10, 0.15, 5, 10);
        v6.PositionInfluence = Vector3.new(0, 0, 0.15);
        v6.RotationInfluence = Vector3.new(2, 1, 4);

        return v6;
    end,

    HandheldCamera = function() -- Line: 79, Name: HandheldCamera
        -- upvalues: CameraShakeInstance (copy)
        local v7 = CameraShakeInstance.new(1, 0.25, 5, 10);
        v7.PositionInfluence = Vector3.new(0, 0, 0);
        v7.RotationInfluence = Vector3.new(1, 0.5, 0.5);

        return v7;
    end,

    Vibration = function() -- Line: 89, Name: Vibration
        -- upvalues: CameraShakeInstance (copy)
        local v8 = CameraShakeInstance.new(0.4, 20, 2, 2);
        v8.PositionInfluence = Vector3.new(0, 0.15, 0);
        v8.RotationInfluence = Vector3.new(1.25, 0, 4);

        return v8;
    end,

    RoughDriving = function() -- Line: 99, Name: RoughDriving
        -- upvalues: CameraShakeInstance (copy)
        local v9 = CameraShakeInstance.new(1, 2, 1, 1);
        v9.PositionInfluence = Vector3.new(0, 0, 0);
        v9.RotationInfluence = Vector3.new(1, 1, 1);

        return v9;
    end
};

return setmetatable({}, {
    __index = function(p11, p12) -- Line: 111, Name: __index
        -- upvalues: u10 (copy)
        local v13 = u10[p12];

        if type(v13) == "function" then
            return v13();
        end;

        error("No preset found with index \"" .. p12 .. "\"");
    end
});