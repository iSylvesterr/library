-- Decompiled with Potassium's decompiler.

local Util = require(script.Parent.Util);
local u1 = {};
setmetatable(u1, {
    __mode = "k"
});
local u12 = {
    __index = function(p2, p3) -- Line: 21, Name: __index
        -- upvalues: u1 (copy), Util (copy)
        local v4 = u1[p2];
        local v5 = v4.Changes[p3];

        if v5 == nil then
            return v4.Tbl[p3];
        end;

        if v5 == Util.None then
            return nil;
        end;

        return v5;
    end,

    __newindex = function(p6, p7, p8) -- Line: 34, Name: __newindex
        -- upvalues: u1 (copy), Util (copy)
        local v9 = u1[p6];

        if v9.Tbl[p7] == p8 then
            return;
        end;

        if p8 == nil then
            v9.Changes[p7] = Util.None;

            return;
        end;

        v9.Changes[p7] = p8;
    end,

    __call = function(p10) -- Line: 46, Name: __call
        -- upvalues: u1 (copy), Util (copy)
        local v11 = u1[p10];

        if next(v11.Changes) == nil then
            return v11.Tbl;
        end;

        return Util.Extend(v11.Tbl, v11.Changes);
    end
};

return function(p13) -- Line: 54, Name: TableWatcher
    -- upvalues: u12 (copy), u1 (copy)
    local v14 = setmetatable({}, u12);
    u1[v14] = {
        Changes = {},
        Tbl = p13
    };

    return v14;
end;