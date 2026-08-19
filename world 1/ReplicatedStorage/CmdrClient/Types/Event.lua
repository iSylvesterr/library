-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local function getEventNames() -- Line: 8
    -- upvalues: ReplicatedStorage (copy)
    local v1 = {};
    local RegisteredEvents = ReplicatedStorage:FindFirstChild("RegisteredEvents");

    if RegisteredEvents then
        for _, child in RegisteredEvents:GetChildren() do
            table.insert(v1, child.Name);
        end;
    end;

    table.sort(v1);

    return v1;
end;

local function fuzzyFind(p2, p3, p4) -- Line: 20
    local v5 = {};

    for _, v in p2 do
        if v:lower() == p3:lower() then
            if p4 then
                return v;
            end;

            table.insert(v5, 1, v);
        elseif v:lower():find(p3:lower(), 1, true) then
            table.insert(v5, v);
        end;
    end;

    if p4 then
        return v5[1];
    end;

    return v5;
end;

return function(p6) -- Line: 34
    -- upvalues: getEventNames (copy), fuzzyFind (copy)
    p6:RegisterType("event", {
        Validate = function(p7) -- Line: 36, Name: Validate
            -- upvalues: getEventNames (ref), fuzzyFind (ref)
            local v8 = getEventNames();

            return fuzzyFind(v8, p7, true) ~= nil, string.format("%q is not a valid event. Valid events: %s", p7, table.concat(v8, ", "));
        end,

        Autocomplete = function(p9) -- Line: 41, Name: Autocomplete
            -- upvalues: fuzzyFind (ref), getEventNames (ref)
            return fuzzyFind(getEventNames(), p9);
        end,

        Parse = function(p10) -- Line: 44, Name: Parse
            -- upvalues: fuzzyFind (ref), getEventNames (ref)
            return fuzzyFind(getEventNames(), p10, true);
        end
    });
end;