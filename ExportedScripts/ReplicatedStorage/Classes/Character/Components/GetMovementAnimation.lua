-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Database.Custom.Types);
local u1 = {
    FR = "ForwardRight",
    FL = "ForwardLeft",
    F = "Forward",
    BR = "BackwardRight",
    BL = "BackwardLeft",
    B = "Backward",
    R = "Right",
    L = "Left"
};

local function getCurrentMovementDirection(p2) -- Line: 27
    if not p2 then
        return false, false, false, false;
    end;

    local v3 = p2.AssemblyLinearVelocity * Vector3.new(1, 0, 1);

    if v3.Magnitude < 0.1 then
        return false, false, false, false;
    end;

    local v4 = p2.CFrame.RightVector:Dot(v3.Unit);
    local v5 = p2.CFrame.LookVector:Dot(v3.Unit);

    return v5 > 0.3, v5 < -0.3, v4 < -0.3, v4 > 0.3;
end;

return function(p6) -- Line: 53
    -- upvalues: u1 (copy)
    local PrimaryPart = p6.PrimaryPart;
    local v7, v8, v9, v10;

    if PrimaryPart then
        local v11 = PrimaryPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1);

        if v11.Magnitude < 0.1 then
            v7 = false;
            v8 = false;
            v9 = false;
            v10 = false;
        else
            local v12 = PrimaryPart.CFrame.RightVector:Dot(v11.Unit);
            local v13 = PrimaryPart.CFrame.LookVector:Dot(v11.Unit);
            v8 = v13 < -0.3;
            v7 = v13 > 0.3;
            v10 = v12 > 0.3;
            v9 = v12 < -0.3;
        end;
    else
        v7 = false;
        v8 = false;
        v9 = false;
        v10 = false;
    end;

    return u1[table.concat({
        v7 and "F" or "",
        v8 and "B" or "",
        v9 and "L" or "",
        v10 and "R" or ""
    })];
end;