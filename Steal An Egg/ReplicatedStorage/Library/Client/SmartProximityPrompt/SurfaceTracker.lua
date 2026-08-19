-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
u1.__class = "SurfaceTracker";

function u1.new(p2, p3) -- Line: 26
    -- upvalues: u1 (copy)
    local u4 = setmetatable({}, u1);
    u4.Model = p2;
    u4.IgnoredPart = p3;
    u4.Parts = {};
    u4.DescendantAddedConnection = nil;
    u4.DescendantRemovingConnection = nil;
    u4.IsDestroyed = false;
    u4:Refresh();
    u4.DescendantAddedConnection = p2.DescendantAdded:Connect(function(p5) -- Line: 37
        -- upvalues: u4 (copy)
        if p5:IsA("BasePart") then
            u4:Refresh();
        end;
    end);
    u4.DescendantRemovingConnection = p2.DescendantRemoving:Connect(function(p6) -- Line: 42
        -- upvalues: u4 (copy)
        if p6:IsA("BasePart") then
            u4:Refresh();
        end;
    end);

    return u4;
end;

function u1._closestPointOnPart(p7, p8) -- Line: 55
    local v9 = p7.CFrame:PointToObjectSpace(p8);
    local v10 = p7.Size * 0.5;
    local v11 = math.clamp(v9.X, -v10.X, v10.X);
    local v12 = math.clamp(v9.Y, -v10.Y, v10.Y);
    local v13 = math.clamp(v9.Z, -v10.Z, v10.Z);
    local v14 = Vector3.new(v11, v12, v13);

    return p7.CFrame:PointToWorldSpace(v14);
end;

function u1.Refresh(p15) -- Line: 71
    table.clear(p15.Parts);

    for _, descendant in ipairs(p15.Model:GetDescendants()) do
        if descendant:IsA("BasePart") and (descendant ~= p15.IgnoredPart and descendant.Parent ~= nil) then
            table.insert(p15.Parts, descendant);
        end;
    end;
end;

function u1.GetClosestSurfacePoint(p16, p17, p18) -- Line: 80
    -- upvalues: u1 (copy)
    local v19 = (1 / 0);
    local v20 = nil;

    for _, v in ipairs(p16.Parts) do
        if v.Parent ~= nil then
            local v21 = u1._closestPointOnPart(v, p17);
            local Magnitude = (p17 - v21).Magnitude;

            if Magnitude < v19 then
                v20 = v21;
                v19 = Magnitude;
            end;
        end;
    end;

    if v20 == nil then
        return nil, nil;
    end;

    local v22 = p17 - v20;

    return v20 + (v22.Magnitude < 0.0001 and Vector3.new(0, 1, 0) or v22.Unit) * (p18 or 0), v19;
end;

function u1.Destroy(p23) -- Line: 112
    if p23.IsDestroyed then
        return;
    end;

    p23.IsDestroyed = true;
    local DescendantAddedConnection = p23.DescendantAddedConnection;

    if DescendantAddedConnection ~= nil then
        DescendantAddedConnection:Disconnect();
        p23.DescendantAddedConnection = nil;
    end;

    local DescendantRemovingConnection = p23.DescendantRemovingConnection;

    if DescendantRemovingConnection ~= nil then
        DescendantRemovingConnection:Disconnect();
        p23.DescendantRemovingConnection = nil;
    end;

    table.clear(p23.Parts);
end;

return u1;