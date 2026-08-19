-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
require(script.Types.Interface);
local v1 = {};

local function signedDistanceFromLine(p2, p3) -- Line: 17
    return p2.CFrame.LookVector:Dot(p3 - p2.Position);
end;

function v1.GetSignedDistanceFromLinePart(p4, p5) -- Line: 25
    -- upvalues: Asserts (copy), signedDistanceFromLine (copy)
    Asserts.BasePart(p4);
    Asserts.Vector3(p5);

    return signedDistanceFromLine(p4, p5);
end;

function v1.IsInGameplaySide(p6, p7) -- Line: 32
    -- upvalues: Asserts (copy)
    Asserts.BasePart(p6);
    Asserts.Vector3(p7);

    return p6.CFrame.LookVector:Dot(p7 - p6.Position) > 0;
end;

function v1.IsWorldPositionInsideXZBounds(p8, p9) -- Line: 39
    -- upvalues: Asserts (copy)
    Asserts.BasePart(p8);
    Asserts.Vector3(p9);
    local v10 = p8.CFrame:PointToObjectSpace(p9);
    local v11 = p8.Size * 0.5;
    local v12;

    if math.abs(v10.X) <= v11.X then
        v12 = math.abs(v10.Z) <= v11.Z;
    else
        v12 = false;
    end;

    return v12;
end;

function v1.ResolveAreaBoundsEntries(p13) -- Line: 49
    -- upvalues: Asserts (copy)
    Asserts.Instance(p13);
    local v14 = p13:IsA("Folder");
    assert(v14, "GuardAreas must be a Folder");
    local v15 = {};

    for _, child in ipairs(p13:GetChildren()) do
        local v16 = child:IsA("Model");
        local v17 = `{child:GetFullName()} must be a Model`;
        assert(v16, v17);
        local Bounds = child.Bounds;
        local v18 = Bounds:IsA("BasePart");
        local v19 = `{child:GetFullName()}.Bounds must be a BasePart`;
        assert(v18, v19);
        v15[#v15 + 1] = {
            AreaId = child.Name,
            Bounds = Bounds
        };
    end;

    assert(#v15 > 0, "Expected at least one guard area");

    return v15;
end;

function v1.HasCrossedGameplayEntryBoundary(p20, p21, p22) -- Line: 70
    -- upvalues: Asserts (copy)
    Asserts.BasePart(p20);
    Asserts.Vector3(p21);
    Asserts.Vector3(p22);
    local v23;

    if p20.CFrame.LookVector:Dot(p21 - p20.Position) <= 0 then
        v23 = p20.CFrame.LookVector:Dot(p22 - p20.Position) > 0;
    else
        v23 = false;
    end;

    return v23;
end;

function v1.HasCrossedGameplayExitBoundary(p24, p25, p26) -- Line: 83
    -- upvalues: Asserts (copy)
    Asserts.BasePart(p24);
    Asserts.Vector3(p25);
    Asserts.Vector3(p26);
    local v27;

    if p24.CFrame.LookVector:Dot(p25 - p24.Position) > 0 then
        v27 = p24.CFrame.LookVector:Dot(p26 - p24.Position) <= 0;
    else
        v27 = false;
    end;

    return v27;
end;

return v1;