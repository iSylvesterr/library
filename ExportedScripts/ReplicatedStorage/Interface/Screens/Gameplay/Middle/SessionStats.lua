-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local Observers = require(ReplicatedStorage.Packages.Observers);
local u2 = table.find(GetUserPlatform(), "Mobile") ~= nil;
local u3 = os.clock();
local u4 = 0;
local u5 = 0;
local u6 = false;
local u7 = false;
local u8 = {};
local u9 = nil;
local u10 = nil;

local function UpdateServerStats(p11) -- Line: 46
    -- upvalues: u10 (ref), Constants (copy)
    u10.Server.Text = `Location: {p11}, Version: {Constants.VERSION}`;
end;

local function IsFiniteNumber(p12) -- Line: 52
    if typeof(p12) ~= "number" then
        return false;
    end;

    local v13;

    if p12 == p12 and p12 ~= (1 / 0) then
        v13 = p12 ~= (-1 / 0);
    else
        v13 = false;
    end;

    return v13;
end;

local function UpdatePlayerText(p14, p15) -- Line: 62
    -- upvalues: u7 (ref), u5 (ref), u8 (copy), u6 (ref), u10 (ref)
    local v16 = {};

    if u7 then
        local v17 = u5;

        if #u8 > 0 then
            local v18 = 0;
            local v19 = 0;

            for _, v in ipairs(u8) do
                local v20;

                if typeof(v) == "number" and (v == v and v ~= (1 / 0)) then
                    v20 = v ~= (-1 / 0);
                else
                    v20 = false;
                end;

                if v20 then
                    v18 = v18 + v;
                    v19 = v19 + 1;
                end;
            end;

            if v19 > 0 then
                v17 = math.round(v18 / v19);
            end;
        end;

        local v21 = `Fps: {tostring(v17)}`;
        table.insert(v16, v21);
    end;

    if u6 then
        local v22 = `Ping: {p15}ms`;
        table.insert(v16, v22);
    end;

    u10.Player.Text = table.concat(v16, ", ");
    u10.Player.Visible = #v16 > 0;
end;

local function UpdatePlayerStats(p23, p24) -- Line: 98
    -- upvalues: u5 (ref), u8 (copy), u4 (ref), u3 (ref), UpdatePlayerText (copy)
    local v25 = os.clock();
    local v26;

    if typeof(p23) == "number" and (p23 == p23 and p23 ~= (1 / 0)) then
        v26 = p23 ~= (-1 / 0);
    else
        v26 = false;
    end;

    local v27;

    if v26 then
        v27 = p23;
    else
        v27 = u5;
    end;

    table.insert(u8, v27);
    u4 = p24;
    u5 = v27;

    if v25 - u3 >= 1 then
        u3 = v25;
        UpdatePlayerText(p23, p24);
        table.clear(u8);
    end;
end;

local function StopStatsUpdate() -- Line: 119
    -- upvalues: u9 (ref)
    if u9 then
        u9:Disconnect();
        u9 = nil;
    end;
end;

local function RunStatsUpdate(p28) -- Line: 128
    -- upvalues: u10 (ref), u7 (ref), u6 (ref), u9 (ref), LocalPlayer (copy), u5 (ref), UpdatePlayerStats (copy)
    if not (u10.Visible and (u7 or u6)) then
        if u9 then
            u9:Disconnect();
            u9 = nil;
        end;

        return;
    end;

    local v29 = LocalPlayer:GetAttribute("Ping");
    local v30 = tonumber(v29) or 999;
    local v31 = u5;

    if p28 > 0 then
        v31 = math.round(1 / p28);
    end;

    local v32;

    if typeof(v31) == "number" and (v31 == v31 and v31 ~= (1 / 0)) then
        v32 = v31 ~= (-1 / 0);
    else
        v32 = false;
    end;

    if not v32 then
        v31 = u5;
    end;

    UpdatePlayerStats(v31, v30);
end;

local function SyncStatsUpdate() -- Line: 149
    -- upvalues: u2 (copy), u10 (ref), u7 (ref), u6 (ref), u9 (ref), u3 (ref), RunServiceController (copy), RunStatsUpdate (copy), LocalPlayer (copy), u5 (ref), UpdatePlayerStats (copy)
    if u2 or not u10 then
        return;
    end;

    if not (u10.Visible and (u7 or u6)) then
        if u9 then
            u9:Disconnect();
            u9 = nil;
        end;

        return;
    end;

    if u9 then
        return;
    end;

    u3 = os.clock();
    u9 = RunServiceController.BindToHeartbeat("UI.SessionStats.UpdatePlayerStats", RunStatsUpdate);

    if u10.Visible and (u7 or u6) then
        local v33 = LocalPlayer:GetAttribute("Ping");
        local v34 = tonumber(v33) or 999;
        local v35 = u5;
        local v36;

        if typeof(v35) == "number" and (v35 == v35 and v35 ~= (1 / 0)) then
            v36 = v35 ~= (-1 / 0);
        else
            v36 = false;
        end;

        if not v36 then
            v35 = u5;
        end;

        UpdatePlayerStats(v35, v34);
    elseif u9 then
        u9:Disconnect();
        u9 = nil;
    end;
end;

