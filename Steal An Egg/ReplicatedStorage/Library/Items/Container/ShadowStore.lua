-- Decompiled with Potassium's decompiler.

local Library = game:GetService("ReplicatedStorage"):WaitForChild("Library");
local Items = Library:WaitForChild("Items");
local Asserts = require(Library.Asserts);
local Types = require(Items.Types);
local AbstractStore = require(script.Parent.AbstractStore);
local u1 = newproxy();

local function encode(p2, p3) -- Line: 15
    -- upvalues: u1 (copy)
    if p2 == p3 then
        return u1;
    end;

    return p2 or u1;
end;

local function decode(p4, p5) -- Line: 22
    -- upvalues: u1 (copy)
    if not p4 then
        return p5;
    end;

    if p4 == u1 then
        return u1;
    end;

    return p4 or u1;
end;

local u6 = {
    NIL = u1
};
local u33 = {
    Class = "ShadowStoreChild",

    GetIteration = function(p7) -- Line: 38, Name: GetIteration
        return (p7._parentIteration or p7._parent:GetIteration()) + p7._iteration;
    end,

    Size = function(p8) -- Line: 42, Name: Size
        return p8._size + p8._parent:Size();
    end,

    Amount = function(p9) -- Line: 46, Name: Amount
        return p9._amount + p9._parent:Amount();
    end,

    Get = function(p10, p11) -- Line: 50, Name: Get
        -- upvalues: u1 (copy)
        local v12 = p10._byUID[p11];

        if not v12 then
            return p10._parent:Get(p11);
        end;

        if v12 == u1 then
            v12 = nil;
        end;

        return v12;
    end,

    _SetReference = function(p13, p14, p15) -- Line: 61, Name: _SetReference
        -- upvalues: u1 (copy)
        local v16 = p13._parent:Get(p14);
        local v17 = p13._byUID[p14];
        local v18;

        if v17 then
            if v17 == u1 then
                v18 = u1;
            else
                v18 = v17 or u1;
            end;
        else
            v18 = v16;
        end;

        local _size = p13._size;
        local _amount = p13._amount;

        if v18 then
            _size = _size - 1;
            _amount = _amount - v18:GetAmount();
        end;

        if p15 then
            _size = _size + 1;
            _amount = _amount + p15:GetAmount();
        end;

        local v19;

        if p15 == v16 then
            v19 = u1;
        else
            v19 = p15 or u1;
        end;

        p13._size = _size;
        p13._amount = _amount;
        p13._byUID[p14] = v19;

        if not p13._parentIteration then
            p13._parentIteration = p13._parent:GetIteration();
        end;

        p13._iteration = p13._iteration + 1;
    end,

    All = function(p20, p21) -- Line: 88, Name: All
        -- upvalues: u1 (copy)
        local v22 = p20._parent:All(true);

        for i, v in pairs(p20._byUID) do
            if v == u1 or not v then
                local v = nil;
            end;

            v22[i] = v;
        end;

        return v22;
    end,

    Each = function(p23, u24, ...) -- Line: 99, Name: Each
        -- upvalues: u1 (copy)
        local v27 = p23._parent:Each(function(p25, p26, ...) -- Line: 100
            -- upvalues: u24 (copy)
            if not p26[p25:GetUID()] then
                return u24(p25, ...);
            end;
        end, p23._byUID, ...);

        if v27 ~= nil then
            return v27;
        end;

        for _, v in pairs(p23._byUID) do
            if v ~= u1 then
                local v28 = u24(v, ...);

                if v28 ~= nil then
                    return v28;
                end;
            end;
        end;
    end,

    IsEmpty = function(p29) -- Line: 122, Name: IsEmpty
        -- upvalues: u1 (copy)
        for _, v in pairs(p29._byUID) do
            if v ~= u1 then
                return false;
            end;
        end;

        return p29._parent:Each(function(p30, p31) -- Line: 129
            -- upvalues: u1 (ref)
            return p31[p30:GetUID()] ~= u1 and true or nil;
        end, p29._byUID) == nil;
    end,

    Reset = function(p32) -- Line: 134, Name: Reset
        p32._size = 0;
        p32._amount = 0;
        table.clear(p32._byUID);
    end
};
local u34 = {
    Class = "ShadowStoreStack"
};
setmetatable(u34, {
    __index = u33
});

