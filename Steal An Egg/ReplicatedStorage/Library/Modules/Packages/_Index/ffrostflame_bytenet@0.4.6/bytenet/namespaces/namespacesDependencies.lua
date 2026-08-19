-- Decompiled with Potassium's decompiler.

local u1 = nil;
local u2 = nil;

return {
    start = function(p3) -- Line: 10, Name: start
        -- upvalues: u1 (ref), u2 (ref)
        u1 = {};
        u2 = p3;
    end,

    add = function(p4) -- Line: 15, Name: add
        -- upvalues: u1 (ref)
        if not u1 then
            return;
        end;

        table.insert(u1, p4);
    end,

    currentLength = function() -- Line: 23, Name: currentLength
        -- upvalues: u1 (ref)
        return u1 and #u1 or 0;
    end,

    currentName = function() -- Line: 27, Name: currentName
        -- upvalues: u2 (ref)
        return u2;
    end,

    empty = function() -- Line: 31, Name: empty
        -- upvalues: u1 (ref)
        if u1 == nil then
            return {};
        end;

        local v5 = u1;
        u1 = nil;

        return v5;
    end
};