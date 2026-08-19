-- Decompiled with Potassium's decompiler.

local ReplicatedFirst = game:GetService("ReplicatedFirst");
local EnumMgr = require(ReplicatedFirst.AllSideCode.ToolSystem.EnumMgr);
local HitCameraShakeConfig = require(script.Parent.HitCameraShakeConfig);

return {
    resolve = function(p1) -- Line: 36, Name: resolve
        -- upvalues: HitCameraShakeConfig (copy), EnumMgr (copy)
        if type(p1) ~= "string" or p1 == "" then
            return nil;
        end;

        local v2 = HitCameraShakeConfig[p1];

        if type(v2) ~= "table" then
            return nil;
        end;

        local shakeTypeName = v2.shakeTypeName;
        local audienceName = v2.audienceName;
        local v3;

        if type(shakeTypeName) == "string" then
            v3 = EnumMgr.CameraShakeType[shakeTypeName] or nil;
        else
            v3 = nil;
        end;

        local v4;

        if type(audienceName) == "string" then
            v4 = EnumMgr.CameraShakeAudience[audienceName] or nil;
        else
            v4 = nil;
        end;

        if v3 and v4 then
            return {
                shakeType = v3,
                audience = v4,
                maxShakeCount = type(v2.maxShakeCount) == "number" and (v2.maxShakeCount or 1) or 1,
                shakeCooldown = type(v2.shakeCooldown) == "number" and (v2.shakeCooldown or 0) or 0,
                minDamage = type(v2.minDamage) == "number" and (v2.minDamage or 1) or 1,
                nearbyRadius = type(v2.nearbyRadius) == "number" and (v2.nearbyRadius or 120) or 120
            };
        end;

        warn("[HitCameraShakeProfile] 无效预设:", p1, shakeTypeName, audienceName);

        return nil;
    end,

    findProfileName = function(p5, p6) -- Line: 72, Name: findProfileName
        if p5 then
            p5 = p5.hitboxConfig;
        end;

        if type(p5) ~= "table" then
            return nil;
        end;

        for _, v in p5 do
            if v.HitboxIndex == p6 then
                local CameraShakeProfile = v.CameraShakeProfile;

                if type(CameraShakeProfile) == "string" and CameraShakeProfile ~= "" then
                    return CameraShakeProfile;
                end;

                return nil;
            end;
        end;

        return nil;
    end
};