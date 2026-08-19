-- Decompiled with Potassium's decompiler.

local u1 = {};
local Main = require(script.Parent.Main);
local v2 = {};
local u3 = {};
local u4 = {};

function v2.Format(p5, p6) -- Line: 15
    -- upvalues: u3 (copy), Main (copy)
    local v7 = type(p5) == "number";
    assert(v7, "Value provided must be a number");
    local v8 = p6 == nil and "" or p6;
    local v9 = type(v8) == "string";
    assert(v9, "Skeleton provided must be a string");
    local v10 = u3[v8];

    if not v10 then
        local v11;
        v11, v10 = Main.NumberFormatter.forSkeleton(v8);
        assert(v11, v10);
        u3[v8] = v10;
    end;

    return v10:Format(p5);
end;

function v2.FormatCompact(p12, p13) -- Line: 43
    -- upvalues: u4 (copy), Main (copy), u1 (copy)
    local v14 = type(p12) == "number";
    assert(v14, "Value provided must be a number");
    local v15 = p13 == nil and "" or p13;
    local v16 = type(v15) == "string";
    assert(v16, "Skeleton provided must be a string");
    local v17 = u4[v15];

    if not v17 then
        local v18, v19 = Main.NumberFormatter.forSkeleton(v15);
        assert(v18, v19);
        v17 = v19:Notation(Main.Notation.compactWithSuffixThousands(u1));
        u4[v15] = v17;
    end;

    assert(#u1 ~= 0, "Please provide the suffix abbreviations for FormatCompact at the top of the Simple ModuleScript");

    return v17:Format(p12);
end;

return table.freeze(v2);