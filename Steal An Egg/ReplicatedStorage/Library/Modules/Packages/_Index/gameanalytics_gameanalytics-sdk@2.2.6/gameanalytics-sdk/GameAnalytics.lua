-- Decompiled with Potassium's decompiler.

local u1 = {
    EGAResourceFlowType = require(script.GAResourceFlowType),
    EGAProgressionStatus = require(script.GAProgressionStatus),
    EGAErrorSeverity = require(script.GAErrorSeverity)
};
require(script.Types);
local Logger = require(script.Logger);
local Threading = require(script.Threading);
local State = require(script.State);
local Validation = require(script.Validation);
local Store = require(script.Store);
local Events = require(script.Events);
local Utilities = require(script.Utilities);
local Players = game:GetService("Players");
local MarketplaceService = game:GetService("MarketplaceService");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalizationService = game:GetService("LocalizationService");
local ScriptContext = game:GetService("ScriptContext");
local Postie = require(script.Postie);
local u2 = nil;
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = {};
local u7 = {};
local u8 = {};

local function addToInitializationQueue(p9, ...) -- Line: 49
    -- upvalues: u7 (ref), Logger (copy)
    if u7 == nil then
        Logger:w("Initialization queue already cleared.");

        return;
    end;

    table.insert(u7, {
        Func = p9,
        Args = { ... }
    });
    Logger:i("Added event to initialization queue");
end;

local function addToInitializationQueueByUserId(p10, p11, ...) -- Line: 63
    -- upvalues: u1 (copy), u8 (copy), Logger (copy)
    if u1:isPlayerReady(p10) then
        Logger:w("Player initialization queue already cleared.");

        return;
    end;

    if u8[p10] == nil then
        u8[p10] = {};
    end;

    table.insert(u8[p10], {
        Func = p11,
        Args = { ... }
    });
    Logger:i("Added event to player initialization queue");
end;

local function isSdkReady(p12) -- Line: 82
    -- upvalues: State (copy), Logger (copy)
    local v13 = p12.playerId or nil;
    local v14 = p12.needsInitialized or true;
    local v15 = p12.shouldWarn or false;
    local v16 = p12.message or "";

    if v14 and not State.Initialized then
        if v15 then
            Logger:w(v16 .. " SDK is not initialized");
        end;

        return false;
    end;

    if v14 and (v13 and not State:isEnabled(v13)) then
        if v15 then
            Logger:w(v16 .. " SDK is disabled");
        end;

        return false;
    end;

    if not v14 or (not v13 or State:sessionIsStarted(v13)) then
        return true;
    end;

    if v15 then
        Logger:w(v16 .. " Session has not started yet");
    end;

    return false;
end;

function u1.configureAvailableCustomDimensions01(p17, p18) -- Line: 118
    -- upvalues: isSdkReady (copy), Logger (copy), State (copy)
    if isSdkReady({
        needsInitialized = true,
        shouldWarn = false
    }) then
        Logger:w("Available custom dimensions must be set before SDK is initialized");

        return;
    end;

    State:setAvailableCustomDimensions01(p18);
end;

function u1.configureAvailableCustomDimensions02(p19, p20) -- Line: 127
    -- upvalues: isSdkReady (copy), Logger (copy), State (copy)
    if isSdkReady({
        needsInitialized = true,
        shouldWarn = false
    }) then
        Logger:w("Available custom dimensions must be set before SDK is initialized");

        return;
    end;

    State:setAvailableCustomDimensions02(p20);
end;

function u1.configureAvailableCustomDimensions03(p21, p22) -- Line: 136
    -- upvalues: isSdkReady (copy), Logger (copy), State (copy)
    if isSdkReady({
        needsInitialized = true,
        shouldWarn = false
    }) then
        Logger:w("Available custom dimensions must be set before SDK is initialized");

        return;
    end;

    State:setAvailableCustomDimensions03(p22);
end;

function u1.configureAvailableResourceCurrencies(p23, p24) -- Line: 145
    -- upvalues: isSdkReady (copy), Logger (copy), Events (copy)
    if isSdkReady({
        needsInitialized = true,
        shouldWarn = false
    }) then
        Logger:w("Available resource currencies must be set before SDK is initialized");

        return;
    end;

    Events:setAvailableResourceCurrencies(p24);
end;

