-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Promise = require(ReplicatedStorage.Library.Modules.Packages.Promise);
local Asserts = require(ReplicatedStorage.Library.Asserts);

return function(u1, p2, u3, u4) -- Line: 14
    -- upvalues: Asserts (copy), Promise (copy)
    Asserts.func(u1);
    Asserts.optional.number(p2);
    Asserts.optional.number(u3);
    Asserts.optional.number(u4);
    assert(u3 == nil == (u4 == nil), "Retry delay minimum and maximum must be provided together");
    local u5 = p2 or 5;
    local u6 = Random.new();

    return Promise.new(function(p7, p8) -- Line: 32
        -- upvalues: u5 (copy), u3 (copy), u4 (copy), u6 (copy), u1 (copy)
        local v9 = nil;

        for i = 1, u5 do
            if i > 1 and (u3 ~= nil and u4 ~= nil) then
                local v10 = 2 ^ (i - 2);
                local v11 = u6:NextNumber(u3 * v10, u4 * v10);
                task.wait(v11);
            end;

            local v12 = table.pack(pcall(u1));

            if v12[1] == true then
                return p7(table.unpack(v12, 2));
            end;

            if i > 1 and u3 == nil then
                task.wait(2 ^ (i - 1));
            end;

            v9 = v12[2];
        end;

        return p8((`Too many retries. Last error: {v9}`));
    end);
end;