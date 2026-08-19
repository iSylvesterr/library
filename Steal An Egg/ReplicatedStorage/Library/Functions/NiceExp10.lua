-- Decompiled with Potassium's decompiler.

function NiceExp10(p1, p2)
    if p2 == 0 then
        return p1;
    end;

    local v3 = `{string.format("%f", p1)}e{p2}`;
    local v4 = tonumber(v3);

    if not v4 then
        local v5 = tostring(p1);
        local v6 = tostring(p2);
        local v7 = string.format("%f", p1);
        error("x:" .. v5 .. " y:" .. v6 .. " fmt(x):" .. v7);
    end;

    return v4;
end;

return NiceExp10;