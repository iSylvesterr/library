-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1._new(p2) -- Line: 129
    -- upvalues: u1 (copy)
    return setmetatable({
        ClassName = "Option",
        _v = p2,
        _s = p2 ~= nil
    }, u1);
end;

function u1.Some(p3) -- Line: 145
    -- upvalues: u1 (copy)
    assert(p3 ~= nil, "Option.Some() value cannot be nil");

    return u1._new(p3);
end;

function u1.Wrap(p4) -- Line: 158
    -- upvalues: u1 (copy)
    if p4 == nil then
        return u1.None;
    end;

    return u1.Some(p4);
end;

function u1.Is(p5) -- Line: 171
    -- upvalues: u1 (copy)
    local v6;

    if type(p5) == "table" then
        v6 = getmetatable(p5) == u1;
    else
        v6 = false;
    end;

    return v6;
end;

function u1.Assert(p7) -- Line: 179
    -- upvalues: u1 (copy)
    local v8 = u1.Is(p7);
    assert(v8, "Result was not of type Option");
end;

function u1.Deserialize(p9) -- Line: 189
    -- upvalues: u1 (copy)
    local v10;

    if type(p9) == "table" then
        v10 = p9.ClassName == "Option";
    else
        v10 = false;
    end;

    assert(v10, "Invalid data for deserializing Option");

    return p9.Value == nil and u1.None or u1.Some(p9.Value);
end;

function u1.Serialize(p11) -- Line: 198
    return {
        ClassName = p11.ClassName,
        Value = p11._v
    };
end;

function u1.Match(p12, p13) -- Line: 219
    local Some = p13.Some;
    local None = p13.None;
    local v14 = type(Some) == "function";
    assert(v14, "Missing \'Some\' match");
    local v15 = type(None) == "function";
    assert(v15, "Missing \'None\' match");

    if p12:IsSome() then
        return Some(p12:Unwrap());
    end;

    return None();
end;

function u1.IsSome(p16) -- Line: 235
    return p16._s;
end;

function u1.IsNone(p17) -- Line: 243
    return not p17._s;
end;

function u1.Expect(p18, p19) -- Line: 257
    local v20 = p18:IsSome();
    assert(v20, p19);

    return p18._v;
end;

function u1.ExpectNone(p21, p22) -- Line: 266
    local v23 = p21:IsNone();
    assert(v23, p22);
end;

function u1.Unwrap(p24) -- Line: 274
    return p24:Expect("Cannot unwrap option of None type");
end;

function u1.UnwrapOr(p25, p26) -- Line: 283
    if p25:IsSome() then
        return p25:Unwrap();
    end;

    return p26;
end;

function u1.UnwrapOrElse(p27, p28) -- Line: 297
    if p27:IsSome() then
        return p27:Unwrap();
    end;

    return p28();
end;

function u1.And(p29, p30) -- Line: 323
    -- upvalues: u1 (copy)
    if p29:IsSome() then
        return p30;
    end;

    return u1.None;
end;

function u1.AndThen(p31, p32) -- Line: 347
    -- upvalues: u1 (copy)
    if not p31:IsSome() then
        return u1.None;
    end;

    local v33 = p32(p31:Unwrap());
    u1.Assert(v33);

    return v33;
end;

function u1.Or(p34, p35) -- Line: 362
    if p34:IsSome() then
        return p34;
    end;

    return p35;
end;

function u1.OrElse(p36, p37) -- Line: 376
    -- upvalues: u1 (copy)
    if p36:IsSome() then
        return p36;
    end;

    local v38 = p37();
    u1.Assert(v38);

    return v38;
end;

function u1.XOr(p39, p40) -- Line: 393
    -- upvalues: u1 (copy)
    local v41 = p39:IsSome();

    if v41 == p40:IsSome() then
        return u1.None;
    end;

    if v41 then
        return p39;
    end;

    return p40;
end;

function u1.Filter(p42, p43) -- Line: 411
    -- upvalues: u1 (copy)
    if p42:IsNone() or not p43(p42._v) then
        return u1.None;
    end;

    return p42;
end;

function u1.Contains(p44, p45) -- Line: 424
    local v46 = p44:IsSome() and p44._v == p45;

    return v46;
end;

function u1.__tostring(p47) -- Line: 438
    return not p47:IsSome() and "Option<None>" or "Option<" .. typeof(p47._v) .. ">";
end;

function u1.__eq(p48, p49) -- Line: 464
    -- upvalues: u1 (copy)
    if u1.Is(p49) then
        if p48:IsSome() and p49:IsSome() then
            return p48:Unwrap() == p49:Unwrap();
        end;

        if p48:IsNone() and p49:IsNone() then
            return true;
        end;
    end;

    return false;
end;

u1.None = u1._new();

return u1;