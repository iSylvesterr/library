-- Decompiled with Potassium's decompiler.

local TestPlan = require(script.Parent.TestPlan);

return {
    createPlan = function(p1, p2, p3) -- Line: 26, Name: createPlan
        -- upvalues: TestPlan (copy)
        local v4 = TestPlan.new(p2, p3);
        table.sort(p1, function(p5, p6) -- Line: 29
            return p5.pathStringForSorting < p6.pathStringForSorting;
        end);

        for _, v in ipairs(p1) do
            v4:addRoot(v.path, v.method);
        end;

        return v4;
    end
};