-- Decompiled with Potassium's decompiler.

local u1 = {
    ProcessEventsInterval = 8,
    GameKey = "",
    SecretKey = "",
    Build = "",
    _availableResourceCurrencies = {},
    _availableResourceItemTypes = {}
};
local Store = require(script.Parent.Store);
local Logger = require(script.Parent.Logger);
local Version = require(script.Parent.Version);
local Validation = require(script.Parent.Validation);
local Threading = require(script.Parent.Threading);
local HttpApi = require(script.Parent.HttpApi);
local Utilities = require(script.Parent.Utilities);
local GAResourceFlowType = require(script.Parent.GAResourceFlowType);
local GAProgressionStatus = require(script.Parent.GAProgressionStatus);
local GAErrorSeverity = require(script.Parent.GAErrorSeverity);
local HttpService = game:GetService("HttpService");

local function addCustomFieldsToEvent(p2, p3) -- Line: 33
    -- upvalues: Logger (copy)
    if not (p2 and p3) then
        return;
    end;

    local v4 = {};

    for i, v in pairs(p3) do
        local v5 = tostring(v);

        if #v5 > 256 then
            Logger:w("Custom field value is too long. Max length is 256 characters. Field: " .. i);
            v5 = string.sub(v5, 1, 256);
        end;

        v4[i] = v5;
    end;

    if v4 and next(v4) then
        p2.custom_fields = v4;
    end;
end;

