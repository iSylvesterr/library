-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 9
    local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);

    function p1.GetGroundAlignedCF(p2, p3, p4, p5, p6) -- Line: 26
        -- upvalues: UtilsSystem (copy)
        local v7 = UtilsSystem.RayCast.RayCastDirection(p2 + Vector3.new(0, p5 or 4, 0), Vector3.new(0, -1, 0), 200, p4 or "Ground");

        if not v7 then
            return nil;
        end;

        local Normal = v7.Normal;
        local v8 = v7.Position + Normal * (p6 or 0.12);
        local v9 = p3 * Vector3.new(1, 0, 1);
        local v10 = v9.Magnitude < 0.05 and Vector3.new(0, 0, -1) or v9.Unit;
        local v11 = v10 - Normal * v10:Dot(Normal);
        local v12;

        if v11.Magnitude < 0.05 then
            local v13 = (Vector3.new(0, 1, 0)):Cross(Normal);

            if v13.Magnitude < 0.05 then
                v13 = (Vector3.new(0, 0, 1)):Cross(Normal);
            end;

            if v13.Magnitude < 0.05 then
                return CFrame.new(v8);
            end;

            v12 = v13.Unit;
        else
            v12 = v11.Unit;
        end;

        return CFrame.lookAt(v8, v8 + v12, Normal);
    end;
end;