-- Decompiled with Potassium's decompiler.

local Items = game:GetService("ReplicatedStorage"):WaitForChild("Library"):WaitForChild("Items");
local AbstractItem = require(Items.AbstractItem);
local u18 = {
    HARD_AMOUNT_CAPACITY = 1e300,
    DEFAULT_SIZE_CAPACITY = 1000000000000000,
    HARD_SIZE_CAPACITY = 1000000000000000,

    Assert = function(p1) -- Line: 11, Name: Assert
        assert(p1.IsValid);
    end,

    AssertOptional = function(p2) -- Line: 15, Name: AssertOptional
        assert(p2 == nil and true or p2.IsValid);
    end,

    ClearReference = function(u3) -- Line: 20, Name: ClearReference
        u3:Each(function(p4) -- Line: 21
            -- upvalues: u3 (copy)
            u3:RemoveReference(p4);
        end);
    end,

    SetReference = function(p5, p6, p7) -- Line: 26, Name: SetReference
        local v8 = p5:Get(p6);

        if not p7 then
            if v8 then
                local Name = v8.Class.Name;
                p5:_SetData(Name, p6, nil);
                p5:_SetReference(p6, nil);
                local v9 = p5:GetType(Name);

                if v9 then
                    v9:_SetReference(p6, nil);
                    local v10 = v9:GetStack(v8:StackKey());

                    if v10 then
                        v10:_SetReference(p6, nil);
                    end;
                end;
            end;

            return;
        end;

        local Class = p7.Class;
        local Name = Class.Name;
        local v11 = p7:StackKey();
        local v12 = p5:Type(Name);
        local v13 = v12:Stack(v11);

        if v8 then
            local v14 = v8:StackKey();

            if Class == v8.Class then
                local v15 = v12:GetStack(v14);

                if v15 and v13 ~= v15 then
                    v15:_SetReference(p6, nil);
                end;
            else
                local Name2 = v8.Class.Name;
                p5:_SetData(Name2, p6, nil);
                local v16 = p5:GetType(Name2);

                if v16 then
                    v16:_SetReference(p6, nil);
                    local v17 = v16:GetStack(v14);

                    if v17 and v13 ~= v17 then
                        v17:_SetReference(p6, nil);
                    end;
                end;
            end;
        end;

        p5:_SetData(Name, p6, p7:GetData());
        p5:_SetReference(p6, p7);
        v12:_SetReference(p6, p7);
        v13:_SetReference(p6, p7);
    end
};

function u18.AddReference(p19, p20) -- Line: 75
    -- upvalues: u18 (copy)
    local v21 = p20:GetUID();

    if (p19:Capacity() or u18.DEFAULT_SIZE_CAPACITY) <= p19:Size() then
        return false;
    end;

    if p19:Get(v21) then
        return false;
    end;

    p19:SetReference(v21, p20);

    return true;
end;

function u18.RemoveReference(p22, p23) -- Line: 87
    local v24 = p23:GetUID();

    if p22:Get(v24) ~= p23 then
        return false;
    end;

    p22:SetReference(v24, nil);

    return true;
end;

function u18.Clear(u25) -- Line: 96
    local v26 = {};
    u25:Each(function(p27, p28) -- Line: 98
        -- upvalues: u25 (copy)
        u25:RemoveReference(p27);
        table.insert(p28, p27);
    end, v26);

    return v26;
end;

