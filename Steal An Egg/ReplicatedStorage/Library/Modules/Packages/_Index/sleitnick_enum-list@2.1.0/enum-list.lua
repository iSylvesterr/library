-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Types = require(script.Private.Types);
local TableUtil = require(ReplicatedStorage.Library.Modules.Packages.TableUtil);
local u1 = Random.new();
local u2 = newproxy();
local u3 = newproxy();
local u4 = newproxy();

local function CreateEnumItem(p5, p6, p7, p8, p9) -- Line: 28
    return table.freeze({
        Name = p5,
        Value = p6,
        Position = p7,
        EnumType = p9,
        Id = p8
    });
end;

local u10 = {};
u10.__index = u10;
u10.__types = Types;

function u10.new(p11, p12) -- Line: 65
    -- upvalues: Types (copy), u2 (copy), u3 (copy), u4 (copy), TableUtil (copy), u10 (copy)
    assert(Types._basicParams(p11, p12));
    local v13 = {
        [u2] = {},
        [u3] = p11,
        [u4] = TableUtil.Copy(p12, true)
    };

    for i, v in pairs(p12) do
        assert(Types._currentEnum(v, i));
        local v14 = typeof(v) == "table";
        local v15;

        if v14 then
            v15 = v.Name or i;
        else
            v15 = v;
        end;

        if v14 then
            local i = v.Position or i;
        end;

        local v16;

        if v14 then
            v16 = v.Value or v;
        else
            v16 = v;
        end;

        local v17 = table.freeze({
            Name = v15,
            Value = v16,
            Position = i,
            EnumType = v13,
            Id = v14 and v.Id or nil
        });
        v13[v15] = v17;
        table.insert(v13[u2], i, v17);
    end;

    return table.freeze((setmetatable(v13, u10)));
end;

function u10.buildFrom(p18, p19, p20) -- Line: 102
    -- upvalues: u10 (copy), Types (copy), TableUtil (copy)
    local v21 = u10.is(p18);
    assert(v21, "EnumList is not a valid EnumList object.");
    assert(Types._cloneParams(p19, p20));
    local v22 = p18:GetEnumNames();

    if p20 then
        v22 = TableUtil.Reconcile(v22, p20) or v22;
    end;

    return u10.new(p19 or p18:GetName(), v22);
end;

function u10.is(p23) -- Line: 117
    -- upvalues: u10 (copy)
    if typeof(p23) == "table" then
        return getmetatable(p23) == u10;
    end;

    return false;
end;

function u10.isItem(p24) -- Line: 129
    -- upvalues: Types (copy)
    if typeof(p24) == "table" then
        return Types.EnumItem(p24);
    end;

    return false, "Invalid type";
end;

function u10.BelongsTo(p25, p26) -- Line: 142
    local v27;

    if type(p26) == "table" then
        v27 = p26.EnumType == p25;
    else
        v27 = false;
    end;

    if v27 then
        return true;
    end;

    return false, `{p26} does not belong to enum-list "{p25:GetName()}"`;
end;

function u10.Exists(p28, p29) -- Line: 156
    local v30;

    if p29 == nil then
        v30 = false;
    else
        v30 = p28[p29];
    end;

    return v30;
end;

function u10.GetEnumItemFromPosition(p31, p32) -- Line: 164
    -- upvalues: Asserts (copy)
    Asserts.number(p32);

    return p31:GetEnumItems()[p32];
end;

function u10.GetStartingFromPosition(p33, p34) -- Line: 173
    -- upvalues: Asserts (copy)
    Asserts.number(p34);

    if p34 == 0 then
        return {};
    end;

    local v35 = p33:GetEnumItems();
    local v36;

    if p34 > 0 then
        v36 = p34 <= #v35;
    else
        v36 = false;
    end;

    assert(v36, "Position must be positive and within the available enums");

    return table.move(v35, p34, #v35, 1, {});
end;

function u10.RollIfPossible(p37, p38) -- Line: 190
    -- upvalues: Asserts (copy), u1 (copy)
    local v39 = p37:Exists(p38);
    local v40 = assert(v39, "Invalid enum name. Not valid member of EnumList.");
    Asserts.table(v40.Value);

    return v40.Value[u1:NextInteger(1, #v40.Value)];
end;

function u10.Compare(p41, p42, p43) -- Line: 199
    local v44 = assert(p41[p42], "First argument is not a member of this EnumList");
    local v45 = assert(p41[p43], "Second argument is not a member of this EnumList");

    return v44.Position - v45.Position;
end;

function u10.UnitCompare(p46, p47, p48) -- Line: 207
    local v49 = p46:Compare(p47, p48);

    return math.clamp(v49, -1, 1);
end;

function u10.Equal(p50, p51, p52) -- Line: 217
    return p50:Compare(p51, p52) == 0;
end;

function u10.IsLessThan(p53, p54, p55) -- Line: 226
    return p53:Compare(p54, p55) < 0;
end;

function u10.IsGreaterThan(p56, p57, p58) -- Line: 235
    return p56:Compare(p57, p58) > 0;
end;

function u10.GetEnumItems(p59) -- Line: 244
    -- upvalues: u2 (copy)
    return p59[u2];
end;

function u10.GetEnumNames(p60) -- Line: 253
    -- upvalues: u4 (copy)
    return p60[u4];
end;

function u10.GetName(p61) -- Line: 262
    -- upvalues: u3 (copy)
    return p61[u3];
end;

return u10;