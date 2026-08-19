-- Decompiled with Potassium's decompiler.

local ContentProvider = game:GetService("ContentProvider");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
require(ReplicatedStorage.SharedModules.Environment);
local v1 = {};
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = 0;
local u6 = {};
local BindableEvent = Instance.new("BindableEvent");
v1.Changed = BindableEvent.Event;

local function nowUnix() -- Line: 127
    -- upvalues: u5 (ref)
    return os.time() + u5;
end;

local function optAssetId(p7) -- Line: 131
    if typeof(p7) == "number" and p7 > 0 then
        return p7;
    end;

    return nil;
end;

local function normalizeType(p8) -- Line: 141
    if typeof(p8) ~= "string" then
        return "default";
    end;

    local v9 = string.lower(p8):gsub("[^%a%d_]", "");

    if v9 == "" then
        return "default";
    end;

    if #v9 > 24 then
        v9 = string.sub(v9, 1, 24);
    end;

    return v9;
end;

local function assetUrl(p10) -- Line: 155
    if p10 then
        return string.format("rbxassetid://%d", p10);
    end;

    return nil;
end;

local function fmt(p11) -- Line: 163
    local v12 = math.floor(p11);
    local v13 = math.max(0, v12);
    local v14 = v13 // 3600;
    local v15 = v13 % 3600 // 60;
    local v16 = v13 % 60;

    if v14 > 0 then
        return string.format("%dh %02dm", v14, v15);
    end;

    if v15 > 0 then
        return string.format("%dm %02ds", v15, v16);
    end;

    return string.format("%ds", v16);
end;

local function getActiveList() -- Line: 180
    -- upvalues: u5 (ref), u4 (copy), u2 (ref)
    local v17 = os.time() + u5;
    local v18 = {};
    local v19 = {};

    for i, v in u4 do
        if v17 < v.grace_end_unix then
            table.insert(v18, v);
            v19[i] = true;
        end;
    end;

    for _, v in u2 do
        if v17 < v.grace_end_unix and not v19[v.id] then
            table.insert(v18, v);
        end;
    end;

    table.sort(v18, function(p20, p21) -- Line: 195
        return p20.release_unix < p21.release_unix;
    end);

    return v18;
end;

local function queuePreload(p22, p23) -- Line: 201
    -- upvalues: u6 (copy)
    local v24;

    if p23 then
        v24 = string.format("rbxassetid://%d", p23);
    else
        v24 = nil;
    end;

    if v24 and not u6[v24] then
        u6[v24] = true;
        table.insert(p22, v24);
    end;
end;

local function preloadAll() -- Line: 212
    -- upvalues: u2 (ref), u6 (copy), u3 (ref), ContentProvider (copy)
    local u25 = {};

    for _, v in u2 do
        local reveal_asset_id = v.reveal_asset_id;
        local v26;

        if reveal_asset_id then
            v26 = string.format("rbxassetid://%d", reveal_asset_id);
        else
            v26 = nil;
        end;

        if v26 and not u6[v26] then
            u6[v26] = true;
            table.insert(u25, v26);
        end;

        local silhouette_asset_id = v.silhouette_asset_id;
        local v27;

        if silhouette_asset_id then
            v27 = string.format("rbxassetid://%d", silhouette_asset_id);
        else
            v27 = nil;
        end;

        if v27 and not u6[v27] then
            u6[v27] = true;
            table.insert(u25, v27);
        end;
    end;

    for _, v in u3 do
        local reveal_asset_id = v.reveal_asset_id;
        local v28;

        if reveal_asset_id then
            v28 = string.format("rbxassetid://%d", reveal_asset_id);
        else
            v28 = nil;
        end;

        if v28 and not u6[v28] then
            u6[v28] = true;
            table.insert(u25, v28);
        end;

        local silhouette_asset_id = v.silhouette_asset_id;
        local v29;

        if silhouette_asset_id then
            v29 = string.format("rbxassetid://%d", silhouette_asset_id);
        else
            v29 = nil;
        end;

        if v29 and not u6[v29] then
            u6[v29] = true;
            table.insert(u25, v29);
        end;
    end;

    if #u25 == 0 then
        return;
    end;

    task.spawn(function() -- Line: 225
        -- upvalues: ContentProvider (ref), u25 (copy)
        pcall(function() -- Line: 226
            -- upvalues: ContentProvider (ref), u25 (ref)
            ContentProvider:PreloadAsync(u25);
        end);
    end);
end;

