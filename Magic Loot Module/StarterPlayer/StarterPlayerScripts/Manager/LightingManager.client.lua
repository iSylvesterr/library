-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local Log = UtilsSystem.Log;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local ReplicatedStorage = UtilsSystem.ReplicatedStorage;
local SystemLightingCustomState = UtilsSystem.SystemLightingCustomState;
local u1 = UtilsSystem.SystemLighting.new();
local u2 = SystemLightingCustomState.new();
local LightingConfig = ReplicatedStorage.Assets.LightingConfig;
local u3 = "世界1";

local function _getLightingConfig(p4) -- Line: 46
    -- upvalues: LightingConfig (copy), Log (copy)
    local v5 = LightingConfig:FindFirstChild(p4);

    if v5 then
        return v5;
    end;

    Log.warn("LightingManager: 缺少天气配置", p4);

    return nil;
end;

local function _changeLighting(p6, p7) -- Line: 63
    -- upvalues: LightingConfig (copy), Log (copy), u1 (copy)
    local v8 = LightingConfig:FindFirstChild(p6);

    if not v8 then
        Log.warn("LightingManager: 缺少天气配置", p6);
        v8 = nil;
    end;

    if v8 then
        u1:changeNewLighting(v8, p7);
    end;
end;

local function _refreshLighting(p9) -- Line: 76
    -- upvalues: u3 (ref), LightingConfig (copy), Log (copy), u1 (copy), u2 (copy)
    local v10 = u3;
    local v11 = LightingConfig:FindFirstChild(v10);

    if not v11 then
        Log.warn("LightingManager: 缺少天气配置", v10);
        v11 = nil;
    end;

    if v11 then
        u1:changeNewLighting(v11, p9);
    end;

    for _, v in u2:getCustomStateObjects() do
        u1:applyEffectFromInstance(v, p9);
    end;
end;

_refreshLighting(0);
NetWork.RegisterBindableEvent(NetMsg.LIGHTING_CHANGE, function(p12, p13) -- Line: 87
    -- upvalues: u3 (ref), LightingConfig (copy), Log (copy), _refreshLighting (copy)
    if u3 == p12 then
        return;
    end;

    if not LightingConfig:FindFirstChild(p12) then
        Log.warn("LightingManager: 缺少天气配置", p12);

        return;
    end;

    u3 = p12;
    _refreshLighting(p13);
end);
NetWork.RegisterBindableEvent(NetMsg.CLOCK_CHANGE, function(p14, p15) -- Line: 101
    -- upvalues: u1 (copy)
    if u1.Lighting.ClockTime == p14 then
        return;
    end;

    u1:setClockTime(p14, p15);
end);
NetWork.RegisterBindableEvent(NetMsg.LIGHT_CUSTOM_CHANGE, function(p16, p17, p18) -- Line: 109
    -- upvalues: u2 (copy), _refreshLighting (copy)
    if not u2:hasState(p16) or u2:isStateActive(p16) == p17 then
        return;
    end;

    u2:setState(p16, p17);
    _refreshLighting(p18);
end);