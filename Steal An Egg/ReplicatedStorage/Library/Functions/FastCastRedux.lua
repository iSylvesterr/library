-- Decompiled with Potassium's decompiler.

local u1 = {
    DebugLogging = false,
    VisualizeCasts = false
};
u1.__index = u1;
u1.__type = "FastCast";
u1.HighFidelityBehavior = {
    Default = 1,
    Always = 3
};
local ActiveCast = require(script.ActiveCast);
local Signal = require(script.Signal);
require(script.Table);
require(script.TypeDefinitions);
ActiveCast.SetStaticFastCastReference(u1);

function u1.new() -- Line: 108
    -- upvalues: Signal (copy), u1 (copy)
    local v2 = {
        LengthChanged = Signal.new("LengthChanged"),
        RayHit = Signal.new("RayHit"),
        RayPierced = Signal.new("RayPierced"),
        CastTerminating = Signal.new("CastTerminating"),
        WorldRoot = workspace
    };

    return setmetatable(v2, u1);
end;

function u1.newBehavior() -- Line: 120
    -- upvalues: u1 (copy)
    return {
        RaycastParams = nil,
        MaxDistance = 1000,
        CanPierceFunction = nil,
        HighFidelitySegmentSize = 0.5,
        CosmeticBulletTemplate = nil,
        CosmeticBulletProvider = nil,
        CosmeticBulletContainer = nil,
        AutoIgnoreContainer = true,
        Acceleration = Vector3.new(),
        HighFidelityBehavior = u1.HighFidelityBehavior.Default
    };
end;

local u3 = u1.newBehavior();

function u1.Fire(p4, p5, p6, p7, p8) -- Line: 137
    -- upvalues: u3 (copy), ActiveCast (copy)
    if p8 == nil then
        p8 = u3;
    end;

    local v9 = ActiveCast.new(p4, p5, p6, p7, p8);
    v9.RayInfo.WorldRoot = p4.WorldRoot;

    return v9;
end;

return u1;