-- Decompiled with Potassium's decompiler.

local u1 = {
    Pretty = true,
    IndentChar = "\t",
    IndentSize = 1
};
local u2 = {};
local u3 = {};

local function getIntegerDistance(p4) -- Line: 10
    local v5 = p4 - math.round(p4);

    return math.abs(v5);
end;

local function isIntegerFuzzy(p6) -- Line: 14
    local v7 = p6 - math.round(p6);

    return math.abs(v7) < 0.001;
end;

local function round(p8, p9) -- Line: 18
    return math.round(p8 * p9) / p9;
end;

local function formatNumber(p10, p11) -- Line: 22
    local v12 = 10 ^ p11;
    local v13 = math.round(p10 * v12) / v12;

    return string.format("%." .. p11 .. "f", v13):gsub("%.?0+$", "");
end;

local function createIndent(p14, p15, p16) -- Line: 28
    return string.rep(p14, p15 * p16);
end;

local function canUseBareIdentifier(p17) -- Line: 32
    return string.match(p17, "^[%a_][%w_]*$") ~= nil;
end;

local function serialize(p18, p19) -- Line: 36
    -- upvalues: u3 (copy)
    local v20 = typeof(p18);
    local v21 = u3[v20];

    if v21 then
        return v21(p18, p19);
    end;

    warn((`Missing serializer: {v20}`));

    return `[{v20}]`;
end;