local function addDimensionsToEvent(p6, p7) -- Line: 55
    -- upvalues: Store (copy)
    if not (p7 and p6) then
        return;
    end;

    local v8 = Store:GetPlayerDataFromCache(p6);

    if v8 and (v8.CurrentCustomDimension01 and #v8.CurrentCustomDimension01 > 0) then
        p7.custom_01 = v8.CurrentCustomDimension01;
    end;

    if v8 and (v8.CurrentCustomDimension02 and #v8.CurrentCustomDimension02 > 0) then
        p7.custom_02 = v8.CurrentCustomDimension02;
    end;

    if v8 and (v8.CurrentCustomDimension03 and #v8.CurrentCustomDimension03 > 0) then
        p7.custom_03 = v8.CurrentCustomDimension03;
    end;
end;

local function getClientTsAdjusted(p9) -- Line: 76
    -- upvalues: Store (copy), Validation (copy)
    if not p9 then
        return os.time();
    end;

    local v10 = Store:GetPlayerDataFromCache(p9);
    local v11 = os.time();
    local v12 = v11 + v10.ClientServerTimeOffset;

    if Validation:validateClientTs(v12) then
        return v12;
    end;

    return v11;
end;

local u13 = HttpService:GenerateGUID(false):lower();

local function Length(p14) -- Line: 93
    local v15 = 0;

    for _, _ in pairs(p14) do
        v15 = v15 + 1;
    end;

    return v15;
end;

local function getEventAnnotations(p16) -- Line: 101
    -- upvalues: Store (copy), u13 (copy), Validation (copy), Version (copy), Utilities (copy), u1 (copy)
    local v17, v18;

    if p16 then
        v17 = Store:GetPlayerDataFromCache(p16);
        v18 = p16;
    else
        v17 = {
            OS = "uwp_desktop 0.0.0",
            Platform = "uwp_desktop",
            Sessions = 1,
            CustomUserId = "Server",
            SessionID = u13
        };
        v18 = "DummyId";
    end;

    local v19 = {
        v = 2,
        user_id = tostring(v18) .. v17.CustomUserId
    };
    local v20;

    if p16 then
        local v21 = Store:GetPlayerDataFromCache(p16);
        v20 = os.time();
        local v22 = v20 + v21.ClientServerTimeOffset;

        if Validation:validateClientTs(v22) then
            v20 = v22;
        end;
    else
        v20 = os.time();
    end;

    v19.client_ts = v20;
    v19.sdk_version = "roblox " .. Version.SdkVersion;
    v19.os_version = v17.OS;
    v19.manufacturer = "unknown";
    v19.device = "unknown";
    v19.platform = v17.Platform;
    v19.session_id = v17.SessionID;
    v19.session_num = v17.Sessions;

    if Utilities:isStringNullOrEmpty(v17.CountryCode) then
        v19.country_code = "unknown";
    else
        v19.country_code = v17.CountryCode;
    end;

    if Validation:validateBuild(u1.Build) then
        v19.build = u1.Build;
    end;

    if v17.Configurations then
        local v23 = 0;

        for _, _ in pairs(v17.Configurations) do
            v23 = v23 + 1;
        end;

        if v23 > 0 then
            v19.configurations = v17.Configurations;
        end;
    end;

    if not Utilities:isStringNullOrEmpty(v17.AbId) then
        v19.ab_id = v17.AbId;
    end;

    if not Utilities:isStringNullOrEmpty(v17.AbVariantId) then
        v19.ab_variant_id = v17.AbVariantId;
    end;

    return v19;
end;

local function addEventToStore(p24, p25) -- Line: 168
    -- upvalues: getEventAnnotations (copy), HttpService (copy), Logger (copy), Store (copy)
    local v26 = getEventAnnotations(p24);

    for i in pairs(p25) do
        v26[i] = p25[i];
    end;

    Logger:ii("Event added to queue: " .. HttpService:JSONEncode(v26));
    Store.EventsQueue[#Store.EventsQueue + 1] = v26;
end;

local function dequeueMaxEvents() -- Line: 187
    -- upvalues: Store (copy), Logger (copy)
    if #Store.EventsQueue <= 500 then
        local EventsQueue = Store.EventsQueue;
        Store.EventsQueue = {};

        return EventsQueue;
    end;

    Logger:w(("More than %d events queued! Sending %d."):format(500, 500));

    if #Store.EventsQueue > 2000 then
        Logger:w(("DROPPING EVENTS: More than %d events queued!"):format(2000));
    end;

    local v27 = table.create(500);

    for i = 1, 500 do
        v27[i] = Store.EventsQueue[i];
    end;

    local v28 = #Store.EventsQueue;

    for i = 1, math.min(2000, v28) do
        Store.EventsQueue[i] = Store.EventsQueue[i + 500];
    end;

    for i = 2001, v28 do
        Store.EventsQueue[i] = nil;
    end;

    return v27;
end;

local function processEvents() -- Line: 225
    -- upvalues: dequeueMaxEvents (copy), Logger (copy), HttpApi (copy), u1 (copy), Store (copy)
    local v29 = dequeueMaxEvents();

    if #v29 == 0 then
        Logger:i("Event queue: No events to send");

        return;
    end;

    Logger:i("Event queue: Sending " .. tostring(#v29) .. " events.");
    local v30 = HttpApi:sendEventsInArray(u1.GameKey, u1.SecretKey, v29);
    local statusCode = v30.statusCode;
    local body = v30.body;

    if statusCode == HttpApi.EGAHTTPApiResponse.Ok and body then
        Logger:i("Event queue: " .. tostring(#v29) .. " events sent.");

        return;
    end;

    if statusCode == HttpApi.EGAHTTPApiResponse.NoResponse then
        Logger:w("Event queue: Failed to send events to collector - Retrying next time");

        for _, v in pairs(v29) do
            if #Store.EventsQueue >= 2000 then
                return;
            end;

            Store.EventsQueue[#Store.EventsQueue + 1] = v;
        end;

        return;
    end;

    if statusCode == HttpApi.EGAHTTPApiResponse.BadRequest and body then
        Logger:w("Event queue: " .. tostring(#v29) .. " events sent. " .. tostring(#body) .. " events failed GA server validation.");

        return;
    end;

    Logger:w("Event queue: Failed to send events.");
end;

function u1.processEventQueue(p31) -- Line: 268
    -- upvalues: processEvents (copy), Threading (copy), u1 (copy)
    processEvents();
    Threading:scheduleTimer(u1.ProcessEventsInterval, function() -- Line: 270
        -- upvalues: u1 (ref)
        u1:processEventQueue();
    end);
end;

function u1.setBuild(p32, p33) -- Line: 275
    -- upvalues: Validation (copy), Logger (copy)
    if not Validation:validateBuild(p33) then
        Logger:w("Validation fail - configure build: Cannot be null, empty or above 32 length. String: " .. p33);

        return;
    end;

    p32.Build = p33;
    Logger:i("Set build version: " .. p33);
end;

function u1.setAvailableResourceCurrencies(p34, p35) -- Line: 285
    -- upvalues: Validation (copy), Logger (copy)
    if not Validation:validateResourceCurrencies(p35) then
        return;
    end;

    p34._availableResourceCurrencies = p35;
    Logger:i("Set available resource currencies: (" .. table.concat(p35, ", ") .. ")");
end;

function u1.setAvailableResourceItemTypes(p36, p37) -- Line: 294
    -- upvalues: Validation (copy), Logger (copy)
    if not Validation:validateResourceCurrencies(p37) then
        return;
    end;

    p36._availableResourceItemTypes = p37;
    Logger:i("Set available resource item types: (" .. table.concat(p37, ", ") .. ")");
end;

function u1.addSessionStartEvent(p38, p39, p40, p41) -- Line: 303
    -- upvalues: Store (copy), addDimensionsToEvent (copy), addEventToStore (copy), addCustomFieldsToEvent (copy), Logger (copy), processEvents (copy)
    local v42 = Store:GetPlayerDataFromCache(p39);

    if p40 then
        v42.Sessions = p40.Sessions;

        return;
    end;

    local v43 = {
        category = "user"
    };
    v42.Sessions = v42.Sessions + 1;
    addDimensionsToEvent(p39, v43);
    addEventToStore(p39, v43);
    addCustomFieldsToEvent(v43, p41);
    Logger:i("Add SESSION START event");
    processEvents();
end;

function u1.addSessionEndEvent(p44, p45, p46) -- Line: 330
    -- upvalues: Store (copy), Validation (copy), Logger (copy), addDimensionsToEvent (copy), addCustomFieldsToEvent (copy), addEventToStore (copy), processEvents (copy)
    local v47 = Store:GetPlayerDataFromCache(p45);
    local SessionStart = v47.SessionStart;
    local v48;

    if p45 then
        local v49 = Store:GetPlayerDataFromCache(p45);
        v48 = os.time();
        local v50 = v48 + v49.ClientServerTimeOffset;

        if Validation:validateClientTs(v50) then
            v48 = v50;
        end;
    else
        v48 = os.time();
    end;

    local v51 = (v48 == nil or SessionStart == nil) and 0 or v48 - SessionStart;

    if v51 < 0 then
        Logger:w("Session length was calculated to be less then 0. Should not be possible. Resetting to 0.");
        v51 = 0;
    end;

    local v52 = {
        category = "session_end",
        length = v51
    };
    addDimensionsToEvent(p45, v52);
    addCustomFieldsToEvent(v52, p46);
    addEventToStore(p45, v52);
    v47.SessionStart = 0;
    Logger:i("Add SESSION END event.");
    processEvents();
end;

function u1.addBusinessEvent(p53, p54, p55, p56, p57, p58, p59, p60) -- Line: 365
    -- upvalues: Validation (copy), Store (copy), Utilities (copy), addDimensionsToEvent (copy), addCustomFieldsToEvent (copy), Logger (copy), addEventToStore (copy)
    if not Validation:validateBusinessEvent(p55, p56, p59, p57, p58) then
        return;
    end;

    local v61 = {};
    local v62 = Store:GetPlayerDataFromCache(p54);
    v62.Transactions = v62.Transactions + 1;
    v61.event_id = p57 .. ":" .. p58;
    v61.category = "business";
    v61.currency = p55;
    v61.amount = p56;
    v61.transaction_num = v62.Transactions;

    if not Utilities:isStringNullOrEmpty(p59) then
        v61.cart_type = p59;
    end;

    addDimensionsToEvent(p54, v61);
    addCustomFieldsToEvent(v61, p60);
    Logger:i("Add BUSINESS event: {currency:" .. p55 .. ", amount:" .. tostring(p56) .. ", itemType:" .. p57 .. ", itemId:" .. p58 .. ", cartType:" .. p59 .. "}");
    addEventToStore(p54, v61);
end;

function u1.addResourceEvent(p63, p64, p65, p66, p67, p68, p69, p70) -- Line: 413
    -- upvalues: Validation (copy), GAResourceFlowType (copy), addDimensionsToEvent (copy), addCustomFieldsToEvent (copy), Logger (copy), addEventToStore (copy)
    if not Validation:validateResourceEvent(GAResourceFlowType, p65, p66, p67, p68, p69, p63._availableResourceCurrencies, p63._availableResourceItemTypes) then
        return;
    end;

    if p65 == GAResourceFlowType.Sink then
        p67 = -1 * p67;
    end;

    local v71 = {
        event_id = GAResourceFlowType[p65] .. ":" .. p66 .. ":" .. p68 .. ":" .. p69,
        category = "resource",
        amount = p67
    };
    addDimensionsToEvent(p64, v71);
    addCustomFieldsToEvent(v71, p70);
    Logger:i("Add RESOURCE event: {currency:" .. p66 .. ", amount:" .. tostring(p67) .. ", itemType:" .. p68 .. ", itemId:" .. p69 .. "}");
    addEventToStore(p64, v71);
end;

function u1.addProgressionEvent(p72, p73, p74, p75, p76, p77, p78, p79) -- Line: 465
    -- upvalues: Validation (copy), GAProgressionStatus (copy), Utilities (copy), Store (copy), addDimensionsToEvent (copy), addCustomFieldsToEvent (copy), Logger (copy), addEventToStore (copy)
    if not Validation:validateProgressionEvent(GAProgressionStatus, p74, p75, p76, p77) then
        return;
    end;

    local v80 = {};
    local v81;

    if Utilities:isStringNullOrEmpty(p76) then
        v81 = p75;
    elseif Utilities:isStringNullOrEmpty(p77) then
        v81 = p75 .. ":" .. p76;
    else
        v81 = p75 .. ":" .. p76 .. ":" .. p77;
    end;

    local v82 = GAProgressionStatus[p74];
    v80.category = "progression";
    v80.event_id = v82 .. ":" .. v81;
    local v83 = 0;

    if p78 ~= nil and p74 ~= GAProgressionStatus.Start then
        v80.score = p78;
    end;

    local v84 = Store:GetPlayerDataFromCache(p73);

    if p74 == GAProgressionStatus.Fail then
        v84.ProgressionTries[v81] = (v84.ProgressionTries[v81] or 0) + 1;
    end;

    if p74 == GAProgressionStatus.Complete then
        v84.ProgressionTries[v81] = (v84.ProgressionTries[v81] or 0) + 1;
        v83 = v84.ProgressionTries[v81];
        v80.attempt_num = v83;
        v84.ProgressionTries[v81] = 0;
    end;

    addDimensionsToEvent(p73, v80);
    addCustomFieldsToEvent(v80, p79);
    Logger:i("Add PROGRESSION event: {status:" .. v82 .. ", progression01:" .. p75 .. ", progression02:" .. (Utilities:isStringNullOrEmpty(p76) and "" or p76) .. ", progression03:" .. (Utilities:isStringNullOrEmpty(p77) and "" or p77) .. ", score:" .. tostring(p78) .. ", attempt:" .. tostring(v83) .. "}");
    addEventToStore(p73, v80);
end;

function u1.addDesignEvent(p85, p86, p87, p88, p89) -- Line: 572
    -- upvalues: Validation (copy), addDimensionsToEvent (copy), addCustomFieldsToEvent (copy), Logger (copy), addEventToStore (copy)
    if not Validation:validateDesignEvent(p87) then
        return;
    end;

    local v90 = {
        category = "design",
        event_id = p87
    };

    if p88 ~= nil then
        v90.value = p88;
    end;

    addDimensionsToEvent(p86, v90);
    addCustomFieldsToEvent(v90, p89);
    Logger:i("Add DESIGN event: {eventId:" .. p87 .. ", value:" .. tostring(p88) .. "}");
    addEventToStore(p86, v90);
end;

function u1.addErrorEvent(p91, p92, p93, p94, p95) -- Line: 600
    -- upvalues: Validation (copy), GAErrorSeverity (copy), addDimensionsToEvent (copy), addCustomFieldsToEvent (copy), Utilities (copy), Logger (copy), addEventToStore (copy)
    if not Validation:validateErrorEvent(GAErrorSeverity, p93, p94) then
        return;
    end;

    local v96 = {};
    local v97 = GAErrorSeverity[p93];
    v96.category = "error";
    v96.severity = v97;
    v96.message = p94;
    addDimensionsToEvent(p92, v96);
    addCustomFieldsToEvent(v96, p95);
    Logger:i("Add ERROR event: {severity:" .. v97 .. ", message:" .. (Utilities:isStringNullOrEmpty(p94) and "" or p94) .. "}");
    addEventToStore(p92, v96);
end;

function u1.addSdkErrorEvent(p98, p99, p100, p101, p102, p103, p104) -- Line: 631
    -- upvalues: Utilities (copy), Logger (copy), addEventToStore (copy)
    local v105 = {
        category = "sdk_error",
        error_category = p100,
        error_area = p101,
        error_action = p102
    };

    if not Utilities:isStringNullOrEmpty(p103) then
        v105.error_parameter = p103;
    end;

    if not Utilities:isStringNullOrEmpty(p104) then
        v105.reason = p104;
    end;

    Logger:i("Add SDK ERROR event: {error_category:" .. p100 .. ", error_area:" .. p101 .. ", error_action:" .. p102 .. "}");
    addEventToStore(p99, v105);
end;

return u1;