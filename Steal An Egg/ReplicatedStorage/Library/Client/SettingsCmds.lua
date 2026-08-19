-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Event = require(ReplicatedStorage.Library.Modules.Event);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Save = require(ReplicatedStorage.Library.Client.Save);
require(script.Types.Interface);
local Variables = require(ReplicatedStorage.Library.Shared.Variables);
local wcall = require(ReplicatedStorage.Library.Functions.wcall);
local Settings = Network.NET_MAP.Settings;
assert(Settings, "Settings network map is not configured");
local SettingsInfo = Variables.SettingsInfo;
local LocalPlayer = Players.LocalPlayer;
local u1 = {};
local u2 = Event.new();
local u3 = {};

local function getDefault(p4) -- Line: 37
    -- upvalues: SettingsInfo (copy)
    local v5 = SettingsInfo[p4];

    if v5 then
        v5 = v5.default;
    end;

    return typeof(v5) ~= "boolean" and true or v5;
end;

local function sanitizeValue(p6, p7) -- Line: 46
    -- upvalues: SettingsInfo (copy)
    if typeof(p7) == "boolean" then
        return p7;
    end;

    local v8 = SettingsInfo[p6];

    if v8 then
        v8 = v8.default;
    end;

    return typeof(v8) ~= "boolean" and true or v8;
end;

local function applySetting(p9, p10) -- Line: 53
    -- upvalues: SettingsInfo (copy), u1 (copy), u2 (copy)
    if typeof(p10) ~= "boolean" then
        local v11 = SettingsInfo[p9];

        if v11 then
            v11 = v11.default;
        end;

        p10 = typeof(v11) ~= "boolean" and true or v11;
    end;

    local v12 = u1[p9];
    u1[p9] = p10;

    if v12 == p10 then
        return;
    end;

    u2:FireAsync(p9, p10);
end;

local function applySettingsMap(p13) -- Line: 63
    -- upvalues: SettingsInfo (copy), u1 (copy), u2 (copy)
    local v14 = p13 or {};

    for i in pairs(SettingsInfo) do
        local v15 = v14[i];

        if typeof(v15) ~= "boolean" then
            local v16 = SettingsInfo[i];

            if v16 then
                v16 = v16.default;
            end;

            v15 = typeof(v16) ~= "boolean" and true or v16;
        end;

        local v17 = u1[i];
        u1[i] = v15;

        if v17 ~= v15 then
            u2:FireAsync(i, v15);
        end;
    end;
end;

local function hydrateFromSave() -- Line: 70
    -- upvalues: Save (copy), applySettingsMap (copy)
    local v18 = Save.Get();

    if not v18 then
        return;
    end;

    local Settings2 = v18.Settings;

    if typeof(Settings2) == "table" then
        applySettingsMap(Settings2);

        return;
    end;

    applySettingsMap(nil);
end;

local function validateSettingKey(p19) -- Line: 85
    -- upvalues: Asserts (copy), SettingsInfo (copy)
    Asserts.string(p19);

    if not SettingsInfo[p19] then
        error(`Unknown setting key '{p19}'`, 3);
    end;
end;

function u3.GetValue(p20) -- Line: 96
    -- upvalues: Asserts (copy), SettingsInfo (copy), u1 (copy)
    Asserts.string(p20);

    if not SettingsInfo[p20] then
        error(`Unknown setting key '{p20}'`, 3);
    end;

    local v21 = u1[p20];

    if v21 ~= nil then
        return v21;
    end;

    local v22 = SettingsInfo[p20];

    if v22 then
        v22 = v22.default;
    end;

    return typeof(v22) ~= "boolean" and true or v22;
end;

function u3.IsEnabled(p23) -- Line: 105
    -- upvalues: u3 (copy)
    return u3.GetValue(p23) ~= false;
end;

function u3.Get(p24) -- Line: 109
    -- upvalues: Asserts (copy), SettingsInfo (copy), u3 (copy)
    Asserts.string(p24);

    if not SettingsInfo[p24] then
        error(`Unknown setting key '{p24}'`, 3);
    end;

    local v25 = SettingsInfo[p24];
    local v26 = u3.GetValue(p24);
    local options = v25.options;

    if typeof(options) == "table" then
        return options[v26];
    end;

    return v26;
end;

function u3.Set(p27, p28) -- Line: 120
    -- upvalues: Asserts (copy), SettingsInfo (copy), wcall (copy), Network (copy), Settings (copy), applySettingsMap (copy), u1 (copy), u2 (copy)
    Asserts.string(p27);

    if not SettingsInfo[p27] then
        error(`Unknown setting key '{p27}'`, 3);
    end;

    Asserts.boolean(p28);
    local v29, v30, v31 = wcall(Network.Invoke, Settings.REQUEST_UPDATE, p27, p28);

    if not v29 then
        return false;
    end;

    if not v30 then
        return false;
    end;

    if typeof(v31) == "table" then
        applySettingsMap(v31);
    else
        if typeof(p28) ~= "boolean" then
            local v32 = SettingsInfo[p27];

            if v32 then
                v32 = v32.default;
            end;

            p28 = typeof(v32) ~= "boolean" and true or v32;
        end;

        local v33 = u1[p27];
        u1[p27] = p28;

        if v33 ~= p28 then
            u2:FireAsync(p27, p28);
        end;
    end;

    return true;
end;

function u3.Toggle(p34) -- Line: 143
    -- upvalues: u3 (copy)
    return u3.Set(p34, not u3.IsEnabled(p34));
end;

u3.Changed = u2;
applySettingsMap(nil);

if LocalPlayer then
    Save.LoadedStats:Connect(function(p35) -- Line: 156
        -- upvalues: LocalPlayer (copy), Save (copy), applySettingsMap (copy)
        if p35 == LocalPlayer then
            local v36 = Save.Get();

            if not v36 then
                return;
            end;

            local Settings2 = v36.Settings;

            if typeof(Settings2) ~= "table" then
                applySettingsMap(nil);

                return;
            end;

            applySettingsMap(Settings2);
        end;
    end);
end;

Save.GetStatChangedSignal("Settings"):Connect(hydrateFromSave);
local v37 = Save.IsLocalDataLoaded() and Save.Get();

if v37 then
    local Settings2 = v37.Settings;

    if typeof(Settings2) == "table" then
        applySettingsMap(Settings2);
    else
        applySettingsMap(nil);
    end;
end;

Network.Fired(Settings.SETTING_CHANGED):Connect(function(p38, p39) -- Line: 169
    -- upvalues: SettingsInfo (copy), u1 (copy), u2 (copy)
    if typeof(p38) ~= "string" then
        return;
    end;

    if not SettingsInfo[p38] then
        return;
    end;

    if typeof(p39) ~= "boolean" then
        local v40 = SettingsInfo[p38];

        if v40 then
            v40 = v40.default;
        end;

        p39 = typeof(v40) ~= "boolean" and true or v40;
    end;

    local v41 = u1[p38];
    u1[p38] = p39;

    if v41 == p39 then
        return;
    end;

    u2:FireAsync(p38, p39);
end);

return u3;