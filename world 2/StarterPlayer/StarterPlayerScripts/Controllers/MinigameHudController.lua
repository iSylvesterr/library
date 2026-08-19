-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;
local u3 = nil;
local u4 = {};
local u5 = {};

local function FormatTime(p6) -- Line: 39
    if p6 <= 0 then
        return "0s";
    end;

    local v7 = math.floor(p6 / 3600);
    local v8 = math.floor(p6 % 3600 / 60);
    local v9 = math.floor(p6 % 60);

    if v7 > 0 then
        return string.format("%dh %dm", v7, v8);
    end;

    if v8 > 0 then
        return string.format("%dm %ds", v8, v9);
    end;

    return string.format("%ds", v9);
end;

local function GetTimeLabel(p10) -- Line: 59
    local Time = p10:FindFirstChild("Time");

    if Time and Time:IsA("TextLabel") then
        return Time;
    end;

    return nil;
end;

local function ReadEndsAt(p11) -- Line: 67
    local v12 = p11:GetAttribute("EndsAt");

    return type(v12) ~= "number" and 0 or v12;
end;

local function ReadDisplayName(p13) -- Line: 73
    local v14 = p13:GetAttribute("DisplayName");

    if type(v14) == "string" and v14 ~= "" then
        return v14;
    end;

    return p13.Name;
end;

local function StopTimer(p15) -- Line: 79
    -- upvalues: u5 (copy)
    local v16 = u5[p15];

    if not v16 then
        return;
    end;

    v16:Disconnect();
    u5[p15] = nil;
end;

local function StartTimer(p17, u18, u19) -- Line: 87
    -- upvalues: u5 (copy), FormatTime (copy), RunService (copy)
    local v20 = u5[p17];

    if v20 then
        v20:Disconnect();
        u5[p17] = nil;
    end;

    local function Refresh() -- Line: 90
        -- upvalues: u19 (copy), FormatTime (ref), u18 (copy)
        local v21 = u18:GetAttribute("EndsAt");
        u19.Text = FormatTime((type(v21) ~= "number" and 0 or v21) - workspace:GetServerTimeNow());
    end;

    local v22 = u18:GetAttribute("EndsAt");
    u19.Text = FormatTime((type(v22) ~= "number" and 0 or v22) - workspace:GetServerTimeNow());
    u5[p17] = RunService.Heartbeat:Connect(Refresh);
end;

local function RefreshCard(u23, p24) -- Line: 98
    -- upvalues: u5 (copy), FormatTime (copy), RunService (copy)
    local v25 = u23:GetAttribute("Active") == true;
    p24.Visible = v25;
    local Time = p24:FindFirstChild("Time");

    if not (Time and Time:IsA("TextLabel")) then
        Time = nil;
    end;

    if v25 then
        local v26 = u23:GetAttribute("EndsAt");
        v25 = (type(v26) ~= "number" and 0 or v26) > 0;
    end;

    if Time then
        Time.Visible = v25;
    end;

    if not (v25 and Time) then
        local Name = u23.Name;
        local v27 = u5[Name];

        if not v27 then
            return;
        end;

        v27:Disconnect();
        u5[Name] = nil;

        return;
    end;

    local Name = u23.Name;
    local v28 = u5[Name];

    if v28 then
        v28:Disconnect();
        u5[Name] = nil;
    end;

    local function v30() -- Line: 90
        -- upvalues: Time (copy), FormatTime (ref), u23 (copy)
        local v29 = u23:GetAttribute("EndsAt");
        Time.Text = FormatTime((type(v29) ~= "number" and 0 or v29) - workspace:GetServerTimeNow());
    end;

    local v31 = u23:GetAttribute("EndsAt");
    Time.Text = FormatTime((type(v31) ~= "number" and 0 or v31) - workspace:GetServerTimeNow());
    u5[Name] = RunService.Heartbeat:Connect(v30);
end;

local function BuildCard(u32) -- Line: 116
    -- upvalues: u4 (copy), u2 (ref), u3 (ref), RefreshCard (copy)
    if u4[u32.Name] then
        return;
    end;

    local v33 = u32:GetAttribute("Icon");

    if type(v33) ~= "string" or v33 == "" then
        return;
    end;

    local v34 = u2;
    local v35 = u3;

    if not (v34 and v35) then
        return;
    end;

    local u36 = v35:Clone();
    u36.Name = u32.Name;
    u36.Visible = false;
    u36.LayoutOrder = 10;
    local Vector = u36:FindFirstChild("Vector");

    if Vector and Vector:IsA("ImageLabel") then
        Vector.Image = v33;
    end;

    local v37 = u32:GetAttribute("DisplayName");

    if type(v37) ~= "string" or v37 == "" then
        v37 = u32.Name;
    end;

    local Weather = u36:FindFirstChild("Weather");

    if Weather and Weather:IsA("TextLabel") then
        Weather.Text = v37;
    end;

    local v38 = u32:GetAttribute("Description");
    u36:SetAttribute("WeatherToolTip", v37);
    u36:SetAttribute("ToolTipDescription", type(v38) ~= "string" and "" or v38);
    u36.Parent = v34;
    u4[u32.Name] = u36;
    u32:GetAttributeChangedSignal("Active"):Connect(function() -- Line: 151
        -- upvalues: RefreshCard (ref), u32 (copy), u36 (copy)
        RefreshCard(u32, u36);
    end);
    u32:GetAttributeChangedSignal("EndsAt"):Connect(function() -- Line: 154
        -- upvalues: RefreshCard (ref), u32 (copy), u36 (copy)
        RefreshCard(u32, u36);
    end);
    RefreshCard(u32, u36);
end;

local function ObserveMarker(u39) -- Line: 162
    -- upvalues: BuildCard (copy)
    u39:GetAttributeChangedSignal("Icon"):Connect(function() -- Line: 163
        -- upvalues: BuildCard (ref), u39 (copy)
        BuildCard(u39);
    end);
    BuildCard(u39);
end;

function v1.Start(p40) -- Line: 169
    -- upvalues: LocalPlayer (copy), u2 (ref), u3 (ref), ReplicatedStorage (copy), BuildCard (copy), ObserveMarker (copy)
    local Frame = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("WeatherUI"):WaitForChild("Frame");
    local Rain = Frame:FindFirstChild("Rain");

    if not (Rain and Rain:IsA("GuiObject")) then
        warn("[MinigameHudController] WeatherUI.Frame has no \"Rain\" card to clone; minigame HUD cards are off.");

        return;
    end;

    u2 = Frame;
    u3 = Rain;
    local RegisteredEvents = ReplicatedStorage:WaitForChild("RegisteredEvents");

    for _, child in RegisteredEvents:GetChildren() do
        child:GetAttributeChangedSignal("Icon"):Connect(function() -- Line: 163
            -- upvalues: BuildCard (ref), child (copy)
            BuildCard(child);
        end);
        BuildCard(child);
    end;

    RegisteredEvents.ChildAdded:Connect(ObserveMarker);
end;

return v1;