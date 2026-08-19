-- Decompiled with Potassium's decompiler.

local TextService = game:GetService("TextService");
local u5 = {
    MakeDictionary = function(p1) -- Line: 6, Name: MakeDictionary
        local v2 = {};

        for i = 1, #p1 do
            v2[p1[i]] = true;
        end;

        return v2;
    end,

    DictionaryKeys = function(p3) -- Line: 17, Name: DictionaryKeys
        local v4 = {};

        for i in pairs(p3) do
            table.insert(v4, i);
        end;

        return v4;
    end
};

local function transformInstanceSet(p6) -- Line: 28
    local v7 = {};

    for i = 1, #p6 do
        v7[i] = p6[i].Name;
    end;

    return v7, p6;
end;

function u5.MakeFuzzyFinder(p8) -- Line: 42
    local u9 = nil;
    local u10 = {};

    if typeof(p8) == "Enum" then
        p8 = p8:GetEnumItems();
    end;

    if typeof(p8) == "Instance" then
        u10 = p8:GetChildren();
        u9 = {};

        for i = 1, #u10 do
            u9[i] = u10[i].Name;
        end;
    elseif typeof(p8) == "table" then
        if typeof(p8[1]) == "Instance" or (typeof(p8[1]) == "EnumItem" or typeof(p8[1]) == "table" and typeof(p8[1].Name) == "string") then
            u9 = {};
            u10 = p8;

            for i = 1, #p8 do
                u9[i] = u10[i].Name;
                p8 = u10;
                u10 = p8;
            end;
        elseif type(p8[1]) == "string" then
            u9 = p8;
        elseif p8[1] == nil then
            u9 = {};
        else
            error("MakeFuzzyFinder only accepts tables of instances or strings.");
        end;
    else
        error("MakeFuzzyFinder only accepts a table, Enum, or Instance.");
    end;

    return function(p11, p12) -- Line: 70
        -- upvalues: u9 (ref), u10 (ref)
        local v13 = {};

        for i, v in pairs(u9) do
            local v14;

            if u10 then
                v14 = u10[i] or v;
            else
                v14 = v;
            end;

            if v:lower() == p11:lower() then
                if p12 then
                    return v14;
                end;

                table.insert(v13, 1, v14);
            elseif v:lower():find(p11:lower(), 1, true) then
                v13[#v13 + 1] = v14;
            end;
        end;

        if p12 then
            return v13[1];
        end;

        return v13;
    end;
end;

function u5.GetNames(p15) -- Line: 98
    local v16 = {};

    for i = 1, #p15 do
        v16[i] = p15[i].Name or tostring(p15[i]);
    end;

    return v16;
end;

function u5.SplitStringSimple(p17, p18) -- Line: 109
    local v19 = {};
    local v20 = 1;

    for i in string.gmatch(p17, "([^" .. (p18 == nil and "%s" or p18) .. "]+)") do
        v19[v20] = i;
        v20 = v20 + 1;
    end;

    return v19;
end;

local function charCode(p21) -- Line: 122
    return utf8.char((tonumber(p21, 16)));
end;

function u5.ParseEscapeSequences(p22) -- Line: 127
    -- upvalues: charCode (copy)
    return p22:gsub("\\(.)", {
        t = "\t",
        n = "\n"
    }):gsub("\\u(%x%x%x%x)", charCode):gsub("\\x(%x%x)", charCode);
end;

function u5.EncodeEscapedOperator(p23, p24) -- Line: 136
    local v25 = p24:sub(1, 1);
    local v26 = p24:gsub(".", "%%%1");

    return p23:gsub("(" .. ("%" .. v25) .. "+)(" .. v26 .. ")", function(p27, p28) -- Line: 141
        return (p27:sub(1, #p27 - 1) .. p28):gsub(".", function(p29) -- Line: 142
            return "\\u" .. string.format("%04x", string.byte(p29), 16);
        end);
    end);
end;

local u30 = { "&&", "||", ";" };

function u5.EncodeEscapedOperators(p31) -- Line: 149
    -- upvalues: u30 (copy), u5 (copy)
    for _, v in ipairs(u30) do
        p31 = u5.EncodeEscapedOperator(p31, v);
    end;

    return p31;
end;

local function encodeControlChars(p32) -- Line: 157
    return p32:gsub("\\\\", "___!CMDR_ESCAPE!___"):gsub("\\\"", "___!CMDR_QUOTE!___"):gsub("\\\'", "___!CMDR_SQUOTE!___"):gsub("\\\n", "___!CMDR_NL!___");
end;

local function decodeControlChars(p33) -- Line: 167
    return p33:gsub("___!CMDR_ESCAPE!___", "\\"):gsub("___!CMDR_QUOTE!___", "\""):gsub("___!CMDR_NL!___", "\n");
end;

function u5.SplitString(p34, p35) -- Line: 177
    -- upvalues: u5 (copy)
    local v36 = nil;
    local v37 = nil;
    local v38 = {};
    local v39 = p35 or (1 / 0);

    for i in p34:gsub("\\\\", "___!CMDR_ESCAPE!___"):gsub("\\\"", "___!CMDR_QUOTE!___"):gsub("\\\'", "___!CMDR_SQUOTE!___"):gsub("\\\n", "___!CMDR_NL!___"):gmatch("[^ ]+") do
        local v40 = u5.ParseEscapeSequences(i);
        local v41 = v40:match("^([\'\"])");
        local v42 = v40:match("([\'\"])$");
        local v43 = v40:match("(\\*)[\'\"]$");

        if v41 and not (v36 or v42) then
            v36 = v41;
            v37 = v40;
        elseif v37 and (v42 == v36 and #v43 % 2 == 0) then
            v40 = v37 .. " " .. v40;
            v37 = nil;
            v36 = nil;
        elseif v37 then
            v37 = v37 .. " " .. v40;
        end;

        if not v37 then
            v38[#v38 + (v39 < #v38 and 0 or 1)] = v40:gsub("^([\'\"])", ""):gsub("([\'\"])$", ""):gsub("___!CMDR_ESCAPE!___", "\\"):gsub("___!CMDR_QUOTE!___", "\""):gsub("___!CMDR_NL!___", "\n");
        end;
    end;

    if v37 then
        v38[#v38 + (v39 < #v38 and 0 or 1)] = v37:gsub("___!CMDR_ESCAPE!___", "\\"):gsub("___!CMDR_QUOTE!___", "\""):gsub("___!CMDR_NL!___", "\n");
    end;

    return v38;
end;

function u5.MashExcessArguments(p44, p45) -- Line: 209
    local v46 = {};

    for i = 1, #p44 do
        if p45 < i then
            v46[p45] = ("%s %s"):format(v46[p45] or "", p44[i]);
        else
            v46[i] = p44[i];
        end;
    end;

    return v46;
end;

function u5.TrimString(p47) -- Line: 222
    local _, v48 = string.find(p47, "^%s*");

    return v48 == #p47 and "" or string.match(p47, ".*%S", v48 + 1);
end;

function u5.GetTextSize(p49, p50, p51) -- Line: 229
    -- upvalues: TextService (copy)
    return TextService:GetTextSize(p49, p50.TextSize, p50.Font, p51 or Vector2.new(p50.AbsoluteSize.X, 0));
end;

function u5.MakeEnumType(u52, p53) -- Line: 234
    -- upvalues: u5 (copy)
    local u54 = u5.MakeFuzzyFinder(p53);

    return {
        Validate = function(p55) -- Line: 237, Name: Validate
            -- upvalues: u54 (copy), u52 (copy)
            return u54(p55, true) ~= nil, ("Value %q is not a valid %s."):format(p55, u52);
        end,

        Autocomplete = function(p56) -- Line: 240, Name: Autocomplete
            -- upvalues: u54 (copy), u5 (ref)
            local v57 = u54(p56);

            if type(v57[1]) ~= "string" then
                v57 = u5.GetNames(v57) or v57;
            end;

            return v57;
        end,

        Parse = function(p58) -- Line: 244, Name: Parse
            -- upvalues: u54 (copy)
            return u54(p58, true);
        end
    };
end;

function u5.ParsePrefixedUnionType(p59, p60) -- Line: 251
    -- upvalues: u5 (copy)
    local v61 = u5.SplitStringSimple(p59);
    local v62 = {};

    for i = 1, #v61, 2 do
        v62[#v62 + 1] = {
            prefix = v61[i - 1] or "",
            type = v61[i]
        };
    end;

    table.sort(v62, function(p63, p64) -- Line: 265
        return #p63.prefix > #p64.prefix;
    end);

    for i = 1, #v62 do
        local v65 = v62[i];

        if p60:sub(1, #v65.prefix) == v65.prefix then
            return v65.type, p60:sub(#v65.prefix + 1), v65.prefix;
        end;
    end;
end;

function u5.MakeListableType(u66, p67) -- Line: 280
    local v68 = {
        Listable = true,
        Transform = u66.Transform,
        Validate = u66.Validate,
        ValidateOnce = u66.ValidateOnce,
        Autocomplete = u66.Autocomplete,
        Default = u66.Default,
        ArgumentOperatorAliases = u66.ArgumentOperatorAliases,

        Parse = function(...) -- Line: 289, Name: Parse
            -- upvalues: u66 (copy)
            return { u66.Parse(...) };
        end
    };

    if p67 then
        for i, v in pairs(p67) do
            v68[i] = v;
        end;
    end;

    return v68;
end;

local function encodeCommandEscape(p69) -- Line: 303
    return p69:gsub("\\%$", "___!CMDR_DOLLAR!___");
end;

local function decodeCommandEscape(p70) -- Line: 307
    return p70:gsub("___!CMDR_DOLLAR!___", "$");
end;

function u5.RunCommandString(p71, p72) -- Line: 311
    -- upvalues: u5 (copy)
    local v73 = u5.ParseEscapeSequences(p72);
    local v74 = u5.EncodeEscapedOperators(v73):split("&&");
    local v75 = "";

    for i, v in ipairs(v74) do
        local v76 = v75:gsub("%$", "\\x24"):gsub("%%", "%%%%");

        if v75:find("%s") then
            v76 = ("%q"):format(v76) or v76;
        end;

        local v77 = v:gsub("||", v76);
        local v78 = u5.RunEmbeddedCommands(p71, v77);
        v75 = tostring(p71:EvaluateAndRun(v78));

        if i == #v74 then
            return v75;
        end;
    end;
end;

function u5.RunEmbeddedCommands(p79, p80) -- Line: 338
    -- upvalues: u5 (copy)
    local v81 = p80:gsub("\\%$", "___!CMDR_DOLLAR!___");
    local v82 = {};

    for i in v81:gmatch("$(%b{})") do
        local v83 = i:sub(2, #i - 1);
        local v84;

        if v83:match("^{.+}$") then
            v83 = v83:sub(2, #v83 - 1);
            v84 = false;
        else
            v84 = true;
        end;

        v82[i] = u5.RunCommandString(p79, v83);

        if v84 and (v82[i]:find("%s") or v82[i] == "") then
            v82[i] = string.format("%q", v82[i]);
        end;
    end;

    return v81:gsub("$(%b{})", v82):gsub("___!CMDR_DOLLAR!___", "$");
end;

function u5.SubstituteArgs(p85, p86) -- Line: 366
    local v87 = p85:gsub("\\%$", "___!CMDR_DOLLAR!___");

    if type(p86) == "table" then
        for i = 1, #p86 do
            local v88 = tostring(i);
            p86[v88] = p86[i];

            if p86[v88]:find("%s") then
                p86[v88] = string.format("%q", p86[v88]);
            end;
        end;
    end;

    return v87:gsub("($%d+)%b{}", "%1"):gsub("$(%w+)", p86):gsub("___!CMDR_DOLLAR!___", "$");
end;

function u5.MakeAliasCommand(p89, p90) -- Line: 383
    -- upvalues: u5 (copy)
    local v91, v92 = unpack(p89:split("|"));
    local u93 = u5.EncodeEscapedOperators(p90);
    local v94 = {};
    local v95 = {};

    for i in u93:gmatch("$(%d+)") do
        if v94[i] == nil then
            v94[i] = true;
            local v96 = u93:match((`${i}(%b\{})`));
            local v97, v98, v99;

            if v96 then
                local v100 = v96:sub(2, #v96 - 1);
                v97, v98, v99 = unpack(v100:split("|"));
            else
                v97 = nil;
                v98 = nil;
                v99 = nil;
            end;

            local v101;

            if v97 then
                v101 = v97:match("%?$") and true or false;
            else
                v101 = v97;
            end;

            local v102 = not v97 and "string" or v97:match("^%w+");
            local v103 = v98 or `Argument {i}`;
            table.insert(v95, {
                Type = v102,
                Name = v103,
                Description = v99 or "",
                Optional = v101
            });
        end;
    end;

    return {
        Group = "UserAlias",
        Name = v91,
        Aliases = {},
        Description = `<Alias> {v92 or u93}`,
        Args = v95,

        Run = function(p104) -- Line: 422, Name: Run
            -- upvalues: u5 (ref), u93 (ref)
            return u5.RunCommandString(p104.Dispatcher, u5.SubstituteArgs(u93, p104.RawArguments));
        end
    };
end;

function u5.MakeSequenceType(p105) -- Line: 429
    -- upvalues: u5 (copy)
    local u106 = p105 or {};
    assert(u106.Parse ~= nil and true or u106.Constructor ~= nil, "MakeSequenceType: Must provide one of: Constructor, Parse");
    u106.TransformEach = u106.TransformEach or function(...) -- Line: 434
        return ...;
    end;
    u106.ValidateEach = u106.ValidateEach or function() -- Line: 438
        return true;
    end;

    return {
        Prefixes = u106.Prefixes,

        Transform = function(p107) -- Line: 445, Name: Transform
            -- upvalues: u5 (ref), u106 (ref)
            return u5.Map(u5.SplitPrioritizedDelimeter(p107, { ",", "%s" }), function(p108) -- Line: 446
                -- upvalues: u106 (ref)
                return u106.TransformEach(p108);
            end);
        end,

        Validate = function(p109) -- Line: 451, Name: Validate
            -- upvalues: u106 (ref)
            if u106.Length and #p109 > u106.Length then
                return false, ("Maximum of %d values allowed in sequence"):format(u106.Length);
            end;

            for i = 1, u106.Length or #p109 do
                local v110, v111 = u106.ValidateEach(p109[i], i);

                if not v110 then
                    return false, v111;
                end;
            end;

            return true;
        end,

        Parse = u106.Parse or function(p112) -- Line: 467
            -- upvalues: u106 (ref)
            return u106.Constructor(unpack(p112));
        end
    };
end;

function u5.SplitPrioritizedDelimeter(p113, p114) -- Line: 475
    -- upvalues: u5 (copy)
    for i, v in ipairs(p114) do
        if p113:find(v) or i == #p114 then
            return u5.SplitStringSimple(p113, v);
        end;
    end;
end;

function u5.Map(p115, p116) -- Line: 484
    local v117 = {};

    for i, v in ipairs(p115) do
        v117[i] = p116(v, i);
    end;

    return v117;
end;

function u5.Each(p118, ...) -- Line: 495
    local v119 = {};

    for i, v in ipairs({ ... }) do
        v119[i] = p118(v);
    end;

    return unpack(v119);
end;

function u5.EmulateTabstops(p120, p121) -- Line: 504
    local v122 = #p120;
    local v123 = table.create(v122);
    local v124 = 0;

    for i = 1, v122 do
        local v125 = string.sub(p120, i, i);

        if v125 == "\t" then
            local v126 = p121 - v124 % p121;
            table.insert(v123, string.rep(" ", v126));
            v124 = v124 + v126;
        else
            table.insert(v123, v125);

            if v125 == "\n" then
                v124 = 0;
            elseif v125 ~= "\r" then
                v124 = v124 + 1;
            end;
        end;
    end;

    return table.concat(v123);
end;

function u5.Mutex() -- Line: 526
    local u127 = {};
    local u128 = false;

    return function() -- Line: 530
        -- upvalues: u128 (ref), u127 (copy)
        if u128 then
            table.insert(u127, coroutine.running());
            coroutine.yield();
        else
            u128 = true;
        end;

        return function() -- Line: 538
            -- upvalues: u127 (ref), u128 (ref)
            if #u127 > 0 then
                coroutine.resume(table.remove(u127, 1));

                return;
            end;

            u128 = false;
        end;
    end;
end;

return u5;