-- Decompiled with Potassium's decompiler.

local Parent = script.Parent.Parent;
require(Parent.PubTypes);
local Oklab = require(Parent.Colour.Oklab);

return function(p1, p2, p3) -- Line: 16, Name: lerpType
    -- upvalues: Oklab (copy)
    local v4 = typeof(p1);

    if typeof(p2) == v4 then
        if v4 == "number" then
            return (p2 - p1) * p3 + p1;
        end;

        if v4 == "CFrame" then
            return p1:Lerp(p2, p3);
        end;

        if v4 == "Color3" then
            local v5 = Oklab.to(p1);
            local v6 = Oklab.to(p2);

            return Oklab.from(v5:Lerp(v6, p3), false);
        end;

        if v4 == "ColorSequenceKeypoint" then
            local v7 = Oklab.to(p1.Value);
            local v8 = Oklab.to(p2.Value);

            return ColorSequenceKeypoint.new((p2.Time - p1.Time) * p3 + p1.Time, Oklab.from(v7:Lerp(v8, p3), false));
        end;

        if v4 == "DateTime" then
            return DateTime.fromUnixTimestampMillis((p2.UnixTimestampMillis - p1.UnixTimestampMillis) * p3 + p1.UnixTimestampMillis);
        end;

        if v4 == "NumberRange" then
            return NumberRange.new((p2.Min - p1.Min) * p3 + p1.Min, (p2.Max - p1.Max) * p3 + p1.Max);
        end;

        if v4 == "NumberSequenceKeypoint" then
            return NumberSequenceKeypoint.new((p2.Time - p1.Time) * p3 + p1.Time, (p2.Value - p1.Value) * p3 + p1.Value, (p2.Envelope - p1.Envelope) * p3 + p1.Envelope);
        end;

        if v4 == "PhysicalProperties" then
            return PhysicalProperties.new((p2.Density - p1.Density) * p3 + p1.Density, (p2.Friction - p1.Friction) * p3 + p1.Friction, (p2.Elasticity - p1.Elasticity) * p3 + p1.Elasticity, (p2.FrictionWeight - p1.FrictionWeight) * p3 + p1.FrictionWeight, (p2.ElasticityWeight - p1.ElasticityWeight) * p3 + p1.ElasticityWeight);
        end;

        if v4 == "Ray" then
            return Ray.new(p1.Origin:Lerp(p2.Origin, p3), p1.Direction:Lerp(p2.Direction, p3));
        end;

        if v4 == "Rect" then
            return Rect.new(p1.Min:Lerp(p2.Min, p3), p1.Max:Lerp(p2.Max, p3));
        end;

        if v4 == "Region3" then
            local v9 = p1.CFrame.Position:Lerp(p2.CFrame.Position, p3);
            local v10 = p1.Size:Lerp(p2.Size, p3) / 2;

            return Region3.new(v9 - v10, v9 + v10);
        end;

        if v4 == "Region3int16" then
            return Region3int16.new(Vector3int16.new((p2.Min.X - p1.Min.X) * p3 + p1.Min.X, (p2.Min.Y - p1.Min.Y) * p3 + p1.Min.Y, (p2.Min.Z - p1.Min.Z) * p3 + p1.Min.Z), Vector3int16.new((p2.Max.X - p1.Max.X) * p3 + p1.Max.X, (p2.Max.Y - p1.Max.Y) * p3 + p1.Max.Y, (p2.Max.Z - p1.Max.Z) * p3 + p1.Max.Z));
        end;

        if v4 == "UDim" then
            return UDim.new((p2.Scale - p1.Scale) * p3 + p1.Scale, (p2.Offset - p1.Offset) * p3 + p1.Offset);
        end;

        if v4 == "UDim2" then
            return p1:Lerp(p2, p3);
        end;

        if v4 == "Vector2" then
            return p1:Lerp(p2, p3);
        end;

        if v4 == "Vector2int16" then
            return Vector2int16.new((p2.X - p1.X) * p3 + p1.X, (p2.Y - p1.Y) * p3 + p1.Y);
        end;

        if v4 == "Vector3" then
            return p1:Lerp(p2, p3);
        end;

        if v4 == "Vector3int16" then
            return Vector3int16.new((p2.X - p1.X) * p3 + p1.X, (p2.Y - p1.Y) * p3 + p1.Y, (p2.Z - p1.Z) * p3 + p1.Z);
        end;
    end;

    if p3 < 0.5 then
        return p1;
    end;

    return p2;
end;