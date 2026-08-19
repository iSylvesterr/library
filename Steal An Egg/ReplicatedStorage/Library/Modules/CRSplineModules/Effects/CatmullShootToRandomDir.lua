-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local TableUtil = require(ReplicatedStorage.Library.Modules.Packages.TableUtil);
local Audio = require(ReplicatedStorage.Library.Audio);
local CatmullRomSpline = require(ReplicatedStorage.Library.Modules.CRSplineModules.CatmullRomSpline);
require(ReplicatedStorage.Library.Modules.CRSplineModules.BaseSpline);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local v1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();
local u2 = Random.new();
local u3 = false;

if not Constants.IS_STUDIO and u3 then
    v1:AtWarning():Log("NEVER let the spline debug be enabled in production!");
    u3 = false;
end;

local u4 = {
    SPIN_SPEED = 25.132741228718345,
    RANDOMIZE_END_DIR = false,
    END_DIRECTION = nil,
    DEATH_SPLINE_PROPULSION_INFO = TweenInfo.new(1.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    SPLINE_DIST = { 20, 30 },
    SPLINE_H1 = { 20, 30 },
    SPLINE_H2 = { 10, 20 },
    SPLINE_H3 = { 3, 4 },
    SPLINE_TENSION = { 0.6, 2 }
};
local u5 = t.interface({
    DEATH_SPLINE_PROPULSION_INFO = t.optional(t.TweenInfo),
    SPLINE_DIST = t.optional(t.array(t.number)),
    SPLINE_H1 = t.optional(t.array(t.number)),
    SPLINE_H2 = t.optional(t.array(t.number)),
    SPLINE_H3 = t.optional(t.array(t.number)),
    SPLINE_TENSION = t.optional(t.array(t.number)),
    CUSTOM_TRANSFORM_FN = t.optional(t.callback),
    SPIN_SPEED = t.optional(t.number),
    RANDOMIZE_END_DIR = t.optional(t.boolean),
    END_DIRECTION = t.optional(t.Vector3),
    THROW_SOUND = t.optional(Audio.__types.SoundFile)
});

local function getDefaultSpinTransform(u6) -- Line: 100
    -- upvalues: Asserts (copy)
    Asserts.number(u6);

    return function(p7, p8) -- Line: 103
        -- upvalues: u6 (copy)
        return p7 * CFrame.Angles(p8 * u6, 0, 0);
    end;
end;

local function getPreserveAnglesTransform(p9) -- Line: 109
    -- upvalues: Asserts (copy)
    Asserts.CFrame(p9);
    local u10, u11, u12 = p9:ToOrientation();

    return function(p13) -- Line: 113
        -- upvalues: u10 (copy), u11 (copy), u12 (copy)
        return CFrame.new(p13.Position) * CFrame.Angles(u10, u11, u12);
    end;
end;

return function(p14, p15, p16) -- Line: 118
    -- upvalues: Asserts (copy), u5 (copy), TableUtil (copy), u4 (copy), u2 (copy), CatmullRomSpline (copy), u3 (ref), Audio (copy)
    Asserts.BasePart(p14);
    Asserts.optional.func(p16);
    local v17 = p15 or {};
    assert(u5(v17));
    p14.Anchored = true;
    local v18 = TableUtil.Reconcile(v17, u4);
    local Position = p14.Position;
    local END_DIRECTION = v18.END_DIRECTION;
    local v19 = nil;

    if END_DIRECTION then
        local Magnitude = END_DIRECTION.Magnitude;

        if Magnitude > 0.0001 then
            v19 = END_DIRECTION / Magnitude;
        end;
    end;

    local v20;

    if v18.RANDOMIZE_END_DIR then
        v20 = u2:NextUnitVector();
    else
        v20 = v19 or -p14.CFrame.LookVector;
    end;

    local v21 = Position + v20 * u2:NextNumber(unpack(v18.SPLINE_DIST)) + Vector3.new(0, 1, 0) * u2:NextNumber(unpack(v18.SPLINE_H3));
    local v22 = Position - Vector3.new(0, 1, 0) * u2:NextNumber(unpack(v18.SPLINE_H1));
    local v23 = v21 - Vector3.new(0, 1, 0) * u2:NextNumber(unpack(v18.SPLINE_H2));
    local v24;

    if v18.CUSTOM_TRANSFORM_FN then
        v24 = v18.CUSTOM_TRANSFORM_FN;
    elseif v18.SPIN_SPEED == 0 then
        local CFrame2 = p14.CFrame;
        Asserts.CFrame(CFrame2);
        local u25, u26, u27 = CFrame2:ToOrientation();

        v24 = function(p28) -- Line: 113
            -- upvalues: u25 (copy), u26 (copy), u27 (copy)
            return CFrame.new(p28.Position) * CFrame.Angles(u25, u26, u27);
        end;
    else
        local SPIN_SPEED = v18.SPIN_SPEED;
        Asserts.number(SPIN_SPEED);

        v24 = function(p29, p30) -- Line: 103
            -- upvalues: SPIN_SPEED (copy)
            return p29 * CFrame.Angles(p30 * SPIN_SPEED, 0, 0);
        end;
    end;

    local v31 = CatmullRomSpline.new({
        v22,
        Position,
        v21,
        v23
    }, u2:NextNumber(unpack(v18.SPLINE_TENSION)));
    local v32 = v31:CreateTween(p14, v18.DEATH_SPLINE_PROPULSION_INFO, nil, v24);

    if u3 then
        CatmullRomSpline.DebugDrawSpline(v31, 100, workspace, Color3.fromRGB(0, 255, 0));
    end;

    if p16 then
        v32.Completed:Once(p16);
    end;

    if v18.THROW_SOUND then
        Audio.PlayFromFormattedParams(v18.THROW_SOUND.SoundId, p14.Position, v18.THROW_SOUND.Data);
    end;

    return v32;
end;