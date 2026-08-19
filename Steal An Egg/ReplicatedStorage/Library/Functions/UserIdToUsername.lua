-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local u1 = {};

return function(u2) -- Line: 4
    -- upvalues: u1 (copy), Players (copy)
    local v3 = u1[u2];

    if v3 then
        return v3;
    end;

    local v4 = Players:GetPlayerByUserId(u2);

    if v4 then
        local Name = v4.Name;
        u1[u2] = Name;

        return Name;
    end;

    local success, result = pcall(function() -- Line: 17
        -- upvalues: Players (ref), u2 (copy)
        return Players:GetNameFromUserIdAsync(u2);
    end);

    if not success then
        return "??";
    end;

    if not result then
        return "???";
    end;

    u1[u2] = result;

    return result;
end;