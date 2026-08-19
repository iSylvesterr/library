-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.new(p2, p3, p4, p5) -- Line: 4
    -- upvalues: u1 (copy)
    local v6 = {
        RestLength = 0,
        Weight = 0.7,
        ParentIndex = 0,
        IsColliding = false,
        RestPosition = Vector3.new(0, 0, 0),
        Anchored = false,
        Bone = p2,
        Transform = p2.WorldCFrame:ToObjectSpace(p3.WorldCFrame):Inverse(),
        LocalTransform = p2.CFrame:ToObjectSpace(p3.CFrame):Inverse(),
        RootTransform = p3.WorldCFrame:ToObjectSpace(p4.CFrame):Inverse(),
        Radius = p5.Radius,
        TransformOffset = CFrame.identity,
        LastTransformOffset = CFrame.identity,
        LocalTransformOffset = CFrame.identity,
        BoneTransform = CFrame.identity,
        CalculatedWorldCFrame = p2.WorldCFrame,
        CalculatedWorldPosition = p2.WorldPosition,
        Position = p2.WorldPosition,
        LastPosition = p2.WorldPosition,
        RecyclingBin = {}
    };

    return setmetatable(v6, u1);
end;

return u1;