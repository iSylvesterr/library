-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

local function createNode(p2, p3) -- Line: 52
    return {
        cell = p2,
        stack = p3 or {}
    };
end;

local function sameLocation(p4, p5) -- Line: 59
    local v6;

    if p4.row == p5.row then
        v6 = p4.col == p5.col;
    else
        v6 = false;
    end;

    return v6;
end;

local function isCellInList(p7, p8) -- Line: 63
    for _, v in ipairs(p7) do
        local v9;

        if v.row == p8.row then
            v9 = v.col == p8.col;
        else
            v9 = false;
        end;

        if v9 then
            return true;
        end;
    end;

    return false;
end;

local function cloneAndAdd(p10, p11) -- Line: 73
    local v12 = table.clone(p10);
    table.insert(v12, p11);

    return v12;
end;

function u1.new(p13, p14, p15, p16) -- Line: 79
    -- upvalues: u1 (copy)
    local v17 = setmetatable({}, u1);
    v17.candidates = {};
    v17.from = p14;
    v17.grid = p13;
    v17.gridSize = #p13;
    v17.to = p15;
    v17.neighbourCache = {};
    v17.seen = {};
    v17.stack = {
        {
            cell = p14,
            stack = {}
        }
    };
    v17.maxLength = p16 or 1;

    return v17;
end;

function u1.generate(p18) -- Line: 95
    while true do
        if #p18.stack <= 0 then
            return;
        end;

        local v19 = table.remove(p18.stack, 1);
        assert(v19, "Expected current pathfinding node");
        local cell = v19.cell;
        local v20 = false;

        for _, v in ipairs(p18.seen) do
            local v21;

            if v.row == cell.row then
                v21 = v.col == cell.col;
            else
                v21 = false;
            end;

            if v21 then
                v20 = true;
                break;
            end;
        end;

        if not v20 then
            for _, v in ipairs(p18:neighboursOf(cell)) do
                if p18.grid[v.row][v.col].status == "empty" then
                    local v22 = false;

                    for _, v2 in ipairs(v19.stack) do
                        local v23;

                        if v2.row == v.row then
                            v23 = v2.col == v.col;
                        else
                            v23 = false;
                        end;

                        if v23 then
                            v22 = true;
                            break;
                        end;
                    end;

                    if not v22 and #v19.stack < p18.maxLength then
                        local v24 = table.clone(v19.stack);
                        table.insert(v24, cell);
                        local v25 = {
                            cell = v,
                            stack = v24 or {}
                        };
                        local to = p18.to;
                        local v26;

                        if v.row == to.row then
                            v26 = v.col == to.col;
                        else
                            v26 = false;
                        end;

                        if v26 then
                            local v27 = table.clone(v25.stack);
                            table.insert(v27, v);
                            table.remove(v27, 1);
                            table.insert(p18.candidates, v27);
                        else
                            table.insert(p18.stack, v25);
                        end;
                    end;
                end;
            end;

            table.insert(p18.seen, cell);
        end;
    end;
end;

function u1.isPathAvailable(p28) -- Line: 128
    if #p28.candidates == 0 then
        p28:generate();
    end;

    return #p28.candidates > 0;
end;

function u1.neighboursOf(p29, p30) -- Line: 136
    local v31 = ("%d-%d"):format(p30.row, p30.col);

    if not p29.neighbourCache[v31] then
        local v32 = {};
        p29.neighbourCache[v31] = v32;

        for i = -1, 1, 2 do
            for i2 = 1, 2 do
                local v33 = {
                    row = p30.row,
                    col = p30.col
                };

                if i2 == 1 then
                    v33.row = v33.row + i;
                else
                    v33.col = v33.col + i;
                end;

                if v33.row >= 1 and (v33.row <= p29.gridSize and (v33.col >= 1 and v33.col <= p29.gridSize)) then
                    table.insert(v32, v33);
                end;
            end;
        end;
    end;

    return p29.neighbourCache[v31];
end;

function u1.shortestPath(p34) -- Line: 171
    if #p34.candidates == 0 then
        p34:generate();
    end;

    table.sort(p34.candidates, function(p35, p36) -- Line: 176
        return #p35 < #p36;
    end);
    local v37 = p34.candidates[1];
    assert(v37, "Expected shortest path candidate");

    return v37;
end;

return u1;