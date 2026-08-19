-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local _ = require(ReplicatedStorage.Library.Globals.Constants).IS_STUDIO;
local u1 = 300;
local u2 = {
    EndingSoonSeconds = 20,
    FinalBlinkSeconds = 10,
    NightGrowthSkipSeconds = 300,
    MinNightDurationSeconds = 1,
    SchedulePollSeconds = 0.25,
    ResetPeriodSeconds = u1
};

local function getScheduleNumber(p3, p4) -- Line: 45
    -- upvalues: Workspace (copy)
    local v5 = Workspace:GetAttribute(p3);

    if type(v5) == "number" then
        return v5;
    end;

    return p4;
end;

local function assertServer() -- Line: 50
    -- upvalues: RunService (copy)
    local v6 = RunService:IsServer();
    assert(v6, "Area egg cycle schedule can only be changed on the server");
end;

local function assertNightDuration(p7) -- Line: 54
    -- upvalues: u1 (copy)
    local v8;

    if p7 >= 1 then
        v8 = p7 <= u1;
    else
        v8 = false;
    end;

    local v9 = `Night duration must be between {1} and {u1} seconds`;
    assert(v8, v9);
end;

local function hashString(p10) -- Line: 61
    local v11 = 2166136261;

    for i = 1, #p10 do
        v11 = (v11 + string.byte(p10, i)) * 16777619 % 2147483647;
    end;

    return v11 <= 0 and 1 or v11;
end;

function u2.GetNightDurationSeconds() -- Line: 76
    -- upvalues: Workspace (copy), u1 (copy)
    local v12 = Workspace:GetAttribute("AreaEggCycleNightSeconds");
    local v13 = type(v12) ~= "number" and 10 or v12;

    return math.clamp(v13, 1, u1);
end;

function u2.GetNightGrowthBonusRate() -- Line: 84
    -- upvalues: u2 (copy)
    return 300 / u2.GetNightDurationSeconds();
end;

function u2.IsScheduleOverridden() -- Line: 88
    -- upvalues: Workspace (copy)
    return Workspace:GetAttribute("AreaEggCycleAnchorAt") ~= nil and true or Workspace:GetAttribute("AreaEggCycleNightSeconds") ~= nil;
end;

function u2.GetPeriodStartsAt(p14) -- Line: 92
    -- upvalues: Asserts (copy), Workspace (copy), u1 (copy)
    Asserts.number(p14);
    local v15 = Workspace:GetAttribute("AreaEggCycleAnchorIndex");
    local v16 = type(v15) ~= "number" and 0 or v15;
    local v17 = Workspace:GetAttribute("AreaEggCycleAnchorAt");

    return (type(v17) ~= "number" and 0 or v17) + (p14 - v16) * u1;
end;

function u2.GetPeriodIndex(p18) -- Line: 98
    -- upvalues: Asserts (copy), Workspace (copy), u1 (copy)
    Asserts.number(p18);
    local v19 = Workspace:GetAttribute("AreaEggCycleAnchorAt");
    local v20 = p18 - (type(v19) ~= "number" and 0 or v19);
    local v21 = Workspace:GetAttribute("AreaEggCycleAnchorIndex");
    local v22 = (type(v21) ~= "number" and 0 or v21) + math.floor(v20 / u1);

    return math.max(v22, 0);
end;

function u2.GetNextResetAt(p23) -- Line: 105
    -- upvalues: Asserts (copy), u2 (copy)
    Asserts.number(p23);

    return u2.GetPeriodStartsAt(u2.GetPeriodIndex(p23) + 1);
end;

function u2.GetTimeLeft(p24) -- Line: 110
    -- upvalues: Asserts (copy), u2 (copy)
    Asserts.number(p24);
    local v25 = u2.GetNextResetAt(p24) - p24;

    return math.max(0, v25);
end;

function u2.GetNightStartsAt(p26) -- Line: 115
    -- upvalues: Asserts (copy), u2 (copy)
    Asserts.number(p26);

    return u2.GetNextResetAt(p26) - u2.GetNightDurationSeconds();
end;

function u2.GetNightTransitionStartsAt(p27, p28, p29) -- Line: 120
    -- upvalues: Asserts (copy), u2 (copy)
    Asserts.number(p27);
    Asserts.number(p28);
    Asserts.number(p29);

    return u2.GetNightStartsAt(p27) - p28 + p29;
end;

function u2.IsNightTransition(p30, p31, p32) -- Line: 131
    -- upvalues: Asserts (copy), u2 (copy)
    Asserts.number(p30);
    Asserts.number(p31);
    Asserts.number(p32);
    local v33 = not u2.IsNight(p30) and u2.GetNightTransitionStartsAt(p30, p31, p32) <= p30;

    return v33;
end;

function u2.IsNight(p34) -- Line: 144
    -- upvalues: Asserts (copy), u2 (copy)
    Asserts.number(p34);

    return u2.GetTimeLeft(p34) <= u2.GetNightDurationSeconds();
end;

function u2.GetActivePeriodIndex(p35) -- Line: 149
    -- upvalues: Asserts (copy), u2 (copy)
    Asserts.number(p35);
    local v36 = u2.GetPeriodIndex(p35);

    if u2.IsNight(p35) then
        return v36 + 1;
    end;

    return v36;
