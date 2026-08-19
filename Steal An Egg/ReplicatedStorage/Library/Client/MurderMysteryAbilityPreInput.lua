-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = {};

function v1.Register(u3, u4) -- Line: 16
    -- upvalues: u2 (copy)
    local v5;

    if type(u3) == "string" then
        v5 = u3 ~= "";
    else
        v5 = false;
    end;

    assert(v5, "abilityId must be a non-empty string");
    local v6 = type(u4) == "function";
    assert(v6, "handler must be a function");
    local v7 = u2[u3];

    if not v7 then
        v7 = {};
        u2[u3] = v7;
    end;

    table.insert(v7, u4);
    local u8 = false;

    return function() -- Line: 29
        -- upvalues: u8 (ref), u2 (ref), u3 (copy), u4 (copy)
        if u8 then
            return;
        end;

        u8 = true;
        local v9 = u2[u3];

        if not v9 then
            return;
        end;

        for i = #v9, 1, -1 do
            if v9[i] == u4 then
                table.remove(v9, i);
                break;
            end;
        end;

        if #v9 == 0 then
            u2[u3] = nil;
        end;
    end;
end;

function v1.Run(p10, p11) -- Line: 53
    -- upvalues: u2 (copy)
    local v12;

    if type(p10) == "string" then
        v12 = p10 ~= "";
    else
        v12 = false;
    end;

    assert(v12, "abilityId must be a non-empty string");
    local v13 = u2[p10];

    if not v13 or #v13 == 0 then
        return nil;
    end;

    local v14 = p11 or {};
    local v15 = nil;

    for _, v in ipairs(v13) do
        local v16 = v(v14);

        if v16 then
            v15 = v16;
        end;
    end;

    return v15;
end;

return v1;