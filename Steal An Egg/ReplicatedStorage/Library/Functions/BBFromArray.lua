-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);

return function(p1, p2) -- Line: 10
    -- upvalues: Asserts (copy)
    Asserts.table(p1);
    assert(#p1 > 0, "No valid parts provided");
    local v3 = p2 or CFrame.identity;
    local v4 = Vector3.new(inf, inf, inf);
    local v5 = Vector3.new(-inf, -inf, -inf);

    for _, v in ipairs(p1) do
        if v:IsA("BasePart") then
            local CFrame2 = v.CFrame;
            local Size = v.Size;
            local v6 = {
                CFrame2 * Vector3.new(-Size.X / 2, -Size.Y / 2, -Size.Z / 2),
                CFrame2 * Vector3.new(Size.X / 2, -Size.Y / 2, -Size.Z / 2),
                CFrame2 * Vector3.new(-Size.X / 2, Size.Y / 2, -Size.Z / 2),
                CFrame2 * Vector3.new(Size.X / 2, Size.Y / 2, -Size.Z / 2),
                CFrame2 * Vector3.new(-Size.X / 2, -Size.Y / 2, Size.Z / 2),
                CFrame2 * Vector3.new(Size.X / 2, -Size.Y / 2, Size.Z / 2),
                CFrame2 * Vector3.new(-Size.X / 2, Size.Y / 2, Size.Z / 2),
                CFrame2 * Vector3.new(Size.X / 2, Size.Y / 2, Size.Z / 2)
            };

            for _, v2 in ipairs(v6) do
                local v7 = v3:PointToObjectSpace(v2);
                local v8 = math.min(v4.X, v7.X);
                local v9 = math.min(v4.Y, v7.Y);
                local v10 = math.min(v4.Z, v7.Z);
                v4 = Vector3.new(v8, v9, v10);
                local v11 = math.max(v5.X, v7.X);
                local v12 = math.max(v5.Y, v7.Y);
                local v13 = math.max(v5.Z, v7.Z);
                v5 = Vector3.new(v11, v12, v13);
            end;
        end;
    end;

    return v3 * CFrame.new((v4 + v5) / 2), v5 - v4;
end;