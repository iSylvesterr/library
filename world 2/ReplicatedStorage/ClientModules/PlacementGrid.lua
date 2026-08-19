-- Decompiled with Potassium's decompiler.

local u11 = {
    SnapToGrid = function(p1, p2, p3) -- Line: 3, Name: SnapToGrid
        local v4 = p2.CFrame:PointToObjectSpace(p1);
        local v5 = math.round(v4.X / p3) * p3;
        local Y = v4.Y;
        local v6 = math.round(v4.Z / p3) * p3;
        local v7 = Vector3.new(v5, Y, v6);

        return p2.CFrame:PointToWorldSpace(v7);
    end,

    GetGardenRotationY = function(p8) -- Line: 13, Name: GetGardenRotationY
        local _, v9, _ = p8.CFrame:ToEulerAnglesYXZ();

        return v9;
    end,

    CalculateYOffset = function(p10) -- Line: 18, Name: CalculateYOffset
        if not (p10 and p10.PrimaryPart) then
            return 0;
        end;

        local PrimaryPart = p10.PrimaryPart;

        return PrimaryPart.Size.Y / 2 + (p10:GetPivot().Position.Y - PrimaryPart.Position.Y);
    end
};

function u11.PositionModel(p12, p13, p14, p15) -- Line: 32
    -- upvalues: u11 (copy)
    if not (p12 and p12.PrimaryPart) then
        return CFrame.new(p13);
    end;

    local v16 = CFrame.Angles(0, p14 + math.rad(p15), 0);
    local FloorAttachment = p12.PrimaryPart:FindFirstChild("FloorAttachment");

    if FloorAttachment then
        return CFrame.new(p13) * v16 * FloorAttachment.CFrame:Inverse();
    end;

    local v17 = u11.CalculateYOffset(p12);

    return CFrame.new(p13 + Vector3.new(0, v17, 0)) * v16;
end;

return u11;