-- Decompiled with Potassium's decompiler.

local u1 = {};
local Logger = require(script.Parent.Logger);
local Utilities = require(script.Parent.Utilities);

function u1.validateCustomDimensions(p2, p3) -- Line: 6
    -- upvalues: u1 (copy)
    return u1:validateArrayOfStrings(20, 32, false, "custom dimensions", p3);
end;

function u1.validateDimension(p4, p5, p6) -- Line: 10
    -- upvalues: Utilities (copy)
    return Utilities:isStringNullOrEmpty(p6) and true or (Utilities:stringArrayContainsString(p5, p6) and true or false);
end;

function u1.validateResourceCurrencies(p7, p8) -- Line: 23
    -- upvalues: u1 (copy), Logger (copy)
    if not u1:validateArrayOfStrings(20, 64, false, "resource currencies", p8) then
        return false;
    end;

    for _, v in pairs(p8) do
        if not string.find(v, "^[A-Za-z]+$") then
            Logger:w("resource currencies validation failed: a resource currency can only be A-Z, a-z. String was: " .. v);

            return false;
        end;
    end;

    return true;
end;

function u1.validateResourceItemTypes(p9, p10) -- Line: 42
    -- upvalues: u1 (copy), Logger (copy)
    if not u1:validateArrayOfStrings(20, 32, false, "resource item types", p10) then
        return false;
    end;

    for _, v in pairs(p10) do
        if not u1:validateEventPartCharacters(v) then
            Logger:w("resource item types validation failed: a resource item type cannot contain other characters than A-z, 0-9, -_., ()!?. String was: " .. v);

            return false;
        end;
    end;

    return true;
end;

function u1.validateEventPartCharacters(p11, p12) -- Line: 61
    return string.find(p12, "^[A-Za-z0-9%s%-_%.%(%)!%?]+$") and true or false;
end;

