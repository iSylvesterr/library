-- Decompiled with Potassium's decompiler.

local Workspace = game:GetService("Workspace");

local function insideBox(p1, p2) -- Line: 3
    local v3;

    if p1.X >= -p2.X and (p1.X <= p2.X and (p1.Y >= -p2.Y and (p1.Y <= p2.Y and p1.Z >= -p2.Z))) then
        v3 = p1.Z <= p2.Z;
    else
        v3 = false;
    end;

    return v3;
end;

return function(u4, p5, p6) -- Line: 12
    -- upvalues: Workspace (copy)
    local v7;

    if typeof(u4) == "Instance" then
        v7 = u4:IsA("PVInstance");
    else
        v7 = false;
    end;

    assert(v7);
    local v8 = p5 == nil and true or type(p5) == "number";
    assert(v8);
    local v9 = p6 == nil and true or type(p6) == "number";
    assert(v9);
    local v10 = p5 or 300;
    local u11 = p6 or 3;
    local v12 = Vector3.new(0, 0, 0);

    if u4:IsA("Model") then
        local v13;
        v13, v12 = u4:GetBoundingBox();
        _ = v13;
    elseif u4:IsA("BasePart") then
        v12 = u4.Size;
    end;

    local u14 = v12 * 0.5 + Vector3.new(v10, v10, v10);
    local u15 = (-1 / 0);
    local u16 = false;

    return function() -- Line: 29
        -- upvalues: u15 (ref), u11 (copy), Workspace (ref), u4 (copy), u16 (ref), u14 (copy)
        local v17 = os.clock();

        if u15 <= v17 then
            u15 = v17 + u11 * (0.5 + math.random());
            local Position = Workspace.CurrentCamera.CFrame.Position;
            local v18 = u4:GetPivot():PointToObjectSpace(Position);
            local v19 = u14;
            local v20;

            if v18.X >= -v19.X and (v18.X <= v19.X and (v18.Y >= -v19.Y and (v18.Y <= v19.Y and v18.Z >= -v19.Z))) then
                v20 = v18.Z <= v19.Z;
            else
                v20 = false;
            end;

            u16 = v20;
        end;

        return u16;
    end;
end;