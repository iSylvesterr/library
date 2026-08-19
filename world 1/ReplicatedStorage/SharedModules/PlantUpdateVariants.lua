-- Decompiled with Potassium's decompiler.

local ReturnVariant = require(script.ReturnVariant);
local u1 = {
    Corn = {
        PlantName = "Corn",
        CurrentVariant = 1,
        Variants = { {
                UnixTimestamp = 1781503200,
                Variant = 1
            } }
    }
};

return table.freeze({
    Variants = u1,

    ReturnVariant = function(p2, p3) -- Line: 35, Name: ReturnVariant
        -- upvalues: ReturnVariant (copy), u1 (copy)
        return ReturnVariant(u1, p2, p3);
    end
});