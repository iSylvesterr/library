-- Decompiled with Potassium's decompiler.

local u1 = setmetatable({}, {
    __mode = "k"
});

return {
    claim = function(p2, p3, p4) -- Line: 12, Name: claim
        -- upvalues: u1 (copy)
        if not (p2 and (p3 and p4)) then
            return;
        end;

        local v5 = u1[p2];

        if not v5 then
            v5 = {};
            u1[p2] = v5;
        end;

        v5[p3] = p4;
    end,

    isOwner = function(p6, p7, p8) -- Line: 24, Name: isOwner
        -- upvalues: u1 (copy)
        if not (p6 and (p7 and p8)) then
            return false;
        end;

        local v9 = u1[p6];
        local v10;

        if v9 == nil then
            v10 = false;
        else
            v10 = v9[p7] == p8;
        end;

        return v10;
    end,

    release = function(p11, p12, p13) -- Line: 32, Name: release
        -- upvalues: u1 (copy)
        if not (p11 and (p12 and p13)) then
            return;
        end;

        local v14 = u1[p11];

        if v14 and v14[p12] == p13 then
            v14[p12] = nil;

            if next(v14) == nil then
                u1[p11] = nil;
            end;
        end;
    end
};