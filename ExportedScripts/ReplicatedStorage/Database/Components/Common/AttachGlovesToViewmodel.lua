-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 12
    local v3 = {};

    for _, v in ipairs(p1) do
        if v:IsA("BasePart") then
            local v4 = p2:FindFirstChild(v.Name);

            if v4 then
                local Scales = v:FindFirstChild("Scales");
                local Offsets = v:FindFirstChild("Offsets");
                local Rotations = v:FindFirstChild("Rotations");

                if Scales then
                    Scales = Scales:FindFirstChild("Camera");
                end;

                if Offsets then
                    Offsets = Offsets:FindFirstChild("Camera");
                end;

                if Rotations then
                    Rotations = Rotations:FindFirstChild("Camera");
                end;

                if Scales then
                    Scales = Scales.Value;
                end;

                local v5 = Offsets and Offsets.Value or Vector3.new(0, 0, 0);
                local v6 = Rotations and Rotations.Value or Vector3.new(0, 0, 0);
                local v7 = math.rad(v6.X);
                local v8 = math.rad(v6.Y);
                local v9 = math.rad(v6.Z);
                local v10 = Vector3.new(v7, v8, v9);
                local v11 = v:Clone();
                v11.CastShadow = false;
                v11.CanCollide = false;
                v11.CanTouch = false;
                v11.Anchored = true;
                v11.CanQuery = false;
                v11.Name = "Glove";
                local Scales2 = v11:FindFirstChild("Scales");
                local Offsets2 = v11:FindFirstChild("Offsets");
                local Rotations2 = v11:FindFirstChild("Rotations");

                if Scales2 then
                    Scales2:Destroy();
                end;

                if Offsets2 then
                    Offsets2:Destroy();
                end;

                if Rotations2 then
                    Rotations2:Destroy();
                end;

                v11.Size = Vector3.new(v4.Size.X * (Scales and (Scales.X or 1) or 1), v4.Size.Y * (Scales and (Scales.Y or 1) or 1), v4.Size.Z * (Scales and Scales.Z or 1));
                local v12 = v4.Size.Z / 2 - v11.Size.Z / 2;
                local v13 = CFrame.new(v5) * CFrame.new(0, 0, -v12 * 1.035) * v11.PivotOffset * CFrame.Angles(v10.X, v10.Y, v10.Z);
                v11.Parent = v4;
                local WeldConstraint = Instance.new("WeldConstraint", v11);
                WeldConstraint.Part0 = v4;
                WeldConstraint.Part1 = v11;
                v11.CFrame = v4.CFrame * v13;
                v11.Anchored = false;
                table.insert(v3, v11);
            end;
        end;
    end;

    return v3;
end;