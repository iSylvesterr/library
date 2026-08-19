-- Decompiled with Potassium's decompiler.

local u9 = {
    mark = function(p1) -- Line: 5, Name: mark
        debug.profilebegin(p1);
        debug.profileend();
    end,

    beginScope = function(p2) -- Line: 10, Name: beginScope
        debug.profilebegin(p2);
    end,

    endScope = function() -- Line: 14, Name: endScope
        debug.profileend();
    end,

    scope = function(p3, p4, ...) -- Line: 18, Name: scope
        debug.profilebegin(p3);
        local v5 = table.pack(pcall(p4, ...));
        debug.profileend();

        if not v5[1] then
            error(v5[2], 2);
        end;

        return table.unpack(v5, 2, v5.n);
    end,

    getInstancePath = function(p6, p7) -- Line: 30, Name: getInstancePath
        local v8 = {};

        while p6 and p6 ~= p7 do
            table.insert(v8, 1, p6.Name);
            p6 = p6.Parent;
        end;

        return table.concat(v8, ".");
    end
};

function u9.defer(u10, u11, ...) -- Line: 42
    -- upvalues: u9 (copy)
    local u12 = table.pack(...);
    task.defer(function() -- Line: 44
        -- upvalues: u10 (copy), u9 (ref), u11 (copy), u12 (copy)
        debug.setmemorycategory(u10);
        u9.mark(u10);
        u11(table.unpack(u12, 1, u12.n));
    end);
end;

function u9.spawn(u13, u14, ...) -- Line: 51
    -- upvalues: u9 (copy)
    local u15 = table.pack(...);
    task.spawn(function() -- Line: 53
        -- upvalues: u13 (copy), u9 (ref), u14 (copy), u15 (copy)
        debug.setmemorycategory(u13);
        u9.mark(u13);
        u14(table.unpack(u15, 1, u15.n));
    end);
end;

return u9;