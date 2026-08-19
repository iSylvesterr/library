-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Interface = require(script.Types.Interface);
local Currency = require(ReplicatedStorage.Library.Types.Currency);
local v30 = {
    __types = Interface,

    Validate = function(p1, p2) -- Line: 26, Name: Validate
        -- upvalues: Currency (copy)
        return Currency.SchemaValidation.AllCurrencyTypes(p2.Currency) == true;
    end,

    EnsureItemValid = function(p3, p4) -- Line: 34, Name: EnsureItemValid
        local v5 = p3:Validate(p4);
        local v6 = ("%s is not a valid item."):format(p3:GetName(p4));
        assert(v5, v6);
    end,

    GetName = function(p7, p8) -- Line: 44, Name: GetName
        return p8.Currency or "Unknown";
    end,

    GetDescription = function(p9, p10) -- Line: 52, Name: GetDescription
        return "";
    end,

    CanBeBoosted = function(p11, p12) -- Line: 60, Name: CanBeBoosted
        error("not used");
    end,

    GetValue = function(p13, p14) -- Line: 68, Name: GetValue
        p13:EnsureItemValid(p14);

        return 1;
    end,

    GetAmount = function(p15, p16) -- Line: 77, Name: GetAmount
        p15:EnsureItemValid(p16);

        return p16.Amount or 1;
    end,

    SetAmount = function(p17, p18, p19) -- Line: 86, Name: SetAmount
        -- upvalues: Asserts (copy)
        Asserts.number(p19);
        p17:EnsureItemValid(p18);
        p18.Amount = p19;
    end,

    GetOwnedAmount = function(p20, p21, p22) -- Line: 98, Name: GetOwnedAmount
        p20:EnsureItemValid(p22);

        return p21[p22.Currency or ""] or 0;
    end,

    CanAfford = function(p23, p24, p25) -- Line: 108, Name: CanAfford
        p23:EnsureItemValid(p25);

        return p23:GetOwnedAmount(p24, p25) >= p23:GetAmount(p25);
    end,

    Compare = function(p26, p27, p28, p29) -- Line: 119, Name: Compare
        if p29 and p27.Amount ~= p28.Amount then
            return false;
        end;

        return p27.Currency == p28.Currency;
    end
};

local function ModifyStats(p31, p32, p33, p34) -- Line: 133
    -- upvalues: Asserts (copy), Interface (copy)
    Asserts.table(p31);
    Asserts.number(p33);
    local Currency2 = p32.Currency;
    assert(Interface.AvailableCurrencies(p32.Currency));
    local v35 = p31[Currency2];
    local v36 = `Player stats do not contain currency: {p32.Currency}`;
    assert(v35, v36);
    p31[Currency2] = p31[Currency2] + p33;

    return Currency2, p31[Currency2];
end;

function v30.Deduct(p37, p38, p39, p40) -- Line: 152
    -- upvalues: ModifyStats (copy)
    if p37:Validate(p39) then
        local v41 = p37:GetAmount(p39);

        if v41 <= p37:GetOwnedAmount(p38, p39) then
            return ModifyStats(p38, p39, -v41, p40);
        end;
    end;

    return nil;
end;

function v30.Add(p42, p43, p44, p45) -- Line: 167
    -- upvalues: ModifyStats (copy)
    if p42:Validate(p44) then
        return ModifyStats(p43, p44, p42:GetAmount(p44), p45);
    end;

    return nil;
end;

function v30.Split(p46, p47, p48) -- Line: 179
    local v49 = p47.Amount or 0;

    if v49 <= p48 then
        return { p47 };
    end;

    local v50 = math.min(v49, p48);
    local v51 = math.floor(v49 / v50);
    local v52 = table.create(v50, v51);

    for i = 1, v49 - v51 * v50 do
        v52[i] = v52[i] + 1;
    end;

    local v53 = {};

    for _, v in ipairs(v52) do
        local v54 = table.clone(p47);
        v54.Amount = v;
        table.insert(v53, v54);
    end;

    return v53;
end;

function v30.Combine(p55, p56) -- Line: 208
    local v57 = {};
    local v58 = {};

    for _, v in ipairs(p56) do
        local v59 = p55:GetName(v);

        if v57[v59] then
            local v60 = v57[v59];
            v60.Amount = v60.Amount + p55:GetAmount(v);
        else
            local v61 = table.clone(v);
            v61.Amount = p55:GetAmount(v61);
            v57[v59] = v61;
        end;
    end;

    local v62 = {};

    for _, v in pairs(v57) do
        table.insert(v62, v);
    end;

    for _, v in ipairs(v58) do
        table.insert(v62, v);
    end;

    return v62;
end;

return v30;