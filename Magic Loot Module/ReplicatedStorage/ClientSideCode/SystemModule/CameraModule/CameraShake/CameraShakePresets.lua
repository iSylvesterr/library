-- Decompiled with Potassium's decompiler.

local CameraShakeInstance = require(script.Parent.CameraShakeInstance);
local u1 = {
    Attack = 1.73,
    Clash = 3.23,
    BigClash = 1.5,
    LongClash = 0.5,
    MagicHit = 1.22
};

local function _resolveTickSeed(p2) -- Line: 71
    -- upvalues: u1 (copy)
    local v3 = u1[p2];

    if type(v3) == "number" then
        return v3;
    end;

    return Random.new():NextNumber(-100, 100);
end;

local function _newPreset(p4, p5, p6, p7, p8) -- Line: 89
    -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
    return CameraShakeInstance.new(p5, p6, p7, p8, _resolveTickSeed(p4));
end;

local u87 = {
    MagicHit = function(p9) -- Line: 105, Name: MagicHit
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v10 = CameraShakeInstance.new(8, 2, 0, 0.3, _resolveTickSeed(p9));
        v10.PositionInfluence = Vector3.new(1, 0, 1);
        v10.RotationInfluence = Vector3.new(0, 1, 0);

        return v10;
    end,

    QuickAttack = function(p11) -- Line: 118, Name: QuickAttack
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v12 = CameraShakeInstance.new(2, 10, 0, 0.3, _resolveTickSeed(p11));
        v12.PositionInfluence = Vector3.new(0.15, 0.15, 0.15);
        v12.RotationInfluence = Vector3.new(1.2, 1, 1);

        return v12;
    end,

    Attack = function(p13) -- Line: 132, Name: Attack
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v14 = CameraShakeInstance.new(1.2, 1, 0, 0.05, _resolveTickSeed(p13));
        v14.PositionInfluence = Vector3.new(1, 0, 1);
        v14.RotationInfluence = Vector3.new(0, 0, 0);

        return v14;
    end,

    HeavyAttack = function(p15) -- Line: 145, Name: HeavyAttack
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v16 = CameraShakeInstance.new(3, 10, 0, 0.55, _resolveTickSeed(p15));
        v16.PositionInfluence = Vector3.new(0.3, 0.25, 0.25);
        v16.RotationInfluence = Vector3.new(1.5, 1, 1.2);

        return v16;
    end,

    AttackLong = function(p17) -- Line: 158, Name: AttackLong
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v18 = CameraShakeInstance.new(2, 10, 0.1, 1.7, _resolveTickSeed(p17));
        v18.PositionInfluence = Vector3.new(0.1, 0.05, 0.05);
        v18.RotationInfluence = Vector3.new(1, 0.5, 0.5);

        return v18;
    end,

    Shot = function(p19) -- Line: 171, Name: Shot
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v20 = CameraShakeInstance.new(2, 8, 0, 0.3, _resolveTickSeed(p19));
        v20.PositionInfluence = Vector3.new(0.1, 0.2, 0.1);
        v20.RotationInfluence = Vector3.new(1.2, 1, 1);

        return v20;
    end,

    Clash = function(p21) -- Line: 190, Name: Clash
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v22 = CameraShakeInstance.new(5, 1, 0, 0.1, _resolveTickSeed(p21));
        v22.PositionInfluence = Vector3.new(1, 0, 1);
        v22.RotationInfluence = Vector3.new(0, 0, 0);

        return v22;
    end,

    BigClash = function(p23) -- Line: 203, Name: BigClash
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v24 = CameraShakeInstance.new(10, 25, 0.3, 0.5, _resolveTickSeed(p23));
        v24.PositionInfluence = Vector3.new(0.5, 0.5, 0.5);
        v24.RotationInfluence = Vector3.new(1, 1, 1);

        return v24;
    end,

    LongClash = function(p25) -- Line: 216, Name: LongClash
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v26 = CameraShakeInstance.new(10, 25, 0.7, 1.1, _resolveTickSeed(p25));
        v26.PositionInfluence = Vector3.new(0.5, 0.5, 0.5);
        v26.RotationInfluence = Vector3.new(1, 1, 1);

        return v26;
    end,

    Hit = function(p27) -- Line: 234, Name: Hit
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v28 = CameraShakeInstance.new(2.75, 12.5, 0.1, 0.5, _resolveTickSeed(p27));
        v28.PositionInfluence = Vector3.new(0.15, 0.15, 0.15);
        v28.RotationInfluence = Vector3.new(1, 1, 1);

        return v28;
    end,

    Bump = function(p29) -- Line: 251, Name: Bump
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v30 = CameraShakeInstance.new(2.5, 4, 0.1, 0.75, _resolveTickSeed(p29));
        v30.PositionInfluence = Vector3.new(0.15, 0.15, 0.15);
        v30.RotationInfluence = Vector3.new(1, 1, 1);

        return v30;
    end,

    Bump2 = function(p31) -- Line: 262, Name: Bump2
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v32 = CameraShakeInstance.new(2.5, 4, 0.1, 0.75, _resolveTickSeed(p31));
        v32.PositionInfluence = Vector3.new(0.15, 0.15, 0.15);
        v32.RotationInfluence = Vector3.new(1, 1, 1);

        return v32;
    end,

    Bump3 = function(p33) -- Line: 275, Name: Bump3
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v34 = CameraShakeInstance.new(1, 2, 0.1, 0.75, _resolveTickSeed(p33));
        v34.PositionInfluence = Vector3.new(0.3, 0.3, 0.3);
        v34.RotationInfluence = Vector3.new(2, 2, 2);

        return v34;
    end,

    Bump4 = function(p35) -- Line: 288, Name: Bump4
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v36 = CameraShakeInstance.new(3, 12, 0.6, 1, _resolveTickSeed(p35));
        v36.PositionInfluence = Vector3.new(0.3, 0.3, 0.3);
        v36.RotationInfluence = Vector3.new(0.5, 0.5, 0.5);

        return v36;
    end,

    TinyShake = function(p37) -- Line: 301, Name: TinyShake
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v38 = CameraShakeInstance.new(4, 8, 0, 0.2, _resolveTickSeed(p37));
        v38.PositionInfluence = Vector3.new(0.3, 0.3, 0.3);
        v38.RotationInfluence = Vector3.new(1.5, 0.6, 1.5);

        return v38;
    end,

    TinyShake2 = function(p39) -- Line: 312, Name: TinyShake2
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v40 = CameraShakeInstance.new(4, 9, 0, 0.2, _resolveTickSeed(p39));
        v40.PositionInfluence = Vector3.new(0.4, 0.3, 0.4);
        v40.RotationInfluence = Vector3.new(1.7, 0.6, 1.7);

        return v40;
    end,

    TinyShake3 = function(p41) -- Line: 323, Name: TinyShake3
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v42 = CameraShakeInstance.new(5, 10, 0, 0.2, _resolveTickSeed(p41));
        v42.PositionInfluence = Vector3.new(0.5, 0.3, 0.5);
        v42.RotationInfluence = Vector3.new(2, 0.6, 2);

        return v42;
    end,

    MiddleShake = function(p43) -- Line: 335, Name: MiddleShake
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v44 = CameraShakeInstance.new(5, 10, 0.1, 0.5, _resolveTickSeed(p43));
        v44.PositionInfluence = Vector3.new(0.3, 0.3, 0.3);
        v44.RotationInfluence = Vector3.new(2, 1, 2);

        return v44;
    end,

    MiddleShakeLong = function(p45) -- Line: 346, Name: MiddleShakeLong
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v46 = CameraShakeInstance.new(5, 10, 0.1, 0.8, _resolveTickSeed(p45));
        v46.PositionInfluence = Vector3.new(0.3, 0.3, 0.3);
        v46.RotationInfluence = Vector3.new(2, 1, 2);

        return v46;
    end,

    MiddleShakeLong2 = function(p47) -- Line: 357, Name: MiddleShakeLong2
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v48 = CameraShakeInstance.new(5, 10, 0.1, 0.8, _resolveTickSeed(p47));
        v48.PositionInfluence = Vector3.new(0.3, 0.2, 0.2);
        v48.RotationInfluence = Vector3.new(2, 1, 1.5);

        return v48;
    end,

    Explosion = function(p49) -- Line: 375, Name: Explosion
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v50 = CameraShakeInstance.new(5, 10, 0, 1.5, _resolveTickSeed(p49));
        v50.PositionInfluence = Vector3.new(0.25, 0.25, 0.25);
        v50.RotationInfluence = Vector3.new(1, 1, 1);

        return v50;
    end,

    Explosion2 = function(p51) -- Line: 387, Name: Explosion2
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v52 = CameraShakeInstance.new(5, 10, 0, 0.3, _resolveTickSeed(p51));
        v52.PositionInfluence = Vector3.new(0.25, 0.25, 0.25);
        v52.RotationInfluence = Vector3.new(1, 1, 1);

        return v52;
    end,

    Explosion3 = function(p53) -- Line: 399, Name: Explosion3
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v54 = CameraShakeInstance.new(5, 10, 0.2, 0.5, _resolveTickSeed(p53));
        v54.PositionInfluence = Vector3.new(0.25, 0.25, 0.25);
        v54.RotationInfluence = Vector3.new(1, 1, 1);

        return v54;
    end,

    Explosion4 = function(p55) -- Line: 411, Name: Explosion4
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v56 = CameraShakeInstance.new(5, 10, 0.2, 1, _resolveTickSeed(p55));
        v56.PositionInfluence = Vector3.new(0.25, 0.25, 0.25);
        v56.RotationInfluence = Vector3.new(1.5, 1.5, 1.5);

        return v56;
    end,

    Earthquake = function(p57) -- Line: 430, Name: Earthquake
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v58 = CameraShakeInstance.new(0.6, 3.5, 2, 10, _resolveTickSeed(p57));
        v58.PositionInfluence = Vector3.new(0.25, 0.25, 0.25);
        v58.RotationInfluence = Vector3.new(1, 1, 4);

        return v58;
    end,

    BadTrip = function(p59) -- Line: 443, Name: BadTrip
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v60 = CameraShakeInstance.new(10, 0.15, 5, 10, _resolveTickSeed(p59));
        v60.PositionInfluence = Vector3.new(0, 0, 0.15);
        v60.RotationInfluence = Vector3.new(2, 1, 4);

        return v60;
    end,

    HandheldCamera = function(p61) -- Line: 456, Name: HandheldCamera
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v62 = CameraShakeInstance.new(1, 0.25, 5, 10, _resolveTickSeed(p61));
        v62.PositionInfluence = Vector3.new(0, 0, 0);
        v62.RotationInfluence = Vector3.new(1, 0.5, 0.5);

        return v62;
    end,

    Vibration = function(p63) -- Line: 469, Name: Vibration
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v64 = CameraShakeInstance.new(0.4, 20, 2, 2, _resolveTickSeed(p63));
        v64.PositionInfluence = Vector3.new(0, 0.15, 0);
        v64.RotationInfluence = Vector3.new(1.25, 0, 4);

        return v64;
    end,

    RoughDriving = function(p65) -- Line: 482, Name: RoughDriving
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v66 = CameraShakeInstance.new(1, 2, 1, 1, _resolveTickSeed(p65));
        v66.PositionInfluence = Vector3.new(0, 0, 0);
        v66.RotationInfluence = Vector3.new(1, 1, 1);

        return v66;
    end,

    LightHit = function(p67) -- Line: 500, Name: LightHit
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v68 = CameraShakeInstance.new(4, 7, 0.1, 0.75, _resolveTickSeed(p67));
        v68.PositionInfluence = Vector3.new(0.25, 0.25, 0);
        v68.RotationInfluence = Vector3.new(0, 0, 0);

        return v68;
    end,

    MediumHit = function(p69) -- Line: 513, Name: MediumHit
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v70 = CameraShakeInstance.new(6, 9.5, 0.1, 0.85, _resolveTickSeed(p69));
        v70.PositionInfluence = Vector3.new(0.325, 0.325, 0);
        v70.RotationInfluence = Vector3.new(0, 0, 0);

        return v70;
    end,

    HeavyHit = function(p71) -- Line: 526, Name: HeavyHit
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v72 = CameraShakeInstance.new(8, 14, 0, 1.25, _resolveTickSeed(p71));
        v72.PositionInfluence = Vector3.new(0.5, 0.5, 0);
        v72.RotationInfluence = Vector3.new(0, 0, 0);

        return v72;
    end,

    Snap = function(p73) -- Line: 539, Name: Snap
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v74 = CameraShakeInstance.new(8, 25, 0, 0.7, _resolveTickSeed(p73));
        v74.PositionInfluence = Vector3.new(0.6, 0.6, 0);
        v74.RotationInfluence = Vector3.new(0, 0, 0);

        return v74;
    end,

    SnapOh = function(p75) -- Line: 550, Name: SnapOh
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v76 = CameraShakeInstance.new(8, 25, 0, 1.4, _resolveTickSeed(p75));
        v76.PositionInfluence = Vector3.new(0.6, 0.6, 0);
        v76.RotationInfluence = Vector3.new(0, 0, 0);

        return v76;
    end,

    LightLoop = function(p77) -- Line: 563, Name: LightLoop
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v78 = CameraShakeInstance.new(7, 7, 0.04, 0.04, _resolveTickSeed(p77));
        v78.PositionInfluence = Vector3.new(0.1, 0.1, 0);
        v78.RotationInfluence = Vector3.new(0, 0, 0);

        return v78;
    end,

    HeavyLoop = function(p79) -- Line: 576, Name: HeavyLoop
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v80 = CameraShakeInstance.new(7, 12, 0.03, 0.03, _resolveTickSeed(p79));
        v80.PositionInfluence = Vector3.new(0.3, 0.3, 0);
        v80.RotationInfluence = Vector3.new(0, 0, 0);

        return v80;
    end,

    SmallBump = function(p81) -- Line: 589, Name: SmallBump
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v82 = CameraShakeInstance.new(2.5, 4, 0.1, 0.75, _resolveTickSeed(p81));
        v82.PositionInfluence = Vector3.new(0.01, 0.01, 0.01);
        v82.RotationInfluence = Vector3.new(0.25, 0.25, 0.25);

        return v82;
    end,

    QuickBumpSmall = function(p83) -- Line: 602, Name: QuickBumpSmall
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v84 = CameraShakeInstance.new(4, 14, 0, 0.3, _resolveTickSeed(p83));
        v84.PositionInfluence = Vector3.new(0.12, 0.18, 0.12);
        v84.RotationInfluence = Vector3.new(1.2, 1.2, 1.2);

        return v84;
    end,

    ViolenterBump = function(p85) -- Line: 614, Name: ViolenterBump
        -- upvalues: CameraShakeInstance (copy), _resolveTickSeed (copy)
        local v86 = CameraShakeInstance.new(4.5, 13.5, 0.1, 0.35, _resolveTickSeed(p85));
        v86.PositionInfluence = Vector3.new(0.3, 0.3, 0.3);
        v86.RotationInfluence = Vector3.new(1.4, 1.4, 1.4);

        return v86;
    end
};

return setmetatable({}, {
    __index = function(p88, p89) -- Line: 628, Name: __index
        -- upvalues: u87 (copy)
        local v90 = u87[p89];

        if type(v90) == "function" then
            return v90(p89);
        end;

        error("No preset found with index \"" .. p89 .. "\"");
    end
});