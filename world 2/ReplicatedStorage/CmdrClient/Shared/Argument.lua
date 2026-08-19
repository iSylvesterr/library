-- Decompiled with Potassium's decompiler.

local Util = require(script.Parent.Util);

local function unescapeOperators(p1) -- Line: 3
    for _, v in ipairs({ "%.", "%?", "%*", "%*%*" }) do
        p1 = p1:gsub("\\" .. v, v:gsub("%%", ""));
    end;

    return p1;
end;

local u2 = {};
u2.__index = u2;

function u2.new(p3, p4, p5) -- Line: 15
    -- upvalues: Util (copy), u2 (copy)
    local v6 = {
        Type = nil,
        Prefix = "",
        TextSegmentInProgress = "",
        RawSegmentsAreAutocomplete = false,
        Command = p3,
        Name = p4.Name,
        Object = p4
    };
    local v7;

    if p4.Default == nil then
        v7 = p4.Optional ~= true;
    else
        v7 = false;
    end;

    v6.Required = v7;
    v6.Executor = p3.Executor;
    v6.RawValue = p5;
    v6.RawSegments = {};
    v6.TransformedValues = {};

    if type(p4.Type) == "table" then
        v6.Type = p4.Type;
    else
        local v8, v9, v10 = Util.ParsePrefixedUnionType(p3.Cmdr.Registry:GetTypeName(p4.Type), p5);
        v6.Type = p3.Dispatcher.Registry:GetType(v8);
        v6.RawValue = v9;
        v6.Prefix = v10;

        if v6.Type == nil then
            error(string.format("%s has an unregistered type %q", v6.Name or "<none>", v8 or "<none>"));
        end;
    end;

    setmetatable(v6, u2);
    v6:Transform();

    return v6;
end;

function u2.GetDefaultAutocomplete(p11) -- Line: 55
    if not p11.Type.Autocomplete then
        return {};
    end;

    local v12, v13 = p11.Type.Autocomplete(p11:TransformSegment(""));

    return v12, v13 or {};
end;

function u2.Transform(p14) -- Line: 67
    -- upvalues: unescapeOperators (copy), Util (copy)
    if #p14.TransformedValues ~= 0 then
        return;
    end;

    local RawValue = p14.RawValue;

    if p14.Type.ArgumentOperatorAliases then
        RawValue = p14.Type.ArgumentOperatorAliases[RawValue] or RawValue;
    end;

    if RawValue == "." and p14.Type.Default then
        RawValue = p14.Type.Default(p14.Executor) or "";
        p14.RawSegmentsAreAutocomplete = true;
    end;

    if RawValue == "?" and p14.Type.Autocomplete then
        local v15, v16 = p14:GetDefaultAutocomplete();

        if not v16.IsPartial and #v15 > 0 then
            RawValue = v15[math.random(1, #v15)];
            p14.RawSegmentsAreAutocomplete = true;
        end;
    end;

    if not p14.Type.Listable or #p14.RawValue <= 0 then
        local v17 = unescapeOperators(RawValue);
        p14.RawSegments[1] = unescapeOperators(v17);
        p14.TransformedValues[1] = { p14:TransformSegment(v17) };
        p14.TextSegmentInProgress = p14.RawValue;

        return;
    end;

    local v18 = RawValue:match("^%?(%d+)$");

    if v18 then
        local v19 = tonumber(v18);

        if v19 and v19 > 0 then
            local v20 = {};
            local v21, v22 = p14:GetDefaultAutocomplete();

            if not v22.IsPartial and #v21 > 0 then
                for _ = 1, math.min(v19, #v21) do
                    table.insert(v20, table.remove(v21, math.random(1, #v21)));
                end;

                RawValue = table.concat(v20, ",");
                p14.RawSegmentsAreAutocomplete = true;
            end;
        end;
    elseif RawValue == "*" or RawValue == "**" then
        local v23, v24 = p14:GetDefaultAutocomplete();

        if not v24.IsPartial and #v23 > 0 then
            if RawValue == "**" and p14.Type.Default then
                local v25 = p14.Type.Default(p14.Executor) or "";

                for i, v in ipairs(v23) do
                    if v == v25 then
                        table.remove(v23, i);
                    end;
                end;
            end;

            RawValue = table.concat(v23, ",");
            p14.RawSegmentsAreAutocomplete = true;
        end;
    end;

    local v26 = unescapeOperators(RawValue);
    local v27 = Util.SplitStringSimple(v26, ",");
    local v28 = #v27 == 0 and { "" } or v27;

    if v26:sub(#v26, #v26) == "," then
        v28[#v28 + 1] = "";
    end;

    for i, v in ipairs(v28) do
        p14.RawSegments[i] = v;
        p14.TransformedValues[i] = { p14:TransformSegment(v) };
    end;

    p14.TextSegmentInProgress = v28[#v28];
end;

function u2.TransformSegment(p29, p30) -- Line: 159
    if p29.Type.Transform then
        return p29.Type.Transform(p30, p29.Executor);
    end;

    return p30;
end;

function u2.GetTransformedValue(p31, p32) -- Line: 168
    return unpack(p31.TransformedValues[p32]);
end;

function u2.Validate(p33, p34) -- Line: 173
    if p33.RawValue == nil or #p33.RawValue == 0 and p33.Required == false then
        return true;
    end;

    if p33.Required and (p33.RawSegments[1] == nil or #p33.RawSegments[1] == 0) then
        return false, "This argument is required.";
    end;

    if not (p33.Type.Validate or p33.Type.ValidateOnce) then
        return true;
    end;

    for i = 1, #p33.TransformedValues do
        if p33.Type.Validate then
            local v35, v36 = p33.Type.Validate(p33:GetTransformedValue(i));

            if not v35 then
                return v35, v36 or "Invalid value";
            end;
        end;

        if p34 and p33.Type.ValidateOnce then
            local v37, v38 = p33.Type.ValidateOnce(p33:GetTransformedValue(i));

            if not v37 then
                return v37, v38;
            end;
        end;
    end;

    return true;
end;

function u2.GetAutocomplete(p39) -- Line: 208
    return not p39.Type.Autocomplete and {} or p39.Type.Autocomplete(p39:GetTransformedValue(#p39.TransformedValues));
end;

function u2.ParseValue(p40, p41) -- Line: 216
    if p40.Type.Parse then
        return p40.Type.Parse(p40:GetTransformedValue(p41));
    end;

    return p40:GetTransformedValue(p41);
end;

function u2.GetValue(p42) -- Line: 225
    if #p42.RawValue == 0 and (not p42.Required and p42.Object.Default ~= nil) then
        return p42.Object.Default;
    end;

    if not p42.Type.Listable then
        return p42:ParseValue(1);
    end;

    local v43 = {};

    for i = 1, #p42.TransformedValues do
        local v44 = p42:ParseValue(i);

        if type(v44) ~= "table" then
            error(("Listable types must return a table from Parse (%s)"):format(p42.Type.Name));
        end;

        for _, v in pairs(v44) do
            v43[v] = true;
        end;
    end;

    local v45 = {};

    for i in pairs(v43) do
        v45[#v45 + 1] = i;
    end;

    return v45;
end;

return u2;