function u1.configureAvailableResourceItemTypes(p25, p26) -- Line: 154
    -- upvalues: isSdkReady (copy), Logger (copy), Events (copy)
    if isSdkReady({
        needsInitialized = true,
        shouldWarn = false
    }) then
        Logger:w("Available resource item types must be set before SDK is initialized");

        return;
    end;

    Events:setAvailableResourceItemTypes(p26);
end;

function u1.configureBuild(p27, p28) -- Line: 163
    -- upvalues: isSdkReady (copy), Logger (copy), Events (copy)
    if isSdkReady({
        needsInitialized = true,
        shouldWarn = false
    }) then
        Logger:w("Build version must be set before SDK is initialized.");

        return;
    end;

    Events:setBuild(p28);
end;

function u1.configureAvailableGamepasses(p29, p30) -- Line: 172
    -- upvalues: isSdkReady (copy), Logger (copy), State (copy)
    if isSdkReady({
        needsInitialized = true,
        shouldWarn = false
    }) then
        Logger:w("Available gamepasses must be set before SDK is initialized.");

        return;
    end;

    State:setAvailableGamepasses(p30);
end;

function u1.startNewSession(p31, u32, u33) -- Line: 181
    -- upvalues: Threading (copy), State (copy), Logger (copy)
    Threading:performTaskOnGAThread(function() -- Line: 182
        -- upvalues: State (ref), Logger (ref), u32 (copy), u33 (copy)
        if not State:isEventSubmissionEnabled() then
            return;
        end;

        if State.Initialized then
            State:startNewSession(u32, u33);

            return;
        end;

        Logger:w("Cannot start new session. SDK is not initialized yet.");
    end);
end;

function u1.endSession(p34, u35) -- Line: 196
    -- upvalues: Threading (copy), State (copy)
    Threading:performTaskOnGAThread(function() -- Line: 197
        -- upvalues: State (ref), u35 (copy)
        if not State:isEventSubmissionEnabled() then
            return;
        end;

        State:endSession(u35);
    end);
end;

function u1.filterForBusinessEvent(p36, p37) -- Line: 205
    return string.gsub(p37, "[^A-Za-z0-9%s%-_%.%(%)!%?]", "");
end;

function u1.addBusinessEvent(p38, u39, u40) -- Line: 209
    -- upvalues: Threading (copy), State (copy), isSdkReady (copy), addToInitializationQueueByUserId (copy), u1 (copy), addToInitializationQueue (copy), Events (copy), Players (copy), Store (copy)
    Threading:performTaskOnGAThread(function() -- Line: 210
        -- upvalues: State (ref), isSdkReady (ref), u39 (copy), addToInitializationQueueByUserId (ref), u1 (ref), u40 (copy), addToInitializationQueue (ref), Events (ref), Players (ref), Store (ref)
        if not State:isEventSubmissionEnabled() then
            return;
        end;

        if not isSdkReady({
            needsInitialized = true,
            shouldWarn = false,
            message = "Could not add business event",
            playerId = u39
        }) then
            if u39 then
                addToInitializationQueueByUserId(u39, u1.addBusinessEvent, u1, u39, u40);

                return;
            end;

            addToInitializationQueue(u1.addBusinessEvent, u1, u39, u40);

            return;
        end;

        if not u40 then
            return;
        end;

        local v41 = u40.itemType or "";
        local v42 = u40.itemId or "";
        local v43 = u40.cartType or "";
        local v44 = math.floor((u40.amount or 0) * 0.7 * 0.35);
        local v45 = u40.gamepassId or nil;
        Events:addBusinessEvent(u39, "USD", v44, v41, v42, v43, u40.customFields);

        if v41 == "Gamepass" and v43 ~= "Website" then
            local v46 = Players:GetPlayerByUserId(u39);
            local v47 = Store:GetPlayerDataFromCache(u39);

            if not v47.OwnedGamepasses then
                v47.OwnedGamepasses = {};
            end;

            table.insert(v47.OwnedGamepasses, v45);
            Store.PlayerCache[u39] = v47;
            Store:SavePlayerData(v46);
        end;
    end);
end;

