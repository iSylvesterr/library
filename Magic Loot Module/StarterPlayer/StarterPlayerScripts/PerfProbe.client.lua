-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Stats = game:GetService("Stats");
local PerfProbeConfig = require(ReplicatedStorage:WaitForChild("ClientSideCode"):WaitForChild("PerfProbeConfig"));

if not PerfProbeConfig.Enabled then
    return;
end;

local LocalPlayer = Players.LocalPlayer;

local function isUserAllowed(p1, p2) -- Line: 34
    if type(p1) ~= "table" then
        return true;
    end;

    local v3 = false;

    for _, v in p1 do
        if tonumber(v) == p2 then
            return true;
        end;

        v3 = true;
    end;

    return not v3;
end;

local AllowedUserIds = PerfProbeConfig.AllowedUserIds;
local UserId = LocalPlayer.UserId;
local v4;

if type(AllowedUserIds) == "table" then
    local v5 = false;

    for _, v in AllowedUserIds do
        if tonumber(v) == UserId then
            v4 = true;
            break;
        end;

        v5 = true;
    end;

    v4 = not v5;
else
    v4 = true;
end;

if not v4 then
    return;
end;

local u6 = tostring(PerfProbeConfig.LogPrefix or "[PERFHOST]");
local u7 = tonumber(PerfProbeConfig.SampleIntervalSec) or 1;
local u8 = tonumber(PerfProbeConfig.PingIntervalSec) or 5;
local u9 = tonumber(PerfProbeConfig.StutterFrameSec) or 0.05;
local u10 = tonumber(PerfProbeConfig.ReadyDelaySec) or 1;
local u11 = tostring(PerfProbeConfig.ReadyBoolValueName or "");
local u12 = tostring(PerfProbeConfig.RemoteFolderName or "PerfProbe");
local u13 = tostring(PerfProbeConfig.PingRemoteName or "Ping");
local u14 = false;
local u15 = 0;
local u16 = 0;
local u17 = nil;
local u18 = false;
local u19 = 0;
local u20 = 0;
local u21 = 0;
local u22 = 0;
local u23 = 0;
local u24 = nil;

local function ensurePingRemote() -- Line: 90
    -- upvalues: ReplicatedStorage (copy), u12 (copy), u13 (copy)
    local v25 = ReplicatedStorage:FindFirstChild(u12);

    if not v25 then
        return nil;
    end;

    local v26 = v25:FindFirstChild(u13);

    if v26 and v26:IsA("RemoteFunction") then
        return v26;
    end;

    return nil;
end;

local function requestPing() -- Line: 102
    -- upvalues: u18 (ref), u24 (ref), ReplicatedStorage (copy), u12 (copy), u13 (copy), u17 (ref)
    if u18 then
        return;
    end;

    if not u24 then
        local v27 = ReplicatedStorage:FindFirstChild(u12);
        local v28;

        if v27 then
            v28 = v27:FindFirstChild(u13);

            if not (v28 and v28:IsA("RemoteFunction")) then
                v28 = nil;
            end;
        else
            v28 = nil;
        end;

        u24 = v28;
    end;

    if not u24 then
        return;
    end;

    u18 = true;
    local u29 = os.clock();
    task.spawn(function() -- Line: 114
        -- upvalues: u24 (ref), u17 (ref), u29 (copy), u18 (ref)
        if pcall(function() -- Line: 115
            -- upvalues: u24 (ref)
            u24:InvokeServer();
        end) then
            u17 = (os.clock() - u29) * 1000;
        end;

        u18 = false;
    end);
end;

local function emit(p30, p31, p32) -- Line: 125
    -- upvalues: Stats (copy), u17 (ref), u19 (ref), u20 (ref), u14 (ref), LocalPlayer (copy), HttpService (copy), u6 (copy)
    local u33 = nil;
    pcall(function() -- Line: 127
        -- upvalues: Stats (ref), u33 (ref)
        if Stats.MemoryTrackingEnabled then
            u33 = Stats:GetTotalMemoryUsageMb();
        end;
    end);
    local u34 = {
        t = os.clock()
    };
    local v35;

    if p30 > 0 then
        v35 = 1 / p30;
    else
        v35 = nil;
    end;

    u34.fps = v35;
    u34.ft = p30;
    u34.ft_max = p31;
    u34.frames = p32;
    u34.ping = u17;
    u34.mem = u33;
    u34.stutter = u19;
    u34.stutter_ms = u20;
    u34.ready = u14;
    u34.place_id = game.PlaceId;
    u34.game_id = game.GameId;
    u34.job_id = game.JobId;
    u34.place_name = game.Name;
    u34.player_name = LocalPlayer.Name;
    u34.display_name = LocalPlayer.DisplayName;
    u34.user_id = LocalPlayer.UserId;
    u19 = 0;
    u20 = 0;
    local success, result = pcall(function() -- Line: 153
        -- upvalues: HttpService (ref), u34 (copy)
        return HttpService:JSONEncode(u34);
    end);

    if success then
        print(u6 .. result);
    end;
end;

task.spawn(function() -- Line: 74, Name: waitReady
    -- upvalues: u11 (copy), LocalPlayer (copy), u10 (copy), u14 (ref)
    if u11 ~= "" then
        local v36 = LocalPlayer:WaitForChild(u11, 120);

        if v36 and v36:IsA("BoolValue") then
            while not v36.Value do
                v36.Changed:Wait();
            end;
        end;
    end;

    if not LocalPlayer.Character then
        LocalPlayer.CharacterAdded:Wait();
    end;

    task.wait(u10);
    u14 = true;
end);
RunService.Heartbeat:Connect(function(p37) -- Line: 163
    -- upvalues: Stats (copy), u9 (copy), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), u15 (ref), u16 (ref), u8 (copy), requestPing (copy), u7 (copy), emit (copy)
    local FrameTime = Stats.FrameTime;

    if typeof(FrameTime) ~= "number" or FrameTime <= 0 then
        FrameTime = p37;
    end;

    if u9 < FrameTime then
        u19 = u19 + 1;
        u20 = u20 + (FrameTime - u9) * 1000;
    end;

    u21 = u21 + FrameTime;
    u22 = u22 + 1;

    if u23 < FrameTime then
        u23 = FrameTime;
    end;

    u15 = u15 + p37;
    u16 = u16 + p37;

    if u8 <= u16 then
        u16 = 0;
        requestPing();
    end;

    if u15 < u7 then
        return;
    end;

    u15 = 0;

    if u22 <= 0 or u21 <= 0 then
        u21 = 0;
        u22 = 0;
        u23 = 0;

        return;
    end;

    local v38 = u21 / u22;
    local v39 = u23;
    local v40 = u22;
    u21 = 0;
    u22 = 0;
    u23 = 0;
    emit(v38, v39, v40);
end);