-- Decompiled with Potassium's decompiler.

local finally = require(script.Parent.finally);
local u1 = {};
local v2 = {};
local u3 = { "Tag", "Count", "Total", "Avg", "Max", "TotalBytes", "AvgBytes", "MaxBytes", "ByteRate" };
local u4 = { 80, 10, 10, 10, 10, 10, 10, 10, 10 };
local u5 = nil;
local u9 = {
    ["nil"] = 0,
    boolean = 1,
    number = 8,

    string = function(p6) -- Line: 31
        return #p6 * 2 + 4;
    end,

    Instance = 8,
    ["function"] = 8,
    thread = 8,
    userdata = 8,
    Vector2 = 8,
    Vector3 = 12,
    Color3 = 3,
    CFrame = 48,
    UDim = 8,
    UDim2 = 16,
    Enum = 4,
    EnumItem = 8,
    Ray = 24,
    Rect = 16,
    Region3 = 24,
    TweenInfo = 24,

    table = function(p7) -- Line: 50
        -- upvalues: u5 (ref)
        local v8 = 8;

        if #p7 > 0 then
            for _, v in ipairs(p7) do
                v8 = v8 + u5(v);
            end;

            return v8;
        end;

        for i, v in pairs(p7) do
            v8 = v8 + u5(i) + u5(v);
        end;

        return v8;
    end
};

u5 = function(p10) -- Line: 65
    -- upvalues: u9 (copy)
    local v11 = u9[typeof(p10)];

    if not v11 then
        return 51;
    end;

    if type(v11) == "number" then
        return 1 + v11;
    end;

    local success, result = pcall(v11, p10);

    return not success and 501 or 1 + result;
end;

v2.ComputeSize = u5;

function v2.Add(u12, u13) -- Line: 83
    -- upvalues: u1 (copy), u5 (ref), finally (copy)
    local v14 = type(u12) == "string";
    assert(v14);
    local v15 = type(u13) == "function";
    assert(v15);
    local u16 = u1[u12];

    if not u16 then
        u16 = {
            Count = 0,
            Total = 0,
            Avg = 0,
            Max = 0,
            TotalBytes = 0,
            AvgBytes = 0,
            MaxBytes = 0,
            Tag = u12
        };
        u1[u12] = u16;
    end;

    return function(...) -- Line: 100
        -- upvalues: u5 (ref), finally (ref), u13 (copy), u12 (copy), u16 (ref)
        local u17 = u5(table.pack(...));
        local u18 = os.clock();

        return finally(u13, function() -- Line: 103
            -- upvalues: u17 (copy), u12 (ref), u18 (copy), u16 (ref)
            if u17 > 100000 then
                warn("[PacketProfiler] Packet of " .. u17 .. " sent for \'" .. u12 .. "\'!");
            end;

            local v19 = os.clock();
            local v20 = v19 - u18;

            if not u16.First then
                u16.First = v19;
            end;

            u16.Count = u16.Count + 1;
            u16.Total = u16.Total + v20;
            u16.Avg = u16.Total / u16.Count;
            u16.Max = math.max(u16.Max, v20);
            u16.TotalBytes = u16.TotalBytes + u17;
            u16.AvgBytes = u16.TotalBytes / u16.Count;
            u16.MaxBytes = math.max(u16.MaxBytes, u17);
        end, ...);
    end;
end;

function v2.AddManually(p21, ...) -- Line: 123
    -- upvalues: u1 (copy), u5 (ref)
    local v22 = type(p21) == "string";
    assert(v22);
    local v23 = u1[p21];

    if not v23 then
        v23 = {
            Count = 0,
            Total = 0,
            Avg = 0,
            Max = 0,
            TotalBytes = 0,
            AvgBytes = 0,
            MaxBytes = 0,
            Tag = p21
        };
        u1[p21] = v23;
    end;

    local v24 = u5(table.pack(...));
    local v25 = os.clock();

    if not v23.First then
        v23.First = v25;
    end;

    v23.Count = v23.Count + 1;
    v23.Total = v23.Total + 0;
    v23.Avg = v23.Total / v23.Count;
    v23.Max = math.max(v23.Max, 0);
    v23.TotalBytes = v23.TotalBytes + v24;
    v23.AvgBytes = v23.TotalBytes / v23.Count;
    v23.MaxBytes = math.max(v23.MaxBytes, v24);
end;

function v2.Reset() -- Line: 153
    -- upvalues: u1 (copy)
    for _, v in pairs(u1) do
        v.First = nil;
        v.Count = 0;
        v.Total = 0;
        v.Avg = 0;
        v.Max = 0;
        v.TotalBytes = 0;
        v.AvgBytes = 0;
        v.MaxBytes = 0;
    end;
end;

function v2.Print() -- Line: 166
    -- upvalues: u1 (copy), u3 (copy), u4 (copy)
    if next(u1) then
        local v26 = {};

        for _, v in pairs(u1) do
            table.insert(v26, v);
        end;

        table.sort(v26, function(p27, p28) -- Line: 172
            return p27.TotalBytes > p28.TotalBytes;
        end);
        local v29 = os.clock();
        local v30 = {};

        for _, v in ipairs(v26) do
            if v.Count ~= 0 and v.First then
                local v31 = v29 - v.First;
                local v32 = {
                    v.Tag,
                    `{string.format("%d", v.Count)}`,
                    `{string.format("%0.2f", v.Total * 1000)}ms`,
                    `{string.format("%0.2f", v.Avg * 1000)}ms`,
                    `{string.format("%0.2f", v.Max * 1000)}ms`,
                    `{string.format("%0.2f", v.TotalBytes / 1024)}kb`,
                    `{string.format("%0.2f", v.AvgBytes / 1024)}kb`,
                    `{string.format("%0.2f", v.MaxBytes / 1024)}kb`,
                    `{string.format("%0.2f", v.TotalBytes / v31 / 1024)}kb/s`
                };
                table.insert(v30, v32);
            end;
        end;

        local v33 = "\n------------ BENCHMARKS ------------\n";

        for i, v in ipairs(u3) do
            v33 = v33 .. pad(v, u4[i]);
        end;

        local v34 = v33 .. "\n";

        for _, v in ipairs(v30) do
            for i, v3 in ipairs(v) do
                v34 = v34 .. pad(tostring(v3), u4[i]);
            end;

            v34 = v34 .. "\n";
        end;

        for i, v in ipairs(u3) do
            v34 = v34 .. pad(v, u4[i]);
        end;

        print(v34 .. "\n------------ BENCHMARKS ------------\n");
    end;
end;

function pad(p35, p36)
    local v37 = p35:len();

    if v37 < p36 then
        p35 = p35 .. string.rep(" ", p36 - v37);
    end;

    return p35;
end;

return v2;