function u1.addResourceEvent(p48, u49, u50) -- Line: 258
    -- upvalues: Threading (copy), State (copy), isSdkReady (copy), addToInitializationQueueByUserId (copy), u1 (copy), addToInitializationQueue (copy), Events (copy)
    Threading:performTaskOnGAThread(function() -- Line: 259
        -- upvalues: State (ref), isSdkReady (ref), u49 (copy), addToInitializationQueueByUserId (ref), u1 (ref), u50 (copy), addToInitializationQueue (ref), Events (ref)
        if not State:isEventSubmissionEnabled() then
            return;
        end;

        if isSdkReady({
            needsInitialized = true,
            shouldWarn = false,
            message = "Could not add resource event",
            playerId = u49
        }) then
            if not u50 then
                return;
            end;

            Events:addResourceEvent(u49, u50.flowType or 0, u50.currency or "", u50.amount or 0, u50.itemType or "", u50.itemId or "", u50.customFields);

            return;
        end;

        if u49 then
            addToInitializationQueueByUserId(u49, u1.addResourceEvent, u1, u49, u50);

            return;
        end;

        addToInitializationQueue(u1.addResourceEvent, u1, u49, u50);
    end);
end;

function u1.addProgressionEvent(p51, u52, u53) -- Line: 295
    -- upvalues: Threading (copy), State (copy), isSdkReady (copy), addToInitializationQueueByUserId (copy), u1 (copy), addToInitializationQueue (copy), Events (copy)
    Threading:performTaskOnGAThread(function() -- Line: 296
        -- upvalues: State (ref), isSdkReady (ref), u52 (copy), addToInitializationQueueByUserId (ref), u1 (ref), u53 (copy), addToInitializationQueue (ref), Events (ref)
        if not State:isEventSubmissionEnabled() then
            return;
        end;

        if isSdkReady({
            needsInitialized = true,
            shouldWarn = false,
            message = "Could not add progression event",
            playerId = u52
        }) then
            if not u53 then
                return;
            end;

            Events:addProgressionEvent(u52, u53.progressionStatus or 0, u53.progression01 or "", u53.progression02 or nil, u53.progression03 or nil, u53.score or nil, u53.customFields);

            return;
        end;

        if u52 then
            addToInitializationQueueByUserId(u52, u1.addProgressionEvent, u1, u52, u53);

            return;
        end;

        addToInitializationQueue(u1.addProgressionEvent, u1, u52, u53);
    end);
end;

function u1.addDesignEvent(p54, u55, u56) -- Line: 340
    -- upvalues: Threading (copy), State (copy), isSdkReady (copy), addToInitializationQueueByUserId (copy), u1 (copy), addToInitializationQueue (copy), Events (copy)
    Threading:performTaskOnGAThread(function() -- Line: 341
        -- upvalues: State (ref), isSdkReady (ref), u55 (copy), addToInitializationQueueByUserId (ref), u1 (ref), u56 (copy), addToInitializationQueue (ref), Events (ref)
        if not State:isEventSubmissionEnabled() then
            return;
        end;

        if isSdkReady({
            needsInitialized = true,
            shouldWarn = false,
            message = "Could not add design event",
            playerId = u55
        }) then
            if not u56 then
                return;
            end;

            Events:addDesignEvent(u55, u56.eventId or "", u56.value or nil, u56.customFields);

            return;
        end;

        if u55 then
            addToInitializationQueueByUserId(u55, u1.addDesignEvent, u1, u55, u56);

            return;
        end;

        addToInitializationQueue(u1.addDesignEvent, u1, u55, u56);
    end);
end;

function u1.addErrorEvent(p57, u58, u59) -- Line: 374
    -- upvalues: Threading (copy), State (copy), isSdkReady (copy), addToInitializationQueueByUserId (copy), u1 (copy), addToInitializationQueue (copy), Events (copy)
    Threading:performTaskOnGAThread(function() -- Line: 375
        -- upvalues: State (ref), isSdkReady (ref), u58 (copy), addToInitializationQueueByUserId (ref), u1 (ref), u59 (copy), addToInitializationQueue (ref), Events (ref)
        if not State:isEventSubmissionEnabled() then
            return;
        end;

        if isSdkReady({
            needsInitialized = true,
            shouldWarn = false,
            message = "Could not add error event",
            playerId = u58
        }) then
            if not u59 then
                return;
            end;

            Events:addErrorEvent(u58, u59.severity or 0, u59.message or "", u59.customFields);

            return;
        end;

        if u58 then
            addToInitializationQueueByUserId(u58, u1.addErrorEvent, u1, u58, u59);

            return;
        end;

        addToInitializationQueue(u1.addErrorEvent, u1, u58, u59);
    end);
end;

