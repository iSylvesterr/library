-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local u1 = {};
local v2 = {};

local function cframeInFrontOfRootClampedToArea(p3, p4) -- Line: 30
    local LookVector = p3.LookVector;
    local v5 = Vector3.new(LookVector.X, 0, LookVector.Z);
    assert(v5.Magnitude > 0, "Asset front placement requires a horizontal root facing direction");
    local Unit = v5.Unit;
    local Size = p4.Size;
    local v6 = math.max(Size.X * 0.5 - 1.75, 0);
    local v7 = math.max(Size.Z * 0.5 - 1.75, 0);
    local v8 = p4.CFrame:PointToObjectSpace(p3.Position + Unit * 6);
    local v9 = math.clamp(v8.X, -v6, v6);
    local v10 = math.clamp(v8.Z, -v7, v7);
    local v11 = Vector3.new(v9, 0, v10);
    local Position = (p4.CFrame * CFrame.new(v11)).Position;

    return CFrame.lookAt(Position, Position + Unit);
end;

function v2.SetFrontPlacement(p12, p13) -- Line: 52
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.string(p12);
    Asserts.CFrame(p13);
    u1[p12] = {
        RootCFrame = p13,
        ExpiresAt = os.clock() + 10
    };
end;

function v2.ConsumeFrontPlacement(p14, p15) -- Line: 62
    -- upvalues: Asserts (copy), u1 (copy), cframeInFrontOfRootClampedToArea (copy)
    Asserts.string(p14);
    Asserts.BasePart(p15);
    local v16 = u1[p14];
    u1[p14] = nil;

    if v16 == nil or v16.ExpiresAt < os.clock() then
        return nil;
    end;

    return cframeInFrontOfRootClampedToArea(v16.RootCFrame, p15);
end;

function v2.ClearFrontPlacement(p17) -- Line: 75
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.string(p17);
    u1[p17] = nil;
end;

return v2;