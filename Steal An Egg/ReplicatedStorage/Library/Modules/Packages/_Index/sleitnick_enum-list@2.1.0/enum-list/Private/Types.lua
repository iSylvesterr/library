-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local u1 = {
    _cloneParams = t.tuple(t.optional(t.string), t.optional(t.table)),
    _basicParams = t.tuple(t.string, t.table),
    _complexStruct = t.interface({
        Position = t.number,
        Name = t.optional(t.any),
        Value = t.any
    })
};

function u1._currentEnum(p2, p3) -- Line: 44
    -- upvalues: t (copy), u1 (copy)
    if typeof(p2) == "table" then
        return u1._complexStruct(p2);
    end;

    return t.tuple(t.any(p2), t.number(p3));
end;

u1.EnumItem = t.strictInterface({
    Name = t.any,
    Value = t.any,
    Position = t.number,
    EnumType = t.any,
    Id = t.optional(t.string)
});

return u1;