function v1.Initialize(p37, p38) -- Line: 171
    -- upvalues: u10 (ref), u2 (copy), u6 (ref), DataController (copy), LocalPlayer (copy), u7 (ref), Constants (copy), UpdatePlayerText (copy), u5 (ref), u4 (ref), u9 (ref), u3 (ref), RunServiceController (copy), RunStatsUpdate (copy), UpdatePlayerStats (copy), SyncStatsUpdate (copy), Observers (copy)
    u10 = p38;
    u10.Visible = false;

    if u2 then
        u10:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 176
            -- upvalues: u10 (ref)
            if not u10.Visible then
                return;
            end;

            u10.Visible = false;
        end);

        return;
    end;

    u6 = DataController.Get(LocalPlayer, "Settings.Game.Other.Show Ping") == true;
    u7 = DataController.Get(LocalPlayer, "Settings.Game.Other.Show FPS") == true;
    u10.Server.Text = `Location: Unknown, Version: {Constants.VERSION}`;
    DataController.CreateListener(LocalPlayer, "Settings.Game.Other.Show FPS", function(p39) -- Line: 189
        -- upvalues: u7 (ref), u10 (ref), UpdatePlayerText (ref), u5 (ref), u4 (ref), u2 (ref), u6 (ref), u9 (ref), u3 (ref), RunServiceController (ref), RunStatsUpdate (ref), LocalPlayer (ref), UpdatePlayerStats (ref)
        u7 = p39 == true;

        if u10.Visible then
            UpdatePlayerText(u5, u4);
        end;

        if not u2 then
            if not u10 then
                return;
            end;

            if u10.Visible and (u7 or u6) then
                if u9 then
                    return;
                end;

                u3 = os.clock();
                u9 = RunServiceController.BindToHeartbeat("UI.SessionStats.UpdatePlayerStats", RunStatsUpdate);

                if u10.Visible and (u7 or u6) then
                    local v40 = LocalPlayer:GetAttribute("Ping");
                    local v41 = tonumber(v40) or 999;
                    local v42 = u5;
                    local v43;

                    if typeof(v42) == "number" and (v42 == v42 and v42 ~= (1 / 0)) then
                        v43 = v42 ~= (-1 / 0);
                    else
                        v43 = false;
                    end;

                    if not v43 then
                        v42 = u5;
                    end;

                    UpdatePlayerStats(v42, v41);

                    return;
                end;

                if u9 then
                    u9:Disconnect();
                    u9 = nil;
                end;
            elseif u9 then
                u9:Disconnect();
                u9 = nil;
            end;
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Game.Other.Show Ping", function(p44) -- Line: 198
        -- upvalues: u6 (ref), u10 (ref), UpdatePlayerText (ref), u5 (ref), u4 (ref), u2 (ref), u7 (ref), u9 (ref), u3 (ref), RunServiceController (ref), RunStatsUpdate (ref), LocalPlayer (ref), UpdatePlayerStats (ref)
        u6 = p44 == true;

        if u10.Visible then
            UpdatePlayerText(u5, u4);
        end;

        if not u2 then
            if not u10 then
                return;
            end;

            if u10.Visible and (u7 or u6) then
                if u9 then
                    return;
                end;

                u3 = os.clock();
                u9 = RunServiceController.BindToHeartbeat("UI.SessionStats.UpdatePlayerStats", RunStatsUpdate);

                if u10.Visible and (u7 or u6) then
                    local v45 = LocalPlayer:GetAttribute("Ping");
                    local v46 = tonumber(v45) or 999;
                    local v47 = u5;
                    local v48;

                    if typeof(v47) == "number" and (v47 == v47 and v47 ~= (1 / 0)) then
                        v48 = v47 ~= (-1 / 0);
                    else
                        v48 = false;
                    end;

                    if not v48 then
                        v47 = u5;
                    end;

                    UpdatePlayerStats(v47, v46);

                    return;
                end;

                if u9 then
                    u9:Disconnect();
                    u9 = nil;
                end;
            elseif u9 then
                u9:Disconnect();
                u9 = nil;
            end;
        end;
    end);
    u10:GetPropertyChangedSignal("Visible"):Connect(SyncStatsUpdate);

    if not u2 and u10 then
        if u10.Visible and (u7 or u6) then
            if not u9 then
                u3 = os.clock();
                u9 = RunServiceController.BindToHeartbeat("UI.SessionStats.UpdatePlayerStats", RunStatsUpdate);

                if u10.Visible and (u7 or u6) then
                    local v49 = LocalPlayer:GetAttribute("Ping");
                    local v50 = tonumber(v49) or 999;
                    local v51 = u5;
                    local v52;

                    if typeof(v51) == "number" and (v51 == v51 and v51 ~= (1 / 0)) then
                        v52 = v51 ~= (-1 / 0);
                    else
                        v52 = false;
                    end;

                    if not v52 then
                        v51 = u5;
                    end;

                    UpdatePlayerStats(v51, v50);
                elseif u9 then
                    u9:Disconnect();
                    u9 = nil;
                end;
            end;
        elseif u9 then
            u9:Disconnect();
            u9 = nil;
        end;
    end;

    Observers.observeAttribute(workspace, "Timezone", function(p53) -- Line: 209
        -- upvalues: u10 (ref), Constants (ref)
        u10.Server.Text = `Location: {p53}, Version: {Constants.VERSION}`;

        return function() -- Line: 212
            -- upvalues: u10 (ref), Constants (ref)
            u10.Server.Text = `Location: Unknown, Version: {Constants.VERSION}`;
        end;
    end);
end;

return v1;