function u1.validateArrayOfStrings(p13, p14, p15, p16, p17, p18) -- Line: 69
    -- upvalues: Logger (copy)
    local v19 = p17 or "Array";

    if not p18 then
        Logger:w(v19 .. " validation failed: array cannot be nil.");

        return false;
    end;

    if not p16 and #p18 == 0 then
        Logger:w(v19 .. " validation failed: array cannot be empty.");

        return false;
    end;

    if p14 > 0 and p14 < #p18 then
        Logger:w(v19 .. " validation failed: array cannot exceed " .. tostring(p14) .. " values. It has " .. #p18 .. " values.");

        return false;
    end;

    for _, v in ipairs(p18) do
        local v20 = v and #v or 0;

        if v20 == 0 then
            Logger:w(v19 .. " validation failed: contained an empty string.");

            return false;
        end;

        if p15 > 0 and p15 < v20 then
            Logger:w(v19 .. " validation failed: a string exceeded max allowed length (which is: " .. tostring(p15) .. "). String was: " .. v);

            return false;
        end;
    end;

    return true;
end;

function u1.validateBuild(p21, p22) -- Line: 130
    -- upvalues: u1 (copy)
    return u1:validateShortString(p22, false) and true or false;
end;

function u1.validateShortString(p23, p24, p25) -- Line: 138
    -- upvalues: Utilities (copy)
    return p25 and Utilities:isStringNullOrEmpty(p24) and true or (not Utilities:isStringNullOrEmpty(p24) and #p24 <= 32 and true or false);
end;

function u1.validateKeys(p26, p27, p28) -- Line: 151
    return string.find(p27, "^[A-Za-z0-9]+$") and (#p27 == 32 and (string.find(p28, "^[A-Za-z0-9]+$") and #p28 == 40)) and true or false;
end;

function u1.validateAndCleanInitRequestResponse(p29, p30, p31) -- Line: 161
    -- upvalues: Logger (copy)
    if not p30 then
        Logger:w("validateInitRequestResponse failed - no response dictionary.");

        return nil;
    end;

    local v32 = {};
    local v33 = p30.server_ts or -1;

    if v33 > 0 then
        v32.server_ts = v33;
    end;

    if p31 then
        v32.configs = p30.configs or {};
        v32.ab_id = p30.ab_id or "";
        v32.ab_variant_id = p30.ab_variant_id or "";
    end;

    return v32;
end;

function u1.validateClientTs(p34, p35) -- Line: 185
    return p35 >= 1000000000 and p35 <= 9999999999;
end;

function u1.validateCurrency(p36, p37) -- Line: 193
    -- upvalues: Utilities (copy)
    if Utilities:isStringNullOrEmpty(p37) then
        return false;
    end;

    return string.find(p37, "^[A-Z]+$") and #p37 == 3 and true or false;
end;

function u1.validateEventPartLength(p38, p39, p40) -- Line: 205
    -- upvalues: Utilities (copy)
    if p40 and Utilities:isStringNullOrEmpty(p39) then
        return true;
    end;

    if Utilities:isStringNullOrEmpty(p39) then
        return false;
    end;

    return #p39 ~= 0 and #p39 <= 64;
end;

function u1.validateBusinessEvent(p41, p42, p43, p44, p45, p46) -- Line: 220
    -- upvalues: u1 (copy), Logger (copy)
    if not u1:validateCurrency(p42) then
        Logger:w("Validation fail - business event - currency: Cannot be (null) and need to be A-Z, 3 characters and in the standard at openexchangerates.org. Failed currency: " .. p42);

        return false;
    end;

    if p43 < 0 then
        Logger:w("Validation fail - business event - amount: Cannot be less then 0. Failed amount: " .. p43);

        return false;
    end;

    if not u1:validateShortString(p44, true) then
        Logger:w("Validation fail - business event - cartType. Cannot be above 32 length. String: " .. p44);

        return false;
    end;

    if not u1:validateEventPartLength(p45, false) then
        Logger:w("Validation fail - business event - itemType: Cannot be (null), empty or above 64 characters. String: " .. p45);

        return false;
    end;

    if not u1:validateEventPartCharacters(p45) then
        Logger:w("Validation fail - business event - itemType: Cannot contain other characters than A-z, 0-9, -_., ()!?. String: " .. p45);

        return false;
    end;

    if not u1:validateEventPartLength(p46, false) then
        Logger:w("Validation fail - business event - itemId. Cannot be (null), empty or above 64 characters. String: " .. p46);

        return false;
    end;

    if u1:validateEventPartCharacters(p46) then
        return true;
    end;

    Logger:w("Validation fail - business event - itemId: Cannot contain other characters than A-z, 0-9, -_., ()!?. String: " .. p46);

    return false;
end;

function u1.validateResourceEvent(p47, p48, p49, p50, p51, p52, p53, p54, p55) -- Line: 279
    -- upvalues: Logger (copy), Utilities (copy), u1 (copy)
    if p49 ~= p48.Source and p49 ~= p48.Sink then
        Logger:w("Validation fail - resource event - flowType: Invalid flow type " .. tostring(p49));

        return false;
    end;

    if Utilities:isStringNullOrEmpty(p50) then
        Logger:w("Validation fail - resource event - currency: Cannot be (null)");

        return false;
    end;

    if not Utilities:stringArrayContainsString(p54, p50) then
        Logger:w("Validation fail - resource event - currency: Not found in list of pre-defined available resource currencies. String: " .. p50);

        return false;
    end;

    if p51 <= 0 then
        Logger:w("Validation fail - resource event - amount: Float amount cannot be 0 or negative. Value: " .. tostring(p51));

        return false;
    end;

    if Utilities:isStringNullOrEmpty(p52) then
        Logger:w("Validation fail - resource event - itemType: Cannot be (null)");

        return false;
    end;

    if not u1:validateEventPartLength(p52, false) then
        Logger:w("Validation fail - resource event - itemType: Cannot be (null), empty or above 64 characters. String: " .. p52);

        return false;
    end;

    if not u1:validateEventPartCharacters(p52) then
        Logger:w("Validation fail - resource event - itemType: Cannot contain other characters than A-z, 0-9, -_., ()!?. String: " .. p52);

        return false;
    end;

    if not Utilities:stringArrayContainsString(p55, p52) then
        Logger:w("Validation fail - resource event - itemType: Not found in list of pre-defined available resource itemTypes. String: " .. p52);

        return false;
    end;

    if not u1:validateEventPartLength(p53, false) then
        Logger:w("Validation fail - resource event - itemId: Cannot be (null), empty or above 64 characters. String: " .. p53);

        return false;
    end;

    if u1:validateEventPartCharacters(p53) then
        return true;
    end;

    Logger:w("Validation fail - resource event - itemId: Cannot contain other characters than A-z, 0-9, -_., ()!?. String: " .. p53);

    return false;
end;

function u1.validateProgressionEvent(p56, p57, p58, p59, p60, p61) -- Line: 363
    -- upvalues: Logger (copy), Utilities (copy), u1 (copy)
    if p58 ~= p57.Start and (p58 ~= p57.Complete and p58 ~= p57.Fail) then
        Logger:w("Validation fail - progression event: Invalid progression status " .. tostring(p58));

        return false;
    end;

    if not Utilities:isStringNullOrEmpty(p61) and (Utilities:isStringNullOrEmpty(p60) and not Utilities:isStringNullOrEmpty(p59)) then
        Logger:w("Validation fail - progression event: 03 found but 01+02 are invalid. Progression must be set as either 01, 01+02 or 01+02+03.");

        return false;
    end;

    if not Utilities:isStringNullOrEmpty(p60) and Utilities:isStringNullOrEmpty(p59) then
        Logger:w("Validation fail - progression event: 02 found but not 01. Progression must be set as either 01, 01+02 or 01+02+03");

        return false;
    end;

    if Utilities:isStringNullOrEmpty(p59) then
        Logger:w("Validation fail - progression event: progression01 not valid. Progressions must be set as either 01, 01+02 or 01+02+03");

        return false;
    end;

    if not u1:validateEventPartLength(p59, false) then
        Logger:w("Validation fail - progression event - progression01: Cannot be (null), empty or above 64 characters. String: " .. p59);

        return false;
    end;

    if not u1:validateEventPartCharacters(p59) then
        Logger:w("Validation fail - progression event - progression01: Cannot contain other characters than A-z, 0-9, -_., ()!?. String: " .. p59);

        return false;
    end;

    if not Utilities:isStringNullOrEmpty(p60) then
        if not u1:validateEventPartLength(p60, false) then
            Logger:w("Validation fail - progression event - progression02: Cannot be empty or above 64 characters. String: " .. p60);

            return false;
        end;

        if not u1:validateEventPartCharacters(p60) then
            Logger:w("Validation fail - progression event - progression02: Cannot contain other characters than A-z, 0-9, -_., ()!?. String: " .. p60);

            return false;
        end;
    end;

    if not Utilities:isStringNullOrEmpty(p61) then
        if not u1:validateEventPartLength(p61, false) then
            Logger:w("Validation fail - progression event - progression03: Cannot be empty or above 64 characters. String: " .. p61);

            return false;
        end;

        if not u1:validateEventPartCharacters(p61) then
            Logger:w("Validation fail - progression event - progression03: Cannot contain other characters than A-z, 0-9, -_., ()!?. String: " .. p61);

            return false;
        end;
    end;

    return true;
end;

function u1.validateEventIdLength(p62, p63) -- Line: 458
    -- upvalues: Utilities (copy)
    if Utilities:isStringNullOrEmpty(p63) then
        return false;
    end;

    local v64 = 0;

    for i in string.gmatch(p63, "([^:]+)") do
        v64 = v64 + 1;

        if v64 > 5 or #i > 64 then
            return false;
        end;
    end;

    return true;
end;

function u1.validateEventIdCharacters(p65, p66) -- Line: 474
    -- upvalues: Utilities (copy)
    if Utilities:isStringNullOrEmpty(p66) then
        return false;
    end;

    local v67 = 0;

    for i in string.gmatch(p66, "([^:]+)") do
        v67 = v67 + 1;

        if v67 > 5 or not string.find(i, "^[A-Za-z0-9%s%-_%.%(%)!%?]+$") then
            return false;
        end;
    end;

    return true;
end;

function u1.validateDesignEvent(p68, p69) -- Line: 490
    -- upvalues: u1 (copy), Logger (copy)
    if not u1:validateEventIdLength(p69) then
        Logger:w("Validation fail - design event - eventId: Cannot be (null) or empty. Only 5 event parts allowed seperated by :. Each part need to be 32 characters or less. String: " .. p69);

        return false;
    end;

    if u1:validateEventIdCharacters(p69) then
        return true;
    end;

    Logger:w("Validation fail - design event - eventId: Non valid characters. Only allowed A-z, 0-9, -_., ()!?. String: " .. p69);

    return false;
end;

function u1.validateLongString(p70, p71, p72) -- Line: 511
    -- upvalues: Utilities (copy)
    return p72 and Utilities:isStringNullOrEmpty(p71) and true or (not Utilities:isStringNullOrEmpty(p71) and #p71 <= 8192 and true or false);
end;

function u1.validateErrorEvent(p73, p74, p75, p76) -- Line: 524
    -- upvalues: Logger (copy), u1 (copy)
    if p75 ~= p74.debug and (p75 ~= p74.info and (p75 ~= p74.warning and (p75 ~= p74.error and p75 ~= p74.critical))) then
        Logger:w("Validation fail - error event - severity: Severity was unsupported value " .. tostring(p75));

        return false;
    end;

    if u1:validateLongString(p76, true) then
        return true;
    end;

    Logger:w("Validation fail - error event - message: Message cannot be above 8192 characters.");

    return false;
end;

return u1;