local function applySnapshot(p30) -- Line: 232
    -- upvalues: u5 (ref), u2 (ref), u3 (ref), preloadAll (copy), BindableEvent (copy), getActiveList (copy)
    if typeof(p30) ~= "table" then
        return;
    end;

    local v31 = {};
    local active = p30.active;

    if typeof(active) == "table" then
        for _, v in active do
            if typeof(v) == "table" and (typeof(v.id) == "string" and (v.id ~= "" and (typeof(v.release_unix) == "number" and typeof(v.grace_end_unix) == "number"))) then
                local v32 = {
                    id = v.id,
                    name = typeof(v.name) ~= "string" and "" or v.name,
                    description = typeof(v.description) ~= "string" and "" or v.description
                };
                local type = v.type;
                local v33;

                if typeof(type) == "string" then
                    v33 = string.lower(type):gsub("[^%a%d_]", "");

                    if v33 == "" then
                        v33 = "default";
                    elseif #v33 > 24 then
                        v33 = string.sub(v33, 1, 24);
                    end;
                else
                    v33 = "default";
                end;

                v32.type = v33;
                v32.state = v.state == "live" and "live" or "countdown";
                v32.release_unix = v.release_unix;
                v32.seconds_remaining = typeof(v.seconds_remaining) ~= "number" and 0 or v.seconds_remaining;
                v32.grace_end_unix = v.grace_end_unix;
                local reveal_asset_id = v.reveal_asset_id;

                if typeof(reveal_asset_id) ~= "number" or reveal_asset_id <= 0 then
                    reveal_asset_id = nil;
                end;

                v32.reveal_asset_id = reveal_asset_id;
                local silhouette_asset_id = v.silhouette_asset_id;

                if typeof(silhouette_asset_id) ~= "number" or silhouette_asset_id <= 0 then
                    silhouette_asset_id = nil;
                end;

                v32.silhouette_asset_id = silhouette_asset_id;
                table.insert(v31, v32);
            end;
        end;
    end;

    local v34 = {};
    local assets = p30.assets;

    if typeof(assets) == "table" then
        for _, v in assets do
            if typeof(v) == "table" and (typeof(v.id) == "string" and v.id ~= "") then
                local v35 = {
                    id = v.id,
                    name = typeof(v.name) ~= "string" and "" or v.name
                };
                local reveal_asset_id = v.reveal_asset_id;

                if typeof(reveal_asset_id) ~= "number" or reveal_asset_id <= 0 then
                    reveal_asset_id = nil;
                end;

                v35.reveal_asset_id = reveal_asset_id;
                local silhouette_asset_id = v.silhouette_asset_id;

                if typeof(silhouette_asset_id) ~= "number" or silhouette_asset_id <= 0 then
                    silhouette_asset_id = nil;
                end;

                v35.silhouette_asset_id = silhouette_asset_id;
                table.insert(v34, v35);
            end;
        end;
    end;

    if typeof(p30.server_now_unix) == "number" then
        u5 = p30.server_now_unix - os.time();
    end;

    u2 = v31;
    u3 = v34;
    preloadAll();
    BindableEvent:Fire((getActiveList()));
end;

local function pruneExpired() -- Line: 301
    -- upvalues: u5 (ref), u2 (ref), u4 (copy)
    local v36 = os.time() + u5;
    local v37 = false;

    for i = #u2, 1, -1 do
        if u2[i].grace_end_unix <= v36 then
            table.remove(u2, i);
            v37 = true;
        end;
    end;

    for i, v in u4 do
        if v.grace_end_unix <= v36 then
            u4[i] = nil;
            v37 = true;
        end;
    end;

    return v37;
end;

local function hasAnyActive() -- Line: 319
    -- upvalues: u2 (ref), u4 (copy)
    return #u2 > 0 and true or next(u4) ~= nil;
end;

local function buildDisplay(p38) -- Line: 326
    -- upvalues: u5 (ref), fmt (copy)
    local v39 = p38.release_unix - (os.time() + u5);
    local v40 = (p38.state == "live" or v39 <= 0) and "live" or "countdown";
    local reveal_asset_id = p38.reveal_asset_id;
    local v41;

    if reveal_asset_id then
        v41 = string.format("rbxassetid://%d", reveal_asset_id);
    else
        v41 = nil;
    end;

    local silhouette_asset_id = p38.silhouette_asset_id;
    local v42;

    if silhouette_asset_id then
        v42 = string.format("rbxassetid://%d", silhouette_asset_id);
    else
        v42 = nil;
    end;

    local v43;

    if v40 == "live" then
        v43 = v41 or v42;
    else
        v43 = v42 or v41;
    end;

    return {
        id = p38.id,
        name = p38.name,
        description = p38.description,
        type = p38.type,
        state = v40,
        remaining = math.max(0, v39),
        label = fmt(v39),
        reveal_asset_id = p38.reveal_asset_id,
        silhouette_asset_id = p38.silhouette_asset_id,
        revealImage = v41,
        silhouetteImage = v42,
        icon = v43
    };
