-- Decompiled with Potassium's decompiler.

local u1 = {
    ["\""] = "\\\"",
    ["\\"] = "\\\\",
    ["\8"] = "\\b",
    ["\f"] = "\\f",
    ["\n"] = "\\n",
    ["\r"] = "\\r",
    ["\t"] = "\\t"
};
setmetatable(u1, {
    __index = function(p2, p3) -- Line: 12
        return string.format("\\u00%02X", p3:byte());
    end
});

function newencoder()
    -- upvalues: u1 (copy)
    local u4 = 1;
    local u5 = {};
    local u6 = nil;
    local u15 = {
        boolean = function(p7) -- Line: 25
            -- upvalues: u5 (ref), u4 (ref)
            u5[u4] = tostring(p7);
            u4 = u4 + 1;
        end,

        number = function(p8) -- Line: 30
            -- upvalues: u5 (ref), u4 (ref)
            u5[u4] = string.format("%.17g", p8);
            u4 = u4 + 1;
        end,

        string = function(p9) -- Line: 35
            -- upvalues: u5 (ref), u4 (ref), u1 (ref)
            u5[u4] = "\"";

            if p9:find("[\0-\31\"\\]") then
                p9 = p9:gsub("[\0-\31\"\\]", u1);
            end;

            u5[u4 + 1] = p9;
            u5[u4 + 2] = "\"";
            u4 = u4 + 3;
        end,

        table = function(p10) -- Line: 47
            -- upvalues: u5 (ref), u4 (ref), u6 (ref), u1 (ref)
            local v11 = #p10;

            if v11 > 0 then
                u5[u4] = "[";
                u4 = u4 + 1;

                for i = 1, v11 do
                    u6(p10[i]);
                    u5[u4] = ",";
                    u4 = u4 + 1;
                end;

                u4 = u4 - 1;
                u5[u4] = "]";
                u4 = u4 + 1;

                return;
            end;

            u5[u4] = "{";
            u4 = u4 + 1;
            local v12 = u4;
            local v13 = {};

            for i, _ in pairs(p10) do
                table.insert(v13, i);
            end;

            table.sort(v13);

            for _, v in ipairs(v13) do
                local v14 = tostring(v);
                u5[u4] = "\"";

                if v14:find("[\0-\31\"\\]") then
                    v14 = v14:gsub("[\0-\31\"\\]", u1);
                end;

                u5[u4 + 1] = v14;
                u5[u4 + 2] = "\"";
                u4 = u4 + 3;
                u5[u4] = ":";
                u4 = u4 + 1;
                u6(p10[v]);
                u5[u4] = ",";
                u4 = u4 + 1;
            end;

            if v12 < u4 then
                u4 = u4 - 1;
            end;

            u5[u4] = "}";
            u4 = u4 + 1;
        end
    };

    u6 = function(p16) -- Line: 107
        -- upvalues: u15 (copy)
        (u15[type(p16)] or u15.string)(p16);
    end;

    return function(p17) -- Line: 118
        -- upvalues: u4 (ref), u5 (ref), u6 (ref)
        u4 = 1;
        u5 = {};
        u6(p17);

        return table.concat(u5);
    end;
end;

return newencoder;