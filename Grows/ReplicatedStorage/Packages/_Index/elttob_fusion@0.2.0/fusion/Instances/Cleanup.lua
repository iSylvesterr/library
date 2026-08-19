-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.PubTypes);

return {
    type = "SpecialKey",
    kind = "Cleanup",
    stage = "observer",

    apply = function(p1, p2, p3, p4) -- Line: 16, Name: apply
        table.insert(p4, p2);
    end
};