function u18.Add(p29, u30, p31, p32) -- Line: 105
    -- upvalues: AbstractItem (copy), u18 (copy)
    AbstractItem:Assert(u30);
    local v33;

    if p31 == nil then
        v33 = true;
    elseif typeof(p31) == "Instance" then
        v33 = p31.ClassName == "Player";
    else
        v33 = false;
    end;

    assert(v33, "Provided owner is not a valid instance class.");
    local v34 = p32 == nil and true or type(p32) == "boolean";
    assert(v34, "Provided flag is not a boolean.");
    local v35 = u30:IsTracked();

    if not v35 then
        if not u30:GetTag() then
            warn("Missing item tag:", u30, debug.traceback());
        end;

        u30:SetTracked(true);
    end;

    local v36;

    if v35 then
        v36 = u30.TrackingEnabled and true or false;
    else
        v36 = false;
    end;

    u30:Populate(p31, u30:PopulateUID(), v36);
    local v37 = u30:GetAmount();
    assert(v37 > 0, "Expected amount to be greater than 0");
    local v38 = u30:GetMaxAmount();
    local v39 = v37 <= math.min(v38, u18.HARD_AMOUNT_CAPACITY);
    assert(v39, "Amount exceeds the allowed maximum capacity.");
    u30:Freeze();
    local v40 = u30:GetUID();

    if p29:Get(v40) then
        warn(`[DupeDetector] [AbstractStore.Add] {u30} {debug.traceback()} {_G.DupeDetectorTraceback}`);

        return false, false, v37;
    end;

    local v41 = {};
    local v42 = p29:Type(u30.Class.Name);
    local v43, v44, v45;

    if v42 then
        local v46 = u18.HARD_AMOUNT_CAPACITY - v42:Amount();
        v43 = math.min(v37, v46);

        if v37 ~= v43 and not p32 then
            return false, false, v37;
        end;

        v44 = v42:GetStack(u30:StackKey());

        if v44 then
            local v47 = u18.HARD_AMOUNT_CAPACITY - v44:Amount();
            v43 = math.min(v43, v47);

            if v37 ~= v43 and not p32 then
                return false, false, v37;
            end;

            if u30:IsStackable() then
                local v48 = {};
                v44:Each(function(p49, p50) -- Line: 164
                    -- upvalues: u30 (copy)
                    if p49:GetAmount() < p49:GetMaxAmount() and p49:IsLikeExact(u30) then
                        table.insert(p50, p49);
                    end;
                end, v48);
                table.sort(v48, function(p51, p52) -- Line: 170
                    return p51:GetAmount() < p52:GetAmount();
                end);
                v45 = v37;
                local v53 = 1;

                while v43 > 0 and #v48 >= v53 do
                    local v54 = v48[v53];
                    v53 = v53 + 1;
                    local v55 = v54:GetAmount();
                    local v56 = v54:GetMaxAmount() - v55;
                    local v57 = math.min(v56, v43);

                    if v57 > 0 then
                        v37 = v37 - v57;
                        v43 = v43 - v57;
                        local v58 = v54:Clone();
                        v58:SetAmount(v55 + v57);
                        local pack = table.pack;
                        local v59 = v54:GetUID();
                        table.insert(v41, pack(v59, v58));
                    end;
                end;
            else
                v45 = v37;
            end;
        else
            v45 = v37;
        end;
    else
        v43 = v37;
        v45 = v43;
        local v60 = v43;
        v43 = v45;
        v60 = v45;
        v44 = nil;
    end;

    if v43 > 0 then
        local v61 = (v44 and v44:Size() or 0) >= u30.StackLimit and 0 or v43;
        local v62 = (v42 and v42:Size() or 0) >= u30.TypeStackLimit and 0 or v61;
        local v63 = (p29:Capacity() or u18.DEFAULT_SIZE_CAPACITY) <= p29:Size() and 0 or v62;

        if v63 > 0 then
            if v63 ~= v45 then
                u30:Clone():SetAmount(v63);
            end;

            table.insert(v41, table.pack(v40, u30));
            v37 = v37 - v63;
        end;
    end;

    if v37 > 0 and not p32 then
        return false, false, v37;
    end;

    for _, v in ipairs(v41) do
        p29:SetReference(table.unpack(v));
    end;

    return true, v36, v37;
end;

function SubtractItem(p64, p65, p66, p67, p68, p69)
    if p66:IsLocked() and not p65:IsLocked() then
        return p67;
    end;

    local v70 = p66:GetAmount();
    local v71 = math.min(v70, p67);

    if v71 > 0 then
        local v72 = v70 - v71;
        local v73, v74;

        if v72 > 0 then
            v73 = p66:Clone();
            v73:SetAmount(v72);
            v74 = p66:Clone();
            v74:SetAmount(v71);
            v74:StripUID();
            v74:Freeze();
        else
            v74 = p66;
            v73 = nil;
        end;

        local pack = table.pack;
        local v75 = p66:GetUID();
        table.insert(p69, pack(v75, v73));
        table.insert(p68, v74);
        p67 = p67 - v71;
    end;

    return p67;
end;