local function serializeArguments(p22, p23) -- Line: 46
    -- upvalues: u3 (copy)
    local v24 = p23.Config.Pretty and ", " or ",";
    local v25 = table.create(#p22);

    for i, v in ipairs(p22) do
        local v26 = typeof(v);
        local v27 = u3[v26];
        local v28;

        if v27 then
            v28 = v27(v, p23);
        else
            warn((`Missing serializer: {v26}`));
            v28 = `[{v26}]`;
        end;

        v25[i] = v28;
    end;

    return table.concat(v25, v24);
end;

local function formatCall(p29, p30, p31) -- Line: 55
    -- upvalues: serializeArguments (copy)
    return string.format("%s(%s)", p29, serializeArguments(p30, p31));
end;

u3["nil"] = function(p32, p33) -- Line: 59
    return "nil";
end;

function u3.boolean(p34, p35) -- Line: 63
    return p34 and "true" or "false";
end;

function u3.number(p36, p37) -- Line: 67
    -- upvalues: formatNumber (copy)
    if p36 == (1 / 0) then
        return "math.huge";
    end;

    if p36 == (-1 / 0) then
        return "-math.huge";
    end;

    if p36 ~= p36 then
        return "0/0";
    end;

    if p37.Config.Pretty then
        return formatNumber(p36, 6);
    end;

    return tostring(p36);
end;

function u3.string(p38, p39) -- Line: 83
    return string.format("%q", p38);
end;

function u3.table(p40, p41) -- Line: 87
    -- upvalues: u3 (copy)
    local Order = p41.Order;
    local v42 = 0;
    local v43 = {};
    local v44 = "{";
    local v45 = true;

    for i, v in pairs(p40) do
        v42 = v42 + 1;

        if i ~= v42 then
            v45 = false;
        end;

        v43[v42] = {
            Key = i,
            Value = v
        };
    end;

    if Order then
        table.sort(v43, function(p46, p47) -- Line: 106
            -- upvalues: Order (copy)
            local v48 = Order[p46.Key];
            local v49 = Order[p47.Key];

            return (v48 and v48.Index or (1 / 0)) < (v49 and v49.Index or (1 / 0));
        end);
    end;

    p41.Level = p41.Level + 1;
    local v50 = not p41.Config.Pretty and "" or "\n" .. string.rep(p41.Config.IndentChar, p41.Config.IndentSize * p41.Level);
    local v51 = false;

    for _, v in ipairs(v43) do
        local Key = v.Key;
        local Value = v.Value;
        local v52 = nil;

        if Order then
            local v53 = Order[Key];

            if v53 then
                v52 = v53.Child;
            end;
        end;

        p41.Order = v52;

        if v51 then
            v44 = v44 .. ",";
        else
            v51 = true;
        end;

        local v54 = v44 .. v50;

        if not v45 then
            local v55 = typeof(Key);
            local v56 = u3[v55];
            local v57;

            if v56 then
                v57 = v56(Key, p41);
            else
                warn((`Missing serializer: {v55}`));
                v57 = `[{v55}]`;
            end;

            local v58;

            if type(Key) == "string" and v57 == string.format("%q", Key) and string.match(Key, "^[%a_][%w_]*$") ~= nil then
                v58 = v54 .. Key;
            else
                v58 = v54 .. `[{v57}]`;
            end;

            v54 = v58 .. (p41.Config.Pretty and " = " or "=");
        end;

        local v59 = typeof(Value);
        local v60 = u3[v59];
        local v61;

        if v60 then
            v61 = v60(Value, p41);
        else
            warn((`Missing serializer: {v59}`));
            v61 = `[{v59}]`;
        end;

        v44 = v54 .. v61;
    end;

    p41.Level = p41.Level - 1;
    p41.Order = Order;

    if v51 and p41.Config.Pretty then
        v44 = v44 .. ",\n" .. string.rep(p41.Config.IndentChar, p41.Config.IndentSize * p41.Level);
    end;

    return v44 .. "}";
end;

function u3.Color3(p62, p63) -- Line: 164
    -- upvalues: formatCall (copy)
    local v64 = p62.R * 255;
    local v65 = p62.G * 255;
    local v66 = p62.B * 255;
    local v67 = "fromRGB";
    local v68 = v64 - math.round(v64);
    local v69, v70, v71;

    if math.abs(v68) < 0.001 then
        local v72 = v65 - math.round(v65);

        if math.abs(v72) < 0.001 then
            local v73 = v66 - math.round(v66);

            if math.abs(v73) < 0.001 then
                v69 = math.round(v64);
                v70 = math.round(v65);
                v71 = math.round(v66);
            else
                v69 = p62.R;
                v70 = p62.G;
                v71 = p62.B;
                v67 = "new";
            end;
        else
            v69 = p62.R;
            v70 = p62.G;
            v71 = p62.B;
            v67 = "new";
        end;
    else
        v69 = p62.R;
        v70 = p62.G;
        v71 = p62.B;
        v67 = "new";
    end;

    return formatCall("Color3." .. v67, { v69, v70, v71 }, p63);
end;

function u3.Vector3(p74, p75) -- Line: 187
    -- upvalues: formatCall (copy)
    return p74 == Vector3.new(0, 0, 0) and "Vector3.zero" or (p74 == Vector3.new(1, 1, 1) and "Vector3.one" or (p74 == Vector3.new(1, 0, 0) and "Vector3.xAxis" or (p74 == Vector3.new(0, 1, 0) and "Vector3.yAxis" or (p74 == Vector3.new(0, 0, 1) and "Vector3.zAxis" or formatCall("Vector3.new", { p74.X, p74.Y, p74.Z }, p75)))));
end;

function u3.Vector2(p76, p77) -- Line: 203
    -- upvalues: formatCall (copy)
    return p76 == Vector2.zero and "Vector2.zero" or (p76 == Vector2.one and "Vector2.one" or (p76 == Vector2.xAxis and "Vector2.xAxis" or (p76 == Vector2.yAxis and "Vector2.yAxis" or formatCall("Vector2.new", { p76.X, p76.Y }, p77))));
end;

function u3.CFrame(p78, p79) -- Line: 217
    -- upvalues: serializeArguments (copy), u3 (copy), serialize (copy)
    if p78 == CFrame.identity then
        return "CFrame.identity";
    end;

    local X = p78.X;
    local Y = p78.Y;
    local Z = p78.Z;
    local v80, v81, v82 = p78:ToOrientation();

    if p79.Config.Pretty then
        X = math.round(X * 1000000) / 1000000;
        Y = math.round(Y * 1000000) / 1000000;
        Z = math.round(Z * 1000000) / 1000000;
        local v83 = math.deg(v80) * 1000000;
        v80 = math.round(v83) / 1000000;
        local v84 = math.deg(v81) * 1000000;
        v81 = math.round(v84) / 1000000;
        local v85 = math.deg(v82) * 1000000;
        v82 = math.round(v85) / 1000000;
    end;

    local v86 = math.sqrt(X ^ 2 + Y ^ 2 + Z ^ 2) > 1e-6;
    local v87 = math.sqrt(v80 ^ 2 + v81 ^ 2 + v82 ^ 2) > 0.00001;

    if not (v86 or v87) then
        return "CFrame.identity";
    end;

    local v88;

    if v86 then
        v88 = string.format("%s(%s)", "CFrame.new", serializeArguments({ X, Y, Z }, p79));
    else
        v88 = nil;
    end;

    local v89;

    if v87 then
        if p79.Config.Pretty then
            local v90 = typeof(v80);
            local v91 = u3[v90];
            local v92;

            if v91 then
                v92 = v91(v80, p79);
            else
                warn((`Missing serializer: {v90}`));
                v92 = `[{v90}]`;
            end;

            local v93 = typeof(v81);
            local v94 = u3[v93];
            local v95;

            if v94 then
                v95 = v94(v81, p79);
            else
                warn((`Missing serializer: {v93}`));
                v95 = `[{v93}]`;
            end;

            v89 = ("CFrame.fromOrientation(math.rad(%s), math.rad(%s), math.rad(%s))"):format(v92, v95, serialize(v82, p79));
        else
            v89 = string.format("%s(%s)", "CFrame.fromOrientation", serializeArguments({ v80, v81, v82 }, p79));
        end;
    else
        v89 = nil;
    end;

    if v88 and v89 then
        return p79.Config.Pretty and ("%s * %s"):format(v88, v89) or ("%s*%s"):format(v88, v89);
    end;

    return v88 or v89;
end;

function u3.EnumItem(p96, p97) -- Line: 268
    return ("Enum.%s.%s"):format(p96.EnumType, p96.Name);
end;

function u2.Pretty(p98, p99) -- Line: 272
    -- upvalues: u1 (copy), serialize (copy)
    local v100 = p99 or u1;

    return serialize(p98, {
        Level = 0,
        Config = v100,
        Order = v100.Order
    });
end;

function u2.CompileOrder(p101) -- Line: 281
    -- upvalues: u2 (copy)
    local v102 = type(p101) == "table";
    assert(v102);
    local v103 = #p101 ~= 0 and true or next(p101) == nil;
    assert(v103);
    local v104 = {};

    for i, v in ipairs(p101) do
        if type(v) == "table" then
            local Key = v.Key;
            local v105 = type(Key) == "string";
            assert(v105);
            v104[Key] = {
                Index = i,
                Child = u2.CompileOrder(v.Value)
            };
        else
            v104[v] = {
                Index = i
            };
        end;
    end;

    return v104;
end;

return u2;