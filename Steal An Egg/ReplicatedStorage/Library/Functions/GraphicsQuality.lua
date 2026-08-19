-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local EstimateClockSpeed = require(ReplicatedStorage.Library.Functions.EstimateClockSpeed);
local Map = require(ReplicatedStorage.Library.Functions.Map);
local Variables = require(ReplicatedStorage.Library.Variables);
local u1 = UserInputService.TouchEnabled and not UserInputService.MouseEnabled or (UserInputService.GyroscopeEnabled or UserInputService.AccelerometerEnabled);

local function estimateQuality() -- Line: 10
    -- upvalues: EstimateClockSpeed (copy), Map (copy)
    local v2 = EstimateClockSpeed();

    if not v2 then
        return nil;
    end;

    local v3 = Map(v2, 2, 5, 1, 10);
    local v4 = math.round(v3);

    return math.clamp(v4, 1, 10);
end;

local u5 = nil;

return function() -- Line: 20
    -- upvalues: Variables (copy), u5 (ref), EstimateClockSpeed (copy), Map (copy), u1 (copy)
    if Variables.PotatoMode then
        return 1;
    end;

    local Value = UserSettings().GameSettings.SavedQualityLevel.Value;

    if Value == 0 then
        if not u5 then
            local v6 = EstimateClockSpeed();
            local v7;

            if v6 then
                local v8 = Map(v6, 2, 5, 1, 10);
                local v9 = math.round(v8);
                v7 = math.clamp(v9, 1, 10);
            else
                v7 = nil;
            end;

            u5 = v7;
        end;

        Value = u5 or 5;
    end;

    if u1 then
        local v10 = Map(Value, 1, 10, 1, 5);
        local v11 = math.round(v10);
        Value = math.clamp(v11, 1, 10);
    end;

    return Value;
end;