-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local EggGrowthAnimation = require(ReplicatedStorage.Library.Client.Eggs.EggGrowthAnimation);
local Player = require(ReplicatedStorage.Library.Player);
local u1 = {};
u1.__index = u1;
u1.__class = "AreaEggNearbyPulse";

function u1.new(p2) -- Line: 44
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.Player(p2);
    local v3 = setmetatable({}, u1);
    v3._player = p2;
    v3._random = Random.new();
    v3._registeredByUid = {};
    v3._nextPulseAt = nil;

    return v3;
end;

function u1._scheduleNextFor(p4, p5, p6) -- Line: 60
    local v7 = p4._registeredByUid[p5];
    local v8 = `Area egg {p5} must be registered before scheduling`;
    local v9 = assert(v7, v8);
    local v10 = p6 + p4._random:NextNumber(6, 25);
    v9.NextPulseAt = v10;
    local _nextPulseAt = p4._nextPulseAt;

    if _nextPulseAt == nil or v10 < _nextPulseAt then
        p4._nextPulseAt = v10;
    end;
end;

function u1._recomputeNextPulseAt(p11) -- Line: 70
    local v12 = nil;

    for _, v in pairs(p11._registeredByUid) do
        if v12 == nil or v.NextPulseAt < v12 then
            v12 = v.NextPulseAt;
        end;
    end;

    p11._nextPulseAt = v12;
end;

function u1._collectClosest(p13, p14) -- Line: 80
    local v15 = {};
    local v16 = {};

    for i, v in pairs(p13._registeredByUid) do
        if v.Model.Parent ~= nil and v.Root.Parent ~= nil then
            local v17 = v.Root.Position - p14;
            local v18 = v17:Dot(v17);

            if v18 <= 122500 then
                local v19 = #v15 + 1;

                for i2, v2 in ipairs(v16) do
                    if v18 < v2 then
                        v19 = i2;
                        break;
                    end;
                end;

                if v19 <= 8 then
                    table.insert(v15, v19, i);
                    table.insert(v16, v19, v18);

                    if #v15 > 8 then
                        table.remove(v15);
                        table.remove(v16);
                    end;
                end;
            end;
        end;
    end;

    return v15;
end;

function u1.Bind(u20, u21, p22, p23) -- Line: 120
    -- upvalues: Asserts (copy), EggGrowthAnimation (copy)
    Asserts.string(u21);
    Asserts.Model(p22);
    Asserts.number(p23);
    u20:Unbind(u21);
    local PrimaryPart = p22.PrimaryPart;
    local v24 = `Rendered area egg {u21} must have a PrimaryPart`;
    assert(PrimaryPart ~= nil, v24);
    local u25 = {
        NextPulseAt = 0,
        Model = p22,
        Root = PrimaryPart,
        Animation = EggGrowthAnimation.new(p22, p22:GetPivot(), 2)
    };
    u20._registeredByUid[u21] = u25;
    u20:_scheduleNextFor(u21, p23);

    return function() -- Line: 138
        -- upvalues: u20 (copy), u21 (copy), u25 (copy)
        if u20._registeredByUid[u21] == u25 then
            u20:Unbind(u21);
        end;
    end;
end;

function u1.Unbind(p26, p27) -- Line: 145
    -- upvalues: Asserts (copy)
    Asserts.string(p27);
    local v28 = p26._registeredByUid[p27];

    if v28 == nil then
        return;
    end;

    local v29 = v28.NextPulseAt == p26._nextPulseAt;
    p26._registeredByUid[p27] = nil;
    v28.Animation:Destroy();

    if v29 then
        p26:_recomputeNextPulseAt();
    end;
end;

function u1.Step(p30, p31) -- Line: 161
    -- upvalues: Asserts (copy), Player (copy)
    Asserts.number(p31);
    local _nextPulseAt = p30._nextPulseAt;

    if _nextPulseAt == nil or p31 < _nextPulseAt then
        return;
    end;

    local v32 = Player.Optional.HumanoidRootPart(p30._player);
    local v33 = {};

    if v32 ~= nil then
        local v34 = v32:IsA("BasePart");
        assert(v34, "Local HumanoidRootPart must be a BasePart");

        for _, v in ipairs(p30:_collectClosest(v32.Position)) do
            v33[v] = true;
        end;
    end;

    p30._nextPulseAt = nil;

    for i, v in pairs(p30._registeredByUid) do
        if v.NextPulseAt <= p31 then
            p30:_scheduleNextFor(i, p31);

            if v33[i] then
                v.Animation:SetBasePivot(v.Model:GetPivot());
                v.Animation:Play();
            end;
        elseif p30._nextPulseAt == nil or v.NextPulseAt < p30._nextPulseAt then
            p30._nextPulseAt = v.NextPulseAt;
        end;
    end;
end;

return u1;