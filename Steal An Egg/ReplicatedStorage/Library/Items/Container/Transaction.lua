-- Decompiled with Potassium's decompiler.

local Library = game:GetService("ReplicatedStorage"):WaitForChild("Library");
local Items = Library:WaitForChild("Items");
local Functions = require(Library.Functions);
local Asserts = require(Library.Asserts);
local AbstractItem = require(Items.AbstractItem);
local AbstractStore = require(script.Parent:WaitForChild("AbstractStore"));
local ShadowStore = require(script.Parent:WaitForChild("ShadowStore"));
local u1 = {};

function u1.new(p2, p3, p4) -- Line: 11
    -- upvalues: AbstractStore (copy), Asserts (copy), u1 (copy)
    AbstractStore.Assert(p2);
    Asserts.optional.Player(p3);
    local v5 = type(p4) == "function";
    assert(v5, "Commit callback must be a function");

    return setmetatable({
        _commitAttempted = false,
        _commitSuccess = false,
        _store = p2,
        _owner = p3,
        _commitCallback = p4,
        _addedSeen = {},
        _addedItems = {},
        _trackedItems = {},
        _removedItems = {}
    }, {
        __index = u1
    });
end;

function u1.Store(p6) -- Line: 29
    assert(not p6._commitAttempted);

    return p6._store;
end;

function u1.GetType(p7, p8) -- Line: 34
    assert(not p7._commitAttempted);

    return p7._store:GetType(p8.Class.Name);
end;

function u1.Type(p9, p10) -- Line: 39
    assert(not p9._commitAttempted);

    return p9._store:Type(p10.Class.Name);
end;

function u1.Owner(p11) -- Line: 44
    return p11._owner;
end;

function u1.Size(p12) -- Line: 48
    assert(not p12._commitAttempted);

    return p12._store:Size();
end;

function u1.Amount(p13, p14) -- Line: 53
    -- upvalues: AbstractItem (copy)
    assert(not p13._commitAttempted);

    if p14 == nil or p14 == AbstractItem then
        return p13._store:Amount();
    end;

    local v15 = p13._store:GetType(p14.Class.Name);

    return v15 and v15:Amount() or 0;
end;

function u1.IsValid(p16) -- Line: 63
    if p16._commitAttempted then
        return false;
    end;

    return p16._store:IsValid();
end;

function u1.IsCommitAttempted(p17) -- Line: 70
    return p17._commitAttempted;
end;

function u1.IsCommitSuccess(p18) -- Line: 74
    return p18._commitSuccess;
end;

function u1.GetAddedItems(p19) -- Line: 78
    return p19._addedItems;
end;

function u1.GetTrackedItems(p20) -- Line: 82
    return p20._trackedItems;
end;

function u1.GetRemovedItems(p21) -- Line: 86
    return p21._removedItems;
end;

function u1.Get(p22, p23, p24) -- Line: 90
    -- upvalues: AbstractItem (copy)
    assert(not p22._commitAttempted);

    if p24 == nil or p24 == AbstractItem then
        return p22._store:Get(p23);
    end;

    local v25 = p22._store:GetType(p24.Class.Name);

    return v25 and v25:Get(p23) or nil;
end;

function u1.All(p26, p27) -- Line: 100
    -- upvalues: AbstractItem (copy)
    assert(not p26._commitAttempted);

    if p27 == nil or p27 == AbstractItem then
        return p26._store:All();
    end;

    local v28 = p26._store:GetType(p27.Class.Name);

    return v28 and v28:All() or {};
end;

function u1.Each(p29, p30, p31, ...) -- Line: 110
    -- upvalues: AbstractItem (copy)
    assert(not p29._commitAttempted);

    if p30 == nil or p30 == AbstractItem then
        return p29._store:Each(p31, ...);
    end;

    local v32 = p29._store:GetType(p30.Class.Name);

    return v32 and v32:Each(p31, ...) or nil;
end;

function u1.IsEmpty(p33, p34) -- Line: 120
    -- upvalues: AbstractItem (copy)
    assert(not p33._commitAttempted);

    if p34 == nil or p34 == AbstractItem then
        return p33._store:IsEmpty();
    end;

    local v35 = p33._store:GetType(p34.Class.Name);

    return not v35 and true or v35:IsEmpty();
end;

function u1.HasExact(p36, p37) -- Line: 130
    assert(not p36._commitAttempted);

    return p36._store:HasExact(p37);
