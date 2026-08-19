-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Save = require(ReplicatedStorage.Library.Client.Save);
local Signal = require(ReplicatedStorage.Library.Modules.Packages.Signal);
local TreadmillUtil = require(ReplicatedStorage.Library.Util.TreadmillUtil);
local DEFAULT_BASE_SPEED_POWER = TreadmillUtil.DEFAULT_BASE_SPEED_POWER;
local u1 = DEFAULT_BASE_SPEED_POWER;
local u2 = false;
local u3 = DEFAULT_BASE_SPEED_POWER;
local u4 = 0;
local u5 = nil;
local u6 = {
    Changed = Signal.new()
};

local function readAuthoritativeSpeedPower() -- Line: 32
    -- upvalues: Save (copy), TreadmillUtil (copy)
    local v7 = Save.Get();
    local v8;

    if v7 == nil then
        v8 = nil;
    else
        v8 = v7.SpeedPower;
    end;

    return TreadmillUtil.NormalizeSpeedPower(v8);
end;

local function resolveEqualisedSpeedPower() -- Line: 37
    -- upvalues: Workspace (copy)
    local v9 = Workspace:GetAttribute("EqualisedSpeedPower");

    if type(v9) == "number" and v9 > 0 then
        return v9;
    end;

    return nil;
end;

local function resolveSessionSpeedPower() -- Line: 45
    -- upvalues: u5 (ref), DEFAULT_BASE_SPEED_POWER (ref), u2 (ref), u3 (ref), u4 (ref)
    if u5 == nil then
        return DEFAULT_BASE_SPEED_POWER;
    end;

    if u2 then
        return u3 + u4;
    end;

    return math.max(DEFAULT_BASE_SPEED_POWER, u3 + u4);
end;

local function resolveProjectedSpeedPower() -- Line: 55
    -- upvalues: u5 (ref), DEFAULT_BASE_SPEED_POWER (ref), u2 (ref), u3 (ref), u4 (ref), Workspace (copy)
    local v10;

    if u5 == nil then
        v10 = DEFAULT_BASE_SPEED_POWER;
    elseif u2 then
        v10 = u3 + u4;
    else
        v10 = math.max(DEFAULT_BASE_SPEED_POWER, u3 + u4);
    end;

    local v11 = Workspace:GetAttribute("EqualisedSpeedPower");

    if type(v11) ~= "number" or v11 <= 0 then
        v11 = nil;
    end;

    if v11 == nil then
        return v10;
    end;

    return math.max(v10, v11);
end;

local function publishProjectedSpeedPower() -- Line: 64
    -- upvalues: u5 (ref), DEFAULT_BASE_SPEED_POWER (ref), u2 (ref), u3 (ref), u4 (ref), Workspace (copy), u1 (ref), u6 (copy)
    local v12;

    if u5 == nil then
        v12 = DEFAULT_BASE_SPEED_POWER;
    elseif u2 then
        v12 = u3 + u4;
    else
        v12 = math.max(DEFAULT_BASE_SPEED_POWER, u3 + u4);
    end;

    local v13 = Workspace:GetAttribute("EqualisedSpeedPower");

    if type(v13) ~= "number" or v13 <= 0 then
        v13 = nil;
    end;

    if v13 ~= nil then
        v12 = math.max(v12, v13);
    end;

    if v12 == u1 then
        return;
    end;

    u1 = v12;
    u6.Changed:Fire(u1);
end;

local function reconcileAuthoritativeSpeedPower() -- Line: 73
    -- upvalues: DEFAULT_BASE_SPEED_POWER (ref), Save (copy), TreadmillUtil (copy), u2 (ref), u5 (ref), u3 (ref), u4 (ref), Workspace (copy), u1 (ref), u6 (copy)
    local v14 = Save.Get();
    local v15;

    if v14 == nil then
        v15 = nil;
    else
        v15 = v14.SpeedPower;
    end;

    DEFAULT_BASE_SPEED_POWER = TreadmillUtil.NormalizeSpeedPower(v15);

    if not u2 and (u5 ~= nil and DEFAULT_BASE_SPEED_POWER >= u3 + u4) then
        u5 = nil;
        u3 = DEFAULT_BASE_SPEED_POWER;
        u4 = 0;
    end;

    local v16;

    if u5 == nil then
        v16 = DEFAULT_BASE_SPEED_POWER;
    elseif u2 then
        v16 = u3 + u4;
    else
        v16 = math.max(DEFAULT_BASE_SPEED_POWER, u3 + u4);
    end;

    local v17 = Workspace:GetAttribute("EqualisedSpeedPower");

    if type(v17) ~= "number" or v17 <= 0 then
        v17 = nil;
    end;

    if v17 ~= nil then
        v16 = math.max(v16, v17);
    end;

    if v16 == u1 then
        return;
    end;

    u1 = v16;
    u6.Changed:Fire(u1);
end;

