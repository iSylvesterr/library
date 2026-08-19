-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
local Signal = require(ReplicatedStorage.Library.Modules.Packages.Signal);
local GameAnalytics = require(ReplicatedStorage.Library.Modules.Packages.GameAnalytics);
local ABTestExperiments = require(ReplicatedStorage.Directory.ABTestExperiments);
local LocalPlayer = Players.LocalPlayer;
local v12 = {
    _loaded = false,
    _loadedSignal = Signal.new(),
    _remoteConfigs = {},

    _runExperiments = function(p1) -- Line: 27, Name: _runExperiments
        -- upvalues: ABTestExperiments (copy), LocalPlayer (copy)
        if not p1._remoteConfigs then
            return;
        end;

        for _, v in ABTestExperiments do
            if not v.Disabled then
                local v2 = p1._remoteConfigs[v.RemoteConfig] or v.DefaultState;
                local v3 = v.States[v2];

                if v3 and v3.Client then
                    task.defer(v3.Client, LocalPlayer, v2);
                end;
            end;
        end;
    end,

    IsLoaded = function(p4) -- Line: 43, Name: IsLoaded
        return p4._loaded;
    end,

    OnLoad = function(p5, p6) -- Line: 47, Name: OnLoad
        return p5._loadedSignal:Connect(p6);
    end,

    GetRemoteConfig = function(p7, p8) -- Line: 51, Name: GetRemoteConfig
        return p7._remoteConfigs[p8], p7:IsLoaded();
    end,

    Start = function(u9) -- Line: 55, Name: Start
        -- upvalues: GameAnalytics (copy), ReplicatedStorage (copy), HttpService (copy)
        GameAnalytics:initClient();
        ReplicatedStorage:WaitForChild("GameAnalyticsRemoteConfigs").OnClientEvent:Connect(function(p10) -- Line: 57
            -- upvalues: HttpService (ref), u9 (copy)
            if typeof(p10) ~= "table" then
                return;
            end;

            local v11 = {};

            for i, v in pairs(p10) do
                local success, result = pcall(HttpService.JSONDecode, HttpService, v);

                if success then
                    if result == nil then
                        result = v;
                    end;
                else
                    result = v;
                end;

                v11[i] = result;
            end;

            u9._remoteConfigs = v11;

            if not u9._loaded then
                u9._loaded = true;
                u9._loadedSignal:Fire(v11);
                u9:_runExperiments();
            end;
        end);
    end
};
task.spawn(v12.Start, v12);

return v12;