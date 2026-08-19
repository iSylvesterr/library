-- Decompiled with Potassium's decompiler.

local u1 = Random.new(1029410295159813);
local u2 = {};
u2.__index = u2;

function u2.new(p3, p4, p5) -- Line: 7
    -- upvalues: u1 (copy), u2 (copy)
    local v6 = {
        BoneTotalLength = 0,
        DistanceFromCamera = 100,
        Force = Vector3.new(0, 0, 0),
        RestGravity = Vector3.new(0, 0, 0),
        ObjectMove = Vector3.new(0, 0, 0),
        ObjectPreviousPosition = Vector3.new(0, 0, 0),
        WindOffset = u1:NextNumber(0, 1000000),
        Root = p3:IsA("Bone") and p3 and p3 or nil,
        RootPart = p4,
        RootWorldToLocal = p3.WorldCFrame:ToObjectSpace(p3.CFrame),
        Particles = {},
        LocalCFrame = p3.WorldCFrame,
        LocalGravity = p3.CFrame:PointToWorldSpace(p5).Unit * p5.Magnitude
    };

    return setmetatable(v6, u2);
end;

return u2;