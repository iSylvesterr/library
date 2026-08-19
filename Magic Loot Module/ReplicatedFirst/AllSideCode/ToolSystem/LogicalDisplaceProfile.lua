-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local v1 = {};
local u2 = {
    ["通用受击物理效果"] = {
        distance = 6.5,
        duration = 0.2,
        easingStyle = "Quad",
        easingDirection = "Out",
        plane = "xz"
    },
    ["中等力度受击物理效果"] = {
        distance = 9.5,
        duration = 0.2,
        easingStyle = "Quad",
        easingDirection = "Out",
        plane = "xz"
    },
    ["默认击退"] = {
        distance = 5.5,
        duration = 0.22,
        easingStyle = "Quad",
        easingDirection = "Out",
        plane = "xz"
    },
    ["中等击退"] = {
        distance = 10,
        duration = 0.28,
        easingStyle = "Quad",
        easingDirection = "Out",
        plane = "xz"
    },
    ["重击退"] = {
        distance = 14,
        duration = 0.32,
        easingStyle = "Quad",
        easingDirection = "Out",
        plane = "xz"
    },
    ["轻位移"] = {
        distance = 6,
        duration = 0.25,
        easingStyle = "Quad",
        easingDirection = "Out",
        plane = "xz"
    },
    ["通用受击冲量效果"] = {
        distance = 4,
        duration = 0.08,
        easingStyle = "Quad",
        easingDirection = "Out",
        plane = "xz"
    }
};

local function _fromMotionRow(p3) -- Line: 100
    if type(p3) ~= "table" then
        return nil;
    end;

    local v4 = p3.mode or "velocity";
    local v5 = type(p3.easingStyle) ~= "string" and "Quad" or p3.easingStyle;
    local v6 = type(p3.easingDirection) ~= "string" and "Out" or p3.easingDirection;
    local v7 = type(p3.plane) ~= "string" and "xz" or p3.plane;

    if v4 == "displacement" then
        local v8 = tonumber(p3.distance) or 0;
        local v9 = tonumber(p3.duration) or 0;

        return v8 > 0 and v9 > 0 and {
            distance = v8,
            duration = v9,
            easingStyle = v5,
            easingDirection = v6,
            plane = v7
        } or nil;
    end;

    if v4 == "impulse" then
        local v10 = tonumber(p3.speed) or 0;

        return v10 > 0 and {
            duration = 0.08,
            distance = math.min(v10 * 0.05, 8),
            easingStyle = v5,
            easingDirection = v6,
            plane = v7
        } or nil;
    end;

    local v11 = tonumber(p3.speed) or 0;
    local v12 = tonumber(p3.duration) or 0;

    if v11 <= 0 or v12 <= 0 then
        return nil;
    end;

    local v13 = tonumber(p3.kickSpeed) or 0;

    return {
        distance = v11 * v12 * 0.55 + v13 * 0.016666666666666666,
        duration = v12,
        easingStyle = v5,
        easingDirection = v6,
        plane = v7
    };
end;

function v1.fromPhysicsName(p14) -- Line: 161
    -- upvalues: u2 (copy), UtilsSystem (copy), _fromMotionRow (copy)
    if type(p14) ~= "string" or p14 == "" then
        return nil;
    end;

    local v15 = u2[p14];

    if v15 then
        return {
            distance = v15.distance,
            duration = v15.duration,
            easingStyle = v15.easingStyle,
            easingDirection = v15.easingDirection,
            plane = v15.plane
        };
    end;

    local PhysicsMotion = UtilsSystem.PhysicsMotion;

    if PhysicsMotion and PhysicsMotion.getProfile then
        return _fromMotionRow(PhysicsMotion.getProfile(p14));
    end;

    return nil;
end;

return v1;