function u1.setEnabledDebugLog(p60, p61) -- Line: 408
    -- upvalues: RunService (copy), Logger (copy)
    if not RunService:IsStudio() then
        Logger:i("setEnabledDebugLog can only be used in studio");

        return;
    end;

    if p61 then
        Logger:setDebugLog(p61);
        Logger:i("Debug logging enabled");

        return;
    end;

    Logger:i("Debug logging disabled");
    Logger:setDebugLog(p61);
end;

function u1.setEnabledInfoLog(p62, p63) -- Line: 422
    -- upvalues: Logger (copy)
    if p63 then
        Logger:setInfoLog(p63);
        Logger:i("Info logging enabled");

        return;
    end;

    Logger:i("Info logging disabled");
    Logger:setInfoLog(p63);
end;

function u1.setEnabledVerboseLog(p64, p65) -- Line: 432
    -- upvalues: Logger (copy)
    if p65 then
        Logger:setVerboseLog(p65);
        Logger:ii("Verbose logging enabled");

        return;
    end;

    Logger:ii("Verbose logging disabled");
    Logger:setVerboseLog(p65);
end;

function u1.setEnabledEventSubmission(p66, u67) -- Line: 442
    -- upvalues: Threading (copy), State (copy), Logger (copy)
    Threading:performTaskOnGAThread(function() -- Line: 443
        -- upvalues: u67 (copy), State (ref), Logger (ref)
        if u67 then
            State:setEventSubmission(u67);
            Logger:i("Event submission enabled");

            return;
        end;

        Logger:i("Event submission disabled");
        State:setEventSubmission(u67);
    end);
end;

function u1.setCustomDimension01(p68, u69, u70) -- Line: 454
    -- upvalues: Threading (copy), Validation (copy), State (copy), Logger (copy), isSdkReady (copy)
    Threading:performTaskOnGAThread(function() -- Line: 455
        -- upvalues: Validation (ref), State (ref), u70 (copy), Logger (ref), isSdkReady (ref), u69 (copy)
        if not Validation:validateDimension(State._availableCustomDimensions01, u70) then
            Logger:w("Could not set custom01 dimension value to \'" .. (u70 or "") .. "\'. Value not found in available custom01 dimension values");

            return;
        end;

        if not isSdkReady({
            needsInitialized = true,
            shouldWarn = true,
            message = "Could not set custom01 dimension",
            playerId = u69
        }) then
            return;
        end;

        State:setCustomDimension01(u69, u70);
    end);
end;

function u1.setCustomDimension02(p71, u72, u73) -- Line: 480
    -- upvalues: Threading (copy), Validation (copy), State (copy), Logger (copy), isSdkReady (copy)
    Threading:performTaskOnGAThread(function() -- Line: 481
        -- upvalues: Validation (ref), State (ref), u73 (copy), Logger (ref), isSdkReady (ref), u72 (copy)
        if not Validation:validateDimension(State._availableCustomDimensions02, u73) then
            Logger:w("Could not set custom02 dimension value to \'" .. (u73 or "") .. "\'. Value not found in available custom02 dimension values");

            return;
        end;

        if not isSdkReady({
            needsInitialized = true,
            shouldWarn = true,
            message = "Could not set custom02 dimension",
            playerId = u72
        }) then
            return;
        end;

        State:setCustomDimension02(u72, u73);
    end);
end;

function u1.setCustomDimension03(p74, u75, u76) -- Line: 506
    -- upvalues: Threading (copy), Validation (copy), State (copy), Logger (copy), isSdkReady (copy)
    Threading:performTaskOnGAThread(function() -- Line: 507
        -- upvalues: Validation (ref), State (ref), u76 (copy), Logger (ref), isSdkReady (ref), u75 (copy)
        if not Validation:validateDimension(State._availableCustomDimensions03, u76) then
            Logger:w("Could not set custom03 dimension value to \'" .. (u76 or "") .. "\'. Value not found in available custom03 dimension values");

            return;
        end;

        if not isSdkReady({
            needsInitialized = true,
            shouldWarn = true,
            message = "Could not set custom03 dimension",
            playerId = u75
        }) then
            return;
        end;

        State:setCustomDimension03(u75, u76);
    end);
end;

function u1.setEnabledReportErrors(p77, u78) -- Line: 532
    -- upvalues: Threading (copy), State (copy)
    Threading:performTaskOnGAThread(function() -- Line: 533
        -- upvalues: State (ref), u78 (copy)
        State.ReportErrors = u78;
    end);
