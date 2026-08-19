-- Decompiled with Potassium's decompiler.

local Library = game:GetService("ReplicatedStorage"):WaitForChild("Library");
local Items = Library:WaitForChild("Items");
local Asserts = require(Library.Asserts);
local Types = require(Items.Types);
local AbstractStore = require(script.Parent:WaitForChild("AbstractStore"));
local ShadowStore = require(script.Parent:WaitForChild("ShadowStore"));
local u1 = {};
local v17 = {
    Class = "SimpleStoreChild",

    GetIteration = function(p2) -- Line: 12, Name: GetIteration
        return p2._iteration;
    end,

    Size = function(p3) -- Line: 16, Name: Size
        return p3._size;
    end,

    Amount = function(p4) -- Line: 20, Name: Amount
        return p4._amount;
    end,

    Get = function(p5, p6) -- Line: 24, Name: Get
        return p5._byUID[p6];
    end,

    _SetReference = function(p7, p8, p9) -- Line: 28, Name: _SetReference
        local v10 = p7._byUID[p8];
        local _size = p7._size;
        local _amount = p7._amount;

        if v10 then
            _size = _size - 1;
            _amount = _amount - v10:GetAmount();
        end;

        if p9 then
            _size = _size + 1;
            _amount = _amount + p9:GetAmount();
        end;

        p7._size = _size;
        p7._amount = _amount;
        p7._byUID[p8] = p9;
        p7._iteration = p7._iteration + 1;
    end,

    All = function(p11, p12) -- Line: 49, Name: All
        local _byUID = p11._byUID;

        if p12 then
            _byUID = table.clone(_byUID);
        end;

        return _byUID;
    end,

    Each = function(p13, p14, ...) -- Line: 59, Name: Each
        for _, v in pairs(p13._byUID) do
            local v15 = p14(v, ...);

            if v15 ~= nil then
                return v15;
            end;
        end;
    end,

    IsEmpty = function(p16) -- Line: 69, Name: IsEmpty
        return next(p16._byUID) == nil;
    end
};
local u18 = {
    Class = "SimpleStoreStack"
};
setmetatable(u18, {
    __index = v17
});

function u1.newStack() -- Line: 81
    -- upvalues: u18 (copy)
    return setmetatable({
        _iteration = 0,
        _size = 0,
        _amount = 0,
        _byUID = {}
    }, {
        __index = u18
    });
end;

local u19 = {
    Class = "SimpleStoreType"
};
setmetatable(u19, {
    __index = v17
});

function u19.Stack(p20, p21) -- Line: 99
    -- upvalues: u1 (copy)
    local v22 = p20._byStack[p21];

    if not v22 then
        local v23 = type(p21) == "string";
        assert(v23);
        v22 = u1.newStack();
        p20._byStack[p21] = v22;
    end;

    return v22;
end;

function u19.GetStack(p24, p25) -- Line: 112
    return p24._byStack[p25];
end;

function u1.newType() -- Line: 116
    -- upvalues: u19 (copy)
    return setmetatable({
        _iteration = 0,
        _size = 0,
        _amount = 0,
        _byUID = {},
        _byStack = {}
    }, {
        __index = u19
    });
end;

local u26 = {
    Class = "SimpleStore"
};
setmetatable(u26, {
    __index = v17
});

function u26.Type(p27, p28) -- Line: 135
    -- upvalues: Types (copy), u1 (copy)
    local v29 = p27._byType[p28];

    if not v29 then
        Types.AssertTypeName(p28);
        v29 = u1.newType();
        p27._byType[p28] = v29;
    end;

    return v29;
end;

function u26.GetType(p30, p31) -- Line: 147
    return p30._byType[p31];
end;

function u26.Capacity(p32) -- Line: 151
    return p32._capacity;
end;

function u26.SetCapacity(p33, p34) -- Line: 155
    -- upvalues: Asserts (copy), AbstractStore (copy)
    if p34 ~= nil then
        Asserts.integer(p34);
        assert(p34 <= AbstractStore.HARD_SIZE_CAPACITY);
    end;

    p33._capacity = p34;
end;

function u26._GetDataContainer(p35, p36) -- Line: 164
    -- upvalues: Types (copy)
    local v37 = p35._dataByType[p36];

    if not v37 then
        Types.AssertTypeName(p36);
        v37 = {};
        p35._dataByType[p36] = v37;
    end;

    return v37;
end;

function u26.GetData(p38, p39, p40) -- Line: 177
    return p38:_GetDataContainer(p39)[p40];
end;

function u26._SetData(p41, p42, p43, p44) -- Line: 181
    p41:_GetDataContainer(p42)[p43] = p44;
    p41._iteration = p41._iteration + 1;
end;

function u26.GetDataTable(p45) -- Line: 186
    return p45._dataByType;
end;

function u26.Packet(p46) -- Line: 190
    local _byUID = p46._byUID;

    if not next(_byUID) then
        return nil;
    end;

    local v47 = {};

    for i, v in pairs(_byUID) do
        local Name = v.Class.Name;
        local v48 = v47[Name];

        if not v48 then
            v48 = {};
            v47[Name] = v48;
        end;

        v48[i] = v:GetData();
    end;

    return {
        set = v47
    };
end;

function u26.Clone(p49) -- Line: 215
    -- upvalues: u1 (copy)
    local v50 = u1.new();

    for _, v in pairs(p49._byUID) do
        v50:SetReference(v:GetUID(), v:Clone());
    end;

    return v50;
end;

function u26.ClearReference(p51) -- Line: 225
    for _, v in pairs(p51._byUID) do
        p51:RemoveReference(v);
    end;
end;

function u26.Clear(p52) -- Line: 231
    local v53 = {};

    for _, v in pairs(p52._byUID) do
        p52:RemoveReference(v);
        table.insert(v53, v);
    end;

    return v53;
end;

function u26.Shadow(p54) -- Line: 242
    -- upvalues: ShadowStore (copy)
    return ShadowStore.new(p54);
end;

u26.AddReference = AbstractStore.AddReference;
u26.RemoveReference = AbstractStore.RemoveReference;
u26.SetReference = AbstractStore.SetReference;
u26.Add = AbstractStore.Add;
u26.RemoveExact = AbstractStore.RemoveExact;
u26.RemoveAny = AbstractStore.RemoveAny;
u26.HasExact = AbstractStore.HasExact;
u26.HasAny = AbstractStore.HasAny;
u26.CountExact = AbstractStore.CountExact;
u26.CountAny = AbstractStore.CountAny;
u26.FindExact = AbstractStore.FindExact;
u26.FindAny = AbstractStore.FindAny;

function u1.new(p55, p56) -- Line: 259
    -- upvalues: u26 (copy), Types (copy)
    local v57 = p55 or {};
    local v58 = setmetatable({
        _iteration = 0,
        _size = 0,
        _amount = 0,
        _capacity = nil,
        _byUID = {},
        _byType = {},
        _dataByType = v57,
        IsValid = p56 or function() -- Line: 274
            return true;
        end
    }, {
        __index = u26
    });

    for i, v in pairs(v57) do
        local v59 = Types.TypeUnchecked(i);

        if v59 then
            for i2, v2 in pairs(v) do
                local v60 = v59:From(v2);
                v60:SetUID(i2);
                v60:SetTracked(true);
                v58:SetReference(i2, v60);
            end;
        end;
    end;

    return v58;
end;

return u1;