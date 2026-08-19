-- Decompiled with Potassium's decompiler.

local v1 = {};

local function sameVectors(p2, p3) -- Line: 51
    local v4;

    if p2.X ^ 2 == p3.X ^ 2 then
        v4 = p2.Y ^ 2 == p3.Y ^ 2;
    else
        v4 = false;
    end;

    return v4;
end;

local function newSpriteSheet(u5, u6) -- Line: 55
    local u7 = {
        totalCells = #u5,
        instance = u6,
        _frames = u5
    };

    function u7.display(p8) -- Line: 61
        -- upvalues: u5 (copy), u6 (copy), u7 (copy)
        if not u5[p8] then
            error((`index {p8} out of range in spritesheet`));
        end;

        local v9 = u5[p8];

        if u6.Image ~= v9.url then
            u6.Image = v9.url;
        end;

        local ImageRectSize = u6.ImageRectSize;
        local size = v9.size;
        local v10;

        if ImageRectSize.X ^ 2 == size.X ^ 2 then
            v10 = ImageRectSize.Y ^ 2 == size.Y ^ 2;
        else
            v10 = false;
        end;

        if not v10 then
            u6.ImageRectSize = v9.size;
        end;

        local new = Vector2.new;
        local v11;

        if u7.isMirroredX() then
            v11 = v9.offset.X - u6.ImageRectSize.X;
        else
            v11 = v9.offset.X;
        end;

        local v12;

        if u7.isMirroredY() then
            v12 = v9.offset.Y - u6.ImageRectSize.Y;
        else
            v12 = v9.offset.Y;
        end;

        u6.ImageRectOffset = new(v11, v12);
        u7.currentCell = p8;
    end;

    function u7.flip() -- Line: 76
        -- upvalues: u7 (copy)
        u7.mirrorX();
    end;

    function u7.mirrorX() -- Line: 80
        -- upvalues: u6 (copy), u7 (copy)
        u6.ImageRectSize = u6.ImageRectSize * Vector2.new(-1, 1);
        u7.display(u7.currentCell);
    end;

    function u7.mirrorY() -- Line: 85
        -- upvalues: u6 (copy), u7 (copy)
        u6.ImageRectSize = u6.ImageRectSize * Vector2.new(1, -1);
        u7.display(u7.currentCell);
    end;

    function u7.isFlipped() -- Line: 90
        -- upvalues: u7 (copy)
        u7.isMirroredX();
    end;

    function u7.isMirroredX() -- Line: 94
        -- upvalues: u6 (copy)
        return u6.ImageRectSize.X < 0;
    end;

    function u7.isMirroredY() -- Line: 98
        -- upvalues: u6 (copy)
        return u6.ImageRectSize.Y < 0;
    end;

    function u7.extend(p13) -- Line: 102
        -- upvalues: u5 (copy), u7 (copy)
        for _, v in p13._frames do
            u5[#u5 + 1] = v;
        end;

        u7.totalCells = #u5;
    end;

    function u7.length() -- Line: 110
        -- upvalues: u5 (copy)
        return #u5;
    end;

    u7.display(1);

    return u7;
end;

function v1.new(p14, p15, p16, p17) -- Line: 118
    -- upvalues: newSpriteSheet (copy)
    local v18 = p14:IsA("ImageLabel");
    assert(v18, "Instance must be an ImageLabel");
    local v19 = p16 / p17;
    local v20 = math.floor(v19.X);
    local v21 = math.floor(v19.Y);
    p14.Image = p15;
    p14.ImageRectSize = p17;
    p14.ImageRectOffset = Vector2.zero;
    local v22 = 0;
    local v23 = {};

    while true do
        local v24 = 0;

        repeat
            v23[v22 * v20 + v24 + 1] = {
                offset = Vector2.new(p17.X * v24, p17.Y * v22),
                url = p15,
                size = p17
            };
            v24 = v24 + 1;
        until v20 <= v24;

        v22 = v22 + 1;

        if v21 <= v22 then
            return newSpriteSheet(v23, p14);
        end;
    end;
end;

return v1;