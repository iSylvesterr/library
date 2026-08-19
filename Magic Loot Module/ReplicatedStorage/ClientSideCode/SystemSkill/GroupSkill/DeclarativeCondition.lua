-- Decompiled with Potassium's decompiler.

local function evaluateDeclarative(p1, p2) -- Line: 30
    -- upvalues: evaluateDeclarative (copy)
    if type(p1) ~= "table" or not p2 then
        return false;
    end;

    if p1.all ~= nil then
        local all = p1.all;

        if type(all) ~= "table" then
            return false;
        end;

        for _, v in ipairs(all) do
            if not evaluateDeclarative(v, p2) then
                return false;
            end;
        end;

        return true;
    end;

    if p1.any ~= nil then
        local any = p1.any;

        if type(any) ~= "table" then
            return false;
        end;

        for _, v in ipairs(any) do
            if evaluateDeclarative(v, p2) then
                return true;
            end;
        end;

        return false;
    end;

    if p1["not"] ~= nil then
        return not evaluateDeclarative(p1["not"], p2);
    end;

    local type2 = p1.type;

    if type(type2) ~= "string" then
        return false;
    end;

    if type2 == "chain_input" then
        local index = p1.index;

        if type(index) ~= "number" then
            return false;
        end;

        local buffer = p1.buffer;

        if buffer == nil or type(buffer) == "number" then
            return p2.CheckChainInput(index, buffer);
        end;

        return false;
    end;

    if type2 == "window" then
        local name = p1.name;

        if type(name) == "string" then
            return p2.InWindow(name);
        end;

        return false;
    end;

    if type2 == "state_before" then
        local state = p1.state;

        if type(state) == "string" then
            return p2.StateBefore(state);
        end;

        return false;
    end;

    if type2 ~= "state_passed" then
        if type2 == "literal" then
            return p1.value and true or false;
        end;

        return false;
    end;

    local state = p1.state;

    if type(state) == "string" then
        return p2.StatePassed(state);
    end;

    return false;
end;

return {
    evaluate = evaluateDeclarative,

    isDeclarative = function(p3) -- Line: 107, Name: isDeclarative
        return type(p3) == "table";
    end
};