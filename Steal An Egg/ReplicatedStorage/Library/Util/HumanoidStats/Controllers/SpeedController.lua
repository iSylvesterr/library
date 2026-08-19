-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Signal = require(ReplicatedStorage.Library.Signal);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
require(ReplicatedStorage.Library.Util.HumanoidStats.Types.Stats);
local StatsKernel = require(ReplicatedStorage.Library.Util.HumanoidStats.Kernel.StatsKernel);
local BASE_WALK_SPEED = Constants.BASE_WALK_SPEED;
local SpeedChanged = Signal.MAP.Server.Kernel.SpeedChanged;
local u1 = {};
u1.__index = u1;

function u1.new(p2) -- Line: 37
    -- upvalues: BASE_WALK_SPEED (copy), Asserts (copy), u1 (copy), StatsKernel (copy), SpeedChanged (copy), Signal (copy)
    local v3 = p2 or BASE_WALK_SPEED;
    Asserts.finite(v3);
    Asserts.cond(v3 > 0);
    local u4 = setmetatable({}, u1);
    u4._baseSpeed = v3;
    u4._kernel = StatsKernel.new(v3, SpeedChanged, u1._speedPolicy);
    u4._humanoid = nil;
    Signal.Fired(u4._kernel.Changed):Connect(function(p5) -- Line: 49
        -- upvalues: u4 (copy)
        u4:_onSpeedChanged(p5);
    end);

    return u4;
end;

function u1._speedPolicy(p6, p7) -- Line: 57
    -- upvalues: Asserts (copy)
    Asserts.finite(p6);
    Asserts.table(p7);
    local v8 = {};
    local v9 = 0;

    for _, v in ipairs(p7) do
        if v.type == "positive" then
            v9 = v9 + v.value;
        elseif v.type == "malus" then
            table.insert(v8, v.value);
        end;
    end;

    local v10 = p6 * (v9 + 1);

    for _, v in ipairs(v8) do
        v10 = v10 * (v + 1);
    end;

    return math.max(0, v10);
end;

function u1.SetHumanoid(p11, p12) -- Line: 82
    -- upvalues: Asserts (copy)
    Asserts.optional.Humanoid(p12);

    if p11._humanoid == p12 then
        return;
    end;

    p11._humanoid = p12;
    p11:_updateHumanoid();
end;

function u1.GetValue(p13) -- Line: 93
    return p13._kernel:GetValue();
end;

function u1.AddModifier(p14, p15, p16, p17, p18) -- Line: 97
    -- upvalues: Asserts (copy)
    Asserts.string(p15);
    Asserts.cond(p16 == "positive" and true or p16 == "malus");
    Asserts.finite(p17);
    Asserts.optional.string(p18);
    p14._kernel:AddModifier({
        id = p15,
        type = p16,
        value = p17,
        source = p18
    });
end;

function u1.RemoveModifier(p19, p20) -- Line: 111
    -- upvalues: Asserts (copy)
    Asserts.string(p20);
    p19._kernel:RemoveModifier(p20);
end;

function u1.RemoveModifiersBySource(p21, p22) -- Line: 116
    -- upvalues: Asserts (copy)
    Asserts.string(p22);
    p21._kernel:RemoveModifiersBySource(p22);
end;

function u1.GetBaseSpeed(p23) -- Line: 121
    return p23._baseSpeed;
end;

function u1.SetBaseSpeed(p24, p25) -- Line: 125
    -- upvalues: Asserts (copy)
    Asserts.finite(p25);
    Asserts.cond(p25 > 0);
    p24._baseSpeed = p25;
    p24._kernel:SetBase(p25);
end;

function u1.GetModifiers(p26) -- Line: 133
    return p26._kernel:GetModifiers();
end;

function u1._onSpeedChanged(p27, p28) -- Line: 137
    p27:_updateHumanoid();
end;

function u1._updateHumanoid(p29) -- Line: 141
    if not p29._humanoid then
        return;
    end;

    local v30 = p29:GetValue();
    p29._humanoid.WalkSpeed = v30;
end;

function u1.Destroy(p31) -- Line: 150
    p31._humanoid = nil;
end;

return u1;