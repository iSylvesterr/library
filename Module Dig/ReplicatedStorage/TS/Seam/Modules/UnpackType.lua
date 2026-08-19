-- Decompiled with Potassium's decompiler.

local Oklab = require(script.Parent.Oklab);

return function(p1, p2) -- Line: 20, Name: unpackType
    -- upvalues: Oklab (copy)
    if p2 == "number" then
        return { p1 };
    end;

    if p2 == "CFrame" then
        local v3, v4 = p1:ToAxisAngle();

        return {
            p1.X,
            p1.Y,
            p1.Z,
            v3.X,
            v3.Y,
            v3.Z,
            v4
        };
    end;

    if p2 == "Color3" then
        local v5 = Oklab.to(p1);

        return { v5.X, v5.Y, v5.Z };
    end;

    if p2 ~= "ColorSequenceKeypoint" then
        return p2 == "DateTime" and { p1.UnixTimestampMillis } or (p2 == "NumberRange" and { p1.Min, p1.Max } or (p2 == "NumberSequenceKeypoint" and { p1.Value, p1.Time, p1.Envelope } or (p2 == "PhysicalProperties" and {
            p1.Density,
            p1.Friction,
            p1.Elasticity,
            p1.FrictionWeight,
            p1.ElasticityWeight
        } or (p2 == "Ray" and {
            p1.Origin.X,
            p1.Origin.Y,
            p1.Origin.Z,
            p1.Direction.X,
            p1.Direction.Y,
            p1.Direction.Z
        } or (p2 == "Rect" and {
            p1.Min.X,
            p1.Min.Y,
            p1.Max.X,
            p1.Max.Y
        } or (p2 == "Region3" and {
            p1.CFrame.X,
            p1.CFrame.Y,
            p1.CFrame.Z,
            p1.Size.X,
            p1.Size.Y,
            p1.Size.Z
        } or (p2 == "Region3int16" and {
            p1.Min.X,
            p1.Min.Y,
            p1.Min.Z,
            p1.Max.X,
            p1.Max.Y,
            p1.Max.Z
        } or (p2 == "UDim" and { p1.Scale, p1.Offset } or (p2 == "UDim2" and {
            p1.X.Scale,
            p1.X.Offset,
            p1.Y.Scale,
            p1.Y.Offset
        } or (p2 == "Vector2" and { p1.X, p1.Y } or (p2 == "Vector2int16" and { p1.X, p1.Y } or (p2 == "Vector3" and { p1.X, p1.Y, p1.Z } or (p2 == "Vector3int16" and { p1.X, p1.Y, p1.Z } or {})))))))))))));
    end;

    local v6 = Oklab.to(p1.Value);

    return {
        v6.X,
        v6.Y,
        v6.Z,
        p1.Time
    };
end;