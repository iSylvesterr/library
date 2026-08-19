-- Decompiled with Potassium's decompiler.

local v1 = {};
local WedgePart = Instance.new("WedgePart");
WedgePart.Color = Color3.fromRGB(200, 255, 200);
WedgePart.Material = Enum.Material.SmoothPlastic;
WedgePart.Reflectance = 0;
WedgePart.Transparency = 0;
WedgePart.Name = "Tri";
WedgePart.Anchored = true;
WedgePart.CanCollide = false;
WedgePart.CanTouch = false;
WedgePart.CanQuery = false;
WedgePart.CFrame = CFrame.new();
WedgePart.Size = Vector3.new(0.25, 0.25, 0.25);
WedgePart.BottomSurface = Enum.SurfaceType.Smooth;
WedgePart.TopSurface = Enum.SurfaceType.Smooth;

local function fromAxes(p2, p3, p4, p5) -- Line: 18
    return CFrame.new(p2.x, p2.y, p2.z, p3.x, p4.x, p5.x, p3.y, p4.y, p5.y, p3.z, p4.z, p5.z);
end;

function v1.Triangle(p6, p7, p8, p9) -- Line: 22
    -- upvalues: WedgePart (copy)
    local magnitude = (p8 - p7).magnitude;
    local magnitude2 = (p9 - p7).magnitude;
    local magnitude3 = (p9 - p8).magnitude;

    if magnitude3 < magnitude and magnitude2 < magnitude then
        local v10 = p9;
        p9 = p7;
        p7 = p8;
        p8 = v10;
    elseif magnitude3 < magnitude2 then
        if magnitude >= magnitude2 then
            local v11 = p8;
            p8 = p7;
            p7 = v11;
        end;
    else
        local v12 = p8;
        p8 = p7;
        p7 = v12;
    end;

    local v13 = p7 - p8;
    local v14 = p9 - p8;
    local v15 = p9 - p7;
    local unit = v14:Cross(v13).unit;
    local v16 = WedgePart:Clone();
    local v17 = WedgePart:Clone();
    local unit2 = v15:Cross(unit).unit;
    local v18 = v13:Dot(unit2);
    local v19 = math.abs(v18);
    local magnitude4 = v15.magnitude;
    local v20 = v13:Dot(v15);
    local v21 = math.abs(v20) / magnitude4;
    v16.Size = Vector3.new(0, v21, v19);
    local v22 = v14:Dot(v15);
    local v23 = math.abs(v22) / magnitude4;
    v17.Size = Vector3.new(0, v19, v23);
    local v24 = -v15.unit;
    local v25 = (p8 + p7) / 2;
    local v26 = -unit;
    local v27 = -unit2;
    v16.CFrame = CFrame.new(v25.x, v25.y, v25.z, v26.x, v24.x, v27.x, v26.y, v24.y, v27.y, v26.z, v24.z, v27.z);
    local v28 = (p8 + p9) / 2;
    local v29 = -unit;
    v17.CFrame = CFrame.new(v28.x, v28.y, v28.z, v29.x, unit2.x, v24.x, v29.y, unit2.y, v24.y, v29.z, unit2.z, v24.z);

    return v16, v17;
end;

return v1;