function u34.Reset(p35) -- Line: 147
    -- upvalues: u33 (copy)
    u33.Reset(p35);
end;

function u6.newStack(p36) -- Line: 151
    -- upvalues: u34 (copy)
    return setmetatable({
        _iteration = 0,
        _size = 0,
        _amount = 0,
        _parent = p36,
        _byUID = {}
    }, {
        __index = u34
    });
end;

local u37 = {
    Class = "ShadowStoreType"
};
setmetatable(u37, {
    __index = u33
});

function u37.Stack(p38, p39) -- Line: 171
    -- upvalues: u6 (copy)
    local v40 = p38._byStack[p39];

    if not v40 then
        local v41 = p38._parent:Stack(p39);
        v40 = u6.newStack(v41);
        p38._byStack[p39] = v40;
    end;

    return v40;
end;

function u37.GetStack(p42, p43) -- Line: 181
    -- upvalues: u6 (copy)
    local v44 = p42._byStack[p43];

    if not v44 then
        local v45 = p42._parent:GetStack(p43);

        if v45 then
            v44 = u6.newStack(v45);
            p42._byStack[p43] = v44;
        end;
    end;

    return v44;
end;

function u37.Reset(p46) -- Line: 193
    for _, v in pairs(p46._byStack) do
        v:Reset();
    end;
end;

function u6.newType(p47) -- Line: 199
    -- upvalues: u37 (copy)
    return setmetatable({
        _iteration = 0,
        _size = 0,
        _amount = 0,
        _parent = p47,
        _byUID = {},
        _byStack = {}
    }, {
        __index = u37
    });
end;

local u48 = {
    Class = "ShadowStore"
};
setmetatable(u48, {
    __index = u33
});

function u48.Type(p49, p50) -- Line: 220
    -- upvalues: u6 (copy)
    local v51 = p49._byType[p50];

    if not v51 then
        local v52 = p49._parent:Type(p50);
        v51 = u6.newType(v52);
        p49._byType[p50] = v51;
    end;

    return v51;
end;

function u48.GetType(p53, p54) -- Line: 230
    -- upvalues: u6 (copy)
    local v55 = p53._byType[p54];

    if not v55 then
        local v56 = p53._parent:GetType(p54);

        if v56 then
            v55 = u6.newType(v56);
            p53._byType[p54] = v55;
        end;
    end;

    return v55;
end;

function u48.Capacity(p57) -- Line: 242
    return p57._capacity or p57._parent:Capacity();
end;

function u48.SetCapacity(p58, p59) -- Line: 246
    -- upvalues: Asserts (copy), AbstractStore (copy)
    if p59 ~= nil then
        Asserts.integer(p59);
        assert(p59 <= AbstractStore.HARD_SIZE_CAPACITY);
    end;

    p58._capacity = p59;
end;

function u48.IsValid(p60) -- Line: 255
    local _parentIteration = p60._parentIteration;

    if _parentIteration and p60._parent:GetIteration() ~= _parentIteration then
        return false;
    end;

    return p60._parent:IsValid();
end;

function u48._GetDataContainer(p61, p62) -- Line: 264
    -- upvalues: Types (copy)
    local v63 = p61._dataByType[p62];

    if not v63 then
        Types.AssertTypeName(p62);
        v63 = {};
        p61._dataByType[p62] = v63;
    end;

    return v63;
end;

function u48.GetData(p64, p65, p66) -- Line: 274
    -- upvalues: u1 (copy)
    local v67 = p64:_GetDataContainer(p65)[p66];

    if not v67 then
        return p64._parent:GetData(p65, p66);
    end;

    if v67 == u1 then
        v67 = nil;
    end;

    return v67;
end;

