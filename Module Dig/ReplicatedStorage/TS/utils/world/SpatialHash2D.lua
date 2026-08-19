-- Decompiled with Potassium's decompiler.

local u1 = setmetatable({}, {
    __tostring = function() -- Line: 5, Name: __tostring
        return "SpatialHash2D";
    end
});
u1.__index = u1;

function u1.new(...) -- Line: 10
    -- upvalues: u1 (ref)
    local v2 = setmetatable({}, u1);

    return v2:constructor(...) or v2;
end;

function u1.constructor(p3, p4) -- Line: 14
    p3.buckets = {};
    p3.cellSize = p4;
    p3.invCellSize = 1 / p4;
end;

function u1.clear(p5) -- Line: 19
    table.clear(p5.buckets);
end;

function u1.setCellSize(p6, p7) -- Line: 22
    if p6.cellSize == p7 then
        return nil;
    end;

    p6.cellSize = p7;
    p6.invCellSize = 1 / p7;
    table.clear(p6.buckets);
end;

function u1.insert(p8, p9, p10, p11) -- Line: 30
    local v12 = p8:makeKey(math.floor(p9 * p8.invCellSize), (math.floor(p10 * p8.invCellSize)));
    local v13 = p8.buckets[v12];

    if v13 == nil then
        v13 = {};
        p8.buckets[v12] = v13;
    end;

    table.insert(v13, {
        x = p9,
        z = p10,
        value = p11
    });
end;

function u1.queryRadius(p14, p15, p16, p17, p18) -- Line: 49
    local v19 = p17 * p17;
    local v20 = math.floor((p15 - p17) * p14.invCellSize);
    local v21 = math.floor((p15 + p17) * p14.invCellSize);
    local v22 = math.floor((p16 - p17) * p14.invCellSize);
    local v23 = math.floor((p16 + p17) * p14.invCellSize);
    local v24 = false;
    local v25 = 0;

    while true do
        if v24 then
            v20 = v20 + 1;
        else
            v24 = true;
        end;

        if v20 > v21 then
            return v25;
        end;

        local v26 = v22;
        local v27 = false;

        while true do
            if true then
                if v27 then
                    v22 = v22 + 1;
                else
                    v27 = true;
                end;
            end;

            if v22 > v23 then
                break;
            end;

            local v28 = p14.buckets[p14:makeKey(v20, v22)];

            if v28 ~= nil then
                for i = 0, #v28 - 1 do
                    local v29 = v28[i + 1];
                    local v30 = v29.x - p15;
                    local v31 = v29.z - p16;

                    if v30 * v30 + v31 * v31 <= v19 then
                        p18[v25 + 1] = v29;
                        v25 = v25 + 1;
                    end;
                end;
            end;
        end;

        v22 = v26;
    end;
end;

function u1.queryNearest(p32, p33, p34, p35, p36) -- Line: 101
    local v37 = p35 * p35;
    local v38 = math.floor((p33 - p35) * p32.invCellSize);
    local v39 = math.floor((p33 + p35) * p32.invCellSize);
    local v40 = math.floor((p34 - p35) * p32.invCellSize);
    local v41 = math.floor((p34 + p35) * p32.invCellSize);
    local v42 = false;
    local v43 = nil;

    while true do
        if v42 then
            v38 = v38 + 1;
        else
            v42 = true;
        end;

        if v38 > v39 then
            return v43;
        end;

        local v44 = v40;
        local v45 = false;

        while true do
            if true then
                if v45 then
                    v40 = v40 + 1;
                else
                    v45 = true;
                end;
            end;

            if v40 > v41 then
                break;
            end;

            local v46 = p32.buckets[p32:makeKey(v38, v40)];

            if v46 ~= nil then
                for i = 0, #v46 - 1 do
                    local v47 = v46[i + 1];
                    local v48 = v47.x - p33;
                    local v49 = v47.z - p34;
                    local v50 = v48 * v48 + v49 * v49;

                    if v50 < v37 and (p36 == nil or p36(v47.value)) then
                        v43 = v47;
                        v37 = v50;
                    end;
                end;
            end;
        end;

        v40 = v44;
    end;
end;

function u1.makeKey(p51, p52, p53) -- Line: 155
    return p52 * 73856093 + p53 * 19349663;
end;

return {
    SpatialHash2D = u1
};