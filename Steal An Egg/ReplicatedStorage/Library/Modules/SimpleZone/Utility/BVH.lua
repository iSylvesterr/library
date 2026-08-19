-- Decompiled with Potassium's decompiler.

function traverseBVH(p1, p2)
    local u3 = { p1 };
    local v4 = 1;
    local u5 = false;

    local function stop() -- Line: 23
        -- upvalues: u3 (copy), u5 (ref)
        table.clear(u3);
        u5 = true;
    end;

    while v4 > 0 and not u5 do
        local v6 = u3[v4];
        v4 = v4 - 1;

        if v6.volume >= 0.001 and p2(v6, stop) then
            if v6.right then
                v4 = v4 + 1;
                u3[v4] = v6.right;
            end;

            if v6.left then
                v4 = v4 + 1;
                u3[v4] = v6.left;
            end;
        end;
    end;
end;

local function getBoundingBox(p7) -- Line: 56
    local v8 = Vector3.new(inf, inf, inf);
    local v9 = Vector3.new(-inf, -inf, -inf);

    for _, v in p7 do
        local cframe = v.cframe;
        local v10 = v.size * 0.5;

        for _, v2 in {
            cframe.Position + vector.create(-v10.X, -v10.Y, -v10.Z),
            cframe.Position + vector.create(v10.X, -v10.Y, -v10.Z),
            cframe.Position + vector.create(-v10.X, v10.Y, -v10.Z),
            cframe.Position + vector.create(v10.X, v10.Y, -v10.Z),
            cframe.Position + vector.create(-v10.X, -v10.Y, v10.Z),
            cframe.Position + vector.create(v10.X, -v10.Y, v10.Z),
            cframe.Position + vector.create(-v10.X, v10.Y, v10.Z),
            cframe.Position + vector.create(v10.X, v10.Y, v10.Z)
        } do
            local v11 = math.min(v8.X, v2.X) // 4 * 4;
            local v12 = math.min(v8.Y, v2.Y) // 4 * 4;
            local v13 = math.min(v8.Z, v2.Z) // 4 * 4;
            v8 = vector.create(v11, v12, v13);
            local v14 = math.max(v9.X, v2.X) // 4 * 4;
            local v15 = math.max(v9.Y, v2.Y) // 4 * 4;
            local v16 = math.max(v9.Z, v2.Z) // 4 * 4;
            v9 = vector.create(v14, v15, v16);
        end;
    end;

    return CFrame.new((v8 + v9) / 2), v9 - v8;
end;

local function determine(p17, p18, p19) -- Line: 100
    -- upvalues: getBoundingBox (copy)
    if #p19 <= 1 then
        if #p19 == 1 then
            local v20 = p19[1];
            p17[p18] = {
                cframe = v20.cframe,
                size = v20.size,
                volume = v20.size.x * v20.size.y * v20.size.z,
                part = v20.part
            };
        end;

        return;
    end;

    local v21, v22 = getBoundingBox(p19);
    p17[p18] = {
        cframe = v21,
        size = v22,
        volume = v22.x * v22.y * v22.z
    };
    split(p17[p18], p19);
end;

function split(p23, p24)
    -- upvalues: determine (copy)
    local size = p23.size;
    local u25 = size.X >= size.Y and size.X >= size.Z and "X" or (size.Y >= size.X and size.Y >= size.Z and "Y" or (size.Z >= size.Y and size.Z >= size.X and "Z" or nil));
    table.sort(p24, function(p26, p27) -- Line: 133
        -- upvalues: u25 (ref)
        return p26.cframe[u25] < p27.cframe[u25];
    end);
    local v28 = #p24;
    local v29 = v28 // 2;
    local v30 = table.create(v29);
    local v31 = table.create(v29);
    table.move(p24, 1, v29, 1, v30);
    table.move(p24, v29 + 1, v28, 1, v31);
    determine(p23, "left", v30);
    determine(p23, "right", v31);
end;

local function calculateDistance(p32, p33) -- Line: 163
    return (p32.cframe.Position - p33.cframe.Position).Magnitude;
end;