end;

function v1.GetPrimary(p44) -- Line: 353
    -- upvalues: getActiveList (copy), buildDisplay (copy)
    local v45 = getActiveList();

    if #v45 == 0 then
        return nil;
    end;

    return buildDisplay(v45[1]);
end;

function v1.GetDisplayList(p46) -- Line: 363
    -- upvalues: getActiveList (copy), buildDisplay (copy)
    local v47 = {};

    for _, v in getActiveList() do
        local v48 = buildDisplay(v);
        table.insert(v47, v48);
    end;

    return v47;
end;

function v1.GetActive(p49) -- Line: 372
    -- upvalues: getActiveList (copy)
    return getActiveList();
end;

function v1.GetAssets(p50) -- Line: 377
    -- upvalues: u3 (ref)
    return table.clone(u3);
end;

function v1.NowUnix(p51) -- Line: 382
    -- upvalues: u5 (ref)
    return os.time() + u5;
end;

function v1.Format(p52, p53) -- Line: 387
    -- upvalues: fmt (copy)
    return fmt(p53);
end;

function v1.DebugInject(p54, p55) -- Line: 396
    -- upvalues: u5 (ref), u4 (copy), preloadAll (copy), BindableEvent (copy), getActiveList (copy)
    local v56 = p55 or {};
    local v57 = (typeof(v56.id) ~= "string" or v56.id == "") and "dev_test_event" or v56.id;
    local v58 = (typeof(v56.name) ~= "string" or v56.name == "") and "Test Event" or v56.name;
    local v59 = typeof(v56.description) ~= "string" and "" or v56.description;
    local v60 = typeof(v56.secondsUntil) ~= "number" and 1800 or v56.secondsUntil;
    local v61 = typeof(v56.graceSeconds) ~= "number" and 1800 or math.max(0, v56.graceSeconds);
    local v62 = os.time() + u5 + v60;
    local v63 = {
        id = v57,
        name = v58,
        description = v59
    };
    local type = v56.type;
    local v64;

    if typeof(type) == "string" then
        v64 = string.lower(type):gsub("[^%a%d_]", "");

        if v64 == "" then
            v64 = "default";
        elseif #v64 > 24 then
            v64 = string.sub(v64, 1, 24);
        end;
    else
        v64 = "default";
    end;

    v63.type = v64;
    v63.state = v60 <= 0 and "live" or "countdown";
    v63.release_unix = v62;
    v63.seconds_remaining = math.max(0, v60);
    v63.grace_end_unix = v62 + v61;
    local reveal_asset_id = v56.reveal_asset_id;

    if typeof(reveal_asset_id) ~= "number" or reveal_asset_id <= 0 then
        reveal_asset_id = nil;
    end;

    v63.reveal_asset_id = reveal_asset_id;
    local silhouette_asset_id = v56.silhouette_asset_id;

    if typeof(silhouette_asset_id) ~= "number" or silhouette_asset_id <= 0 then
        silhouette_asset_id = nil;
    end;

    v63.silhouette_asset_id = silhouette_asset_id;
    u4[v57] = v63;
    preloadAll();
    BindableEvent:Fire((getActiveList()));

    return v63;
end;

function v1.DebugClear(p65) -- Line: 425
    -- upvalues: u4 (copy), BindableEvent (copy), getActiveList (copy)
    local v66 = 0;

    for _ in u4 do
        v66 = v66 + 1;
    end;

    table.clear(u4);
    BindableEvent:Fire((getActiveList()));

    return v66;
end;

function v1.Init(p67) -- Line: 437
    -- upvalues: Networking (copy), applySnapshot (copy), RunService (copy), u2 (ref), u4 (copy), pruneExpired (copy), BindableEvent (copy), getActiveList (copy)
    Networking.Release.Snapshot.OnClientEvent:Connect(applySnapshot);
    local success, result = pcall(function() -- Line: 441
        -- upvalues: Networking (ref)
        return Networking.Release.Request:Fire();
    end);

    if success then
        applySnapshot(result);
    else
        warn("[ReleaseCountdownController] initial Release.Request failed:", (tostring(result)));
    end;

    local u68 = 0;
    RunService.Heartbeat:Connect(function(p69) -- Line: 453
        -- upvalues: u2 (ref), u4 (ref), u68 (ref), pruneExpired (ref), BindableEvent (ref), getActiveList (ref)
        if #u2 <= 0 and next(u4) == nil then
            return;
        end;

        u68 = u68 + p69;

        if u68 < 0.5 then
            return;
        end;

        u68 = 0;

        if pruneExpired() then
            BindableEvent:Fire((getActiveList()));
        end;
    end);
end;

return v1;