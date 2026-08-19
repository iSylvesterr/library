-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = table.freeze({
    ["0"] = "\0",
    ["1"] = "\1",
    ["2"] = "\2",
    ["3"] = "\3",
    ["4"] = "\4",
    ["5"] = "\5",
    ["6"] = "\6",
    ["7"] = "\7",
    ["8"] = "\8",
    ["9"] = "\t"
});

function v1.from_double(p3) -- Line: 15
    -- upvalues: u2 (copy)
    local v4, v5, v6 = string.match(tostring(p3), "^(%d+)%.?(%d*)e?([+-]?%d*)$");
    local v7, v8 = string.match(v4 .. v5, "^0*(%d-)(0*)$");
    local v9 = {};
    local v10 = string.gsub(v7, ".", u2);
    v9[1] = string.byte(v10, 1, -1);

    return v9, #v9, (tonumber(v6) or 0) - #v5 + #v8;
end;

return table.freeze(v1);