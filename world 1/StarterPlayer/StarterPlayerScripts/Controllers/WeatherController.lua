-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local WeatherData = require(ReplicatedStorage.SharedModules.WeatherData);
local WeatherValues = ReplicatedStorage:WaitForChild("WeatherValues");
local Frame = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("WeatherUI"):WaitForChild("Frame");
local u2 = {};
local u3 = {};

local function GetAttr(p4, p5) -- Line: 24
    -- upvalues: WeatherValues (copy)
    return WeatherValues:GetAttribute(p4 .. "_" .. p5);
end;

local function FormatTime(p6) -- Line: 29
    if p6 <= 0 then
        return "0s";
    end;

    local v7 = math.floor(p6 / 60);
    local v8 = math.floor(p6 % 60);

    if v7 > 0 then
        return string.format("%dm %ds", v7, v8);
    end;

    return string.format("%ds", v8);
end;

local function StartEffects(p9) -- Line: 46
    -- upvalues: u2 (copy)
    local v10 = u2[p9];

    if v10 and v10.StartWeather then
        v10.StartWeather();
    end;
end;

local function StopEffects(p11) -- Line: 54
    -- upvalues: u2 (copy)
    local v12 = u2[p11];

    if v12 and v12.EndWeather then
        v12.EndWeather();
    end;
end;

local function RefreshTimeLabel(p13, p14) -- Line: 62
    -- upvalues: WeatherValues (copy)
    local v15 = workspace:GetServerTimeNow();
    local v16 = (WeatherValues:GetAttribute(p13 .. "_EndTime") or 0) - v15;
    local v17 = math.max(0, v16);
    local v18;

    if v17 <= 0 then
        v18 = "0s";
    else
        local v19 = math.floor(v17 / 60);
        local v20 = math.floor(v17 % 60);

        if v19 > 0 then
            v18 = string.format("%dm %ds", v19, v20);
        else
            v18 = string.format("%ds", v20);
        end;
    end;

    p14.Text = v18;
end;

local function StartTimer(u21, u22) -- Line: 70
    -- upvalues: u3 (copy), WeatherValues (copy), RunService (copy)
    if not u22 then
        return;
    end;

    if u3[u21] then
        u3[u21]:Disconnect();
        u3[u21] = nil;
    end;

    local v23 = workspace:GetServerTimeNow();
    local v24 = (WeatherValues:GetAttribute(u21 .. "_EndTime") or 0) - v23;
    local v25 = math.max(0, v24);
    local v26;

    if v25 <= 0 then
        v26 = "0s";
    else
        local v27 = math.floor(v25 / 60);
        local v28 = math.floor(v25 % 60);

        if v27 > 0 then
            v26 = string.format("%dm %ds", v27, v28);
        else
            v26 = string.format("%ds", v28);
        end;
    end;

    u22.Text = v26;
    u3[u21] = RunService.Heartbeat:Connect(function() -- Line: 83
        -- upvalues: u21 (copy), WeatherValues (ref), u22 (copy)
        if not WeatherValues:GetAttribute(u21 .. "_Playing") then
            return;
        end;

        local v29 = workspace:GetServerTimeNow();
        local v30 = (WeatherValues:GetAttribute(u21 .. "_EndTime") or 0) - v29;
        local v31 = math.max(0, v30);
        local v32;

        if v31 <= 0 then
            v32 = "0s";
        else
            local v33 = math.floor(v31 / 60);
            local v34 = math.floor(v31 % 60);

            if v33 > 0 then
                v32 = string.format("%dm %ds", v33, v34);
            else
                v32 = string.format("%ds", v34);
            end;
        end;

        u22.Text = v32;
    end);
end;

function v1.SetupWeather(p35, u36) -- Line: 90
    -- upvalues: u2 (copy), Frame (copy), WeatherValues (copy), StartTimer (copy), u3 (copy)
    local v37 = script:FindFirstChild(u36);

    if v37 then
        u2[u36] = require(v37);
    end;

    local u38 = Frame:FindFirstChild(u36);

    if not u38 then
        return;
    end;

    local Time = u38:FindFirstChild("Time");
    local v39 = WeatherValues:GetAttribute(u36 .. "_Playing");
    u38.Visible = v39 or false;

    if v39 then
        local v40 = u2[u36];

        if v40 and v40.StartWeather then
            v40.StartWeather();
        end;

        StartTimer(u36, Time);
    end;

    WeatherValues:GetAttributeChangedSignal(u36 .. "_Playing"):Connect(function() -- Line: 113
        -- upvalues: u36 (copy), WeatherValues (ref), u38 (copy), u2 (ref), StartTimer (ref), Time (copy), u3 (ref)
        local v41 = WeatherValues:GetAttribute(u36 .. "_Playing");
        u38.Visible = v41;

        if v41 then
            local v42 = u2[u36];

            if v42 and v42.StartWeather then
                v42.StartWeather();
            end;

            StartTimer(u36, Time);

            return;
        end;

        local v43 = u2[u36];

        if v43 and v43.EndWeather then
            v43.EndWeather();
        end;

        if u3[u36] then
            u3[u36]:Disconnect();
            u3[u36] = nil;
        end;
    end);
end;

function v1.Init(p44) -- Line: 133
end;

function v1.Start(p45) -- Line: 138
    -- upvalues: WeatherData (copy)
    for _, v in WeatherData.Data do
        p45:SetupWeather(v.Name);
    end;
end;

return v1;