end;

function u2.GetPhaseTimeLeft(p37) -- Line: 155
    -- upvalues: Asserts (copy), u2 (copy)
    Asserts.number(p37);
    local v38 = u2.GetTimeLeft(p37);

    if u2.IsNight(p37) then
        return v38;
    end;

    local v39 = v38 - u2.GetNightDurationSeconds();

    return math.max(0, v39);
end;

function u2.GetNextNightAt(p40) -- Line: 163
    -- upvalues: Asserts (copy), u2 (copy), u1 (copy)
    Asserts.number(p40);
    local v41 = u2.GetNightStartsAt(p40);

    if p40 < v41 then
        return v41;
    end;

    return v41 + u1;
end;

function u2.GetNightGrowthSecondsAt(p42, p43) -- Line: 172
    -- upvalues: Asserts (copy), u2 (copy)
    Asserts.number(p42);
    Asserts.number(p43);

    return math.clamp(p42 - p43, 0, u2.GetNightDurationSeconds()) * u2.GetNightGrowthBonusRate();
end;

function u2.GetSlotSeed(p44, p45, p46) -- Line: 180
    -- upvalues: Asserts (copy)
    Asserts.number(p44);
    Asserts.string(p45);
    Asserts.string(p46);
    local v47 = `{p44}:{p45}:{p46}`;
    local v48 = 2166136261;

    for i = 1, #v47 do
        v48 = (v48 + string.byte(v47, i)) * 16777619 % 2147483647;
    end;

    return v48 <= 0 and 1 or v48;
end;

function u2.IsEndingSoon(p49) -- Line: 187
    -- upvalues: Asserts (copy)
    Asserts.number(p49);

    return p49 <= 20;
end;

function u2.IsWithinResetWindow(p50, p51) -- Line: 192
    -- upvalues: Asserts (copy), u2 (copy), u1 (copy)
    Asserts.number(p50);
    Asserts.number(p51);
    local v52 = u2.GetNextNightAt(p50);

    return v52 - p50 <= p51 and true or p50 - (v52 - u1) <= p51;
end;

function u2.IsFinalBlinkWindow(p53) -- Line: 200
    -- upvalues: Asserts (copy)
    Asserts.number(p53);

    return p53 <= 10;
end;

function u2.IsBlinkRed(p54) -- Line: 205
    -- upvalues: Asserts (copy)
    Asserts.number(p54);

    return math.ceil(p54) % 2 == 0;
end;

function u2.SetNightDurationSeconds(p55) -- Line: 214
    -- upvalues: RunService (copy), Asserts (copy), u1 (copy), Workspace (copy)
    local v56 = RunService:IsServer();
    assert(v56, "Area egg cycle schedule can only be changed on the server");
    Asserts.optional.number(p55);

    if p55 ~= nil then
        local v57;

        if p55 >= 1 then
            v57 = p55 <= u1;
        else
            v57 = false;
        end;

        local v58 = `Night duration must be between {1} and {u1} seconds`;
        assert(v57, v58);
    end;

    Workspace:SetAttribute("AreaEggCycleNightSeconds", p55);
end;

function u2.StartNightAt(p59, p60) -- Line: 224
    -- upvalues: RunService (copy), Asserts (copy), u2 (copy), u1 (copy), Workspace (copy)
    local v61 = RunService:IsServer();
    assert(v61, "Area egg cycle schedule can only be changed on the server");
    Asserts.number(p59);
    Asserts.optional.number(p60);

    if u2.IsNight(p59) then
        return false, "Night is already running";
    end;

    local v62 = p60 or u2.GetNightDurationSeconds();
    local v63;

    if v62 >= 1 then
        v63 = v62 <= u1;
    else
        v63 = false;
    end;

    local v64 = `Night duration must be between {1} and {u1} seconds`;
    assert(v63, v64);
    local v65 = u2.GetPeriodIndex(p59);
    Workspace:SetAttribute("AreaEggCycleNightSeconds", v62);
    Workspace:SetAttribute("AreaEggCycleAnchorIndex", v65 + 1);
    Workspace:SetAttribute("AreaEggCycleAnchorAt", p59 + v62);

    return true, nil;
end;

function u2.DeferNextReset(p66) -- Line: 244
    -- upvalues: RunService (copy), Asserts (copy), u2 (copy), Workspace (copy)
    local v67 = RunService:IsServer();
    assert(v67, "Area egg cycle schedule can only be changed on the server");
    Asserts.number(p66);
    Workspace:SetAttribute("AreaEggCycleAnchorIndex", (u2.GetPeriodIndex(p66)));
    Workspace:SetAttribute("AreaEggCycleAnchorAt", p66);
end;

function u2.ClearScheduleOverrides() -- Line: 253
    -- upvalues: RunService (copy), Workspace (copy)
    local v68 = RunService:IsServer();
    assert(v68, "Area egg cycle schedule can only be changed on the server");
    Workspace:SetAttribute("AreaEggCycleAnchorAt", nil);
    Workspace:SetAttribute("AreaEggCycleAnchorIndex", nil);
    Workspace:SetAttribute("AreaEggCycleNightSeconds", nil);
end;

return table.freeze(u2);