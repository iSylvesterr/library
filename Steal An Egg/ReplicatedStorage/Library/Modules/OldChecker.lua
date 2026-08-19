-- Decompiled with Potassium's decompiler.

local u1 = { "__index", "__newindex" };
local u4 = {
    __proxy = {
        new = function(p2) -- Line: 7, Name: new
            -- upvalues: u1 (copy)
            if typeof(p2) == "table" then
                local v3 = newproxy(true);

                for _, v in u1 do
                    getmetatable(v3)[v] = p2;
                end;

                return v3;
            end;
        end
    }
};
u4.__index = u4;

local function Is_Structure_Valid(p5, p6) -- Line: 24
    -- upvalues: Is_Structure_Valid (copy)
    if typeof(p5) ~= "table" or typeof(p6) ~= "table" then
        return warn("Invalid STRF structure params. Structure must be a table, got:", p5, ", object must be a table got:", p6);
    end;

    local v7 = table.find({ "string", "table" }, (typeof(p5.__generic))) and p5.__generic;

    for i, v in v7 and p6 and p6 or p5 do
        local v8 = v7 or v;
        local v9 = v7 and v and v or p6[i];
        local v10 = typeof(v8) == "string" and { v8:gsub(";", "") } or false;
        local v11;

        if v10 then
            v11 = v8:split(";")[1]:split("|");
        else
            v11 = v10;
        end;

        local v12;

        if v10 then
            if v10[2] > 0 and #v8:split(";")[2] > 0 then
                v12 = v8:split(";")[2]:split("|");
            else
                v12 = false;
            end;
        else
            v12 = v10;
        end;

        local v13;

        if v7 or not v then
            v13 = typeof(v7) == "table" and v7 and v7 or p5[i];
        else
            v13 = v;
        end;

        if typeof(v13) == "table" then
            local v14 = v7 and { typeof(v7) == "table" and v7 and v7 or p5[i], v } or { v, p6[i] };

            if not Is_Structure_Valid(unpack(v14)) then
                return;
            end;
        else
            if not table.find(v11, (typeof(v9))) then
                return;
            end;

            if #v11 >= 2 and (v10[2] > 0 and (not v9:IsA(v11[2]) or v12 and not table.find(v12, v9.ClassName))) then
                return;
            end;
        end;
    end;

    return p6;
end;

function u4.new(p15) -- Line: 63
    -- upvalues: u4 (copy)
    return setmetatable(p15, u4);
end;

function u4.Request_Proxy(p16, p17, ...) -- Line: 67
    -- upvalues: Is_Structure_Valid (copy)
    local v18 = Is_Structure_Valid(p16["Strct_" .. p17], { ... });

    if typeof(v18) ~= "table" then
        v18 = false;
    end;

    return v18;
end;

return u4;