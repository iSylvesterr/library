-- Decompiled with Potassium's decompiler.

local Library = game:GetService("ReplicatedStorage"):WaitForChild("Library");
local Items = Library:WaitForChild("Items");
local Modules = Library:WaitForChild("Modules");
local Asserts = require(Library.Asserts);
local Functions = require(Library.Functions);
local Event = require(Modules.Event);
local Types = require(Items:WaitForChild("Types"));
local AbstractItem = require(Items.AbstractItem);
local AbstractStore = require(script.AbstractStore);
local SimpleStore = require(script.SimpleStore);
local ShadowStore = require(script.ShadowStore);
local Transaction = require(script.Transaction);
local u1 = {};

function u1.new(p2, p3) -- Line: 20
    -- upvalues: AbstractStore (copy), Asserts (copy), SimpleStore (copy), Event (copy), u1 (copy)
    AbstractStore.AssertOptional(p2);
    Asserts.optional.Player(p3);
    local v4 = {
        _store = p2 or SimpleStore.new(),
        _owner = p3,
        Added = Event.new(),
        Removed = Event.new(),
        Deleted = Event.new(),
        Tracked = Event.new(),
        Updated = Event.new()
    };

    return setmetatable(v4, {
        __index = u1
    });
end;

function u1.IsA(p5) -- Line: 37
    -- upvalues: u1 (copy)
    if typeof(p5) == "table" then
        local v6 = getmetatable(p5);
        local v7;

        if typeof(v6) == "table" then
            v7 = v6.__index == u1;
        else
            v7 = false;
        end;

        return v7;
    end;
end;

function u1.Destroy(p8) -- Line: 47
    -- upvalues: Event (copy)
    for _, v in p8 do
        if Event.IsA(v) then
            v:Destroy();
        end;
    end;

    table.clear(p8);
    setmetatable(p8, nil);
end;

function u1.Clone(p9) -- Line: 59
    -- upvalues: u1 (copy)
    return u1.new(p9._store:Clone(), p9._owner);
end;