end;

function u1.setEnabledCustomUserId(p79, u80) -- Line: 538
    -- upvalues: Threading (copy), State (copy)
    Threading:performTaskOnGAThread(function() -- Line: 539
        -- upvalues: State (ref), u80 (copy)
        State.UseCustomUserId = u80;
    end);
end;

function u1.setEnabledAutomaticSendBusinessEvents(p81, u82) -- Line: 544
    -- upvalues: Threading (copy), State (copy)
    Threading:performTaskOnGAThread(function() -- Line: 545
        -- upvalues: State (ref), u82 (copy)
        State.AutomaticSendBusinessEvents = u82;
    end);
end;

function u1.addGameAnalyticsTeleportData(p83, p84, p85) -- Line: 550
    -- upvalues: Store (copy)
    local v86 = {};

    for _, v in ipairs(p84) do
        local v87 = Store:GetPlayerDataFromCache(v);
        v87.PlayerTeleporting = true;
        local v88 = {
            SessionID = v87.SessionID,
            Sessions = v87.Sessions,
            SessionStart = v87.SessionStart
        };
        v86[tostring(v)] = v88;
    end;

    p85.gameanalyticsData = v86;

    return p85;
end;

function u1.getRemoteConfigsValueAsString(p89, p90, p91) -- Line: 569
    -- upvalues: State (copy)
    return State:getRemoteConfigsStringValue(p90, p91.key or "", p91.defaultValue or nil);
end;

function u1.isRemoteConfigsReady(p92, p93) -- Line: 575
    -- upvalues: State (copy)
    return State:isRemoteConfigsReady(p93);
end;

function u1.getRemoteConfigsContentAsString(p94, p95) -- Line: 579
    -- upvalues: State (copy)
    return State:getRemoteConfigsContentAsString(p95);
end;

