-- Decompiled with Potassium's decompiler.

local Finally = require(game.ReplicatedStorage.UserGenerated.Lang.Finally);
local v1 = {};
local u11 = table.freeze({
    __index = table.freeze({
        Call = function(u2, p3, ...) -- Line: 40, Name: Call
            -- upvalues: Finally (copy)
            local v4 = type(p3) == "function";
            assert(v4);

            while u2.Count > 0 do
                task.wait();
            end;

            u2.Count = u2.Count + 1;

            return Finally(p3, function() -- Line: 47
                -- upvalues: u2 (copy)
                local v5 = u2;
                v5.Count = v5.Count - 1;
            end, ...);
        end,

        Try = function(u6, p7, ...) -- Line: 52, Name: Try
            -- upvalues: Finally (copy)
            local v8 = type(p7) == "function";
            assert(v8);

            if u6.Count > 0 then
                return false;
            end;

            u6.Count = u6.Count + 1;

            return true, Finally(p7, function() -- Line: 59
                -- upvalues: u6 (copy)
                local v9 = u6;
                v9.Count = v9.Count - 1;
            end, ...);
        end,

        IsLocked = function(p10) -- Line: 64, Name: IsLocked
            return p10.Count > 0;
        end
    })
});

function v1.new() -- Line: 73
    -- upvalues: u11 (copy)
    return setmetatable({
        Count = 0
    }, u11);
end;

return table.freeze(v1);