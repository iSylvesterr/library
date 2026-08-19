-- Decompiled with Potassium's decompiler.

local Validation = require(script.Parent.Validation);
local Logger = require(script.Parent.Logger);
local HttpApi = require(script.Parent.HttpApi);
local Store = require(script.Parent.Store);
local Events = require(script.Parent.Events);
local HttpService = game:GetService("HttpService");
local u1 = {
    _enableEventSubmission = true,
    Initialized = false,
    ReportErrors = true,
    UseCustomUserId = false,
    AutomaticSendBusinessEvents = true,
    ConfigsHash = "",
    _availableCustomDimensions01 = {},
    _availableCustomDimensions02 = {},
    _availableCustomDimensions03 = {},
    _availableGamepasses = {}
};
local u2 = nil;

local function getClientTsAdjusted(p3) -- Line: 23
    -- upvalues: Store (copy), Validation (copy)
    local v4 = Store:GetPlayerDataFromCache(p3);

    if not v4 then
        return os.time();
    end;

    local v5 = os.time();
    local v6 = v5 + v4.ClientServerTimeOffset;

    if Validation:validateClientTs(v6) then
        return v6;
    end;

    return v5;
end;

local function populateConfigurations(p7) -- Line: 38
    -- upvalues: Store (copy), Validation (copy), Logger (copy), u2 (ref)
    local v8 = Store:GetPlayerDataFromCache(p7.UserId);
    local SdkConfig = v8.SdkConfig;

    if SdkConfig.configs then
        for _, v in pairs(SdkConfig.configs) do
            if v then
                local v9 = v.key or "";
                local v10 = v.start_ts or 0;
                local v11 = v.end_ts or (1 / 0);
                local v12 = Store:GetPlayerDataFromCache(p7.UserId);
                local v13;

                if v12 then
                    v13 = os.time();
                    local v14 = v13 + v12.ClientServerTimeOffset;

                    if Validation:validateClientTs(v14) then
                        v13 = v14;
                    end;
                else
                    v13 = os.time();
                end;

                if #v9 > 0 and (v.value and (v10 < v13 and v13 < v11)) then
                    v8.Configurations[v9] = v.value;
                    Logger:d("configuration added: key=" .. v.key .. ", value=" .. v.value);
                end;
            end;
        end;
    end;

    Logger:i("Remote configs populated");
    v8.RemoteConfigsIsReady = true;
    u2 = u2 or game:GetService("ReplicatedStorage"):WaitForChild("GameAnalyticsRemoteConfigs");
    u2:FireClient(p7, v8.Configurations);
end;

function u1.sessionIsStarted(p15, p16) -- Line: 75
    -- upvalues: Store (copy)
    local v17 = Store:GetPlayerDataFromCache(p16);

    if v17 then
        return v17.SessionStart ~= 0;
    end;

    return false;
end;

function u1.isEnabled(p18, p19) -- Line: 84
    -- upvalues: Store (copy)
    local v20 = Store:GetPlayerDataFromCache(p19);

    if v20 then
        return v20.InitAuthorized and true or false;
    end;

    return false;
end;

function u1.validateAndFixCurrentDimensions(p21, p22) -- Line: 95
    -- upvalues: Store (copy), Validation (copy), Logger (copy)
    local v23 = Store:GetPlayerDataFromCache(p22);

    if not Validation:validateDimension(p21._availableCustomDimensions01, v23.CurrentCustomDimension01) then
        Logger:d("Invalid dimension01 found in variable. Setting to nil. Invalid dimension: " .. v23.CurrentCustomDimension01);
    end;

    if not Validation:validateDimension(p21._availableCustomDimensions02, v23.CurrentCustomDimension02) then
        Logger:d("Invalid dimension02 found in variable. Setting to nil. Invalid dimension: " .. v23.CurrentCustomDimension02);
    end;

    if not Validation:validateDimension(p21._availableCustomDimensions03, v23.CurrentCustomDimension03) then
        Logger:d("Invalid dimension03 found in variable. Setting to nil. Invalid dimension: " .. v23.CurrentCustomDimension03);
    end;
end;

function u1.setAvailableCustomDimensions01(p24, p25) -- Line: 123
    -- upvalues: Validation (copy), Logger (copy)
    if not Validation:validateCustomDimensions(p25) then
        return;
    end;

    p24._availableCustomDimensions01 = p25;
    Logger:i("Set available custom01 dimension values: (" .. table.concat(p25, ", ") .. ")");
end;

function u1.setAvailableCustomDimensions02(p26, p27) -- Line: 132
    -- upvalues: Validation (copy), Logger (copy)
    if not Validation:validateCustomDimensions(p27) then
        return;
    end;

    p26._availableCustomDimensions02 = p27;
    Logger:i("Set available custom02 dimension values: (" .. table.concat(p27, ", ") .. ")");
end;

function u1.setAvailableCustomDimensions03(p28, p29) -- Line: 141
    -- upvalues: Validation (copy), Logger (copy)
    if not Validation:validateCustomDimensions(p29) then
        return;
    end;

    p28._availableCustomDimensions03 = p29;
    Logger:i("Set available custom03 dimension values: (" .. table.concat(p29, ", ") .. ")");
end;

function u1.setAvailableGamepasses(p30, p31) -- Line: 150
    -- upvalues: Logger (copy)
    p30._availableGamepasses = p31;
    Logger:i("Set available game passes: (" .. table.concat(p31, ", ") .. ")");
end;

function u1.setEventSubmission(p32, p33) -- Line: 155
    p32._enableEventSubmission = p33;
end;

function u1.isEventSubmissionEnabled(p34) -- Line: 159
    return p34._enableEventSubmission;
