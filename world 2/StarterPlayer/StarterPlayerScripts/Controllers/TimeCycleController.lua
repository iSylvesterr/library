-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game.ReplicatedStorage;
local SharedModules = ReplicatedStorage.SharedModules;
local TimeCycleData = require(SharedModules.TimeCycleData);
local MoonGating = require(SharedModules.MoonGating);
require(ReplicatedStorage.ClientModules.Skybox);
local MusicController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.MusicController);
local Phases = script.Phases;
local u1 = {};
local u2 = nil;
local u3 = nil;
local v4 = {
    StartOrder = 1
};

for i, v in TimeCycleData.Data do
    table.insert(u1, {
        Name = i,
        Weathers = v.Weathers,
        Duration = v.Lasts,
        Order = v.StartOrder
    });
end;

table.sort(u1, function(p5, p6) -- Line: 25
    return p5.Order < p6.Order;
end);
local u7 = 0;

for _, v in u1 do
    u7 = u7 + v.Duration;
end;

local function pickWeather(p8, p9) -- Line: 32
    -- upvalues: MoonGating (copy)
    local v10 = 0;

    for i, v in p8.Weathers do
        if not v.AdminOnly and MoonGating.IsNaturallySpawnable(i) then
            v10 = v10 + v.Chance;
        end;
    end;

    local v11 = p9:NextNumber() * v10;
    local v12 = 0;

    for i, v in p8.Weathers do
        if not v.AdminOnly and MoonGating.IsNaturallySpawnable(i) then
            v12 = v12 + v.Chance;

            if v11 <= v12 then
                return i, v;
            end;
        end;
    end;

    for i, v in p8.Weathers do
        if not v.AdminOnly and MoonGating.IsNaturallySpawnable(i) then
            return i, v;
        end;
    end;
end;

local function getCycleState() -- Line: 55
    -- upvalues: u7 (ref), u1 (copy)
    local v13 = workspace:GetServerTimeNow() / u7;
    local v14 = math.floor(v13);
    local v15 = workspace:GetAttribute("ActivePhase");

    if not v15 then
        repeat
            task.wait(0.1);
            v15 = workspace:GetAttribute("ActivePhase");
        until v15;
    end;

    for i, v in u1 do
        if v.Name == v15 then
            return v14, i, v, 0, v.Duration;
        end;
    end;

    return v14, #u1;
end;

local function getWeatherForPhase(p16, p17, p18) -- Line: 94
    -- upvalues: pickWeather (copy)
    return pickWeather(p18, (Random.new(p16 * 1000 + p17)));
end;

local function startPhaseModule(p19, p20, p21) -- Line: 100
    -- upvalues: u2 (ref), u3 (ref), Phases (copy), MusicController (copy)
    if u2 and u2.End then
        u2:End();
    end;

    u3 = p20;
    local v22 = Phases:FindFirstChild(p19);

    if v22 then
        u2 = require(v22);

        if not u2.NoMusic then
            MusicController:SetActiveWeather(p20);
        end;

        if u2.Start then
            u2:Start(p20, p21);
        end;
    else
        MusicController:SetActiveWeather(p20);
        u2 = nil;
    end;
end;

function v4.GetCurrentWeather(p23) -- Line: 126
    -- upvalues: u3 (ref)
    return u3;
end;

function v4.Init(p24) -- Line: 130
end;

function v4.Start(p25) -- Line: 133
    -- upvalues: getCycleState (copy), pickWeather (copy), startPhaseModule (copy)
    task.spawn(function() -- Line: 134
        -- upvalues: getCycleState (ref), pickWeather (ref), startPhaseModule (ref)
        while true do
            local v26, v27, v28, _, _ = getCycleState();
            local v29 = workspace:GetAttribute("ActiveWeather");
            local v30;

            if type(v29) == "string" and (v28.Weathers and v28.Weathers[v29]) then
                v30 = v28.Weathers[v29];
            else
                v29, v30 = pickWeather(v28, (Random.new(v26 * 1000 + v27)));
            end;

            startPhaseModule(v29, v29, v30);
            local u31 = coroutine.running();
            local u32 = false;
            local u33 = nil;
            local u34 = nil;

            local function resume() -- Line: 158
                -- upvalues: u32 (ref), u33 (ref), u34 (ref), u31 (copy)
                if u32 then
                    return;
                end;

                u32 = true;

                if u33 then
                    u33:Disconnect();
                end;

                if u34 then
                    u34:Disconnect();
                end;

                task.spawn(u31);
            end;

            u33 = workspace:GetAttributeChangedSignal("ActivePhase"):Connect(resume);
            u34 = workspace:GetAttributeChangedSignal("ActiveWeather"):Connect(resume);
            coroutine.yield();
        end;
    end);
end;

return v4;