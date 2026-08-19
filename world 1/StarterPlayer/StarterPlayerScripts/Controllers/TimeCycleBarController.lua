-- Decompiled with Potassium's decompiler.

local SharedModules = game.ReplicatedStorage.SharedModules;
local TimeCycleData = require(SharedModules.TimeCycleData);
local MoonGating = require(SharedModules.MoonGating);
local TweenService = game:GetService("TweenService");
local u1 = {};
local v2 = {};

for i, v in TimeCycleData.Data do
    table.insert(u1, {
        Name = i,
        Weathers = v.Weathers,
        Duration = v.Lasts,
        Order = v.StartOrder
    });
end;

table.sort(u1, function(p3, p4) -- Line: 18
    return p3.Order < p4.Order;
end);
local u5 = 0;

for _, v in u1 do
    u5 = u5 + v.Duration;
end;

local function pickWeather(p6, p7) -- Line: 25
    -- upvalues: MoonGating (copy)
    local v8 = 0;

    for i, v in p6.Weathers do
        if not v.AdminOnly and MoonGating.IsNaturallySpawnable(i) then
            v8 = v8 + v.Chance;
        end;
    end;

    local v9 = p7:NextNumber() * v8;
    local v10 = 0;

    for i, v in p6.Weathers do
        if not v.AdminOnly and MoonGating.IsNaturallySpawnable(i) then
            v10 = v10 + v.Chance;

            if v9 <= v10 then
                return i, v;
            end;
        end;
    end;

    for i, v in p6.Weathers do
        if not v.AdminOnly and MoonGating.IsNaturallySpawnable(i) then
            return i, v;
        end;
    end;
end;

local function getCycleState() -- Line: 48
    -- upvalues: u5 (ref), u1 (copy)
    local v11 = workspace:GetServerTimeNow() / u5;
    local v12 = math.floor(v11);
    local v13 = workspace:GetAttribute("ActivePhase");

    if not (v13 and workspace:GetAttribute("PhaseDuration")) then
        repeat
            task.wait(0.1);
            v13 = workspace:GetAttribute("ActivePhase");
        until v13 and workspace:GetAttribute("PhaseDuration");
    end;

    local v14 = workspace:GetAttribute("CyclePausedRemaining");

    if type(v14) ~= "number" then
        v14 = workspace:GetAttribute("PhaseDuration") - workspace:GetServerTimeNow();
    end;

    for i, v in u1 do
        if v.Name == v13 then
            return v12, i, v, v.Duration - v14, v14;
        end;
    end;
end;

local function getWeatherForPhase(p15, p16, p17) -- Line: 80
    -- upvalues: pickWeather (copy)
    return pickWeather(p17, (Random.new(p15 * 1000 + p16)));
end;

local function formatTime(p18) -- Line: 86
    local v19 = math.max(p18, 0);
    local v20 = math.floor(v19);
    local v21 = math.floor(v20 / 60);
    local v22 = v20 % 60;

    if v21 > 0 then
        return string.format("%dm %ds", v21, v22);
    end;

    return string.format("%ds", v22);
end;

function v2.Init(p23) -- Line: 99
end;

function v2.Start(u24) -- Line: 102
    task.spawn(function() -- Line: 103
        -- upvalues: u24 (copy)
        local TimeCycleBar = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("TeleportButtons"):WaitForChild("TimeCycleBar");
        workspace:GetAttributeChangedSignal("InAdminParty"):Connect(function() -- Line: 107, Name: updatePartyVisibility
            -- upvalues: TimeCycleBar (copy)
            TimeCycleBar.Visible = workspace:GetAttribute("InAdminParty") ~= true;
        end);
        TimeCycleBar.Visible = workspace:GetAttribute("InAdminParty") ~= true;
        local MainFrame = TimeCycleBar:WaitForChild("MainFrame");
        local Bar = MainFrame:WaitForChild("Bar");
        u24:SetupBar(Bar, MainFrame:WaitForChild("TextLabel"), Bar:WaitForChild("UIGradient"), (TimeCycleBar:WaitForChild("Vector")));
    end);
end;

function v2.SetupBar(p25, u26, u27, u28, u29) -- Line: 123
    -- upvalues: getCycleState (copy), TweenService (copy)
    local u30 = TweenInfo.new(0.1, Enum.EasingStyle.Linear);
    u29.AnchorPoint = Vector2.new(0.5, 0.5);
    task.spawn(function() -- Line: 139
        -- upvalues: getCycleState (ref), TweenService (ref), u28 (copy), u30 (copy), u26 (copy), u29 (copy), u27 (copy)
        while true do
            local _, _, v31, v32, v33 = getCycleState();
            local v34 = workspace:GetAttribute("ActiveWeather");
            local v35 = nil;

            if type(v34) == "string" and (v31.Weathers and v31.Weathers[v34]) then
                v35 = v31.Weathers[v34];
            else
                local v36 = (-1 / 0);

                for _, v in v31.Weathers do
                    if v36 < v.Chance then
                        v36 = v.Chance;
                        v35 = v;
                    end;
                end;
            end;

            local v37 = v32 / v31.Duration;
            TweenService:Create(u28, u30, {
                Offset = Vector2.new(-0.9 * (1 - v37), 0)
            }):Play();
            local v38 = 1 - v37;
            TweenService:Create(u29, u30, {
                Position = UDim2.new((u26.AbsolutePosition.X + u26.AbsoluteSize.X * (0.1 + 0.9 * v37) - u29.Parent.AbsolutePosition.X) / u29.Parent.AbsoluteSize.X, 0, v38 * v38 * 0.56 + 2 * v38 * v37 * 0.35 + v37 * v37 * 0.56, 0)
            }):Play();
            u26.ImageColor3 = v35.Color;

            if v34 == "Mega Moon" then
                u29.Size = UDim2.new(1.25, 0, 1.25, 0);
            else
                u29.Size = UDim2.new(0.9, 0, 0.9, 0);
            end;

            u29.Image = v35.Image;
            local v39 = math.ceil(v33);
            local v40 = math.max(v39, 0);
            local v41 = math.floor(v40);
            local v42 = math.floor(v41 / 60);
            local v43 = v41 % 60;
            local v44;

            if v42 > 0 then
                v44 = string.format("%dm %ds", v42, v43);
            else
                v44 = string.format("%ds", v43);
            end;

            u27.Text = v44;
            task.wait(1);
        end;
    end);
end;

return v2;