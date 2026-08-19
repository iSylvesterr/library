-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
require(script:WaitForChild("Types"));
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Observers = require(ReplicatedStorage.Packages.Observers);

local function updateScreen(p1) -- Line: 15
    local Screen = p1:FindFirstChild("Screen");

    if not Screen then
        return;
    end;

    for _, child in ipairs(Screen:GetChildren()) do
        if child.Name == "Noise" then
            local v2 = math.random();
            child.Transparency = math.clamp(v2, 0.2, 0.7);
            child.Color3 = Color3.fromRGB(192 + math.random(-10, 10), 216 + math.random(-10, 10), 255 + math.random(-10, 10));
        end;
    end;
end;

local function breakScreen(p3) -- Line: 37
    -- upvalues: TweenService (copy)
    local Screen = p3:FindFirstChild("Screen");

    if not Screen then
        return;
    end;

    TweenService:Create(Screen, TweenInfo.new(2.15), {
        Color = Color3.fromRGB(0, 0, 0)
    }):Play();
    local PointLight = Screen.ScreenLight.PointLight;

    for _ = 1, 8 do
        PointLight.Enabled = not PointLight.Enabled;
        task.wait(math.random(1, 4) / 10);
    end;

    PointLight.Enabled = false;

    for _, child in ipairs(Screen:GetChildren()) do
        if child.Name == "Noise" then
            child.Transparency = 1;
        end;
    end;
end;

return Observers.observeTag("Television", function(u4) -- Line: 64
    -- upvalues: RunServiceController (copy), updateScreen (copy), Observers (copy), breakScreen (copy)
    local u5 = 0;

    if u4:IsDescendantOf(workspace) then
        local v6 = RunServiceController.CreateBindingName("Observers.Game.Television.Noise");
        local u8 = RunServiceController.BindToHeartbeat(v6, function(p7) -- Line: 73
            -- upvalues: u5 (ref), u4 (copy), updateScreen (ref)
            u5 = u5 + p7;

            if u5 >= 0.016666666666666666 then
                u5 = u5 - 0.016666666666666666;

                if u4 and u4:IsDescendantOf(workspace) then
                    updateScreen(u4);
                end;
            end;
        end);
        local u10 = Observers.observeAttribute(u4, "Broken", function(p9) -- Line: 85
            -- upvalues: breakScreen (ref), u4 (copy), u8 (copy)
            breakScreen(u4);

            if u8 and u8.Connected then
                u8:Disconnect();
            end;
        end);

        return function() -- Line: 93
            -- upvalues: u10 (copy), u8 (copy)
            u10();

            if u8 and u8.Connected then
                u8:Disconnect();
            end;
        end;
    end;
end);