-- Decompiled with Potassium's decompiler.

local v1 = {};
local Event = require(script.Parent.Event);
local u7 = {
    IsLocked = function(p2) -- Line: 7, Name: IsLocked
        return p2._obtainedCount > 0;
    end,

    IsUnlocked = function(p3) -- Line: 11, Name: IsUnlocked
        return p3._obtainedCount <= 0;
    end,

    ObtainLock = function(u4) -- Line: 15, Name: ObtainLock
        local u5 = false;
        u4._obtainedCount = u4._obtainedCount + 1;
        u4.Modified:FireAsync(u4);

        return function() -- Line: 20
            -- upvalues: u5 (ref), u4 (copy)
            if not u5 then
                u5 = true;
                u4:ReleaseLock();
            end;
        end;
    end,

    ReleaseLock = function(p6) -- Line: 28, Name: ReleaseLock
        assert(p6._obtainedCount > 0, "Cannot release a lock that is not obtained");
        p6._obtainedCount = p6._obtainedCount - 1;
        p6.Modified:FireAsync(p6);
    end
};

function v1.new() -- Line: 34
    -- upvalues: Event (copy), u7 (copy)
    local v8 = {
        _obtainedCount = 0,
        Modified = Event.new()
    };

    return setmetatable(v8, {
        __index = u7
    });
end;

return v1;