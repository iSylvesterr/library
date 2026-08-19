-- Decompiled with Potassium's decompiler.

local Asserts = require(game:GetService("ReplicatedStorage").Library.Asserts);

local function WrapSelfToConnect(u1, u2, ...) -- Line: 35
    -- upvalues: Asserts (copy)
    Asserts.table(u1);
    Asserts.func(u2);
    local u3 = { ... };

    return function(...) -- Line: 41
        -- upvalues: u3 (copy), u2 (copy), u1 (copy)
        local v4 = { ... };
        local v5 = {};

        if #u3 ~= 0 then
            table.move(u3, 1, #u3, 1, v5);
            table.move(v4, 1, #v4, #v5 + 1, v5);
        end;

        if #v5 ~= 0 and v5 then
            v4 = v5;
        end;

        return u2(u1, unpack(v4));
    end;
end;

return {
    WrapSelfToConnect = WrapSelfToConnect,

    CreateWrapper = function(u6) -- Line: 54, Name: CreateWrapper
        -- upvalues: WrapSelfToConnect (copy)
        return function(p7, ...) -- Line: 55
            -- upvalues: WrapSelfToConnect (ref), u6 (copy)
            return WrapSelfToConnect(u6, p7, ...);
        end;
    end
};