function u48._SetData(p68, p69, p70, p71) -- Line: 285
    -- upvalues: u1 (copy)
    local v72 = p68:_GetDataContainer(p69);
    local v73;

    if p71 == p68._parent:GetData(p69, p70) then
        v73 = u1;
    else
        v73 = p71 or u1;
    end;

    v72[p70] = v73;

    if not p68._parentIteration then
        p68._parentIteration = p68._parent:GetIteration();
    end;

    p68._iteration = p68._iteration + 1;
end;

function u48.GetDataTable(p74) -- Line: 293
    if not next(p74._byUID) then
        return p74._parent:GetDataTable();
    end;

    local v75 = {};
    p74:Each(function(p76, p77) -- Line: 298
        local Name = p76.Class.Name;
        local v78 = p77[Name];

        if not v78 then
            v78 = {};
            p77[Name] = v78;
        end;

        v78[p76:GetUID()] = p76:GetData();
    end, v75);

    return v75;
end;

function u48.Packet(p79) -- Line: 310
    -- upvalues: u1 (copy)
    local _byUID = p79._byUID;
    local v80;

    if next(_byUID) then
        local v81 = {};
        local v82 = {};

        for i, v in pairs(_byUID) do
            if v == u1 then
                table.insert(v81, i);
            else
                local Name = v.Class.Name;
                local v83 = v82[Name];

                if not v83 then
                    v83 = {};
                    v82[Name] = v83;
                end;

                v83[i] = v:GetData();
            end;
        end;

        v80 = {
            set = next(v82) and v82 and v82 or nil,
            del = #v81 > 0 and v81 and v81 or nil
        };
    else
        v80 = nil;
    end;

    return v80;
end;

function u48.Reset(p84) -- Line: 337
    -- upvalues: u33 (copy)
    if next(p84._byUID) then
        p84._parentIteration = nil;
        u33.Reset(p84);

        for _, v in pairs(p84._byType) do
            v:Reset();
        end;

        for _, v in pairs(p84._dataByType) do
            table.clear(v);
        end;
    end;
end;

function u48.ReplicateTo(p85, p86) -- Line: 351
    -- upvalues: u1 (copy)
    for i, v in pairs(p85._byUID) do
        if v == u1 or not v then
            local v = nil;
        end;

        p86:SetReference(i, v);
    end;
end;

function u48.Replicate(p87) -- Line: 360
    return p87:ReplicateTo(p87._parent);
end;

function u48.HasChanges(p88) -- Line: 364
    return next(p88._byUID);
end;

function u48.Clone(p89) -- Line: 368
    -- upvalues: u6 (copy), u1 (copy)
    local v90 = u6.new(p89._parent);

    for i, v in pairs(p89._byUID) do
        local v91;

        if v == u1 then
            v91 = nil;
        else
            v91 = v:Clone() or nil;
        end;

        v90:SetReference(i, v91);
    end;

    return v90;
end;

function u48.Shadow(p92) -- Line: 376
    -- upvalues: u6 (copy)
    return u6.new(p92);
end;

u48.ClearReference = AbstractStore.ClearReference;
u48.AddReference = AbstractStore.AddReference;
u48.RemoveReference = AbstractStore.RemoveReference;
u48.SetReference = AbstractStore.SetReference;
u48.Clear = AbstractStore.Clear;
u48.Add = AbstractStore.Add;
u48.RemoveExact = AbstractStore.RemoveExact;
u48.RemoveAny = AbstractStore.RemoveAny;
u48.HasExact = AbstractStore.HasExact;
u48.HasAny = AbstractStore.HasAny;
u48.CountExact = AbstractStore.CountExact;
u48.CountAny = AbstractStore.CountAny;
u48.FindExact = AbstractStore.FindExact;
u48.FindAny = AbstractStore.FindAny;

function u6.new(p93) -- Line: 395
    -- upvalues: u48 (copy)
    return setmetatable({
        _iteration = 0,
        _parentIteration = nil,
        _size = 0,
        _amount = 0,
        _parent = p93,
        _byUID = {},
        _byType = {},
        _dataByType = {}
    }, {
        __index = u48
    });
end;

return u6;