end;

function u1.HasAny(p38, p39) -- Line: 135
    assert(not p38._commitAttempted);

    return p38._store:HasAny(p39);
end;

function u1.CountExact(p40, p41) -- Line: 140
    assert(not p40._commitAttempted);

    return p40._store:CountExact(p41);
end;

function u1.CountAny(p42, p43) -- Line: 145
    assert(not p42._commitAttempted);

    return p42._store:CountAny(p43);
end;

function u1.CollectExact(p44, ...) -- Line: 150
    -- upvalues: Functions (copy), ShadowStore (copy)
    assert(not p44._commitAttempted);
    local v45 = Functions.SmartPack(...);
    local v46 = ShadowStore.new(p44._store);
    local v47 = {};

    for _, v in ipairs(v45) do
        local v48 = v46:RemoveExact(v);

        if not v48 then
            return nil;
        end;

        table.move(v48, 1, #v48, #v47 + 1, v47);
    end;

    return v47;
end;

function u1.CollectAny(p49, ...) -- Line: 165
    -- upvalues: Functions (copy), ShadowStore (copy)
    assert(not p49._commitAttempted);
    local v50 = Functions.SmartPack(...);
    local v51 = ShadowStore.new(p49._store);
    local v52 = {};

    for _, v in ipairs(v50) do
        local v53 = v51:RemoveAny(v);

        if not v53 then
            return nil;
        end;

        table.move(v53, 1, #v53, #v52 + 1, v52);
    end;

    return v52;
end;

function u1.FindExact(p54, p55) -- Line: 181
    assert(not p54._commitAttempted);

    return p54._store:FindExact(p55);
end;

function u1.FindAny(p56, p57) -- Line: 186
    assert(not p56._commitAttempted);

    return p56._store:FindAny(p57);
end;

function u1.Clear(p58) -- Line: 191
    assert(not p58._commitAttempted);
    local v59 = p58._store:Clear();
    table.move(v59, 1, #v59, #p58._removedItems + 1, p58._removedItems);

    return v59;
end;

local function AddGeneric(p60, p61, p62) -- Line: 198
    assert(not p60._commitAttempted);
    local v63, v64 = p60._store:Add(p61, p60._owner, p62);

    if not v63 then
        return false;
    end;

    local v65 = p61:GetUID();

    if p60._addedSeen[v65] then
        warn(("[DupeDetector] [Transaction.Add] %s %s %s"):format(tostring(p61), debug.traceback(), (tostring(_G.DupeDetectorTraceback))));

        return false;
    end;

    p60._addedSeen[v65] = true;
    table.insert(p60._addedItems, p61);

    if v64 then
        table.insert(p60._trackedItems, p61);
    end;

    return true;
end;

function u1.Add(p66, p67) -- Line: 227
    -- upvalues: AddGeneric (copy)
    return AddGeneric(p66, p67);
end;

function u1.AddRelaxed(p68, p69) -- Line: 231
    -- upvalues: AddGeneric (copy)
    return AddGeneric(p68, p69, true);
end;

function u1.RemoveExact(p70, p71) -- Line: 235
    assert(not p70._commitAttempted);
    local v72 = p70._store:RemoveExact(p71);

    if v72 then
        if not p71:IsExchangeBlacklisted() then
            table.move(v72, 1, #v72, #p70._removedItems + 1, p70._removedItems);

            return v72;
        end;

        for _, v in ipairs(v72) do
            local v73 = v:Clone():SetExchangeBlacklisted(true);
            table.insert(p70._removedItems, v73:Freeze());
        end;
    end;

    return v72;
end;

function u1.RemoveAny(p74, p75) -- Line: 251
    assert(not p74._commitAttempted);
    local v76 = p74._store:RemoveAny(p75);

    if v76 then
        if not p75:IsExchangeBlacklisted() then
            table.move(v76, 1, #v76, #p74._removedItems + 1, p74._removedItems);

            return v76;
        end;

        for _, v in ipairs(v76) do
            local v77 = v:Clone():SetExchangeBlacklisted(true);
            table.insert(p74._removedItems, v77:Freeze());
        end;
    end;

    return v76;
end;

function u1.Commit(p78) -- Line: 267
    assert(not p78._commitAttempted);
    p78._commitAttempted = true;
    local v79 = p78._commitCallback(p78);
    p78._commitSuccess = v79;

    return v79;
end;

return u1;