function RemoveGeneric(p76, u77, u78)
    -- upvalues: AbstractItem (copy), u18 (copy)
    AbstractItem:Assert(u77);
    local v79 = {};
    local v80 = u77:GetAmount();
    assert(v80 > 0);
    local v81 = u77:GetMaxAmount();
    local v82 = v80 <= math.min(v81, u18.HARD_AMOUNT_CAPACITY);
    assert(v82);
    local v83 = {};
    local v84 = u77:GetOptionalUID();
    local v85;

    if v84 then
        v85 = p76:Get(v84);

        if v85 then
            if u78 and v85:IsLikeAny(u77) or v85:IsLikeExact(u77) then
                v80 = SubtractItem(p76, u77, v85, v80, v79, v83);
            else
                v85 = nil;
            end;
        end;
    else
        v85 = nil;
    end;

    if v80 > 0 then
        local v86 = p76:GetType(u77.Class.Name);

        if v86 then
            local v87 = v86:GetStack(u77:StackKey());

            if v87 then
                local v88 = {};
                v87:Each(function(p89, p90, p91) -- Line: 303
                    -- upvalues: u78 (copy), u77 (copy)
                    if p89 == p91 then
                        return;
                    end;

                    if u78 or p89:IsLikeExact(u77) then
                        table.insert(p90, p89);
                    end;
                end, v88, v85);
                table.sort(v88, function(p92, p93) -- Line: 310
                    return p92:GetAmount() > p93:GetAmount();
                end);
                local v94 = 1;

                while v80 > 0 and #v88 >= v94 do
                    local v95 = v88[v94];
                    v94 = v94 + 1;
                    v80 = SubtractItem(p76, u77, v95, v80, v79, v83);
                end;
            end;
        end;
    end;

    if v80 > 0 then
        return nil;
    end;

    for _, v in ipairs(v83) do
        p76:SetReference(table.unpack(v));
    end;

    return v79;
end;

function u18.RemoveExact(p96, p97) -- Line: 335
    return RemoveGeneric(p96, p97, false);
end;

function u18.RemoveAny(p98, p99) -- Line: 339
    return RemoveGeneric(p98, p99, true);
end;

function HasGeneric(p100, u101, u102)
    -- upvalues: AbstractItem (copy)
    AbstractItem:Assert(u101);
    local u103 = u101:GetAmount();
    local v104 = p100:GetType(u101.Class.Name);

    if v104 then
        v104 = v104:GetStack(u101:StackKey());
    end;

    if v104 then
        v104:Each(function(p105) -- Line: 349
            -- upvalues: u102 (copy), u101 (copy), u103 (ref)
            if u102 or p105:IsLikeExact(u101) then
                local v106 = p105:GetAmount();
                u103 = u103 - math.min(v106, u103);

                if u103 <= 0 then
                    return true;
                end;
            end;
        end);
    end;

    return u103 <= 0;
end;

function u18.HasExact(p107, p108) -- Line: 361
    return HasGeneric(p107, p108, false);
end;

function u18.HasAny(p109, p110) -- Line: 365
    return HasGeneric(p109, p110, true);
end;

function CountGeneric(p111, u112, u113)
    -- upvalues: AbstractItem (copy)
    AbstractItem:Assert(u112);
    local u114 = 0;
    local v115 = p111:GetType(u112.Class.Name);

    if v115 then
        v115 = v115:GetStack(u112:StackKey());
    end;

    if v115 then
        v115:Each(function(p116) -- Line: 375
            -- upvalues: u113 (copy), u112 (copy), u114 (ref)
            if u113 or p116:IsLikeExact(u112) then
                u114 = u114 + p116:GetAmount();
            end;
        end);
    end;

    return u114;
end;

function u18.CountExact(p117, p118) -- Line: 384
    return CountGeneric(p117, p118, false);
end;

function u18.CountAny(p119, p120) -- Line: 388
    return CountGeneric(p119, p120, true);
end;

function FindGeneric(p121, u122, u123)
    -- upvalues: AbstractItem (copy)
    AbstractItem:Assert(u122);
    local u124 = {};
    local v125 = p121:GetType(u122.Class.Name);

    if v125 then
        v125 = v125:GetStack(u122:StackKey());
    end;

    if v125 then
        v125:Each(function(p126) -- Line: 398
            -- upvalues: u123 (copy), u122 (copy), u124 (copy)
            if u123 or p126:IsLikeExact(u122) then
                table.insert(u124, p126);
            end;
        end);
    end;

    return u124;
end;

function u18.FindExact(p127, p128) -- Line: 407
    return FindGeneric(p127, p128, false);
end;

function u18.FindAny(p129, p130) -- Line: 411
    return FindGeneric(p129, p130, true);
end;

return u18;