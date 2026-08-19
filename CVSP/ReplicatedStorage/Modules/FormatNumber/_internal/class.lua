-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = {};
local u3 = setmetatable({}, {
    __mode = "k"
});

local function proxy_tostring(p4) -- Line: 5
    -- upvalues: u3 (copy)
    return u3[p4].type_name .. ": " .. u3[p4].as_string;
end;

local u5 = table.freeze({
    DEFAULT = 0,
    NUMBER_FORMATTER = 1,
    SYMBOLS = 2
});
u1.ImmutabilityType = u5;

function u1.create_init_function(u6, p7, u8, p9, u10) -- Line: 16
    -- upvalues: u2 (copy), u5 (copy), proxy_tostring (copy), u3 (copy)
    if p9 then
        local v11 = table.clone(p9);
        u8 = setmetatable(v11, {
            __index = u8
        });
    end;

    u2[u6] = p7 or "FormatNumberObject";

    return function(p12, p13) -- Line: 31
        -- upvalues: u10 (copy), u5 (ref), u6 (copy), u8 (ref), proxy_tostring (ref), u3 (ref)
        local v14 = newproxy(true);
        local v15 = getmetatable(v14);

        if u10 ~= u5.SYMBOLS and type(p12) == "table" then
            table.freeze(p12);
        end;

        v15.data = p12;
        v15.resolved_data = nil;
        v15.type_name = u6;

        if not p13 then
            local v16 = tostring(v14);
            p13 = string.sub(v16, 11);
        end;

        v15.as_string = p13;
        v15.__index = u8;
        v15.__tostring = proxy_tostring;
        v15.__metatable = "The metatable is locked";

        if u10 ~= u5.NUMBER_FORMATTER then
            table.freeze(v15);
        end;

        u3[v14] = v15;

        return v14;
    end;
end;

function u1.is_a(p17, p18) -- Line: 58
    -- upvalues: u3 (copy), u2 (copy)
    local v19 = u3[p17];

    if v19 then
        v19 = v19.type_name;
    end;

    local v20 = false;

    if v19 == p18 then
        return true;
    end;

    if v19 then
        repeat
            v19 = u2[v19];
            v20 = v19 == p18;
        until not v19 or v20;
    end;

    return v20;
end;

function u1.get_data(p21) -- Line: 76
    -- upvalues: u3 (copy)
    return u3[p21].data;
end;

function u1.get_resolved_data(p22, p23) -- Line: 80
    -- upvalues: u3 (copy)
    local v24 = u3[p22];
    local resolved_data = v24.resolved_data;

    if not resolved_data then
        resolved_data = p23(v24.data);
        v24.resolved_data = resolved_data;

        if resolved_data then
            table.freeze(v24);
        end;
    end;

    return resolved_data;
end;

function u1.try_coerce(p25, p26, p27, p28) -- Line: 95
    -- upvalues: u1 (copy), u3 (copy)
    local v29 = false;
    local v30 = nil;

    if p26 == nil and p28 ~= nil then
        v30 = p28;
        v29 = true;
    elseif p27 == "string" then
        if type(p26) == "string" then
            v30 = p26;
            v29 = true;
        elseif type(p26) == "number" then
            v30 = tostring(p26);
            v29 = true;
        else
            v29 = false;
        end;
    elseif p27 == "number" then
        v30 = tonumber(p26);

        if v30 then
            v29 = true;
        else
            p27 = p27 .. " object";
            v29 = false;
        end;
    elseif string.sub(p27, 1, 1) == "{" then
        local v31 = string.sub(p27, 2, -2);

        if type(p26) == "table" then
            v30 = table.move(p26, 1, rawlen(p26), 1, table.create((rawlen(p26))));

            for i, v in v30 do
                if type(v) ~= v31 then
                    error(string.format("Values inside the table argument must be a %s, index %d got %s", v31, i, (type(v))), 3);
                end;
            end;

            v29 = true;
        else
            p27 = "table";
        end;
    elseif u1.is_a(p26, p27) then
        v30 = u3[p26].data;
        v29 = true;
    end;

    if not v29 then
        error(string.format("Argument #%d provided must be a %s", p25, p27), 3);
    end;

    return v30;
end;

function u1.try_coerce_range(p32, p33, p34, p35, p36) -- Line: 147
    -- upvalues: u1 (copy)
    local v37 = nil;

    if p33 ~= nil then
        local v38 = tonumber(p33);

        if v38 then
            p36 = u1.double_to_int32(v38);

            if p34 <= p36 then
                if p36 > p35 then
                    p36 = v37;
                end;
            else
                p36 = v37;
            end;
        else
            p36 = v37;
        end;
    end;

    return p36 or error(string.format("Argument #%d provided must be an integer that is in the range of %d to (and including) %d", p32, p34, p35), 3);
end;

function u1.try_coerce_enum(p39, p40, p41, p42) -- Line: 169
    -- upvalues: u1 (copy)
    local v43 = nil;

    if p40 == nil then
        v43 = p42;
    elseif tonumber(p40) then
        local v44 = u1.double_to_int32(p40);

        for _, v in p41 do
            if v44 == v then
                v43 = v;
                break;
            end;
        end;
    end;

    return v43 or error(string.format("Argument #%d provided is out of range", p39), 3);
end;

function u1.double_to_int32(p45) -- Line: 190
    if p45 <= -2147483649 or p45 >= 2147483648 then
        return UDim.new(nil, p45).Offset;
    end;

    if p45 <= -1 then
        return math.ceil(p45);
    end;

    return p45 < 1 and 0 or math.floor(p45);
end;

return table.freeze(u1);