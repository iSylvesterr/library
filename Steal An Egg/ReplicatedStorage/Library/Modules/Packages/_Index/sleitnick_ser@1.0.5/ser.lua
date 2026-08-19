-- Decompiled with Potassium's decompiler.

local u2 = {
    Classes = {
        Option = {
            Serialize = function(p1) -- Line: 73, Name: Serialize
                return p1:Serialize();
            end,

            Deserialize = require(script.Parent.Option).Deserialize
        }
    }
};

function u2.SerializeArgs(...) -- Line: 85
    -- upvalues: u2 (copy)
    local v3 = table.pack(...);

    for i, v in ipairs(v3) do
        if type(v) == "table" then
            local v4 = u2.Classes[v.ClassName];

            if v4 then
                v3[i] = v4.Serialize(v);
            end;
        end;
    end;

    return v3;
end;

function u2.SerializeArgsAndUnpack(...) -- Line: 103
    -- upvalues: u2 (copy)
    local v5 = u2.SerializeArgs(...);

    return table.unpack(v5, 1, v5.n);
end;

function u2.DeserializeArgs(...) -- Line: 113
    -- upvalues: u2 (copy)
    local v6 = table.pack(...);

    for i, v in ipairs(v6) do
        if type(v) == "table" then
            local v7 = u2.Classes[v.ClassName];

            if v7 then
                v6[i] = v7.Deserialize(v);
            end;
        end;
    end;

    return v6;
end;

function u2.DeserializeArgsAndUnpack(...) -- Line: 131
    -- upvalues: u2 (copy)
    local v8 = u2.DeserializeArgs(...);

    return table.unpack(v8, 1, v8.n);
end;

function u2.Serialize(p9) -- Line: 141
    -- upvalues: u2 (copy)
    if type(p9) == "table" then
        local v10 = u2.Classes[p9.ClassName];

        if v10 then
            p9 = v10.Serialize(p9);
        end;
    end;

    return p9;
end;

function u2.Deserialize(p11) -- Line: 156
    -- upvalues: u2 (copy)
    if type(p11) == "table" then
        local v12 = u2.Classes[p11.ClassName];

        if v12 then
            p11 = v12.Deserialize(p11);
        end;
    end;

    return p11;
end;

function u2.UnpackArgs(p13) -- Line: 171
    return table.unpack(p13, 1, p13.n);
end;

return u2;