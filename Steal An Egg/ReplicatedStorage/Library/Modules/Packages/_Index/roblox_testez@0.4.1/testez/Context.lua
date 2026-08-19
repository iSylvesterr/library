-- Decompiled with Potassium's decompiler.

return {
    new = function(p1) -- Line: 7, Name: new
        local v2 = {};
        local u3 = {};
        v2.__index = u3;

        if p1 then
            for i, v in pairs(getmetatable(p1).__index) do
                u3[i] = v;
            end;
        end;

        function v2.__newindex(p4, p5, p6) -- Line: 18
            -- upvalues: u3 (copy)
            local v7 = u3[p5] == nil;
            local format = string.format;
            local v8 = tostring(p5);
            assert(v7, format("Cannot reassign %s in context", v8));
            u3[p5] = p6;
        end;

        return setmetatable({}, v2);
    end
};