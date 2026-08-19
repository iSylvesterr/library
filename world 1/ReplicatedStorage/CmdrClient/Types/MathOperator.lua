-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 1
    p1:RegisterType("mathOperator", p1.Cmdr.Util.MakeEnumType("Math Operator", {
        {
            Name = "+",

            Perform = function(p2, p3) -- Line: 5, Name: Perform
                return p2 + p3;
            end
        },
        {
            Name = "-",

            Perform = function(p4, p5) -- Line: 11, Name: Perform
                return p4 - p5;
            end
        },
        {
            Name = "*",

            Perform = function(p6, p7) -- Line: 17, Name: Perform
                return p6 * p7;
            end
        },
        {
            Name = "/",

            Perform = function(p8, p9) -- Line: 23, Name: Perform
                return p8 / p9;
            end
        },
        {
            Name = "**",

            Perform = function(p10, p11) -- Line: 29, Name: Perform
                return p10 ^ p11;
            end
        },
        {
            Name = "%",

            Perform = function(p12, p13) -- Line: 35, Name: Perform
                return p12 % p13;
            end
        }
    }));
end;