function u1.UpdatedCallback(u10, u11, ...) -- Line: 63
    -- upvalues: Functions (copy), AbstractItem (copy)
    local u12 = Functions.SmartPack(...);
    assert(#u12 > 0, "UpdatedCallback requires at least one item type");
    local u13 = {};

    for _, v in ipairs(u12) do
        AbstractItem.AssertModule(v);
        u13[v] = u10:Type(v):GetIteration();
    end;

    return u10.Updated:Connect(function(p14) -- Line: 73
        -- upvalues: u12 (copy), u10 (copy), u13 (copy), u11 (copy)
        local v15 = false;

        for _, v in ipairs(u12) do
            local v16 = u10:Type(v):GetIteration();

            if u13[v] ~= v16 then
                u13[v] = v16;
                v15 = true;
            end;
        end;

        if v15 then
            u11(p14);
        end;
    end);
end;

function u1.FireDeleted(p17, p18, p19) -- Line: 89
    if not p19 then
        warn("MissingItemDeletionTag", debug.traceback());
    end;

    p17.Deleted:FireAsync({
        { p18, p19 }
    });

    return p17;
end;

function u1.Capacity(p20) -- Line: 98
    return p20._store:Capacity();
end;

function u1.SetCapacity(p21, p22) -- Line: 102
    p21._store:SetCapacity(p22);

    return p21;
end;

function u1.Transact(u23) -- Line: 107
    -- upvalues: ShadowStore (copy), Transaction (copy)
    local u24 = ShadowStore.new(u23._store);

    return Transaction.new(u24, u23._owner, function(p25) -- Line: 109
        -- upvalues: u24 (copy), u23 (copy)
        if not u24:IsValid() then
            return false;
        end;

        if u24:HasChanges() then
            u24:Replicate();
            u23.Updated:FireAsync(u24);
            local v26 = p25._addedItems or {};

            if #v26 > 0 then
                u23.Added:FireAsync(v26);
            end;

            local v27 = p25._trackedItems or {};

            if #v27 > 0 then
                u23.Tracked:FireAsync(v27);
            end;

            local v28 = p25._removedItems or {};

            if #v28 > 0 then
                u23.Removed:FireAsync(v28);
            end;

            local v29 = p25._deletedItems or {};

            if #v29 > 0 then
                u23.Deleted:FireAsync(v29);
            end;
        end;

        return true;
    end);
end;

function u1.Store(p30) -- Line: 139
    return p30._store;
end;

function u1.GetDataTable(p31) -- Line: 143
    return p31._store:GetDataTable();
end;

function u1.GetType(p32, p33) -- Line: 147
    return p32._store:GetType(p33.Class.Name);
end;

function u1.Type(p34, p35) -- Line: 151
    return p34._store:Type(p35.Class.Name);
end;

function u1.Owner(p36) -- Line: 155
    return p36._owner;
end;

function u1.Size(p37) -- Line: 159
    return p37._store:Size();
end;

function u1.Amount(p38, p39) -- Line: 163
    -- upvalues: AbstractItem (copy)
    if p39 == nil or p39 == AbstractItem then
        return p38._store:Amount();
    end;

    local v40 = p38._store:GetType(p39.Class.Name);

    return not v40 and 0 or v40:Amount();
end;

function u1.IsValid(p41) -- Line: 176
    return p41._store:IsValid();
end;

function u1.Get(p42, p43, p44) -- Line: 180
    -- upvalues: AbstractItem (copy)
    if p44 == nil or p44 == AbstractItem then
        return p42._store:Get(p43);
    end;

    local v45 = p42._store:GetType(p44.Class.Name);

    if v45 then
        return v45:Get(p43);
    end;

    return nil;
end;

function u1.All(p46, p47) -- Line: 193
    -- upvalues: AbstractItem (copy)
    if p47 == nil or p47 == AbstractItem then
        return p46._store:All();
    end;

    local v48 = p46._store:GetType(p47.Class.Name);

    return not v48 and {} or v48:All();
end;

function u1.Each(p49, p50, p51, ...) -- Line: 206
    -- upvalues: AbstractItem (copy)
    local v52 = nil;

    if p50 == nil or p50 == AbstractItem then
        v52 = p49._store:Each(p51, ...);
    else
        local v53 = p49._store:GetType(p50.Class.Name);

        if v53 then
            return v53:Each(p51, ...);
        end;
    end;

    return v52;
end;

function u1.IsEmpty(p54, p55) -- Line: 219
    -- upvalues: AbstractItem (copy)
    if p55 == nil or p55 == AbstractItem then
        return p54._store:IsEmpty();
    end;

    local v56 = p54._store:GetType(p55.Class.Name);

    return not v56 and true or v56:IsEmpty();
end;

function u1.HasExact(p57, p58) -- Line: 232
    return p57._store:HasExact(p58);
end;

function u1.HasAny(p59, p60) -- Line: 236
    return p59._store:HasAny(p60);
end;

function u1.CountExact(p61, p62) -- Line: 240
    return p61._store:CountExact(p62);
end;

function u1.CountAny(p63, p64) -- Line: 244
    return p63._store:CountAny(p64);
end;

function u1.FindExact(p65, p66) -- Line: 248
    return p65._store:FindExact(p66);
end;

function u1.FindAny(p67, p68) -- Line: 252
    return p67._store:FindAny(p68);
end;

function u1.CollectExact(p69, ...) -- Line: 256
    -- upvalues: Functions (copy), ShadowStore (copy)
    local v70 = Functions.SmartPack(...);
    local v71 = ShadowStore.new(p69._store);
    local v72 = {};

    for _, v in ipairs(v70) do
        local v73 = v71:RemoveExact(v);

        if not v73 then
            return nil;
        end;

        table.move(v73, 1, #v73, #v72 + 1, v72);
    end;

    return v72;
end;

function u1.CollectAny(p74, ...) -- Line: 273
    -- upvalues: Functions (copy), ShadowStore (copy)
    local v75 = Functions.SmartPack(...);
    local v76 = ShadowStore.new(p74._store);
    local v77 = {};

    for _, v in ipairs(v75) do
        local v78 = v76:RemoveAny(v);

        if not v78 then
            return nil;
        end;

        table.move(v78, 1, #v78, #v77 + 1, v77);
    end;

    return v77;
end;

function u1.Clear(p79, p80, p81) -- Line: 288
    local v82 = p79:Transact();
    v82:Clear(p80, p81);

    return v82:Commit();
end;

function u1.Add(p83, p84) -- Line: 294
    local v85 = p83:Transact();

    if v85:Add(p84) then
        return v85:Commit();
    end;

    return false;
end;

function u1.AddRelaxed(p86, p87) -- Line: 303
    local v88 = p86:Transact();

    if v88:AddRelaxed(p87) then
        return v88:Commit();
    end;

    return false;
end;

function u1.RemoveExact(p89, p90) -- Line: 312
    local v91 = p89:Transact();

    if not v91:RemoveExact(p90) then
        return nil;
    end;

    if v91:Commit() then
        return v91._removedItems;
    end;

    return nil;
end;

function u1.RemoveAny(p92, p93) -- Line: 323
    local v94 = p92:Transact();

    if not v94:RemoveAny(p93) then
        return nil;
    end;

    if v94:Commit() then
        return v94._removedItems;
    end;

    return nil;
end;

function u1.ApplyPacket(p95, p96) -- Line: 334
    -- upvalues: Asserts (copy), ShadowStore (copy), Types (copy)
    Asserts.table(p96);

    if not p95:IsValid() then
        return false;
    end;

    local v97 = {};
    local v98 = {};
    local v99 = ShadowStore.new(p95._store);

    if p96.del then
        for _, v in ipairs(p96.del) do
            local v100 = v99:Get(v);

            if v100 then
                v99:SetReference(v, nil);
                table.insert(v97, v100);
            end;
        end;
    end;

    if p96.set then
        for i, v in pairs(p96.set) do
            local v101 = Types.TypeUnchecked(i);

            if v101 then
                for i2, v2 in pairs(v) do
                    local v102 = v101:From(v2);
                    v102:SetUID(i2);
                    v102:SetTracked(true);
                    local v103 = v99:Get(i2);

                    if v103 then
                        table.insert(v97, v103);
                    end;

                    v99:SetReference(i2, v102);
                    table.insert(v98, v102);
                end;
            end;
        end;
    end;

    if v99:HasChanges() then
        v99:Replicate();
        p95.Updated:FireAsync(v99);

        if #v97 > 0 then
            p95.Removed:FireAsync(v97);
        end;

        if #v98 > 0 then
            p95.Added:FireAsync(v98);
        end;
    end;

    return true;
end;

return u1;