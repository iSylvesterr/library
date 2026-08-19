-- Decompiled with Potassium's decompiler.

local Asserts = require(game:GetService("ReplicatedStorage").Library.Asserts);
local u1 = {
    rbxassetid = "rbxassetid://"
};
local u5 = {
    Append = function(p2, p3) -- Line: 11, Name: Append
        -- upvalues: Asserts (copy), u1 (copy)
        Asserts.string(p2);

        if not tonumber(p3) then
            return p3;
        end;

        local v4 = assert(u1[p2], "Must be a valid extension type.");

        return `{p3:find((`^{v4}`)) and "" or v4}{p3}`;
    end
};

function u5.Wrap(u6) -- Line: 21
    -- upvalues: u5 (copy)
    return function(...) -- Line: 22
        -- upvalues: u5 (ref), u6 (copy)
        return u5.Append(u6, ...);
    end;
end;

return u5;