function u1.PlayerJoined(p96, u97) -- Line: 583
    -- upvalues: Store (copy), Postie (copy), Utilities (copy), LocalizationService (copy), Events (copy), State (copy), Logger (copy), u1 (copy), u2 (ref), ReplicatedStorage (copy), MarketplaceService (copy), u3 (copy), u8 (copy)
    local TeleportData = u97:GetJoinData().TeleportData;
    local v98 = Store:GetPlayerData(u97);
    local v99;

    if TeleportData and typeof(TeleportData) == "table" then
        v99 = TeleportData.gameanalyticsData and TeleportData.gameanalyticsData[tostring(u97.UserId)];
    else
        v99 = nil;
    end;

    local v100 = Store:GetPlayerDataFromCache(u97.UserId);

    if v100 then
        if v99 then
            v100.SessionID = v99.SessionID;
            v100.SessionStart = v99.SessionStart;
        end;

        v100.PlayerTeleporting = false;

        return;
    end;

    local v101, v102 = Postie.invokeClient("getPlatform", u97, 5);
    local v103 = not v101 and "unknown" or v102;

    for i, v in pairs(Store.BasePlayerData) do
        if not v98[i] then
            if typeof(v) == "table" then
                v98[i] = Utilities:copyTable(v);
            else
                v98[i] = v;
            end;
        end;
    end;

    local success, result = pcall(function() -- Line: 624
        -- upvalues: LocalizationService (ref), u97 (copy)
        return LocalizationService:GetCountryRegionForPlayerAsync(u97);
    end);

    if success then
        v98.CountryCode = result;
    end;

    Store.PlayerCache[u97.UserId] = v98;
    local v104;

    if v103 == "Console" then
        v104 = "uwp_console";
    elseif v103 == "Mobile" then
        v104 = "uwp_mobile";
    else
        local _ = v103 == "Desktop";
        v104 = "uwp_desktop";
    end;

    v98.Platform = v104;
    v98.OS = v98.Platform .. " 0.0.0";

    if not success then
        Events:addSdkErrorEvent(u97.UserId, "event_validation", "player_joined", "string_empty_or_null", "country_code", "");
    end;

    local v105 = "";
    local v106;

    if State.UseCustomUserId then
        local v107;
        v107, v106 = Postie.invokeClient("getCustomUserId", u97, 5);

        if not v107 then
            v106 = v105;
        end;
    else
        v106 = v105;
    end;

    if not Utilities:isStringNullOrEmpty(v106) then
        Logger:i("Using custom id: " .. v106);
        v98.CustomUserId = v106;
    end;

    u1:startNewSession(u97, v99);
    u2 = u2 or ReplicatedStorage:WaitForChild("OnPlayerReadyEvent");
    u2:Fire(u97);

    if State.AutomaticSendBusinessEvents then
        if v98.OwnedGamepasses == nil then
            v98.OwnedGamepasses = {};

            for _, v in ipairs(State._availableGamepasses) do
                if MarketplaceService:UserOwnsGamePassAsync(u97.UserId, v) then
                    table.insert(v98.OwnedGamepasses, v);
                end;
            end;

            Store.PlayerCache[u97.UserId] = v98;
            Store:SavePlayerData(u97);
        else
            local v108 = {};

            for _, v in ipairs(State._availableGamepasses) do
                if MarketplaceService:UserOwnsGamePassAsync(u97.UserId, v) then
                    table.insert(v108, v);
                end;
            end;

            local v109 = {};

            for _, v in ipairs(v98.OwnedGamepasses) do
                v109[v] = true;
            end;

            for _, v in ipairs(v108) do
                if not v109[v] then
                    table.insert(v98.OwnedGamepasses, v);
                    local v110 = u3[v];

                    if not v110 then
                        v110 = MarketplaceService:GetProductInfo(v, Enum.InfoType.GamePass);
                        u3[v] = v110;
                    end;

                    u1:addBusinessEvent(u97.UserId, {
                        itemType = "Gamepass",
                        cartType = "Website",
                        amount = v110.PriceInRobux,
                        itemId = u1:filterForBusinessEvent(v110.Name)
                    });
                end;
            end;

            Store.PlayerCache[u97.UserId] = v98;
            Store:SavePlayerData(u97);
        end;
    end;

    local v111 = u8[u97.UserId];

    if v111 then
        u8[u97.UserId] = nil;

        for _, v in ipairs(v111) do
            v.Func(unpack(v.Args));
        end;

        Logger:i("Player initialization queue called #" .. #v111 .. " events");
    end;
end;

function u1.PlayerRemoved(p112, p113) -- Line: 737
    -- upvalues: Store (copy), u1 (copy)
    Store:SavePlayerData(p113);
    local v114 = Store:GetPlayerDataFromCache(p113.UserId);

    if v114 then
        if not v114.PlayerTeleporting then
            u1:endSession(p113.UserId);

            return;
        end;

        Store.PlayerCache[p113.UserId] = nil;
        Store.DataStoreQueue.RemoveKey(p113.UserId);
    end;
end;

function u1.isPlayerReady(p115, p116) -- Line: 752
    -- upvalues: Store (copy)
    return Store:GetPlayerDataFromCache(p116) and true or false;
end;

function u1.ProcessReceiptCallback(p117, u118) -- Line: 760
    -- upvalues: u3 (copy), MarketplaceService (copy), u1 (copy)
    local u119 = u3[u118.ProductId];

    if not u119 then
        pcall(function() -- Line: 767
            -- upvalues: u119 (ref), MarketplaceService (ref), u118 (copy), u3 (ref)
            u119 = MarketplaceService:GetProductInfo(u118.ProductId, Enum.InfoType.Product);
            u3[u118.ProductId] = u119;
        end);
    end;

    if u119 then
        u1:addBusinessEvent(u118.PlayerId, {
            itemType = "DeveloperProduct",
            amount = u118.CurrencySpent,
            itemId = u1:filterForBusinessEvent(u119.Name)
        });
    end;
end;

function u1.GamepassPurchased(p120, p121, p122, p123) -- Line: 783
    -- upvalues: u3 (copy), MarketplaceService (copy), u1 (copy)
    local v124 = u3[p122];

    if not v124 then
        v124 = MarketplaceService:GetProductInfo(p122, Enum.InfoType.GamePass);
        u3[p122] = v124;
    end;

    local v125 = 0;
    local v126 = "GamePass";

    if p123 then
        v125 = p123.PriceInRobux;
        v126 = p123.Name;
    elseif v124 then
        v125 = v124.PriceInRobux;
        v126 = v124.Name;
    end;

    u1:addBusinessEvent(p121.UserId, {
        itemType = "Gamepass",
        amount = v125 or 0,
        itemId = u1:filterForBusinessEvent(v126),
        gamepassId = p122
    });
end;

local u127 = { "gameKey", "secretKey" };

function u1.initServer(p128, p129, p130) -- Line: 813
    -- upvalues: u1 (copy)
    u1:initialize({
        gameKey = p129,
        secretKey = p130
    });
end;

function u1.initialize(p131, u132) -- Line: 820
    -- upvalues: Threading (copy), u127 (copy), Logger (copy), u1 (copy), isSdkReady (copy), Validation (copy), Events (copy), State (copy), Players (copy), u7 (ref)
    Threading:performTaskOnGAThread(function() -- Line: 821
        -- upvalues: u127 (ref), u132 (copy), Logger (ref), u1 (ref), isSdkReady (ref), Validation (ref), Events (ref), State (ref), Players (ref), u7 (ref)
        for _, v in ipairs(u127) do
            if u132[v] == nil then
                Logger:e("Initialize \'" .. v .. "\' option missing");

                return;
            end;
        end;

        if u132.enableInfoLog ~= nil and u132.enableInfoLog then
            u1:setEnabledInfoLog(u132.enableInfoLog);
        end;

        if u132.enableVerboseLog ~= nil and u132.enableVerboseLog then
            u1:setEnabledVerboseLog(u132.enableVerboseLog);
        end;

        if u132.availableCustomDimensions01 ~= nil and #u132.availableCustomDimensions01 > 0 then
            u1:configureAvailableCustomDimensions01(u132.availableCustomDimensions01);
        end;

        if u132.availableCustomDimensions02 ~= nil and #u132.availableCustomDimensions02 > 0 then
            u1:configureAvailableCustomDimensions02(u132.availableCustomDimensions02);
        end;

        if u132.availableCustomDimensions03 ~= nil and #u132.availableCustomDimensions03 > 0 then
            u1:configureAvailableCustomDimensions03(u132.availableCustomDimensions03);
        end;

        if u132.availableResourceCurrencies ~= nil and #u132.availableResourceCurrencies > 0 then
            u1:configureAvailableResourceCurrencies(u132.availableResourceCurrencies);
        end;

        if u132.availableResourceItemTypes ~= nil and #u132.availableResourceItemTypes > 0 then
            u1:configureAvailableResourceItemTypes(u132.availableResourceItemTypes);
        end;

        if u132.build ~= nil and #u132.build > 0 then
            u1:configureBuild(u132.build);
        end;

        if u132.availableGamepasses ~= nil and #u132.availableGamepasses > 0 then
            u1:configureAvailableGamepasses(u132.availableGamepasses);
        end;

        if u132.enableDebugLog ~= nil then
            u1:setEnabledDebugLog(u132.enableDebugLog);
        end;

        if u132.automaticSendBusinessEvents ~= nil then
            u1:setEnabledAutomaticSendBusinessEvents(u132.automaticSendBusinessEvents);
        end;

        if u132.reportErrors ~= nil then
            u1:setEnabledReportErrors(u132.reportErrors);
        end;

        if u132.useCustomUserId ~= nil then
            u1:setEnabledCustomUserId(u132.useCustomUserId);
        end;

        if isSdkReady({
            needsInitialized = true,
            shouldWarn = false
        }) then
            Logger:w("SDK already initialized. Can only be called once.");

            return;
        end;

        local gameKey = u132.gameKey;
        local secretKey = u132.secretKey;

        if not Validation:validateKeys(gameKey, secretKey) then
            Logger:w("SDK failed initialize. Game key or secret key is invalid. Can only contain characters A-z 0-9, gameKey is 32 length, secretKey is 40 length. Failed keys - gameKey: " .. gameKey .. ", secretKey: " .. secretKey);

            return;
        end;

        Events.GameKey = gameKey;
        Events.SecretKey = secretKey;
        State.Initialized = true;
        Players.PlayerAdded:Connect(function(p133) -- Line: 894
            -- upvalues: u1 (ref)
            u1:PlayerJoined(p133);
        end);
        Players.PlayerRemoving:Connect(function(p134) -- Line: 899
            -- upvalues: u1 (ref)
            u1:PlayerRemoved(p134);
        end);

        for _, v in ipairs(Players:GetPlayers()) do
            coroutine.wrap(u1.PlayerJoined)(u1, v);
        end;

        for _, v in ipairs(u7) do
            task.spawn(v.Func, unpack(v.Args));
        end;

        Logger:i("Server initialization queue called #" .. #u7 .. " events");
        u7 = {};
        Events:processEventQueue();
    end);
end;

if not ReplicatedStorage:FindFirstChild("GameAnalyticsRemoteConfigs") then
    local RemoteEvent = Instance.new("RemoteEvent");
    RemoteEvent.Name = "GameAnalyticsRemoteConfigs";
    RemoteEvent.Parent = ReplicatedStorage;
end;

if not ReplicatedStorage:FindFirstChild("OnPlayerReadyEvent") then
    local BindableEvent = Instance.new("BindableEvent");
    BindableEvent.Name = "OnPlayerReadyEvent";
    BindableEvent.Parent = ReplicatedStorage;
end;

task.spawn(function() -- Line: 932
    -- upvalues: u4 (ref), Store (copy), u5 (ref), u6 (ref)
    local v135 = os.time() / 3600;
    u4 = Store:GetErrorDataStore((math.floor(v135)));

    while task.wait(3600) do
        local v136 = os.time() / 3600;
        u4 = Store:GetErrorDataStore((math.floor(v136)));
        u5 = {};
        u6 = {};
    end;
end);
task.spawn(function() -- Line: 944
    -- upvalues: Store (copy), u6 (ref), u5 (ref), u4 (ref)
    while task.wait(Store.AutoSaveData) do
        for _, v in pairs(u6) do
            local v137 = u5[v];
            u5[v].countInDS = Store:IncrementErrorCount(u4, v, v137.currentCount - v137.countInDS);
            u5[v].currentCount = u5[v].countInDS;
        end;
    end;
end);

local function ErrorHandler(p138, p139, p140, p141) -- Line: 955
    -- upvalues: u5 (ref), u6 (ref), u1 (copy)
    local v142 = (p140 == nil and "(null)" or p140) .. ": message=" .. (p138 == nil and "(null)" or p138) .. ", trace=" .. (p139 == nil and "(null)" or p139);

    if #v142 > 8192 then
        v142 = string.sub(v142, 1, 8192);
    end;

    local v143;

    if p141 then
        v143 = p141.UserId;
        v142 = v142:gsub(p141.Name, "[LocalPlayer]");
    else
        v143 = nil;
    end;

    local v144;

    if #v142 > 50 then
        v144 = string.sub(v142, 1, 50);
    else
        v144 = v142;
    end;

    if u5[v144] == nil then
        u6[#u6 + 1] = v144;
        u5[v144] = {};
        u5[v144].countInDS = 0;
        u5[v144].currentCount = 0;
    end;

    if u5[v144].currentCount > 10 then
        return;
    end;

    u1:addErrorEvent(v143, {
        severity = u1.EGAErrorSeverity.error,
        message = v142
    });
    u5[v144].currentCount = u5[v144].currentCount + 1;
end;

local function ErrorHandlerFromClient(p145, p146, p147, p148) -- Line: 1026
    -- upvalues: State (copy), ErrorHandler (copy)
    if State.ReportErrors then
        return ErrorHandler(p145, p146, p147, p148);
    end;
end;

ScriptContext.Error:Connect(function(p149, p150, u151) -- Line: 1005, Name: ErrorHandlerFromServer
    -- upvalues: State (copy), ErrorHandler (copy)
    if not State.ReportErrors then
        return;
    end;

    if not u151 then
        return;
    end;

    local u152 = nil;
    local success, _ = pcall(function() -- Line: 1016
        -- upvalues: u152 (ref), u151 (copy)
        u152 = u151:GetFullName();
    end);

    if success then
        return ErrorHandler(p149, p150, u152);
    end;
end);

if not ReplicatedStorage:FindFirstChild("GameAnalyticsError") then
    local RemoteEvent = Instance.new("RemoteEvent");
    RemoteEvent.Name = "GameAnalyticsError";
    RemoteEvent.Parent = ReplicatedStorage;
end;

ReplicatedStorage.GameAnalyticsError.OnServerEvent:Connect(function(p153, p154, p155, p156) -- Line: 1044
    -- upvalues: State (copy), ErrorHandler (copy)
    if not State.ReportErrors then
        return;
    end;

    ErrorHandler(p154, p155, p156, p153);
end);
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(p157, p158, p159) -- Line: 1049
    -- upvalues: State (copy), u1 (copy)
    if not (State.AutomaticSendBusinessEvents and p159) then
        return;
    end;

    u1:GamepassPurchased(p157, p158);
end);

return u1;