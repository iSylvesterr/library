-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local Parent = require(script.Parent.Parent);
local ArrowPointerFromPlayer = require(script.Parent.ArrowPointerFromPlayer);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();
local u2 = Vector3.new(0, 1, 0) * (Parent.__constants.ARROW_SIZE + Parent.__constants.DEFAULT_CONFIG.Amplitude + Parent.__constants.DEFAULT_CONFIG.Radius);
local u3 = t.union(t.instanceIsA("Model"), t.instanceIsA("BasePart"), t.Vector3);
local u4 = {};
u4.__index = u4;
u4.__class = "TwoArrowsFromPlayer";

function u4.new(p5, p6, p7) -- Line: 48
    -- upvalues: u3 (copy), Parent (copy), u4 (copy), Trove (copy), ArrowPointerFromPlayer (copy)
    assert(u3(p5));
    assert(Parent.__types.OptionalConfig(p7));
    local v8 = p7 or {};
    v8.ProximityThreshold = 0;
    local v9 = setmetatable({}, u4);
    v9._trove = Trove.new();
    v9._originOrModelToTrack = p5;
    v9.Started = false;
    v9.StaticArrow = v9._trove:Add((Parent.new(nil, nil, v8)));
    v9.PlayerArrow = v9._trove:Add((ArrowPointerFromPlayer.new(nil, p6)));
    v9:_init();

    return v9;
end;

function u4.Start(p10) -- Line: 77
    if p10.Started then
        return;
    end;

    p10.Started = true;
    p10.PlayerArrow:Start();
    p10.StaticArrow:Start();
end;

function u4.Stop(p11) -- Line: 87
    if not p11.Started then
        return;
    end;

    p11.Started = false;
    p11.PlayerArrow:Stop();
    p11.StaticArrow:Stop();
end;

function u4.ChangeOrigin(p12, p13) -- Line: 97
    -- upvalues: u3 (copy)
    assert(u3(p13));
    p12._originOrModelToTrack = p13;
    p12:_init();
end;

function u4.Destroy(p14) -- Line: 104
    p14._trove:Destroy();
    table.clear(p14);
    setmetatable(p14, nil);
end;

function u4._init(p15) -- Line: 115
    -- upvalues: u2 (copy), u1 (copy)
    local v16 = nil;
    local v17 = nil;
    local v18 = nil;

    if typeof(p15._originOrModelToTrack) == "Vector3" then
        v16 = p15._originOrModelToTrack;
        v18 = v16 + u2 * 1.8;
        v17 = v16;
    elseif p15._originOrModelToTrack:IsA("BasePart") then
        v17 = p15._originOrModelToTrack.Position;
        v16 = v17 + Vector3.new(0, 1, 0) * (p15._originOrModelToTrack.Size.Y / 2);
        v18 = v16 + u2;
    elseif p15._originOrModelToTrack:IsA("Model") then
        local v19, v20 = p15._originOrModelToTrack:GetBoundingBox();
        v17 = v19.Position;
        v16 = v17 + Vector3.new(0, 1, 0) * (v20.Y / 2);
        v18 = v16 + u2;
    end;

    u1:AtTrace():Log("TwoArrowsFromPlayer tracked center:", v16, "origin:", v18);
    p15.StaticArrow:ChangeOrigin(v18);
    p15.StaticArrow:ChangeTarget(v16);
    p15.PlayerArrow:ChangeTarget(v17);

    return p15;
end;

return u4;