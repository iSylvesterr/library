-- Decompiled with Potassium's decompiler.

local MotionProfile = require(script.MotionProfile);
local MotionResolve = require(script.MotionResolve);
local MotionRegistry = require(script.MotionRegistry);
local VelocityDriver = require(script.VelocityDriver);
local DisplacementDriver = require(script.DisplacementDriver);
local ImpulseDriver = require(script.ImpulseDriver);
local v1 = {};

local function _mergeProfile(p2) -- Line: 68
    -- upvalues: MotionProfile (copy)
    local v3 = table.clone(p2);
    local profileName = p2.profileName;

    if type(profileName) == "string" and profileName ~= "" then
        local v4 = MotionProfile.get(profileName);

        if v4 then
            for i, v in pairs(v4) do
                if v3[i] == nil then
                    v3[i] = v;
                end;
            end;
        end;
    end;

    if type(p2.overrides) == "table" then
        for i, v in pairs(p2.overrides) do
            if v ~= nil then
                v3[i] = v;
            end;
        end;
    end;

    return v3;
end;

local function _makeHandle(u5, u6, u7, u8) -- Line: 100
    -- upvalues: MotionRegistry (copy)
    return {
        channel = u6,
        gen = u7,

        cancel = function(p9) -- Line: 105, Name: cancel
            -- upvalues: u8 (copy)
            u8();
        end,

        isActive = function(p10) -- Line: 109, Name: isActive
            -- upvalues: MotionRegistry (ref), u5 (copy), u6 (copy), u7 (copy)
            local v11 = MotionRegistry.isActive(u5, u6) and MotionRegistry.isGenCurrent(u5, u6, u7);

            return v11;
        end
    };
end;

function v1.getProfile(p12) -- Line: 122
    -- upvalues: MotionProfile (copy)
    return MotionProfile.get(p12);
end;

function v1.cancel(p13, p14) -- Line: 132
    -- upvalues: MotionRegistry (copy)
    if not p13 then
        return;
    end;

    local HumanoidRootPart = p13:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart then
        MotionRegistry.cancel(HumanoidRootPart, p14);
    end;
end;

function v1.isActive(p15, p16) -- Line: 149
    -- upvalues: MotionRegistry (copy)
    if not p15 or type(p16) ~= "string" then
        return false;
    end;

    local HumanoidRootPart = p15:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart then
        return MotionRegistry.isActive(HumanoidRootPart, p16);
    end;

    return false;
end;

function v1.apply(p17) -- Line: 166
    -- upvalues: _mergeProfile (copy), MotionResolve (copy), ImpulseDriver (copy), MotionRegistry (copy), VelocityDriver (copy), DisplacementDriver (copy), _makeHandle (copy)
    if type(p17) ~= "table" then
        return nil;
    end;

    local v18 = _mergeProfile(p17);
    local v19, v20, v21 = MotionResolve.normalize(v18);

    if not (v19 and (v20 and v21)) then
        return nil;
    end;

    local mode = v19.mode;
    local channel = v19.channel;
    local onComplete = v19.onComplete;

    if mode == "impulse" then
        ImpulseDriver.apply(v19, v20);

        if onComplete then
            onComplete("complete");
        end;

        return nil;
    end;

    local v22 = MotionRegistry.begin(v20, channel, v19.replaceSameChannel);
    local v23;

    if mode == "velocity" then
        v23 = VelocityDriver.start(v19, v20, v21, v22, channel, onComplete);
    else
        if mode ~= "displacement" then
            MotionRegistry.release(v20, channel, v22);

            return nil;
        end;

        v23 = DisplacementDriver.start(v19, v20, v21, v22, channel, onComplete);
    end;

    MotionRegistry.setCancel(v20, channel, v23);

    return _makeHandle(v20, channel, v22, v23);
end;

return v1;