function u6.BeginSession(p18) -- Line: 91
    -- upvalues: Asserts (copy), DEFAULT_BASE_SPEED_POWER (ref), Save (copy), TreadmillUtil (copy), u2 (ref), u5 (ref), u3 (ref), u1 (ref), u4 (ref), Workspace (copy), u6 (copy)
    Asserts.number(p18);
    local v19 = Save.Get();
    local v20;

    if v19 == nil then
        v20 = nil;
    else
        v20 = v19.SpeedPower;
    end;

    DEFAULT_BASE_SPEED_POWER = TreadmillUtil.NormalizeSpeedPower(v20);
    u2 = true;
    u5 = p18;
    u3 = math.max(DEFAULT_BASE_SPEED_POWER, u1);
    u4 = 0;
    local v21;

    if u5 == nil then
        v21 = DEFAULT_BASE_SPEED_POWER;
    elseif u2 then
        v21 = u3 + u4;
    else
        v21 = math.max(DEFAULT_BASE_SPEED_POWER, u3 + u4);
    end;

    local v22 = Workspace:GetAttribute("EqualisedSpeedPower");

    if type(v22) ~= "number" or v22 <= 0 then
        v22 = nil;
    end;

    if v22 ~= nil then
        v21 = math.max(v21, v22);
    end;

    if v21 == u1 then
        return;
    end;

    u1 = v21;
    u6.Changed:Fire(u1);
end;

function u6.RevealCompletedGain(p23, p24) -- Line: 102
    -- upvalues: Asserts (copy), u5 (ref), u4 (ref), DEFAULT_BASE_SPEED_POWER (ref), u2 (ref), u3 (ref), Workspace (copy), u1 (ref), u6 (copy)
    Asserts.number(p23);
    Asserts.number(p24);

    if u5 ~= p23 or p24 <= 0 then
        return false;
    end;

    u4 = u4 + p24;
    local v25;

    if u5 == nil then
        v25 = DEFAULT_BASE_SPEED_POWER;
    elseif u2 then
        v25 = u3 + u4;
    else
        v25 = math.max(DEFAULT_BASE_SPEED_POWER, u3 + u4);
    end;

    local v26 = Workspace:GetAttribute("EqualisedSpeedPower");

    if type(v26) ~= "number" or v26 <= 0 then
        v26 = nil;
    end;

    if v26 ~= nil then
        v25 = math.max(v25, v26);
    end;

    if v25 ~= u1 then
        u1 = v25;
        u6.Changed:Fire(u1);
    end;

    return true;
end;

function u6.EndSession(p27) -- Line: 114
    -- upvalues: Asserts (copy), u5 (ref), u2 (ref), DEFAULT_BASE_SPEED_POWER (ref), Save (copy), TreadmillUtil (copy), u3 (ref), u4 (ref), Workspace (copy), u1 (ref), u6 (copy)
    Asserts.number(p27);

    if u5 ~= p27 then
        return;
    end;

    u2 = false;
    local v28 = Save.Get();
    local v29;

    if v28 == nil then
        v29 = nil;
    else
        v29 = v28.SpeedPower;
    end;

    DEFAULT_BASE_SPEED_POWER = TreadmillUtil.NormalizeSpeedPower(v29);

    if not u2 and (u5 ~= nil and DEFAULT_BASE_SPEED_POWER >= u3 + u4) then
        u5 = nil;
        u3 = DEFAULT_BASE_SPEED_POWER;
        u4 = 0;
    end;

    local v30;

    if u5 == nil then
        v30 = DEFAULT_BASE_SPEED_POWER;
    elseif u2 then
        v30 = u3 + u4;
    else
        v30 = math.max(DEFAULT_BASE_SPEED_POWER, u3 + u4);
    end;

    local v31 = Workspace:GetAttribute("EqualisedSpeedPower");

    if type(v31) ~= "number" or v31 <= 0 then
        v31 = nil;
    end;

    if v31 ~= nil then
        v30 = math.max(v30, v31);
    end;

    if v30 == u1 then
        return;
    end;

    u1 = v30;
    u6.Changed:Fire(u1);
end;

function u6.GetSpeedPower() -- Line: 124
    -- upvalues: u1 (ref)
    return u1;
end;

local v32 = Save.Get();
local v33;

if v32 == nil then
    v33 = nil;
else
    v33 = v32.SpeedPower;
end;

DEFAULT_BASE_SPEED_POWER = TreadmillUtil.NormalizeSpeedPower(v33);

if not u2 and (u5 ~= nil and u3 + u4 <= DEFAULT_BASE_SPEED_POWER) then
    u5 = nil;
    u3 = DEFAULT_BASE_SPEED_POWER;
    u4 = 0;
end;

local v34;

if u5 == nil then
    v34 = DEFAULT_BASE_SPEED_POWER;
elseif u2 then
    v34 = u3 + u4;
else
    v34 = math.max(DEFAULT_BASE_SPEED_POWER, u3 + u4);
end;

local v35 = Workspace:GetAttribute("EqualisedSpeedPower");

if type(v35) ~= "number" or v35 <= 0 then
    v35 = nil;
end;

if v35 ~= nil then
    v34 = math.max(v34, v35);
end;

if v34 ~= u1 then
    u1 = v34;
    u6.Changed:Fire(u1);
end;

Save.GetStatChangedSignal("SpeedPower"):Connect(reconcileAuthoritativeSpeedPower);
Workspace:GetAttributeChangedSignal("EqualisedSpeedPower"):Connect(publishProjectedSpeedPower);

return u6;