local function needsUpdate(p34, p35, p36) -- Line: 170
    return p36 < (p34.cframe.Position - p35.cframe.Position).Magnitude and true or p36 < (p34.size - p35.size).Magnitude;
end;

local function updateBVHNode(p37, p38, p39, p40) -- Line: 179
    -- upvalues: updateBVHNode (copy)
    if not p37 then
        return;
    end;

    if not p37.part then
        if not (updateBVHNode(p37.left, p38, p39, p40) or updateBVHNode(p37.right, p38, p39, p40)) then
            return false;
        end;

        local v41 = p37.left and {
            cframe = p37.left.cframe,
            size = p37.left.size,
            volume = p37.left.volume
        };
        local v42 = p37.right and {
            cframe = p37.right.cframe,
            size = p37.right.size,
            volume = p37.right.volume
        };

        if v41 and v42 then
            local Position = v41.cframe.Position;
            local Position2 = v42.cframe.Position;
            local v43 = math.min(Position.X - v41.size.X / 2, Position2.X - v42.size.X / 2) // 4 * 4;
            local v44 = math.min(Position.Y - v41.size.Y / 2, Position2.Y - v42.size.Y / 2) // 4 * 4;
            local v45 = math.min(Position.Z - v41.size.Z / 2, Position2.Z - v42.size.Z / 2) // 4 * 4;
            local v46 = vector.create(v43, v44, v45);
            local v47 = math.max(Position.X + v41.size.X / 2, Position2.X + v42.size.X / 2) // 4 * 4;
            local v48 = math.max(Position.Y + v41.size.Y / 2, Position2.Y + v42.size.Y / 2) // 4 * 4;
            local v49 = math.max(Position.Z + v41.size.Z / 2, Position2.Z + v42.size.Z / 2) // 4 * 4;
            local v50 = vector.create(v47, v48, v49);
            local v51 = v50 - v46;
            p37.cframe = CFrame.new((v46 + v50) / 2);
            p37.size = v51;
            p37.volume = v51.x * v51.y * v51.z;
        elseif v41 then
            p37.cframe = v41.cframe;
            p37.size = v41.size;
            p37.volume = v41.volume;
        elseif v42 then
            p37.cframe = v42.cframe;
            p37.size = v42.size;
            p37.volume = v42.volume;
        end;

        return true;
    end;

    local v52 = {
        cframe = p37.cframe,
        size = p37.size,
        volume = p37.volume,
        part = p37.part
    };
    local v53 = nil;

    for _, v in p39 do
        if v.part == p37.part then
            v53 = v;
            break;
        end;
    end;

    if not v53 or p40 >= (v52.cframe.Position - v53.cframe.Position).Magnitude and p40 >= (v52.size - v53.size).Magnitude then
        return false;
    end;

    p37.cframe = v53.cframe;
    p37.size = v53.size;
    p37.volume = v53.volume;

    return true;
end;

return {
    VoxelSize = 4,

    createBVH = function(p54) -- Line: 149, Name: createBVH
        -- upvalues: getBoundingBox (copy)
        local v55, v56 = getBoundingBox(p54);
        local v57 = {
            cframe = v55,
            size = v56,
            volume = v56.x * v56.y * v56.z
        };
        split(v57, p54);

        return v57;
    end,

    traverseBVH = traverseBVH,

    updateBVH = function(p58, p59, p60, p61) -- Line: 282, Name: updateBVH
        -- upvalues: updateBVHNode (copy)
        return updateBVHNode(p58, p59, p60, p61 or 0.1);
    end,

    getBoundingBox = getBoundingBox,

    visualize = function(p62) -- Line: 290, Name: visualize
        traverseBVH(p62, function(p63) -- Line: 291
            local Part = Instance.new("Part");
            Part.Anchored = true;
            Part.Transparency = 0.7;
            Part.CFrame = p63.cframe;
            Part.Size = p63.size;
            Part.Parent = workspace;
            Part.CanCollide = false;
            Part.CanQuery = false;

            if not (p63.right or p63.left) then
                Part.Color = Color3.fromRGB(255, 0, 0);
            end;

            return true;
        end);
    end
};