end;

function u1.setCustomDimension01(p35, p36, p37) -- Line: 163
    -- upvalues: Store (copy)
    Store:GetPlayerDataFromCache(p36).CurrentCustomDimension01 = p37;
end;

function u1.setCustomDimension02(p38, p39, p40) -- Line: 168
    -- upvalues: Store (copy)
    Store:GetPlayerDataFromCache(p39).CurrentCustomDimension02 = p40;
end;

function u1.setCustomDimension03(p41, p42, p43) -- Line: 173
    -- upvalues: Store (copy)
    Store:GetPlayerDataFromCache(p42).CurrentCustomDimension03 = p43;
end;

function u1.startNewSession(p44, p45, p46, p47) -- Line: 178
    -- upvalues: u1 (copy), Logger (copy), Store (copy), HttpApi (copy), Events (copy), populateConfigurations (copy), HttpService (copy), Validation (copy)
    if u1:isEventSubmissionEnabled() and p46 == nil then
        Logger:i("Starting a new session.");
    end;

    local v48 = Store:GetPlayerDataFromCache(p45.UserId);
    u1:validateAndFixCurrentDimensions(p45.UserId);
    local v49 = HttpApi:initRequest(Events.GameKey, Events.SecretKey, Events.Build, v48, p45.UserId);
    local statusCode = v49.statusCode;
    local body = v49.body;

    if (statusCode == HttpApi.EGAHTTPApiResponse.Ok or statusCode == HttpApi.EGAHTTPApiResponse.Created) and body then
        local v50 = body.server_ts or -1;
        body.time_offset = v50 <= 0 and 0 or v50 - os.time();

        if statusCode ~= HttpApi.EGAHTTPApiResponse.Created then
            local SdkConfig = v48.SdkConfig;

            if SdkConfig.configs then
                body.configs = SdkConfig.configs;
            end;

            if SdkConfig.ab_id then
                body.ab_id = SdkConfig.ab_id;
            end;

            if SdkConfig.ab_variant_id then
                body.ab_variant_id = SdkConfig.ab_variant_id;
            end;
        end;

        v48.SdkConfig = body;
        v48.InitAuthorized = true;
    elseif statusCode == HttpApi.EGAHTTPApiResponse.Unauthorized then
        Logger:w("Initialize SDK failed - Unauthorized");
        v48.InitAuthorized = false;
    else
        if statusCode == HttpApi.EGAHTTPApiResponse.NoResponse or statusCode == HttpApi.EGAHTTPApiResponse.RequestTimeout then
            Logger:i("Init call (session start) failed - no response. Could be offline or timeout.");
        elseif statusCode == HttpApi.EGAHTTPApiResponse.BadResponse or (statusCode == HttpApi.EGAHTTPApiResponse.JsonEncodeFailed or statusCode == HttpApi.EGAHTTPApiResponse.JsonDecodeFailed) then
            Logger:i("Init call (session start) failed - bad response. Could be bad response from proxy or GA servers.");
        elseif statusCode == HttpApi.EGAHTTPApiResponse.BadRequest or statusCode == HttpApi.EGAHTTPApiResponse.UnknownResponseCode then
            Logger:i("Init call (session start) failed - bad request or unknown response.");
        end;

        v48.InitAuthorized = true;
    end;

    v48.ClientServerTimeOffset = v48.SdkConfig.time_offset or 0;
    v48.ConfigsHash = v48.SdkConfig.configs_hash or "";
    v48.AbId = v48.SdkConfig.ab_id or "";
    v48.AbVariantId = v48.SdkConfig.ab_variant_id or "";
    populateConfigurations(p45);

    if not u1:isEnabled(p45.UserId) then
        Logger:w("Could not start session: SDK is disabled.");

        return;
    end;

    if p46 then
        v48.SessionID = p46.SessionID;
        v48.SessionStart = p46.SessionStart;
    else
        v48.SessionID = string.lower(HttpService:GenerateGUID(false));
        local v51 = Store:GetPlayerDataFromCache(p45.UserId);
        local v52;

        if v51 then
            v52 = os.time();
            local v53 = v52 + v51.ClientServerTimeOffset;

            if Validation:validateClientTs(v53) then
                v52 = v53;
            end;
        else
            v52 = os.time();
        end;

        v48.SessionStart = v52;
    end;

    if u1:isEventSubmissionEnabled() then
        Events:addSessionStartEvent(p45.UserId, p46, p47);
    end;
end;

function u1.endSession(p54, p55, p56) -- Line: 277
    -- upvalues: u1 (copy), Logger (copy), Events (copy), Store (copy)
    if u1.Initialized and u1:isEventSubmissionEnabled() then
        Logger:i("Ending session.");

        if u1:isEnabled(p55) and u1:sessionIsStarted(p55) then
            Events:addSessionEndEvent(p55, p56);
            Store.PlayerCache[p55] = nil;
        end;
    end;
end;

function u1.getRemoteConfigsStringValue(p57, p58, p59, p60) -- Line: 287
    -- upvalues: Store (copy)
    return Store:GetPlayerDataFromCache(p58).Configurations[p59] or p60;
end;

function u1.isRemoteConfigsReady(p61, p62) -- Line: 292
    -- upvalues: Store (copy)
    return Store:GetPlayerDataFromCache(p62).RemoteConfigsIsReady;
end;

function u1.getRemoteConfigsContentAsString(p63, p64) -- Line: 297
    -- upvalues: Store (copy), HttpService (copy)
    return HttpService:JSONEncode(Store:GetPlayerDataFromCache(p64).Configurations);
end;

return u1;