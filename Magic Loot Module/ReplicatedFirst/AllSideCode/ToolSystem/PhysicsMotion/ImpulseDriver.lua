-- Decompiled with Potassium's decompiler.

local MotionResolve = require(script.Parent.MotionResolve);

return {
    apply = function(p1, p2) -- Line: 20, Name: apply
        -- upvalues: MotionResolve (copy)
        local v3 = MotionResolve.resolveWorldDirection(p1, p2);
        local v4;

        if typeof(p1.velocity) == "Vector3" then
            v4 = p1.velocity;

            if p1.plane ~= "xyz" then
                v4 = Vector3.new(v4.X, 0, v4.Z);
            end;
        else
            if typeof(p1.direction) ~= "Vector3" and v3.Magnitude <= 0.0001 then
                return false;
            end;

            local v5 = tonumber(p1.speed) or 0;

            if v5 <= 0 then
                return false;
            end;

            v4 = v3 * v5;
        end;

        if v4.Magnitude < 0.0001 then
            return false;
        end;

        local AssemblyLinearVelocity = p2.AssemblyLinearVelocity;

        if p1.preserveVertical then
            p2.AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity.X + v4.X, AssemblyLinearVelocity.Y, AssemblyLinearVelocity.Z + v4.Z);
        else
            p2.AssemblyLinearVelocity = AssemblyLinearVelocity + v4;
        end;

        return true;
    end
};