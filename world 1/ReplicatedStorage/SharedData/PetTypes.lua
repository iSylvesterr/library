-- Decompiled with Potassium's decompiler.

local u1 = {
    Rainbow = {
        DisplayText = "RAINBOW"
    }
};
local v7 = {
    Rainbow = "Rainbow",
    BOOST_MULTIPLIER = 1.25,
    Registry = table.freeze(u1),

    IsValid = function(p2) -- Line: 53, Name: IsValid
        -- upvalues: u1 (copy)
        if type(p2) == "string" then
            return u1[p2] ~= nil;
        end;

        return false;
    end,

    GetBoostMultiplier = function(p3) -- Line: 60, Name: GetBoostMultiplier
        return p3 == "Rainbow" and 1.25 or 1;
    end,

    GetDisplayText = function(p4) -- Line: 67, Name: GetDisplayText
        -- upvalues: u1 (copy)
        if type(p4) ~= "string" then
            return nil;
        end;

        local v5 = u1[p4];

        if v5 then
            return v5.DisplayText;
        end;

        return nil;
    end,

    IsRainbow = function(p6) -- Line: 76, Name: IsRainbow
        if type(p6) == "table" then
            return p6.Type == "Rainbow";
        end;

        return false;
    end
};

return table.freeze(v7);