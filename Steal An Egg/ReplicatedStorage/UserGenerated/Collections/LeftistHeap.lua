-- Decompiled with Potassium's decompiler.

function _merge1(p1, p2, p3)
    if not p2.Left then
        p2.Left = p3;

        return p2;
    end;

    p2.Right = _merge(p1, p2.Right, p3);

    if p2.Left.Npl < p2.Right.Npl then
        local Left = p2.Left;
        p2.Left = p2.Right;
        p2.Right = Left;
    end;

    p2.Npl = p2.Right.Npl + 1;

    return p2;
end;

function _merge(p4, p5, p6)
    if not p5 then
        return p6;
    end;

    if not p6 then
        return p5;
    end;

    if p4(p5.Value, p6.Value) < 0 then
        return _merge1(p4, p5, p6);
    end;

    return _merge1(p4, p6, p5);
end;

local v7 = {};
local u8 = table.freeze({
    __index = v7
});

function v7.Merge(p9, p10) -- Line: 131
    if p9.Root ~= p10.Root then
        p9.Root = _merge(p9.Comparator, p9.Root, p10.Root);
        p10.Root = nil;
    end;
end;

function v7.Insert(p11, p12) -- Line: 138
    p11.Root = _merge(p11.Comparator, {
        Npl = 0,
        Value = p12
    }, p11.Root);
end;

function v7.Min(p13) -- Line: 145
    assert(p13.Root);

    return p13.Root.Value;
end;

function v7.TryMin(p14) -- Line: 150
    if p14.Root then
        return true, p14.Root.Value;
    end;

    return false, nil;
end;

function v7.Pop(p15) -- Line: 157
    assert(p15.Root);
    local Value = p15.Root.Value;
    p15.Root = _merge(p15.Comparator, p15.Root.Left, p15.Root.Right);

    return Value;
end;

function v7.TryPop(p16) -- Line: 164
    if not p16.Root then
        return false, nil;
    end;

    local Value = p16.Root.Value;
    p16.Root = _merge(p16.Comparator, p16.Root.Left, p16.Root.Right);

    return true, Value;
end;

function v7.PopFast(p17) -- Line: 173
    p17.Root = _merge(p17.Comparator, p17.Root.Left, p17.Root.Right);
end;

function v7.Empty(p18) -- Line: 177
    return p18.Root == nil;
end;

function v7.Clear(p19) -- Line: 181
    p19.Root = nil;
end;

table.freeze(v7);

return table.freeze({
    Compare = function(p20, p21) -- Line: 190, Name: Compare
        return p20 < p21 and -1 or (p21 < p20 and 1 or 0);
    end,

    new = function(p22, p23) -- Line: 200, Name: new
        -- upvalues: u8 (copy)
        local v24 = type(p22) == "function";
        assert(v24);

        return setmetatable({
            Comparator = p22
        }, u8);
    end
});