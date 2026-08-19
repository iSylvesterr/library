-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RemoteSignal = require(script.Parent.RemoteSignal);
require(script.Parent.Parent.Types);
local None = require(script.Parent.Parent.Util).None;
local u1 = {};
u1.__index = u1;

function u1.new(p2, p3, p4, p5, p6) -- Line: 53
    -- upvalues: u1 (copy), RemoteSignal (copy), Players (copy), None (copy)
    local u7 = setmetatable({}, u1);
    u7._rs = RemoteSignal.new(p2, p3, false, p5, p6);
    u7._value = p4;
    u7._perPlayer = {};
    u7._playerRemoving = Players.PlayerRemoving:Connect(function(p8) -- Line: 64
        -- upvalues: u7 (copy)
        u7._perPlayer[p8] = nil;
    end);
    u7._rs:Connect(function(p9) -- Line: 67
        -- upvalues: u7 (copy), None (ref)
        local v10 = u7._perPlayer[p9];

        if v10 == nil then
            v10 = u7._value;
        elseif v10 == None then
            v10 = nil;
        end;

        u7._rs:Fire(p9, v10);
    end);

    return u7;
end;

function u1.Set(p11, p12) -- Line: 91
    p11._value = p12;
    table.clear(p11._perPlayer);
    p11._rs:FireAll(p12);
end;

function u1.SetTop(p13, p14) -- Line: 118
    -- upvalues: Players (copy)
    p13._value = p14;

    for _, v in ipairs(Players:GetPlayers()) do
        if p13._perPlayer[v] == nil then
            p13._rs:Fire(v, p14);
        end;
    end;
end;

function u1.SetFilter(p15, p16, p17) -- Line: 141
    -- upvalues: Players (copy)
    for _, v in ipairs(Players:GetPlayers()) do
        if p16(v, p17) then
            p15:SetFor(v, p17);
        end;
    end;
end;

function u1.SetFor(p18, p19, p20) -- Line: 163
    -- upvalues: None (copy)
    if p19.Parent then
        local v21;

        if p20 == nil then
            v21 = None;
        else
            v21 = p20;
        end;

        p18._perPlayer[p19] = v21;
    end;

    p18._rs:Fire(p19, p20);
end;

function u1.SetForList(p22, p23, p24) -- Line: 179
    for _, v in ipairs(p23) do
        p22:SetFor(v, p24);
    end;
end;

function u1.ClearFor(p25, p26) -- Line: 206
    if p25._perPlayer[p26] == nil then
        return;
    end;

    p25._perPlayer[p26] = nil;
    p25._rs:Fire(p26, p25._value);
end;

function u1.ClearForList(p27, p28) -- Line: 219
    for _, v in ipairs(p28) do
        p27:ClearFor(v);
    end;
end;

function u1.ClearFilter(p29, p30) -- Line: 229
    -- upvalues: Players (copy)
    for _, v in ipairs(Players:GetPlayers()) do
        if p30(v) then
            p29:ClearFor(v);
        end;
    end;
end;

function u1.Get(p31) -- Line: 247
    return p31._value;
end;

function u1.GetFor(p32, p33) -- Line: 281
    -- upvalues: None (copy)
    local v34 = p32._perPlayer[p33];

    if v34 == nil then
        return p32._value;
    end;

    if v34 == None then
        return nil;
    end;

    return v34;
end;

function u1.Destroy(p35) -- Line: 290
    p35._rs:Destroy();
    p35._playerRemoving:Disconnect();
end;

return u1;