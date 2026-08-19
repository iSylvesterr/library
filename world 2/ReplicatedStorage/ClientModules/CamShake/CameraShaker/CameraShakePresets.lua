-- Decompiled with Potassium's decompiler.

local CameraShakeInstance = require(script.Parent.CameraShakeInstance);
local u11 = {
    Bump = function() -- Line: 26, Name: Bump
        -- upvalues: CameraShakeInstance (copy)
        local v1 = CameraShakeInstance.new(2.5, 4, 0.1, 0.75);
        v1.PositionInfluence = Vector3.new(0.15, 0.15, 0.15);
        v1.RotationInfluence = Vector3.new(0, 0, 0);

        return v1;
    end,

    Bump2 = function() -- Line: 33, Name: Bump2
        -- upvalues: CameraShakeInstance (copy)
        local v2 = CameraShakeInstance.new(4, 4, 0.1, 0.75);
        v2.PositionInfluence = Vector3.new(0.15, 0.15, 0.15);
        v2.RotationInfluence = Vector3.new(0, 0, 0);

        return v2;
    end,

    Explosion = function() -- Line: 42, Name: Explosion
        -- upvalues: CameraShakeInstance (copy)
        local v3 = CameraShakeInstance.new(5, 10, 0, 1.5);
        v3.PositionInfluence = Vector3.new(0.25, 0.25, 0.25);
        v3.RotationInfluence = Vector3.new(4, 1, 1);

        return v3;
    end,

    SideExplosion = function() -- Line: 49, Name: SideExplosion
        -- upvalues: CameraShakeInstance (copy)
        local v4 = CameraShakeInstance.new(5, 10, 0, 1.5);
        v4.PositionInfluence = Vector3.new(0.25, 0.25, 0);
        v4.RotationInfluence = Vector3.new(1, 1, 1);

        return v4;
    end,

    Earthquake = function() -- Line: 58, Name: Earthquake
        -- upvalues: CameraShakeInstance (copy)
        local v5 = CameraShakeInstance.new(0.6, 3.5, 2, 10);
        v5.PositionInfluence = Vector3.new(0.25, 0.25, 0.25);
        v5.RotationInfluence = Vector3.new(1, 1, 4);

        return v5;
    end,

    SoftEarthquake = function() -- Line: 65, Name: SoftEarthquake
        -- upvalues: CameraShakeInstance (copy)
        local v6 = CameraShakeInstance.new(0.3, 1.75, 0, 0);
        v6.PositionInfluence = Vector3.new(0.1, 0.1, 0.1);
        v6.RotationInfluence = Vector3.new(0.1, 0.1, 0.1);

        return v6;
    end,

    BadTrip = function() -- Line: 74, Name: BadTrip
        -- upvalues: CameraShakeInstance (copy)
        local v7 = CameraShakeInstance.new(10, 0.15, 5, 10);
        v7.PositionInfluence = Vector3.new(0, 0, 0.15);
        v7.RotationInfluence = Vector3.new(2, 1, 4);

        return v7;
    end,

    HandheldCamera = function() -- Line: 84, Name: HandheldCamera
        -- upvalues: CameraShakeInstance (copy)
        local v8 = CameraShakeInstance.new(1, 0.25, 5, 10);
        v8.PositionInfluence = Vector3.new(0.05, 0.05, 0.05);
        v8.RotationInfluence = Vector3.new(0.1, 0.1, 0.1);

        return v8;
    end,

    Vibration = function() -- Line: 94, Name: Vibration
        -- upvalues: CameraShakeInstance (copy)
        local v9 = CameraShakeInstance.new(0.4, 20, 2, 2);
        v9.PositionInfluence = Vector3.new(0, 0.15, 0);
        v9.RotationInfluence = Vector3.new(1.25, 0, 4);

        return v9;
    end,

    RoughDriving = function() -- Line: 104, Name: RoughDriving
        -- upvalues: CameraShakeInstance (copy)
        local v10 = CameraShakeInstance.new(1, 2, 1, 1);
        v10.PositionInfluence = Vector3.new(0, 0, 0);
        v10.RotationInfluence = Vector3.new(1, 1, 1);

        return v10;
    end
};

return setmetatable({}, {
    __index = function(p12, p13) -- Line: 116, Name: __index
        -- upvalues: u11 (copy)
        local v14 = u11[p13];

        if type(v14) == "function" then
            return v14();
        end;

        error("No preset found with index \"" .. p13 .. "\"");
    end
});