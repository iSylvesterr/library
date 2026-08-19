-- Decompiled with Potassium's decompiler.

return {
    new = function(p1) -- Line: 4, Name: new
        local v2 = p1.Amount or 4;
        local v3 = p1.Delay or 1;
        local v4 = p1.SizeMin or Vector3.new(1, 1, 1);
        local v5 = p1.SizeMax or Vector3.new(1, 1, 1);
        local v6 = p1.Colors or { Color3.new(1, 1, 1) };
        local v7 = p1.Material or Enum.Material.Plastic;
        local v8 = p1.Velocity or 30;
        local _ = p1.Direction or Vector3.new(0, 1, 0);
        local v9 = p1.Spread or 45;
        local u10 = p1.Lifetime or 3;
        local Origin = p1.Origin;
        local v11 = Random.new();
        local v12 = {};

        for _ = 1, v2 do
            local Part = Instance.new("Part");
            Part.Anchored = false;
            Part.CanCollide = true;
            local v13 = v11:NextNumber(v4.X, v5.X);
            local v14 = v11:NextNumber(v4.Y, v5.Y);
            Part.Size = Vector3.new(v13, v14, v11:NextNumber(v4.Z, v5.Z));
            Part.Transparency = 0;
            Part.CFrame = Origin;
            Part.Material = v7;
            Part.Color = v6[math.random(1, #v6)];
            table.insert(v12, Part);
        end;

        for _, v in v12 do
            v.Parent = workspace.Temporary;
            game.Debris:AddItem(v, u10 + v3);
            local v15 = v11:NextNumber(-v9, v9);
            local v16 = v11:NextNumber(-v9, v9);
            v:ApplyImpulse((Origin * CFrame.Angles(0, math.rad(v15), 0) * CFrame.Angles(math.rad(v16), 0, 0)).LookVector * v8 * v.AssemblyMass);
            task.delay(v3, function() -- Line: 65
                -- upvalues: v (copy), u10 (copy)
                game.TweenService:Create(v, TweenInfo.new(u10), {
                    Size = Vector3.new(0, 0, 0)
                }):Play();
                task.delay(0.1, function() -- Line: 67
                    -- upvalues: v (ref)
                    v.CanCollide = true;
                end);
            end);
        end;
    end
};