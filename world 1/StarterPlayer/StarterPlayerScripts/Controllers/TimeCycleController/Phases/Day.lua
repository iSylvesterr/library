-- Decompiled with Potassium's decompiler.

local v1 = {};
local RunService = game:GetService("RunService");
local Lighting = game:GetService("Lighting");
local LightingController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.LightingController);
local TimeCycleData = require(game.ReplicatedStorage.SharedModules.TimeCycleData);
local u2 = {};
local u3 = nil;

function v1.Start(p4, p5, p6) -- Line: 23
    -- upvalues: LightingController (copy), u2 (copy), TimeCycleData (copy), Lighting (copy), u3 (ref), RunService (copy)
    local v7 = {};

    for i, v in LightingController:GetDefault() do
        v7[i] = v;
    end;

    for i, v in u2 do
        v7[i] = v;
    end;

    v7.ClockTime = nil;
    LightingController:TransitionTo(v7);
    local u8, u9 = LightingController:GetDefault().Ambient:ToHSV();
    local _ = TimeCycleData.Data.Day.Lasts;
    local u10 = 0;

    for _, v in TimeCycleData.Data do
        u10 = u10 + v.Lasts;
    end;

    local function getDayProgress() -- Line: 56
        -- upvalues: u10 (ref), TimeCycleData (ref)
        if workspace:GetAttribute("InAdminParty") == true then
            return 0.625;
        end;

        local v11 = workspace:GetAttribute("CycleOffset") or 0;
        local v12 = (workspace:GetServerTimeNow() + v11) % u10;
        local v13 = {};
        local v14 = 0;

        for i, v in TimeCycleData.Data do
            table.insert(v13, {
                Name = i,
                Duration = v.Lasts,
                Order = v.StartOrder
            });
        end;

        table.sort(v13, function(p15, p16) -- Line: 72
            return p15.Order < p16.Order;
        end);

        for _, v in v13 do
            if v.Name == "Day" then
                return math.clamp((v12 - v14) / v.Duration, 0, 1);
            end;

            v14 = v14 + v.Duration;
        end;

        return 0;
    end;

    Lighting.ClockTime = 7 + 8 * getDayProgress();

    if u3 then
        u3:Disconnect();
    end;

    u3 = RunService.Heartbeat:Connect(function() -- Line: 92
        -- upvalues: getDayProgress (copy), Lighting (ref), u8 (copy), u9 (copy)
        local v17 = getDayProgress();

        if workspace:GetAttribute("TimeFrozen") then
            return;
        end;

        Lighting.Ambient = Color3.fromHSV(u8, u9, 0.5 + 0.3 * v17);
        Lighting.ClockTime = 7 + 8 * v17;
    end);
end;

function v1.End(p18) -- Line: 102
    -- upvalues: u3 (ref)
    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;
end;

return v1;