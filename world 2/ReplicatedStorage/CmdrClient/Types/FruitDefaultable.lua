-- Decompiled with Potassium's decompiler.

local u1 = {
    ["."] = true,
    ["-"] = true,
    _ = true,
    x = true,
    d = true,
    default = true,
    ["nil"] = true
};
local u2 = table.freeze({});

local function isSkip(p3) -- Line: 21
    -- upvalues: u1 (copy)
    return u1[p3:lower()] == true;
end;

return function(p4) -- Line: 25
    -- upvalues: u1 (copy), u2 (copy)
    p4:RegisterType("fruitWeight", {
        Transform = function(p5) -- Line: 27, Name: Transform
            -- upvalues: u1 (ref), u2 (ref)
            if u1[p5:lower()] == true then
                return u2;
            end;

            return tonumber(p5);
        end,

        Validate = function(p6) -- Line: 31, Name: Validate
            -- upvalues: u2 (ref)
            if p6 == u2 then
                return true;
            end;

            local v7;

            if p6 == nil then
                v7 = false;
            else
                v7 = p6 > 0;
            end;

            return v7, "Weight must be a positive number, or \'.\' to use the fruit\'s base weight.";
        end,

        Parse = function(p8) -- Line: 36, Name: Parse
            -- upvalues: u2 (ref)
            if p8 == u2 then
                return nil;
            end;

            return p8;
        end
    });
    p4:RegisterType("fruitSeed", {
        Transform = function(p9) -- Line: 43, Name: Transform
            -- upvalues: u1 (ref), u2 (ref)
            if u1[p9:lower()] == true then
                return u2;
            end;

            return tonumber(p9);
        end,

        Validate = function(p10) -- Line: 47, Name: Validate
            -- upvalues: u2 (ref)
            if p10 == u2 then
                return true;
            end;

            local v11;

            if p10 == nil or p10 ~= math.floor(p10) then
                v11 = false;
            else
                v11 = p10 > 0;
            end;

            return v11, "Seed must be a positive whole number, or \'.\' for a random seed.";
        end,

        Parse = function(p12) -- Line: 52, Name: Parse
            -- upvalues: u2 (ref)
            if p12 == u2 then
                return nil;
            end;

            return p12;
        end
    });
end;